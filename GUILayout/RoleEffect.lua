RoleEffect = {}

RoleEffect._selectRingID = 4008  -- 选中目标特效ID

function RoleEffect.main()
    RoleEffect._selectRing = nil   -- 选中目标特效

    RoleEffect.RegisterEvent()
end

function RoleEffect.CreateSelectTargetEffect(actorID)
    if not RoleEffect._selectRing then
        RoleEffect._selectRing = GUI:Effect_Create(-1, "effect_selectRing", 0, 0, 0, RoleEffect._selectRingID)
        -- ! 同一特效才复用, 注意释放
        GUI:addRef(RoleEffect._selectRing)
    end

    GUI:removeFromParent(RoleEffect._selectRing)
    GUI:setVisible(RoleEffect._selectRing, true)
    GUI:Effect_play(RoleEffect._selectRing, 0, 0, true)

    return RoleEffect._selectRing
end

function RoleEffect.OnClearSelect()
    if RoleEffect._selectRing and GUI:getParent(RoleEffect._selectRing) then
        GUI:removeFromParent(RoleEffect._selectRing)
        GUI:setVisible(RoleEffect._selectRing, true)
        GUI:Effect_stop(RoleEffect._selectRing)
    end
end

function RoleEffect.OnUpdateSelectTarget(targetID)
    if targetID then
        -- 官方内部获取创建的特效[ RoleEffect.CreateSelectTargetEffect ]处理
    else
        RoleEffect.OnClearSelect()
    end
end

function RoleEffect.OnReleaseMemory()
    if RoleEffect._selectRing then
        GUI:removeFromParent(RoleEffect._selectRing)
        GUI:autoDecRef(RoleEffect._selectRing)
        RoleEffect._selectRing = nil
    end
end

function RoleEffect.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CHANGE, "RoleEffect", RoleEffect.OnUpdateSelectTarget)
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_OWNER_CHANGE, "RoleEffect", RoleEffect.OnUpdateSelectTarget)
    SL:RegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "RoleEffect", RoleEffect.OnReleaseMemory)
end

RoleEffect.main()