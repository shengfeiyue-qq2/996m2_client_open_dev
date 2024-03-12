LookPlayerEquip = {}

local _EquipPosCfg = GUIShare.EquipPosTypeConfig
LookPlayerEquip._feature = {
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
    [_EquipPosCfg.Equip_Type_Wing]     = {order = 3,  scale = 1, create = function () LookPlayerEquip.CreateWings()    end},
    [_EquipPosCfg.Equip_Type_Dress]    = {order = 6,  scale = 1, create = function () LookPlayerEquip.CreateDress()    end},
    [_EquipPosCfg.Equip_Type_Weapon]   = {order = 9,  scale = 1, create = function () LookPlayerEquip.CreateWeapon()   end},
    [_EquipPosCfg.Equip_Type_Veil]     = {order = 13, scale = 1, create = function () LookPlayerEquip.CreateVeil()     end},
    [_EquipPosCfg.Equip_Type_Helmet]   = {order = 16, scale = 1, create = function () LookPlayerEquip.CreateHelmet()   end},
    [_EquipPosCfg.Equip_Type_Cap]      = {order = 16, scale = 1, create = function () LookPlayerEquip.CreateCap()      end},
    [_EquipPosCfg.Equip_Type_Shield]   = {order = 19, scale = 1, create = function () LookPlayerEquip.CreateShield()   end},
    [_EquipPosCfg.Equip_Type_Embattle] = {order = -1, scale = 1, create = function () LookPlayerEquip.CreateEmbattle() end},
}

local Typefunc = {
    [_EquipPosCfg.Equip_Type_Dress] = function (data)
        LookPlayerEquip._feature.clothID = data.ID
        LookPlayerEquip._feature.clothEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Weapon] = function (data)
        LookPlayerEquip._feature.weaponID = data.ID
        LookPlayerEquip._feature.weaponEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Helmet] = function (data)
        LookPlayerEquip._feature.headID = data.ID
        LookPlayerEquip._feature.headEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Cap] = function (data)
        LookPlayerEquip._feature.capID = data.ID
        LookPlayerEquip._feature.capEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Shield] = function (data)
        LookPlayerEquip._feature.shieldID = data.ID
        LookPlayerEquip._feature.shieldEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Veil] = function (data)
        LookPlayerEquip._feature.veilID = data.ID
        LookPlayerEquip._feature.veilEffectID = data.effectID
    end,
    [_EquipPosCfg.Equip_Type_Wing] = function (data)
        LookPlayerEquip._feature.wingsID = data.ID
        LookPlayerEquip._feature.wingEffectID = data.effectID
    end
}
local _SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
LookPlayerEquip._SamePos = true

function LookPlayerEquip.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "look_player/player_equip_node")

    LookPlayerEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerEquip._ui then
        return false
    end
    LookPlayerEquip._parent = parent

    LookPlayerEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerEquip._playerHairID = SL:GetMetaValue("L.HAIR")
    -- 性别
    LookPlayerEquip._playerSex = SL:GetMetaValue("L.SEX")
    -- 职业
    LookPlayerEquip._playerJob = SL:GetMetaValue("L.JOB")

    -- 首饰盒按钮
    local BestRingBox = LookPlayerEquip._ui["BestRingBox"]
    local isVisible = SL:GetServerOption(GUIShare.ServerOption.SERVER_OPTION_SNDAITEMBOX) == 1
    GUI:setVisible(BestRingBox, isVisible)

    local btnIcon = GUI:getChildByName(BestRingBox, "BtnIcon")
    GUI:addOnClickEvent(btnIcon, function ()
        SL:OpenBestRingBoxUI(11)
        GUI:setClickDelay(btnIcon, 0.3)
    end)
    LookPlayerEquip._BestRingBox = BestRingBox

    -- 额外装备位
    LookPlayerEquip.InitEquipCells()
    
    -- 初始化首饰盒
    LookPlayerEquip.InitBestRingsBox()

    -- 初始化装备框装备
    LookPlayerEquip.InitEquipLayer()

    -- 初始化装备事件
    LookPlayerEquip.InitEquipLayerEvent()

    -- 行会信息
    LookPlayerEquip.UpdateGuildInfo()

    LookPlayerEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookPlayerEquip.InitPlayerModel()
end

-- 初始化装备框装备
function LookPlayerEquip.InitEquipLayer()
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")
    for pos, data in pairs(equipPosData) do
        local itemNode = LookPlayerEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookPlayerEquip.IsShowAll(pos)
        local isNaikan = LookPlayerEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", data.MakeIndex)
            if equipData then       
                LookPlayerEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookPlayerEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not LookPlayerEquip.IsShowAll(data.Where)
    info.from       = SL:GetItemForm().PALYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    return GUI:ItemShow_Create(parent, "item", -30, -30, info)
