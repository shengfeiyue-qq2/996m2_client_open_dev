local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "附近对象场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 420.00, 200.00, 200.00, false)
	GUI:setChineseName(Panel_1, "附近对象组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 196)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 100.00, 200.00, "res/private/main/assist/near_panel/title_bg.png")
	GUI:setChineseName(Image_1, "附近对象_类型_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 198)

	-- Create Panel_title
	local Panel_title = GUI:Layout_Create(Panel_1, "Panel_title", 0.00, 200.00, 200.00, 29.00, false)
	GUI:setChineseName(Panel_title, "附近对象_标题组合")
	GUI:setAnchorPoint(Panel_title, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_title, false)
	GUI:setTag(Panel_title, 199)

	-- Create ListView_title
	local ListView_title = GUI:ListView_Create(Panel_title, "ListView_title", 100.00, 0.00, 200.00, 29.00, 2)
	GUI:ListView_setGravity(ListView_title, 5)
	GUI:setChineseName(ListView_title, "附近对象_对象列表")
	GUI:setAnchorPoint(ListView_title, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_title, false)
	GUI:setTag(ListView_title, 202)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Panel_1, "Panel_bg", 0.00, 0.00, 200.00, 171.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_bg, 66, 66, 58, 68)
	GUI:Layout_setBackGroundImage(Panel_bg, "res/private/main/assist/near_panel/show_bg.png")
	GUI:setChineseName(Panel_bg, "附近对象_背景")
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, 197)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_bg, "ListView_1", 0.00, 0.00, 200.00, 171.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setChineseName(ListView_1, "附近对象_对象_列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 200)

	-- Create Panel_can_touch
	local Panel_can_touch = GUI:Layout_Create(Panel_1, "Panel_can_touch", 0.00, -10.00, 200.00, 20.00, false)
	GUI:setChineseName(Panel_can_touch, "附近对象_是否_触摸")
	GUI:setTouchEnabled(Panel_can_touch, true)
	GUI:setTag(Panel_can_touch, 203)

	-- Create Button_type2
	local Button_type2 = GUI:Button_Create(Panel_1, "Button_type2", 0.00, 0.00, "res/private/main/assist/near_panel/type_2_1.png")
	GUI:Button_loadTexturePressed(Button_type2, "res/private/main/assist/near_panel/type_2_2.png")
	GUI:Button_loadTextureDisabled(Button_type2, "res/private/main/assist/near_panel/type_2_2.png")
	GUI:Button_setScale9Slice(Button_type2, 15, 15, 11, 11)
	GUI:setContentSize(Button_type2, 97, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_type2, false)
	GUI:Button_setTitleText(Button_type2, "")
	GUI:Button_setTitleColor(Button_type2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_type2, 14)
	GUI:Button_titleEnableOutline(Button_type2, "#000000", 1)
	GUI:setChineseName(Button_type2, "附近对象_类型_按钮")
	GUI:setAnchorPoint(Button_type2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_type2, true)
	GUI:setTag(Button_type2, 201)
	GUI:setVisible(Button_type2, false)

	-- Create Button_type3
	local Button_type3 = GUI:Button_Create(Panel_1, "Button_type3", 6.00, -29.00, "res/private/main/assist/near_panel/type_3_1.png")
	GUI:Button_loadTexturePressed(Button_type3, "res/private/main/assist/near_panel/type_3_2.png")
	GUI:Button_loadTextureDisabled(Button_type3, "res/private/main/assist/near_panel/type_3_2.png")
	GUI:Button_setScale9Slice(Button_type3, 21, 21, 8, 7)
	GUI:setContentSize(Button_type3, 63, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_type3, false)
	GUI:Button_setTitleText(Button_type3, "")
	GUI:Button_setTitleColor(Button_type3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_type3, 14)
	GUI:Button_titleEnableOutline(Button_type3, "#000000", 1)
	GUI:setChineseName(Button_type3, "附近对象_类型_按钮")
	GUI:setAnchorPoint(Button_type3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_type3, true)
	GUI:setTag(Button_type3, 201)
	GUI:setVisible(Button_type3, false)
end
return ui