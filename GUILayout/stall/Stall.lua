Stall = {}
StallInfo = StallInfo or {}

function Stall.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if not StallInfo._layer then
        Stall.InitData(data)
        Stall.InitUI()
        Stall.UpdateStallPanelInfo()
        Stall.RegisterEvent()
        UIOperator:OpenBagUI({ pos = { x = 0, y = 0 } })
    else
        local nowOpened = StallInfo._buy
        local openStatus = data and data.buy or false
        if openStatus ~= nowOpened then
            UIOperator:CloseStallLayerUI()
            UIOperator:OpenStallLayerUI(data)
        end
    end
end

function Stall.InitData(data)
    StallInfo._isWinMode        = SL:GetValue("IS_PC_OPER_MODE")
    StallInfo._maxNum           = 20
    StallInfo._itemWid          = StallInfo._isWinMode and 40.5 or 62
    StallInfo._itemHei          = StallInfo._isWinMode and 42 or 64
    StallInfo._itemPanelWid     = StallInfo._isWinMode and 209 or 316
    StallInfo._itemPanelHei     = StallInfo._isWinMode and 168 or 256
    StallInfo._rowMaxItemNum    = 5
    StallInfo._selectImg        = nil
    StallInfo._selectID         = nil
    -- 购买
    StallInfo._buy = data and data.buy or false
end

