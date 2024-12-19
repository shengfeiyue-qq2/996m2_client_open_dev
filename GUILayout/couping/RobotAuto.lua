RobotAuto = {}

local mAbs = math.abs
local SharedInputLaunchData = {}
function RobotAuto.main()
    RobotAuto._items                 = {}
    RobotAuto._cdingTime             = {}

    RobotAuto._cdingTime[51]         = 0

    RobotAuto._launchTime            = 0
    RobotAuto._trainingTime          = 0

    RobotAuto._spellScopeShowHide    = 0

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4] = 0

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4] = 0

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE] = 0
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK] = 0

    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_INITED, "RobotAuto", RobotAuto.Init)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE,      "RobotAuto", RobotAuto.OnBagOperData)
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER,   "RobotAuto", RobotAuto.OnQuickUseItemRmv)
    SL:RegisterLUAEvent(LUA_EVENT_PC_SPELL_SCOPE_SHOW_HIDE,   "RobotAuto", RobotAuto.OnSpellScopeShowHide)
end

function RobotAuto.OnBagOperData(data)
    if data.opera == GUIDefine.OprateType.DEL and data.operID and data.operID[1].item then
        SL:UnpackDrugByIndex(data.operID[1].item.Index)
    end
end

function RobotAuto.FindBagCountByIndex(index)
    local count = 0
    local items = BagData.GetItemDataByItemIndex(index)
    if items and next(items) then
        count = count + #items
    end
    return count
end

function RobotAuto.OnQuickUseItemRmv(data)
    if data.opra ~= GUIDefine.OprateType.DEL then
        return false
    end

    if data.itemData and RobotAuto.FindBagCountByIndex(data.itemData.Index) <= 0 then
        SL:UnpackDrugByIndex(data.itemData.Index, true)
    end
end

function RobotAuto.Init()
    RobotAuto.TimerBegan()
    -- 药品
    RobotAuto._items[51] = SL:GetValue("GAME_DATA", "fixItemDrug")
end

function RobotAuto.OnSpellScopeShowHide(type)
    if type ~= 1 then
        RobotAuto._spellScopeShowHide = 0
    else
        RobotAuto._spellScopeShowHide = 1
    end
end

function RobotAuto.TimerBegan()
    if not RobotAuto._timerID then
        local function callback(delta)
            RobotAuto.Tick(delta)
        end
        RobotAuto._timerID = SL:Schedule(callback, 0.1)
    end

    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SPELL_HELP) == 1 then
        RobotAuto._spellScopeShowHide = 1
    end
    if SL:GetValue("IS_PC_OPER_MODE") then
        if not RobotAuto._timerSpellScopeID then
            local function call(delta)
                if RobotAuto._spellScopeShowHide == 1 then
                    SL:onLUAEvent(LUA_EVENT_PC_SPELL_SCOPE_POS)
                end
            end
            RobotAuto._timerSpellScopeID = SL:Schedule(call, 1/60)
        end
    end
end

function RobotAuto.TimerEnded()
    if RobotAuto._timerID then
        SL:UnSchedule(RobotAuto._timerID)
        RobotAuto._timerID = nil
    end

    if RobotAuto._timerSpellScopeID then
        SL:UnSchedule(RobotAuto._timerSpellScopeID)
        RobotAuto._timerSpellScopeID = nil
    end
end

function RobotAuto.Tick(delta)
    -- 摆摊
    if  SL:GetValue("STALL_MY_TRADING_STATUS") then
        return nil
    end
    -- check role
    local role = SL:GetValue("MAIN_PLAYER_IS_VALID")
    if role then
        -- 自动释放相关
        RobotAuto.AutoLaunch(delta)
        -- 自动练功
        RobotAuto.AutoTraining(delta)
        -- 自动使用修复神水
        RobotAuto.AutoUseFIXItem(delta)
        --hp保护
        RobotAuto.AutoHpProtect(delta)
        --mp保护
        RobotAuto.AutoMpProtect(delta)
        --红名保护 
        RobotAuto.AutoPkProtect(delta)
        -- 逃脱保护   
        RobotAuto.AutoBesiegeprotect(delta)
        --主动攻击敌人
        RobotAuto.SelectEnemy(delta)
    end
end

