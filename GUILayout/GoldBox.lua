GoldBox = {}

function GoldBox.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "treasure_box/gold_box_panel_win32")
    else
        GUI:LoadExport(parent, "treasure_box/gold_box_panel")
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    GoldBox._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(GoldBox._ui.Panel_1, screenW, screenH)
    GUI:setPosition(GoldBox._ui.Panel_1, screenW / 2, screenH / 2)

    GUI:setPosition(GoldBox._ui.Panel_main, screenW / 2, screenH * 62.5 / 100)
end