LookPlayerBestRing = {}

LookPlayerBestRing._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_EQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookPlayerBestRing.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.LookPlayerBestRingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, isPC and "player_look/player_best_ring_box_win32" or "player_look/player_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    LookPlayerBestRing._ui = ui
    
    LookPlayerBestRing._EquipPosSet = EquipPosSet

    local PMainUI = LookPlayerBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if isPC then
        GUI:setMouseEnabled(PMainUI, true)
    end

    GUI:Win_SetCloseCB(parent, LookPlayerBestRing.OnClose)

    -- 关闭按钮
    GUI:addOnClickEvent(LookPlayerBestRing._ui["CloseButton"], function ()
        UIOperator:CloseBestRingBoxUI(GUIDefine.RoleUIType.PLAYER_OTHER)
    end)

    -- 初始化装备事件
    LookPlayerBestRing.InitEquipLayerEvent()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerBestRingO})
end

function LookPlayerBestRing.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerBestRingO
    })
end

-- 创建装备item
function LookPlayerBestRing.CreateEquipItem(parent, data)
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
function LookPlayerBestRing.InitEquipLayerEvent()
    local InitPanel = function (widget, pos)
        GUI:addOnTouchEvent(widget, function (sender, eventType) 
            LookPlayerBestRing.OnClickEvent(widget, pos) 
        end)

        if isPC then
            GUIFunction:InitItemTipsScrollEvent(widget, "LookPlayerBestRing")
            GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookPlayerBestRing.OnOpenItemTips)
        end
    end

    for _, pos in ipairs(LookPlayerBestRing._EquipPosSet) do
        local widget = LookPlayerBestRing.GetPanel(pos)
        local iconVisible = true
        local data = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
        if data then
            LookPlayerBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            iconVisible = false
        end
        InitPanel(widget, pos)
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

function LookPlayerBestRing.GetPanel(pos)
    return LookPlayerBestRing._ui["PanelPos"..pos]
end

LookPlayerBestRing.main()