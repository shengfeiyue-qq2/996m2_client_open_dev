local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 136.00, 28.00, false)
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 51)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_cell, "Image_select", 68.00, 14.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_select, 42, 42, 0, 0)
	GUI:setContentSize(Image_select, 136, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 52)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 5.00, 14.00, 18, "#ffffff", [[Text Label]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 53)
	GUI:Text_enableOutline(Text_name, "#000000", 1)
end
return ui