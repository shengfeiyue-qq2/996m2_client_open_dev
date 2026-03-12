local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 505.00, 70.00, 505.00, 70.00, false)
	GUI:setAnchorPoint(Panel_cell, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_cell, false)
	GUI:setTag(Panel_cell, 328)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", 6.00, 35.00, "res/public_win32/1900000664.png")
	GUI:setAnchorPoint(Image_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 68.00, 35.00, 12, "#ffffff", [[物品名称]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 100)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_p_num
	local Text_p_num = GUI:Text_Create(Panel_cell, "Text_p_num", 180.00, 35.00, 12, "#ffffff", [[数量]])
	GUI:setAnchorPoint(Text_p_num, 0.50, 0.50)
	GUI:setTouchEnabled(Text_p_num, false)
	GUI:setTag(Text_p_num, 101)
	GUI:Text_enableOutline(Text_p_num, "#000000", 1)

	-- Create Text_total
	local Text_total = GUI:Text_Create(Panel_cell, "Text_total", 260.00, 35.00, 12, "#ffffff", [[价格]])
	GUI:setAnchorPoint(Text_total, 0.50, 0.50)
	GUI:setTouchEnabled(Text_total, false)
	GUI:setTag(Text_total, 103)
	GUI:Text_enableOutline(Text_total, "#000000", 1)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Panel_cell, "Text_time", 338.00, 35.00, 12, "#ffffff", [[日期]])
	GUI:setAnchorPoint(Text_time, 0.50, 0.50)
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, 103)
	GUI:Text_enableOutline(Text_time, "#000000", 1)

	-- Create Button_oper
	local Button_oper = GUI:Button_Create(Panel_cell, "Button_oper", 582.00, 40.00, "res/public/1900000652.png")
	GUI:Button_setScale9Slice(Button_oper, 15, 15, 12, 10)
	GUI:setContentSize(Button_oper, 65, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_oper, false)
	GUI:Button_setTitleText(Button_oper, "删除")
	GUI:Button_setTitleColor(Button_oper, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_oper, 16)
	GUI:Button_titleEnableOutline(Button_oper, "#111111", 2)
	GUI:setAnchorPoint(Button_oper, 0.50, 0.50)
	GUI:setTouchEnabled(Button_oper, true)
	GUI:setTag(Button_oper, 144)
	GUI:setVisible(Button_oper, false)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_cell, "Image_line", 0.00, 1.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_line, 640, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, -1)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_cell, "Text_state", 420.00, 35.00, 12, "#ffffff", [[出售]])
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, -1)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Text_coin
	local Text_coin = GUI:Text_Create(Panel_cell, "Text_coin", 505.00, 35.00, 12, "#ffffff", [[货币]])
	GUI:setAnchorPoint(Text_coin, 0.50, 0.50)
	GUI:setTouchEnabled(Text_coin, false)
	GUI:setTag(Text_coin, 145)
	GUI:Text_enableOutline(Text_coin, "#000000", 1)
end
return ui