LookPlayerSuperEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
LookPlayerSuperEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Super_Wing]     = {order = 3,  scale = 1, create = function () LookPlayerSuperEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Super_Dress]    = {order = 6,  scale = 1, create = function () LookPlayerSuperEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Super_Weapon]   = {order = 9,  scale = 1, create = function () LookPlayerSuperEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Super_Veil]     = {order = 13, scale = 1, create = function () LookPlayerSuperEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Super_Helmet]   = {order = 16, scale = 1, create = function () LookPlayerSuperEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Super_Cap]      = {order = 16, scale = 1, create = function () LookPlayerSuperEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Super_Shield]   = {order = 19, scale = 1, create = function () LookPlayerSuperEquip.CreateShield()   end}
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        LookPlayerSuperEquip._feature.clothID = data.ID
        LookPlayerSuperEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        LookPlayerSuperEquip._feature.weaponID = data.ID
        LookPlayerSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        LookPlayerSuperEquip._feature.headID = data.ID
        LookPlayerSuperEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        LookPlayerSuperEquip._feature.capID = data.ID
        LookPlayerSuperEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        LookPlayerSuperEquip._feature.shieldID = data.ID
        LookPlayerSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        LookPlayerSuperEquip._feature.veilID = data.ID
        LookPlayerSuperEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Wing] = function (data)
        LookPlayerSuperEquip._feature.wingsID = data.ID
        LookPlayerSuperEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

function LookPlayerSuperEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/player_super_equip_node")

    LookPlayerSuperEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerSuperEquip._ui then
        return false
    end
    LookPlayerSuperEquip._parent = parent

    -- 部位位置配置
    LookPlayerSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerSuperEquip._playerHairID = SL:GetMetaValue("L.HAIR")
    -- 性别
    LookPlayerSuperEquip._playerSex = SL:GetMetaValue("L.SEX")
    -- 职业
    LookPlayerSuperEquip._playerJob = SL:GetMetaValue("L.JOB")

    -- 额外装备位
    LookPlayerSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    LookPlayerSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    LookPlayerSuperEquip.InitEquipLayerEvent()

    -- 更新数据
    LookPlayerSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookPlayerSuperEquip.InitPlayerModel()
end

-- 初始化装备框装备
function LookPlayerSuperEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = LookPlayerSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isNaikan = LookPlayerSuperEquip.IsNaikan(pos)

        if itemNode and not isNaikan then
            -- 加载外观
            local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                LookPlayerSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookPlayerSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from       = SL:GetItemForm().PALYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function LookPlayerSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerSuperEquip.OnOpenItemTips(widget, pos)
end

function LookPlayerSuperEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookPlayerSuperEquip._EquipPosSet) do
        local widget = LookPlayerSuperEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                LookPlayerSuperEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "LookPlayerSuperEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().PALYER_EQUIP
            widget._GetEquipDataByPos  = LookPlayerSuperEquip.GetEquipDataByPos
            widget._OnClickEvent  = LookPlayerSuperEquip.OnClickEvent
            
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

            local Node = LookPlayerSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function LookPlayerSuperEquip.GetEquipPosPanel(pos)
    return LookPlayerSuperEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function LookPlayerSuperEquip.GetEquipPosNode(pos)
    return LookPlayerSuperEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function LookPlayerSuperEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerSuperEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = LookPlayerSuperEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Super_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookPlayerSuperEquip._feature.showNodeModel = false
        LookPlayerSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookPlayerSuperEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Super_Dress,  LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Helmet, LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Weapon, LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Cap,    LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Shield, LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Veil,   LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Wing,   LookPlayerSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Wing))

    LookPlayerSuperEquip._feature.hairID = LookPlayerSuperEquip._playerHairID
end

-- 额外的装备位置
function LookPlayerSuperEquip.InitEquipCells()
    local openFEquip = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(LookPlayerSuperEquip._EquipPosSet, 42)
        table.insert(LookPlayerSuperEquip._EquipPosSet, 44)

        local newPosSetting = {17, 18}
        for i,pos in ipairs(LookPlayerSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = LookPlayerSuperEquip.GetEquipPosPanel(pos)
                if equipPanel then
                    equipPanel:setVisible(false)
                end
            end
        end
        LookPlayerSuperEquip._EquipPosSet = {}
        LookPlayerSuperEquip._EquipPosSet = newPosSetting
        return false
    end

    local isExtraPos = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    local showExtra  = isExtraPos == 1
    if showExtra then
        table.insert(LookPlayerSuperEquip._EquipPosSet, 42)
        table.insert(LookPlayerSuperEquip._EquipPosSet, 44)
    else
        GUI:setVisible(LookPlayerSuperEquip._ui["PanelPos42"], false)
        GUI:setVisible(LookPlayerSuperEquip._ui["PanelPos44"], false)
        GUI:setVisible(LookPlayerSuperEquip._ui["Node42"], false)
        GUI:setVisible(LookPlayerSuperEquip._ui["Node44"], false)
    end

end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookPlayerSuperEquip.IsNaikan(pos) and SL:GetMetaValue("L.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("L.EQUIP_DATA_BY_POS", pos)}
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
    data.from = SL:GetItemForm().PALYER_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function LookPlayerSuperEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        LookPlayerSuperEquip.OnOpenItemTips(widget, pos)
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
function LookPlayerSuperEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(LookPlayerSuperEquip._EquipPosSet) do
            local widget = LookPlayerSuperEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "LookPlayerSuperEquip")
            end
        end

        if LookPlayerSuperEquip._scheduleID then
            SL:UnSchedule(LookPlayerSuperEquip._scheduleID)
            LookPlayerSuperEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerSuperEquip.CreateUIModel()
    local NodeModel = LookPlayerSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerSuperEquip._playerSex, LookPlayerSuperEquip._feature, nil)
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerSuperEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        LookPlayerSuperEquip.CreateNodeModel()
        LookPlayerSuperEquip.CreateSingleModelByType()
    else
        LookPlayerSuperEquip.CreateUIModel()
    end
end

-- 创建裸模
function LookPlayerSuperEquip.CreateNodeModel()
    local NodeModel = LookPlayerSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = LookPlayerSuperEquip._feature
    local feature = {
        hairID        = LookPlayerSuperEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, LookPlayerSuperEquip._playerSex, feature)
end

function LookPlayerSuperEquip.CreateSingleModelByType(type)
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

function LookPlayerSuperEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function LookPlayerSuperEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Super_Wing
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.wingsID, effectID = LookPlayerSuperEquip._feature.wingEffectID})
end


-- 创建衣服
function LookPlayerSuperEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Super_Dress
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.clothID, effectID = LookPlayerSuperEquip._feature.clothEffectID})
end

-- 创建武器
function LookPlayerSuperEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Super_Weapon
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.weaponID, effectID = LookPlayerSuperEquip._feature.weaponEffectID})
end

-- 创建盾牌
function LookPlayerSuperEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Super_Shield
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.shieldID, effectID = LookPlayerSuperEquip._feature.shieldEffectID})
end

-- 创建头盔
function LookPlayerSuperEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Super_Helmet
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.headID, effectID = LookPlayerSuperEquip._feature.headEffectID})
end

-- 创建面纱
function LookPlayerSuperEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Super_Veil
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.veilID, effectID = LookPlayerSuperEquip._feature.veilEffectID})
end

-- 创建斗笠
function LookPlayerSuperEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Super_Cap
    local node = LookPlayerSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerSuperEquip.CreateCommonModel(node, type, {ID = LookPlayerSuperEquip._feature.capID, effectID = LookPlayerSuperEquip._feature.capEffectID})
end