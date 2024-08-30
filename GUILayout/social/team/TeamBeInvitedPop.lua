TeamBeInvitedPop = {}

function TeamBeInvitedPop.main()
    local data = GUI:GetLayerOpenParam() or {}
    GUI:SetLayerOpenParam(nil)
    local parent = GUI:Win_Create(UIConst.LAYERID.TeamBeInvitedPopGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/team/team_beInvited")

    TeamBeInvitedPop._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamBeInvitedPop._ui["Panel_info"], posX, posY) 


    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_close"], function()
        SL:RequestTeamInviteRefuse(data.UserID)
        UIOperator:CloseTeamBeInvite()
    end)

    -- 同意
    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_agree"], function()
        if SL:GetValue("TEAM_MEMBER_COUNT") > 0 then
            SL:ShowSystemTips("已有队伍，请退出当前队伍后重试")
            return
        end
        SL:RequestTeamInviteAgree(data.UserID)
        UIOperator:CloseTeamBeInvite()
    end)

    -- 拒绝
    GUI:addOnClickEvent(TeamBeInvitedPop._ui["Button_disagree"], function()
        SL:RequestTeamInviteRefuse(data.UserID)
        UIOperator:CloseTeamBeInvite()
    end)

    -- 提示内容
    local showStr = string.format("玩家%s邀请您进入队伍", data.UserName)
    GUI:Text_setString(TeamBeInvitedPop._ui["Text_info"], showStr)
end

TeamBeInvitedPop.main()