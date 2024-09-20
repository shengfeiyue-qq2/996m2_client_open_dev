HeroBestRing = {}

HeroBestRing._ui = nil

-- 拖动区域默认尺寸
local TouchSize   = {width = 292, height = 219}

local EquipPosSet = {30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}

-- 装备数据类型
local EDType = GUIDefine.EquipDataType.HEROEQUIP

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function HeroBestRing.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.HeroBestRingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, isPC and "hero/hero_best_ring_box_win32" or "hero/hero_best_ring_box")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    HeroBestRing._ui = ui
    
    HeroBestRing._EquipPosSet = EquipPosSet

    TouchSize = GUI:getContentSize(HeroBestRing._ui["PanelTouch"])

    local PMainUI = HeroBestRing._ui["PMainUI"]
    
    -- 拖动层
    GUI:Win_SetDrag(parent, PMainUI)

    if isPC then
        GUI:setMouseEnabled(PMainUI, true)
    end

    GUI:Win_SetCloseCB(parent, HeroBestRing.OnClose)

    -- 关闭按钮
    GUI:addOnClickEvent(HeroBestRing._ui["CloseButton"], function ()
        UIOperator:CloseBestRingBoxUI(GUIDefine.RoleUIType.HERO)
    end)
    HeroBestRing.RegistEvent()
    HeroBestRing.RegisterMouseEvent()

    -- 初始化装备事件
    HeroBestRing.InitEquipLayerEvent()

    -- 自定义组件挂接
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerBestRing_hero})

    -- 交易行 截图节点 请勿删除 
    HeroBestRing._screenshotRootNode = PMainUI
end

function HeroBestRing.OnClose()
    HeroBestRing.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerBestRing_hero
    })
end

-- 注册事件
function HeroBestRing.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroBestRing", HeroBestRing.UpdateEquipPanelState)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroBestRing", HeroBestRing.UpdateEquipLayer)
end

-- 取消事件
function HeroBestRing.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, "HeroBestRing")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroBestRing")
end

-- 装备状态改变时刷新
function HeroBestRing.UpdateEquipPanelState(data)
    if not (data and next(data)) then
        return false
    end

    local makeIndex = data.MakeIndex
    local itemData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    if not itemData then
        return false
    end
    
    local pos = itemData.Where
    local equipPanel = HeroBestRing.GetPanel(pos)
    if not equipPanel then
        return false
    end

    local state = data.state and data.state > 0
    equipPanel._movingState = not state

    local itemNode = GUI:getChildByName(equipPanel, "Node")
    GUI:removeAllChildren(itemNode)

    local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
    HeroBestRing.CreateEquipItem(itemNode, equipData)

    HeroBestRing.SetIconVisible(equipPanel, false)
end

-----------------------------------------------------------------------------------------------------------------
-- 对装备进行操作时刷新
function HeroBestRing.UpdateEquipLayer(data)
    if not (data and next(data)) then
        return false
    end

    -- 操作类型
    local optType = data.opera
    local makeIndex = data.MakeIndex

    local pos = data.Where
    local equipPanel = HeroBestRing.GetPanel(pos)
    if not equipPanel then
        return false
    end
    equipPanel._movingState = false

    local itemNode = GUI:getChildByName(equipPanel, "Node")

    local iconVisible = false

    if GUIDefine.OprateType.ADD == optType then
        GUI:removeAllChildren(itemNode)

        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        HeroBestRing.CreateEquipItem(itemNode, equipData)
    elseif GUIDefine.OprateType.DEL == optType then
        GUI:removeAllChildren(itemNode)

        iconVisible = true
    elseif GUIDefine.OprateType.CHANGE == optType then
        local itemShow = GUI:getChildByTag(itemNode, makeIndex)
        if GUI:Win_IsNull(itemShow) then
            return false  
        end
        local equipData = GUIFunction:GetEquipDataByMakeIndex(makeIndex, EDType)
        GUI:ItemShow_OnRunFunc(itemShow, "UpdateGoodsItem", equipData)
    end

    HeroBestRing.SetIconVisible(equipPanel, iconVisible)
end

