Trade = {}

local TRADE_ITEM_SIZE_WIDTH       = 67
local TRADE_ITEM_SIZE_HEIGHT      = 68
local TRADE_ITEM_SIZE_WIDTH_WIN   = 42
local TRADE_ITEM_SIZE_HEIGHT_WIN  = 42
local TRADE_ROW_MAX_ITEM_NUMBER   = 5
local TRADE_MAX_ITEM_NUMBER       = 10
local TRADE_ITEM_PANEL_HEIGHT     = 136
local TRADE_ITEM_PANEL_WIDTH      = 340
local TRADE_ITEM_PANEL_HEIGHT_WIN = 84
local TRADE_ITEM_PANEL_WIDTH_WIN  = 210

local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
local itemFrom  = GUIDefine.ItemFrom
local itemGoTo  = GUIDefine.ItemGoTo

Trade._isBeCancel = false

function Trade.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.TradeGUI) then
        return
    end

    Trade._isBeCancel = false
    Trade._layer = GUI:Win_Create(UIConst.LAYERID.TradeGUI, 0, 0, 0, 0, false, false, true, true)
    if isWinMode then
        GUI:LoadExport(Trade._layer, "trade/trade_layer_win32")
    else
        GUI:LoadExport(Trade._layer, "trade/trade_layer")
    end
    
    -- 关闭回调
    GUI:Win_SetCloseCB(Trade._layer, function()
        Trade._layer = nil
        Trade.RemoveEvent()
        SL:RequestSendItemMoveMsg()
        -- 主动关闭时，通知服务器取消交易
        if not Trade._isBeCancel then
            SL:RequestTradeCancel()
        end
    end)

    Trade._ui = GUI:ui_delegate(Trade._layer)

    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    local pSize    = GUI:getContentSize(Trade._ui.PMainUI)
    local rightSpace = isWinMode and 150 or 80
    GUI:setPositionX(Trade._ui.PMainUI, winSizeW - rightSpace - pSize.width)

    GUI:Win_SetZPanel(Trade._layer, Trade._ui.PMainUI)

    --自己关闭
    local btnCloseMy = GUI:getChildByName(Trade._ui["Panel_self"],"btnClose")
    GUI:addOnClickEvent(btnCloseMy, function()
        Trade.Close()
    end)

    --其他人关闭
    local btnCloseTarget = GUI:getChildByName(Trade._ui["Panel_target"],"btnClose")
    GUI:addOnClickEvent(btnCloseTarget, function()
        Trade.Close()
    end)

    --别人的名字
    local traderData = SL:GetValue("TRADE_TARGET_DATA")
    if traderData and next(traderData) then
        local ui_targetName = GUI:getChildByName(Trade._ui["Panel_target"],"Text_name")
        GUI:Text_setString(ui_targetName,traderData.name)
    end

    --我自己的名字
    local myName = SL:GetValue("USER_NAME")
    local ui_myName = GUI:getChildByName(Trade._ui["Panel_self"],"Text_name")
    GUI:Text_setString(ui_myName,myName)

    Trade.InitGUI()
    Trade.RegisterEvent()
end

function Trade.InitGUI()
    if isWinMode then
        GUI:addOnClickEvent(Trade._ui.Button_trade, function(sender)
            GUI:delayTouchEnabled(sender)
            if not SL:GetValue("TRADE_MY_LOCK_STATUS") or not SL:GetValue("TRADE_TARGET_LOCK_STATUS") then
                SL:RequestTradeChangeLock()
                return
            end
            SL:RequestTradeEnd()
        end)
    else
        GUI:addOnClickEvent(Trade._ui.Button_trade, function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestTradeEnd()
        end)
    
        GUI:addOnClickEvent(Trade._ui.Button_lock, function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestTradeChangeLock()
        end)
    end

    local isForbid = SL:GetValue("SERVER_OPTION", SW_KEY_NO_SELL_MONEY) == true
    if isForbid then
        GUI:setTouchEnabled(Trade._ui["Panel_addGold"],false)
        local ui_imagegold = GUI:getChildByName(Trade._ui["Panel_self"], "Image_gold")
        GUI:setTouchEnabled(ui_imagegold,false)
        local uiSelfGold = GUI:getChildByName(Trade._ui["Panel_self"], "Text_gold")
        GUI:Text_setString(uiSelfGold, "禁止交易货币")
        local uiTargetGold = GUI:getChildByName(Trade._ui["Panel_target"], "Text_gold")
        GUI:Text_setString(uiTargetGold, "禁止交易货币")
    end
    local imageMyselfForbid = GUI:getChildByName(Trade._ui.Panel_self, "Image_forbid")
    local imageTargetForbid = GUI:getChildByName(Trade._ui.Panel_target, "Image_forbid")
    GUI:setVisible(imageMyselfForbid,isForbid)
    GUI:setVisible(imageTargetForbid,isForbid)

    --初始化背包
    Trade.InitBag()
    Trade.RegisterMouseEvent()
