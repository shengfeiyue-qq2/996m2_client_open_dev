PlayerEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
PlayerEquip._feature = {
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
    embattlesID     = nil,      -- 光环

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local TypeCfg = {
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () PlayerEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () PlayerEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () PlayerEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () PlayerEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () PlayerEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () PlayerEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () PlayerEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () PlayerEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        PlayerEquip._feature.clothID = data.ID
        PlayerEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        PlayerEquip._feature.weaponID = data.ID
        PlayerEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        PlayerEquip._feature.headID = data.ID
        PlayerEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        PlayerEquip._feature.capID = data.ID
        PlayerEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        PlayerEquip._feature.shieldID = data.ID
        PlayerEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        PlayerEquip._feature.veilID = data.ID
        PlayerEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        PlayerEquip._feature.wingsID = data.ID
        PlayerEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
PlayerEquip._SamePos = true

function PlayerEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_equip_node")

    PlayerEquip._ui = GUI:ui_delegate(parent)
    if not PlayerEquip._ui then
        return false
    end
    PlayerEquip._parent = parent

    PlayerEquip._EquipPosSet = EquipPosSet

    -- 发型
    PlayerEquip._playerHairID = SL:GetMetaValue("M.HAIR")
    -- 性别
    PlayerEquip._playerSex = SL:GetMetaValue("M.SEX")
    -- 职业
    PlayerEquip._playerJob = SL:GetMetaValue("M.JOB")

    -- 首饰盒按钮
    local BestRingBox = PlayerEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:RequestOpenPlayerBestRings()
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    PlayerEquip._BestRingBox = BestRingBox

    -- 注册事件
    PlayerEquip.RegistEvent()

    -- 额外装备位
    PlayerEquip.InitEquipCells()
    
    -- 初始化首饰盒
    PlayerEquip.InitBestRingsBox()

    -- 初始化装备框装备
    PlayerEquip.InitEquipLayer()

    -- 初始化装备事件
    PlayerEquip.InitEquipLayerEvent()

    -- 行会信息
    PlayerEquip.UpdateGuildInfo()

    PlayerEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    PlayerEquip.InitPlayerModel()
end

-- 初始化装备框装备
function PlayerEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("M.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = PlayerEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = PlayerEquip.IsShowAll(pos)
        local isNaikan = PlayerEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                PlayerEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function PlayerEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not PlayerEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().PALYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = false

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function PlayerEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerEquip.OnOpenItemTips(widget, pos)
end

function PlayerEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = SL:GetMetaValue("M.EQUIP_DATA", pos, PlayerEquip._SamePos)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:OnTakeOffEquip({itemData = itemData, pos = itemData.Where})
end

function PlayerEquip.RefeshMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    PlayerEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function PlayerEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = PlayerEquip.GetEquipPosNode(pos)
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
                _SetFeature(pos, PlayerEquip.GetLooks(SL:GetMetaValue("M.EQUIP_POS_DATAS"), pos))
            end
            PlayerEquip.CreateSingleModelByType(pos)
        else
            if state then
                _SetFeature(pos, {})
            else
                PlayerEquip.UpdateModelFeatureData()
            end
            PlayerEquip.CreateUIModel()
        end
    end

    -- 是否刷新内观和装备框
    local isShowAll = PlayerEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan(pos, state)
        onRefEquipIcon(pos, state)
        return false
    end

    -- 是否刷新只内观
    local isNaikan = PlayerEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan(pos, state)
    else
        onRefEquipIcon(pos, state)
    end
end

function PlayerEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("M.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function PlayerEquip.InitEquipLayerEvent()
    for _,pos in pairs(PlayerEquip._EquipPosSet) do
        local widget = PlayerEquip.GetEquipPosPanel(pos)
        if widget then
            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().PALYER_EQUIP
            widget._GetEquipDataByPos  = PlayerEquip.GetEquipDataByPos
            widget._RefeshMoveState = PlayerEquip.RefeshMoveState
            widget._OnClickEvent  = PlayerEquip.OnClickEvent
            widget._OnPressEvent  = PlayerEquip.OnClickEvent
            widget._OnDoubleEvent = PlayerEquip.OnDoubleEvent
            
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) SL:OnEquipTouchedEvent(sender, eventType) end)

            local function addItemIntoEquip(touchPos)
                local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
                if not isMoving then
                    return -1
                end
                
                local data = {}
                data.target = SL:GetItemGoto().PALYER_EQUIP
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
                return 1
            end

            local function onRightDownFunc(touchPos)
                if not SL:IsWinMode() then
                    return -1
                end

                local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
                if isMoving then
                    return -1
                end

                local itemData = PlayerEquip.GetEquipDataByPos(pos)
                if not itemData then
                    return -1
                end

                PlayerEquip.RefeshMoveState(widget, true, itemData.Where)

                SL:CloseItemTips()

                SL:SetItemMoveBegan({
                    from = SL:GetItemGoto().PALYER_EQUIP,
                    pos  = touchPos,
                    itemData = itemData,
                    cancelCallBack = function ()
                        PlayerEquip.RefeshMoveState(widget, false, itemData.Where)
                    end
                })
                
                return 1
            end
            -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
            GUI:addMouseButtonEvent(widget, {OnSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if SL:IsWinMode() then
                PlayerEquip.OnRegisterMouseMoveEvent(widget, pos)
                
                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "PlayerEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

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

            local Node = PlayerEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    PlayerEquip.SetSamePosEquip()
end

function PlayerEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not PlayerEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and PlayerEquip.GetEquipDataByPos(pos) then
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
function PlayerEquip.GetEquipPosPanel(pos)
    return PlayerEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function PlayerEquip.GetEquipPosNode(pos)
    return PlayerEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function PlayerEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function PlayerEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function PlayerEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = PlayerEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        PlayerEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        PlayerEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function PlayerEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("M.EQUIP_POS_DATAS")

    PlayerEquip._feature = {
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
        embattlesID     = nil,      -- 光环

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   PlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    PlayerEquip._feature.hairID = PlayerEquip._playerHairID
    PlayerEquip._feature.embattlesID = SL:GetMetaValue("M.EMBATTLE")

    dump(PlayerEquip._feature, "--PlayerEquip._feature-----")
end

-- 额外的装备位置
function PlayerEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(PlayerEquip._EquipPosSet, 14)
        table.insert(PlayerEquip._EquipPosSet, 15)
    else
        GUI:setVisible(PlayerEquip._ui["PanelPos14"], false)
        GUI:setVisible(PlayerEquip._ui["PanelPos15"], false)
        GUI:setVisible(PlayerEquip._ui["Node14"], false)
        GUI:setVisible(PlayerEquip._ui["Node15"], false)
    end
end

function PlayerEquip.InitBestRingsBox()
    if not PlayerEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(1)
    local btn = GUI:getChildByName(PlayerEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = PlayerEquip.IsNaikan(pos) and SL:GetMetaValue("M.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("M.EQUIP_DATA_BY_POS", pos)}
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
-- 对装备进行操作时刷新
function PlayerEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera
    local MakeIndex = data.MakeIndex

    local pos = data.Where
    if PlayerEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end
    
    local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    PlayerEquip.SetSamePosEquip()

    local function onRefEquipNaikan()
        if GUIShare.Operator_Add == optType or GUIShare.Operator_Sub == optType or GUIShare.Operator_Change == optType then
            if GUIShare.IsCreateSingleModel then
                _SetFeature(pos, PlayerEquip.GetLooks(SL:GetMetaValue("M.EQUIP_POS_DATAS"), pos))
                PlayerEquip.CreateSingleModelByType(pos)
            else
                PlayerEquip.UpdateModelFeatureData()
                PlayerEquip.CreateUIModel()
            end
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIShare.Operator_Add == optType then
            local itemNode = PlayerEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            PlayerEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIShare.Operator_Sub == optType then
            local itemNode = PlayerEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        elseif GUIShare.Operator_Change == optType then
            local itemNode = PlayerEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)

            local itemShow = GUI:getChildByName(itemNode, "item")            
            if GUI:Win_IsNull(itemShow) then
                return false  
            end
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            GUI:ItemShow_OnRunFunc(itemShow, "UpdateGoodsItem", equipData)
        end
    end
    
    local isShowAll = PlayerEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 装备状态改变时刷新
function PlayerEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local MakeIndex = data.MakeIndex
    local itemData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    if PlayerEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end

    local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state
    
    PlayerEquip.SetSamePosEquip()

    local function onRefEquipNaikan()
        if GUIShare.IsCreateSingleModel then
            _SetFeature(pos, PlayerEquip.GetLooks(SL:GetMetaValue("M.EQUIP_POS_DATAS"), pos))
            PlayerEquip.CreateSingleModelByType(pos)
        else
            PlayerEquip.UpdateModelFeatureData()
            PlayerEquip.CreateUIModel()
        end
    end

    local function onRefEquipIcon()
        local itemNode = PlayerEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
        PlayerEquip.CreateEquipItem(itemNode, equipData)
    end

    local isShowAll = PlayerEquip.IsShowAll(pos)
    if PlayerEquip.IsShowAll(pos) then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 更新生肖框状态
function PlayerEquip.UpdateBestRingsBox(isOpen)
    if not PlayerEquip._BestRingBox then
        return false
    end

    isOpen = isOpen or false

    local btn = GUI:getChildByName(PlayerEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)

    if isOpen then           
        SL:OpenBestRingBoxUI(1)
    else
        GUI:SetWorldTips("首饰盒未开启", GUI:getTouchEndPosition(PlayerEquip._BestRingBox), {x = 0, y = 1})
    end
end

-- 更新所属行会信息
function PlayerEquip.UpdateGuildInfo()
    local textGuildInfo = PlayerEquip._ui["Text_Guildinfo"]
    -- 行会数据
    local guildData   = SL:GetMetaValue("GUILD_INFO")

    -- 行会名字
    local guildName   = guildData.guildName
    guildName = guildName or ""

    -- 行会官职
    local officalName = SL:GetMetaValue("GUILD_OFFICIAL", guildData.rank)
    officalName = officalName or ""

    local str = guildName .. " " .. officalName
    if string.len(str) < 1 then
        GUI:Text_setString(textGuildInfo, "")
        return false
    end
    
    GUI:Text_setString(textGuildInfo, str)
    local color = SL:GetMetaValue("NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function PlayerEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        PlayerEquip.OnOpenItemTips(widget, pos)
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
function PlayerEquip.CloseCallback()
    PlayerEquip.UnRegisterEvent()

    if SL:IsWinMode() then
        for _,pos in pairs(PlayerEquip._EquipPosSet) do
            local widget = PlayerEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "PlayerEquip")
            end
        end

        if PlayerEquip._scheduleID then
            SL:UnSchedule(PlayerEquip._scheduleID)
            PlayerEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function PlayerEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_BEST_RING_BOX_STATE, "PlayerEquip", PlayerEquip.UpdateBestRingsBox)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "PlayerEquip", PlayerEquip.UpdateGuildInfo)
    SL:RegisterLUAEvent(LUA_EVENT_EMBATTLE_CHANGE, "PlayerEquip", PlayerEquip.UpdateEmbattleModel)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip", PlayerEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerEquip", PlayerEquip.UpdateEquipPanelState)
end

-- 取消事件
function PlayerEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_BEST_RING_BOX_STATE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EMBATTLE_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerEquip")
end

-- 更新光环
function PlayerEquip.UpdateEmbattleModel()
    PlayerEquip._feature.embattlesID = SL:GetMetaValue("M.EMBATTLE")
    if GUIShare.IsCreateSingleModel then
        PlayerEquip.CreateEmbattle()
    else
        PlayerEquip.CreateUIModel()
    end
end

function PlayerEquip.CreateUIModel()
    local NodeModel = PlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerEquip._playerSex, PlayerEquip._feature, nil, {showHelmet = PlayerEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function PlayerEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        PlayerEquip.CreateNodeModel()
        PlayerEquip.CreateSingleModelByType()
    else
        PlayerEquip.CreateUIModel()
    end
end

-- 创建裸模
function PlayerEquip.CreateNodeModel()
    local NodeModel = PlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = PlayerEquip._feature
    local feature = {
        hairID        = PlayerEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, PlayerEquip._playerSex, feature)
end

function PlayerEquip.CreateSingleModelByType(type)
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

function PlayerEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function PlayerEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.wingsID, effectID = PlayerEquip._feature.wingEffectID})
end

-- 创建衣服
function PlayerEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.clothID, effectID = PlayerEquip._feature.clothEffectID})
end

-- 创建武器
function PlayerEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.weaponID, effectID = PlayerEquip._feature.weaponEffectID})
end

-- 创建盾牌
function PlayerEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.shieldID, effectID = PlayerEquip._feature.shieldEffectID})
end

-- 创建头盔
function PlayerEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.headID, effectID = PlayerEquip._feature.headEffectID})
end

-- 创建面纱
function PlayerEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.veilID, effectID = PlayerEquip._feature.veilEffectID})
end

-- 创建斗笠
function PlayerEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerEquip.CreateCommonModel(node, type, {ID = PlayerEquip._feature.capID, effectID = PlayerEquip._feature.capEffectID})
end

-- 创建光环
function PlayerEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = PlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    local embattlesID = (PlayerEquip._feature.embattlesID and next(PlayerEquip._feature.embattlesID)) and PlayerEquip._feature.embattlesID
    PlayerEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end