local ui = {}
function ui.init(parent)
	-- Create Layout
	local Layout = GUI:Layout_Create(parent, "Layout", 0.00, 0.00, 1700.00, 768.00, false)
	GUI:setTouchEnabled(Layout, false)
	GUI:setTag(Layout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 770.00, 360.00, 256.00, 359.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(PMainUI, "pBg", 128.00, 179.00, "res/public/1900000601.png")
	GUI:setAnchorPoint(pBg, 0.50, 0.50)
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create Text_title
	local Text_title = GUI:Text_Create(PMainUI, "Text_title", 128.00, 335.00, 18, "#ffffff", [[道具购买]])
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, -1)
	GUI:Text_enableOutline(Text_title, "#000000", 1)

	-- Create line
	local line = GUI:Image_Create(PMainUI, "line", 128.00, 320.00, "res/public/1900000667.png")
	GUI:setAnchorPoint(line, 0.50, 0.50)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create ItemBg
	local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 60.00, 270.00, "res/public/1900000664.png")
	GUI:setAnchorPoint(ItemBg, 0.50, 0.50)
	GUI:setTouchEnabled(ItemBg, false)
	GUI:setTag(ItemBg, -1)

	-- Create NodeItem
	local NodeItem = GUI:Node_Create(PMainUI, "NodeItem", 60.00, 270.00)
	GUI:setAnchorPoint(NodeItem, 0.50, 0.50)
	GUI:setTag(NodeItem, -1)

	-- Create NodeSingle
	local NodeSingle = GUI:Node_Create(PMainUI, "NodeSingle", 30.00, 208.00)
	GUI:setAnchorPoint(NodeSingle, 0.00, 0.50)
	GUI:setTag(NodeSingle, -1)

	-- Create NodeTotal
	local NodeTotal = GUI:Node_Create(PMainUI, "NodeTotal", 30.00, 112.00)
	GUI:setAnchorPoint(NodeTotal, 0.00, 0.50)
	GUI:setTag(NodeTotal, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 105.00, 270.00, 18, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 30.00, 160.00, 16, "#ffffff", [[数量:]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create BtnSub
	local BtnSub = GUI:Button_Create(PMainUI, "BtnSub", 95.00, 160.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(BtnSub, "res/public/1900000620_1.png")
	GUI:Button_setTitleText(BtnSub, "")
	GUI:Button_setTitleColor(BtnSub, "#ffffff")
	GUI:Button_setTitleFontSize(BtnSub, 10)
	GUI:Button_titleEnableOutline(BtnSub, "#000000", 1)
	GUI:setAnchorPoint(BtnSub, 0.50, 0.50)
	GUI:setTouchEnabled(BtnSub, true)
	GUI:setTag(BtnSub, -1)

	-- Create BtnAdd
	local BtnAdd = GUI:Button_Create(PMainUI, "BtnAdd", 220.00, 160.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(BtnAdd, "res/public/1900000621_1.png")
	GUI:Button_setTitleText(BtnAdd, "")
	GUI:Button_setTitleColor(BtnAdd, "#ffffff")
	GUI:Button_setTitleFontSize(BtnAdd, 10)
	GUI:Button_titleEnableOutline(BtnAdd, "#000000", 1)
	GUI:setAnchorPoint(BtnAdd, 0.50, 0.50)
	GUI:setTouchEnabled(BtnAdd, true)
	GUI:setTag(BtnAdd, -1)

	-- Create editBg
	local editBg = GUI:Image_Create(PMainUI, "editBg", 158.00, 160.00, "res/public/1900000676.png")
	GUI:setAnchorPoint(editBg, 0.50, 0.50)
	GUI:setTouchEnabled(editBg, false)
	GUI:setTag(editBg, -1)

	-- Create TextInput
	local TextInput = GUI:TextInput_Create(PMainUI, "TextInput", 158.00, 160.00, 67.00, 24.00, 20)
	GUI:TextInput_setString(TextInput, "")
	GUI:TextInput_setFontColor(TextInput, "#ffffff")
	GUI:setAnchorPoint(TextInput, 0.50, 0.50)
	GUI:setTouchEnabled(TextInput, true)
	GUI:setTag(TextInput, -1)

	-- Create BtnBuy
	local BtnBuy = GUI:Button_Create(PMainUI, "BtnBuy", 128.00, 50.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(BtnBuy, "res/public/1900000661.png")
	GUI:Button_setTitleText(BtnBuy, "购买")
	GUI:Button_setTitleColor(BtnBuy, "#ffffff")
	GUI:Button_setTitleFontSize(BtnBuy, 18)
	GUI:Button_titleEnableOutline(BtnBuy, "#000000", 1)
	GUI:setAnchorPoint(BtnBuy, 0.50, 0.50)
	GUI:setTouchEnabled(BtnBuy, true)
	GUI:setTag(BtnBuy, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 256.00, 359.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)
end
return ui