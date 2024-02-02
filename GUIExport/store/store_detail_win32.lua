local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 600.00, 350.00, 200.00, 300.00, false)
	GUI:Layout_setBackGroundColorType(PMainUI, 1)
	GUI:Layout_setBackGroundColor(PMainUI, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(PMainUI, 102)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 75)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(PMainUI, "Panel_item", 0.00, 0.00, 200.00, 300.00, false)
	GUI:setTouchEnabled(Panel_item, false)
	GUI:setTag(Panel_item, 76)

	-- Create img_touch
	local img_touch = GUI:Image_Create(Panel_item, "img_touch", 100.00, 150.00, "res/public_win32/1900000666.png")
	GUI:setContentSize(img_touch, 200, 300)
	GUI:setIgnoreContentAdaptWithSize(img_touch, false)
	GUI:setAnchorPoint(img_touch, 0.50, 0.50)
	GUI:setTouchEnabled(img_touch, false)
	GUI:setTag(img_touch, 77)

	-- Create Image_iconBg
	local Image_iconBg = GUI:Image_Create(Panel_item, "Image_iconBg", 50.00, 220.00, "res/public_win32/1900000664.png")
	GUI:setAnchorPoint(Image_iconBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_iconBg, false)
	GUI:setTag(Image_iconBg, 78)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_item, "Text_title", 100.00, 275.00, 14, "#ffffff", [[道具购买]])
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 79)
	GUI:Text_enableOutline(Text_title, "#000000", 1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_item, "Image_line", 100.00, 260.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_line, 215, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 80)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(Panel_item, "Text_itemName", 100.00, 220.00, 14, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_itemName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 81)
	GUI:Text_enableOutline(Text_itemName, "#000000", 1)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_item, "Button_buy", 100.00, 35.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_buy, "res/public_win32/1900000661.png")
	GUI:Button_setScale9Slice(Button_buy, 15, 15, 11, 11)
	GUI:setContentSize(Button_buy, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "购买")
	GUI:Button_setTitleColor(Button_buy, "#ffffff")
	GUI:Button_setTitleFontSize(Button_buy, 14)
	GUI:Button_titleEnableOutline(Button_buy, "#000000", 1)
	GUI:setAnchorPoint(Button_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, 82)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_item, "Text_num", 20.00, 120.00, 12, "#ffffff", [[数量:]])
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 83)
	GUI:Text_enableOutline(Text_num, "#000000", 1)

	-- Create Button_add
	local Button_add = GUI:Button_Create(Panel_item, "Button_add", 160.00, 120.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(Button_add, "res/public/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_add, 11, 11, 13, 9)
	GUI:setContentSize(Button_add, 30, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_add, false)
	GUI:Button_setTitleText(Button_add, "")
	GUI:Button_setTitleColor(Button_add, "#414146")
	GUI:Button_setTitleFontSize(Button_add, 14)
	GUI:Button_titleDisableOutLine(Button_add)
	GUI:setAnchorPoint(Button_add, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add, true)
	GUI:setTag(Button_add, 84)

	-- Create Button_sub
	local Button_sub = GUI:Button_Create(Panel_item, "Button_sub", 70.00, 120.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(Button_sub, "res/public/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_sub, 11, 11, 13, 9)
	GUI:setContentSize(Button_sub, 30, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_sub, false)
	GUI:Button_setTitleText(Button_sub, "")
	GUI:Button_setTitleColor(Button_sub, "#414146")
	GUI:Button_setTitleFontSize(Button_sub, 14)
	GUI:Button_titleDisableOutLine(Button_sub)
	GUI:setAnchorPoint(Button_sub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sub, true)
	GUI:setTag(Button_sub, 85)

	-- Create Image_inputBg
	local Image_inputBg = GUI:Image_Create(Panel_item, "Image_inputBg", 115.00, 120.00, "res/public/1900000676.png")
	GUI:setContentSize(Image_inputBg, 50, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_inputBg, false)
	GUI:setAnchorPoint(Image_inputBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_inputBg, false)
	GUI:setTag(Image_inputBg, 86)

	-- Create input_num
	local input_num = GUI:TextInput_Create(Panel_item, "input_num", 115.00, 120.00, 50.00, 25.00, 14)
	GUI:TextInput_setString(input_num, "1")
	GUI:TextInput_setFontColor(input_num, "#ffffff")
	GUI:TextInput_setMaxLength(input_num, 4)
	GUI:setAnchorPoint(input_num, 0.50, 0.50)
	GUI:setTouchEnabled(input_num, true)
	GUI:setTag(input_num, 87)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_item, "Node_icon", 50.00, 220.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 88)

	-- Create Node_single
	local Node_single = GUI:Node_Create(Panel_item, "Node_single", 20.00, 160.00)
	GUI:setAnchorPoint(Node_single, 0.50, 0.50)
	GUI:setTag(Node_single, 89)

	-- Create Node_total
	local Node_total = GUI:Node_Create(Panel_item, "Node_total", 20.00, 80.00)
	GUI:setAnchorPoint(Node_total, 0.50, 0.50)
	GUI:setTag(Node_total, 90)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 200.00, 301.00, "res/public_win32/1900000530.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 91)
end
return ui