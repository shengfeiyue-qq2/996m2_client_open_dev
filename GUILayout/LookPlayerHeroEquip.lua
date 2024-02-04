LookPlayerHeroEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
LookPlayerHeroEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () LookPlayerHeroEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () LookPlayerHeroEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () LookPlayerHeroEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () LookPlayerHeroEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () LookPlayerHeroEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () LookPlayerHeroEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () LookPlayerHeroEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () LookPlayerHeroEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        LookPlayerHeroEquip._feature.clothID = data.ID
        LookPlayerHeroEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        LookPlayerHeroEquip._feature.weaponID = data.ID
        LookPlayerHeroEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        LookPlayerHeroEquip._feature.headID = data.ID
        LookPlayerHeroEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        LookPlayerHeroEquip._feature.capID = data.ID
        LookPlayerHeroEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        LookPlayerHeroEquip._feature.shieldID = data.ID
        LookPlayerHeroEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        LookPlayerHeroEquip._feature.veilID = data.ID
        LookPlayerHeroEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        LookPlayerHeroEquip._feature.wingsID = data.ID
        LookPlayerHeroEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
LookPlayerHeroEquip._SamePos = true

function LookPlayerHeroEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/hero_equip_node")

    LookPlayerHeroEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerHeroEquip._ui then
        return false
    end
    LookPlayerHeroEquip._parent = parent

    LookPlayerHeroEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerHeroEquip._playerHairID = SL:GetMetaValue("L.HAIR")
    -- 性别
    LookPlayerHeroEquip._playerSex = SL:GetMetaValue("L.SEX")
    -- 职业
    LookPlayerHeroEquip._playerJob = SL:GetMetaValue("L.JOB")

    -- 首饰盒按钮
    local BestRingBox = LookPlayerHeroEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:OpenBestRingBoxUI(12)
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    LookPlayerHeroEquip._BestRingBox = BestRingBox

    -- 额外装备位
    LookPlayerHeroEquip.InitEquipCells()
    
    -- 初始化首饰盒
    LookPlayerHeroEquip.InitBestRingsBox()

    -- 初始化装备框装备
    LookPlayerHeroEquip.InitEquipLayer()

    -- 初始化装备事件
    LookPlayerHeroEquip.InitEquipLayerEvent()

    -- 行会信息
    LookPlayerHeroEquip.UpdateGuildInfo()

    LookPlayerHeroEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookPlayerHeroEquip.InitPlayerModel()
end

-- 初始化装备框装备
function LookPlayerHeroEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = LookPlayerHeroEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookPlayerHeroEquip.IsShowAll(pos)
        local isNaikan = LookPlayerHeroEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                LookPlayerHeroEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookPlayerHeroEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not LookPlayerHeroEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function LookPlayerHeroEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerHeroEquip.OnOpenItemTips(widget, pos)
end

function LookPlayerHeroEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerHeroEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookPlayerHeroEquip._EquipPosSet) do
        local widget = LookPlayerHeroEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                LookPlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "LookPlayerHeroEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().HERO_EQUIP
            widget._GetEquipDataByPos  = LookPlayerHeroEquip.GetEquipDataByPos
            widget._OnClickEvent  = LookPlayerHeroEquip.OnClickEvent
            
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

            local Node = LookPlayerHeroEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    LookPlayerHeroEquip.SetSamePosEquip()
end

function LookPlayerHeroEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not LookPlayerHeroEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = LookPlayerHeroEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and LookPlayerHeroEquip.GetEquipDataByPos(pos) then
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
function LookPlayerHeroEquip.GetEquipPosPanel(pos)
    return LookPlayerHeroEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function LookPlayerHeroEquip.GetEquipPosNode(pos)
    return LookPlayerHeroEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function LookPlayerHeroEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookPlayerHeroEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = LookPlayerHeroEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookPlayerHeroEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        LookPlayerHeroEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookPlayerHeroEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   LookPlayerHeroEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    LookPlayerHeroEquip._feature.hairID = LookPlayerHeroEquip._playerHairID
    LookPlayerHeroEquip._feature.embattlesID = SL:GetMetaValue("L.EMBATTLE")
