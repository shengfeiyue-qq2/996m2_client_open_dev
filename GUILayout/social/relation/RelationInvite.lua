RelationInvite = {}

RelationInvite._openPage = 0
RelationInvite._openType = {
    Near = 1,
    Friend = 2,
    Guild = 3
}

local tinsert = table.insert

function RelationInvite.main()
    RelationInvite._type = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local parent = GUI:Win_Create(UIConst.LAYERID.RelationInviteGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/relation/relation_invite")

    RelationInvite._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(RelationInvite._ui.Panel_1, posX, posY) 

    GUI:addOnClickEvent(RelationInvite._ui.Button_close, function()
        UIOperator:CloseRelationInvite()
    end)

    -- 附近
    GUI:addOnClickEvent(RelationInvite._ui.Button_near, function()
        if RelationInvite._openPage == RelationInvite._openType.Near then
            return
        end
        RelationInvite._openPage = RelationInvite._openType.Near
        RelationInvite.RefreshBtn()
        RelationInvite.RefreshContent()
    end)

    -- 好友
    GUI:addOnClickEvent(RelationInvite._ui.Button_friend, function()
        if RelationInvite._openPage == RelationInvite._openType.Friend then
            return
        end
        RelationInvite._openPage = RelationInvite._openType.Friend
        RelationInvite.RefreshBtn()
        RelationInvite.RefreshContent()
    end)

    -- 行会
    GUI:addOnClickEvent(RelationInvite._ui.Button_guild, function()
        if RelationInvite._openPage == RelationInvite._openType.Guild then
            return
        end
        RelationInvite._openPage = RelationInvite._openType.Guild
        RelationInvite.RefreshBtn()
        RelationInvite.RefreshContent()
    end)

    -- 输入名字
    GUI:addOnClickEvent(RelationInvite._ui.Button_name, function()
        local data = {}
        data.str = "请输入邀请玩家的名字"
        data.btnType = 2
        data.showEdit = true
        data.callback = function(atype, param)
            if atype == 1 then
                if param and param.editStr and string.len(param.editStr) > 0 then
                    RelationInvite.DoInviteMember({name = param.editStr})
                end
            end
        end
        UIOperator:OpenCommonTipsUI(data)
    end)

    SL:RequestGuildMemberList()
    SL:RequestFriendList()

    RelationInvite._openPage = RelationInvite._openType.Near
    RelationInvite.RefreshBtn()
    RelationInvite.RefreshContent()
end

function RelationInvite.RefreshBtn()
    GUI:Button_setBright(RelationInvite._ui.Button_near, RelationInvite._openPage ~= RelationInvite._openType.Near)
    GUI:Button_setBright(RelationInvite._ui.Button_friend, RelationInvite._openPage ~= RelationInvite._openType.Friend)
    GUI:Button_setBright(RelationInvite._ui.Button_guild, RelationInvite._openPage ~= RelationInvite._openType.Guild)
    GUI:Button_setTitleColor(RelationInvite._ui.Button_near, RelationInvite._openPage == RelationInvite._openType.Near and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(RelationInvite._ui.Button_friend, RelationInvite._openPage == RelationInvite._openType.Friend and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(RelationInvite._ui.Button_guild, RelationInvite._openPage == RelationInvite._openType.Guild and "#f8e6c6" or "#6c6861")
end

function RelationInvite.RefreshContent()
    local members = {}
    local openPage = RelationInvite._openPage
    if openPage == RelationInvite._openType.Near then
        local playerList = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
        for i, v in ipairs(playerList) do
            -- 排除人形怪、有队伍的玩家、英雄
            if not (SL:GetValue("ACTOR_IS_HUMAN", v) or SL:GetValue("ACTOR_TEAM_STATE", v) ~= 0 or SL:GetValue("ACTOR_IS_HERO", v)) then
                local item = {}
                item.uid = v
                item.name = SL:GetValue("ACTOR_NAME", v)
                item.level = SL:GetValue("ACTOR_LEVEL", v)
                item.sex = SL:GetValue("ACTOR_SEX", v)
                item.guildName = SL:GetValue("ACTOR_GUILD_NAME", v)
                tinsert(members, item)
            end
        end

    elseif openPage == RelationInvite._openType.Friend then
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

    elseif openPage == RelationInvite._openType.Guild then
        local myUid = SL:GetValue("USER_ID")
        local guildName = SL:GetValue("GUILD_INFO").guildName

        for _, v in pairs(SL:GetValue("GUILD_MEMBER_LIST") or {}) do
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

    local ListView = RelationInvite._ui.ListView
    GUI:ListView_removeAllItems(ListView)
    for _, member in pairs(members) do
        if not SL:GetValue("TEAM_IS_MEMBER", member.uid) then
            local cell = RelationInvite.CreateMemberCell()
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
                RelationInvite.DoInviteMember(member)
                GUI:delayTouchEnabled(sender)

                GUI:setVisible(cellUI["Button_operation"], false)
                GUI:setVisible(cellUI["Label_operation"], true)
            end)
        end
    end
end

function RelationInvite.DoInviteMember(member)
    if not RelationInvite._type then
        return
    end

    SL:RequestRelationInviteJoin(RelationInvite._type, member.uid, member.name)
end

function RelationInvite.CreateMemberCell()
    local parent = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(parent, "social/relation/relation_invite_member_cell")
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    return member_cell
end

RelationInvite.main()