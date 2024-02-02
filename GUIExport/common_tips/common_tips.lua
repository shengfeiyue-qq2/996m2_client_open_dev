local ui = {}
function ui.init(parent)
	-- Create Layout
	local Layout = GUI:Layout_Create(parent, "Layout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Layout, "通用信息框_布局")
	GUI:setTouchEnabled(Layout, true)
	GUI:setTag(Layout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 452.00, 179.00, false)
	GUI:Layout_setBackGroundImage(PMainUI, "res/public/1900000600.png")
	GUI:setChineseName(PMainUI, "通用信息框_组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create DescList
	local DescList = GUI:ScrollView_Create(PMainUI, "DescList", 20.00, 159.00, 412.00, 99.00, 1)
	GUI:ScrollView_setInnerContainerSize(DescList, 412.00, 99.00)
	GUI:setChineseName(DescList, "通用信息框_信息_文本")
	GUI:setAnchorPoint(DescList, 0.00, 1.00)
	GUI:setTouchEnabled(DescList, true)
	GUI:setTag(DescList, -1)

	-- Create TextFieldBg
	local TextFieldBg = GUI:Image_Create(PMainUI, "TextFieldBg", 226.00, 89.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(TextFieldBg, 78, 77, 4, 4)
	GUI:setContentSize(TextFieldBg, 380, 31)
	GUI:setIgnoreContentAdaptWithSize(TextFieldBg, false)
	GUI:setChineseName(TextFieldBg, "通用信息框_输入框背景_图片")
	GUI:setAnchorPoint(TextFieldBg, 0.50, 0.50)
	GUI:setTouchEnabled(TextFieldBg, false)
	GUI:setTag(TextFieldBg, -1)
	GUI:setVisible(TextFieldBg, false)

	-- Create TextField
	local TextField = GUI:TextInput_Create(TextFieldBg, "TextField", 190.00, 15.00, 374.00, 25.00, 18)
	GUI:TextInput_setString(TextField, "")
	GUI:TextInput_setFontColor(TextField, "#ffffff")
	GUI:setChineseName(TextField, "通用信息框_输入框_文本")
	GUI:setAnchorPoint(TextField, 0.50, 0.50)
	GUI:setTouchEnabled(TextField, true)
	GUI:setTag(TextField, -1)

	-- Create CheckBox_state
	local CheckBox_state = GUI:CheckBox_Create(PMainUI, "CheckBox_state", 20.00, 18.00, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
	GUI:CheckBox_setSelected(CheckBox_state, false)
	GUI:setTouchEnabled(CheckBox_state, true)
	GUI:setTag(CheckBox_state, -1)
	GUI:setVisible(CheckBox_state, false)

	-- Create Text_state
	local Text_state = GUI:Text_Create(CheckBox_state, "Text_state", 43.00, 16.00, 12, "#ffffff", [[]])
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, -1)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Btn_1
	local Btn_1 = GUI:Button_Create(PMainUI, "Btn_1", 287.00, 40.00, "res/public/1900001022.png")
	GUI:Button_loadTexturePressed(Btn_1, "res/public/1900001023.png")
	GUI:Button_setTitleText(Btn_1, "")
	GUI:Button_setTitleColor(Btn_1, "#ffffff")
	GUI:Button_setTitleFontSize(Btn_1, 14)
	GUI:Button_titleEnableOutline(Btn_1, "#000000", 1)
	GUI:setChineseName(Btn_1, "通用信息框_取消按钮2")
	GUI:setAnchorPoint(Btn_1, 0.50, 0.50)
	GUI:setTouchEnabled(Btn_1, true)
	GUI:setTag(Btn_1, -1)

	-- Create Btn_2
	local Btn_2 = GUI:Button_Create(PMainUI, "Btn_2", 387.00, 40.00, "res/public/1900001022.png")
	GUI:Button_loadTexturePressed(Btn_2, "res/public/1900001023.png")
	GUI:Button_setTitleText(Btn_2, "")
	GUI:Button_setTitleColor(Btn_2, "#ffffff")
	GUI:Button_setTitleFontSize(Btn_2, 14)
	GUI:Button_titleEnableOutline(Btn_2, "#000000", 1)
	GUI:setChineseName(Btn_2, "通用信息框_确认按钮2")
	GUI:setAnchorPoint(Btn_2, 0.50, 0.50)
	GUI:setTouchEnabled(Btn_2, true)
	GUI:setTag(Btn_2, -1)
end
return ui