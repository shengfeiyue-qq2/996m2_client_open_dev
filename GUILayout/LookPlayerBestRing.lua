LookPlayerBestRing = {}

LookPlayerBestRing._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

function LookPlayerBestRing.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/player_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    LookPlayerBestRing._ui = ui
    
    LookPlayerBestRing._EquipPosSet = EquipPosSet

    local PMainUI = LookPlayerBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(LookPlayerBestRing._ui["CloseButton"], LookPlayerBestRing.OnClose)

    -- 初始化装备事件
    LookPlayerBestRing.InitEquipLayerEvent()
end

function LookPlayerBestRing.OnClose()
    SL:CloseBestRingBoxUI(11)
end

function LookPlayerBestRing.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos, true)
end

-- 创建装备item
function LookPlayerBestRing.CreateEquipItem(parent, data)
    local info = {}

    info.showModelEffect = true
    info.from      = SL:GetItemForm().BEST_RINGS
    info.itemData  = data
    info.index     = data.Index
    local itemShow = GUI:ItemShow_Create(parent, "item", -30, -30, info)
    GUI:setTag(itemShow, data.MakeIndex)

    return itemShow
end

function LookPlayerBestRing.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerBestRing.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerBestRing.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = SL:GetMetaValue("L.EQUIP_DATA_BY_POS", pos)
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
function LookPlayerBestRing.InitEquipLayerEvent()

    local InitPanel = function (widget, pos)
        widget._pos               = pos
        widget._itemFrom          = SL:GetItemForm().BEST_RINGS
        widget._GetEquipDataByPos = LookPlayerBestRing.GetEquipDataByPos
        widget._OnClickEvent      = LookPlayerBestRing.OnClickEvent
        GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)
        GUI:setTouchEnabled(widget, true)

        if SL:IsWinMode() then
            LookPlayerBestRing.OnRegisterMouseMoveEvent(widget, pos)
            
            -- 鼠标放在装备框上滚动事件
            SL:RegisterWndEvent(widget, "LookPlayerBestRing", WND_EVENT_MOUSE_WHEEL, function (data) 
                if ItemTips and ItemTips.OnMouseScroll then
                    ItemTips.OnMouseScroll(data)
                end
            end)
        end
    end

    for _,pos in ipairs(LookPlayerBestRing._EquipPosSet) do
        local widget = LookPlayerBestRing.GetPanel(pos)
        local iconVisible = true
        local data = LookPlayerBestRing.GetEquipDataByPos(pos)
        if data then
            LookPlayerBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            InitPanel(widget, pos)
            iconVisible = false
        end
        LookPlayerBestRing.SetIconVisible(widget, iconVisible)
    end
end

function LookPlayerBestRing.SetIconVisible(widget, visible)
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
function LookPlayerBestRing.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        LookPlayerBestRing.OnOpenItemTips(widget, pos)
    end

    local function onLeaveFunc() 
        SL:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end

function LookPlayerBestRing.GetPanel(pos)
    return LookPlayerBestRing._ui["PanelPos"..pos]
end