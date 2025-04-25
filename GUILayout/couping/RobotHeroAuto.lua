RobotHeroAuto = {}

function RobotHeroAuto.main()
    RobotHeroAuto._items                 = {}
    RobotHeroAuto._cdingTime             = {}

    RobotHeroAuto._launchTime            = 0
    RobotHeroAuto._trainingTime          = 0
    RobotHeroAuto._loginHeroDelayTime    = 1--召唤英雄的间隔
    RobotHeroAuto._loginHeroTime         = 0
    
    RobotHeroAuto._loginOutHeroDelayTime = 1--收回英雄的间隔
    RobotHeroAuto._loginOutHeroTime      = 0
    
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4] = 0
    
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3] = 0
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4] = 0
    
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] = 0
    
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_INITED, "RobotHeroAuto", RobotHeroAuto.Init)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE,      "RobotHeroAuto", RobotHeroAuto.OnBagOperData)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_HPMP_CHANGE,     "RobotHeroAuto", RobotHeroAuto.OnHeroBeAttacked)
end

function RobotHeroAuto.OnHeroBeAttacked()
    --残血收回
    if not SL:GetValue("HERO_IS_ACTIVE") then
        return
    end
    if not SL:GetValue("HERO_IS_ALIVE") then
        return
    end
    local value = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_LOGINOUT)
    local enable = value[1] == 1
    if not enable then
        return
    end
    -- 人物或英雄可以复活时，不自动使用回城卷，随机卷，自动召回，不能复活时才自动使用
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT_HERO) == 1 and SL:GetValue("HERO_CAN_REVIVE") then
        return
    end

    local per   = (value[2] or 50) / 100
    local curHp = SL:GetValue("H.HP") or 1
    local maxHp = SL:GetValue("H.MAXHP") or 1
    local percent = curHp / maxHp
    if RobotHeroAuto._loginOutHeroTime >= RobotHeroAuto._loginOutHeroDelayTime and percent < per and percent >= 0 then
        RobotHeroAuto._loginOutHeroTime = 0
        SL:RequestCallOrOutHero()
    end
end

function RobotHeroAuto.OnBagOperData(data)
    if data.opera == GUIDefine.OperateType.DEL and data.operID and data.operID[1].item then
        SL:UnpackDrugByIndexHero(data.operID[1].item.Index)
    end
end

function RobotHeroAuto.Init()
    -- 药品
    RobotHeroAuto._items[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] = SL:GetValue("GAME_DATA", "fixItemDrug")
    RobotHeroAuto.TimerBegan()
end

function RobotHeroAuto.TimerBegan()
    if not RobotHeroAuto._timerID then
        local function callback(delta)
            RobotHeroAuto.Tick(delta)
        end
        RobotHeroAuto._timerID = SL:Schedule(callback, 0.1)
    end
end

function RobotHeroAuto.TimerEnded()
    if RobotHeroAuto._timerID then
        SL:UnSchedule(RobotHeroAuto._timerID)
        RobotHeroAuto._timerID = nil
    end
end

function RobotHeroAuto.Tick(delta)
    -- 摆摊
    if SL:GetValue("STALL_MY_TRADING_STATUS") then
        return nil
    end
    if not SL:GetValue("USEHERO") then
        return nil
    end
    --自动召唤
    RobotHeroAuto.AutoLogin(delta)
    --自动收回
    RobotHeroAuto.AutoLoginOut(delta)--改成被攻击触发
    -- 自动释放相关
    RobotHeroAuto.AutoLaunch(delta)
    -- 自动使用修复神水
    RobotHeroAuto.AutoUseFIXItem(delta)
    --hp保护
    RobotHeroAuto.AutoHpProtect(delta)
    --mp保护
    RobotHeroAuto.AutoMpProtect(delta)
end
function RobotHeroAuto.AutoMpProtect(delta)
    local hp = SL:GetValue("H.HP")
    if hp == 0 then
        return
    end
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4] - delta
    -- 自动吃药相关
    local mppercent     = SL:GetValue("H.MPPercent")
    local maxMP         = SL:GetValue("H.MAXMP")
    -- mp保护1
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1] = (protectData.time or 1000)/1000
            end
        end
    end
    -- mp保护2
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2] = (protectData.time or 1000)/1000
            end
        end
    end
    -- mp保护3
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3] = (protectData.time or 1000)/1000
            end
        end
    end
    -- mp保护4
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxMP > 0 and mppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4] = (protectData.time or 1000)/1000
            end
        end
    end
end

function RobotHeroAuto.AutoHpProtect(delta)
    -- dead
    local hp = SL:GetValue("H.HP")
    if hp == 0 then
        return
    end
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3] - delta
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4] - delta
    -- 自动吃药相关
    local hppercent     = SL:GetValue("H.HPPercent")
    local maxHP         = SL:GetValue("H.MAXHP")
    -- hp保护1
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1] = (protectData.time or 1000)/1000
            end
        end
    end
    -- hp保护2
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2] = (protectData.time or 1000)/1000
            end
        end
    end
    -- hp保护3
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3] = (protectData.time or 1000)/1000
            end
        end
    end
    -- hp保护4
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4] <= 0 then
        local value     = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4)
        local enable    = value[1] == 1
        local percent   = value[2] or 50
        if enable and maxHP > 0 and hppercent <= percent then
            local protectData = SL:GetValue("SETTING_RANK_DATA", SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4)
            local used        = RobotHeroAuto.AutoUseItem(protectData.indexs, true)
            if used then
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4] = (protectData.time or 1000)/1000
            end
        end
    end
