local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "连击节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(Panel_1, "连击组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 189)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 136.00, 174.00, "res/private/internal_win32/ng_bg.png")
	GUI:setChineseName(Image_bg, "连击_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 237)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 136.00, 275.00, "res/private/internal/1900000678.png")
	GUI:Image_setScale9Slice(Image_1, 43, 43, 11, 10)
	GUI:setContentSize(Image_1, 244, 56)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "连击_暴击_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create icon_1
	local icon_1 = GUI:Image_Create(Panel_1, "icon_1", 28.00, 278.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_1, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(icon_1, false)
	GUI:setChineseName(icon_1, "连击_10%暴击")
	GUI:setTouchEnabled(icon_1, false)
	GUI:setTag(icon_1, -1)

	-- Create skill_icon_1
	local skill_icon_1 = GUI:Image_Create(icon_1, "skill_icon_1", 2.00, 2.00, "res/private/internal_win32/00901.png")
	GUI:setChineseName(skill_icon_1, "连击_10%暴击_图标")
	GUI:setTouchEnabled(skill_icon_1, false)
	GUI:setTag(skill_icon_1, -1)

	-- Create icon_2
	local icon_2 = GUI:Image_Create(Panel_1, "icon_2", 84.00, 278.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_2, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(icon_2, false)
	GUI:setChineseName(icon_2, "连击_15%暴击")
	GUI:setTouchEnabled(icon_2, false)
	GUI:setTag(icon_2, -1)

	-- Create skill_icon_2
	local skill_icon_2 = GUI:Image_Create(icon_2, "skill_icon_2", 2.00, 2.00, "res/private/internal_win32/00902.png")
	GUI:setChineseName(skill_icon_2, "连击_15%暴击_图标")
	GUI:setTouchEnabled(skill_icon_2, false)
	GUI:setTag(skill_icon_2, -1)

	-- Create icon_3
	local icon_3 = GUI:Image_Create(Panel_1, "icon_3", 140.00, 278.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_3, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(icon_3, false)
	GUI:setChineseName(icon_3, "连击_25%暴击")
	GUI:setTouchEnabled(icon_3, false)
	GUI:setTag(icon_3, -1)

	-- Create skill_icon_3
	local skill_icon_3 = GUI:Image_Create(icon_3, "skill_icon_3", 2.00, 2.00, "res/private/internal_win32/00903.png")
	GUI:setChineseName(skill_icon_3, "连击_25%暴击_图标")
	GUI:setTouchEnabled(skill_icon_3, false)
	GUI:setTag(skill_icon_3, -1)

	-- Create icon_4
	local icon_4 = GUI:Image_Create(Panel_1, "icon_4", 196.00, 278.00, "res/private/internal/skill_icon.png")
	GUI:setContentSize(icon_4, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(icon_4, false)
	GUI:setChineseName(icon_4, "连击_自定义配置")
	GUI:setTouchEnabled(icon_4, false)
	GUI:setTag(icon_4, -1)

	-- Create skill_icon_4
	local skill_icon_4 = GUI:Image_Create(icon_4, "skill_icon_4", 2.00, 2.00, "res/private/internal_win32/00905.png")
	GUI:setChineseName(skill_icon_4, "连击_自定义_图标")
	GUI:setTouchEnabled(skill_icon_4, false)
	GUI:setTag(skill_icon_4, -1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_1, "Image_line", 136.00, 264.00, "res/private/internal_win32/line_1.png")
	GUI:setChineseName(Image_line, "连击_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, -1)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 136.00, 16.00, 244.00, 246.00, 1)
	GUI:ListView_setGravity(ListView_cells, 5)
	GUI:setChineseName(ListView_cells, "连击_连击技能列表")
	GUI:setAnchorPoint(ListView_cells, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 190)
end
return ui