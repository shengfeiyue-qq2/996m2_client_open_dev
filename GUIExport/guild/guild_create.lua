local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 548.00, 326.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setContentSize(FrameBG, 548, 326)
	GUI:setIgnoreContentAdaptWithSize(FrameBG, false)
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create bgTitle
	local bgTitle = GUI:Image_Create(FrameLayout, "bgTitle", 275.00, 285.00, "res/private/guild_ui/word_hhzy_11.png")
	GUI:setAnchorPoint(bgTitle, 0.50, 0.50)
	GUI:setTouchEnabled(bgTitle, false)
	GUI:setTag(bgTitle, -1)

	-- Create TitleText_1
	local TitleText_1 = GUI:Text_Create(FrameLayout, "TitleText_1", 156.00, 240.00, 18, "#ffffff", [[行会名字]])
	GUI:setAnchorPoint(TitleText_1, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_1, false)
	GUI:setTag(TitleText_1, -1)
	GUI:Text_enableOutline(TitleText_1, "#000000", 1)

	-- Create TitleText_2
	local TitleText_2 = GUI:Text_Create(FrameLayout, "TitleText_2", 156.00, 150.00, 18, "#ffffff", [[需要道具]])
	GUI:setAnchorPoint(TitleText_2, 0.50, 0.50)
	GUI:setTouchEnabled(TitleText_2, false)
	GUI:setTag(TitleText_2, -1)
	GUI:Text_enableOutline(TitleText_2, "#000000", 1)

	-- Create Node_item
	local Node_item = GUI:Node_Create(FrameLayout, "Node_item", 275.00, 150.00)
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTag(Node_item, -1)

	-- Create Input_bg
	local Input_bg = GUI:Image_Create(FrameLayout, "Input_bg", 335.00, 240.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Input_bg, 37, 35, 10, 16)
	GUI:setContentSize(Input_bg, 200, 25)
	GUI:setIgnoreContentAdaptWithSize(Input_bg, false)
	GUI:setAnchorPoint(Input_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Input_bg, false)
	GUI:setTag(Input_bg, -1)

	-- Create Input
	local Input = GUI:TextInput_Create(FrameLayout, "Input", 330.00, 238.00, 195.00, 23.00, 16)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setPlaceHolder(Input, "请输入行会名")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setAnchorPoint(Input, 0.50, 0.50)
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, -1)

	-- Create BtnCreate
	local BtnCreate = GUI:Button_Create(FrameLayout, "BtnCreate", 275.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnCreate, "创建行会")
	GUI:Button_setTitleColor(BtnCreate, "#ffffff")
	GUI:Button_setTitleFontSize(BtnCreate, 16)
	GUI:Button_titleEnableOutline(BtnCreate, "#000000", 1)
	GUI:setAnchorPoint(BtnCreate, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCreate, true)
	GUI:setTag(BtnCreate, -1)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(FrameLayout, "CheckBox", 340.00, 186.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox, false)
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, -1)

	-- Create Label
	local Label = GUI:Text_Create(CheckBox, "Label", 25.00, 0.00, 16, "#ffffff", [[自动同意入会申请]])
	GUI:setTouchEnabled(Label, false)
	GUI:setTag(Label, -1)
	GUI:Text_enableOutline(Label, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox, "TouchSize", 0.00, -1.00, 145.00, 28.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create Input_level_bg
	local Input_level_bg = GUI:Image_Create(FrameLayout, "Input_level_bg", 337.00, 140.00, "res/public/1900000668.png")
	GUI:setContentSize(Input_level_bg, 40, 30)
	GUI:setIgnoreContentAdaptWithSize(Input_level_bg, false)
	GUI:setAnchorPoint(Input_level_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Input_level_bg, false)
	GUI:setTag(Input_level_bg, -1)

	-- Create Input_level
	local Input_level = GUI:TextInput_Create(Input_level_bg, "Input_level", -1.00, 13.00, 33.00, 23.00, 14)
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
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 561.00, 306.00, "res/public/1900000510.png")
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