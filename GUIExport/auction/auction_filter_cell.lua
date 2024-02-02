local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 102.00, 32.00, false)
	GUI:setChineseName(Panel_1, "拍卖行职业过滤组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 276)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 51.00, 16.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1, 51, 51, 10, 10)
	GUI:setContentSize(Image_1, 102, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "职业过滤_背景框")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 268)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 5.00, 16.00, 16, "#ffffff", [[职业]])
	GUI:setChineseName(Text_1, "职业过滤_职业_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 269)
	GUI:Text_enableOutline(Text_1, "#111111", 1)

	-- Create Image_arrow
	local Image_arrow = GUI:Image_Create(Panel_1, "Image_arrow", 51.00, 16.00, "res/public/btn_szjm_01_4.png")
	GUI:setChineseName(Image_arrow, "职业过滤_箭头_图片")
	GUI:setAnchorPoint(Image_arrow, 0.50, 0.50)
	GUI:setTouchEnabled(Image_arrow, false)
	GUI:setTag(Image_arrow, 270)

	-- Create Image_pull
	local Image_pull = GUI:Image_Create(Panel_1, "Image_pull", 92.00, 16.00, "res/public/btn_szjm_01.png")
	GUI:setChineseName(Image_pull, "职业过滤_展开_图片")
	GUI:setAnchorPoint(Image_pull, 0.50, 0.50)
	GUI:setScaleX(Image_pull, 0.45)
	GUI:setScaleY(Image_pull, 0.45)
	GUI:setTouchEnabled(Image_pull, false)
	GUI:setTag(Image_pull, 271)
end
return ui