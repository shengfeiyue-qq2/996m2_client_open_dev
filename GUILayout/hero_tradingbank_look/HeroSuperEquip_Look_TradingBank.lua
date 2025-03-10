HeroSuperEquip_Look_TradingBank = {}

local EquipPosCfg = GUIDefine.EquipPosUI
HeroSuperEquip_Look_TradingBank._feature = {
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

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.clothID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.weaponID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.headID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.capID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.shieldID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        HeroSuperEquip_Look_TradingBank._feature.veilID = data.ID
        HeroSuperEquip_Look_TradingBank._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

-- 斗笠和头盔是否在相同的位置
HeroSuperEquip_Look_TradingBank._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.TRADE_HEROEQUIP

function HeroSuperEquip_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_super_equip_node")

    HeroSuperEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroSuperEquip_Look_TradingBank._ui then
        return false
    end

    HeroSuperEquip_Look_TradingBank._EquipPosSet = EquipPosSet

    -- 发型
    HeroSuperEquip_Look_TradingBank._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.TRADE_HERO)
    -- 性别
    HeroSuperEquip_Look_TradingBank._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.TRADE_HERO)
    -- 职业
    HeroSuperEquip_Look_TradingBank._job = GUIFunction:GetRoleJob(GUIDefine.RoleUIType.TRADE_HERO)

    -- 额外装备位
    HeroSuperEquip_Look_TradingBank.InitEquipCells()

    -- 初始化装备框装备
    HeroSuperEquip_Look_TradingBank.InitEquipLayer()

    -- 初始化装备事件
    HeroSuperEquip_Look_TradingBank.InitEquipLayerEvent()

    HeroSuperEquip_Look_TradingBank.UpdateModelFeatureData()

    -- 初始化装备内观
    HeroSuperEquip_Look_TradingBank.CreateUIModel()
end

-- 初始化装备框装备
function HeroSuperEquip_Look_TradingBank.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = HeroSuperEquip_Look_TradingBank.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = HeroSuperEquip_Look_TradingBank.IsShowAll(pos)
        local isNaikan = HeroSuperEquip_Look_TradingBank.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                HeroSuperEquip_Look_TradingBank.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function HeroSuperEquip_Look_TradingBank.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not HeroSuperEquip_Look_TradingBank.IsShowAll(data.Where)
    info.from       = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function HeroSuperEquip_Look_TradingBank.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    HeroSuperEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function HeroSuperEquip_Look_TradingBank.InitEquipLayerEvent()
    for _, pos in ipairs(HeroSuperEquip_Look_TradingBank._EquipPosSet) do
        local widget = HeroSuperEquip_Look_TradingBank.GetEquipPosPanel(pos)
        if widget and GUI:getVisible(widget) then
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function() HeroSuperEquip_Look_TradingBank.OnClickEvent(widget, pos) end)
        end
    end
    HeroSuperEquip_Look_TradingBank.SetSamePosEquip()
end

function HeroSuperEquip_Look_TradingBank.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not HeroSuperEquip_Look_TradingBank._SamePos then
        return false
    end
    
    for belongPos, v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = HeroSuperEquip_Look_TradingBank.GetEquipPosPanel(pos)
            if equipPanel then
                if GUIFunction:GetEquipDataByPos(pos, nil, EDType) then
                    GUI:setVisible(equipPanel, true)
                    GUI:setTouchEnabled(equipPanel, true)
                else
                    GUI:setVisible(equipPanel, false)
                end
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function HeroSuperEquip_Look_TradingBank.GetEquipPosPanel(pos)
    return HeroSuperEquip_Look_TradingBank._ui["Panel_pos"..pos]
end

-- 装备位置节点
function HeroSuperEquip_Look_TradingBank.GetEquipPosNode(pos)
    return HeroSuperEquip_Look_TradingBank._ui["Node_"..pos]
end

-- 该部位是否展示内观
function HeroSuperEquip_Look_TradingBank.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function HeroSuperEquip_Look_TradingBank.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function HeroSuperEquip_Look_TradingBank.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = HeroSuperEquip_Look_TradingBank.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    if pos == EquipPosCfg.Equip_Type_Super_Dress and equipData and HeroSuperEquip_Look_TradingBank._feature.showNodeModel and equipData.zblmtkz and tonumber(equipData.zblmtkz) == 1 then -- zblmtkz == 1 不显示裸模, 表配置字段
        HeroSuperEquip_Look_TradingBank._feature.showNodeModel = false
        HeroSuperEquip_Look_TradingBank._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function HeroSuperEquip_Look_TradingBank.UpdateModelFeatureData()
    HeroSuperEquip_Look_TradingBank._feature = {
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

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    HeroSuperEquip_Look_TradingBank._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1
    HeroSuperEquip_Look_TradingBank._feature.showHair = HeroSuperEquip_Look_TradingBank._feature.showNodeModel

    SetFeature(EquipPosCfg.Equip_Type_Super_Dress,  HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Super_Helmet, HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Super_Weapon, HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Super_Cap,    HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Super_Shield, HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Super_Veil,   HeroSuperEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Super_Veil))

    HeroSuperEquip_Look_TradingBank._feature.hairID = HeroSuperEquip_Look_TradingBank._hairID

end

-- 额外的装备位置
function HeroSuperEquip_Look_TradingBank.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(HeroSuperEquip_Look_TradingBank._EquipPosSet, 14)
        table.insert(HeroSuperEquip_Look_TradingBank._EquipPosSet, 15)
        local newPosSetting = {17, 18}

        for i, pos in ipairs(HeroSuperEquip_Look_TradingBank._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = HeroSuperEquip_Look_TradingBank._ui["Panel_pos" .. pos]
                if equipPanel then 
                    GUI:setVisible(equipPanel, false)
                end 
            end
        end
        HeroSuperEquip_Look_TradingBank._EquipPosSet = {}
        HeroSuperEquip_Look_TradingBank._EquipPosSet = newPosSetting
    else
        -- 额外的装备位置 1是6格 0是4格
        local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
        if showExtra then
            table.insert(HeroSuperEquip_Look_TradingBank._EquipPosSet, 42)
            table.insert(HeroSuperEquip_Look_TradingBank._EquipPosSet, 44)
        else
            GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui["Panel_pos42"], false)
            GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui["Panel_pos44"], false)
        end
    end

    if SL:GetValue("GAME_DATA", "isSeparateSuperHelmetAndCap") == 1 then
        HeroSuperEquip_Look_TradingBank._SamePos = false
    else
        HeroSuperEquip_Look_TradingBank._SamePos = true
    end
end

-- 装备为内观且使用相同位置时显示同部位多件装备tips，否则显示单件
function HeroSuperEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = (HeroSuperEquip_Look_TradingBank.IsNaikan(pos) and HeroSuperEquip_Look_TradingBank._SamePos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.HERO_EQUIP

    UIOperator:OpenItemTips(data)
end

function HeroSuperEquip_Look_TradingBank.CreateUIModel()
    local NodeModel = HeroSuperEquip_Look_TradingBank._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, HeroSuperEquip_Look_TradingBank._sex, HeroSuperEquip_Look_TradingBank._feature, nil, true, HeroSuperEquip_Look_TradingBank._job)
end

function HeroSuperEquip_Look_TradingBank.OnClose()
end

HeroSuperEquip_Look_TradingBank.main()