function Stall.InitUI()
    StallInfo._layer = GUI:Win_Create(UIConst.LAYERID.StallLayerGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(StallInfo._layer, StallInfo._isWinMode and "stall/stall_layer_win32" or "stall/stall_layer")
    StallInfo._ui = GUI:ui_delegate(StallInfo._layer)
    GUI:setSwallowTouches(StallInfo._ui.Panel_addItem, false)
    GUI:setVisible(StallInfo._ui.Button_cancel, not StallInfo._buy)
    GUI:Button_setTitleText(StallInfo._ui.Button_do, StallInfo._buy and "购买" or "摆摊")
    GUI:Text_setString(StallInfo._ui.Text_titleName, StallInfo._buy and SL:GetValue("STALL_SELL_SHOW_NAME") or "我的摊位")

    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPositionY(StallInfo._ui.PMainUI, StallInfo._isWinMode and SL:GetValue("PC_POS_Y") or (winSizeH / 2))
    GUI:Win_SetZPanel(StallInfo._layer, StallInfo._ui.PMainUI)
    GUI:Win_SetDrag(StallInfo._layer, StallInfo._ui.Image_move)

    local chooseTag = GUI:Image_Create(StallInfo._ui.Panel_addItem, "chooseTag", 0, 0, "res/public/1900000678_1.png")
    GUI:setIgnoreContentAdaptWithSize(chooseTag, false)
    GUI:setAnchorPoint(chooseTag, 0.5, 0.5)
    GUI:Image_setScale9Slice(chooseTag, 20, 20, 20, 20)
    GUI:setContentSize(chooseTag, StallInfo._isWinMode and 48 or 66, StallInfo._isWinMode and 48 or 68)
    GUI:setVisible(chooseTag, false)
    StallInfo._selectImg = chooseTag

    GUI:addOnClickEvent(StallInfo._ui.Button_close, function()
        if not SL:GetValue("STALL_MY_TRADING_STATUS") then
            Stall.CleanMySellData()
        end
        UIOperator:CloseStallLayerUI()
    end)

    GUI:addOnClickEvent(StallInfo._ui.Button_cancel, function()
        if not SL:GetValue("STALL_MY_TRADING_STATUS") then
            Stall.CleanMySellData()
        end
        SL:RequestCancelAutoStall()
        UIOperator:CloseStallLayerUI()
    end)

    GUI:addOnClickEvent(StallInfo._ui.Button_do, function(sender)
        if StallInfo._buy then
            if StallInfo._selectID then
                local itemData = Stall.GetOnSellDataByMakeIndex(StallInfo._selectID)
                if not itemData then 
                    return 
                end
                local count = SL:GetValue("ITEM_COUNT", itemData.goldtype, true)
                if count < itemData.price then 
                    local name = SL:GetValue("ITEM_NAME", itemData.goldtype)
                    SL:ShowSystemTips(string.format("%s不足", name))
                    return 
                end
                SL:RequestStallBuyItem(StallInfo._selectID)
                GUI:delayTouchEnabled(sender)
            else
                SL:ShowSystemTips("未选中购买商品")
            end
        else
            local data = SL:GetValue("STALL_MYSELL_DATA")
            if data and next(data) then
                UIOperator:OpenStallSetLayerUI()
            end
        end
    end)

    local function addItemStall(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state and StallInfo._buy == false then
            local goToName = GUIDefine.ItemGoTo.AUTO_TRADE
            local data = {}
            data.target = goToName
            data.pos = touchPos
            data.itemPosInTrade = Stall.GetItemEmptyPos(touchPos)
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end
    GUI:addMouseButtonEvent(StallInfo._ui.Panel_addItem,{
        onRightDownFunc = function() return -1 end,
        onSpecialRFunc = addItemStall
    })
end

function Stall.CleanMySellData()
    local mySellData = SL:GetValue("STALL_MYSELL_DATA")
    if mySellData and next(mySellData) then
        for i, v in ipairs(mySellData) do
            v.goldtype = nil
            v.price = nil
            BagData.AddItemDataAndNotice(v)
        end
    end
    SL:StallCleanMySellData()
end

function Stall.RefreshChoosTag(makeIndex)
    if not makeIndex then
        GUI:Text_setString(StallInfo._ui.Text_price, "")
        GUI:Text_setString(StallInfo._ui.Text_itemName, "")
        if StallInfo._selectImg then
            GUI:setPosition(StallInfo._selectImg, 0, 0)
            GUI:setVisible(StallInfo._selectImg, false)
        end
        return
    end

    local itemData = StallInfo._buy and Stall.GetOnSellDataByMakeIndex(makeIndex) or Stall.GetMySellDataByMakeIndex(makeIndex)

    if itemData then
        local price =  itemData.price or 0
        local goldTypeName = SL:GetValue("ITEM_NAME", itemData.goldtype)
        GUI:Text_setString(StallInfo._ui.Text_price, price .. goldTypeName)
        GUI:Text_setString(StallInfo._ui.Text_itemName, itemData.Name)
    end

    if not StallInfo._selectImg then
        return
    end

    local item = GUI:getChildByStrTag(StallInfo._ui.Panel_items, makeIndex)
    if item then
        local posX = GUI:getPositionX(item)
        local posY = GUI:getPositionY(item)
        GUI:setPosition(StallInfo._selectImg, posX, posY)
        GUI:setVisible(StallInfo._selectImg, true)
    else
        GUI:setPosition(StallInfo._selectImg, 0, 0)
        GUI:setVisible(StallInfo._selectImg, false)
    end
end

function Stall.UpdateStallPanelInfo()
    Stall.RefreshChoosTag(nil)
    GUI:removeAllChildren(StallInfo._ui.Panel_items)

    local items = StallInfo._buy and SL:GetValue("STALL_ONSELL_DATA") or SL:GetValue("STALL_MYSELL_DATA")
    for k, data in ipairs(items) do
        if k > StallInfo._maxNum then
            return
        end

        local YPos = math.floor((k - 1) / StallInfo._rowMaxItemNum)
        local XPos = (k - 1) % StallInfo._rowMaxItemNum
        local posX = XPos * (StallInfo._itemWid + 1.5) + StallInfo._itemWid / 2   -- 底图带框 适当偏移
        local posY = StallInfo._itemPanelHei - StallInfo._itemHei / 2 - StallInfo._itemHei * YPos
        local item = GUI:ItemShow_Create(StallInfo._ui.Panel_items, "Item_" .. data.MakeIndex, posX, posY, {
            itemData    = data,
            index       = data.Index,
            look        = true,
            movable     = not StallInfo._buy,
            from        = GUIDefine.ItemFrom.AUTO_TRADE
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
        GUI:setStrTag(item, data.MakeIndex)

        local function OnTouchEvent()
            local tipsPos = GUI:getWorldPosition(item)
            if not tipsPos or next(tipsPos) == nil then
                return
            end
            UIOperator:OpenItemTips({
                itemData = data,
                pos      = tipsPos,
                from     = GUIDefine.ItemFrom.AUTO_TRADE
            })
            StallInfo._selectID = data.MakeIndex
            Stall.RefreshChoosTag(data.MakeIndex)
        end
        GUI:addOnTouchEvent(item, OnTouchEvent)

        if StallInfo._isWinMode then
            local function mouseMoveCallBack()
                if item._movingState then
                    return
                end
                UIOperator:OpenItemTips({
                    itemData = data,
                    pos      = GUI:getWorldPosition(item),
                    from     = GUIDefine.ItemFrom.AUTO_TRADE
                })
            end

            local function leaveItem()
                UIOperator:CloseItemTips()
            end

            GUI:addMouseMoveEvent(item, {
                onEnterFunc = mouseMoveCallBack,
                onLeaveFunc = leaveItem
            })
        end
    end
end

function Stall.GetItemEmptyPos(touchPos)
    local x = touchPos.x
    local y = touchPos.y
    local panelWorldPos = GUI:getWorldPosition(StallInfo._ui.Panel_addItem)
    local posXInPanel = x - panelWorldPos.x
    local posYInPanel = panelWorldPos.y - y
    if posXInPanel >= StallInfo._itemPanelWid or posXInPanel <= 0 then
        return false
    end
    if posYInPanel >= StallInfo._itemPanelHei or posYInPanel <= 0 then
        return false
    end
    local indexX = math.ceil(posXInPanel / StallInfo._itemWid)
    local indexY = math.floor(posYInPanel / StallInfo._itemHei)

    local posIndex = indexY * StallInfo._rowMaxItemNum + indexX
    if posIndex > StallInfo._maxNum then
        return false
    end
    return posIndex
end

function Stall.GetMySellDataByMakeIndex(MakeIndex)
    local data = SL:GetValue("STALL_MYSELL_DATA")
    if not data or next(data) == nil then
        return nil
    end
    local item = nil
    for k, v in pairs(data) do
        if v.MakeIndex == MakeIndex then
            item = v
            break
        end
    end
    return item
end

function Stall.GetOnSellDataByMakeIndex(MakeIndex)
    local data = SL:GetValue("STALL_ONSELL_DATA")
    if not data or next(data) == nil then
        return nil
    end
    local item = nil
    for k, v in pairs(data) do
        if v.MakeIndex == MakeIndex then
            item = v
            break
        end
    end
    return item
end
--------------------------- 注册事件 -----------------------------
function Stall.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, "Stall", Stall.UpdateStallPanelInfo)
    SL:RegisterLUAEvent(LUA_EVENT_STALL_ITEM_LIST_CHANGE, "Stall", Stall.UpdateStallPanelInfo)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Stall", Stall.OnCloseLayer) --关闭界面
end

function Stall.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, "Stall")
    SL:UnRegisterLUAEvent(LUA_EVENT_STALL_ITEM_LIST_CHANGE, "Stall")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Stall")
end

-- 关闭监听
function Stall.OnCloseLayer(id)
    if UIConst.LAYERID.StallLayerGUI == id and StallInfo and StallInfo._layer then
        Stall.UnRegisterEvent()
        StallInfo = nil
    end
end

Stall.main()