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
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 329)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 303.00, 309.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_1, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setAnchorPoint(Image_1_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 98)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 303.00, 50.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_2, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_2, 606, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setAnchorPoint(Image_1_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 99)

	-- Create Panel_hide_filter
	local Panel_hide_filter = GUI:Layout_Create(Panel_1, "Panel_hide_filter", 0.00, 0.00, 606.00, 355.00, false)
	GUI:setTouchEnabled(Panel_hide_filter, true)
	GUI:setTag(Panel_hide_filter, 45)
	GUI:setVisible(Panel_hide_filter, false)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 606.00, 355.00, 606.00, 355.00, false)
	GUI:setAnchorPoint(Panel_items, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_items, false)
	GUI:setTag(Panel_items, 328)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_items, "Text_1", 30.00, 338.00, 12, "#ffffff", [[物品名称]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 100)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_items, "Text_1_0", 184.00, 338.00, 12, "#ffffff", [[数量]])
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 101)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_coin_type
	local Text_coin_type = GUI:Text_Create(Panel_items, "Text_coin_type", 500.00, 338.00, 12, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_coin_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_coin_type, false)
	GUI:setTag(Text_coin_type, 103)
	GUI:Text_enableOutline(Text_coin_type, "#000000", 1)

	-- Create Image_filter_c
	local Image_filter_c = GUI:Image_Create(Text_coin_type, "Image_filter_c", 34.00, 10.00, "res/public/btn_szjm_01_6.png")
	GUI:setAnchorPoint(Image_filter_c, 0.00, 0.50)
	GUI:setTouchEnabled(Image_filter_c, true)
	GUI:setTag(Image_filter_c, -1)

	-- Create Text_1_2_1
	local Text_1_2_1 = GUI:Text_Create(Panel_items, "Text_1_2_1", 260.00, 338.00, 12, "#ffffff", [[价格]])
	GUI:setAnchorPoint(Text_1_2_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2_1, false)
	GUI:setTag(Text_1_2_1, 103)
	GUI:Text_enableOutline(Text_1_2_1, "#000000", 1)

	-- Create Image_sort_s
	local Image_sort_s = GUI:Image_Create(Text_1_2_1, "Image_sort_s", 32.00, -2.00, "res/public/btn_szjm_01_3.png")
	GUI:setTouchEnabled(Image_sort_s, true)
	GUI:setTag(Image_sort_s, -1)

	-- Create Text_1_2_2
	local Text_1_2_2 = GUI:Text_Create(Panel_items, "Text_1_2_2", 348.00, 338.00, 12, "#ffffff", [[日期]])
	GUI:setAnchorPoint(Text_1_2_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2_2, false)
	GUI:setTag(Text_1_2_2, 103)
	GUI:Text_enableOutline(Text_1_2_2, "#000000", 1)

	-- Create Image_sort_t
	local Image_sort_t = GUI:Image_Create(Text_1_2_2, "Image_sort_t", 32.00, -2.00, "res/public/btn_szjm_01_3.png")
	GUI:setTouchEnabled(Image_sort_t, true)
	GUI:setTag(Image_sort_t, -1)
	GUI:setVisible(Image_sort_t, false)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_items, "ListView_items", 303.00, 48.00, 605.00, 260.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 334)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_items, "Image_empty", 320.00, 150.00, "res/private/auction/word_paimaihang_01.png")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 345)
	GUI:setVisible(Image_empty, false)

	-- Create Image_filter_bg
	local Image_filter_bg = GUI:Image_Create(Panel_items, "Image_filter_bg", 500.00, 324.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_filter_bg, 21, 21, 37, 29)
	GUI:setContentSize(Image_filter_bg, 105, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_filter_bg, false)
	GUI:setAnchorPoint(Image_filter_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_filter_bg, false)
	GUI:setTag(Image_filter_bg, 30)

	-- Create ListView_filter_c
	local ListView_filter_c = GUI:ListView_Create(Image_filter_bg, "ListView_filter_c", 52.00, 2.00, 100.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_filter_c, 5)
	GUI:setAnchorPoint(ListView_filter_c, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter_c, false)
	GUI:setTag(ListView_filter_c, 46)

	-- Create Text_states
	local Text_states = GUI:Text_Create(Panel_items, "Text_states", 420.00, 338.00, 12, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_states, 0.50, 0.50)
	GUI:setTouchEnabled(Text_states, false)
	GUI:setTag(Text_states, 105)
	GUI:Text_enableOutline(Text_states, "#000000", 1)

	-- Create Panel_bottom
	local Panel_bottom = GUI:Layout_Create(Panel_1, "Panel_bottom", 732.00, 0.00, 732.00, 48.00, false)
	GUI:setAnchorPoint(Panel_bottom, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_bottom, true)
	GUI:setTag(Panel_bottom, 360)
	GUI:setVisible(Panel_bottom, false)

	-- Create Button_home_page
	local Button_home_page = GUI:Button_Create(Panel_bottom, "Button_home_page", 256.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_home_page, "首页")
	GUI:Button_setTitleColor(Button_home_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_home_page, 16)
	GUI:Button_titleEnableOutline(Button_home_page, "#000000", 2)
	GUI:setAnchorPoint(Button_home_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_home_page, true)
	GUI:setTag(Button_home_page, -1)

	-- Create Button_last_page
	local Button_last_page = GUI:Button_Create(Panel_bottom, "Button_last_page", 376.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_last_page, "上一页")
	GUI:Button_setTitleColor(Button_last_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_last_page, 16)
	GUI:Button_titleEnableOutline(Button_last_page, "#000000", 2)
	GUI:setAnchorPoint(Button_last_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_last_page, true)
	GUI:setTag(Button_last_page, -1)

	-- Create Button_next_page
	local Button_next_page = GUI:Button_Create(Panel_bottom, "Button_next_page", 496.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_next_page, "下一页")
	GUI:Button_setTitleColor(Button_next_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_next_page, 16)
	GUI:Button_titleEnableOutline(Button_next_page, "#000000", 2)
	GUI:setAnchorPoint(Button_next_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_next_page, true)
	GUI:setTag(Button_next_page, -1)

	-- Create Button_end_page
	local Button_end_page = GUI:Button_Create(Panel_bottom, "Button_end_page", 616.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_end_page, "尾页")
	GUI:Button_setTitleColor(Button_end_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_end_page, 16)
	GUI:Button_titleEnableOutline(Button_end_page, "#000000", 2)
	GUI:setAnchorPoint(Button_end_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_end_page, true)
	GUI:setTag(Button_end_page, -1)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Panel_1, "Text_tips", 125.00, 21.00, 12, "#ffffff", [[出售/购买记录各记录最多为30条]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 400)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)
end
return ui