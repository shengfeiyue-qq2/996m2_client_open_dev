PlayerEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI
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
    embattlesID     = nil,      -- 光环

    showNodeModel   = true,     -- 裸模
    showHair        = true      -- 头发
}

local Typefunc = {
    [EquipPosCfg.Equip_Type_Dress] = function (data)
        PlayerEquip._feature.clothID = data.ID
        PlayerEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        PlayerEquip._feature.weaponID = data.ID
        PlayerEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        PlayerEquip._feature.headID = data.ID
        PlayerEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        PlayerEquip._feature.capID = data.ID
        PlayerEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        PlayerEquip._feature.shieldID = data.ID
        PlayerEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        PlayerEquip._feature.veilID = data.ID
        PlayerEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 55, 56}

-- 斗笠和头盔是否在相同的位置
PlayerEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.EQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function PlayerEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if GUI:Win_IsNull(parent) then
        return false
    end
    GUI:LoadExport(parent, isPC and "player/player_equip_node_win32" or "player/player_equip_node")

    PlayerEquip._ui = GUI:ui_delegate(parent)
    if not PlayerEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    PlayerEquip._EquipPosSet = EquipPosSet

    -- 发型
    PlayerEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.PLAYER)
    -- 性别
    PlayerEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER)

    -- 首饰盒按钮
    local BestRingBox = PlayerEquip._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function ()
        SL:RequestOpenPlayerBestRings()
        GUI:setClickDelay(BestRingBox, 0.3)
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
    PlayerEquip.CreateUIModel()

    -- 装备加载成功添加红点
    SL:PlayerEquipUILoadSuccessAddRed()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerEquip})

    SL:AttachTXTSUI({root = PlayerEquip._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipB})

    PlayerEquip.InitJJSplit()
end

-- 剑甲分离
function PlayerEquip.InitJJSplit()
    for pos, show in pairs(GUIDefine.EquipAllShow) do
        local p1 = PlayerEquip.GetEquipPosExPanel(pos)
        local p2 = PlayerEquip.GetEquipPosPanel(pos)
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
function PlayerEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = PlayerEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = PlayerEquip.IsShowAll(pos)
        local isNaikan = PlayerEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
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
    info.from            = GUIDefine.ItemFrom.PLAYER_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = false
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
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
    local isMoving = SL:GetValue("ITEM_MOVE_STATE")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = GUIFunction:GetEquipDataByPos(pos, PlayerEquip._SamePos, EDType)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:RequestTakeOffEquip({itemData = itemData})
end

function PlayerEquip.UpdateMoveState(widget, state, pos)
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
        if state then
            SetFeature(pos, {})
        else
            PlayerEquip.UpdateModelFeatureData()
        end
        PlayerEquip.CreateUIModel()
    end

    -- 是否刷新内观和装备框
    local isShowAll = PlayerEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end

    -- 是否刷新只内观
    local isNaikan = PlayerEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 初始化点击（包含鼠标）事件
function PlayerEquip.InitEquipLayerEvent()
    for _, pos in pairs(PlayerEquip._EquipPosSet) do
        local widget = PlayerEquip.GetEquipPosPanel(pos)
        if type(GUIDefine.EquipAllShow[pos]) == "boolean" then
            widget = GUIDefine.EquipAllShow[pos] and PlayerEquip.GetEquipPosPanel(pos) or PlayerEquip.GetEquipPosExPanel(pos)
        end
        if widget then
            local params = {
                pos       = pos,
                from      = GUIDefine.ItemFrom.PLAYER_EQUIP,
                dataType  = EDType,
                moveCallBack = PlayerEquip.UpdateMoveState,
                onClick   = PlayerEquip.OnClickEvent,
                onPress   = PlayerEquip.OnClickEvent,
                onDouble  = PlayerEquip.OnDoubleEvent
            }
            
            GUI:setTouchEnabled(widget, true)
            GUI:addOnTouchEvent(widget, function (sender, eventType)
                GUIFunction:DealEquipTouch(sender, eventType, params)
            end)

            local function addItemIntoEquip(touchPos)
                local isMoving = SL:GetValue("ITEM_MOVE_STATE")
                if not isMoving then
                    return -1
                end
                
                local data = {}
                data.target = GUIDefine.ItemGoTo.PLAYER_EQUIP
                data.pos = touchPos
                data.equipPos = pos

                -- 拖动结束处理函数; PC端做个延迟处理，防止再次触发点击事件
                if isPC then
                    SL:ScheduleOnce(function () SL:ItemMoveCheck(data) end, GUIDefine.CLICK_DOUBLE_TIME)
                else
                    SL:ItemMoveCheck(data)
                end
                return 1
            end

            local function onRightDownFunc(touchPos)
                return -1
            end
            -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
            GUI:addMouseButtonEvent(widget, {onSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "PlayerEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, PlayerEquip.OnOpenItemTips)
            end

            -- 斗笠、头盔内装备特殊处理
            local isNaikan = GUIDefine.EquipNaikanShow and GUIDefine.EquipNaikanShow[pos]
            
            local isSpeDeal = isNaikan == true or isNaikan == false
            GUI:setVisible(widget, true)

            local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
            if DefaultIcon and isSpeDeal then
                GUI:setVisible(DefaultIcon, not isNaikan)
            end

            local PanelBg = GUI:getChildByName(widget, "PanelBg")
            if PanelBg and isSpeDeal then
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
    
    for belongPos,v in pairs(GUIDefine.EquipPosMapping or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
            if equipPanel then
                local equipData = EquipData.FindEquipDataByPos(pos)
                if equipData then
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
function PlayerEquip.GetEquipPosPanel(pos)
    return PlayerEquip._ui["Panel_pos"..pos]
end

function PlayerEquip.GetEquipPosExPanel(pos)
    return PlayerEquip._ui["Panel_posEx"..pos]
end

-- 装备位置节点
function PlayerEquip.GetEquipPosNode(pos)
    return PlayerEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function PlayerEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function PlayerEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function PlayerEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = PlayerEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}


    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        PlayerEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
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
        embattlesID     = nil,      -- 光环

        showNodeModel   = true,     -- 裸模
        showHair        = true      -- 头发
    }

    SetFeature(EquipPosCfg.Equip_Type_Dress,  PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   PlayerEquip.GetLooks(EquipPosCfg.Equip_Type_Veil))

    PlayerEquip._feature.hairID = PlayerEquip._hairID
    PlayerEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)

