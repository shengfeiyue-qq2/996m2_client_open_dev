GuildList = {}

function GuildList.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    GuildList._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if GuildList._isWinMode then
        GUI:LoadExport(parent, "guild/guild_list_win32")
    else
        GUI:LoadExport(parent, "guild/guild_list")
    end

    GuildList._parent = parent
    GuildList._ui = GUI:ui_delegate(parent)
    GuildList._layer = GuildList._ui.Layer
    GuildList._init = true
    GuildList._qCells = {}

    -- 自定义组件挂接
    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.GuildList,
        root = GuildList._ui.PMainUI,
    })

    SL:RequestGuildWorldList()

    GuildList.InitUI()
    GuildList.RegisterEvent()
end

function GuildList.InitUI()
    local isJoinGuild = SL:GetValue("GUILD_IS_JOINED")
    GUI:setVisible(GuildList._ui["Button_create"], not isJoinGuild)

    GUI:addOnClickEvent(GuildList._ui["Button_create"], function()
        UIOperator:OpenGuildCreateUI()
    end)
    
end

function GuildList.OnRefreshGuildList()
    if not GuildList._init then
        return
    end
    GuildList._init = false
    
    GuildList._qCells = {}
    GUI:ListView_removeAllItems(GuildList._ui.ListView)

    local listData = SL:GetValue("GUILD_WORLD_LIST")
    for i, info in ipairs(listData) do
        local function createCell(parent)
            local guildInfo = SL:GetValue("GUILD_WORLD_INFO_BY_GUILDID", info.GuildID)
            return GuildList.CreateCell(parent, guildInfo)
        end 
        local cellWid = SL:GetValue("IS_PC_OPER_MODE") and 606 or 732
        local cellHei = SL:GetValue("IS_PC_OPER_MODE") and 42 or 50
        GuildList._qCells[info.GuildID] = GUI:QuickCell_Create(GuildList._ui.ListView, "cell" .. info.GuildID, 0, 0, cellWid, cellHei, createCell)
    end
    
end 

