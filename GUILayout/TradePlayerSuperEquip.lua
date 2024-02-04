TradePlayerSuperEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
TradePlayerSuperEquip._feature = {
    clothID         = nil,      -- 衣服
    clothEffectID   = nil,
    weaponID        = nil,      -- 武器 
    weaponEffectID  = nil,
    headID          = nil,      -- 头盔
    headEffectID    = nil,
    hairID          = nil,      -- 头发
    capID           = nil,      -- 斗笠
    capEffectID     = nil,
    veilID          = nil,      -- 面纱
    veilEffectID    = nil,
    shieldID        = nil,      -- 盾牌
    shieldEffectID  = nil,
    wingsID         = nil,      -- 翅膀
    wingEffectID    = nil,

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local TypeCfg = {
    [_EquipPosCfg.Equip_Type_Super_Wing]     = {order = 3,  scale = 1, create = function () TradePlayerSuperEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Super_Dress]    = {order = 6,  scale = 1, create = function () TradePlayerSuperEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Super_Weapon]   = {order = 9,  scale = 1, create = function () TradePlayerSuperEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Super_Veil]     = {order = 13, scale = 1, create = function () TradePlayerSuperEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Super_Helmet]   = {order = 16, scale = 1, create = function () TradePlayerSuperEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Super_Cap]      = {order = 16, scale = 1, create = function () TradePlayerSuperEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Super_Shield]   = {order = 19, scale = 1, create = function () TradePlayerSuperEquip.CreateShield()   end}
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        TradePlayerSuperEquip._feature.clothID = data.ID
        TradePlayerSuperEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        TradePlayerSuperEquip._feature.weaponID = data.ID
        TradePlayerSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        TradePlayerSuperEquip._feature.headID = data.ID
        TradePlayerSuperEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        TradePlayerSuperEquip._feature.capID = data.ID
        TradePlayerSuperEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        TradePlayerSuperEquip._feature.shieldID = data.ID
        TradePlayerSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        TradePlayerSuperEquip._feature.veilID = data.ID
        TradePlayerSuperEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Wing] = function (data)
        TradePlayerSuperEquip._feature.wingsID = data.ID
        TradePlayerSuperEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

function TradePlayerSuperEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "trade_player/player_super_equip_node")

    TradePlayerSuperEquip._ui = GUI:ui_delegate(parent)
    if not TradePlayerSuperEquip._ui then
        return false
    end
    TradePlayerSuperEquip._parent = parent

    -- 部位位置配置
    TradePlayerSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    TradePlayerSuperEquip._playerHairID = SL:GetMetaValue("T.M.HAIR")
    -- 性别
    TradePlayerSuperEquip._playerSex = SL:GetMetaValue("T.M.SEX")
    -- 职业
    TradePlayerSuperEquip._playerJob = SL:GetMetaValue("T.M.JOB")

    -- 额外装备位
    TradePlayerSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    TradePlayerSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    TradePlayerSuperEquip.InitEquipLayerEvent()

    -- 更新数据
    TradePlayerSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    TradePlayerSuperEquip.InitPlayerModel()
end

-- 初始化装备框装备
function TradePlayerSuperEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = TradePlayerSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isNaikan = TradePlayerSuperEquip.IsNaikan(pos)

        if itemNode and not isNaikan then
            -- 加载外观
            local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                TradePlayerSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function TradePlayerSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from       = SL:GetItemForm().PALYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function TradePlayerSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    TradePlayerSuperEquip.OnOpenItemTips(widget, pos)
end

function TradePlayerSuperEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("T.M.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function TradePlayerSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(TradePlayerSuperEquip._EquipPosSet) do
        local widget = TradePlayerSuperEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                TradePlayerSuperEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "TradePlayerSuperEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().PALYER_EQUIP
            widget._GetEquipDataByPos  = TradePlayerSuperEquip.GetEquipDataByPos
            widget._OnClickEvent  = TradePlayerSuperEquip.OnClickEvent

            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)

            -- 斗笠、头盔内装备特殊处理
            local isNaikan = GUIShare.EquipNaikanShow and GUIShare.EquipNaikanShow[pos]
            GUI:setVisible(widget, true)
            local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
            if DefaultIcon then
                GUI:setVisible(DefaultIcon, not isNaikan)
            end

            local PanelBg = GUI:getChildByName(widget, "PanelBg")
            if PanelBg then
                GUI:setVisible(PanelBg, not isNaikan)
            end

            local Node = TradePlayerSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function TradePlayerSuperEquip.GetEquipPosPanel(pos)
    return TradePlayerSuperEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function TradePlayerSuperEquip.GetEquipPosNode(pos)
    return TradePlayerSuperEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function TradePlayerSuperEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerSuperEquip.GetLooks(equipPosData, equipPos, showNodeModel)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = TradePlayerSuperEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {
        showNodeModel = showNodeModel
    }

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Super_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        TradePlayerSuperEquip._feature.showNodeModel = false
        TradePlayerSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function TradePlayerSuperEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Super_Dress,  TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Helmet, TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Weapon, TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Cap,    TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Shield, TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Veil,   TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Wing,   TradePlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Wing))

    TradePlayerSuperEquip._feature.hairID = TradePlayerSuperEquip._playerHairID
