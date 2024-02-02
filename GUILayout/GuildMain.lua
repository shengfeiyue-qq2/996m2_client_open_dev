GuildMain = {}

function GuildMain.main()
    local parent = GUI:Attach_Parent()


    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_main_win32")
    else
        GUI:LoadExport(parent, "guild/guild_main")
    end

    GuildMain._parent = parent
    GuildMain._ui = GUI:ui_delegate(parent)

    GuildMain.RegisterEvent()
end

function GuildMain.OnRefreshGuildInfo()
    local guildInfo = SL:GetMetaValue("GUILD_INFO")
    if not guildInfo or not next(guildInfo) then
        return
    end

    GUI:Text_setString(GuildMain._ui["GuildName"],guildInfo.guildName)
    GUI:Text_setString(GuildMain._ui["MasterName"],guildInfo.guidMaster)

    local str = guildInfo.notice or ""
    if string.len(str) < 1 then
        str = SL:GetMetaValue("GAME_DATA", "announce") or ""
    end
    str = string.gsub(str, "\\r", "\r")
    str = string.gsub(str, "\\n", "\n")
    GUI:Text_setString(GuildMain._ui["EditInput"],str)
    GUI:setTouchEnabled(GuildMain._ui["EditInput"],guildInfo.isChairMan)
end

-----------------------------------注册事件--------------------------------------
function GuildMain.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMain", GuildMain.OnRefreshGuildInfo)
end

function GuildMain.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMain")
end