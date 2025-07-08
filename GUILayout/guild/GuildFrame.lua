GuildFrame = {}

GuildFrameInfo = GuildFrameInfo or {}

-- 页签ID
GuildFrame._pageIDs = {
    UIConst.LayerTable.GuildMain,
    UIConst.LayerTable.GuildMember,
    UIConst.LayerTable.GuildList,
}

if SL:GetValue("IS_PC_OPER_MODE") and #GuildFrame._pageIDs < 4 then
    table.insert(GuildFrame._pageIDs, UIConst.LayerTable.GuildChat)
end

GuildFrame._pageFiles = {
    [UIConst.LayerTable.GuildMain]      = UIConst.LUAFile.LUA_FILE_GUILD_MAIN,
    [UIConst.LayerTable.GuildMember]    = UIConst.LUAFile.LUA_FILE_GUILD_MEMBER,
    [UIConst.LayerTable.GuildList]      = UIConst.LUAFile.LUA_FILE_GUILD_LIST,
    [UIConst.LayerTable.GuildChat]      = UIConst.LUAFile.LUA_FILE_GUILD_CHAT,
}

function GuildFrame.main()
    local index = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local isJoinGuild = SL:GetValue("GUILD_IS_JOINED")
    if index and not isJoinGuild then
        SL:ShowSystemTips("您还未加入行会")
        return
    end

    if GUI:GetWindow(nil, UIConst.LAYERID.GuildFrameGUI) then
        local layerId = nil
        if index and GuildFrame._pageIDs then
            layerId = GuildFrame._pageIDs[index]
        end
        GuildFrame.PageTo(layerId)
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildFrameGUI, 0, 0, 0, 0, false, false, true, true)
    GuildFrameInfo._layer = parent
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_frame_win32")
    else
        GUI:LoadExport(parent, "guild/guild_frame")
    end
    
    GuildFrameInfo._ui = GUI:ui_delegate(parent)
    GuildFrameInfo._Pages = {}
    GuildFrameInfo._index = 0

    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.GuildBg,
        root = GuildFrameInfo._ui.FrameBG,
    })

    local closeLayout = GuildFrameInfo._ui["CloseLayout"]
    local frameLayout = GuildFrameInfo._ui["FrameLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(closeLayout, winSizeW, winSizeH)
    GUI:setPosition(frameLayout, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(closeLayout, false)
        GUI:setPosition(frameLayout, winSizeW / 2, SL:GetValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, frameLayout)
        GUI:Win_SetZPanel(parent, frameLayout)
    else
        -- 全屏关闭
        GUI:setVisible(closeLayout, true)
        GUI:addOnClickEvent(closeLayout, function()
            UIOperator:CloseGuildMainUI()
        end)
    end
    
    -- 关闭按钮
    GUI:addOnClickEvent(GuildFrameInfo._ui["CloseButton"], function()
        UIOperator:CloseGuildMainUI()
    end)

    for i, layerId in ipairs(GuildFrame._pageIDs) do
        local btnName = "page_cell_" .. i
        local page = GuildFrameInfo._ui[btnName]
        if page then
            GUI:Win_SetParam(page, layerId)
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                GuildFrame.PageTo(layerId)
            end)
            GuildFrameInfo._Pages[btnName] = page
        end
    end

    if not index then
        if isJoinGuild then
            GuildFrame.PageTo(GuildFrame._pageIDs[1], true)
        else
            GuildFrame.OnRefreshBtnShow(false)
            GuildFrame.PageTo(GuildFrame._pageIDs[3], true)
        end
    else
        GuildFrame.PageTo(GuildFrame._pageIDs[index])
    end

    GuildFrame.RegisterEvent()
end

function GuildFrame.PageTo(index, isAuto)
    local isJoinGuild = SL:GetValue("GUILD_IS_JOINED")
    if index and not isJoinGuild and not isAuto then
        SL:ShowSystemTips("您还未加入行会")
        return
    end

    if not index then
        if isJoinGuild then
            index = GuildFrame._pageIDs[1]
        else
            index = GuildFrame._pageIDs[3]
        end
        GuildFrame.OnRefreshBtnShow(isJoinGuild)
    end
    
    if GuildFrameInfo._index == index then
        return
    end

    GuildFrame.OnClose()

    GuildFrameInfo._index = index

    GuildFrame.OnOpen()

    GuildFrame.SetPageStatus()
end

function GuildFrame.OnClose()
    SL:onLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, GuildFrameInfo._index)
    GUI:removeAllChildren(GuildFrameInfo._ui["AttachLayout"])
end

function GuildFrame.OnOpen()
    local file = GuildFrame._pageFiles[GuildFrameInfo._index]
    if not file then
        return
    end

    -- 设置父节点
    GUI:SetLayerOpenParam(GuildFrameInfo._ui["AttachLayout"])

    GUI:Win_Open(file)
end

function GuildFrame.SetPageStatus()
    for _, uiPage in pairs(GuildFrameInfo._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == GuildFrameInfo._index and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, SL:GetValue("IS_PC_OPER_MODE") and 13 or 16)
                local selColor = SL:GetValue("IS_PC_OPER_MODE") and "#e6e7a7" or "#f8e6c6"
                GUI:Text_setTextColor(uiText, isSel and selColor or "#807256")
                GUI:Text_enableOutline(uiText, "#111111", 2)
                if isSel then
                    local titleStr = string.gsub(GUI:Text_getString(uiText), "\n", "")
                    GUI:Text_setString(GuildFrameInfo._ui["TitleText"], titleStr)
                end
            end
        end
    end
end

function GuildFrame.OnRefresh()
    local isJoinGuild = SL:GetValue("GUILD_IS_JOINED")
    if isJoinGuild then
        GuildFrame.OnRefreshBtnShow(true)
        GuildFrame.PageTo(GuildFrame._pageIDs[1])
    end 
end

function GuildFrame.OnRefreshBtnShow(state)
    for ID, page in pairs(GuildFrameInfo._Pages) do
        if page then
            GUI:setVisible(page, state)
        end
    end
end

----------------------------------------
function GuildFrame.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildFrame", GuildFrame.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_JOIN_STATE_CHANGE, "GuildFrame", GuildFrame.OnRefresh, GuildFrameInfo._layer)
end

function GuildFrame.OnCloseWin(id)
    if UIConst.LAYERID.GuildFrameGUI == id then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.GuildBg
        })
        GuildFrame.OnClose()
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildFrame")
        GuildFrameInfo = nil
    end
end
----------------------------------------

GuildFrame.main()