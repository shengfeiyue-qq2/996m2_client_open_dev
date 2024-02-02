MiniMap = {}

function MiniMap.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "minimap/mini_map_win32")

    local ui      = GUI:ui_delegate(parent)
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(ui["Panel_2"], screenW / 2, SL:GetMetaValue("PC_POS_Y"))
end