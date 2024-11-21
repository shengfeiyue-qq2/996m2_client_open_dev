HeroEquip = {}

local EquipPosCfg = GUIDefine.EquipPosUI

HeroEquip._feature = {
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
        HeroEquip._feature.clothID = data.ID
        HeroEquip._feature.clothEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Weapon] = function (data)
        HeroEquip._feature.weaponID = data.ID
        HeroEquip._feature.weaponEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Helmet] = function (data)
        HeroEquip._feature.headID = data.ID
        HeroEquip._feature.headEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Cap] = function (data)
        HeroEquip._feature.capID = data.ID
        HeroEquip._feature.capEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Shield] = function (data)
        HeroEquip._feature.shieldID = data.ID
        HeroEquip._feature.shieldEffectID = data.effectID
    end,
    [EquipPosCfg.Equip_Type_Veil] = function (data)
        HeroEquip._feature.veilID = data.ID
        HeroEquip._feature.veilEffectID = data.effectID
    end
}
local SetFeature = function (pos, data)
    if Typefunc[pos] then Typefunc[pos](data) end
end

-- 部位位置配置(4 和 13 同部位)
local EquipPosSet = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 55, 56}

-- 斗笠和头盔是否在相同的位置
HeroEquip._SamePos = true

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function HeroEquip.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_equip_node_win32" or "hero/hero_equip_node")

    HeroEquip._ui = GUI:ui_delegate(parent)
    if not HeroEquip._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    HeroEquip._EquipPosSet = EquipPosSet

    -- 发型
    HeroEquip._hairID = GUIFunction:GetRoleHair(GUIDefine.RoleUIType.HERO)
    -- 性别
    HeroEquip._sex = GUIFunction:GetRoleSex(GUIDefine.RoleUIType.HERO)

    -- 首饰盒按钮
    local BestRingBox = HeroEquip._ui["Best_ringBox"]
    local isVisible = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_SHOW) == 1
    GUI:setVisible(BestRingBox, isVisible)

    GUI:addOnClickEvent(BestRingBox, function()
        SL:RequestOpenPlayerBestRings()
        GUI:setClickDelay(BestRingBox, 0.3)
    end)
    HeroEquip._BestRingBox = BestRingBox

    -- 注册事件
    HeroEquip.RegistEvent()

    -- 额外装备位
    HeroEquip.InitEquipCells()
    
    -- 初始化首饰盒
    HeroEquip.InitBestRingsBox()

    -- 初始化装备框装备
    HeroEquip.InitEquipLayer()

    -- 初始化装备事件
    HeroEquip.InitEquipLayerEvent()

    HeroEquip.UpdateModelFeatureData()

    -- 初始化装备内观
    HeroEquip.CreateUIModel()

    -- 装备加载成功添加红点
    SL:HeroEquipUILoadSuccessAddRed()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = HeroEquip._ui["EquipUI"], index = SLDefine.SUIComponentTable.PlayerEquip_hero})

    SL:AttachTXTSUI({root = HeroEquip._ui["BG"], index = SLDefine.SUIComponentTable.PlayerEquipB_hero})
end

-- 初始化装备框装备
function HeroEquip.InitEquipLayer()
    local equipPosData = GUIFunction:GetEquipPosData(EDType)
    for pos, MakeIndex in pairs(equipPosData) do
        local itemNode = HeroEquip.GetEquipPosNode(pos)
        if itemNode then
            GUI:removeAllChildren(itemNode)
        end
        local isShowAll = HeroEquip.IsShowAll(pos)
        local isNaikan = HeroEquip.IsNaikan(pos)

        if itemNode and (not isNaikan or isShowAll) then
            -- 加载外观
            local equipData = GUIFunction:GetEquipDataByMakeIndex(MakeIndex, EDType)
            if equipData then       
                HeroEquip.CreateEquipItem(itemNode, equipData)
            end
        end
    end
end

-- 创建装备item
function HeroEquip.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = not HeroEquip.IsShowAll(data.Where)
    info.from            = GUIDefine.ItemFrom.HERO_EQUIP
    info.itemData        = data
    info.index           = data.Index
    info.lookPlayer      = false
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end

function HeroEquip.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    HeroEquip.OnOpenItemTips(widget, pos)
end

function HeroEquip.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetValue("ITEM_MOVE_STATE")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = GUIFunction:GetEquipDataByPos(pos, HeroEquip._SamePos, EDType)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:RequestHeroTakeOffEquip({itemData = itemData})
end

function HeroEquip.UpdateMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    HeroEquip.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function HeroEquip.UpdateEquipStateChange(state, pos)
    -- 刷新装备装备框
    local function onRefEquipIcon()
        local itemNode = HeroEquip.GetEquipPosNode(pos)
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
            HeroEquip.UpdateModelFeatureData()
        end
        HeroEquip.CreateUIModel()
    end

    -- 是否刷新内观和装备框
    local isShowAll = HeroEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end

    -- 是否刷新只内观
    local isNaikan = HeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end
end

