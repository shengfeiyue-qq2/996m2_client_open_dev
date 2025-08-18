local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家基本属性组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 37)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 174.00, 239.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_1, 348, 478)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "玩家基本属性_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 232)
	GUI:setVisible(Image_1, false)

	-- Create ListView_base
	local ListView_base = GUI:ListView_Create(Panel_1, "ListView_base", 4.00, 4.00, 340.00, 470.00, 1)
	GUI:ListView_setGravity(ListView_base, 5)
	GUI:setChineseName(ListView_base, "玩家基本属性_列表")
	GUI:setTouchEnabled(ListView_base, true)
	GUI:setTag(ListView_base, 109)
end
return ui