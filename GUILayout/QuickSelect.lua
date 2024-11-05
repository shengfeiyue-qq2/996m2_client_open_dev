QuickSelect = {}

QuickSelect._path = "res/private/quick_select/"

QuickSelect._imgList = {
    [1]     = QuickSelect._path .. "player.png",
    [2]     = QuickSelect._path .. "monster.png",
}

QuickSelect._selectImgTag = 1111

local mMin = math.min
local mMax = math.max
local mAbs = math.abs

local function squLen(x, y)
    return x * x + y * y
end

local function sortPlayer(e1, e2)
    if e1.selectCount == e2.selectCount then
        return e1.len < e2.len
    end

    return e1.selectCount < e2.selectCount
end

local function sortMonster(e1, e2)
    if e1.selectCount == e2.selectCount then
        return e1.len < e2.len
    end

    return e1.selectCount < e2.selectCount
end

function QuickSelect.main()

    QuickSelect._selectPlayer   = {}
    QuickSelect._selectMonster  = {}
    QuickSelect._selectHero     = {}

    QuickSelect.InitEvent()
end

function QuickSelect.InitEvent()
    SL:RegisterLUAEvent(LUA_EVENT_QUICK_SELECT_TARGET, "QuickSelect", QuickSelect.OnSelectTarget)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "QuickSelect", QuickSelect.OnActorOutOfView)
end

function QuickSelect.OnSelectTarget(data)

    local targetType = data.type
    local imgNotice  = data.imgNotice
    local systemTips = data.systemTips

    if GUIDefine.ActorType.PLAYER == targetType then
        QuickSelect.SelectPlayer(imgNotice, systemTips)
        
    elseif GUIDefine.ActorType.MONSTER == targetType then
        QuickSelect.SelectMonster(imgNotice, systemTips)

    elseif GUIDefine.ActorType.HERO == targetType then
        QuickSelect.SelectHero(imgNotice, systemTips)
    end
end

function QuickSelect.SelectPlayer(imgNotice, systemTips)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return nil
    end


    local playerVec, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    local enemyVec   = {}
    local enemyCount = 0
    local pMapX      = SL:GetValue("X")
    local pMapY      = SL:GetValue("Y")
    local fMapX      = 0
    local fMapY      = 0

    for i = 1, nPlayer do
        local playerID = playerVec[i]
        if SL:GetValue("ACTOR_IS_VALID", playerID) and not SL:GetValue("ACTOR_IS_HERO", playerID) and not SL:GetValue("ACTOR_IS_HUMAN", playerID) 
            and not SL:GetValue("ACTOR_HUD_SNEAK_SHOW", playerID) and GUIFunction.CheckAutoTargetEnableByID(playerID)  then
            fMapX               = SL:GetValue("ACTOR_MAP_X", playerID)
            fMapY               = SL:GetValue("ACTOR_MAP_Y", playerID)
            local selectCount   = QuickSelect._selectPlayer[playerID]
            local enemy         = {}
            enemy.actorID       = playerID
            enemy.len           = squLen(fMapX - pMapX, fMapY - pMapY) 
            enemy.selectCount   = selectCount or 0

            enemyCount = enemyCount + 1
            enemyVec[enemyCount] = enemy
        end
    end

    if enemyCount > 0 then
        table.sort(enemyVec, sortPlayer)
        
        local enemy    = enemyVec[1] 
        local targetID = enemy.actorID
        QuickSelect._selectPlayer[targetID] = enemy.selectCount + 1
    
        SL:SetValue("SELECT_TARGET_ID", targetID)
    else
        if systemTips then
            SL:ShowSystemTips("范围内没有可攻击的玩家")
        end

        if imgNotice then
            QuickSelect.CreateCircle(1)
        end
    end
end

