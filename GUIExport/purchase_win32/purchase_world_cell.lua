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
	local Text_p_num = GUI:Text_Create(Panel_cell, "Text_p_num", 174.00, 35.00, 12, "#ffffff", [[求购数量]])
	GUI:setAnchorPoint(Text_p_num, 0.50, 0.50)
	GUI:setTouchEnabled(Text_p_num, false)
	GUI:setTag(Text_p_num, 101)
	GUI:Text_enableOutline(Text_p_num, "#000000", 1)

	-- Create Text_min_num
	local Text_min_num = GUI:Text_Create(Panel_cell, "Text_min_num", 236.00, 35.00, 12, "#ffffff", [[最小数量]])
	GUI:setAnchorPoint(Text_min_num, 0.50, 0.50)
	GUI:setTouchEnabled(Text_min_num, false)
	GUI:setTag(Text_min_num, 102)
	GUI:Text_enableOutline(Text_min_num, "#000000", 1)

	-- Create Text_coin
	local Text_coin = GUI:Text_Create(Panel_cell, "Text_coin", 290.00, 35.00, 12, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_coin, 0.50, 0.50)
	GUI:setTouchEnabled(Text_coin, false)
	GUI:setTag(Text_coin, 103)
	GUI:Text_enableOutline(Text_coin, "#000000", 1)

	-- Create Text_single
	local Text_single = GUI:Text_Create(Panel_cell, "Text_single", 350.00, 35.00, 12, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_single, 0.50, 0.50)
	GUI:setTouchEnabled(Text_single, false)
	GUI:setTag(Text_single, 103)
	GUI:Text_enableOutline(Text_single, "#000000", 1)

	-- Create Text_total
	local Text_total = GUI:Text_Create(Panel_cell, "Text_total", 405.00, 35.00, 12, "#ffffff", [[总价]])
	GUI:setAnchorPoint(Text_total, 0.50, 0.50)
	GUI:setTouchEnabled(Text_total, false)
	GUI:setTag(Text_total, 103)
	GUI:Text_enableOutline(Text_total, "#000000", 1)

	-- Create Text_oper
	local Text_oper = GUI:Text_Create(Panel_cell, "Text_oper", 466.00, 35.00, 12, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_oper, 0.50, 0.50)
	GUI:setTouchEnabled(Text_oper, false)
	GUI:setTag(Text_oper, 103)
	GUI:Text_enableOutline(Text_oper, "#000000", 1)

	-- Create Button_oper
	local Button_oper = GUI:Button_Create(Panel_cell, "Button_oper", 466.00, 35.00, "res/public/1900000652.png")
	GUI:setContentSize(Button_oper, 55, 25)
	GUI:setIgnoreContentAdaptWithSize(Button_oper, false)
	GUI:Button_setTitleText(Button_oper, "卖出")
	GUI:Button_setTitleColor(Button_oper, "#ffffff")
	GUI:Button_setTitleFontSize(Button_oper, 12)
	GUI:Button_titleEnableOutline(Button_oper, "#000000", 1)
	GUI:setAnchorPoint(Button_oper, 0.50, 0.50)
	GUI:setTouchEnabled(Button_oper, true)
	GUI:setTag(Button_oper, -1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_cell, "Image_line", 0.00, 1.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_line, 505, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, -1)
end
return ui