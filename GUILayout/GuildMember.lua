GuildMember = {}

function GuildMember.main()
    local parent = GUI:Attach_Parent()

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_member_win32")
    else
        GUI:LoadExport(parent, "guild/guild_member")
    end

    GuildMember._parent = parent
    GuildMember._ui = GUI:ui_delegate(parent)

    GUI:addOnClickEvent(
        GuildMember._ui["BtnApplyList"],
        function()
            SL:OpenGuildApplyListUI()
        end
    )
end

function GuildMember.RefreshMemberList(listData, listCell)
    GUI:ListView_removeAllItems(GuildMember._ui["MemberList"])
    for i, member in ipairs(listData) do
        local function createCell(parent)
            return GuildMember.CreateMemberCell(parent, member)
        end 
        local isWinMode = SL:GetMetaValue("WINPLAYMODE")
        local cell_width = 732
        if isWinMode then
            cell_width = 606
        end
        listCell[member.UserID] = GUI:QuickCell_Create(GuildMember._ui["MemberList"], "cell" .. member.UserID, 0, 0, cell_width, 50, createCell)
    end
end

function GuildMember.CreateMemberCell(parent, member)
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_member_cell_win32")
    else
        GUI:LoadExport(parent, "guild/guild_member_cell")
    end

    local cell = GUI:getChildByName(parent, "Panel_cell")

    local ui_name = GUI:getChildByName(cell, "username")
    GUI:Text_setString(ui_name, member.Name)

    local ui_level = GUI:getChildByName(cell, "level")
    local relevelStr = member.ReLevel and member.ReLevel > 0 and string.format("%s转", member.ReLevel) or ""
    GUI:Text_setString(ui_level,  relevelStr .. string.format("%s级", member.Level or 0))

    local ui_job = GUI:getChildByName(cell, "job")
    GUI:Text_setString(ui_job, SL:GetMetaValue("JOB_NAME", member.Job))

    local ui_official = GUI:getChildByName(cell, "official")
    local str = SL:GetMetaValue("GUILD_OFFICIAL", member.Rank)
    GUI:Text_setString(ui_official, str)
    local isChairMan = member.Rank == 1 or member.Rank == 2
    GUI:Text_setTextColor(ui_official, isChairMan and "#ffff0f" or "#ffffff")

    local ui_online = GUI:getChildByName(cell, "online")
    if member.Online == 1 then
        GUI:Text_setString(ui_online, "在线")
        GUI:Text_setTextColor(ui_online, "#28ef01")
    else
        GUI:Text_setString(ui_online, "离线")
        if member.LastLoginTime and tonumber(member.LastLoginTime) > 0 then     -- 离线天数
            local day = string.format("%s天", member.LastLoginTime)
            GUI:Text_setString(ui_online, "离线" .. day)
        end
    end

    GUI:addOnClickEvent(
        cell,
        function()
            SL:OpenFuncDockTips(
                {
                    type = 4,
                    targetId = member.UserID,
                    targetName = member.Name,
                    pos = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
                }
            )
        end
    )

    return cell
end
