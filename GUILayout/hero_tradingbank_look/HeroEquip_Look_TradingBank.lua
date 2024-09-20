HeroEquip_Look_TradingBank = {}

local EquipPosCfg = GUIDefine.EquipPosUI
HeroEquip_Look_TradingBank._feature = {
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
        HeroEquip_Look_TradingBank._feature.clothID = data.ID
        HeroEquip_Look_TradingBank._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        HeroEquip_Look_TradingBank._feature.weaponID = data.ID
        HeroEquip_Look_TradingBank._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        HeroEquip_Look_TradingBank._feature.headID = data.ID
        HeroEquip_Look_TradingBank._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        HeroEquip_Look_TradingBank._feature.capID = data.ID
        HeroEquip_Look_TradingBank._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        HeroEquip_Look_TradingBank._feature.shieldID = data.ID
        HeroEquip_Look_TradingBank._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        HeroEquip_Look_TradingBank._feature.veilID = data.ID
        HeroEquip_Look_TradingBank._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
HeroEquip_Look_TradingBank._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.TRADE_HEROEQUIP


function HeroEquip_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_equip_node")

    HeroEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroEquip_Look_TradingBank._ui then
        return false
    end

    HeroEquip_Look_TradingBank._EquipPosSet = EquipPosSet

    -- 发型
    HeroEquip_Look_TradingBank._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.TRADE_HERO)
    -- 性别
    HeroEquip_Look_TradingBank._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.TRADE_HERO)

    -- 首饰盒按钮
    local BestRingBox = HeroEquip_Look_TradingBank._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function ()
        -- 首饰盒是否开启
        UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.TRADE_HERO)
        GUI:setClickDelay(BestRingBox, 0.3)
    end)

    -- 额外装备位
    HeroEquip_Look_TradingBank.InitEquipCells()
    
    -- 初始化首饰盒
    HeroEquip_Look_TradingBank.InitBestRingsBox()

    -- 初始化装备框装备
    HeroEquip_Look_TradingBank.InitEquipLayer()

    -- 初始化装备事件
    HeroEquip_Look_TradingBank.InitEquipLayerEvent()

    -- 行会信息
    HeroEquip_Look_TradingBank.UpdateGuildInfo()

    HeroEquip_Look_TradingBank.UpdateModelFeatureData()

    -- 初始化装备内观
    HeroEquip_Look_TradingBank.CreateUIModel()

    if SL:GetValue("GAME_DATA","TradingBankHideSUI") ~= 1 then 
        -- 自定义组件挂接
        SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerEquipB_hero})

        SL:AttachTXTSUI({root = HeroEquip_Look_TradingBank._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipBO_hero})
    end
end

-- 初始化装备框装备
function HeroEquip_Look_TradingBank.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = HeroEquip_Look_TradingBank.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = HeroEquip_Look_TradingBank.IsShowAll(pos)
        local isNaikan = HeroEquip_Look_TradingBank.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                HeroEquip_Look_TradingBank.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function HeroEquip_Look_TradingBank.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not HeroEquip_Look_TradingBank.IsShowAll(data.Where)
    info.from       = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function HeroEquip_Look_TradingBank.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    HeroEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function HeroEquip_Look_TradingBank.InitEquipLayerEvent()
    for _,pos in pairs(HeroEquip_Look_TradingBank._EquipPosSet) do
        local widget = HeroEquip_Look_TradingBank.GetEquipPosPanel(pos)
        if widget then     
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) HeroEquip_Look_TradingBank.OnClickEvent() end)

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

            local Node = HeroEquip_Look_TradingBank.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    HeroEquip_Look_TradingBank.SetSamePosEquip()
end

function HeroEquip_Look_TradingBank.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not HeroEquip_Look_TradingBank._SamePos then
        return false
    end
    
    local Is = false
    for belongPos,v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k,pos in ipairs(v) do
            local equipPanel = HeroEquip_Look_TradingBank.GetEquipPosPanel(pos)
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
function HeroEquip_Look_TradingBank.GetEquipPosPanel(pos)
    return HeroEquip_Look_TradingBank._ui["Panel_pos"..pos]
end

-- 装备位置节点
function HeroEquip_Look_TradingBank.GetEquipPosNode(pos)
    return HeroEquip_Look_TradingBank._ui["Node_"..pos]
end

-- 该部位是否展示内观
function HeroEquip_Look_TradingBank.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function HeroEquip_Look_TradingBank.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function HeroEquip_Look_TradingBank.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = HeroEquip_Look_TradingBank.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        HeroEquip_Look_TradingBank._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        HeroEquip_Look_TradingBank._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function HeroEquip_Look_TradingBank.UpdateModelFeatureData()
    HeroEquip_Look_TradingBank._feature = {
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

    SetFeature(EquipPosCfg.Equip_Type_Dress,  HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   HeroEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Veil))

    HeroEquip_Look_TradingBank._feature.hairID = HeroEquip_Look_TradingBank._hairID

    dump(HeroEquip_Look_TradingBank._feature, "--HeroEquip_Look_TradingBank._feature-----")
end

-- 额外的装备位置
function HeroEquip_Look_TradingBank.InitEquipCells()
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(HeroEquip_Look_TradingBank._EquipPosSet, 14)
        table.insert(HeroEquip_Look_TradingBank._EquipPosSet, 15)
    else
        GUI:setVisible(HeroEquip_Look_TradingBank._ui["Panel_pos14"], false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui["Panel_pos15"], false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui["Node_14"], false)
        GUI:setVisible(HeroEquip_Look_TradingBank._ui["Node_15"], false)
    end
end

function HeroEquip_Look_TradingBank.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.TradingBankHeroBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    GUI:Image_loadTexture(HeroEquip_Look_TradingBank._ui.Image_box, GUIDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(HeroEquip_Look_TradingBank._ui.Image_box, true)
    
    local activeState = GUIFunction:GetBestRingsState(EDType)
    if activeState then
        GUI:Image_setGrey(HeroEquip_Look_TradingBank._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip_Look_TradingBank._ui.Image_box, true)
        GUI:setTouchEnabled(HeroEquip_Look_TradingBank._ui.Best_ringBox, false)
    end
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function HeroEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = HeroEquip_Look_TradingBank.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
function HeroEquip_Look_TradingBank.UpdateGuildInfo()
    local textGuildInfo = HeroEquip_Look_TradingBank._ui["Text_guildinfo"]
    GUI:Text_setString(textGuildInfo, "")
end

-- 界面关闭回调
function HeroEquip_Look_TradingBank.OnClose()
    if SL:GetValue("GAME_DATA","TradingBankHideSUI") ~= 1 then 
        -- 自定义组件卸载
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.PlayerEquipB_hero
        })

        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.PlayerEquipBO_hero
        })
    end
end

function HeroEquip_Look_TradingBank.CreateUIModel()
    local NodeModel = HeroEquip_Look_TradingBank._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, HeroEquip_Look_TradingBank._sex, HeroEquip_Look_TradingBank._feature, nil, {showHelmet = HeroEquip_Look_TradingBank._feature.showHair})
end

HeroEquip_Look_TradingBank.main()