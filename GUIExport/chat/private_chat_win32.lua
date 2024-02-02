local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "私聊场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 400.00, 261.00, false)
	GUI:setChineseName(Panel_1, "私聊组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 80)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 200.00, 130.50, "res/private/main-win32/chat/01150.png")
	GUI:setChineseName(Image_bg, "私聊_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 139)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 377.00, 238.00, "res/public_win32/btn_02.png")
	GUI:Button_setScale9Slice(Button_close, 6, 6, 11, 11)
	GUI:setContentSize(Button_close, 16, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "私聊_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 141)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 17.00, 218.00, 345.00, 175.00, 1)
	GUI:setChineseName(ListView_cells, "私聊_内容列表")
	GUI:setAnchorPoint(ListView_cells, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 140)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 370.00, 131.50, "res/private/main-win32/chat/00291.png")
	GUI:setContentSize(Image_2, 16, 175)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setChineseName(Image_2, "私聊滑块组合")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 142)

	-- Create Image_up
	local Image_up = GUI:Image_Create(Image_2, "Image_up", 9.00, 166.00, "res/private/main-win32/chat/00293.png")
	GUI:setChineseName(Image_up, "私聊_滑块向上_图片")
	GUI:setAnchorPoint(Image_up, 0.50, 0.50)
	GUI:setTouchEnabled(Image_up, false)
	GUI:setTag(Image_up, 144)

	-- Create Image_down
	local Image_down = GUI:Image_Create(Image_2, "Image_down", 9.00, 8.00, "res/private/main-win32/chat/00294.png")
	GUI:setChineseName(Image_down, "私聊_滑块向下_图片")
	GUI:setAnchorPoint(Image_down, 0.50, 0.50)
	GUI:setTouchEnabled(Image_down, false)
	GUI:setTag(Image_down, 145)

	-- Create Image_bar
	local Image_bar = GUI:Image_Create(Image_2, "Image_bar", 9.00, 87.50, "res/private/main-win32/chat/00579.png")
	GUI:setChineseName(Image_bar, "私聊_滑块_图片")
	GUI:setAnchorPoint(Image_bar, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bar, false)
	GUI:setTag(Image_bar, 143)

	-- Create CheckBox_1
	local CheckBox_1 = GUI:CheckBox_Create(Panel_1, "CheckBox_1", 27.85, 30.33, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_1, false)
	GUI:setChineseName(CheckBox_1, "私聊_自动回复_勾选框")
	GUI:setAnchorPoint(CheckBox_1, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_1, true)
	GUI:setTag(CheckBox_1, 78)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 62.51, 30.33, 12, "#ffffff", [[自动回复]])
	GUI:setChineseName(Text_1, "私聊_自动回复_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 80)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_inputbg
	local Image_inputbg = GUI:Image_Create(Panel_1, "Image_inputbg", 378.00, 30.00, "res/private/main-win32/chat/bg_input.png")
	GUI:Image_setScale9Slice(Image_inputbg, 115, 115, 13, 13)
	GUI:setContentSize(Image_inputbg, 288, 22)
	GUI:setIgnoreContentAdaptWithSize(Image_inputbg, false)
	GUI:setChineseName(Image_inputbg, "私聊_回复内容_背景框")
	GUI:setAnchorPoint(Image_inputbg, 1.00, 0.50)
	GUI:setTouchEnabled(Image_inputbg, false)
	GUI:setTag(Image_inputbg, 79)

	-- Create TextField_1
	local TextField_1 = GUI:TextInput_Create(Image_inputbg, "TextField_1", 144.00, 11.00, 282.00, 22.00, 12)
	GUI:TextInput_setString(TextField_1, "")
	GUI:TextInput_setPlaceHolder(TextField_1, "输入自动回复内容")
	GUI:TextInput_setFontColor(TextField_1, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_1, 10)
	GUI:setChineseName(TextField_1, "私聊_回复内容")
	GUI:setAnchorPoint(TextField_1, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_1, true)
	GUI:setTag(TextField_1, 81)
end
return ui