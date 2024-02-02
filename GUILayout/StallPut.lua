StallPut = {}
StallPut._currencyShowStr = "%s出售"    -- 货币展示格式

function StallPut.main(data)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "stall/stall_put_layer_win32")
    else
        GUI:LoadExport(parent, "stall/stall_put_layer")
    end
    
    StallPut._ui = GUI:ui_delegate(parent)
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(StallPut._ui.PMainUI, winSizeW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or winSizeH / 2)

    GUI:Win_SetZPanel(parent, StallPut._ui.PMainUI)

end