end

function LookPlayerEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    LookPlayerEquip.OnOpenItemTips(widget, pos)
end

function LookPlayerEquip.GetEquipDataByPos(pos)
    return SL:GetMetaValue("L.EQUIP_DATA", pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookPlayerEquip._EquipPosSet) do
        local widget = LookPlayerEquip.GetEquipPosPanel(pos)
        if widget then
            if SL:IsWinMode() then
                LookPlayerEquip.OnRegisterMouseMoveEvent(widget, pos)

                -- 鼠标放在装备框上滚动事件
                SL:RegisterWndEvent(widget, "LookPlayerEquip", WND_EVENT_MOUSE_WHEEL, function (data) 
                    if ItemTips and ItemTips.OnMouseScroll then
                        ItemTips.OnMouseScroll(data)
                    end
                end)
            end

            widget._pos           = pos
            widget._itemFrom      = SL:GetItemForm().PALYER_EQUIP
            widget._GetEquipDataByPos  = LookPlayerEquip.GetEquipDataByPos
            widget._OnClickEvent  = LookPlayerEquip.OnClickEvent
            
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

            local Node = LookPlayerEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    LookPlayerEquip.SetSamePosEquip()
end

function LookPlayerEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not LookPlayerEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIShare.EquipPosMapping or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = LookPlayerEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and LookPlayerEquip.GetEquipDataByPos(pos) then
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
function LookPlayerEquip.GetEquipPosPanel(pos)
    return LookPlayerEquip._ui["PanelPos"..pos]
end

-- 装备位置节点
function LookPlayerEquip.GetEquipPosNode(pos)
    return LookPlayerEquip._ui["Node"..pos]
end

-- 该部位是否展示内观
function LookPlayerEquip.IsNaikan(pos)
    return GUIShare.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookPlayerEquip.IsShowAll(pos)
    return GUIShare.EquipAllShow and GUIShare.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerEquip.GetLooks(equipPosData, equipPos)
    if not (equipPos and equipPosData[equipPos]) then
        return {}
    end

    -- 装备唯一ID
    local MakeIndex = equipPosData[equipPos].MakeIndex

    -- 是否是内观
    local isNaikan = LookPlayerEquip.IsNaikan(equipPos)
    if not isNaikan then
        return {}
    end

    local data = {}

    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = SL:GetMetaValue("L.EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
    if equipPos == _EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookPlayerEquip._feature.showNodeModel = false
    end

    if equipPos == _EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        LookPlayerEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookPlayerEquip.UpdateModelFeatureData()
    -- 装备位置数据--{pos = MakeIndex}
    local equipPosData = SL:GetMetaValue("L.EQUIP_POS_DATAS")

    _SetFeature(_EquipPosCfg.Equip_Type_Dress,  LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Dress))
    _SetFeature(_EquipPosCfg.Equip_Type_Helmet, LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Helmet))
    _SetFeature(_EquipPosCfg.Equip_Type_Weapon, LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Weapon))
    _SetFeature(_EquipPosCfg.Equip_Type_Cap,    LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Cap))
    _SetFeature(_EquipPosCfg.Equip_Type_Shield, LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Shield))
    _SetFeature(_EquipPosCfg.Equip_Type_Veil,   LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Veil))
    _SetFeature(_EquipPosCfg.Equip_Type_Wing,   LookPlayerEquip.GetLooks(equipPosData, _EquipPosCfg.Equip_Type_Wing))

    LookPlayerEquip._feature.hairID = LookPlayerEquip._playerHairID
    LookPlayerEquip._feature.embattlesID = SL:GetMetaValue("L.EMBATTLE")
end

