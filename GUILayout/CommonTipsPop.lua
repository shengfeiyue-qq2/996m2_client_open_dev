
CommonTipsPop = {}

function CommonTipsPop.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/common_tips")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    CommonTipsPop._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(CommonTipsPop._ui.Layout, screenW, screenH)
    GUI:setPosition(CommonTipsPop._ui.PMainUI, screenW / 2, screenH / 2)
end