end

-- 额外的装备位置
function LookPlayerHeroEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(LookPlayerHeroEquip._EquipPosSet, 14)
        table.insert(LookPlayerHeroEquip._EquipPosSet, 15)
    else
        GUI:setVisible(LookPlayerHeroEquip._ui["PanelPos14"], false)
        GUI:setVisible(LookPlayerHeroEquip._ui["PanelPos15"], false)
        GUI:setVisible(LookPlayerHeroEquip._ui["Node14"], false)
        GUI:setVisible(LookPlayerHeroEquip._ui["Node15"], false)
    end
end

function LookPlayerHeroEquip.InitBestRingsBox()
    if not LookPlayerHeroEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(11)
    local btn = GUI:getChildByName(LookPlayerHeroEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerHeroEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookPlayerHeroEquip.IsNaikan(pos) and SL:GetMetaValue("L.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("L.EQUIP_DATA_BY_POS", pos)}
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
    data.from = SL:GetItemForm().HERO_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 更新所属行会信息
function LookPlayerHeroEquip.UpdateGuildInfo()
    local textGuildInfo = LookPlayerHeroEquip._ui["Text_Guildinfo"]
    -- 行会数据
    local guildData   = SL:GetMetaValue("L.GUILD_INFO")

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
    local color = SL:GetMetaValue("L.NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-----------------------------------------------------------------------------------------------------------------
-- 注册鼠标经过事件
function LookPlayerHeroEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        LookPlayerHeroEquip.OnOpenItemTips(widget, pos)
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
function LookPlayerHeroEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(LookPlayerHeroEquip._EquipPosSet) do
            local widget = LookPlayerHeroEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "LookPlayerHeroEquip")
            end
        end

        if LookPlayerHeroEquip._scheduleID then
            SL:UnSchedule(LookPlayerHeroEquip._scheduleID)
            LookPlayerHeroEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroEquip.CreateUIModel()
    local NodeModel = LookPlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerHeroEquip._playerSex, LookPlayerHeroEquip._feature, nil, {showHelmet = LookPlayerHeroEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerHeroEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        LookPlayerHeroEquip.CreateNodeModel()
        LookPlayerHeroEquip.CreateSingleModelByType()
    else
        LookPlayerHeroEquip.CreateUIModel()
    end
end

-- 创建裸模
function LookPlayerHeroEquip.CreateNodeModel()
    local NodeModel = LookPlayerHeroEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = LookPlayerHeroEquip._feature
    local feature = {
        hairID        = LookPlayerHeroEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, LookPlayerHeroEquip._playerSex, feature)
end

function LookPlayerHeroEquip.CreateSingleModelByType(type)
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

function LookPlayerHeroEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function LookPlayerHeroEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.wingsID, effectID = LookPlayerHeroEquip._feature.wingEffectID})
end

-- 创建衣服
function LookPlayerHeroEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.clothID, effectID = LookPlayerHeroEquip._feature.clothEffectID})
end

-- 创建武器
function LookPlayerHeroEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.weaponID, effectID = LookPlayerHeroEquip._feature.weaponEffectID})
end

-- 创建盾牌
function LookPlayerHeroEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.shieldID, effectID = LookPlayerHeroEquip._feature.shieldEffectID})
end

-- 创建头盔
function LookPlayerHeroEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.headID, effectID = LookPlayerHeroEquip._feature.headEffectID})
end

-- 创建面纱
function LookPlayerHeroEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.veilID, effectID = LookPlayerHeroEquip._feature.veilEffectID})
end

-- 创建斗笠
function LookPlayerHeroEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerHeroEquip.CreateCommonModel(node, type, {ID = LookPlayerHeroEquip._feature.capID, effectID = LookPlayerHeroEquip._feature.capEffectID})
end

-- 创建光环
function LookPlayerHeroEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = LookPlayerHeroEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    local embattlesID = (LookPlayerHeroEquip._feature.embattlesID and next(LookPlayerHeroEquip._feature.embattlesID)) and LookPlayerHeroEquip._feature.embattlesID
    LookPlayerHeroEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end