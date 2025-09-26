FuncDockData = FuncDockData or {}

-- 功能菜单类型
FuncDockData.FuncDockType = {
    Func_Player_Head        = 1,    -- 点击玩家头像
    Func_Friend             = 2,    -- 好友界面
    Func_Assist_Team        = 3,    -- 左侧组队导航栏
    Func_Guild              = 4,    -- 行会界面
    Func_Friend_Recent      = 5,    -- 好友最近联系界面
    Func_Friend_Enemy       = 6,    -- 好友仇敌界面
    Func_Friend_BlackList   = 7,    -- 好友黑名单界面
    Func_Team               = 8,    -- 组队界面
    Func_Monster_Head       = 9,    -- 点击人形怪头像
    Func_Near_Player        = 10,   -- 附近玩家
}

-- 按钮操作类型
FuncDockData.BtnOperatorType = {
    look_role       = 1,    -- 查看玩家
    add_friend      = 2,    -- 添加好友
    chat            = 3,    -- 私聊
    team            = 4,    -- 组队
    trade           = 5,    -- 交易
    invite_team     = 6,    -- 邀请入队
    invite_guild    = 7,    -- 邀请入会
    apply_team      = 8,    -- 申请入队
    out_team        = 10,   -- 踢出队伍
    set_teamLeader  = 11,   -- 升为队长
    add_blacklist   = 12,   -- 拉黑
    out_guild       = 13,   -- 踢出行会
    call_teammate   = 14,   -- 召集队员
    send_position   = 15,   -- 发送位置
    exit_team       = 16,   -- 退出队伍

    out_blacklist   = 21,   -- 移出黑名单
    delete_friend   = 22,   -- 删除好友

    challenge       = 24,   -- 挑战
    horse_invite    = 25,   -- 骑马邀请

    appoint_rank1   = 101,  -- 转移会长
    appoint_rank2   = 102,  -- 任命副会
    appoint_rank3   = 103,  -- 行会 任命职位
    appoint_rank4   = 104,  -- 行会 任命职位
    appoint_rank5   = 105,  -- 行会 任命职位
}

local FuncType = FuncDockData.FuncDockType
local BtnType = FuncDockData.BtnOperatorType

-- 不同类型功能菜单对应按钮组
FuncDockData.FuncConfig = {
    [FuncType.Func_Player_Head] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.apply_team,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.out_blacklist,
        BtnType.horse_invite
    },
    [FuncType.Func_Assist_Team] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.chat,
        BtnType.set_teamLeader,
        BtnType.out_team,
        BtnType.send_position,
        BtnType.exit_team,
        BtnType.call_teammate
    },
    [FuncType.Func_Team] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.chat,
        BtnType.out_team,
        BtnType.send_position,
        BtnType.exit_team
    },
    [FuncType.Func_Guild] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.appoint_rank1,
        BtnType.appoint_rank2,
        BtnType.appoint_rank4,
        BtnType.appoint_rank3,
        BtnType.appoint_rank5,
        BtnType.out_guild
    },
    [FuncType.Func_Friend] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.delete_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist
    },
    [FuncType.Func_Friend_Recent] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist
    },
    [FuncType.Func_Friend_Enemy] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.delete_enemy
    },
    [FuncType.Func_Friend_BlackList] = {BtnType.look_role, BtnType.out_blacklist},
    [FuncType.Func_Monster_Head] = {BtnType.look_role},
    [FuncType.Func_Near_Player] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.apply_team,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.out_blacklist,
        BtnType.challenge
    }
}

function FuncDockData.Init()
    FuncDockData._targetName = ""
    FuncDockData._targetId = nil
    FuncDockData._targetType = nil
    FuncDockData._playerBasic = nil -- 查看玩家的基础信息
    FuncDockData._openParam = nil
    FuncDockData._isInitRelation = true
    --------------------------
    FuncDockData._allowAddFriend = 0        -- 允许添加好友
    FuncDockData._allowTrade = 0            -- 允许交易
    FuncDockData._allowTeam = 0             -- 允许组队
    FuncDockData._allowShowForNear = 0      -- 允许附近的人显示
    FuncDockData._allowShowFashion = 0      -- 时装
    FuncDockData._allowShowHeroFashion = 0  -- 英雄时装
    ---------------------------
    FuncDockData.InitFunction()

    FuncDockData.RegisterEvent()