end

-- 额外的装备位置
function PlayerEquip.InitEquipCells()
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(SL:GetValue("USER_ID"))
    
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(PlayerEquip._EquipPosSet, 14)
        table.insert(PlayerEquip._EquipPosSet, 15)
    else
        GUI:setVisible(PlayerEquip._ui["Panel_pos14"], false)
        GUI:setVisible(PlayerEquip._ui["Panel_pos15"], false)
        GUI:setVisible(PlayerEquip._ui["Node_14"], false)
        GUI:setVisible(PlayerEquip._ui["Node_15"], false)
    end
end

function PlayerEquip.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.PlayerBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    local path = isPC and "player_best_rings_ui_win32" or "player_best_rings_ui_mobile"
    GUI:Image_loadTexture(PlayerEquip._ui.Image_box, string.format("res/private/player_best_rings_ui/%s/%s", path, texture))
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(PlayerEquip._ui.Image_box, true)
    PlayerEquip.UpdateBestRingsBox()
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function PlayerEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = PlayerEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.PLAYER_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function PlayerEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera

    local makeIndex = data.MakeIndex

    local pos = data.Where
    local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local function onRefEquipNaikan()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.DEL == optType or GUIDefine.OprateType.CHANGE == optType then
            PlayerEquip.UpdateModelFeatureData()
            PlayerEquip.CreateUIModel()
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.CHANGE == optType then
            local itemNode = PlayerEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
            PlayerEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIDefine.OprateType.DEL == optType then
            local itemNode = PlayerEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
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

    PlayerEquip.SetSamePosEquip()
end

-- 装备状态改变时刷新
function PlayerEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local makeIndex = data.MakeIndex
    local itemData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local equipPanel = PlayerEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state

    local function onRefEquipNaikan()
        PlayerEquip.UpdateModelFeatureData()
        PlayerEquip.CreateUIModel()
    end

    local function onRefEquipIcon()
        local itemNode = PlayerEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        PlayerEquip.CreateEquipItem(itemNode, equipData)
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

    PlayerEquip.SetSamePosEquip()
end

-- 更新生肖框状态
function PlayerEquip.UpdateBestRingsBox(isOpen)
    if not PlayerEquip._BestRingBox then
        return false
    end

    local activeState = GUIFunction:GetBestRingsState(EDType)
    if activeState then
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, true)
    end

    if isOpen then
        if activeState then  
            UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.PLAYER)
        else
            local bestRingsName = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_NAME) or "首饰盒"
            GUI:SetWorldTips(string.format("%s未开启", bestRingsName), GUI:getTouchEndPosition(PlayerEquip._BestRingBox), {x = 0, y = 1})
        end
    end
end

-- 更新所属行会信息
function PlayerEquip.UpdateGuildInfo()
    local textGuildInfo = PlayerEquip._ui["Text_guildinfo"]
    -- 行会数据
    local guildData   = SL:GetValue("GUILD_INFO")

    -- 行会名字
    local guildName   = guildData.guildName
    guildName = guildName or ""

    -- 行会官职
    local officalName = SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", guildData.rank)
    officalName = officalName or ""

    local str = guildName .. " " .. officalName

    if string.len(str) < 1 then
        GUI:Text_setString(textGuildInfo, "")
        return false
    end
    
    GUI:Text_setString(textGuildInfo, str)
    local color = SL:GetValue("USER_NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

-- 界面关闭回调
function PlayerEquip.OnClose()
    PlayerEquip.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquip
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipB
    })
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function PlayerEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_BESTRINGBOX_STATE, "PlayerEquip", PlayerEquip.UpdateBestRingsBox)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip", PlayerEquip.UpdateGuildInfo)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EMBATTLE_CHANGE, "PlayerEquip", PlayerEquip.UpdateEmbattleModel)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip", PlayerEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerEquip", PlayerEquip.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerEquip", PlayerEquip.OnSexChange)

    SL:SexChangeAddRed()
end

-- 取消事件
function PlayerEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_BESTRINGBOX_STATE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EMBATTLE_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerEquip")
end

-- 更新光环+
function PlayerEquip.UpdateEmbattleModel()
    PlayerEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)
    PlayerEquip.CreateUIModel()
end

function PlayerEquip.OnSexChange()
    PlayerEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.PLAYER)
    PlayerEquip.CreateUIModel()
    SL:SexChangeAddRed()
end

function PlayerEquip.CreateUIModel()
    local NodeModel = PlayerEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, PlayerEquip._sex, PlayerEquip._feature, nil, {showHelmet = PlayerEquip._feature.showHair})
end

PlayerEquip.main()