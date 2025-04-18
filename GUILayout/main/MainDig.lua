MainDig = {}

MainDig._targets = {}

local calcMapDis = function(sX, sY, dX, dY)
    return math.max(math.abs(sX - dX), math.abs(sY - dY))
end

function MainDig.main()
    local parent = GUI:Attach_Center()
    GUI:LoadExport(parent, "main/main_dig")

    MainDig._root = GUI:getChildByName(parent, "Main_Dig")
    GUI:setPositionX(MainDig._root, SL:GetValue("SCREEN_WIDTH") / 2)

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end

    MainDig._digBtn = ui["Button_dig"]

    GUI:setVisible(MainDig._digBtn, false)

    -- 挖
    GUI:addOnTouchEvent(MainDig._digBtn, MainDig.OnDig)

    MainDig.RegisterEvent()
end

-- 事件监听注册
function MainDig.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW, "MainDig", MainDig.OnActorInOfView)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainDig", MainDig.OnActorOutOfView)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE, "MainDig", MainDig.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, "MainDig", MainDig.OnActorMonsterDie)
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE, "MainDig", MainDig.OnActorPlayerDie)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "MainDig", MainDig.OnPlayerActorBegin)
end

function MainDig.OnDig(sender, eventType)
    local dig = function()
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
    MainDig.AddDigTarget(data.actorID)
end

-- 怪物死亡
function MainDig.OnActorMonsterDie(data)
    MainDig.AddDigTarget(data.actorID)
end

-- 人物死亡
function  MainDig.OnActorPlayerDie(data)
    if data.actorID and SL:GetValue("ACTOR_IS_HUMAN", data.actorID) then -- 人形怪
        MainDig.OnActorMonsterDie(data)
    end
end

-- 出视野
function MainDig.OnActorOutOfView(data)
    MainDig.DelDigTarget(data.actorID)
end

-- 复活
function MainDig.OnActorRevive(data)
    MainDig.DelDigTarget(data.actorID)
end

function MainDig.AddDigTarget(actorID)
    if GUIFunction:CheckTargetDigAble(actorID) then
        MainDig._targets[actorID] = true
    end

    MainDig.CheckDigAble()
end

function MainDig.DelDigTarget(actorID)
    MainDig._targets[actorID] = nil

    MainDig.CheckDigAble()
end

function MainDig.CheckDigAble()
    -- 主玩家
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    local pMapX   = SL:GetValue("X")
    local pMapY   = SL:GetValue("Y")
    local tMapX   = 0
    local tMapY   = 0
    local minLen  = 3
    local targetID = nil

    -- 找最近的
    for actorID, _ in pairs(MainDig._targets) do
        tMapX = SL:GetValue("ACTOR_MAP_X", actorID)
        tMapY = SL:GetValue("ACTOR_MAP_Y", actorID)
        local len = calcMapDis(pMapX, pMapY, tMapX, tMapY)
        if len <= minLen and GUIFunction:CheckTargetDigAble(actorID) then
            minLen = len
            targetID = actorID
        end
    end

    MainDig._targetID = targetID

    -- 显示隐藏
    local isVisible = targetID and true or false
    GUI:setVisible(MainDig._digBtn, isVisible)
end

function MainDig.OnPlayerActorBegin(data)
    if GUIDefine.Action.IDLE == data.act then
        return
    end

    MainDig.CheckDigAble()
end

MainDig.main()