end

function FuncDockData.Clean()
    FuncDockData._targetName = ""
    FuncDockData._targetId = nil
    FuncDockData._targetType = nil
    FuncDockData._playerBasic = nil
end

function FuncDockData.SetParam(data)
    if not data then
        return
    end
    FuncDockData.Clean()
    FuncDockData._targetName = data.targetName
    FuncDockData._targetId = data.targetId
    FuncDockData._targetType = data.type
    FuncDockData._playerBasic = data.basic
end

function FuncDockData.SetTargetName(name)
    FuncDockData._targetName = name
end

function FuncDockData.GetTargetName()
    return FuncDockData._targetName
end

function FuncDockData.SetTargetId(id)
    FuncDockData._targetId = id
end

function FuncDockData.GetTargetId()
    return FuncDockData._targetId
end

function FuncDockData.SetTargetType(posType)
    FuncDockData._targetType = posType
end

function FuncDockData.GetTargetType()
    return FuncDockData._targetType
end

function FuncDockData.SetPlayerBasic(data)
    FuncDockData._playerBasic = data
end

function FuncDockData.GetPlayerBasic()
    return FuncDockData._playerBasic
end

-- 允许添加好友
function FuncDockData.SetAllowAddFriend(allow)
    FuncDockData._allowAddFriend = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowAddFriend()
    return FuncDockData._allowAddFriend
end

-- 允许交易
function FuncDockData.SetAllowTrade(allow)
    FuncDockData._allowTrade = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowTrade()
    return FuncDockData._allowTrade
end

-- 显示时装
function FuncDockData.SetAllowShowFashion(allow)
    FuncDockData._allowShowFashion = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowShowFashion()
    return FuncDockData._allowShowFashion
end

-- 允许组队
function FuncDockData.SetAllowTeam(allow)
    FuncDockData._allowTeam = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowTeam()
    return FuncDockData._allowTeam
end

--允许附近的人显示
function FuncDockData.SetAllowShowForNear(allow)
    FuncDockData._allowShowForNear = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowShowForNear()
    return FuncDockData._allowShowForNear
end

--显示英雄时装
function FuncDockData.SetAllowShowHeroFashion(allow)
    FuncDockData._allowShowHeroFashion = allow
    FuncDockData.RequestPermit()
end

function FuncDockData.GetAllowShowHeroFashion()
    return FuncDockData._allowShowHeroFashion
end

