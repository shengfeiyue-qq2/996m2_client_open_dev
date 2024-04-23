Team = {}

Team._type = 1     -- 1: 我的队伍; 2: 附近队伍

function Team.main(type)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "team/team")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    Team._ui = ui

    GUI:setPosition(ui["mainPanel"], 0 , 0)

    Team._type = type

    SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team", Team.UpdateMemberList)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team", Team.UpdateNearList)

    Team.InitEvent(ui)

    Team.SetBtnStatus()

    Team.UpdateUI()
end

function Team.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "Team")
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_NEAR_UPDATE, "Team")
end

function Team.InitEvent(ui)
    GUI:addOnClickEvent(ui.myTeamBtn, function ()
        if Team._type == 1 then
            return false
        end
        Team._type = 1
        Team.SetBtnStatus()
        Team.UpdateUI()
    end)

    GUI:addOnClickEvent(ui.nearTeamBtn, function ()
        if Team._type == 2 then
            return false
        end
        Team._type = 2
        Team.SetBtnStatus()
        Team.UpdateUI()
    end)

    GUI:addOnClickEvent(ui.createTeamBtn, function ()
        SL:CreateTeam()
    end)

    GUI:addOnClickEvent(ui.applyListBtn, function ()
        SL:OpenTeamApply()
    end)

    GUI:addOnClickEvent(ui.callBtn, function ()
        GUIShare.CallTeamFunc()
    end)

    GUI:addOnClickEvent(ui.inviteBtn, function ()
        SL:OpenTeamInvite()
    end)

    GUI:addOnClickEvent(ui.exitBtn, function ()
        SL:LeaveTeam()
    end)

    -- 允许组队
    local setID = 4001
    GUI:CheckBox_setSelected(ui.permitCheckBox, SL:CheckSet(setID) == 1)
    
    GUI:CheckBox_addOnEvent(ui.permitCheckBox, function (sender, eventType)
        local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
        SL:SetSettingValue(setID, {isSelected})
    end)
end

function Team.SetBtnStatus()
    local pColorID = 1025
    local nColorID = 1026

    local myTeamBtn = Team._ui["myTeamBtn"]
    if GUI:Win_IsNotNull(myTeamBtn) then
        local isPress = Team._type == 1

        GUI:Button_setBright(myTeamBtn, not isPress)
        SL:SetColorStyle(myTeamBtn, isPress and pColorID or nColorID)
    end

    local nearTeamBtn = Team._ui["nearTeamBtn"]
    if GUI:Win_IsNotNull(nearTeamBtn) then
        local isPress = Team._type == 2

        GUI:Button_setBright(nearTeamBtn, not isPress)
        SL:SetColorStyle(nearTeamBtn, isPress and pColorID or nColorID)
    end
end

function Team.UpdateUI()
    if Team._type == 2 then
        GUI:setVisible(Team._ui["nearTeamPanel"], true)
        GUI:setVisible(Team._ui["myTeamPanel"], false)

        SL:RequestNearTeam()
    elseif Team._type == 1 then
        GUI:setVisible(Team._ui["nearTeamPanel"], false)
        GUI:setVisible(Team._ui["myTeamPanel"], true)

        Team.UpdateMemberList()
    end
end

