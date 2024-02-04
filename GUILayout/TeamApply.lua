TeamApply = {}

function TeamApply.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "team/team_apply")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    TeamApply._ui = ui

    TeamApply._list = ui["ListView"]

    TeamApply.AdaptUI(parent, ui)

    SL:RegisterLUAEvent(LUA_EVENT_TEAM_APPLY_LIST, "TeamApply", TeamApply.UpdateUI)
    
    GUI:addOnClickEvent(ui["closeBtn"], function () SL:CloseTeamApply() end)

    SL:RequestApplyList()
end

function TeamApply.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_TEAM_APPLY_LIST, "TeamApply")
end

function TeamApply.AdaptUI(parent, ui)
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    GUI:setContentSize(ui["MaskLayout"], screenW, screenH)

    local bgPanel = ui["bgPanel"]
    GUI:setPosition(bgPanel, screenW/2, screenH/2)

    if SL:IsWinMode() then
        GUI:setTouchEnabled(bgPanel, true)
        GUI:Win_SetDrag(parent, bgPanel)
        GUI:setMouseEnabled(bgPanel, true)
    end
end

function TeamApply.CreateCell(parent, info)
    GUI:LoadExport(parent, "team/team_apply_cell")
    local ui = GUI:ui_delegate(parent)

    GUI:setVisible(ui.Cell, true)

    local uid, name, level, guildName = info.UserID, info.sUserName, info.Level, info.guildName

    -- 名字
    GUI:Text_setString(ui["nameLabel"], name)

    -- 等级
    GUI:Text_setString(ui["levelLabel"], level)

    -- 行会名字
    GUI:Text_setString(ui["guildLabel"], guildName or "无")

    GUI:addOnClickEvent(ui["disagreeBtn"], function ()
        SL:RefuseTeamApply(uid)
        TeamApply.RemoveCell(uid)
    end)

    GUI:addOnClickEvent(ui["agreeBtn"], function ()
        SL:AgreeTeamApply(uid)
        TeamApply.RemoveCell(uid)
    end)

    return ui.Cell
end

function TeamApply.RemoveCell(uid)
    local cell = TeamApply._cells[uid]
    if not cell then
        return false
    end
    GUI:ListView_removeChild(TeamApply._list, cell)
    TeamApply._cells[uid] = nil
end

function TeamApply.UpdateUI(data)
    local list = TeamApply._list
    GUI:ListView_removeAllItems(TeamApply._list)

    TeamApply._cells = {}
    for k, info in ipairs(data) do
        local quickCell = GUI:QuickCell_Create(list, "Cell" .. k, 0, 0, 600, 48, function(parent) return TeamApply.CreateCell(parent, info) end)
        TeamApply._cells[info.UserID] = quickCell
    end
end