----------------------------------------------------------------------
function FuncDockData.InitFunction()
    FuncDockData._typeFunction = {}
    -----------------组队-----------------
    FuncDockData._typeFunction[BtnType.invite_team] = function(targetId)
        local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
        local memberMaxCount = SL:GetValue("TEAM_MEMBER_MAX_COUNT")
        if memberCount == 0 then
            SL:RequestCreateTeam()
        elseif memberCount >= memberMaxCount then
            SL:ShowSystemTips("队伍已满")
            return
        end
        -- 邀请入队
        SL:RequestInviteJoinTeam(targetId)
    end
    FuncDockData._typeFunction[BtnType.apply_team] = function(targetId)
        -- 申请入队
        if SL:GetValue("TEAM_MEMBER_COUNT") > 0 then
            SL:ShowSystemTips("已有队伍，请退出当前队伍后重试")
            return
        end
        SL:RequestApplyJoinTeam(targetId)
    end
    FuncDockData._typeFunction[BtnType.out_team] = function(targetId)
        -- 踢出队伍
        SL:RequestSubTeamMember(targetId)
    end
    FuncDockData._typeFunction[BtnType.set_teamLeader] = function(targetId)
        -- 移交队长
        SL:RequestTransferTeamLeader(targetId)
    end
    FuncDockData._typeFunction[BtnType.call_teammate] = function()
        -- 召集队员
        FuncDockData.TeamCallFunc()
    end
    FuncDockData._typeFunction[BtnType.send_position] = function()
        -- 发送坐标
        SL:RequestSendChatPosMsg(GUIDefine.ChatChannel.TEAM)
    end
    FuncDockData._typeFunction[BtnType.exit_team] = function()
        -- 退出队伍
        SL:RequestLeaveTeam()
    end

    ---------------行会------------------
    FuncDockData._typeFunction[BtnType.invite_guild] = function(targetId)
        -- 邀请入会
        SL:RequestGuildInviteMember(targetId)
    end
    FuncDockData._typeFunction[BtnType.out_guild] = function(targetId)
        -- 踢出行会
        SL:RequestSubGuildMember(targetId)
    end
    FuncDockData._typeFunction[BtnType.appoint_rank2] = function(targetId)
        -- 任命副会
        SL:RequestGuildAppointRank(targetId, SLDefine.GuildRank.ViceChairman)
    end
    FuncDockData._typeFunction[BtnType.appoint_rank3] = function(targetId)
        -- 任命精英
        SL:RequestGuildAppointRank(targetId, SLDefine.GuildRank.Elite)
    end
    FuncDockData._typeFunction[BtnType.appoint_rank4] = function(targetId)
        -- 任命会员
        SL:RequestGuildAppointRank(targetId, SLDefine.GuildRank.Member)
    end
    FuncDockData._typeFunction[BtnType.appoint_rank5] = function(targetId)
        -- 任命会员
        SL:RequestGuildAppointRank(targetId, SLDefine.GuildRank.Rank5)
    end
    FuncDockData._typeFunction[BtnType.appoint_rank1] = function(targetId)
        -- 转移会长
        local info = SL:GetValue("GUILD_MEMBER_INFO", targetId)
        if info and info.Line == 1 then
            local data      = {}
            data.str        = string.format("是否转移%s给%s", SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", 0), info.UserName)
            data.btnType    = 2
            data.callback   = function(type)
                if 1 == type then
                    SL:RequestGuildAppointRank(targetId, SLDefine.GuildRank.Chairman)
                end
            end
            UIOperator:OpenCommonTipsUI(data)

        else
            SL:ShowSystemTips("对方不在线")
        end
    end

    FuncDockData._typeFunction[BtnType.look_role] = function(targetId)
        -- 查看玩家
        SL:RequestLookPlayer(targetId)
    end

    FuncDockData._typeFunction[BtnType.chat] = function(targetId, targetName)
        -- 私聊
        SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = targetName, uid = targetId})
    end

    FuncDockData._typeFunction[BtnType.trade] = function(targetId)
        -- 交易
        SL:RequestTrade(targetId)
    end

    FuncDockData._typeFunction[BtnType.add_friend] = function(targetId, targetName)
        -- 添加好友
        if SL:GetValue("SOCIAL_IS_FRIEND_BY_NAME", targetName) then 
            SL:ShowSystemTips("你们已经是好友")
            return 
        end
        SL:RequestAddFriend(targetName)
    end

    FuncDockData._typeFunction[BtnType.out_blacklist] = function(targetId)
        -- 移出黑名单
        SL:RequestOutBlacklist(targetId)
    end

    FuncDockData._typeFunction[BtnType.delete_friend] = function(targetId, targetName)
        -- 删除好友
        local data    = {}
        data.btnType  = 2
        data.str      = string.format("是否将玩家<font color='#FF0000'>%s</font>从好友列表中删除?", targetName)
        data.callback = function(type)
            if 1 == type then
                SL:RequestDelFriend(targetId)
            end
        end
        UIOperator:OpenCommonTipsUI(data)
    end

    FuncDockData._typeFunction[BtnType.add_blacklist] = function(targetId, targetName)
        -- 拉黑
        SL:RequestAddBlacklistByName(targetName)
    end
    
    FuncDockData._typeFunction[BtnType.horse_invite] = function(targetId)
        -- 邀请上马
        local mainPlayerID = SL:GetValue("USER_ID")
        if not mainPlayerID then
            return
        end
        if not SL:GetValue("ACTOR_IS_DOUBLE_HORSE", mainPlayerID) then -- 主玩家不是双人坐骑
            SL:ShowSystemTips("你的坐骑不是双人坐骑")
            return
        end
        if SL:GetValue("ACTOR_HORSE_MASTER_ID", mainPlayerID) and SL:GetValue("ACTOR_HORSE_COPILOT_ID", mainPlayerID) then -- 主玩家的双人坐骑已满
            SL:ShowSystemTips("已满员")
            return
        end

        local targetID = SL:GetValue("SELECT_TARGET_ID")
        if not targetID then -- 没有选中对象
            return
        end
        if not SL:GetValue("ACTOR_IS_PLAYER", targetID) then -- 选择对象不是玩家
            SL:ShowSystemTips("邀请对象不是角色玩家")
            return
        end

        local mainPos = {x = SL:GetValue("ACTOR_MAP_X", mainPlayerID), y = SL:GetValue("ACTOR_MAP_Y", mainPlayerID)}
        local targetPos = {x = SL:GetValue("ACTOR_MAP_X", targetID), y = SL:GetValue("ACTOR_MAP_Y", targetID)}
        if SL:GetPointDistance(mainPos, targetPos) > 3 then
            SL:ShowSystemTips("邀请玩家不在邀请范围内")
            return
        end
        SL:RequestInvitePlayerInHorse(targetId)
    end
