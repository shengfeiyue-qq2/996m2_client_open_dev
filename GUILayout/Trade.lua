Trade = {}

function Trade.main()
    local parent = GUI:Attach_Parent()

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "trade/trade_layer_win32")
    else
        GUI:LoadExport(parent, "trade/trade_layer")
    end

    Trade._ui = GUI:ui_delegate(parent)

    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    local pSize    = GUI:getContentSize(Trade._ui.PMainUI)
    local rightSpace = isWinMode and 150 or 80
    Trade._ui.PMainUI:setPositionX(winSizeW - rightSpace - pSize.width)

    GUI:Win_SetZPanel(parent, Trade._ui.PMainUI)

    --自己关闭
    local btnCloseMy = GUI:getChildByName(Trade._ui["Panel_self"],"btnClose")
    GUI:addOnClickEvent(btnCloseMy, function()
        SL:CloseTradeUI()
    end)

    --其他人关闭
    local btnCloseOther = GUI:getChildByName(Trade._ui["Panel_other"],"btnClose")
    GUI:addOnClickEvent(btnCloseOther, function()
        SL:CloseTradeUI()
    end)

    -- other name
    local traderData = SL:GetMetaValue("TRADE_DATA")
    if traderData and next(traderData) then
        local ui_otherName = GUI:getChildByName(Trade._ui["Panel_other"],"Text_name")
        GUI:Text_setString(ui_otherName,traderData.name)
    end

    -- my name
    local myName = SL:GetMetaValue("USER_NAME")
    local ui_myName = GUI:getChildByName(Trade._ui["Panel_self"],"Text_name")
    GUI:Text_setString(ui_myName,myName)

    Trade.RegisterEvent()
end

function Trade.OnRefreshTradeMoney(data)
    if not data or not next(data) then
        return
    end

    local textGold = GUI:getChildByName(Trade._ui["Panel_other"],"Text_gold")
    GUI:Text_setString(textGold,data.count or 0)
end 

function Trade.OnRefreshMyMoney(data)
    if not data or not next(data) then
        return
    end

    local textGold = GUI:getChildByName(Trade._ui["Panel_self"],"Text_gold")
    GUI:Text_setString(textGold,data.count or 0)
end 

function Trade.OnRefreshTradeStatus()
    local otherState = SL:GetMetaValue("TRADE_OTHER_LOCK_STATUS")
    local panelLock = GUI:getChildByName(Trade._ui["Panel_other"], "Panel_lockStatus")
    GUI:setVisible(panelLock, otherState)

    if SL:GetMetaValue("WINPLAYMODE") then
        local myState = SL:GetMetaValue("TRADE_MY_LOCK_STATUS")
        local btnTrade = GUI:getChildByName(Trade._ui["Panel_self"], "Button_trade") 
        local titleStr = (otherState and myState) and "交易" or ( myState and "解除锁定" or "锁定")
        GUI:Button_setTitleText(btnTrade, titleStr)
    end 
end 

function Trade.OnRefreshMyStatus()
    local myState = SL:GetMetaValue("TRADE_MY_LOCK_STATUS")
    local panelLock = GUI:getChildByName(Trade._ui["Panel_self"],"Panel_lockStatus") 
    GUI:setVisible(panelLock, myState)

    if SL:GetMetaValue("WINPLAYMODE") then
        local otherState = SL:GetMetaValue("TRADE_OTHER_LOCK_STATUS")
        local btnTrade = GUI:getChildByName(Trade._ui["Panel_self"], "Button_trade") 
        local titleStr = (myState and otherState) and "交易" or ( myState and "解除锁定" or "锁定")
        GUI:Button_setTitleText(btnTrade, titleStr)
    else
        local btnLock = GUI:getChildByName(Trade._ui["Panel_self"], "Button_lock") 
        local titleStr = myState and "解除锁定" or "锁定"
        GUI:Button_setTitleText(btnLock, titleStr)
    end 
end 


-----------------------------------注册事件--------------------------------------
function Trade.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MONEY_CHANGE, "Trade1", Trade.OnRefreshTradeMoney)
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MY_MONEY_CHANGE, "Trade2", Trade.OnRefreshMyMoney)
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_STATUS_CHANGE, "Trade3", Trade.OnRefreshTradeStatus)
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MY_STATUS_CHANGE, "Trade4", Trade.OnRefreshMyStatus)
end

function Trade.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MONEY_CHANGE, "Trade1")
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MY_MONEY_CHANGE, "Trade2")
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_STATUS_CHANGE, "Trade3")
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MY_STATUS_CHANGE, "Trade4")
end
