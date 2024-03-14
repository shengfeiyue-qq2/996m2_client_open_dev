local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "登录场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_1, 0, 0, 0, 0)
	GUI:setChineseName(Panel_1, "登录背景层")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 16)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Scene, "Image_bg", 568.00, 320.00, "res/private/login/open_door/00.png")
	GUI:setContentSize(Image_bg, 1136, 640)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "登录背景")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 108)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_bg, "登录框_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, 10)

	-- Create Panel_login
	local Panel_login = GUI:Layout_Create(Panel_bg, "Panel_login", 568.00, 320.00, 400.00, 350.00, false)
	GUI:setChineseName(Panel_login, "登录框_组合")
	GUI:setAnchorPoint(Panel_login, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_login, true)
	GUI:setTag(Panel_login, 12)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_login, "Image_1", 200.00, 175.00, "res/private/login/account/bg_dengl_01.png")
	GUI:setChineseName(Image_1, "登录框_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 22)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_login, "Image_4", 190.00, 292.00, "res/private/login/account/word_yongh_03.png")
	GUI:setChineseName(Image_4, "登录框_标题_图片")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 22)

	-- Create Panel_account
	local Panel_account = GUI:Layout_Create(Panel_login, "Panel_account", 45.00, 191.00, 300.00, 90.00, false)
	GUI:setChineseName(Panel_account, "登录框_账户密码组合")
	GUI:setTouchEnabled(Panel_account, true)
	GUI:setTag(Panel_account, 340)
	GUI:setVisible(Panel_account, false)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_account, "Text_1", 50.00, 65.00, 18, "#ffffff", [[账　号]])
	GUI:setChineseName(Text_1, "登录框_账号文字")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 20)
	GUI:Text_enableOutline(Text_1, "#000000", 3)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_account, "Text_1_0", 50.00, 25.00, 18, "#ffffff", [[密　码]])
	GUI:setChineseName(Text_1_0, "登录框_密码文字")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 21)
	GUI:Text_enableOutline(Text_1_0, "#000000", 3)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_account, "Image_5", 180.00, 65.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5, false)
	GUI:setChineseName(Image_5, "登录框_账号输入背景框")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 23)

	-- Create Image_5_0
	local Image_5_0 = GUI:Image_Create(Panel_account, "Image_5_0", 180.00, 25.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_0, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_0, false)
	GUI:setChineseName(Image_5_0, "登录框_密码输入背景框")
	GUI:setAnchorPoint(Image_5_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_0, false)
	GUI:setTag(Image_5_0, 24)

	-- Create TextField_username
	local TextField_username = GUI:TextInput_Create(Panel_account, "TextField_username", 97.00, 65.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_username, "")
	GUI:TextInput_setFontColor(TextField_username, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_username, 20)
	GUI:setChineseName(TextField_username, "登录框_账户输入")
	GUI:setAnchorPoint(TextField_username, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_username, true)
	GUI:setTag(TextField_username, 118)

	-- Create TextField_password
	local TextField_password = GUI:TextInput_Create(Panel_account, "TextField_password", 97.00, 25.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_password, "")
	GUI:TextInput_setFontColor(TextField_password, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_password, 20)
	GUI:setChineseName(TextField_password, "登录框_密码输入")
	GUI:setAnchorPoint(TextField_password, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_password, true)
	GUI:setTag(TextField_password, 114)

	-- Create Panel_phone
	local Panel_phone = GUI:Layout_Create(Panel_login, "Panel_phone", 45.00, 191.00, 300.00, 90.00, false)
	GUI:setChineseName(Panel_phone, "登录框_手机登录组合")
	GUI:setTouchEnabled(Panel_phone, true)
	GUI:setTag(Panel_phone, 341)
	GUI:setVisible(Panel_phone, false)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_phone, "Text_2", 50.00, 65.00, 18, "#ffffff", [[手机号]])
	GUI:setChineseName(Text_2, "登录框_手机号文字")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 342)
	GUI:Text_enableOutline(Text_2, "#000000", 3)

	-- Create Text_2_0
	local Text_2_0 = GUI:Text_Create(Panel_phone, "Text_2_0", 50.00, 25.00, 18, "#ffffff", [[验证码]])
	GUI:setChineseName(Text_2_0, "登录框_验证码文字")
	GUI:setAnchorPoint(Text_2_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2_0, false)
	GUI:setTag(Text_2_0, 343)
	GUI:Text_enableOutline(Text_2_0, "#000000", 3)

	-- Create Image_6
	local Image_6 = GUI:Image_Create(Panel_phone, "Image_6", 180.00, 65.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_6, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_6, false)
	GUI:setChineseName(Image_6, "登录框_手机号输入背景框")
	GUI:setAnchorPoint(Image_6, 0.50, 0.50)
	GUI:setTouchEnabled(Image_6, false)
	GUI:setTag(Image_6, 344)

	-- Create Image_6_0
	local Image_6_0 = GUI:Image_Create(Panel_phone, "Image_6_0", 140.00, 25.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_6_0, 90, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_6_0, false)
	GUI:setChineseName(Image_6_0, "登录框_验证码输入背景框")
	GUI:setAnchorPoint(Image_6_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_6_0, false)
	GUI:setTag(Image_6_0, 345)

	-- Create TextField_phoneId
	local TextField_phoneId = GUI:TextInput_Create(Panel_phone, "TextField_phoneId", 97.00, 65.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_phoneId, "")
	GUI:TextInput_setFontColor(TextField_phoneId, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_phoneId, 12)
	GUI:setChineseName(TextField_phoneId, "登录框_手机号输入")
	GUI:setAnchorPoint(TextField_phoneId, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_phoneId, true)
	GUI:setTag(TextField_phoneId, 346)

	-- Create TextField_authcode
	local TextField_authcode = GUI:TextInput_Create(Panel_phone, "TextField_authcode", 97.00, 25.00, 87.00, 30.00, 22)
	GUI:TextInput_setString(TextField_authcode, "")
	GUI:TextInput_setFontColor(TextField_authcode, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_authcode, 12)
	GUI:setChineseName(TextField_authcode, "登录框_验证码输入")
	GUI:setAnchorPoint(TextField_authcode, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_authcode, true)
	GUI:setTag(TextField_authcode, 347)

	-- Create Button_authcode
	local Button_authcode = GUI:Button_Create(Panel_phone, "Button_authcode", 226.00, 24.00, "res/private/login/account/btn_huoq_01.png")
	GUI:Button_loadTexturePressed(Button_authcode, "res/private/login/account/btn_huoq_02.png")
	GUI:Button_setScale9Slice(Button_authcode, 15, 15, 11, 11)
	GUI:setContentSize(Button_authcode, 93, 51)
	GUI:setIgnoreContentAdaptWithSize(Button_authcode, false)
	GUI:Button_setTitleText(Button_authcode, "")
	GUI:Button_setTitleColor(Button_authcode, "#414146")
	GUI:Button_setTitleFontSize(Button_authcode, 14)
	GUI:Button_titleDisableOutLine(Button_authcode)
	GUI:setChineseName(Button_authcode, "登录框_获取验证码_按钮")
	GUI:setAnchorPoint(Button_authcode, 0.50, 0.50)
	GUI:setTouchEnabled(Button_authcode, true)
	GUI:setTag(Button_authcode, 349)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_phone, "Text_remaining", 271.00, 25.00, 20, "#ffffff", [[19]])
	GUI:setChineseName(Text_remaining, "登录框_倒计时_文本")
	GUI:setAnchorPoint(Text_remaining, 0.00, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 348)
	GUI:Text_enableOutline(Text_remaining, "#000000", 3)

	-- Create Button_register
	local Button_register = GUI:Button_Create(Panel_login, "Button_register", 102.00, 161.00, "res/private/login/account/btn_zhuce_01.png")
	GUI:Button_loadTexturePressed(Button_register, "res/private/login/account/btn_zhuce_02.png")
	GUI:Button_setScale9Slice(Button_register, 15, 15, 4, 4)
	GUI:setContentSize(Button_register, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_register, false)
	GUI:Button_setTitleText(Button_register, "")
	GUI:Button_setTitleColor(Button_register, "#414146")
	GUI:Button_setTitleFontSize(Button_register, 14)
	GUI:Button_titleDisableOutLine(Button_register)
	GUI:setChineseName(Button_register, "登录框_注册_按钮")
	GUI:setAnchorPoint(Button_register, 0.50, 0.50)
	GUI:setTouchEnabled(Button_register, true)
	GUI:setTag(Button_register, 13)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_login, "Button_submit", 268.00, 161.00, "res/private/login/account/btn_dlz_01.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/private/login/account/btn_dlz_02.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 4, 4)
	GUI:setContentSize(Button_submit, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#414146")
	GUI:Button_setTitleFontSize(Button_submit, 14)
	GUI:Button_titleDisableOutLine(Button_submit)
	GUI:setChineseName(Button_submit, "登录框_登录_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 23)

	-- Create Button_change_question
	local Button_change_question = GUI:Button_Create(Panel_login, "Button_change_question", 102.00, 115.00, "res/private/login/account/btn_mibao_01.png")
	GUI:Button_loadTexturePressed(Button_change_question, "res/private/login/account/btn_mibao_02.png")
	GUI:Button_setScale9Slice(Button_change_question, 15, 15, 4, 4)
	GUI:setContentSize(Button_change_question, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_change_question, false)
	GUI:Button_setTitleText(Button_change_question, "")
	GUI:Button_setTitleColor(Button_change_question, "#414146")
	GUI:Button_setTitleFontSize(Button_change_question, 14)
	GUI:Button_titleDisableOutLine(Button_change_question)
	GUI:setChineseName(Button_change_question, "登录框_修改密保_按钮")
	GUI:setAnchorPoint(Button_change_question, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change_question, true)
	GUI:setTag(Button_change_question, 25)

	-- Create Button_change_password
	local Button_change_password = GUI:Button_Create(Panel_login, "Button_change_password", 268.00, 115.00, "res/private/login/account/btn_chongzhi_01.png")
	GUI:Button_loadTexturePressed(Button_change_password, "res/private/login/account/btn_chongzhi_02.png")
	GUI:Button_setScale9Slice(Button_change_password, 15, 15, 4, 4)
	GUI:setContentSize(Button_change_password, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_change_password, false)
	GUI:Button_setTitleText(Button_change_password, "")
	GUI:Button_setTitleColor(Button_change_password, "#414146")
	GUI:Button_setTitleFontSize(Button_change_password, 14)
	GUI:Button_titleDisableOutLine(Button_change_password)
	GUI:setChineseName(Button_change_password, "登录框_重置密码_按钮")
	GUI:setAnchorPoint(Button_change_password, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change_password, true)
	GUI:setTag(Button_change_password, 26)

	-- Create Button_bind_phone
	local Button_bind_phone = GUI:Button_Create(Panel_login, "Button_bind_phone", 102.00, 68.00, "res/private/login/account/btn_bdsj_01.png")
	GUI:Button_loadTexturePressed(Button_bind_phone, "res/private/login/account/btn_bdsj_02.png")
	GUI:Button_setScale9Slice(Button_bind_phone, 15, 15, 4, 4)
	GUI:setContentSize(Button_bind_phone, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_bind_phone, false)
	GUI:Button_setTitleText(Button_bind_phone, "")
	GUI:Button_setTitleColor(Button_bind_phone, "#414146")
	GUI:Button_setTitleFontSize(Button_bind_phone, 14)
	GUI:Button_titleDisableOutLine(Button_bind_phone)
	GUI:setChineseName(Button_bind_phone, "登录框_绑定手机_按钮")
	GUI:setAnchorPoint(Button_bind_phone, 0.50, 0.50)
	GUI:setTouchEnabled(Button_bind_phone, true)
	GUI:setTag(Button_bind_phone, 27)

	-- Create Button_change_phone
	local Button_change_phone = GUI:Button_Create(Panel_login, "Button_change_phone", 268.00, 68.00, "res/private/login/account/btn_xiugsj_01.png")
	GUI:Button_loadTexturePressed(Button_change_phone, "res/private/login/account/btn_xiugsj_02.png")
	GUI:Button_setScale9Slice(Button_change_phone, 15, 15, 4, 4)
	GUI:setContentSize(Button_change_phone, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_change_phone, false)
	GUI:Button_setTitleText(Button_change_phone, "")
	GUI:Button_setTitleColor(Button_change_phone, "#414146")
	GUI:Button_setTitleFontSize(Button_change_phone, 14)
	GUI:Button_titleDisableOutLine(Button_change_phone)
	GUI:setChineseName(Button_change_phone, "登录框_修改手机_按钮")
	GUI:setAnchorPoint(Button_change_phone, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change_phone, true)
	GUI:setTag(Button_change_phone, 28)

	-- Create Button_identify
	local Button_identify = GUI:Button_Create(Panel_login, "Button_identify", 102.00, 25.00, "res/private/login/account/btn_identify_01.png")
	GUI:Button_loadTexturePressed(Button_identify, "res/private/login/account/btn_identify_02.png")
	GUI:Button_setScale9Slice(Button_identify, 15, 15, 4, 4)
	GUI:setContentSize(Button_identify, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_identify, false)
	GUI:Button_setTitleText(Button_identify, "")
	GUI:Button_setTitleColor(Button_identify, "#414146")
	GUI:Button_setTitleFontSize(Button_identify, 14)
	GUI:Button_titleDisableOutLine(Button_identify)
	GUI:setChineseName(Button_identify, "登录框_实名认证_按钮")
	GUI:setAnchorPoint(Button_identify, 0.50, 0.50)
	GUI:setTouchEnabled(Button_identify, true)
	GUI:setTag(Button_identify, 201)

	-- Create Text_phone
	local Text_phone = GUI:Button_Create(Panel_login, "Text_phone", 268.00, 25.00, "res/private/login/account/btn_phone_01.png")
	GUI:Button_loadTexturePressed(Text_phone, "res/private/login/account/btn_phone_02.png")
	GUI:Button_setScale9Slice(Text_phone, 15, 15, 11, 11)
	GUI:setContentSize(Text_phone, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Text_phone, false)
	GUI:Button_setTitleText(Text_phone, "")
	GUI:Button_setTitleColor(Text_phone, "#414146")
	GUI:Button_setTitleFontSize(Text_phone, 14)
	GUI:Button_titleDisableOutLine(Text_phone)
	GUI:setChineseName(Text_phone, "登录框_手机登录_按钮")
	GUI:setAnchorPoint(Text_phone, 0.50, 0.50)
	GUI:setTouchEnabled(Text_phone, true)
	GUI:setTag(Text_phone, 34)

	-- Create Text_account
	local Text_account = GUI:Button_Create(Panel_login, "Text_account", 268.00, 25.00, "res/private/login/account/btn_account_01.png")
	GUI:Button_loadTexturePressed(Text_account, "res/private/login/account/btn_account_02.png")
	GUI:Button_setScale9Slice(Text_account, 15, 15, 11, 11)
	GUI:setContentSize(Text_account, 113, 46)
	GUI:setIgnoreContentAdaptWithSize(Text_account, false)
	GUI:Button_setTitleText(Text_account, "")
	GUI:Button_setTitleColor(Text_account, "#414146")
	GUI:Button_setTitleFontSize(Text_account, 14)
	GUI:Button_titleDisableOutLine(Text_account)
	GUI:setChineseName(Text_account, "登录框_账号登录_按钮")
	GUI:setAnchorPoint(Text_account, 0.50, 0.50)
	GUI:setTouchEnabled(Text_account, true)
	GUI:setTag(Text_account, 84)
	GUI:setVisible(Text_account, false)

	-- Create Node_ext
	local Node_ext = GUI:Node_Create(Scene, "Node_ext", 0.00, 0.00)
	GUI:setChineseName(Node_ext, "登录框_节点")
	GUI:setAnchorPoint(Node_ext, 0.50, 0.50)
	GUI:setTag(Node_ext, 309)
end
return ui