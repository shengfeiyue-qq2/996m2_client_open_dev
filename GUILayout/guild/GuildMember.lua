GuildMember = {}

function GuildMember.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_member_win32")
    else
        GUI:LoadExport(parent, "guild/guild_member")
    end

    GuildMember._parent = parent
    GuildMember._ui = GUI:ui_delegate(parent)
    GuildMember._layer = GuildMember._ui.Layer

    GuildMember._memberCell     = {}
    GuildMember._memberList     = {}
    GuildMember._filterLevel    = 1
    GuildMember._filterRank     = 0
    GuildMember._filterJob      = 0
    GuildMember._maxMember      = 0

    -- 自定义组件挂接
    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.GuildMembers,
        root = GuildMember._ui.PMainUI
    })

    SL:RequestGuildMemberList()

    GuildMember.InitUI()

    GuildMember.RegisterEvent()
end

function GuildMember.InitUI()
    GUI:addOnClickEvent(GuildMember._ui.BtnDissolve, function()
        UIOperator:OpenCommonTipsUI({
            str = "是否解散行会？",
            btnType = 2,
            callback = function(tag)
                if tag == 1 then
                    SL:RequestGuildDissolve()
                end
            end
        })
    end)

    GUI:addOnClickEvent(GuildMember._ui.BtnQuit, function()
        UIOperator:OpenCommonTipsUI({
            str = "是否退出行会？",
            btnType = 2,
            callback = function(tag)
                if tag == 1 then
                    SL:RequestGuildQuit()
                end
            end
        })
    end)

    GUI:addOnClickEvent(GuildMember._ui.BtnLevel, function()
        GuildMember._filterLevel = GuildMember._filterLevel == 1 and 2 or 1
        GuildMember.RefreshShowFilter()
        GuildMember.RefreshMemberList(true)
    end)

    GUI:addOnClickEvent(GuildMember._ui.Text_level, function()
        GuildMember.ShowFilterLevel()
    end)

    GUI:addOnClickEvent(GuildMember._ui.BtnJob, function()
        GuildMember.ShowFilterJob()
    end)

    GUI:addOnClickEvent(GuildMember._ui.BtnOfficial, function()
        GuildMember.ShowFilterOfficial()
    end)

    for i = 1, 2 do
        local list = GUI:getChildByName(GuildMember._ui.FilterLevel, "ListView_filter")
        local item = GUI:getChildByName(list, "filter" .. i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function()
                GUI:setVisible(GuildMember._ui.FilterLevel, false)
                GuildMember._filterLevel = i
                GuildMember.RefreshMemberList()
            end)
        end
    end

    for i = 0, 3 do
        local list = GUI:getChildByName(GuildMember._ui.FilterJob, "ListView_filter")
        local item = GUI:getChildByName(list, "filter" .. i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function()
                GUI:setVisible(GuildMember._ui.FilterJob, false)
                GuildMember._filterJob = i
                GuildMember.RefreshMemberList()
            end)
        end
    end

    for i = 0, 5 do
        local list = GUI:getChildByName(GuildMember._ui.FilterOfficial, "ListView_filter")
        local item = GUI:getChildByName(list, "filter" .. i)
        if item then
            GUI:setTag(item, i)
            GUI:addOnClickEvent(item, function()
                GUI:setVisible(GuildMember._ui.FilterOfficial, false)
                GuildMember._filterRank = i
                GuildMember.RefreshMemberList()
            end)
        end
    end

    GUI:addOnClickEvent(GuildMember._ui.BtnEditTitle, function()
        UIOperator:OpenGuildEditTitleUI()
    end)

    GUI:addOnClickEvent(GuildMember._ui.BtnApplyList, function()
        UIOperator:OpenGuildApplyListUI()
    end)

    GuildMember.RefreshShowFilter()
    GuildMember.RefreshInfo()
end

function GuildMember.RefreshShowFilter()
    GUI:setRotation(GuildMember._ui.BtnLevel, GuildMember._filterLevel == 1 and 0 or 180)
end

-- 成员排序
function GuildMember.ShowFilterLevel()
    local isShow = not GUI:getVisible(GuildMember._ui.FilterLevel)
    GUI:setVisible(GuildMember._ui.FilterLevel, isShow)

    if isShow then
        local list = GUI:getChildByName(GuildMember._ui.FilterLevel, "ListView_filter")
        for _, v in pairs(GUI:getChildren(list)) do
            local selectImg = GUI:getChildByName(v, "Image_select")
            GUI:setVisible(selectImg, GuildMember._filterLevel == GUI:getTag(v))
        end
    end
end

function GuildMember.ShowFilterJob()
    local isShow = not GUI:getVisible(GuildMember._ui.FilterJob)
    GUI:setVisible(GuildMember._ui.FilterJob, isShow)

    if isShow then
        local list = GUI:getChildByName(GuildMember._ui.FilterJob, "ListView_filter")
        for _, v in pairs(GUI:getChildren(list)) do
            local selectImg = GUI:getChildByName(v, "Image_select")
            GUI:setVisible(selectImg, GuildMember._filterJob == GUI:getTag(v))
        end
    end
end

