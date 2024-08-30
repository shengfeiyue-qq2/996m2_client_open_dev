local ui = {}
function ui.init(parent)
	-- Create Cell_setting
	local Cell_setting = GUI:Layout_Create(parent, "Cell_setting", 0.00, 0.00, 95.00, 110.00, false)
	GUI:setChineseName(Cell_setting, "单技能组合")
	GUI:setAnchorPoint(Cell_setting, 0.00, 1.00)
	GUI:setTouchEnabled(Cell_setting, true)
	GUI:setTag(Cell_setting, 18.0)

	-- Create skill_bg
	local skill_bg = GUI:Image_Create(Cell_setting, "skill_bg", 47.00, 65.00, "res/private/skill/1900012701.png")
	GUI:setChineseName(skill_bg, "技能_背景图")
	GUI:setAnchorPoint(skill_bg, 0.50, 0.50)
	GUI:setTouchEnabled(skill_bg, false)
	GUI:setTag(skill_bg, 19.0)

	-- Create skill_icon
	local skill_icon = GUI:Image_Create(Cell_setting, "skill_icon", 47.00, 65.00, "Default/ImageFile.png")
	GUI:setChineseName(skill_icon, "技能_图标")
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, false)
	GUI:setTag(skill_icon, 49.0)

	-- Create skill_name
	local skill_name = GUI:Text_Create(Cell_setting, "skill_name", 47.00, 15.00, 16.0, "#ffffff", [[skill name]])
	GUI:setChineseName(skill_name, "技能_名称_文本")
	GUI:setAnchorPoint(skill_name, 0.50, 0.50)
	GUI:setTouchEnabled(skill_name, false)
	GUI:setTag(skill_name, 20.0)
	GUI:Text_enableOutline(skill_name, "#111111", 1.0)
end
return ui