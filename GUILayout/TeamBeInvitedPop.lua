TeamBeInvitedPop = {}

function TeamBeInvitedPop.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "social/team/team_beInvited")

    TeamBeInvitedPop._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamBeInvitedPop._ui["Panel_info"], posX, posY) 

    local data = data or {}

    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_close"], function()
        SL:RequestRefuseTeamInvite(data.UserID)
        SL:CloseTeamBeInvite()
    end)

    -- 同意
    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_agree"], function()
        if data.bMaster then
            SL:RequestAgreeTeamInvite(data.UserID)
        else
            SL:RequestApplyJoinTeam(data.GroupId)
        end
        SL:CloseTeamBeInvite()
    end)

    -- 拒绝
    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_disagree"], function()
        SL:RequestRefuseTeamInvite(data.UserID)
        SL:CloseTeamBeInvite()
    end)

    -- 提示内容
    local showStr = string.format("玩家%s邀请您进入队伍", data.sUserName)
    GUI:Text_setString(TeamBeInvitedPop._ui["Text_info"], showStr)
end