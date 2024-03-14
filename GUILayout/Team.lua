Team = {}

function Team.main(openPage)
    local parent = GUI:Attach_Parent()

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/team/team_win32")
    else
        GUI:LoadExport(parent, "social/team/team")
    end

    Team._ui = GUI:ui_delegate(parent)
    Team._openPage = openPage or 1

    -- 我的队伍
    local Button_myTeam = Team._ui["Button_myTeam"]
    Team.Button_myTeam = Button_myTeam
    GUI:addOnClickEvent(Button_myTeam, function()
        if Team._openPage == 1 then
            return
        end
        Team._openPage = 1
        Team.RefreshBtn()
        Team.Refresh()
    end)

    -- 附近队伍
    local Button_nearTeam = Team._ui["Button_nearTeam"]
    Team.Button_nearTeam = Button_nearTeam
    GUI:addOnClickEvent(Button_nearTeam, function()
        if Team._openPage == 2 then
            return
        end
        Team._openPage = 2
        Team.RefreshBtn()
        Team.Refresh()
    end)

    -- 创建队伍
    local Button_createTeam = Team._ui["Button_createTeam"]
    Team.Button_createTeam = Button_createTeam
    GUI:addOnClickEvent(Button_createTeam, function()
        SL:RequestCreateTeam()
    end)

    -- 申请列表
    local Button_applyList = Team._ui["Button_applyList"]
    Team.Button_applyList = Button_applyList
    GUI:addOnClickEvent(Button_applyList, function()
        SL:OpenTeamApply()
    end)

    -- 召集队友
    local Button_call = Team._ui["Button_call"]
    Team.Button_call = Button_call
    GUI:addOnClickEvent(Button_call, function()
        SL:RequestCallTeamMember()
    end)

    -- 邀请成员
    local Button_invite = Team._ui["Button_invite"]
    Team.Button_invite = Button_invite
    GUI:addOnClickEvent(Button_invite, function()
        SL:OpenTeamInvite()
    end)

    -- 离开队伍
    local Button_exit = Team._ui["Button_exit"]
    Team.Button_exit = Button_exit
    GUI:addOnClickEvent(Button_exit, function()
        SL:RequestLeaveTeam()
    end)

    -- 允许组队
    local CheckBox_permit = Team._ui["CheckBox_permit"]
    GUI:CheckBox_setSelected(CheckBox_permit, SL:GetMetaValue("TEAM_STATUS_PERMIT") == 1)
    GUI:CheckBox_addOnEvent(CheckBox_permit, function(sender)
        local isSelected = GUI:CheckBox_isSelected(sender)
        local status = isSelected and 1 or 0
        SL:RequestSetTeamPermitStatus(status)
    end)

    Team.RegisterEvent()

    SL:RequestNearTeam()

    Team.RefreshBtn()
    Team.Refresh()
end

