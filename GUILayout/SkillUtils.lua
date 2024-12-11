SkillUtils = {}

SKILL_ID_PuGong             = 0         -- 普攻
SKILL_ID_ShiDuShu           = 6         -- 施毒术
SKILL_ID_GongSha            = 7         -- 攻杀
SKILL_ID_KJHuoHuan          = 8         -- 抗拒火环
SKILL_ID_CiSha              = 12        -- 刺杀
SKILL_ID_YouLingDun         = 14        -- 幽灵盾
SKILL_ID_SSZhanJia          = 15        -- 神圣战甲术
SKILL_ID_ZHKuLou            = 17        -- 召唤骷髅
SKILL_ID_YinShenShu         = 18        -- 隐身术
SKILL_ID_HuoQiang           = 22        -- 火墙
SKILL_ID_DYLeiGuang         = 24        -- 地狱雷光
SKILL_ID_BanYue             = 25        -- 半月
SKILL_ID_LieHuo             = 26        -- 烈火
SKILL_ID_YMChongZhuang      = 27        -- 野蛮冲撞
SKILL_ID_XLQISHI            = 28        -- 心灵启示
SKILL_ID_QTZhiYuShu         = 29        -- 群体治愈术
SKILL_ID_ZHShenShou         = 30        -- 召唤神兽
SKILL_ID_MoFaDun            = 31        -- 魔法盾
SKILL_ID_HuoYanBing         = 36        -- 火焰冰
SKILL_ID_ShuangLongZhan     = 40        -- 双龙斩
SKILL_ID_ShiZiHou           = 41        -- 狮子吼
SKILL_ID_LYJianFa           = 42        -- 龙影剑法
SKILL_ID_LTJianFa           = 43        -- 雷霆剑法
SKILL_ID_HanBingZhang       = 44        -- 寒冰掌
SKILL_ID_WuJiZhenQi         = 50        -- 无极真气
SKILL_ID_QTShiDuShu         = 51        -- 群体施毒术
SKILL_ID_ZHYueLing          = 55        -- 召唤月灵
SKILL_ID_ZhuRi              = 56        -- 逐日
SKILL_ID_ShiXueShu          = 57        -- 嗜血术
SKILL_ID_KaiTian            = 66        -- 开天
SKILL_ID_DaoLiDun           = 73        -- 道力盾
SKILL_ID_ZHShengShou        = 76        -- 召唤圣兽
SKILL_ID_ZHJianShu          = 81        -- 纵横剑术
SKILL_ID_SBYiSha            = 82        -- 十步一杀
SKILL_ID_BingLianShu        = 83        -- 冰镰术
SKILL_ID_BSQunYu            = 84        -- 冰霜群雨
SKILL_ID_LieShenFu          = 85        -- 裂神符
SKILL_ID_SWZhiYan           = 86        -- 死亡之眼
SKILL_ID_WuLiDun            = 87        -- 武力盾
SKILL_ID_XPYiJi             = 115       -- 血魄一击

local AUTO_SETTING_KEY_VALUE = {
    [SKILL_ID_MoFaDun]      = SLDefine.SETTINGID.SETTING_IDX_AUTO_MOFADUN,          -- 自动魔法盾
    [SKILL_ID_HuoQiang]     = SLDefine.SETTINGID.SETTING_IDX_AUTO_FIRE_WALL,        -- 自动火墙
    [SKILL_ID_ShiDuShu]     = SLDefine.SETTINGID.SETTING_IDX_AUTO_DU,               -- 自动施毒术
    [SKILL_ID_YouLingDun]   = SLDefine.SETTINGID.SETTING_IDX_AUTO_YOULINGDUN,       -- 自动幽灵盾
    [SKILL_ID_SSZhanJia]    = SLDefine.SETTINGID.SETTING_IDX_AUTO_SSZJS,            -- 自动神圣战甲术
    [SKILL_ID_WuJiZhenQi]   = SLDefine.SETTINGID.SETTING_IDX_AUTO_WJZQ,             -- 自动无极真气
    [SKILL_ID_YinShenShu]   = SLDefine.SETTINGID.SETTING_IDX_AUTO_CLOAKING,         -- 自动隐身
    [SKILL_ID_HanBingZhang] = SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_PALM,         -- 自动寒冰掌
    [SKILL_ID_ShiXueShu]    = SLDefine.SETTINGID.SETTING_IDX_AUTO_BLOODTHIRSTY_S,   -- 自动嗜血术
    [SKILL_ID_LieShenFu]    = SLDefine.SETTINGID.SETTING_IDX_AUTO_BREACH_NERVE_FU,  -- 自动裂神符
    [SKILL_ID_BingLianShu]  = SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_SICKLE_S,     -- 自动冰镰术
    [SKILL_ID_HuoYanBing]   = SLDefine.SETTINGID.SETTING_IDX_AUTO_FLAME_ICE,        -- 自动火焰冰
    [SKILL_ID_BSQunYu]      = SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_GROUP_RAIN,   -- 自动冰霜群雨
    [SKILL_ID_SWZhiYan]     = SLDefine.SETTINGID.SETTING_IDX_AUTO_DEATH_EYE,        -- 自动死亡之眼
    [SKILL_ID_ShiZiHou]     = SLDefine.SETTINGID.SETTING_IDX_AUTO_SHI_ZI_HOU,       -- 自动狮子吼
    [SKILL_ID_WuLiDun]      = SLDefine.SETTINGID.SETTING_IDX_AUTO_SHIELD_OF_FORCE,  -- 自动武力盾
    [SKILL_ID_DaoLiDun]     = SLDefine.SETTINGID.SETTING_IDX_AUTO_SHIELD_OF_TAOIST, -- 自动道力盾
}

-- 内挂检测技能
local SETTING_SKILL = {
    SKILL_ID_KaiTian,
    SKILL_ID_ZhuRi,
    SKILL_ID_LYJianFa,
    SKILL_ID_LTJianFa,
    SKILL_ID_ZHJianShu,
    SKILL_ID_ShiDuShu,
    SKILL_ID_HuoQiang,
    SKILL_ID_HanBingZhang,
    SKILL_ID_ShiXueShu,
    SKILL_ID_LieShenFu,
    SKILL_ID_SWZhiYan,
    SKILL_ID_BingLianShu,
    SKILL_ID_HuoYanBing,
    SKILL_ID_BSQunYu,
    SKILL_ID_LieHuo,
}

local sharedQuickSelTab = {}

local SLDirection = SLDefine.Direction
local banyueAround = {
    [SLDirection.UP]            = {{-1, -1}, {0, -1}, {1, -1}, {1, 0}},
    [SLDirection.RIGHT_UP]      = {{0, -1}, {1, -1}, {1, 0}, {1, 1}},
    [SLDirection.RIGHT]         = {{1, -1}, {1, 0}, {1, 1}, {0, 1}},
    [SLDirection.RIGHT_BOTTOM]  = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}},
    [SLDirection.BOTTOM]        = {{1, 1}, {0, 1}, {-1, 1}, {-1, 0}},
    [SLDirection.LEFT_BOTTOM]   = {{0, 1}, {-1, 1}, {-1, 0}, {-1, -1}},
    [SLDirection.LEFT]          = {{-1, 1}, {-1, 0}, {-1, -1}, {0, -1}},
    [SLDirection.LEFT_UP]       = {{-1, 0}, {-1, -1}, {0, -1}, {1, -1}}
}

