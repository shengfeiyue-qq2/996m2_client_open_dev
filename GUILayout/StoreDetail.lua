StoreDetail = {}

function StoreDetail.main(data)
    local parent = GUI:Attach_Parent()
    StoreDetail._ui = GUI:ui_delegate(parent)

    StoreDetail.buyData = {}
    StoreDetail.buyData = data.data
    StoreDetail.buyCount = 1

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "store/store_detail_win32")
    else
        GUI:LoadExport(parent, "store/store_detail")
    end

    -- 可拖拽
    GUI:Win_SetDrag(parent, StoreDetail._ui["PMainUI"])
    GUI:Win_SetZPanel(parent, StoreDetail._ui["PMainUI"])

    -- 关闭按钮
    GUI:addOnClickEvent(StoreDetail._ui["Button_close"], function()
        SL:CloseStoreDetailUI()
    end)

    StoreDetail.InitMoneyCell()

    StoreDetail.InitGoodsItem()

    StoreDetail.InitEditBox()

    StoreDetail.InitADDSUBBtn()

    StoreDetail.InitBuyBtn()
end

function StoreDetail.InitEditBox()
    local data = StoreDetail.buyData
    local inputCount = 1
    local inputCountMin = data.CountMin or 0
    local inputCountMax = data.CountMax == 0 and 9999 or data.CountMax 
    inputCount = math.max(inputCount, inputCountMin)
    inputCount = math.min(inputCount, inputCountMax)
    GUI:TextInput_setInputMode(StoreDetail._ui["input_num"], 2)
    StoreDetail.SetBuyCount(inputCount)
    
    local function textFieldEvent(sender, eventType)
        local input = tonumber(GUI:TextInput_getString(sender)) or 0
        -- 限购
        if data.LimitCount and data.LimitCount > 0 and data.LimitType then
            local buyCount = data.BuyCount or 0
            local leftCount = data.LimitCount - buyCount
            leftCount = math.max(leftCount, 0)
            input = math.min(leftCount, input)
        end

        -- 单次限制
        local inputCountMin = data.CountMin or 0
        local inputCountMax = data.CountMax == 0 and 9999 or data.CountMax 
        input = math.max(input, inputCountMin)
        input = math.min(input, inputCountMax)
        
        StoreDetail.SetBuyCount(input)
    end

    GUI:TextInput_addOnEvent(StoreDetail._ui["input_num"], textFieldEvent)
end

function StoreDetail.InitADDSUBBtn()
    local function changeCallBack(count)
        local data = StoreDetail.buyData
        local input = StoreDetail.buyCount + count

        -- 限购
        if data.LimitCount and data.LimitCount > 0 and data.LimitType then
            local buyCount = data.BuyCount or 0
            local leftCount = data.LimitCount - buyCount
            leftCount = math.max(leftCount, 0)
            input = math.min(leftCount, input)
        end

        -- 单次限制
        local inputCountMin = data.CountMin or 0
        local inputCountMax = data.CountMax == 0 and 9999 or data.CountMax 
        input = math.max(input, inputCountMin)
        input = math.min(input, inputCountMax)

        if input <= 0 or input > 9999 then
            return
        end
        StoreDetail.SetBuyCount(input)
    end

    GUI:addOnClickEvent(StoreDetail._ui["Button_add"], function ()
        changeCallBack(1)
    end)
    
    GUI:addOnClickEvent(StoreDetail._ui["Button_sub"], function ()
        changeCallBack(-1)
    end)
end

function StoreDetail.SetBuyCount(count)
    StoreDetail.buyCount = count

    GUI:TextInput_setString(StoreDetail._ui["input_num"], count)
    StoreDetail.RefreshTotalPrice()
end

