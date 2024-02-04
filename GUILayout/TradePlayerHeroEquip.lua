TradePlayerHeroEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
TradePlayerHeroEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () TradePlayerHeroEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () TradePlayerHeroEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () TradePlayerHeroEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () TradePlayerHeroEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () TradePlayerHeroEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () TradePlayerHeroEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () TradePlayerHeroEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () TradePlayerHeroEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        TradePlayerHeroEquip._feature.clothID = data.ID
        TradePlayerHeroEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        TradePlayerHeroEquip._feature.weaponID = data.ID
        TradePlayerHeroEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        TradePlayerHeroEquip._feature.headID = data.ID
        TradePlayerHeroEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        TradePlayerHeroEquip._feature.capID = data.ID
        TradePlayerHeroEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        TradePlayerHeroEquip._feature.shieldID = data.ID
        TradePlayerHeroEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        TradePlayerHeroEquip._feature.veilID = data.ID
        TradePlayerHeroEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        TradePlayerHeroEquip._feature.wingsID = data.ID
        TradePlayerHeroEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
TradePlayerHeroEquip._EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
TradePlayerHeroEquip._SamePos = true

function TradePlayerHeroEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "trade_player/hero_equip_node")

    TradePlayerHeroEquip._ui = GUI:ui_delegate(parent)
    if not TradePlayerHeroEquip._ui then
        return false
    end
    TradePlayerHeroEquip._parent = parent

    -- 发型
    TradePlayerHeroEquip._playerHairID = SL:GetMetaValue("T.H.HAIR")
    -- 性别
    TradePlayerHeroEquip._playerSex = SL:GetMetaValue("T.H.SEX")
    -- 职业
    TradePlayerHeroEquip._playerJob = SL:GetMetaValue("T.H.JOB")

    -- 首饰盒按钮
    local BestRingBox = TradePlayerHeroEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:OpenBestRingBoxUI(22)
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    TradePlayerHeroEquip._BestRingBox = BestRingBox

    -- 额外装备位
    TradePlayerHeroEquip.InitEquipCells()
    
    -- 初始化首饰盒
    TradePlayerHeroEquip.InitBestRingsBox()

    -- 初始化装备框装备
    TradePlayerHeroEquip.InitEquipLayer()

    -- 初始化装备事件
    TradePlayerHeroEquip.InitEquipLayerEvent()

    -- 行会信息
    TradePlayerHeroEquip.UpdateGuildInfo()

    TradePlayerHeroEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    TradePlayerHeroEquip.InitPlayerModel()
end