local slzAround = {
    [SLDirection.UP]            = {{-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}},
    [SLDirection.RIGHT_UP]      = {{-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}},
    [SLDirection.RIGHT]         = {{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}},
    [SLDirection.RIGHT_BOTTOM]  = {{1, -1}, {1, 0}, {1, 1}, {0, 1},{-1, 1}},
    [SLDirection.BOTTOM]        = {{1, 0}, {1, 1}, {0, 1}, {-1, 1},{0, -1}},
    [SLDirection.LEFT_BOTTOM]   = {{1, 1}, {0, 1}, {-1, 1}, {-1, 0},{-1, -1}},
    [SLDirection.LEFT]          = {{0, 1}, {-1, 1}, {-1, 0}, {-1, -1},{0, -1}},
    [SLDirection.LEFT_UP]       = {{-1, 1}, {-1, 0}, {-1, -1}, {0, -1},{1, -1}}
}

SkillUtils.CalcLaunchDirection = function(dstPosX, dstPosY,  srcPosX, srcPosY)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return SLDirection.UP
    end
    if not dstPosX or not srcPosX or not dstPosY or not srcPosY then
        return SL:GetValue("DIR")
    end
    if srcPosX == dstPosX and srcPosY == dstPosY then
        return SL:GetValue("DIR")
    end
    return GUIFunction:CalcMapDirection(dstPosX, dstPosY, srcPosX, srcPosY)
end

--------------------------- 技能检测 begin -------------------------------
SkillUtils.CHECK_SKILL = {
    -- 武力盾
    [SKILL_ID_WuLiDun] = function(targetID)
        local skillID = SKILL_ID_WuLiDun
        -- exist shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.MAGIC_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 魔法盾
    [SKILL_ID_MoFaDun] = function(targetID)
        local skillID = SKILL_ID_MoFaDun
        -- exist shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.MAGIC_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 道力盾
    [SKILL_ID_DaoLiDun] = function(targetID)
        local skillID = SKILL_ID_DaoLiDun
        -- exist shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.MAGIC_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 无极真气
    [SKILL_ID_WuJiZhenQi] = function(targetID)
        local skillID = SKILL_ID_WuJiZhenQi
        -- exit shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.WUJI_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 幽灵盾
    [SKILL_ID_YouLingDun] = function(targetID)
        local skillID = SKILL_ID_YouLingDun
        -- exist shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.GHOST_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 神圣战甲术
    [SKILL_ID_SSZhanJia] = function(targetID)
        local skillID = SKILL_ID_SSZhanJia
        -- exist shield
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.ANGEL_SHIELD) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 召唤月灵
    [SKILL_ID_ZHYueLing] = function(targetID)
        local skillID = SKILL_ID_ZHYueLing
        if not SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 召唤神兽
    [SKILL_ID_ZHShenShou] = function(targetID)
        local skillID = SKILL_ID_ZHShenShou
        if not SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 召唤圣兽
    [SKILL_ID_ZHShengShou] = function(targetID)
        local skillID = SKILL_ID_ZHShengShou
        if not SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 召唤骷髅
    [SKILL_ID_ZHKuLou] = function(targetID)
        local skillID = SKILL_ID_ZHKuLou
        if not SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
            return nil
        end
        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 火墙
    [SKILL_ID_HuoQiang] = function(targetID)
        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end
        local skillID = SKILL_ID_HuoQiang
        -- check fire is existed
        local dstX = SL:GetValue("ACTOR_MAP_X", targetID)
        local dstY = SL:GetValue("ACTOR_MAP_Y", targetID)
        if SL:GetValue("MAP_IS_EXIST_FIREWALL", dstX, dstY) then
            return nil
        end

        -- check launchTime
        local lastLaunchTime = SL:GetValue("SKILL_CUSTOM_DATA", skillID)
        local currTime = os.time()
        if lastLaunchTime and currTime - lastLaunchTime < 3 then
            return nil
        end
       SL:SetValue("SKILL_CUSTOM_DATA", skillID, currTime)

        return skillID, dstX, dstY
    end,

    -- 施毒术
    [SKILL_ID_ShiDuShu] = function(targetID)
        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end

        if not SL:GetValue("CHECK_SKILL_SDS_TIME") then
            return nil
        end

        local skillID = SKILL_ID_ShiDuShu
        -- 红绿毒
        local res = 0
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", targetID, SLDefine.BUFFID.POISONING_RED) then
            res = res + 1
        end
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", targetID, SLDefine.BUFFID.POISONING_GREEN) then
            res = res + 2
        end

        if res == 0 then
            if GUIFunction:CheckSkillAbleToLaunch(skillID) == 1 then
                SL:SetValue("UPDATE_SKILL_SDS_TIME")
            end
            return skillID
        elseif res == 1 and GUIFunction:CheckDuItem(1) then
            return skillID
        elseif res == 2 and GUIFunction:CheckDuItem(2) then
            return skillID
        end
        return nil
    end,

    -- 群体施毒术
    [SKILL_ID_QTShiDuShu] = function(targetID)
        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end

        local skillID = SKILL_ID_QTShiDuShu
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", targetID, SLDefine.BUFFID.POISONING_RED) or SL:GetValue("ACTOR_HAS_ONE_BUFF", targetID, SLDefine.BUFFID.POISONING_GREEN) then
            return nil
        end
        return skillID
    end,

    -- 隐身术
    [SKILL_ID_YinShenShu] = function(targetID)
        local skillID = SKILL_ID_YinShenShu
        if SL:GetValue("ACTOR_HAS_ONE_BUFF", SL:GetValue("USER_ID"), SLDefine.BUFFID.CLOAKING) then
            return nil
        end

        -- 根据模式来确定是否判断符毒
        -- （0：穿戴，1:背包，2：无）
        local skillAmuleType = SL:GetValue("SERVER_OPTION", "UseAmuletType")
        if skillAmuleType == 2 then
            return skillID, SL:GetValue("X"), SL:GetValue("Y")
        end
        if not ((skillAmuleType == 0 or skillAmuleType == 1) and
            (GUIFunction:CheckDressEquipSkillID(skillID) or GUIFunction:CheckBagEquipSkillID(skillID))) then
            return nil
        end

        return skillID, SL:GetValue("X"), SL:GetValue("Y")
    end,

    -- 半月
    [SKILL_ID_BanYue] = function(targetID)
        local skillID = SKILL_ID_BanYue
        local ret = GUIFunction:CheckSkillAbleToLaunch(skillID)
        if ret ~= 1 and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SMART_BANYUE) ~= 1 then
            return nil
        end

        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end

        local monsterID = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
        if not SL:GetValue("SKILL_CAN_ATTACK_MONSTER", skillID, monsterID) then
            return nil
        end

        local mapX = SL:GetValue("X")
        local mapY = SL:GetValue("Y")
        local mainPlayerDir = SL:GetValue("DIR")
        local count = 0
        local isTargetAround = false
        for k, v in ipairs(banyueAround[mainPlayerDir] or {}) do
            local monsterIDs = SL:GetValue("MONSTER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
            if monsterIDs then
                for i, monID in ipairs(monsterIDs) do
                    if GUIFunction:CheckLaunchEnableByID(monID) and
                        not SL:GetValue("IS_SKILL_IGNORE_MONSTER", skillID, SL:GetValue("ACTOR_TYPE_INDEX", monID)) then
                        count = count + 1

                        if not isTargetAround then
                            isTargetAround = targetID == monID
                        end
                    end
                end
            end

            if not isTargetAround or count < 2 then
                local playerIDs = SL:GetValue("PLAYER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
                if playerIDs then
                    for i, playerID in ipairs(playerIDs) do
                        if GUIFunction:CheckLaunchEnableByID(playerID) then
                            count = count + 1

                            if not isTargetAround then
                                isTargetAround = targetID == playerID
                            end
                        end
                    end
                end
            end

            if count >= 2 and isTargetAround then
                break
            end
        end

        if not isTargetAround then
            count = 0
        end

        -- 自动打开/关闭
        if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SMART_BANYUE) == 1 then
            local isOnSkill = SL:GetValue("SKILL_IS_ON_SKILL", skillID)
            if isOnSkill and count < 2 then
                SL:SetValue("SKILL_ON", skillID, false)
                return nil
            elseif not isOnSkill and count >= 2 then
                SL:SetValue("SKILL_ON", skillID, true)
                return nil
            end
        end

        return count >= 2 and skillID or nil, SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID), false
    end,

    -- 双龙斩
    [SKILL_ID_ShuangLongZhan] = function(targetID)
        local skillID = SKILL_ID_ShuangLongZhan
        local ret = GUIFunction:CheckSkillAbleToLaunch(skillID)
        if ret ~= 1 and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SMART_BANYUE) ~= 1 then
            return nil
        end

        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end

        local monsterID = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
        if not SL:GetValue("SKILL_CAN_ATTACK_MONSTER", skillID, monsterID) then
            return nil
        end

        local mapX = SL:GetValue("X")
        local mapY = SL:GetValue("Y")
        local mainPlayerDir = SL:GetValue("DIR")
        local count = 0
        local isTargetAround = false
        local aroundT = targetID and slzAround[mainPlayerDir] or {}
        for k, v in ipairs(aroundT) do
            local monsterIDs = SL:GetValue("MONSTER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
            if monsterIDs then
                for i, monID in ipairs(monsterIDs) do
                    if GUIFunction:CheckLaunchEnableByID(monID) then
                        count = count + 1

                        if not isTargetAround then
                            isTargetAround = targetID == monID
                        end
                    end
                end
            end

            if not isTargetAround or count < 2 then
                local playerIDs = SL:GetValue("PLAYER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
                if playerIDs then
                    for i, playerID in ipairs(playerIDs) do
                        if GUIFunction:CheckLaunchEnableByID(playerID) then
                            count = count + 1

                            if not isTargetAround then
                                isTargetAround = targetID == playerID
                            end
                        end
                    end
                end
            end

            if count >= 2 and isTargetAround then
                break
            end
        end

        if not isTargetAround then
            count = 0
        end

        -- 自动打开/关闭
        if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SMART_BANYUE) == 1 then
            local isOnSkill = SL:GetValue("SKILL_IS_ON_SKILL", skillID)
            if isOnSkill and count < 2 then
                SL:SetValue("SKILL_ON", skillID, false)
                return nil
            elseif not isOnSkill and count >= 2 then
                SL:SetValue("SKILL_ON", skillID, true)
                return nil
            end
        end

        return count >= 2 and skillID or nil, SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID), false
    end,

    -- 群体治愈术
    [SKILL_ID_QTZhiYuShu] = function(targetID)
        local skillID = SKILL_ID_QTZhiYuShu
        if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
            return nil
        end
        if SL:GetValue("ACTOR_RELATION_TAG", targetID) == 1 then
            return nil
        end
        return skillID
    end,

    -- 刺杀
    [SKILL_ID_CiSha] = function(targetID)
        local skillID = SKILL_ID_CiSha
        if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
            local monsterID = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
            if not SL:GetValue("SKILL_CAN_ATTACK_MONSTER", skillID, monsterID) then
                return nil
            end
        end

        return skillID
    end
}

