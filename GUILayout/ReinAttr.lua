
ReinAttr = {}

function ReinAttr.main()
    local parent = GUI:Attach_Parent()

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "rein_attr/rein_attr_panel_win32")
    else
        GUI:LoadExport(parent, "rein_attr/rein_attr_panel")
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    ReinAttr._ui = GUI:ui_delegate(parent)
    GUI:setPosition(ReinAttr._ui.Panel_1, screenW / 2, isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    -- 可拖拽
    GUI:Win_SetDrag(parent, ReinAttr._ui.Panel_1)
    GUI:Win_SetZPanel(parent, ReinAttr._ui.Panel_1)

    -- 属性行间隔
    ReinAttr._interval = SL:GetMetaValue("WINPLAYMODE") and 2 or 4
end