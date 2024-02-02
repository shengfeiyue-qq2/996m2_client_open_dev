local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 441)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Scene, "Image_bg", 0.00, 420.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 8, 8)
	GUI:setContentSize(Image_bg, 269, 179)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 438)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_bg, "ListView_1", 4.00, 175.00, 260.00, 171.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setAnchorPoint(ListView_1, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 439)

end
return ui