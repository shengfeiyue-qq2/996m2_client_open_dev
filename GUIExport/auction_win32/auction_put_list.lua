local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 261)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 303.00, 355.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_1, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setAnchorPoint(Image_1_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 300)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 382.00, 34.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_2, 321, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setAnchorPoint(Image_1_2, 1.00, 0.00)
	GUI:setRotation(Image_1_2, 90.00)
	GUI:setRotationSkewX(Image_1_2, 90.00)
	GUI:setRotationSkewY(Image_1_2, 90.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 299)

	-- Create Image_1_3
	local Image_1_3 = GUI:Image_Create(Panel_1, "Image_1_3", 303.00, 35.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_3, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_3, false)
	GUI:setAnchorPoint(Image_1_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1_3, false)
	GUI:setTag(Image_1_3, 301)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 0.00, 355.00, 380.00, 320.00, false)
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 262)

	-- Create Text_tile
	local Text_tile = GUI:Text_Create(Panel_items, "Text_tile", 190.00, 310.00, 14, "#ebf291", [[寄售货架]])
	GUI:setAnchorPoint(Text_tile, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tile, false)
	GUI:setTag(Text_tile, 90)
	GUI:Text_enableOutline(Text_tile, "#111111", 1)

	-- Create ScrollView_items
	local ScrollView_items = GUI:ScrollView_Create(Panel_items, "ScrollView_items", 190.00, 300.00, 380.00, 298.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_items, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_items, 380.00, 380.00)
	GUI:setAnchorPoint(ScrollView_items, 0.50, 1.00)
	GUI:setTouchEnabled(ScrollView_items, true)
	GUI:setTag(ScrollView_items, 265)

	-- Create Panel_bag
	local Panel_bag = GUI:Layout_Create(Panel_1, "Panel_bag", 606.00, 355.00, 220.00, 320.00, false)
	GUI:setAnchorPoint(Panel_bag, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_bag, true)
	GUI:setTag(Panel_bag, 266)

	-- Create Text_tile_0
	local Text_tile_0 = GUI:Text_Create(Panel_bag, "Text_tile_0", 110.00, 310.00, 14, "#ebf291", [[选择寄售道具]])
	GUI:setAnchorPoint(Text_tile_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tile_0, false)
	GUI:setTag(Text_tile_0, 147)
	GUI:Text_enableOutline(Text_tile_0, "#111111", 1)

	-- Create ScrollView_bag
	local ScrollView_bag = GUI:ScrollView_Create(Panel_bag, "ScrollView_bag", 110.00, 300.00, 220.00, 298.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_bag, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_bag, 220.00, 455.00)
	GUI:setAnchorPoint(ScrollView_bag, 0.50, 1.00)
	GUI:setTouchEnabled(ScrollView_bag, true)
	GUI:setTag(ScrollView_bag, 267)
end
return ui