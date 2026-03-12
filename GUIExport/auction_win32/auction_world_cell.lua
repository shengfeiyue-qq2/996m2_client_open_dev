local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 150.00, 300.00, 505.00, 70.00, false)
	GUI:setChineseName(Panel_1, "拍卖_组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 136)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 252.00, 0.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_3, 505, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 187)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_1, "Image_select", 0.00, 0.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_select, 43, 43, 11, 10)
	GUI:setContentSize(Image_select, 504, 70)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_1, "Image_item", 40.00, 35.00, "res/public_win32/1900000664.png")
	GUI:setChineseName(Image_item, "拍卖_物品框")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 138)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 70.00, 40.00, 12, "#28ef01", [[装备名名名名]])
	GUI:setChineseName(Text_name, "拍卖_装备名称")
	GUI:setAnchorPoint(Text_name, 0.00, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 139)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_tstatus
	local Text_tstatus = GUI:Text_Create(Panel_1, "Text_tstatus", 200.00, 55.00, 12, "#ffff0f", [[即将开拍]])
	GUI:setChineseName(Text_tstatus, "拍卖_拍卖状态")
	GUI:setAnchorPoint(Text_tstatus, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tstatus, false)
	GUI:setTag(Text_tstatus, 140)
	GUI:Text_enableOutline(Text_tstatus, "#111111", 1)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_1, "Text_remaining", 200.00, 35.00, 12, "#ffffff", [[00:00:00]])
	GUI:setChineseName(Text_remaining, "拍卖_倒计时_文本")
	GUI:setAnchorPoint(Text_remaining, 0.50, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 141)
	GUI:Text_enableOutline(Text_remaining, "#111111", 1)

	-- Create Text_title_1
	local Text_title_1 = GUI:Text_Create(Panel_1, "Text_title_1", 382.00, 48.00, 12, "#ffffff", [[竞拍价：]])
	GUI:setChineseName(Text_title_1, "拍卖_价格标题1")
	GUI:setAnchorPoint(Text_title_1, 1.00, 0.50)
	GUI:setTouchEnabled(Text_title_1, false)
	GUI:setTag(Text_title_1, 146)
	GUI:Text_enableOutline(Text_title_1, "#111111", 1)

	-- Create Text_title_2
	local Text_title_2 = GUI:Text_Create(Panel_1, "Text_title_2", 382.00, 22.00, 12, "#ffffff", [[一口价：]])
	GUI:setChineseName(Text_title_2, "拍卖_价格标题2")
	GUI:setAnchorPoint(Text_title_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text_title_2, false)
	GUI:setTag(Text_title_2, 146)
	GUI:Text_enableOutline(Text_title_2, "#111111", 1)

	-- Create Node_bid_price
	local Node_bid_price = GUI:Node_Create(Panel_1, "Node_bid_price", 382.00, 48.00)
	GUI:setChineseName(Node_bid_price, "拍卖_货币_节点")
	GUI:setAnchorPoint(Node_bid_price, 0.50, 0.50)
	GUI:setTag(Node_bid_price, 142)

	-- Create Text_status
	local Text_status = GUI:Text_Create(Panel_1, "Text_status", 272.00, 36.00, 12, "#ffff0f", [[竞价被超过]])
	GUI:setChineseName(Text_status, "拍卖_竞价状态")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, 143)
	GUI:Text_enableOutline(Text_status, "#111111", 1)

	-- Create Text_unable_buy
	local Text_unable_buy = GUI:Text_Create(Panel_1, "Text_unable_buy", 414.00, 22.00, 12, "#ffffff", [[无法一口价]])
	GUI:setChineseName(Text_unable_buy, "拍卖_购买条件")
	GUI:setAnchorPoint(Text_unable_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Text_unable_buy, false)
	GUI:setTag(Text_unable_buy, 146)
	GUI:Text_enableOutline(Text_unable_buy, "#111111", 1)

	-- Create Text_me
	local Text_me = GUI:Text_Create(Panel_1, "Text_me", 70.00, 55.00, 12, "#ffff0f", [[我的拍品]])
	GUI:setChineseName(Text_me, "拍卖_我的拍品_文本")
	GUI:setAnchorPoint(Text_me, 0.00, 0.50)
	GUI:setTouchEnabled(Text_me, false)
	GUI:setTag(Text_me, 147)
	GUI:Text_enableOutline(Text_me, "#111111", 1)

	-- Create Node_price
	local Node_price = GUI:Node_Create(Panel_1, "Node_price", 382.00, 22.00)
	GUI:setChineseName(Node_price, "拍卖_一口价货币_节点")
	GUI:setAnchorPoint(Node_price, 0.50, 0.50)
	GUI:setTag(Node_price, 148)

	-- Create Text_rebate
	local Text_rebate = GUI:Text_Create(Panel_1, "Text_rebate", 502.00, 60.00, 12, "#ffff0f", [[9折]])
	GUI:setChineseName(Text_rebate, "拍卖_折扣_文本")
	GUI:setAnchorPoint(Text_rebate, 1.00, 0.50)
	GUI:setTouchEnabled(Text_rebate, false)
	GUI:setTag(Text_rebate, 183)
	GUI:Text_enableOutline(Text_rebate, "#111111", 1)
end
return ui