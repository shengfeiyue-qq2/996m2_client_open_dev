StoreBuy = {}

local MaxNum = 9999

function StoreBuy.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "store/store_buy")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    StoreBuy._ui = ui

    GUI:Win_SetDrag(parent, ui["PMainUI"])
    if SL:IsWinMode() then
        GUI:setMouseEnabled(ui["PMainUI"], true)
    end

    if not data then
		return false
	end
    StoreBuy._bData = data

    StoreBuy._Price = StoreBuy._bData.NowPrice > 0 and StoreBuy._bData.NowPrice or StoreBuy._bData.Price
    local min = StoreBuy._bData.CountMin or 0
    local max = StoreBuy._bData.CountMax > 0 and StoreBuy._bData.CountMax or MaxNum
    local min = math.min(max, min)
    StoreBuy._curNum = min
    GUI:TextInput_setString(StoreBuy._ui["TextInput"], StoreBuy._curNum)

    StoreBuy.InitSigle()
    StoreBuy.InitTotal()
    StoreBuy.InitGoodsItem()

    -- 关闭按钮
    GUI:addOnClickEvent(ui["Button_close"], function () GUI:Win_Close(parent) end)
    
    GUI:TextInput_addOnEvent(StoreBuy._ui["TextInput"], StoreBuy.OnEditBoxEvent)
    GUI:addOnClickEvent(StoreBuy._ui["BtnAdd"], handler(1, StoreBuy.OnADDSUBEvent))
    GUI:addOnClickEvent(StoreBuy._ui["BtnSub"], handler(-1, StoreBuy.OnADDSUBEvent))
    GUI:addOnClickEvent(StoreBuy._ui["BtnBuy"], StoreBuy.OnBuyEvent)
end

-- 单价
function StoreBuy.InitSigle()
    GUI:removeAllChildren(StoreBuy._ui["NodeSingle"])
    
    local info = {titleText  = "单价:"}
    local priceCell = GUI:CreateCostItemCell(string.format("%s#%s", StoreBuy._bData.CostID, StoreBuy._Price), info)
    GUI:setAnchorPoint(priceCell, 0, 0.5)
    GUI:addChild(StoreBuy._ui["NodeSingle"], priceCell)
end

-- 总价
function StoreBuy.InitTotal()
    GUI:removeAllChildren(StoreBuy._ui["NodeTotal"])

    local dMoney, surPrice = StoreBuy.GetMoneyInfo()
    local num  = #dMoney
    local offX = 0
    for i, v in ipairs(dMoney) do
        local mPrice    = i == num and (v.Count + surPrice) or v.Count
        local titleText = i == 1 and "总价:" or nil
        local info = {titleText = titleText, noShowTip = i > 1}
        local priceCell = GUI:CreateCostItemCell(string.format("%s#%s", v.ID, mPrice), info)

        GUI:setAnchorPoint(priceCell, 0, 0.5)
        GUI:setPositionX(priceCell, offX)
        GUI:addChild(StoreBuy._ui["NodeTotal"], priceCell)

        offX = offX + GUI:getContentSize(priceCell).width / 2 + 15
    end
end

-- 获取货币
function StoreBuy.GetMoneyInfo()
    local surPrice = StoreBuy._curNum * StoreBuy._Price
    local moneys   = {}

    local ArrConstID = StoreBuy._bData.ArrConstID
    if ArrConstID then
        for i,mID in ipairs(ArrConstID) do
            if surPrice <= 0 then
                break
            end
            local num = SL:GetItemNumberByIndex(mID, true)
            surPrice = surPrice - num
            table.insert(moneys, {
                ID = mID, Count = num
            })
        end
    else
        local num = SL:GetItemNumberByIndex(StoreBuy._bData.CostID, true)
        surPrice = surPrice - num
        table.insert(moneys, {
            ID = StoreBuy._bData.CostID, Count = num
        })
    end
    return moneys, surPrice
end

function StoreBuy.InitGoodsItem()
    GUI:removeAllChildren(StoreBuy._ui["NodeItem"])

    if StoreBuy._bData.Id and StoreBuy._bData.Look then
        local goodsItem = GoodsItem:create({index = StoreBuy._bData.Id, look = true})
        GUI:addChild(StoreBuy._ui["NodeItem"], goodsItem)
    end

    local p = GUI:getPosition(StoreBuy._ui["Text_name"])
    GUI:ScrollText_Create(StoreBuy._ui["PMainUI"], "ItemName", p.x, p.y, 130, 16, "#FFFFFF", StoreBuy._bData.Name)
end

function StoreBuy.OnEditBoxEvent()
    local input = tonumber(GUI:TextInput_getString(StoreBuy._ui["TextInput"])) or 0
    -- 限购
    if StoreBuy._bData.LimitCount and StoreBuy._bData.LimitCount > 0 and StoreBuy._bData.LimitType then
        local buyCount  = StoreBuy._bData.BuyCount or 0
        local leftCount = StoreBuy._bData.LimitCount - buyCount
        leftCount = math.max(leftCount, 0)
        input     = math.min(leftCount, input)
    end
    -- 单次限制
    local inputCountMin = StoreBuy._bData.CountMin or 0
    local inputCountMax = StoreBuy._bData.CountMax > 0 and StoreBuy._bData.CountMax  or MaxNum
    input = math.max(input, inputCountMin)
    input = math.min(input, inputCountMax)

    StoreBuy._curNum = input
    GUI:TextInput_setString(StoreBuy._ui["TextInput"], StoreBuy._curNum)
    StoreBuy.InitTotal()
end

function StoreBuy.OnADDSUBEvent(add)
    local input = StoreBuy._curNum + add
    -- 限购
    if StoreBuy._bData.LimitCount and StoreBuy._bData.LimitCount > 0 and StoreBuy._bData.LimitType then
        -- 限购
        local buyCount  = StoreBuy._bData.BuyCount or 0
        local leftCount = StoreBuy._bData.LimitCount - buyCount
        leftCount = math.max(leftCount, 0)
        input     = math.min(leftCount, input)
    end

    -- 单次限制
    local inputCountMin = StoreBuy._bData.CountMin or 0
    local inputCountMax = StoreBuy._bData.CountMax == 0 and MaxNum or StoreBuy._bData.CountMax 
    input = math.max(input, inputCountMin)
    input = math.min(input, inputCountMax)

    if input <= 0 or input > MaxNum then
        return false
    end
    StoreBuy._curNum = input
    GUI:TextInput_setString(StoreBuy._ui["TextInput"], StoreBuy._curNum)
    StoreBuy.InitTotal()
end

function StoreBuy.OnBuyEvent()
    if StoreBuy._curNum < 1 then
        SL:CloseStoreBuyPop()
        return false
    end

    if not SL:CheckCondition(StoreBuy._bData.Condition) then
        SL:CloseStoreBuyPop()
        return false
    end

    -- 检测背包是否有位置
    if not SL:CheckNeedSpace(StoreBuy._bData.Id, StoreBuy._curNum) then
        SL:ShowSystemTips("背包空间不足！")
        SL:CloseStoreBuyPop()
        return false
    end

    -- 购买
    SL:RequestStoreBuyItem(StoreBuy._bData.Index, StoreBuy._curNum)
end