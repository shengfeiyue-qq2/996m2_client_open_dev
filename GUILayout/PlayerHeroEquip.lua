PlayerHeroEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
PlayerHeroEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () PlayerHeroEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () PlayerHeroEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () PlayerHeroEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () PlayerHeroEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () PlayerHeroEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () PlayerHeroEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () PlayerHeroEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () PlayerHeroEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        PlayerHeroEquip._feature.clothID = data.ID
        PlayerHeroEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        PlayerHeroEquip._feature.weaponID = data.ID
        PlayerHeroEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        PlayerHeroEquip._feature.headID = data.ID
        PlayerHeroEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        PlayerHeroEquip._feature.capID = data.ID
        PlayerHeroEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        PlayerHeroEquip._feature.shieldID = data.ID
        PlayerHeroEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        PlayerHeroEquip._feature.veilID = data.ID
        PlayerHeroEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        PlayerHeroEquip._feature.wingsID = data.ID
        PlayerHeroEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
PlayerHeroEquip._EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
PlayerHeroEquip._SamePos = true

function PlayerHeroEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/hero_equip_node")

    PlayerHeroEquip._ui = GUI:ui_delegate(parent)
    if not PlayerHeroEquip._ui then
        return false
    end
    PlayerHeroEquip._parent = parent

    -- 发型
    PlayerHeroEquip._playerHairID = SL:GetMetaValue("H.HAIR")
    -- 性别
    PlayerHeroEquip._playerSex = SL:GetMetaValue("H.SEX")
    -- 职业
    PlayerHeroEquip._playerJob = SL:GetMetaValue("H.JOB")

    -- 首饰盒按钮
    local BestRingBox = PlayerHeroEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:RequestOpenHeroBestRings()
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    PlayerHeroEquip._BestRingBox = BestRingBox

    -- 注册事件
    PlayerHeroEquip.RegistEvent()

    -- 额外装备位
    PlayerHeroEquip.InitEquipCells()
    
    -- 初始化首饰盒
    PlayerHeroEquip.InitBestRingsBox()

    -- 初始化装备框装备
    PlayerHeroEquip.InitEquipLayer()

    -- 初始化装备事件
    PlayerHeroEquip.InitEquipLayerEvent()

    -- 行会信息
    PlayerHeroEquip.UpdateGuildInfo()

    PlayerHeroEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    PlayerHeroEquip.InitPlayerModel()
end