-- 检测技能内挂开关
SkillUtils.CheckAutoSetting = function(skillID)
    local settingID = nil
    if skillID and skillID > 1000 then  -- 自定义技能
        settingID = 10000 + skillID
        local config = SL:GetValue("SKILL_CONFIG", skillID)
        if (config and config.skilltype == 4) or not SL:GetValue("SETTING_CONFIG", settingID) then
            settingID = nil
        end
    else
        settingID = AUTO_SETTING_KEY_VALUE[skillID]
    end
    if not settingID then
        return true
    end
    return SL:GetValue("SETTING_ENABLED", settingID) == 1
end

-- 检测技能释放
SkillUtils.CheckSkillLaunch = function(skillID, targetID)
    if not SkillUtils.CheckAutoSetting(skillID) then
        return nil
    end
    local destPosX, destPosY = nil, nil
    local checkSkill = SkillUtils.CHECK_SKILL[skillID]
    if checkSkill then
        local skillIDT, destPosT1, destPosT2 = checkSkill(targetID)
        if not skillIDT then
            return nil
        end
        destPosX = destPosT1
        destPosY = destPosT2
    end

    if skillID and GUIFunction:CheckSkillAbleToLaunch(skillID) ~= 1 then
        return nil
    end

    return skillID, destPosX, destPosY
end

-- 检测自动战斗技能释放
SkillUtils.CheckAbleToAutoLaunch = function(skillID, targetID, multiJob)
    local roleJob = SL:GetValue("JOB")
    if multiJob and not GUIFunction:IsFighter(roleJob) and not GUIFunction:IsWizzard(roleJob) and not GUIFunction:IsTaoist(roleJob) then
    else
        if not SkillUtils.CheckAutoSetting(skillID) then
            return nil
        end
    end

    local skillID, destPosX, destPosY = SkillUtils.CheckSkillLaunch(skillID, targetID)
    if not skillID then
        return nil
    end

    if SL:GetValue("ACTOR_IS_VALID", targetID) then
        local monsterID = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
        if not SL:GetValue("SKILL_CAN_ATTACK_MONSTER", skillID, monsterID) then
            return nil
        end
    end

    -- 召唤
    local config = SL:GetValue("SKILL_CONFIG", skillID)
    if config and config.skilltype == 4 and not SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
        return nil
    end

    -- 根据模式来确定是否判断符毒
    -- （0：穿戴，1:背包，2：无）
    local skillAmuleType = SL:GetValue("SERVER_OPTION", "UseAmuletType")

    -- 无
    if not skillAmuleType or skillAmuleType == 2 then
        return skillID, destPosX, destPosY
    end

    if (skillAmuleType == 0 or skillAmuleType == 1) and (GUIFunction:CheckDressEquipSkillID(skillID) or GUIFunction:CheckBagEquipSkillID(skillID)) then
        return skillID, destPosX, destPosY
    end

    return nil
