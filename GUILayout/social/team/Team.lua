Team = {}

TeamInfo = TeamInfo or {} 

function Team.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    TeamInfo._parent = parent
    Team.InitData()
    Team.InitUI() 
    Team.RefreshBtn()
    Team.Refresh()
    Team.RegisterEvent()
end

function Team.InitData()
    TeamInfo._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    TeamInfo._pageType = {
        MyTeam = 1,
        NearTeam = 2
    }
    TeamInfo._openPage =  TeamInfo._pageType.MyTeam
end

function Team.InitUI()
    GUI:LoadExport(TeamInfo._parent, TeamInfo._isWinMode and "social/team/team_win32" or "social/team/team")
    TeamInfo._ui = GUI:ui_delegate(TeamInfo._parent)
    TeamInfo._layer = TeamInfo._ui.teamLayer
    -- 我的队伍
    GUI:addOnClickEvent(TeamInfo._ui.Button_myTeam, function()
        if TeamInfo._openPage == TeamInfo._pageType.MyTeam then
            return
        end
        TeamInfo._openPage = TeamInfo._pageType.MyTeam
        Team.RefreshBtn()
        Team.Refresh()
    end)

    -- 附近队伍
    GUI:addOnClickEvent(TeamInfo._ui.Button_nearTeam, function()
        if TeamInfo._openPage == TeamInfo._pageType.NearTeam then
            return
        end
        TeamInfo._openPage = TeamInfo._pageType.NearTeam
        Team.RefreshBtn()
        Team.Refresh()
    end)

    -- 创建队伍
    GUI:addOnClickEvent(TeamInfo._ui.Button_createTeam, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestCreateTeam()
    end)

    -- 申请列表
    GUI:addOnClickEvent(TeamInfo._ui.Button_applyList, function()
        UIOperator:OpenTeamApply()
    end)

    -- 召集队友
    GUI:addOnClickEvent(TeamInfo._ui.Button_call, function()
        FuncDockData.TeamCallFunc()
    end)

    -- 邀请成员
    GUI:addOnClickEvent(TeamInfo._ui.Button_invite, function()
        UIOperator:OpenTeamInvite()
    end)

    -- 离开队伍
    GUI:addOnClickEvent(TeamInfo._ui.Button_exit, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestLeaveTeam()
    end)

    -- 允许组队
    GUI:CheckBox_setSelected(TeamInfo._ui.CheckBox_permit, FuncDockData.GetAllowTeam() == 1)
    GUI:CheckBox_addOnEvent(TeamInfo._ui.CheckBox_permit, function(sender)
        local isSelected = GUI:CheckBox_isSelected(sender)
        local status = isSelected and 1 or 0
        FuncDockData.SetAllowTeam(status)
    end)
end

