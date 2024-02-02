local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 177.00, 39.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 39)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 88.00, 3.00, "res/private/compound_items_ui/1900000667.png")
	GUI:setContentSize(Image_bg, 174, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 41)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 86.00, 20.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 42)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Image_tag
	local Image_tag = GUI:Image_Create(Panel_1, "Image_tag", 88.00, 23.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_tag, 160, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_tag, false)
	GUI:setAnchorPoint(Image_tag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag, false)
	GUI:setTag(Image_tag, 43)
	GUI:setVisible(Image_tag, false)

	-- Create Image_red
	local Image_red = GUI:Image_Create(Panel_1, "Image_red", 166.00, 29.00, "res/public/btn_npcfh_04.png")
	GUI:setAnchorPoint(Image_red, 0.50, 0.50)
	GUI:setTouchEnabled(Image_red, false)
	GUI:setTag(Image_red, 45)
	GUI:setVisible(Image_red, false)
end
return ui