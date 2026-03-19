ExchangeBuyPanel = {}

local function getCurrentNumConfig()
        return {
            numKey = "_itemNum",
            uiTextKey = "Text_itemNum"
        }
end


local function setNumAndRefresh(numKey, value)
    ExchangeBuyPanel[numKey] = tostring(value)
    ExchangeBuyPanel.RefreshShowInput()
end

function ExchangeBuyPanel.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.ExchangeBuyPanelGUI, 0, 0, 0, 0, false, false, true, true)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(parent, isWinMode and "exchange_win32/exchange_buy_panel" or "exchange/exchange_buy_panel")

    ExchangeBuyPanel._ui = GUI:ui_delegate(parent)
    ExchangeBuyPanel._data = data

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(ExchangeBuyPanel._ui["Panel_1"], screenW / 2, posY)


    ExchangeBuyPanel._itemNum = ExchangeBuyPanel._data.remainqty or 1
    ExchangeBuyPanel._maxItemNum = ExchangeBuyPanel._data.remainqty or 1
    ExchangeBuyPanel._minSinglePrice = ExchangeBuyPanel._data.price or 1

    -- 关闭
    GUI:addOnClickEvent(ExchangeBuyPanel._ui.Button_close, function()
        UIOperator:CloseExchangeBuyPanelUI()
    end)

    ExchangeBuyPanel.InitShow()
    ExchangeBuyPanel.InitCalculatorBtn()
end

function ExchangeBuyPanel.InitCalculatorBtn( ... )
    local function InputNum(value)
        local config = getCurrentNumConfig()
        local currentNum = tonumber(ExchangeBuyPanel[config.numKey]) or 0

        local newNumStr = (currentNum == 0) and tostring(value) or (ExchangeBuyPanel[config.numKey] .. value)
        local newNum = tonumber(newNumStr) or 0

        local isValid = true
        if newNum > ExchangeBuyPanel._data.remainqty  then
            SL:ShowSystemTips("数量有误，超出出售最大数量")
            isValid = false
        end

        if isValid then
            setNumAndRefresh(config.numKey, newNum)
        else
            local rollbackNum = tonumber(GUI:Text_getString(ExchangeBuyPanel._ui[config.uiTextKey])) or 0
            setNumAndRefresh(config.numKey, rollbackNum)
            return
        end
    end


    local function AddNum( value )
        local config = getCurrentNumConfig()
        local addValue = tonumber(value) or 0
        local currentNum = tonumber(ExchangeBuyPanel[config.numKey]) or 0
        local newNum = currentNum + addValue
        if newNum > ExchangeBuyPanel._data.remainqty  then
            SL:ShowSystemTips("数量有误，超出出售最大数量")
            return
        end
        newNum = math.min(newNum, ExchangeBuyPanel._maxItemNum)
        setNumAndRefresh(config.numKey, newNum)
    end

    local function RefNum()
        local config = getCurrentNumConfig()
        setNumAndRefresh(config.numKey, 0)
    end

    local function SubNum( ... )
        local config = getCurrentNumConfig()
        local numStr = tostring(ExchangeBuyPanel[config.numKey])
        local len = #numStr

        local subValue = (len > 1) and string.sub(numStr, 1, len - 1) or "0"
        setNumAndRefresh(config.numKey, subValue)
    end

    local function MaxNum()
        local config = getCurrentNumConfig()
        local maxValue = 0
        maxValue = ExchangeBuyPanel._maxItemNum
        setNumAndRefresh(config.numKey, maxValue)
    end


    local function MinNum()
        local config = getCurrentNumConfig()
        setNumAndRefresh(config.numKey, 1)
    end

    local btnEventMap = {
        ref = RefNum,
        sub = SubNum,
        max = MaxNum,
        min = MinNum
    }

    local btnList = GUI:getChildren(ExchangeBuyPanel._ui["Panel_num"])
    for _, btn in ipairs(btnList) do
        local btnName = GUI:getName(btn)
        if btnName and #btnName > 0 and string.find(btnName, "Button_") then
            local str = SL:Split(btnName, "_")[2]
            if not str then goto continue end 

            -- 处理数字按钮（0-9）
            local num = tonumber(str)
            if num then
                if num >= 0 and num <= 9 then
                    GUI:addOnClickEvent(btn, handler(str, InputNum))
                else
                    GUI:addOnClickEvent(btn, handler(str, AddNum))
                end
            else
                local eventFunc = btnEventMap[str]
                if eventFunc then
                    GUI:addOnClickEvent(btn, eventFunc)
                end
            end

            ::continue::
        end
    end
