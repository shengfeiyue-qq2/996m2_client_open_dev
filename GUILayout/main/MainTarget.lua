MainTarget = {}

MainTarget.jobIconPath = {
    "res/private/main/Target/1900012533.png",
    "res/private/main/Target/1900012534.png",
    "res/private/main/Target/1900012535.png"
}
MainTarget.heroJobIconPath = {
    "res/private/main/Target/1900012537.png",
    "res/private/main/Target/1900012538.png",
    "res/private/main/Target/1900012539.png"
}

MainTarget._targetID = nil
MainTarget._targetOwnID = nil

MainTarget._isPC = SL:GetValue("IS_PC_OPER_MODE")

function MainTarget.main()
    local parent = GUI:Attach_Bottom()
    GUI:LoadExport(parent, "main/main_target")

    MainTarget._root = GUI:getChildByName(parent, "Main_Target")
    MainTarget._ui = GUI:ui_delegate(MainTarget._root)
    if not MainTarget._ui then
        return false
    end

    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local y = MainTarget._isPC and screenH - 190 or screenH - 225
    GUI:setPositionY(MainTarget._root, y)

    MainTarget._panel = MainTarget._ui["Panel_1"]
    GUI:setVisible(MainTarget._root, false)
    GUI:addOnClickEvent(MainTarget._panel, MainTarget.OnClickTargetPanel)

    GUI:Text_setString(MainTarget._ui["nameText"], "")
    local size = MainTarget._isPC and 12 or 16
    local scrollText = GUI:ScrollText_Create(MainTarget._ui["nameText"], "scrollText", 0, 0, 115, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    MainTarget._scrollNameText = scrollText


    -- 目标是否显示  PC不显示
    MainTarget._isShowTargetPanel = MainTarget._isPC == false

    if MainTarget._lockUIState == nil and MainTarget._ui.LockPanel then
        MainTarget._lockUIState = GUI:getVisible(MainTarget._ui.LockPanel)
    end

    -- 宠物锁定
    GUI:addOnClickEvent(MainTarget._ui["LockPanel"], MainTarget.OnClickLockPanel)
    -- 取消目标选择
    GUI:addOnClickEvent(MainTarget._ui["cleanBtn"], MainTarget.OnClickCleanBtn)
    
    -- 注册事件
    MainTarget.RegisterEvent()
end

function MainTarget.RegisterEvent()
    -- 选中目标改变
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CHANGE,          "MainTarget", MainTarget.OnTargetChange)
    -- 召唤物存活状态改变
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE,    "MainTarget", MainTarget.OnUpdateLockBtn)
    -- 归属改变
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE,     "MainTarget", MainTarget.OnActorOwnerChange)
    -- 目标血量变化
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH,       "MainTarget", MainTarget.OnRefreshActorHP)
end

-- 点击查看菜单
function MainTarget.OnClickTargetPanel()
    local targetID = MainTarget._targetID
    --是玩家才显示详细页面
    if SL:GetValue("ACTOR_IS_PLAYER", targetID) then
        UIOperator:OpenFuncDockTips({
            targetId   = targetID,
            targetName = SL:GetValue("ACTOR_NAME", targetID),
            isHero     = SL:GetValue("ACTOR_IS_HERO", targetID),
            pos        = {x = GUI:getTouchEndPosition(MainTarget._panel).x + 15, y = GUI:getTouchEndPosition(MainTarget._panel).y},
            type       = SL:GetValue("ACTOR_IS_HUMAN", targetID) and FuncDockData.FuncDockType.Func_Monster_Head or FuncDockData.FuncDockType.Func_Player_Head
        })
    end
end

function MainTarget.OnClickLockPanel()
    -- 未存活
    if not SL:GetValue("PET_ALIVE") then
        return false
    end

    -- F9隐藏
    if MainTarget._lockUIState == false then
        return
    end

    local lockID = SL:GetValue("PET_LOCK_ID")
    if lockID == MainTarget._targetID then --已锁定
        GUI:Button_setBright(MainTarget._ui["LockBtn"], false)
        SL:RequestUnLockPetID(MainTarget._targetID)
    else
        GUI:Button_setBright(MainTarget._ui["LockBtn"], true)
        SL:RequestLockPetID(MainTarget._targetID)
    end
    GUI:delayTouchEnabled(MainTarget._ui["LockPanel"])
end

function MainTarget.OnClickCleanBtn()
    -- 取消锁定
    if SL:GetValue("PET_ALIVE") and SL:GetValue("PET_LOCK_ID") == MainTarget._targetID then
        SL:RequestUnLockPetID(MainTarget._targetID)
        GUI:delayTouchEnabled(MainTarget._ui["cleanBtn"])
    end
    SL:SetValue("SELECT_TARGET_ID", nil)
end

