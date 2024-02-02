local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "重置密码场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 640.00, 475.00, false)
	GUI:setChineseName(Panel_bg, "重置密码_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 67)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 328.00, 233.00, "res/private/login/account/bg_tongy_01.png")
	GUI:setChineseName(Image_1, "重置密码_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 68)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_bg, "Image_8", 320.00, 350.00, "res/private/login/account/word_yongh_06.png")
	GUI:setChineseName(Image_8, "重置密码_标题_图片")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 69)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 539.00, 367.00, "res/public/btn_normal_2.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "重置密码_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 70)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1", 215.00, 295.00, 18, "#ffffff", [[账　　　号]])
	GUI:setChineseName(Text_1_1, "重置密码_账号_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 71)
	GUI:Text_enableOutline(Text_1_1, "#000000", 3)

	-- Create Text_1_1_0
	local Text_1_1_0 = GUI:Text_Create(Panel_bg, "Text_1_1_0", 215.00, 249.00, 18, "#ffffff", [[手　机　号]])
	GUI:setChineseName(Text_1_1_0, "重置密码_手机号_文本")
	GUI:setAnchorPoint(Text_1_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_0, false)
	GUI:setTag(Text_1_1_0, 72)
	GUI:Text_enableOutline(Text_1_1_0, "#000000", 3)

	-- Create Text_1_1_1
	local Text_1_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1_1", 215.00, 202.00, 18, "#ffffff", [[验　证　码]])
	GUI:setChineseName(Text_1_1_1, "重置密码_验证码_文本")
	GUI:setAnchorPoint(Text_1_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_1, false)
	GUI:setTag(Text_1_1_1, 73)
	GUI:Text_enableOutline(Text_1_1_1, "#000000", 3)

	-- Create Text_1_1_2
	local Text_1_1_2 = GUI:Text_Create(Panel_bg, "Text_1_1_2", 215.00, 158.00, 18, "#ffffff", [[新　密　码]])
	GUI:setChineseName(Text_1_1_2, "重置密码_新密码_文本")
	GUI:setAnchorPoint(Text_1_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_2, false)
	GUI:setTag(Text_1_1_2, 74)
	GUI:Text_enableOutline(Text_1_1_2, "#000000", 3)

	-- Create Image_5_1
	local Image_5_1 = GUI:Image_Create(Panel_bg, "Image_5_1", 382.00, 295.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1, false)
	GUI:setChineseName(Image_5_1, "重置密码_账号_输入背景框")
	GUI:setAnchorPoint(Image_5_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1, false)
	GUI:setTag(Image_5_1, 75)

	-- Create Image_5_1_0
	local Image_5_1_0 = GUI:Image_Create(Panel_bg, "Image_5_1_0", 382.00, 249.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_0, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_0, false)
	GUI:setChineseName(Image_5_1_0, "重置密码_手机号_输入背景框")
	GUI:setAnchorPoint(Image_5_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_0, false)
	GUI:setTag(Image_5_1_0, 76)

	-- Create Image_5_1_1
	local Image_5_1_1 = GUI:Image_Create(Panel_bg, "Image_5_1_1", 353.00, 202.00, "res/private/login/account/bg_shuru_01.png")
	GUI:setContentSize(Image_5_1_1, 85, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_1, false)
	GUI:setChineseName(Image_5_1_1, "重置密码_验证码_输入背景框")
	GUI:setAnchorPoint(Image_5_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_1, false)
	GUI:setTag(Image_5_1_1, 77)

	-- Create Image_5_1_2
	local Image_5_1_2 = GUI:Image_Create(Panel_bg, "Image_5_1_2", 382.00, 158.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_2, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_2, false)
	GUI:setChineseName(Image_5_1_2, "重置密码_新密码_输入背景框")
	GUI:setAnchorPoint(Image_5_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_2, false)
	GUI:setTag(Image_5_1_2, 78)

	-- Create TextField_username
	local TextField_username = GUI:TextInput_Create(Panel_bg, "TextField_username", 312.00, 295.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_username, "")
	GUI:TextInput_setFontColor(TextField_username, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_username, 12)
	GUI:setChineseName(TextField_username, "重置密码_账号输入")
	GUI:setAnchorPoint(TextField_username, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_username, true)
	GUI:setTag(TextField_username, 79)

	-- Create TextField_phone
	local TextField_phone = GUI:TextInput_Create(Panel_bg, "TextField_phone", 312.00, 249.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_phone, "")
	GUI:TextInput_setFontColor(TextField_phone, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_phone, 12)
	GUI:setChineseName(TextField_phone, "重置密码_手机号输入")
	GUI:setAnchorPoint(TextField_phone, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_phone, true)
	GUI:setTag(TextField_phone, 80)

	-- Create TextField_authcode
	local TextField_authcode = GUI:TextInput_Create(Panel_bg, "TextField_authcode", 312.00, 202.00, 82.00, 30.00, 22)
	GUI:TextInput_setString(TextField_authcode, "")
	GUI:TextInput_setFontColor(TextField_authcode, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_authcode, 12)
	GUI:setChineseName(TextField_authcode, "重置密码_验证码输入")
	GUI:setAnchorPoint(TextField_authcode, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_authcode, true)
	GUI:setTag(TextField_authcode, 81)

	-- Create TextField_password
	local TextField_password = GUI:TextInput_Create(Panel_bg, "TextField_password", 312.00, 158.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_password, "")
	GUI:TextInput_setFontColor(TextField_password, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_password, 12)
	GUI:setChineseName(TextField_password, "重置密码_新密码输入")
	GUI:setAnchorPoint(TextField_password, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_password, true)
	GUI:setTag(TextField_password, 82)

	-- Create Button_authcode
	local Button_authcode = GUI:Button_Create(Panel_bg, "Button_authcode", 445.00, 202.00, "res/private/login/account/btn_huoq_01.png")
	GUI:Button_loadTexturePressed(Button_authcode, "res/private/login/account/btn_huoq_02.png")
	GUI:Button_setScale9Slice(Button_authcode, 15, 15, 11, 11)
	GUI:setContentSize(Button_authcode, 93, 51)
	GUI:setIgnoreContentAdaptWithSize(Button_authcode, false)
	GUI:Button_setTitleText(Button_authcode, "")
	GUI:Button_setTitleColor(Button_authcode, "#414146")
	GUI:Button_setTitleFontSize(Button_authcode, 14)
	GUI:Button_titleDisableOutLine(Button_authcode)
	GUI:setChineseName(Button_authcode, "重置密码_获取验证码_按钮")
	GUI:setAnchorPoint(Button_authcode, 0.50, 0.50)
	GUI:setTouchEnabled(Button_authcode, true)
	GUI:setTag(Button_authcode, 86)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_bg, "Text_remaining", 490.00, 202.00, 20, "#ffffff", [[19]])
	GUI:setChineseName(Text_remaining, "重置密码_倒计时文本")
	GUI:setAnchorPoint(Text_remaining, 0.00, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 85)
	GUI:Text_enableOutline(Text_remaining, "#000000", 3)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_bg, "Button_submit", 320.00, 95.00, "res/private/login/account/btn_tijiao_01.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/private/login/account/btn_tijiao_02.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 4, 4)
	GUI:setContentSize(Button_submit, 112, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#414146")
	GUI:Button_setTitleFontSize(Button_submit, 14)
	GUI:Button_titleDisableOutLine(Button_submit)
	GUI:setChineseName(Button_submit, "重置密码_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 83)

	-- Create Text_change
	local Text_change = GUI:Text_Create(Panel_bg, "Text_change", 485.00, 95.00, 18, "#ffffff", [[密 保 验 证]])
	GUI:setChineseName(Text_change, "重置密码_手机验证_文本")
	GUI:setAnchorPoint(Text_change, 0.50, 0.50)
	GUI:setTouchEnabled(Text_change, true)
	GUI:setTag(Text_change, 88)
	GUI:Text_enableOutline(Text_change, "#000000", 3)
end
return ui