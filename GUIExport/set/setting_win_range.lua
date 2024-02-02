setting_win_range = {}
function setting_win_range.init(parent)
	local Panel_1 = GUI:Layout_Create(parent, "Panel_bg", 0, 0, 732, 445, false)
	GUI:setTouchEnabled(Panel_1, true)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_bg", 366.00, 278.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 686, 300)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)


	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_1, "ListView_1", 0.00, 0.00, 686.00, 300.00, 1)
	GUI:ListView_setGravity(ListView_1, 0)
	GUI:setTouchEnabled(ListView_1, false)


	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 366.00, 63.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
	GUI:setContentSize(Image_2, 686, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)

end
return setting_win_range