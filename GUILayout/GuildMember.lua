GuildMember = {}

GuildMember._ui = nil

local getJobStr = function (job)
    return ({[0] = "战士", [1] = "法师", [2] = "道士"})[job] or "其他"
end

local compareJob = function (job, info)
    if job == 0 then
        return true
    end
    return job == (info.Job + 1)
end

local compareRank = function (rank, info)
    if rank == 0 then
        return true
    end
    if rank == 1 then
        return SL:GetMetaValue("IS_MASTER", info.Rank)
    else
        return rank == info.Rank
    end
end

function GuildMember.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "guild/guild_member_list")
    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    GuildMember._ui = ui

    GuildMember.RegistEvent()

    -- 请求行会数据
    SL:RequestGuildMemberList()

    GuildMember.InitVar()
    GuildMember.InitEvent()
    GuildMember.UpdateButtonStatus()
end

-- 注册事件
function GuildMember.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "GuildMember", GuildMember.UpdateButtonStatus)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_REFRESH, "GuildMember", GuildMember.RefreshUI)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_RANK_REFRESH, "GuildMember", GuildMember.RefreshCellRank)
end

-- 取消事件
function GuildMember.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_INFO_CHANGE, "GuildMember")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_REFRESH, "GuildMember")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_RANK_REFRESH, "GuildMember")
end

function GuildMember.CloseCallback()
    GuildMember.UnRegisterEvent()
end

function GuildMember.InitVar()
    GuildMember._membersCell = {}
    GuildMember._memberList  = {}
    GuildMember._filterLevel = 1
    GuildMember._filterRank  = 0
    GuildMember._filterJob   = 0
    GUI:setRotation(GuildMember._ui["BtnLevel"], 0)
end

function GuildMember.InitEvent()
    -- 申请列表按钮
    GUI:addOnClickEvent(GuildMember._ui["BtnApplyList"], function ()
        SL:CloseGuildMainUI()
        SL:OpenGuildApplyListUI()
    end)

    -- 解散行会按钮
    GUI:addOnClickEvent(GuildMember._ui["BtnDissolve"], function ()
        local data = {
            str = "是否解散行会？",
            btnType = 2, 
            callback = function(tag)
                if tag == 1 then
                    SL:RequestDissolveGuild()
                end
            end
        }
        SL:OpenCommonTipsPop(data)
    end)

    -- 退出行会按钮
    GUI:addOnClickEvent(GuildMember._ui["BtnQuit"], function ()
        local data = {
            str = "是否退出行会？",
            btnType = 2, 
            callback = function(tag)
                if tag == 1 then
                    SL:RequestGuildExit()
                end
            end
        }
        SL:OpenCommonTipsPop(data)
    end)

    -- 行会称号编辑按钮
    GUI:addOnClickEvent(GuildMember._ui["BtnEditTitle"], function ()
        SL:OpenGuildEditTitleUI()
    end)

    -- 点击按等级排序
    GUI:addOnClickEvent(GuildMember._ui["Text_level"], GuildMember.OnShowFilterLevel)

    -- 行会职业选择页签
    GUI:addOnClickEvent(GuildMember._ui["BtnJob"], GuildMember.OnShowFilterJob)

    -- 行会官职选择页签
    GUI:addOnClickEvent(GuildMember._ui["BtnOfficial"], GuildMember.OnShowFilterOfficial)

    -- 行会等级选择页签
    GUI:addOnClickEvent(GuildMember._ui["BtnLevel"], function ()
        GuildMember._filterLevel = GuildMember._filterLevel ==  1 and 2 or 1
        local rotate = GuildMember._filterLevel == 1 and 0 or 180
        GUI:setRotation(GuildMember._ui["BtnLevel"], rotate)
        GuildMember:RefreshUI(true)
    end)

    -- 等级 Filter
    for i = 1, 2 do
        local item = GUI:getChildByName(GUI:getChildByName(GuildMember._ui["FilterLevel"], "ListView_filter"), "filter"..i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function ()
                GUI:setVisible(GuildMember._ui["FilterLevel"], false)
                GuildMember._filterLevel = i
                GuildMember:RefreshUI()
            end)
        end
    end

    -- 职业 Filter
    for i = 0, 3 do
        local item = GUI:getChildByName(GUI:getChildByName(GuildMember._ui["FilterJob"], "ListView_filter"), "filter"..i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function ()
                GUI:setVisible(GuildMember._ui["FilterJob"], false)
                GuildMember._filterJob = i
                GuildMember:RefreshUI()
            end)
        end
    end

    -- 官职 Filter
    for i = 0, 5 do
        local item = GUI:getChildByName(GUI:getChildByName(GuildMember._ui["FilterOfficial"], "ListView_filter"), "filter"..i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function ()
                GUI:setVisible(GuildMember._ui["FilterOfficial"], false)
                GuildMember._filterRank = i
                GuildMember:RefreshUI()
            end)
        end
    end
end

function GuildMember.UpdateButtonStatus()
    -- 是否是会长
    local isMaster = SL:GetMetaValue("IS_MASTER")
    -- 是否是副会长
    local isChairman = SL:GetMetaValue("IS_CHAIRMAN")
    -- 是否有-收踢人权限
    local isPower = SL:GetMetaValue("IS_HAVE_POWER")

    GUI:setVisible(GuildMember._ui["BtnDissolve"], isMaster)
    GUI:setVisible(GuildMember._ui["BtnQuit"], not isMaster)
    GUI:setVisible(GuildMember._ui["BtnApplyList"], isPower)
    GUI:setVisible(GuildMember._ui["BtnEditTitle"], isChairman or isMaster)
