StallPut = {}
StallPut._currencyShowStr = "%s出售"    -- 货币展示格式

function StallPut.main()
    local data = GUI:GetLayerOpenParam()
    StallPut.InitData()
    StallPut.InitUI(data)
end

function StallPut.InitData()
    StallPut._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    StallPut._goldType = 0
    StallPut._sellPrice = 0
end

function StallPut.InitUI(data)
    local makeIndex = data
    StallPut._parent = GUI:Win_Create(UIConst.LAYERID.StallPutGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(StallPut._parent, StallPut._isWinMode and "stall/stall_put_layer_win32" or "stall/stall_put_layer")
    StallPut._ui = GUI:ui_delegate(StallPut._parent)

    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPosition(StallPut._ui.PMainUI, winSizeW / 2, StallPut._isWinMode and SL:GetValue("PC_POS_Y") or winSizeH / 2)
    GUI:Win_SetZPanel(StallPut._parent, StallPut._ui.PMainUI)

    GUI:TextInput_setInputMode(StallPut._ui.TextField_price, 2)
    GUI:Text_setString(StallPut._ui.TextField_price, 0)
    GUI:TextInput_addOnEvent(StallPut._ui.TextField_price, function(_, eventType)
        local input = tonumber(GUI:Text_getString(StallPut._ui.TextField_price)) or 0
        if input < 0 then
            input = 0
        end
        StallPut._sellPrice = input
    end)

    local function CancelCallBack() -- 背包中的重新刷出来
        local data = {
            dropping = {
                MakeIndex = makeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, data)
        UIOperator:CloseStallPutLayerUI()
    end
    GUI:addOnClickEvent(StallPut._ui.Button_close, CancelCallBack)
    GUI:addOnClickEvent(StallPut._ui.Button_cancel, CancelCallBack)
    GUI:addOnClickEvent(StallPut._ui.Button_sell, function ()
        local price = GUI:Text_getString(StallPut._ui.TextField_price)
        local isFull = SL:GetValue("STALL_IS_FULL")
        if not isFull and price and tonumber(price) > 0 and not SL:GetValue("STALL_MY_TRADING_STATUS") then
            StallPut.PutItemIntoAutoSellFromBag(makeIndex, StallPut._goldType, tonumber(price))
            UIOperator:CloseStallPutLayerUI()
        else
            CancelCallBack()
        end
    end)

    GUI:addOnClickEvent(StallPut._ui.Button_currency_open, function()
        StallPut.HideCurrencyList()
    end)

    GUI:addOnClickEvent(StallPut._ui.Button_currency_close, function()
        StallPut.ShowCurrencyList()
    end)

    GUI:setVisible(StallPut._ui.Button_currency_close, true)
    StallPut.UpdateCurrencyList()
end

function StallPut.ShowCurrencyList()
    GUI:setVisible(StallPut._ui.Button_currency_open, true)
    GUI:setVisible(StallPut._ui.Button_currency_close, false)
    GUI:stopAllActions(StallPut._ui.ListView_currency)
    GUI:setVisible(StallPut._ui.ListView_currency, true)
    local scaleAction = GUI:ActionScaleTo(0.1, 1)
    GUI:runAction(StallPut._ui.ListView_currency, scaleAction)
end

function StallPut.HideCurrencyList()
    GUI:setVisible(StallPut._ui.Button_currency_open, false)
    GUI:setVisible(StallPut._ui.Button_currency_close, true)
    GUI:stopAllActions(StallPut._ui.ListView_currency)
    local scaleAction = GUI:ActionScaleTo(0.1, 1, 0)
    local callback = GUI:CallFunc(function()
            GUI:setVisible(StallPut._ui.ListView_currency, false)
    end)
    local sequence = GUI:ActionSequence(scaleAction, callback)
    GUI:runAction(StallPut._ui.ListView_currency, sequence)
end

function StallPut.PutItemIntoAutoSellFromBag(MakeIndex, goldType, price)
    local item = BagData.GetItemDataByMakeIndex(MakeIndex)
    if item then
        local bagPos = BagData.GetBagPosByMakeIndex(MakeIndex)
        BagData.DelItemData(item, true, nil, nil, true)

        item.goldtype = goldType
        item.price = price
        item.bagPos = bagPos

        SL:StallAddItemToSell(item)
        SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", MakeIndex, GUIDefine.ItemBelong.STALL)
        SL:onLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, item)
    end
end

--更新货币
function StallPut.UpdateCurrencyList()
    local currencies = SL:GetValue("STALL_MONEY")
    local onEvent = function(v)
        if v then
            StallPut._goldType = v.id
            StallPut.UpdateCurrency(v.name)
            StallPut.HideCurrencyList()
        end
    end

    for i, v in ipairs(currencies) do
        local text = GUI:Clone(StallPut._ui.Text_currency_item)
        GUI:setVisible(text, true)
        GUI:Text_setString(text, v.name)
        GUI:setTouchEnabled(text, true)
        GUI:addOnClickEvent(text, function()
            onEvent(v)
        end)
        GUI:ListView_pushBackCustomItem(StallPut._ui.ListView_currency, text)
    end

    local listWid = GUI:getContentSize(StallPut._ui.ListView_currency).width
    GUI:setContentSize(StallPut._ui.ListView_currency,  GUI:Size(listWid, 20 * (#currencies)))
    onEvent(currencies[1])
end

--更新出售的货币  currency_name：货币名
function StallPut.UpdateCurrency(currency_name)
    if currency_name then
        local sform = string.format(StallPut and StallPut._currencyShowStr, currency_name)
        GUI:Text_setString(StallPut._ui.Text_currency, sform)
    else
        GUI:Text_setString(StallPut._ui.Text_currency, "")
    end
end

StallPut.main()