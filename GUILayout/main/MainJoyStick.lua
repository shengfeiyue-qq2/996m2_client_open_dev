MainJoyStick = {}

local joystickTypes         = { Walk = 1, Run = 2}
local resPath               = GUIDefine.PATH_RES_PRIVATE .. "main/Rocker/"
local enableSizeWalk        = GUI:Size(150, 160)     -- 双摇杆 走
local enableSizeRun         = GUI:Size(370, 370)     -- 双摇杆 跑
local enableSizeAll         = GUI:Size(290, 335)     -- 单摇杆 走 跑local 
local originPosWalk         = GUI:p(100, 105)        -- 双摇杆 走
local originPosRun          = GUI:p(200, 205)        -- 双摇杆 跑
local originPosAll          = GUI:p(150, 155)        -- 双摇杆 跑

function MainJoyStick.main()
    MainJoyStick._debugDir = {x = 0, y = 0}
    MainJoyStick.InitJoySticks()
    MainJoyStick.RegisterEvent()
    MainJoyStick.InitDebugKeyboard()
end

function MainJoyStick.InitJoySticks()
    if not MainJoyStick._nodeRun then 
        MainJoyStick._nodeRun = MainJoyStick.CreateNode(joystickTypes.Run) 
        GUI:setLocalZOrder(MainJoyStick._nodeRun, -1)
    end

    if not MainJoyStick._nodeWalk then 
        MainJoyStick._nodeWalk = MainJoyStick.CreateNode(joystickTypes.Walk) 
        GUI:setLocalZOrder(MainJoyStick._nodeWalk,-1)
    end
end

function MainJoyStick.CreateNode(type)
    local parent = GUI:Attach_Bottom()
    local MainJoyStickNode = GUI:Widget_Create(parent, "MainJoyStick_"..type, 0, 0, 0, 0)
    MainJoyStickNode._angle             = 0xff  -- joystick 方向(度数)
    MainJoyStickNode._joystickType      = type -- 1走摇杆  2跑摇杆
    MainJoyStickNode._enableSize        = MainJoyStickNode._joystickType == joystickTypes.Walk and enableSizeWalk or enableSizeRun -- 触摸有效区
    MainJoyStickNode._bgOrigin          = MainJoyStickNode._joystickType == joystickTypes.Walk and originPosWalk or originPosRun  -- 背景默认位置
    -- 背景
    local path                      = resPath .. (MainJoyStickNode._joystickType == joystickTypes.Walk and "1900012073.png" or "1900012073.png")
    MainJoyStickNode._bg            = GUI:Image_Create(MainJoyStickNode, "bg", MainJoyStickNode._bgOrigin.x, MainJoyStickNode._bgOrigin.y, path)

    local bgSize                    = GUI:getContentSize(MainJoyStickNode._bg)
    MainJoyStickNode._bgSize            = bgSize
    MainJoyStickNode._limitRadius       = bgSize.width * 0.3 -- joystick限制半径
    MainJoyStickNode._limitRadiusSq     = MainJoyStickNode._limitRadius * MainJoyStickNode._limitRadius -- 半径的平方
    MainJoyStickNode._joystickOrigin    = GUI:p(bgSize.width * 0.5, bgSize.height * 0.5) -- joystick 原点

    GUI:setContentSize(MainJoyStickNode, MainJoyStickNode._enableSize)
    GUI:setCascadeOpacityEnabled(MainJoyStickNode._bg, true)
    GUI:setAnchorPoint(MainJoyStickNode._bg, 0.5, 0.5)
    -- 摇杆
    MainJoyStickNode._gamePad = GUI:Image_Create(MainJoyStickNode, "JoyStick", bgSize.width / 2, bgSize.height / 2, resPath .. "1900012070.png")  
    GUI:setAnchorPoint(MainJoyStickNode._gamePad, 0.5, 0.5)

    -- 走跑提醒
    local contentSize = GUI:getContentSize(MainJoyStickNode._gamePad)
    local fileName    = resPath .. (MainJoyStickNode._joystickType == joystickTypes.Walk and "1900012076.png" or "1900012075.png")
    MainJoyStickNode._joystickTips = GUI:Image_Create(MainJoyStickNode._gamePad, "tips", contentSize.width / 2, contentSize.height / 2, fileName)   
    GUI:setAnchorPoint(MainJoyStickNode._joystickTips, 0.5, 0.5)

    -- 箭头
    MainJoyStickNode._arrowTips = GUI:Image_Create(MainJoyStickNode._bg, "tips", 0, 0, resPath .. "1900012074.png")     
    GUI:setAnchorPoint(MainJoyStickNode._arrowTips, 0.5, 0.5)

    -- 走/跑切换
    MainJoyStickNode._buttonMode = GUI:Button_Create(MainJoyStickNode, "changeMode",0, 28, resPath .. "bg_jindutiao_16.png") 
    
    GUI:addOnClickEvent(MainJoyStickNode._buttonMode, function()
        local joystickMode = SL:GetValue("CLOUD_DATA_BY_KEY", "joystick_mode") or 2
        SL:SetValue("CLOUD_DATA_BY_KEY", "joystick_mode", 3 - joystickMode)
        SL:onLUAEvent(LUA_EVENT_MAIN_JOYSTICKUPDATE)
    end)

    MainJoyStick.SetBgVisible(MainJoyStickNode, false)
    MainJoyStick.SetTipsVisible(MainJoyStickNode, false)
    MainJoyStick.RegisterTouchListener(MainJoyStickNode)
    MainJoyStick.UpdateJoystickMode(MainJoyStickNode)
    MainJoyStick.OnShowDistanceChange(MainJoyStickNode)

    return MainJoyStickNode