end 

function Trade.InitBag()
    local data = {pos = {x = 0, y = 0}}
    UIOperator:OpenBagUI(data) 
end

function Trade.RegisterMouseEvent()
    GUI:setSwallowTouches(Trade._ui.Panel_itemTouch,false)
    local ui_imgGold = GUI:getChildByName(Trade._ui.Panel_self, "Image_gold")

    GUI:addOnClickEvent(ui_imgGold, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestAddGoldToTrade()
    end)

    GUI:addOnClickEvent(Trade._ui.Panel_addGold, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestAddGoldToTrade()
    end)

    local function setNoswallowMouse()
        return -1
    end

    local function addItemIntoTrade(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = itemGoTo.TRADE
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.itemPosInbag = Trade.GetItemBagEmptyPos(touchPos)
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    GUI:addMouseButtonEvent(Trade._ui.Panel_itemTouch, {
        onRightDownFunc = setNoswallowMouse,
        onSpecialRFunc = addItemIntoTrade
    })

    local function addGoldIntoTrade(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = itemGoTo.TRADE
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.isGold = true
            data.itemPosInbag = Trade.GetItemBagEmptyPos(touchPos)
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    GUI:addMouseButtonEvent(ui_imgGold, {
        onRightDownFunc = setNoswallowMouse,
        onSpecialRFunc = addGoldIntoTrade
    })

    local param = {}
    param.nodeFrom = itemFrom.TRADE_GOLD
    param.moveNode = ui_imgGold
    param.cancelMoveCall = function()
        ui_imgGold._movingState = false
    end
    GUI:RegisterNodeMovaEvent(ui_imgGold, param)
end

function Trade.GetItemBagEmptyPos(touchPos)
    local x = touchPos.x
    local y = touchPos.y
    local panelWorldPos = GUI:getWorldPosition(Trade._ui.Panel_itemTouch)
    local panelSize = GUI:getContentSize(Trade._ui.Panel_itemTouch)
    local posXInPanel = x - panelWorldPos.x
    local posYInPanel = panelWorldPos.y - y
    if posXInPanel >= panelSize.width or posXInPanel <= 0 then
        return nil
    end

    if posYInPanel >= panelSize.height or posYInPanel <= 0 then
        return nil
    end
    local indexX = math.ceil(posXInPanel/TRADE_ITEM_SIZE_WIDTH)
    local indexY = math.floor(posYInPanel/TRADE_ITEM_SIZE_HEIGHT)
    if isWinMode then
        indexX = math.ceil(posXInPanel/TRADE_ITEM_SIZE_WIDTH_WIN)
        indexY = math.floor(posYInPanel/TRADE_ITEM_SIZE_HEIGHT_WIN)
    end

    local posIndex = indexY*TRADE_ROW_MAX_ITEM_NUMBER + indexX
    if posIndex > TRADE_MAX_ITEM_NUMBER then
        return nil
    end
    return posIndex
end

function Trade.UpdateItemList(param)
    if not param or not next(param) then
        return
    end
    local panel = Trade._ui.Panel_self
    local items = SL:GetValue("TRADE_MY_ITEMS")
    if param.way == 1 then -- 1为交易方的 其他为自己的
        panel = Trade._ui.Panel_target
        items = SL:GetValue("TRADE_TARGET_ITEMS")
    end
    local panelItem = GUI:getChildByName(panel,"Panel_item")
    GUI:removeAllChildren(panelItem)

    local itemHeight = TRADE_ITEM_SIZE_HEIGHT
    local itemWidth  = TRADE_ITEM_SIZE_WIDTH
    local maxHeight  = TRADE_ITEM_PANEL_HEIGHT
    local maxWidth   = TRADE_ITEM_PANEL_WIDTH
    if isWinMode then
        itemHeight = TRADE_ITEM_SIZE_HEIGHT_WIN
        itemWidth  = TRADE_ITEM_SIZE_WIDTH_WIN
        maxHeight  = TRADE_ITEM_PANEL_HEIGHT_WIN
        maxWidth   = TRADE_ITEM_PANEL_WIDTH_WIN
    end
    local rowMax = TRADE_ROW_MAX_ITEM_NUMBER
    local pos = 1
    for MakeIndex,data in pairs(items) do
        if pos > TRADE_MAX_ITEM_NUMBER then
            return
        end
        local info = {}
        info.itemData = data
        info.index = data.Index
        info.look = true
        info.movable = param.way ~= 1
        info.from = itemFrom.TRADE

        local YPos = math.floor((pos-1)/rowMax)
        local XPos = (pos-1)%rowMax
        local posX = XPos*(itemWidth + 1.5)-- 底图带框 适当偏移
        local posY = maxHeight - itemHeight/2 - itemHeight*YPos - itemHeight/2
        local goodItem = GUI:ItemShow_Create(panelItem, "goodItem_" .. pos, posX, posY, info)

        local function QuickPutOut()
            if not data then
                return
            end
            local state = SL:GetValue("TRADE_MY_LOCK_STATUS")
            if state then
                --请解锁后操作提示
                SL:onLUAEvent(LUA_EVENT_TRADE_UNLOCK_OPERATION)
            end
            if state then
                return
            end
            if BagData.isToBeFull(true) then
                return
            end
            local itemID = data.MakeIndex
            SL:RequestTradePutOutItem(itemID)
        end
        -- 双击
        GUI:ItemShow_addDoubleEvent(goodItem, QuickPutOut)

        if isWinMode then
            local function mouseMoveCallBack()
                if goodItem._movingState then
                    return
                end
                local tipsData = {}
                tipsData.itemData = data
                tipsData.pos = GUI:getWorldPosition(goodItem)
                UIOperator:OpenItemTips(data)
            end

            local function leaveItem()
                UIOperator:CloseItemTips()
            end

            GUI:addMouseMoveEvent(goodItem, {
                onEnterFunc = mouseMoveCallBack, 
                onLeaveFunc = leaveItem
            })
        end
        pos = pos + 1
    end
end

function Trade.OnRefreshTradeMoney(data)
    if not data or not next(data) then
        return
    end

    local textGold = GUI:getChildByName(Trade._ui["Panel_target"], "Text_gold")
    GUI:Text_setString(textGold, data.count or 0)
end 

function Trade.OnRefreshMyselfMoney(data)
    if not data or not next(data) then
        return
    end

    local textGold = GUI:getChildByName(Trade._ui["Panel_self"], "Text_gold")
    GUI:Text_setString(textGold, data.count or 0)
end 

function Trade.OnRefreshTradeStatus()
    local targetState = SL:GetValue("TRADE_TARGET_LOCK_STATUS")
    local panelLock = GUI:getChildByName(Trade._ui["Panel_target"], "Panel_lockStatus")
    GUI:setVisible(panelLock, targetState)

    if isWinMode then
        local myState = SL:GetValue("TRADE_MY_LOCK_STATUS")
        local btnTrade = GUI:getChildByName(Trade._ui["Panel_self"], "Button_trade") 
        local titleStr = (targetState and myState) and "交易" or ( myState and "解除锁定" or "锁定")
        GUI:Button_setTitleText(btnTrade, titleStr)
    end 
end 

function Trade.OnRefreshMyStatus()
    local myState = SL:GetValue("TRADE_MY_LOCK_STATUS")
    local panelLock = GUI:getChildByName(Trade._ui["Panel_self"],"Panel_lockStatus") 
    GUI:setVisible(panelLock, myState)

    if isWinMode then
        local targetState = SL:GetValue("TRADE_TARGET_LOCK_STATUS")
        local btnTrade = GUI:getChildByName(Trade._ui["Panel_self"], "Button_trade") 
        local titleStr = (myState and targetState) and "交易" or ( myState and "解除锁定" or "锁定")
        GUI:Button_setTitleText(btnTrade, titleStr)
    else
        local btnLock = GUI:getChildByName(Trade._ui["Panel_self"], "Button_lock") 
        local titleStr = myState and "解除锁定" or "锁定"
        GUI:Button_setTitleText(btnLock, titleStr)
    end 
end 

function Trade.Close()
    if Trade._layer then
        GUI:Win_Close(Trade._layer)
    end
end

function Trade.OnTraderItemChange(data)
    Trade.UpdateItemList(data)
end

function Trade.OnMyselfItemChange(data)
    Trade.UpdateItemList(data)
end

function Trade.OnTradeBeCancel()
    Trade._isBeCancel = true
    Trade.Close()
end

-----------------------------------注册事件--------------------------------------
function Trade.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_CANCELED,            "Trade", Trade.OnTradeBeCancel)        -- 交易被取消
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_TARGET_MONEY_CHANGE, "Trade", Trade.OnRefreshTradeMoney)    -- 交易货币改变
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MYSELF_MONEY_CHANGE, "Trade", Trade.OnRefreshMyselfMoney)   -- 交易自己货币改变
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_STATUS_CHANGE,       "Trade", Trade.OnRefreshTradeStatus)   -- 交易状态改变
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MY_STATUS_CHANGE,    "Trade", Trade.OnRefreshMyStatus)      -- 交易自己状态改变
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_TRADER_TIEM_CHANGE,  "Trade", Trade.OnTraderItemChange)
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_MYSEFL_ITEM_CHANGE,  "Trade", Trade.OnMyselfItemChange)
end

function Trade.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_CANCELED,            "Trade") -- 交易被取消
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_TARGET_MONEY_CHANGE, "Trade") -- 交易货币改变
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MYSELF_MONEY_CHANGE, "Trade") -- 交易自己货币改变
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_STATUS_CHANGE,       "Trade") -- 交易状态改变
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MY_STATUS_CHANGE,    "Trade") -- 交易自己状态改变
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_TRADER_TIEM_CHANGE,  "Trade")
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_MYSEFL_ITEM_CHANGE,  "Trade")
end

Trade.main()