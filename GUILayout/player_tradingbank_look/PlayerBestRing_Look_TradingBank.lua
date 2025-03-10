PlayerBestRing_Look_TradingBank = {}

PlayerBestRing_Look_TradingBank._ui = nil

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.TRADE_EQUIP

function PlayerBestRing_Look_TradingBank.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.TradingBankBestRingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent,  "player_look_tradingbank/player_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    PlayerBestRing_Look_TradingBank._ui = ui
    
    PlayerBestRing_Look_TradingBank._EquipPosSet = EquipPosSet

    local PMainUI = PlayerBestRing_Look_TradingBank._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    -- 关闭按钮
    GUI:addOnClickEvent(PlayerBestRing_Look_TradingBank._ui["CloseButton"], function ()
        UIOperator:CloseBestRingBoxUI(GUIDefine.RoleUIType.TRADE_PLAYER)
    end)

    -- 初始化装备事件
    PlayerBestRing_Look_TradingBank.InitEquipLayerEvent()
end

-- 创建装备item
function PlayerBestRing_Look_TradingBank.CreateEquipItem(parent, data)
    local info = {}

    info.showModelEffect = true
    info.from      = GUIDefine.ItemFrom.BEST_RINGS
    info.itemData  = data
    info.index     = data.Index
    
    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function PlayerBestRing_Look_TradingBank.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    PlayerBestRing_Look_TradingBank.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerBestRing_Look_TradingBank.OnOpenItemTips(widget, pos)
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
    data.lookPlayer = false

    UIOperator:OpenItemTips(data)
end

-- 初始化点击（包含鼠标）事件
function PlayerBestRing_Look_TradingBank.InitEquipLayerEvent()
    for _, pos in ipairs(PlayerBestRing_Look_TradingBank._EquipPosSet) do
        local widget = PlayerBestRing_Look_TradingBank.GetPanel(pos)
        local iconVisible = true
        local data =  GUIFunction:GetEquipDataByPos(pos, nil, EDType)
        if data then
            PlayerBestRing_Look_TradingBank.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            GUI:addOnTouchEvent(widget, function() 
                PlayerBestRing_Look_TradingBank.OnClickEvent(widget, pos) 
            end)
            iconVisible = false
        end
        PlayerBestRing_Look_TradingBank.SetIconVisible(widget, iconVisible)
    end
end

function PlayerBestRing_Look_TradingBank.SetIconVisible(widget, visible)
    local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
    if DefaultIcon then
        GUI:setVisible(DefaultIcon, visible)
    end
    local itemNode = GUI:getChildByName(widget, "Node")
    if itemNode then
        GUI:setVisible(itemNode, not visible)
    end
end

function PlayerBestRing_Look_TradingBank.GetPanel(pos)
    return PlayerBestRing_Look_TradingBank._ui["PanelPos"..pos]
end

function PlayerBestRing_Look_TradingBank.OnClose()
end

PlayerBestRing_Look_TradingBank.main()