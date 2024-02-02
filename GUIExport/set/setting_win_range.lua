local ui = {}
function ui.init(parent)
	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_bg, "内挂视距组合")
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 366.00, 278.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_bg, 33, 33, 9, 9)
	GUI:setContentSize(Image_bg, 686, 300)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "内挂视距_背景框1")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_bg, "ListView_1", 0.00, 0.00, 686.00, 300.00, 1)
	GUI:ListView_setGravity(ListView_1, 0)
	GUI:setChineseName(ListView_1, "内挂视距_列表")
	GUI:setTouchEnabled(ListView_1, false)
	GUI:setTag(ListView_1, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_bg, "Image_2", 366.00, 63.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
	GUI:setContentSize(Image_2, 686, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setChineseName(Image_2, "内挂视距_背景框2")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)
end
return ui