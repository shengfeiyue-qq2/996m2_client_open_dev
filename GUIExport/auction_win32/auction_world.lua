local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setChineseName(Panel_1, "拍卖操作组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 325)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 303.00, 355.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 329)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_1, "Image_1_0", 102.00, 35.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_0, 320, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setChineseName(Image_1_0, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_1_0, 1.00, 1.00)
	GUI:setRotation(Image_1_0, 90.00)
	GUI:setRotationSkewX(Image_1_0, 90.00)
	GUI:setRotationSkewY(Image_1_0, 90.00)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 97)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 102.00, 336.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_1, 504, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setChineseName(Image_1_1, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_1_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 98)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 303.00, 35.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_2, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_2, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setChineseName(Image_1_2, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_1_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 99)

	-- Create Panel_filter_1
	local Panel_filter_1 = GUI:Layout_Create(Panel_1, "Panel_filter_1", 0.00, 35.00, 100.00, 320.00, false)
	GUI:setChineseName(Panel_filter_1, "拍卖_左侧类型分组")
	GUI:setTouchEnabled(Panel_filter_1, true)
	GUI:setTag(Panel_filter_1, 326)

	-- Create ListView_filter_1
	local ListView_filter_1 = GUI:ListView_Create(Panel_filter_1, "ListView_filter_1", 50.00, 318.00, 100.00, 318.00, 1)
	GUI:ListView_setGravity(ListView_filter_1, 5)
	GUI:setChineseName(ListView_filter_1, "拍卖_左侧类型")
	GUI:setAnchorPoint(ListView_filter_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_filter_1, true)
	GUI:setTag(ListView_filter_1, 327)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 606.00, 355.00, 505.00, 320.00, false)
	GUI:setChineseName(Panel_items, "拍卖_物品详细分组")
	GUI:setAnchorPoint(Panel_items, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_items, false)
	GUI:setTag(Panel_items, 328)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_items, "Text_1", 50.00, 310.00, 12, "#ffffff", [[竞拍道具]])
	GUI:setChineseName(Text_1, "拍卖_竞拍道具_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 100)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_items, "Text_1_0", 200.00, 310.00, 12, "#ffffff", [[剩余时间]])
	GUI:setChineseName(Text_1_0, "拍卖_剩余时间_文本")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 101)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_items, "Text_1_1", 350.00, 310.00, 12, "#ffffff", [[竞拍价格]])
	GUI:setChineseName(Text_1_1, "拍卖_竞拍价格_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 102)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_1_2
	local Text_1_2 = GUI:Text_Create(Panel_items, "Text_1_2", 450.00, 310.00, 12, "#ffffff", [[一口价]])
	GUI:setChineseName(Text_1_2, "拍卖_一口价_文本")
	GUI:setAnchorPoint(Text_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2, false)
	GUI:setTag(Text_1_2, 103)
	GUI:Text_enableOutline(Text_1_2, "#000000", 1)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_items, "ListView_items", 252.00, 0.00, 505.00, 299.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setChineseName(ListView_items, "拍卖_物品详情")
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 334)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_items, "Image_empty", 252.00, 150.00, "res/private/auction-win32/word_paimaihang_01.png")
	GUI:setChineseName(Image_empty, "拍卖_无商品_图片")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 345)

	-- Create Panel_filter_2
	local Panel_filter_2 = GUI:Layout_Create(Panel_1, "Panel_filter_2", 606.00, 0.00, 606.00, 35.00, false)
	GUI:setChineseName(Panel_filter_2, "拍卖_筛选组合")
	GUI:setAnchorPoint(Panel_filter_2, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_filter_2, true)
	GUI:setTag(Panel_filter_2, 360)

	-- Create Node_filter_job
	local Node_filter_job = GUI:Node_Create(Panel_filter_2, "Node_filter_job", 230.00, 15.00)
	GUI:setChineseName(Node_filter_job, "拍卖_筛选职业_节点")
	GUI:setAnchorPoint(Node_filter_job, 0.50, 0.50)
	GUI:setTag(Node_filter_job, 386)

	-- Create Node_filter_quality
	local Node_filter_quality = GUI:Node_Create(Panel_filter_2, "Node_filter_quality", 330.00, 15.00)
	GUI:setChineseName(Node_filter_quality, "拍卖_筛选品质_节点")
	GUI:setAnchorPoint(Node_filter_quality, 0.50, 0.50)
	GUI:setTag(Node_filter_quality, 387)

	-- Create Node_filter_money
	local Node_filter_money = GUI:Node_Create(Panel_filter_2, "Node_filter_money", 430.00, 15.00)
	GUI:setChineseName(Node_filter_money, "拍卖_筛选货币_节点")
	GUI:setAnchorPoint(Node_filter_money, 0.50, 0.50)
	GUI:setTag(Node_filter_money, 108)

	-- Create Node_filter_price
	local Node_filter_price = GUI:Node_Create(Panel_filter_2, "Node_filter_price", 530.00, 15.00)
	GUI:setChineseName(Node_filter_price, "拍卖_筛选价格_节点")
	GUI:setAnchorPoint(Node_filter_price, 0.50, 0.50)
	GUI:setTag(Node_filter_price, 107)

	-- Create Panel_hide_filter
	local Panel_hide_filter = GUI:Layout_Create(Panel_filter_2, "Panel_hide_filter", 0.00, 0.00, 732.00, 410.00, false)
	GUI:setChineseName(Panel_hide_filter, "拍卖_隐藏筛选")
	GUI:setTouchEnabled(Panel_hide_filter, true)
	GUI:setTag(Panel_hide_filter, 45)

	-- Create Image_filter_bg
	local Image_filter_bg = GUI:Image_Create(Panel_filter_2, "Image_filter_bg", 233.00, 35.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_filter_bg, 21, 21, 39, 27)
	GUI:setContentSize(Image_filter_bg, 96, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_filter_bg, false)
	GUI:setChineseName(Image_filter_bg, "拍卖_悬浮描述组合")
	GUI:setAnchorPoint(Image_filter_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Image_filter_bg, false)
	GUI:setTag(Image_filter_bg, 30)

	-- Create ListView_filter_3
	local ListView_filter_3 = GUI:ListView_Create(Image_filter_bg, "ListView_filter_3", 48.00, 2.00, 90.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_filter_3, 5)
	GUI:setChineseName(ListView_filter_3, "拍卖_悬浮描述")
	GUI:setAnchorPoint(ListView_filter_3, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter_3, true)
	GUI:setTag(ListView_filter_3, 46)
end
return ui