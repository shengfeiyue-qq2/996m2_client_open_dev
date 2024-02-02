local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 176)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Scene, "Image_bg", 568.00, 320.00, "res/private/TradingBankLayer/bg_jiaoyh_01.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 296)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_bg, "ButtonClose", 429.00, 489.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 6, 12, 10)
	GUI:setContentSize(ButtonClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 308)

	-- Create Panel_sel1
	local Panel_sel1 = GUI:Layout_Create(Image_bg, "Panel_sel1", 46.00, 328.00, 214.00, 25.00, false)
	GUI:setAnchorPoint(Panel_sel1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_sel1, true)
	GUI:setTag(Panel_sel1, 329)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_sel1, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 330)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 331)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_sel1, "Text_1", 30.00, 11.00, 16, "#ffffff", [[商品信息和宣传信息不符]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 332)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_sel3
	local Panel_sel3 = GUI:Layout_Create(Image_bg, "Panel_sel3", 46.00, 246.00, 92.00, 25.00, false)
	GUI:setAnchorPoint(Panel_sel3, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_sel3, true)
	GUI:setTag(Panel_sel3, 333)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_sel3, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 334)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 335)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_sel3, "Text_1", 30.00, 11.00, 16, "#ffffff", [[其他]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 336)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_sel2
	local Panel_sel2 = GUI:Layout_Create(Image_bg, "Panel_sel2", 46.00, 289.00, 100.00, 25.00, false)
	GUI:setAnchorPoint(Panel_sel2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_sel2, true)
	GUI:setTag(Panel_sel2, 325)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_sel2, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 326)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 327)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_sel2, "Text_1", 30.00, 11.00, 16, "#ffffff", [[不想要了]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 328)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Image_bg, "Button_1", 208.00, 57.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "拒绝收货")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 18)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 320)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Image_bg, "Image_2", 208.00, 151.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_2, 8, 8, 10, 10)
	GUI:setContentSize(Image_2, 318, 89)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 432)

	-- Create TextField_2
	local TextField_2 = GUI:TextInput_Create(Image_2, "TextField_2", 2.00, 84.00, 310.00, 81.00, 20)
	GUI:TextInput_setString(TextField_2, "")
	GUI:TextInput_setFontColor(TextField_2, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_2, 100)
	GUI:setAnchorPoint(TextField_2, 0.00, 1.00)
	GUI:setTouchEnabled(TextField_2, true)
	GUI:setTag(TextField_2, 435)

	-- Create Text_30_0_0
	local Text_30_0_0 = GUI:Text_Create(Image_bg, "Text_30_0_0", 47.00, 358.00, 16, "#e7c05a", [[请选择取消订单原因]])
	GUI:setAnchorPoint(Text_30_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0_0, false)
	GUI:setTag(Text_30_0_0, 315)
	GUI:Text_enableOutline(Text_30_0_0, "#000000", 1)

	-- Create Text_30
	local Text_30 = GUI:Text_Create(Image_bg, "Text_30", 51.00, 414.00, 18, "#ffffff", [[取消订单，无法恢复，取消订单后
钱将原路返回]])
	GUI:setAnchorPoint(Text_30, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30, false)
	GUI:setTag(Text_30, 313)
	GUI:Text_enableOutline(Text_30, "#000000", 1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Image_bg, "Image_3", 208.00, 467.00, "res/private/TradingBankLayer/jyh_2_04.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 312)

	-- Create Panel_mask
	local Panel_mask = GUI:Layout_Create(Image_bg, "Panel_mask", 208.00, 151.00, 318.00, 89.00, false)
	GUI:setAnchorPoint(Panel_mask, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_mask, true)
	GUI:setTag(Panel_mask, 225)
end
return ui