function MainTarget.OnTargetChange(targetID)
    if not targetID then
        MainTarget.SelectTarget(nil)
    end

    if SL:GetValue("ACTOR_IS_PLAYER", targetID) or (SL:GetValue("ACTOR_IS_MONSTER", targetID) and not SL:GetValue("ACTOR_BIGICON_ID", targetID)) then
        MainTarget.SelectTarget(targetID)
    else
        MainTarget.SelectTarget(nil)
    end

    -- 目标归属
    UIOperator:OpenTargetBelongUI({parent = MainTarget._root, targetID = targetID, X = 0, Y = -50})
end

function MainTarget.SelectTarget(targetID)
    MainTarget._targetID = targetID
    if not MainTarget._targetID or not SL:GetValue("ACTOR_IS_VALID", MainTarget._targetID) then
        GUI:setVisible(MainTarget._root, false)
        return false
    end

    if not MainTarget._isShowTargetPanel then
        GUI:setVisible(MainTarget._root, false)
        return false
    end
    GUI:setVisible(MainTarget._root, true)
    -- icon
    if SL:GetValue("ACTOR_IS_PLAYER", targetID) then
        local job = SL:GetValue("ACTOR_JOB_ID", targetID)
        local jobPath = {}
        if SL:GetValue("ACTOR_IS_HERO", targetID) then
            jobPath = MainTarget.heroJobIconPath
        else
            jobPath = MainTarget.jobIconPath
        end
        if jobPath[job + 1] then
            GUI:Image_loadTexture(MainTarget._ui["icon"], jobPath[job + 1])
        end
    elseif SL:GetValue("ACTOR_IS_MONSTER", targetID) then
        GUI:Image_loadTexture(MainTarget._ui["icon"], "res/private/main/Target/1900012536.png")
    end

    MainTarget.UpdateTargetHP()
    MainTarget.UpdateTargetName()
    MainTarget.OnUpdateLockBtn()
end

function MainTarget.OnRefreshActorHP(data)
    local actorID = data.actorID

    if not actorID then
        return false
    end

    if MainTarget._targetID ~= actorID then
        return false
    end

    if not SL:GetValue("ACTOR_IS_VALID", MainTarget._targetID) then
        return false
    end

    MainTarget.UpdateTargetHP()

    if SL:GetValue("ACTOR_IS_MONSTER", actorID) and SL:GetValue("ACTOR_HP", actorID) < 1 then
        SL:SetValue("AFK_TARGET_DEATH", true)
    end
end

function MainTarget.UpdateTargetHP() 
    if not MainTarget._isShowTargetPanel then
        return false
    end

    -- 血量刷新
    local curHP = SL:GetValue("ACTOR_HP", MainTarget._targetID)
    local maxHP = SL:GetValue("ACTOR_MAXHP", MainTarget._targetID)
    local percent = math.ceil(curHP / maxHP * 100)
    GUI:LoadingBar_setPercent(MainTarget._ui["hpLoadingBar"], percent)
    GUI:Text_setString(MainTarget._ui["hpText"], percent .. "%")
end

function MainTarget.OnActorOwnerChange(data)
    local targetID = data and data.actorID
    if not targetID then
        return false
    end

    if MainTarget._targetID ~= targetID then
        return false
    end

    MainTarget.UpdateTargetName()
end

function MainTarget.UpdateTargetName()
    if not MainTarget._isShowTargetPanel then
        return false
    end
    if not SL:GetValue("ACTOR_IS_VALID", MainTarget._targetID) then
        return false
    end

    -- name
    local ownerName = SL:GetValue("ACTOR_OWNER_NAME", MainTarget._targetID) or ""
    local name      = SL:GetValue("ACTOR_NAME", MainTarget._targetID) .. (ownerName ~= "" and string.format("(%s)", ownerName) or "")

    if (tonumber(SL:GetValue("GAME_DATA", "Monsterlevel")) or 0) >= 1 and SL:GetValue("SETTING_ENABLED", 34) == 1 and not SL:GetValue("MAP_FORBID_LEVEL_AND_JOB") then
        name = name .. "/J" .. (SL:GetValue("ACTOR_LEVEL", MainTarget._targetID) or "")
    end
    GUI:ScrollText_setString(MainTarget._scrollNameText, name)
end

function MainTarget.OnUpdateLockBtn()
    if not MainTarget._isShowTargetPanel then
        return false
    end
    if not MainTarget._targetID or not SL:GetValue("ACTOR_IS_VALID", MainTarget._targetID) then
        return false 
    end

    if SL:GetValue("PET_ALIVE") then
        GUI:setVisible(MainTarget._ui["LockPanel"], true)
        GUI:setPositionX(MainTarget._ui["cleanBtn"], 235)
        local lockID = SL:GetValue("PET_LOCK_ID")
        GUI:Button_setBright(MainTarget._ui["LockBtn"], lockID == MainTarget._targetID)
    else
        GUI:setVisible(MainTarget._ui["LockPanel"], false)
        GUI:setPositionX(MainTarget._ui["cleanBtn"], 190)
    end
end

MainTarget.main()
