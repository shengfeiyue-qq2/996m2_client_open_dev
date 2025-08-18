TeamInvite = {}

TeamInvite._openPage = 0
TeamInvite._openType = {
    Near = 1,
    Friend = 2,
    Guild = 3
}

local tinsert = table.insert

function TeamInvite.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.TeamInviteGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/team/team_invite")

    TeamInvite._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamInvite._ui.Panel_1, posX, posY) 

    GUI:addOnClickEvent(TeamInvite._ui.Button_close, function()
        UIOperator:CloseTeamInvite()
    end)

    -- 附近
    GUI:addOnClickEvent(TeamInvite._ui.Button_near, function()
        if TeamInvite._openPage == TeamInvite._openType.Near then
            return
        end
        TeamInvite._openPage = TeamInvite._openType.Near
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 好友
    GUI:addOnClickEvent(TeamInvite._ui.Button_friend, function()
        if TeamInvite._openPage == TeamInvite._openType.Friend then
            return
        end
        TeamInvite._openPage = TeamInvite._openType.Friend
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 行会
    GUI:addOnClickEvent(TeamInvite._ui.Button_guild, function()
        if TeamInvite._openPage == TeamInvite._openType.Guild then
            return
        end
        TeamInvite._openPage = TeamInvite._openType.Guild
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 输入名字
    GUI:addOnClickEvent(TeamInvite._ui.Button_name, function()
        local data = {}
        data.str = "请输入邀请玩家的名字"
        data.btnType = 2
        data.showEdit = true
        data.callback = function(atype, param)
            if atype == 1 then
                if param and param.editStr and string.len(param.editStr) > 0 then
                    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
                    local memberMaxCount = SL:GetValue("TEAM_MEMBER_MAX_COUNT")
                    if memberCount == 0 then
                        SL:RequestCreateTeam()
                    elseif memberCount >= memberMaxCount then
                        SL:ShowSystemTips("队伍已满")
                        return
                    end
                    SL:RequestInviteJoinTeam(nil, param.editStr)
                end
            end
        end
        UIOperator:OpenCommonTipsUI(data)
    end)

    SL:RequestGuildMemberList()
    SL:RequestFriendList()

    TeamInvite._openPage = TeamInvite._openType.Near
    TeamInvite.RefreshBtn()
    TeamInvite.RefreshContent()
end

function TeamInvite.RefreshBtn()
    GUI:Button_setBright(TeamInvite._ui.Button_near, TeamInvite._openPage ~= TeamInvite._openType.Near)
    GUI:Button_setBright(TeamInvite._ui.Button_friend, TeamInvite._openPage ~= TeamInvite._openType.Friend)
    GUI:Button_setBright(TeamInvite._ui.Button_guild, TeamInvite._openPage ~= TeamInvite._openType.Guild)
    GUI:Button_setTitleColor(TeamInvite._ui.Button_near, TeamInvite._openPage == TeamInvite._openType.Near and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(TeamInvite._ui.Button_friend, TeamInvite._openPage == TeamInvite._openType.Friend and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(TeamInvite._ui.Button_guild, TeamInvite._openPage == TeamInvite._openType.Guild and "#f8e6c6" or "#6c6861")
end

function TeamInvite.RefreshContent()
    local members = {}
    local openPage = TeamInvite._openPage
    if openPage == TeamInvite._openType.Near then
        local playerList = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
        for i, v in ipairs(playerList) do
            -- 排除人形怪、有队伍的玩家、英雄
            if not (SL:GetValue("ACTOR_IS_HUMAN", v) or SL:GetValue("ACTOR_TEAM_STATE", v) ~= 0 or SL:GetValue("ACTOR_IS_HERO", v)) then
                local item = {}
                item.uid = v
                item.name = SL:GetValue("ACTOR_NAME", v)
                item.level = SL:GetValue("ACTOR_LEVEL", v)
                item.guildName = SL:GetValue("ACTOR_GUILD_NAME", v)
                tinsert(members, item)
            end
        end

    elseif openPage == TeamInvite._openType.Friend then
        for _, v in pairs(SL:GetValue("FRIEND_LIST") or {}) do
            if v.Line then
                local item = {}
                item.uid = v.UserID
                item.name = v.UserName
                item.level = v.Level
                item.guildName = v.GuildName
                tinsert(members, item)
            end
        end

    elseif openPage == TeamInvite._openType.Guild then
        local myUid = SL:GetValue("USER_ID")
        local guildName = SL:GetValue("GUILD_INFO").guildName

        for _, v in pairs(SL:GetValue("GUILD_MEMBER_LIST") or {}) do
            if v.UserID ~= myUid and v.Line == 1 then
                local item = {}
                item.uid = v.UserID
                item.name = v.UserName
                item.level = v.Level
                item.guildName = guildName
                tinsert(members, item)
            end
        end
    end

    local ListView = TeamInvite._ui.ListView
    GUI:ListView_removeAllItems(ListView)
    for _, member in pairs(members) do
        if not SL:GetValue("TEAM_IS_MEMBER", member.uid) then
            local cell = TeamInvite.CreateMemberCell()
            GUI:ListView_pushBackCustomItem(ListView, cell)

            local cellUI = GUI:ui_delegate(cell)
            local guildName = "无"
            if member.guildName and member.guildName ~= "" then 
                guildName = member.guildName
            end
            GUI:Text_setString(cellUI["Label_name"], member.name)
            GUI:Text_setString(cellUI["Label_level"], member.level)
            GUI:Text_setString(cellUI["Label_guild"], guildName)

            GUI:setVisible(cellUI["Button_operation"], true)
            GUI:setVisible(cellUI["Label_operation"], false)

            GUI:addOnClickEvent(cellUI["Button_operation"], function(sender)
                local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
                local memberMaxCount = SL:GetValue("TEAM_MEMBER_MAX_COUNT")
                if memberCount == 0 then
                    SL:RequestCreateTeam()
                elseif memberCount >= memberMaxCount then
                    SL:ShowSystemTips("队伍已满")
                    return
                end
                SL:RequestInviteJoinTeam(member.uid)
                GUI:delayTouchEnabled(sender)

                GUI:setVisible(cellUI["Button_operation"], false)
                GUI:setVisible(cellUI["Label_operation"], true)
            end)
        end
    end
end

function TeamInvite.CreateMemberCell()
    local parent = GUI:Node_Create(TeamInvite._ui.nativeUI, "node", 0, 0)
    GUI:LoadExport(parent, "social/team/team_invite_member_cell")
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

TeamInvite.main()