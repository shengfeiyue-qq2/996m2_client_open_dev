StoreFrame = {}

StoreFrame.MEMU_GROUPID = 9

-- 页签ID
StoreFrame._pageIDs = {
    SLDefine.StorePage.StoreHot,
    SLDefine.StorePage.StoreBeauty,
    SLDefine.StorePage.StoreEngine,
    SLDefine.StorePage.StoreFestival,
    SLDefine.StorePage.StoreRecharge
}

function StoreFrame.main(index)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")

    if isWinMode then
        GUI:LoadExport(parent, "store/store_frame_win32")
    else
        GUI:LoadExport(parent, "store/store_frame")
    end
    StoreFrame._ui = GUI:ui_delegate(parent)

    StoreFrame._Pages = {}
    StoreFrame._index = 0

    local CloseLayout = StoreFrame._ui["CloseLayout"]
    local FrameLayout = StoreFrame._ui["FrameLayout"]
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
    GUI:addOnClickEvent(StoreFrame._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    for i, layerId in ipairs(StoreFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = StoreFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        if SL:CheckMenuLayerConditionByID(layerId) then
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                StoreFrame.PageTo(layerId)
            end)
        else
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SL:ShowSystemTips("条件不满足!")
            end)
        end
        StoreFrame._Pages[btnName] = page
    end

    -- 默认跳到第一个
    StoreFrame.PageTo(StoreFrame._pageIDs[index or 1])
end

function StoreFrame.PageTo(index)
    if not index or StoreFrame._index == index then
        return
    end

    StoreFrame.OnClose()

    StoreFrame._index = index

    StoreFrame.OnOpen()

    StoreFrame.SetPageStatus()
end

function StoreFrame.OnClose()
    SL:CloseMenuLayerByID(StoreFrame._index)
end

function StoreFrame.OnOpen()
    SL:OpenMenuLayerByID(StoreFrame._index, StoreFrame._ui["AttachLayout"])
end

function StoreFrame.SetPageStatus()
    for _, uiPage in pairs(StoreFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == StoreFrame._index and true or false
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
                    GUI:Text_setString(StoreFrame._ui["TitleText"], titleStr)
                end
            end
        end
    end
end