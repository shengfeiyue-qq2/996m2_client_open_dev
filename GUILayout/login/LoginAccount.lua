LoginAccount = {}

local strim = string.trim
local slen = string.len

function LoginAccount.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.LoginAccountGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.LoginAccountGUI, 0, 0, 0, 0, false, false, false, false, nil, nil, GUIDefine.UIZ.NORMAL, LoginAccount.handlePressedEnter)
    LoginAccount._layer = parent
    GUI:LoadExport(parent, "login_account/login_account")

    LoginAccount._ui = GUI:ui_delegate(parent)

    LoginAccount._inputMaxLength = 50
    LoginAccount._placeHolderColor = "#FFFFFF"

    LoginAccount._loginType = 1 -- 账号登录方式 1: 账号密码 2: 手机号验证码
    LoginAccount._requestDelay = false
    LoginAccount._isEditing = false

    LoginAccount._screenW = SL:GetValue("SCREEN_WIDTH")
    LoginAccount._screenH = SL:GetValue("SCREEN_HEIGHT")
    LoginAccount.InitUI()

    SL:PlayAudioBGMByType(GUIDefine.BGMType.LOGIN)

    LoginAccount.RegisterEvent()
end

function LoginAccount.InitUI()

    -- 登录
    GUI:addOnClickEvent(LoginAccount._ui.Button_submit, function()
        GUI:delayTouchEnabled(LoginAccount._ui.Button_submit, 1)
        LoginAccount.RequestLogin()
    end)

    -- 注册
    GUI:addOnClickEvent(LoginAccount._ui.Button_register, function()
        LoginAccount.ShowRegister()
    end)

    -- 修改密保
    GUI:addOnClickEvent(LoginAccount._ui.Button_change_question, function()
        LoginAccount.ShowChangeQuestion()
    end)

    -- 修改密码
    GUI:addOnClickEvent(LoginAccount._ui.Button_change_password, function()
        LoginAccount.ShowChangePassword()
    end)

    -- 绑定手机
    GUI:addOnClickEvent(LoginAccount._ui.Button_bind_phone, function()
        LoginAccount.ShowBindPhone()
    end)

    -- 修改手机
    GUI:addOnClickEvent(LoginAccount._ui.Button_change_phone, function()
        LoginAccount.ShowChangePhone()
    end)

    -- 实名认证
    GUI:addOnClickEvent(LoginAccount._ui.Button_identify, function()
        LoginAccount.ShowIdentifyID()
    end)

    GUI:addOnClickEvent(LoginAccount._ui.Text_phone, function()
        LoginAccount._loginType = 2
        LoginAccount.ChangeLoginPanelByType()
    end)

    GUI:addOnClickEvent(LoginAccount._ui.Text_account, function()
        LoginAccount._loginType = 1
        LoginAccount.ChangeLoginPanelByType()
    end)

    LoginAccount.InitLogin()
    LoginAccount.InitLoginByPhone()
    LoginAccount.InitAdapte()

    LoginAccount.ChangeLoginPanelByType()
    LoginAccount.FillCurrent()

    -- debug
    LoginAccount.InitResolutionUI()
    LoginAccount.InitIntroButton()
end

function LoginAccount.InitAdapte()
    local screenW = LoginAccount._screenW
    local screenH = LoginAccount._screenH

    GUI:setContentSize(LoginAccount._ui.Panel_bg, screenW, screenH)
    GUI:setVisible(LoginAccount._ui.Panel_bg, true)
    GUI:setPosition(LoginAccount._ui.Panel_bg, screenW / 2, screenH / 2)

    GUI:setPosition(LoginAccount._ui.Panel_login, screenW / 2, screenH / 2)

    GUI:Image_loadTexture(LoginAccount._ui.Image_bg, string.format("res/private/login/open_door/%02d.png", 0))
    GUI:setContentSize(LoginAccount._ui.Image_bg, screenW, screenH)
    GUI:setPosition(LoginAccount._ui.Image_bg, screenW / 2, screenH / 2)

end

local needRefreshInputKeys = {
    ["TextField_username"] = true,
    ["TextField_password"] = true,
    ["TextField_phoneId"] = true,
    ["TextField_authcode"] = true
}

local function checkNeedRefreshShow(sender)
    local name = GUI:getName(sender)
    if name and needRefreshInputKeys[name] then
        LoginAccount.RefreshLoginTouched()
    end
end

local function checkPasswordIsSimple(password, account)
    if password and slen(password) < 6 then
        return true
    end
    if account == password then
        return true
    end
    if not string.match(password, "[^%d]") then
        return true
    end
    if not string.match(password, "[^%a]") then
        return true
    end
    return false