-- 初始化点击（包含鼠标）事件
function HeroEquip.InitEquipLayerEvent()
    for _,pos in pairs(HeroEquip._EquipPosSet) do
        local widget = HeroEquip.GetEquipPosPanel(pos)
        if widget then
            local params = {
                pos       = pos,
                from      = GUIDefine.ItemFrom.HERO_EQUIP,
                dataType  = EDType,
                moveCallBack = HeroEquip.UpdateMoveState,
                onClick   = HeroEquip.OnClickEvent,
                onPress   = HeroEquip.OnClickEvent,
                onDouble  = HeroEquip.OnDoubleEvent
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
                data.target = GUIDefine.ItemGoTo.HERO_EQUIP
                data.pos = touchPos
                data.equipPos = pos

                widget._Click_flag = true

                SL:ItemMoveCheck(data)
                
                return 1
            end

            local function onRightDownFunc(touchPos)
                return -1
            end
            -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
            GUI:addMouseButtonEvent(widget, {onSpecialRFunc = addItemIntoEquip, onRightDownFunc = onRightDownFunc})

            if isPC then
                GUIFunction:InitItemTipsScrollEvent(widget, "HeroEquip")
                GUIFunction:InitMouseMoveToEquipEvent(widget, pos, HeroEquip.OnOpenItemTips)
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

            local Node = HeroEquip.GetEquipPosNode(pos)
            if Node then
                GUI:setVisible(Node, not isNaikan)
            end
        end
    end
    HeroEquip.SetSamePosEquip()
end

function HeroEquip.SetSamePosEquip()
    -- 相同部位存在显示一个
    if not HeroEquip._SamePos then
        return false
    end

    for belongPos,v in pairs(GUIDefine.EquipPosMapping or {}) do
        for k, pos in ipairs(v) do
            local equipPanel = HeroEquip.GetEquipPosPanel(pos)
            if equipPanel then
                local equipData = HeroEquipData.FindEquipDataByPos(pos)
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
function HeroEquip.GetEquipPosPanel(pos)
    return HeroEquip._ui["Panel_pos"..pos]
end

-- 装备位置节点
function HeroEquip.GetEquipPosNode(pos)
    return HeroEquip._ui["Node_"..pos]
end

-- 该部位是否展示内观
function HeroEquip.IsNaikan(pos)
    return GUIDefine.IsNaikanEquip(pos)
end

-- 是否显示内观和装备框
function HeroEquip.IsShowAll(pos)
    return GUIDefine.EquipAllShow and GUIDefine.EquipAllShow[pos]
end

-----------------------------------------------------------------------------------------------------------------
function HeroEquip.GetLooks(pos)
    -- 通过唯一ID MakeIndex 获取装备数据
    local equipData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not equipData then
        return {}
    end

    -- 是否是内观
    local isNaikan = HeroEquip.IsNaikan(pos)
    if not isNaikan then
        return {}
    end

    local data = {}


    if pos == EquipPosCfg.Equip_Type_Dress and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then -- shonourSell == 1 不显示裸模, 服务器下发字段
        HeroEquip._feature.showNodeModel = false
    end

    if pos == EquipPosCfg.Equip_Type_Cap and equipData.AniCount == 0 then
        HeroEquip._feature.showHair = false
    end

    if equipData then
        data.ID = equipData.Looks
        data.effectID = equipData.sEffect
    end

    return data
end

-- 更新装备内观数据  
function HeroEquip.UpdateModelFeatureData()
    HeroEquip._feature = {
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

    SetFeature(EquipPosCfg.Equip_Type_Dress,  HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Dress))
    SetFeature(EquipPosCfg.Equip_Type_Helmet, HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Helmet))
    SetFeature(EquipPosCfg.Equip_Type_Weapon, HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Weapon))
    SetFeature(EquipPosCfg.Equip_Type_Cap,    HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Cap))
    SetFeature(EquipPosCfg.Equip_Type_Shield, HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Shield))
    SetFeature(EquipPosCfg.Equip_Type_Veil,   HeroEquip.GetLooks(EquipPosCfg.Equip_Type_Veil))

    HeroEquip._feature.hairID = HeroEquip._hairID
    HeroEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)

end

-- 额外的装备位置
function HeroEquip.InitEquipCells()
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(SL:GetValue("USER_ID"))
    
    local showExtra = SL:GetValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) == 1
    if showExtra then
        table.insert(HeroEquip._EquipPosSet, 14)
        table.insert(HeroEquip._EquipPosSet, 15)
    else
        GUI:setVisible(HeroEquip._ui["Panel_pos14"], false)
        GUI:setVisible(HeroEquip._ui["Panel_pos15"], false)
        GUI:setVisible(HeroEquip._ui["Node_14"], false)
        GUI:setVisible(HeroEquip._ui["Node_15"], false)
    end
end

