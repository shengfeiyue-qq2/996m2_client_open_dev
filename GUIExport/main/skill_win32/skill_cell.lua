local ui = {}
function ui.init(parent)
	-- Create skill_cell
	local skill_cell = GUI:Layout_Create(parent, "skill_cell", 0.00, 0.00, 55.00, 55.00, false)
	GUI:setTouchEnabled(skill_cell, false)
	GUI:setTag(skill_cell, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(skill_cell, "Image_bg", 27.00, 27.00, "res/private/main-win32/skill/bg_kjjsz_02.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create skill_icon
	local skill_icon = GUI:Button_Create(skill_cell, "skill_icon", 27.00, 26.00, "res/public/0.png")
	GUI:setContentSize(skill_icon, 44, 44)
	GUI:setIgnoreContentAdaptWithSize(skill_icon, false)
	GUI:Button_setTitleText(skill_icon, "")
	GUI:Button_setTitleColor(skill_icon, "#ffffff")
	GUI:Button_setTitleFontSize(skill_icon, 10)
	GUI:Button_titleEnableOutline(skill_icon, "#000000", 1)
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, true)
	GUI:setTag(skill_icon, -1)

	-- Create Image_key
	local Image_key = GUI:Image_Create(skill_cell, "Image_key", 47.00, 5.00, "res/private/main-win32/word/key_F1.png")
	GUI:setAnchorPoint(Image_key, 1.00, 0.00)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Text_cd
	local Text_cd = GUI:Text_Create(skill_cell, "Text_cd", 27.00, 27.00, 14, "#ff0000", [[]])
	GUI:setAnchorPoint(Text_cd, 0.50, 0.50)
	GUI:setTouchEnabled(Text_cd, false)
	GUI:setTag(Text_cd, -1)
	GUI:Text_enableOutline(Text_cd, "#000000", 1)

	-- Create Node_tx
	local Node_tx = GUI:Node_Create(skill_cell, "Node_tx", 27.00, 27.00)
	GUI:setAnchorPoint(Node_tx, 0.50, 0.50)
	GUI:setTag(Node_tx, -1)
end
return ui