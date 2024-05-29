
SetWinSizePop = {}

SetWinSizePop._resolutions = {      -- 分辨率切换列表
    {width= 1920,   height = 1080},
    {width= 1600,   height = 1024},
    {width= 1600,   height = 900},
    {width= 1440,   height = 900},
    {width= 1366,   height = 768},
    {width= 1280,   height = 800},
    {width= 1280,   height = 768},
    {width= 1152,   height = 864},
    {width= 1024,   height = 768},
    {width= 800,    height = 600},
}

function SetWinSizePop.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/set_win_size_pop")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    SetWinSizePop._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(SetWinSizePop._ui.Panel_cancel, screenW, screenH)
    GUI:setPosition(SetWinSizePop._ui.PMainUI, screenW / 2, SL:GetMetaValue("PC_POS_Y"))

    GUI:Win_SetDrag(parent, SetWinSizePop._ui.PMainUI)
    GUI:Win_SetZPanel(parent, SetWinSizePop._ui.PMainUI)
end