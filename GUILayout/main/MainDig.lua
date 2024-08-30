MainDig = {}

MainDig._targets = {}

local squLen = function(x, y) return x * x + y * y end

function MainDig.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_dig")

    GUI:setPosition(parent, 290, 270)

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end

    MainDig.Button_dig = ui["Button_dig"]

    GUI:setVisible(MainDig.Button_dig, false)

    -- 挖
    GUI:addOnTouchEvent(MainDig.Button_dig, MainDig.OnDig)
end

-- 事件监听注册
function MainDig.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW, "MainDig", MainDig.OnActorInOfView)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainDig", MainDig.OnActorOutOfView)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE, "MainDig", MainDig.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, "MainDig", MainDig.OnActorMonsterDie)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "MainDig", MainDig.OnPlayerActorBegin)
end

function MainDig.OnDig(sender, eventType)
    local dig = function ()
        SL:ToDoDig(MainDig._targetID)
    end

    if eventType == 0 then
        GUI:stopAllActions(sender)
        SL:schedule(sender, dig, 0.5)
        dig()
    elseif eventType == 2 or eventType == 3 then
        GUI:stopAllActions(sender)
    end
end

-- 进视野
function MainDig.OnActorInOfView(data)
    MainDig:AddDigTarget(data.actorID)
end

-- 怪物死亡
function MainDig.OnActorMonsterDie(data)
    MainDig:AddDigTarget(data.actorID)
end

-- 出视野
function MainDig.OnActorOutOfView(data)
    MainDig:DelDigTarget(data.actorID)
end

-- 复活
function MainDig.OnActorRevive(data)
    MainDig:DelDigTarget(data.actorID)
end

function MainDig:AddDigTarget(actorID)
    if GUIFunction:CheckTargetDigAble(actorID) then
        MainDig._targets[actorID] = true
    end

    MainDig.CheckDigAble()
end

function MainDig:DelDigTarget(actorID)
    MainDig._targets[actorID] = nil

    MainDig.CheckDigAble()
end

function MainDig.CheckDigAble()
    -- 主玩家
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    local actorID = SL:GetValue("USER_ID")
    local pMapX   = SL:GetValue("X", actorID)
    local pMapY   = SL:GetValue("Y", actorID)
    local fMapX   = 0
    local fMapY   = 0
    local minLen  = 17
    local targetID = nil

    -- 找最近的
    for actorID, _ in pairs(MainDig._targets) do
        fMapX = SL:GetValue("ACTOR_MAP_X", actorID)
        fMapY = SL:GetValue("ACTOR_MAP_Y", actorID)
        local len = squLen(fMapX - pMapX, fMapY - pMapY)
        if len < minLen and GUIFunction:CheckTargetDigAble(actorID) then
            minLen = len
            targetID = actorID
        end
    end

    MainDig._targetID = targetID

    -- 显示隐藏
    local isVisible = targetID and true or false
    GUI:setVisible(MainDig.Button_dig, isVisible)
end

function MainDig.OnPlayerActorBegin(data)
    if SL:GetValue("ACTOR_IS_DIE", data.actorID) then
        return false
    end

    MainDig.CheckDigAble()
end