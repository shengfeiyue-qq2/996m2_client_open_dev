StoreFrame = {}

function StoreFrame.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "store/store_frame")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    StoreFrame._ui = ui
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, ui["pBg"])
        GUI:setMouseEnabled(ui["pBg"], true)
    end

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    GUI:setContentSize(ui["Layout"], screenW, screenH)
    GUI:setPosition(ui["PMainUI"], screenW / 2, screenH / 2)

    StoreFrame:InitEvent()
end

function StoreFrame:InitEvent()
    -- 关闭
    GUI:addOnClickEvent(StoreFrame._ui["Button_close"], function () SL:CloseStoreUI() end)

    -- 页签
    GUI:addOnClickEvent(StoreFrame._ui["Page1"], function() StoreFrame.PageTo(1) end)
    GUI:addOnClickEvent(StoreFrame._ui["Page2"], function() StoreFrame.PageTo(2) end)
    GUI:addOnClickEvent(StoreFrame._ui["Page3"], function() StoreFrame.PageTo(3) end)
    GUI:addOnClickEvent(StoreFrame._ui["Page4"], function() StoreFrame.PageTo(4) end)
    GUI:addOnClickEvent(StoreFrame._ui["Page5"], function() StoreFrame.PageTo(5) end)
end