function HeroEquip.InitBestRingsBox()
    local texture = GUI:GetWindow(nil, UIConst.LAYERID.HeroBestRingGUI) and "btn_jewelry_1_1.png" or "btn_jewelry_1_0.png"
    GUI:Image_loadTexture(HeroEquip._ui.Image_box, GUIDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
    -- 重置尺寸
    GUI:setIgnoreContentAdaptWithSize(HeroEquip._ui.Image_box, true)
    HeroEquip.UpdateBestRingsBox()
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function HeroEquip.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = HeroEquip.IsNaikan(pos) and GUIFunction:GetEquipDataListByPos(pos, EDType) or {GUIFunction:GetEquipDataByPos(pos, nil, EDType)}
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
    data.from = GUIDefine.ItemFrom.HERO_EQUIP

    UIOperator:OpenItemTips(data)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function HeroEquip.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera

    local makeIndex = data.MakeIndex

    local pos = data.Where
    local equipPanel = HeroEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local function onRefEquipNaikan()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.DEL == optType or GUIDefine.OprateType.CHANGE == optType then
            HeroEquip.UpdateModelFeatureData()
            HeroEquip.CreateUIModel()
            return false
        end
    end

    local function onRefEquipIcon()
        if GUIDefine.OprateType.ADD == optType or GUIDefine.OprateType.CHANGE == optType then
            local itemNode = HeroEquip.GetEquipPosNode(pos)
            local visible  = GUI:getVisible(equipPanel)
            GUI:setVisible(itemNode, visible)
            GUI:removeAllChildren(itemNode)

            local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
            HeroEquip.CreateEquipItem(itemNode, equipData)
        elseif GUIDefine.OprateType.DEL == optType then
            local itemNode = HeroEquip.GetEquipPosNode(pos)
            GUI:removeAllChildren(itemNode)
        end
    end
    
    local isShowAll = HeroEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = HeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    HeroEquip.SetSamePosEquip()
end

-- 装备状态改变时刷新
function HeroEquip.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local makeIndex = data.MakeIndex
    local itemData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local equipPanel = HeroEquip.GetEquipPosPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state >= 1
    equipPanel._movingState = not state

    local function onRefEquipNaikan()
        HeroEquip.UpdateModelFeatureData()
        HeroEquip.CreateUIModel()
    end

    local function onRefEquipIcon()
        local itemNode = HeroEquip.GetEquipPosNode(pos)
        GUI:setVisible(itemNode, state)
        GUI:removeAllChildren(itemNode)

        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        HeroEquip.CreateEquipItem(itemNode, equipData)
    end

    local isShowAll = HeroEquip.IsShowAll(pos)
    if isShowAll then
        onRefEquipNaikan()
        onRefEquipIcon()
        return false
    end
    local isNaikan = HeroEquip.IsNaikan(pos)
    if isNaikan then
        onRefEquipNaikan()
    else
        onRefEquipIcon()
    end

    HeroEquip.SetSamePosEquip()
end

-- 更新生肖框状态
function HeroEquip.UpdateBestRingsBox(isOpen)
    if not HeroEquip._BestRingBox then
        return false
    end

    local activeState = GUIFunction:GetBestRingsState(EDType)
    if activeState then
        GUI:Image_setGrey(HeroEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip._ui.Image_box, true)
    end

    if isOpen then
        if activeState then  
            UIOperator:OpenBestRingBoxUI(GUIDefine.RoleUIType.HERO)
        else
            local bestRingsName = SL:GetValue("SERVER_OPTION", SW_KEY_BESTRINGBOX_NAME) or "首饰盒"
            GUI:SetWorldTips(string.format("%s未开启", bestRingsName), GUI:getTouchEndPosition(HeroEquip._BestRingBox), {x = 0, y = 1})
        end
    end
end

-- 界面关闭回调
function HeroEquip.OnClose()
    HeroEquip.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquip_hero
    })

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerEquipB_hero
    })
end

-----------------------------------------------------------------------------------------------------------------
-- 注册事件
function HeroEquip.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BESTRINGBOX_STATE, "HeroEquip", HeroEquip.UpdateBestRingsBox)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EMBATTLE_CHANGE, "HeroEquip", HeroEquip.UpdateEmbattleModel)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroEquip", HeroEquip.UpdateEquipLayer)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroEquip", HeroEquip.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroEquip", HeroEquip.OnSexChange)

    SL:SexChangeAddRed()
end

-- 取消事件
function HeroEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_BESTRINGBOX_STATE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EMBATTLE_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroEquip")
end

-- 更新光环+
function HeroEquip.UpdateEmbattleModel()
    HeroEquip._feature.embattlesID = GUIFunction:GetEmbattle(EDType)
    HeroEquip.CreateUIModel()
end

function HeroEquip.OnSexChange()
    HeroEquip._sex = SL:GetValue("SEX")
    HeroEquip.CreateUIModel()
    SL:SexChangeAddRed()
end

function HeroEquip.CreateUIModel()
    local NodeModel = HeroEquip._ui["Node_playerModel"]
    GUI:removeAllChildren(NodeModel)
    GUI:UIModel_Create(NodeModel, "Model", 0, 0, HeroEquip._sex, HeroEquip._feature, nil, {showHelmet = HeroEquip._feature.showHair})
end

HeroEquip.main()