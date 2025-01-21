PlayerSuperEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
PlayerSuperEquip._feature = {
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
        PlayerSuperEquip._feature.clothID = data.ID
        PlayerSuperEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Weapon] = function (data)
        PlayerSuperEquip._feature.weaponID = data.ID
        PlayerSuperEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Helmet] = function (data)
        PlayerSuperEquip._feature.headID = data.ID
        PlayerSuperEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Cap] = function (data)
        PlayerSuperEquip._feature.capID = data.ID
        PlayerSuperEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Shield] = function (data)
        PlayerSuperEquip._feature.shieldID = data.ID
        PlayerSuperEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Super_Veil] = function (data)
        PlayerSuperEquip._feature.veilID = data.ID
        PlayerSuperEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

local EquipPosSet = {17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45}

-- 斗笠和头盔是否在相同的位置
PlayerSuperEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.EQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function PlayerSuperEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if GUI:Win_IsNull(parent) then
        return false
    end
    GUI:LoadExport(parent, isPC and "player/player_super_equip_node_win32" or "player/player_super_equip_node")

    PlayerSuperEquip._ui = GUI:ui_delegate(parent)
    if not PlayerSuperEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    PlayerSuperEquip._EquipPosSet = EquipPosSet

    -- 发型
    PlayerSuperEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.PLAYER)
    -- 性别
    PlayerSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER)

    -- 是否显示裸模 0开启  1关闭
    PlayerSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1

    -- 注册事件
    PlayerSuperEquip.RegistEvent()

    -- 额外装备位
    PlayerSuperEquip.InitEquipCells()

    -- 初始化装备框装备
    PlayerSuperEquip.InitEquipLayer()

    -- 初始化装备事件
    PlayerSuperEquip.InitEquipLayerEvent()

    -- 开关设置
    PlayerSuperEquip.InitEquipSetting()

    PlayerSuperEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    PlayerSuperEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = PlayerSuperEquip._ui["Panel_1"], index = SLDefine.SUIComponentTable.PlayerSuperEquip})

    SL:AttachTXTSUI({root = isPC and PlayerSuperEquip._ui["Image_equippanel"] or PlayerSuperEquip._ui["Image_20"], index = SLDefine.SUIComponentTable.PlayerSuperEquipB})

    PlayerSuperEquip.InitJJSplit()
end

-- 剑甲分离
function PlayerSuperEquip.InitJJSplit()
    for pos, show in pairs(GUIDefine.EquipAllShow) do
        local p1 = PlayerSuperEquip.GetEquipPosExPanel(pos)
        local p2 = PlayerSuperEquip.GetEquipPosPanel(pos)
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
function PlayerSuperEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = PlayerSuperEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = PlayerSuperEquip.IsShowAll(pos)
        local isNaikan = PlayerSuperEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                PlayerSuperEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function PlayerSuperEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not PlayerSuperEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.PLAYER_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = false
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function PlayerSuperEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerSuperEquip.OnOpenItemTips(widget, pos)
end

function PlayerSuperEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetValue("ITEM_MOVE_STATE")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = GUIFunction:GetEquipDataByPos(pos, PlayerSuperEquip._SamePos, EDType)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:RequestTakeOffEquip({itemData = itemData})
end

function PlayerSuperEquip.UpdateMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    PlayerSuperEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function PlayerSuperEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = PlayerSuperEquip.GetEquipPosNode(pos)
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
            PlayerSuperEquip.UpdateModelFeatureData()
        end
        PlayerSuperEquip.CreateUIModel()
    end

    -- 是否刷新内观和装备框
    local isShowAll = PlayerSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end

    -- 是否刷新只内观
    local isNaikan = PlayerSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 初始化点击（包含鼠标）事件
