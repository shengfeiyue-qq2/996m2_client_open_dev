TradePlayerHeroSuperEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
TradePlayerHeroSuperEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Super_Wing]     = {order = 3,  scale = 1, create = function () TradePlayerHeroSuperEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Super_Dress]    = {order = 6,  scale = 1, create = function () TradePlayerHeroSuperEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Super_Weapon]   = {order = 9,  scale = 1, create = function () TradePlayerHeroSuperEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Super_Veil]     = {order = 13, scale = 1, create = function () TradePlayerHeroSuperEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Super_Helmet]   = {order = 16, scale = 1, create = function () TradePlayerHeroSuperEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Super_Cap]      = {order = 16, scale = 1, create = function () TradePlayerHeroSuperEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Super_Shield]   = {order = 19, scale = 1, create = function () TradePlayerHeroSuperEquip.CreateShield()   end}
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        TradePlayerHeroSuperEquip._feature.clothID = data.ID
        TradePlayerHeroSuperEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        TradePlayerHeroSuperEquip._feature.weaponID = data.ID
        TradePlayerHeroSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        TradePlayerHeroSuperEquip._feature.headID = data.ID
        TradePlayerHeroSuperEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        TradePlayerHeroSuperEquip._feature.capID = data.ID
        TradePlayerHeroSuperEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        TradePlayerHeroSuperEquip._feature.shieldID = data.ID
        TradePlayerHeroSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        TradePlayerHeroSuperEquip._feature.veilID = data.ID
        TradePlayerHeroSuperEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Wing] = function (data)
        TradePlayerHeroSuperEquip._feature.wingsID = data.ID
        TradePlayerHeroSuperEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

function TradePlayerHeroSuperEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "trade_player/hero_super_equip_node")

    TradePlayerHeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not TradePlayerHeroSuperEquip._ui then
        return false
    end
    TradePlayerHeroSuperEquip._parent = parent

    -- 部位位置配置
    TradePlayerHeroSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    TradePlayerHeroSuperEquip._playerHairID = SL:GetMetaValue("T.M.HAIR")
    -- 性别
    TradePlayerHeroSuperEquip._playerSex = SL:GetMetaValue("T.M.SEX")
    -- 职业
    TradePlayerHeroSuperEquip._playerJob = SL:GetMetaValue("T.M.JOB")

    -- 额外装备位
    TradePlayerHeroSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    TradePlayerHeroSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    TradePlayerHeroSuperEquip.InitEquipLayerEvent()

    -- 更新数据
    TradePlayerHeroSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    TradePlayerHeroSuperEquip.InitPlayerModel()
end

-- 初始化装备框装备
function TradePlayerHeroSuperEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = TradePlayerHeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isNaikan = TradePlayerHeroSuperEquip.IsNaikan(pos)

        if itemNode and not isNaikan then
            -- 加载外观
            local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                TradePlayerHeroSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function TradePlayerHeroSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function TradePlayerHeroSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    TradePlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
end

function TradePlayerHeroSuperEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("T.M.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function TradePlayerHeroSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(TradePlayerHeroSuperEquip._EquipPosSet) do
        local widget = TradePlayerHeroSuperEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                TradePlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "TradePlayerHeroSuperEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = TradePlayerHeroSuperEquip.GetEquipDataByPos
            widget._OnClickEvent  = TradePlayerHeroSuperEquip.OnClickEvent

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

            local Node = TradePlayerHeroSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function TradePlayerHeroSuperEquip.GetEquipPosPanel(pos)
    return TradePlayerHeroSuperEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function TradePlayerHeroSuperEquip.GetEquipPosNode(pos)
    return TradePlayerHeroSuperEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function TradePlayerHeroSuperEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroSuperEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = TradePlayerHeroSuperEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Super_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        TradePlayerHeroSuperEquip._feature.showNodeModel = false
        TradePlayerHeroSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function TradePlayerHeroSuperEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Super_Dress,  TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Helmet, TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Weapon, TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Cap,    TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Shield, TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Veil,   TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Wing,   TradePlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Wing))

    TradePlayerHeroSuperEquip._feature.hairID = TradePlayerHeroSuperEquip._playerHairID
