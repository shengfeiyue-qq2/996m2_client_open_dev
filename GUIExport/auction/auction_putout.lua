local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "拍卖操作场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "拍卖_范围点击关闭区域")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 257)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 355.00, 495.00, false)
	GUI:setChineseName(Panel_2, "拍卖_操作组合框")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 225)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 177.00, 247.00, "res/public/1900000601.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 355, 495)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "拍卖_操作背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 226)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_2, "Text_title", 177.00, 465.00, 18, "#f8e6c6", [[下架道具]])
	GUI:setChineseName(Text_title, "拍卖_下架道具_文本")
	GUI:setAnchorPoint(Text_title, 0.52, 0.37)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 228)
	GUI:Text_enableOutline(Text_title, "#111111", 1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_2, "Image_14", 177.00, 447.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_14, 300, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_14, false)
	GUI:setChineseName(Image_14, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_14, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, 229)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 177.00, 364.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_icon, "拍卖_物品图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 230)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 177.00, 415.00, 16, "#ffffff", [[装备名称七个字]])
	GUI:setChineseName(Text_name, "拍卖_物品名称")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 231)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_1_0_2
	local Text_1_0_2 = GUI:Text_Create(Panel_2, "Text_1_0_2", 110.00, 210.00, 16, "#ffffff", [[竞拍价：]])
	GUI:setChineseName(Text_1_0_2, "拍卖_竞拍价_文本")
	GUI:setAnchorPoint(Text_1_0_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_2, false)
	GUI:setTag(Text_1_0_2, 237)
	GUI:Text_enableOutline(Text_1_0_2, "#000000", 1)

	-- Create Text_1_0_3
	local Text_1_0_3 = GUI:Text_Create(Panel_2, "Text_1_0_3", 111.00, 159.00, 16, "#ffffff", [[一口价：]])
	GUI:setChineseName(Text_1_0_3, "拍卖_一口价_文本")
	GUI:setAnchorPoint(Text_1_0_3, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_3, false)
	GUI:setTag(Text_1_0_3, 238)
	GUI:Text_enableOutline(Text_1_0_3, "#000000", 1)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 93.00, 52.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 15, 11, 11)
	GUI:setContentSize(Button_cancel, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取  消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 18)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "拍卖_取消按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 126)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 262.00, 52.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 11, 11)
	GUI:setContentSize(Button_submit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "下架道具")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 18)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "拍卖_下架道具按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 248)

	-- Create Image_16_0
	local Image_16_0 = GUI:Image_Create(Panel_2, "Image_16_0", 210.00, 159.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0, 188, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0, false)
	GUI:setChineseName(Image_16_0, "拍卖_一口价输入框_图片")
	GUI:setAnchorPoint(Image_16_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0, false)
	GUI:setTag(Image_16_0, 249)

	-- Create Image_16_0_0
	local Image_16_0_0 = GUI:Image_Create(Panel_2, "Image_16_0_0", 210.00, 210.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0_0, 188, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0_0, false)
	GUI:setChineseName(Image_16_0_0, "拍卖_竞拍价输入框_图片")
	GUI:setAnchorPoint(Image_16_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0_0, false)
	GUI:setTag(Image_16_0_0, 250)

	-- Create Node_money_bid
	local Node_money_bid = GUI:Node_Create(Panel_2, "Node_money_bid", 135.00, 210.00)
	GUI:setChineseName(Node_money_bid, "拍卖_竞拍货币_节点")
	GUI:setAnchorPoint(Node_money_bid, 0.50, 0.50)
	GUI:setTag(Node_money_bid, 251)

	-- Create Node_money_buy
	local Node_money_buy = GUI:Node_Create(Panel_2, "Node_money_buy", 135.00, 159.00)
	GUI:setChineseName(Node_money_buy, "拍卖_一口价货币_节点")
	GUI:setAnchorPoint(Node_money_buy, 0.50, 0.50)
	GUI:setTag(Node_money_buy, 252)

	-- Create Text_bid_price
	local Text_bid_price = GUI:Text_Create(Panel_2, "Text_bid_price", 220.00, 210.00, 16, "#ffffff", [[9999]])
	GUI:setChineseName(Text_bid_price, "拍卖_竞拍价价格_文本")
	GUI:setAnchorPoint(Text_bid_price, 0.50, 0.50)
	GUI:setTouchEnabled(Text_bid_price, false)
	GUI:setTag(Text_bid_price, 124)
	GUI:Text_enableOutline(Text_bid_price, "#111111", 1)

	-- Create Text_buy_price
	local Text_buy_price = GUI:Text_Create(Panel_2, "Text_buy_price", 220.00, 159.00, 16, "#ffffff", [[9999]])
	GUI:setChineseName(Text_buy_price, "拍卖_一口价价格_文本")
	GUI:setAnchorPoint(Text_buy_price, 0.50, 0.50)
	GUI:setTouchEnabled(Text_buy_price, false)
	GUI:setTag(Text_buy_price, 127)
	GUI:Text_enableOutline(Text_buy_price, "#111111", 1)

	-- Create Text_remaining
	local Text_remaining = GUI:Text_Create(Panel_2, "Text_remaining", 95.00, 265.00, 16, "#28ef01", [[竞拍中03:20:00]])
	GUI:setChineseName(Text_remaining, "拍卖_竞拍状态倒计时_文本")
	GUI:setAnchorPoint(Text_remaining, 0.50, 0.50)
	GUI:setTouchEnabled(Text_remaining, false)
	GUI:setTag(Text_remaining, 128)
	GUI:Text_enableOutline(Text_remaining, "#111111", 1)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_2, "Text_count", 260.00, 265.00, 16, "#28ef01", [[数量1]])
	GUI:setChineseName(Text_count, "拍卖_数量_文本")
	GUI:setAnchorPoint(Text_count, 0.50, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 129)
	GUI:Text_enableOutline(Text_count, "#111111", 1)

	-- Create Text_status
	local Text_status = GUI:Text_Create(Panel_2, "Text_status", 177.00, 315.00, 16, "#ffffff", [[状态]])
	GUI:setChineseName(Text_status, "拍卖_状态_文本")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, 130)
	GUI:Text_enableOutline(Text_status, "#111111", 1)
end
return ui