function Team.CreateMemberCell(parent, info)
    GUI:LoadExport(parent, "team/team_cell_my")
    local ui = GUI:ui_delegate(parent)

    GUI:setVisible(ui.Cell, true)
    GUI:setTouchEnabled(ui.Cell, true)

    local rand, uid, name, level, job, guildName, mapName = info.Rand, info.UserID, info.sUserName, info.Level, info.Job, info.sGuildName, info.MapName

    -- 队长标记
    GUI:setVisible(ui["leaderImg"], rand == 1)

    -- 名字
    GUI:Text_setString(ui["nameLabel"], name)

    -- 等级
    GUI:Text_setString(ui["levelLabel"], level)

    -- 职业
    local jobStr = job == 1 and "法师" or (job == 2 and "道士" or "战士")
    GUI:Text_setString(ui["jobLabel"], jobStr)

    -- 行会名字
    GUI:Text_setString(ui["guildLabel"], guildName or "无")
    
    -- 地图名字
    GUI:Text_setString(ui["mapLabel"], mapName)

    GUI:addOnClickEvent(ui.Cell, function ()
        SL:OpenFuncDockTips({
            type = SL:EnumDockType().Func_TeamLayer,
            targetId = uid,
            targetName = name,
            pos = {x = GUI:getTouchEndPosition(ui.Cell).x + 20, y = GUI:getTouchEndPosition(ui.Cell).y}
        })
    end)

    return ui.Cell
end

function Team.UpdateMemberList()
    if Team._type ~= 1 then
        return false
    end

    -- 队伍数量
    local memberCount = SL:GetTeamMemberCount()
    if memberCount > 0 then
        GUI:setVisible(Team._ui.noneTip, true)
        GUI:setVisible(Team._ui.expText, true)
        GUI:Text_setString(Team._ui.expText, string.format("经验加成:%s%%", 100 + 10 * (memberCount - 1)))

        GUI:setVisible(Team._ui.createTeamBtn, false)
        GUI:setVisible(Team._ui.applyListBtn, true)
        GUI:setVisible(Team._ui.callBtn, true)
        GUI:setVisible(Team._ui.inviteBtn, true)
        GUI:setVisible(Team._ui.exitBtn, true)
    else
        GUI:setVisible(Team._ui.noneTip, false)
        GUI:setVisible(Team._ui.expText, false)

        GUI:setVisible(Team._ui.createTeamBtn, true)
        GUI:setVisible(Team._ui.applyListBtn, false)
        GUI:setVisible(Team._ui.callBtn, false)
        GUI:setVisible(Team._ui.inviteBtn, false)
        GUI:setVisible(Team._ui.exitBtn, false)
    end

    local list = Team._ui.memberListView
    GUI:ListView_removeAllItems(list)

    local memberDatas = SL:GetMetaValue("TEAM_MEMBER_LIST")
    for k, info in ipairs(memberDatas) do
        GUI:QuickCell_Create(list, "Cell" .. k, 0, 0, 600, 48, function(parent) return Team.CreateMemberCell(parent, info) end)
    end
end

function Team.CreateNearCell(parent, info)
    GUI:LoadExport(parent, "team/team_cell_near")
    local ui = GUI:ui_delegate(parent)

    local uid, name, guildName, count = info.UserID, info.sUserName, info.sGuildName, info.Count

    -- 名字
    GUI:Text_setString(ui["nameLabel"], name)

    -- 行会名字
    GUI:Text_setString(ui["guildLabel"], guildName or "无")

    -- 数量
    GUI:Text_setString(ui["numberLabel"], count)

    local btnOperate = ui["operationButton"]
    local lblOperate = ui["operationLabel"]

    local memberCount = SL:GetTeamMemberCount()
    GUI:setVisible(btnOperate, memberCount == 0)
    GUI:setVisible(lblOperate, false)

    GUI:addOnClickEvent(btnOperate, function ()
        if count >= SL:GetMetaValue("TEAM_MAC_COUNT") then
            return SL:ShowSystemTips("队伍已满")
        end
        GUI:setVisible(btnOperate, false)
        GUI:setVisible(lblOperate, true)

        SL:RequestApllyTeam(uid)
    end)

    return ui.Cell
end

function Team.UpdateNearList(data)
    if Team._type ~= 2 then
        return false
    end

    local list = Team._ui.nearListView
    GUI:ListView_removeAllItems(list)

    for k, info in ipairs(data) do
        GUI:QuickCell_Create(list, "Cell" .. k, 0, 0, 600, 50, function(parent) return Team.CreateNearCell(parent, info) end)
    end
end