function QuickSelect.SelectMonster(imgNotice, systemTips)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return nil
    end

    
    local monsterVec, nMonster = SL:GetMetaValue("FIND_IN_VIEW_MONSTER_LIST")
    local num        = nMonster
    local enemyVec   = {}
    local enemyCount = 0
    local pMapX      = SL:GetValue("X")
    local pMapY      = SL:GetValue("Y")
    local fMapX      = 0
    local fMapY      = 0
    
    -- 人形怪
    local playerVec, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, nPlayer do
        local playerID = playerVec[i]
        if SL:GetValue("ACTOR_IS_VALID", playerID) and SL:GetValue("ACTOR_IS_HUMAN", playerID) then
            num = num + 1
            monsterVec[num] = playerID
        end
    end

    local selectCount   = 0
    for _, value in pairs(QuickSelect._selectMonster) do
        selectCount     = mMin(selectCount, value)
    end

    for i = 1, num do
        local monsterID = monsterVec[i]
        if SL:GetValue("ACTOR_IS_VALID", monsterID) then
            fMapX = SL:GetValue("ACTOR_MAP_X", monsterID)
            fMapY = SL:GetValue("ACTOR_MAP_Y", monsterID)
            if mMax(mAbs(fMapX - pMapX), mAbs(fMapY - pMapY)) <= 8 and GUIFunction.CheckAutoTargetEnableByID(monsterID) then
                local enemy         = {}
                enemy.actorID       = monsterID
                enemy.len           = squLen( fMapX - pMapX, fMapY - pMapY )
                enemy.selectCount   = selectCount == 0 and (QuickSelect._selectMonster[monsterID] or 0) or 1
                
                enemyCount          = enemyCount + 1
                enemyVec[enemyCount] = enemy
            end
        end
    end

    if enemyCount > 0 then
        table.sort(enemyVec, sortMonster)
        
        local enemy     = enemyVec[1]
        local targetID  = enemy.actorID
        if SL:GetValue("SELECT_TARGET_ID") ~= targetID then
            local targetID  = target:GetID()
            QuickSelect._selectMonster[targetID] = enemy.selectCount + 1
            SL:SetValue("SELECT_TARGET_ID", targetID)
        end
    else
        if systemTips then
            SL:ShowSystemTips("范围内没有可攻击的怪物")
        end

        if imgNotice then
            QuickSelect.CreateCircle(2)
        end
    end
end

function QuickSelect.SelectHero(imgNotice, systemTips)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return nil
    end

    local playerVec, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    local enemyVec   = {}
    local enemyCount = 0
    local pMapX      = SL:GetValue("X")
    local pMapY      = SL:GetValue("Y")
    local fMapX      = 0
    local fMapY      = 0

    for i = 1, nPlayer do
        local playerID = playerVec[i]
        if SL:GetValue("ACTOR_IS_VALID", playerID) and SL:GetValue("ACTOR_IS_HERO", playerID) and GUIFunction.CheckAutoTargetEnableByID(playerID) then
            fMapX               = SL:GetValue("ACTOR_MAP_X", playerID)
            fMapY               = SL:GetValue("ACTOR_MAP_Y", playerID)
            local selectCount   = QuickSelect._selectHero[playerID]
            local enemy         = {}
            enemy.actorID       = playerID
            enemy.len           = squLen(fMapX - pMapX, fMapY - pMapY) 
            enemy.selectCount   = selectCount or 0

            enemyCount = enemyCount + 1
            enemyVec[enemyCount] = enemy
        end
    end

    if enemyCount > 0 then
        table.sort(enemyVec, sortPlayer)
        
        local enemy    = enemyVec[1] 
        local targetID = enemy.actorID
        QuickSelect._selectHero[targetID] = enemy.selectCount + 1
    
        SL:SetValue("SELECT_TARGET_ID", targetID)
    else
        if systemTips then
            SL:ShowSystemTips("范围内没有可攻击的元神")
        end

        if imgNotice then
            QuickSelect.CreateCircle(1)
        end
    end

end

function QuickSelect.CreateCircle(type)
    local mainPlayerID = SL:GetValue("USER_ID")
    local actorMountNode = SL:GetValue("ACTOR_MOUNT_NODE", mainPlayerID)
    local lastImg = actorMountNode and GUI:getChildByTag(actorMountNode,  QuickSelect._selectImgTag)
    if not lastImg and actorMountNode then
        local img = GUI:Image_Create(actorMountNode, "select_circle_img", 24, -16, QuickSelect._imgList[type])
        GUI:setAnchorPoint(img, 0.5, 0.5)
        GUI:setScale(img, 1.8)
        GUI:setTag(img, QuickSelect._selectImgTag)
        GUI:setLocalZOrder(img, -1)
        GUI:runAction(img, GUI:ActionSequence(
            GUI:ActionRepeat(GUI:ActionSequence(GUI:ActionFadeTo(0.4, 70), GUI:ActionFadeTo(0.4, 255)), 1),
            GUI:ActionFadeTo(0.4, 0),
            GUI:ActionRemoveSelf()
        ))
    end
end

function QuickSelect.OnActorOutOfView(data)
    local actorID = data and data.actorID
    if not actorID then
        return
    end

    QuickSelect._selectPlayer[actorID]  = nil
    QuickSelect._selectMonster[actorID] = nil
    QuickSelect._selectHero[actorID]    = nil
end

QuickSelect.main()