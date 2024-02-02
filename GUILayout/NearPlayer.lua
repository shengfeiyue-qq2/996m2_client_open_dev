NearPlayer = {}

function NearPlayer.main()
    local parent = GUI:Attach_Parent()

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/near/near_player_win32")
    else
        GUI:LoadExport(parent, "social/near/near_player")
    end
    NearPlayer._ui = GUI:ui_delegate(parent)

    --允许添加
    local CheckBox_add = NearPlayer._ui.CheckBox_add
    if CheckBox_add then
        GUI:CheckBox_setSelected(CheckBox_add, SL:GetMetaValue("ADD_STATUS_PERMIT") == 1)
        GUI:CheckBox_addOnEvent(CheckBox_add, function(sender)
            local isSelected = GUI:CheckBox_isSelected(CheckBox_add)
            local status = isSelected and 1 or 0
            SL:SetMetaValue("ADD_STATUS_PERMIT", status)
        end)
    end

    -- 允许组队
    local CheckBox_team = NearPlayer._ui.CheckBox_team
    if CheckBox_team then
        GUI:CheckBox_setSelected(CheckBox_team, SL:GetMetaValue("TEAM_STATUS_PERMIT") == 1)
        GUI:CheckBox_addOnEvent(CheckBox_team, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            SL:SetMetaValue("TEAM_STATUS_PERMIT", status)
        end)
    end

    --允许交易
    local CheckBox_deal = NearPlayer._ui.CheckBox_deal
    if CheckBox_deal then
        GUI:CheckBox_setSelected(CheckBox_deal, SL:GetMetaValue("DEAL_STATUS_PERMIT") == 1)
        GUI:CheckBox_addOnEvent(CheckBox_deal, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            SL:SetMetaValue("DEAL_STATUS_PERMIT", status)
        end)
    end

    --允许挑战 (默认隐藏)
    local CheckBox_challenge = NearPlayer._ui.CheckBox_challenge
    if CheckBox_challenge then
        GUI:setVisible(CheckBox_challenge, false)
    end

    --允许显示
    local CheckBox_show = NearPlayer._ui.CheckBox_show
    if CheckBox_show then
        if CheckBox_challenge then -- 替代允许挑战位置
            GUI:setPosition(CheckBox_show, GUI:getPosition(CheckBox_challenge))
        end
        GUI:CheckBox_setSelected(CheckBox_show, SL:GetMetaValue("SHOW_STATUS_PERMIT") == 1)
        GUI:CheckBox_addOnEvent(CheckBox_show, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            SL:SetMetaValue("SHOW_STATUS_PERMIT", status)
        end)
    end

    NearPlayer.RefreshList()
end

function NearPlayer.RefreshList()
    GUI:removeAllChildren(NearPlayer._ui.ListView_near)

    local members = {}
    local nearPlayer = SL:FindPlayerInCurrViewField()
    for _, v in pairs(nearPlayer) do
        -- 排除人形怪、有队伍的玩家
        if not SL:GetMetaValue("ACTOR_IS_HUMAN", v) and SL:GetMetaValue("ACTOR_NEAR_SHOW", v) then
            local item = {}
            item.job = SL:GetMetaValue("ACTOR_JOB_ID", v)
            item.sex = SL:GetMetaValue("ACTOR_SEX", v)
            item.uid = SL:GetMetaValue("ACTOR_ID", v)
            item.name = SL:GetMetaValue("ACTOR_NAME", v)
            item.level = SL:GetMetaValue("ACTOR_LEVEL", v)
            item.guildID = SL:GetMetaValue("ACTOR_GUILD_ID", v)
            item.guildName = SL:GetMetaValue("ACTOR_GUILD_NAME", v)
            table.insert(members, item)
        end
    end

    for idx, member in ipairs(members) do
        local cell = NearPlayer.CreateMemberCell(member)
        GUI:ListView_pushBackCustomItem(NearPlayer._ui.ListView_near, cell)
    end

end

function NearPlayer.CreateMemberCell(data)
    local node = GUI:Node_Create(-1, "Node", 0, 0)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(node, "social/near/member_cell_win32")
    else
        GUI:LoadExport(node, "social/near/member_cell")
    end
    local layout = GUI:getChildByName(node, "Panel_near_member")
    if not layout then
        return
    end

    local ui = GUI:ui_delegate(layout)
    local Label_name = ui.Label_name
    if Label_name then
        GUI:Text_setString(Label_name, data.name)
    end

    local Label_level = ui.Label_level
    if Label_level then
        GUI:Text_setString(Label_level, data.level)
    end

    local Label_guild = ui.Label_guild
    if Label_guild then
        GUI:Text_setString(Label_guild, data.guildName)
    end

    local Label_job = ui.Label_job
    if Label_job then
        GUI:Text_setString(Label_job, SL:GetMetaValue("JOB_NAME", data.job))
    end

    local Button_operation = ui.Button_operation
    if Button_operation then
        GUI:addOnClickEvent(Button_operation, function(sender)
            SL:RequestLookPlayer(data.uid)
        end)
    end

    GUI:addOnClickEvent(layout, function()
        SL:OpenFuncDockTips({
            type = SL:GetMetaValue("DOCKTYPE_NENUM").Func_Near_Player,
            targetId = data.uid,
            targetName = data.name,
            pos = {x = GUI:getTouchEndPosition(layout).x + 20, y = GUI:getTouchEndPosition(layout).y}
        })
    end)

    GUI:setVisible(layout, true)
    GUI:removeFromParent(layout)
    return layout
end