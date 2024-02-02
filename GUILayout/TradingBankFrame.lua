TradingBankFrame = {}

TradingBankFrame._GROUPID = 111
TradingBankFrame._Pages = {}
TradingBankFrame._index = 0
TradingBankFrame._ui = nil

-- 页签ID
TradingBankFrame._pageIDs = {
    SLDefine.TradingBankPage.Buy,
    SLDefine.TradingBankPage.Sell,
    SLDefine.TradingBankPage.Goods,
    SLDefine.TradingBankPage.Mine,
}

function TradingBankFrame.main(skipPage)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "tradingbank/trading_bank_frame")
    TradingBankFrame._ui = GUI:ui_delegate(parent)

    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")

    local PMainUI = TradingBankFrame._ui["PMainUI"]
    GUI:setPosition(PMainUI, winSizeW / 2, winSizeH / 2)

    GUI:Win_SetDrag(parent, PMainUI)
    GUI:setMouseEnabled(PMainUI, true)

    -- 关闭按钮
    GUI:addOnClickEvent(TradingBankFrame._ui["CloseButton"], function() GUI:Win_Close(parent) end)

    TradingBankFrame._Pages = {}
    TradingBankFrame._index = 0

    local posY = 380
    local distance = 75

    for i, layerId in ipairs(TradingBankFrame._pageIDs) do
        local btnName = "page_cell_"..i
        local page = TradingBankFrame._ui[btnName]
        GUI:Win_SetParam(page, layerId)
        if SL:CheckMenuLayerConditionByID(layerId) then
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                TradingBankFrame.PageTo(layerId)
                SL:RequestTradingBankBtnUpload(i)
            end)
        else
            GUI:addOnClickEvent(GUI:getChildByName(page, "TouchSize"), function()
                SL:ShowSystemTips("条件不满足!")
            end)
        end
        TradingBankFrame._Pages[btnName] = page
    end
    TradingBankFrame.PageTo(TradingBankFrame._pageIDs[skipPage or 1])
end

function TradingBankFrame.PageTo(index)
    if not index or TradingBankFrame._index == index then
        return false
    end

    TradingBankFrame.OnClose()

    TradingBankFrame._index = index

    TradingBankFrame.OnOpen()
    TradingBankFrame.SetPageStatus()
end

function TradingBankFrame.OnClose()
    SL:CloseMenuLayerByID(TradingBankFrame._index)
end

function TradingBankFrame.getCurPageID()
    return TradingBankFrame._index
end

function TradingBankFrame.changPageById(id)
    TradingBankFrame.PageTo(id)
end

function TradingBankFrame.OnOpen()
    if TradingBankFrame._ui and TradingBankFrame._ui["AttachLayout"] then
        SL:OpenMenuLayerByID(TradingBankFrame._index, TradingBankFrame._ui["AttachLayout"])
    end
end

function TradingBankFrame.SetPageStatus()
    for k, uiPage in pairs(TradingBankFrame._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == TradingBankFrame._index and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, SL:GetMetaValue("WINPLAYMODE") and 13 or 16)
                local selColor = SL:GetMetaValue("WINPLAYMODE") and "#e6e7a7" or "#f8e6c6"
                GUI:Text_setTextColor(uiText, isSel and selColor or "#807256")
                GUI:Text_enableOutline(uiText, "#111111", 2)
                if isSel then
                    TradingBankFrame.UpdateTitle(string.gsub(GUI:Text_getString(uiText), "\n", ""))
                end
            end
        end
    end
end

function TradingBankFrame.UpdateTitle(text)
    if not TradingBankFrame._ui then
        return false
    end
    if not TradingBankFrame._ui["TitleText"] then
        return false
    end
    TradingBankFrame._ui.TitleText:setString(text)
end