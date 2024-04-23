LookPlayerHeroSuperEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
LookPlayerHeroSuperEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Super_Wing]     = {order = 3,  scale = 1, create = function () LookPlayerHeroSuperEquip.CreateWings()    end}, 
    [_EquipPosCfg.Equip_Type_Super_Dress]    = {order = 6,  scale = 1, create = function () LookPlayerHeroSuperEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Super_Weapon]   = {order = 9,  scale = 1, create = function () LookPlayerHeroSuperEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Super_Veil]     = {order = 13, scale = 1, create = function () LookPlayerHeroSuperEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Super_Helmet]   = {order = 16, scale = 1, create = function () LookPlayerHeroSuperEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Super_Cap]      = {order = 16, scale = 1, create = function () LookPlayerHeroSuperEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Super_Shield]   = {order = 19, scale = 1, create = function () LookPlayerHeroSuperEquip.CreateShield()   end}
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        LookPlayerHeroSuperEquip._feature.clothID = data.ID
        LookPlayerHeroSuperEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        LookPlayerHeroSuperEquip._feature.weaponID = data.ID
        LookPlayerHeroSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        LookPlayerHeroSuperEquip._feature.headID = data.ID
        LookPlayerHeroSuperEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        LookPlayerHeroSuperEquip._feature.capID = data.ID
        LookPlayerHeroSuperEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        LookPlayerHeroSuperEquip._feature.shieldID = data.ID
        LookPlayerHeroSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        LookPlayerHeroSuperEquip._feature.veilID = data.ID
        LookPlayerHeroSuperEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Wing] = function (data)
        LookPlayerHeroSuperEquip._feature.wingsID = data.ID
        LookPlayerHeroSuperEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

function LookPlayerHeroSuperEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/hero_super_equip_node")

    LookPlayerHeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerHeroSuperEquip._ui then
        return false
    end
    LookPlayerHeroSuperEquip._parent = parent

    -- 部位位置配置
    LookPlayerHeroSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerHeroSuperEquip._playerHairID = SL:GetMetaValue("L.HAIR")
    -- 性别
    LookPlayerHeroSuperEquip._playerSex = SL:GetMetaValue("L.SEX")
    -- 职业
    LookPlayerHeroSuperEquip._playerJob = SL:GetMetaValue("L.JOB")

    -- 额外装备位
    LookPlayerHeroSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    LookPlayerHeroSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    LookPlayerHeroSuperEquip.InitEquipLayerEvent()

    -- 更新数据
    LookPlayerHeroSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookPlayerHeroSuperEquip.InitPlayerModel()
end

-- 初始化装备框装备
function LookPlayerHeroSuperEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = LookPlayerHeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isNaikan = LookPlayerHeroSuperEquip.IsNaikan(pos)

        if itemNode and not isNaikan then
            -- 加载外观
            local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                LookPlayerHeroSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookPlayerHeroSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function LookPlayerHeroSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
end

function LookPlayerHeroSuperEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerHeroSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookPlayerHeroSuperEquip._EquipPosSet) do
        local widget = LookPlayerHeroSuperEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                LookPlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "LookPlayerHeroSuperEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = LookPlayerHeroSuperEquip.GetEquipDataByPos
            widget._OnClickEvent  = LookPlayerHeroSuperEquip.OnClickEvent
            
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

            local Node = LookPlayerHeroSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function LookPlayerHeroSuperEquip.GetEquipPosPanel(pos)
    return LookPlayerHeroSuperEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function LookPlayerHeroSuperEquip.GetEquipPosNode(pos)
    return LookPlayerHeroSuperEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function LookPlayerHeroSuperEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroSuperEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = LookPlayerHeroSuperEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Super_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookPlayerHeroSuperEquip._feature.showNodeModel = false
        LookPlayerHeroSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookPlayerHeroSuperEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Super_Dress,  LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Helmet, LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Weapon, LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Cap,    LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Shield, LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Veil,   LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Wing,   LookPlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Wing))

    LookPlayerHeroSuperEquip._feature.hairID = LookPlayerHeroSuperEquip._playerHairID