end

function MainJoyStick.OnTouchBegan(sender, type)
    if not GUI:getVisible(sender) then
        return false
    end
    local worldPosition = GUI:getTouchBeganPosition(sender)
    if not MainJoyStick.CheckGamePadRect(sender, worldPosition) then -- 是否在点击rect
        return false
    end

    MainJoyStick.SetBgVisible(sender, true)
    MainJoyStick.SetTipsVisible(sender, false)
    MainJoyStick.JoystickLogic(sender, worldPosition)

    return true
end

function MainJoyStick.OnTouchMoved(sender, type)
    local worldPosition = GUI:getTouchMovePosition(sender)
    MainJoyStick.JoystickLogic(sender, worldPosition)
end

function MainJoyStick.OnTouchEnded(sender, type)
    local touchEndPosition = GUI:getTouchEndPosition(sender)

    MainJoyStick.Ray2Scene(sender, touchEndPosition)

    MainJoyStick.ResetGamePad(sender)
end

function MainJoyStick.Ray2Scene(MainJoyStickNode, worldPosition)
    if MainJoyStickNode._angle ~= 0xFF then
        return
    end

    local touchPoint = GUI:convertToNodeSpace(MainJoyStickNode, worldPosition)
    SL:ActorPickerMouseLeftBeganEvent(touchPoint)
end

function MainJoyStick.CheckGamePadRect(MainJoyStickNode, worldPosition)
    local bOutSide    = true
    local touchPoint  = GUI:convertToNodeSpace(MainJoyStickNode, worldPosition)
    local gamePadRect = GUI:Rect(0, 0, MainJoyStickNode._enableSize.width, MainJoyStickNode._enableSize.height)

    if (GUI:RectContainsPoint(gamePadRect, touchPoint)) then
        GUI:setPosition(MainJoyStickNode._bg, touchPoint)
        bOutSide = false
    end

    return not bOutSide
end

function MainJoyStick.SetBgVisible(MainJoyStickNode, visible)
    GUI:setVisible(MainJoyStickNode._bg, visible)
end

function MainJoyStick.SetTipsVisible(MainJoyStickNode, visible)
    GUI:setVisible(MainJoyStickNode._arrowTips, visible)
end

