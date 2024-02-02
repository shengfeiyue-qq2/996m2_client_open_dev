local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 200.00, 80.00, 80.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 22)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 40.00, 48.00, "res/private/main/collect/btn_xbzy_03.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 24)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 40.00, 48.00, "res/private/main/collect/bg_xbzy_02.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 25)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 40.00, 0.00, "res/private/main/collect/bg_xbzy_01.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 27)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 40.00, 10.00, 16, "#ffffff", [[采集]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 26)
	GUI:Text_enableOutline(Text_1, "#000000", 1)
end
return ui