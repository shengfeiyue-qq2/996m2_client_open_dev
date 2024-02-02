local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "注册新账户场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 640.00, 475.00, false)
	GUI:setChineseName(Panel_bg, "注册新账户_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 138)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 315.00, 245.00, "res/private/login/account/bg_zhuce_01.png")
	GUI:setChineseName(Image_1, "注册新账户_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 139)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_bg, "Image_7", 475.00, 239.00, "res/private/login/account/bg_juese_01.png")
	GUI:setChineseName(Image_7, "注册新账户_详细信息框")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 140)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_bg, "Image_8", 305.00, 418.00, "res/private/login/account/word_yongh_01.png")
	GUI:setChineseName(Image_8, "注册新账户_标题_图片")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 141)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 600.00, 440.00, "res/public/btn_normal_2.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "注册新账户_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 142)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1", 85.00, 356.00, 18, "#ffffff", [[账　　号]])
	GUI:setChineseName(Text_1_1, "注册新账户_账号_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 143)
	GUI:Text_enableOutline(Text_1_1, "#000000", 3)

	-- Create Text_1_1_0
	local Text_1_1_0 = GUI:Text_Create(Panel_bg, "Text_1_1_0", 85.00, 298.00, 18, "#ffffff", [[密　　码]])
	GUI:setChineseName(Text_1_1_0, "注册新账户_密码_文本")
	GUI:setAnchorPoint(Text_1_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_0, false)
	GUI:setTag(Text_1_1_0, 144)
	GUI:Text_enableOutline(Text_1_1_0, "#000000", 3)

	-- Create Text_1_1_1
	local Text_1_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1_1", 85.00, 241.00, 18, "#ffffff", [[确认密码]])
	GUI:setChineseName(Text_1_1_1, "注册新账户_确认密码_文本")
	GUI:setAnchorPoint(Text_1_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_1, false)
	GUI:setTag(Text_1_1_1, 145)
	GUI:Text_enableOutline(Text_1_1_1, "#000000", 3)

	-- Create Text_1_1_2
	local Text_1_1_2 = GUI:Text_Create(Panel_bg, "Text_1_1_2", 85.00, 184.00, 18, "#ffffff", [[密保问题]])
	GUI:setChineseName(Text_1_1_2, "注册新账户_密保_文本")
	GUI:setAnchorPoint(Text_1_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_2, false)
	GUI:setTag(Text_1_1_2, 146)
	GUI:Text_enableOutline(Text_1_1_2, "#000000", 3)

	-- Create Text_1_1_3
	local Text_1_1_3 = GUI:Text_Create(Panel_bg, "Text_1_1_3", 85.00, 127.00, 18, "#ffffff", [[答　　案]])
	GUI:setChineseName(Text_1_1_3, "注册新账户_答案_文本")
	GUI:setAnchorPoint(Text_1_1_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_3, false)
	GUI:setTag(Text_1_1_3, 147)
	GUI:Text_enableOutline(Text_1_1_3, "#000000", 3)

	-- Create Image_5_1
	local Image_5_1 = GUI:Image_Create(Panel_bg, "Image_5_1", 235.00, 353.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_1, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1, false)
	GUI:setChineseName(Image_5_1, "注册新账户_账户_输入背景框")
	GUI:setAnchorPoint(Image_5_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1, false)
	GUI:setTag(Image_5_1, 148)

	-- Create Image_5_1_0
	local Image_5_1_0 = GUI:Image_Create(Panel_bg, "Image_5_1_0", 235.00, 298.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_1_0, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_0, false)
	GUI:setChineseName(Image_5_1_0, "注册新账户_密码_输入背景框")
	GUI:setAnchorPoint(Image_5_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_0, false)
	GUI:setTag(Image_5_1_0, 149)

	-- Create Image_5_1_1
	local Image_5_1_1 = GUI:Image_Create(Panel_bg, "Image_5_1_1", 235.00, 242.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_1_1, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_1, false)
	GUI:setChineseName(Image_5_1_1, "注册新账户_确认密码_输入背景框")
	GUI:setAnchorPoint(Image_5_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_1, false)
	GUI:setTag(Image_5_1_1, 150)

	-- Create Image_5_1_2
	local Image_5_1_2 = GUI:Image_Create(Panel_bg, "Image_5_1_2", 235.00, 184.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_1_2, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_2, false)
	GUI:setChineseName(Image_5_1_2, "注册新账户_密保_输入背景框")
	GUI:setAnchorPoint(Image_5_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_2, false)
	GUI:setTag(Image_5_1_2, 151)

	-- Create Image_5_1_3
	local Image_5_1_3 = GUI:Image_Create(Panel_bg, "Image_5_1_3", 235.00, 127.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_1_3, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_3, false)
	GUI:setChineseName(Image_5_1_3, "注册新账户_答案_输入背景框")
	GUI:setAnchorPoint(Image_5_1_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_3, false)
	GUI:setTag(Image_5_1_3, 152)

	-- Create TextField_username
	local TextField_username = GUI:TextInput_Create(Panel_bg, "TextField_username", 151.00, 353.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_username, "")
	GUI:TextInput_setFontColor(TextField_username, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_username, 12)
	GUI:setChineseName(TextField_username, "注册新账户_账号输入")
	GUI:setAnchorPoint(TextField_username, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_username, true)
	GUI:setTag(TextField_username, 153)

	-- Create TextField_password
	local TextField_password = GUI:TextInput_Create(Panel_bg, "TextField_password", 151.00, 298.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_password, "")
	GUI:TextInput_setFontColor(TextField_password, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_password, 12)
	GUI:setChineseName(TextField_password, "注册新账户_密码输入")
	GUI:setAnchorPoint(TextField_password, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_password, true)
	GUI:setTag(TextField_password, 154)

	-- Create TextField_password_confirm
	local TextField_password_confirm = GUI:TextInput_Create(Panel_bg, "TextField_password_confirm", 151.00, 241.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_password_confirm, "")
	GUI:TextInput_setFontColor(TextField_password_confirm, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_password_confirm, 12)
	GUI:setChineseName(TextField_password_confirm, "注册新账户_确认密码输入")
	GUI:setAnchorPoint(TextField_password_confirm, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_password_confirm, true)
	GUI:setTag(TextField_password_confirm, 155)

	-- Create TextField_question
	local TextField_question = GUI:TextInput_Create(Panel_bg, "TextField_question", 151.00, 184.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_question, "")
	GUI:TextInput_setFontColor(TextField_question, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_question, 12)
	GUI:setChineseName(TextField_question, "注册新账户_密保输入")
	GUI:setAnchorPoint(TextField_question, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_question, true)
	GUI:setTag(TextField_question, 156)

	-- Create TextField_answer
	local TextField_answer = GUI:TextInput_Create(Panel_bg, "TextField_answer", 151.00, 127.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_answer, "")
	GUI:TextInput_setFontColor(TextField_answer, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_answer, 12)
	GUI:setChineseName(TextField_answer, "注册新账户_答案输入")
	GUI:setAnchorPoint(TextField_answer, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_answer, true)
	GUI:setTag(TextField_answer, 157)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_bg, "Button_submit", 300.00, 52.00, "res/private/login/account/btn_tijiao_01.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/private/login/account/btn_tijiao_02.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 4, 4)
	GUI:setContentSize(Button_submit, 112, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#414146")
	GUI:Button_setTitleFontSize(Button_submit, 14)
	GUI:Button_titleDisableOutLine(Button_submit)
	GUI:setChineseName(Button_submit, "注册新账户_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 158)
end
return ui