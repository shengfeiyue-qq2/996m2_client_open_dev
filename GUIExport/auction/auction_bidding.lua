local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 732.00, 410.00, false)
	GUI:setChineseName(Panel_1, "拍卖通用标题组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 293)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 366.00, 408.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1, "拍卖通用标题_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 298)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_1, "Image_1_0", 366.00, 374.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1_0, "拍卖通用标题_装饰条")
	GUI:setAnchorPoint(Image_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 161)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 85.00, 390.00, 16, "#ffffff", [[竞拍道具]])
	GUI:setChineseName(Text_1, "通用标题_竞拍道具_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 218)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_1, "Text_1_0", 275.00, 390.00, 16, "#ffffff", [[剩余时间]])
	GUI:setChineseName(Text_1_0, "通用标题_剩余时间_文本")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 217)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_1, "Text_1_1", 467.00, 390.00, 16, "#ffffff", [[竞拍价格]])
	GUI:setChineseName(Text_1_1, "通用标题_竞拍价格_文本")
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 216)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_1_2
	local Text_1_2 = GUI:Text_Create(Panel_1, "Text_1_2", 660.00, 390.00, 16, "#ffffff", [[一口价]])
	GUI:setChineseName(Text_1_2, "通用标题_一口价_文本")
	GUI:setAnchorPoint(Text_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2, false)
	GUI:setTag(Text_1_2, 215)
	GUI:Text_enableOutline(Text_1_2, "#000000", 1)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_1, "ListView_items", 366.00, 0.00, 730.00, 373.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setChineseName(ListView_items, "通用标题_商品容器_列表")
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 300)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_1, "Image_empty", 366.00, 205.00, "res/private/auction/word_paimaihang_01.png")
	GUI:setChineseName(Image_empty, "通用标题_无物品上架_图片")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 310)

	-- Create TextMaxTips
	local TextMaxTips = GUI:Text_Create(Panel_1, "TextMaxTips", 600.00, 20.00, 16, "#ffe400", [[我的竞拍只显示100条竞拍]])
	GUI:setChineseName(TextMaxTips, "通用标题_我的竞拍上限提示")
	GUI:setTouchEnabled(TextMaxTips, false)
	GUI:setTag(TextMaxTips, -1)
	GUI:setVisible(TextMaxTips, false)
	GUI:Text_enableOutline(TextMaxTips, "#000000", 1)
end
return ui