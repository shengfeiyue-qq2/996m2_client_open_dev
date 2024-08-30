local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "连击节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "连击组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 174.00, 239.00, "res/private/internal/ng_bg.png")
	GUI:setChineseName(Image_bg, "连击_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 232)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 174.00, 413.00, "res/private/internal/1900000678.png")
	GUI:setContentSize(Image_1, 300, 76)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "连击_暴击_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create icon_1
	local icon_1 = GUI:Image_Create(Panel_1, "icon_1", 57.00, 413.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_1, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(icon_1, false)
	GUI:setChineseName(icon_1, "连击_10%暴击")
	GUI:setAnchorPoint(icon_1, 0.50, 0.50)
	GUI:setTouchEnabled(icon_1, false)
	GUI:setTag(icon_1, 32)

	-- Create skill_icon_1
	local skill_icon_1 = GUI:Image_Create(icon_1, "skill_icon_1", 2.00, 2.00, "res/private/internal/00901.png")
	GUI:setChineseName(skill_icon_1, "连击_10%暴击_图标")
	GUI:setTouchEnabled(skill_icon_1, false)
	GUI:setTag(skill_icon_1, -1)

	-- Create icon_2
	local icon_2 = GUI:Image_Create(Panel_1, "icon_2", 135.00, 413.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_2, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(icon_2, false)
	GUI:setChineseName(icon_2, "连击_15%暴击")
	GUI:setAnchorPoint(icon_2, 0.50, 0.50)
	GUI:setTouchEnabled(icon_2, false)
	GUI:setTag(icon_2, 32)

	-- Create skill_icon_2
	local skill_icon_2 = GUI:Image_Create(icon_2, "skill_icon_2", 2.00, 2.00, "res/private/internal/00902.png")
	GUI:setChineseName(skill_icon_2, "连击_15%暴击_图标")
	GUI:setTouchEnabled(skill_icon_2, false)
	GUI:setTag(skill_icon_2, -1)

	-- Create icon_3
	local icon_3 = GUI:Image_Create(Panel_1, "icon_3", 215.00, 413.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_3, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(icon_3, false)
	GUI:setChineseName(icon_3, "连击_25%暴击")
	GUI:setAnchorPoint(icon_3, 0.50, 0.50)
	GUI:setTouchEnabled(icon_3, false)
	GUI:setTag(icon_3, 32)

	-- Create skill_icon_3
	local skill_icon_3 = GUI:Image_Create(icon_3, "skill_icon_3", 2.00, 2.00, "res/private/internal/00903.png")
	GUI:setChineseName(skill_icon_3, "连击_25%暴击_图标")
	GUI:setTouchEnabled(skill_icon_3, false)
	GUI:setTag(skill_icon_3, -1)

	-- Create icon_4
	local icon_4 = GUI:Image_Create(Panel_1, "icon_4", 292.00, 413.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_4, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(icon_4, false)
	GUI:setChineseName(icon_4, "连击_自定义配置")
	GUI:setAnchorPoint(icon_4, 0.50, 0.50)
	GUI:setTouchEnabled(icon_4, false)
	GUI:setTag(icon_4, 32)

	-- Create skill_icon_4
	local skill_icon_4 = GUI:Image_Create(icon_4, "skill_icon_4", 2.00, 2.00, "res/private/internal/00905.png")
	GUI:setChineseName(skill_icon_4, "连击_自定义_图标")
	GUI:setTouchEnabled(skill_icon_4, false)
	GUI:setTag(skill_icon_4, -1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_1, "Image_line", 174.00, 358.00, "res/private/internal/line_1.png")
	GUI:setChineseName(Image_line, "连击_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 36)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 174.00, 23.00, 310.00, 332.00, 1)
	GUI:ListView_setGravity(ListView_cells, 5)
	GUI:setChineseName(ListView_cells, "连击_连击技能列表")
	GUI:setAnchorPoint(ListView_cells, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 13)
end
return ui