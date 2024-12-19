TradingBankLookPlayerData = TradingBankLookPlayerData or {}

function TradingBankLookPlayerData.Init()
    TradingBankLookPlayerData._lookPlayerData = {}
    TradingBankLookPlayerData._lookPlayerEquips = {}
    TradingBankLookPlayerData._lookPlayerEquipsMakeIndex = {}
    TradingBankLookPlayerData._titleData = {} --称号数据
    TradingBankLookPlayerData._titleActive = nil --激活的称号
    TradingBankLookPlayerData._bagItems = {}
    TradingBankLookPlayerData._storeItems = {}
    TradingBankLookPlayerData._skills = {}
    TradingBankLookPlayerData._curAtr = {}
    TradingBankLookPlayerData._maxAtr = {}

    TradingBankLookPlayerData._lookHeroData = {}
    TradingBankLookPlayerData._lookHeroEquips = {}
    TradingBankLookPlayerData._lookHeroEquipssMakeIndex = {}
    TradingBankLookPlayerData._heroTitleData = {} --称号数据
    TradingBankLookPlayerData._heroTitleActive = nil --激活的称号
    TradingBankLookPlayerData._heroBagItems = {}
    TradingBankLookPlayerData._heroSkills = {}
    TradingBankLookPlayerData._heroCurAtr = {}
    TradingBankLookPlayerData._heroMaxAtr = {}
    TradingBankLookPlayerData._hasHeroData = false
end

function TradingBankLookPlayerData.handle_MSG_SC_ROLE_INFO_RESPONSE(data)
    if not data then
        return SL:ShowSystemTips("玩家不在线")
    end

    TradingBankLookPlayerData.Init()

    TradingBankLookPlayerData._titleActive = data.active
    TradingBankLookPlayerData._storeItems = data.storeItems
    TradingBankLookPlayerData._bagItems = data.bagItems
    TradingBankLookPlayerData._curAtr = data.arrCurAbil
    TradingBankLookPlayerData._maxAtr = data.arrMaxAbil
    TradingBankLookPlayerData.SetPlayerTitle(data.Titles)
    TradingBankLookPlayerData.SetSkills(data.Magic)
    TradingBankLookPlayerData.SetPlayerData(data)
    TradingBankLookPlayerData.SetPlayerEquipsData(data.equips)

    if data.HeroData then 
        TradingBankLookPlayerData._hasHeroData = true
        TradingBankLookPlayerData._heroTitleActive = data.HeroData.active
        TradingBankLookPlayerData._heroBagItems = data.HeroData.bagItems
        TradingBankLookPlayerData._heroCurAtr = data.HeroData.arrCurAbil
        TradingBankLookPlayerData._heroMaxAtr = data.HeroData.arrMaxAbil
        TradingBankLookPlayerData.SetHeroTitle(data.HeroData.Titles)
        TradingBankLookPlayerData.SetHeroSkills(data.HeroData.Magic)
        TradingBankLookPlayerData.SetHeroData(data.HeroData)
        TradingBankLookPlayerData.SetHeroEquipsData(data.HeroData.equips)
    end
end

function TradingBankLookPlayerData.GetBagData()
    return TradingBankLookPlayerData._bagItems
end

function TradingBankLookPlayerData.GetHeroBagData()
    return TradingBankLookPlayerData._heroBagItems
end

function TradingBankLookPlayerData.GetStoreData()
    return TradingBankLookPlayerData._storeItems
end

function TradingBankLookPlayerData.GetHasHeroData()
    return TradingBankLookPlayerData._hasHeroData
end

function TradingBankLookPlayerData.GetActiveTitle()
    return TradingBankLookPlayerData._titleActive ~= -1 and TradingBankLookPlayerData._titleActive or nil
end

function TradingBankLookPlayerData.GetHeroActiveTitle()
    return TradingBankLookPlayerData._heroTitleActive ~= -1 and TradingBankLookPlayerData._heroTitleActive or nil
end

function TradingBankLookPlayerData.GetEquipPosData()
    return TradingBankLookPlayerData._lookPlayerEquips
end

function TradingBankLookPlayerData.GetHeroEquipPosData()
    return TradingBankLookPlayerData._lookHeroEquips
end

function TradingBankLookPlayerData.SetPlayerData(data)
    TradingBankLookPlayerData._lookPlayerData.Job               = data.Job
    TradingBankLookPlayerData._lookPlayerData.Name              = data.Name
    TradingBankLookPlayerData._lookPlayerData.Sex               = data.Sex
    TradingBankLookPlayerData._lookPlayerData.Hair              = data.hair
    TradingBankLookPlayerData._lookPlayerData.Color             = data.nameColor
    TradingBankLookPlayerData._lookPlayerData.GuildName         = data.guildName or ""
    TradingBankLookPlayerData._lookPlayerData.RankName          = data.rankName or ""
    TradingBankLookPlayerData._lookPlayerData.SndaItemBoxOpened = data.SndaItemBoxOpened
