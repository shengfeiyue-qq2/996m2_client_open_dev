LoginServer = {}

function LoginServer.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.LoginServerGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.LoginServerGUI, 0, 0, 0, 0, false, false, false, false, nil, nil, GUIDefine.UIZ.NORMAL)
    GUI:LoadExport(parent, "login_account/login_server")

    LoginServer._layer = parent
    LoginServer._ui = GUI:ui_delegate(parent)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local path = string.format("res/private/login/open_door/%02d.png", 0)
    LoginServer._bg = LoginServer._ui.Image_login_bg
    GUI:Image_loadTexture(LoginServer._bg, path)
    GUI:setContentSize(LoginServer._bg, screenW, screenH)
    GUI:setPosition(LoginServer._bg, screenW / 2, screenH / 2)

    -- 先下载资源
    local index = 0
    while true do
        index = index + 1
        local textureFile = string.format("res/private/login/open_door/%02d.png", index)
        if not SL:IsRemoteFileExist(textureFile) then
            break
        end
        SL:LoadRemoteRes(textureFile)
    end
    
    LoginServer.RegisterEvent()
end

function LoginServer.OnLoginServerSuccess()
    SL:StopAudioBGM()
    SL:PlayLoginOpenDoorAudio()

    -- 开门动画
    GUI:stopAllActions(LoginServer._bg)
    local index = 1
    local textureFile = nil
    local function callback()
        if textureFile then
            SL:RemoveTextureForKey(textureFile)
        end
        textureFile = string.format("res/private/login/open_door/%02d.png", index)
        if SL:IsRemoteFileExist(textureFile) then
            GUI:Image_loadTexture(LoginServer._bg, textureFile)
        else
            GUI:stopAllActions(LoginServer._bg)
            SL:SwitchGameStateToRole()
        end

        index = index + 1
    end
    SL:schedule(LoginServer._bg, callback, 0.1)
end

function LoginServer.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_SERVER_SUCCESS, "LoginServer", LoginServer.OnLoginServerSuccess, LoginServer._layer)
end

LoginServer.main()