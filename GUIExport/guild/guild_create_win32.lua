local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "创建行会_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(Scene, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 76)
	GUI:setChineseName(CloseLayout, "创建行会_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, 21)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 568.00, 384.00, 460.00, 280.00, false)
	GUI:setChineseName(PMainUI, "创建行会_组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 24)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 230.00, 140.00, "res/public/1900000675.jpg")
	GUI:setContentSize(FrameBG, 460, 280)
	GUI:setIgnoreContentAdaptWithSize(FrameBG, false)
	GUI:setChineseName(FrameBG, "创建行会_背景")
	GUI:setAnchorPoint(FrameBG, 0.50, 0.50)
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, 25)

	-- Create bgTitle
	local bgTitle = GUI:Image_Create(PMainUI, "bgTitle", 230.00, 240.00, "res/private/guild_ui_win32/word_hhzy_11.png")
	GUI:setChineseName(bgTitle, "创建行会_标题_文本")
	GUI:setAnchorPoint(bgTitle, 0.50, 0.50)
	GUI:setTouchEnabled(bgTitle, false)
	GUI:setTag(bgTitle, 26)

	-- Create TitleText_1
	local TitleText_1 = GUI:Text_Create(PMainUI, "TitleText_1", 120.00, 200.00, 12, "#f8e6c6", [[行会名字]])
	GUI:setChineseName(TitleText_1, "创建行会_行会名字_文本")
	GUI:setAnchorPoint(TitleText_1, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_1, false)
	GUI:setTag(TitleText_1, 27)
	GUI:Text_enableOutline(TitleText_1, "#111111", 1)

	-- Create TitleText_2
	local TitleText_2 = GUI:Text_Create(PMainUI, "TitleText_2", 120.00, 125.00, 12, "#f8e6c6", [[需要道具]])
	GUI:setChineseName(TitleText_2, "创建行会_需要道具_文本")
	GUI:setAnchorPoint(TitleText_2, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_2, false)
	GUI:setTag(TitleText_2, -1)
	GUI:Text_enableOutline(TitleText_2, "#000000", 1)

	-- Create Node_item
	local Node_item = GUI:Node_Create(PMainUI, "Node_item", 205.00, 120.00)
	GUI:setChineseName(Node_item, "创建行会_需求物品_节点")
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTag(Node_item, -1)

	-- Create Input_bg
	local Input_bg = GUI:Image_Create(PMainUI, "Input_bg", 280.00, 200.00, "res/public/1900000668.png")
	GUI:setContentSize(Input_bg, 200, 22)
	GUI:setIgnoreContentAdaptWithSize(Input_bg, false)
	GUI:setChineseName(Input_bg, "创建行会_输入框_背景图")
	GUI:setAnchorPoint(Input_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Input_bg, false)
	GUI:setTag(Input_bg, 117)

	-- Create Input
	local Input = GUI:TextInput_Create(PMainUI, "Input", 280.00, 200.00, 200.00, 23.00, 13)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setPlaceHolder(Input, "请输入行会名")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:TextInput_setMaxLength(Input, 7)
	GUI:setChineseName(Input, "创建行会_输入框")
	GUI:setAnchorPoint(Input, 0.50, 0.50)
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, 28)

	-- Create BtnCreate
	local BtnCreate = GUI:Button_Create(PMainUI, "BtnCreate", 230.00, 45.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(BtnCreate, "res/public_win32/1900000611.png")
	GUI:Button_setScale9Slice(BtnCreate, 15, 15, 11, 11)
	GUI:setContentSize(BtnCreate, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(BtnCreate, false)
	GUI:Button_setTitleText(BtnCreate, "创建行会")
	GUI:Button_setTitleColor(BtnCreate, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnCreate, 14)
	GUI:Button_titleEnableOutline(BtnCreate, "#111111", 2)
	GUI:setChineseName(BtnCreate, "创建行会_创建行会_按钮")
	GUI:setAnchorPoint(BtnCreate, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCreate, true)
	GUI:setTag(BtnCreate, 29)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(PMainUI, "CheckBox", 300.00, 150.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox, true)
	GUI:setChineseName(CheckBox, "创建行会_勾选框_组合")
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, 30)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox, "TouchSize", -10.00, -10.00, 180.00, 35.00, false)
	GUI:setChineseName(TouchSize, "创建行会_自动同意触摸点")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 143)
	GUI:setVisible(TouchSize, false)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(CheckBox, "Text_2", 30.00, 9.00, 12, "#28ef01", [[自动同意入会申请]])
	GUI:setChineseName(Text_2, "创建行会_自动同意_文本")
	GUI:setAnchorPoint(Text_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 32)
	GUI:Text_enableOutline(Text_2, "#111111", 1)

	-- Create Input_level_bg
	local Input_level_bg = GUI:Image_Create(PMainUI, "Input_level_bg", 290.00, 100.00, "res/public/1900000668.png")
	GUI:setContentSize(Input_level_bg, 40, 31)
	GUI:setIgnoreContentAdaptWithSize(Input_level_bg, false)
	GUI:setChineseName(Input_level_bg, "创建行会_等级限制_组合")
	GUI:setAnchorPoint(Input_level_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Input_level_bg, true)
	GUI:setTag(Input_level_bg, 108)

	-- Create Input_level
	local Input_level = GUI:TextInput_Create(Input_level_bg, "Input_level", 20.00, 15.00, 30.00, 20.00, 13)
	GUI:TextInput_setString(Input_level, "")
	GUI:TextInput_setPlaceHolder(Input_level, "1")
	GUI:TextInput_setFontColor(Input_level, "#ffffff")
	GUI:TextInput_setMaxLength(Input_level, 10)
	GUI:setChineseName(Input_level, "创建行会_等级输入框")
	GUI:setAnchorPoint(Input_level, 0.50, 0.50)
	GUI:setTouchEnabled(Input_level, true)
	GUI:setTag(Input_level, 86)

	-- Create text
	local text = GUI:Text_Create(Input_level_bg, "text", 45.00, 15.00, 12, "#f8e6c6", [[级以上]])
	GUI:setChineseName(text, "创建行会_等级限制_文本")
	GUI:setAnchorPoint(text, 0.00, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, 110)
	GUI:Text_enableOutline(text, "#111111", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 460.00, 281.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(CloseButton, 8, 8, 12, 10)
	GUI:setContentSize(CloseButton, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(CloseButton, false)
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#414146")
	GUI:Button_setTitleFontSize(CloseButton, 14)
	GUI:Button_titleDisableOutLine(CloseButton)
	GUI:setChineseName(CloseButton, "创建行会_关闭按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, 31)
end
return ui