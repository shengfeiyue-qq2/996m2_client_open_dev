local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "行会列表组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Layer, "PMainUI", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(PMainUI, "行会列表组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 34)

	-- Create Image_bottom
	local Image_bottom = GUI:Image_Create(PMainUI, "Image_bottom", 303.00, 30.00, "res/public/bg_hhdb_01.jpg")
	GUI:Image_setScale9Slice(Image_bottom, 242, 242, 21, 21)
	GUI:setContentSize(Image_bottom, 606, 64)
	GUI:setIgnoreContentAdaptWithSize(Image_bottom, false)
	GUI:setChineseName(Image_bottom, "行会列表创建行会_背景图")
	GUI:setAnchorPoint(Image_bottom, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bottom, false)
	GUI:setTag(Image_bottom, 74)

	-- Create Image_line
	local Image_line = GUI:Image_Create(PMainUI, "Image_line", 303.00, 354.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_line, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setChineseName(Image_line, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 159)

	-- Create Image_line1
	local Image_line1 = GUI:Image_Create(Image_line, "Image_line1", 150.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line1, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line1, false)
	GUI:setChineseName(Image_line1, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line1, false)
	GUI:setTag(Image_line1, 163)

	-- Create Image_line2
	local Image_line2 = GUI:Image_Create(Image_line, "Image_line2", 300.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line2, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line2, false)
	GUI:setChineseName(Image_line2, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line2, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line2, false)
	GUI:setTag(Image_line2, 164)

	-- Create Image_line3
	local Image_line3 = GUI:Image_Create(Image_line, "Image_line3", 380.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line3, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line3, false)
	GUI:setChineseName(Image_line3, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line3, false)
	GUI:setTag(Image_line3, 165)

	-- Create Image_line4
	local Image_line4 = GUI:Image_Create(Image_line, "Image_line4", 490.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line4, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line4, false)
	GUI:setChineseName(Image_line4, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line4, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line4, false)
	GUI:setTag(Image_line4, 166)

	-- Create Button_create
	local Button_create = GUI:Button_Create(PMainUI, "Button_create", 530.00, 30.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_create, "res/public_win32/1900000661.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "创建行会")
	GUI:Button_setTitleColor(Button_create, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#111111", 2)
	GUI:setChineseName(Button_create, "行会列表_创建行会_按钮")
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 41)

	-- Create ListView
	local ListView = GUI:ListView_Create(PMainUI, "ListView", 0.00, 62.00, 606.00, 290.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setChineseName(ListView, "行会列表_行会列表内容")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 75)

	-- Create Text_name
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 70.00, 370.00, 12, "#ffffff", [[行会名字]])
	GUI:setChineseName(Text_name, "行会列表_行会名称")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 76)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_master
	local Text_master = GUI:Text_Create(PMainUI, "Text_master", 220.00, 370.00, 12, "#ffffff", [[会长]])
	GUI:setChineseName(Text_master, "行会列表_会长名称")
	GUI:setAnchorPoint(Text_master, 0.50, 0.50)
	GUI:setTouchEnabled(Text_master, false)
	GUI:setTag(Text_master, 77)
	GUI:Text_enableOutline(Text_master, "#111111", 1)

	-- Create Text_count
	local Text_count = GUI:Text_Create(PMainUI, "Text_count", 340.00, 370.00, 12, "#ffffff", [[人数]])
	GUI:setChineseName(Text_count, "行会列表_行会人数")
	GUI:setAnchorPoint(Text_count, 0.50, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 78)
	GUI:Text_enableOutline(Text_count, "#111111", 1)

	-- Create Text_condition
	local Text_condition = GUI:Text_Create(PMainUI, "Text_condition", 435.00, 370.00, 12, "#ffffff", [[加入条件]])
	GUI:setChineseName(Text_condition, "行会列表_加入条件")
	GUI:setAnchorPoint(Text_condition, 0.50, 0.50)
	GUI:setTouchEnabled(Text_condition, false)
	GUI:setTag(Text_condition, 79)
	GUI:Text_enableOutline(Text_condition, "#111111", 1)

	-- Create Text_operation
	local Text_operation = GUI:Text_Create(PMainUI, "Text_operation", 550.00, 370.00, 12, "#ffffff", [[操作]])
	GUI:setChineseName(Text_operation, "行会列表_操作")
	GUI:setAnchorPoint(Text_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Text_operation, false)
	GUI:setTag(Text_operation, 80)
	GUI:Text_enableOutline(Text_operation, "#111111", 1)
end
return ui