AutoUsePop = {}

function AutoUsePop.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "auto_use_pop")

    AutoUsePop._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local posY     = 140
    local baseOffX = 350
    local screenH  = SL:GetMetaValue("SCREEN_HEIGHT")
    local PPopUI   = AutoUsePop._ui["PPopUI"]
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:Win_SetDrag(parent, PPopUI)
        GUI:setMouseEnabled(PPopUI, true)
        baseOffX = 220
        posY = screenH - 330 - GUI:getContentSize(PPopUI).height
    end

    local notch, rect = SL:GetMetaValue("NOTCH_PHONE_INFO")
    if notch then
        baseOffX = baseOffX + rect.x
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(AutoUsePop._ui["Node"], screenW - baseOffX, posY)
end