function GuildList.CreateCell(parent, info)
    local isJoinGuild = SL:GetValue("GUILD_IS_JOINED")
    local isGuildAdmin = SL:GetValue("GUILD_IS_ADMIN")
    local myGuildID = SL:GetValue("GUILD_ID")
    local isOtherGuild = myGuildID ~= info.GuildID
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_list_cell_win32")
    else
        GUI:LoadExport(parent, "guild/guild_list_cell")
    end
    
    local cell = GUI:getChildByName(parent, "Panel_cell")

    local warTime = info.WarTime or 0
    local isWar = isOtherGuild and warTime > 0 and warTime > SL:GetValue("SERVER_TIME") -- 是否有宣战
    
    local allyTime = info.AllyTime or 0
    local isAlly = isOtherGuild and allyTime > 0 and allyTime > SL:GetValue("SERVER_TIME") -- 是否已结盟

    local ui_name = GUI:getChildByName(cell, "label_name") 
    GUI:Text_setString(ui_name, info.GuildName)
    
    local ui_master = GUI:getChildByName(cell, "label_master")
    GUI:Text_setString(ui_master, info.MasterName)
    GUI:Text_setTextColor(ui_master, info.MasterLine == 1 and "#28ef01" or "#bfbfbf")
    
    local ui_count = GUI:getChildByName(cell, "label_count")
    GUI:Text_setString(ui_count, info.Member .. "/" .. info.MemberMax)
    
    local ui_condition = GUI:getChildByName(cell, "label_condition")
    GUI:Text_setString(ui_condition, "")
    
    local ui_desc = GUI:getChildByName(cell, "label_desc")
    GUI:Text_setString(ui_desc, "")
    
    local ui_btnJoin = GUI:getChildByName(cell, "Button_join")
    GUI:setVisible(ui_btnJoin, not isJoinGuild and (info.Member < info.MemberMax))
    
    local ui_btnWar = GUI:getChildByName(cell, "Button_war")
    GUI:setVisible(ui_btnWar, isGuildAdmin and not isWar and not isAlly and isOtherGuild) 

    local ui_btnAlly = GUI:getChildByName(cell, "Button_ally")
    GUI:setVisible(ui_btnAlly, isGuildAdmin and not isWar and not isAlly and isOtherGuild) 

    local ui_btnCancel = GUI:getChildByName(cell, "Button_cancel")
    local Hangxuan = SL:GetValue("GAME_DATA", "Hangxuan") 
    if Hangxuan and Hangxuan == 0 then
        GUI:setVisible(ui_btnCancel, false)
    else
        GUI:setVisible(ui_btnCancel, isGuildAdmin and (isWar or isAlly)) 
    end
    -- 条件
    if info.AutoJoin == 0 then 
        GUI:Text_setString(ui_condition, "需要申请")
        GUI:Button_setTitleText(ui_btnJoin, "申请")
    elseif info.JoinLevel then
        local playerLevel = SL:GetValue("LEVEL")
        GUI:Text_setString(ui_condition, string.format("%s级", info.JoinLevel))
        GUI:Text_setTextColor(ui_condition, playerLevel >= info.JoinLevel and "#28ef01" or "#ff0500")
        GUI:Button_setTitleText(ui_btnJoin, "加入")
    end

    -- 描述
    if not isJoinGuild and info.Member >= info.MemberMax then
        GUI:Text_setString(ui_desc, "行会已满")
    end

    GUI:stopAllActions(ui_desc)
    if isWar and isJoinGuild then
        local function showWarTime()
            local time = math.max(warTime - SL:GetValue("SERVER_TIME"), 0)
            local desc = string.format("已宣战：%s", SL:TimeFormatToStr(time))
            GUI:Text_setString(ui_desc, desc)
        end
        showWarTime()
        GUI:schedule(ui_desc, showWarTime, 1)
    elseif isAlly and isJoinGuild then
        local function showAllyTime()
            local time = math.max(allyTime - SL:GetValue("SERVER_TIME"), 0)
            local desc = string.format("已结盟：%s", SL:TimeFormatToStr(time))
            GUI:Text_setString(ui_desc, desc)
        end
        showAllyTime()
        GUI:schedule(ui_desc, showAllyTime, 1)
    end

    GUI:addOnClickEvent(ui_btnJoin, function(sender)
        if info.Member >= info.MemberMax then
            SL:ShowSystemTips("行会人数已满")
            return
        end

        SL:RequestGuildApplyJoin(info.GuildID)
        GUI:setVisible(ui_btnJoin, false)
        GUI:Text_setString(ui_desc, "已申请")
        GUI:delayTouchEnabled(sender)
    end)

    GUI:addOnClickEvent(ui_btnWar, function()
        if not isGuildAdmin then
            SL:ShowSystemTips("没有权限")
            return
        elseif isWar then
            SL:ShowSystemTips("已经是宣战对象")
            return
        end
        -- 发起行会宣战
        local data = {
            type = 1,
            guildId = info.GuildID,
            guildName = info.GuildName
        }
        UIOperator:OpenGuildWarAllyUI(data)
    end)

    GUI:addOnClickEvent(ui_btnAlly, function()
        local allyTime = info.AllyTime or  0
        local isAlly = allyTime > 0 and allyTime > SL:GetValue("SERVER_TIME")

        if not isGuildAdmin then
            SL:ShowSystemTips("没有权限")
            return
        elseif isAlly then
            SL:ShowSystemTips("已经是结盟对象")
            return
        end
        -- 结盟
        local data = {
            type = 2,
            guildId = info.GuildID,
            guildName = info.GuildName
        }
        UIOperator:OpenGuildWarAllyUI(data)
    end)

    GUI:addOnClickEvent(ui_btnCancel, function()
        -- 是否有宣战
        local warTime = info.WarTime or 0
        local isWar = warTime > 0 and warTime > SL:GetValue("SERVER_TIME")
        -- 是否已结盟
        local allyTime = info.AllyTime or 0
        local isAlly = allyTime > 0 and allyTime > SL:GetValue("SERVER_TIME")

        if not (isAlly or isWar) then
            return
        end

        local strF = "是否取消 <font color='#ebf291' size='%s'>%s</font> 行会的%s？"
        local data = {
            btnType  = 2,
            str = string.format(strF, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), info.GuildName, isAlly and "结盟" or "宣战"),
            callback = function(type)
                if 1 == type then
                    if isAlly then
                        -- 请求取消结盟
                        SL:RequestGuildCancelAlly(info.GuildID)
                    elseif isWar then  
                        -- 请求取消宣战
                        SL:RequestGuildCancelWar(info.GuildID)   
                    end
                end
            end
        }
        UIOperator:OpenCommonTipsUI(data)
    end)

    return cell
end

-- 刷新结盟/宣战显示
function GuildList.OnRefreshAllyWarShow(guildID)
    if not guildID then
        return
    end
    
    if not GuildList._qCells[guildID] then
        return
    end

    GUI:QuickCell_Exit(GuildList._qCells[guildID])
    GUI:QuickCell_Refresh(GuildList._qCells[guildID])
end

--------------------------------------------------------------------------
function GuildList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_WORLDLIST, "GuildList", GuildList.OnRefreshGuildList)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_ALL_WAR_UPDATE, "GuildList", GuildList.OnRefreshAllyWarShow)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildList", GuildList.OnClose)
end

function GuildList.OnClose(layerId)
    if layerId == UIConst.LayerTable.GuildList then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.GuildList
        })
        GuildList.RemoveEvent()
        GuildList._layer = nil
    end
end

function GuildList.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_WORLDLIST, "GuildList")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_ALL_WAR_UPDATE, "GuildList")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildList")
end
---------------------------------------------------------------------------

GuildList.main()