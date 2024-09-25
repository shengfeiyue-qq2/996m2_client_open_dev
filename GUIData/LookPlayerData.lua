LookPlayerData = LookPlayerData or {}

function LookPlayerData.Init()
    LookPlayerData._playerData = {}
    LookPlayerData._equipPosDatas = {}
    LookPlayerData._equipMakeIndexDatas = {}

    -- 称号数据
    LookPlayerData._titleData = {}
    -- 激活的称号
    LookPlayerData._titleActive = nil
end

-- 获取数据时进行清理, 因为在请求时进行清理会出现脚本发送了请求而导致数据没有进行清理的问题
function LookPlayerData.Clear()
    LookPlayerData._playerData = {}
    LookPlayerData._equipPosDatas = {}
    LookPlayerData._equipMakeIndexDatas = {}
end

function LookPlayerData.handle_MSG_SC_ROLE_INFO_RESPONSE(data)
    if not data then
        return SL:ShowSystemTips("玩家不在线")
    end

    LookPlayerData.Clear()

    -- 法阵
    LookPlayerData.SetEmbattle(data.embattle)
    
    -- 激活的称号
    LookPlayerData.SetActiveTitle(data.activeTittle)

    -- 装备数据
    LookPlayerData.SetPlayerData(data)

    LookPlayerData.SetTitle(data.titles)

    LookPlayerData.SetPlayerItemData(data.items)

    LookPlayerData.SetPlayerUID(data.userID)

    -- 禁止查看玩家
    if SL:GetValue("GAME_DATA","ForbidShowLookLayer") then
        return false
    end

    -- 打开界面
    GUI:SetLayerOpenParam({page = data.pageID})
    GUI:Win_Open(data.isHero and UIConst.LUAFile.LUA_FILE_HERO_LOOK_FRAME or UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_FRAME)
end

function LookPlayerData.SetTitle(data)
    LookPlayerData._titleData = data
end

function LookPlayerData.GetTitle()
    return LookPlayerData._titleData
end

function LookPlayerData.SetActiveTitle(titleID)
    LookPlayerData._titleActive = titleID
end

function LookPlayerData.GetActiveTitle()
    return LookPlayerData._titleActive ~= -1 and LookPlayerData._titleActive or nil
end

function LookPlayerData.FindEquipDataByPos(pos)
    local makeIndex = LookPlayerData._equipPosDatas and LookPlayerData._equipPosDatas[pos]
    if makeIndex then
        return LookPlayerData.GetEquipDataByMakeIndex(makeIndex)
    else
        return nil
    end
end

function LookPlayerData.GetEquipDataByMakeIndex(makeIndex)
    return LookPlayerData._equipMakeIndexDatas[makeIndex]
end

function LookPlayerData.GetEquipPosData()
    return LookPlayerData._equipPosDatas
end

function LookPlayerData.SetPlayerData(data)
    LookPlayerData._playerData.Job               = data.job
    LookPlayerData._playerData.Name              = data.userName
    LookPlayerData._playerData.Sex               = data.sex
    LookPlayerData._playerData.Hair              = data.hair
    LookPlayerData._playerData.Color             = data.nameColor
    LookPlayerData._playerData.GuildName         = data.guildName or ""
    LookPlayerData._playerData.RankName          = data.rankName or ""
    LookPlayerData._playerData.Level             = data.level or 0
    LookPlayerData._playerData.SndaItemBoxOpened = data.SndaItemBoxOpened
end

function LookPlayerData.SetPlayerItemData(items)
    for _, itemData in pairs(items or {}) do
        LookPlayerData._equipPosDatas[itemData.Where] = itemData.MakeIndex
        LookPlayerData._equipMakeIndexDatas[itemData.MakeIndex] = itemData
    end
end

function LookPlayerData.GetPlayerData()
    return LookPlayerData._playerData
end

function LookPlayerData.SetPlayerUID(uid)
    LookPlayerData._uID = uid or LookPlayerData._uID
end

function LookPlayerData.GetPlayerUID()
    return LookPlayerData._uID
end

function LookPlayerData.GetPlayerLevel()
    return LookPlayerData._playerData.Level or 0
end
-- 当前查看玩家职业
function LookPlayerData.GetLookPlayerJob()
    return LookPlayerData._playerData.Job
end

function LookPlayerData.GetPlayerName()
    return LookPlayerData._playerData.Name
end

function LookPlayerData.GetPlayerSex()
    return LookPlayerData._playerData.Sex
end

function LookPlayerData.GetPlayerHair()
    return LookPlayerData._playerData.Hair
end

function LookPlayerData.GetPlayerNameColor()
    return LookPlayerData._playerData.Color
end

function LookPlayerData.GetPlayerGuildName()
    return LookPlayerData._playerData.GuildName or ""
end

function LookPlayerData.GetPlayerGuildRankName()
    return LookPlayerData._playerData.RankName or ""
end

function LookPlayerData.SetEmbattle(embattle)
    LookPlayerData._embattle = embattle
end

function LookPlayerData.GetEmbattle()
    return LookPlayerData._embattle
end

function LookPlayerData.GetBestRingsOpenState()
    return LookPlayerData._playerData.SndaItemBoxOpened
end

return LookPlayerData