local ui = {}
function ui.init(parent)
	-- Create currency_cell
	local currency_cell = GUI:Layout_Create(parent, "currency_cell", 0.00, 0.00, 150.00, 30.00, false)
	GUI:setChineseName(currency_cell, "拍卖_输入货币组合框")
	GUI:setAnchorPoint(currency_cell, 0.50, 0.50)
	GUI:setTouchEnabled(currency_cell, true)
	GUI:setTag(currency_cell, 132)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(currency_cell, "Image_bg", 75.00, 15.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "拍卖_输入框背景图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 140)

	-- Create Image_line
	local Image_line = GUI:Image_Create(currency_cell, "Image_line", 75.00, 0.00, "res/public/1900000667_1.png")
	GUI:setContentSize(Image_line, 150, 1)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setChineseName(Image_line, "拍卖_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 54)

	-- Create Node_item
	local Node_item = GUI:Node_Create(currency_cell, "Node_item", 20.00, 15.00)
	GUI:setChineseName(Node_item, "拍卖_输入_节点")
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTag(Node_item, 133)

	-- Create Text_name
	local Text_name = GUI:Text_Create(currency_cell, "Text_name", 75.00, 15.00, 12, "#ffffff", [[金币]])
	GUI:setChineseName(Text_name, "拍卖_货币名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 134)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui