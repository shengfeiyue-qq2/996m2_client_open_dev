GuildMain = {}

function GuildMain.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_main")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildMain._ui = ui

    GUI:TextInput_addOnEvent(ui["Input"], GuildMain.OnEditNotice)

    SL:RegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_INFO, "GuildMain", GuildMain.UpdateUI)
    SL:RequestGuildInfo()
end

function GuildMain.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_INFO, "GuildMain")
end

function GuildMain.UpdateUI(data)
    if not data then
        return false
    end

    if not next(data) then
        return false
    end

    local notice = data.Notice or ""
    notice = string.len(notice) > 0 and notice or (SL:GetGameData("announce") or "")
    notice = string.gsub(notice, "\\r", "\r")

    local input = GuildMain._ui["Input"]
    GUI:setTouchEnabled(input, SL:GetMetaValue("IS_MASTER"))
    GUI:TextInput_setString(input, notice)

    -- 行会名字
    GUI:Text_setString(GuildMain._ui["GuildName"], data.Name)

    -- 会长
    GUI:Text_setString(GuildMain._ui["MasterName"], data.GuildMaster)
end

function GuildMain.OnEditNotice(sender, eventType)
    if eventType ~= 1 then
        return false
    end

    if SL:GetMetaValue("M2_FORBID_SAY", true) then
        return false
    end
    
    local inputStr = GUI:TextInput_getString(sender)
    SL:CheckSensitive(inputStr, function () SL:RequestEditNotice(inputStr) end)
end