end

local function inputLimitCB(sender)
    local input = GUI:TextInput_getString(sender)

    -- 排除空格
    GUI:TextInput_setString(sender, strim(input))

    -- 数字 字母 下划线 破折号
    GUI:TextInput_setString(sender, string.gsub(input, "[^A-Za-z0-9_%-]", ""))

    checkNeedRefreshShow(sender)
end

local function inputLimitNormalCB(sender)
    local input = GUI:TextInput_getString(sender)

    -- 排除空格
    GUI:TextInput_setString(sender, strim(input))
end

local function inputLimitNumberCB(sender)
    local input = GUI:TextInput_getString(sender)

    -- 排除空格
    GUI:TextInput_setString(sender, strim(input))

    -- 替换非字母数字
    GUI:TextInput_setString(sender, string.gsub(input, "[^%d]", ""))

    checkNeedRefreshShow(sender)
end

local function findNextEditBox(sender, inputList)
    local findIndex = 1
    for index, value in ipairs(inputList) do
        if sender == value then
            findIndex = index
            break
        end
    end

    if findIndex == #inputList then
        return inputList[1]
    end
    return inputList[findIndex + 1]
end

local function commonInputCB(sender, eventType, inputList, exitCB)
    if eventType == GUIDefine.TextInputEventType.CHANGE then
        local input = GUI:TextInput_getString(sender)

        if string.find(input, "\t") then
            GUI:TextInput_closeInput(sender)
            exitCB(sender)

            local nextEditBox = findNextEditBox(sender, inputList)
            GUI:TextInput_touchDownAction(nextEditBox, 2)

        elseif string.find(input, "\n") then
            GUI:TextInput_closeInput(sender)
            exitCB(sender)
        end
    elseif eventType == GUIDefine.TextInputEventType.ENDED or eventType == GUIDefine.TextInputEventType.RETURN or eventType == GUIDefine.TextInputEventType.SEND then
        exitCB(sender)
    end
end

