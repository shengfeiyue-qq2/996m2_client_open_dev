local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "实名认证场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 640.00, 475.00, false)
	GUI:setChineseName(Panel_bg, "实名认证_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 72)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 328.00, 233.00, "res/private/login/account/bg_tongy_01.png")
	GUI:setChineseName(Image_1, "实名认证_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 73)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_bg, "Text_title", 320.00, 350.00, 18, "#53a050", [[实 名 认 证]])
	GUI:setChineseName(Text_title, "实名认证_标题_文本")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 74)
	GUI:Text_enableOutline(Text_title, "#000000", 3)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 539.00, 367.00, "res/public/btn_normal_2.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "实名认证_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 75)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_bg, "Text_1_1", 215.00, 304.00, 18, "#ffffff", [[姓　　　名]])
	GUI:setChineseName(Text_1_1, "实名认证_姓名_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 76)
	GUI:Text_enableOutline(Text_1_1, "#000000", 3)

	-- Create Text_1_1_0
	local Text_1_1_0 = GUI:Text_Create(Panel_bg, "Text_1_1_0", 215.00, 265.00, 18, "#ffffff", [[身 份 证 号]])
	GUI:setChineseName(Text_1_1_0, "实名认证_身份证_文本")
	GUI:setAnchorPoint(Text_1_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1_0, false)
	GUI:setTag(Text_1_1_0, 77)
	GUI:Text_enableOutline(Text_1_1_0, "#000000", 3)

	-- Create Image_5_1
	local Image_5_1 = GUI:Image_Create(Panel_bg, "Image_5_1", 372.00, 304.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1, 143, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1, false)
	GUI:setChineseName(Image_5_1, "实名认证_姓名_输入背景框")
	GUI:setAnchorPoint(Image_5_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1, false)
	GUI:setTag(Image_5_1, 78)

	-- Create Image_5_1_0
	local Image_5_1_0 = GUI:Image_Create(Panel_bg, "Image_5_1_0", 400.00, 265.00, "res/private/login/account/bg_shuru_02.png")
	GUI:setContentSize(Image_5_1_0, 200, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_1_0, false)
	GUI:setChineseName(Image_5_1_0, "实名认证_身份证_输入背景框")
	GUI:setAnchorPoint(Image_5_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_1_0, false)
	GUI:setTag(Image_5_1_0, 79)

	-- Create TextField_name
	local TextField_name = GUI:TextInput_Create(Panel_bg, "TextField_name", 304.00, 304.00, 140.00, 30.00, 22)
	GUI:TextInput_setString(TextField_name, "")
	GUI:TextInput_setFontColor(TextField_name, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_name, 12)
	GUI:setChineseName(TextField_name, "实名认证_姓名输入")
	GUI:setAnchorPoint(TextField_name, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_name, true)
	GUI:setTag(TextField_name, 80)

	-- Create TextField_IDnumber
	local TextField_IDnumber = GUI:TextInput_Create(Panel_bg, "TextField_IDnumber", 303.00, 265.00, 192.00, 30.00, 22)
	GUI:TextInput_setString(TextField_IDnumber, "")
	GUI:TextInput_setFontColor(TextField_IDnumber, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_IDnumber, 12)
	GUI:setChineseName(TextField_IDnumber, "实名认证_身份证输入")
	GUI:setAnchorPoint(TextField_IDnumber, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_IDnumber, true)
	GUI:setTag(TextField_IDnumber, 81)

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
	GUI:setChineseName(Button_submit, "实名认证_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 82)
end
return ui