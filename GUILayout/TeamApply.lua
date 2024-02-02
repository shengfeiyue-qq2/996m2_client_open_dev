TeamApply = {}

function TeamApply.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "social/team/team_apply")

    TeamApply._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(TeamApply._ui["Panel_1"], posX, posY) 

    GUI:addOnClickEvent(TeamApply._ui["Button_close"], function()
        SL:CloseTeamApply()
    end)

    TeamApply.RegisterEvent()

    SL:RequestApplyData()
end

function TeamApply.OnTeamApplyUpdate()
    local members = {}
    local applyItems = SL:GetMetaValue("TEAM_APPLY")
    for index, v in pairs(applyItems or {}) do
        local uid = v.UserID
        if not members[uid] then
            local item = {}
            item.uid = v.UserID
            item.name = v.sUserName
            item.level = v.Level
            item.guildName = v.sGuildName
            item.index = index
            members[item.uid] = item
        end
    end

    table.sort(members, function(a, b)
        return a.index < b.index
    end)

    local ListView = TeamApply._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)

    for _, member in pairs(members) do
        local cell = TeamApply.CreateMemberCell()
        GUI:ListView_pushBackCustomItem(ListView, cell)

        local cellUI = GUI:ui_delegate(cell)
        GUI:Text_setString(cellUI["Label_name"], member.name)
        GUI:Text_setString(cellUI["Label_level"], member.level)
        GUI:Text_setString(cellUI["Label_guild"], member.guildName)
        GUI:setVisible(cellUI["Button_disagree"], true)
        GUI:setVisible(cellUI["Label_agree"], false)
        GUI:setVisible(cellUI["Button_agree"], true)
        GUI:setVisible(cellUI["Label_disagree"], false)

        GUI:addOnClickEvent(cellUI["Button_disagree"], function()
            SL:RequestRefuseTeamInvite(member.uid)
            GUI:ListView_removeChild(ListView, cell)
        end)

        GUI:addOnClickEvent(cellUI["Button_agree"], function()
            SL:RequestApplyAgree(member.uid)
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
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TeamApply", TeamApply.RemoveEvent)
end

function TeamApply.RemoveEvent(ID)
    if ID ~= "TeamApplyGUI" then
        return false
    end
    
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_APPLY_UPDATE, "TeamApply")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TeamApply")
end