
PrivateChat = {}

function PrivateChat.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "chat/private_chat_win32")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    PrivateChat._ui = GUI:ui_delegate(parent)
    GUI:setPosition(PrivateChat._ui.Panel_1, screenW / 2, SL:GetMetaValue("PC_POS_Y"))

    -- 设置拖拽
    GUI:Win_SetDrag(parent, PrivateChat._ui.Panel_1)
    GUI:Win_SetZPanel(parent, PrivateChat._ui.Panel_1)
end