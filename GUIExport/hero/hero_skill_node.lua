local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家技能组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/player_skill/1900015001.png")
	GUI:setContentSize(Image_bg, 348.0, 478.0)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家技能_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 42.0)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 2.00, 3.00, 344.00, 473.00, 1.0)
	GUI:ListView_setGravity(ListView_cells, 5.0)
	GUI:setChineseName(ListView_cells, "玩家技能_技能列表")
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 13.0)
end
return ui