end

-- 飞行技能被阻挡
SkillUtils.CheckSkillBlocked = function(skillID, srcPosX, srcPosY, dstPosX, dstPosY)
    if not (skillID == 1 or skillID == 5 or skillID == 13) then
        return false
    end
    if srcPosX == dstPosX and srcPosY == dstPosY then
        return false
    end

    if not SL:GetValue("SELECT_TARGET_ID") then
        return false
    end

    local isMiss = SL:GetValue("SELECT_TARGET_ID") == SL:GetValue("SKILL_HIT_MISS_ACTORID")
    SL:SetValue("RESET_SKILL_HIT_MISS_ACTORID")
    return isMiss
end

SkillUtils.CheckTarget = function(skillID)
    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    -- 是否是增益技能
    if skillID and SL:GetValue("SKILL_IS_ADDITION_SKILL", skillID) then
        -- 是友方
        if SL:GetValue("ACTOR_IS_PLAYER", targetID) or (SL:GetValue("ACTOR_IS_MONSTER", targetID) and SL:GetValue("ACTOR_HAVE_MASTER", targetID)) then
            return targetID
        end
        return nil
    end

    -- 是否可攻击
    if false == GUIFunction:CheckLaunchEnableByID(targetID) then
        return nil
    end

    return targetID
end

-- 检测目标范围群怪
local neighborsAround = {{1, 0}, {1, 1}, {1, -1}, {-1, 0}, {-1, 1}, {-1, -1}, {0, 1}, {0, -1}, {0, 0}}
SkillUtils.CheckTargetNeighbors = function(targetID, count)
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) or SL:GetValue("ACTOR_IS_DIE", targetID) or SL:GetValue("ACTOR_IS_DEATH", targetID) then
        return nil
    end

    local neighbors = {}
    local mapX = SL:GetValue("ACTOR_MAP_X", targetID)
    local mapY = SL:GetValue("ACTOR_MAP_Y", targetID)
    for i, v in ipairs(neighborsAround) do
        if count and #neighbors >= count then
            break
        end

        if SL:GetValue("ACTOR_IS_MONSTER", targetID) then
            local monsterIDs = SL:GetValue("MONSTER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
            if monsterIDs then
                for i, monID in ipairs(monsterIDs) do
                    if targetID ~= monID and GUIFunction.CheckAutoTargetEnableByID(monID) then
                        table.insert(neighbors, monID)
                    end
                end
            end
        elseif SL:GetValue("ACTOR_IS_PLAYER", targetID) then
            local playerIDs = SL:GetValue("PLAYER_BY_MAPXY", mapX + v[1], mapY + v[2], true)
            if playerIDs then
                for i, playerID in ipairs(playerIDs) do
                    if targetID ~= playerID and GUIFunction.CheckAutoTargetEnableByID(playerID) then
                        table.insert(neighbors, playerID)
                    end
                end
            end
        end
    end

    return neighbors
end

--------------------------- 技能检测 end -------------------------------
-- 自动找目标，只会找可攻击的
SkillUtils.FindTarget = function()
    local targetID = SL:GetValue("SELECT_TARGET_ID")

    -- auto select monster
    if not targetID then
        GUIFunction:OnAutoFindHumanoidFunc()
        targetID = SL:GetValue("SELECT_TARGET_ID")
    end

    -- auto select player
    if not targetID then
        sharedQuickSelTab.type = GUIDefine.ActorType.PLAYER
        SL:onLUAEvent(LUA_EVENT_QUICK_SELECT_TARGET, sharedQuickSelTab)
    end

    -- found
    if nil == SL:GetValue("SELECT_TARGET_ID") then
        return nil
    end

    -- 2.check target actor
    if not SL:GetValue("ACTOR_IS_VALID", SL:GetValue("SELECT_TARGET_ID")) then
        return nil
    end

    return SL:GetValue("SELECT_TARGET_ID")
end

-- 技能释放位置
SkillUtils.FindBestLaunchPos = function(skillID, targetID, srcX, srcY, dstX, dstY)
    if not skillID then
        return srcX, srcY, srcX, srcY
    end
    local minLaunchDis = GUIFunction:GetSkillMinLaunchDistance(skillID)
    local maxLaunchDis = GUIFunction:GetSkillMaxLaunchDistance(skillID)

    local launchBestX = srcX
    local launchBestY = srcY
    local moveBestX = srcX
    local moveBestY = srcY
    if SL:GetValue("SKILL_IS_LINE_ATTACK", skillID) then
        if not (srcX == dstX and srcY == dstY and targetID == nil) then
            launchBestX, launchBestY = SL:GetValue("FIND_BEST_ATTACK_POS", srcX, srcY, dstX, dstY, maxLaunchDis, minLaunchDis)
            moveBestX = launchBestX
            moveBestY = launchBestY
            if skillID ~= SKILL_ID_CiSha and targetID then
                if SL:GetValue("ACTOR_IS_VALID", targetID) and (SL:GetValue("ACTOR_IS_PLAYER", targetID) and SL:GetValue("ACTOR_ACTION", targetID) == GUIDefine.Action.WALK) then
                    local sX = SL:GetValue("ACTOR_MAP_X", targetID)
                    local sY = SL:GetValue("ACTOR_MAP_Y", targetID)
                    local moveDir = SL:GetValue("ACTOR_DIR", targetID)
                    local moveStep = 1
                    local dX, dY = SL:GetValue("FIND_DESTPOS_BY_PARAM", sX, sY, moveDir, moveStep)
                    if dX and dY then
                        moveBestX, moveBestY = SL:GetValue("FIND_BEST_ATTACK_POS", srcX, srcY, dX, dY,
                            maxLaunchDis, minLaunchDis)
                    end
                end
            end
        end
    else
        launchBestX, launchBestY = SL:GetValue("FIND_BEST_SKILL_POS", srcX, srcY, dstX, dstY, maxLaunchDis, minLaunchDis)
        moveBestX = launchBestX
        moveBestY = launchBestY

        -- 自动走位多走一步
        if minLaunchDis > 1 and (srcX ~= launchBestX or srcY ~= launchBestY) then
            moveBestX, moveBestY = SL:GetValue("FIND_BEST_SKILL_POS", srcX, srcY, dstX, dstY, maxLaunchDis, minLaunchDis + 1)
        end
    end
    return launchBestX, launchBestY, moveBestX, moveBestY
end

SkillUtils.FindRobotLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local destPosX, destPosY = SL:GetValue("X"), SL:GetValue("Y")

    -- 魔法盾
    local skillID = SKILL_ID_MoFaDun
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 武力盾
    skillID = SKILL_ID_WuLiDun
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 道力盾
    skillID = SKILL_ID_DaoLiDun
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 幽灵盾
    skillID = SKILL_ID_YouLingDun
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 神圣战甲术
    skillID = SKILL_ID_SSZhanJia
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 自动隐身术
    skillID = SKILL_ID_YinShenShu
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 自动无极真气
    skillID = SKILL_ID_WuJiZhenQi
    if SkillUtils.CheckAbleToAutoLaunch(skillID) then
        return skillID, destPosX, destPosY
    end

    -- 自动招怪
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON) == 1 then
        local value = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON)
        local value1 = value[1]
        skillID = value[2]
        if value1 == 1 and skillID then
            local newAutoSummon = SL:GetValue("SERVER_OPTION", SW_KEY_NEW_AUTO_SUMMON)
            if newAutoSummon and skillID == -1 then 
                skillID = SL:GetValue("AUTO_SUMMON_SKILLID")
                if skillID ~= -1 then 
                    return skillID, destPosX, destPosY
                end
            else
                if SkillUtils.CheckAbleToAutoLaunch(skillID) and SL:GetValue("SKILL_CAN_SUMMONS", skillID) then
                    return skillID, destPosX, destPosY
                end
            end
        end
    end

    -- 自动治愈术
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL) == 1 then
        local value = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL)
        local value2 = value[2]
        skillID = tonumber(value[3])
        local hpPer = SL:GetValue("HP") / SL:GetValue("MAXHP") * 100
        if value2 and tonumber(value2) and skillID and hpPer <= value2 then
            if skillID and SkillUtils.CheckAbleToAutoLaunch(skillID) then
                return skillID, destPosX, destPosY
            end
        end
    end

    return nil
