PlayerBestRing = {}

PlayerBestRing._ui = nil

-- 拖动区域默认尺寸
local TouchSize   = {width = 292, height = 219}

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

function PlayerBestRing.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    PlayerBestRing._ui = ui
    
    PlayerBestRing._EquipPosSet = EquipPosSet

    TouchSize = GUI:getContentSize(PlayerBestRing._ui["PanelTouch"])

    local PMainUI = PlayerBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(PlayerBestRing._ui["CloseButton"], PlayerBestRing.OnClose)
    PlayerBestRing.RegistEvent()
    PlayerBestRing.RegisterMouseEvent()

    -- 初始化装备事件
    PlayerBestRing.InitEquipLayerEvent()
end

function PlayerBestRing.OnClose()
    SL:CloseBestRingBoxUI(1)
end

-- 注册事件
function PlayerBestRing.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerBestRing", PlayerBestRing.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerBestRing", PlayerBestRing.UpdateEquipLayer)
end

function PlayerBestRing.CloseCallback()
    PlayerBestRing.UnRegisterEvent()
end

-- 取消事件
function PlayerBestRing.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerBestRing")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerBestRing")
end

-- 装备状态改变时刷新
function PlayerBestRing.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local MakeIndex = data.MakeIndex
    local itemData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local dePos = GUIShare.GetDeEquipMappingConfig(pos)
    pos = dePos and dePos or pos

    local equipPanel = PlayerBestRing.GetPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state > 0
    equipPanel._movingState = not state

    local itemNode = GUI:getChildByName(equipPanel, "Node")
    GUI:removeAllChildren(itemNode)

    local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    PlayerBestRing.CreateEquipItem(itemNode, equipData)

    PlayerBestRing.SetIconVisible(equipPanel, false)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function PlayerBestRing.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera
    local MakeIndex = data.MakeIndex

    local pos = data.Where
    local dePos = GUIShare.GetDeEquipMappingConfig(pos)
    pos = dePos and dePos or pos

    local equipPanel = PlayerBestRing.GetPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local itemNode = GUI:getChildByName(equipPanel, "Node")

    local iconVisible = false

    if GUIShare.Operator_Add == optType then
        GUI:removeAllChildren(itemNode)

        local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
        PlayerBestRing.CreateEquipItem(itemNode, equipData)
    elseif GUIShare.Operator_Sub == optType then
        GUI:removeAllChildren(itemNode)

        iconVisible = true
    elseif GUIShare.Operator_Change == optType then
        local itemShow = GUI:getChildByTag(itemNode, MakeIndex)
        if GUI:Win_IsNull(itemShow) then
            return false  
        end
        local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
        GUI:ItemShow_OnRunFunc(itemShow, "UpdateGoodsItem", equipData)
    end

    PlayerBestRing.SetIconVisible(equipPanel, iconVisible)
end

function PlayerBestRing.RegisterMouseEvent()
    local getItemBagEmptyPos = function (touchPos)
        local x = touchPos.x
        local y = touchPos.y
        local pWorldPos = GUI:getWorldPosition(PlayerBestRing._ui["PanelTouch"])

        local posXInPanel = x - pWorldPos.x
        local posYInPanel = pWorldPos.y - y

        if posXInPanel >= TouchSize.width or posXInPanel <= 0 then
            return false
        end
    
        if posYInPanel >= TouchSize.height or posYInPanel <= 0 then
            return false
        end
        
        local nRect = GUI:Rect(0, 0, TouchSize.width, TouchSize.height)
        local iPos  = {x = posXInPanel, y = posYInPanel}
        for _,pos in ipairs(PlayerBestRing._EquipPosSet) do
            local itemNode = self:GetPanel(pos)
            if itemNode then
                local p = GUI:getPosition(itemNode)
                nRect.x = p.x - TouchSize.width / 2
                nRect.y = TouchSize.height - p.y - TouchSize.height / 2
                if iPos.x >= nRect.x and iPos.x <= nRect.x + nRect.width and iPos.y >= nRect.y and iPos.y <= nRect.y + nRect.height then
                    return pos
                end
            end
        end

        return nil
    end

    local addItemIntoEquip = function (touchPos)
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if not isMoving then
            return -1
        end
        
        local data = {}
        data.target = SL:GetItemGoto().BEST_RINGS
        data.pos = touchPos
        data.equipPos = getItemBagEmptyPos(touchPos)

        SL:OnItemDragEndDeal(data)
    end

    GUI:setSwallowTouches(PlayerBestRing._ui["PanelTouch"], false)

    -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
    GUI:addMouseButtonEvent(PlayerBestRing._ui["PanelTouch"], {OnSpecialRFunc = addItemIntoEquip})
