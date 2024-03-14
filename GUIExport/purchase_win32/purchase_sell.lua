local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_close
	local Panel_close = GUI:Layout_Create(Scene, "Panel_close", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_close, true)
	GUI:setTag(Panel_close, 161)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 356.00, 362.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 144)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 178.00, 180.00, "res/public/1900000601.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 356, 360)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 146)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 355.00, 344.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000530.png")
	GUI:Button_setScale9Slice(Button_close, 7, 6, 11, 10)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.00, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 149)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 61.00, 279.00, 12, "#ffffff", [[物品名称：]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_1, "Text_1_1", 61.00, 244.00, 12, "#ffffff", [[物品单价：]])
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, -1)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_1_2
	local Text_1_2 = GUI:Text_Create(Panel_1, "Text_1_2", 61.00, 209.00, 12, "#ffffff", [[出售总价：]])
	GUI:setTouchEnabled(Text_1_2, false)
	GUI:setTag(Text_1_2, -1)
	GUI:Text_enableOutline(Text_1_2, "#000000", 1)

	-- Create Text_1_3
	local Text_1_3 = GUI:Text_Create(Panel_1, "Text_1_3", 61.00, 174.00, 12, "#ffffff", [[剩余数量：]])
	GUI:setTouchEnabled(Text_1_3, false)
	GUI:setTag(Text_1_3, -1)
	GUI:Text_enableOutline(Text_1_3, "#000000", 1)

	-- Create Text_1_4
	local Text_1_4 = GUI:Text_Create(Panel_1, "Text_1_4", 61.00, 139.00, 12, "#ffffff", [[拥有数量：]])
	GUI:setTouchEnabled(Text_1_4, false)
	GUI:setTag(Text_1_4, -1)
	GUI:Text_enableOutline(Text_1_4, "#000000", 1)

	-- Create Text_1_5
	local Text_1_5 = GUI:Text_Create(Panel_1, "Text_1_5", 61.00, 104.00, 12, "#ffffff", [[出售数量：]])
	GUI:setTouchEnabled(Text_1_5, false)
	GUI:setTag(Text_1_5, -1)
	GUI:Text_enableOutline(Text_1_5, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 148.00, 279.00, 12, "#ffffff", [[物品名]])
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 146.00, 240.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1_1, 52, 52, 10, 11)
	GUI:setContentSize(Image_1_1, 120, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, -1)

	-- Create Text_single
	local Text_single = GUI:Text_Create(Image_1_1, "Text_single", 60.00, 14.00, 12, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_single, 0.50, 0.50)
	GUI:setTouchEnabled(Text_single, false)
	GUI:setTag(Text_single, -1)
	GUI:Text_enableOutline(Text_single, "#000000", 1)

	-- Create Text_coin_1
	local Text_coin_1 = GUI:Text_Create(Image_1_1, "Text_coin_1", 126.00, 14.00, 12, "#ffffff", [[元宝]])
	GUI:setAnchorPoint(Text_coin_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_coin_1, false)
	GUI:setTag(Text_coin_1, -1)
	GUI:Text_enableOutline(Text_coin_1, "#000000", 1)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 146.00, 204.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1_2, 52, 52, 10, 11)
	GUI:setContentSize(Image_1_2, 120, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, -1)

	-- Create Text_total
	local Text_total = GUI:Text_Create(Image_1_2, "Text_total", 60.00, 14.00, 12, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_total, 0.50, 0.50)
	GUI:setTouchEnabled(Text_total, false)
	GUI:setTag(Text_total, -1)
	GUI:Text_enableOutline(Text_total, "#000000", 1)

	-- Create Text_coin_2
	local Text_coin_2 = GUI:Text_Create(Image_1_2, "Text_coin_2", 126.00, 14.00, 12, "#ffffff", [[元宝]])
	GUI:setAnchorPoint(Text_coin_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_coin_2, false)
	GUI:setTag(Text_coin_2, -1)
	GUI:Text_enableOutline(Text_coin_2, "#000000", 1)

	-- Create Image_1_3
	local Image_1_3 = GUI:Image_Create(Panel_1, "Image_1_3", 146.00, 170.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1_3, 52, 52, 10, 11)
	GUI:setContentSize(Image_1_3, 120, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_3, false)
	GUI:setTouchEnabled(Image_1_3, false)
	GUI:setTag(Image_1_3, -1)

	-- Create Text_remain
	local Text_remain = GUI:Text_Create(Image_1_3, "Text_remain", 60.00, 14.00, 12, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_remain, 0.50, 0.50)
	GUI:setTouchEnabled(Text_remain, false)
	GUI:setTag(Text_remain, -1)
	GUI:Text_enableOutline(Text_remain, "#000000", 1)

	-- Create Button_ref
	local Button_ref = GUI:Button_Create(Image_1_3, "Button_ref", 125.00, -4.00, "res/public/zhunxing.png")
	GUI:setContentSize(Button_ref, 46, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_ref, false)
	GUI:Button_setTitleText(Button_ref, "")
	GUI:Button_setTitleColor(Button_ref, "#ffffff")
	GUI:Button_setTitleFontSize(Button_ref, 14)
	GUI:Button_titleEnableOutline(Button_ref, "#000000", 1)
	GUI:setScaleX(Button_ref, 0.70)
	GUI:setScaleY(Button_ref, 0.70)
	GUI:setTouchEnabled(Button_ref, true)
	GUI:setTag(Button_ref, -1)
	GUI:setVisible(Button_ref, false)

	-- Create Image_1_4
	local Image_1_4 = GUI:Image_Create(Panel_1, "Image_1_4", 146.00, 134.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1_4, 52, 52, 10, 11)
	GUI:setContentSize(Image_1_4, 120, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_4, false)
	GUI:setTouchEnabled(Image_1_4, false)
	GUI:setTag(Image_1_4, -1)

	-- Create Text_have
	local Text_have = GUI:Text_Create(Image_1_4, "Text_have", 60.00, 14.00, 12, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_have, 0.50, 0.50)
	GUI:setTouchEnabled(Text_have, false)
	GUI:setTag(Text_have, -1)
	GUI:Text_enableOutline(Text_have, "#000000", 1)

	-- Create Image_1_5
	local Image_1_5 = GUI:Image_Create(Panel_1, "Image_1_5", 146.00, 100.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_1_5, 52, 52, 10, 11)
	GUI:setContentSize(Image_1_5, 120, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_5, false)
	GUI:setTouchEnabled(Image_1_5, false)
	GUI:setTag(Image_1_5, -1)

	-- Create Input_sell
	local Input_sell = GUI:TextInput_Create(Panel_1, "Input_sell", 148.00, 102.00, 116.00, 24.00, 12)
	GUI:TextInput_setInputMode(Input_sell, 2)
	GUI:TextInput_setString(Input_sell, "0")
	GUI:TextInput_setFontColor(Input_sell, "#ffffff")
	GUI:setTouchEnabled(Input_sell, true)
	GUI:setTag(Input_sell, -1)

	-- Create Button_confirm
	local Button_confirm = GUI:Button_Create(Panel_1, "Button_confirm", 178.00, 64.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_confirm, "res/public_win32/1900000661.png")
	GUI:Button_setTitleText(Button_confirm, "确认出售")
	GUI:Button_setTitleColor(Button_confirm, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_confirm, 14)
	GUI:Button_titleEnableOutline(Button_confirm, "#000000", 2)
	GUI:setAnchorPoint(Button_confirm, 0.50, 0.50)
	GUI:setTouchEnabled(Button_confirm, true)
	GUI:setTag(Button_confirm, -1)
end
return ui