local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 76)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 645.00, 460.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public_win32/1900000610.png")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", 17.00, 443.00, "res/public_win32/1900000610_1.png")
	GUI:setAnchorPoint(DressIMG, 0.50, 0.50)
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 23.00, 437.00, 14, "#d8c8ae", [[我要求购]])
	GUI:setAnchorPoint(TitleText, 0.00, 0.50)
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 640.00, 414.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(FrameLayout, "PMainUI", 322.00, 222.00, 608.00, 391.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 6)

	-- Create Panel_search
	local Panel_search = GUI:Layout_Create(PMainUI, "Panel_search", 236.00, 356.00, 220.00, 35.00, false)
	GUI:setAnchorPoint(Panel_search, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_search, true)
	GUI:setTag(Panel_search, 94)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_search, "Image_1", 20.00, 17.00, "res/public/btn_szjm_02.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 95)

	-- Create ImageView
	local ImageView = GUI:Image_Create(Panel_search, "ImageView", 38.00, 17.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(ImageView, 52, 52, 12, 8)
	GUI:setContentSize(ImageView, 104, 28)
	GUI:setIgnoreContentAdaptWithSize(ImageView, false)
	GUI:setAnchorPoint(ImageView, 0.00, 0.50)
	GUI:setTouchEnabled(ImageView, false)
	GUI:setTag(ImageView, -1)

	-- Create SearchInput
	local SearchInput = GUI:TextInput_Create(Panel_search, "SearchInput", 40.00, 17.00, 100.00, 20.00, 12)
	GUI:TextInput_setString(SearchInput, "")
	GUI:TextInput_setPlaceHolder(SearchInput, "请输入物品名")
	GUI:TextInput_setFontColor(SearchInput, "#ffffff")
	GUI:TextInput_setMaxLength(SearchInput, 10)
	GUI:setAnchorPoint(SearchInput, 0.00, 0.50)
	GUI:setTouchEnabled(SearchInput, true)
	GUI:setTag(SearchInput, 93)

	-- Create Button_confirm
	local Button_confirm = GUI:Button_Create(Panel_search, "Button_confirm", 190.00, 17.00, "res/public/btn_fanye_03.png")
	GUI:Button_loadTexturePressed(Button_confirm, "res/public/btn_fanye_03_1.png")
	GUI:Button_loadTextureDisabled(Button_confirm, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_confirm, 15, 15, 12, 10)
	GUI:setContentSize(Button_confirm, 63, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_confirm, false)
	GUI:Button_setTitleText(Button_confirm, "搜索")
	GUI:Button_setTitleColor(Button_confirm, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_confirm, 12)
	GUI:Button_titleEnableOutline(Button_confirm, "#111111", 2)
	GUI:setAnchorPoint(Button_confirm, 0.50, 0.50)
	GUI:setTouchEnabled(Button_confirm, true)
	GUI:setTag(Button_confirm, 96)

	-- Create ListView_filter_1
	local ListView_filter_1 = GUI:ListView_Create(PMainUI, "ListView_filter_1", 50.00, 354.00, 100.00, 354.00, 1)
	GUI:ListView_setBackGroundImage(ListView_filter_1, "res/public/1900000610799.png")
	GUI:ListView_setBackGroundImageScale9Slice(ListView_filter_1, 0, 205, 0, 410)
	GUI:ListView_setGravity(ListView_filter_1, 5)
	GUI:setAnchorPoint(ListView_filter_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_filter_1, true)
	GUI:setTag(ListView_filter_1, -1)

	-- Create ListView_filter_2
	local ListView_filter_2 = GUI:ListView_Create(PMainUI, "ListView_filter_2", 156.00, 354.00, 100.00, 354.00, 1)
	GUI:ListView_setBackGroundImage(ListView_filter_2, "res/public/1900000610799.png")
	GUI:ListView_setBackGroundImageScale9Slice(ListView_filter_2, 0, 205, 0, 410)
	GUI:ListView_setGravity(ListView_filter_2, 5)
	GUI:setAnchorPoint(ListView_filter_2, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_filter_2, true)
	GUI:setTag(ListView_filter_2, -1)

	-- Create Layout_item
	local Layout_item = GUI:Layout_Create(PMainUI, "Layout_item", 212.00, 354.00, 160.00, 354.00, false)
	GUI:Layout_setBackGroundImage(Layout_item, "res/public/1900000610799.png")
	GUI:Layout_setBackGroundImageScale9Slice(Layout_item, 0, 205, 0, 410)
	GUI:setAnchorPoint(Layout_item, 0.00, 1.00)
	GUI:setTouchEnabled(Layout_item, false)
	GUI:setTag(Layout_item, -1)

	-- Create Panel_hide_filter
	local Panel_hide_filter = GUI:Layout_Create(PMainUI, "Panel_hide_filter", 0.00, 0.00, 608.00, 392.00, false)
	GUI:setTouchEnabled(Panel_hide_filter, true)
	GUI:setTag(Panel_hide_filter, 45)
	GUI:setVisible(Panel_hide_filter, false)

	-- Create Layout_param
	local Layout_param = GUI:Layout_Create(PMainUI, "Layout_param", 376.00, 354.00, 230.00, 354.00, false)
	GUI:setAnchorPoint(Layout_param, 0.00, 1.00)
	GUI:setTouchEnabled(Layout_param, false)
	GUI:setTag(Layout_param, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Layout_param, "Text_1", 3.00, 334.00, 12, "#ffffff", [[求购配置：]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Layout_param, "Text_2", 17.00, 308.00, 12, "#ffffff", [[物品名称：]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_2, "Image_bg", 63.00, -4.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Layout_param, "Text_3", 17.00, 282.00, 12, "#ffffff", [[货币类型：]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Panel_currency
	local Panel_currency = GUI:Layout_Create(Layout_param, "Panel_currency", 81.00, 283.00, 90.00, 20.00, false)
	GUI:Layout_setBackGroundImage(Panel_currency, "res/public/1900000676.png")
	GUI:Layout_setBackGroundImageScale9Slice(Panel_currency, 0, 73, 0, 31)
	GUI:setTouchEnabled(Panel_currency, true)
	GUI:setTag(Panel_currency, -1)

	-- Create Text_coin_type
	local Text_coin_type = GUI:Text_Create(Panel_currency, "Text_coin_type", 6.00, 8.00, 12, "#ffffff", [[元宝]])
	GUI:setAnchorPoint(Text_coin_type, 0.00, 0.50)
	GUI:setTouchEnabled(Text_coin_type, false)
	GUI:setTag(Text_coin_type, 103)
	GUI:Text_enableOutline(Text_coin_type, "#000000", 1)

	-- Create Image_filter_c
	local Image_filter_c = GUI:Image_Create(Text_coin_type, "Image_filter_c", 52.00, 10.00, "res/public/btn_szjm_01_6.png")
	GUI:setAnchorPoint(Image_filter_c, 0.00, 0.50)
	GUI:setTouchEnabled(Image_filter_c, true)
	GUI:setTag(Image_filter_c, -1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Layout_param, "Text_4", 17.00, 258.00, 12, "#ffffff", [[求购单价：]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_4, "Image_bg", 63.00, -4.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Input_single
	local Input_single = GUI:TextInput_Create(Text_4, "Input_single", 66.00, -1.00, 146.00, 22.00, 16)
	GUI:TextInput_setString(Input_single, "")
	GUI:TextInput_setFontColor(Input_single, "#ffffff")
	GUI:setTouchEnabled(Input_single, true)
	GUI:setTag(Input_single, -1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Layout_param, "Text_5", 17.00, 232.00, 12, "#ffffff", [[求购数量：]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_5, "Image_bg", 63.00, -6.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Input_num
	local Input_num = GUI:TextInput_Create(Text_5, "Input_num", 66.00, -3.00, 146.00, 22.00, 16)
	GUI:TextInput_setString(Input_num, "")
	GUI:TextInput_setFontColor(Input_num, "#ffffff")
	GUI:setTouchEnabled(Input_num, true)
	GUI:setTag(Input_num, -1)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Layout_param, "Text_6", 17.00, 204.00, 12, "#ffffff", [[最小数量：]])
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, -1)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_6, "Image_bg", 63.00, -6.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Input_min_num
	local Input_min_num = GUI:TextInput_Create(Text_6, "Input_min_num", 66.00, -3.00, 146.00, 22.00, 16)
	GUI:TextInput_setString(Input_min_num, "")
	GUI:TextInput_setFontColor(Input_min_num, "#ffffff")
	GUI:setTouchEnabled(Input_min_num, true)
	GUI:setTag(Input_min_num, -1)

	-- Create Text_2_1
	local Text_2_1 = GUI:Text_Create(Layout_param, "Text_2_1", 2.00, 170.00, 12, "#ffffff", [[物品信息：]])
	GUI:setTouchEnabled(Text_2_1, false)
	GUI:setTag(Text_2_1, -1)
	GUI:Text_enableOutline(Text_2_1, "#000000", 1)

	-- Create Text_2_2
	local Text_2_2 = GUI:Text_Create(Layout_param, "Text_2_2", 16.00, 140.00, 12, "#ffffff", [[物品底价：]])
	GUI:setTouchEnabled(Text_2_2, false)
	GUI:setTag(Text_2_2, -1)
	GUI:Text_enableOutline(Text_2_2, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_2_2, "Image_bg", 63.00, -5.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_price_base
	local Text_price_base = GUI:Text_Create(Text_2_2, "Text_price_base", 72.00, 1.00, 12, "#ffffff", [[-]])
	GUI:setTouchEnabled(Text_price_base, false)
	GUI:setTag(Text_price_base, -1)
	GUI:Text_enableOutline(Text_price_base, "#000000", 1)

	-- Create Text_2_3
	local Text_2_3 = GUI:Text_Create(Layout_param, "Text_2_3", 16.00, 108.00, 12, "#ffffff", [[物品总价：]])
	GUI:setTouchEnabled(Text_2_3, false)
	GUI:setTag(Text_2_3, -1)
	GUI:Text_enableOutline(Text_2_3, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_2_3, "Image_bg", 63.00, -5.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_price_total
	local Text_price_total = GUI:Text_Create(Text_2_3, "Text_price_total", 72.00, 1.00, 12, "#ffffff", [[-]])
	GUI:setTouchEnabled(Text_price_total, false)
	GUI:setTag(Text_price_total, -1)
	GUI:Text_enableOutline(Text_price_total, "#000000", 1)

	-- Create Text_2_4
	local Text_2_4 = GUI:Text_Create(Layout_param, "Text_2_4", 16.00, 76.00, 12, "#ffffff", [[货币数量：]])
	GUI:setTouchEnabled(Text_2_4, false)
	GUI:setTag(Text_2_4, -1)
	GUI:Text_enableOutline(Text_2_4, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Text_2_4, "Image_bg", 63.00, -5.00, "res/public/1900000676.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 25, 10, 11)
	GUI:setContentSize(Image_bg, 150, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_coin_num
	local Text_coin_num = GUI:Text_Create(Text_2_4, "Text_coin_num", 72.00, 1.00, 12, "#ffffff", [[-]])
	GUI:setTouchEnabled(Text_coin_num, false)
	GUI:setTag(Text_coin_num, -1)
	GUI:Text_enableOutline(Text_coin_num, "#000000", 1)

	-- Create Text_item_name
	local Text_item_name = GUI:Text_Create(Layout_param, "Text_item_name", 88.00, 310.00, 12, "#ffffff", [[-]])
	GUI:setTouchEnabled(Text_item_name, false)
	GUI:setTag(Text_item_name, -1)
	GUI:Text_enableOutline(Text_item_name, "#000000", 1)

	-- Create Image_filter_bg
	local Image_filter_bg = GUI:Image_Create(Layout_param, "Image_filter_bg", 124.00, 282.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_filter_bg, 21, 21, 37, 29)
	GUI:setContentSize(Image_filter_bg, 82, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_filter_bg, false)
	GUI:setAnchorPoint(Image_filter_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_filter_bg, false)
	GUI:setTag(Image_filter_bg, 30)

	-- Create ListView_filter_c
	local ListView_filter_c = GUI:ListView_Create(Image_filter_bg, "ListView_filter_c", 41.00, 2.00, 80.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_filter_c, 5)
	GUI:setAnchorPoint(ListView_filter_c, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter_c, false)
	GUI:setTag(ListView_filter_c, 46)

	-- Create Button_add
	local Button_add = GUI:Button_Create(PMainUI, "Button_add", 450.00, 20.00, "res/public_win32/1900000660.png")
	GUI:Button_setTitleText(Button_add, "添加")
	GUI:Button_setTitleColor(Button_add, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_add, 14)
	GUI:Button_titleEnableOutline(Button_add, "#000000", 2)
	GUI:setTouchEnabled(Button_add, true)
	GUI:setTag(Button_add, -1)
end
return ui