end

----------------------------------------------------------------------
function FuncDockData.CanOpen(data)
    if SL:GetValue("USER_ID") == data.targetId and (data.type ~= FuncType.Func_Assist_Team and data.type ~= FuncType.Func_Team) then
        return false
    end
    return true
end

function FuncDockData.IsShowBtn(type, index)
    -- 英雄，只有查看
    if SL:GetValue("ACTOR_IS_HERO", FuncDockData._targetId) and BtnType.look_role ~= index then
        return false
    end

    local show = true
    if type == FuncType.Func_Assist_Team or type == FuncType.Func_Team then
        if SL:GetValue("USER_ID") == FuncDockData._targetId then
            show = BtnType.call_teammate == index or BtnType.send_position == index or BtnType.exit_team == index
        else
            if BtnType.call_teammate == index or BtnType.send_position == index or BtnType.exit_team == index then
                show = false

            elseif BtnType.set_teamLeader == index or BtnType.out_team == index then
                show = SL:GetValue("TEAM_IS_LEADER")
            end
        end

    elseif type == FuncType.Func_Guild then
        local isMaster = SL:GetValue("GUILD_IS_CHAIRMAN")
        local isAdmin = SL:GetValue("GUILD_IS_ADMIN")
        local info = SL:GetValue("GUILD_MEMBER_INFO", FuncDockData._targetId)
        local rank = info.Rank
        local targetIsAdmin = rank == SLDefine.GuildRank.Chairman or rank == SLDefine.GuildRank.ViceChairman
        if BtnType.appoint_rank2 == index or BtnType.appoint_rank4 == index or BtnType.appoint_rank3 == index or BtnType.appoint_rank1 == index
            or BtnType.appoint_rank5 == index then
            show = false
            if isAdmin and info and info.Rank then
                if isMaster then
                    show = true

                else
                    if BtnType.appoint_rank3 == index then
                        show = rank ~= SLDefine.GuildRank.Elite and not targetIsAdmin
                    elseif BtnType.appoint_rank4 == index then
                        show = rank ~= SLDefine.GuildRank.Member and not targetIsAdmin
                    elseif BtnType.appoint_rank5 == index then
                        show = rank ~= SLDefine.GuildRank.Rank5 and not targetIsAdmin
                    elseif BtnType.appoint_rank2 == index then
                        show = false
                    end
                end
            end
        end
        if BtnType.out_guild == index then
            show = isMaster or (isAdmin and not targetIsAdmin)
        elseif BtnType.invite_team == index then
            show = info.Online == 1
        end

    elseif type == FuncType.Func_Player_Head then
        if not SL:GetValue("SOCIAL_IS_BLACKLIST_BY_UID", FuncDockData._targetId) then
            if BtnType.invite_team == index then
                if FuncDockData._playerBasic and FuncDockData._playerBasic.group == 1 then
                    show = false
                end
    
            elseif BtnType.apply_team == index then
                if (FuncDockData._playerBasic and FuncDockData._playerBasic.group == 0) or SL:GetValue("TEAM_MEMBER_COUNT") > 0 then
                    show = false
                end
    
            elseif BtnType.invite_guild == index then
                if (FuncDockData._playerBasic and FuncDockData._playerBasic.guild ~= "") or not SL:GetValue("GUILD_IS_JOINED") then
                    show = false
                end
            end

            if FuncDockData.IsRelationTypeBtn(index) then
                show = FuncDockData.CheckRelationBtnTypeShow(index)
            end

        else
            show = false
            if BtnType.look_role == index then
                show = true
            end
        end
        
        if BtnType.look_role == index and SL:GetValue("ACTOR_IS_HUMAN", FuncDockData._targetId) then -- 人形怪
            local disHeadLookHumanoid = tonumber(SL:GetValue("GAME_DATA", "disHeadLookHumanoid")) == 1
            if disHeadLookHumanoid then
                show = false
            end
        end
    end

    if index == BtnType.add_friend then
        show = not SL:GetValue("FRIEND_INFO_BY_UID", FuncDockData._targetId) and SL:GetValue("USER_ID") ~= FuncDockData._targetId
    elseif index == BtnType.add_blacklist then
        -- 拉黑
        show = not SL:GetValue("SOCIAL_IS_BLACKLIST_BY_UID", FuncDockData._targetId)
    elseif index == BtnType.out_blacklist then
        -- 移除黑名单
        show = SL:GetValue("SOCIAL_IS_BLACKLIST_BY_UID", FuncDockData._targetId)
    elseif BtnType.invite_team == index then
        if SL:GetValue("TEAM_IS_MEMBER", FuncDockData._targetId) then
            show = false
        end
    elseif BtnType.trade == index then
        if tonumber(SL:GetValue("GAME_DATA", "CloseTradeFunc")) == 1 then
            show = false
        end
    elseif BtnType.horse_invite == index then -- 骑马邀请
        if not SL:GetValue("ACTOR_IS_DOUBLE_HORSE", SL:GetValue("USER_ID")) then
            -- 不是双人坐骑
            show = false
        elseif SL:GetValue("ACTOR_HORSE_COPILOT_ID", SL:GetValue("USER_ID")) then
            -- 双人坐骑已满
            show = false
        end
        if not SL:GetValue("ACTOR_IS_PLAYER", FuncDockData._targetId) then
            show = false
        end
    end

    return show