function LoginAccount.InitLogin()
    -- 输入框
    GUI:TextInput_setMaxLength(LoginAccount._ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setInputFlag(LoginAccount._ui.TextField_password, 0)

    GUI:TextInput_setPlaceholderFontColor(LoginAccount._ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(LoginAccount._ui.TextField_password, LoginAccount._placeHolderColor)

    local inputList = {}
    table.insert(inputList, LoginAccount._ui.TextField_username)
    table.insert(inputList, LoginAccount._ui.TextField_password)

    -- 账号输入
    local function accountInputCB(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end
    GUI:TextInput_addOnEvent(LoginAccount._ui.TextField_username, accountInputCB)

    -- 密码输入
    local function passwordInputCB(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end
    GUI:TextInput_addOnEvent(LoginAccount._ui.TextField_password, passwordInputCB)
end

function LoginAccount.InitLoginByPhone()
    -- 输入框
    GUI:TextInput_setMaxLength(LoginAccount._ui.TextField_phoneId, 11)
    GUI:TextInput_setMaxLength(LoginAccount._ui.TextField_authcode, 6)
    GUI:TextInput_setInputFlag(LoginAccount._ui.TextField_phoneId, 3)
    GUI:TextInput_setInputFlag(LoginAccount._ui.TextField_authcode, 3)

    GUI:TextInput_setPlaceholderFontColor(LoginAccount._ui.TextField_phoneId, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(LoginAccount._ui.TextField_authcode, LoginAccount._placeHolderColor)

    local inputList = {}
    table.insert(inputList, LoginAccount._ui.TextField_phoneId)
    table.insert(inputList, LoginAccount._ui.TextField_authcode)

    local function inputCB(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end
    -- 手机号
    GUI:TextInput_addOnEvent(LoginAccount._ui.TextField_phoneId, inputCB)
    -- 验证码
    GUI:TextInput_addOnEvent(LoginAccount._ui.TextField_authcode, inputCB)

    -- 获取验证码
    GUI:setVisible(LoginAccount._ui.Text_remaining, false)
    GUI:addOnClickEvent(LoginAccount._ui.Button_authcode, function()
        LoginAccount.OnClickAuthCodeBtnEvent(LoginAccount._ui.Button_authcode, LoginAccount._ui.TextField_phoneId, LoginAccount._ui.Text_remaining)
    end)
end

function LoginAccount.FillCurrent()
    local username = SL:GetValue("LOGIN_ACCOUNT")
    local password = SL:GetValue("LOGIN_PASSWORD")

    if username and password then
        GUI:TextInput_setString(LoginAccount._ui.TextField_username, username)
        GUI:TextInput_setString(LoginAccount._ui.TextField_password, password)
    end

    LoginAccount.RefreshLoginTouched()
end

function LoginAccount.ChangeLoginPanelByType()
    if LoginAccount._loginType == 1 then
        GUI:setVisible(LoginAccount._ui.Panel_account, true)
        GUI:setVisible(LoginAccount._ui.Panel_phone, false)
        GUI:setVisible(LoginAccount._ui.Text_phone, true)
        GUI:setTouchEnabled(LoginAccount._ui.Text_phone, true)
        GUI:setVisible(LoginAccount._ui.Text_account, false)
    elseif LoginAccount._loginType == 2 then
        GUI:setVisible(LoginAccount._ui.Panel_account, false)
        GUI:setVisible(LoginAccount._ui.Panel_phone, true)
        GUI:setVisible(LoginAccount._ui.Text_phone, false)
        GUI:setTouchEnabled(LoginAccount._ui.Text_account, true)
        GUI:setVisible(LoginAccount._ui.Text_account, true)
        GUI:TextInput_setString(LoginAccount._ui.TextField_authcode, "")
    end

    LoginAccount.RefreshLoginTouched()
end

function LoginAccount.RefreshLoginTouched()
    local strUserName = GUI:TextInput_getString(LoginAccount._ui[LoginAccount._loginType == 1 and "TextField_username" or "TextField_phoneId"])
    local strPassword = GUI:TextInput_getString(LoginAccount._ui[LoginAccount._loginType == 1 and "TextField_password" or "TextField_authcode"])
    
    if strUserName and slen(strUserName) > 0 and strPassword and slen(strPassword) > 0 then
        GUI:Button_setBrightEx(LoginAccount._ui.Button_submit, true)
    else
        GUI:Button_setBrightEx(LoginAccount._ui.Button_submit, false)
    end
end

-----------------------------------------------------------------
function LoginAccount.HideAllExt()
    LoginAccount._isEditing = false
    GUI:removeAllChildren(LoginAccount._ui.Node_ext)
end

-- 登录
function LoginAccount.RequestLogin()
    if LoginAccount._requestDelay then
        return false
    end
    LoginAccount._requestDelay = true
    SL:ScheduleOnce(function()
        LoginAccount._requestDelay = false
    end, 1)

    if LoginAccount._loginType == 1 then
        -- 账号密码登录
        local username = strim(GUI:TextInput_getString(LoginAccount._ui.TextField_username))
        local password = strim(GUI:TextInput_getString(LoginAccount._ui.TextField_password))

        if slen(username) <= 0 or slen(password) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end

        SL:RequestLoginAccount(username, password)
    else
        -- 手机号登录
        local phoneId = strim(GUI:TextInput_getString(LoginAccount._ui.TextField_phoneId))
        local authCode = strim(GUI:TextInput_getString(LoginAccount._ui.TextField_authcode))

        if slen(phoneId) <= 0 or slen(authCode) <= 0 then
            SL:ShowSystemTips("手机号或验证码不能为空")
            return
        end

        SL:RequestLoginAccountByPhone(phoneId, authCode)
    end
end

function LoginAccount.handlePressedEnter()
    if LoginAccount._isEditing then
        return
    end
    LoginAccount.RequestLogin()
end

----------------------------------------------------
--- 注册
function LoginAccount.ShowRegister()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_register")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_password, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_password_confirm, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_question, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_answer, LoginAccount._inputMaxLength)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_password, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_password_confirm, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_question, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_answer, LoginAccount._placeHolderColor)

    GUI:TextInput_setInputFlag(ui.TextField_password, 0)
    GUI:TextInput_setInputFlag(ui.TextField_password_confirm, 0)

    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_password)
    table.insert(inputList, ui.TextField_password_confirm)
    table.insert(inputList, ui.TextField_question)
    table.insert(inputList, ui.TextField_answer)

    -- 账号
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 密码
    GUI:TextInput_addOnEvent(ui.TextField_password, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 确认密码
    GUI:TextInput_addOnEvent(ui.TextField_password_confirm, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 密保问题
    GUI:TextInput_addOnEvent(ui.TextField_question, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 密保答案
    GUI:TextInput_addOnEvent(ui.TextField_answer, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 请求注册
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username  = strim(GUI:TextInput_getString(ui.TextField_username))
        local password  = strim(GUI:TextInput_getString(ui.TextField_password))
        local passwordC = strim(GUI:TextInput_getString(ui.TextField_password_confirm))
        local question  = GUI:TextInput_getString(ui.TextField_question)
        local answer    = GUI:TextInput_getString(ui.TextField_answer)

        -- 输入为空
        if slen(username) <= 0 or slen(password) <= 0 or slen(passwordC) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end
        -- 密码和确认密码不同
        if passwordC ~= password then
            SL:ShowSystemTips("两次密码不同")
            return
        end
        -- 密保问题为空
        if slen(question) <= 0 then
            SL:ShowSystemTips("请检查密保问题")
            return
        end
        -- 密保答案为空
        if slen(answer) <= 0 then
            SL:ShowSystemTips("请检查密保答案")
            return
        end

        if checkPasswordIsSimple(password, username) then
            SL:ShowSystemTips("该账号密码过于简单，请修改强度较高的密码以保证账号安全")
            return
        end

        -- 注册
        local data = {}
        data.username   = username
        data.password   = password
        data.question   = question
        data.answer     = answer
        SL:RequestLoginRegisterAccount(data)
    end)
end

function LoginAccount.OnRegisterSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return 
    end
    SL:ShowSystemTips("注册成功")
    LoginAccount.HideAllExt()
    LoginAccount.FillCurrent()
end

----------------------------------------------------
--- 修改密保
function LoginAccount.ShowChangeQuestion()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_change_question")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_password, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_question, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_answer, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_question_new, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_answer_new, LoginAccount._inputMaxLength)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_password, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_question, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_answer, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_question_new, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_answer_new, LoginAccount._placeHolderColor)

    GUI:TextInput_setInputFlag(ui.TextField_password, 0)

    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_password)
    table.insert(inputList, ui.TextField_question)
    table.insert(inputList, ui.TextField_answer)
    table.insert(inputList, ui.TextField_question_new)
    table.insert(inputList, ui.TextField_answer_new)

    -- 账号
    local username = SL:GetValue("LOGIN_ACCOUNT")
    GUI:TextInput_setString(ui.TextField_username, username)
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 密码
    local password = SL:GetValue("LOGIN_PASSWORD")
    GUI:TextInput_setString(ui.TextField_password, password)
    GUI:TextInput_addOnEvent(ui.TextField_password, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 原密保问题
    GUI:TextInput_addOnEvent(ui.TextField_question, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 原密保答案
    GUI:TextInput_addOnEvent(ui.TextField_answer, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 新密保问题
    GUI:TextInput_addOnEvent(ui.TextField_question_new, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 新密保答案
    GUI:TextInput_addOnEvent(ui.TextField_answer_new, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username  = strim(GUI:TextInput_getString(ui.TextField_username))
        local password  = strim(GUI:TextInput_getString(ui.TextField_password))
        local question  = strim(GUI:TextInput_getString(ui.TextField_question))
        local answer    = strim(GUI:TextInput_getString(ui.TextField_answer))
        local questionN = strim(GUI:TextInput_getString(ui.TextField_question_new))
        local answerN   = strim(GUI:TextInput_getString(ui.TextField_answer_new))

        -- 输入为空
        if slen(username) <= 0 or slen(password) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end
        -- 密保问题为空
        if slen(question) <= 0 or slen(questionN) <= 0 then
            SL:ShowSystemTips("请检查密保问题")
            return
        end
        -- 密保答案为空
        if slen(answer) <= 0 or slen(answerN) <= 0 then
            SL:ShowSystemTips("请检查密保答案")
            return
        end

        -- 修改密保
        local data = {}
        data.username       = username
        data.password       = password
        data.question       = question
        data.answer         = answer
        data.question_new   = questionN
        data.answer_new     = answerN
        SL:RequestLoginChangeMbQuestion(data)
    end)
end

function LoginAccount.OnChangeMbQuestionSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
       return 
    end
    SL:ShowSystemTips("修改成功，请牢记您的新密保")
    LoginAccount.HideAllExt()
    LoginAccount.FillCurrent()
end

----------------------------------------------------
--- 修改密码
function LoginAccount.ShowChangePassword()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_change_pwd")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 切换
    GUI:addOnClickEvent(ui.Text_change, function()
        LoginAccount.HideAllExt()
        LoginAccount.ShowChangePasswordByPhone()
    end)
    
    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_password, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_question, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_answer, LoginAccount._inputMaxLength)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_password, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_question, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_answer, LoginAccount._placeHolderColor)

    GUI:TextInput_setInputFlag(ui.TextField_password, 0)

    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_question)
    table.insert(inputList, ui.TextField_answer)
    table.insert(inputList, ui.TextField_password)

    -- 账号
    local username = SL:GetValue("LOGIN_ACCOUNT")
    GUI:TextInput_setString(ui.TextField_username, username)
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 密保问题
    GUI:TextInput_addOnEvent(ui.TextField_question, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 密保答案
    GUI:TextInput_addOnEvent(ui.TextField_answer, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 密码
    GUI:TextInput_addOnEvent(ui.TextField_password, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username  = strim(GUI:TextInput_getString(ui.TextField_username))
        local password  = strim(GUI:TextInput_getString(ui.TextField_password))
        local question  = strim(GUI:TextInput_getString(ui.TextField_question))
        local answer    = strim(GUI:TextInput_getString(ui.TextField_answer))

        -- 输入为空
        if slen(username) <= 0 or slen(password) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end
        -- 密保问题为空
        if slen(question) <= 0 then
            SL:ShowSystemTips("请检查密保问题")
            return
        end
        -- 密保答案为空
        if slen(answer) <= 0 then
            SL:ShowSystemTips("请检查密保答案")
            return
        end

        if checkPasswordIsSimple(password, username) then
            SL:ShowSystemTips("该账号密码过于简单，请修改强度较高的密码以保证账号安全")
            return
        end

        -- 改密码
        local data = {}
        data.username       = username
        data.question       = question
        data.answer         = answer
        data.newpassword    = password
        SL:RequestLoginChangePasswordByMb(data)
    end)
end

function LoginAccount.OnChangePasswordSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return
    end
    SL:ShowSystemTips("修改成功，请牢记您的新密码")
    LoginAccount.HideAllExt()
    LoginAccount.FillCurrent()
end

---------------------------------------------------
--- 获取验证码按钮事件
function LoginAccount.OnClickAuthCodeBtnEvent(button, phoneInput, timeText)
    local phone = strim(GUI:TextInput_getString(phoneInput))

    -- 手机号
    if slen(phone) <= 0 or slen(phone) ~= 11 then
        SL:ShowSystemTips("请检查手机号")
        return
    end

    local remaining = 60
    local function callback()
        GUI:Text_setString(timeText, remaining)

        remaining = remaining - 1
        if remaining == 0 then
            GUI:stopAllActions(timeText)
            GUI:setVisible(timeText, false)
            GUI:setTouchEnabled(button, true)
        end
    end
    GUI:setTouchEnabled(button, false)
    GUI:stopAllActions(timeText)
    GUI:setVisible(timeText, true)
    SL:schedule(timeText, callback, 1)
    callback()

    SL:RequestLoginPhoneAuthCode(phone)
end

----------------------------------------------------
--- 修改密码 手机
function LoginAccount.ShowChangePasswordByPhone()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_change_pwd_by_phone")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 切换
    GUI:addOnClickEvent(ui.Text_change, function()
        LoginAccount.HideAllExt()
        LoginAccount.ShowChangePassword()
    end)

    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_password, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_phone, 11)
    GUI:TextInput_setMaxLength(ui.TextField_authcode, 6)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_password, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_phone, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_authcode, LoginAccount._placeHolderColor)
    
    GUI:TextInput_setInputMode(ui.TextField_phone, 3)
    GUI:TextInput_setInputMode(ui.TextField_authcode, 3)
    GUI:TextInput_setInputFlag(ui.TextField_password, 0)

    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_phone)
    table.insert(inputList, ui.TextField_authcode)
    table.insert(inputList, ui.TextField_password)

    -- 账号
    local username = SL:GetValue("LOGIN_ACCOUNT")
    GUI:TextInput_setString(ui.TextField_username, username)
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 手机号
    GUI:TextInput_addOnEvent(ui.TextField_phone, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 验证码
    GUI:TextInput_addOnEvent(ui.TextField_authcode, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 密码
    GUI:TextInput_addOnEvent(ui.TextField_password, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 获取验证码
    GUI:setVisible(ui.Text_remaining, false)
    GUI:addOnClickEvent(ui.Button_authcode, function()
        LoginAccount.OnClickAuthCodeBtnEvent(ui.Button_authcode, ui.TextField_phone, ui.Text_remaining)
    end)

    -- 
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username      = strim(GUI:TextInput_getString(ui.TextField_username))
        local phone         = strim(GUI:TextInput_getString(ui.TextField_phone))
        local authcode      = strim(GUI:TextInput_getString(ui.TextField_authcode))
        local newpassword   = strim(GUI:TextInput_getString(ui.TextField_password))

        -- 输入为空
        if slen(username) <= 0 or slen(newpassword) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end
        -- 手机号
        if slen(phone) <= 0 or slen(phone) ~= 11 then
            SL:ShowSystemTips("请检查手机号")
            return
        end
        -- 验证码
        if slen(authcode) <= 0 then
            SL:ShowSystemTips("请检查验证码")
            return
        end

        if checkPasswordIsSimple(newpassword, username) then
            SL:ShowSystemTips("该账号密码过于简单，请修改强度较高的密码以保证账号安全")
            return
        end

        -- 换手机号
        local data = {}
        data.username       = username
        data.newpassword    = newpassword
        data.phone          = phone
        data.code           = authcode
        SL:RequestLoginChangePasswordByPhone(data)
    end)
end

----------------------------------------------------
--- 绑定手机
function LoginAccount.ShowBindPhone()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_bind_phone")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_question, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_answer, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_phone, 11)
    GUI:TextInput_setMaxLength(ui.TextField_authcode, 6)


    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_question, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_answer, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_phone, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_authcode, LoginAccount._placeHolderColor)
    
    GUI:TextInput_setInputMode(ui.TextField_phone, 3)
    GUI:TextInput_setInputMode(ui.TextField_authcode, 3)

    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_question)
    table.insert(inputList, ui.TextField_answer)
    table.insert(inputList, ui.TextField_phone)
    table.insert(inputList, ui.TextField_authcode)

    -- 账号
    local username = SL:GetValue("LOGIN_ACCOUNT")
    GUI:TextInput_setString(ui.TextField_username, username)
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 密保问题
    GUI:TextInput_addOnEvent(ui.TextField_question, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 密保答案
    GUI:TextInput_addOnEvent(ui.TextField_answer, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 手机号
    GUI:TextInput_addOnEvent(ui.TextField_phone, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 验证码
    GUI:TextInput_addOnEvent(ui.TextField_authcode, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)
    
    -- 获取验证码
    GUI:setVisible(ui.Text_remaining, false)
    GUI:addOnClickEvent(ui.Button_authcode, function()
        LoginAccount.OnClickAuthCodeBtnEvent(ui.Button_authcode, ui.TextField_phone, ui.Text_remaining)
    end)

    -- 
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username  = strim(GUI:TextInput_getString(ui.TextField_username))
        local question  = strim(GUI:TextInput_getString(ui.TextField_question))
        local answer    = strim(GUI:TextInput_getString(ui.TextField_answer))
        local phone     = strim(GUI:TextInput_getString(ui.TextField_phone))
        local authcode  = strim(GUI:TextInput_getString(ui.TextField_authcode))

        -- 输入为空
        if slen(username) <= 0 then
            SL:ShowSystemTips("账号或密码不可为空")
            return
        end
        -- 密保问题为空
        if slen(question) <= 0 then
            SL:ShowSystemTips("请检查密保问题")
            return
        end
        -- 密保答案为空
        if slen(answer) <= 0 then
            SL:ShowSystemTips("请检查密保答案")
            return
        end
        -- 手机号
        if slen(phone) <= 0 or slen(phone) ~= 11 then
            SL:ShowSystemTips("请检查手机号")
            return
        end
        -- 验证码
        if slen(authcode) <= 0 then
            SL:ShowSystemTips("请检查验证码")
            return
        end

        -- 绑定手机号
        local data = {}
        data.username   = username
        data.question   = question
        data.answer     = answer
        data.phone      = phone
        data.code       = authcode
        SL:RequestLoginBindPhoneByMb(data)
    end)
end

function LoginAccount.OnBindPhoneSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return
    end
    SL:ShowSystemTips("手机号绑定成功")
    LoginAccount.HideAllExt()
end

----------------------------------------------------
--- 换绑手机
function LoginAccount.ShowChangePhone()
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_change_phone")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)

    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_username, LoginAccount._inputMaxLength)
    GUI:TextInput_setMaxLength(ui.TextField_phone, 11)
    GUI:TextInput_setMaxLength(ui.TextField_authcode, 6)
    GUI:TextInput_setMaxLength(ui.TextField_phone_new, 11)
    GUI:TextInput_setMaxLength(ui.TextField_authcode_new, 6)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_username, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_phone, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_authcode, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_phone_new, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_authcode_new, LoginAccount._placeHolderColor)

    GUI:TextInput_setInputMode(ui.TextField_phone, 3)
    GUI:TextInput_setInputMode(ui.TextField_authcode, 3)
    GUI:TextInput_setInputMode(ui.TextField_phone_new, 3)
    GUI:TextInput_setInputMode(ui.TextField_authcode_new, 3)


    local inputList = {}
    table.insert(inputList, ui.TextField_username)
    table.insert(inputList, ui.TextField_phone)
    table.insert(inputList, ui.TextField_authcode)
    table.insert(inputList, ui.TextField_phone_new)
    table.insert(inputList, ui.TextField_authcode_new)

    -- 账号
    local username = SL:GetValue("LOGIN_ACCOUNT")
    GUI:TextInput_setString(ui.TextField_username, username)
    GUI:TextInput_addOnEvent(ui.TextField_username, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 手机号
    GUI:TextInput_addOnEvent(ui.TextField_phone, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 验证码
    GUI:TextInput_addOnEvent(ui.TextField_authcode, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 手机号 新
    GUI:TextInput_addOnEvent(ui.TextField_phone_new, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)

    -- 验证码 新
    GUI:TextInput_addOnEvent(ui.TextField_authcode_new, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNumberCB)
    end)
    
    -- 获取验证码
    GUI:setVisible(ui.Text_remaining, false)
    GUI:addOnClickEvent(ui.Button_authcode, function()
        LoginAccount.OnClickAuthCodeBtnEvent(ui.Button_authcode, ui.TextField_phone, ui.Text_remaining)
    end)

    -- 获取验证码 新
    GUI:setVisible(ui.Text_remaining_new, false)
    GUI:addOnClickEvent(ui.Button_authcode_new, function()
        LoginAccount.OnClickAuthCodeBtnEvent(ui.Button_authcode_new, ui.TextField_phone_new, ui.Text_remaining_new)
    end)

    -- 
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local username  = strim(GUI:TextInput_getString(ui.TextField_username))
        local phone     = strim(GUI:TextInput_getString(ui.TextField_phone))
        local authcode  = strim(GUI:TextInput_getString(ui.TextField_authcode))
        local phoneN    = strim(GUI:TextInput_getString(ui.TextField_phone_new))
        local authcodeN = strim(GUI:TextInput_getString(ui.TextField_authcode_new))

        -- 输入为空
        if slen(username) <= 0 then
            SL:ShowSystemTips("请检查账号")
            return
        end
        -- 手机号
        if slen(phone) <= 0 or slen(phone) ~= 11 then
            SL:ShowSystemTips("请检查手机号")
            return
        end
        -- 验证码
        if slen(authcode) <= 0 then
            SL:ShowSystemTips("请检查验证码")
            return
        end
        -- 手机号 新
        if slen(phoneN) <= 0 or slen(phone) ~= 11 then
            SL:ShowSystemTips("请检查新手机号")
            return
        end
        -- 验证码 新
        if slen(authcodeN) <= 0 then
            SL:ShowSystemTips("请检查新验证码")
            return
        end
    
        -- 换手机号
        local data = {}
        data.username   = username
        data.phone      = phone
        data.code       = authcode
        data.phone_new  = phoneN
        data.code_new   = authcodeN
        SL:RequestLoginChangePhone(data)
    end)
end

function LoginAccount.OnChangeBindPhoneSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return
    end
    SL:ShowSystemTips("手机号修改成功")
    LoginAccount.HideAllExt()
end

----------------------------------------------------
--- 实名认证
function LoginAccount.ShowIdentifyID(cannotClose)
    LoginAccount._isEditing = true

    GUI:LoadExport(LoginAccount._ui.Node_ext, "login_account/login_account_identify")
    local ui = GUI:ui_delegate(LoginAccount._ui.Node_ext)

    GUI:setPosition(ui.Panel_bg, LoginAccount._screenW / 2, LoginAccount._screenH / 2)

    -- 关闭
    if cannotClose then
        GUI:setVisible(ui.Button_close, not cannotClose)
    end
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginAccount.HideAllExt()
    end)
    
    -- 输入框
    GUI:TextInput_setMaxLength(ui.TextField_name, 15)
    GUI:TextInput_setMaxLength(ui.TextField_IDnumber, 18)

    GUI:TextInput_setPlaceholderFontColor(ui.TextField_name, LoginAccount._placeHolderColor)
    GUI:TextInput_setPlaceholderFontColor(ui.TextField_IDnumber, LoginAccount._placeHolderColor)

    local inputList = {}
    table.insert(inputList, ui.TextField_name)
    table.insert(inputList, ui.TextField_IDnumber)

    -- 姓名
    GUI:TextInput_addOnEvent(ui.TextField_name, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitNormalCB)
    end)

    -- 身份证号
    GUI:TextInput_addOnEvent(ui.TextField_IDnumber, function(sender, eventType)
        commonInputCB(sender, eventType, inputList, inputLimitCB)
    end)

    -- 提交
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 1)

        local name  = strim(GUI:TextInput_getString(ui.TextField_name))
        local id    = strim(GUI:TextInput_getString(ui.TextField_IDnumber))
       
        -- 输入为空
        if slen(name) <= 0 then
            SL:ShowSystemTips("请检查姓名")
            return
        end
        -- 身份证号
        if slen(id) <= 0 or slen(id) ~= 18 then
            SL:ShowSystemTips("请检查身份证号")
            return
        end

        SL:RequestLoginIdentifyIDCard(name, id)
    end)
end

function LoginAccount.OnIdentifyIDSuccess()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return
    end
    SL:ShowSystemTips("实名认证成功")
    LoginAccount.HideAllExt()
    LoginAccount.FillCurrent()
end

----------------------------------------------------
-- 分辨率
function LoginAccount.InitResolutionUI()
    if not SL._DEBUG then
        return
    end

    GUI:LoadExport(LoginAccount._ui.Panel_bg, "login_account/login_resolution")
    local panel = GUI:getChildByName(LoginAccount._ui.Panel_bg, "Panel_resolution")
    if not panel then
        return false
    end

    GUI:setVisible(panel, true)
    GUI:setPosition(panel, LoginAccount._screenW - 270, LoginAccount._screenH - 200)

    local ui = GUI:ui_delegate(panel)
    local width  = LoginAccount._screenW
    local height = LoginAccount._screenH

    local debugSetSize = SL:GetDebugResolutionSize()
    if debugSetSize then
        width = debugSetSize.width
        height = debugSetSize.height
    end

    GUI:TextInput_setString(ui.TextField_width, width)
    GUI:TextInput_setString(ui.TextField_height, height)
    GUI:TextInput_setInputMode(ui.TextField_width, 2)
    GUI:TextInput_setInputMode(ui.TextField_height, 2)

    local function onChangeEdit(sender, eventType)
        local str = GUI:TextInput_getString(sender)
        local default = GUI:getName(sender) == "TextField_height" and height or width

        if eventType == GUIDefine.TextInputEventType.ENDED then
            str = string.trim(str)
            str = tonumber(str) or default
            if str < 0 then
                str = default
            end
            GUI:TextInput_setString(sender, str)
        elseif eventType == GUIDefine.TextInputEventType.CHANGE then
            if string.find(str, "\n") then
                GUI:TextInput_closeInput(sender)
            end
        end
    end

    GUI:TextInput_addOnEvent(ui.TextField_width, onChangeEdit)
    GUI:TextInput_addOnEvent(ui.TextField_height, onChangeEdit)

    GUI:addOnClickEvent(ui.btnOk, function()
        local setWidth  = tonumber(GUI:TextInput_getString(ui.TextField_width))
        local setHeight = tonumber(GUI:TextInput_getString(ui.TextField_height))
        SL:ChangeDebugResolutionSize(false, setWidth, setHeight)
    end)
    GUI:addOnClickEvent(ui.btnReset, function()
        SL:ChangeDebugResolutionSize(true)
    end)
end

-- 说明书
function LoginAccount.InitIntroButton()
    if SL._DEBUG then
        local introButton = GUI:Button_Create(LoginAccount._ui.Panel_bg, "ButtonIntro", LoginAccount._screenW - 90, LoginAccount._screenH - 220, "res/public/1900001022.png")
        GUI:setAnchorPoint(introButton, 0.5, 0.5)
        GUI:Button_loadTexturePressed(introButton, "res/public/1900001023.png")
        GUI:Button_setTitleFontSize(introButton, 16)
        GUI:Button_setTitleColor(introButton, "#F8E6C6")
        GUI:Button_setTitleText(introButton, "说明书")
        GUI:Button_titleEnableOutline(introButton, "#111111", 2)
        GUI:addOnClickEvent(introButton, function()
            local url = "https://engine-doc.996m2.com/web/#/70/23182"
            SL:OpenURL(url)
        end)
    end
end

----------------------------------------------------------------------------
function LoginAccount.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_REGISTER_ACCOUNT_SUCCESS, "LoginAccount", LoginAccount.OnRegisterSuccess, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_IDENTIFY_IDCARD_SUCCESS, "LoginAccount", LoginAccount.OnIdentifyIDSuccess, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CHANGE_PASSWORD_SUCCESS, "LoginAccount", LoginAccount.OnChangePasswordSuccess, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CHANGE_MBQUESTION_SUCCESS, "LoginAccount", LoginAccount.OnChangeMbQuestionSuccess, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_BIND_PHONE_SUCCESS, "LoginAccount", LoginAccount.OnBindPhoneSuccess, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CHANGE_BIND_PHONE_SUCCESS, "LoginAccount", LoginAccount.OnChangeBindPhoneSuccess, LoginAccount._layer)   
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_SHOW_IDENTIFY_UI, "LoginAccount", LoginAccount.ShowIdentifyID, LoginAccount._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_SHOW_BIND_PHONE_UI, "LoginAccount", LoginAccount.ShowBindPhone, LoginAccount._layer)
end

LoginAccount.main()