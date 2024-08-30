SightBead = SightBead or {}
local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
function SightBead.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.SightBeadGUI) then
        return
    end
    SightBead._parent = GUI:Win_Create(UIConst.LAYERID.SightBeadGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.MOUSE)

    GUI:LoadExport(SightBead._parent, "moved_layer/moved_event_layer")

    SightBead._ui = GUI:ui_delegate(SightBead._parent)

    if not SightBead._ui then
        return false
    end
    SightBead._sightbeadimg = nil --准星图标  没有触摸
    SightBead.panel = SightBead._ui["Panel_1"]
    GUI:setSwallowTouches(SightBead.panel, false)

    SightBead._isshow = false
    local publicRes = SLDefine.PATH_RES_PUBLIC
    if isWinMode then
        publicRes = SLDefine.PATH_RES_PUBLIC_WIN32
    end
    local imgUrl = publicRes .. "zhunxing.png"
    SightBead._sightbeadimg = GUI:Image_Create(SightBead._parent, "img", 0.00, 0.00, imgUrl)
    GUI:setTouchEnabled(SightBead._sightbeadimg, false)
    GUI:setSwallowTouches(SightBead._sightbeadimg, false)
    GUI:setVisible(SightBead._sightbeadimg, false)

    SightBead.beadImgSize = GUI:getContentSize(SightBead._sightbeadimg)

    SightBead.RegisterTouch(false)
    SightBead.RegisterEvent()


    local function onMouseMoving(pos)
        SightBead.SetMoveBeginPos(pos)
    end

    local function onSpecialR(touch)
        return -1
    end

    local function onMouseDownR()
        if BagData.GetBagCollimator() then
            BagData.ClearBagCollimator()
            SL:RequestCancelCollimator()
            SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE)
        end
    end

    GUI:addMouseButtonEvent(SightBead.panel, {
        onMovingFunc    = onMouseMoving,
        onRightDownFunc = onMouseDownR,
        onSpecialRFunc  = onSpecialR,
        needTouchPos = true,
        swallow = -1
    })
end

--注册触摸
function SightBead.RegisterTouch( is_register )
    if is_register then
        local visibleSize = nil
        if not isWinMode then
            visibleSize = SL:GetValue("SCREEN_SIZE")
        else
            visibleSize = { width=0, height=0 }
        end
        GUI:setContentSize(SightBead.panel, visibleSize.width, visibleSize.height)
    else
        GUI:setContentSize(SightBead.panel, 0, 0)
    end
end

--设置移动位置  pos: 位置
function SightBead.SetMoveBeginPos(pos)
    if SightBead._isshow and pos then
        GUI:setPosition(SightBead._sightbeadimg, pos.x - SightBead.beadImgSize.width/2, pos.y - SightBead.beadImgSize.height/2)
    end
end

--显示准星  data：准星开始显示的位置
function SightBead.OnShow(data)
    if SightBead._sightbeadimg then
        SightBead._isshow = true
        SightBead.RegisterTouch(true)
        local visibleSize = SL:GetValue("SCREEN_SIZE")
        local pos = data and data.pos or {x = visibleSize.width/2, y = visibleSize.height/2}
        GUI:setPosition(SightBead._sightbeadimg, pos.x - SightBead.beadImgSize.width/2, pos.y - SightBead.beadImgSize.height/2)
        GUI:setVisible(SightBead._sightbeadimg, true)
    end
end

--隐藏准星
function SightBead.OnHide()
    if SightBead._sightbeadimg then
        SightBead._isshow = false
        SightBead.RegisterTouch(false)
        GUI:setVisible(SightBead._sightbeadimg, false)
    end
end

function SightBead.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE,   "SightBead", SightBead.OnHide)-- 隐藏准星 
    SL:RegisterLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW,   "SightBead", SightBead.OnShow)-- 显示准星
end

function SightBead.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SIGHT_BEAD_HIDE,   "SightBead")
    SL:UnRegisterLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW,   "SightBead")
end

SightBead.main()