-- 四周是否有足够的敌人（人物）
function RobotAuto.CheckIsEnoughEnemyPlayer(targetID, count, distance)
    if SL:GetValue("ACTOR_IS_VALID", targetID) then
        return false
    end
    
    local enoughCount = tonumber(count) or 3
    local count = 0
    local actors, actorNums = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    local pMapX = SL:GetValue("ACTOR_MAP_X", targetID)
    local pMapY = SL:GetValue("ACTOR_MAP_Y", targetID)
    distance    = distance or 2 -- 多少格之内

    for i = 1, actorNums do
        local actorID = actors[i]
        if actorID and not SL:GetValue("ACTOR_IS_HUMAN", actorID) then
            local actorMapX = SL:GetValue("ACTOR_MAP_X", actorID)
            local actorMapY = SL:GetValue("ACTOR_MAP_Y", actorID)
            
            if mAbs(actorMapX - pMapX) <= distance and mAbs(actorMapY - pMapY) <= distance and SL:GetValue("TARGET_ATTACK_ENABLE", actorID) then
                count = count + 1
            end
            if count >= enoughCount then
                return true
            end
        end
    end
    
    return false
end

-- 四周是否有足够的红名敌人（人物）
function RobotAuto.CheckIsEnoughRedNameEnemy(targetID, count, distance)
    if SL:GetValue("ACTOR_IS_VALID", targetID) then
        return false
    end
    
    local enoughCount = tonumber(count) or 3
    local count = 0
    local actors, actorNums = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    local pMapX = SL:GetValue("ACTOR_MAP_X", targetID)
    local pMapY = SL:GetValue("ACTOR_MAP_Y", targetID)
    distance    = distance or 2 -- 多少格之内

    for i = 1, actorNums do
        local actorID = actors[i]
        if actorID then
            local actorMapX = SL:GetValue("ACTOR_MAP_X", actorID)
            local actorMapY = SL:GetValue("ACTOR_MAP_Y", actorID)
            
            if mAbs(actorMapX - pMapX) <= distance and mAbs(actorMapY - pMapY) <= distance and SL:GetValue("TARGET_ATTACK_ENABLE", actorID) 
                and SL:GetValue("ACTOR_PKLV", actorID) == 2 then
                count = count + 1
            end
            if count >= enoughCount then
                return true
            end
        end
    end
    
    return false
end

function RobotAuto.SelectEnemy(delta)
    if SL:GetValue("MAP_IS_IN_SAFE_AREA") then
        return nil
    end
    -- dead
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end
    if not SL:GetValue("BATTLE_IS_AFK") and not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return false
    end

    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return
    end

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK] - delta
    
    local values = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK) -- 周围有敌人时主动攻击
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK] <= 0 and values[1] == 1 then
        local distance = tonumber(values[2]) or 8

        local targetID = SL:GetValue("SELECT_TARGET_ID")
        if SL:GetValue("ACTOR_IS_PLAYER", targetID) then
            return false
        end

        -- 找距离内可以攻击的人形怪
        local pMapX      = SL:GetValue("X")
        local pMapY      = SL:GetValue("Y")
        local aX         = 0
        local aY         = 0

        local playerVec, playerVecNum = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
        for i = 1, playerVecNum do
            local playerID = playerVec[i]
            if SL:GetValue("ACTOR_IS_VALID", playerID) and SL:GetValue("ACTOR_IS_HUMAN", playerID) then
                aX = SL:GetValue("ACTOR_MAP_X", playerID)
                aY = SL:GetValue("ACTOR_MAP_Y", playerID)
                if GUIFunction:CheckLaunchEnableByID(playerID) and math.abs(aX - pMapX) <= distance and math.abs(aY - pMapY) <= distance then
                    SL:SetValue("SELECT_TARGET_ID", playerID)
                    break
                end
            end
        end        

        RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK] = 1
    end
end