function MainJoyStick.JoystickLogic(MainJoyStickNode, worldPosition)
    -- swallow touch
    GUI:setSwallowTouches(MainJoyStickNode, true)

    local touchPoint    = GUI:convertToNodeSpace(MainJoyStickNode._bg, worldPosition)
    local targPos, step = MainJoyStick.CalcTargPos(MainJoyStickNode, touchPoint)
    local bgOriginPos   = GUI:p(GUI:getPositionX(MainJoyStickNode._bg) - MainJoyStickNode._bgSize.width/2, GUI:getPositionY(MainJoyStickNode._bg) - MainJoyStickNode._bgSize.height/2)
    GUI:setPosition(MainJoyStickNode._gamePad, GUI:pAdd(bgOriginPos, targPos))
    GUI:stopAllActions(MainJoyStickNode._gamePad)

    MainJoyStick.SetGamePadDir(MainJoyStickNode, GUI:pSub(targPos, MainJoyStickNode._joystickOrigin), step)
end

function MainJoyStick.CalcTargPos(MainJoyStickNode, movePos)
    local diff = GUI:pSub(movePos, MainJoyStickNode._joystickOrigin)
    local distSq = GUI:pLengthSQ(diff)

    if (distSq <= MainJoyStickNode._limitRadiusSq) then
        return movePos, 1
    end

    -- out of bound, clamp it.
    diff = GUI:pNormalize(diff)
    diff = GUI:pMul(diff, MainJoyStickNode._limitRadius)

    return GUI:pAdd(MainJoyStickNode._joystickOrigin, diff), 2
end

function MainJoyStick.SetGamePadDir(MainJoyStickNode, vec, step)
    local dis = GUI:pLengthSQ(vec)
    if (dis <= 50) then --// 触摸盲区
        MainJoyStickNode._angle = 0xff
        MainJoyStickNode._step  = 1

        MainJoyStick.SetTipsVisible(MainJoyStickNode, false)
    else
        MainJoyStickNode._angle = math.deg(GUI:pToAngleSelf(vec))
        MainJoyStickNode._step  = step

        MainJoyStick.CheckArrowTips(MainJoyStickNode)
    end
end

function MainJoyStick.CheckArrowTips(MainJoyStickNode)
    local angle    = 90 - MainJoyStickNode._angle
    GUI:setRotation(MainJoyStickNode._arrowTips, angle)
    
    local radius   = MainJoyStickNode._bgSize.width / 2 + 10
    local sinValue = math.sin(MainJoyStickNode._angle / 57.29577951)
    local cosValue = math.cos(MainJoyStickNode._angle / 57.29577951)
    local offsetX  = radius * cosValue
    local offsetY  = radius * sinValue
    GUI:setPosition(MainJoyStickNode._arrowTips, MainJoyStickNode._bgSize.width / 2 + offsetX, MainJoyStickNode._bgSize.height / 2 + offsetY)

    MainJoyStick.SetTipsVisible(MainJoyStickNode, true)
end

function MainJoyStick.ResetGamePad(MainJoyStickNode)
    GUI:setSwallowTouches(MainJoyStickNode, false)

    MainJoyStickNode._angle      = 0xFF
    MainJoyStickNode._move       = 1
    MainJoyStick.SetBgVisible(MainJoyStickNode, false)
    MainJoyStick.SetTipsVisible(MainJoyStickNode, false)
    GUI:setPosition(MainJoyStickNode._bg, MainJoyStickNode._bgOrigin)
    GUI:stopAllActions(MainJoyStickNode._gamePad)
    GUI:runAction(MainJoyStickNode._gamePad, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.3, MainJoyStickNode._bgOrigin.x, MainJoyStickNode._bgOrigin.y)))
end

function MainJoyStick.GetGamePadAngle(MainJoyStickNode)
    return MainJoyStickNode._angle
end

function MainJoyStick.GetGamePadStep(MainJoyStickNode)
    return MainJoyStickNode._step
end

function MainJoyStick.RegisterTouchListener(MainJoyStickNode)
    GUI:setTouchEnabled(MainJoyStickNode, true)
    GUI:addOnTouchEvent(MainJoyStickNode, function (sender, type)
        if type == GUIDefine.TouchEventType.BEGAN then 
            MainJoyStick.OnTouchBegan(sender, type)
        elseif type == GUIDefine.TouchEventType.MOVED then 
            MainJoyStick.OnTouchMoved(sender, type)
        elseif type == GUIDefine.TouchEventType.ENDED then 
            MainJoyStick.OnTouchEnded(sender, type)
        elseif type == GUIDefine.TouchEventType.CANCALED then 
            MainJoyStick.OnTouchEnded(sender, type)
        end
    end)
    GUI:setSwallowTouches(MainJoyStickNode, false)
