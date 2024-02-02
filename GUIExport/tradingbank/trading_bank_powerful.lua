local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 465)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 127)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 568.00, 320.00, "res/private/TradingBankLayer/img_phonebg.png")
	GUI:Image_setScale9Slice(Image_1, 180, 180, 92, 92)
	GUI:setContentSize(Image_1, 548, 350)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, true)
	GUI:setTag(Image_1, 466)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_1, "Text_1", 262.00, 91.00, 20, "#ffffff", [[Text Label]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 120)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_ewm
	local Image_ewm = GUI:Image_Create(Image_1, "Image_ewm", 261.00, 216.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_ewm, 200, 200)
	GUI:setIgnoreContentAdaptWithSize(Image_ewm, false)
	GUI:setAnchorPoint(Image_ewm, 0.50, 0.50)
	GUI:setTouchEnabled(Image_ewm, false)
	GUI:setTag(Image_ewm, 119)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 568.00, 319.00, "res/private/TradingBankLayer/img_phonebg.png")
	GUI:Image_setScale9Slice(Image_2, 180, 180, 92, 92)
	GUI:setContentSize(Image_2, 548, 281)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, true)
	GUI:setTag(Image_2, 121)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_2, "Text_2", 263.00, 166.00, 20, "#ffffff", [[Text Label]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 122)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_1, "Button_1", 461.00, 191.00, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 13, 9)
	GUI:setContentSize(Button_1, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "支付完成")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 20)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 125)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_1, "Button_2", 679.00, 191.00, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_2, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 13, 9)
	GUI:setContentSize(Button_2, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "重新支付")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 20)
	GUI:Button_titleDisableOutLine(Button_2)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 124)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_1, "Button_3", 854.00, 472.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_3, 8, 8, 12, 10)
	GUI:setContentSize(Button_3, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 20)
	GUI:Button_titleDisableOutLine(Button_3)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 126)
end
return ui