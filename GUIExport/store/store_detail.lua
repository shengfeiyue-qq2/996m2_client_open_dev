local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "商店购买操作场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 641.00, 182.00, 256.00, 359.00, false)
	GUI:Layout_setBackGroundColorType(PMainUI, 1)
	GUI:Layout_setBackGroundColor(PMainUI, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(PMainUI, 102)
	GUI:setChineseName(PMainUI, "商店购买操作组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 26)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(PMainUI, "Panel_item", 0.00, 0.00, 256.00, 359.00, false)
	GUI:setChineseName(Panel_item, "商店购买操作组合")
	GUI:setTouchEnabled(Panel_item, false)
	GUI:setTag(Panel_item, 27)

	-- Create img_touch
	local img_touch = GUI:Image_Create(Panel_item, "img_touch", 128.00, 179.00, "res/public/1900000601.png")
	GUI:setChineseName(img_touch, "购买操作_背景图")
	GUI:setAnchorPoint(img_touch, 0.50, 0.50)
	GUI:setTouchEnabled(img_touch, false)
	GUI:setTag(img_touch, 28)

	-- Create Image_iconBg
	local Image_iconBg = GUI:Image_Create(Panel_item, "Image_iconBg", 55.00, 265.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_iconBg, "购买操作_物品图标_背景图")
	GUI:setAnchorPoint(Image_iconBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_iconBg, false)
	GUI:setTag(Image_iconBg, 31)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_item, "Node_icon", 55.00, 265.00)
	GUI:setChineseName(Node_icon, "购买操作_物品图标_节点")
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 40)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_item, "Text_title", 124.00, 335.00, 18, "#ffffff", [[道具购买]])
	GUI:setChineseName(Text_title, "购买操作_标题_文本")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 38)
	GUI:Text_enableOutline(Text_title, "#000000", 1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_item, "Image_line", 127.00, 322.00, "res/public/1900000667.png")
	GUI:setChineseName(Image_line, "购买操作_装饰图")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 32)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(Panel_item, "Text_itemName", 104.00, 266.00, 18, "#ffffff", [[]])
	GUI:setChineseName(Text_itemName, "购买操作_物品名称_文本")
	GUI:setAnchorPoint(Text_itemName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 39)
	GUI:Text_enableOutline(Text_itemName, "#000000", 1)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_item, "Button_buy", 133.00, 35.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_buy, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_buy, 15, 15, 11, 11)
	GUI:setContentSize(Button_buy, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "购买")
	GUI:Button_setTitleColor(Button_buy, "#ffffff")
	GUI:Button_setTitleFontSize(Button_buy, 18)
	GUI:Button_titleEnableOutline(Button_buy, "#000000", 1)
	GUI:setChineseName(Button_buy, "购买操作_购买_按钮")
	GUI:setAnchorPoint(Button_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, 32)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_item, "Text_num", 20.00, 165.00, 16, "#ffffff", [[数量:]])
	GUI:setChineseName(Text_num, "购买操作_数量_文本")
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 33)
	GUI:Text_enableOutline(Text_num, "#000000", 1)

	-- Create Button_sub
	local Button_sub = GUI:Button_Create(Panel_item, "Button_sub", 80.00, 165.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(Button_sub, "res/public/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_sub, 15, 6, 12, 3)
	GUI:setContentSize(Button_sub, 33, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_sub, false)
	GUI:Button_setTitleText(Button_sub, "")
	GUI:Button_setTitleColor(Button_sub, "#414146")
	GUI:Button_setTitleFontSize(Button_sub, 14)
	GUI:Button_titleDisableOutLine(Button_sub)
	GUI:setChineseName(Button_sub, "购买操作_减少_按钮")
	GUI:setAnchorPoint(Button_sub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sub, true)
	GUI:setTag(Button_sub, 35)

	-- Create Button_add
	local Button_add = GUI:Button_Create(Panel_item, "Button_add", 200.00, 165.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(Button_add, "res/public/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_add, 15, 6, 12, 3)
	GUI:setContentSize(Button_add, 33, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_add, false)
	GUI:Button_setTitleText(Button_add, "")
	GUI:Button_setTitleColor(Button_add, "#414146")
	GUI:Button_setTitleFontSize(Button_add, 14)
	GUI:Button_titleDisableOutLine(Button_add)
	GUI:setChineseName(Button_add, "购买操作_增加_按钮")
	GUI:setAnchorPoint(Button_add, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add, true)
	GUI:setTag(Button_add, 34)

	-- Create Image_inputBg
	local Image_inputBg = GUI:Image_Create(Panel_item, "Image_inputBg", 140.00, 165.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_inputBg, 25, 23, 11, 9)
	GUI:setContentSize(Image_inputBg, 80, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_inputBg, false)
	GUI:setChineseName(Image_inputBg, "购买操作_输入_背景图")
	GUI:setAnchorPoint(Image_inputBg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_inputBg, false)
	GUI:setTag(Image_inputBg, 36)

	-- Create input_num
	local input_num = GUI:TextInput_Create(Panel_item, "input_num", 140.00, 165.00, 70.00, 24.00, 20)
	GUI:TextInput_setString(input_num, "1")
	GUI:TextInput_setFontColor(input_num, "#ffffff")
	GUI:TextInput_setMaxLength(input_num, 4)
	GUI:setChineseName(input_num, "购买操作_输入内容")
	GUI:setAnchorPoint(input_num, 0.50, 0.50)
	GUI:setTouchEnabled(input_num, true)
	GUI:setTag(input_num, 37)

	-- Create Node_single
	local Node_single = GUI:Node_Create(Panel_item, "Node_single", 66.00, 208.00)
	GUI:setChineseName(Node_single, "购买操作_单价_节点")
	GUI:setAnchorPoint(Node_single, 0.50, 0.50)
	GUI:setTag(Node_single, 41)

	-- Create Node_total
	local Node_total = GUI:Node_Create(Panel_item, "Node_total", 66.00, 118.00)
	GUI:setChineseName(Node_total, "购买操作_总价_节点")
	GUI:setAnchorPoint(Node_total, 0.50, 0.50)
	GUI:setTag(Node_total, 42)

	-- Create Node_have
	local Node_have = GUI:Node_Create(Panel_item, "Node_have", 66.00, 73.00)
	GUI:setAnchorPoint(Node_have, 0.50, 0.50)
	GUI:setTag(Node_have, 42)

	-- Create Text_info1
	local Text_info1 = GUI:Text_Create(Panel_item, "Text_info1", 20.00, 210.00, 16, "#ffffff", [[单价：]])
	GUI:setAnchorPoint(Text_info1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info1, false)
	GUI:setTag(Text_info1, -1)
	GUI:Text_enableOutline(Text_info1, "#000000", 1)

	-- Create Text_info2
	local Text_info2 = GUI:Text_Create(Panel_item, "Text_info2", 20.00, 120.00, 16, "#ffffff", [[总价：]])
	GUI:setAnchorPoint(Text_info2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info2, false)
	GUI:setTag(Text_info2, -1)
	GUI:Text_enableOutline(Text_info2, "#000000", 1)

	-- Create Text_info3
	local Text_info3 = GUI:Text_Create(Panel_item, "Text_info3", 20.00, 75.00, 16, "#ffffff", [[当前：]])
	GUI:setAnchorPoint(Text_info3, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info3, false)
	GUI:setTag(Text_info3, -1)
	GUI:Text_enableOutline(Text_info3, "#000000", 1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 256.00, 359.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "商店购买操作_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 30)
end
return ui