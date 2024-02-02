local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 3)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 50.00, 50.00, false)
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 19)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 25.00, 25.00, "res/public/1900000665.png")
	GUI:Image_setScale9Slice(Image_1, 78, 78, 44, 44)
	GUI:setContentSize(Image_1, 238, 136)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 20)

	-- Create Panel_dice
	local Panel_dice = GUI:Layout_Create(Panel_2, "Panel_dice", 25.00, 10.00, 200.00, 30.00, false)
	GUI:setAnchorPoint(Panel_dice, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_dice, true)
	GUI:setTag(Panel_dice, 22)
end
return ui