function RobotAuto.AutoBesiegeprotect(delta)
    if SL:GetValue("MAP_IS_IN_SAFE_AREA") then
        return nil
    end
    -- dead
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end

    local mainPlayerID = SL:GetValue("USER_ID")
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") or not mainPlayerID then
        return
    end
    local isAFKState = SL:GetValue("BATTLE_IS_AFK")
    if not isAFKState then
        return
    end
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE] - delta
    -- 逃脱保护
    local values = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE)--周围有多少敌人时使用
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE] <= 0 and values[1] == 1 then
        local distance = values[2] or 0
        local count = values[3] or 99
        local index = tonumber(values[4])
        if RobotAuto.CheckIsEnoughEnemyPlayer(mainPlayerID, count, distance) and index then
            local used = RobotAuto.AutoUseItem({ index })
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE] = 5
            end
        end
    end


    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE] - delta
    local values = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE)--周围有红名时使用
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE] <= 0 and values[1] == 1 then
        local distance = values[2] or 0
        local count = values[3] or 99
        local index = tonumber(values[4])
        if RobotAuto.CheckIsEnoughRedNameEnemy(mainPlayerID, count, distance) and index then
            local used = RobotAuto.AutoUseItem({ index })
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE] = 5
            end
        end
    end
end

function RobotAuto.AutoPkProtect(delta)
    -- dead
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end

    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return
    end
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT] - delta

    local PKLv = SL:GetValue("PK_LV") or 0

    -- pk保护
    local values = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT)--红名时使用
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT] <= 0 and values[1] == 1 then
        if PKLv == 2 then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT)
            local used        = RobotAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT] = (protectData.time or 1000) / 1000
            end
        end
    end
end

function RobotAuto.AutoMpProtect(delta)
    -- dead
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4] - delta

    -- 自动吃药相关
    local mppercent     = SL:GetValue("ROLE_MP_PERCENT")
    local maxMP         = SL:GetValue("MAXMP")

    -- mp保护1
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1)
            local used        = RobotAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1] = (protectData.time or 1000) / 1000
            end
        end
    end

    -- mp保护2
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2)
            local used        = RobotAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2] = (protectData.time or 1000) / 1000
            end
        end
    end

    --mp保护3
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3)
            local used        = RobotAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3] = (protectData.time or 1000) / 1000
            end
        end
    end

    --mp保护4
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4)
            local used        = RobotAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4] = (protectData.time or 1000) / 1000
            end
        end
    end
end

function RobotAuto.AutoHpProtect(delta)
    -- dead
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end

    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3] - delta
    RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4] = RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4] - delta

    -- 自动吃药相关
    local hppercent     = SL:GetValue("ROLE_MP_PERCENT")
    local maxHP         = SL:GetValue("MAXHP")

    -- hp保护1
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1)
            local used        = RobotAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1] = (protectData.time or 1000) / 1000
            end
        end
    end

    -- hp保护2
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2)
            local used        = RobotAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2] = (protectData.time or 1000) / 1000
            end
        end
    end

    -- hp保护3
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3)
            local used        = RobotAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3] = (protectData.time or 1000) / 1000
            end
        end
    end

    -- hp保护4
    if RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4] <= 0 then
        local value         = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4)
        local enable        = value[1] == 1
        local percent       = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4)
            local used        = RobotAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4] = (protectData.time or 1000) / 1000
            end
        end
    end
end

function RobotAuto.FindItemByIndex(index)
    local itemData = QuickUseData.GetQuickUseDataByIndex(index)
    if itemData and itemData[1] then
        return itemData[1]
    end

    local itemData = BagData.GetItemDataByItemIndex(index)
    if itemData and itemData[1] then
        return itemData[1]
    end

    return nil
end

function RobotAuto.AutoUseItem(items, isHpProtect)
    for _, itemIndex in ipairs(items) do
        repeat
            local unpack = SL:UnpackDrugByIndex(itemIndex)
            if unpack then
                return true
            end
            local item = RobotAuto.FindItemByIndex(itemIndex)
            if item then
                --回城石和随机石
                if SL:GetValue("ITEM_IS_CITY_STONE", itemIndex) or SL:GetValue("ITEM_IS_RAND_STONE", itemIndex) then
                    if SL:GetValue("MAP_IS_IN_SAFE_AREA") then -- 安全区不使用
                        break
                    end
                    if isHpProtect then --  hp保护检查 复活
                        -- 复活戒指准备就绪，回城/随机保护不生效
                        if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT) == 1 and SL:GetValue("USER_IS_CANREVIVE") then
                            break
                        end
                    end
                end
                SL:RequestUseItem(item)
                return true
            end
        until true
    end
    return false
end