end
-------------------------自动召唤
function RobotHeroAuto.AutoLogin(delay)
    if not SL:GetValue("HERO_IS_ACTIVE") then
        return
    end
    if SL:GetValue("HERO_IS_ALIVE") then
        return
    end
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_LOGIN) == 0 then
        return
    end
    if RobotHeroAuto._loginHeroTime >= RobotHeroAuto._loginHeroDelayTime and SL:GetValue("HERO_LOGIN_CD") == 0 then
        RobotHeroAuto._loginHeroTime = 0
        SL:RequestCallOrOutHero()
    else
        RobotHeroAuto._loginHeroTime = RobotHeroAuto._loginHeroTime + delay
    end
end
-----------------------
-- 修复神水
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
local checkFixArticleType = {[GUIDefine.ItemArticleType.TYPE_FIX] = true}

function RobotHeroAuto.AutoUseFIXItem(delta)
    if SL:GetValue("USER_IS_DIE") then
        return nil
    end
    if not SL:GetValue("HERO_IS_ACTIVE") then
        return
    end
    if  not SL:GetValue("HERO_IS_ALIVE") then
        return
    end
    -- cding
    RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] = RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] - delta
    if RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] <= 0 then
        if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR) == 1 then
            -- 是否有损坏的装备
            local found             = false
            local equipData         = HeroEquipData.GetEquipData()
            for _, equip in pairs(equipData) do
                if equip.Dura < 1000 and not isInvalidEquip(equip) then
                    if not SL:GetValue("ITEM_ARTICLE", equip.Index, checkFixArticleType) then
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
                local items         = RobotHeroAuto._items[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR]
                local result        = RobotHeroAuto.AutoUseItem(items)
                local cdtime        = SL:GetValue("SERVER_OPTION", SW_KEY_EAT_ITEM_SPEED) or 1000
                RobotHeroAuto._cdingTime[SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR] = cdtime / 1000
            end
        end
    end
end
-------------------------自动收回
function RobotHeroAuto.AutoLoginOut(delay)
    RobotHeroAuto._loginOutHeroTime = RobotHeroAuto._loginOutHeroTime + delay
end
-----------------------
function RobotHeroAuto.FindItemByIndex_Hero(index)
    local itemData = HeroBagData.GetItemDataByItemIndex(index)
    if itemData and itemData[1] then
        return itemData[1]
    end

    return nil
end

function RobotHeroAuto.AutoUseItem(items, isHpProtect)
    for _, itemIndex in ipairs(items) do
        repeat
            if SL:GetValue("ITEM_IS_CITY_STONE", itemIndex) or SL:GetValue("ITEM_IS_RAND_STONE", itemIndex) then 
                if SL:GetValue("MAP_IS_IN_SAFE_AREA") then -- 安全区不使用
                    break
                end
                if isHpProtect then -- hp保护检查 复活
                    -- 复活戒指准备就绪，回城/随机保护不生效
                    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT_HERO) == 1 and SL:GetValue("HERO_CAN_REVIVE") then
                        break
                    end
                end
                local item = RobotAuto.FindItemByIndex(itemIndex) -- 回城/随机保护不生效 得人物用
                if item then
                    SL:RequestUseItem(item)
                    return true
                end
                break
            else 
                local unpack = SL:UnpackDrugByIndexHero(itemIndex)
                if unpack then
                    return true
                end
                local item = RobotHeroAuto.FindItemByIndex_Hero(itemIndex)
                if item then
                    SL:RequestUseHeroItem(item)
                    return true
                end
            end
        until true

    end
    return false
end
-------------------------------------------------------

-------------------------------------------------------
-- 自动释放
function RobotHeroAuto.AutoLaunch(delta)
    RobotHeroAuto._launchTime = RobotHeroAuto._launchTime + delta
    if RobotHeroAuto._launchTime <= 1 then
        return false
    end
    RobotHeroAuto._launchTime = 0

    local hp = SL:GetValue("H.HP")
    if hp == 0 then
        return
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID then
        return nil
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return
    end

    if SL:GetValue("MAP_IS_IN_SAFE_AREA")
    and (not SL:GetValue("ACTOR_IS_MONSTER", targetID) and not SL:GetValue("ACTOR_IS_HUMAN", targetID))
    then --安全区不打人 可以打怪
        return nil
    end
    
    if not SL:GetValue("TARGET_ATTACK_ENABLE", targetID) then
        return nil
    end

    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_JOINT) == 1 then--自动释放
        local jointSkill = SL:GetValue("HERO_JOINT_SKILL")
        if not jointSkill then
            return nil
        end
        if SL:GetValue("H.SHAN") then--在闪的时候才能放合击
            SL:RequestHeroJoinAttack()--请求合击
        end
    end
end

RobotHeroAuto.main()
