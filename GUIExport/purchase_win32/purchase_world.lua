local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 325)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 303.00, 355.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 329)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_1, "Image_1_0", 102.00, 35.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_0, 320, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setAnchorPoint(Image_1_0, 1.00, 1.00)
	GUI:setRotation(Image_1_0, 90.00)
	GUI:setRotationSkewX(Image_1_0, 90.00)
	GUI:setRotationSkewY(Image_1_0, 90.00)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 97)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 102.00, 336.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_1, 504, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setAnchorPoint(Image_1_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 98)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 303.00, 35.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_2, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_2, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setAnchorPoint(Image_1_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 99)

	-- Create Panel_filter_1
	local Panel_filter_1 = GUI:Layout_Create(Panel_1, "Panel_filter_1", 0.00, 35.00, 100.00, 320.00, false)
	GUI:setTouchEnabled(Panel_filter_1, true)
	GUI:setTag(Panel_filter_1, 326)

	-- Create ListView_filter_1
	local ListView_filter_1 = GUI:ListView_Create(Panel_filter_1, "ListView_filter_1", 50.00, 318.00, 100.00, 318.00, 1)
	GUI:ListView_setGravity(ListView_filter_1, 5)
	GUI:setAnchorPoint(ListView_filter_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_filter_1, true)
	GUI:setTag(ListView_filter_1, 327)

	-- Create Panel_hide_filter
	local Panel_hide_filter = GUI:Layout_Create(Panel_1, "Panel_hide_filter", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setTouchEnabled(Panel_hide_filter, true)
	GUI:setTag(Panel_hide_filter, 45)
	GUI:setVisible(Panel_hide_filter, false)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 606.00, 355.00, 505.00, 320.00, false)
	GUI:setAnchorPoint(Panel_items, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_items, false)
	GUI:setTag(Panel_items, 328)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_items, "Text_1", 54.00, 310.00, 12, "#ffffff", [[物品名称]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 100)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_items, "Text_1_0", 174.00, 310.00, 12, "#ffffff", [[求购数量]])
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 101)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_items, "Text_1_1", 236.00, 310.00, 12, "#ffffff", [[最小数量]])
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 102)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_coin_type
	local Text_coin_type = GUI:Text_Create(Panel_items, "Text_coin_type", 290.00, 310.00, 12, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_coin_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_coin_type, false)
	GUI:setTag(Text_coin_type, 103)
	GUI:Text_enableOutline(Text_coin_type, "#000000", 1)

	-- Create Image_filter_c
	local Image_filter_c = GUI:Image_Create(Text_coin_type, "Image_filter_c", 20.00, 10.00, "res/public/btn_szjm_01_6.png")
	GUI:setAnchorPoint(Image_filter_c, 0.00, 0.50)
	GUI:setTouchEnabled(Image_filter_c, true)
	GUI:setTag(Image_filter_c, -1)

	-- Create Text_1_2_1
	local Text_1_2_1 = GUI:Text_Create(Panel_items, "Text_1_2_1", 350.00, 310.00, 12, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_1_2_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2_1, false)
	GUI:setTag(Text_1_2_1, 103)
	GUI:Text_enableOutline(Text_1_2_1, "#000000", 1)

	-- Create Image_sort_s
	local Image_sort_s = GUI:Image_Create(Text_1_2_1, "Image_sort_s", 25.00, 0.00, "res/public/btn_szjm_01_3.png")
	GUI:setScaleX(Image_sort_s, 0.80)
	GUI:setScaleY(Image_sort_s, 0.80)
	GUI:setTouchEnabled(Image_sort_s, true)
	GUI:setTag(Image_sort_s, -1)

	-- Create Text_1_2_2
	local Text_1_2_2 = GUI:Text_Create(Panel_items, "Text_1_2_2", 405.00, 310.00, 12, "#ffffff", [[总价]])
	GUI:setAnchorPoint(Text_1_2_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2_2, false)
	GUI:setTag(Text_1_2_2, 103)
	GUI:Text_enableOutline(Text_1_2_2, "#000000", 1)

	-- Create Image_sort_t
	local Image_sort_t = GUI:Image_Create(Text_1_2_2, "Image_sort_t", 25.00, 0.00, "res/public/btn_szjm_01_3.png")
	GUI:setScaleX(Image_sort_t, 0.80)
	GUI:setScaleY(Image_sort_t, 0.80)
	GUI:setTouchEnabled(Image_sort_t, true)
	GUI:setTag(Image_sort_t, -1)

	-- Create Text_1_2_3
	local Text_1_2_3 = GUI:Text_Create(Panel_items, "Text_1_2_3", 465.00, 310.00, 12, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_1_2_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2_3, false)
	GUI:setTag(Text_1_2_3, 103)
	GUI:Text_enableOutline(Text_1_2_3, "#000000", 1)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_items, "ListView_items", 252.00, 0.00, 505.00, 299.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 334)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_items, "Image_empty", 252.00, 150.00, "res/private/auction-win32/word_paimaihang_01.png")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 345)

	-- Create Image_filter_bg
	local Image_filter_bg = GUI:Image_Create(Panel_items, "Image_filter_bg", 296.00, 300.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_filter_bg, 21, 21, 39, 27)
	GUI:setContentSize(Image_filter_bg, 80, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_filter_bg, false)
	GUI:setAnchorPoint(Image_filter_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_filter_bg, false)
	GUI:setTag(Image_filter_bg, 30)
	GUI:setVisible(Image_filter_bg, false)

	-- Create ListView_filter_c
	local ListView_filter_c = GUI:ListView_Create(Image_filter_bg, "ListView_filter_c", 40.00, 2.00, 76.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_filter_c, 5)
	GUI:setAnchorPoint(ListView_filter_c, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter_c, true)
	GUI:setTag(ListView_filter_c, 46)

	-- Create Panel_bottom
	local Panel_bottom = GUI:Layout_Create(Panel_1, "Panel_bottom", 606.00, 0.00, 606.00, 35.00, false)
	GUI:setAnchorPoint(Panel_bottom, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_bottom, true)
	GUI:setTag(Panel_bottom, 360)
	GUI:setVisible(Panel_bottom, false)

	-- Create Button_home_page
	local Button_home_page = GUI:Button_Create(Panel_bottom, "Button_home_page", 248.00, 3.00, "res/public_win32/1900000660.png")
	GUI:Button_setTitleText(Button_home_page, "首页")
	GUI:Button_setTitleColor(Button_home_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_home_page, 12)
	GUI:Button_titleEnableOutline(Button_home_page, "#000000", 2)
	GUI:setTouchEnabled(Button_home_page, true)
	GUI:setTag(Button_home_page, -1)

	-- Create Button_last_page
	local Button_last_page = GUI:Button_Create(Panel_bottom, "Button_last_page", 338.00, 3.00, "res/public_win32/1900000660.png")
	GUI:Button_setTitleText(Button_last_page, "上一页")
	GUI:Button_setTitleColor(Button_last_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_last_page, 12)
	GUI:Button_titleEnableOutline(Button_last_page, "#000000", 2)
	GUI:setTouchEnabled(Button_last_page, true)
	GUI:setTag(Button_last_page, -1)

	-- Create Button_next_page
	local Button_next_page = GUI:Button_Create(Panel_bottom, "Button_next_page", 428.00, 3.00, "res/public_win32/1900000660.png")
	GUI:Button_setTitleText(Button_next_page, "下一页")
	GUI:Button_setTitleColor(Button_next_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_next_page, 12)
	GUI:Button_titleEnableOutline(Button_next_page, "#000000", 2)
	GUI:setTouchEnabled(Button_next_page, true)
	GUI:setTag(Button_next_page, -1)

	-- Create Button_end_page
	local Button_end_page = GUI:Button_Create(Panel_bottom, "Button_end_page", 518.00, 3.00, "res/public_win32/1900000660.png")
	GUI:Button_setTitleText(Button_end_page, "尾页")
	GUI:Button_setTitleColor(Button_end_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_end_page, 12)
	GUI:Button_titleEnableOutline(Button_end_page, "#000000", 2)
	GUI:setTouchEnabled(Button_end_page, true)
	GUI:setTag(Button_end_page, -1)
end
return ui