MoveEvent = MoveEvent or {}

--[[
    README:
    在移动端时 本层内的节点移动响应于目标节点的触摸事件 所以不能直接移出目标节点
]]
MoveEvent.onMoving = false
MoveEvent.moveBegin = {}
MoveEvent.moveNode = nil
MoveEvent.goodsItem = nil
MoveEvent.beginPos = nil
MoveEvent.cancelCallBack = nil
local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
function MoveEvent.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.MoveEventGUI) then
        return
    end
    MoveEvent._parent = GUI:Win_Create(UIConst.LAYERID.MoveEventGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.MOUSE)

    GUI:LoadExport(MoveEvent._parent, "moved_layer/moved_event_layer")

    MoveEvent._ui = GUI:ui_delegate(MoveEvent._parent)

    if not MoveEvent._ui then
        return false
    end
    MoveEvent.panel = MoveEvent._ui["Panel_1"]
    GUI:setSwallowTouches(MoveEvent.panel, false)
    GUI:setContentSize(MoveEvent.panel, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))

    MoveEvent.RegisterEvent()

    local function onMouseBegin(pos)
        MoveEvent.SetMoveBeginPos(pos)
        return -1
    end
    local function onMouseDownR(pos)
        MoveEvent.SetMoveBeginPos(pos)
        return -1
    end
    local function onMouseMoving(updatePos)
        MoveEvent.SetMoveBeginPos(updatePos)
        SL:ItemMoveUpdate({pos = updatePos})
    end
    --注册游戏触摸事件
    GUI:addMouseButtonEvent(MoveEvent.panel, {
        onSpecialRFunc  = onMouseBegin,
        onMovingFunc    = onMouseMoving,
        onRightDownFunc = onMouseDownR,
        needTouchPos    = true,
        swallow         = -1
    })

end

function MoveEvent.SetMoveBeginPos(pos)
    MoveEvent.beginPos = pos
end

function MoveEvent.UpdatePostion(data)
    if MoveEvent.moveNode and next(MoveEvent.moveBegin) and next(data.pos) and data.pos then
        local movePos = data.pos
        GUI:setPosition(MoveEvent.moveNode, movePos.x, movePos.y)
    end
end

function MoveEvent.OnMoveCancelEvent(data) 
    local movedData = SL:GetValue("ITEM_MOVE_DATA")
    local needMove = true
    if data then
        if data.MakeIndex then
            if not movedData or data.MakeIndex ~= movedData.MakeIndex then
                needMove  = false
            end
        elseif data.from then
            if data.from ~= MoveEvent.from then
                needMove = false
            end
        end
    end
    if not needMove then
        return
    end
    if MoveEvent.goodsItem and not GUI:Widget_IsNull(MoveEvent.goodsItem) then
        GUI:ItemShow_resetMoveState(MoveEvent.goodsItem)
    end
    if MoveEvent.cancelCallBack then
        MoveEvent.cancelCallBack()
    end
    MoveEvent.RemoveChildrenAndCleanNode()
end

function MoveEvent.RemoveChildrenAndCleanNode()
    GUI:removeAllChildren(MoveEvent.panel)
    SL:SetValue("ITEM_MOVE_DATA", nil, nil)
    MoveEvent.onMoving = false
    MoveEvent.moveBegin = {}
    MoveEvent.moveNode = nil
    MoveEvent.goodsItem = nil
    MoveEvent.cancelCallBack = nil
    MoveEvent.beginPos = nil
end

function MoveEvent.OnSpecialCanel(type)
    if type and MoveEvent.from then
        if type == MoveEvent.from then
            SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL)
        end
    end
end

