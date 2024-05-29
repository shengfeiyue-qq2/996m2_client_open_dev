local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setChineseName(CloseLayout, "行会结盟_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 680.00, 400.00, false)
	GUI:setChineseName(PMainUI, "行会结盟_组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setChineseName(FrameBG, "行会结盟_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create line_bg
	local line_bg = GUI:Image_Create(PMainUI, "line_bg", 340.00, 350.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(line_bg, 660, 2)
	GUI:setIgnoreContentAdaptWithSize(line_bg, false)
	GUI:setChineseName(line_bg, "行会结盟_装饰条")
	GUI:setAnchorPoint(line_bg, 0.50, 0.50)
	GUI:setTouchEnabled(line_bg, false)
	GUI:setTag(line_bg, -1)

	-- Create line1
	local line1 = GUI:Image_Create(line_bg, "line1", 450.00, 20.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(line1, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(line1, false)
	GUI:setChineseName(line1, "行会结盟_装饰条")
	GUI:setAnchorPoint(line1, 0.50, 0.50)
	GUI:setTouchEnabled(line1, false)
	GUI:setTag(line1, -1)

	-- Create Title1
	local Title1 = GUI:Text_Create(PMainUI, "Title1", 235.00, 370.00, 16, "#f2e7cf", [[申请详情]])
	GUI:setChineseName(Title1, "行会结盟_申请详情_文本")
	GUI:setAnchorPoint(Title1, 0.50, 0.50)
	GUI:setTouchEnabled(Title1, false)
	GUI:setTag(Title1, -1)
	GUI:Text_enableOutline(Title1, "#000000", 1)

	-- Create Title2
	local Title2 = GUI:Text_Create(PMainUI, "Title2", 565.00, 370.00, 16, "#f2e7cf", [[操作]])
	GUI:setChineseName(Title2, "行会结盟_操作_文本")
	GUI:setAnchorPoint(Title2, 0.50, 0.50)
	GUI:setTouchEnabled(Title2, false)
	GUI:setTag(Title2, -1)
	GUI:Text_enableOutline(Title2, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 680.00, 401.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "行会结盟_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(PMainUI, "ListView", 13.00, 13.00, 653.00, 333.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setChineseName(ListView, "行会结盟_可操作列表")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)
end
return ui