-- 初始化装备框装备
function TradePlayerHeroEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("T.H.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = TradePlayerHeroEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = TradePlayerHeroEquip.IsShowAll(pos)
        local isNaikan = TradePlayerHeroEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("T.H.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                TradePlayerHeroEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function TradePlayerHeroEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not TradePlayerHeroEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function TradePlayerHeroEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    TradePlayerHeroEquip.OnOpenItemTips(widget, pos)
end

function TradePlayerHeroEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("T.H.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function TradePlayerHeroEquip.InitEquipLayerEvent()
    for _,pos in pairs(TradePlayerHeroEquip._EquipPosSet) do
        local widget = TradePlayerHeroEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                TradePlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "TradePlayerHeroEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = TradePlayerHeroEquip.GetEquipDataByPos
            widget._OnClickEvent  = TradePlayerHeroEquip.OnClickEvent

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

            local Node = TradePlayerHeroEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    TradePlayerHeroEquip.SetSamePosEquip()
end

function TradePlayerHeroEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not TradePlayerHeroEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = TradePlayerHeroEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and TradePlayerHeroEquip.GetEquipDataByPos(pos) then
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
function TradePlayerHeroEquip.GetEquipPosPanel(pos)
    return TradePlayerHeroEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function TradePlayerHeroEquip.GetEquipPosNode(pos)
    return TradePlayerHeroEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function TradePlayerHeroEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function TradePlayerHeroEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = TradePlayerHeroEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("T.H.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        TradePlayerHeroEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        TradePlayerHeroEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function TradePlayerHeroEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("T.H.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   TradePlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    TradePlayerHeroEquip._feature.hairID = TradePlayerHeroEquip._playerHairID
    TradePlayerHeroEquip._feature.embattlesID = SL:GetMetaValue("T.H.EMBATTLE")
end

-- 额外的装备位置
function TradePlayerHeroEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(TradePlayerHeroEquip._EquipPosSet, 14)
        table.insert(TradePlayerHeroEquip._EquipPosSet, 15)
    else
        GUI:setVisible(TradePlayerHeroEquip._ui["PanelPos14"], false)
        GUI:setVisible(TradePlayerHeroEquip._ui["PanelPos15"], false)
        GUI:setVisible(TradePlayerHeroEquip._ui["Node14"], false)
        GUI:setVisible(TradePlayerHeroEquip._ui["Node15"], false)
    end
end

function TradePlayerHeroEquip.InitBestRingsBox()
    if not TradePlayerHeroEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(22)
    local btn = GUI:getChildByName(TradePlayerHeroEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function TradePlayerHeroEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = TradePlayerHeroEquip.IsNaikan(pos) and SL:GetMetaValue("T.H.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("T.H.EQUIP_DATA_BY_POS", pos)}
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
-- 更新所属行会信息
function TradePlayerHeroEquip.UpdateGuildInfo()
    local textGuildInfo = TradePlayerHeroEquip._ui["Text_Guildinfo"]
    -- 行会数据
    local guildData   = SL:GetMetaValue("T.H.GUILD_INFO")

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
    local color = SL:GetMetaValue("T.H.NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function TradePlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        TradePlayerHeroEquip.OnOpenItemTips(widget, pos)
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
function TradePlayerHeroEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(TradePlayerHeroEquip._EquipPosSet) do
            local widget = TradePlayerHeroEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "TradePlayerHeroEquip")
            end
        end

        if TradePlayerHeroEquip._scheduleID then
            SL:UnSchedule(TradePlayerHeroEquip._scheduleID)
            TradePlayerHeroEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroEquip.CreateUIModel()
    local NodeModel = TradePlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, TradePlayerHeroEquip._playerSex, TradePlayerHeroEquip._feature, nil, {showHelmet = TradePlayerHeroEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerHeroEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        TradePlayerHeroEquip.CreateNodeModel()
        TradePlayerHeroEquip.CreateSingleModelByType()
    else
        TradePlayerHeroEquip.CreateUIModel()
    end
end

-- 创建裸模
function TradePlayerHeroEquip.CreateNodeModel()
    local NodeModel = TradePlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = TradePlayerHeroEquip._feature
    local feature = {
        hairID        = TradePlayerHeroEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, TradePlayerHeroEquip._playerSex, feature)
end

function TradePlayerHeroEquip.CreateSingleModelByType(type)
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

function TradePlayerHeroEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function TradePlayerHeroEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.wingsID, effectID = TradePlayerHeroEquip._feature.wingEffectID})
end

-- 创建衣服
function TradePlayerHeroEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.clothID, effectID = TradePlayerHeroEquip._feature.clothEffectID})
end

-- 创建武器
function TradePlayerHeroEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.weaponID, effectID = TradePlayerHeroEquip._feature.weaponEffectID})
end

-- 创建盾牌
function TradePlayerHeroEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.shieldID, effectID = TradePlayerHeroEquip._feature.shieldEffectID})
end

-- 创建头盔
function TradePlayerHeroEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.headID, effectID = TradePlayerHeroEquip._feature.headEffectID})
end

-- 创建面纱
function TradePlayerHeroEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.veilID, effectID = TradePlayerHeroEquip._feature.veilEffectID})
end

-- 创建斗笠
function TradePlayerHeroEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerHeroEquip.CreateCommonModel(node, type, {ID = TradePlayerHeroEquip._feature.capID, effectID = TradePlayerHeroEquip._feature.capEffectID})
end

-- 创建光环
function TradePlayerHeroEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = TradePlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    local embattlesID = (TradePlayerHeroEquip._feature.embattlesID and next(TradePlayerHeroEquip._feature.embattlesID)) and TradePlayerHeroEquip._feature.embattlesID
    TradePlayerHeroEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end