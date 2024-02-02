Stall = {}

function Stall.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "stall/stall_layer_win32")
    else
        GUI:LoadExport(parent, "stall/stall_layer")
    end

    Stall._ui = GUI:ui_delegate(parent)
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")

    GUI:Win_SetZPanel(parent, Stall._ui.PMainUI)
    GUI:Win_SetDrag(parent, Stall._ui.Image_move)

    GUI:setPositionY(Stall._ui.PMainUI, isWinMode and SL:GetMetaValue("PC_POS_Y") or winSizeH / 2)
    
end