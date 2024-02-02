local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 104.00, 36.00, false)
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 143)

	-- Create CheckBox_drop
	local CheckBox_drop = GUI:CheckBox_Create(Panel_cell, "CheckBox_drop", 27.00, 18.00, "res/private/chat/drop/1900000654.png", "res/private/chat/drop/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_drop, true)
	GUI:setAnchorPoint(CheckBox_drop, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_drop, true)
	GUI:setTag(CheckBox_drop, 60)

	-- Create Text_drop_name
	local Text_drop_name = GUI:Text_Create(Panel_cell, "Text_drop_name", 50.00, 18.00, 20, "#ffffff", [[分类1]])
	GUI:setAnchorPoint(Text_drop_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_drop_name, false)
	GUI:setTag(Text_drop_name, 61)
	GUI:Text_enableOutline(Text_drop_name, "#000000", 1)
end
return ui