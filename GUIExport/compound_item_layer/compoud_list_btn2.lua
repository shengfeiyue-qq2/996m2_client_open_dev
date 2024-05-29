local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 177.00, 39.00, false)
	GUI:setChineseName(Panel_1, "系统合成_二级按钮组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create Button_type2
	local Button_type2 = GUI:Button_Create(Panel_1, "Button_type2", 88.00, 19.00, "res/private/compound_items_ui/1900000663_2.png")
	GUI:Button_loadTexturePressed(Button_type2, "res/private/compound_items_ui/1900000663_1.png")
	GUI:Button_loadTextureDisabled(Button_type2, "res/private/compound_items_ui/1900000663_1.png")
	GUI:Button_setScale9Slice(Button_type2, 15, 15, 11, 11)
	GUI:setContentSize(Button_type2, 174, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_type2, false)
	GUI:Button_setTitleText(Button_type2, "")
	GUI:Button_setTitleColor(Button_type2, "#6c6861")
	GUI:Button_setTitleFontSize(Button_type2, 18)
	GUI:Button_titleEnableOutline(Button_type2, "#111111", 2)
	GUI:setChineseName(Button_type2, "系统合成_二级按钮")
	GUI:setAnchorPoint(Button_type2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_type2, true)
	GUI:setTag(Button_type2, 38)

	-- Create Image_red
	local Image_red = GUI:Image_Create(Panel_1, "Image_red", 166.00, 29.00, "res/public/btn_npcfh_04.png")
	GUI:setChineseName(Image_red, "系统合成_二级按钮_红点")
	GUI:setAnchorPoint(Image_red, 0.50, 0.50)
	GUI:setTouchEnabled(Image_red, false)
	GUI:setTag(Image_red, 44)
	GUI:setVisible(Image_red, false)

	-- Create Image_opened
	local Image_opened = GUI:Image_Create(Panel_1, "Image_opened", 25.00, 18.00, "res/private/compound_items_ui/btn_szjm_01_6.png")
	GUI:setChineseName(Image_opened, "系统合成_二级按钮_折叠图")
	GUI:setAnchorPoint(Image_opened, 0.50, 0.50)
	GUI:setRotation(Image_opened, 90.00)
	GUI:setRotationSkewX(Image_opened, 90.00)
	GUI:setRotationSkewY(Image_opened, 90.00)
	GUI:setTouchEnabled(Image_opened, false)
	GUI:setTag(Image_opened, 46)
end
return ui