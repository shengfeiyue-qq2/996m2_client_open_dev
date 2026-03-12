local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setChineseName(Panel_1, "拍卖通用标题组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 293)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 303.00, 355.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "拍卖通用标题_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 298)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_1, "Image_1_0", 303.00, 335.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_0, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setChineseName(Image_1_0, "拍卖通用标题_装饰条")
	GUI:setAnchorPoint(Image_1_0, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 161)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 50.00, 345.00, 12, "#ffffff", [[竞拍道具]])
	GUI:setChineseName(Text_1, "通用标题_竞拍道具_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 218)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_1, "Text_1_0", 250.00, 345.00, 12, "#ffffff", [[剩余时间]])
	GUI:setChineseName(Text_1_0, "通用标题_剩余时间_文本")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 217)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_1, "Text_1_1", 342.00, 345.00, 12, "#ffffff", [[状态]])
	GUI:setChineseName(Text_1_1, "通用标题_状态_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 216)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_1_2
	local Text_1_2 = GUI:Text_Create(Panel_1, "Text_1_2", 484.00, 345.00, 12, "#ffffff", [[价格]])
	GUI:setChineseName(Text_1_2, "通用标题_价格_文本")
	GUI:setAnchorPoint(Text_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2, false)
	GUI:setTag(Text_1_2, 215)
	GUI:Text_enableOutline(Text_1_2, "#000000", 1)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_1, "ListView_items", 304.00, 34.00, 606.00, 300.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setChineseName(ListView_items, "通用标题_商品容器_列表")
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 300)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_1, "Image_empty", 303.00, 177.00, "res/private/auction-win32/word_paimaihang_01.png")
	GUI:setChineseName(Image_empty, "通用标题_无物品上架_图片")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 310)

	-- Create TextMaxTips
	local TextMaxTips = GUI:Text_Create(Panel_1, "TextMaxTips", 460.00, 20.00, 12, "#ffe400", [[我的竞拍只显示100条竞拍]])
	GUI:setChineseName(TextMaxTips, "通用标题_我的竞拍上限提示")
	GUI:setTouchEnabled(TextMaxTips, false)
	GUI:setTag(TextMaxTips, -1)
	GUI:setVisible(TextMaxTips, false)
	GUI:Text_enableOutline(TextMaxTips, "#000000", 1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_1, "Image_line", 0.00, 36.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_line, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setAnchorPoint(Image_line, 0.00, 1.00)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, -1)

	-- Create Panel_btn
	local Panel_btn = GUI:Layout_Create(Panel_1, "Panel_btn", 0.00, 0.00, 606.00, 34.00, false)
	GUI:setTouchEnabled(Panel_btn, false)
	GUI:setTag(Panel_btn, -1)

	-- Create Button_bid
	local Button_bid = GUI:Button_Create(Panel_btn, "Button_bid", 442.00, 0.00, "res/public/1900000653.png")
	GUI:Button_setScale9Slice(Button_bid, 27, 28, 10, 10)
	GUI:setContentSize(Button_bid, 64, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_bid, false)
	GUI:Button_setTitleText(Button_bid, "竞 价")
	GUI:Button_setTitleColor(Button_bid, "#ffffff")
	GUI:Button_setTitleFontSize(Button_bid, 14)
	GUI:Button_titleEnableOutline(Button_bid, "#000000", 1)
	GUI:setTouchEnabled(Button_bid, true)
	GUI:setTag(Button_bid, -1)
	GUI:setVisible(Button_bid, false)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_btn, "Button_buy", 524.00, 0.00, "res/public/1900000652.png")
	GUI:Button_setScale9Slice(Button_buy, 27, 28, 10, 10)
	GUI:setContentSize(Button_buy, 64, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "购 买")
	GUI:Button_setTitleColor(Button_buy, "#ffffff")
	GUI:Button_setTitleFontSize(Button_buy, 14)
	GUI:Button_titleEnableOutline(Button_buy, "#000000", 1)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, -1)
	GUI:setVisible(Button_buy, false)

	-- Create Button_acquire
	local Button_acquire = GUI:Button_Create(Panel_btn, "Button_acquire", 524.00, 0.00, "res/public/1900000652.png")
	GUI:Button_setScale9Slice(Button_acquire, 27, 28, 10, 10)
	GUI:setContentSize(Button_acquire, 64, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_acquire, false)
	GUI:Button_setTitleText(Button_acquire, "领 取")
	GUI:Button_setTitleColor(Button_acquire, "#ffffff")
	GUI:Button_setTitleFontSize(Button_acquire, 14)
	GUI:Button_titleEnableOutline(Button_acquire, "#000000", 1)
	GUI:setTouchEnabled(Button_acquire, true)
	GUI:setTag(Button_acquire, -1)
	GUI:setVisible(Button_acquire, false)
end
return ui