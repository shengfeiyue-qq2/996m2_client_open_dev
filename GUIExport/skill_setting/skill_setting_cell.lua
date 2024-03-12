local ui = {}
function ui.init(parent)
	-- Create SkillCell
	local SkillCell = GUI:Layout_Create(parent, "SkillCell", 499.00, 395.00, 95.00, 110.00, false)
	GUI:setAnchorPoint(SkillCell, 0.00, 1.00)
	GUI:setTouchEnabled(SkillCell, true)
	GUI:setTag(SkillCell, -1)

	-- Create skill_bg
	local skill_bg = GUI:Image_Create(SkillCell, "skill_bg", 47.00, 65.00, "res/private/skill/1900012701.png")
	GUI:setAnchorPoint(skill_bg, 0.50, 0.50)
	GUI:setTouchEnabled(skill_bg, false)
	GUI:setTag(skill_bg, -1)

	-- Create skill_icon
	local skill_icon = GUI:Image_Create(SkillCell, "skill_icon", 47.00, 65.00, "res/private/skill/1900012703.png")
	GUI:setAnchorPoint(skill_icon, 0.50, 0.50)
	GUI:setTouchEnabled(skill_icon, false)
	GUI:setTag(skill_icon, -1)

	-- Create skill_name
	local skill_name = GUI:Text_Create(SkillCell, "skill_name", 47.00, 15.00, 16, "#ffffff", [[name]])
	GUI:setAnchorPoint(skill_name, 0.50, 0.50)
	GUI:setTouchEnabled(skill_name, false)
	GUI:setTag(skill_name, -1)
	GUI:Text_enableOutline(skill_name, "#000000", 1)
end
return ui