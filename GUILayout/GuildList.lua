GuildList = {}

function GuildList.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_list")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildList._ui = ui

    GuildList._list = ui["List"]
    GuildList._CheckBox = ui["CheckBox"]

    GuildList._data = {}

    -- 创建行会按钮
    GUI:addOnClickEvent(ui["btnCreate"], GuildList.CreateGuld)

    GUI:CheckBox_addOnEvent(GuildList._CheckBox, function () GuildList.RefreshList() end)

    SL:RegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_LIST, "GuildList", GuildList.UpdateUI)
    SL:RequestWorldGuildList()
end

function GuildList.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_RESPONSE_GUILD_LIST, "GuildList")
end

function GuildList.CreateGuld()
    SL:CloseGuildMainUI()
    SL:OpenGuildCreateUI()
end

function GuildList.UpdateUI(data)
    GUI:setVisible(GuildList._ui["btnCreate"], not SL:GetMetaValue("IS_IN_GUILD"))
    GUI:CheckBox_setSelected(GuildList._CheckBox, false)

    GuildList._data = data
    GuildList.RefreshList()
end

function GuildList.RefreshList()
    GUI:removeAllChildren(GuildList._list)
    for _,data in ipairs(GuildList._data) do
        if data and (not GUI:CheckBox_isSelected(GuildList._CheckBox) or data.MasterLine == 1) then
            local item = GUI:Clone(GuildList._ui["Item"])
            GUI:ListView_pushBackCustomItem(GuildList._list, item)
            GuildList:InitItem(item, data)
            GUI:setVisible(item, true)
        end
    end
end

function GuildList:InitItem(item, data)
    local isAutoJoin  = data.AutoJoin
    local joinLevel   = data.JoinLevel
    local chiefName   = data.ChiefName
    local memberMax   = data.MembersMax or SL:GetMetaValue("GUILD_MEMBER_LIMIT")
    local isChairman  = SL:GetMetaValue("IS_MASTER") or SL:GetMetaValue("IS_CHAIRMAN")      -- 是否是会长或者副会长
    local isJoinGuild = SL:GetMetaValue("IS_IN_GUILD")                                      -- 是否加入行会
    local myGuildId   = SL:GetMetaValue("GUILD_INFO").guildId
    local level       = SL:GetMetaValue("LEVEL")
    local warTime     = data.WarTime
    local guildId     = data.GuildID
    local guildName   = data.GuildName
    local serverTime  = SL:GetCurServerTime()

    local ui = {}
    GUI:ui_IterChilds(ui, item)

    -- 是否有宣战
    local isWar = warTime and warTime > 0 and warTime > serverTime

    -- 是否是盟友
    local allyTime = data.AllyTime
    local isAlly = allyTime and allyTime > 0 and allyTime > serverTime

    GUI:Text_setString(ui["TName"], guildName)

    GUI:Text_setString(ui["TChairman"], chiefName)

    GUI:Text_setString(ui["TCount"], (data.MemberCount.."/"..memberMax))
    
    local isCanJoin = (not isJoinGuild) and data.MemberCount < memberMax
    local isCanAlly = isChairman and not isWar  and not isAlly and myGuildId ~= guildId

    local cTips = isAutoJoin == 0 and "需要申请" or (
        level >= joinLevel and string.format("%s级", joinLevel) or "等级不足"
    )
    GUI:Text_setString(ui["TCondition"], cTips)

    local btnJoin = ui["BtnJoin"]
    GUI:Button_setTitleText(btnJoin, isAutoJoin == 0 and "申请" or "加入")
    GUI:setVisible(btnJoin, isCanJoin)
    GUI:addOnClickEvent(btnJoin, function()
        if data.MemberCount >= memberMax then
            return SL:ShowSystemTips("行会人数已满")
        end
        SL:RequestApplyGuild(data.GuildID)
        GUI:setVisible(btnJoin, false)
        GUI:setVisible(ui["TDesc"], true)
    end)

    local btnWar = ui["BtnWar"]
    GUI:setVisible(btnWar, isCanAlly)
    GUI:addOnClickEvent(btnWar, function()
        if not isChairman then
            return SL:ShowSystemTips("没有权限")
        end
        if isWar then
            return SL:ShowSystemTips("已经是宣战对象")
        end
        -- 打开宣战界面
        SL:OpenGuildWarSponsorUI({type = 1, guildId = guildId, guildName = guildName})
    end)

    local btnAlly = ui["BtnAlly"]
    GUI:setVisible(btnAlly, isCanAlly)
    GUI:addOnClickEvent(btnAlly, function()
        if not isChairman then
            return SL:ShowSystemTips("没有权限")
        end
        if isAlly then
            return SL:ShowSystemTips("已经是结盟对象")
        end
        -- 打开结盟界面
        SL:OpenGuildWarSponsorUI({type = 2, guildId = guildId, guildName = guildName})
    end)
    
    local TDesc = ui["TDesc"]
    local isFull = (not isJoinGuild) and data.MemberCount >= memberMax
    if isFull then
        GUI:Text_setString(TDesc, "行会已满")
        GUI:setVisible(TDesc, true)
    end
    GUI:Text_setTextColor(TDesc, "#ffffff")
    GUI:stopAllActions(TDesc)

    if isWar then
        local function showTime()
            local time = math.max(warTime - SL:GetCurServerTime(), 0)
            GUI:Text_setString(TDesc, string.format("已宣战 %s", SL:TimeFormatToStr(time)))
        end

        GUI:setVisible(TDesc, true)
        showTime()
        SL:schedule(TDesc, showTime, 1)
    elseif isAlly then
        local function showTime()
            local time = math.max(allyTime - SL:GetCurServerTime(), 0)
            GUI:Text_setString(TDesc, string.format("已结盟 %s", SL:TimeFormatToStr(time)))   
        end

        GUI:setVisible(TDesc, true)
        showTime()
        GUI:Text_setTextColor(TDesc, "#28ef01")
        SL:schedule(TDesc, showTime, 1)
    end

    local btnCancel = ui["BtnCancel"]
    GUI:setVisible(btnCancel, isWar or isAlly)
    GUI:addOnClickEvent(btnCancel, function()
        if not (isAlly or isWar) then
            return false
        end

        local callback = function (type)
            if 1 ~= type then
                return false
            end
            if isAlly then
                return SL:RequestGuildCancelAlly(guildId)
            end
            if isWar then
                return SL:RequestGuildCancelWar(guildId)
            end
        end

        SL:OpenCommonTipsPop({
            str = string.format("是否取消 <font color='#ebf291' size='16'>%s</font> 行会的%s？", guildName, isAlly and "结盟" or "宣战"),
            btnType  = 2,
            callback = callback
        })
    end)
end
