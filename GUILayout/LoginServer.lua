LoginServer = {}

function LoginServer.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "login_account/login_server")

    LoginServer._parent = parent
    LoginServer._ui = GUI:ui_delegate(parent)
end