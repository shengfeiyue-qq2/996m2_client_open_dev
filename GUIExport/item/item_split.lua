local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "物品拆分层")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Layer, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_touch, "物品拆分_范围点击关闭")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 9)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layer, "Panel_1", 568.00, 320.00, 406.00, 266.00, false)
	GUI:Layout_setBackGroundImage(Panel_1, "res/public/bg_npc_08.jpg")
	GUI:setChineseName(Panel_1, "物品拆分_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 8)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 86.00, 105.00, 18, "#ffffff", [[拆分数量: ]])
	GUI:setChineseName(Text_1, "物品拆分_拆分数量_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 10)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 235.00, 105.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_2, 100, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setChineseName(Image_2, "物品拆分_输入背景框")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 11)

	-- Create Text_input
	local Text_input = GUI:TextInput_Create(Panel_1, "Text_input", 235.00, 105.00, 100.00, 20.00, 18)
	GUI:TextInput_setString(Text_input, "")
	GUI:TextInput_setFontColor(Text_input, "#ffffff")
	GUI:TextInput_setMaxLength(Text_input, 10)
	GUI:setChineseName(Text_input, "物品拆分_输入内容")
	GUI:setAnchorPoint(Text_input, 0.50, 0.50)
	GUI:setTouchEnabled(Text_input, true)
	GUI:setTag(Text_input, 12)

	-- Create Button_reduce
	local Button_reduce = GUI:Button_Create(Panel_1, "Button_reduce", 158.00, 105.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(Button_reduce, "res/public/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_reduce, 15, 13, 11, 9)
	GUI:setContentSize(Button_reduce, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_reduce, false)
	GUI:Button_setTitleText(Button_reduce, "")
	GUI:Button_setTitleColor(Button_reduce, "#414146")
	GUI:Button_setTitleFontSize(Button_reduce, 14)
	GUI:Button_titleEnableOutline(Button_reduce, "#000000", 1)
	GUI:setChineseName(Button_reduce, "物品拆分_减_按钮")
	GUI:setAnchorPoint(Button_reduce, 0.50, 0.50)
	GUI:setTouchEnabled(Button_reduce, true)
	GUI:setTag(Button_reduce, 13)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(Panel_1, "Button_ok", 203.00, 48.00, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button_ok, 15, 15, 11, 11)
	GUI:setContentSize(Button_ok, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "拆分")
	GUI:Button_setTitleColor(Button_ok, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_ok, 16)
	GUI:Button_titleEnableOutline(Button_ok, "#111111", 2)
	GUI:setChineseName(Button_ok, "物品拆分_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 17)

	-- Create Button_add
	local Button_add = GUI:Button_Create(Panel_1, "Button_add", 312.00, 105.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(Button_add, "res/public/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_add, 15, 13, 11, 9)
	GUI:setContentSize(Button_add, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_add, false)
	GUI:Button_setTitleText(Button_add, "")
	GUI:Button_setTitleColor(Button_add, "#414146")
	GUI:Button_setTitleFontSize(Button_add, 14)
	GUI:Button_titleEnableOutline(Button_add, "#000000", 1)
	GUI:setChineseName(Button_add, "物品拆分_加_按钮")
	GUI:setAnchorPoint(Button_add, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add, true)
	GUI:setTag(Button_add, 14)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 203.00, 227.00, 20, "#ffffff", [[地狱火]])
	GUI:setChineseName(Text_name, "物品拆分_物品名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 15)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Node_goods
	local Node_goods = GUI:Node_Create(Panel_1, "Node_goods", 203.00, 175.00)
	GUI:setChineseName(Node_goods, "物品拆分_物品")
	GUI:setAnchorPoint(Node_goods, 0.50, 0.50)
	GUI:setTag(Node_goods, 16)
end
return ui