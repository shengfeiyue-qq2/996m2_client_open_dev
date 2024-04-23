local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 0.00, 0.00, 730.00, 140.00, true)
	GUI:setTouchEnabled(Cell, true)
	GUI:setTag(Cell, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Cell, "Image_1", 123.00, 70.00, "res/public/1900000665.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, true)
	GUI:setTag(Image_1, -1)
	GUI:setVisible(Image_1, false)

	-- Create ImageTag
	local ImageTag = GUI:Image_Create(Image_1, "ImageTag", 31.00, 118.00, "res/private/store_ui/1900020100.png")
	GUI:setAnchorPoint(ImageTag, 0.50, 0.50)
	GUI:setTouchEnabled(ImageTag, false)
	GUI:setTag(ImageTag, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_1, "Text_name", 120.00, 115.00, 18, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create itemBg
	local itemBg = GUI:Image_Create(Image_1, "itemBg", 51.00, 55.00, "res/public/1900000664.png")
	GUI:setAnchorPoint(itemBg, 0.50, 0.50)
	GUI:setTouchEnabled(itemBg, false)
	GUI:setTag(itemBg, -1)

	-- Create pPriceNow
	local pPriceNow = GUI:Layout_Create(Image_1, "pPriceNow", 95.00, 40.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPriceNow, 0.00, 0.50)
	GUI:setTouchEnabled(pPriceNow, false)
	GUI:setTag(pPriceNow, -1)

	-- Create pPrice
	local pPrice = GUI:Layout_Create(Image_1, "pPrice", 95.00, 75.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPrice, 0.00, 0.50)
	GUI:setTouchEnabled(pPrice, false)
	GUI:setTag(pPrice, -1)

	-- Create Text_condition
	local Text_condition = GUI:Text_Create(Image_1, "Text_condition", 95.00, 75.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_condition, 0.00, 0.50)
	GUI:setTouchEnabled(Text_condition, false)
	GUI:setTag(Text_condition, -1)
	GUI:Text_enableOutline(Text_condition, "#000000", 1)

	-- Create pIcon
	local pIcon = GUI:Node_Create(Image_1, "pIcon", 51.00, 55.00)
	GUI:setTag(pIcon, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Cell, "Image_2", 365.00, 70.00, "res/public/1900000665.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, true)
	GUI:setTag(Image_2, -1)
	GUI:setVisible(Image_2, false)

	-- Create ImageTag
	local ImageTag = GUI:Image_Create(Image_2, "ImageTag", 31.00, 118.00, "res/private/store_ui/1900020100.png")
	GUI:setAnchorPoint(ImageTag, 0.50, 0.50)
	GUI:setTouchEnabled(ImageTag, false)
	GUI:setTag(ImageTag, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_2, "Text_name", 120.00, 115.00, 18, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create itemBg
	local itemBg = GUI:Image_Create(Image_2, "itemBg", 51.00, 55.00, "res/public/1900000664.png")
	GUI:setAnchorPoint(itemBg, 0.50, 0.50)
	GUI:setTouchEnabled(itemBg, false)
	GUI:setTag(itemBg, -1)

	-- Create pPriceNow
	local pPriceNow = GUI:Layout_Create(Image_2, "pPriceNow", 95.00, 40.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPriceNow, 0.00, 0.50)
	GUI:setTouchEnabled(pPriceNow, false)
	GUI:setTag(pPriceNow, -1)

	-- Create pPrice
	local pPrice = GUI:Layout_Create(Image_2, "pPrice", 95.00, 75.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPrice, 0.00, 0.50)
	GUI:setTouchEnabled(pPrice, false)
	GUI:setTag(pPrice, -1)

	-- Create Text_condition
	local Text_condition = GUI:Text_Create(Image_2, "Text_condition", 95.00, 75.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_condition, 0.00, 0.50)
	GUI:setTouchEnabled(Text_condition, false)
	GUI:setTag(Text_condition, -1)
	GUI:Text_enableOutline(Text_condition, "#000000", 1)

	-- Create pIcon
	local pIcon = GUI:Node_Create(Image_2, "pIcon", 51.00, 55.00)
	GUI:setTag(pIcon, -1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Cell, "Image_3", 607.00, 70.00, "res/public/1900000665.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, true)
	GUI:setTag(Image_3, -1)
	GUI:setVisible(Image_3, false)

	-- Create ImageTag
	local ImageTag = GUI:Image_Create(Image_3, "ImageTag", 31.00, 118.00, "res/private/store_ui/1900020100.png")
	GUI:setAnchorPoint(ImageTag, 0.50, 0.50)
	GUI:setTouchEnabled(ImageTag, false)
	GUI:setTag(ImageTag, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_3, "Text_name", 120.00, 115.00, 18, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create itemBg
	local itemBg = GUI:Image_Create(Image_3, "itemBg", 51.00, 55.00, "res/public/1900000664.png")
	GUI:setAnchorPoint(itemBg, 0.50, 0.50)
	GUI:setTouchEnabled(itemBg, false)
	GUI:setTag(itemBg, -1)

	-- Create pPriceNow
	local pPriceNow = GUI:Layout_Create(Image_3, "pPriceNow", 95.00, 40.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPriceNow, 0.00, 0.50)
	GUI:setTouchEnabled(pPriceNow, false)
	GUI:setTag(pPriceNow, -1)

	-- Create pPrice
	local pPrice = GUI:Layout_Create(Image_3, "pPrice", 95.00, 75.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pPrice, 0.00, 0.50)
	GUI:setTouchEnabled(pPrice, false)
	GUI:setTag(pPrice, -1)

	-- Create Text_condition
	local Text_condition = GUI:Text_Create(Image_3, "Text_condition", 95.00, 75.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_condition, 0.00, 0.50)
	GUI:setTouchEnabled(Text_condition, false)
	GUI:setTag(Text_condition, -1)
	GUI:Text_enableOutline(Text_condition, "#000000", 1)

	-- Create pIcon
	local pIcon = GUI:Node_Create(Image_3, "pIcon", 51.00, 55.00)
	GUI:setTag(pIcon, -1)
end
return ui