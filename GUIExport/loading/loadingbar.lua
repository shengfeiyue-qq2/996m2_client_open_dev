local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 11.0)

	-- Create Image_bar
	local Image_bar = GUI:Image_Create(Scene, "Image_bar", 568.00, 320.00, "res/private/loading/bg_load_1.png")
	GUI:setAnchorPoint(Image_bar, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bar, false)
	GUI:setTag(Image_bar, 10.0)
end
return ui