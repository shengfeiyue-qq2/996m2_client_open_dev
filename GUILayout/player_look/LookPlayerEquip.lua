LookPlayerEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
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
    embattlesID     = nil,      -- 光环

    showNodeModel   = true,     -- 裸模
    showHair        = true,     -- 头发
    showHelmet      = false
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Dress] = function (data)
        LookPlayerEquip._feature.clothID = data.ID
        LookPlayerEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        LookPlayerEquip._feature.weaponID = data.ID
        LookPlayerEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        LookPlayerEquip._feature.headID = data.ID
        LookPlayerEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        LookPlayerEquip._feature.capID = data.ID
        LookPlayerEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        LookPlayerEquip._feature.shieldID = data.ID
        LookPlayerEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        LookPlayerEquip._feature.veilID = data.ID
        LookPlayerEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 55, 56}

-- 斗笠和头盔是否在相同的位置
LookPlayerEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.OTHER_EQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookPlayerEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player_look/player_equip_node_win32" or "player_look/player_equip_node")

    LookPlayerEquip._ui = GUI:ui_delegate(parent)
    if not LookPlayerEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    LookPlayerEquip._EquipPosSet = EquipPosSet

    -- 发型
    LookPlayerEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.PLAYER_OTHER)
    -- 性别
    LookPlayerEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER_OTHER)

    -- 首饰盒按钮
    local BestRingBox = LookPlayerEquip._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function ()
        -- 首饰盒是否开启
        UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.PLAYER_OTHER)
        GUI:setClickDelay(BestRingBox, 0.3)
    end)

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
    LookPlayerEquip.CreateUIModel()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = LookPlayerEquip._ui["EquipUI"], index = SLDefine.SUIComponentTable.PlayerEquipO})

    SL:AttachTXTSUI({root = LookPlayerEquip._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipBO})

end

-- 剑甲分离
function LookPlayerEquip.InitJJSplit()
    for pos, show in pairs(GUIDefine.EquipAllShow) do
        local p1 = LookPlayerEquip.GetEquipPosExPanel(pos)
        local p2 = LookPlayerEquip.GetEquipPosPanel(pos)
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
function LookPlayerEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = LookPlayerEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = LookPlayerEquip.IsShowAll(pos)
        local isNaikan = LookPlayerEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
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
    info.from            = GUIDefine.ItemFrom.PLAYER_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = true
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function LookPlayerEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    LookPlayerEquip.OnOpenItemTips(widget, pos)
end

-- 初始化点击（包含鼠标）事件
function LookPlayerEquip.InitEquipLayerEvent()
    for _, pos in ipairs(LookPlayerEquip._EquipPosSet) do
        local widget = LookPlayerEquip.GetEquipPosPanel(pos)
        if type(GUIDefine.EquipAllShow[pos]) == "boolean" then
            widget = GUIDefine.EquipAllShow[pos] and LookPlayerEquip.GetEquipPosPanel(pos) or LookPlayerEquip.GetEquipPosExPanel(pos)
        end

        if widget and GUI:getVisible(widget) then     
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType) 
                LookPlayerEquip.OnClickEvent(widget, pos) 
            end)

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "LookPlayerEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, LookPlayerEquip.OnOpenItemTips)
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
    
    for belongPos, v in pairs(GUIDefine.EquipPosMappingEx or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = LookPlayerEquip.GetEquipPosPanel(pos)
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
function LookPlayerEquip.GetEquipPosPanel(pos)
    return LookPlayerEquip._ui["Panel_pos"..pos]
end

function LookPlayerEquip.GetEquipPosExPanel(pos)
    return LookPlayerEquip._ui["Panel_posEx"..pos]
end

-- 装备位置节点
function LookPlayerEquip.GetEquipPosNode(pos)
    return LookPlayerEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function LookPlayerEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function LookPlayerEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function LookPlayerEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = LookPlayerEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}

    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.zblmtkz and tonumber(equipData.zblmtkz) == 1 then -- zblmtkz == 1 不显示裸模, 表配置字段
        LookPlayerEquip._feature.showNodeModel = false
        LookPlayerEquip._feature.showHair = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        LookPlayerEquip._feature.showHelmet = true
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function LookPlayerEquip.UpdateModelFeatureData()
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
        embattlesID     = nil,      -- 光环

        showNodeModel   = true,     -- 裸模
        showHair        = true,     -- 头发
        showHelmet      = false
    }

    SetFeature(EquipPosCfg.Equip_Type_Dress,  LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   LookPlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Veil))

    LookPlayerEquip._feature.hairID = LookPlayerEquip._hairID
    LookPlayerEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)

end

-- 额外的装备位置
function LookPlayerEquip.InitEquipCells()
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(LookPlayerData.GetPlayerUID())
    
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(LookPlayerEquip._EquipPosSet, 14)
        table.insert(LookPlayerEquip._EquipPosSet, 15)
    else
        GUI:setVisible(LookPlayerEquip._ui["Panel_pos14"], false)
        GUI:setVisible(LookPlayerEquip._ui["Panel_pos15"], false)
        GUI:setVisible(LookPlayerEquip._ui["Node_14"], false)
        GUI:setVisible(LookPlayerEquip._ui["Node_15"], false)
    end

    LookPlayerEquip.InitJJSplit()

    if SL:GetValue("GAME_DATA", "isSeparateHelmetAndCap") == 1 then
        LookPlayerEquip._SamePos = false
    else
        LookPlayerEquip._SamePos = true
    end
end

function LookPlayerEquip.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.LookPlayerBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    GUI:Image_loadTexture(LookPlayerEquip._ui.Image_box, GUIDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(LookPlayerEquip._ui.Image_box, true)
    
    local activeState = LookPlayerData.GetBestRingsOpenState()
    if activeState then
        GUI:Image_setGrey(LookPlayerEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(LookPlayerEquip._ui.Image_box, true)
    end
end

-- 装备为内观且使用相同位置时显示同部位多件装备tips，否则显示单件
function LookPlayerEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = (LookPlayerEquip.IsNaikan(pos) and LookPlayerEquip._SamePos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
function LookPlayerEquip.UpdateGuildInfo()
    local textGuildInfo = LookPlayerEquip._ui["Text_guildinfo"]

    -- 行会名字
    local guildName = LookPlayerData.GetPlayerGuildName()
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
function LookPlayerEquip.OnClose()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipO
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipBO
    })
end

function LookPlayerEquip.CreateUIModel()
    local NodeModel = LookPlayerEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, LookPlayerEquip._sex, LookPlayerEquip._feature, nil, true, SL:GetValue("L.M.JOB"))
end

LookPlayerEquip.main()