end

function TradingBankLookPlayerData.SetHeroData(data)
    TradingBankLookPlayerData._lookHeroData.Job               = data.Job
    TradingBankLookPlayerData._lookHeroData.Name              = data.Name
    TradingBankLookPlayerData._lookHeroData.Sex               = data.Sex
    TradingBankLookPlayerData._lookHeroData.Hair              = data.hair
    TradingBankLookPlayerData._lookHeroData.Color             = data.nameColor
    TradingBankLookPlayerData._lookHeroData.SndaItemBoxOpened = data.SndaItemBoxOpened
end

function TradingBankLookPlayerData.GetCurAbilByID(id)
    return TradingBankLookPlayerData._curAtr[id]
end

function TradingBankLookPlayerData.GetMaxAbilByID(id)
    return TradingBankLookPlayerData._maxAtr[id]
end

function TradingBankLookPlayerData.GetHeroCurAbilByID(id)
    return TradingBankLookPlayerData._heroCurAtr[id]
end

function TradingBankLookPlayerData.GetHeroMaxAbilByID(id)
    return TradingBankLookPlayerData._heroMaxAtr[id]
end

function TradingBankLookPlayerData.SetPlayerEquipsData(items)
    for _, itemData in pairs(items or {}) do
        TradingBankLookPlayerData._lookPlayerEquips[itemData.Where] = itemData.MakeIndex
        TradingBankLookPlayerData._lookPlayerEquipsMakeIndex[itemData.MakeIndex] = itemData
    end
end

function TradingBankLookPlayerData.GetPlayerEquipsData()
    return TradingBankLookPlayerData._lookPlayerEquipsMakeIndex or {}
end

-- 通过pos获取装备
function TradingBankLookPlayerData.FindEquipDataByPos(pos)
    local makeIndex = TradingBankLookPlayerData._lookPlayerEquips and TradingBankLookPlayerData._lookPlayerEquips[pos]
    if makeIndex then
        return TradingBankLookPlayerData.GetEquipDataByMakeIndex(makeIndex)
    else
        return nil
    end
end

function TradingBankLookPlayerData.GetEquipDataByMakeIndex(makeIndex)
    return TradingBankLookPlayerData._lookPlayerEquipsMakeIndex[makeIndex]
end

function TradingBankLookPlayerData.SetHeroEquipsData(items)
    for _, itemData in pairs(items or {}) do
        TradingBankLookPlayerData._lookHeroEquips[itemData.Where] = itemData.MakeIndex
        TradingBankLookPlayerData._lookHeroEquipssMakeIndex[itemData.MakeIndex] = itemData
    end
end

function TradingBankLookPlayerData.GetHeroEquipsData()
    return TradingBankLookPlayerData._lookHeroEquipssMakeIndex or {}
end

-- 通过pos获取装备
function TradingBankLookPlayerData.FindHeroEquipDataByPos(pos)
    local makeIndex = TradingBankLookPlayerData._lookHeroEquips and TradingBankLookPlayerData._lookHeroEquips[pos]
    if makeIndex then
        return TradingBankLookPlayerData.GetHeroEquipDataByMakeIndex(makeIndex)
    else
        return nil
    end
end

function TradingBankLookPlayerData.GetHeroEquipDataByMakeIndex(makeIndex)
    return TradingBankLookPlayerData._lookHeroEquipssMakeIndex[makeIndex]
end

function TradingBankLookPlayerData.SetSkills(skills)
    if not skills then
        return false
    end
    for i, v in ipairs(skills) do
        if TradingBankLookPlayerData._skills[v.MagicID] then
            return false
        end
        TradingBankLookPlayerData._skills[v.MagicID] = v
    end
end

function TradingBankLookPlayerData.GetSkills()
    return TradingBankLookPlayerData._skills
end

function TradingBankLookPlayerData.GetSkillByID(id)
    return TradingBankLookPlayerData._skills[id]
end

function TradingBankLookPlayerData.GetSkillTrainData(skillID)
    -- 技能等级>3的全部特殊处理下
    local maxStr = "-"
    if not skillID or not TradingBankLookPlayerData._skills[skillID] then
        return maxStr
    end
    if skillID == SKILL_ID_PuGong then
        return maxStr
    end
    local skillData = TradingBankLookPlayerData._skills[skillID]

    return TradingBankLookPlayerData.GetSkillTrain(skillData)
end

