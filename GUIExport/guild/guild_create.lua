local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 0)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 548.00, 326.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setContentSize(FrameBG, 548, 326)
	GUI:setIgnoreContentAdaptWithSize(FrameBG, false)
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create bgTitle
	local bgTitle = GUI:Image_Create(PMainUI, "bgTitle", 275.00, 285.00, "res/private/guild_ui/word_hhzy_11.png")
	GUI:setAnchorPoint(bgTitle, 0.50, 0.50)
	GUI:setTouchEnabled(bgTitle, false)
	GUI:setTag(bgTitle, -1)

	-- Create TitleText_1
	local TitleText_1 = GUI:Text_Create(PMainUI, "TitleText_1", 170.00, 240.00, 18, "#f2e7cf", [[行会名字]])
	GUI:setAnchorPoint(TitleText_1, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_1, false)
	GUI:setTag(TitleText_1, -1)
	GUI:Text_enableOutline(TitleText_1, "#000000", 1)

	-- Create TitleText_2
	local TitleText_2 = GUI:Text_Create(PMainUI, "TitleText_2", 170.00, 150.00, 18, "#f2e7cf", [[需要道具]])
	GUI:setAnchorPoint(TitleText_2, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_2, false)
	GUI:setTag(TitleText_2, -1)
	GUI:Text_enableOutline(TitleText_2, "#000000", 1)

	-- Create Node_item
	local Node_item = GUI:Node_Create(PMainUI, "Node_item", 248.00, 125.00)
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTag(Node_item, -1)

	-- Create Input_bg
	local Input_bg = GUI:Image_Create(PMainUI, "Input_bg", 320.00, 240.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Input_bg, 37, 35, 11, 15)
	GUI:setContentSize(Input_bg, 200, 30)
	GUI:setIgnoreContentAdaptWithSize(Input_bg, false)
	GUI:setAnchorPoint(Input_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Input_bg, false)
	GUI:setTag(Input_bg, -1)

	-- Create Input
	local Input = GUI:TextInput_Create(PMainUI, "Input", 320.00, 240.00, 200.00, 30.00, 20)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setPlaceHolder(Input, "请输入行会名")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setAnchorPoint(Input, 0.50, 0.50)
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, -1)

	-- Create BtnCreate
	local BtnCreate = GUI:Button_Create(PMainUI, "BtnCreate", 275.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnCreate, "创建行会")
	GUI:Button_setTitleColor(BtnCreate, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnCreate, 18)
	GUI:Button_titleEnableOutline(BtnCreate, "#111111", 2)
	GUI:setAnchorPoint(BtnCreate, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCreate, true)
	GUI:setTag(BtnCreate, -1)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(PMainUI, "CheckBox", 350.00, 170.00, "res/public/1900000682.png", "res/public/1900000683.png")
	GUI:setContentSize(CheckBox, 35, 30)
	GUI:setIgnoreContentAdaptWithSize(CheckBox, false)
	GUI:CheckBox_setSelected(CheckBox, false)
	GUI:setAnchorPoint(CheckBox, 0.00, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, -1)

	-- Create Label
	local Label = GUI:Text_Create(CheckBox, "Label", 45.00, 5.00, 16, "#f2e7cf", [[自动同意入会申请]])
	GUI:setTouchEnabled(Label, false)
	GUI:setTag(Label, -1)
	GUI:Text_enableOutline(Label, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox, "TouchSize", 0.00, 0.00, 150.00, 30.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create Input_level_bg
	local Input_level_bg = GUI:Image_Create(PMainUI, "Input_level_bg", 350.00, 130.00, "res/public/1900000668.png")
	GUI:setContentSize(Input_level_bg, 40, 30)
	GUI:setIgnoreContentAdaptWithSize(Input_level_bg, false)
	GUI:setAnchorPoint(Input_level_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Input_level_bg, false)
	GUI:setTag(Input_level_bg, -1)

	-- Create Input_level
	local Input_level = GUI:TextInput_Create(Input_level_bg, "Input_level", 0.00, 15.00, 40.00, 30.00, 16)
	GUI:TextInput_setString(Input_level, "")
	GUI:TextInput_setPlaceHolder(Input_level, "1")
	GUI:TextInput_setFontColor(Input_level, "#ffffff")
	GUI:setAnchorPoint(Input_level, 0.00, 0.50)
	GUI:setTouchEnabled(Input_level, true)
	GUI:setTag(Input_level, -1)

	-- Create text
	local text = GUI:Text_Create(Input_level_bg, "text", 45.00, 15.00, 16, "#f2e7cf", [[级以上]])
	GUI:setAnchorPoint(text, 0.00, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 561.00, 305.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setAnchorPoint(CloseButton, 0.50, 0.50)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)
end
return ui