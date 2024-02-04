PlayerHeroSuperEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
PlayerHeroSuperEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Super_Wing]     = {order = 3,  scale = 1, create = function () PlayerHeroSuperEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Super_Dress]    = {order = 6,  scale = 1, create = function () PlayerHeroSuperEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Super_Weapon]   = {order = 9,  scale = 1, create = function () PlayerHeroSuperEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Super_Veil]     = {order = 13, scale = 1, create = function () PlayerHeroSuperEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Super_Helmet]   = {order = 16, scale = 1, create = function () PlayerHeroSuperEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Super_Cap]      = {order = 16, scale = 1, create = function () PlayerHeroSuperEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Super_Shield]   = {order = 19, scale = 1, create = function () PlayerHeroSuperEquip.CreateShield()   end}
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Super_Dress] = function (data)
        PlayerHeroSuperEquip._feature.clothID = data.ID
        PlayerHeroSuperEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        PlayerHeroSuperEquip._feature.weaponID = data.ID
        PlayerHeroSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        PlayerHeroSuperEquip._feature.headID = data.ID
        PlayerHeroSuperEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        PlayerHeroSuperEquip._feature.capID = data.ID
        PlayerHeroSuperEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        PlayerHeroSuperEquip._feature.shieldID = data.ID
        PlayerHeroSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        PlayerHeroSuperEquip._feature.veilID = data.ID
        PlayerHeroSuperEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Super_Wing] = function (data)
        PlayerHeroSuperEquip._feature.wingsID = data.ID
        PlayerHeroSuperEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置
local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

function PlayerHeroSuperEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/hero_super_equip_node")

    PlayerHeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not PlayerHeroSuperEquip._ui then
        return false
    end
    PlayerHeroSuperEquip._parent = parent

    PlayerHeroSuperEquip._EquipPosSet = EquipPosSet
    -- 发型
    PlayerHeroSuperEquip._playerHairID = SL:GetMetaValue("H.HAIR")
    -- 性别
    PlayerHeroSuperEquip._playerSex = SL:GetMetaValue("H.SEX")
    -- 职业
    PlayerHeroSuperEquip._playerJob = SL:GetMetaValue("H.JOB")

    -- 注册事件
    PlayerHeroSuperEquip.RegistEvent()

    -- 初始化装备框装备
    PlayerHeroSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    PlayerHeroSuperEquip.InitEquipLayerEvent()

    -- 开关设置
    PlayerHeroSuperEquip.InitEquipSetting()

    -- 装备位
    PlayerHeroSuperEquip.InitEquipCells()

    PlayerHeroSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    PlayerHeroSuperEquip.InitPlayerModel()
end

