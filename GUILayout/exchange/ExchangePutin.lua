ExchangePutin = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

local function getCurrentNumConfig()
    if ExchangePutin._numAble then
        return {
            numKey = "_itemNum",
            uiTextKey = "Text_itemNum"
        }
    else
        return {
            numKey = "_minSinglePrice",
            uiTextKey = "Text_single"
        }
    end
end


local function setNumAndRefresh(numKey, value)
    ExchangePutin[numKey] = tostring(value)
    ExchangePutin.RefreshShowInput()
end

local function insertLimitMinBuyPrice(index, minPrice, maxPrice, minNum, maxNum)
    local name = SL:GetValue("ITEM_NAME", index)
    local itemData = SL:GetValue("ITEM_DATA", index)
    table.insert(ExchangePutin._limitMinBuyPrices, {
        id = index,
        name = name,
        minPrice = minPrice,
        maxPrice = maxPrice,
        minNum = minNum,
        maxNum = maxNum,
        item = itemData
    })
end

function ExchangePutin.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.ExchangePutinGUI, 0, 0, 0, 0, false, false, true, true)
    local itemData = GUI:GetLayerOpenParam()
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(parent, isWinMode and "exchange_win32/exchange_putin" or "exchange/exchange_putin")

    ExchangePutin._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(ExchangePutin._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(ExchangePutin._ui["Panel_1"], screenW, screenH)

    ExchangePutin._numAble        = true  --默认键盘输入数量
    ExchangePutin._singlePricAble        = false
    ExchangePutin._isShowCurrency = false
    ExchangePutin._currencyIndex  = 1         -- 货币索引

    -- 物品配置不同货币单价
    ExchangePutin._limitMinBuyPrices = {}

    local curItemData = SL:GetValue("ITEM_DATA", itemData.Index)
    local currencyStr = itemData.JiaoYiSuoLimit


    if currencyStr and string.len(currencyStr) > 0 then
        local currencyParts = string.split(currencyStr, "&")
        local minBuyNum = 1
        local maxBuyNum = itemData.OverLap

        if currencyParts[2] then
            local numParamParts = string.split(currencyParts[2], "#")
            local param2_1 = tonumber(numParamParts[1]) or maxBuyNum
            local param2_2 = tonumber(numParamParts[2]) or minBuyNum
            
            minBuyNum = param2_2
            maxBuyNum = math.min(maxBuyNum, param2_1)
        end
        if currencyParts[1] then
            local priceParamParts = string.split(currencyParts[1], "|")
            for j, priceItem in ipairs(priceParamParts) do
                local priceDetailParts = string.split(priceItem, "#")
                local itemIndex = tonumber(priceDetailParts[1])
                local itemMaxPrice = tonumber(priceDetailParts[2])
                local itemMinPrice = tonumber(priceDetailParts[3])
                if not (itemIndex and itemMaxPrice and itemMinPrice) then
                    goto continue
                end
                insertLimitMinBuyPrice(itemIndex, itemMinPrice, itemMaxPrice, minBuyNum, maxBuyNum)
                ::continue::
            end
        end
    end
    ExchangePutin._currcies = ExchangePutin._limitMinBuyPrices
    ExchangePutin.UpdateCurrencyPrice()

    GUI:addOnClickEvent(ExchangePutin._ui["Button_close"], function()
        GUI:Win_Close(parent)
    end)
    
    GUI:addOnClickEvent(ExchangePutin._ui["Button_num"], function()--选择输入数量
        if ExchangePutin._numAble then
            return 
        end
        ExchangePutin._numAble = not ExchangePutin._numAble
        ExchangePutin._singlePricAble = not ExchangePutin._singlePricAble
        ExchangePutin.UpdateSlectedModulus()
    end)

    GUI:addOnClickEvent(ExchangePutin._ui["Button_single"], function()--选择输入单价
         if ExchangePutin._singlePricAble then
            return 
        end
        ExchangePutin._singlePricAble = not ExchangePutin._singlePricAble
        ExchangePutin._numAble = not ExchangePutin._numAble
        ExchangePutin.UpdateSlectedModulus()
    end)

    local function updateExchangeUI()
        GUI:Text_setString(ExchangePutin._ui["Text_itemNum"], ExchangePutin._itemNum)
        GUI:Text_setString(ExchangePutin._ui["Text_total"], ExchangePutin._itemNum * ExchangePutin._minSinglePrice)
        GUI:Text_setString(ExchangePutin._ui["Text_single"], ExchangePutin._minSinglePrice)
        if ExchangePutin._numAble then
            GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], ExchangePutin._itemNum .. "/" .. ExchangePutin._maxItemNum)
        else
            GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], ExchangePutin._minSinglePrice)
        end
    end


    GUI:addOnClickEvent(ExchangePutin._ui["Button_countadd"], function()
        if ExchangePutin._numAble then
            if tonumber(ExchangePutin._itemNum)* tonumber(ExchangePutin._minSinglePrice) >= fixMaxPrice then
                return 
            end
            ExchangePutin._itemNum = ExchangePutin._itemNum + 1
            if ExchangePutin._itemNum > ExchangePutin._maxItemNum then
                ExchangePutin._itemNum = ExchangePutin._maxItemNum
            end
        else
            ExchangePutin._minSinglePrice = ExchangePutin._minSinglePrice + 1
            local maxPrice = fixMaxPrice / ExchangePutin._itemNum
            if ExchangePutin._minSinglePrice > maxPrice then
                ExchangePutin._minSinglePrice = math.ceil(maxPrice)
            end
        end
        updateExchangeUI()
    end)


    GUI:addOnClickEvent(ExchangePutin._ui["Button_countsub"], function()
        if ExchangePutin._numAble then
            ExchangePutin._itemNum = ExchangePutin._itemNum - 1
            if ExchangePutin._itemNum <= 0 then
                ExchangePutin._itemNum = 1
            end
        else
            ExchangePutin._minSinglePrice = ExchangePutin._minSinglePrice - 1
            if ExchangePutin._minSinglePrice <= 0 then
                ExchangePutin._minSinglePrice = 1
            end
        end
        updateExchangeUI()
    end)


    --上架按钮
    GUI:addOnClickEvent(ExchangePutin._ui["Button_submit"], function(sender)
        GUI:delayTouchEnabled(sender)
        if not itemData then
            return
        end


        -- 数量
        local inputCount = tonumber(GUI:Text_getString(ExchangePutin._ui["Text_itemNum"])) or 0
        if inputCount < ExchangePutin._currcies[ExchangePutin._currencyIndex].minNum then
            SL:ShowSystemTips("小于最低上架数量")
            return
        end
        if inputCount > ExchangePutin._currcies[ExchangePutin._currencyIndex].maxNum then
            SL:ShowSystemTips("超出最高上架数量")
            return
        end

        -- 价格
        local currencyID    = ExchangePutin._currcies[ExchangePutin._currencyIndex].id
        local inputBuyPrice = tonumber(GUI:TextInput_getString(ExchangePutin._ui["Text_single"])) or 0

        if inputBuyPrice < ExchangePutin._currcies[ExchangePutin._currencyIndex].minPrice then
            SL:ShowSystemTips("低于最低上架价格")
            return
        end
        if inputBuyPrice > ExchangePutin._currcies[ExchangePutin._currencyIndex].maxPrice then
            SL:ShowSystemTips("超出最高上架价格")
            return
        end

        SL:RequestExchangePutInItem(itemData.MakeIndex, inputCount,inputBuyPrice, currencyID)        
    end)

    -- item icon
    local Image_icon = ExchangePutin._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData, look = true, index = itemData.Index, disShowCount = true,}
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    -- name
    GUI:Text_setString(ExchangePutin._ui["Text_name"], itemData.Name)
    GUI:Text_setString(ExchangePutin._ui["Text_itemNum"], ExchangePutin._itemNum)
    GUI:Text_setString(ExchangePutin._ui["Text_single"], ExchangePutin._minSinglePrice)
    GUI:Text_setString(ExchangePutin._ui["Text_total"], ExchangePutin._itemNum*ExchangePutin._minSinglePrice)


    -- 出售货币
    ExchangePutin.Image_currency = ExchangePutin._ui["Image_currency"]
    ExchangePutin.ListView_currency = ExchangePutin._ui["ListView_currency"]
    ExchangePutin.HideCurrencyCells()
    ExchangePutin.UpdateCurrency()

    ExchangePutin.UpdateSlectedModulus()

    ExchangePutin.InitCalculatorBtn()

    -- 注册事件监听
    ExchangePutin:RegisterEvent()

    SL:AttachTXTSUI({
        root  = ExchangePutin._ui.Panel_2,
        index = SLDefine.SUIComponentTable.ExchangePutin
    })
