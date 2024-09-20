LookHeroSuperEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
LookHeroSuperEquip._feature = {
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
        LookHeroSuperEquip._feature.clothID = data.ID
        LookHeroSuperEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        LookHeroSuperEquip._feature.weaponID = data.ID
        LookHeroSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        LookHeroSuperEquip._feature.headID = data.ID
        LookHeroSuperEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        LookHeroSuperEquip._feature.capID = data.ID
        LookHeroSuperEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        LookHeroSuperEquip._feature.shieldID = data.ID
        LookHeroSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        LookHeroSuperEquip._feature.veilID = data.ID
        LookHeroSuperEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

-- 斗笠和头盔是否在相同的位置
LookHeroSuperEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookHeroSuperEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero_look/hero_super_equip_node_win32" or "hero_look/hero_super_equip_node")

    LookHeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not LookHeroSuperEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    LookHeroSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookHeroSuperEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.HERO_OTHER)
    -- 性别
    LookHeroSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.HERO_OTHER)

    -- 额外装备位
    LookHeroSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    LookHeroSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    LookHeroSuperEquip.InitEquipLayerEvent()

    LookHeroSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookHeroSuperEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerSuperEquipO_hero})
end

-- 初始化装备框装备
function LookHeroSuperEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = LookHeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookHeroSuperEquip.IsShowAll(pos)
        local isNaikan = LookHeroSuperEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                LookHeroSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookHeroSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not LookHeroSuperEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = true
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function LookHeroSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    LookHeroSuperEquip.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function LookHeroSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookHeroSuperEquip._EquipPosSet) do
        local widget = LookHeroSuperEquip.GetEquipPosPanel(pos)
        if widget then
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) LookHeroSuperEquip.OnClickEvent() end)

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "LookHeroSuperEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookHeroSuperEquip.OnOpenItemTips)
            end

            -- 斗笠、头盔内装备特殊处理
            local isNaikan = GUIDefine.EquipNaikanShow and GUIDefine.EquipNaikanShow[pos]
            GUI:setVisible(widget, true)
            local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
            if DefaultIcon then
                GUI:setVisible(DefaultIcon, not isNaikan)
            end

            local PanelBg = GUI:getChildByName(widget, "PanelBg")
            if PanelBg then
                GUI:setVisible(PanelBg, not isNaikan)
            end

            local Node = LookHeroSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    LookHeroSuperEquip.SetSamePosEquip()
end

function LookHeroSuperEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not LookHeroSuperEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = LookHeroSuperEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and GUIFunction:GetEquipDataByPos(pos, nil, EDType) then
                    GUI:setVisible(equipPanel, true)
                    Is = true
                else
                    GUI:setVisible(equipPanel, false)
                end
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function LookHeroSuperEquip.GetEquipPosPanel(pos)
    return LookHeroSuperEquip._ui["Panel_pos"..pos]
end

-- 装备位置节点
function LookHeroSuperEquip.GetEquipPosNode(pos)
    return LookHeroSuperEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function LookHeroSuperEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookHeroSuperEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookHeroSuperEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = LookHeroSuperEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    if pos == EquipPosCfg.Equip_Type_Super_Dress and equipData and LookHeroSuperEquip._feature.showNodeModel and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookHeroSuperEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Super_Cap and equipData.AniCount == 0 then
        LookHeroSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookHeroSuperEquip.UpdateModelFeatureData()
    LookHeroSuperEquip._feature = {
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

    LookHeroSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1

    SetFeature(EquipPosCfg.Equip_Type_Super_Dress,  LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Super_Helmet, LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Super_Weapon, LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Super_Cap,    LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Super_Shield, LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Super_Veil,   LookHeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Veil))

    LookHeroSuperEquip._feature.hairID = LookHeroSuperEquip._hairID

    dump(LookHeroSuperEquip._feature, "--LookHeroSuperEquip._feature-----")
end

-- 额外的装备位置
function LookHeroSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(LookHeroSuperEquip._EquipPosSet, 14)
        table.insert(LookHeroSuperEquip._EquipPosSet, 15)
        local newPosSetting = {17, 18}

        for i, pos in ipairs(LookHeroSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = LookHeroSuperEquip._ui["Panel_pos" .. pos]
                if equipPanel then 
                    GUI:setVisible(equipPanel, false)
                end 
            end
        end
        LookHeroSuperEquip._EquipPosSet = {}
        LookHeroSuperEquip._EquipPosSet = newPosSetting
    else
        -- 额外的装备位置 1是6格 0是4格
        local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
        if showExtra then
            table.insert(LookHeroSuperEquip._EquipPosSet, 42)
            table.insert(LookHeroSuperEquip._EquipPosSet, 44)
        else
            GUI:setVisible(LookHeroSuperEquip._ui["Panel_pos42"], false)
            GUI:setVisible(LookHeroSuperEquip._ui["Panel_pos44"], false)
        end
    end
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookHeroSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookHeroSuperEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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

-- 界面关闭回调
function LookHeroSuperEquip.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquipO_hero
    })
end

function LookHeroSuperEquip.CreateUIModel()
    local NodeModel = LookHeroSuperEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookHeroSuperEquip._sex, LookHeroSuperEquip._feature, nil, {showHelmet = LookHeroSuperEquip._feature.showHair})
end

LookHeroSuperEquip.main()