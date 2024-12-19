LookHeroEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
LookHeroEquip._feature = {
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
    embattlesID     = nil,      -- 光环

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Dress] = function (data)
        LookHeroEquip._feature.clothID = data.ID
        LookHeroEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        LookHeroEquip._feature.weaponID = data.ID
        LookHeroEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        LookHeroEquip._feature.headID = data.ID
        LookHeroEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        LookHeroEquip._feature.capID = data.ID
        LookHeroEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        LookHeroEquip._feature.shieldID = data.ID
        LookHeroEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        LookHeroEquip._feature.veilID = data.ID
        LookHeroEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
LookHeroEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookHeroEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero_look/hero_equip_node_win32" or "hero_look/hero_equip_node")

    LookHeroEquip._ui = GUI:ui_delegate(parent)
    if not LookHeroEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    LookHeroEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookHeroEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.HERO_OTHER)
    -- 性别
    LookHeroEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.HERO_OTHER)

    -- 首饰盒按钮
    local BestRingBox = LookHeroEquip._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function ()
        -- 首饰盒是否开启
        UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.HERO_OTHER)
        GUI:setClickDelay(BestRingBox, 0.3)
    end)

    -- 额外装备位
    LookHeroEquip.InitEquipCells()
    
    -- 初始化首饰盒
    LookHeroEquip.InitBestRingsBox()

    -- 初始化装备框装备
    LookHeroEquip.InitEquipLayer()

    -- 初始化装备事件
    LookHeroEquip.InitEquipLayerEvent()

    -- 行会信息
    LookHeroEquip.UpdateGuildInfo()

    LookHeroEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    LookHeroEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = LookHeroEquip._ui["EquipUI"], index = SLDefine.SUIComponentTable.PlayerEquipB_hero})

    SL:AttachTXTSUI({root = LookHeroEquip._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipBO_hero})
end

-- 初始化装备框装备
function LookHeroEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = LookHeroEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookHeroEquip.IsShowAll(pos)
        local isNaikan = LookHeroEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                LookHeroEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function LookHeroEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not LookHeroEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = true
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function LookHeroEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    LookHeroEquip.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function LookHeroEquip.InitEquipLayerEvent()
    for _,pos in pairs(LookHeroEquip._EquipPosSet) do
        local widget = LookHeroEquip.GetEquipPosPanel(pos)
        if widget then     
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) LookHeroEquip.OnClickEvent() end)

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "LookHeroEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookHeroEquip.OnOpenItemTips)
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

            local Node = LookHeroEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    LookHeroEquip.SetSamePosEquip()
end

function LookHeroEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not LookHeroEquip._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = LookHeroEquip.GetEquipPosPanel(pos)
            if equipPanel then
                if Is == false and GUIFunction:GetEquipDataByPos(pos, nil, EDType) then
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
function LookHeroEquip.GetEquipPosPanel(pos)
    return LookHeroEquip._ui["Panel_pos"..pos]
end

-- 装备位置节点
function LookHeroEquip.GetEquipPosNode(pos)
    return LookHeroEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function LookHeroEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookHeroEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookHeroEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = LookHeroEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        LookHeroEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        LookHeroEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookHeroEquip.UpdateModelFeatureData()
    LookHeroEquip._feature = {
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
        embattlesID     = nil,      -- 光环

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    SetFeature(EquipPosCfg.Equip_Type_Dress,  LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   LookHeroEquip.GetLooks(EquipPosCfg.Equip_Type_Veil))

    LookHeroEquip._feature.hairID = LookHeroEquip._hairID
    LookHeroEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)

end

-- 额外的装备位置
function LookHeroEquip.InitEquipCells()
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(LookPlayerData.GetPlayerUID())
    
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(LookHeroEquip._EquipPosSet, 14)
        table.insert(LookHeroEquip._EquipPosSet, 15)
    else
        GUI:setVisible(LookHeroEquip._ui["Panel_pos14"], false)
        GUI:setVisible(LookHeroEquip._ui["Panel_pos15"], false)
        GUI:setVisible(LookHeroEquip._ui["Node_14"], false)
        GUI:setVisible(LookHeroEquip._ui["Node_15"], false)
    end
end

function LookHeroEquip.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.LookHeroBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    GUI:Image_loadTexture(LookHeroEquip._ui.Image_box, GUIDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(LookHeroEquip._ui.Image_box, true)
    
    local activeState = GUIFunction:GetBestRingsState(EDType)
    if activeState then
        GUI:Image_setGrey(LookHeroEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(LookHeroEquip._ui.Image_box, true)
    end
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function LookHeroEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = LookHeroEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.HERO_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 更新所属行会信息
function LookHeroEquip.UpdateGuildInfo()
    local textGuildInfo = LookHeroEquip._ui["Text_guildinfo"]
    -- 行会数据
    local guildData   = LookPlayerData.GetPlayerGuildName()

    -- 行会名字
    local guildName   = guildData.guildName
    guildName = guildName or ""

    -- 行会官职
    local officalName = LookPlayerData.GetPlayerGuildRankName()

    officalName = officalName or ""

    local str = guildName .. " " .. officalName

    if string.len(str) < 1 then
        GUI:Text_setString(textGuildInfo, "")
        return false
    end
    
    GUI:Text_setString(textGuildInfo, str)
    local color = LookPlayerData.GetPlayerNameColor()
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-- 界面关闭回调
function LookHeroEquip.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipB_hero
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipBO_hero
    })
end

function LookHeroEquip.CreateUIModel()
    local NodeModel = LookHeroEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookHeroEquip._sex, LookHeroEquip._feature, nil, {showHelmet = LookHeroEquip._feature.showHair})
end

LookHeroEquip.main()