end

function PlayerBestRing.GetEquipDataByPos(pos)
    return SL:GetMetaValue("M.EQUIP_DATA", pos, true)
end

-- 创建装备item
function PlayerBestRing.CreateEquipItem(parent, data)
    local info = {}

    info.showModelEffect = true
    info.from      = SL:GetItemForm().BEST_RINGS
    info.itemData  = data
    info.index     = data.Index
    local itemShow = GUI:ItemShow_Create(parent, "item", -30, -30, info)
    GUI:setTag(itemShow, data.MakeIndex)

    return itemShow
end


function PlayerBestRing.RefeshMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    PlayerBestRing.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function PlayerBestRing.UpdateEquipStateChange(state, pos)
    local itemNode = GUI:getChildByName(PlayerBestRing.GetPanel(pos), "Node")
    if itemNode then
        GUI:setVisible(itemNode, not state)
    end
end

function PlayerBestRing.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = SL:GetMetaValue("M.EQUIP_DATA", pos)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:OnTakeOffEquip({itemData = itemData, pos = itemData.Where})
end

function PlayerBestRing.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerBestRing.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerBestRing.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = SL:GetMetaValue("M.EQUIP_DATA_BY_POS", pos)
    if not itemData then
        return false
    end

    local data = {}
    data.itemData   = itemData
    data.pos        = GUI:getWorldPosition(widget)
    data.from       = SL:GetItemForm().BEST_RINGS
    data.lookPlayer = false

    SL:OpenItemTips(data)
end

-- 初始化点击（包含鼠标）事件
function PlayerBestRing.InitEquipLayerEvent()

    local InitPanel = function (widget, pos)
        widget._pos               = pos
        widget._itemFrom          = SL:GetItemForm().BEST_RINGS
        widget._GetEquipDataByPos = PlayerBestRing.GetEquipDataByPos
        widget._RefeshMoveState   = PlayerBestRing.RefeshMoveState
        widget._OnClickEvent      = PlayerBestRing.OnClickEvent
        widget._OnDoubleEvent     = PlayerBestRing.OnDoubleEvent
        GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)
        GUI:setTouchEnabled(widget, true)

        if SL:IsWinMode() then
            PlayerBestRing.OnRegisterMouseMoveEvent(widget, pos)
            
            -- 鼠标放在装备框上滚动事件
            SL:RegisterWndEvent(widget, "PlayerBestRing", WND_EVENT_MOUSE_WHEEL, function (data) 
                if ItemTips and ItemTips.OnMouseScroll then
                    ItemTips.OnMouseScroll(data)
                end
            end)
        end
    end

    for _,pos in ipairs(PlayerBestRing._EquipPosSet) do
        local widget = PlayerBestRing.GetPanel(pos)
        local iconVisible = true
        local data = PlayerBestRing.GetEquipDataByPos(pos)
        if data then
            PlayerBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            InitPanel(widget, pos)
            iconVisible = false
        end
        PlayerBestRing.SetIconVisible(widget, iconVisible)
    end
end

function PlayerBestRing.SetIconVisible(widget, visible)
    local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
    if DefaultIcon then
        GUI:setVisible(DefaultIcon, visible)
    end
    local itemNode = GUI:getChildByName(widget, "Node")
    if itemNode then
        GUI:setVisible(itemNode, not visible)
    end
end

-- 注册鼠标经过事件
function PlayerBestRing.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        PlayerBestRing.OnOpenItemTips(widget, pos)
    end

    local function onLeaveFunc() 
        SL:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end

function PlayerBestRing.GetPanel(pos)
    return PlayerBestRing._ui["PanelPos"..pos]
end