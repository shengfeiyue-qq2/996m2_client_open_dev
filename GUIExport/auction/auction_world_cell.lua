local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 150.00, 302.00, 605.00, 85.00, false)
	GUI:setChineseName(Panel_1, "拍卖_组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 136)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 302.00, 0.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_3, 605, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 187)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_1, "Image_item", 41.00, 42.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_item, "拍卖_物品框")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 138)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 80.00, 55.00, 16, "#28ef01", [[装备名名名名]])
	GUI:setChineseName(Text_name, "拍卖_装备名称")
	GUI:setAnchorPoint(Text_name, 0.00, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 139)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_tstatus
	local Text_tstatus = GUI:Text_Create(Panel_1, "Text_tstatus", 225.00, 70.00, 16, "#ffff0f", [[即将开拍]])
	GUI:setChineseName(Text_tstatus, "拍卖_拍卖状态")
	GUI:setAnchorPoint(Text_tstatus, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tstatus, false)
	GUI:setTag(Text_tstatus, 140)
	GUI:Text_enableOutline(Text_tstatus, "#111111", 1)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_1, "Text_remaining", 225.00, 43.00, 16, "#ffffff", [[00:00:00]])
	GUI:setChineseName(Text_remaining, "拍卖_倒计时_文本")
	GUI:setAnchorPoint(Text_remaining, 0.50, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 141)
	GUI:Text_enableOutline(Text_remaining, "#111111", 1)

	-- Create Node_bid_price
	local Node_bid_price = GUI:Node_Create(Panel_1, "Node_bid_price", 380.00, 42.00)
	GUI:setChineseName(Node_bid_price, "拍卖_货币_节点")
	GUI:setAnchorPoint(Node_bid_price, 0.50, 0.50)
	GUI:setTag(Node_bid_price, 142)

	-- Create Text_status
	local Text_status = GUI:Text_Create(Panel_1, "Text_status", 377.00, 70.00, 16, "#ffff0f", [[竞价被超过]])
	GUI:setChineseName(Text_status, "拍卖_竞价状态")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, 143)
	GUI:Text_enableOutline(Text_status, "#111111", 1)

	-- Create Button_bid
	local Button_bid = GUI:Button_Create(Panel_1, "Button_bid", 417.00, 42.00, "res/public/1900000652.png")
	GUI:Button_setScale9Slice(Button_bid, 15, 15, 12, 10)
	GUI:setContentSize(Button_bid, 65, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_bid, false)
	GUI:Button_setTitleText(Button_bid, "")
	GUI:Button_setTitleColor(Button_bid, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_bid, 16)
	GUI:Button_titleEnableOutline(Button_bid, "#111111", 2)
	GUI:setChineseName(Button_bid, "拍卖_竞价按钮")
	GUI:setAnchorPoint(Button_bid, 0.50, 0.50)
	GUI:setTouchEnabled(Button_bid, true)
	GUI:setTag(Button_bid, 144)

	-- Create Text
	local Text = GUI:Text_Create(Button_bid, "Text", 33.00, 15.00, 16, "#f8e6c6", [[竞 价]])
	GUI:setChineseName(Text, "拍卖_竞价_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#111111", 2)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_1, "Button_buy", 565.00, 42.00, "res/public/1900000652.png")
	GUI:Button_setScale9Slice(Button_buy, 15, 15, 12, 10)
	GUI:setContentSize(Button_buy, 65, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "")
	GUI:Button_setTitleColor(Button_buy, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_buy, 12)
	GUI:Button_titleEnableOutline(Button_buy, "#111111", 2)
	GUI:setChineseName(Button_buy, "拍卖_一口价按钮")
	GUI:setAnchorPoint(Button_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, 145)

	-- Create Text
	local Text = GUI:Text_Create(Button_buy, "Text", 33.00, 15.00, 16, "#f8e6c6", [[购 买]])
	GUI:setChineseName(Text, "拍卖_购买_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#111111", 2)

	-- Create Text_unable_buy
	local Text_unable_buy = GUI:Text_Create(Panel_1, "Text_unable_buy", 513.00, 42.00, 16, "#ffffff", [[无法一口价]])
	GUI:setChineseName(Text_unable_buy, "拍卖_购买条件")
	GUI:setAnchorPoint(Text_unable_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Text_unable_buy, false)
	GUI:setTag(Text_unable_buy, 146)
	GUI:Text_enableOutline(Text_unable_buy, "#111111", 1)

	-- Create Text_me
	local Text_me = GUI:Text_Create(Panel_1, "Text_me", 114.00, 70.00, 16, "#ffff0f", [[我的拍品]])
	GUI:setChineseName(Text_me, "拍卖_我的拍品_文本")
	GUI:setAnchorPoint(Text_me, 0.50, 0.50)
	GUI:setTouchEnabled(Text_me, false)
	GUI:setTag(Text_me, 147)
	GUI:Text_enableOutline(Text_me, "#111111", 1)

	-- Create Node_price
	local Node_price = GUI:Node_Create(Panel_1, "Node_price", 530.00, 42.00)
	GUI:setChineseName(Node_price, "拍卖_一口价货币_节点")
	GUI:setAnchorPoint(Node_price, 0.50, 0.50)
	GUI:setTag(Node_price, 148)

	-- Create Text_rebate
	local Text_rebate = GUI:Text_Create(Panel_1, "Text_rebate", 570.00, 75.00, 16, "#ffff0f", [[9折]])
	GUI:setChineseName(Text_rebate, "拍卖_折扣_文本")
	GUI:setAnchorPoint(Text_rebate, 0.00, 0.50)
	GUI:setTouchEnabled(Text_rebate, false)
	GUI:setTag(Text_rebate, 183)
	GUI:Text_enableOutline(Text_rebate, "#111111", 1)
end
return ui