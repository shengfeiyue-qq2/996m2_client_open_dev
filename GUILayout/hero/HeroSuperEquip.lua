HeroSuperEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
HeroSuperEquip._feature = {
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
        HeroSuperEquip._feature.clothID = data.ID
        HeroSuperEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        HeroSuperEquip._feature.weaponID = data.ID
        HeroSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        HeroSuperEquip._feature.headID = data.ID
        HeroSuperEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        HeroSuperEquip._feature.capID = data.ID
        HeroSuperEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        HeroSuperEquip._feature.shieldID = data.ID
        HeroSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        HeroSuperEquip._feature.veilID = data.ID
        HeroSuperEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

-- 斗笠和头盔是否在相同的位置
HeroSuperEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function HeroSuperEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_super_equip_node_win32" or "hero/hero_super_equip_node")

    HeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not HeroSuperEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    HeroSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    HeroSuperEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.HERO)
    -- 性别
    HeroSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.HERO)

    -- 是否显示裸模 0开启  1关闭
    HeroSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1

    -- 注册事件
    HeroSuperEquip.RegistEvent()

    -- 额外装备位
    HeroSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    HeroSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    HeroSuperEquip.InitEquipLayerEvent()

    -- 开关设置
    HeroSuperEquip.InitEquipSetting()

    HeroSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    HeroSuperEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerSuperEquip_hero})
end

-- 初始化装备框装备
function HeroSuperEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = HeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = HeroSuperEquip.IsShowAll(pos)
        local isNaikan = HeroSuperEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                HeroSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function HeroSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not HeroSuperEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = false
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function HeroSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    HeroSuperEquip.OnOpenItemTips(widget, pos)
end

function HeroSuperEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetValue("ITEM_MOVE_STATE")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = GUIFunction:GetEquipDataByPos(pos, HeroSuperEquip._SamePos, EDType)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:RequestTakeOffEquip({itemData = itemData})
end

function HeroSuperEquip.UpdateMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    HeroSuperEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function HeroSuperEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = HeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:setVisible(itemNode, not state)
        end
    end

    -- 刷新装备内观
    local function onRefEquipNaikan()
        -- 开始移动, 设置移动的装备内观特效ID是空
        if state then
            SetFeature(pos, {})
        else
            HeroSuperEquip.UpdateModelFeatureData()
        end
        HeroSuperEquip.CreateUIModel()
    end

    -- 是否刷新内观和装备框
    local isShowAll = HeroSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end

    -- 是否刷新只内观
    local isNaikan = HeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 初始化点击（包含鼠标）事件
function HeroSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(HeroSuperEquip._EquipPosSet) do
        local widget = HeroSuperEquip.GetEquipPosPanel(pos)
        if widget then
            local params = {
                pos       = pos,
                from      = GUIDefine.ItemFrom.HERO_EQUIP,
                dataType  = EDType,
                moveCallBack = HeroSuperEquip.UpdateMoveState,
                onClick   = HeroSuperEquip.OnClickEvent,
                onPress   = HeroSuperEquip.OnClickEvent,
                onDouble  = HeroSuperEquip.OnDoubleEvent
            }

            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType)
                GUIFunction:DealEquipTouch(sender, eventType, params)
            end)

            local function addItemIntoEquip(touchPos)
                local isMoving = SL:GetValue("ITEM_MOVE_STATE")
                if not isMoving then
                    return -1
                end
                
                local data = {}
                data.target = GUIDefine.ItemGoTo.HERO_EQUIP
                data.pos = touchPos
                data.equipPos = pos

                widget._Click_flag = true

                SL:ItemMoveCheck(data)

                return 1
            end

            local function onRightDownFunc(touchPos)
                return -1
            end
            -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
            GUI:addMouseButtonEvent(widget, {onSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "HeroSuperEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, HeroSuperEquip.OnOpenItemTips)
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

            local Node = HeroSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    HeroSuperEquip.SetSamePosEquip()
end

function HeroSuperEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not HeroSuperEquip._SamePos then
        return false
    end
    
    for belongPos,v in pairs(GUIDefine.EquipPosMapping or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = HeroSuperEquip.GetEquipPosPanel(pos)
            if equipPanel then
                local equipData = HeroEquipData.FindEquipDataByPos(pos)
                if equipData then
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
function HeroSuperEquip.GetEquipPosPanel(pos)
    return HeroSuperEquip._ui["Panel_pos"..pos]
end

-- 装备位置节点
function HeroSuperEquip.GetEquipPosNode(pos)
    return HeroSuperEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function HeroSuperEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function HeroSuperEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function HeroSuperEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = HeroSuperEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Super_Dress and equipData and HeroSuperEquip._feature.showNodeModel and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        HeroSuperEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Super_Cap and equipData.AniCount == 0 then
        HeroSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function HeroSuperEquip.UpdateModelFeatureData()
    HeroSuperEquip._feature = {
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

    HeroSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1

    SetFeature(EquipPosCfg.Equip_Type_Super_Dress,  HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Super_Helmet, HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Super_Weapon, HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Super_Cap,    HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Super_Shield, HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Super_Veil,   HeroSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Veil))

    HeroSuperEquip._feature.hairID = HeroSuperEquip._heroHairID

    dump(HeroSuperEquip._feature, "--HeroSuperEquip._feature-----")
end

-- 额外的装备位置
function HeroSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(HeroSuperEquip._EquipPosSet, 14)
        table.insert(HeroSuperEquip._EquipPosSet, 15)
        local newPosSetting = {17, 18}

        for i, pos in ipairs(HeroSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = HeroSuperEquip._ui["Panel_pos" .. pos]
                if equipPanel then 
                    GUI:setVisible(equipPanel, false)
                end 
            end
        end
        HeroSuperEquip._EquipPosSet = {}
        HeroSuperEquip._EquipPosSet = newPosSetting
    else
        -- 额外的装备位置 1是6格 0是4格
        local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
        if showExtra then
            table.insert(HeroSuperEquip._EquipPosSet, 42)
            table.insert(HeroSuperEquip._EquipPosSet, 44)
        else
            GUI:setVisible(HeroSuperEquip._ui["Panel_pos42"], false)
            GUI:setVisible(HeroSuperEquip._ui["Panel_pos44"], false)
        end
    end
end

function HeroSuperEquip.InitEquipSetting()
    GUI:setVisible(HeroSuperEquip._ui["Text_shizhuang"],true)
    GUI:setVisible(HeroSuperEquip._ui["CheckBox_shizhuang"],true)

    GUI:CheckBox_addOnEvent(HeroSuperEquip._ui["CheckBox_shizhuang"],function()
        FuncDockData.SetAllowShowHeroFashion(GUI:CheckBox_isSelected(HeroSuperEquip._ui["CheckBox_shizhuang"]) and 1 or 0)
    end)

    local showSetting = FuncDockData.GetAllowShowHeroFashion() == 1
    GUI:CheckBox_setSelected(HeroSuperEquip._ui["CheckBox_shizhuang"], showSetting)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function HeroSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = HeroSuperEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.HERO_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function HeroSuperEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera

    local makeIndex = data.MakeIndex

    local pos = data.Where
    local equipPanel = HeroSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local function onRefEquipNaikan()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.DEL == optType or GUIDefine.OprateType.CHANGE == optType then
            HeroSuperEquip.UpdateModelFeatureData()
            HeroSuperEquip.CreateUIModel()
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.CHANGE == optType then
            local itemNode = HeroSuperEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData =  GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
            HeroSuperEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIDefine.OprateType.DEL == optType then
            local itemNode = HeroSuperEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        end
    end
    
    local isShowAll = HeroSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = HeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    HeroSuperEquip.SetSamePosEquip()
end

-- 装备状态改变时刷新
function HeroSuperEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local makeIndex = data.MakeIndex
    local itemData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local equipPanel = HeroSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state

    local function onRefEquipNaikan()
        HeroSuperEquip.UpdateModelFeatureData()
        HeroSuperEquip.CreateUIModel()
    end

    local function onRefEquipIcon()
        local itemNode = HeroSuperEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        HeroSuperEquip.CreateEquipItem(itemNode, equipData)
    end

    local isShowAll = HeroSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = HeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    HeroSuperEquip.SetSamePosEquip()
end

-- 界面关闭回调
function HeroSuperEquip.OnClose()
    HeroSuperEquip.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquip_hero
    })
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function HeroSuperEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroSuperEquip", HeroSuperEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroSuperEquip", HeroSuperEquip.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroSuperEquip", HeroSuperEquip.OnSexChange)
end

-- 取消事件
function HeroSuperEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroSuperEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroSuperEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroSuperEquip")
end

function HeroSuperEquip.OnSexChange()
    HeroSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.HERO)
    HeroSuperEquip.CreateUIModel()
end

function HeroSuperEquip.CreateUIModel()
    local NodeModel = HeroSuperEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, HeroSuperEquip._sex, HeroSuperEquip._feature, nil, {showHelmet = HeroSuperEquip._feature.showHair})
end

HeroSuperEquip.main()