local ui = {}
function ui.init(parent)
	-- Create skill_cell
	local skill_cell = GUI:Layout_Create(parent, "skill_cell", 0.00, 0.00, 65.00, 65.00, false)
	GUI:setTouchEnabled(skill_cell, false)
	GUI:setTag(skill_cell, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(skill_cell, "Image_bg", 32.00, 39.00, "res/private/main/bg_hejidj_01.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Image_progress
	local Image_progress = GUI:Image_Create(skill_cell, "Image_progress", 32.00, 32.00, "res/private/main/bg_hejidj_02.png")
	GUI:setAnchorPoint(Image_progress, 0.50, 0.50)
	GUI:setTouchEnabled(Image_progress, false)
	GUI:setTag(Image_progress, -1)

	-- Create skill_icon
	local skill_icon = GUI:Button_Create(skill_cell, "skill_icon", 32.00, 32.00, "res/private/main/bg_hejidj_01.png")
	GUI:setContentSize(skill_icon, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(skill_icon, false)
	GUI:Button_setTitleText(skill_icon, "")
	GUI:Button_setTitleColor(skill_icon, "#ffffff")
	GUI:Button_setTitleFontSize(skill_icon, 10)
	GUI:Button_titleEnableOutline(skill_icon, "#000000", 1)
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, true)
	GUI:setTag(skill_icon, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(skill_icon, "TouchSize", -5.00, -5.00, 70.00, 70.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(skill_cell, "Node_sfx", 32.00, 32.00)
	GUI:setTag(Node_sfx, -1)
	GUI:setVisible(Node_sfx, false)
end
return ui