end

function FuncDockData.IsRelationTypeBtn(btnType)
    local type = btnType - 1000
    if type >= 100 then
        return true
    end

    return false
end

function FuncDockData.CheckRelationBtnTypeShow(btnType)
    local type = btnType - 1000
    local isShow = true

    local config = SL:GetValue("RELATION_TYPE_CONFIG", type) or {}
    local sexDiff = config.sex_diff or 0
    local netData = SL:GetValue("RELATION_MY_NETLIST")[type]
    local memberCount = (netData and netData.MemCount or 1) - 1
    if memberCount >= (config.maxCount or 500) then
        isShow = false
    end

    if netData and netData.MemList and next(netData.MemList) then
        for i, member in ipairs(netData.MemList) do
            if member.UserID == FuncDockData._openParam.targetId then
                isShow = false
                break
            end
        end
    end

    local targetSex = SL:GetValue("ACTOR_SEX", FuncDockData._openParam.targetId)
    if sexDiff == 1 and SL:GetValue("SEX") == targetSex then   -- 非异性
        isShow = false
    elseif sexDiff == 2 and SL:GetValue("SEX") ~= targetSex then   -- 非同性
        isShow = false
    end

    return isShow
end

--队伍召集令
function FuncDockData.TeamCallFunc()
    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
    if memberCount <= 0 then
        SL:ShowSystemTips("未组队，无法使用")
        return
    elseif memberCount == 1 then
        SL:ShowSystemTips("缺少成员，无法召集！")
        return
    end

    local itemIndex = SL:GetValue("GAME_DATA", "Team_assembled") or 3020001
    local costParam = {
        itemID = itemIndex,
        itemNum = 1,
    }
    local function checkItemCount()
        local myCount = SL:GetValue("ITEM_COUNT", costParam.itemID)
        if myCount < costParam.itemNum then
            SL:ShowSystemTips(string.format("%s不足", SL:GetValue("ITEM_NAME", costParam.itemID)))
            return false
        end
        return true
    end
    if checkItemCount() then
        local data    = {}
        data.btnType  = 2
        data.str      = "确认使用队伍召集令？"
        data.callback = function(type)
            if 1 == type then
                SL:RequestUseItemByIndex(itemIndex)
            end
        end
        UIOperator:OpenCommonTipsUI(data)
    end
