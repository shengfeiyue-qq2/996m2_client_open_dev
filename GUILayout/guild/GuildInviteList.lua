GuildInviteList = {}

function GuildInviteList.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.GuildInviteListGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "guild/guild_invite_list")

    GuildInviteList._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(GuildInviteList._ui["Panel_1"], posX, posY)

    GUI:addOnClickEvent(GuildInviteList._ui["Button_close"], function()
        UIOperator:CloseGuildInviteListUI()
    end)

    GuildInviteList.RegisterEvent()

    GuildInviteList.OnInviteListUpdate()
end

function GuildInviteList.OnInviteListUpdate()
    local inviteList = SL:GetValue("GUILD_INVITE_JOIN_LIST") or {}

    local ListView = GuildInviteList._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)

    for _, v in ipairs(inviteList) do
        local cell = GuildInviteList.CreateInviteCell()
        GUI:ListView_pushBackCustomItem(ListView, cell)
        local cellUI = GUI:ui_delegate(cell)
        GUI:Text_setString(cellUI["Label_guildName"], v.guildName or "")
        GUI:Text_setString(cellUI["Label_masterName"], v.masterName or "")
        GUI:setVisible(cellUI["Button_disagree"], true)
        GUI:setVisible(cellUI["Label_agree"], false)
        GUI:setVisible(cellUI["Button_agree"], true)
        GUI:setVisible(cellUI["Label_disagree"], false)

        GUI:addOnClickEvent(cellUI["Button_disagree"], function(sender)
            GUI:delayTouchEnabled(sender)
            GUI:ListView_removeChild(ListView, cell)
            SL:RequestGuildRejectUserInvite(v.guildID, v.masterName)
            GuildInviteList:CheckInviteList()
        end)

        GUI:addOnClickEvent(cellUI["Button_agree"], function(sender)
            GUI:delayTouchEnabled(sender)
            GUI:ListView_removeChild(ListView, cell)
            if SL:GetValue("GUILD_IS_JOINED") then
                SL:ShowSystemTips("你已加入行会！")
            end
            SL:RequestGuildApproveUserInvite(v.guildID, v.masterName)
            GuildInviteList:CheckInviteList()
        end)
    end

end

function GuildInviteList.CreateInviteCell()
    local parent = GUI:Node_Create(GuildInviteList._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "guild/guild_invite_join_cell")
    local invite_cell = GUI:getChildByName(parent, "invite_cell")
    GUI:removeFromParent(invite_cell)
    GUI:removeFromParent(parent)
    return invite_cell
end

function GuildInviteList:CheckInviteList()
    local inviteList = SL:GetValue("GUILD_INVITE_JOIN_LIST") or {}
    if #inviteList == 0 then
        SL:DelBubbleTips(GUIDefine.BubbleType.GUILD_INVITE)
    end
end

-----------------------------------注册事件--------------------------------------
function GuildInviteList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_JOIN_INVITE, "GuildInviteList", GuildInviteList.OnInviteListUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildInviteList", GuildInviteList.UnRegisterEvent)
end

function GuildInviteList.UnRegisterEvent(ID)
    if ID ~= UIConst.LAYERID.GuildInviteListGUI then
        return
    end

    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_JOIN_INVITE, "GuildInviteList")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildInviteList")
end

GuildInviteList.main()
