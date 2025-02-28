HeroBestRing_Look_TradingBank = {}

HeroBestRing_Look_TradingBank._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.TRADE_HEROEQUIP

function HeroBestRing_Look_TradingBank.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.TradingBankHeroBestRingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent,  "hero_look_tradingbank/hero_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    HeroBestRing_Look_TradingBank._ui = ui
    
    HeroBestRing_Look_TradingBank._EquipPosSet = EquipPosSet

    local PMainUI = HeroBestRing_Look_TradingBank._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    -- 关闭按钮
    GUI:addOnClickEvent(HeroBestRing_Look_TradingBank._ui["CloseButton"], function ()
        UIOperator:CloseBestRingBoxUI(GUIDefine.RoleUIType.TRADE_HERO)
    end)

    -- 初始化装备事件
    HeroBestRing_Look_TradingBank.InitEquipLayerEvent()
end

-- 创建装备item
function HeroBestRing_Look_TradingBank.CreateEquipItem(parent, data)
    local info = {}

    info.showModelEffect = true
    info.from      = GUIDefine.ItemFrom.HERO_BEST_RINGS
    info.itemData  = data
    info.index     = data.Index
    
    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function HeroBestRing_Look_TradingBank.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    HeroBestRing_Look_TradingBank.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function HeroBestRing_Look_TradingBank.OnOpenItemTips(widget, pos)
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
    data.from       = GUIDefine.ItemFrom.HERO_BEST_RINGS
    data.lookPlayer = false

    UIOperator:OpenItemTips(data)
end

-- 初始化点击（包含鼠标）事件
function HeroBestRing_Look_TradingBank.InitEquipLayerEvent()
    local InitPanel = function (widget, pos)
        GUI:addOnTouchEvent(widget, function (sender, eventType) 
            HeroBestRing_Look_TradingBank.OnClickEvent() 
        end)
    end

    for _,pos in ipairs(HeroBestRing_Look_TradingBank._EquipPosSet) do
        local widget = HeroBestRing_Look_TradingBank.GetPanel(pos)
        local iconVisible = true
        local data =  GUIFunction:GetEquipDataByPos(pos, nil, EDType)
        if data then
            HeroBestRing_Look_TradingBank.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            InitPanel(widget, pos)
            iconVisible = false
        end
        HeroBestRing_Look_TradingBank.SetIconVisible(widget, iconVisible)
    end
end

function HeroBestRing_Look_TradingBank.SetIconVisible(widget, visible)
    local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
    if DefaultIcon then
        GUI:setVisible(DefaultIcon, visible)
    end
    local itemNode = GUI:getChildByName(widget, "Node")
    if itemNode then
        GUI:setVisible(itemNode, not visible)
    end
end

function HeroBestRing_Look_TradingBank.GetPanel(pos)
    return HeroBestRing_Look_TradingBank._ui["PanelPos"..pos]
end

function HeroBestRing_Look_TradingBank.OnClose()
end

HeroBestRing_Look_TradingBank.main()