-- 额外的装备位置
function LookPlayerEquip.InitEquipCells()
    local showExtra = SL:GetServerOption(GUIShare.ServerOption.EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(LookPlayerEquip._EquipPosSet, 14)
        table.insert(LookPlayerEquip._EquipPosSet, 15)
    else
        GUI:setVisible(LookPlayerEquip._ui["PanelPos14"], false)
        GUI:setVisible(LookPlayerEquip._ui["PanelPos15"], false)
        GUI:setVisible(LookPlayerEquip._ui["Node14"], false)
        GUI:setVisible(LookPlayerEquip._ui["Node15"], false)
    end
end

function LookPlayerEquip.InitBestRingsBox()
    if not LookPlayerEquip._BestRingBox then
        return false
    end
    local isOpen = SL:GetBestRingsOpenState(12)
    local btn = GUI:getChildByName(LookPlayerEquip._BestRingBox, "BtnIcon")
    GUI:Button_setGrey(btn, not isOpen)
    GUI:setTouchEnabled(btn, isOpen)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookPlayerEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookPlayerEquip.IsNaikan(pos) and SL:GetMetaValue("L.EQUIP_DATA_LIST_BY_POS", pos) or {SL:GetMetaValue("L.EQUIP_DATA_BY_POS", pos)}
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
    data.from = SL:GetItemForm().PALYER_EQUIP

    SL:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 更新所属行会信息
function LookPlayerEquip.UpdateGuildInfo()
    local textGuildInfo = LookPlayerEquip._ui["Text_Guildinfo"]
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
function LookPlayerEquip.OnRegisterMouseMoveEvent(widget, pos)
    local function onShowItemTips()
        LookPlayerEquip.OnOpenItemTips(widget, pos)
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
function LookPlayerEquip.CloseCallback()
    if SL:IsWinMode() then
        for _,pos in pairs(LookPlayerEquip._EquipPosSet) do
            local widget = LookPlayerEquip.GetEquipPosPanel(pos)
            if widget then
                SL:UnRegisterWndEvent(widget, "LookPlayerEquip")
            end
        end

        if LookPlayerEquip._scheduleID then
            SL:UnSchedule(LookPlayerEquip._scheduleID)
            LookPlayerEquip._scheduleID = nil
        end
    end
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerEquip.CreateUIModel()
    local NodeModel = LookPlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerEquip._playerSex, LookPlayerEquip._feature, nil, {showHelmet = LookPlayerEquip._feature.showHair})
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerEquip.InitPlayerModel()
    if GUIShare.IsCreateSingleModel then
        LookPlayerEquip.CreateNodeModel()
        LookPlayerEquip.CreateSingleModelByType()
    else
        LookPlayerEquip.CreateUIModel()
    end
end

-- 创建裸模
function LookPlayerEquip.CreateNodeModel()
    local NodeModel = LookPlayerEquip._ui["NodePlayerModel"]
    GUI:removeAllChildren(NodeModel)

    local features = LookPlayerEquip._feature
    local feature = {
        hairID        = LookPlayerEquip._playerHairID,
        showHair      = features.showHair,
        showNodeModel = features.showNodeModel
    }
    GUI:UINodeModel_Create(NodeModel, "NodeModel", 0, 0, LookPlayerEquip._playerSex, feature)
end

function LookPlayerEquip.CreateSingleModelByType(type)
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

function LookPlayerEquip.CreateCommonModel(node, type, feature, x, y)
    GUI:removeAllChildren(node)

    local size = GUI:getContentSize(node)
    local x = x or size.width  / 2
    local y = y or size.height / 2
    GUI:UIModelCell_Create(node, "ID", x, y, type, feature, TypeCfg[type].scale, TypeCfg[type].order)
end

-- 创建翅膀
function LookPlayerEquip.CreateWings()
    local type = _EquipPosCfg.Equip_Type_Wing
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.wingsID, effectID = LookPlayerEquip._feature.wingEffectID})
end

-- 创建衣服
function LookPlayerEquip.CreateDress()
    local type = _EquipPosCfg.Equip_Type_Dress
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.clothID, effectID = LookPlayerEquip._feature.clothEffectID})
end

-- 创建武器
function LookPlayerEquip.CreateWeapon()
    local type = _EquipPosCfg.Equip_Type_Weapon
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.weaponID, effectID = LookPlayerEquip._feature.weaponEffectID})
end

-- 创建盾牌
function LookPlayerEquip.CreateShield()
    local type = _EquipPosCfg.Equip_Type_Shield
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.shieldID, effectID = LookPlayerEquip._feature.shieldEffectID})
end

-- 创建头盔
function LookPlayerEquip.CreateHelmet()
    local type = _EquipPosCfg.Equip_Type_Helmet
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.headID, effectID = LookPlayerEquip._feature.headEffectID})
end

-- 创建面纱
function LookPlayerEquip.CreateVeil()
    local type = _EquipPosCfg.Equip_Type_Veil
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.veilID, effectID = LookPlayerEquip._feature.veilEffectID})
end

-- 创建斗笠
function LookPlayerEquip.CreateCap()
    local type = _EquipPosCfg.Equip_Type_Cap
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    LookPlayerEquip.CreateCommonModel(node, type, {ID = LookPlayerEquip._feature.capID, effectID = LookPlayerEquip._feature.capEffectID})
end

-- 创建光环
function LookPlayerEquip.CreateEmbattle()
    local type = _EquipPosCfg.Equip_Type_Embattle
    local node = LookPlayerEquip.GetEquipPosPanel(type)
    if not node then
        return false
    end
    local embattlesID = (LookPlayerEquip._feature.embattlesID and next(LookPlayerEquip._feature.embattlesID)) and LookPlayerEquip._feature.embattlesID
    LookPlayerEquip.CreateCommonModel(node, type, {effectID = embattlesID})
end