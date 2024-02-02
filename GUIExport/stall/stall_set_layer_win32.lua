local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "摆摊场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 568.00, 320.00, 312.00, 150.00, false)
	GUI:setChineseName(PMainUI, "摆摊组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 68)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 156.00, 75.00, "res/private/baitan_ui/baitan_ui_win32/bg_baitanzy06.png")
	GUI:setChineseName(Image_1, "摆摊输入_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 69)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 156.00, 116.00, 15, "#ffffff", [[请输入商户信息]])
	GUI:setChineseName(Text_1, "摆摊输入_提示_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 70)
	GUI:Text_enableOutline(Text_1, "#111111", 1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(PMainUI, "Image_2", 156.00, 74.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_2, 51, 51, 10, 10)
	GUI:setContentSize(Image_2, 268, 33)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setChineseName(Image_2, "摆摊输入_输入框_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 71)

	-- Create TextField_name
	local TextField_name = GUI:TextInput_Create(PMainUI, "TextField_name", 156.00, 74.00, 268.00, 33.00, 20)
	GUI:TextInput_setString(TextField_name, "")
	GUI:TextInput_setFontColor(TextField_name, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_name, 10)
	GUI:setChineseName(TextField_name, "摆摊输入_输入内容_文本")
	GUI:setAnchorPoint(TextField_name, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_name, true)
	GUI:setTag(TextField_name, 72)

	-- Create Text_name
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 156.00, 74.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "摆摊输入_默认摆摊名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 78)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 322.00, 132.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setScale9Slice(Button_close, 5, 9, 11, 16)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "摆摊输入_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 73)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(PMainUI, "Button_ok", 156.00, 33.00, "res/public_win32/1900000673.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public_win32/1900000674.png")
	GUI:Button_setScale9Slice(Button_ok, 15, 15, 11, 11)
	GUI:setContentSize(Button_ok, 69, 26)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "确定")
	GUI:Button_setTitleColor(Button_ok, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_ok, 14)
	GUI:Button_titleEnableOutline(Button_ok, "#111111", 2)
	GUI:setChineseName(Button_ok, "摆摊输入_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 74)
end
return ui