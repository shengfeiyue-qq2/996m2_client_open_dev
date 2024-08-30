local ui = {}
function ui.init(parent)
	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(parent, "Panel_item", 0.00, 0.00, 244.00, 140.00, false)
	GUI:setChineseName(Panel_item, "商店物品组合")
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 65)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_item, "Image_bg", 122.00, 70.00, "res/public/1900000665.png")
	GUI:setChineseName(Image_bg, "商店物品_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 66)

	-- Create Image_tag
	local Image_tag = GUI:Image_Create(Panel_item, "Image_tag", 35.00, 115.00, "res/private/page_store_ui/page_store_ui_mobile/1900020100.png")
	GUI:setChineseName(Image_tag, "商店物品_售卖状态_图片")
	GUI:setAnchorPoint(Image_tag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag, false)
	GUI:setTag(Image_tag, 37)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(Panel_item, "Text_itemName", 120.00, 115.00, 18, "#f2e7ce", [[金条]])
	GUI:setChineseName(Text_itemName, "商店物品_标题_文本")
	GUI:setAnchorPoint(Text_itemName, 0.50, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 67)
	GUI:Text_enableOutline(Text_itemName, "#111111", 2)

	-- Create Image_iconBg
	local Image_iconBg = GUI:Image_Create(Panel_item, "Image_iconBg", 50.00, 55.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_iconBg, "商店物品_背景图标")
	GUI:setAnchorPoint(Image_iconBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_iconBg, false)
	GUI:setTag(Image_iconBg, 68)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_item, "Node_icon", 51.00, 55.00)
	GUI:setChineseName(Node_icon, "商店物品_图标节点")
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 69)

	-- Create Panel_limit
	local Panel_limit = GUI:Layout_Create(Panel_item, "Panel_limit", 88.00, 74.00, 140.00, 30.00, false)
	GUI:setAnchorPoint(Panel_limit, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_limit, false)
	GUI:setTag(Panel_limit, -1)

	-- Create Text_info
	local Text_info = GUI:Text_Create(Panel_limit, "Text_info", 0.00, 16.00, 16, "#f2e7ce", [[限时：]])
	GUI:setAnchorPoint(Text_info, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info, false)
	GUI:setTag(Text_info, -1)
	GUI:Text_enableOutline(Text_info, "#000000", 1)

	-- Create Panel_price
	local Panel_price = GUI:Layout_Create(Panel_item, "Panel_price", 88.00, 74.00, 140.00, 30.00, false)
	GUI:setAnchorPoint(Panel_price, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_price, false)
	GUI:setTag(Panel_price, -1)

	-- Create Text_info
	local Text_info = GUI:Text_Create(Panel_price, "Text_info", 0.00, 16.00, 16, "#28ef01", [[原价：]])
	GUI:setAnchorPoint(Text_info, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info, false)
	GUI:setTag(Text_info, -1)
	GUI:Text_enableOutline(Text_info, "#000000", 1)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_price, "Node_icon", 60.00, 16.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setScaleX(Node_icon, 0.50)
	GUI:setScaleY(Node_icon, 0.50)
	GUI:setTag(Node_icon, 71)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Panel_price, "Node_count", 80.00, 16.00)
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 71)

	-- Create Panel_nowPrice
	local Panel_nowPrice = GUI:Layout_Create(Panel_item, "Panel_nowPrice", 88.00, 34.00, 140.00, 30.00, false)
	GUI:setAnchorPoint(Panel_nowPrice, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_nowPrice, false)
	GUI:setTag(Panel_nowPrice, -1)

	-- Create Text_info
	local Text_info = GUI:Text_Create(Panel_nowPrice, "Text_info", 0.00, 16.00, 16, "#28ef01", [[现价：]])
	GUI:setAnchorPoint(Text_info, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info, false)
	GUI:setTag(Text_info, -1)
	GUI:Text_enableOutline(Text_info, "#000000", 1)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_nowPrice, "Node_icon", 60.00, 16.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setScaleX(Node_icon, 0.50)
	GUI:setScaleY(Node_icon, 0.50)
	GUI:setTag(Node_icon, 71)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Panel_nowPrice, "Node_count", 80.00, 16.00)
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 71)
end
return ui