end

function ExchangePutin.UpdateCurrencyPrice()
    ExchangePutin._itemNum     = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].minNum or 1
    ExchangePutin._maxItemNum     = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].maxNum or 100
    ExchangePutin._minSinglePrice = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].minPrice or 1
    ExchangePutin._maxSinglePrice = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].maxPrice or 10000000000

    GUI:Text_setString(ExchangePutin._ui["Text_itemNum"], ExchangePutin._itemNum)
    GUI:Text_setString(ExchangePutin._ui["Text_total"],ExchangePutin._itemNum*ExchangePutin._minSinglePrice)
    GUI:Text_setString(ExchangePutin._ui["Text_single"], ExchangePutin._minSinglePrice)
    if ExchangePutin._numAble then
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], string.format("%s/%s", ExchangePutin._itemNum, ExchangePutin._maxItemNum))
    else
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], ExchangePutin._minSinglePrice)
    end 
    GUI:Text_setString(ExchangePutin._ui["Text_price_4"], ExchangePutin._minSinglePrice and (ExchangePutin._minSinglePrice..ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].name) or "暂无")
end



function ExchangePutin.InitCalculatorBtn( ... )
    local function InputNum(value)
        local config = getCurrentNumConfig()
        local currentNum = tonumber(ExchangePutin[config.numKey]) or 0

        local newNumStr = (currentNum == 0) and tostring(value) or (ExchangePutin[config.numKey] .. value)
        local newNum = tonumber(newNumStr) or 0

        local isValid = true
        if ExchangePutin._numAble then
            if newNum > ExchangePutin._maxItemNum or newNum* tonumber(ExchangePutin._minSinglePrice) > fixMaxPrice then
                SL:ShowSystemTips("请输入有效数量")
                isValid = false
            end
        else
            local totalPrice = newNum * tonumber(ExchangePutin._itemNum)
            if totalPrice > fixMaxPrice then
                SL:ShowSystemTips("请输入有效数量")
                isValid = false
            end
        end

        if isValid then
            setNumAndRefresh(config.numKey, newNum)
        else
            local rollbackNum = tonumber(GUI:Text_getString(ExchangePutin._ui[config.uiTextKey])) or 0
            setNumAndRefresh(config.numKey, rollbackNum)
            return
        end
    end


    local function AddNum( value )
        local config = getCurrentNumConfig()
        local addValue = tonumber(value) or 0
        local currentNum = tonumber(ExchangePutin[config.numKey]) or 0
        local newNum = currentNum + addValue

        if ExchangePutin._numAble then
            newNum = math.min(newNum, ExchangePutin._maxItemNum)
        else
            local totalPrice = newNum * (tonumber(ExchangePutin._itemNum) or 0)
            if totalPrice > fixMaxPrice then
                newNum = fixMinPrice
            end
        end

        setNumAndRefresh(config.numKey, newNum)
    end

    local function RefNum()
        local config = getCurrentNumConfig()
        setNumAndRefresh(config.numKey, 0)
    end

    local function SubNum( ... )
        local config = getCurrentNumConfig()
        local numStr = tostring(ExchangePutin[config.numKey])
        local len = #numStr

        local subValue = (len > 1) and string.sub(numStr, 1, len - 1) or "0"
        setNumAndRefresh(config.numKey, subValue)
    end

    local function MaxNum()
        local config = getCurrentNumConfig()
        local maxValue = 0
        
        if ExchangePutin._numAble then
            maxValue = ExchangePutin._maxItemNum
        else
            maxValue = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].maxPrice
        end

        setNumAndRefresh(config.numKey, maxValue)
    end


    local function MinNum()
        local config = getCurrentNumConfig()
        if ExchangePutin._numAble then
            minValue = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].minNum
        else
            minValue = ExchangePutin._limitMinBuyPrices[ExchangePutin._currencyIndex].minPrice
        end
        setNumAndRefresh(config.numKey, minValue)
    end

    local btnEventMap = {
        ref = RefNum,
        sub = SubNum,
        max = MaxNum,
        min = MinNum
    }

    local btnList = GUI:getChildren(ExchangePutin._ui["Panel_num"])
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

