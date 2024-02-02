TreasureBox = {}

function TreasureBox.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "treasure_box/treasure_box")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    TreasureBox._ui = GUI:ui_delegate(parent)
    GUI:setPosition(TreasureBox._ui.PMainUI, screenW / 2, screenH / 2)
end