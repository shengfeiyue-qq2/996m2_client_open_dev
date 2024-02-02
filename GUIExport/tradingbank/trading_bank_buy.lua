local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 731.00, 445.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 12)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 1.00, 0.00, "res/private/TradingBankLayer/word_jiaoyh_018.jpg")
	GUI:Image_setScale9Slice(Image_1, 75, 75, 0, 0)
	GUI:setContentSize(Image_1, 729, 445)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 6)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 60.00, 441.00, 120.00, 441.00, 1)
	GUI:ListView_setItemsMargin(ListView_1, 4)
	GUI:setAnchorPoint(ListView_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 3)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_1, "Button_1", -393.55, -323.51, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "角色")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 20)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 4)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 121.06, 76.05)
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 240)

	-- Create Image_bottom
	local Image_bottom = GUI:Image_Create(Panel_1, "Image_bottom", 123.00, 0.00, "res/private/TradingBankLayer/img_66.jpg")
	GUI:setContentSize(Image_bottom, 607, 92)
	GUI:setIgnoreContentAdaptWithSize(Image_bottom, false)
	GUI:setTouchEnabled(Image_bottom, false)
	GUI:setTag(Image_bottom, 202)

	-- Create Image_17
	local Image_17 = GUI:Image_Create(Image_bottom, "Image_17", 0.00, 90.32, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_17, 606.5, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_17, false)
	GUI:setAnchorPoint(Image_17, 0.00, 0.50)
	GUI:setTouchEnabled(Image_17, false)
	GUI:setTag(Image_17, 203)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_bottom, "Image_1", 250.62, 26.80, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_1, 8, 8, 10, 10)
	GUI:setContentSize(Image_1, 288, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 199)

	-- Create TextField_1
	local TextField_1 = GUI:TextInput_Create(Image_1, "TextField_1", 144.00, 14.00, 288.00, 28.00, 18)
	GUI:TextInput_setString(TextField_1, "")
	GUI:TextInput_setPlaceHolder(TextField_1, "角色名称")
	GUI:TextInput_setFontColor(TextField_1, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_1, 13)
	GUI:setAnchorPoint(TextField_1, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_1, true)
	GUI:setTag(TextField_1, 201)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Image_bottom, "Button_3", 476.54, 26.80, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 11, 11)
	GUI:setContentSize(Button_3, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "搜索")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 24)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setScaleX(Button_3, 0.90)
	GUI:setScaleY(Button_3, 0.90)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 219)

	-- Create Text_tip
	local Text_tip = GUI:Text_Create(Panel_1, "Text_tip", 420.63, 68.00, 20, "#f8e6c6", [[购买后角色会直接出现在角色栏]])
	GUI:setAnchorPoint(Text_tip, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tip, false)
	GUI:setTag(Text_tip, 84)
	GUI:Text_enableOutline(Text_tip, "#000000", 1)
end
return ui