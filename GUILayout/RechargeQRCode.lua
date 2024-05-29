
RechargeQRCode = {}

function RechargeQRCode.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "store/store_recharge_qrcode_panel_win32")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    RechargeQRCode._ui = GUI:ui_delegate(parent)
    GUI:setPosition(RechargeQRCode._ui.PMainUI, screenW / 2, SL:GetMetaValue("PC_POS_Y"))
    GUI:Win_SetZPanel(parent, RechargeQRCode._ui.PMainUI)

end