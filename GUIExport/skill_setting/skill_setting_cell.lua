local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 95.00, 110.00, false)
	GUI:setChineseName(Panel_cell, "单技能组合")
	GUI:setAnchorPoint(Panel_cell, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 18)

	-- Create Image_skill_bg
	local Image_skill_bg = GUI:Image_Create(Panel_cell, "Image_skill_bg", 47.00, 65.00, "res/private/skill/1900012701.png")
	GUI:setChineseName(Image_skill_bg, "技能_背景图")
	GUI:setAnchorPoint(Image_skill_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_bg, false)
	GUI:setTag(Image_skill_bg, 19)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_cell, "Image_icon", 47.00, 65.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_icon, "技能_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 49)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 47.00, 15.00, 16, "#ffffff", [[skill name]])
	GUI:setChineseName(Text_name, "技能_名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 20)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui