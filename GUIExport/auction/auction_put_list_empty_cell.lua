local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 400.00, 300.00, 225.00, 110.00, false)
	GUI:setChineseName(Panel_1, "拍卖行_上架_组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 138)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 112.00, 55.00, "res/public/1900000665.png")
	GUI:setContentSize(Image_bg, 220, 105)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "拍卖行_上架背景图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 139)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_1, "Image_item", 45.00, 45.00, "res/public/1900000651.png")
	GUI:setChineseName(Image_item, "拍卖行_上架物品框")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 141)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_1, "Image_5", 45.00, 45.00, "res/public/btn_jiahao_01.png")
	GUI:setChineseName(Image_5, "拍卖行_上架装饰图片")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 146)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 145.00, 45.00, 16, "#ffffff", [[右侧点击道具
　　上架]])
	GUI:setChineseName(Text_name, "拍卖行_右侧点击道具_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 140)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui