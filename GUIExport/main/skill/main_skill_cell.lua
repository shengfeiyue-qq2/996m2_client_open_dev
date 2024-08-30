local ui = {}
function ui.init(parent)
	-- Create skill_cell
	local skill_cell = GUI:Layout_Create(parent, "skill_cell", 0.00, 0.00, 65.00, 65.00, false)
	GUI:setChineseName(skill_cell, "技能组合")
	GUI:setAnchorPoint(skill_cell, 0.50, 0.50)
	GUI:setTouchEnabled(skill_cell, false)
	GUI:setTag(skill_cell, -1.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(skill_cell, "Image_bg", 32.00, 32.00, "res/private/main/Skill/1900012017.png")
	GUI:setChineseName(Image_bg, "技能_背景框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1.0)

	-- Create skill_icon
	local skill_icon = GUI:Button_Create(skill_cell, "skill_icon", 32.00, 32.00, "res/private/main/Skill/1900012017.png")
	GUI:Button_setTitleText(skill_icon, "")
	GUI:Button_setTitleColor(skill_icon, "#ffffff")
	GUI:Button_setTitleFontSize(skill_icon, 10.0)
	GUI:Button_titleEnableOutline(skill_icon, "#000000", 1.0)
	GUI:setChineseName(skill_icon, "技能_图标")
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, true)
	GUI:setTag(skill_icon, -1.0)

	-- Create Node_select
	local Node_select = GUI:Node_Create(skill_cell, "Node_select", 32.00, 32.00)
	GUI:setChineseName(Node_select, "技能_选中节点")
	GUI:setAnchorPoint(Node_select, 0.50, 0.50)
	GUI:setTag(Node_select, -1.0)

	-- Create Node_on
	local Node_on = GUI:Node_Create(skill_cell, "Node_on", 32.00, 32.00)
	GUI:setChineseName(Node_on, "技能_开关节点")
	GUI:setAnchorPoint(Node_on, 0.50, 0.50)
	GUI:setTag(Node_on, -1.0)
end
return ui