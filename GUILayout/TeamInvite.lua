TeamInvite = {}

TeamInvite._openPage = 0

local tinsert = table.insert

function TeamInvite.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "social/team/team_invite")

    TeamInvite._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamInvite._ui["Panel_1"], posX, posY) 

    GUI:addOnClickEvent(TeamInvite._ui["Button_close"], function()
        SL:CloseTeamInvite()
    end)

    -- 附近
    local Button_near = TeamInvite._ui["Button_near"]
    TeamInvite.Button_near = Button_near
    GUI:addOnClickEvent(Button_near, function()
        if TeamInvite._openPage == 1 then
            return
        end
        TeamInvite._openPage = 1
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 好友
    local Button_friend = TeamInvite._ui["Button_friend"]
    TeamInvite.Button_friend = Button_friend
    GUI:addOnClickEvent(Button_friend, function()
        if TeamInvite._openPage == 2 then
            return
        end
        TeamInvite._openPage = 2
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 行会
    local Button_guild = TeamInvite._ui["Button_guild"]
    TeamInvite.Button_guild = Button_guild
    GUI:addOnClickEvent(Button_guild, function()
        if TeamInvite._openPage == 3 then
            return
        end
        TeamInvite._openPage = 3
        TeamInvite.RefreshBtn()
        TeamInvite.RefreshContent()
    end)

    -- 输入名字
    GUI:addOnClickEvent(TeamInvite._ui["Button_name"], function()
        local data = {}
        data.str = "请输入邀请玩家的名字"
        data.btnType = 2
        data.showEdit = true
        data.callback = function(atype, param)
            if atype == 1 then
                if param and param.editStr and string.len(param.editStr) > 0 then
                    SL:RequestInviteJoinTeam(nil, param.editStr)
                end
            end
        end
        SL:OpenCommonTipsPop(data)
    end)

    SL:RequestGuildMemberList()
    SL:RequestFriendList()

    TeamInvite._openPage = 1
    TeamInvite.RefreshBtn()
    TeamInvite.RefreshContent()
end

function TeamInvite.RefreshBtn()
    GUI:Button_setBright(TeamInvite.Button_near, TeamInvite._openPage ~= 1)
    GUI:Button_setBright(TeamInvite.Button_friend, TeamInvite._openPage ~= 2)
    GUI:Button_setBright(TeamInvite.Button_guild, TeamInvite._openPage ~= 3)
    GUI:Button_setTitleColor(TeamInvite.Button_near, TeamInvite._openPage == 1 and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(TeamInvite.Button_friend, TeamInvite._openPage == 2 and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(TeamInvite.Button_guild, TeamInvite._openPage == 3 and "#f8e6c6" or "#6c6861")
end

function TeamInvite.RefreshContent()
    local members = {}
    local openPage = TeamInvite._openPage
    if openPage == 1 then
        local nearPlayer = SL:FindPlayerInCurrViewField()
        for _, v in pairs(nearPlayer) do
            -- 排除人形怪、有队伍的玩家、英雄
            if not (SL:GetMetaValue("ACTOR_RACE", v) == 150 or SL:GetMetaValue("ACTOR_TEAM_STATE", v) == 1 or SL:GetMetaValue("ACTOR_IS_HERO", v)) then
                local item = {}
                item.uid = SL:GetMetaValue("ACTOR_ID", v)
                item.name = SL:GetMetaValue("ACTOR_NAME", v)
                item.level = SL:GetMetaValue("ACTOR_LEVEL", v)
                item.guildName = SL:GetMetaValue("ACTOR_GUILD_NAME", v)
                tinsert(members, item)
            end
        end

    elseif openPage == 2 then
        for _, v in pairs(SL:GetMetaValue("FRIEND_LIST") or {}) do
            if v.Online then
                local item = {}
                item.uid = v.UserId
                item.name = v.Name
                item.level = v.Level
                item.guildName = v.Guild
                tinsert(members, item)
            end
        end

    elseif openPage == 3 then
        local myUid = SL:GetMetaValue("USER_ID")
        local guildName = SL:GetMetaValue("GUILD_INFO").guildName

        for _, v in pairs(SL:GetMetaValue("GUILD_MEMBER_LIST") or {}) do
            if v.UserID ~= myUid and v.Online == 1 then
                local item = {}
                item.uid = v.UserID
                item.name = v.Name
                item.level = v.Level
                item.guildName = guildName
                tinsert(members, item)
            end
        end
    end

    local ListView = TeamInvite._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)
    for _, member in pairs(members) do
        print(SL:GetMetaValue("TEAM_IS_MEMBER", member.uid))
        if not SL:GetMetaValue("TEAM_IS_MEMBER", member.uid) then
            local cell = TeamInvite.CreateMemberCell()
            GUI:ListView_pushBackCustomItem(ListView, cell)

            local cellUI = GUI:ui_delegate(cell)

            GUI:Text_setString(cellUI["Label_name"], member.name)
            GUI:Text_setString(cellUI["Label_level"], member.level)
            GUI:Text_setString(cellUI["Label_guild"], member.guildName)

            GUI:setVisible(cellUI["Button_operation"], true)
            GUI:setVisible(cellUI["Label_operation"], false)

            GUI:addOnClickEvent(cellUI["Button_operation"], function()
                SL:RequestInviteJoinTeam(member.uid)
                GUI:setVisible(cellUI["Button_operation"], false)
                GUI:setVisible(cellUI["Label_operation"], true)
            end)
        end
    end
end

function TeamInvite.CreateMemberCell()
    local parent = GUI:Node_Create(TeamInvite._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "social/team/team_invite_member_cell")
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end