SocialFrame = {}

SocialFrame.MEMU_GROUPID = 4

-- 页签ID
SocialFrame._pageIDs = {
    SLDefine.SocialPage.NearPlayer,
    SLDefine.SocialPage.Team,
    SLDefine.SocialPage.Friend,
    SLDefine.SocialPage.Mail,
}

function SocialFrame.main(index)
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, isWinMode and "social/social_frame_win32" or "social/social_frame")
    
    SocialFrame._ui = GUI:ui_delegate(parent)

    SocialFrame._Pages = {}
    SocialFrame._index = 0

    local CloseLayout = SocialFrame._ui["CloseLayout"]
    local FrameLayout = SocialFrame._ui["FrameLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:Win_SetZPanel(parent, FrameLayout)

    if isWinMode then
        -- 显示适配
        GUI:setPosition(FrameLayout, winSizeW / 2, SL:GetMetaValue("PC_POS_Y"))
                
        -- 可拖拽
        GUI:Win_SetDrag(parent, FrameLayout)
        GUI:setVisible(CloseLayout, false)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)

        -- 显示适配
        GUI:setPosition(FrameLayout, winSizeW / 2, winSizeH / 2)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(SocialFrame._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    for i, layerId in ipairs(SocialFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = SocialFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        if SL:CheckMenuLayerConditionByID(layerId) then
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SocialFrame.PageTo(layerId)
            end)
        else
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SL:ShowSystemTips("条件不满足!")
            end)
        end
        SocialFrame._Pages[btnName] = page
    end

    -- 默认跳到第一个
    SocialFrame.PageTo(SocialFrame._pageIDs[index or 1])
end

function SocialFrame.PageTo(index)
    if not index or SocialFrame._index == index then
        return
    end

    SocialFrame.OnClose()

    SocialFrame._index = index

    SocialFrame.OnOpen()

    SocialFrame.SetPageStatus()
end

function SocialFrame.OnClose()
    SL:CloseMenuLayerByID(SocialFrame._index)
end

function SocialFrame.OnOpen()
    SL:OpenMenuLayerByID(SocialFrame._index, SocialFrame._ui["AttachLayout"])
end

function SocialFrame.SetPageStatus()
    for _, uiPage in pairs(SocialFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == SocialFrame._index and true or false
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
                    GUI:Text_setString(SocialFrame._ui["TitleText"], titleStr)
                end
            end
        end
    end
end