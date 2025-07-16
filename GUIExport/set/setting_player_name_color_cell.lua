local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 440.00, 50.00, false)
	GUI:setTouchEnabled(Panel_cell, false)
	GUI:setTag(Panel_cell, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 12.00, 14.00, 16, "#ffffff", [[名字]])
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Panel_color_1
	local Panel_color_1 = GUI:Layout_Create(Panel_cell, "Panel_color_1", 153.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_1, 1)
	GUI:Layout_setBackGroundColor(Panel_color_1, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_1, 255)
	GUI:setAnchorPoint(Panel_color_1, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_1, true)
	GUI:setTag(Panel_color_1, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_1, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_2
	local Panel_color_2 = GUI:Layout_Create(Panel_cell, "Panel_color_2", 197.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_2, 1)
	GUI:Layout_setBackGroundColor(Panel_color_2, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_2, 255)
	GUI:setAnchorPoint(Panel_color_2, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_2, true)
	GUI:setTag(Panel_color_2, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_2, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_3
	local Panel_color_3 = GUI:Layout_Create(Panel_cell, "Panel_color_3", 241.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_3, 1)
	GUI:Layout_setBackGroundColor(Panel_color_3, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_3, 255)
	GUI:setAnchorPoint(Panel_color_3, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_3, true)
	GUI:setTag(Panel_color_3, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_3, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_4
	local Panel_color_4 = GUI:Layout_Create(Panel_cell, "Panel_color_4", 285.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_4, 1)
	GUI:Layout_setBackGroundColor(Panel_color_4, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_4, 255)
	GUI:setAnchorPoint(Panel_color_4, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_4, true)
	GUI:setTag(Panel_color_4, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_4, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_5
	local Panel_color_5 = GUI:Layout_Create(Panel_cell, "Panel_color_5", 329.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_5, 1)
	GUI:Layout_setBackGroundColor(Panel_color_5, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_5, 255)
	GUI:setAnchorPoint(Panel_color_5, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_5, true)
	GUI:setTag(Panel_color_5, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_5, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_6
	local Panel_color_6 = GUI:Layout_Create(Panel_cell, "Panel_color_6", 373.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_6, 1)
	GUI:Layout_setBackGroundColor(Panel_color_6, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_6, 255)
	GUI:setAnchorPoint(Panel_color_6, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_6, true)
	GUI:setTag(Panel_color_6, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_6, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_color_7
	local Panel_color_7 = GUI:Layout_Create(Panel_cell, "Panel_color_7", 417.00, 7.00, 36.00, 36.00, false)
	GUI:Layout_setBackGroundColorType(Panel_color_7, 1)
	GUI:Layout_setBackGroundColor(Panel_color_7, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Panel_color_7, 255)
	GUI:setAnchorPoint(Panel_color_7, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_color_7, true)
	GUI:setTag(Panel_color_7, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_color_7, "Image_select", -2.00, -2.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_select, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_split
	local Image_split = GUI:Image_Create(Panel_cell, "Image_split", 0.00, 0.00, "res/public/1900000667_1.png")
	GUI:Image_setScale9Slice(Image_split, 92, 92, 0, 1)
	GUI:setContentSize(Image_split, 440, 1)
	GUI:setIgnoreContentAdaptWithSize(Image_split, false)
	GUI:setTouchEnabled(Image_split, false)
	GUI:setTag(Image_split, -1)
end
return ui