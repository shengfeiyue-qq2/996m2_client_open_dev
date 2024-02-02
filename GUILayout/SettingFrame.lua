SettingFrame = {}

SettingFrame._GROUPID = 60
SettingFrame._Pages = {}
SettingFrame._index = 0
SettingFrame._ui = nil

-- 页签ID
SettingFrame._pageIDs = {
    SLDefine.SettingPage.SettingBasic,
    SLDefine.SettingPage.SettingWindowRange,
    SLDefine.SettingPage.SettingFight,
    SLDefine.SettingPage.SettingProtect,
    SLDefine.SettingPage.SettingAuto,
    SLDefine.SettingPage.SettingHelp,
}

function SettingFrame.main(skipPage)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_frame")
    SettingFrame._ui = GUI:ui_delegate(parent)

    local PMainUI = SettingFrame._ui["PMainUI"]
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(PMainUI, screenW / 2, screenH / 2)
    GUI:setContentSize(SettingFrame._ui.Panel_cancle, screenW, screenH)
    GUI:Win_SetZPanel(parent, PMainUI)

    -- 关闭按钮
    GUI:addOnClickEvent(SettingFrame._ui["CloseButton"], function() GUI:Win_Close(parent) end)
    --全屏关闭
    GUI:addOnClickEvent(SettingFrame._ui.Panel_cancle,function() GUI:Win_Close(parent)end)

    SettingFrame._Pages = {}
    SettingFrame._index = 0

    for i, layerId in ipairs(SettingFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = SettingFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        if SL:CheckMenuLayerConditionByID(layerId) then
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SettingFrame.PageTo(layerId)
            end)
        else
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SL:ShowSystemTips("条件不满足!")
            end)
        end
        SettingFrame._Pages[btnName] = page
    end

    SettingFrame.PageTo(SettingFrame._pageIDs[skipPage or 1])
end

function SettingFrame.PageTo(index)
    if not index or SettingFrame._index == index then
        return false
    end

    SettingFrame.OnClose()

    SettingFrame._index = index

    SettingFrame.OnOpen()
    SettingFrame.SetPageStatus()
end

function SettingFrame.GetCurPageID()
    return SettingFrame._index
end

function SettingFrame.OnClose()
    SL:CloseMenuLayerByID(SettingFrame._index)
end

function SettingFrame.OnOpen()
    if SettingFrame._ui and SettingFrame._ui["AttachLayout"] then
        SL:OpenMenuLayerByID(SettingFrame._index, SettingFrame._ui["AttachLayout"])
    end
end

function SettingFrame.SetPageStatus()
    for k, uiPage in pairs(SettingFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == SettingFrame._index and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, 16)
                GUI:Text_setTextColor(uiText, isSel and "#f8e6c6" or "#807256")
                GUI:Text_enableOutline(uiText, "#111111", 2)
                if isSel then
                    SettingFrame.UpdateTitle(string.gsub(GUI:Text_getString(uiText), "\n", ""))
                end
            end
        end
    end
end

function SettingFrame.UpdateTitle(text)
    if not SettingFrame._ui then
        return false
    end
    if not SettingFrame._ui["TitleText"] then
        return false
    end
    SettingFrame._ui.TitleText:setString(text)
end