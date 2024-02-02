
CommonVerification = {}

function CommonVerification.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_verification")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")

    CommonVerification._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonVerification._ui.Panel_1, screenW, screenH)
    GUI:setPosition(CommonVerification._ui.Image_panel, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    GUI:Win_SetDrag(parent, CommonVerification._ui.Image_panel)
end