end

SkillUtils.FindFirstLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local skillID, destPosX, destPosY, stamp = SL:GetValue("AUTO_LAUNCH_FIRST_SKILL")
    if not skillID then
        return nil
    end

    if GUIFunction:CheckSkillAbleToLaunch(skillID) ~= 1 then
        return nil
    end

    SL:ClearLaunchFirstSkill()

    if stamp and SL:GetValue("SERVER_TIME") - stamp > 2 then
        return nil
    end

    return skillID, destPosX, destPosY
end

-- 闪避
local avoidAround = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
local autoMoveSkills = {SKILL_ID_KJHuoHuan, SKILL_ID_DYLeiGuang, SKILL_ID_YinShenShu}
SkillUtils.FindAvoidDangerSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    if GUIFunction:IsFighter(SL:GetValue("ACTOR_JOB_ID", mainPlayerID)) then
        return nil
    end

    -- 未开启自动走位
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_MOVE) ~= 1 then
        return nil
    end

    local avoidStamp = SL:GetValue("AUTO_LAUNCH_AVOID_STAMP")
    if SL:GetValue("SERVER_TIME") - avoidStamp < 3 then
        return nil
    end

    -- 检测躲避怪
    local pMapX = SL:GetValue("X")
    local pMapY = SL:GetValue("Y")
    local avoidMonster = false
    for i, v in ipairs(avoidAround) do
        local monsterIDs = SL:GetValue("MONSTER_BY_MAPXY", pMapX + v[1], pMapY + v[2], true)
        if monsterIDs then
            for k, monID in ipairs(monsterIDs) do
                if GUIFunction.CheckAutoTargetEnableByID(monID) then
                    avoidMonster = true
                    break
                end
            end
            if avoidMonster then
                break
            end
        end
    end

    if not avoidMonster then
        return nil
    end

    -- 抗拒火环  地狱雷光  隐身术
    local launchSkill = nil
    for i, _skillID in ipairs(autoMoveSkills) do
        local priority = SL:GetValue("SKILL_PRIORITY", _skillID)
        if priority > 0 and SkillUtils.CheckSkillLaunch(_skillID) then
            launchSkill = _skillID
            break
        end
    end

    if not launchSkill then
        return nil
    end

    return launchSkill, SL:GetValue("X"), SL:GetValue("Y")
end

-- 内挂自动技能
SkillUtils.FindAutoSettingLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    local distance = GUIFunction:CalcMapDistance(SL:GetValue("X"), SL:GetValue("Y"), SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID))

    -- 内挂技能
    -- 刺杀12  烈火剑法26  半月25  开天斩66  逐日56     双龙斩40  龙影剑法42  雷霆剑法43  纵横剑术81 
    -- 施毒6   火墙22  寒冰掌44   噬血术57   裂神符85   死亡之眼86  冰镰术83  火焰冰36   冰霜群雨84
    -- 自动连击
    local skillID = nil
    local destPosX, destPosY = nil, nil
    local skillIDT = nil
    local destPosT1, destPosT2 = nil, nil
    local priority = 0
    local priorityT = nil

    -- 自定义技能
    local skillCount = #SETTING_SKILL
    local settingCustomSkills = {}
    local customSkill = SL:GetValue("ALL_CUSTOM_SKILLS")
    for k, v in pairs(customSkill) do
        local priority = SL:GetValue("SKILL_LOCAL_PRIORITY", v)
        if priority > 0 and SkillUtils.CheckAutoSetting(v) then
            skillCount = skillCount + 1
            settingCustomSkills[skillCount] = v
        end
    end

    for i = 1, skillCount, 1 do
        local id = SETTING_SKILL[i] or settingCustomSkills[i]
        priority = SL:GetValue("SKILL_LOCAL_PRIORITY", id)
        if not priorityT or (priority > priorityT) then
            skillIDT, destPosT1, destPosT2 = SkillUtils.CheckAbleToAutoLaunch(id, targetID)
            if skillIDT then
                if skillIDT == SKILL_ID_LieHuo and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_NEAR_LIEHUO) ~= 1 then
                    if 2 == distance and SkillUtils.CheckAbleToAutoLaunch(SKILL_ID_CiSha, targetID) then
                        skillIDT = nil
                    end
                end
                priorityT   = priority
                skillID     = skillIDT
                destPosX    = destPosT1
                destPosY    = destPosT2
            end
        end
    end

    return skillID, destPosX or SL:GetValue("ACTOR_MAP_X", targetID), destPosY or SL:GetValue("ACTOR_MAP_Y", targetID)
end

local function getCursorMapPos()
    local cursorPos = SL:GetValue("MOUSE_MOVE_POS")
    local worldX, worldY = SL:ConvertScreen2WorldPos(cursorPos.x, cursorPos.y)
    return SL:ConvertWorldPos2MapPos(worldX, worldY)
end