end

function MainJoyStick.SetDir(MainJoyStickNode, dir)
    if not dir or not dir.x or not dir.y then
        return
    end

    local targPos1      = GUI:p((dir.x + 1) * MainJoyStickNode._bgSize.width * 0.5, (dir.y + 1) * MainJoyStickNode._bgSize.height * 0.5)
    local targPos       = MainJoyStick.CalcTargPos(MainJoyStickNode, targPos1)
    local bgOriginPos   = GUI:p(GUI:getPositionX(MainJoyStickNode._bg)-MainJoyStickNode._bgSize.width/2, GUI:getPositionY(MainJoyStickNode._bg) - MainJoyStickNode._bgSize.height/2)
    GUI:stopAllActions(MainJoyStickNode._gamePad)
    GUI:setPosition(MainJoyStickNode._gamePad, GUI:pAdd(bgOriginPos, targPos))

    MainJoyStick.SetGamePadDir(MainJoyStickNode, GUI:pSub(targPos, MainJoyStickNode._joystickOrigin))
    MainJoyStick.CheckArrowTips(MainJoyStickNode)

    if 0 == dir.x and 0 == dir.y then
        MainJoyStick.ResetGamePad(MainJoyStickNode)
    else
        MainJoyStick.SetBgVisible(MainJoyStickNode, true)
        MainJoyStick.SetTipsVisible(MainJoyStickNode, true)
    end
end

function MainJoyStick.UpdateJoystickMode(MainJoyStickNode)
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_ONE_DOUBLE_ROCKER) ~= 1 or (SL:GetValue("GAME_DATA","gameOption_WalkOnly") == 1) then
        -- 单摇杆
        -------------------------
        MainJoyStickNode._enableSize        = enableSizeAll     -- 触摸有效区
        MainJoyStickNode._bgOrigin          = originPosAll      -- 背景默认位置
        GUI:setContentSize(MainJoyStickNode, MainJoyStickNode._enableSize)
        GUI:setPosition(MainJoyStickNode._bg, MainJoyStickNode._bgOrigin.x, MainJoyStickNode._bgOrigin.y)

        -- 摇杆背景
        GUI:Image_loadTexture(MainJoyStickNode._bg, resPath .. "1900012073.png")
        local bgSize                        = GUI:getContentSize(MainJoyStickNode._bg)
        MainJoyStickNode._limitRadius       = bgSize.width * 0.3 -- joystick限制半径
        MainJoyStickNode._limitRadiusSq     = MainJoyStickNode._limitRadius * MainJoyStickNode._limitRadius -- 半径的平方
        MainJoyStickNode._joystickOrigin    = GUI:p(bgSize.width * 0.5, bgSize.height * 0.5) -- joystick 原点
        MainJoyStickNode._bgSize            = bgSize

        -- 摇杆中间球
        GUI:Image_loadTexture(MainJoyStickNode._gamePad, resPath .. "1900012070.png")
        GUI:setPosition(MainJoyStickNode._gamePad, 0, 0)
        local gamePadSize = GUI:getContentSize(MainJoyStickNode._gamePad)
        GUI:setPosition(MainJoyStickNode._joystickTips, gamePadSize.width/2, gamePadSize.height/2)
        -------------------------

        -- 摇杆
        local joystickMode = SL:GetValue("CLOUD_DATA_BY_KEY", "joystick_mode") or 2
        if joystickMode == joystickTypes.Walk then
            -- 走
            GUI:setVisible(MainJoyStickNode, MainJoyStickNode._joystickType == joystickTypes.Walk)
            GUI:Button_loadTextureNormal(MainJoyStickNode._buttonMode, resPath .. "bg_jindutiao_17.png")
            GUI:setVisible(MainJoyStickNode._buttonMode, true)
        else
            -- 跑
            GUI:setVisible(MainJoyStickNode, MainJoyStickNode._joystickType == joystickTypes.Run)
            GUI:Button_loadTextureNormal(MainJoyStickNode._buttonMode, resPath .. "bg_jindutiao_16.png")
            GUI:setVisible(MainJoyStickNode._buttonMode, true)
        end

        -- 走 -> 跑
        if (SL:GetValue("GAME_DATA","gameOption_WalkOnly") == 1) then
            GUI:setVisible(MainJoyStickNode, MainJoyStickNode._joystickType == joystickTypes.Run)
            GUI:setVisible(MainJoyStickNode._buttonMode, false)
        end
    else
        -- 双摇杆
        -------------------------
        -- 响应区域
        MainJoyStickNode._enableSize        = (MainJoyStickNode._joystickType == joystickTypes.Walk and enableSizeWalk or enableSizeRun) -- 触摸有效区
        MainJoyStickNode._bgOrigin          = (MainJoyStickNode._joystickType == joystickTypes.Walk and originPosWalk or originPosRun)  -- 背景默认位置
        GUI:setContentSize(MainJoyStickNode, MainJoyStickNode._enableSize)
        GUI:setPosition(MainJoyStickNode._bg, MainJoyStickNode._bgOrigin)
        
        -- 背景
        GUI:Image_loadTexture(MainJoyStickNode._bg, resPath .. (MainJoyStickNode._joystickType == joystickTypes.Walk and "1900012072.png" or "1900012073.png"))
        local bgSize                        = GUI:getContentSize(MainJoyStickNode._bg)
        MainJoyStickNode._bgSize            = bgSize
        MainJoyStickNode._limitRadius       = bgSize.width * 0.5 -- joystick限制半径
        MainJoyStickNode._limitRadiusSq     = MainJoyStickNode._limitRadius * MainJoyStickNode._limitRadius -- 半径的平方
        MainJoyStickNode._joystickOrigin    = GUI:p(bgSize.width * 0.5, bgSize.height * 0.5) -- joystick 原点

        -- 摇杆中间球
        GUI:Image_loadTexture(MainJoyStickNode._gamePad, resPath .. (MainJoyStickNode._joystickType == joystickTypes.Walk and "1900012070.png" or "1900012071.png"))
        GUI:setPosition(MainJoyStickNode._gamePad, MainJoyStickNode._bgSize.width / 2, MainJoyStickNode._bgSize.height / 2)
        local gamePadSize = GUI:getContentSize(MainJoyStickNode._gamePad)
        GUI:setPosition(MainJoyStickNode._joystickTips, gamePadSize.width/2, gamePadSize.height/2)
        -------------------------

        -- 遥感显示隐藏
        GUI:setVisible(MainJoyStickNode, true)
        GUI:setVisible(MainJoyStickNode._buttonMode, false)
    end

    MainJoyStick.ResetGamePad(MainJoyStickNode)