function HeroBestRing.RegisterMouseEvent()
    local getItemBagEmptyPos = function (touchPos)
        local x = touchPos.x
        local y = touchPos.y
        local pWorldPos = GUI:getWorldPosition(HeroBestRing._ui["PanelTouch"])

        local posXInPanel = x - pWorldPos.x
        local posYInPanel = pWorldPos.y - y

        if posXInPanel >= TouchSize.width or posXInPanel <= 0 then
            return false
        end
    
        if posYInPanel >= TouchSize.height or posYInPanel <= 0 then
            return false
        end
        
        local nRect = GUI:Rect(0, 0, TouchSize.width, TouchSize.height)
        local iPos  = {x = posXInPanel, y = posYInPanel}
        for _,pos in ipairs(HeroBestRing._EquipPosSet) do
            local itemNode = self:GetPanel(pos)
            if itemNode then
                local p = GUI:getPosition(itemNode)
                nRect.x = p.x - TouchSize.width / 2
                nRect.y = TouchSize.height - p.y - TouchSize.height / 2
                if iPos.x >= nRect.x and iPos.x <= nRect.x + nRect.width and iPos.y >= nRect.y and iPos.y <= nRect.y + nRect.height then
                    return pos
                end
            end
        end

        return nil
    end

    local addItemIntoEquip = function (touchPos)
        local isMoving = SL:GetValue("ITEM_MOVE_STATE")
        if not isMoving then
            return -1
        end
        
        local data = {}
        data.target = GUIDefine.ItemGoTo.BEST_RINGS
        data.pos = touchPos
        data.equipPos = getItemBagEmptyPos(touchPos)

        if isPC then
            SL:ScheduleOnce(function () SL:ItemMoveCheck(data) end, GUIDefine.CLICK_DOUBLE_TIME)
        else
            SL:ItemMoveCheck(data)
        end
        return 1
    end

    GUI:setSwallowTouches(HeroBestRing._ui["PanelTouch"], false)

    -- 注册从其他地方拖到玩家装备部位事件、PC右键点击移动
    GUI:addMouseButtonEvent(HeroBestRing._ui["PanelTouch"], {onSpecialRFunc = addItemIntoEquip})
end

-- 创建装备item
function HeroBestRing.CreateEquipItem(parent, data)
    local info = {}
    info.showModelEffect = true
    info.from            = GUIDefine.ItemGoTo.BEST_RINGS
    info.itemData        = data
    info.index           = data.Index
    info.noMouseTips     = true     -- 此处不在注册鼠标经过事件

    local itemShow = GUI:ItemShow_Create(parent, "item", 0, 0, info)
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    return itemShow
end


function HeroBestRing.UpdateMoveState(widget, state, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    -- true: 开始移动; false: 移动结束
    widget._movingState = state

    HeroBestRing.UpdateEquipStateChange(state, pos)
end

-- 移动状态变化时候刷新装备位
function HeroBestRing.UpdateEquipStateChange(state, pos)
    HeroBestRing.SetIconVisible(HeroBestRing.GetPanel(pos), state)
end

function HeroBestRing.OnDoubleEvent(pos)
    -- 道具是否处于移动中
    local isMoving = SL:GetValue("ITEM_MOVE_STATE")
    if isMoving then
        return false
    end

    -- 获取当前位置下卸下的装备数据
    local itemData = GUIFunction:GetEquipDataByPos(pos)
    if not itemData then
        return false
    end

    -- 卸下装备
    SL:OnTakeOffEquip({itemData = itemData, pos = itemData.Where})
end

function HeroBestRing.OnClickEvent(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end
    if widget._movingState then
        return false
    end
    HeroBestRing.OnOpenItemTips(widget, pos)
end

-- 装备为内观时显示同部位多件装备tips，否则显示单件
function HeroBestRing.OnOpenItemTips(widget, pos)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local itemData = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
    if not itemData then
        return false
    end

    local data = {}
    data.itemData   = itemData
    data.pos        = GUI:getWorldPosition(widget)
    data.from       = GUIDefine.ItemGoTo.BEST_RINGS
    data.lookPlayer = false

    UIOperator:OpenItemTips(data)
end

-- 初始化点击（包含鼠标）事件
function HeroBestRing.InitEquipLayerEvent()
    local InitPanel = function (widget, pos)
        local params = {
            pos       = pos,
            from      = GUIDefine.ItemFrom.BEST_RINGS,
            dataType  = EDType,
            moveCallBack = HeroBestRing.UpdateMoveState,
            onClick   = HeroBestRing.OnClickEvent,
            onPress   = HeroBestRing.OnClickEvent,
            onDouble  = HeroBestRing.OnDoubleEvent
        }
        
        GUI:setTouchEnabled(widget, true)
        GUI:addOnTouchEvent(widget, function (sender, eventType)
            GUIFunction:DealEquipTouch(sender, eventType, params)
        end)

        if isPC then
            GUIFunction:InitItemTipsScrollEvent(widget, "HeroBestRing")
            GUIFunction:InitMouseMoveToEquipEvent(widget, pos, HeroBestRing.OnOpenItemTips)
        end
    end

    for _,pos in ipairs(HeroBestRing._EquipPosSet) do
        local widget = HeroBestRing.GetPanel(pos)
        local iconVisible = true
        local data = GUIFunction:GetEquipDataByPos(pos, nil, EDType)
        if data then
            HeroBestRing.CreateEquipItem(GUI:getChildByName(widget, "Node"), data)
            InitPanel(widget, pos)
            iconVisible = false
        end
        HeroBestRing.SetIconVisible(widget, iconVisible)
    end
end

function HeroBestRing.SetIconVisible(widget, visible)
    local DefaultIcon = GUI:getChildByName(widget, "DefaultIcon")
    if DefaultIcon then
        GUI:setVisible(DefaultIcon, visible)
    end
    local itemNode = GUI:getChildByName(widget, "Node")
    if itemNode then
        GUI:setVisible(itemNode, not visible)
    end
end

function HeroBestRing.GetPanel(pos)
    return HeroBestRing._ui["PanelPos"..pos]
end

HeroBestRing.main()