function MoveEvent.CreateMoveItem(data)
    if MoveEvent.onMoving then --替换
        MoveEvent.OnMoveCancelEvent()
    end
    local pos = data.pos
    MoveEvent.moveBegin = MoveEvent.beginPos or pos
    MoveEvent.from = data.from
    
    if data.movingNode then
        local node = data.movingNode
        GUI:removeFromParent(node)
        GUI:setTouchEnabled(node, false)
        GUI:setPosition(node, MoveEvent.moveBegin.x, MoveEvent.moveBegin.y)
        GUI:addChild(MoveEvent.panel, node)
        MoveEvent.moveNode = node
    end

    if data.itemData then
        local info = {}
        info.itemData = data.itemData
        info.index = data.itemData.Index
        info.noMouseTips = true
        info.noLockTips = true
        info.noFullTips = true
        info.moveItem = true
        local goodItem = GUI:ItemShow_Create(MoveEvent.panel, "goodsItem", MoveEvent.moveBegin.x, MoveEvent.moveBegin.y, info)
        GUI:setAnchorPoint(goodItem, 0.5, 0.5)
        MoveEvent.moveNode = goodItem
        SL:PlayClickItemSound(data.itemData)
    end

    SL:SetValue("ITEM_MOVE_DATA", data.itemData, MoveEvent.from, data.skillId)
    SL:SetValue("ITEM_MOVE_LINK_FUNC", data.linkFunc)

    MoveEvent.goodsItem = data.goodsItem
    MoveEvent.cancelCallBack = data.cancelCallBack
    MoveEvent.onMoving = true
end

function MoveEvent.CheckMoveEndPos(data)
    -- 除开window端手动发送鼠标事件 模拟点击
    SL:MouseMoveEvent(data)
    MoveEvent.RemoveChildrenAndCleanNode()
end

function MoveEvent.MoveItemUpDate(data)
    if not data or not next(data) then
        return
    end
    if data.cancelCallBack then
        MoveEvent.cancelCallBack = data.cancelCallBack
    end
    if data.goodItem then
        MoveEvent.goodsItem = data.goodItem
    end
end

function MoveEvent.OnSpecialCancelStorage(data)
    MoveEvent.OnSpecialCanel(GUIDefine.ItemFrom.STORAGE)
end

function MoveEvent.CancelBagMove(data)
    if not data or not next(data) then
        return
    end
    local type = data.opera
    local itemData = data.operID
    if not itemData or not next(itemData) then
        return
    end
    if type == 2 then
        for k,v in pairs(itemData) do
            --移动中处理
            local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
            local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
            if itemMoving and itemMovingData then --在道具移动中
                if v.MakeIndex == itemMovingData.MakeIndex then
                    SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL)
                end
            end
        end
    end
end

function MoveEvent.CancelEquipMove(data)
    if not data or not next(data) then
        return
    end
    local type = data.opera
    local makeIndex = data.MakeIndex
    if type == 2 then
        local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
        local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
        if itemMoving and itemMovingData then --在道具移动中
            if makeIndex == itemMovingData.MakeIndex then
                SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL)
            end
        end
    end
end

function MoveEvent.CancelQuickUseMove(data)
    if not data or not next(data) then
        return false
    end
    if data.opra ~= GUIDefine.OperateType.DEL then
        return false
    end
    local itemData = data.itemData
    if not itemData or not next(itemData) then
        return
    end
    local itemMoving = SL:GetValue("ITEM_MOVE_STATE")
    local itemMovingData = SL:GetValue("ITEM_MOVE_DATA")
    if itemMoving and itemMovingData then --在道具移动中
        if itemData.MakeIndex == itemMovingData.MakeIndex then
            SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL)
        end
    end
end

function MoveEvent.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER,  "MoveEvent", MoveEvent.CancelQuickUseMove)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_BEGIN,   "MoveEvent", MoveEvent.CreateMoveItem)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_MOVING,  "MoveEvent", MoveEvent.UpdatePostion)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_END,     "MoveEvent", MoveEvent.CheckMoveEndPos)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL,  "MoveEvent", MoveEvent.OnMoveCancelEvent)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_UP_DATA, "MoveEvent", MoveEvent.MoveItemUpDate)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE,     "MoveEvent", MoveEvent.CancelBagMove)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MoveEvent", MoveEvent.CancelEquipMove)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE,   "MoveEvent", MoveEvent.CancelEquipMove)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_STORAGE_CLOSE,   "MoveEvent", MoveEvent.OnSpecialCancelStorage)
end

function MoveEvent.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER,     "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_BEGIN,      "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_MOVING,     "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_END,        "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL,     "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_UP_DATA,    "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE,        "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE,    "MoveEvent")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE,      "MoveEvent")
end

MoveEvent.main()