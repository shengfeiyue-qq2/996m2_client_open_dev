local ui = {}
function ui.init(parent)
	-- Create Panel_resolution
	local Panel_resolution = GUI:Layout_Create(parent, "Panel_resolution", 20.00, 20.00, 250.00, 180.00, false)
	GUI:setChineseName(Panel_resolution, "登录_分辨率组合")
	GUI:setTouchEnabled(Panel_resolution, true)
	GUI:setTag(Panel_resolution, 340)

	-- Create Text_1_0_1
	local Text_1_0_1 = GUI:Text_Create(Panel_resolution, "Text_1_0_1", 23.00, 77.00, 18, "#ffffff", [[高]])
	GUI:setChineseName(Text_1_0_1, "分辨率_高_文本")
	GUI:setAnchorPoint(Text_1_0_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0_1, false)
	GUI:setTag(Text_1_0_1, 21)
	GUI:Text_enableOutline(Text_1_0_1, "#000000", 3)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_resolution, "Text_1_0", 131.00, 161.00, 18, "#ffffff", [[分辨率]])
	GUI:setChineseName(Text_1_0, "分辨率_分辨率_文本")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 21)
	GUI:Text_enableOutline(Text_1_0, "#000000", 3)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_resolution, "Text_1", 23.00, 117.00, 18, "#ffffff", [[宽]])
	GUI:setChineseName(Text_1, "分辨率_宽_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 20)
	GUI:Text_enableOutline(Text_1, "#000000", 3)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_resolution, "Image_5", 138.00, 117.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5, false)
	GUI:setChineseName(Image_5, "分辨率_宽_背景框")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 23)

	-- Create Image_5_0
	local Image_5_0 = GUI:Image_Create(Panel_resolution, "Image_5_0", 138.00, 77.00, "res/private/login/account/bg_shuru_03.png")
	GUI:setContentSize(Image_5_0, 170, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_5_0, false)
	GUI:setChineseName(Image_5_0, "分辨率_高_背景框")
	GUI:setAnchorPoint(Image_5_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5_0, false)
	GUI:setTag(Image_5_0, 24)

	-- Create TextField_width
	local TextField_width = GUI:TextInput_Create(Panel_resolution, "TextField_width", 55.00, 117.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_width, "")
	GUI:TextInput_setFontColor(TextField_width, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_width, 12)
	GUI:setChineseName(TextField_width, "分辨率_宽_输入框")
	GUI:setAnchorPoint(TextField_width, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_width, true)
	GUI:setTag(TextField_width, 118)

	-- Create TextField_height
	local TextField_height = GUI:TextInput_Create(Panel_resolution, "TextField_height", 55.00, 78.00, 167.00, 30.00, 22)
	GUI:TextInput_setString(TextField_height, "")
	GUI:TextInput_setFontColor(TextField_height, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_height, 12)
	GUI:setChineseName(TextField_height, "分辨率_高_输入框")
	GUI:setAnchorPoint(TextField_height, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_height, true)
	GUI:setTag(TextField_height, 114)

	-- Create btnReset
	local btnReset = GUI:Button_Create(Panel_resolution, "btnReset", 182.00, 22.00, "res/public/1900001022.png")
	GUI:Button_setScale9Slice(btnReset, 27, 22, 12, 9)
	GUI:setContentSize(btnReset, 80, 34)
	GUI:setIgnoreContentAdaptWithSize(btnReset, false)
	GUI:Button_setTitleText(btnReset, "恢复默认")
	GUI:Button_setTitleColor(btnReset, "#ffffff")
	GUI:Button_setTitleFontSize(btnReset, 14)
	GUI:Button_titleEnableOutline(btnReset, "#000000", 1)
	GUI:setChineseName(btnReset, "分辨率_恢复默认_按钮")
	GUI:setAnchorPoint(btnReset, 0.50, 0.50)
	GUI:setTouchEnabled(btnReset, true)
	GUI:setTag(btnReset, 13)

	-- Create btnOk
	local btnOk = GUI:Button_Create(Panel_resolution, "btnOk", 92.00, 22.00, "res/public/1900001022.png")
	GUI:Button_setScale9Slice(btnOk, 26, 24, 13, 9)
	GUI:setContentSize(btnOk, 80, 34)
	GUI:setIgnoreContentAdaptWithSize(btnOk, false)
	GUI:Button_setTitleText(btnOk, "确    定")
	GUI:Button_setTitleColor(btnOk, "#ffffff")
	GUI:Button_setTitleFontSize(btnOk, 14)
	GUI:Button_titleEnableOutline(btnOk, "#000000", 1)
	GUI:setChineseName(btnOk, "分辨率_确认_按钮")
	GUI:setAnchorPoint(btnOk, 0.50, 0.50)
	GUI:setTouchEnabled(btnOk, true)
	GUI:setTag(btnOk, 13)
end
return ui