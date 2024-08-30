SettingFrame = {}

SettingFrame._pages = {}
SettingFrame._index = 0
SettingFrame._ui = nil

-- 页签ID
SettingFrame._pageIDs = {
    UIConst.LayerTable.SettingBasic,
    UIConst.LayerTable.SettingFight,
    UIConst.LayerTable.SettingProtect,
    UIConst.LayerTable.SettingAuto,
    UIConst.LayerTable.SettingHelp,
}

function SettingFrame.main(skipPage)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_frame_win32")
    SettingFrame._ui = GUI:ui_delegate(parent)

    local PMainUI = SettingFrame._ui["PMainUI"]
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPosition(PMainUI, screenW / 2, SL:GetValue("PC_POS_Y"))
    GUI:Win_SetDrag(parent, PMainUI)
    GUI:Win_SetZPanel(parent, PMainUI)

    -- 关闭按钮
    GUI:addOnClickEvent(SettingFrame._ui["CloseButton"], function() GUI:Win_Close(parent) end)

    SettingFrame._pages = {}
    SettingFrame._index = 0

    for i, layerId in ipairs(SettingFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = SettingFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
            SettingFrame.PageTo(layerId)
        end)
        SettingFrame._pages[btnName] = page
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
    UIOperator:ClosePanelByID(SettingFrame._index)
end

function SettingFrame.OnOpen()
    if SettingFrame._ui and SettingFrame._ui["AttachLayout"] then
        UIOperator:OpenPanelByID(SettingFrame._index, SettingFrame._ui["AttachLayout"])
    end 
end

function SettingFrame.SetPageStatus()
    for k, uiPage in pairs(SettingFrame._pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == SettingFrame._index and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, 13)
                GUI:Text_setTextColor(uiText, isSel and "#e6e7a7" or "#807256")
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