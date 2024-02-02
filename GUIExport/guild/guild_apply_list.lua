local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 76)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 680.00, 400.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create btmImage
	local btmImage = GUI:Image_Create(PMainUI, "btmImage", 340.00, 43.00, "res/public/bg_hhdb_01.jpg")
	GUI:setContentSize(btmImage, 660, 64)
	GUI:setIgnoreContentAdaptWithSize(btmImage, false)
	GUI:setAnchorPoint(btmImage, 0.50, 0.50)
	GUI:setTouchEnabled(btmImage, false)
	GUI:setTag(btmImage, -1)

	-- Create line_bg
	local line_bg = GUI:Image_Create(PMainUI, "line_bg", 340.00, 350.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(line_bg, 660, 2)
	GUI:setIgnoreContentAdaptWithSize(line_bg, false)
	GUI:setAnchorPoint(line_bg, 0.50, 0.50)
	GUI:setTouchEnabled(line_bg, false)
	GUI:setTag(line_bg, -1)

	-- Create line1
	local line1 = GUI:Image_Create(line_bg, "line1", 170.00, 20.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(line1, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(line1, false)
	GUI:setAnchorPoint(line1, 0.50, 0.50)
	GUI:setTouchEnabled(line1, false)
	GUI:setTag(line1, -1)

	-- Create line2
	local line2 = GUI:Image_Create(line_bg, "line2", 335.00, 20.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(line2, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(line2, false)
	GUI:setAnchorPoint(line2, 0.50, 0.50)
	GUI:setTouchEnabled(line2, false)
	GUI:setTag(line2, -1)

	-- Create line3
	local line3 = GUI:Image_Create(line_bg, "line3", 450.00, 20.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(line3, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(line3, false)
	GUI:setAnchorPoint(line3, 0.50, 0.50)
	GUI:setTouchEnabled(line3, false)
	GUI:setTag(line3, -1)

	-- Create Title1
	local Title1 = GUI:Text_Create(PMainUI, "Title1", 90.00, 370.00, 16, "#f2e7cf", [[玩家名字]])
	GUI:setAnchorPoint(Title1, 0.50, 0.50)
	GUI:setTouchEnabled(Title1, false)
	GUI:setTag(Title1, -1)
	GUI:Text_enableOutline(Title1, "#000000", 1)

	-- Create Title2
	local Title2 = GUI:Text_Create(PMainUI, "Title2", 263.00, 370.00, 16, "#f2e7cf", [[等级]])
	GUI:setAnchorPoint(Title2, 0.50, 0.50)
	GUI:setTouchEnabled(Title2, false)
	GUI:setTag(Title2, -1)
	GUI:Text_enableOutline(Title2, "#000000", 1)

	-- Create Title3
	local Title3 = GUI:Text_Create(PMainUI, "Title3", 400.00, 370.00, 16, "#f2e7cf", [[职业]])
	GUI:setAnchorPoint(Title3, 0.50, 0.50)
	GUI:setTouchEnabled(Title3, false)
	GUI:setTag(Title3, -1)
	GUI:Text_enableOutline(Title3, "#000000", 1)

	-- Create Title4
	local Title4 = GUI:Text_Create(PMainUI, "Title4", 563.00, 370.00, 16, "#f2e7cf", [[操作]])
	GUI:setAnchorPoint(Title4, 0.50, 0.50)
	GUI:setTouchEnabled(Title4, false)
	GUI:setTag(Title4, -1)
	GUI:Text_enableOutline(Title4, "#000000", 1)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(PMainUI, "CheckBox", 35.00, 42.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:setContentSize(CheckBox, 20, 22)
	GUI:setIgnoreContentAdaptWithSize(CheckBox, false)
	GUI:CheckBox_setSelected(CheckBox, false)
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, -1)

	-- Create Label
	local Label = GUI:Text_Create(CheckBox, "Label", 25.00, 0.00, 16, "#f2e7cf", [[自动同意入会申请]])
	GUI:setTouchEnabled(Label, false)
	GUI:setTag(Label, -1)
	GUI:Text_enableOutline(Label, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox, "TouchSize", 0.00, 0.00, 145.00, 28.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create Input_bg
	local Input_bg = GUI:Image_Create(PMainUI, "Input_bg", 220.00, 40.00, "res/public/1900000668.png")
	GUI:setContentSize(Input_bg, 40, 20)
	GUI:setIgnoreContentAdaptWithSize(Input_bg, false)
	GUI:setAnchorPoint(Input_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Input_bg, false)
	GUI:setTag(Input_bg, -1)

	-- Create Input
	local Input = GUI:TextInput_Create(PMainUI, "Input", 220.00, 43.00, 40.00, 20.00, 16)
	GUI:TextInput_setString(Input, "1")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setAnchorPoint(Input, 0.50, 0.50)
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, -1)

	-- Create text
	local text = GUI:Text_Create(PMainUI, "text", 245.00, 40.00, 16, "#f2e7cf", [[级以上]])
	GUI:setAnchorPoint(text, 0.00, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create BtnAll
	local BtnAll = GUI:Button_Create(PMainUI, "BtnAll", 604.00, 42.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnAll, "一键通过")
	GUI:Button_setTitleColor(BtnAll, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnAll, 16)
	GUI:Button_titleEnableOutline(BtnAll, "#111111", 2)
	GUI:setAnchorPoint(BtnAll, 0.50, 0.50)
	GUI:setTouchEnabled(BtnAll, true)
	GUI:setTag(BtnAll, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 680.00, 401.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(PMainUI, "ListView", 13.00, 76.00, 653.00, 270.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)
end
return ui