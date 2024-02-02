local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 172)

	-- Create Panel_show
	local Panel_show = GUI:Layout_Create(Scene, "Panel_show", 0.00, 200.00, 68.00, 200.00, false)
	GUI:setAnchorPoint(Panel_show, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show, true)
	GUI:setTag(Panel_show, 154)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_show, "Image_2", 0.00, 200.00, "res/public/1900000651_2.png")
	GUI:Image_setScale9Slice(Image_2, 21, 21, 21, 21)
	GUI:setContentSize(Image_2, 68, 200)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.00, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 144)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_show, "ListView_1", 0.00, 200.00, 68.00, 200.00, 1)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:setAnchorPoint(ListView_1, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 155)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Panel_show, "Panel_1", 0.00, 119.42, 68.00, 30.00, false)
	GUI:Layout_setBackGroundColorType(Panel_1, 1)
	GUI:Layout_setBackGroundColor(Panel_1, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_1, 255)
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 145)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 0.00, 30.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_1, 68, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 153)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 33.28, 15.17, 16, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 146)
	GUI:Text_enableOutline(Text_1, "#000000", 1)
end
return ui