end

-- 额外的装备位置
function TradePlayerSuperEquip.InitEquipCells()
    local openFEquip = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(TradePlayerSuperEquip._EquipPosSet, 42)
        table.insert(TradePlayerSuperEquip._EquipPosSet, 44)

        local newPosSetting = {17, 18}
        for i,pos in ipairs(TradePlayerSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = TradePlayerSuperEquip.GetEquipPosPanel(pos)
                if equipPanel then
                    equipPanel:setVisible(false)
                end
            end
        end
        TradePlayerSuperEquip._EquipPosSet = {}
        TradePlayerSuperEquip._EquipPosSet = newPosSetting
        return false
    end

    local isExtraPos = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    local showExtra  = isExtraPos == 1
    if showExtra then
        table.insert(TradePlayerSuperEquip._EquipPosSet, 42)
        table.insert(TradePlayerSuperEquip._EquipPosSet, 44)
    else
        GUI:setVisible(TradePlayerSuperEquip._ui["PanelPos42"], false)
        GUI:setVisible(TradePlayerSuperEquip._ui["PanelPos44"], false)
        GUI:setVisible(TradePlayerSuperEquip._ui["Node42"], false)
        GUI:setVisible(TradePlayerSuperEquip._ui["Node44"], false)
    end

end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function TradePlayerSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = TradePlayerSuperEquip.IsNaikan(pos) and SL:GetMetaValue("T.M.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("T.M.EQUIP_DATA_BY_POS", pos)}
    if not (itemData and next(itemData)) then
        return false
    end

    local data = {}
    data.itemData = itemData[1]
    data.pos = GUI:getWorldPosition(widget)
    if #itemData == 2 then
        data.itemData = itemData[2]
        data.itemData2 = itemData[1]
    elseif #itemData == 3 then
        data.itemData = itemData[3]
        data.itemData2 = itemData[2]
        data.itemData3 = itemData[1]
    end
    data.lookPlayer = false
    data.from = SL:GetItemForm().PALYER_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function TradePlayerSuperEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        TradePlayerSuperEquip.OnOpenItemTips(widget, pos)
    end

    local function onLeaveFunc() 
        SL:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end

-- 界面关闭回调
function TradePlayerSuperEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(TradePlayerSuperEquip._EquipPosSet) do
            local widget = TradePlayerSuperEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "TradePlayerSuperEquip")
            end
        end

        if TradePlayerSuperEquip._scheduleID then
            SL:UnSchedule(TradePlayerSuperEquip._scheduleID)
            TradePlayerSuperEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerSuperEquip.CreateUIModel()
    local NodeModel = TradePlayerSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, TradePlayerSuperEquip._playerSex, TradePlayerSuperEquip._feature, nil)
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerSuperEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        TradePlayerSuperEquip.CreateNodeModel()
        TradePlayerSuperEquip.CreateSingleModelByType()
    else
        TradePlayerSuperEquip.CreateUIModel()
    end
end

-- 创建裸模
function TradePlayerSuperEquip.CreateNodeModel()
    local NodeModel = TradePlayerSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = TradePlayerSuperEquip._feature
    local feature = {
        hairID        = TradePlayerSuperEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, TradePlayerSuperEquip._playerSex, feature)
end

function TradePlayerSuperEquip.CreateSingleModelByType(type)
    if type and TypeCfg[type] and TypeCfg[type].create then
        TypeCfg[type].create()
    else
        for k,v in pairs(TypeCfg) do
            if v and v.create then
                v.create()
            end
        end
    end
end

function TradePlayerSuperEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function TradePlayerSuperEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Super_Wing
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.wingsID, effectID = TradePlayerSuperEquip._feature.wingEffectID})
end

-- 创建衣服
function TradePlayerSuperEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Super_Dress
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.clothID, effectID = TradePlayerSuperEquip._feature.clothEffectID})
end

-- 创建武器
function TradePlayerSuperEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Super_Weapon
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.weaponID, effectID = TradePlayerSuperEquip._feature.weaponEffectID})
end

-- 创建盾牌
function TradePlayerSuperEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Super_Shield
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.shieldID, effectID = TradePlayerSuperEquip._feature.shieldEffectID})
end

-- 创建头盔
function TradePlayerSuperEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Super_Helmet
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.headID, effectID = TradePlayerSuperEquip._feature.headEffectID})
end

-- 创建面纱
function TradePlayerSuperEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Super_Veil
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.veilID, effectID = TradePlayerSuperEquip._feature.veilEffectID})
end

-- 创建斗笠
function TradePlayerSuperEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Super_Cap
    local node = TradePlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerSuperEquip._feature.capID, effectID = TradePlayerSuperEquip._feature.capEffectID})
end