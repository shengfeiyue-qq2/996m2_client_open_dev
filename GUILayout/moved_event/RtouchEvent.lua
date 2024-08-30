RtouchEvent = RtouchEvent or {}

RtouchEvent.onMoving        = false
RtouchEvent.moveBegin       = {}
RtouchEvent.moveNode        = nil
RtouchEvent.beginPos        = nil
RtouchEvent.cancelCallBack  = nil
RtouchEvent.isMoving        = false

function RtouchEvent.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.RightTouchEventGUI) then
        return
    end
    RtouchEvent._parent = GUI:Win_Create(UIConst.LAYERID.RightTouchEventGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.RTOUCH)

    GUI:LoadExport(RtouchEvent._parent, "moved_layer/rtouch_layer")

    RtouchEvent._ui = GUI:ui_delegate(RtouchEvent._parent)

    if not RtouchEvent._ui then
        return false
    end
    RtouchEvent.panel = RtouchEvent._ui["Panel_1"]
    GUI:setSwallowTouches(RtouchEvent.panel, false)
    GUI:setContentSize(RtouchEvent.panel, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))

    RtouchEvent.RegisterEvent()

    local function onMouseDown(touch)
        RtouchEvent.isMoving = true
        SL:ActorPickerMouseRightBeganEvent(touch)
        SL:KeepMovingBegin(touch)
    end

    local function onMouseMoving(touch)
        if RtouchEvent.isMoving then
            local data = {
                way = global.MMO.MOVE_EVENT_MOUSE_R,
                pos = touch
            }
            global.Facade:sendNotification(global.NoticeTable.keepMovingUpdate, data)
        end
        SL:MouseMoveWorldEvent(touch)
    end

    local function onMouseUp()
        RtouchEvent.ChangeState(false)
    end

    local function onSpecialR(touch)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = GUIDefine.ItemGoTo.DROP
            local data = {}
            data.target = goToName
            data.pos = touch
            SL:ItemMoveCheck(data)
        end
    end

    GUI:addMouseButtonEvent(RtouchEvent.panel, {
        onRightDownFunc = onMouseDown,
        onRightUpFunc   = onMouseUp,
        onSpecialRFunc  = onSpecialR,
        onMovingFunc    = onMouseMoving,
        needTouchPos    = true
    })
end

function RtouchEvent.ChangeState(bool)
    RtouchEvent.isMoving = bool
    if not bool then
        SL:KeepMovingEnded()
    end
end

function RtouchEvent.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_RTOUCH_STATE_CHANGE,  "RtouchEvent", RtouchEvent.ChangeState)
end

function RtouchEvent.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_RTOUCH_STATE_CHANGE, "RtouchEvent")
end

RtouchEvent.main()