function ExchangePutin.RefreshShowInput( ... )
    local itemNum = ExchangePutin._itemNum or "0"
    local minSinglePrice = ExchangePutin._minSinglePrice or "0"
    local total = tonumber(itemNum) * tonumber(minSinglePrice) or 0

    if ExchangePutin._numAble then
        GUI:Text_setString(ExchangePutin._ui["Text_itemNum"], itemNum)
        GUI:Text_setString(ExchangePutin._ui["Text_total"], total)
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], 
            string.format("%s/%s", itemNum, ExchangePutin._maxItemNum))
    else
        GUI:Text_setString(ExchangePutin._ui["Text_single"], minSinglePrice)
        GUI:Text_setString(ExchangePutin._ui["Text_total"], total)
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], minSinglePrice)
    end
end



function ExchangePutin.UpdateSlectedModulus()
    GUI:setVisible(ExchangePutin._ui["Image_23"],ExchangePutin._numAble)
    GUI:setVisible(ExchangePutin._ui["Image_25"],ExchangePutin._singlePricAble )
    if ExchangePutin._numAble then
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], ExchangePutin._itemNum.."/"..ExchangePutin._maxItemNum)
    else        
        GUI:Text_setString(ExchangePutin._ui["Text_selectnum"], ExchangePutin._minSinglePrice)
    end
