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

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Scene, "Image_1", 568.00, 320.00, "res/private/TradingBankLayer/img_phonebg.png")
	GUI:Image_setScale9Slice(Image_1, 180, 180, 92, 92)
	GUI:setContentSize(Image_1, 537, 249)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, true)
	GUI:setTag(Image_1, 466)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Image_1, "Image_5", 268.00, 208.00, "res/private/TradingBankLayer/jyh_2_04.png")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 32)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Image_1, "Button_2", 550.00, 227.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_2, 8, 8, 12, 10)
	GUI:setContentSize(Button_2, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 20)
	GUI:Button_titleDisableOutLine(Button_2)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 477)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Image_1, "Text_desc", 268.00, 127.00, 20, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, false)
	GUI:setTag(Text_desc, 33)
	GUI:Text_enableOutline(Text_desc, "#000000", 1)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Image_1, "Button_1", 268.00, 40.00, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 13, 9)
	GUI:setContentSize(Button_1, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "取回角色")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 18)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 476)

	-- Create Panel_8
	local Panel_8 = GUI:Layout_Create(Image_1, "Panel_8", 268.00, 41.00, 266.00, 28.00, false)
	GUI:setAnchorPoint(Panel_8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_8, false)
	GUI:setTag(Panel_8, 42)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_8, "Image_7", 133.00, 14.00, "res/private/TradingBankLayer/jyh_2_03.png")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 43)

	-- Create Panel_mask
	local Panel_mask = GUI:Layout_Create(Panel_8, "Panel_mask", 2.00, 0.00, 261.00, 28.00, true)
	GUI:setTouchEnabled(Panel_mask, false)
	GUI:setTag(Panel_mask, 44)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_mask, "Image_8", 1.00, 4.00, "res/private/TradingBankLayer/jyh_2_02.png")
	GUI:Image_setScale9Slice(Image_8, 28, 37, 9, 10)
	GUI:setContentSize(Image_8, 260.67999267578, 20.000400543213)
	GUI:setIgnoreContentAdaptWithSize(Image_8, false)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 45)

	-- Create Slider_3
	local Slider_3 = GUI:Slider_Create(Panel_8, "Slider_3", 132.00, 14.00, "res/private/gui_edit/Slider_Bg.png", "res/private/gui_edit/Slider_Bar.png", "res/private/TradingBankLayer/jyh_2_01.png")
	GUI:setContentSize(Slider_3, 237, 29)
	GUI:setIgnoreContentAdaptWithSize(Slider_3, false)
	GUI:Slider_setPercent(Slider_3, 24)
	GUI:setAnchorPoint(Slider_3, 0.50, 0.50)
	GUI:setTouchEnabled(Slider_3, true)
	GUI:setTag(Slider_3, 46)
end
return ui