function PlayerSuperEquip.InitEquipLayerEvent()
    for _,pos in pairs(PlayerSuperEquip._EquipPosSet) do
        local widget = PlayerSuperEquip.GetEquipPosPanel(pos)
        if type(GUIDefine.EquipAllShow[pos]) == "boolean" then
            widget = GUIDefine.EquipAllShow[pos] and PlayerSuperEquip.GetEquipPosPanel(pos) or PlayerSuperEquip.GetEquipPosExPanel(pos)
        end
        if widget then
            local params = {
                pos       = pos,
                from      = GUIDefine.ItemFrom.PLAYER_EQUIP,
                dataType  = EDType,
                moveCallBack = PlayerSuperEquip.UpdateMoveState,
                onClick   = PlayerSuperEquip.OnClickEvent,
                onPress   = PlayerSuperEquip.OnClickEvent,
                onDouble  = PlayerSuperEquip.OnDoubleEvent
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
                data.target = GUIDefine.ItemGoTo.PLAYER_EQUIP
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
                GUIFunction:InitItemTipsScrollEvent(widget, "PlayerSuperEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, PlayerSuperEquip.OnOpenItemTips)
            end

            -- 斗笠、头盔内装备特殊处理
            local isNaikan = GUIDefine.EquipNaikanShow and GUIDefine.EquipNaikanShow[pos]

            local isSpeDeal = isNaikan == true or isNaikan == false
            GUI:setVisible(widget, true)

            local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
            if DefaultIcon and isSpeDeal then
                GUI:setVisible(DefaultIcon, not isNaikan)
            end

            local PanelBg = GUI:getChildByName(widget, "PanelBg")
            if PanelBg and isSpeDeal then
                GUI:setVisible(PanelBg, not isNaikan)
            end
    
            local Node = PlayerSuperEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    PlayerSuperEquip.SetSamePosEquip()
end

function PlayerSuperEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not PlayerSuperEquip._SamePos then
        return false
    end

    for belongPos,v in pairs(GUIDefine.EquipPosMapping or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = PlayerSuperEquip.GetEquipPosPanel(pos)
            if equipPanel then
                local equipData = EquipData.FindEquipDataByPos(pos)
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
function PlayerSuperEquip.GetEquipPosPanel(pos)
    return PlayerSuperEquip._ui["Panel_pos"..pos]
end

function PlayerSuperEquip.GetEquipPosExPanel(pos)
    return PlayerSuperEquip._ui["Panel_posEx"..pos]
end

-- 装备位置节点
function PlayerSuperEquip.GetEquipPosNode(pos)
    return PlayerSuperEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function PlayerSuperEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function PlayerSuperEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function PlayerSuperEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = PlayerSuperEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Super_Dress and equipData and PlayerSuperEquip._feature.showNodeModel and equipData.zblmtkz and tonumber(equipData.zblmtkz) == 1 then -- zblmtkz == 1 不显示裸模, 表配置字段
        PlayerSuperEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Super_Cap and equipData.AniCount == 0 then
        PlayerSuperEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function PlayerSuperEquip.UpdateModelFeatureData()
    PlayerSuperEquip._feature = {
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

    PlayerSuperEquip._feature.showNodeModel = tonumber(SL:GetValue("GAME_DATA", "Fashionfx") or 0) ~= 1

    SetFeature(EquipPosCfg.Equip_Type_Super_Dress,  PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Super_Helmet, PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Super_Weapon, PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Super_Cap,    PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Super_Shield, PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Super_Veil,   PlayerSuperEquip.GetLooks(EquipPosCfg.Equip_Type_Super_Veil))

    PlayerSuperEquip._feature.hairID = PlayerSuperEquip._hairID

end

-- 额外的装备位置
function PlayerSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(PlayerSuperEquip._EquipPosSet, 14)
        table.insert(PlayerSuperEquip._EquipPosSet, 15)
        local newPosSetting = {17, 18}

        for i, pos in ipairs(PlayerSuperEquip._EquipPosSet) do
            if not newPosSetting[pos] then
                local equipPanel = PlayerSuperEquip._ui["Panel_pos" .. pos]
                if equipPanel then 
                    GUI:setVisible(equipPanel, false)
                end 
            end
        end
        PlayerSuperEquip._EquipPosSet = {}
        PlayerSuperEquip._EquipPosSet = newPosSetting
    else
        -- 额外的装备位置 1是6格 0是4格
        local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
        if showExtra then
            table.insert(PlayerSuperEquip._EquipPosSet, 42)
            table.insert(PlayerSuperEquip._EquipPosSet, 44)
        else
            GUI:setVisible(PlayerSuperEquip._ui["Panel_pos42"], false)
            GUI:setVisible(PlayerSuperEquip._ui["Panel_pos44"], false)
        end
    end
end

function PlayerSuperEquip.InitEquipSetting()
    GUI:setVisible(PlayerSuperEquip._ui["Text_shizhuang"],true)
    GUI:setVisible(PlayerSuperEquip._ui["CheckBox_shizhuang"],true)

    GUI:CheckBox_addOnEvent(PlayerSuperEquip._ui["CheckBox_shizhuang"],function()
        FuncDockData.SetAllowShowFashion(GUI:CheckBox_isSelected(PlayerSuperEquip._ui["CheckBox_shizhuang"]) and 1 or 0)
    end)

    local showSetting = FuncDockData.GetAllowShowFashion() == 1
    GUI:CheckBox_setSelected(PlayerSuperEquip._ui["CheckBox_shizhuang"], showSetting)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerSuperEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = PlayerSuperEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.PLAYER_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function PlayerSuperEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera

    local makeIndex = data.MakeIndex

    local pos = data.Where
    local equipPanel = PlayerSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local function onRefEquipNaikan()
        if GUIDefine.OperateType.ADD == optType or GUIDefine.OperateType.DEL == optType or GUIDefine.OperateType.CHANGE == optType then
            PlayerSuperEquip.UpdateModelFeatureData()
            PlayerSuperEquip.CreateUIModel()
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIDefine.OperateType.ADD == optType or GUIDefine.OperateType.CHANGE == optType then
            local itemNode = PlayerSuperEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData =  GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
            PlayerSuperEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIDefine.OperateType.DEL == optType then
            local itemNode = PlayerSuperEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        end
    end
    
    local isShowAll = PlayerSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    PlayerSuperEquip.SetSamePosEquip()
end

-- 装备状态改变时刷新
function PlayerSuperEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local makeIndex = data.MakeIndex
    local itemData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local equipPanel = PlayerSuperEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state

    local function onRefEquipNaikan()
        PlayerSuperEquip.UpdateModelFeatureData()
        PlayerSuperEquip.CreateUIModel()
    end

    local function onRefEquipIcon()
        local itemNode = PlayerSuperEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        PlayerSuperEquip.CreateEquipItem(itemNode, equipData)
    end

    local isShowAll = PlayerSuperEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerSuperEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    PlayerSuperEquip.SetSamePosEquip()
end

-- 界面关闭回调
function PlayerSuperEquip.OnClose()
    PlayerSuperEquip.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquip
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSuperEquipB
    })
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function PlayerSuperEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerSuperEquip", PlayerSuperEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerSuperEquip", PlayerSuperEquip.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerSuperEquip", PlayerSuperEquip.OnSexChange)
end

-- 取消事件
function PlayerSuperEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerSuperEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerSuperEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerSuperEquip")
end

function PlayerSuperEquip.OnSexChange()
    PlayerSuperEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER)
    PlayerSuperEquip.CreateUIModel()
end

function PlayerSuperEquip.CreateUIModel()
    local NodeModel = PlayerSuperEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerSuperEquip._sex, PlayerSuperEquip._feature, nil, {showHelmet = PlayerSuperEquip._feature.showHair})
end

PlayerSuperEquip.main()