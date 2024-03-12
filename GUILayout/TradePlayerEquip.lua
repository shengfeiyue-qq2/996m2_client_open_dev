TradePlayerEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
TradePlayerEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () TradePlayerEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () TradePlayerEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () TradePlayerEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () TradePlayerEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () TradePlayerEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () TradePlayerEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () TradePlayerEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () TradePlayerEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        TradePlayerEquip._feature.clothID = data.ID
        TradePlayerEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        TradePlayerEquip._feature.weaponID = data.ID
        TradePlayerEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        TradePlayerEquip._feature.headID = data.ID
        TradePlayerEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        TradePlayerEquip._feature.capID = data.ID
        TradePlayerEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        TradePlayerEquip._feature.shieldID = data.ID
        TradePlayerEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        TradePlayerEquip._feature.veilID = data.ID
        TradePlayerEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        TradePlayerEquip._feature.wingsID = data.ID
        TradePlayerEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
TradePlayerEquip._SamePos = true

function TradePlayerEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "trade_player/player_equip_node")

    TradePlayerEquip._ui = GUI:ui_delegate(parent)
    if not TradePlayerEquip._ui then
        return false
    end
    TradePlayerEquip._parent = parent

    TradePlayerEquip._EquipPosSet = EquipPosSet

    -- 发型
    TradePlayerEquip._playerHairID = SL:GetMetaValue("T.M.HAIR")
    -- 性别
    TradePlayerEquip._playerSex = SL:GetMetaValue("T.M.SEX")
    -- 职业
    TradePlayerEquip._playerJob = SL:GetMetaValue("T.M.JOB")

    -- 首饰盒按钮
    local BestRingBox = TradePlayerEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:OpenBestRingBoxUI(21)
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    TradePlayerEquip._BestRingBox = BestRingBox

    -- 额外装备位
    TradePlayerEquip.InitEquipCells()
    
    -- 初始化首饰盒
    TradePlayerEquip.InitBestRingsBox()

    -- 初始化装备框装备
    TradePlayerEquip.InitEquipLayer()

    -- 初始化装备事件
    TradePlayerEquip.InitEquipLayerEvent()

    -- 行会信息
    TradePlayerEquip.UpdateGuildInfo()

    TradePlayerEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    TradePlayerEquip.InitPlayerModel()
end

-- 初始化装备框装备
function TradePlayerEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = TradePlayerEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = TradePlayerEquip.IsShowAll(pos)
        local isNaikan = TradePlayerEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                TradePlayerEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function TradePlayerEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not TradePlayerEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().PALYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function TradePlayerEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    TradePlayerEquip.OnOpenItemTips(widget, pos)
end

function TradePlayerEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("T.M.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function TradePlayerEquip.InitEquipLayerEvent()
    for _,pos in pairs(TradePlayerEquip._EquipPosSet) do
        local widget = TradePlayerEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                TradePlayerEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "TradePlayerEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().PALYER_EQUIP
            widget._GetEquipDataByPos  = TradePlayerEquip.GetEquipDataByPos
            widget._OnClickEvent  = TradePlayerEquip.OnClickEvent
            
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

            local Node = TradePlayerEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    TradePlayerEquip.SetSamePosEquip()
end

function TradePlayerEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not TradePlayerEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = TradePlayerEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and TradePlayerEquip.GetEquipDataByPos(pos) then
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
function TradePlayerEquip.GetEquipPosPanel(pos)
    return TradePlayerEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function TradePlayerEquip.GetEquipPosNode(pos)
    return TradePlayerEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function TradePlayerEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function TradePlayerEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = TradePlayerEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("T.M.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        TradePlayerEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        TradePlayerEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function TradePlayerEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("T.M.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   TradePlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    TradePlayerEquip._feature.hairID = TradePlayerEquip._playerHairID
    TradePlayerEquip._feature.embattlesID = SL:GetMetaValue("T.M.EMBATTLE")
end

-- 额外的装备位置
function TradePlayerEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(TradePlayerEquip._EquipPosSet, 14)
        table.insert(TradePlayerEquip._EquipPosSet, 15)
    else
        GUI:setVisible(TradePlayerEquip._ui["PanelPos14"], false)
        GUI:setVisible(TradePlayerEquip._ui["PanelPos15"], false)
        GUI:setVisible(TradePlayerEquip._ui["Node14"], false)
        GUI:setVisible(TradePlayerEquip._ui["Node15"], false)
    end
end

function TradePlayerEquip.InitBestRingsBox()
    if not TradePlayerEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(21)
    local btn = GUI:getChildByName(TradePlayerEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function TradePlayerEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = TradePlayerEquip.IsNaikan(pos) and SL:GetMetaValue("T.M.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("T.M.EQUIP_DATA_BY_POS", pos)}
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
-- 更新所属行会信息
function TradePlayerEquip.UpdateGuildInfo()
    local textGuildInfo = TradePlayerEquip._ui["Text_Guildinfo"]
    -- 行会数据
    local guildData   = SL:GetMetaValue("T.M.GUILD_INFO")

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
    local color = SL:GetMetaValue("T.M.NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function TradePlayerEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        TradePlayerEquip.OnOpenItemTips(widget, pos)
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
function TradePlayerEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(TradePlayerEquip._EquipPosSet) do
            local widget = TradePlayerEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "TradePlayerEquip")
            end
        end

        if TradePlayerEquip._scheduleID then
            SL:UnSchedule(TradePlayerEquip._scheduleID)
            TradePlayerEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerEquip.CreateUIModel()
    local NodeModel = TradePlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, TradePlayerEquip._playerSex, TradePlayerEquip._feature, nil, {showHelmet = TradePlayerEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function TradePlayerEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        TradePlayerEquip.CreateNodeModel()
        TradePlayerEquip.CreateSingleModelByType()
    else
        TradePlayerEquip.CreateUIModel()
    end
end

-- 创建裸模
function TradePlayerEquip.CreateNodeModel()
    local NodeModel = TradePlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = TradePlayerEquip._feature
    local feature = {
        hairID        = TradePlayerEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, TradePlayerEquip._playerSex, feature)
end

function TradePlayerEquip.CreateSingleModelByType(type)
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

function TradePlayerEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function TradePlayerEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.wingsID, effectID = TradePlayerEquip._feature.wingEffectID})
end

-- 创建衣服
function TradePlayerEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.clothID, effectID = TradePlayerEquip._feature.clothEffectID})
end

-- 创建武器
function TradePlayerEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.weaponID, effectID = TradePlayerEquip._feature.weaponEffectID})
end

-- 创建盾牌
function TradePlayerEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.shieldID, effectID = TradePlayerEquip._feature.shieldEffectID})
end

-- 创建头盔
function TradePlayerEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.headID, effectID = TradePlayerEquip._feature.headEffectID})
end

-- 创建面纱
function TradePlayerEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.veilID, effectID = TradePlayerEquip._feature.veilEffectID})
end

-- 创建斗笠
function TradePlayerEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    TradePlayerEquip.CreateCommonModel(node, type, {ID = TradePlayerEquip._feature.capID, effectID = TradePlayerEquip._feature.capEffectID})
end

-- 创建光环
function TradePlayerEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = TradePlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    local embattlesID = (TradePlayerEquip._feature.embattlesID and next(TradePlayerEquip._feature.embattlesID)) and TradePlayerEquip._feature.embattlesID
    TradePlayerEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end