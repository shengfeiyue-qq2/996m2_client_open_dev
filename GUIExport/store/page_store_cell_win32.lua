local ui = {}
function ui.init(parent)
	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(parent, "Panel_item", 0.00, 0.00, 202.00, 120.00, false)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 25)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_item, "Image_bg", 98.00, 58.00, "res/public_win32/1900000665.png")
	GUI:setContentSize(Image_bg, 202, 120)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 26)

	-- Create Image_tag
	local Image_tag = GUI:Image_Create(Panel_item, "Image_tag", 30.00, 95.00, "res/private/page_store_ui/page_store_ui_mobile/1900020100.png")
	GUI:setAnchorPoint(Image_tag, 0.50, 0.50)
	GUI:setScaleX(Image_tag, 0.80)
	GUI:setScaleY(Image_tag, 0.80)
	GUI:setTouchEnabled(Image_tag, false)
	GUI:setTag(Image_tag, 38)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(Panel_item, "Text_itemName", 100.00, 95.00, 18, "#f2e7ce", [[金条]])
	GUI:setAnchorPoint(Text_itemName, 0.50, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 27)
	GUI:Text_enableOutline(Text_itemName, "#111111", 2)

	-- Create Image_iconBg
	local Image_iconBg = GUI:Image_Create(Panel_item, "Image_iconBg", 46.00, 44.00, "res/public_win32/1900000664.png")
	GUI:setAnchorPoint(Image_iconBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_iconBg, false)
	GUI:setTag(Image_iconBg, 28)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_item, "Node_icon", 46.00, 44.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 29)

	-- Create Node_priceNow
	local Node_priceNow = GUI:Node_Create(Panel_item, "Node_priceNow", 85.00, 61.00)
	GUI:setAnchorPoint(Node_priceNow, 0.50, 0.50)
	GUI:setTag(Node_priceNow, 30)

	-- Create Node_price
	local Node_price = GUI:Node_Create(Panel_item, "Node_price", 85.00, 27.00)
	GUI:setAnchorPoint(Node_price, 0.50, 0.50)
	GUI:setTag(Node_price, 31)

	-- Create Text_condition
	local Text_condition = GUI:Text_Create(Panel_item, "Text_condition", 83.00, 61.00, 12, "#f2e7ce", [[]])
	GUI:setAnchorPoint(Text_condition, 0.00, 0.50)
	GUI:setTouchEnabled(Text_condition, false)
	GUI:setTag(Text_condition, 32)
	GUI:Text_enableOutline(Text_condition, "#111111", 2)
end
return ui