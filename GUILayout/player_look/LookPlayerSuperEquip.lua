LookPlayerSuperEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
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

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        LookPlayerSuperEquip._feature.clothID = data.ID
        LookPlayerSuperEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        LookPlayerSuperEquip._feature.weaponID = data.ID
        LookPlayerSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        LookPlayerSuperEquip._feature.headID = data.ID
        LookPlayerSuperEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        LookPlayerSuperEquip._feature.capID = data.ID
        LookPlayerSuperEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        LookPlayerSuperEquip._feature.shieldID = data.ID
        LookPlayerSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        LookPlayerSuperEquip._feature.veilID = data.ID
        LookPlayerSuperEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

-- 斗笠和头盔是否在相同的位置
LookPlayerSuperEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_EQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookPlayerSuperEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player_look/player_super_equip_node_win32" or "player_look/player_super_equip_node")

    LookPlayerSuperEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerSuperEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    LookPlayerSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerSuperEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.PLAYER_OTHER)
    -- 性别
    LookPlayerSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER_OTHER)

    -- 额外装备位
    LookPlayerSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    LookPlayerSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    LookPlayerSuperEquip.InitEquipLayerEvent()

    LookPlayerSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookPlayerSuperEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = LookPlayerSuperEquip._ui["EquipUI"], index = SLDefine.SUIComponentTable.PlayerSuperEquipO})

    SL:AttachTXTSUI({root = LookPlayerSuperEquip._ui["BG"], index = SLDefine.SUIComponentTable.PlayerSuperEquipBO})

end

-- 剑甲分离
function LookPlayerSuperEquip.InitJJSplit()
    for pos, show in pairs(GUIDefine.EquipAllShow) do
        local p1 = LookPlayerSuperEquip.GetEquipPosExPanel(pos)
        local p2 = LookPlayerSuperEquip.GetEquipPosPanel(pos)
        if p1 and p2 then
            if show then
                GUI:setVisible(p1, false)
                GUI:setVisible(p2, true)
            else
                GUI:setVisible(p1, true)
                GUI:setVisible(p2, false)
            end
        end
    end
end

-- 初始化装备框装备
function LookPlayerSuperEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = LookPlayerSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookPlayerSuperEquip.IsShowAll(pos)
        local isNaikan = LookPlayerSuperEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                LookPlayerSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookPlayerSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not LookPlayerSuperEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.PLAYER_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = true
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function LookPlayerSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    LookPlayerSuperEquip.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerSuperEquip.InitEquipLayerEvent()
    for _, pos in ipairs(LookPlayerSuperEquip._EquipPosSet) do
        local widget = LookPlayerSuperEquip.GetEquipPosPanel(pos)
        if type(GUIDefine.EquipAllShow[pos]) == "boolean" then
            widget = GUIDefine.EquipAllShow[pos] and LookPlayerSuperEquip.GetEquipPosPanel(pos) or LookPlayerSuperEquip.GetEquipPosExPanel(pos)
        end

        if widget and GUI:getVisible(widget) then
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function() LookPlayerSuperEquip.OnClickEvent(widget, pos) end)

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "LookPlayerSuperEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookPlayerSuperEquip.OnOpenItemTips)
            end

        end
    end
    LookPlayerSuperEquip.SetSamePosEquip()
end

function LookPlayerSuperEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not LookPlayerSuperEquip._SamePos then
        return false
    end

    for belongPos, v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = LookPlayerSuperEquip.GetEquipPosPanel(pos)
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
function LookPlayerSuperEquip.GetEquipPosPanel(pos)
    return LookPlayerSuperEquip._ui["Panel_pos"..pos]
end

function LookPlayerSuperEquip.GetEquipPosExPanel(pos)
    return LookPlayerSuperEquip._ui["Panel_posEx"..pos]
end

-- 装备位置节点
function LookPlayerSuperEquip.GetEquipPosNode(pos)
    return LookPlayerSuperEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function LookPlayerSuperEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookPlayerSuperEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerSuperEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = LookPlayerSuperEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    if pos == EquipPosCfg.Equip_Type_Super_Dress and equipData and LookPlayerSuperEquip._feature.showNodeModel and equipData.zblmtkz and tonumber(equipData.zblmtkz) == 1 then -- zblmtkz == 1 不显示裸模, 表配置字段
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

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    LookPlayerSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1
    LookPlayerSuperEquip._feature.showHair = LookPlayerSuperEquip._feature.showNodeModel

    SetFeature(EquipPosCfg.Equip_Type_Super_Dress,  LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Super_Helmet, LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Super_Weapon, LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Super_Cap,    LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Super_Shield, LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Super_Veil,   LookPlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Veil))

    LookPlayerSuperEquip._feature.hairID = LookPlayerSuperEquip._hairID

end

-- 额外的装备位置
function LookPlayerSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(LookPlayerSuperEquip._EquipPosSet, 42)
        table.insert(LookPlayerSuperEquip._EquipPosSet, 44)

        for i, pos in ipairs(LookPlayerSuperEquip._EquipPosSet) do
            local equipPanel = LookPlayerSuperEquip._ui["Panel_pos" .. pos]
            if equipPanel then 
                GUI:setVisible(equipPanel, false)
            end
        end
        LookPlayerSuperEquip._EquipPosSet = {17, 18}
    else
        -- 额外的装备位置 1是6格 0是4格
        local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
        if showExtra then
            table.insert(LookPlayerSuperEquip._EquipPosSet, 42)
            table.insert(LookPlayerSuperEquip._EquipPosSet, 44)
        else
            GUI:setVisible(LookPlayerSuperEquip._ui["Panel_pos42"], false)
            GUI:setVisible(LookPlayerSuperEquip._ui["Panel_pos44"], false)
        end
    end

    LookPlayerSuperEquip.InitJJSplit()

    if SL:GetValue("GAME_DATA", "isSeparateSuperHelmetAndCap") == 1 then
        LookPlayerSuperEquip._SamePos = false
    else
        LookPlayerSuperEquip._SamePos = true
    end
end

-- 装备为内观且使用相同位置时显示同部位多件装备tips，否则显示单件
function LookPlayerSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = (LookPlayerSuperEquip.IsNaikan(pos) and LookPlayerSuperEquip._SamePos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.PLAYER_EQUIP

    UIOperator:OpenItemTips(data)
end

-- 界面关闭回调
function LookPlayerSuperEquip.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquipO
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquipBO
    })
end

function LookPlayerSuperEquip.CreateUIModel()
    local NodeModel = LookPlayerSuperEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerSuperEquip._sex, LookPlayerSuperEquip._feature, nil, true, SL:GetValue("L.M.JOB"))
end

LookPlayerSuperEquip.main()