function GuildMember.ShowFilterOfficial()
    local isShow = not GUI:getVisible(GuildMember._ui.FilterOfficial)
    GUI:setVisible(GuildMember._ui.FilterOfficial, isShow)

    if isShow then
        local list = GUI:getChildByName(GuildMember._ui.FilterOfficial, "ListView_filter")
        for _, v in pairs(GUI:getChildren(list)) do
            local selectImg = GUI:getChildByName(v, "Image_select")
            local tag = GUI:getTag(v)
            GUI:setVisible(selectImg, GuildMember._filterRank == tag)
            if tag > 0 then
                GUI:Text_setString(GUI:getChildByName(v, "Text"), SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", tag - 1))
            end
        end
    end
end

function GuildMember.CompareJob(job, info)
    if job == 0 then
        return true
    end
    return job == (info.Job + 1)
end

function GuildMember.CompareRank(rank, info)
    -- 全部
    if rank == 0 then
        return true
    end
    return rank == (info.Rank + 1)
end

function GuildMember.RefreshMemberList(levelSort)
    GuildMember._memberList = {}
    GuildMember._memberCell = {}
    for i, v in pairs(SL:GetValue("GUILD_MEMBER_LIST")) do
        if GuildMember.CompareJob(GuildMember._filterJob, v) and GuildMember.CompareRank(GuildMember._filterRank, v) then
            table.insert(GuildMember._memberList, v)
        end
    end

    table.sort(GuildMember._memberList, function(a, b)
        if not levelSort then
            if a.Line ~= b.Line then
                return a.Line > b.Line
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
        
        return a.UserName < b.UserName
    end)
    
    GUI:ListView_removeAllItems(GuildMember._ui.MemberList)
    for i, member in ipairs(GuildMember._memberList) do
        local function createCell(parent)
            return GuildMember.CreateMemberCell(parent, member)
        end
        local cell_width = SL:GetValue("IS_PC_OPER_MODE") and 606 or 732
        GuildMember._memberCell[member.UserID] = GUI:QuickCell_Create(GuildMember._ui.MemberList, "cell" .. member.UserID, 0, 0, cell_width, 50, createCell)
    end

    GuildMember.RefreshInfo()
    GuildMember.RefreshMemberCount()
end

function GuildMember.RefreshInfo()
    GUI:setVisible(GuildMember._ui.BtnDissolve, SL:GetValue("GUILD_IS_CHAIRMAN"))
    GUI:setVisible(GuildMember._ui.BtnQuit, not SL:GetValue("GUILD_IS_CHAIRMAN"))
    GUI:setVisible(GuildMember._ui.BtnApplyList, SL:GetValue("GUILD_CHECK_PERMISSION_APPROVE_APPLY"))
    GUI:setVisible(GuildMember._ui.BtnEditTitle, SL:GetValue("GUILD_IS_ADMIN"))
end

function GuildMember.RefreshMemberCount()
    local onLine = 0
    local count  = 0
    for _, v in pairs(GuildMember._memberList) do
        count = count + 1
        if v.Line == 1 then
            onLine = onLine + 1
        end
    end
    GUI:Text_setString(GuildMember._ui.LabelOnline, string.format("在线人数:%s/%s", onLine, count))
    GuildMember._maxMember = count
end

function GuildMember.CreateMemberCell(parent, member)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_member_cell_win32")
    else
        GUI:LoadExport(parent, "guild/guild_member_cell")
    end

    local cell = GUI:getChildByName(parent, "Panel_cell")

    -- 名字
    local ui_name = GUI:getChildByName(cell, "username")
    GUI:Text_setString(ui_name, member.UserName)

    -- 等级
    local ui_level = GUI:getChildByName(cell, "level")
    local relevelStr = member.ReLevel and member.ReLevel > 0 and string.format("%s转", member.ReLevel) or ""
    GUI:Text_setString(ui_level,  relevelStr .. string.format("%s级", member.Level or 0))

    -- 职业
    local ui_job = GUI:getChildByName(cell, "job")
    GUI:Text_setString(ui_job, SL:GetValue("JOB_NAME", member.Job))

    -- 职位
    local ui_official = GUI:getChildByName(cell, "official")
    local str = SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", member.Rank)
    local isChairMan = SL:GetValue("GUILD_IS_ADMIN", member.Rank)
    GUI:Text_setString(ui_official, str)
    GUI:Text_setTextColor(ui_official, isChairMan and "#ffff0f" or "#ffffff")

    -- 在线状态
    local ui_online = GUI:getChildByName(cell, "online")
    if member.Line == 1 then
        GUI:Text_setString(ui_online, "在线")
        GUI:Text_setTextColor(ui_online, "#28ef01")
    else
        GUI:Text_setString(ui_online, "离线")
        if tonumber(member.LastTime) then
            local time = SL:SecondToHMS(SL:GetValue("SERVER_TIME") - tonumber(member.LastTime))
            if time.d > 0 then -- 离线天数
                local str = string.format("离线%s天", time.d)
                GUI:Text_setString(ui_online, str)
            end
        end
    end

    GUI:addOnClickEvent(cell, function()
        UIOperator:OpenFuncDockTips({
            type = FuncDockData.FuncDockType.Func_Guild,
            targetId = member.UserID,
            targetName = member.UserName,
            pos = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
        })
    end)

    return cell
end

------------------------------------------------------------
function GuildMember.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_LIST, "GuildMember", GuildMember.RefreshMemberList)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMember", GuildMember.RefreshInfo)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildMember", GuildMember.OnClose)
end

function GuildMember.OnClose(layerId)
    if layerId == UIConst.LayerTable.GuildMember then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.GuildMembers
        })
        GuildMember.RemoveEvent()
        GuildMember._layer = nil
    end
end

function GuildMember.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_LIST, "GuildMember")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_MAIN_INFO, "GuildMember")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildMember")
end
------------------------------------------------------------

GuildMember.main()