-- 自动释放技能
local ignoreSkills = {[SKILL_ID_BanYue] = true, [SKILL_ID_ShuangLongZhan] = true, [SKILL_ID_CiSha] = true, [SKILL_ID_LieHuo] = true}
SkillUtils.FindAutoLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID then
        return nil
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        return nil
    end

    local targetDestPosX = SL:GetValue("ACTOR_MAP_X", targetID)
    local targetDestPosY = SL:GetValue("ACTOR_MAP_Y", targetID)
    -- 自动连击
    local skillID, destPosX, destPosY = SkillUtils.FindAutoComboLaunchSkill()
    if skillID then
        return skillID, destPosX, destPosY
    end

    skillID, destPosX, destPosY = SkillUtils.FindRobotLaunchSkill()
    if skillID then
        return skillID, destPosX, destPosY
    end

    local srcPosX, srcPosY = SL:GetValue("X"), SL:GetValue("Y")
    -- 施毒术
    skillID, destPosX, destPosY = SkillUtils.CheckAbleToAutoLaunch(SKILL_ID_ShiDuShu, targetID)
    if skillID and not SkillUtils.CheckSkillBlocked(skillID, srcPosX, srcPosY, destPosX, destPosY) then
        if not destPosX or not destPosY then
            destPosX, destPosY = getCursorMapPos()
        end
        return skillID, destPosX, destPosY
    end

    -- 内挂 群、单体技能
    local neighbors = SkillUtils.CheckTargetNeighbors(targetID, 1)
    local isSample = not neighbors[1]
    local settingID = isSample and SLDefine.SETTINGID.SETTING_IDX_AUTO_SIMPSKILL or SLDefine.SETTINGID.SETTING_IDX_AUTO_GROUPSKILL
    local optionValue = SL:GetValue("SETTING_RANK_DATA", settingID)
    local settingSkills = optionValue.indexs or {}

    local isBlocked = false
    -- 单群体技能检测
    local isNeighbors = false
    local destPosT1, destPosT2 = nil, nil
    for k, _skillID in ipairs(settingSkills) do
        if not isNeighbors and SL:GetValue("SKILL_IS_LEARNED", _skillID) then -- 职业变更后内挂的单群体技能还没改变的情况
            isNeighbors = true
        end

        skillID, destPosT1, destPosT2 = SkillUtils.CheckSkillLaunch(_skillID, targetID)
        if skillID then
            destPosX = destPosT1
            destPosY = destPosT2
            if not isBlocked and SkillUtils.CheckSkillBlocked(skillID, srcPosX, srcPosY, targetDestPosX, targetDestPosY) then
                isBlocked = true
            end
            break
        end
    end

    if skillID then
        return skillID, destPosX or targetDestPosX, destPosY or targetDestPosY
    end

    -- 单群体施法检测开关
    local isSkillSN = tonumber(SL:GetValue("GAME_DATA", "check_skill_neighbors")) == 1
    if not isSkillSN then
        settingSkills = {}
    end

    -- 自动战斗检测先检测内挂技能， 然后再检测其它技能
    local ngSkillPriority = 0
    local checkAutoNGLauncher = function(skillID, priority)
        if SETTING_SKILL[skillID] then
            return priority > ngSkillPriority, true
        end
        if skillID and skillID > 1000 then
            local settingID = 10000 + skillID
            if SL:GetValue("SETTING_CONFIG", settingID) then
                return priority > ngSkillPriority, true
            end
        end

        if ngSkillPriority == 0 then
            return true, false
        end
        return false, false
    end

    skillID, destPosX, destPosY = SkillUtils.FindAutoSettingLaunchSkill()
    if skillID then
        return skillID, destPosX or targetDestPosX, destPosY or targetDestPosY
    end

    local _, skills, nSkill = nil, nil, 0
    if not isNeighbors then
        _, skills, nSkill = SL:GetValue("LEARNED_SKILLS", true)
    end
    local priorityT = 0
    local skillIDT = nil
    local distance = GUIFunction:CalcMapDistance(SL:GetValue("X"), SL:GetValue("Y"), SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID))
    
    local skillSNCount      = 0                    
    local skillSNPriorityT  = 0
    local skillSNSkillT     = nil

    for i = 1, nSkill do
        local v = skills and skills[i] or {}
        if v.MagicID and not settingSkills[v.MagicID] and not ignoreSkills[v.MagicID] then
            local priority = SL:GetValue("SKILL_PRIORITY", v.MagicID)
            local config = SL:GetValue("SKILL_CONFIG", v.MagicID)
            local isCheckSkillSN = false
            local isLuanch = not (config and config.skilltype == 4 or false)
            if isSkillSN and config then
                if isSample and 1 == config.skilltype then
                    if priority > 0 then
                        skillSNCount = skillSNCount + 1
                    end
                    isCheckSkillSN = true
                elseif not isSample and 2 == config.skilltype then
                    if priority > 0 then
                        skillSNCount = skillSNCount + 1
                    end
                    isCheckSkillSN = true
                end
            end

            local isMarkNGProiority = false
            isLuanch, isMarkNGProiority = isLuanch and checkAutoNGLauncher(v.MagicID, priority)
            if isMarkNGProiority then
                priority = (priorityT or 0) + priority
            end

            if isLuanch and priority > 0 and ((skillSNCount == 0 and priority > priorityT) or (skillSNCount > 0 and priority > skillSNPriorityT)) then
                skillIDT, destPosT1, destPosT2 = SkillUtils.CheckAbleToAutoLaunch(v.MagicID, targetID)
                if skillIDT then
                    if not isBlocked and SkillUtils.CheckSkillBlocked(skillIDT, srcPosX, srcPosY, targetDestPosX, targetDestPosY) then
                        isBlocked = true
                    end

                    if isCheckSkillSN then
                        skillSNSkillT = skillIDT
                        skillSNPriorityT = priority
                    end

                    if isMarkNGProiority then
                        ngSkillPriority = priority - (priorityT or 0)
                    end

                    skillID = skillIDT
                    priorityT = priority
                    destPosX = destPosT1
                    destPosY = destPosT2
                end
            end
        end
    end

    if skillSNCount > 0 then
        skillID = skillSNSkillT
    end

    if (not skillID or isBlocked) and GUIFunction:CheckSkillAbleToLaunch(SKILL_ID_PuGong) == 1 then
        local roleJob = SL:GetValue("JOB")
        if GUIFunction:IsFighter(roleJob) then
            skillID = 0
        elseif GUIFunction:IsWizzard(roleJob) then
            local _, __, n = nil, nil, 0 
            if not isBlocked then
                _, __, n = SL:GetValue("LEARNED_SKILLS", true, true, true)
            end
            if CHECK_SETTING(SLDefine.SETTINGID.SETTING_IDX_SKILL_NEXT_ATTACK) == 1 or isBlocked or n < 1 then
                skillID = 0
            end
        elseif GUIFunction:IsTaoist(roleJob) then
            local _, __, n = nil, nil, 0 
            if not isBlocked then
                _, __, n = SL:GetValue("LEARNED_SKILLS", true, true, true)
            end
            if CHECK_SETTING(SLDefine.SETTINGID.SETTING_IDX_SKILL_NEXT_ATTACK) == 1 or isBlocked or n < 1 then
                skillID = 0
            end
        else
            local skillSNCount      = 0                    
            local skillSNPriorityT  = 0
            local skillSNSkillT     = nil
            for i = 1, nSkill do
                local v = skills and skills[i] or {}
                if v.MagicID and not settingSkills[v.MagicID] and not ignoreSkills[v.MagicID] then
                    local priority = SL:GetValue("SKILL_PRIORITY", v.MagicID)
                    local config = SL:GetValue("SKILL_CONFIG", v.MagicID)
                    local isCheckSkillSN = false
                    local isLaunch = not (config and config.skilltype == 4 or false)
                    if isSkillSN and config then
                        if isSample and 1 == config.skilltype then
                            if priority > 0 then
                                skillSNCount = skillSNCount + 1
                            end
                            isCheckSkillSN = true
                        elseif not isSample and 2 == config.skilltype then
                            if priority > 0 then
                                skillSNCount = skillSNCount + 1
                            end
                            isCheckSkillSN = true
                        end
                    end
        
                    if isLaunch and priority > 0 and ((skillSNCount == 0 and priority > priorityT) or (skillSNCount > 0 and priority > skillSNPriorityT)) then
                        skillIDT, destPosT1, destPosT2 = SkillUtils.CheckAbleToAutoLaunch(v.MagicID, targetID, config and config.job == roleJob or false)
                        if skillIDT then
                            if not isBlocked and SkillUtils.CheckSkillBlocked(skillIDT, srcPosX, srcPosY, targetDestPosX, targetDestPosY) then
                                isBlocked = true
                            end
        
                            if isCheckSkillSN then
                                skillSNSkillT = skillIDT
                                skillSNPriorityT = priority
                            end
        
                            skillID = skillIDT
                            priorityT = priority 
                            destPosX = destPosT1
                            destPosY = destPosT2
                        end
                    end
                end
            end

            if skillSNCount > 0 then
                skillID = skillSNSkillT
            end

            if not skillID then
                skillID = SKILL_ID_PuGong
            end
        end
    end

    if not skillID or skillID == SKILL_ID_PuGong then
        local newSkillID, newDestPosX, newDestPosY = SkillUtils.FindAttackExLaunchSkill()
        if newSkillID then
            skillID = newSkillID
            destPosX = newDestPosX
            destPosY = newDestPosY
        end
    end

    local cursorMapPosX, cursorMapPosY = getCursorMapPos()
    return skillID, destPosX or targetDestPosX or cursorMapPosX , destPosY or targetDestPosY or cursorMapPosY
