local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Image_arrow
	local Image_arrow = GUI:Image_Create(Node, "Image_arrow", -17.00, 0.00, "res/private/guide/arrow_guide_1.png")
	GUI:setContentSize(Image_arrow, 33, 29)
	GUI:setIgnoreContentAdaptWithSize(Image_arrow, false)
	GUI:setAnchorPoint(Image_arrow, 0.50, 0.50)
	GUI:setTouchEnabled(Image_arrow, false)
	GUI:setTag(Image_arrow, 25)

	-- Create Image_desc
	local Image_desc = GUI:Image_Create(Node, "Image_desc", -108.72, 0.00, "res/private/guide/btn_guide_1.png")
	GUI:setContentSize(Image_desc, 167, 66)
	GUI:setIgnoreContentAdaptWithSize(Image_desc, false)
	GUI:setAnchorPoint(Image_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Image_desc, false)
	GUI:setTag(Image_desc, 26)

	-- Create Node_desc
	local Node_desc = GUI:Node_Create(Node, "Node_desc", -108.72, 0.00)
	GUI:setAnchorPoint(Node_desc, 0.50, 0.50)
	GUI:setTag(Node_desc, 36)
end
return ui