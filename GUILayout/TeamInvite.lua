TeamInvite = {}

TeamInvite._type = 1     -- 1: 我的队伍; 2: 附近队伍

function TeamInvite.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "team/team_invite")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    TeamInvite._ui = ui

    GUI:setContentSize(ui["MaskLayout"], SL:GetScreenWidth(), SL:GetScreenHeight())

    TeamInvite._type = 1

    SL:RegisterLUAEvent(LUA_EVENT_TEAM_FRIEND_UPDATE, "TeamInvite", TeamInvite.UpdateFriendList)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_REFRESH, "TeamInvite", TeamInvite.UpdateMemberList)

    TeamInvite.InitEvent(ui)

    TeamInvite.SetBtnStatus()

    TeamInvite.UpdateUI()
end

function TeamInvite.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_FRIEND_UPDATE, "TeamInvite")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_REFRESH, "TeamInvite")
end

function TeamInvite.InitEvent(ui)
    local onSkipPage = function (index)
        if TeamInvite._type == index then
            return false
        end
        TeamInvite._type = index
        TeamInvite.SetBtnStatus()
        TeamInvite.UpdateUI()
    end

    GUI:addOnClickEvent(ui.nearBtn, function ()
        onSkipPage(1)
    end)

    GUI:addOnClickEvent(ui.friendBtn, function ()
        onSkipPage(2)
    end)

    GUI:addOnClickEvent(ui.guildBtn, function ()
        onSkipPage(3)
    end)

    GUI:addOnClickEvent(ui.closeBtn, function ()
        SL:CloseTeamInvite()
    end)

    GUI:addOnClickEvent(ui.nameBtn, function ()
        local callback = function (btnType, editparam)
            if btnType ~= 1 then
                return false
            end

            if not editparam then
                return false
            end

            local editStr = editparam.editStr
            if not editStr then
                return false
            end

            if string.len(editStr) < 1 then
                return false
            end

            SL:RequestInviteTeam(nil, editStr)
        end

        local data   = {
            str      = "请输入邀请玩家的名字",
            btnType  = 2,
            showEdit = true,
            callback = callback
        }

        SL:OpenCommonTipsPop(data)
    end)
end

function TeamInvite.SetBtnStatus()
    local pColorID = 1025
    local nColorID = 1026

    local nearBtn = TeamInvite._ui["nearBtn"]
    if GUI:Win_IsNotNull(nearBtn) then
        local isPress = TeamInvite._type == 1

        GUI:Button_setBright(nearBtn, not isPress)
        SL:SetColorStyle(nearBtn, isPress and pColorID or nColorID)
    end

    local friendBtn = TeamInvite._ui["friendBtn"]
    if GUI:Win_IsNotNull(friendBtn) then
        local isPress = TeamInvite._type == 2

        GUI:Button_setBright(friendBtn, not isPress)
        SL:SetColorStyle(friendBtn, isPress and pColorID or nColorID)
    end

    local guildBtn = TeamInvite._ui["guildBtn"]
    if GUI:Win_IsNotNull(guildBtn) then
        local isPress = TeamInvite._type == 3

        GUI:Button_setBright(guildBtn, not isPress)
        SL:SetColorStyle(guildBtn, isPress and pColorID or nColorID)
    end
end

function TeamInvite.UpdateUI()
    local list = TeamInvite._ui["ListView"]
    GUI:ListView_removeAllItems(list)

    if TeamInvite._type == 1 then
        local actorIDs = SL:GetPlayerInViewField()
        for k = 1, #actorIDs do
            local actorID = actorIDs[k]
            -- 排除人形怪、有队伍的玩家、英雄
            if actorID and not (SL:GetMetaValue("ACTOR_IS_HUMAN", actorID) or SL:GetMetaValue("ACTOR_TEAM_STATE", actorID) == 1) then
                local data = {
                    uid       = actorID,
                    name      = SL:GetMetaValue("ACTOR_NAME", actorID),
                    level     = SL:GetMetaValue("ACTOR_LEVEL", actorID),
                    guildName = SL:GetMetaValue("ACTOR_GUILD_NAME", actorID)
                }

                GUI:QuickCell_Create(list, "Cell" .. k, 0, 0, 504, 40, function(parent) return TeamInvite.CreateCell(parent, data) end)
            end
        end
    elseif TeamInvite._type == 2 then
        -- 请求好友列表
        SL:RequistFriendList()
    elseif TeamInvite._type == 3 then
        -- 请求行会成员列表
        SL:RequestGuildMemberList()
    end
end

function TeamInvite.UpdateFriendList()
    if TeamInvite._type ~= 2 then
        return false
    end

    local friends = SL:GetFriends()

    for k, v in pairs(friends) do
        if v.Online and not SL:GetMetaValue("IS_TEAM_MEMBER", v.UserId) then
            local data = {
                uid       = v.UserId,
                name      = v.Name,
                level     = v.Level,
                guildName = v.Guild
            }

            GUI:QuickCell_Create(TeamInvite._ui["ListView"], "Cell" .. k, 0, 0, 504, 40, function(parent) return TeamInvite.CreateCell(parent, data) end)
        end
    end
end

function TeamInvite.UpdateMemberList()
    if TeamInvite._type ~= 3 then
        return false
    end

    local members = SL:GetGuildMemberList()

    for k, v in pairs(members) do
        if v.UserID ~= SL:GetMetaValue("USERID") and v.Online == 1 then
            local data    = {
                uid       = v.UserID,
                name      = v.Name,
                level     = v.Level,
                guildName = SL:GetMetaValue("GUILDNAME")
            }

            GUI:QuickCell_Create(TeamInvite._ui["ListView"], "Cell" .. k, 0, 0, 504, 40, function(parent) return TeamInvite.CreateCell(parent, data) end)
        end
    end
end

function TeamInvite.CreateCell(parent, info)
    GUI:LoadExport(parent, "team/team_invite_cell")
    local ui = GUI:ui_delegate(parent)

    GUI:setVisible(ui.Cell, true)

    local uid, name, level, guildName, mapName = info.uid, info.name, info.level, info.guildName

    -- 名字
    GUI:Text_setString(ui["nameLabel"], name)

    -- 等级
    GUI:Text_setString(ui["levelLabel"], level)

    -- 行会名字
    GUI:Text_setString(ui["guildLabel"], guildName or "无")

    local operationBtn = ui["operationBtn"]
    GUI:setVisible(operationBtn, true)

    local operationLbl = ui["operationLabel"]
    GUI:setVisible(operationLbl, false)

    GUI:addOnClickEvent(operationBtn, function ()
        GUI:setVisible(operationBtn, false)
        GUI:setVisible(operationLbl, true)
        SL:RequestInviteTeam(uid)
    end)

    return ui.Cell
end

return TeamInvite