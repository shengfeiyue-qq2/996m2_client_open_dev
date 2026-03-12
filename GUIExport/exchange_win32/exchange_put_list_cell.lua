local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 400.00, 300.00, 190.00, 100.00, false)
	GUI:setChineseName(Panel_1, "寄售组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 130)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 95.00, 50.00, "res/public_win32/1900000665.png")
	GUI:setContentSize(Image_bg, 185, 95)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "寄售_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 131)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 95.00, 80.00, 12, "#ffffff", [[我是装备名称]])
	GUI:setChineseName(Text_name, "寄售_物品名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 132)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_1, "Image_item", 40.00, 40.00, "res/public/1900000651.png")
	GUI:setContentSize(Image_item, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(Image_item, false)
	GUI:setChineseName(Image_item, "寄售_物品_图片")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 133)

	-- Create Text_number_name
	local Text_number_name = GUI:Text_Create(Panel_1, "Text_number_name", 66.00, 55.00, 12, "#ffffff", [[数　量:]])
	GUI:setChineseName(Text_number_name, "寄售_数量_文本")
	GUI:setAnchorPoint(Text_number_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_number_name, false)
	GUI:setTag(Text_number_name, 135)
	GUI:Text_enableOutline(Text_number_name, "#000000", 1)

	-- Create Text_itemnum
	local Text_itemnum = GUI:Text_Create(Panel_1, "Text_itemnum", 126.00, 55.00, 12, "#ffffff", [[400]])
	GUI:setChineseName(Text_itemnum, "寄售_数量_文本")
	GUI:setAnchorPoint(Text_itemnum, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemnum, false)
	GUI:setTag(Text_itemnum, 136)
	GUI:Text_enableOutline(Text_itemnum, "#111111", 1)

	-- Create Node_buy_money
	local Node_buy_money = GUI:Node_Create(Panel_1, "Node_buy_money", 116.00, 40.00)
	GUI:setChineseName(Node_buy_money, "寄售_价格货币节点")
	GUI:setAnchorPoint(Node_buy_money, 0.50, 0.50)
	GUI:setTag(Node_buy_money, 231)

	-- Create Text_buy_name
	local Text_buy_name = GUI:Text_Create(Panel_1, "Text_buy_name", 66.00, 40.00, 12, "#ffffff", [[价格:]])
	GUI:setChineseName(Text_buy_name, "寄售_价格_文本")
	GUI:setAnchorPoint(Text_buy_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_buy_name, false)
	GUI:setTag(Text_buy_name, 232)
	GUI:Text_enableOutline(Text_buy_name, "#000000", 1)

	-- Create Text_buy_price
	local Text_buy_price = GUI:Text_Create(Panel_1, "Text_buy_price", 126.00, 40.00, 12, "#ffff0f", [[400]])
	GUI:setChineseName(Text_buy_price, "寄售_价格_文本")
	GUI:setAnchorPoint(Text_buy_price, 0.00, 0.50)
	GUI:setTouchEnabled(Text_buy_price, false)
	GUI:setTag(Text_buy_price, 233)
	GUI:Text_enableOutline(Text_buy_price, "#111111", 1)

	-- Create Text_status
	local Text_status = GUI:Text_Create(Panel_1, "Text_status", 130.00, 20.00, 12, "#ff0500", [[20超时]])
	GUI:setChineseName(Text_status, "寄售_状态_文本")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, 137)
	GUI:Text_enableOutline(Text_status, "#111111", 1)
end
return ui