GameWorldConfirm = {}

function GameWorldConfirm.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "game_world_confirm")

    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    -- 屏蔽触摸
    local TouchLayout = ui["TouchLayout"]
    GUI:setContentSize(TouchLayout, screenW, screenH)

    -- 背景图
    local ConfirmBG = ui["ConfirmBG"]
    GUI:setPosition(ConfirmBG, screenW / 2, screenH / 2)
end