local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "商店场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 591.00, 330.00, 311.00, false)
	GUI:setChineseName(Panel_1, "商店物品组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 38)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 1.00, 310.00, "res/public_win32/bg_bbgm_01.png")
	GUI:setChineseName(Image_bg, "商店_售卖物品_背景图")
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 39)

	-- Create ListView_list
	local ListView_list = GUI:ListView_Create(Panel_1, "ListView_list", 15.00, 294.00, 299.00, 208.00, 1)
	GUI:ListView_setGravity(ListView_list, 5)
	GUI:setChineseName(ListView_list, "商店_售卖物品_列表")
	GUI:setAnchorPoint(ListView_list, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_list, true)
	GUI:setTag(ListView_list, 43)

	-- Create Button_last
	local Button_last = GUI:Button_Create(Panel_1, "Button_last", 53.00, 49.00, "res/public_win32/1900000690.png")
	GUI:Button_loadTexturePressed(Button_last, "res/public_win32/1900000690_1.png")
	GUI:Button_loadTextureDisabled(Button_last, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_last, 15, 15, 12, 10)
	GUI:setContentSize(Button_last, 48, 48)
	GUI:setIgnoreContentAdaptWithSize(Button_last, false)
	GUI:Button_setTitleText(Button_last, "")
	GUI:Button_setTitleColor(Button_last, "#414146")
	GUI:Button_setTitleFontSize(Button_last, 14)
	GUI:Button_titleDisableOutLine(Button_last)
	GUI:setChineseName(Button_last, "商店_上一页_按钮")
	GUI:setAnchorPoint(Button_last, 0.50, 0.50)
	GUI:setTouchEnabled(Button_last, true)
	GUI:setTag(Button_last, 68)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_last, "TouchSize", -2.00, 49.00, 50.00, 50.00, false)
	GUI:setChineseName(TouchSize, "商店_上一页_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 69)
	GUI:setVisible(TouchSize, false)

	-- Create Button_next
	local Button_next = GUI:Button_Create(Panel_1, "Button_next", 148.00, 49.00, "res/public_win32/1900000691.png")
	GUI:Button_loadTexturePressed(Button_next, "res/public_win32/1900000691_1.png")
	GUI:Button_setScale9Slice(Button_next, 15, 15, 4, 4)
	GUI:setContentSize(Button_next, 48, 48)
	GUI:setIgnoreContentAdaptWithSize(Button_next, false)
	GUI:Button_setTitleText(Button_next, "")
	GUI:Button_setTitleColor(Button_next, "#414146")
	GUI:Button_setTitleFontSize(Button_next, 14)
	GUI:Button_titleDisableOutLine(Button_next)
	GUI:setChineseName(Button_next, "商店_下一页_按钮")
	GUI:setAnchorPoint(Button_next, 0.50, 0.50)
	GUI:setTouchEnabled(Button_next, true)
	GUI:setTag(Button_next, 46)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_next, "TouchSize", -14.00, 36.00, 50.00, 50.00, false)
	GUI:setChineseName(TouchSize, "商店_下一页_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 47)
	GUI:setVisible(TouchSize, false)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(Panel_1, "Button_ok", 263.00, 49.00, "res/public_win32/btn_bbgm_01.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public_win32/btn_bbgm_02.png")
	GUI:Button_setScale9Slice(Button_ok, 15, 15, 6, 2)
	GUI:setContentSize(Button_ok, 71, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "")
	GUI:Button_setTitleColor(Button_ok, "#414146")
	GUI:Button_setTitleFontSize(Button_ok, 14)
	GUI:Button_titleDisableOutLine(Button_ok)
	GUI:setChineseName(Button_ok, "商店_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 48)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 341.00, 295.00, "res/public/btn_normal_2.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/btn_pressed_2.png")
	GUI:Button_loadTextureDisabled(Button_close, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "商店_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 49)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.00, 30.00, 50.00, 50.00, false)
	GUI:setChineseName(TouchSize, "商店_关闭_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 50)
	GUI:setVisible(TouchSize, false)

	-- Create Text_pages
	local Text_pages = GUI:Text_Create(Panel_1, "Text_pages", 98.00, 50.00, 20, "#ffffff", [[1/1]])
	GUI:setChineseName(Text_pages, "商店_页码_文本")
	GUI:setAnchorPoint(Text_pages, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pages, false)
	GUI:setTag(Text_pages, 70)
	GUI:Text_enableOutline(Text_pages, "#000000", 1)

	-- Create Panel_customize
	local Panel_customize = GUI:Layout_Create(Scene, "Panel_customize", -436.00, -211.00, 200.00, 200.00, false)
	GUI:setChineseName(Panel_customize, "物品详细分组")
	GUI:setTouchEnabled(Panel_customize, true)
	GUI:setTag(Panel_customize, 71)
	GUI:setVisible(Panel_customize, false)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_customize, "Panel_item", 0.00, 156.00, 299.00, 52.00, false)
	GUI:setChineseName(Panel_item, "物品信息分组")
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 72)

	-- Create Panel_item1
	local Panel_item1 = GUI:Layout_Create(Panel_item, "Panel_item1", 0.00, 0.00, 149.00, 52.00, false)
	GUI:setChineseName(Panel_item1, "商店物品分组(左)")
	GUI:setTouchEnabled(Panel_item1, true)
	GUI:setTag(Panel_item1, 73)
	GUI:setVisible(Panel_item1, false)

	-- Create Image_item_bg
	local Image_item_bg = GUI:Image_Create(Panel_item1, "Image_item_bg", 0.00, 26.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_item_bg, 13, 13, 6, 6)
	GUI:setContentSize(Image_item_bg, 149, 51)
	GUI:setIgnoreContentAdaptWithSize(Image_item_bg, false)
	GUI:setChineseName(Image_item_bg, "商店物品左_背景图")
	GUI:setAnchorPoint(Image_item_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_item_bg, true)
	GUI:setTag(Image_item_bg, 74)

	-- Create Image_icon_bg
	local Image_icon_bg = GUI:Image_Create(Panel_item1, "Image_icon_bg", 27.00, 27.00, "res/public_win32/bg_daoju_00.png")
	GUI:setContentSize(Image_icon_bg, 44, 44)
	GUI:setIgnoreContentAdaptWithSize(Image_icon_bg, false)
	GUI:setChineseName(Image_icon_bg, "商店物品左_物品图标_背景")
	GUI:setAnchorPoint(Image_icon_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon_bg, false)
	GUI:setTag(Image_icon_bg, 75)

	-- Create Text_item_name
	local Text_item_name = GUI:Text_Create(Panel_item1, "Text_item_name", 52.00, 37.00, 14, "#ffffff", [[]])
	GUI:setChineseName(Text_item_name, "商店物品左_名称_文本")
	GUI:setAnchorPoint(Text_item_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_item_name, false)
	GUI:setTag(Text_item_name, 76)
	GUI:Text_enableOutline(Text_item_name, "#000000", 1)

	-- Create Text_item_price
	local Text_item_price = GUI:Text_Create(Panel_item1, "Text_item_price", 51.00, 17.00, 14, "#ffffff", [[]])
	GUI:setChineseName(Text_item_price, "商店物品左_图片")
	GUI:setAnchorPoint(Text_item_price, 0.00, 0.50)
	GUI:setTouchEnabled(Text_item_price, false)
	GUI:setTag(Text_item_price, 77)
	GUI:Text_enableOutline(Text_item_price, "#000000", 1)

	-- Create Panel_item2
	local Panel_item2 = GUI:Layout_Create(Panel_item, "Panel_item2", 150.00, 0.00, 149.00, 52.00, false)
	GUI:setChineseName(Panel_item2, "商店物品分组(右)")
	GUI:setTouchEnabled(Panel_item2, true)
	GUI:setTag(Panel_item2, 83)
	GUI:setVisible(Panel_item2, false)

	-- Create Image_item_bg
	local Image_item_bg = GUI:Image_Create(Panel_item2, "Image_item_bg", 0.00, 26.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_item_bg, 13, 13, 6, 6)
	GUI:setContentSize(Image_item_bg, 149, 51)
	GUI:setIgnoreContentAdaptWithSize(Image_item_bg, false)
	GUI:setChineseName(Image_item_bg, "商店物品右_背景图")
	GUI:setAnchorPoint(Image_item_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_item_bg, true)
	GUI:setTag(Image_item_bg, 84)

	-- Create Image_icon_bg
	local Image_icon_bg = GUI:Image_Create(Panel_item2, "Image_icon_bg", 27.00, 27.00, "res/public_win32/bg_daoju_00.png")
	GUI:setContentSize(Image_icon_bg, 44, 44)
	GUI:setIgnoreContentAdaptWithSize(Image_icon_bg, false)
	GUI:setChineseName(Image_icon_bg, "商店物品右_物品图标_背景")
	GUI:setAnchorPoint(Image_icon_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon_bg, false)
	GUI:setTag(Image_icon_bg, 85)

	-- Create Text_item_name
	local Text_item_name = GUI:Text_Create(Panel_item2, "Text_item_name", 52.00, 37.00, 14, "#ffffff", [[]])
	GUI:setChineseName(Text_item_name, "商店物品右_名称_文本")
	GUI:setAnchorPoint(Text_item_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_item_name, false)
	GUI:setTag(Text_item_name, 86)
	GUI:Text_enableOutline(Text_item_name, "#000000", 1)

	-- Create Text_item_price
	local Text_item_price = GUI:Text_Create(Panel_item2, "Text_item_price", 51.00, 17.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_item_price, "商店物品右_图片")
	GUI:setAnchorPoint(Text_item_price, 0.00, 0.50)
	GUI:setTouchEnabled(Text_item_price, false)
	GUI:setTag(Text_item_price, 87)
	GUI:Text_enableOutline(Text_item_price, "#000000", 1)
end
return ui