local ui = {}
function ui.init(parent)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0, 0, 606, 390, false)
	GUI:setTouchEnabled(Panel_1, true)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 104.00, 380.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 180, 258)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_1, "ListView_1", 0.00, 2.00, 180.00, 254.00, 1)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:setTouchEnabled(ListView_1, true)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 302, 380, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
	GUI:setContentSize(Image_2, 180, 258)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_2, false)

	-- Create ListView_1
	local ListView_2 = GUI:ListView_Create(Image_2, "ListView_2", 0.00, 2.00, 180.00, 254.00, 1)
	GUI:ListView_setGravity(ListView_2, 2)
	GUI:setTouchEnabled(ListView_2, true)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 501.00, 380.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_3, 33, 33, 9, 9)
	GUI:setContentSize(Image_3, 180, 258)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setAnchorPoint(Image_3, 0.50, 1.00)
	GUI:setTouchEnabled(Image_3, false)

	-- Create ListView_1
	local ListView_3 = GUI:ListView_Create(Image_3, "ListView_3", 0.00, 2.00, 180.00, 254.00, 1)
	GUI:ListView_setGravity(ListView_3, 2)
	GUI:setTouchEnabled(ListView_3, true)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_1, "Image_4", 14.00, 112.60, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_4, 33, 33, 9, 9)
	GUI:setContentSize(Image_4, 577, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setAnchorPoint(Image_4, 0.00, 1.00)
	GUI:setTouchEnabled(Image_4, false)

	-- Create ListView_1
	local ListView_4 = GUI:ListView_Create(Image_4, "ListView_4", 0.00, 0.00, 577.00, 100.00, 2)
	GUI:ListView_setGravity(ListView_4, 5)
	GUI:setTouchEnabled(ListView_4, false)
end
return ui