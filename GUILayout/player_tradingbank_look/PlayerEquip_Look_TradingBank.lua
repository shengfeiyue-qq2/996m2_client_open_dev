PlayerEquip_Look_TradingBank = {}

local EquipPosCfg = GUIDefine.EquipPosUI
PlayerEquip_Look_TradingBank._feature = {
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
    showHair        = true,     -- 头发
    showHelmet      = false
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Dress] = function (data)
        PlayerEquip_Look_TradingBank._feature.clothID = data.ID
        PlayerEquip_Look_TradingBank._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        PlayerEquip_Look_TradingBank._feature.weaponID = data.ID
        PlayerEquip_Look_TradingBank._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        PlayerEquip_Look_TradingBank._feature.headID = data.ID
        PlayerEquip_Look_TradingBank._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        PlayerEquip_Look_TradingBank._feature.capID = data.ID
        PlayerEquip_Look_TradingBank._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        PlayerEquip_Look_TradingBank._feature.shieldID = data.ID
        PlayerEquip_Look_TradingBank._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        PlayerEquip_Look_TradingBank._feature.veilID = data.ID
        PlayerEquip_Look_TradingBank._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 56}

-- 斗笠和头盔是否在相同的位置
PlayerEquip_Look_TradingBank._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.TRADE_EQUIP

function PlayerEquip_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "player_look_tradingbank/player_equip_node")

    PlayerEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerEquip_Look_TradingBank._ui then
        return false
    end

    PlayerEquip_Look_TradingBank._EquipPosSet = EquipPosSet

    -- 发型
    PlayerEquip_Look_TradingBank._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.TRADE_PLAYER)
    -- 性别
    PlayerEquip_Look_TradingBank._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.TRADE_PLAYER)
    -- 职业
    PlayerEquip_Look_TradingBank._job = GUIFunction:GetRoleJob(GUIDefine.RoleUIType.TRADE_PLAYER)

    -- 首饰盒按钮
    local BestRingBox = PlayerEquip_Look_TradingBank._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function ()
        -- 首饰盒是否开启
        UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.TRADE_PLAYER)
        GUI:setClickDelay(BestRingBox, 0.3)
    end)

    -- 额外装备位
    PlayerEquip_Look_TradingBank.InitEquipCells()
    
    -- 初始化首饰盒
    PlayerEquip_Look_TradingBank.InitBestRingsBox()

    -- 初始化装备框装备
    PlayerEquip_Look_TradingBank.InitEquipLayer()

    -- 初始化装备事件
    PlayerEquip_Look_TradingBank.InitEquipLayerEvent()

    -- 行会信息
    PlayerEquip_Look_TradingBank.UpdateGuildInfo()

    PlayerEquip_Look_TradingBank.UpdateModelFeatureData()

    -- 初始化装备内观
    PlayerEquip_Look_TradingBank.CreateUIModel()

    if SL:GetValue("GAME_DATA","TradingBankHideSUI") ~= 1 then 
        -- 自定义组件挂接
        SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerEquipO})

        SL:AttachTXTSUI({root = PlayerEquip_Look_TradingBank._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipBO})
    end
end

-- 初始化装备框装备
function PlayerEquip_Look_TradingBank.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = PlayerEquip_Look_TradingBank.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = PlayerEquip_Look_TradingBank.IsShowAll(pos)
        local isNaikan = PlayerEquip_Look_TradingBank.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                PlayerEquip_Look_TradingBank.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function PlayerEquip_Look_TradingBank.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not PlayerEquip_Look_TradingBank.IsShowAll(data.Where)
    info.from       = GUIDefine.ItemFrom.PLAYER_EQUIP
    info.itemData   = data
    info.index      = data.Index
    info.lookPlayer = true

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function PlayerEquip_Look_TradingBank.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    PlayerEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function PlayerEquip_Look_TradingBank.InitEquipLayerEvent()
    for _, pos in ipairs(PlayerEquip_Look_TradingBank._EquipPosSet) do
        local widget = PlayerEquip_Look_TradingBank.GetEquipPosPanel(pos)
        if widget and GUI:getVisible(widget) then     
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function() 
                PlayerEquip_Look_TradingBank.OnClickEvent(widget, pos) 
            end)
        end
    end
    PlayerEquip_Look_TradingBank.SetSamePosEquip()
end

