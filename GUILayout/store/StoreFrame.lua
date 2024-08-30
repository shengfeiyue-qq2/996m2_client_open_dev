StoreFrame = {}

StoreFrame.MEMU_GROUPID = 9

-- 页签ID
StoreFrame._pageIDs = {
    UIConst.LayerTable.StoreHot,
    UIConst.LayerTable.StoreBeauty,
    UIConst.LayerTable.StoreEngine,
    UIConst.LayerTable.StoreFestival,
    UIConst.LayerTable.StoreRecharge
}

StoreFrame._pageCloseEvent = {
    [UIConst.LayerTable.StoreHot] = LUA_EVENT_STORE_HOT_LAYER_CLOSE,
    [UIConst.LayerTable.StoreBeauty] = LUA_EVENT_STORE_BEAUTY_LAYER_CLOSE,
    [UIConst.LayerTable.StoreEngine] = LUA_EVENT_STORE_ENGINE_LAYER_CLOSE,
    [UIConst.LayerTable.StoreFestival] = LUA_EVENT_STORE_FESTIVAL_LAYER_CLOSE,
    [UIConst.LayerTable.StoreRecharge] = LUA_EVENT_STORE_RECHARGE_LAYER_CLOSE,
}

StoreFrame._pageOpenFile = {
    [UIConst.LayerTable.StoreHot] = UIConst.LUAFile.LUA_FILE_STORE_PAGE,
    [UIConst.LayerTable.StoreBeauty] = UIConst.LUAFile.LUA_FILE_STORE_PAGE,
    [UIConst.LayerTable.StoreEngine] = UIConst.LUAFile.LUA_FILE_STORE_PAGE,
    [UIConst.LayerTable.StoreFestival] = UIConst.LUAFile.LUA_FILE_STORE_PAGE,
    [UIConst.LayerTable.StoreRecharge] = UIConst.LUAFile.LUA_FILE_STORE_RECHARGE,
}

function StoreFrame.main()
    local index = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    StoreFrame._layer = GUI:Win_Create(UIConst.LAYERID.StoreFrameGUI, 0, 0, 0, 0, false, false, true, true)
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")

    if isWinMode then
        GUI:LoadExport(StoreFrame._layer, "store/store_frame_win32")
    else
        GUI:LoadExport(StoreFrame._layer, "store/store_frame")
    end
    StoreFrame._ui = GUI:ui_delegate(StoreFrame._layer)

    StoreFrame._Pages = {}
    StoreFrame._pageID = 0
    StoreFrame._index = index or 1

    local CloseLayout = StoreFrame._ui["CloseLayout"]
    local FrameLayout = StoreFrame._ui["FrameLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:setPosition(FrameLayout, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(CloseLayout, false)
        GUI:setPosition(FrameLayout, winSizeW / 2, SL:GetValue("PC_POS_Y"))

        -- 可拖拽
        GUI:Win_SetDrag(StoreFrame._layer, FrameLayout)
        GUI:Win_SetZPanel(StoreFrame._layer, FrameLayout)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(StoreFrame._layer)
        end)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(StoreFrame._ui["CloseButton"], function()
        GUI:Win_Close(StoreFrame._layer)
    end)

    for i, layerId in ipairs(StoreFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = StoreFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
            StoreFrame._index = i;
            StoreFrame.PageTo(layerId)
        end)
        StoreFrame._Pages[btnName] = page
    end

    -- 默认跳到第一个
    StoreFrame.PageTo(StoreFrame._pageIDs[index or 1])

    StoreFrame.RegisterEvent()

end

function StoreFrame.PageTo(pageID)
    if not pageID or StoreFrame._pageID == pageID then
        return
    end

    StoreFrame.OnClose()

    StoreFrame._pageID = pageID

    StoreFrame.OnOpen()

    StoreFrame.SetPageStatus()
end

function StoreFrame.OnClose()
    SL:onLUAEvent(StoreFrame._pageCloseEvent[StoreFrame._pageID])
    SL:onLUAEvent(LUA_EVENT_STORE_BUY_CLOSE)
    GUI:removeAllChildren(StoreFrame._ui.AttachLayout)
end

function StoreFrame.OnOpen()
    GUI:SetLayerOpenParam({parent = StoreFrame._ui.AttachLayout, index = StoreFrame._index})
    GUI:Win_Open(StoreFrame._pageOpenFile[StoreFrame._pageID])
end

function StoreFrame.SetPageStatus()
    for _, uiPage in pairs(StoreFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == StoreFrame._pageID and true or false
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
                    GUI:Text_setString(StoreFrame._ui["TitleText"], titleStr)
                end
            end
        end
    end
end

function StoreFrame.OnCloseLayer(UID)
    if UID ~= UIConst.LAYERID.StoreFrameGUI then
        return false
    end
    
    SL:onLUAEvent(LUA_EVENT_STORE_BUY_CLOSE)
    StoreFrame.OnClose()
    StoreFrame.UnRegisterEvent()
    StoreFrame._layer = nil
end
function StoreFrame.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "StoreFrame", StoreFrame.OnCloseLayer)
end

function StoreFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "StoreFrame")
end

StoreFrame.main()