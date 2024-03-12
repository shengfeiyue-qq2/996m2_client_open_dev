TeamBeInvitedPop = {}

TeamBeInvitedPop._data = nil

function TeamBeInvitedPop.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "team/team_beInvited_pop")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    TeamBeInvitedPop._ui = ui

    TeamBeInvitedPop.AdaptUI(parent, ui)

    TeamBeInvitedPop._data = data

    -- 文本
    local TextInfo = ui["TextInfo"]
    GUI:Text_setString(TextInfo, string.format("玩家%s邀请您进入队伍", data.sUserName))

    -- 拒绝申请
    local BtnDisAgree = ui["BtnDisAgree"]
    GUI:addOnClickEvent(BtnDisAgree, TeamBeInvitedPop.onRefuseTeamApply)

    -- 同意申请
    local BtnAgree = ui["BtnAgree"]
    GUI:addOnClickEvent(BtnAgree, TeamBeInvitedPop.onAgreeTeamApply)

    -- 拒绝申请
    local BtnClose = ui["BtnClose"]
    GUI:addOnClickEvent(BtnClose, TeamBeInvitedPop.onRefuseTeamApply)
end

function TeamBeInvitedPop.AdaptUI(parent, ui)
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local PMainUI = ui["PMainUI"]
    GUI:setPosition(PMainUI, screenW / 2, screenH / 2)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end
end

function TeamBeInvitedPop.onRefuseTeamApply()
    local data = TeamBeInvitedPop._data and TeamBeInvitedPop._data
    if not data then
        return false
    end

    SL:RefuseTeamApply(data.UserID)
    SL:CloseTeamBeInvitePop()
end

function TeamBeInvitedPop.onAgreeTeamApply()
    local data = TeamBeInvitedPop._data and TeamBeInvitedPop._data
    if not data then
        return false
    end

    if data.bMaster then
        SL:AgreeToTeam(data.UserID)
    else
        SL:RequestApllyTeam(data.GroupId)
    end

    SL:CloseTeamBeInvitePop()
end