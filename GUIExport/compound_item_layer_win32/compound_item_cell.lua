local ui = {}
function ui.init(parent)
	-- Create Panel_icon
	local Panel_icon = GUI:Layout_Create(parent, "Panel_icon", 0.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_icon, false)
	GUI:setTag(Panel_icon, -1)

	-- Create Image_iconBg
	local Image_iconBg = GUI:Image_Create(Panel_icon, "Image_iconBg", 0.00, 0.00, "res/public/1900000651.png")
	GUI:setContentSize(Image_iconBg, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(Image_iconBg, false)
	GUI:setTouchEnabled(Image_iconBg, false)
	GUI:setTag(Image_iconBg, -1)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_icon, "Node_icon", 25.00, 25.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, -1)

	-- Create Text_have
	local Text_have = GUI:Text_Create(Panel_icon, "Text_have", 22.00, 10.00, 13, "#ffffff", [[999]])
	GUI:setAnchorPoint(Text_have, 1.00, 0.50)
	GUI:setTouchEnabled(Text_have, false)
	GUI:setTag(Text_have, -1)
	GUI:setVisible(Text_have, false)
	GUI:Text_enableOutline(Text_have, "#000000", 1)

	-- Create Text_need
	local Text_need = GUI:Text_Create(Panel_icon, "Text_need", 48.00, 10.00, 13, "#ffffff", [[/999]])
	GUI:setAnchorPoint(Text_need, 1.00, 0.50)
	GUI:setTouchEnabled(Text_need, false)
	GUI:setTag(Text_need, -1)
	GUI:setVisible(Text_need, false)
	GUI:Text_enableOutline(Text_need, "#000000", 1)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_icon, "Text_count", 48.00, 10.00, 13, "#ffffff", [[999]])
	GUI:setAnchorPoint(Text_count, 1.00, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, -1)
	GUI:setVisible(Text_count, false)
	GUI:Text_enableOutline(Text_count, "#000000", 1)
end
return ui