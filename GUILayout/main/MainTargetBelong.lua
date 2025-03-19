MainTargetBelong = {}

MainTargetBelong._targetID = nil

MainTargetBelong._targetOwnID = nil

local GetBelongID = function(actorID)
    if not actorID or not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return nil 
    end

    local actorID = SL:GetValue("ACTOR_OWNER_ID", actorID)
    if not actorID or actorID == "" or actorID == -1 or actorID == "0" then
        return nil
    end

    return actorID
end

function MainTargetBelong.main()
    local params   = GUI:GetLayerOpenParam()
    local parent   = params.parent
    local targetID = params.targetID

    local root = GUI:getChildByName(parent, "Main_Target_Belong")
    if not targetID then
        if root then
            GUI:removeFromParent(root)
            MainTargetBelong.UnRegisterEvent()
        end
        return false
    end

    if not root then
        GUI:LoadExport(parent, "main/main_target_belong")
        root = GUI:getChildByName(parent, "Main_Target_Belong")
    end
    MainTargetBelong._root = root

    MainTargetBelong._ui = GUI:ui_delegate(root)
    if not MainTargetBelong._ui then
        return false
    end

    GUI:setPosition(root, params.X or 0, params.Y or 0)

    GUI:addOnClickEvent(MainTargetBelong._ui["Panel_click"], MainTargetBelong.OnClickTargetBelong)

    -- 归属文本
    MainTargetBelong._scrollNameText = MainTargetBelong.CreateScrollText()

    MainTargetBelong._targetID = targetID
    MainTargetBelong._targetOwnID = nil

    MainTargetBelong.ShowUI()
    
    -- 注册事件
    MainTargetBelong.RegisterEvent()
end

function MainTargetBelong.CreateScrollText()
    local Text_name = MainTargetBelong._ui["Text_name"]
    GUI:Text_setString(Text_name, "")
    local scrollText = GUI:getChildByName(Text_name, "scrollText")
    if scrollText then
        return scrollText
    end

    local scrollText = GUI:ScrollText_Create(Text_name, "scrollText", 0, 0, 55, 13, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    return scrollText
end

function MainTargetBelong.RegisterEvent()
    -- 归属改变
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE,      "MainTargetBelong", MainTargetBelong.OnActorOwnerChange)
    -- 目标血量变化
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH,        "MainTargetBelong", MainTargetBelong.OnRefreshActorHP)
    -- 快捷归属选中
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_BELONG_SELECT,    "MainTargetBelong", MainTargetBelong.OnBelongSelect)

    SL:RegisterLUAEvent(LUA_EVENT_USER_INPUT_MOVE,         "MainTargetBelong", MainTargetBelong.OnUserInputMove)

    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE,           "MainTargetBelong", MainTargetBelong.OnPKModeChange)

    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_ACTION_ENDED,"MainTargetBelong", MainTargetBelong.OnMainPlayerActionEnd)
end

function MainTargetBelong.UnRegisterEvent()
    -- 归属改变
    SL:UnRegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE,      "MainTargetBelong")
    -- 目标血量变化
    SL:UnRegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH,        "MainTargetBelong")
    -- 快捷归属选中
    SL:UnRegisterLUAEvent(LUA_EVENT_TARGET_BELONG_SELECT,    "MainTargetBelong")

    SL:UnRegisterLUAEvent(LUA_EVENT_USER_INPUT_MOVE,         "MainTargetBelong")

    SL:UnRegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE,           "MainTargetBelong")

    SL:UnRegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_ACTION_ENDED,"MainTargetBelong")
end

function MainTargetBelong.OnRefreshActorHP(data)
    local actorID = data.actorID
    if not actorID then
        return false
    end

    MainTargetBelong.UpdateBelongHp(actorID)
end

function MainTargetBelong.OnActorOwnerChange(data)
    local targetID = data and data.actorID
    if not targetID or MainTargetBelong._targetID ~= targetID then
        return false
    end
    MainTargetBelong.UpdateBelongUI()
    MainTargetBelong.UpdateBelongHp()
end

-- 更新UI显示
function MainTargetBelong.GetRootVisible()
    -- 和平模式也不显示
    if GetBelongID(MainTargetBelong._targetID) and SL:GetValue("PKMODE") ~= GUIDefine.PKModeType.HAM_PEACE then
        return true
    else
        return false 
    end
end

function MainTargetBelong.OnClickTargetBelong()
    if not MainTargetBelong._targetID then
        return false
    end
    
    if not SL:GetValue("ACTOR_IS_VALID", MainTargetBelong._targetID) then
        return false 
    end

    local ownerID = GetBelongID(MainTargetBelong._targetID)

    if not SL:GetValue("TARGET_ATTACK_ENABLE", ownerID) then
        return false
    end

    SL:SetValue("TARGET_OWNER_ID", ownerID)
    SL:SetValue("AUTO_TRACE_TARGET_OWNER", true)
end

-- 血量刷新
function MainTargetBelong.UpdateBelongHp(ownerID)
    local ownerID = ownerID or MainTargetBelong._targetOwnID
    if not ownerID or not SL:GetValue("ACTOR_IS_VALID", ownerID) then
        return false 
    end

    -- 归属不是玩家
    if not SL:GetValue("ACTOR_IS_PLAYER", ownerID) then
        return false
    end

    local curHP = SL:GetValue("ACTOR_HP", ownerID)
    local maxHP = SL:GetValue("ACTOR_MAXHP", ownerID)

    if curHP < 1 then
        MainTargetBelong.HideUI()
    else
        GUI:LoadingBar_setPercent(MainTargetBelong._ui["LoadingBar_hp"], math.ceil(curHP / maxHP * 100))
    end
end

-- 选中归属特效
function MainTargetBelong.OnBelongSelect()
    GUI:removeAllChildren(MainTargetBelong._ui["Node_tx"])

    if not SL:GetValue("TARGET_OWNER_ID") then
        return false
    end

    if not SL:GetValue("AUTO_TRACE_TARGET_OWNER") then
        return false
    end

    GUI:Effect_Create(MainTargetBelong._ui["Node_tx"], "sfx", 0, 0, 0, 7300)
end

function MainTargetBelong.OnUserInputMove(data)
    -- 摇杆移动取消自动跟踪
    if data and data.type == GUIDefine.InputMoveType.JOYSTICK then
        MainTargetBelong.UpdateMoveCancelTracking()
        MainTargetBelong.UpdateBelongUI()
    end
end

function MainTargetBelong.OnPKModeChange()
    GUI:setVisible(MainTargetBelong._root, MainTargetBelong.GetRootVisible())
end

function MainTargetBelong.OnMainPlayerActionEnd()
    if not SL:GetValue("AUTO_TRACE_TARGET_OWNER") then
        return false
    end

    local ownerID = SL:GetValue("TARGET_OWNER_ID")
    if not ownerID then
        return false
    end

    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    if not SL:GetValue("ACTOR_IS_PLAYER", ownerID) then
        return false
    end

    local playerPos = {
        x = SL:GetValue("X"), y = SL:GetValue("Y")
    }

    local actorPos = {
        x = SL:GetValue("ACTOR_MAP_X", ownerID), y = SL:GetValue("ACTOR_MAP_X", ownerID)
    }

    if SL:GetPointDistance(actorPos, playerPos) > 8 then
        MainTargetBelong.UpdateMoveCancelTracking()
        MainTargetBelong.UpdateBelongUI()
    end
end

function MainTargetBelong.UpdateMoveCancelTracking()
    SL:GetValue("AUTO_TRACE_TARGET_OWNER", false)

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    SL:onLUAEvent(LUA_EVENT_TARGET_CHANGE, targetID)

    local isShow = SL:GetValue("HP", targetID) > 0
    if isShow then
        MainTargetBelong.ShowUI()
    else
        MainTargetBelong.HideUI()
    end
end

function MainTargetBelong.ShowUI()
    GUI:setVisible(MainTargetBelong._root, true)

    -- 更新归属
    MainTargetBelong.UpdateBelongUI()

    -- 更新血量
    MainTargetBelong.UpdateBelongHp()

    -- 更新归属选中特效
    MainTargetBelong.OnBelongSelect()
end

function MainTargetBelong.HideUI()
    SL:SetValue("TARGET_OWNER_ID", nil)
    SL:SetValue("AUTO_TRACE_TARGET_OWNER", false)
    GUI:setVisible(MainTargetBelong._root, false)
end

--  刷新UI数据
function MainTargetBelong.UpdateBelongUI()
    GUI:setVisible(MainTargetBelong._root, MainTargetBelong.GetRootVisible())

    local ownerID = GetBelongID(MainTargetBelong._targetID)

    -- 归属不是玩家
    if not SL:GetValue("ACTOR_IS_PLAYER", ownerID) then
        return nil
    end

    -- 更换了归属
    if ownerID ~= MainTargetBelong._targetOwnID then
        SL:SetValue("TARGET_OWNER_ID", nil)
        SL:SetValue("AUTO_TRACE_TARGET_OWNER", false)
    end

    MainTargetBelong._targetOwnID = ownerID

    local sex = SL:GetValue("SEX", ownerID)
    local job = SL:GetValue("JOB", ownerID)
    local iconPath = string.format("res/private/monster_belong_netplayer/job_%s_%s.png", sex, job)
    GUI:Image_loadTexture(MainTargetBelong._ui["Image_icon"], iconPath)

    local name = SL:GetValue("ACTOR_NAME", ownerID)

    GUI:ScrollText_setString(MainTargetBelong._scrollNameText, name or "")
end

MainTargetBelong.main()
