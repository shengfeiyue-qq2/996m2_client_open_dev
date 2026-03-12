local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 150.00, 300.00, 730.00, 85.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_1, 0, 0, 0, 0)
	GUI:setChineseName(Panel_1, "竞拍_组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 219)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 365.00, 0.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_8, 730, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_8, false)
	GUI:setChineseName(Image_8, "竞拍_分割条_图片")
	GUI:setAnchorPoint(Image_8, 0.50, 0.00)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 220)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_1, "Image_select", 0.00, 0.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_select, 43, 43, 11, 10)
	GUI:setContentSize(Image_select, 730, 84)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_1, "Image_item", 60.00, 42.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_item, "竞拍_物品框")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 221)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 100.00, 55.00, 16, "#ffffff", [[装备名装备]])
	GUI:setChineseName(Text_name, "竞拍_装备名字_文本")
	GUI:setAnchorPoint(Text_name, 0.00, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 222)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_1, "Text_remaining", 275.00, 42.00, 16, "#ffffff", [[00:00:00]])
	GUI:setChineseName(Text_remaining, "竞拍_拍卖时间")
	GUI:setAnchorPoint(Text_remaining, 0.50, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 223)
	GUI:Text_enableOutline(Text_remaining, "#111111", 1)

	-- Create Text_title_1
	local Text_title_1 = GUI:Text_Create(Panel_1, "Text_title_1", 564.00, 52.00, 16, "#ffffff", [[竞拍价：]])
	GUI:setAnchorPoint(Text_title_1, 1.00, 0.00)
	GUI:setTouchEnabled(Text_title_1, false)
	GUI:setTag(Text_title_1, -1)
	GUI:Text_enableOutline(Text_title_1, "#000000", 1)

	-- Create Text_title_2
	local Text_title_2 = GUI:Text_Create(Panel_1, "Text_title_2", 564.00, 14.00, 16, "#ffffff", [[一口价：]])
	GUI:setAnchorPoint(Text_title_2, 1.00, 0.00)
	GUI:setTouchEnabled(Text_title_2, false)
	GUI:setTag(Text_title_2, -1)
	GUI:Text_enableOutline(Text_title_2, "#000000", 1)

	-- Create Node_bid_price
	local Node_bid_price = GUI:Node_Create(Panel_1, "Node_bid_price", 563.00, 60.00)
	GUI:setChineseName(Node_bid_price, "竞拍_竞价_货币节点")
	GUI:setAnchorPoint(Node_bid_price, 0.50, 0.50)
	GUI:setTag(Node_bid_price, 224)

	-- Create Text_status
	local Text_status = GUI:Text_Create(Panel_1, "Text_status", 404.00, 44.00, 16, "#28ef01", [[竞价被超过]])
	GUI:setChineseName(Text_status, "竞拍_竞价被超过_文本")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, 225)
	GUI:Text_enableOutline(Text_status, "#111111", 1)

	-- Create Text_unable_buy
	local Text_unable_buy = GUI:Text_Create(Panel_1, "Text_unable_buy", 600.00, 24.00, 16, "#ff0500", [[无法一口价]])
	GUI:setChineseName(Text_unable_buy, "竞拍_一口价_文本")
	GUI:setAnchorPoint(Text_unable_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Text_unable_buy, false)
	GUI:setTag(Text_unable_buy, 228)
	GUI:Text_enableOutline(Text_unable_buy, "#111111", 1)

	-- Create Node_price
	local Node_price = GUI:Node_Create(Panel_1, "Node_price", 562.00, 24.00)
	GUI:setChineseName(Node_price, "竞拍_一口价_货币")
	GUI:setAnchorPoint(Node_price, 0.50, 0.50)
	GUI:setTag(Node_price, 229)

	-- Create Text_acquire
	local Text_acquire = GUI:Text_Create(Panel_1, "Text_acquire", 404.00, 44.00, 16, "#28ef01", [[竞拍成功]])
	GUI:setChineseName(Text_acquire, "竞拍_竞拍成功_文本")
	GUI:setAnchorPoint(Text_acquire, 0.50, 0.50)
	GUI:setTouchEnabled(Text_acquire, false)
	GUI:setTag(Text_acquire, 58)
	GUI:Text_enableOutline(Text_acquire, "#111111", 1)
end
return ui