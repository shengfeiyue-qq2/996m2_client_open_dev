TeamApply = {}

function TeamApply.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.TeamApplyGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/team/team_apply")

    TeamApply._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamApply._ui["Panel_1"], posX, posY) 

    GUI:addOnClickEvent(TeamApply._ui["Button_close"], function()
        UIOperator:CloseTeamApply()
    end)

    TeamApply.RegisterEvent()

    TeamApply.OnTeamApplyUpdate()
end

function TeamApply.OnTeamApplyUpdate()
    local applyItems = SL:GetValue("TEAM_APPLY")

    local ListView = TeamApply._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)

    for _, member in pairs(applyItems) do
        local cell = TeamApply.CreateMemberCell()
        GUI:ListView_pushBackCustomItem(ListView, cell)
        local guildName = "无"
        if member.GuildName and member.GuildName ~= "" then 
            guildName = member.GuildName
        end
        local cellUI = GUI:ui_delegate(cell)
        GUI:Text_setString(cellUI["Label_name"], member.UserName)
        GUI:Text_setString(cellUI["Label_level"], member.Level)
        GUI:Text_setString(cellUI["Label_guild"], guildName)
        GUI:setVisible(cellUI["Button_disagree"], true)
        GUI:setVisible(cellUI["Label_agree"], false)
        GUI:setVisible(cellUI["Button_agree"], true)
        GUI:setVisible(cellUI["Label_disagree"], false)

        GUI:addOnClickEvent(cellUI["Button_disagree"], function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestTeamApplyRefuse(member.UserID)
            GUI:ListView_removeChild(ListView, cell)
        end)

        GUI:addOnClickEvent(cellUI["Button_agree"], function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestTeamApplyAgree(member.UserID)
            GUI:ListView_removeChild(ListView, cell)
        end)
    end
end

function TeamApply.CreateMemberCell()
    local parent = GUI:Node_Create(TeamApply._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "social/team/team_apply_member_cell")
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

-----------------------------------注册事件--------------------------------------
function TeamApply.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_APPLY_UPDATE, "TeamApply", TeamApply.OnTeamApplyUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TeamApply", TeamApply.UnRegisterEvent)
end

function TeamApply.UnRegisterEvent(ID)
    if ID ~= UIConst.LAYERID.TeamApplyGUI then
        return 
    end
    
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_APPLY_UPDATE, "TeamApply")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TeamApply")
end

TeamApply.main()