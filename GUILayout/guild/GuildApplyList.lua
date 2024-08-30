GuildApplyList = {}

function GuildApplyList.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GuildApplyListGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildApplyListGUI, 0, 0, 0, 0, false, false, true, true)
    GuildApplyList._layer = parent
    GUI:LoadExport(parent, "guild/guild_apply_list")

    GuildApplyList._parent = parent
    GuildApplyList._ui = GUI:ui_delegate(parent)
    GuildApplyList._cells = {}

    local mainPanel = GuildApplyList._ui["PMainUI"]
    local closeLayout = GuildApplyList._ui["CloseLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPosition(mainPanel, winSizeW / 2, winSizeH / 2)

    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:setVisible(closeLayout, false)
        GUI:setPosition(mainPanel, winSizeW / 2, SL:GetValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, mainPanel)
        GUI:Win_SetZPanel(parent, mainPanel)
    else
        -- 全屏关闭
        GUI:setVisible(closeLayout, true)
        GUI:addOnClickEvent(closeLayout,function()
            UIOperator:CloseGuildApplyListUI()
        end)
    end

    GUI:addOnClickEvent(GuildApplyList._ui.CloseButton, function()
        UIOperator:CloseGuildApplyListUI()
    end)

    SL:RequestGuildApplyList()

    GuildApplyList.InitUI()
    GuildApplyList.RegisterEvent()
end

function GuildApplyList.InitUI()
    GUI:addOnClickEvent(GuildApplyList._ui.BtnAll, function(sender)
        GUI:delayTouchEnabled(sender)
        GUI:ListView_removeAllItems(GuildApplyList._ui.ListView)
        GuildApplyList._cells = {}
        SL:RequestGuildApproveAllUsersApply()
        SL:DelBubbleTips(GUIDefine.BubbleType.GUILD_APPLY)
    end)

    GUI:CheckBox_setSelected(GuildApplyList._ui.CheckBox, SL:GetValue("GUILD_AUTO_APPROVE_APPLY"))
    GUI:CheckBox_addOnEvent(GuildApplyList._ui.CheckBox, function()
        SL:RequestGuildAutoApply(GUI:CheckBox_isSelected(GuildApplyList._ui.CheckBox))
    end)

    GUI:TextInput_setString(GuildApplyList._ui.Input, SL:GetValue("GUILD_AUTO_APPROVE_LEVEL"))
    GUI:TextInput_addOnEvent(GuildApplyList._ui.Input, function(sender, eventType)
        local input = tonumber(GUI:TextInput_getString(sender)) or 0
        local maxLevel = SL:GetValue("GUILD_AUTO_APPROVE_MAX_LEVEL")
        if maxLevel then
            input = math.min(input, maxLevel)
            GUI:TextInput_setString(GuildApplyList._ui.Input, input)
        end
        if eventType == 3 then
            -- 自动同意等级设置
            local autoLevel = tonumber(GUI:TextInput_getString(sender))
            SL:RequestGuildSetAutoJoinLevel(autoLevel)
        end
    end)
end

function GuildApplyList.RefreshApplyList()
    GUI:ListView_removeAllItems(GuildApplyList._ui.ListView)
    GuildApplyList._cells = {}

    local applyList = SL:GetValue("GUILD_APPLY_LIST")
    for i, info in pairs(applyList) do
        local cell = GuildApplyList.CreateApplyCell(info)
        GUI:ListView_pushBackCustomItem(GuildApplyList._ui.ListView, cell)
        GuildApplyList._cells[info.UserID] = cell
    end
end

function GuildApplyList.CreateApplyCell(info)
    local parent = GUI:Widget_Create(-1, "widget" .. info.UserID, 0, 0)
    GUI:LoadExport(parent, "guild/guild_apply_cell")
    local cell = GUI:getChildByName(parent, "ListCell")

    local ui_name = GUI:getChildByName(cell, "username")
    GUI:Text_setString(ui_name, info.UserName)

    local ui_level = GUI:getChildByName(cell, "level")
    GUI:Text_setString(ui_level, info.Level)

    local ui_job = GUI:getChildByName(cell, "job")
    GUI:Text_setString(ui_job, SL:GetValue("JOB_NAME", info.Job))

    local btnAgree = GUI:getChildByName(cell, "btnAgree")
    GUI:addOnClickEvent(btnAgree, function(sender)
        GUI:delayTouchEnabled(sender)
        -- 同意添加行会成员
        SL:RequestGuildApproveUserApply(info.UserID)
        GuildApplyList.RemoveApplyCell(info.UserID)
    end)

    local btnDisAgree = GUI:getChildByName(cell, "btnDisAgree")
    GUI:addOnClickEvent(btnDisAgree, function(sender)
        GUI:delayTouchEnabled(sender)
        -- 拒绝添加行会成员
        SL:RequestGuildRejectUserApply(info.UserID)
        GuildApplyList.RemoveApplyCell(info.UserID)
    end)

    GUI:removeFromParent(cell)
    return cell
end

function GuildApplyList.RemoveApplyCell(userID)
    local cell = GuildApplyList._cells[userID]
    if cell then
        GUI:ListView_removeChild(GuildApplyList._ui.ListView, cell)
        GuildApplyList._cells[userID] = nil
    end
end

------------------------------------------------------------------------------
function GuildApplyList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPLYLIST, "GuildApplyList", GuildApplyList.RefreshApplyList, GuildApplyList._layer)
end
-------------------------------------------------------------------------------

GuildApplyList.main()