-- 初始化装备框装备
function PlayerHeroEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("H.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = PlayerHeroEquip.IsShowAll(pos)
        local isNaikan = PlayerHeroEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
            if equipData then       
                PlayerHeroEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function PlayerHeroEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not PlayerHeroEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function PlayerHeroEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerHeroEquip.OnOpenItemTips(widget, pos)
end

function PlayerHeroEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = SL:GetMetaValue("H.EQUIP_DATA", pos, PlayerHeroEquip._SamePos)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:OnTakeOffHeroEquip({itemData = itemData, pos = itemData.Where})
end

function PlayerHeroEquip.RefeshMoveState(widget, state, pos)
    print(widget)
    if GUI:Win_IsNull(widget) then
        return false
    end

    -- true: 开始移动; false: 移动结束
    widget._movingState = state
    PlayerHeroEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function PlayerHeroEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
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
                _SetFeature(pos, PlayerHeroEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
            end
            PlayerHeroEquip.CreateSingleModelByType(pos)
        else
            if state then
                _SetFeature(pos, {})
            else
                PlayerHeroEquip.UpdateModelFeatureData()
            end
            PlayerHeroEquip.CreateUIModel()
        end
    end

    -- 是否刷新内观和装备框
    local isShowAll = PlayerHeroEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan(pos, state)
        onRefEquipIcon(pos, state)
        return false
    end

    -- 是否刷新只内观
    local isNaikan = PlayerHeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan(pos, state)
    else
        onRefEquipIcon(pos, state)
    end
end

function PlayerHeroEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("H.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function PlayerHeroEquip.InitEquipLayerEvent()
    for _,pos in pairs(PlayerHeroEquip._EquipPosSet) do
        local widget = PlayerHeroEquip.GetEquipPosPanel(pos)
        if widget then
            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = PlayerHeroEquip.GetEquipDataByPos
            widget._RefeshMoveState = PlayerHeroEquip.RefeshMoveState
            widget._OnClickEvent  = PlayerHeroEquip.OnClickEvent
            widget._OnPressEvent  = PlayerHeroEquip.OnClickEvent
            widget._OnDoubleEvent = PlayerHeroEquip.OnDoubleEvent
            
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

                local itemData = PlayerHeroEquip.GetEquipDataByPos(pos)
                if not itemData then
                    return -1
                end

                PlayerHeroEquip.RefeshMoveState(widget, true, itemData.Where)

                SL:CloseItemTips()

                SL:SetItemMoveBegan({
                    from = SL:GetItemGoto().HERO_EQUIP,
                    pos  = touchPos,
                    itemData = itemData,
                    cancelCallBack = function ()
                        PlayerHeroEquip.RefeshMoveState(widget, false, itemData.Where)
                    end
                })
            end
            -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
            GUI:addMouseButtonEvent(widget, {OnSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if SL:IsWinMode() then
                PlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "PlayerHeroEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
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

            local Node = PlayerHeroEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    PlayerHeroEquip.SetSamePosEquip()
end

function PlayerHeroEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not PlayerHeroEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = PlayerHeroEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and PlayerHeroEquip.GetEquipDataByPos(pos) then
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
function PlayerHeroEquip.GetEquipPosPanel(pos)
    return PlayerHeroEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function PlayerHeroEquip.GetEquipPosNode(pos)
    return PlayerHeroEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function PlayerHeroEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function PlayerHeroEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function PlayerHeroEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = PlayerHeroEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        PlayerHeroEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        PlayerHeroEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function PlayerHeroEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("H.EQUIP_POS_DATAS")

    PlayerHeroEquip._feature = {
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

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   PlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    PlayerHeroEquip._feature.hairID = PlayerHeroEquip._playerHairID
    PlayerHeroEquip._feature.embattlesID = SL:GetMetaValue("H.EMBATTLE")
end

-- 额外的装备位置
function PlayerHeroEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(PlayerHeroEquip._EquipPosSet, 14)
        table.insert(PlayerHeroEquip._EquipPosSet, 15)
    else
        GUI:setVisible(PlayerHeroEquip._ui["PanelPos14"], false)
        GUI:setVisible(PlayerHeroEquip._ui["PanelPos15"], false)
        GUI:setVisible(PlayerHeroEquip._ui["Node14"], false)
        GUI:setVisible(PlayerHeroEquip._ui["Node15"], false)
    end
end

function PlayerHeroEquip.InitBestRingsBox()
    if not PlayerHeroEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(2)
    local btn = GUI:getChildByName(PlayerHeroEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerHeroEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = PlayerHeroEquip.IsNaikan(pos) and SL:GetMetaValue("H.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("H.EQUIP_DATA_BY_POS", pos)}
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
function PlayerHeroEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera
    local MakeIndex = data.MakeIndex

    local pos = data.Where
    if PlayerHeroEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end
    
    local equipPanel = PlayerHeroEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    PlayerHeroEquip.SetSamePosEquip()

    local function onRefEquipNaikan()
        if GUIShare.Operator_Add == optType or GUIShare.Operator_Sub == optType or GUIShare.Operator_Change == optType then
            if GUIShare.IsCreateSingleModel then
                _SetFeature(pos, PlayerHeroEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
                PlayerHeroEquip.CreateSingleModelByType(pos)
            else
                PlayerHeroEquip.UpdateModelFeatureData()
                PlayerHeroEquip.CreateUIModel()
            end
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIShare.Operator_Add == optType then
            local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
            PlayerHeroEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIShare.Operator_Sub == optType then
            local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        elseif GUIShare.Operator_Change == optType then
            local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
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
    
    local isShowAll = PlayerHeroEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerHeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 装备状态改变时刷新
function PlayerHeroEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local MakeIndex = data.MakeIndex
    local itemData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    if PlayerHeroEquip.IsNaikan(pos) then
        local dePos = GUIShare.GetDeEquipMappingConfig(pos)
        pos = dePos and dePos or pos
    end

    local equipPanel = PlayerHeroEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state
    
    PlayerHeroEquip.SetSamePosEquip()

    local function onRefEquipNaikan()
        if GUIShare.IsCreateSingleModel then
            _SetFeature(pos, PlayerHeroEquip.GetLooks(SL:GetMetaValue("H.EQUIP_POS_DATAS"), pos))
            PlayerHeroEquip.CreateSingleModelByType(pos)
        else
            PlayerHeroEquip.UpdateModelFeatureData()
            PlayerHeroEquip.CreateUIModel()
        end
    end

    local function onRefEquipIcon()
        local itemNode = PlayerHeroEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex, true)
        PlayerHeroEquip.CreateEquipItem(itemNode, equipData)
    end

    local isShowAll = PlayerHeroEquip.IsShowAll(pos)
    if PlayerHeroEquip.IsShowAll(pos) then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = PlayerHeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 更新生肖框状态
function PlayerHeroEquip.UpdateBestRingsBox(isOpen)
    if not PlayerHeroEquip._BestRingBox then
        return false
    end

    isOpen = isOpen or false

    local btn = GUI:getChildByName(PlayerHeroEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)

    if isOpen then           
        SL:OpenBestRingBoxUI(2)
    else
        GUI:SetWorldTips("首饰盒未开启", GUI:getTouchEndPosition(PlayerHeroEquip._BestRingBox), {x = 0, y = 1})
    end
end

-- 更新所属行会信息
function PlayerHeroEquip.UpdateGuildInfo()
    local textGuildInfo = PlayerHeroEquip._ui["Text_Guildinfo"]
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
    local color = SL:GetMetaValue("H.NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function PlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        local isMoving = SL:GetMetaValue("ITEM_IS_MOVING")
        if isMoving then
            return false
        end
        PlayerHeroEquip.OnOpenItemTips(widget, pos)
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
function PlayerHeroEquip.CloseCallback()
    PlayerHeroEquip.UnRegisterEvent()

    if SL:IsWinMode() then
        for _,pos in pairs(PlayerHeroEquip._EquipPosSet) do
            local widget = PlayerHeroEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "PlayerHeroEquip")
            end
        end

        if PlayerHeroEquip._scheduleID then
            SL:UnSchedule(PlayerHeroEquip._scheduleID)
            PlayerHeroEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function PlayerHeroEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_BEST_RING_BOX_STATE, "PlayerHeroEquip", PlayerHeroEquip.UpdateBestRingsBox)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "PlayerHeroEquip", PlayerHeroEquip.UpdateGuildInfo)
    SL:RegisterLUAEvent(LUA_EVENT_EMBATTLE_CHANGE, "PlayerHeroEquip", PlayerHeroEquip.UpdateEmbattleModel)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "PlayerHeroEquip", PlayerHeroEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerHeroEquip", PlayerHeroEquip.UpdateEquipPanelState)
end

-- 取消事件
function PlayerHeroEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_BEST_RING_BOX_STATE, "PlayerHeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "PlayerHeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EMBATTLE_CHANGE, "PlayerHeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "PlayerHeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerHeroEquip")
end

-- 更新光环
function PlayerHeroEquip.UpdateEmbattleModel()
    PlayerHeroEquip._feature.embattlesID = SL:GetMetaValue("H.EMBATTLE")
    if GUIShare.IsCreateSingleModel then
        PlayerHeroEquip.CreateEmbattle()
    else
        PlayerHeroEquip.CreateUIModel()
    end
end

function PlayerHeroEquip.CreateUIModel()
    local NodeModel = PlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerHeroEquip._playerSex, PlayerHeroEquip._feature, nil, {showHelmet = PlayerHeroEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function PlayerHeroEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        PlayerHeroEquip.CreateNodeModel()
        PlayerHeroEquip.CreateSingleModelByType()
    else
        PlayerHeroEquip.CreateUIModel()
    end
end

-- 创建裸模
function PlayerHeroEquip.CreateNodeModel()
    local NodeModel = PlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = PlayerHeroEquip._feature
    local feature = {
        hairID        = PlayerHeroEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, PlayerHeroEquip._playerSex, feature)
end

function PlayerHeroEquip.CreateSingleModelByType(type)
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

function PlayerHeroEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function PlayerHeroEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.wingsID, effectID = PlayerHeroEquip._feature.wingEffectID})
end

-- 创建衣服
function PlayerHeroEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.clothID, effectID = PlayerHeroEquip._feature.clothEffectID})
end

-- 创建武器
function PlayerHeroEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.weaponID, effectID = PlayerHeroEquip._feature.weaponEffectID})
end

-- 创建盾牌
function PlayerHeroEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.shieldID, effectID = PlayerHeroEquip._feature.shieldEffectID})
end

-- 创建头盔
function PlayerHeroEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.headID, effectID = PlayerHeroEquip._feature.headEffectID})
end

-- 创建面纱
function PlayerHeroEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.veilID, effectID = PlayerHeroEquip._feature.veilEffectID})
end

-- 创建斗笠
function PlayerHeroEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    PlayerHeroEquip.CreateCommonModel(node, type, {ID = PlayerHeroEquip._feature.capID, effectID = PlayerHeroEquip._feature.capEffectID})
end

-- 创建光环
function PlayerHeroEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = PlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    -- 脚下光环
    local embattlesID = (PlayerHeroEquip._feature.embattlesID and next(PlayerHeroEquip._feature.embattlesID)) and PlayerHeroEquip._feature.embattlesID
    PlayerHeroEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end