end

function ExchangeBuyPanel.RefreshShowInput( ... )
    local itemNum = ExchangeBuyPanel._itemNum or "0"
    local minSinglePrice = ExchangeBuyPanel._minSinglePrice or "0"
    local total = tonumber(itemNum) * tonumber(minSinglePrice) or 0

    GUI:Text_setString(ExchangeBuyPanel._ui["Text_itemNum"], itemNum)
    GUI:Text_setString(ExchangeBuyPanel._ui["Text_total"], total)
    GUI:Text_setString(ExchangeBuyPanel._ui["Text_selectnum"], string.format("%s/%s", itemNum, ExchangeBuyPanel._maxItemNum))
end

function ExchangeBuyPanel.InitShow()
    local item = ExchangeBuyPanel._data
    if not item or not next(item) then
        return
    end
    local colorHex = SL:GetValue("ITEM_NAME_COLOR_VALUE", item.itemid)
    local itemName = SL:GetValue("ITEM_NAME", item.itemid)
    GUI:Text_setString(ExchangeBuyPanel._ui.Text_name, itemName)
    GUI:Text_setTextColor(ExchangeBuyPanel._ui.Text_name, colorHex)
    -- item icon
    local Image_icon = ExchangeBuyPanel._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local itemData = SL:GetValue("ITEM_DATA", item.itemid)
    local goodsInfo = { itemData = itemData, look = true, index = itemData.Index, disShowCount = true,}
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

    local function createGoodsItem(parentNode, itemData, scale)
        scale = scale or 0.6  -- 默认缩放比例
        local goodsItem = GUI:ItemShow_Create(
            parentNode, 
            "goodsItem", 
            0, 0, 
            { index = itemData.Index, itemData = itemData }
        )
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, scale)
        return goodsItem
    end
    local coinData = SL:GetValue("ITEM_DATA", item.currency)
    createGoodsItem(ExchangeBuyPanel._ui["Node_money_single"], coinData)
    createGoodsItem(ExchangeBuyPanel._ui["Node_money_total"], coinData)
    -- 单价
    GUI:Text_setString(ExchangeBuyPanel._ui.Text_single, item.price)
    -- 总价
    GUI:Text_setString(ExchangeBuyPanel._ui.Text_total, item.price * item.remainqty)
    -- 数量
    GUI:Text_setString(ExchangeBuyPanel._ui.Text_itemNum, item.remainqty)

    GUI:Text_setString(ExchangeBuyPanel._ui.Text_selectnum, string.format("%s/%s", item.remainqty, item.remainqty))

    
    GUI:addOnClickEvent(ExchangeBuyPanel._ui.Button_submit, function(sender)
        if tonumber(ExchangeBuyPanel._itemNum) > item.remainqty then
            SL:ShowSystemTips("该物品最大购买数量为" .. item.remainqty)
            return
        end
        local reqNum = math.min(ExchangeBuyPanel._itemNum, item.remainqty)
        if item.guid then
            SL:RequestExchangeBuyPanel({ guid = item.guid, qty = reqNum })
            GUI:delayTouchEnabled(sender)
        end
        UIOperator:CloseExchangeBuyPanelUI()
    end)

    GUI:addOnClickEvent(ExchangeBuyPanel._ui.Button_countsub, function(sender) --减少数量
        ExchangeBuyPanel._itemNum = ExchangeBuyPanel._itemNum - 1
        if ExchangeBuyPanel._itemNum <= 0 then
            ExchangeBuyPanel._itemNum = 1
        end
        ExchangeBuyPanel.RefreshShowInput()
    end)

    GUI:addOnClickEvent(ExchangeBuyPanel._ui.Button_countadd, function(sender) --增加数量
        ExchangeBuyPanel._itemNum = ExchangeBuyPanel._itemNum + 1
        if ExchangeBuyPanel._itemNum > ExchangeBuyPanel._maxItemNum then
            ExchangeBuyPanel._itemNum = ExchangeBuyPanel._maxItemNum
        end
        ExchangeBuyPanel.RefreshShowInput()
    end)
end

ExchangeBuyPanel.main()