end

-- 额外的装备位置
function LookPlayerHeroSuperEquip.InitEquipCells()
    local openFEquip = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(LookPlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(LookPlayerHeroSuperEquip._EquipPosSet, 44)

        local newPosSetting = {17, 18}
        for i,pos in ipairs(LookPlayerHeroSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = LookPlayerHeroSuperEquip.GetEquipPosPanel(pos)
                if equipPanel then
                    equipPanel:setVisible(false)
                end
            end
        end
        LookPlayerHeroSuperEquip._EquipPosSet = {}
        LookPlayerHeroSuperEquip._EquipPosSet = newPosSetting
        return false
    end

    local isExtraPos = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    local showExtra  = isExtraPos == 1
    if showExtra then
        table.insert(LookPlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(LookPlayerHeroSuperEquip._EquipPosSet, 44)
    else
        GUI:setVisible(LookPlayerHeroSuperEquip._ui["PanelPos42"], false)
        GUI:setVisible(LookPlayerHeroSuperEquip._ui["PanelPos44"], false)
        GUI:setVisible(LookPlayerHeroSuperEquip._ui["Node42"], false)
        GUI:setVisible(LookPlayerHeroSuperEquip._ui["Node44"], false)
    end

end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookPlayerHeroSuperEquip.IsNaikan(pos) and SL:GetMetaValue("L.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("L.EQUIP_DATA_BY_POS", pos)}
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
    data.lookPlayer = true
    data.from = SL:GetItemForm().HERO_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function LookPlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        LookPlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
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
function LookPlayerHeroSuperEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(LookPlayerHeroSuperEquip._EquipPosSet) do
            local widget = LookPlayerHeroSuperEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "LookPlayerHeroSuperEquip")
            end
        end

        if LookPlayerHeroSuperEquip._scheduleID then
            SL:UnSchedule(LookPlayerHeroSuperEquip._scheduleID)
            LookPlayerHeroSuperEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroSuperEquip.CreateUIModel()
    local NodeModel = LookPlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerHeroSuperEquip._playerSex, LookPlayerHeroSuperEquip._feature, nil)
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroSuperEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        LookPlayerHeroSuperEquip.CreateNodeModel()
        LookPlayerHeroSuperEquip.CreateSingleModelByType()
    else
        LookPlayerHeroSuperEquip.CreateUIModel()
    end
end

-- 创建裸模
function LookPlayerHeroSuperEquip.CreateNodeModel()
    local NodeModel = LookPlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = LookPlayerHeroSuperEquip._feature
    local feature = {
        hairID        = LookPlayerHeroSuperEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, LookPlayerHeroSuperEquip._playerSex, feature)
end

function LookPlayerHeroSuperEquip.CreateSingleModelByType(type)
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

function LookPlayerHeroSuperEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function LookPlayerHeroSuperEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Super_Wing
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.wingsID, effectID = LookPlayerHeroSuperEquip._feature.wingEffectID})
end

-- 创建衣服
function LookPlayerHeroSuperEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Super_Dress
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.clothID, effectID = LookPlayerHeroSuperEquip._feature.clothEffectID})
end

-- 创建武器
function LookPlayerHeroSuperEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Super_Weapon
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.weaponID, effectID = LookPlayerHeroSuperEquip._feature.weaponEffectID})
end

-- 创建盾牌
function LookPlayerHeroSuperEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Super_Shield
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.shieldID, effectID = LookPlayerHeroSuperEquip._feature.shieldEffectID})
end

-- 创建头盔
function LookPlayerHeroSuperEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Super_Helmet
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.headID, effectID = LookPlayerHeroSuperEquip._feature.headEffectID})
end

-- 创建面纱
function LookPlayerHeroSuperEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Super_Veil
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.veilID, effectID = LookPlayerHeroSuperEquip._feature.veilEffectID})
end

-- 创建斗笠
function LookPlayerHeroSuperEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Super_Cap
    local node = LookPlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroSuperEquip._feature.capID, effectID = LookPlayerHeroSuperEquip._feature.capEffectID})
end