end

----------------------------------------------------------------------
function FuncDockData.RequestPermit()
    local setData = {}
    setData[SLDefine.FuncDockOption.ALLOW_ADD_FRIEND] = FuncDockData.GetAllowAddFriend()
    setData[SLDefine.FuncDockOption.ALLOW_TRADE] = FuncDockData.GetAllowTrade()
    setData[SLDefine.FuncDockOption.ALLOW_SHOW_FASHTION] = FuncDockData.GetAllowShowFashion()
    setData[SLDefine.FuncDockOption.ALLOW_TEAM] = FuncDockData.GetAllowTeam()
    setData[SLDefine.FuncDockOption.ALLOW_NEAR_SHOW] = FuncDockData.GetAllowShowForNear()
    setData[SLDefine.FuncDockOption.ALLOW_SHOW_HERO_FASHTION] = FuncDockData.GetAllowShowHeroFashion()
    SL:RequestFuncDockPermit(setData)
end

function FuncDockData.RequestLookPlayerInfo(data)
    FuncDockData._openParam = nil
    if not data or not next(data) then
        return
    end

    local userID = data.targetId
    if not data.targetId then
        return
    end

    local isHero = data.isHero
    FuncDockData._openParam = data
    SL:RequestFuncDockLookPlayerInfo(userID, isHero)
end

function FuncDockData.OnUpdateOption(data)
    if not data or not next(data) then
        return
    end
    FuncDockData._allowAddFriend = data[SLDefine.FuncDockOption.ALLOW_ADD_FRIEND] or 0
    FuncDockData._allowTrade = data[SLDefine.FuncDockOption.ALLOW_TRADE] or 0
    FuncDockData._allowShowFashion = data[SLDefine.FuncDockOption.ALLOW_SHOW_FASHTION] or 0
    FuncDockData._allowTeam = data[SLDefine.FuncDockOption.ALLOW_TEAM] or 0
    FuncDockData._allowShowForNear = data[SLDefine.FuncDockOption.ALLOW_NEAR_SHOW] or 0
    FuncDockData._allowShowHeroFashion = data[SLDefine.FuncDockOption.ALLOW_SHOW_HERO_FASHTION] or 0
end

function FuncDockData.OnLookPlayerInfo(data)
    if not data or not FuncDockData._openParam then
        return
    end

    if not data.isOnline then
        SL:ShowSystemTips("对方不在线！")
        return
    end
    
    if FuncDockData._openParam.targetId ~= data.UserID then
        return
    end

    local openData = FuncDockData._openParam
    openData.basic = data

    GUI:SetLayerOpenParam(openData)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_FUNC_DOCK)
end

function FuncDockData.InitAddRelationType()
    if not FuncDockData._isInitRelation then
        return
    end

    local btnConfig = FuncDockData.FuncConfig[FuncDockData.FuncDockType.Func_Player_Head]
    local relationTypeList = SL:GetValue("RELATION_TYPE_LIST") or {}
    if next(relationTypeList) then
        for i = 1, #relationTypeList do
            local type = relationTypeList[i]
            table.insert(btnConfig, type + 1000)
        end
    end

    FuncDockData._isInitRelation = false
end

function FuncDockData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_FUNC_DOCK_OPTION_CHANGE, "FuncDockData", FuncDockData.OnUpdateOption)
    SL:RegisterLUAEvent(LUA_EVENT_FUNC_DOCK_LOOK_PLAYER_INFO, "FuncDockData", FuncDockData.OnLookPlayerInfo)
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_DATA_INIT, "FuncDockData", FuncDockData.InitAddRelationType)
end

