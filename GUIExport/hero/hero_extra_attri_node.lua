local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家其他属性组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 39.0)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 174.00, 239.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_1, 348.0, 478.0)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "玩家其他属性_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 244.0)
	GUI:setVisible(Image_1, false)

	-- Create ListView_extraAtt
	local ListView_extraAtt = GUI:ListView_Create(Panel_1, "ListView_extraAtt", 4.00, 4.00, 340.00, 470.00, 1.0)
	GUI:ListView_setGravity(ListView_extraAtt, 5.0)
	GUI:setChineseName(ListView_extraAtt, "玩家其他属性_列表")
	GUI:setTouchEnabled(ListView_extraAtt, true)
	GUI:setTag(ListView_extraAtt, 111.0)
end
return ui