end

-- 闪避走位
local matrixAround = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
local avoidDangerAround = {
    {1, 0},     -- right
    {0, 1},     -- bottom
    {-1, 0},    -- left
    {0, -1},    -- top
    {1, -1},    -- right up    
    {1, 1},     -- right bottom
    {-1, 1},    -- left bottom
    {-1, -1}    -- left top    
}
SkillUtils.FindAvoidDangerPos = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    -- 战士不生效
    if GUIFunction:IsFighter(SL:GetValue("ACTOR_JOB_ID", mainPlayerID)) then
        return nil
    end

    -- 未开启自动走位
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_MOVE) ~= 1 then
        return nil
    end

    if not SL:GetValue("MAP_DATA_LOADED") then
        return nil
    end

    local pMapX = SL:GetValue("X")
    local pMapY = SL:GetValue("Y")
    local mMapX = 0
    local mMapY = 0
    local monsterMatrix = {}
    for i, v in ipairs(matrixAround) do
        local monsterIDs = SL:GetValue("MONSTER_BY_MAPXY", pMapX + v[1], pMapY + v[2], true)
        if monsterIDs then
            for k, monID in ipairs(monsterIDs) do
                if GUIFunction.CheckAutoTargetEnableByID(monID) then
                    mMapX = SL:GetValue("ACTOR_MAP_X", monID)
                    mMapY = SL:GetValue("ACTOR_MAP_Y", monID)
                    monsterMatrix[mMapX] = monsterMatrix[mMapX] or {}
                    monsterMatrix[mMapX][mMapY] = monID
                end
            end
        end
    end

    if not next(monsterMatrix) then
        return nil
    end

    local mapRows = SL:GetValue("MAP_ROWS")
    local mapCols = SL:GetValue("MAP_COLS")
    local avoidDangerPosX, avoidDangerPosY = nil, nil
    for _, p in ipairs(avoidDangerAround) do
        local posX = pMapX + p[1]
        local posY = pMapY + p[2]
        if posX < 0 or posX >= mapCols or posY < 0 or posY >= mapRows then
        elseif SL:GetValue("MAP_IS_OBSTACLE", posX, posY) then
        elseif monsterMatrix[posX] and monsterMatrix[posX][posY] then
        else
            avoidDangerPosX, avoidDangerPosY = posX, posY
            break
        end
    end

    return avoidDangerPosX, avoidDangerPosY
end

-- 自动连击
SkillUtils.FindAutoComboLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local isAttackState = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("ATTACK_STATE") or false
    if not isAttackState and not SL:GetValue("BATTLE_IS_AUTO_LOCK_STATE") and not SL:GetValue("BATTLE_IS_AFK") and not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return nil
    end

    if tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) ~= 1 then
        return nil
    end

    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_COMBO) ~= 1 then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    if not SL:GetValue("CAN_LAUNCH_COMBO") then
        return nil
    end

    local setComboSkill = SL:GetValue("SET_COMBO_SKILLS")
    local skillID = setComboSkill and setComboSkill[1]
    if not skillID then
        return nil
    end

    local destPosX, destPosY = nil, nil
    skillID, destPosX, destPosY = SkillUtils.CheckAbleToAutoLaunch(skillID, targetID)
    if not skillID then
        return nil
    end
    if not destPosX or not destPosY then
        destPosX, destPosY = getCursorMapPos()
    end
    return skillID, destPosX, destPosY
end

-- 连击技能
SkillUtils.FindComboLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local skillID = SL:GetValue("AUTO_COMBO_LAUNCH_SKILLID")
    local destPosX, destPosY = nil, nil
    local isAuto = false
    if not skillID then
        skillID, destPosX, destPosY = SkillUtils.FindAutoComboLaunchSkill()
        isAuto = skillID and true or false
    end

    return skillID, destPosX, destPosY, isAuto
end

-- 自定义技能
SkillUtils.FindAutoCustomLaunchSkill = function(priority)
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    local isProiority = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_ALWAYS_ATTACK) == 1 or SL:GetValue("IS_PC_OPER_MODE")
    local priorityT = priority or 0
    local skillID = nil
    local destPosX, destPosY = nil, nil
    local skillIDT = nil
    local destPosT1, destPosT2 = nil, nil
    local customSkill = SL:GetValue("ALL_CUSTOM_SKILLS")
    for k, v in pairs(customSkill) do
        skillIDT, destPosT1, destPosT2 = SkillUtils.CheckSkillLaunch(v, targetID)
        if skillIDT then
            if not isProiority then
                break
            end

            local priority = SL:GetValue("SKILL_LOCAL_PRIORITY", v)
            if not priorityT or priority > priorityT then
                priorityT = priority
                skillID, destPosX, destPosY = skillIDT, destPosT1, destPosT2
            end
        end
    end

    if skillID then
        if not destPosX or not destPosY then
            destPosX, destPosY = getCursorMapPos()
        end
        return skillID, destPosX, destPosY
    end

    return nil
end

