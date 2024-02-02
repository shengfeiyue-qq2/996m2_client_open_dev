CommonBubbleInfo = {}

function CommonBubbleInfo.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_bubble_info")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonBubbleInfo._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonBubbleInfo._ui.Panel_1, screenW, screenH)
end