end

-- 额外的装备位置
function TradePlayerHeroSuperEquip.InitEquipCells()
    local openFEquip = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(TradePlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(TradePlayerHeroSuperEquip._EquipPosSet, 44)

        local newPosSetting = {17, 18}
        for i,pos in ipairs(TradePlayerHeroSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = TradePlayerHeroSuperEquip.GetEquipPosPanel(pos)
                if equipPanel then
                    equipPanel:setVisible(false)
                end
            end
        end
        TradePlayerHeroSuperEquip._EquipPosSet = {}
        TradePlayerHeroSuperEquip._EquipPosSet = newPosSetting
        return false
    end

    local isExtraPos = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    local showExtra  = isExtraPos == 1
    if showExtra then
        table.insert(TradePlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(TradePlayerHeroSuperEquip._EquipPosSet, 44)
    else
        GUI:setVisible(TradePlayerHeroSuperEquip._ui["PanelPos42"], false)
        GUI:setVisible(TradePlayerHeroSuperEquip._ui["PanelPos44"], false)
        GUI:setVisible(TradePlayerHeroSuperEquip._ui["Node42"], false)
        GUI:setVisible(TradePlayerHeroSuperEquip._ui["Node44"], false)
    end

end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function TradePlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = TradePlayerHeroSuperEquip.IsNaikan(pos) and SL:GetMetaValue("T.M.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("T.M.EQUIP_DATA_BY_POS", pos)}
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
    data.from = SL:GetItemForm().HERO_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function TradePlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        TradePlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
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
function TradePlayerHeroSuperEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(TradePlayerHeroSuperEquip._EquipPosSet) do
            local widget = TradePlayerHeroSuperEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "TradePlayerHeroSuperEquip")
            end
        end

        if TradePlayerHeroSuperEquip._scheduleID then
            SL:UnSchedule(TradePlayerHeroSuperEquip._scheduleID)
            TradePlayerHeroSuperEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroSuperEquip.CreateUIModel()
    local NodeModel = TradePlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, TradePlayerHeroSuperEquip._playerSex, TradePlayerHeroSuperEquip._feature, nil)
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroSuperEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        TradePlayerHeroSuperEquip.CreateNodeModel()
        TradePlayerHeroSuperEquip.CreateSingleModelByType()
    else
        TradePlayerHeroSuperEquip.CreateUIModel()
    end
end

-- 创建裸模
function TradePlayerHeroSuperEquip.CreateNodeModel()
    local NodeModel = TradePlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = TradePlayerHeroSuperEquip._feature
    local feature = {
        hairID        = TradePlayerHeroSuperEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, TradePlayerHeroSuperEquip._playerSex, feature)
end

function TradePlayerHeroSuperEquip.CreateSingleModelByType(type)
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

function TradePlayerHeroSuperEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function TradePlayerHeroSuperEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Super_Wing
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.wingsID, effectID = TradePlayerHeroSuperEquip._feature.wingEffectID})
end

-- 创建衣服
function TradePlayerHeroSuperEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Super_Dress
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.clothID, effectID = TradePlayerHeroSuperEquip._feature.clothEffectID})
end

-- 创建武器
function TradePlayerHeroSuperEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Super_Weapon
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.weaponID, effectID = TradePlayerHeroSuperEquip._feature.weaponEffectID})
end

-- 创建盾牌
function TradePlayerHeroSuperEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Super_Shield
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.shieldID, effectID = TradePlayerHeroSuperEquip._feature.shieldEffectID})
end

-- 创建头盔
function TradePlayerHeroSuperEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Super_Helmet
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.headID, effectID = TradePlayerHeroSuperEquip._feature.headEffectID})
end

-- 创建面纱
function TradePlayerHeroSuperEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Super_Veil
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.veilID, effectID = TradePlayerHeroSuperEquip._feature.veilEffectID})
end

-- 创建斗笠
function TradePlayerHeroSuperEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Super_Cap
    local node = TradePlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroSuperEquip._feature.capID, effectID = TradePlayerHeroSuperEquip._feature.capEffectID})
end