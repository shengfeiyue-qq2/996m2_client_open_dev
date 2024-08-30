local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 115.00, 50.00, false)
	GUI:setChineseName(Panel_cell, "充值货币类型组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 27)

	-- Create Image_product
	local Image_product = GUI:Image_Create(Panel_cell, "Image_product", 57.00, 25.00, "res/private/powerful_secret/bg_czzya_01.png")
	GUI:setContentSize(Image_product, 112, 46)
	GUI:setIgnoreContentAdaptWithSize(Image_product, false)
	GUI:setChineseName(Image_product, "充值货币_背景图")
	GUI:setAnchorPoint(Image_product, 0.50, 0.50)
	GUI:setTouchEnabled(Image_product, false)
	GUI:setTag(Image_product, 55)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_cell, "Image_select", 57.00, 25.00, "res/public/1900000678_1.png")
	GUI:Image_setScale9Slice(Image_select, 23, 21, 22, 22)
	GUI:setContentSize(Image_select, 116, 50)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "充值货币_选中")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 57)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 57.00, 35.00, 16, "#ffff00", [[元宝]])
	GUI:setChineseName(Text_name, "充值货币_名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 29)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_ratio
	local Text_ratio = GUI:Text_Create(Panel_cell, "Text_ratio", 57.00, 15.00, 12, "#ffff00", [[1:100]])
	GUI:setChineseName(Text_ratio, "充值货币_比例_文本")
	GUI:setAnchorPoint(Text_ratio, 0.50, 0.50)
	GUI:setTouchEnabled(Text_ratio, false)
	GUI:setTag(Text_ratio, 30)
	GUI:Text_enableOutline(Text_ratio, "#000000", 1)
end
return ui