function Team.RefreshBtn()
    GUI:Button_setBright(TeamInfo._ui.Button_myTeam, TeamInfo._openPage ~= TeamInfo._pageType.MyTeam)
    GUI:Button_setBright(TeamInfo._ui.Button_nearTeam, TeamInfo._openPage ~= TeamInfo._pageType.NearTeam)
    GUI:Button_setTitleColor(TeamInfo._ui.Button_myTeam, TeamInfo._openPage == TeamInfo._pageType.MyTeam and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(TeamInfo._ui.Button_nearTeam, TeamInfo._openPage == TeamInfo._pageType.NearTeam and "#f8e6c6" or "#6c6861")
end

function Team.Refresh()
    GUI:setVisible(TeamInfo._ui.Panel_myTeam, TeamInfo._openPage == TeamInfo._pageType.MyTeam)
    GUI:setVisible(TeamInfo._ui.Panel_nearTeam, TeamInfo._openPage == TeamInfo._pageType.NearTeam)
    if TeamInfo._openPage == TeamInfo._pageType.NearTeam then
        SL:RequestNearTeam()
    end

    Team.RefreshContent()
end

function Team.RefreshContent()
    if TeamInfo._openPage == TeamInfo._pageType.MyTeam then
        Team.RefreshMemberList()

    elseif TeamInfo._openPage == TeamInfo._pageType.NearTeam then
        Team.RefreshNearList()
    end
end

function Team.RefreshMemberList()
    if TeamInfo._openPage ~= TeamInfo._pageType.MyTeam then return end

    local teamMember = SL:GetValue("TEAM_MEMBER_LIST")
    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
    GUI:setVisible(TeamInfo._ui.Image_none, memberCount == 0)

    local expSwitch = SL:GetValue("SERVER_OPTION", SW_KEY_ALL_TEAM_EXP) or false  -- 服务器开关 是否开启全队经验 true/false
    GUI:setVisible(TeamInfo._ui.Text_exp, memberCount > 1 and expSwitch or false)
    local expMemberCount = memberCount == 1 and 0 or memberCount
    GUI:Text_setString(TeamInfo._ui.Text_exp, string.format("经验加成:%s%%", 100 + 10 * expMemberCount))

    if memberCount > 0 then
        GUI:setVisible(TeamInfo._ui.Button_createTeam, false)
        GUI:setVisible(TeamInfo._ui.Button_applyList, true)
        GUI:setVisible(TeamInfo._ui.Button_call, true)
        GUI:setVisible(TeamInfo._ui.Button_invite, true)
        GUI:setVisible(TeamInfo._ui.Button_exit, true)
    else
        GUI:setVisible(TeamInfo._ui.Button_createTeam, true)
        GUI:setVisible(TeamInfo._ui.Button_applyList, false)
        GUI:setVisible(TeamInfo._ui.Button_call, false)
        GUI:setVisible(TeamInfo._ui.Button_invite, false)
        GUI:setVisible(TeamInfo._ui.Button_exit, false)
    end

    local ListView_member = TeamInfo._ui.ListView_member
    GUI:ListView_removeAllItems(ListView_member)
    for _, member in pairs(teamMember) do
        local cell = Team.CreateMemberCell()
        GUI:ListView_pushBackCustomItem(ListView_member, cell)

        local guildName = "无"
        if member.GuildName and member.GuildName ~= "" then 
            guildName = member.GuildName
        end
        local cellUI = GUI:ui_delegate(cell)
        GUI:setVisible(cellUI.Image_leader, member.Rank == 1)
        GUI:Text_setString(cellUI.Label_name, member.UserName)
        GUI:Text_setString(cellUI.Label_level, member.Level)
        GUI:Text_setString(cellUI.Label_guild, guildName)
        GUI:Text_setString(cellUI.Label_map, member.Map)
        GUI:Text_setString(cellUI.Label_job, SL:GetValue("JOB_NAME", member.Job))

        GUI:addOnClickEvent(cell, function()
            UIOperator:OpenFuncDockTips({
                type = FuncDockData.FuncDockType.Func_Team,
                targetId = member.UserID,
                targetName = member.UserName,
                pos = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
            })
        end)
    end
end

function Team.CreateMemberCell()
    local parent = GUI:Node_Create(TeamInfo._ui.nativeUI, "node", 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
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
    if TeamInfo._openPage ~= TeamInfo._pageType.NearTeam then return end

    local ListView_near = TeamInfo._ui.ListView_near
    GUI:ListView_removeAllItems(ListView_near)

    local nearTeam = SL:GetValue("TEAM_NEAR")
    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
    local memberMax = SL:GetValue("TEAM_MEMBER_MAX_COUNT")
    for _, team in pairs(nearTeam) do
        if not SL:GetValue("TEAM_IS_MEMBER", team.UserID) then
            local cell = Team.CreateNearMemberCell()
            GUI:ListView_pushBackCustomItem(ListView_near, cell)

            local guildName = "无"
            if team.GuildName and team.GuildName ~= "" then 
                guildName = member.GuildName
            end
            local cellUI = GUI:ui_delegate(cell)
            GUI:Text_setString(cellUI.Label_name, team.MasterName)
            GUI:Text_setString(cellUI.Label_guild, guildName)
            GUI:Text_setString(cellUI.Label_number, team.MemCount)
            GUI:setVisible(cellUI.Button_operation, memberCount == 0)
            GUI:setVisible(cellUI.Label_operation, false)

            GUI:addOnClickEvent(cellUI.Button_operation, function(sender)
                if team.MemCount >= memberMax then
                    SL:ShowSystemTips("队伍已满")
                    return
                end

                GUI:setVisible(cellUI.Button_operation, false)
                GUI:setVisible(cellUI.Label_operation, true)
                SL:RequestApplyJoinTeam(team.MasterID)
                GUI:delayTouchEnabled(sender)
            end)
        end
    end
end

function Team.CreateNearMemberCell()
    local parent = GUI:Node_Create(TeamInfo._ui.nativeUI, "node", 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/team/team_near_member_cell_win32")
    else
        GUI:LoadExport(parent, "social/team/team_near_member_cell")
    end
    local member_cell = GUI:getChildByName(parent, "near_member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

function Team.OnClose()
    if TeamInfo and TeamInfo._layer then 
        Team.UnRegisterEvent()
        TeamInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function Team.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team", Team.RefreshContent)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team", Team.RefreshContent)
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_LAYER_CLOSE, "Team", Team.OnClose)
end

function Team.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team")
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team")
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_LAYER_CLOSE, "Team")
end

Team.main()