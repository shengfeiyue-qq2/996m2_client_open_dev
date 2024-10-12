LookHeroBestRing = {}

LookHeroBestRing._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookHeroBestRing.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.LookHeroBestRingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, isPC and "hero_look/hero_best_ring_box_win32" or "hero_look/hero_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    LookHeroBestRing._ui = ui
    
    LookHeroBestRing._EquipPosSet = EquipPosSet

    local PMainUI = LookHeroBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if isPC then
        GUI:setMouseEnabled(PMainUI, true)
    end

    GUI:Win_SetCloseCB(parent, LookHeroBestRing.OnClose)

    -- 关闭按钮
    GUI:addOnClickEvent(LookHeroBestRing._ui["CloseButton"], function ()
        UIOperator:CloseBestRingBoxUI(GUIDefine.RoleUIType.HERO_OTHER)
    end)

    -- 初始化装备事件
    LookHeroBestRing.InitEquipLayerEvent()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerBestRingO_hero})
end

function LookHeroBestRing.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerBestRingO_hero
    })
end

-- 创建装备item
function LookHeroBestRing.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from            = GUIDefine.ItemFrom.BEST_RINGS
    info.itemData        = data
    info.index           = data.Index
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function LookHeroBestRing.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookHeroBestRing.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookHeroBestRing.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not itemData then
        return false
    end

    local data = {}
    data.itemData   = itemData
    data.pos        = GUI:getWorldPosition(widget)
    data.from       = GUIDefine.ItemFrom.BEST_RINGS
    data.lookPlayer = true

    UIOperator:OpenItemTips(data)
end

-- 初始化点击（包含鼠标）事件
function LookHeroBestRing.InitEquipLayerEvent()
    local InitPanel = function (widget, pos)
        GUI:addOnTouchEvent(widget, function (sender, eventType) 
            LookHeroBestRing.OnClickEvent() 
        end)

        if isPC then
            GUIFunction:InitItemTipsScrollEvent(widget, "LookHeroBestRing")
            GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookHeroBestRing.OnOpenItemTips)
        end
    end

    for _,pos in ipairs(LookHeroBestRing._EquipPosSet) do
        local widget = LookHeroBestRing.GetPanel(pos)
        local iconVisible = true
        local data = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
        if data then
            LookHeroBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            iconVisible = false
        end
        InitPanel(widget, pos)
        LookHeroBestRing.SetIconVisible(widget, iconVisible)
    end
end

function LookHeroBestRing.SetIconVisible(widget, visible)
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
function LookHeroBestRing.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetValue("ITEM_MOVE_STATE")
        if isMoving then
            return false
        end
        LookHeroBestRing.OnOpenItemTips(widget, pos)
    end

    local function onLeaveFunc() 
        UIOperator:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end

function LookHeroBestRing.GetPanel(pos)
    return LookHeroBestRing._ui["PanelPos"..pos]
end

LookHeroBestRing.main()