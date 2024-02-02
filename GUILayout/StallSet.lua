StallSet = {}

function StallSet.main()
    local parent = GUI:Attach_Parent()

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "stall/stall_set_layer_win32")
    else
        GUI:LoadExport(parent, "stall/stall_set_layer")
    end

    StallSet._ui = GUI:ui_delegate(parent)
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(StallSet._ui.PMainUI, winSizeW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or winSizeH / 2)
    
end