end

function MainJoyStick.OnShowDistanceChange(MainJoyStickNode)
    local value = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_ROCKER_SHOW_DISTANCE)
    local distance = value and value[1] or 0
    GUI:setPosition(MainJoyStickNode, distance, 0)
end

function MainJoyStick.InitDebugKeyboard()
    if SL._DEBUG then
        local function released_callback(keycode, evt)
            if keycode == SLDefine.KeyCode.KEY_D then
                MainJoyStick._debugDir.x = MainJoyStick._debugDir.x - 1
            elseif keycode == SLDefine.KeyCode.KEY_A then
                MainJoyStick._debugDir.x = MainJoyStick._debugDir.x + 1
            elseif keycode == SLDefine.KeyCode.KEY_W then
                MainJoyStick._debugDir.y = MainJoyStick._debugDir.y - 1
            elseif keycode == SLDefine.KeyCode.KEY_S then
                MainJoyStick._debugDir.y = MainJoyStick._debugDir.y + 1
            end
            
            if GUI:getVisible(MainJoyStick._nodeRun) then
                MainJoyStick.SetDir(MainJoyStick._nodeRun, MainJoyStick._debugDir)
            else
                MainJoyStick.SetDir(MainJoyStick._nodeWalk, MainJoyStick._debugDir)
            end
        end
        
        local function pressed_callback(keycode, evt)
            if keycode == SLDefine.KeyCode.KEY_D then
                MainJoyStick._debugDir.x = MainJoyStick._debugDir.x + 1
            elseif keycode == SLDefine.KeyCode.KEY_A then
                MainJoyStick._debugDir.x = MainJoyStick._debugDir.x - 1
            elseif keycode == SLDefine.KeyCode.KEY_W then
                MainJoyStick._debugDir.y = MainJoyStick._debugDir.y + 1
            elseif keycode ==  SLDefine.KeyCode.KEY_S then
                MainJoyStick._debugDir.y = MainJoyStick._debugDir.y - 1
            end
            
            if GUI:getVisible(MainJoyStick._nodeRun) then
                MainJoyStick.SetDir(MainJoyStick._nodeRun, MainJoyStick._debugDir)
            else
                MainJoyStick.SetDir(MainJoyStick._nodeWalk, MainJoyStick._debugDir)
            end
        end
        GUI:addKeyboardEventEx(pressed_callback, released_callback)
    end
