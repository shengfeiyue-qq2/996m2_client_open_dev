NearPlayer = {}
NearPlayerInfo = NearPlayerInfo or {} 

function NearPlayer.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    NearPlayerInfo._parent = parent
    NearPlayer.InitData()
    NearPlayer.InitUI() 
    NearPlayer.RegisterEvent()
    NearPlayer.RefreshList()
end

function NearPlayer.InitData()
    NearPlayerInfo._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
end

function NearPlayer.InitUI()
    GUI:LoadExport(NearPlayerInfo._parent, NearPlayerInfo._isWinMode and "social/near/near_player_win32" or "social/near/near_player")
    NearPlayerInfo._ui = GUI:ui_delegate(NearPlayerInfo._parent)
    NearPlayerInfo._layer = NearPlayerInfo._ui.nearPlayerLayer
    -- 允许添加
    if NearPlayerInfo._ui.CheckBox_add then
        GUI:CheckBox_setSelected(NearPlayerInfo._ui.CheckBox_add, FuncDockData.GetAllowAddFriend() == 1)
        GUI:CheckBox_addOnEvent(NearPlayerInfo._ui.CheckBox_add, function(sender)
            local isSelected = GUI:CheckBox_isSelected(NearPlayerInfo._ui.CheckBox_add)
            local status = isSelected and 1 or 0
            FuncDockData.SetAllowAddFriend(status)
        end)
    end

    -- 允许组队
    if NearPlayerInfo._ui.CheckBox_team then
        GUI:CheckBox_setSelected(NearPlayerInfo._ui.CheckBox_team, FuncDockData.GetAllowTeam() == 1)
        GUI:CheckBox_addOnEvent(NearPlayerInfo._ui.CheckBox_team, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            FuncDockData.SetAllowTeam(status)
        end)
    end

    -- 允许交易
    if NearPlayerInfo._ui.CheckBox_deal then
        GUI:CheckBox_setSelected(NearPlayerInfo._ui.CheckBox_deal, FuncDockData.GetAllowTrade() == 1)
        GUI:CheckBox_addOnEvent(NearPlayerInfo._ui.CheckBox_deal, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            FuncDockData.SetAllowTrade(status)
        end)
    end

    -- 允许挑战 (默认隐藏)
    if NearPlayerInfo._ui.CheckBox_challenge then
        GUI:setVisible(NearPlayerInfo._ui.CheckBox_challenge, false)
    end

    -- 允许显示
    if NearPlayerInfo._ui.CheckBox_show then
        if NearPlayerInfo._ui.CheckBox_challenge then -- 替代允许挑战位置
            GUI:setPosition(NearPlayerInfo._ui.CheckBox_show, GUI:getPosition(NearPlayerInfo._ui.CheckBox_challenge))
        end
        GUI:CheckBox_setSelected(NearPlayerInfo._ui.CheckBox_show, FuncDockData.GetAllowShowForNear() == 1)
        GUI:CheckBox_addOnEvent(NearPlayerInfo._ui.CheckBox_show, function(sender)
            local isSelected = GUI:CheckBox_isSelected(sender)
            local status = isSelected and 1 or 0
            FuncDockData.SetAllowShowForNear(status)
        end)
    end

    NearPlayer._cellWid = NearPlayerInfo._isWinMode and 500 or 600
    NearPlayer._cellHei = NearPlayerInfo._isWinMode and 24 or 40
end

function NearPlayer.RefreshList()
    GUI:removeAllChildren(NearPlayerInfo._ui.ListView_near)

    local members = {}
    local playerList = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i, v in ipairs(playerList) do
        -- 排除人形怪、有队伍的玩家
        if not SL:GetValue("ACTOR_IS_HUMAN", v) and SL:GetValue("ACTOR_NEAR_SHOW", v) then
            local item = {}
            item.job = SL:GetValue("ACTOR_JOB_ID", v)
            item.sex = SL:GetValue("ACTOR_SEX", v)
            item.uid = v
            item.name = SL:GetValue("ACTOR_NAME", v)
            item.level = SL:GetValue("ACTOR_LEVEL", v)
            item.guildID = SL:GetValue("ACTOR_GUILD_ID", v)
            item.guildName = SL:GetValue("ACTOR_GUILD_NAME", v)
            table.insert(members, item)
        end
    end

    for i, member in ipairs(members) do
        GUI:QuickCell_Create(NearPlayerInfo._ui.ListView_near, "member" .. i, 0, 0, NearPlayer._cellWid, NearPlayer._cellHei, function(parent)
            return NearPlayer.CreateMemberCell(parent, member)
        end)
    end
end

function NearPlayer.CreateMemberCell(parent, data)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/near/member_cell_win32")
    else
        GUI:LoadExport(parent, "social/near/member_cell")
    end
    local layout = GUI:getChildByName(parent, "Panel_near_member")

    local ui = GUI:ui_delegate(layout)
    if ui.Label_name then
        GUI:Text_setString(ui.Label_name, data.name)
    end

    if ui.Label_level then
        GUI:Text_setString(ui.Label_level, data.level)
    end

    if ui.Label_guild then
        GUI:Text_setString(ui.Label_guild, data.guildName)
    end

    if ui.Label_job then
        GUI:Text_setString(ui.Label_job, SL:GetValue("JOB_NAME", data.job))
    end

    if ui.Button_operation then
        GUI:addOnClickEvent(ui.Button_operation, function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestLookPlayer(data.uid)
        end)
    end

    GUI:addOnClickEvent(layout, function()
        UIOperator:OpenFuncDockTips({
            type = FuncDockData.FuncDockType.Func_Near_Player,
            targetId = data.uid,
            targetName = data.name,
            pos = {x = GUI:getTouchEndPosition(layout).x + 20, y = GUI:getTouchEndPosition(layout).y}
        })
    end)

    GUI:setVisible(layout, true)

    return layout
end

function NearPlayer.OnClose()
    if NearPlayerInfo and NearPlayerInfo._layer then 
        NearPlayer.UnRegisterEvent()
        NearPlayerInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function NearPlayer.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_NRAR_PLAYER_LAYER_CLOSE, "NearPlayer", NearPlayer.OnClose)
end

function NearPlayer.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_NRAR_PLAYER_LAYER_CLOSE, "NearPlayer")
end

NearPlayer.main()