function TradingBankLookPlayerData.GetSkillTrain(skillData)
    -- 技能等级>3的全部特殊处理下
    local maxStr = "-"
    local isBaseSkill   = skillData.Level <= 3
    local skillLevel    = skillData.Level
    local maxSkillLevel = skillData.TrainLv
    if isBaseSkill and skillLevel >= maxSkillLevel then
        return maxStr
    end
    local skillMaxTrain = {
        [0] = skillData.MaxTrain1,
        [1] = skillData.MaxTrain2,
        [2] = skillData.MaxTrain3,
        [3] = skillData.MaxTrain4
    }
    local curTrain = skillData.CurTrain or 0
    local maxTrain = (isBaseSkill and skillMaxTrain[skillLevel] or skillData.MaxTrain1) or 0
    local str = curTrain >= maxTrain and maxStr or string.format("%s/%s", curTrain, maxTrain)
    return str
end

function TradingBankLookPlayerData.SetHeroSkills(skills)
    if not skills then
        return false
    end
    for i, v in ipairs(skills) do
        if TradingBankLookPlayerData._heroSkills[v.MagicID] then
            return false
        end
        TradingBankLookPlayerData._heroSkills[v.MagicID] = v
    end
end

function TradingBankLookPlayerData.GetHeroSkills()
    return TradingBankLookPlayerData._heroSkills
end

function TradingBankLookPlayerData.GetHeroSkillByID(id)
    return TradingBankLookPlayerData._heroSkills[id]
end

function TradingBankLookPlayerData.GetHeroSkillTrainData(skillID)
    -- 技能等级>3的全部特殊处理下
    local maxStr = "-"
    if not skillID or not TradingBankLookPlayerData._heroSkills[skillID] then
        return maxStr
    end
    if skillID == SKILL_ID_PuGong then
        return maxStr
    end
    local skillData = TradingBankLookPlayerData._heroSkills[skillID]

    return TradingBankLookPlayerData.GetSkillTrain(skillData)
end

function TradingBankLookPlayerData.SetPlayerTitle(data)
    if data and next(data) then
        for i, v in pairs(data) do
            local id = v[1]
            local time = v[2]
            local data = { id = id, time = time, index = i }
            TradingBankLookPlayerData._titleData[i] = data
        end
    end
end

function TradingBankLookPlayerData.GetTitle()
    return TradingBankLookPlayerData._titleData
end

function TradingBankLookPlayerData.SetHeroTitle(data)
    if data and next(data) then
        for i, v in pairs(data) do
            local id = v[1]
            local time = v[2]
            local data = { id = id, time = time, index = i }
            TradingBankLookPlayerData._heroTitleData[i] = data
        end
    end
end

function TradingBankLookPlayerData.GetHeroTitle()
    return TradingBankLookPlayerData._heroTitleData
end

function TradingBankLookPlayerData.GetPlayerData()
    return TradingBankLookPlayerData._lookPlayerData
end

function TradingBankLookPlayerData.GetHerorData()
    return TradingBankLookPlayerData._lookHeroData
end

function TradingBankLookPlayerData.GetPlayerJob()
    return TradingBankLookPlayerData._lookPlayerData.Job
end

function TradingBankLookPlayerData.GetHeroJob()
    return TradingBankLookPlayerData._lookHeroData.Job
end

function TradingBankLookPlayerData.GetPlayerName()
    return TradingBankLookPlayerData._lookPlayerData.Name
end

function TradingBankLookPlayerData.GetHeroName()
    return TradingBankLookPlayerData._lookHeroData.Name
end

function TradingBankLookPlayerData.GetPlayerSex()
    return TradingBankLookPlayerData._lookPlayerData.Sex
end

function TradingBankLookPlayerData.GetHeroSex()
    return TradingBankLookPlayerData._lookHeroData.Sex
end

function TradingBankLookPlayerData.GetPlayerHair()
    return TradingBankLookPlayerData._lookPlayerData.Hair
end

function TradingBankLookPlayerData.GetHeroHair()
    return TradingBankLookPlayerData._lookHeroData.Hair
end

function TradingBankLookPlayerData.GetPlayerNameColor()
    return TradingBankLookPlayerData._lookPlayerData.Color
end

function TradingBankLookPlayerData.GetHeroNameColor()
    return TradingBankLookPlayerData._lookHeroData.Color
end

function TradingBankLookPlayerData.GetPlayerGuildName()
    return TradingBankLookPlayerData._lookPlayerData.GuildName or ""
end

function TradingBankLookPlayerData.GetPlayerGuildRankName()
    return TradingBankLookPlayerData._lookPlayerData.RankName or ""
end

function TradingBankLookPlayerData.GetBestRingsOpenState()
    return TradingBankLookPlayerData._lookPlayerData.SndaItemBoxOpened
end

function TradingBankLookPlayerData.GetHeroBestRingsOpenState()
    return TradingBankLookPlayerData._lookHeroData.SndaItemBoxOpened
end
return TradingBankLookPlayerData