end

--获取摇杆 移动的方向和步数 勿删
function MainJoyStick.GetGamePadMove()
    if not MainJoyStick._nodeRun or not MainJoyStick._nodeWalk then
        return 0xff, 1
    end

    local runAngle  = MainJoyStick.GetGamePadAngle(MainJoyStick._nodeRun)
    local walkAngle = MainJoyStick.GetGamePadAngle(MainJoyStick._nodeWalk)
    local angle     = 0xff
    local step      = 1
    if runAngle ~= 0xff then
        angle = runAngle
        step  = (SL:GetValue("GAME_DATA","gameOption_WalkOnly") == 1) and 1 or 2

    elseif walkAngle ~= 0xff then
        angle = walkAngle
        step  = 1
    end

    local ret = 0xff
    if (angle > -22.5 and angle <= 22.5) then -- right
        ret = SLDefine.Direction.RIGHT
    
    elseif (angle > 22.5 and angle <= 67.5) then -- right up
        ret = SLDefine.Direction.RIGHT_UP
    
    elseif (angle > 67.5 and angle <= 112.5) then -- up
        ret = SLDefine.Direction.UP
    
    elseif (angle > 112.5 and angle <= 157.5) then -- left up
        ret = SLDefine.Direction.LEFT_UP
    
    elseif ((angle > 157.5 and angle <= 180) or (angle <= -157.5 and angle > -180)) then -- left
        ret = SLDefine.Direction.LEFT
    
    elseif (angle <= -112.5 and angle > -157.5) then -- left bottom
        ret = SLDefine.Direction.LEFT_BOTTOM
    
    elseif (angle <= -67.5 and angle > -112.5) then -- bottom
        ret = SLDefine.Direction.BOTTOM
    
    elseif (angle <= -22.5 and angle > -67.5) then --right bottom
        ret = SLDefine.Direction.RIGHT_BOTTOM
    end
    return ret, step
end

function MainJoyStick.OnJoystickUpdate(data)
    if not MainJoyStick._nodeRun or not MainJoyStick._nodeWalk then
        return nil
    end
    MainJoyStick.UpdateJoystickMode(MainJoyStick._nodeRun)
    MainJoyStick.UpdateJoystickMode(MainJoyStick._nodeWalk)
end

function MainJoyStick.OnOneDoubleJoystick(data)
    if not MainJoyStick._nodeRun or not MainJoyStick._nodeWalk then
        return nil
    end
    MainJoyStick.UpdateJoystickMode(MainJoyStick._nodeRun)
    MainJoyStick.UpdateJoystickMode(MainJoyStick._nodeWalk)
end

function MainJoyStick.OnJoystickShowDistanceChange(data)
    if not MainJoyStick._nodeRun or not MainJoyStick._nodeWalk then
        return nil
    end
    MainJoyStick.OnShowDistanceChange(MainJoyStick._nodeRun)
    MainJoyStick.OnShowDistanceChange(MainJoyStick._nodeWalk)
end
--------------------------- 注册事件 -----------------------------
function MainJoyStick.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_JOYSTICKUPDATE, "MainJoyStick", MainJoyStick.OnJoystickUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_ONE_DOUBLE_JOYSTICK, "MainJoyStick", MainJoyStick.OnOneDoubleJoystick)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_JOYSTICK_DISTANCE_CHANGE, "MainJoyStick", MainJoyStick.OnJoystickShowDistanceChange)
end

MainJoyStick.main()