end

function ExchangePutin.HideCurrencyCells()
    ExchangePutin._isShowCurrency = false
    GUI:ListView_removeAllItems(ExchangePutin.ListView_currency)
    GUI:setVisible(ExchangePutin.ListView_currency, false)
    GUI:setVisible(ExchangePutin.Image_currency, false)
end

function ExchangePutin.UpdateCurrency()
    local currentCurrency = ExchangePutin._currcies[ExchangePutin._currencyIndex]
    if not currentCurrency then
        print("[ExchangePutin] 未找到对应索引的货币配置")
        return
    end


    local currencyCell = ExchangePutin.CreateCurrencyCell()
    GUI:removeAllChildren(ExchangePutin._ui["Node_currency"])
    GUI:setVisible(currencyCell["Image_line"], false)

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

    createGoodsItem(currencyCell["Node_item"], currentCurrency.item)
    GUI:Text_setString(currencyCell["Text_name"], currentCurrency.name)
    GUI:addChild(ExchangePutin._ui["Node_currency"], currencyCell["nativeUI"])

    GUI:addOnClickEvent(currencyCell["nativeUI"], function()
        if ExchangePutin._isShowCurrency then
            ExchangePutin.HideCurrencyCells()
        else
            ExchangePutin.ShowCurrencyCells()
        end
    end)
    GUI:removeAllChildren(ExchangePutin._ui["Node_money_single"])
    GUI:removeAllChildren(ExchangePutin._ui["Node_money_total"])
    
    createGoodsItem(ExchangePutin._ui["Node_money_single"], currentCurrency.item)
    createGoodsItem(ExchangePutin._ui["Node_money_total"], currentCurrency.item)
end

function ExchangePutin.CreateCurrencyCell()
    local parent = GUI:Node_Create(ExchangePutin._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_putin_currency_cell" or "exchange/exchange_putin_currency_cell")
    local currency_cell = GUI:getChildByName(parent, "currency_cell")
    GUI:removeFromParent(currency_cell)
    GUI:removeFromParent(parent)

    local ui = GUI:ui_delegate(currency_cell)
    return ui
end
function ExchangePutin.ShowCurrencyCells()
    ExchangePutin._isShowCurrency = true
    GUI:ListView_removeAllItems(ExchangePutin.ListView_currency)
    GUI:setVisible(ExchangePutin.ListView_currency, true)
    GUI:setVisible(ExchangePutin.Image_currency, true)

    for key, value in ipairs(ExchangePutin._currcies) do
        local cell = ExchangePutin.CreateCurrencyCell(value)
        GUI:setVisible(cell["Image_bg"], false)
        local goodsItem = GUI:ItemShow_Create(cell["Node_item"], "goodsItem", 0, 0, { index = value.item.Index, itemData = value.item })
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, 0.6)
        GUI:Text_setString(cell["Text_name"], value.name)
        GUI:ListView_pushBackCustomItem(ExchangePutin.ListView_currency, cell["nativeUI"])
        GUI:addOnClickEvent(cell["nativeUI"], function()
            ExchangePutin._currencyIndex = key
            ExchangePutin.HideCurrencyCells()
            ExchangePutin.UpdateCurrency()
            ExchangePutin.UpdateCurrencyPrice()
        end)
    end

    local height = math.min(#ExchangePutin._currcies * 30, 235)
    GUI:setContentSize(ExchangePutin.ListView_currency, 150, height)
    GUI:setContentSize(ExchangePutin.Image_currency, 150, height + 5)
end

function ExchangePutin.ShowItemPrice(data)
    if not data then
        return 
    end
    local currentCurrency = ExchangePutin._currcies[ExchangePutin._currencyIndex]
    local name = SL:GetValue("ITEM_NAME", data.iconType)
    GUI:Text_setString(ExchangePutin._ui["Text_price_2"], data.newPrice == 0 and "暂无" or (data.newPrice..currentCurrency.name))
end




function ExchangePutin.Close()
    GUI:Win_CloseByID(UIConst.LAYERID.ExchangePutinGUI)
end

-- 界面关闭回调
function ExchangePutin.OnClose()
    ExchangePutin.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.ExchangePutin
    })
end

function ExchangePutin.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_IN, "ExchangePutin", ExchangePutin.Close)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_PRICE, "ExchangePutin", ExchangePutin.ShowItemPrice)
end

function ExchangePutin.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_IN, "ExchangePutin")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_PRICE, "ExchangePutin")
end

ExchangePutin.main()