function StoreDetail.InitBuyBtn()
    local function buy()
        local data = StoreDetail.buyData
        if not SL:CheckCondition(data.Condition) then
            return
        end

        local bagSpace = true -- 背包是否有格子
        if StoreDetail.buyCount > 0 then
            bagSpace = SL:GetMetaValue("BAG_CHECK_NEED_SPACE", data.Id, StoreDetail.buyCount, true)
        end

        if bagSpace then
            local basePrice = data.NowPrice > 0 and data.NowPrice or data.Price
            local tCurrency, isCanBuy = StoreDetail.GetTotalMoney(data, StoreDetail.buyCount * basePrice) 
            if not isCanBuy then
                local strTips = "货币不足"
                if #tCurrency == 1 then
                    local itemName = SL:GetMetaValue("ITEM_NAME", tCurrency[1].id)
                    strTips = string.format("%s不足", itemName)
                end
                SL:ShowSystemTips(strTips)
            end
            SL:RequestStoreBuy(data.Index, StoreDetail.buyCount)
        end

        SL:CloseStoreDetailUI()
    end
    GUI:addOnClickEvent(StoreDetail._ui["Button_buy"], buy)
end

function StoreDetail.InitMoneyCell()
    GUI:removeAllChildren(StoreDetail._ui["Node_single"])
    GUI:removeAllChildren(StoreDetail._ui["Node_total"])

    local data = StoreDetail.buyData
    local price = data.NowPrice > 0 and data.NowPrice or data.Price
    local tCurrency, isCanBuy = StoreDetail.GetTotalMoney(data, StoreDetail.buyCount * price)
    local tHaveCurrency = StoreDetail.GetHaveMoney(data, StoreDetail.buyCount * price)

    -- 单价
    local itemData = {
        id = tCurrency[1].id,
        price = price,
        isCanBuy = isCanBuy,
        isShowIcon = true,
    }
    local priceCell = StoreDetail.createItemIcon(itemData)
    GUI:setPosition(priceCell, 0, 0)
    GUI:setAnchorPoint(priceCell, 0, 0.5)
    GUI:addChild(StoreDetail._ui["Node_single"], priceCell)

    -- 总价
    local offX = 0
    for i, moneyData in ipairs(tCurrency) do
        local itemData = {
            id = moneyData.id,
            price = moneyData.count,
            isCanBuy = isCanBuy,
            isShowIcon = false,
        }
        local totalCell = StoreDetail.createItemIcon(itemData)
        GUI:setPosition(totalCell, offX, 0)
        GUI:setAnchorPoint(totalCell, 0, 0.5)
        GUI:addChild(StoreDetail._ui["Node_total"], totalCell)
        offX = offX + totalCell:getContentSize().width
    end

    -- 拥有
    local offX2 = 0
    for i, moneyData in ipairs(tHaveCurrency) do
        local itemData = {
            id = moneyData.id,
            price = moneyData.count,
            isCanBuy = isCanBuy,
            isShowIcon = true,
        }
        local haveCell = StoreDetail.createItemIcon(itemData)
        GUI:setPosition(haveCell, offX2, 0)
        GUI:setAnchorPoint(haveCell, 0, 0.5)
        GUI:addChild(StoreDetail._ui["Node_have"], haveCell)
        offX2 = offX2 + haveCell:getContentSize().width
    end
end 

function StoreDetail.RefreshTotalPrice()
    GUI:removeAllChildren(StoreDetail._ui["Node_total"])

    local data = StoreDetail.buyData
    local basePrice = data.NowPrice > 0 and data.NowPrice or data.Price
    local tCurrency, isCanBuy = StoreDetail.GetTotalMoney(data, StoreDetail.buyCount * basePrice)
    local offX = 0
    for i, moneyData in ipairs(tCurrency) do
        local itemData = {
            id = moneyData.id,
            price = moneyData.count,
            isCanBuy = isCanBuy,
            isShowIcon = false,
        }
        local totalCell = StoreDetail.createItemIcon(itemData)
        GUI:setPosition(totalCell, offX, 0)
        GUI:setAnchorPoint(totalCell, 0, 0.5)
        GUI:addChild(StoreDetail._ui["Node_total"], totalCell)
        offX = offX + GUI:getContentSize(totalCell).width
    end
end

