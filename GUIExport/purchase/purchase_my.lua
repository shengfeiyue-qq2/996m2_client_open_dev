local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 732.00, 410.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 325)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 366.00, 408.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1, 732, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 329)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_1, "Image_1_0", 127.00, 228.00, "res/public/bg_yyxsz_01.png")
	GUI:setContentSize(Image_1_0, 356, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setAnchorPoint(Image_1_0, 0.50, 1.00)
	GUI:setRotation(Image_1_0, 90.00)
	GUI:setRotationSkewX(Image_1_0, 90.00)
	GUI:setRotationSkewY(Image_1_0, 90.00)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 97)

	-- Create Image_1_1
	local Image_1_1 = GUI:Image_Create(Panel_1, "Image_1_1", 429.00, 365.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_1, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_1, 605, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_1, false)
	GUI:setAnchorPoint(Image_1_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_1, false)
	GUI:setTag(Image_1_1, 98)

	-- Create Image_1_2
	local Image_1_2 = GUI:Image_Create(Panel_1, "Image_1_2", 366.00, 50.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_2, 93, 93, 0, 0)
	GUI:setContentSize(Image_1_2, 732, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_2, false)
	GUI:setAnchorPoint(Image_1_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_2, false)
	GUI:setTag(Image_1_2, 99)

	-- Create Panel_filter_1
	local Panel_filter_1 = GUI:Layout_Create(Panel_1, "Panel_filter_1", 0.00, 50.00, 125.00, 355.00, false)
	GUI:setTouchEnabled(Panel_filter_1, true)
	GUI:setTag(Panel_filter_1, 326)

	-- Create ListView_filter_1
	local ListView_filter_1 = GUI:ListView_Create(Panel_filter_1, "ListView_filter_1", 62.00, 355.00, 125.00, 355.00, 1)
	GUI:ListView_setGravity(ListView_filter_1, 5)
	GUI:setAnchorPoint(ListView_filter_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_filter_1, true)
	GUI:setTag(ListView_filter_1, 327)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 732.00, 405.00, 605.00, 355.00, false)
	GUI:setAnchorPoint(Panel_items, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_items, false)
	GUI:setTag(Panel_items, 328)

	-- Create Panel_title_1
	local Panel_title_1 = GUI:Layout_Create(Panel_items, "Panel_title_1", 605.00, 357.00, 605.00, 42.00, false)
	GUI:setAnchorPoint(Panel_title_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_title_1, false)
	GUI:setTag(Panel_title_1, 328)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_title_1, "Text_1", 69.00, 23.00, 16, "#ffffff", [[物品名称]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 100)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_title_1, "Text_2", 214.00, 23.00, 16, "#ffffff", [[剩余数量]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 101)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_title_1, "Text_3", 288.00, 23.00, 16, "#ffffff", [[最小数量]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 102)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_title_1, "Text_4", 350.00, 23.00, 16, "#ffffff", [[货币]])
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 103)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_title_1, "Text_5", 405.00, 23.00, 16, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 103)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Text_5_1
	local Text_5_1 = GUI:Text_Create(Panel_title_1, "Text_5_1", 485.00, 23.00, 16, "#ffffff", [[剩余总价]])
	GUI:setAnchorPoint(Text_5_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5_1, false)
	GUI:setTag(Text_5_1, 103)
	GUI:Text_enableOutline(Text_5_1, "#000000", 1)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_title_1, "Text_6", 562.00, 23.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 103)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Panel_title_2
	local Panel_title_2 = GUI:Layout_Create(Panel_items, "Panel_title_2", 605.00, 357.00, 605.00, 42.00, false)
	GUI:setAnchorPoint(Panel_title_2, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_title_2, false)
	GUI:setTag(Panel_title_2, 328)
	GUI:setVisible(Panel_title_2, false)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_title_2, "Text_1", 69.00, 23.00, 16, "#ffffff", [[物品名称]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 100)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_title_2, "Text_2", 228.00, 23.00, 16, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 101)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_title_2, "Text_3", 310.00, 23.00, 16, "#ffffff", [[单位]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 102)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_title_2, "Text_4", 388.00, 23.00, 16, "#ffffff", [[剩余数量]])
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 103)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_title_2, "Text_5", 476.00, 23.00, 16, "#ffffff", [[待提取数量]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 103)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_title_2, "Text_6", 562.00, 23.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 103)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create ListView_items
	local ListView_items = GUI:ListView_Create(Panel_items, "ListView_items", 302.00, 0.00, 605.00, 313.00, 1)
	GUI:ListView_setGravity(ListView_items, 5)
	GUI:setAnchorPoint(ListView_items, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_items, true)
	GUI:setTag(ListView_items, 334)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Panel_items, "Image_empty", 302.00, 150.00, "res/private/auction/word_paimaihang_01.png")
	GUI:setAnchorPoint(Image_empty, 0.50, 0.50)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, 345)

	-- Create Panel_bottom
	local Panel_bottom = GUI:Layout_Create(Panel_1, "Panel_bottom", 732.00, 0.00, 732.00, 48.00, false)
	GUI:setAnchorPoint(Panel_bottom, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_bottom, true)
	GUI:setTag(Panel_bottom, 360)

	-- Create Button_last_page
	local Button_last_page = GUI:Button_Create(Panel_bottom, "Button_last_page", 182.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_last_page, "上一页")
	GUI:Button_setTitleColor(Button_last_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_last_page, 16)
	GUI:Button_titleEnableOutline(Button_last_page, "#000000", 2)
	GUI:setAnchorPoint(Button_last_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_last_page, true)
	GUI:setTag(Button_last_page, -1)
	GUI:setVisible(Button_last_page, false)

	-- Create Button_next_page
	local Button_next_page = GUI:Button_Create(Panel_bottom, "Button_next_page", 302.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_next_page, "下一页")
	GUI:Button_setTitleColor(Button_next_page, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_next_page, 16)
	GUI:Button_titleEnableOutline(Button_next_page, "#000000", 2)
	GUI:setAnchorPoint(Button_next_page, 0.00, 0.50)
	GUI:setTouchEnabled(Button_next_page, true)
	GUI:setTag(Button_next_page, -1)
	GUI:setVisible(Button_next_page, false)

	-- Create Button_take_out
	local Button_take_out = GUI:Button_Create(Panel_bottom, "Button_take_out", 616.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_take_out, "全部取出")
	GUI:Button_setTitleColor(Button_take_out, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_take_out, 16)
	GUI:Button_titleEnableOutline(Button_take_out, "#000000", 2)
	GUI:setAnchorPoint(Button_take_out, 0.00, 0.50)
	GUI:setTouchEnabled(Button_take_out, true)
	GUI:setTag(Button_take_out, -1)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_bottom, "Button_cancel", 500.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_cancel, "全部取消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 16)
	GUI:Button_titleEnableOutline(Button_cancel, "#000000", 2)
	GUI:setAnchorPoint(Button_cancel, 0.00, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, -1)
	GUI:setVisible(Button_cancel, false)

	-- Create Button_purchase
	local Button_purchase = GUI:Button_Create(Panel_bottom, "Button_purchase", 616.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_purchase, "我要求购")
	GUI:Button_setTitleColor(Button_purchase, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_purchase, 16)
	GUI:Button_titleEnableOutline(Button_purchase, "#000000", 2)
	GUI:setAnchorPoint(Button_purchase, 0.00, 0.50)
	GUI:setTouchEnabled(Button_purchase, true)
	GUI:setTag(Button_purchase, -1)
	GUI:setVisible(Button_purchase, false)
end
return ui