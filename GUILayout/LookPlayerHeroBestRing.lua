LookPlayerHeroBestRing = {}

LookPlayerHeroBestRing._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

function LookPlayerHeroBestRing.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/hero_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    LookPlayerHeroBestRing._ui = ui
    
    LookPlayerHeroBestRing._EquipPosSet = EquipPosSet

    local PMainUI = LookPlayerHeroBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(LookPlayerHeroBestRing._ui["CloseButton"], LookPlayerHeroBestRing.OnClose)

    -- 初始化装备事件
    LookPlayerHeroBestRing.InitEquipLayerEvent()
end

function LookPlayerHeroBestRing.OnClose()
    SL:CloseBestRingBoxUI(12)
end

function LookPlayerHeroBestRing.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos, true)
end

-- 创建装备item
function LookPlayerHeroBestRing.CreateEquipItem(parent, data)
    local info = {}

    info.showModelEffect = true
    info.from      = SL:GetItemForm().BEST_RINGS
    info.itemData  = data
    info.index     = data.Index
    local itemShow = GUI:ItemShow_Create(parent, "item", -30, -30, info)
    GUI:setTag(itemShow, data.MakeIndex)

    return itemShow
end

function LookPlayerHeroBestRing.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerHeroBestRing.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerHeroBestRing.OnOpenItemTips(widget, pos)
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
function LookPlayerHeroBestRing.InitEquipLayerEvent()

    local InitPanel = function (widget, pos)
        widget._pos               = pos
        widget._itemFrom          = SL:GetItemForm().BEST_RINGS
        widget._GetEquipDataByPos = LookPlayerHeroBestRing.GetEquipDataByPos
        widget._OnClickEvent      = LookPlayerHeroBestRing.OnClickEvent
        GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)
        GUI:setTouchEnabled(widget, true)

        if SL:IsWinMode() then
            LookPlayerHeroBestRing.OnRegisterMouseMoveEvent(widget, pos)
            
            -- 鼠标放在装备框上滚动事件
            SL:RegisterWndEvent(widget, "LookPlayerHeroBestRing", WND_EVENT_MOUSE_WHEEL, function (data) 
                if ItemTips and ItemTips.OnMouseScroll then
                    ItemTips.OnMouseScroll(data)
                end
            end)
        end
    end

    for _,pos in ipairs(LookPlayerHeroBestRing._EquipPosSet) do
        local widget = LookPlayerHeroBestRing.GetPanel(pos)
        local iconVisible = true
        local data = LookPlayerHeroBestRing.GetEquipDataByPos(pos)
        if data then
            LookPlayerHeroBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            InitPanel(widget, pos)
            iconVisible = false
        end
        LookPlayerHeroBestRing.SetIconVisible(widget, iconVisible)
    end
end

function LookPlayerHeroBestRing.SetIconVisible(widget, visible)
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
function LookPlayerHeroBestRing.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        LookPlayerHeroBestRing.OnOpenItemTips(widget, pos)
    end

    local function onLeaveFunc() 
        SL:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end

function LookPlayerHeroBestRing.GetPanel(pos)
    return LookPlayerHeroBestRing._ui["PanelPos"..pos]
end