end

--成员排序
function GuildMember.OnShowFilterLevel()
    local filter = GuildMember._ui["FilterLevel"]
    local isShow = not GUI:getVisible(filter)

    if isShow then
        local list = GUI:getChildByName(filter, "ListView_filter")
        for _,item in pairs(GUI:getChildren(list)) do
            GUI:setVisible(GUI:getChildByName(item, "Image_select"), GuildMember._filterLevel == GUI:getTag(item))
        end
    end
    GUI:setVisible(filter, isShow)
end

function GuildMember.OnShowFilterJob()
    local filter = GuildMember._ui["FilterJob"]
    local isShow = not GUI:getVisible(filter)

    if isShow then
        local list = GUI:getChildByName(filter, "ListView_filter")
        for _,item in pairs(GUI:getChildren(list)) do
            GUI:setVisible(GUI:getChildByName(item, "Image_select"), GuildMember._filterJob == GUI:getTag(item))
        end
    end
    GUI:setVisible(filter, isShow)
end

function GuildMember.OnShowFilterOfficial()
    local filter = GuildMember._ui["FilterOfficial"]
    local isShow = not GUI:getVisible(filter)

    if isShow then
        local list = GUI:getChildByName(filter, "ListView_filter")
        for _,item in pairs(GUI:getChildren(list)) do
            local tag = GUI:getTag(item)
            GUI:setVisible(GUI:getChildByName(item, "Image_select"), GuildMember._filterRank == tag)
            if tag > 0 then
                GUI:Text_setString(GUI:getChildByName(item, "text"), SL:GetMetaValue("GUILD_OFFICIAL", tag))
            end
        end
    end
    GUI:setVisible(filter, isShow)
end

function GuildMember.RefreshCellRank(data)
    if not data or not data.UserID then 
        return false
    end

    local cell = GuildMember._membersCell[data.UserID]
    if cell then
        cell:Exit()
    end
end

function GuildMember.RefreshUI(levelSort)
    GuildMember._memberList  = {}
    GuildMember._membersCell = {}

    local members = SL:GetMetaValue("GUILD_MEMBER_LIST")
    
    for _,v in pairs(members) do
        if compareJob(GuildMember._filterJob, v) and compareRank(GuildMember._filterRank, v) then
            table.insert(GuildMember._memberList, v)
        end
    end

    table.sort(GuildMember._memberList, function(a, b)
        if not levelSort then
            if a.Online ~= b.Online then
                return a.Online == 1
            end
    
            if a.Rank ~= b.Rank then
                return a.Rank < b.Rank
            end
        end
        
        if GuildMember._filterLevel > 0 and a.Level ~= b.Level then
            if GuildMember._filterLevel == 1 then
                return a.Level > b.Level
            elseif GuildMember._filterLevel == 2 then
                return a.Level < b.Level
            end
        end
        return a.Name < b.Name
    end)

    local list = GuildMember._ui["MemberList"]
    GUI:stopAllActions(list)
    GUI:removeAllChildren(list)

    for i,member in ipairs(GuildMember._memberList) do
        local userID = member.UserID
        local quickCell = GUI:QuickCell_Create(list, "Cell" .. i, 0, 0, 732, 50, function(parent) return GuildMember.CreateMemberCell(parent, userID) end)
        GuildMember._membersCell[userID] = quickCell
    end

    GUI:setVisible(GuildMember._ui["Image_none"], not next(GuildMember._memberList))

    GuildMember.UpdateButtonStatus()
    GuildMember.SetMemberOnlineCount()
end

function GuildMember:SetMemberOnlineCount()
    local online = 0
    local count  = 0
    for _,v in pairs(GuildMember._memberList) do
        count = count + 1
        if v.Online == 1 then
            online = online + 1
        end
    end
    GUI:Text_setString(GuildMember._ui["LabelOnline"], string.format("在线人数:%s/%s", online, count))
end

function GuildMember.CreateMemberCell(parent, uid)
    local data = SL:GetGuildMemberByUID(uid)
    if not data then
        return false
    end
    
    GUI:LoadExport(parent, "guild/guild_member_cell")
    local ui = GUI:ui_delegate(parent)

    local rank = data.Rank

    -- 名字
    GUI:Text_setString(ui["username"], data.Name)

    -- 等级
    GUI:Text_setString(ui["level"], string.format("%s级", data.Level or 0))

    -- 职业
    GUI:Text_setString(ui["job"], getJobStr(data.Job))

    -- 官职
    GUI:Text_setString(ui["official"], SL:GetMetaValue("GUILD_OFFICIAL", rank))

    local isMaster = SL:GetMetaValue("IS_MASTER", rank)
    local color = isMaster and "#ffff0f" or "#ffffff"
    GUI:Text_setTextColor(ui["official"], color)

    if data.Online == 1 then
        GUI:Text_setTextColor(ui["online"], "#28ef01")
        GUI:Text_setString(ui["online"], "在线")
    else
        GUI:Text_setTextColor(ui["online"], "#ffffff")
        GUI:Text_setString(ui["online"], "离线")
    end
    GUI:setVisible(ui["online"], true)

    local cell = ui.mCell
    GUI:addOnClickEvent(cell, function ()
        SL:OpenFuncDockTips({
            type = SL:EnumDockType().Func_Guild,
            targetId = data.UserID,
            targetName = data.Name,
            pos  = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
        })
    end)

    GUI:setVisible(cell, true)
    GUI:setTouchEnabled(cell, true)

    return cell
end