local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 186.00, 59.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 46.0)

	-- Create Image_arrow
	local Image_arrow = GUI:Image_Create(Panel_1, "Image_arrow", 14.69, 29.14, "res/private/guide/arrow_guide_1.png")
	GUI:setContentSize(Image_arrow, 33.0, 29.0)
	GUI:setIgnoreContentAdaptWithSize(Image_arrow, false)
	GUI:setAnchorPoint(Image_arrow, 0.50, 0.50)
	GUI:setRotation(Image_arrow, 180.00)
	GUI:setRotationSkewX(Image_arrow, 180.00)
	GUI:setRotationSkewY(Image_arrow, 180.00)
	GUI:setTouchEnabled(Image_arrow, false)
	GUI:setTag(Image_arrow, 46.0)

	-- Create Image_desc
	local Image_desc = GUI:Image_Create(Panel_1, "Image_desc", 108.22, 29.14, "res/private/guide/btn_guide_1.png")
	GUI:setContentSize(Image_desc, 167.0, 66.0)
	GUI:setIgnoreContentAdaptWithSize(Image_desc, false)
	GUI:setAnchorPoint(Image_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Image_desc, false)
	GUI:setTag(Image_desc, 45.0)

	-- Create Node_desc
	local Node_desc = GUI:Node_Create(Panel_1, "Node_desc", 108.22, 29.14)
	GUI:setAnchorPoint(Node_desc, 0.50, 0.50)
	GUI:setTag(Node_desc, 44.0)
end
return ui