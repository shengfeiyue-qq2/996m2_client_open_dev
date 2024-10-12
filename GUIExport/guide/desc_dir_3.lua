local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Image_arrow
	local Image_arrow = GUI:Image_Create(Node, "Image_arrow", 0.00, 16.00, "res/private/guide/arrow_guide_1.png")
	GUI:setContentSize(Image_arrow, 33, 29)
	GUI:setIgnoreContentAdaptWithSize(Image_arrow, false)
	GUI:setAnchorPoint(Image_arrow, 0.50, 0.50)
	GUI:setRotation(Image_arrow, 90.00)
	GUI:setRotationSkewX(Image_arrow, 90.00)
	GUI:setRotationSkewY(Image_arrow, 90.00)
	GUI:setTouchEnabled(Image_arrow, false)
	GUI:setTag(Image_arrow, 34)

	-- Create Image_desc
	local Image_desc = GUI:Image_Create(Node, "Image_desc", 0.00, 65.00, "res/private/guide/btn_guide_1.png")
	GUI:setContentSize(Image_desc, 167, 66)
	GUI:setIgnoreContentAdaptWithSize(Image_desc, false)
	GUI:setAnchorPoint(Image_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Image_desc, false)
	GUI:setTag(Image_desc, 35)

	-- Create Node_desc
	local Node_desc = GUI:Node_Create(Node, "Node_desc", 0.00, 65.00)
	GUI:setAnchorPoint(Node_desc, 0.50, 0.50)
	GUI:setTag(Node_desc, 38)
end
return ui