local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 590.76, 500.00, 200.00, false)
	GUI:setAnchorPoint(Panel_2, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_2, false)
	GUI:setTag(Panel_2, 153)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 250.00, 155.00, "res/private/TradingBankLayer/jyh_2_05.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 107)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_2, "Button_1", 180.56, 115.00, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 12, 10)
	GUI:setContentSize(Button_1, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "个人信息")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 18)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 148)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_2, "Button_2", 328.87, 115.00, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_2, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 12, 10)
	GUI:setContentSize(Button_2, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "返回盒子")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 18)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 149)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_2, "Button_3", 180.56, 61.66, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_3, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 12, 10)
	GUI:setContentSize(Button_3, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "拒绝收货")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 18)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 150)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_2, "Button_4", 328.85, 61.66, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_4, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_4, 15, 15, 12, 10)
	GUI:setContentSize(Button_4, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_4, false)
	GUI:Button_setTitleText(Button_4, "确认收货")
	GUI:Button_setTitleColor(Button_4, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_4, 18)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 151)
end
return ui