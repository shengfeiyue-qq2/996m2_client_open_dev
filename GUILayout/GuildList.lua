GuildList = {}

function GuildList.main()
    local parent = GUI:Attach_Parent()

    GuildList._isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if GuildList._isWinMode then
        GUI:LoadExport(parent, "guild/guild_list_win32")
    else
        GUI:LoadExport(parent, "guild/guild_list")
    end

    GuildList._parent = parent
    GuildList._ui = GUI:ui_delegate(parent)

    GuildList._curPage = 1
    SL:RequestWorldGuildList(GuildList._curPage)
    if GuildList._curPage + 1 <= SL:GetMetaValue("GUILD_WORLD_TOTAL_PAGES") then
        SL:RequestWorldGuildList(GuildList._curPage + 1)
    end

    GuildList.RegisterEvent()
end


function GuildList.InitGuildListUI()
    local guildMain = SL:GetMetaValue("GUILD_INFO")
    
    GUI:setVisible(GuildList._ui["Button_create"], not guildMain.isJoinGuild)
    GUI:addOnClickEvent(GuildList._ui["Button_create"], function()
        SL:OpenGuildCreateUI()
    end)

    GUI:ListView_addOnScrollEvent(GuildList._ui["ListView"], function(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(GuildList._ui["ListView"])
            if innerPos.y == 0 then
                local totalPage = SL:GetMetaValue("GUILD_WORLD_TOTAL_PAGES")
                local page = GuildList._curPage + 1
                if page <= totalPage then
                    SL:RequestWorldGuildList(page)
                end
            end
        end
    end)
    
end

function GuildList.RefreshGuildList(page)
    if page == 1 then
        GUI:ListView_removeAllItems(GuildList._ui["ListView"])
    elseif page ~= (GuildList._curPage + 1) then
        return
    end
    GuildList._curPage = page

    local guildMain = SL:GetMetaValue("GUILD_INFO")
    local listData = SL:GetMetaValue("GUILD_WORLD_LIST", GuildList._curPage)
    local addCellHei = 0
    local innerPos = GUI:ListView_getInnerContainerPosition(GuildList._ui["ListView"])
    for i, info in pairs(listData) do 
        local cell = GuildList.createCell(info)
        GUI:ListView_pushBackCustomItem(GuildList._ui["ListView"], cell)

        local cellHei = GUI:getContentSize(cell).height
        addCellHei = addCellHei + cellHei

        local warTime = info.WarTime
        local isWar = warTime and warTime > 0 and warTime > SL:GetMetaValue("SERVER_TIME") --是否有宣战
    
        local allyTime = info.AllyTime 
        local isAlly = allyTime and allyTime > 0 and allyTime > SL:GetMetaValue("SERVER_TIME") --是否是盟友
    
        local ui_name = GUI:getChildByName(cell, "label_name") 
        GUI:Text_setString(ui_name, info.GuildName)
    
        local ui_master = GUI:getChildByName(cell, "label_master")
        GUI:Text_setString(ui_master, info.ChiefName)
        GUI:Text_setTextColor(ui_master, info.MasterLine == 1 and "#28ef01" or "#bfbfbf")
    
        local ui_count = GUI:getChildByName(cell, "label_count")
        GUI:Text_setString(ui_count, info.MemberCount .. "/" .. info.MembersMax)
    
        local ui_condition = GUI:getChildByName(cell, "label_condition")
        GUI:Text_setString(ui_condition, "")
    
        local ui_desc = GUI:getChildByName(cell, "label_desc")
        GUI:Text_setString(ui_desc, "")
    
        local ui_btnJoin = GUI:getChildByName(cell, "Button_join")
        GUI:setVisible(ui_btnJoin, not (guildMain.isJoinGuild) and (info.MemberCount < info.MembersMax))
    
        local ui_btnWar = GUI:getChildByName(cell, "Button_war")
        GUI:setVisible(ui_btnWar, guildMain.isChairMan and not isWar and not isAlly and guildMain.guildId ~= info.GuildID) 
    
        local ui_btnAlly = GUI:getChildByName(cell, "Button_ally")
        GUI:setVisible(ui_btnAlly, guildMain.isChairMan and not isWar and not isAlly and guildMain.guildId ~= info.GuildID) 
    
        local ui_btnCancel = GUI:getChildByName(cell, "Button_cancel")
        local Hangxuan =  SL:GetMetaValue("GAME_DATA", "Hangxuan") 
        if Hangxuan and Hangxuan == 0 then
            GUI:setVisible(ui_btnCancel, false)
        else
            GUI:setVisible(ui_btnCancel, isWar or isAlly) 
        end
        -- 条件
        if info.AutoJoin == 0 then 
            GUI:Text_setString(ui_condition, "需要申请")
            GUI:Button_setTitleText(ui_btnJoin, "申请")
        else
            local playerLevel = SL:GetMetaValue("LEVEL")
            GUI:Text_setString(ui_condition, string.format("%s级", info.JoinLevel))
            GUI:Text_setTextColor(ui_condition, playerLevel >= info.JoinLevel and "#28ef01" or "#ff0500")
            GUI:Button_setTitleText(ui_btnJoin,"加入")
        end
    
        -- 描述
        if (not guildMain.isJoinGuild) and info.MemberCount >= info.MembersMax then
            GUI:Text_setString(ui_desc, "行会已满")
        end
    
        GUI:stopAllActions(ui_desc)
        if isWar and guildMain.isJoinGuild then
            local function showTime1()
                local time = math.max(warTime - SL:GetMetaValue("SERVER_TIME"), 0)
                local desc = string.format("已宣战：%s", SL:TimeFormatToStr(time))
                GUI:Text_setString(ui_desc, desc) -- fixme
            end
            showTime1()
            GUI:schedule(ui_desc, showTime1, 1)
        elseif isAlly and guildMain.isJoinGuild then
            local function showTime2()
                local time = math.max(allyTime - SL:GetMetaValue("SERVER_TIME"), 0)
                local desc = string.format("已结盟：%s", SL:TimeFormatToStr(time))
                GUI:Text_setString(ui_desc, desc) -- fixme
            end
            showTime2()
            GUI:schedule(ui_desc, showTime2, 1)
        end
    
        GUI:addOnClickEvent(ui_btnJoin, function()
            if info.MemberCount >= info.MembersMax then
                SL:ShowSystemTips("行会人数已满")
                return
            end
    
            GuildList.clickBtnJoin(info)
            GUI:setVisible(ui_btnJoin, false)
            GUI:Text_setString(ui_desc, "已申请")
        end)
    
        GUI:addOnClickEvent(ui_btnWar, function()
            if not guildMain.isChairMan then
                SL:ShowSystemTips("没有权限")
                return
            elseif isWar then
                SL:ShowSystemTips("已经是宣战对象")
                return
            end
            GuildList.clickBtnWar(info)
        end)
    
        GUI:addOnClickEvent(ui_btnAlly, function()
            GuildList.clickBtnAlly(info)
        end)
    
        GUI:addOnClickEvent(ui_btnCancel, function()
            GuildList.clickBtnCancel(info)
        end)
    end
    if GuildList._curPage ~= 1 and GuildList._curPage ~= 2 then
        innerPos.y = innerPos.y - addCellHei
        GUI:ListView_doLayout(GuildList._ui["ListView"])
        local curY = GUI:ListView_getInnerContainerPosition(GuildList._ui["ListView"]).y
        if curY < innerPos.y then
            GUI:ListView_setInnerContainerPosition(GuildList._ui["ListView"], innerPos)
        end
    end
end 

function GuildList.createCell(info)
    local guildMain = SL:GetMetaValue("GUILD_INFO")

    local parent = GUI:Widget_Create(GuildList._ui["PMainUI"], "widget" .. info.GuildName, 0, 0)

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_list_cell_win32")
    else
        GUI:LoadExport(parent, "guild/guild_list_cell")
    end
    
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end 

function GuildList.OnRefreshGuildList(page)
    GuildList.RefreshGuildList(page)
end 

-----------------------------------注册事件--------------------------------------
function GuildList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_WORLDLIST, "GuildList", GuildList.OnRefreshGuildList)
end

function GuildList.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_WORLDLIST, "GuildList")
end