function PlayerEquip_Look_TradingBank.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not PlayerEquip_Look_TradingBank._SamePos then
        return false
    end

    for belongPos, v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = PlayerEquip_Look_TradingBank.GetEquipPosPanel(pos)
            if equipPanel then
                if GUIFunction:GetEquipDataByPos(pos, nil, EDType) then
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
function PlayerEquip_Look_TradingBank.GetEquipPosPanel(pos)
    return PlayerEquip_Look_TradingBank._ui["Panel_pos"..pos]
end

-- 装备位置节点
function PlayerEquip_Look_TradingBank.GetEquipPosNode(pos)
    return PlayerEquip_Look_TradingBank._ui["Node_"..pos]
end

-- 该部位是否展示内观
function PlayerEquip_Look_TradingBank.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function PlayerEquip_Look_TradingBank.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function PlayerEquip_Look_TradingBank.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = PlayerEquip_Look_TradingBank.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.zblmtkz and tonumber(equipData.zblmtkz) == 1 then -- zblmtkz == 1 不显示裸模, 表配置字段
        PlayerEquip_Look_TradingBank._feature.showNodeModel = false
        PlayerEquip_Look_TradingBank._feature.showHair = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        PlayerEquip_Look_TradingBank._feature.showHelmet = true
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function PlayerEquip_Look_TradingBank.UpdateModelFeatureData()
    PlayerEquip_Look_TradingBank._feature = {
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
        showHair        = true,     -- 头发
        showHelmet      = false
    }

    SetFeature(EquipPosCfg.Equip_Type_Dress,  PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   PlayerEquip_Look_TradingBank.GetLooks(EquipPosCfg.Equip_Type_Veil))

    PlayerEquip_Look_TradingBank._feature.hairID = PlayerEquip_Look_TradingBank._hairID

end

-- 额外的装备位置
function PlayerEquip_Look_TradingBank.InitEquipCells()
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(PlayerEquip_Look_TradingBank._EquipPosSet, 14)
        table.insert(PlayerEquip_Look_TradingBank._EquipPosSet, 15)
    else
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui["Panel_pos14"], false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui["Panel_pos15"], false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui["Node_14"], false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui["Node_15"], false)
    end

    if SL:GetValue("GAME_DATA", "isSeparateHelmetAndCap") == 1 then
        PlayerEquip_Look_TradingBank._SamePos = false
    else
        PlayerEquip_Look_TradingBank._SamePos = true
    end
end

function PlayerEquip_Look_TradingBank.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.TradingBankBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    GUI:Image_loadTexture(PlayerEquip_Look_TradingBank._ui.Image_box, GUIDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(PlayerEquip_Look_TradingBank._ui.Image_box, true)
    
    local activeState = TradingBankLookPlayerData.GetBestRingsOpenState()
    if activeState then
        GUI:Image_setGrey(PlayerEquip_Look_TradingBank._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip_Look_TradingBank._ui.Image_box, true)
        GUI:setTouchEnabled(PlayerEquip_Look_TradingBank._ui.Best_ringBox, false)
    end
end

-- 装备为内观且使用相同位置时显示同部位多件装备tips，否则显示单件
function PlayerEquip_Look_TradingBank.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = (PlayerEquip_Look_TradingBank.IsNaikan(pos) and PlayerEquip_Look_TradingBank._SamePos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.PLAYER_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 更新所属行会信息
function PlayerEquip_Look_TradingBank.UpdateGuildInfo()
    local textGuildInfo = PlayerEquip_Look_TradingBank._ui["Text_guildinfo"]

    -- 行会名字
    local guildName = TradingBankLookPlayerData.GetPlayerGuildName()
    guildName = guildName or ""

    -- 行会官职
    local officalName = TradingBankLookPlayerData.GetPlayerGuildRankName()

    officalName = officalName or ""

    local str = guildName .. " " .. officalName

    if string.len(str) < 1 then
        GUI:Text_setString(textGuildInfo, "")
        return false
    end
    
    GUI:Text_setString(textGuildInfo, str)
    local color = TradingBankLookPlayerData.GetPlayerNameColor()
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-- 界面关闭回调
function PlayerEquip_Look_TradingBank.OnClose()
    if SL:GetValue("GAME_DATA","TradingBankHideSUI") ~= 1 then 
        -- 自定义组件卸载
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.PlayerEquipO
        })

        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.PlayerEquipBO
        })
    end
end

function PlayerEquip_Look_TradingBank.CreateUIModel()
    local NodeModel = PlayerEquip_Look_TradingBank._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerEquip_Look_TradingBank._sex, PlayerEquip_Look_TradingBank._feature, nil, true, PlayerEquip_Look_TradingBank._job)
end

PlayerEquip_Look_TradingBank.main()