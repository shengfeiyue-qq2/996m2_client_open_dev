GuildMain = {}

function GuildMain.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_main_win32")
    else
        GUI:LoadExport(parent, "guild/guild_main")
    end

    GuildMain._parent = parent
    GuildMain._ui = GUI:ui_delegate(parent)
    GuildMain._layer = GuildMain._ui.Layer

    -- 自定义组件挂接
    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.GuildMain,
        root = GuildMain._ui.PMainUI
    })

    SL:RequestGuildInfo()

    GuildMain.InitEvent()
    GuildMain.RegisterEvent()
end

function GuildMain.InitEvent()
    local function editEvent(ref, eventType)
        if eventType == 1 then
            if SL:GetValue("M2_FORBID_NAME", true) then
                return
            end

            local notice = GUI:Text_getString(GuildMain._ui.EditInput)
            if not notice or string.len(notice) == 0 then
                SL:RequestGuildEditNotice(notice)
                return
            end

            SL:RequestCheckSensitiveWord(notice, 3, function(state, content)
                if not content then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    local guildInfo = SL:GetValue("GUILD_INFO")
                    local oriNotice = guildInfo and guildInfo.notice or ""
                    SL:onLUAEvent(LUA_EVENT_GUILD_NOTICE_UPDATE, oriNotice)
                    return
                end
                SL:RequestGuildEditNotice(content)
            end)
        end
    end

    GUI:TextInput_addOnEvent(GuildMain._ui.EditInput, editEvent)
end

function GuildMain.OnRefreshGuildInfo()
    local guildInfo = SL:GetValue("GUILD_INFO")
    if not guildInfo or not next(guildInfo) then
        return
    end

    GUI:Text_setString(GuildMain._ui["GuildName"], guildInfo.guildName)
    GUI:Text_setString(GuildMain._ui["MasterName"], guildInfo.guidMaster)

    local str = guildInfo.notice or ""
    GuildMain.OnSetGuildNotice(str)
    GUI:setTouchEnabled(GuildMain._ui["EditInput"], guildInfo.isChairMan)
end

function GuildMain.OnSetGuildNotice(noticeStr)
    if not noticeStr or string.len(noticeStr) == 0 then
        noticeStr = SL:GetValue("GAME_DATA", "announce") or ""
    end
    noticeStr = string.gsub(noticeStr, "\\r", "\r")
    noticeStr = string.gsub(noticeStr, "\\n", "\n")
    GUI:Text_setString(GuildMain._ui["EditInput"], noticeStr)
end

----------------------------------------------------------------------------
function GuildMain.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMain", GuildMain.OnRefreshGuildInfo)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_NOTICE_UPDATE, "GuildMain", GuildMain.OnSetGuildNotice)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildMain", GuildMain.OnClose)
end

function GuildMain.OnClose(layerId)
    if layerId == UIConst.LayerTable.GuildMain then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.GuildMain
        })
        GuildMain.RemoveEvent()
        GuildMain._layer = nil
    end
end

function GuildMain.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_NOTICE_UPDATE, "GuildMain")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildMain")
end
-----------------------------------------------------------------------------

GuildMain.main()