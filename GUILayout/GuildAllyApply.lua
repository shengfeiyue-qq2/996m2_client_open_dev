GuildAllyApply = {}

function GuildAllyApply.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_ally_apply")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildAllyApply._ui = ui
    
    GuildAllyApply._list = ui["List"]

    GuildAllyApply.AdaptUI(parent, ui)

    SL:RegisterLUAEvent(LUA_EVENT_RESPONSE_ALLY_APPLY_LIST, "GuildAllyApply", GuildAllyApply.UpdateUI)
    
    GUI:addOnClickEvent(ui["CloseButton"], function () SL:CloseGuildAllyApplyUI() end)

    SL:RequestGuildAllyApplyList()
end

function GuildAllyApply.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_RESPONSE_ALLY_APPLY_LIST, "GuildAllyApply")
end

function GuildAllyApply.AdaptUI(parent, ui)
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

    GUI:addOnClickEvent(ui["CloseButton"], function ()
        SL:CloseGuildCreateUI()
        SL:OpenGuildMainUI()
    end)
end

function GuildAllyApply.CreateCell(parent, info)
    GUI:LoadExport(parent, "guild/guild_ally_apply_cell")
    local ui = GUI:ui_delegate(parent)

    GUI:setVisible(ui.Cell, true)

    local sliceStr = SL:Split(SL:GetGameData("alliance_time"), "#")

    GUI:removeAllChildren(ui["Node_tips"])
    local str = string.format("<font color='#28ef01'>%s</font>向您发起结盟申请, 持续<font color='#28ef01'>%s小时</font>", info.n, sliceStr[info.t])
    local richText = GUI:RichText_Create(ui["Node_tips"], "rTips", 0, 0, str, 400, 16, "#ffffff")
    GUI:setAnchorPoint(richText, 0, 0.5)

    local guildID = info.i

    GUI:addOnClickEvent(ui["btnDisAgree"], function ()
        SL:RequestAllyOperate(guildID, 2)
        GuildAllyApply.RemoveCell(guildID)
    end)

    GUI:addOnClickEvent(ui["btnAgree"], function ()
        SL:RequestAllyOperate(guildID, 1)
        GuildAllyApply.RemoveCell(guildID)
    end)

    return ui.Cell
end

function GuildAllyApply.RemoveCell(guildID)
    local cell = GuildAllyApply._cells[guildID]
    if not cell then
        return false
    end
    GUI:ListView_removeChild(GuildAllyApply._list, cell)
    GuildAllyApply._cells[guildID] = nil
end

function GuildAllyApply.UpdateUI(data)
    local list = GuildAllyApply._list
    GUI:ListView_removeAllItems(GuildAllyApply._list)

    GuildAllyApply._cells = {}
    for _,info in pairs(data) do
        local guildID = info.i
        local quickCell = GUI:QuickCell_Create(GuildAllyApply._list, "Cell" .. guildID, 0, 0, 653, 50, function(parent) return GuildAllyApply.CreateCell(parent, info) end)
        GuildAllyApply._cells[guildID] = quickCell
    end
end