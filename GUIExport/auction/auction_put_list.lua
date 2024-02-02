local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 732.00, 410.00, false)
	GUI:setChineseName(Panel_1, "寄售_组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 261)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 366.00, 408.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1_1, "拍卖行_装饰条_图片")
	GUI:setAnchorPoint(Image_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 300)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 455.00, 227.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_2, 361, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setChineseName(Image_1_2, "拍卖行_装饰条_图片")
	GUI:setAnchorPoint(Image_1_2, 0.50, 0.50)
	GUI:setRotation(Image_1_2, 90.00)
	GUI:setRotationSkewX(Image_1_2, 90.00)
	GUI:setRotationSkewY(Image_1_2, 90.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 299)

	-- Create Image_1_3
	local Image_1_3 = GUI:Image_Create(Panel_1, "Image_1_3", 366.00, 45.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1_3, "拍卖行_装饰条_图片")
	GUI:setAnchorPoint(Image_1_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1_3, false)
	GUI:setTag(Image_1_3, 301)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 2.00, 405.00, 450.00, 360.00, false)
	GUI:setChineseName(Panel_items, "寄售货架_组合框")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 262)

	-- Create Text_tile
	local Text_tile = GUI:Text_Create(Panel_items, "Text_tile", 225.00, 345.00, 16, "#ebf291", [[寄售货架]])
	GUI:setChineseName(Text_tile, "拍卖行_寄售货架_文本")
	GUI:setAnchorPoint(Text_tile, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tile, false)
	GUI:setTag(Text_tile, 90)
	GUI:Text_enableOutline(Text_tile, "#111111", 1)

	-- Create ScrollView_items
	local ScrollView_items = GUI:ScrollView_Create(Panel_items, "ScrollView_items", 225.00, 331.00, 450.00, 330.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_items, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_items, 620.00, 380.00)
	GUI:setChineseName(ScrollView_items, "拍卖行_寄售物品列表")
	GUI:setAnchorPoint(ScrollView_items, 0.50, 1.00)
	GUI:setTouchEnabled(ScrollView_items, true)
	GUI:setTag(ScrollView_items, 265)

	-- Create Panel_bag
	local Panel_bag = GUI:Layout_Create(Panel_1, "Panel_bag", 730.00, 405.00, 270.00, 360.00, false)
	GUI:setChineseName(Panel_bag, "选择寄售_组合框")
	GUI:setAnchorPoint(Panel_bag, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_bag, true)
	GUI:setTag(Panel_bag, 266)

	-- Create Text_tile_0
	local Text_tile_0 = GUI:Text_Create(Panel_bag, "Text_tile_0", 135.00, 345.00, 16, "#ebf291", [[选择寄售道具]])
	GUI:setChineseName(Text_tile_0, "拍卖行_选择寄售道具_文本")
	GUI:setAnchorPoint(Text_tile_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tile_0, false)
	GUI:setTag(Text_tile_0, 147)
	GUI:Text_enableOutline(Text_tile_0, "#111111", 1)

	-- Create ScrollView_bag
	local ScrollView_bag = GUI:ScrollView_Create(Panel_bag, "ScrollView_bag", 135.00, 331.00, 270.00, 330.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_bag, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_bag, 270.00, 455.00)
	GUI:setChineseName(ScrollView_bag, "拍卖行_背包物品列表")
	GUI:setAnchorPoint(ScrollView_bag, 0.50, 1.00)
	GUI:setTouchEnabled(ScrollView_bag, true)
	GUI:setTag(ScrollView_bag, 267)
end
return ui