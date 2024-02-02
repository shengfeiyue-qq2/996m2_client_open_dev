local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "绑定手机场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 640.00, 475.00, false)
	GUI:setChineseName(Panel_bg, "绑定手机_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 197)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 328.00, 233.00, "res/private/login/account/bg_tongy_01.png")
	GUI:setChineseName(Image_1, "绑定手机_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 198)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_bg, "Image_8", 320.00, 350.00, "res/private/login/account/word_yongh_02.png")
	GUI:setChineseName(Image_8, "绑定手机_标题_文本")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 199)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 539.00, 367.00, "res/public/btn_normal_2.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "绑定手机_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 200)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1", 215.00, 304.00, 18, "#ffffff", [[账　　　号]])
	GUI:setChineseName(Text_1_1, "绑定手机_账号_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 201)
	GUI:Text_enableOutline(Text_1_1, "#000000", 3)

	-- Create Text_1_1_0
	local Text_1_1_0 = GUI:Text_Create(Panel_bg, "Text_1_1_0", 215.00, 265.00, 18, "#ffffff", [[密 保 问 题]])
	GUI:setChineseName(Text_1_1_0, "绑定手机_密保问题_文本")
	GUI:setAnchorPoint(Text_1_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_0, false)
	GUI:setTag(Text_1_1_0, 202)
	GUI:Text_enableOutline(Text_1_1_0, "#000000", 3)

	-- Create Text_1_1_1
	local Text_1_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1_1", 215.00, 225.00, 18, "#ffffff", [[答　　　案]])
	GUI:setChineseName(Text_1_1_1, "绑定手机_答案_文本")
	GUI:setAnchorPoint(Text_1_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_1, false)
	GUI:setTag(Text_1_1_1, 203)
	GUI:Text_enableOutline(Text_1_1_1, "#000000", 3)

	-- Create Text_1_1_2
	local Text_1_1_2 = GUI:Text_Create(Panel_bg, "Text_1_1_2", 215.00, 185.00, 18, "#ffffff", [[手　机　号]])
	GUI:setChineseName(Text_1_1_2, "绑定手机_手机号_文本")
	GUI:setAnchorPoint(Text_1_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_2, false)
	GUI:setTag(Text_1_1_2, 204)
	GUI:Text_enableOutline(Text_1_1_2, "#000000", 3)

	-- Create Text_1_1_3
	local Text_1_1_3 = GUI:Text_Create(Panel_bg, "Text_1_1_3", 215.00, 146.00, 18, "#ffffff", [[验　证　码]])
	GUI:setChineseName(Text_1_1_3, "绑定手机_验证码_文本")
	GUI:setAnchorPoint(Text_1_1_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_3, false)
	GUI:setTag(Text_1_1_3, 205)
	GUI:Text_enableOutline(Text_1_1_3, "#000000", 3)

	-- Create Image_5_1
	local Image_5_1 = GUI:Image_Create(Panel_bg, "Image_5_1", 382.00, 304.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1, false)
	GUI:setChineseName(Image_5_1, "绑定手机_账号_输入背景框")
	GUI:setAnchorPoint(Image_5_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1, false)
	GUI:setTag(Image_5_1, 206)

	-- Create Image_5_1_0
	local Image_5_1_0 = GUI:Image_Create(Panel_bg, "Image_5_1_0", 382.00, 265.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_0, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_0, false)
	GUI:setChineseName(Image_5_1_0, "绑定手机_密保_输入背景框")
	GUI:setAnchorPoint(Image_5_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_0, false)
	GUI:setTag(Image_5_1_0, 207)

	-- Create Image_5_1_1
	local Image_5_1_1 = GUI:Image_Create(Panel_bg, "Image_5_1_1", 382.00, 225.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_1, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_1, false)
	GUI:setChineseName(Image_5_1_1, "绑定手机_答案_输入背景框")
	GUI:setAnchorPoint(Image_5_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_1, false)
	GUI:setTag(Image_5_1_1, 208)

	-- Create Image_5_1_2
	local Image_5_1_2 = GUI:Image_Create(Panel_bg, "Image_5_1_2", 382.00, 185.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_2, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_2, false)
	GUI:setChineseName(Image_5_1_2, "绑定手机_手机号_输入背景框")
	GUI:setAnchorPoint(Image_5_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_2, false)
	GUI:setTag(Image_5_1_2, 209)

	-- Create Image_5_1_2_0
	local Image_5_1_2_0 = GUI:Image_Create(Panel_bg, "Image_5_1_2_0", 354.00, 145.00, "res/private/login/account/bg_shuru_01.png")
	GUI:setContentSize(Image_5_1_2_0, 85, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_2_0, false)
	GUI:setChineseName(Image_5_1_2_0, "绑定手机_验证码_输入背景框")
	GUI:setAnchorPoint(Image_5_1_2_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_2_0, false)
	GUI:setTag(Image_5_1_2_0, 210)

	-- Create TextField_username
	local TextField_username = GUI:TextInput_Create(Panel_bg, "TextField_username", 312.00, 304.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_username, "")
	GUI:TextInput_setFontColor(TextField_username, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_username, 12)
	GUI:setChineseName(TextField_username, "绑定手机_账号输入")
	GUI:setAnchorPoint(TextField_username, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_username, true)
	GUI:setTag(TextField_username, 211)

	-- Create TextField_question
	local TextField_question = GUI:TextInput_Create(Panel_bg, "TextField_question", 312.00, 265.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_question, "")
	GUI:TextInput_setFontColor(TextField_question, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_question, 12)
	GUI:setChineseName(TextField_question, "绑定手机_密保输入")
	GUI:setAnchorPoint(TextField_question, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_question, true)
	GUI:setTag(TextField_question, 212)

	-- Create TextField_answer
	local TextField_answer = GUI:TextInput_Create(Panel_bg, "TextField_answer", 312.00, 225.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_answer, "")
	GUI:TextInput_setFontColor(TextField_answer, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_answer, 12)
	GUI:setChineseName(TextField_answer, "绑定手机_答案输入")
	GUI:setAnchorPoint(TextField_answer, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_answer, true)
	GUI:setTag(TextField_answer, 213)

	-- Create TextField_phone
	local TextField_phone = GUI:TextInput_Create(Panel_bg, "TextField_phone", 312.00, 185.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_phone, "")
	GUI:TextInput_setFontColor(TextField_phone, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_phone, 12)
	GUI:setChineseName(TextField_phone, "绑定手机_手机号输入")
	GUI:setAnchorPoint(TextField_phone, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_phone, true)
	GUI:setTag(TextField_phone, 214)

	-- Create TextField_authcode
	local TextField_authcode = GUI:TextInput_Create(Panel_bg, "TextField_authcode", 312.00, 146.00, 83.00, 30.00, 22)
	GUI:TextInput_setString(TextField_authcode, "")
	GUI:TextInput_setFontColor(TextField_authcode, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_authcode, 12)
	GUI:setChineseName(TextField_authcode, "绑定手机_验证码输入")
	GUI:setAnchorPoint(TextField_authcode, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_authcode, true)
	GUI:setTag(TextField_authcode, 215)

	-- Create Button_authcode
	local Button_authcode = GUI:Button_Create(Panel_bg, "Button_authcode", 445.00, 146.00, "res/private/login/account/btn_huoq_01.png")
	GUI:Button_loadTexturePressed(Button_authcode, "res/private/login/account/btn_huoq_02.png")
	GUI:Button_setScale9Slice(Button_authcode, 15, 15, 11, 11)
	GUI:setContentSize(Button_authcode, 93, 51)
	GUI:setIgnoreContentAdaptWithSize(Button_authcode, false)
	GUI:Button_setTitleText(Button_authcode, "")
	GUI:Button_setTitleColor(Button_authcode, "#414146")
	GUI:Button_setTitleFontSize(Button_authcode, 14)
	GUI:Button_titleDisableOutLine(Button_authcode)
	GUI:setChineseName(Button_authcode, "绑定手机_获取_按钮")
	GUI:setAnchorPoint(Button_authcode, 0.50, 0.50)
	GUI:setTouchEnabled(Button_authcode, true)
	GUI:setTag(Button_authcode, 216)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_bg, "Text_remaining", 490.00, 146.00, 20, "#ffffff", [[19]])
	GUI:setChineseName(Text_remaining, "绑定手机_验证码倒计时")
	GUI:setAnchorPoint(Text_remaining, 0.00, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 137)
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
	GUI:setChineseName(Button_submit, "绑定手机_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 217)
end
return ui