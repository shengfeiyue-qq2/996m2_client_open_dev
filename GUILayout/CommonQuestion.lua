
CommonQuestion = {}

function CommonQuestion.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_question")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")

    CommonQuestion._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonQuestion._ui.Panel_1, screenW, screenH)
    GUI:setPosition(CommonQuestion._ui.Image_bg, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    GUI:Win_SetDrag(parent, CommonQuestion._ui.Image_bg)
end