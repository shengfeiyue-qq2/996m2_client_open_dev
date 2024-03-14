LoginAccount = {}

function LoginAccount.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "login_account/login_account")

    LoginAccount._parent = parent
    LoginAccount._ui = GUI:ui_delegate(parent)
end