-- 锁定释放技能
local checkSkills = {
    SKILL_ID_ZhuRi, 
    SKILL_ID_KaiTian, 
    SKILL_ID_LieHuo,
    SKILL_ID_ShuangLongZhan,
    SKILL_ID_BanYue, 
    SKILL_ID_ZHJianShu, 
    SKILL_ID_LYJianFa,
    SKILL_ID_LTJianFa,
    SKILL_ID_XPYiJi,
    SKILL_ID_CiSha,
}
SkillUtils.FindLockLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    local distance = GUIFunction:CalcMapDistance(SL:GetValue("X"), SL:GetValue("Y"), SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID))
    local isSepPos = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_MOVE_GEWEI_CISHA) == 1 or SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_GEWEICISHA) == 1

    -- 逐日 56  开天 66 烈火 26  双龙斩 40  半月 25   纵横剑术 81  龙影剑法 42 雷霆剑法 43  血魄一击(战) 115  刺杀 12  
    local priorityT = nil
    local skillID = nil
    local destPosX, destPosY = nil, nil
    local skillIDT = nil
    local destPosT1, destPosT2 = nil, nil
    for i, id in ipairs(checkSkills) do
        local priority = SL:GetValue("SKILL_LOCAL_PRIORITY", id)
        if not skillID and id == SKILL_ID_PuGong then
            priorityT = nil
        end
        if not priorityT or (priority > priorityT) or (isSepPos and id == SKILL_ID_CiSha and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_DAODAOCISHA) == 1) then
            skillIDT, destPosT1, destPosT2 = SkillUtils.CheckAbleToAutoLaunch(id, targetID)
            if skillIDT then
                if skillIDT == SKILL_ID_CiSha then -- 刺杀位
                    if 2 == distance and skillID and (skillID ~= SKILL_ID_LieHuo or SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_NEAR_LIEHUO) == 1) then
                        break
                    end
                    if 2 ~= distance and skillID and priorityT and priority < priorityT then
                        break
                    end
                end
                priorityT   = priority
                skillID     = skillIDT
                destPosX    = destPosT1
                destPosY    = destPosT2
            end
        end
    end

    -- 攻杀处理
    if 1 == distance and skillID == SKILL_ID_CiSha and SL:GetValue("SKILL_IS_LOCK_TARGET", SKILL_ID_GongSha, true) then
        local newSkillID, newDestPosX, newDestPosY = SkillUtils.CheckSkillLaunch(SKILL_ID_GongSha, targetID)
        if newSkillID then
            skillID, destPosX, destPosY = newSkillID, newDestPosX, newDestPosY 
        end
    end

    local newSkillID, newDestPosX, newDestPosY = SkillUtils.FindAutoCustomLaunchSkill(priorityT)
    if newSkillID then
        skillID, destPosX, destPosY = newSkillID, newDestPosX, newDestPosY 
    end

    if not skillID and SkillUtils.CheckSkillLaunch(SKILL_ID_GongSha) then
        skillID = SKILL_ID_GongSha
    end

    if not skillID and SkillUtils.CheckSkillLaunch(SKILL_ID_PuGong) then
        skillID = SKILL_ID_PuGong
    end

    if not skillID then
        return nil
    end
    
    if not destPosX or not destPosY then
        destPosX, destPosY = getCursorMapPos()
    end

    return skillID, destPosX, destPosY
end

SkillUtils.FindSimpleLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    -- 自动连击
    local skillID, destPosX, destPosY = SkillUtils.FindAutoComboLaunchSkill()
    if skillID then
        return skillID, destPosX, destPosY
    end

    -- 自动释放技能
    skillID, destPosX, destPosY = SkillUtils.FindRobotLaunchSkill()
    if skillID then
        return skillID, destPosX, destPosY
    end

    skillID = SL:GetValue("AUTO_LOCK_SKILLID")
    if not skillID then
        return nil
    end

    -- 普攻
    skillID, destPosX, destPosY = SkillUtils.FindAutoSettingLaunchSkill()

    if not skillID then
        skillID, destPosX, destPosY = SkillUtils.FindAutoCustomLaunchSkill()
    end

    if skillID then
        return skillID, destPosX, destPosY
    end

    skillID, destPosX, destPosY = SkillUtils.FindAttackExLaunchSkill()
    if skillID then
        return skillID, destPosX, destPosY
    end

    skillID = SL:GetValue("AUTO_LOCK_SKILLID")

    if skillID == SKILL_ID_PuGong and SkillUtils.CheckSkillLaunch(SKILL_ID_GongSha) then
        return SKILL_ID_GongSha, getCursorMapPos()
    end

    if skillID and SkillUtils.CheckSkillLaunch(skillID) then
        return skillID, getCursorMapPos()
    end

    local isPugong = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SKILL_NEXT_ATTACK) == 1
    if isPugong and SkillUtils.CheckSkillLaunch(SKILL_ID_PuGong) then
        return SKILL_ID_PuGong, getCursorMapPos()
    end
    return nil
end

SkillUtils.FindAttackExLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    
    -- 半月
    local skillID, destPosX, destPosY = SkillUtils.CheckAbleToAutoLaunch(SKILL_ID_BanYue, targetID)
    if not skillID then
        skillID, destPosX, destPosY = SkillUtils.CheckAbleToAutoLaunch(SKILL_ID_ShuangLongZhan, targetID)
    end

    if not skillID then
        skillID, destPosX, destPosY = SkillUtils.CheckAbleToAutoLaunch(SKILL_ID_CiSha)

        local distance = nil
        if SL:GetValue("ACTOR_IS_VALID", targetID) then
            distance = GUIFunction:CalcMapDistance(SL:GetValue("X"), SL:GetValue("Y"), SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID))
        end
        -- 攻杀处理
        if 1 == distance and skillID == SKILL_ID_CiSha and SL:GetValue("SKILL_IS_LOCK_TARGET", SKILL_ID_GongSha, true) then
            local newSkillID, newDestPosX, newDestPosY = SkillUtils.CheckSkillLaunch(SKILL_ID_GongSha, targetID)
            if newSkillID then
                skillID, destPosX, destPosY = newSkillID, newDestPosX, newDestPosY
            end
        end
    end

    if not skillID then
        return nil
    end

    if not destPosX or not destPosY then
        destPosX, destPosY = getCursorMapPos()
    end
    return skillID, destPosX, destPosY
end

SkillUtils.FindAttackLaunchSkill = function()
    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID or not SL:GetValue("MAIN_PLAYER_IS_VALID") or SL:GetValue("ACTOR_IS_DIE", mainPlayerID) or SL:GetValue("ACTOR_IS_DEATH", mainPlayerID) then
        return nil
    end

    -- 刺杀
    local skillID, destPosX, destPosY = SkillUtils.CheckSkillLaunch(SKILL_ID_CiSha)
    if not skillID then
        -- 普攻
        skillID, destPosX, destPosY = SkillUtils.CheckSkillLaunch(SKILL_ID_PuGong)
    end

    if not skillID then
        return nil
    end

    if not destPosX or not destPosY then
        destPosX, destPosY = getCursorMapPos()
    end
    return skillID, destPosX, destPosY
end

-- 技能优先级检测
SkillUtils.FindSkills = function(skilltype, filterJob, filterLearned, noBasic)
    local roleJob = SL:GetValue("JOB")
    local skills, nSkills = SL:GetValue("SKILL_CONFIGS_BY_JOB", filterJob)
    local items = {}
    for i = 1, nSkills do
        local skill = skills[i]
        if skill and (skill.MagicID ~= 0 or not noBasic) and (skilltype == -1 or skill.skilltype == skilltype) and (filterJob == 3 or roleJob == filterJob) then
            if (not filterLearned or (SL:GetValue("SKILL_IS_LEARNED", skill.MagicID) and not SL:GetValue("SKILL_IS_COMBO_SKILL", skill.MagicID))) then
                items[skill.MagicID] = skill
            end
        end
    end
    return items
end

return SkillUtils
