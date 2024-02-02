GuildFrame = {}

GuildFrame.MEMU_GROUPID = 12

-- 页签ID
GuildFrame._pageIDs = {
    SLDefine.GuildPage.GuildMain,
    SLDefine.GuildPage.GuildMember,
    SLDefine.GuildPage.GuildList,
}

function GuildFrame.main(index)
    local parent = GUI:Attach_Parent()

    local isJoinGuild = SL:GetMetaValue("GUILD_INFO").isJoinGuild
    if index and not isJoinGuild then
        SL:ShowSystemTips("您还未加入行会")
        return
    end

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_frame_win32")
    else
        GUI:LoadExport(parent, "guild/guild_frame")
    end
    
    GuildFrame._ui = GUI:ui_delegate(parent)
    GuildFrame._Pages = {}
    GuildFrame._index = 0

    local CloseLayout = GuildFrame._ui["CloseLayout"]
    local FrameLayout = GuildFrame._ui["FrameLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:setPosition(FrameLayout, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        GUI:setPosition(FrameLayout, winSizeW / 2, SL:GetMetaValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, FrameLayout)
        GUI:Win_SetZPanel(parent, FrameLayout)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)
    end
    
    -- 关闭按钮
    GUI:addOnClickEvent(GuildFrame._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    for i, layerId in ipairs(GuildFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = GuildFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        if SL:CheckMenuLayerConditionByID(layerId) then
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                GuildFrame.PageTo(layerId)
            end)
        else
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SL:ShowSystemTips("条件不满足!")
            end)
        end
        GuildFrame._Pages[btnName] = page
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
end

function GuildFrame.PageTo(index, isAuto)
    local isJoinGuild = SL:GetMetaValue("GUILD_INFO").isJoinGuild
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
    
    if GuildFrame._index == index then
        return
    end

    GuildFrame.OnClose()

    GuildFrame._index = index

    GuildFrame.OnOpen()

    GuildFrame.SetPageStatus()
end

function GuildFrame.OnClose()
    SL:CloseMenuLayerByID(GuildFrame._index)
end

function GuildFrame.OnOpen()
    SL:OpenMenuLayerByID(GuildFrame._index, GuildFrame._ui["AttachLayout"])
end

function GuildFrame.SetPageStatus()
    for _, uiPage in pairs(GuildFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == GuildFrame._index and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, SL:GetMetaValue("WINPLAYMODE") and 13 or 16)
                local selColor = SL:GetMetaValue("WINPLAYMODE") and "#e6e7a7" or "#f8e6c6"
                GUI:Text_setTextColor(uiText, isSel and selColor or "#807256")
                GUI:Text_enableOutline(uiText, "#111111", 2)
                if isSel then
                    local titleStr = string.gsub(GUI:Text_getString(uiText), "\n", "")
                    GUI:Text_setString(GuildFrame._ui["TitleText"], titleStr)
                end
            end
        end
    end
end

function GuildFrame.OnRefresh()
    local isJoinGuild = SL:GetMetaValue("GUILD_INFO").isJoinGuild
    if isJoinGuild then
        GuildFrame.OnRefreshBtnShow(true)
        GuildFrame.PageTo(GuildFrame._pageIDs[1])
    end 
end

function GuildFrame.OnRefreshBtnShow(state)
    for ID, page in pairs(GuildFrame._Pages) do
        if page then
            GUI:setVisible(page, state)
        end
    end
end