-------------------------------------------------------
-- 修复神水
function RobotAuto.AutoUseFIXItem(delta)
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end

    local function isInvalidEquip(item)
        -- 祝福罐
        if item.StdMode == 96 then
            return true
        end
        -- 护身符
        if item.StdMode == 25 then
            return true
        end

        -- 气血石
        if item.StdMode == 7 and item.Shape == 1 then
            return true
        end
        -- 幻魔石
        if item.StdMode == 7 and item.Shape == 2 then
            return true
        end
        -- 魔血石
        if item.StdMode == 7 and item.Shape == 3 then
            return true
        end
    end

    -- cding
    RobotAuto._cdingTime[51]    = RobotAuto._cdingTime[51] - delta
    if RobotAuto._cdingTime[51] <= 0 then
        if SL:GetValue("SETTING_ENABLED", 51) == 1 then
            -- 是否有损坏的装备
            local found             = false
            local equipData         = EquipData.GetEquipData()
            local articleType       = GUIDefine.ItemArticleType
            local checkArticleType  = {[articleType.TYPE_FIX] = true}
            for _, equip in pairs(equipData) do
                if equip.Dura < 1000 and not isInvalidEquip(equip) then
                    if not SL:GetValue("ITEM_ARTICLE", equip.Index, checkArticleType) then
                        local fixValue = equip.Bind or 0
                        found = not SL:CheckBit(fixValue, 3) --是否已经修复过了
                        if found then 
                            break
                        end
                    end
                end
            end

            -- 是否有
            if found then
                local items         = RobotAuto._items[51]
                local result        = RobotAuto.AutoUseItem(items)
                local cdtime        = SL:GetValue("SERVER_OPTION", SW_KEY_EAT_ITEM_SPEED) or 1000
                RobotAuto._cdingTime[51] = cdtime / 1000
            end
        end
    end
end
-------------------------------------------------------


-------------------------------------------------------
-- 自动释放
function RobotAuto.AutoLaunch(delta)
    RobotAuto._launchTime = RobotAuto._launchTime + delta
    if RobotAuto._launchTime <= 1 then
        return false
    end
    RobotAuto._launchTime = 0


    local skillID, destPosX, destPosY = SkillUtils.FindRobotLaunchSkill()
    if not skillID then
        return nil
    end

    local skillID           = skillID
    local priority          = GUIDefine.LaunchPriority.ROBOT
    local launchType        = GUIDefine.LaunchType.AUTO
    SharedInputLaunchData.launchType = launchType
    SharedInputLaunchData.priority = priority
    SharedInputLaunchData.skillID = skillID
    SharedInputLaunchData.destPosX = destPosX
    SharedInputLaunchData.destPosY = destPosY
    SL:InputLaunch(SharedInputLaunchData)
end

-------------------------------------------------------
-- 自动练功
function RobotAuto.AutoTraining(delta)
    local value = SL:GetValue("SETTING_VALUE", 38)
    if not value[1] or value[1] == 0 then
        return false
    end

    local skillID           = tonumber(value[1])
    local delay             = value[2] or 3
    RobotAuto._trainingTime = RobotAuto._trainingTime + delta
    if RobotAuto._trainingTime >= delay and skillID ~= -1 then
        RobotAuto._trainingTime = 0

        if SL:GetValue("SKILL_CHECK_LAUNCH", skillID) ~= 1 then
            return nil
        end
        if not SL:GetValue("CHECK_AUTO_TRAIN_ABLE") then
            return nil
        end
        local targetID = SL:GetValue("SELECT_TARGET_ID")
        if targetID then
            if not SL:GetValue("ACTOR_IS_MONSTER", targetID) then
                return nil
            end
        end
    
        local skillID           = skillID
        local destPos           = SL:GetValue("FACE_DEST")
        local priority          = GUIDefine.LaunchPriority.ROBOT
        local launchType        = GUIDefine.LaunchType.AUTO
        SharedInputLaunchData.launchType = launchType
        SharedInputLaunchData.priority = priority
        SharedInputLaunchData.skillID = skillID
        SharedInputLaunchData.destPosX = destPos and destPos.x
        SharedInputLaunchData.destPosY = destPos and destPos.y
        SL:InputLaunch(SharedInputLaunchData)
    end
end

RobotAuto.main()