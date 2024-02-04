GuildFrame = {}

function GuildFrame.main( skipPage )
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_frame")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end

    GuildFrame.AdaptUI(parent, ui)

    local isJoinGuild = SL:GetMetaValue("IS_IN_GUILD")
    if isJoinGuild then
        GuildFrame.PageTo(1)
    else
        GUI:setVisible(ui["Page1"], false)
        GUI:setVisible(ui["Page2"], false)
        GUI:setVisible(ui["Page3"], false)
        GuildFrame.PageTo(3)
    end

    GUI:addOnClickEvent(ui["Page1"], function ()
        GuildFrame.PageTo(1)
    end)

    GUI:addOnClickEvent(ui["Page2"], function ()
        GuildFrame.PageTo(2)
    end)

    GUI:addOnClickEvent(ui["Page3"], function ()
        GuildFrame.PageTo(3)
    end)

    if skipPage then
        return GuildFrame.PageTo(skipPage)
    end
end

function GuildFrame.AdaptUI(parent, ui)
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local function close()
        GUI:Win_Close(parent)
    end

    local fLayout = ui["FrameLayout"]
    local cLayout = ui["CloseLayout"]

    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, fLayout)
        GUI:setMouseEnabled(fLayout, true)
        
        GUI:setVisible(cLayout, false)
    else
        GUI:setContentSize(cLayout, screenW, screenH)
        GUI:addOnClickEvent(cLayout, close)
        GUI:setVisible(cLayout, true)
    end

    GUI:addOnClickEvent(ui["CloseButton"], close)
end

function GuildFrame.PageTo(index)
    GuildFrame.index = index
end