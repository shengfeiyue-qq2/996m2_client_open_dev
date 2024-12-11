local SkillLaunch = {}

local SharedInputMoveTab = {}

local mMax = math.max
local mAbs = math.abs
local function squLen(x, y)
    local maxv = mMax(mAbs(x), mAbs(y))
    return maxv * maxv
end

function SkillLaunch.FindTargetByWorldPos(worldPosX, worldPosY, launchID, findAll)
    -- find pickable
    local targetID = nil

    if not targetID then
        targetID = SL:GetValue("PICK_ACTORID_BY_POS", worldPosX, worldPosY)
    end

    -- can't find target
    if not targetID or not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return nil
    end

    -- error type
    if not findAll and not GUIFunction:CheckLaunchEnableByID(targetID) then
        if launchID == SKILL_ID_XLQISHI and SL:GetValue("ACTOR_IS_BORN", targetID) then
        else
            return nil
        end
    end

    return targetID
end

function SkillLaunch.FindTargetByMapPos(mapPosX, mapPosY, launchID, findAll)
    local worldX, worldY = SL:ConvertMapPos2WorldPos(mapPosX, mapPosY, true)
    return SkillLaunch.FindTargetByWorldPos(worldX, worldY, launchID, findAll)
end

function SkillLaunch.FindDestTarget(skillID)
    local x, y = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    if SL:GetValue("SKILL_IS_ADDITION_SKILL", skillID) then
        if x and y then
            local targetID = SkillLaunch.FindTargetByMapPos(x, y, skillID, true)
            return targetID, x, y
        else
            return SL:GetValue("USER_ID"), SL:GetValue("X"), SL:GetValue("Y")
        end
    elseif SL:GetValue("SKILL_IS_INPUT_POS_SKILL", skillID) then
        if x and y then
            local isAutoFight = SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE")
            local targetID = isAutoFight and SL:GetValue("INPUT_LAUNCH_TARGET_ID") or SkillLaunch.FindTargetByMapPos(x, y, skillID)
            if isAutoFight and targetID then
                x, y = nil, nil
                if SL:GetValue("ACTOR_IS_VALID", targetID) then
                    x, y = SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)
                end
            end
            return targetID, x, y
        else
            return nil
        end
    end
end

-------------------------------------------------------------------------------------
-- step 3:
-- 技能释放前launchMode判定targetID targetPos dir
-------------------- 手机端 begin -----------------
function SkillLaunch.CheckParam1(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- check target
    local targetID = SkillUtils.CheckTarget(param.skillID)

    -- if target, find best pos & dir
    if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)
        param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
        param.targetID  = targetID
    else
        -- default
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
        param.dir       = SL:GetValue("DIR")
    end

    return true
end

