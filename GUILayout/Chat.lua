Chat = {}

function Chat.main(parent)
    GUI:LoadExport(parent, "chat/chat_main")
    Chat._ui = GUI:ui_delegate(parent)
    Chat.parent = parent
end