function Team.RefreshBtn()
    GUI:Button_setBright(Team.Button_myTeam, Team._openPage ~= 1)
    GUI:Button_setBright(Team.Button_nearTeam, Team._openPage ~= 2)
    GUI:Button_setTitleColor(Team.Button_myTeam, Team._openPage == 1 and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(Team.Button_nearTeam, Team._openPage == 2 and "#f8e6c6" or "#6c6861")
end

function Team.Refresh()
    GUI:setVisible(Team._ui["Panel_myTeam"], Team._openPage == 1)
    GUI:setVisible(Team._ui["Panel_nearTeam"], Team._openPage == 2)
    if Team._openPage == 2 then
        SL:RequestNearTeam()
    end

    Team.RefreshContent()
end

function Team.RefreshContent()
    if Team._openPage == 1 then
        Team.RefreshMemberList()

    elseif Team._openPage == 2 then
        Team.RefreshNearList()
    end
end

function Team.RefreshMemberList()
    if Team._openPage ~= 1 then return end

    local teamMember = SL:GetMetaValue("TEAM_MEMBER_LIST")
    local memberCount = SL:GetMetaValue("TEAM_COUNT")

    GUI:setVisible(Team._ui["Image_none"], memberCount == 0)

    local expSwitch = SL:GetMetaValue("SERVER_OPTION", SW_KEY_ALL_TEAM_EXP) or false  -- 服务器开关 是否开启全队经验 true/false
    GUI:setVisible(Team._ui["Text_exp"], memberCount > 1 and expSwitch or false)
    local expMemberCount = memberCount == 1 and 0 or memberCount
    GUI:Text_setString(Team._ui["Text_exp"], string.format("经验加成:%s%%", 100 + 10 * expMemberCount))

    if memberCount > 0 then
        GUI:setVisible(Team.Button_createTeam, false)
        GUI:setVisible(Team.Button_applyList, true)
        GUI:setVisible(Team.Button_call, true)
        GUI:setVisible(Team.Button_invite, true)
        GUI:setVisible(Team.Button_exit, true)
    else
        GUI:setVisible(Team.Button_createTeam, true)
        GUI:setVisible(Team.Button_applyList, false)
        GUI:setVisible(Team.Button_call, false)
        GUI:setVisible(Team.Button_invite, false)
        GUI:setVisible(Team.Button_exit, false)
    end

    local ListView_member = Team._ui["ListView_member"]
    GUI:ListView_removeAllItems(ListView_member)
    for _, member in pairs(teamMember) do
        local cell = Team.CreateMemberCell()
        GUI:ListView_pushBackCustomItem(ListView_member, cell)

        local cellUI = GUI:ui_delegate(cell)
        GUI:setVisible(cellUI["Image_leader"], member.Rand == 1)
        GUI:Text_setString(cellUI["Label_name"], member.sUserName)
        GUI:Text_setString(cellUI["Label_level"], member.Level)
        GUI:Text_setString(cellUI["Label_guild"], member.sGuildName)
        GUI:Text_setString(cellUI["Label_map"], member.MapName)
        GUI:Text_setString(cellUI["Label_job"], SL:GetMetaValue("JOB_NAME", member.Job))

        GUI:addOnClickEvent(cell, function()
            SL:OpenFuncDockTips({
                type = SL:GetMetaValue("DOCKTYPE_NENUM").Func_TeamLayer,
                targetId = member.UserID,
                targetName = member.sUserName,
                pos = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
            })
        end)
    end
end

function Team.CreateMemberCell()
    local parent = GUI:Node_Create(Team._ui["nativeUI"], "node", 0, 0)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/team/team_member_cell_win32")
    else
        GUI:LoadExport(parent, "social/team/team_member_cell")
    end
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

function Team.RefreshNearList()
    if Team._openPage ~= 2 then return end

    local ListView_near = Team._ui["ListView_near"]
    GUI:ListView_removeAllItems(ListView_near)

    local nearTeam = SL:GetMetaValue("TEAM_NEAR")
    local memberCount = SL:GetMetaValue("TEAM_COUNT")
    local memberMax = SL:GetMetaValue("TEAM_MAC_COUNT")

    for _, team in pairs(nearTeam) do
        if not SL:GetMetaValue("TEAM_IS_MEMBER", team.UserID) then
            local cell = Team.CreateNearMemberCell()
            GUI:ListView_pushBackCustomItem(ListView_near, cell)

            local cellUI = GUI:ui_delegate(cell)
            GUI:Text_setString(cellUI["Label_name"], team.sUserName)
            GUI:Text_setString(cellUI["Label_guild"], team.sGuildName)
            GUI:Text_setString(cellUI["Label_number"], team.Count)
            GUI:setVisible(cellUI["Button_operation"], memberCount == 0)
            GUI:setVisible(cellUI["Label_operation"], false)

            GUI:addOnClickEvent(cellUI["Button_operation"], function()
                if team.Count >= memberMax then
                    SL:ShowSystemTips("队伍已满")
                    return
                end

                GUI:setVisible(cellUI["Button_operation"], false)
                GUI:setVisible(cellUI["Label_operation"], true)

                SL:RequestApplyJoinTeam(team.UserID)
            end)
        end
    end
end

function Team.CreateNearMemberCell()
    local parent = GUI:Node_Create(Team._ui["nativeUI"], "node", 0, 0)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/team/team_near_member_cell_win32")
    else
        GUI:LoadExport(parent, "social/team/team_near_member_cell")
    end
    local member_cell = GUI:getChildByName(parent, "near_member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

-----------------------------------注册事件--------------------------------------
function Team.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team", Team.RefreshContent)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team", Team.RefreshContent)
end

function Team.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team")
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team")
end