function SkillLaunch.CheckParam2(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- src & dir, only
    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
    param.dir = SL:GetValue("DIR")

    return true
end

function SkillLaunch.CheckParam3(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- check target
    local targetID = SkillUtils.CheckTarget()

    -- if target, find best pos & dir
    if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)
        param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
        param.targetID  = targetID
    else
        -- default
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
        param.dir       = SL:GetValue("DIR")
    end

    return true
end

function SkillLaunch.CheckParam4(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- 1.check target pos
    local targetID, x, y = SkillLaunch.FindDestTarget(param.skillID)
    if not x or not y then
        return false
    end

    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = x, y
    param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
    param.targetID  = targetID

    return true
end

function SkillLaunch.CheckParam5(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- 强攻
    local launchType = SL:GetValue("INPUT_LAUNCH_TYPE")
    if launchType == GUIDefine.LaunchType.ATTACK then
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
        param.dir    = SL:GetValue("DIR")
        return true
    end

    ---------------------------------------------------------
    -- can't find target
    if nil == SL:GetValue("SELECT_TARGET_ID") then
        SL:SetValue("BATTLE_IS_AUTO_LOCK_STATE", false)
        SL:SetValue("AUTO_LOCK_SKILLID", nil)

        return false
    end

    -- 目标无法攻击
    if false == GUIFunction:CheckLaunchEnableByID(SL:GetValue("SELECT_TARGET_ID")) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        SL:SetValue("BATTLE_IS_AUTO_LOCK_STATE", false)
        SL:SetValue("AUTO_LOCK_SKILLID", nil)

        return false
    end
    ---------------------------------------------------------

    -- find target
    local targetID = SkillUtils.CheckTarget()
    if not targetID then
        return false
    end

    -- find best pos & dir
    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)
    param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
    param.targetID  = targetID

    return true
end
-------------------- 手机端 end -------------------

-------------------- PC端 begin -------------------
function SkillLaunch.CheckParam1_pc(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
    param.dir = SL:GetValue("DIR")

    return true
end

function SkillLaunch.CheckParam2_pc(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- src & dir, only
    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
    param.dir = SL:GetValue("DIR")

    return true
end

function SkillLaunch.CheckParam3_pc(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    param.targetID = SL:GetValue("INPUT_LAUNCH_TARGET_ID")

    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    param.dir = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)

    -- 增益型技能, 在自动释放或锁定释放时
    local launchType = SL:GetValue("INPUT_LAUNCH_TYPE")
    if SL:GetValue("SKILL_IS_ADDITION_SKILL", param.skillID) and (launchType == GUIDefine.LaunchType.AUTO or launchType == GUIDefine.LaunchType.LOCK) then
        param.vecDstX = SL:GetValue("X")
        param.vecDstY = SL:GetValue("Y")
        param.targetID = SL:GetValue("USER_ID")
        param.dir = SL:GetValue("DIR")
    end

    -- 选择目标点下目标
    local x, y = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    if not param.targetID and x and y then
        param.targetID = SkillLaunch.FindTargetByMapPos(x, y, param.skillID, true)
    end

    return true
end

function SkillLaunch.CheckParam4_pc(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    -- 强攻
    local launchType = SL:GetValue("INPUT_LAUNCH_TYPE")
    if launchType == GUIDefine.LaunchType.ATTACK then
        param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
        param.vecDstX, param.vecDstY = SL:GetValue("X"), SL:GetValue("Y")
        param.dir   = SL:GetValue("MOUSE_WORLD_DIR")
        return true
    end

    param.targetID = SL:GetValue("INPUT_LAUNCH_TARGET_ID")

    -- 默认传入方向和传入坐标
    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)

    -- 选择目标点下目标
    local x, y = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    if not param.targetID and x and y then
        param.targetID = SkillLaunch.FindTargetByMapPos(x, y, param.skillID, true)
    end

    -- 锁定攻击目标
    local attackTargetID = SL:GetValue("SELECT_SHIFT_ATTACK_ID")
    if attackTargetID and SL:GetValue("ACTOR_IS_VALID", attackTargetID) then
        param.targetID  = attackTargetID
        param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", attackTargetID), SL:GetValue("ACTOR_MAP_Y", attackTargetID)
        param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
    end

    local isAttack = false
    local targetID = param.targetID
    if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
        param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)
        param.dir   = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
        isAttack    = not SL:GetValue("ACTOR_IS_DEATH", targetID) and not SL:GetValue("ACTOR_IS_DIE", targetID) and true or false
    end

    if param.skillID == 0 and not isAttack then
        return false
    end

    return true
end

function SkillLaunch.CheckParam5_pc(param)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    param.targetID = SL:GetValue("INPUT_LAUNCH_TARGET_ID")

    -- 默认传入方向和传入坐标
    param.vecSrcX, param.vecSrcY = SL:GetValue("X"), SL:GetValue("Y")
    param.vecDstX, param.vecDstY = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    param.dir    = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)

    -- 选择目标点下目标
    local x, y = SL:GetValue("INPUT_LAUNCH_TARGET_POS")
    if not param.targetID and x and y then
        param.targetID = SkillLaunch.FindTargetByMapPos(x, y, param.skillID, true)
    end

    -- 判断目标是否是掉落物
    if param.targetID and SL:GetValue("ACTOR_IS_VALID", param.targetID) then
        if SL:GetValue("ACTOR_IS_DROPITEM", param.targetID) or not GUIFunction:CheckLaunchEnableByID(param.targetID) then
            param.targetID = nil
        end
    end

    -- 魔法锁定
    if not param.targetID then
        local magicTargetID = SL:GetValue("SELECT_TARGET_ID")
        if magicTargetID and GUIFunction:CheckLaunchEnableByID(magicTargetID) then
            param.targetID = magicTargetID
            param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", magicTargetID), SL:GetValue("ACTOR_MAP_Y", magicTargetID)
            param.dir   = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
        end
    end

    if param.targetID and SL:GetValue("ACTOR_IS_VALID", param.targetID) then
        param.vecDstX, param.vecDstY = SL:GetValue("ACTOR_MAP_X", param.targetID), SL:GetValue("ACTOR_MAP_Y", param.targetID)
        param.dir       = SkillUtils.CalcLaunchDirection(param.vecDstX, param.vecDstY, param.vecSrcX, param.vecSrcY)
    end

    -- 技能魔法锁定
    local skillID = param.skillID
    local targetID = param.targetID
    if SL:GetValue("SKILL_IS_MAGIC_LOCK", skillID) and targetID and GUIFunction:CheckLaunchEnableByID(targetID) 
    and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_MAGIC_LOCK) == 1 then
        SL:SetValue("SELECT_TARGET_ID", targetID)
    end

    return true
end
-------------------- PC端 end ---------------------
-- 模式检测
SkillLaunch.CheckParamFunc = SL:GetValue("IS_PC_OPER_MODE") and {
    [1] = SkillLaunch.CheckParam1_pc,
    [2] = SkillLaunch.CheckParam2_pc,
    [3] = SkillLaunch.CheckParam3_pc,
    [4] = SkillLaunch.CheckParam4_pc,
    [5] = SkillLaunch.CheckParam5_pc,
} or {
    [1] = SkillLaunch.CheckParam1,
    [2] = SkillLaunch.CheckParam2,
    [3] = SkillLaunch.CheckParam3,
    [4] = SkillLaunch.CheckParam4,
    [5] = SkillLaunch.CheckParam5,
}

SkillLaunch.CheckParamByLaunchMode = function(launchMode, param)
    if not launchMode then
        return false
    end

    if not SkillLaunch.CheckParamFunc[launchMode] then
        return false
    end

    return SkillLaunch.CheckParamFunc[launchMode](param)
end

-------------------------------------------------------------------------------------
-- step 4:
-- 技能释放前检查攻击范围
function SkillLaunch.CheckAttackRange(skillID, param)
    local skillConfig = SL:GetValue("SKILL_CONFIG", skillID)
    local moveBestPos = skillConfig.bestPos ~= 0
    if nil == param.targetID and param.vecSrcX == param.vecDstX and param.vecSrcY == param.vecDstY then
        moveBestPos = false
    end
    if moveBestPos then
        local srcX        = param.vecSrcX
        local srcY        = param.vecSrcY
        local dstX        = param.vecDstX
        local dstY        = param.vecDstY
        local targetID    = param.targetID

        -- move best pos to launch
        local launchX, launchY, moveX, moveY = SkillUtils.FindBestLaunchPos(skillID, targetID, srcX, srcY, dstX, dstY)
        if srcX ~= launchX or srcY ~= launchY then
            if srcX == moveX and srcY == moveY then
                moveX = launchX
                moveY = launchY
            end
            SharedInputMoveTab.skillID  = skillID
            SharedInputMoveTab.targetID = targetID
            SharedInputMoveTab.x        = moveX
            SharedInputMoveTab.y        = moveY
            SL:InputMove(SharedInputMoveTab)
            SL:ResetInputLaunchDirty()

            -- check path points
            local pathPoints = SL:GetValue("MAP_CURRENT_PATH_INDEX")
            if pathPoints == 0 then
                -- ignore target
                if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
                    if not SL:GetValue("ACTOR_IS_PAUSE_IGNORED", targetID) and not SL:GetValue("ACTOR_IS_IGNORED", targetID) then
                        if SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE")
                        and SL:GetValue("IS_ACTOR_LIMIT_OBSTACLE", SL:GetValue("X"), SL:GetValue("Y"), SL:GetValue("ACTOR_MAP_X", targetID), SL:GetValue("ACTOR_MAP_Y", targetID)) then
                            SL:SetValue("ACTOR_IS_PAUSE_IGNORED", true)
                        else
                            SL:SetValue("ACTOR_IS_IGNORED", false)
                        end
                    end
                end

                -- clear launch data
                if not SL:GetValue("ACTOR_IS_VALID", targetID) or (not SL:GetValue("ACTOR_IS_PAUSE_IGNORED", targetID) and SL:GetValue("ACTOR_IS_IGNORED", targetID)) then
                    SL:SetValue("BATTLE_IS_AUTO_LOCK_STATE", false)
                    SL:SetValue("AUTO_LOCK_SKILLID", nil)

                    SL:ClearInputLaunch()

                    SL:SetValue("SELECT_TARGET_ID", nil)
                end
            end

            return false
        end
    elseif SL:GetValue("SKILL_IS_FORCE_DISTANCE", skillID) then
        local srcX          = param.vecSrcX
        local srcY          = param.vecSrcY
        local dstX          = param.vecDstX
        local dstY          = param.vecDstY
        local minLaunchDis  = tonumber(GUIFunction:GetSkillMinLaunchDistance(skillID))
        local maxLaunchDis  = tonumber(GUIFunction:GetSkillMaxLaunchDistance(skillID))
        if minLaunchDis and maxLaunchDis then
            local len       = squLen(srcX - dstX, srcY - dstY)
            local minRange  = minLaunchDis * minLaunchDis
            local maxRange  = maxLaunchDis * maxLaunchDis
            if len < minRange or len > maxRange then
                SL:ResetInputLaunchDirty()
                return false
            end
        end
    end

    local targetID = param.targetID
    if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
        if SL:GetValue("ACTOR_IS_PAUSE_IGNORED", targetID) then
            SL:SetValue("ACTOR_IS_PAUSE_IGNORED", false)
        end
    end

    return true
end

return SkillLaunch