function StoreDetail.createItemIcon(data)
    local file = SL:GetMetaValue("WINPLAYMODE") and "store/item_icon_cell_win32" or "store/item_icon_cell"
    local widget = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    GUI:LoadExport(widget, file)

    local item = GUI:getChildByName(widget, "Panel_icon")
    -- icon
    local price_icon = GUI:getChildByName(item, "Node_icon")
    GUI:removeAllChildren(price_icon)

    local info = {
        index = data.id,
        bgVisible = false,
        look = true
    }
    local goodsItem = GUI:ItemShow_Create(price_icon, "goodsItem", 0, 0, info)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5) 

    -- count
    local price_count = GUI:getChildByName(item, "Node_count")
    GUI:removeAllChildren(price_count)
    local color = (data.isCanBuy == true) and "#28ef01" or "#FB0000"
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local size = isWinMode and 12 or 15
    local sPrice = SL:GetSimpleNumber(data.price, 1)
    local richText = GUI:RichText_Create(price_count, "richText", 0, 0, sPrice, 100, size, color)
    GUI:setAnchorPoint(richText, 0, 0.5)

    if not data.isShowIcon then 
        GUI:setVisible(price_icon, false)
        GUI:setPositionX(richText, -24)
    end 

    GUI:removeFromParent(item)

    return item
end 

function StoreDetail.InitGoodsItem(data)
    GUI:removeAllChildren(StoreDetail._ui["Image_iconBg"])

    local data = StoreDetail.buyData
    if data.Id and data.Look then
        local goodsData = {}
        goodsData.index = data.Id
        goodsData.look = true
        local ui_icon = GUI:ItemShow_Create(StoreDetail._ui["Image_iconBg"], "ui_icon", 0, 0, goodsData)
        local iconBgSize = GUI:getContentSize(StoreDetail._ui["Image_iconBg"])
        GUI:setAnchorPoint(ui_icon, 0.5, 0.5)
        GUI:setPosition(ui_icon, iconBgSize.width / 2, iconBgSize.height / 2)
    end

    if data.Name then
        GUI:Text_setString(StoreDetail._ui["Text_itemName"], data.Name)
        GUI:setVisible(StoreDetail._ui["Text_itemName"],true)
    end
end 

--获取货币
function StoreDetail.GetTotalMoney(data, totalPrice)
    local isCanBuy = false
    local moneys = {}
    if not totalPrice or not data then
        return moneys, isCanBuy
    end

    local MoneyType = {
        Gold = 1,
        YuanBao = 2,
        BindYuanBao = 4,
        Exp = 6
    }

    local isBind = SL:GetMetaValue("SERVER_OPTIONS", "BindGold")
    if data.ArrConstID and next(data.ArrConstID) then
        local haveCount = 0
        for i, id in ipairs(data.ArrConstID) do
            local count= tonumber(SL:GetMetaValue("MONEY", id)) 
            haveCount = haveCount + count
            if haveCount >= totalPrice then 
                isCanBuy = true 
            end 

            if i == 1 then 
                table.insert(moneys, {id = id, count = totalPrice})
            end 
        end 
    else
        local count = tonumber(SL:GetMetaValue("MONEY", data.CostID))  
        if data.CostID == MoneyType.BindYuanBao and isBind then 
            count = count + tonumber(SL:GetMetaValue("MONEY", MoneyType.YuanBao))
        end 

        if count >= totalPrice then 
            isCanBuy = true
        end 
        table.insert(moneys, {id = data.CostID, count = totalPrice}) 
    end
    return moneys, isCanBuy
end

-- 获取拥有货币
function StoreDetail.GetHaveMoney(data, totalPrice)
    local moneys = {}
    if not totalPrice or not data then
        return moneys
    end

    local MoneyType = {
        Gold = 1,
        YuanBao = 2,
        BindYuanBao = 4,
        Exp = 6
    }

    local isBind = SL:GetMetaValue("SERVER_OPTIONS", "BindGold")
    if data.ArrConstID and next(data.ArrConstID) then
        for i, id in ipairs(data.ArrConstID) do
            local count= tonumber(SL:GetMetaValue("MONEY", id))   
            table.insert(moneys, {id = id, count = count}) 
        end 
    else
        local count = tonumber(SL:GetMetaValue("MONEY", data.CostID))  
        if data.CostID == MoneyType.BindYuanBao and isBind then 
            count = count + tonumber(SL:GetMetaValue("MONEY", MoneyType.YuanBao))
        end 

        table.insert(moneys, {id = data.CostID, count = count}) 
    end
    return moneys
end