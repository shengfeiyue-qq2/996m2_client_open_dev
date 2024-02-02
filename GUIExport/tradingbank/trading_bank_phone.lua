local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(Panel_cancel, 1)
	GUI:Layout_setBackGroundColor(Panel_cancel, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cancel, 102)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 172)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Scene, "Image_1", 568.00, 320.00, "res/private/TradingBankLayer/img_phonebg.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, true)
	GUI:setTag(Image_1, 173)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_1, "Text_1", 277.00, 220.00, 20, "#f8e6c6", [[使用交易行需先验证身份信息,避免出现盗号现象]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 174)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Image_1, "Button_2", 395.00, 169.00, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "获取验证码")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 19)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 232)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Image_1, "Image_4", 246.00, 95.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_4, 8, 8, 10, 10)
	GUI:setContentSize(Image_4, 150, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 230)

	-- Create TextField_6
	local TextField_6 = GUI:TextInput_Create(Image_4, "TextField_6", 75.00, 16.00, 150.00, 32.00, 20)
	GUI:TextInput_setString(TextField_6, "")
	GUI:TextInput_setFontColor(TextField_6, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_6, 11)
	GUI:setAnchorPoint(TextField_6, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_6, true)
	GUI:setTag(TextField_6, 231)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Image_1, "Image_3", 246.00, 168.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_3, 8, 8, 10, 10)
	GUI:setContentSize(Image_3, 150, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 228)

	-- Create TextField_5
	local TextField_5 = GUI:TextInput_Create(Image_3, "TextField_5", 75.00, 16.00, 150.00, 32.00, 20)
	GUI:TextInput_setString(TextField_5, "")
	GUI:TextInput_setFontColor(TextField_5, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_5, 11)
	GUI:setAnchorPoint(TextField_5, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_5, true)
	GUI:setTag(TextField_5, 229)

	-- Create Text_12
	local Text_12 = GUI:Text_Create(Image_1, "Text_12", 56.00, 91.00, 22, "#ff0000", [[*]])
	GUI:setAnchorPoint(Text_12, 0.50, 0.50)
	GUI:setTouchEnabled(Text_12, false)
	GUI:setTag(Text_12, 227)
	GUI:Text_enableOutline(Text_12, "#000000", 1)

	-- Create Text_11
	local Text_11 = GUI:Text_Create(Image_1, "Text_11", 114.00, 94.00, 19, "#f8e6c6", [[手机验证码:]])
	GUI:setAnchorPoint(Text_11, 0.50, 0.50)
	GUI:setTouchEnabled(Text_11, false)
	GUI:setTag(Text_11, 226)
	GUI:Text_enableOutline(Text_11, "#000000", 1)

	-- Create Text_9
	local Text_9 = GUI:Text_Create(Image_1, "Text_9", 114.00, 167.00, 19, "#f8e6c6", [[您的手机号:]])
	GUI:setAnchorPoint(Text_9, 0.50, 0.50)
	GUI:setTouchEnabled(Text_9, false)
	GUI:setTag(Text_9, 225)
	GUI:Text_enableOutline(Text_9, "#000000", 1)

	-- Create Text_bindtip
	local Text_bindtip = GUI:Text_Create(Image_1, "Text_bindtip", 339.00, 135.00, 15, "#76684f", [[本次获取验证码将绑定手机号,用于登录Web交易行]])
	GUI:setAnchorPoint(Text_bindtip, 0.50, 0.50)
	GUI:setTouchEnabled(Text_bindtip, false)
	GUI:setTag(Text_bindtip, 224)
	GUI:Text_enableOutline(Text_bindtip, "#000000", 1)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Image_1, "Button_3", 274.00, 47.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 11, 11)
	GUI:setContentSize(Button_3, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "确定")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 19)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 234)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_1, "ButtonClose", 560.00, 259.00, "res/public/1900000510.png")
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
	GUI:setTag(ButtonClose, 78)
end
return ui