-- 初始化装备框装备
function PlayerHeroSuperEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("H.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isNaikan = PlayerHeroSuperEquip.IsNaikan(pos)

        if itemNode and not isNaikan then
            -- 加载外观
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
            if equipData then       
                PlayerHeroSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function PlayerHeroSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function PlayerHeroSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
end

function PlayerHeroSuperEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = SL:GetMetaValue("H.EQUIP_DATA", pos)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:OnTakeOffHeroEquip({itemData = itemData, pos = itemData.Where})
end

function PlayerHeroSuperEquip.RefeshMoveState(widget, state, pos)
    print(widget)
    if GUI:Win_IsNull(widget) then
        return false
    end

    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    PlayerHeroSuperEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function PlayerHeroSuperEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:setVisible(itemNode, not state)
        end
    end

    -- 刷新装备内观
    local function onRefEquipNaikan()
        -- 开始移动, 设置移动的装备内观特效ID是空
        if GUIShare.IsCreateSingleModel then
            if state then
                _SetFeature(pos, {})
            else
                _SetFeature(pos, PlayerHeroSuperEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
            end
            PlayerHeroSuperEquip.CreateSingleModelByType(pos)
        else
            if state then
                _SetFeature(pos, {})
            else
                PlayerHeroSuperEquip.UpdateModelFeatureData()
            end
            PlayerHeroSuperEquip.CreateUIModel()
        end
    end

    -- 是否刷新只内观
    local isNaikan = PlayerHeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan(pos, state)
    else
        onRefEquipIcon(pos, state)
    end
end

function PlayerHeroSuperEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("H.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function PlayerHeroSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(PlayerHeroSuperEquip._EquipPosSet) do
        local widget = PlayerHeroSuperEquip.GetEquipPosPanel(pos)
        if widget then
            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = PlayerHeroSuperEquip.GetEquipDataByPos
            widget._RefeshMoveState = PlayerHeroSuperEquip.RefeshMoveState
            widget._OnClickEvent  = PlayerHeroSuperEquip.OnClickEvent
            widget._OnPressEvent  = PlayerHeroSuperEquip.OnClickEvent
            widget._OnDoubleEvent = PlayerHeroSuperEquip.OnDoubleEvent
            
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)

            local function addItemIntoEquip(touchPos)
                local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
                if not isMoving then
                    return -1
                end
                
                local data = {}
                data.target = SL:GetItemGoto().HERO_EQUIP
                data.pos = touchPos
                data.equipPos = pos

                -- 拖动结束处理函数; PC端做个延迟处理，防止再次触发点击事件
                if SL:IsWinMode() then
                    SL:ScheduleOnce(
                        function () 
                            SL:OnItemDragEndDeal(data)
                        end, 
                    GUIShare.CLICK_DOUBLE_TIME)
                else
                    SL:OnItemDragEndDeal(data)
                end
            end
            
            local function onRightDownFunc(touchPos)
                if not SL:IsWinMode() then
                    return -1
                end

                local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
                if isMoving then
                    return -1
                end

                local itemData = PlayerHeroSuperEquip.GetEquipDataByPos(pos)
                if not itemData then
                    return -1
                end

                PlayerHeroSuperEquip.RefeshMoveState(widget, true, itemData.Where)

                SL:CloseItemTips()

                SL:SetItemMoveBegan({
                    from = SL:GetItemGoto().HERO_EQUIP,
                    pos  = touchPos,
                    itemData = itemData,
                    cancelCallBack = function ()
                        PlayerHeroSuperEquip.RefeshMoveState(widget, false, itemData.Where)
                    end
                })
            end

            -- 注册从其他地方拖到玩家装备部位事件
            GUI:addMouseButtonEvent(widget, {OnSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if SL:IsWinMode() then
                PlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "PlayerHeroSuperEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            -- -- 斗笠、头盔内装备特殊处理
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

            local Node = PlayerHeroSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 装备位置框
function PlayerHeroSuperEquip.GetEquipPosPanel(pos)
    return PlayerHeroSuperEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function PlayerHeroSuperEquip.GetEquipPosNode(pos)
    return PlayerHeroSuperEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function PlayerHeroSuperEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-----------------------------------------------------------------------------------------------------------------
function PlayerHeroSuperEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = PlayerHeroSuperEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
    if equipPos == _EquipPosCfg.Equip_Type_Super_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        PlayerHeroSuperEquip._feature.showNodeModel = false
        PlayerHeroSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function PlayerHeroSuperEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("H.EQUIP_POS_DATAS")

    PlayerHeroSuperEquip._feature = {
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

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    _SetFeature(_EquipPosCfg.Equip_Type_Super_Dress,  PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Helmet, PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Weapon, PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Cap,    PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Shield, PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Veil,   PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Super_Wing,   PlayerHeroSuperEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Super_Wing))

    PlayerHeroSuperEquip._feature.hairID = PlayerHeroSuperEquip._playerHairID
end

-- 额外的装备位置
function PlayerHeroSuperEquip.InitEquipCells()
    local openFEquip = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(PlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(PlayerHeroSuperEquip._EquipPosSet, 44)

        local newPosSetting = {17, 18}
        for i,pos in ipairs(PlayerHeroSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = PlayerHeroSuperEquip.GetEquipPosPanel(pos)
                if equipPanel then
                    equipPanel:setVisible(false)
                end
            end
        end
        PlayerHeroSuperEquip._EquipPosSet = {}
        PlayerHeroSuperEquip._EquipPosSet = newPosSetting
        return
    end

    local isExtraPos = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    local showExtra  = isExtraPos == 1
    if showExtra then
        table.insert(PlayerHeroSuperEquip._EquipPosSet, 42)
        table.insert(PlayerHeroSuperEquip._EquipPosSet, 44)
    else
        GUI:setVisible(PlayerHeroSuperEquip._ui["PanelPos42"], false)
        GUI:setVisible(PlayerHeroSuperEquip._ui["PanelPos44"], false)
        GUI:setVisible(PlayerHeroSuperEquip._ui["Node42"], false)
        GUI:setVisible(PlayerHeroSuperEquip._ui["Node44"], false)
    end

end

function PlayerHeroSuperEquip.InitEquipSetting()
    local CheckBox = PlayerHeroSuperEquip._ui["CheckBox"]
    local Text_CheckBox = PlayerHeroSuperEquip._ui["Text_CheckBox"]

    GUI:setVisible(CheckBox, true)
    GUI:setVisible(Text_CheckBox, true)

    GUI:CheckBox_setSelected(CheckBox, SL:GetHeroFashionShow())

    GUI:addOnClickEvent(CheckBox, function ()
        local isSelected = GUI:CheckBox_isSelected(CheckBox) and 0 or 1
        SL:SetHeroFashionShow(isSelected)
    end)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = PlayerHeroSuperEquip.IsNaikan(pos) and SL:GetMetaValue("H.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("H.EQUIP_DATA_BY_POS", pos)}
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
-- 对装备进行操作时刷新
function PlayerHeroSuperEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera
    local MakeIndex = data.MakeIndex

    local pos = data.Where
    if PlayerHeroSuperEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end
    
    local equipPanel = PlayerHeroSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local function onRefEquipNaikan()
        if GUIShare.Operator_Add == optType or GUIShare.Operator_Sub == optType or GUIShare.Operator_Change == optType then
            if GUIShare.IsCreateSingleModel then
                _SetFeature(pos, PlayerHeroSuperEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
                PlayerHeroSuperEquip.CreateSingleModelByType(pos)
            else
                PlayerHeroSuperEquip.UpdateModelFeatureData()
                PlayerHeroSuperEquip.CreateUIModel()
            end
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIShare.Operator_Add == optType then
            local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
            PlayerHeroSuperEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIShare.Operator_Sub == optType then
            local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        elseif GUIShare.Operator_Change == optType then
            local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)

            local itemShow = GUI:getChildByName(itemNode, "item")            
            if GUI:Win_IsNull(itemShow) then
                return false  
            end
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
            GUI:ItemShow_OnRunFunc(itemShow, "UpdateGoodsItem", equipData)
        end
    end

    local isNaikan = PlayerHeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 装备状态改变时刷新
function PlayerHeroSuperEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local MakeIndex = data.MakeIndex
    local itemData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    if PlayerHeroSuperEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end

    local equipPanel = PlayerHeroSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state

    local function onRefEquipNaikan()
        if GUIShare.IsCreateSingleModel then
            _SetFeature(pos, PlayerHeroSuperEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
            PlayerHeroSuperEquip.CreateSingleModelByType(pos)
        else
            PlayerHeroSuperEquip.UpdateModelFeatureData()
            PlayerHeroSuperEquip.CreateUIModel()
        end
    end

    local function onRefEquipIcon()
        local itemNode = PlayerHeroSuperEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
        PlayerHeroSuperEquip.CreateEquipItem(itemNode, equipData)
    end

    local isNaikan = PlayerHeroSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function PlayerHeroSuperEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        PlayerHeroSuperEquip.OnOpenItemTips(widget, pos)
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
function PlayerHeroSuperEquip.CloseCallback()
    PlayerHeroSuperEquip.UnRegisterEvent()

    if SL:IsWinMode() then
        for _,pos in pairs(PlayerHeroSuperEquip._EquipPosSet) do
            local widget = PlayerHeroSuperEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "PlayerHeroSuperEquip")
            end
        end

        if PlayerHeroSuperEquip._scheduleID then
            SL:UnSchedule(PlayerHeroSuperEquip._scheduleID)
            PlayerHeroSuperEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function PlayerHeroSuperEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "PlayerHeroSuperEquip", PlayerHeroSuperEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerHeroSuperEquip", PlayerHeroSuperEquip.UpdateEquipPanelState)
end

-- 取消事件
function PlayerHeroSuperEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "PlayerHeroSuperEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerHeroSuperEquip")
end

function PlayerHeroSuperEquip.CreateUIModel()
    local NodeModel = PlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerHeroSuperEquip._playerSex, PlayerHeroSuperEquip._feature, nil, {showHelmet = PlayerHeroSuperEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function PlayerHeroSuperEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        PlayerHeroSuperEquip.CreateNodeModel()
        PlayerHeroSuperEquip.CreateSingleModelByType()
    else
        PlayerHeroSuperEquip.CreateUIModel()
    end
end

-- 创建裸模
function PlayerHeroSuperEquip.CreateNodeModel()
    local NodeModel = PlayerHeroSuperEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = PlayerHeroSuperEquip._feature
    local feature = {
        hairID        = PlayerHeroSuperEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, PlayerHeroSuperEquip._playerSex, feature)
end

function PlayerHeroSuperEquip.CreateSingleModelByType(type)
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

function PlayerHeroSuperEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function PlayerHeroSuperEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Super_Wing
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.wingsID, effectID = PlayerHeroSuperEquip._feature.wingEffectID})
end

-- 创建衣服
function PlayerHeroSuperEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Super_Dress
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.clothID, effectID = PlayerHeroSuperEquip._feature.clothEffectID})
end

-- 创建武器
function PlayerHeroSuperEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Super_Weapon
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.weaponID, effectID = PlayerHeroSuperEquip._feature.weaponEffectID})
end

-- 创建盾牌
function PlayerHeroSuperEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Super_Shield
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.shieldID, effectID = PlayerHeroSuperEquip._feature.shieldEffectID})
end

-- 创建头盔
function PlayerHeroSuperEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Super_Helmet
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.headID, effectID = PlayerHeroSuperEquip._feature.headEffectID})
end

-- 创建面纱
function PlayerHeroSuperEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Super_Veil
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.veilID, effectID = PlayerHeroSuperEquip._feature.veilEffectID})
end

-- 创建斗笠
function PlayerHeroSuperEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Super_Cap
    local node = PlayerHeroSuperEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroSuperEquip.CreateCommonModel(node, type, {ID = PlayerHeroSuperEquip._feature.capID, effectID = PlayerHeroSuperEquip._feature.capEffectID})
end