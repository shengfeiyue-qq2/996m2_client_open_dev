GuildApplyList = {}

local getJobStr = function (job)
    return ({[0] = "战士", [1] = "法师", [2] = "道士"})[job] or "其他"
end

function GuildApplyList.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_apply_list")
    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildApplyList._ui = ui

    GuildApplyList._list = ui["List"]
    
    GuildApplyList.AdaptUI(parent, ui)
    GuildApplyList.InitEvent()
    
    GUI:CheckBox_setSelected(ui["CheckBox"], SL:IsAutoJoinGuild())
    GUI:TextInput_setString(GuildApplyList._ui["Input"], SL:GetJoinLevel())

    SL:RegisterLUAEvent(LUA_EVENT_RESPONSE_APPLY_LIST, "GuildApplyList", GuildApplyList.UpdateUI)

    SL:RequestGuildInfo()
    SL:RequestApplyGuildList()
end

function GuildApplyList.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_RESPONSE_APPLY_LIST, "GuildApplyList")
end

function GuildApplyList.InitEvent()
    GUI:addOnClickEvent(GuildApplyList._ui["CloseButton"], function ()
        SL:CloseGuildApplyListUI()
        SL:OpenGuildMainUI(2)
    end)

    GUI:addOnClickEvent(GuildApplyList._ui["BtnAll"], function ()
        GUI:ListView_removeAllItems(GuildApplyList._list)
        GuildApplyList._cells = {}
        SL:RequestAddGuildMember()
    end)

    GUI:CheckBox_addOnEvent(GuildApplyList._ui["CheckBox"], function (sender)
        local auto  = GUI:CheckBox_isSelected(sender) and 1 or 0
        local level = GUI:TextInput_getString(GuildApplyList._ui["Input"])
        SL:SetAutoJoinGuild(auto, level)
        SL:RequestGuildInfo()
    end)

    GUI:TextInput_addOnEvent(GuildApplyList._ui["Input"], function (sender, eventType)
        if eventType == 3 then
            local auto  = GUI:CheckBox_isSelected(GuildApplyList._ui["CheckBox"]) and 1 or 0
            local level = GUI:TextInput_getString(sender)
            SL:SetAutoJoinGuild(auto, level)
            SL:RequestGuildInfo()
        end
    end)
end

function GuildApplyList.AdaptUI(parent, ui)
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local fLayout = ui["FrameLayout"]
    local cLayout = ui["CloseLayout"]

    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, fLayout)
        GUI:setMouseEnabled(fLayout, true)
        
        GUI:setVisible(cLayout, false)
    else
        GUI:setContentSize(cLayout, screenW, screenH)
        GUI:addOnClickEvent(cLayout, function ()
            GUI:Win_Close(parent)
        end)
        GUI:setVisible(cLayout, true)
    end

    GUI:setPosition(fLayout, screenW / 2, screenH / 2)
end

function GuildApplyList.CreateCell(parent, info)
    GUI:LoadExport(parent, "guild/guild_apply_cell")
    local ui = GUI:ui_delegate(parent)

    GUI:setVisible(ui.Cell, true)

    GUI:Text_setString(ui["username"], info.Name)
    GUI:Text_setString(ui["level"], info.Level)
    GUI:Text_setString(ui["job"], getJobStr(info.Job))

    local userID = info.UserID

    GUI:addOnClickEvent(ui["btnDisAgree"], function ()
        SL:RequestRefuseApplyMember(userID)
        GuildApplyList.RemoveCell(userID)
    end)

    GUI:addOnClickEvent(ui["btnAgree"], function ()
        SL:RequestAddApplyMember(userID)
        GuildApplyList.RemoveCell(userID)
    end)

    return ui.Cell
end

function GuildApplyList.RemoveCell(userID)
    local cell = GuildApplyList._cells[userID]
    if not cell then
        return false
    end
    GUI:ListView_removeChild(GuildApplyList._list, cell)
    GuildApplyList._cells[userID] = nil
end

function GuildApplyList.UpdateUI(data)
    GUI:ListView_removeAllItems(GuildApplyList._list)
    GuildApplyList._cells = {}
    for _,info in pairs(data) do
        local userID = info.UserID
        local quickCell = GUI:QuickCell_Create(GuildApplyList._list, "Cell" .. userID, 0, 0, 653, 50, function(parent) return GuildApplyList.CreateCell(parent, info) end)
        GuildApplyList._cells[userID] = quickCell
    end
end
