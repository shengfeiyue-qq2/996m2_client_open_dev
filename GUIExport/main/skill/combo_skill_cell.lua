local ui = {}
function ui.init(parent)
	-- Create skill_cell
	local skill_cell = GUI:Layout_Create(parent, "skill_cell", 0.00, 0.00, 64.00, 64.00, false)
	GUI:setChineseName(skill_cell, "连击技能组合")
	GUI:setAnchorPoint(skill_cell, 0.50, 0.50)
	GUI:setTouchEnabled(skill_cell, false)
	GUI:setTag(skill_cell, -1.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(skill_cell, "Image_bg", 0.00, 3.00, "res/private/main/bg_combo_skill.png")
	GUI:setContentSize(Image_bg, 64.0, 64.0)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "连击技能_背景")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1.0)

	-- Create skill_icon
	local skill_icon = GUI:Button_Create(skill_cell, "skill_icon", 3.00, -4.00, "res/skill_icon_c/0.png")
	GUI:setContentSize(skill_icon, 60.0, 60.0)
	GUI:setIgnoreContentAdaptWithSize(skill_icon, false)
	GUI:Button_setTitleText(skill_icon, "")
	GUI:Button_setTitleColor(skill_icon, "#ffffff")
	GUI:Button_setTitleFontSize(skill_icon, 14.0)
	GUI:Button_titleEnableOutline(skill_icon, "#000000", 1.0)
	GUI:setChineseName(skill_icon, "连击技能_技能图标")
	GUI:setTouchEnabled(skill_icon, true)
	GUI:setTag(skill_icon, -1.0)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(skill_cell, "Node_sfx", 8.00, 3.00)
	GUI:setChineseName(Node_sfx, "连击技能_节点")
	GUI:setTag(Node_sfx, -1.0)
end
return ui