local ui = {}
function ui.init(parent)
	-- Create skill_cell
	local skill_cell = GUI:Layout_Create(parent, "skill_cell", 0.00, 0.00, 65.00, 65.00, false)
	GUI:setAnchorPoint(skill_cell, 0.50, 0.50)
	GUI:setTouchEnabled(skill_cell, false)
	GUI:setTag(skill_cell, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(skill_cell, "Image_bg", 32.00, 32.00, "res/private/main/Skill/1900012017.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create skill_icon
	local skill_icon = GUI:Button_Create(skill_cell, "skill_icon", 32.00, 32.00, "res/private/main/Skill/1900012017.png")
	GUI:Button_setTitleText(skill_icon, "")
	GUI:Button_setTitleColor(skill_icon, "#ffffff")
	GUI:Button_setTitleFontSize(skill_icon, 10)
	GUI:Button_titleEnableOutline(skill_icon, "#000000", 1)
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, true)
	GUI:setTag(skill_icon, -1)

	-- Create Node_select
	local Node_select = GUI:Node_Create(skill_cell, "Node_select", 32.00, 32.00)
	GUI:setTag(Node_select, -1)

	-- Create Node_on
	local Node_on = GUI:Node_Create(skill_cell, "Node_on", 32.00, 32.00)
	GUI:setTag(Node_on, -1)

	-- Create Text_cd
	local Text_cd = GUI:Text_Create(skill_cell, "Text_cd", 33.00, 33.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_cd, 0.50, 0.50)
	GUI:setTouchEnabled(Text_cd, false)
	GUI:setTag(Text_cd, -1)
	GUI:setVisible(Text_cd, false)
	GUI:Text_enableOutline(Text_cd, "#000000", 1)
end
return ui