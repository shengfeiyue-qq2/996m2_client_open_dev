local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "上架道具场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "上架道具_范围点击关闭")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 161)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 621.00, 326.00, 305.00, 405.00, false)
	GUI:setChineseName(Panel_2, "上架道具组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 144)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 156.00, 200.00, "res/public/1900000601.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 305, 405)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "上架道具_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 146)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 307.00, 378.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "上架道具_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.00, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 149)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_2, "Text_title", 152.00, 383.00, 12, "#f8e6c6", [[购买道具]])
	GUI:setChineseName(Text_title, "购买道具_标题")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 207)
	GUI:Text_enableOutline(Text_title, "#111111", 1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_2, "Image_14", 156.00, 367.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_14, 290, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_14, false)
	GUI:setChineseName(Image_14, "上架道具_装饰条")
	GUI:setAnchorPoint(Image_14, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, 208)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 65.00, 289.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_icon, "上架道具_物品框_背景框")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 150)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 65.00, 340.00, 12, "#ffffff", [[装备名称七个字]])
	GUI:setChineseName(Text_name, "上架道具_装备名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 151)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_16
	local Image_16 = GUI:Image_Create(Panel_2, "Image_16", 203.00, 235.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16, 52, 52, 10, 11)
	GUI:setContentSize(Image_16, 120, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_16, false)
	GUI:setChineseName(Image_16, "上架道具_上架数量_背景框")
	GUI:setAnchorPoint(Image_16, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16, false)
	GUI:setTag(Image_16, 154)

	-- Create Image_17
	local Image_17 = GUI:Image_Create(Image_16, "Image_17", 60.00, 13.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_17, 120, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_17, false)
	GUI:setChineseName(Image_17, "上架道具_上架数量_选中框")
	GUI:setAnchorPoint(Image_17, 0.50, 0.50)
	GUI:setTouchEnabled(Image_17, false)
	GUI:setTag(Image_17, 155)
	GUI:setVisible(Image_17, false)

	-- Create Text_selectnum
	local Text_selectnum = GUI:Text_Create(Image_16, "Text_selectnum", 60.00, 13.00, 12, "#ffffff", [[1/10]])
	GUI:setAnchorPoint(Text_selectnum, 0.50, 0.50)
	GUI:setTouchEnabled(Text_selectnum, false)
	GUI:setTag(Text_selectnum, 156)
	GUI:Text_enableOutline(Text_selectnum, "#000000", 1)

	-- Create Button_countadd
	local Button_countadd = GUI:Button_Create(Panel_2, "Button_countadd", 282.00, 234.00, "res/public_win32/1900000621.png")
	GUI:Button_loadTexturePressed(Button_countadd, "res/public_win32/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_countadd, 12, 12, 11, 12)
	GUI:setContentSize(Button_countadd, 30, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_countadd, false)
	GUI:Button_setTitleText(Button_countadd, "")
	GUI:Button_setTitleColor(Button_countadd, "#414146")
	GUI:Button_setTitleFontSize(Button_countadd, 14)
	GUI:Button_titleDisableOutLine(Button_countadd)
	GUI:setChineseName(Button_countadd, "上架道具_增加_按钮")
	GUI:setAnchorPoint(Button_countadd, 0.50, 0.50)
	GUI:setTouchEnabled(Button_countadd, true)
	GUI:setTag(Button_countadd, 164)

	-- Create Button_countsub
	local Button_countsub = GUI:Button_Create(Panel_2, "Button_countsub", 122.00, 234.00, "res/public_win32/1900000620.png")
	GUI:Button_loadTexturePressed(Button_countsub, "res/public_win32/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_countsub, 12, 12, 11, 12)
	GUI:setContentSize(Button_countsub, 30, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_countsub, false)
	GUI:Button_setTitleText(Button_countsub, "")
	GUI:Button_setTitleColor(Button_countsub, "#414146")
	GUI:Button_setTitleFontSize(Button_countsub, 14)
	GUI:Button_titleDisableOutLine(Button_countsub)
	GUI:setChineseName(Button_countsub, "上架道具_减少_按钮")
	GUI:setAnchorPoint(Button_countsub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_countsub, true)
	GUI:setTag(Button_countsub, 165)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 150.00, 23.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public_win32/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 26, 27, 10, 10)
	GUI:setContentSize(Button_submit, 69, 26)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "购买")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 12)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "上架道具_确认上架_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 160)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_2, "Text_6", 133.00, 324.00, 12, "#ffffff", [[数量]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 218)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Image_22
	local Image_22 = GUI:Image_Create(Panel_2, "Image_22", 224.00, 330.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_22, 140, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_22, false)
	GUI:setAnchorPoint(Image_22, 0.50, 0.50)
	GUI:setTouchEnabled(Image_22, false)
	GUI:setTag(Image_22, 220)

	-- Create Image_23
	local Image_23 = GUI:Image_Create(Panel_2, "Image_23", 224.00, 330.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_23, 140, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_23, false)
	GUI:setAnchorPoint(Image_23, 0.50, 0.50)
	GUI:setTouchEnabled(Image_23, false)
	GUI:setTag(Image_23, 224)

	-- Create Text_itemNum
	local Text_itemNum = GUI:Text_Create(Panel_2, "Text_itemNum", 161.00, 320.00, 12, "#ffffff", [[222222000000]])
	GUI:setTouchEnabled(Text_itemNum, false)
	GUI:setTag(Text_itemNum, 228)
	GUI:Text_enableOutline(Text_itemNum, "#000000", 1)

	-- Create Text_7
	local Text_7 = GUI:Text_Create(Panel_2, "Text_7", 133.00, 297.00, 12, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_7, 0.50, 0.50)
	GUI:setTouchEnabled(Text_7, false)
	GUI:setTag(Text_7, 236)
	GUI:Text_enableOutline(Text_7, "#000000", 1)

	-- Create Image_24
	local Image_24 = GUI:Image_Create(Panel_2, "Image_24", 224.00, 300.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_24, 140, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_24, false)
	GUI:setAnchorPoint(Image_24, 0.50, 0.50)
	GUI:setTouchEnabled(Image_24, false)
	GUI:setTag(Image_24, 240)

	-- Create Node_money_single
	local Node_money_single = GUI:Node_Create(Panel_2, "Node_money_single", 170.00, 300.00)
	GUI:setChineseName(Node_money_single, "上架道具_单价货币节点")
	GUI:setAnchorPoint(Node_money_single, 0.50, 0.50)
	GUI:setTag(Node_money_single, 248)

	-- Create Text_single
	local Text_single = GUI:Text_Create(Panel_2, "Text_single", 200.00, 290.00, 12, "#ffffff", [[666]])
	GUI:setTouchEnabled(Text_single, false)
	GUI:setTag(Text_single, 260)
	GUI:Text_enableOutline(Text_single, "#000000", 1)

	-- Create Text_8
	local Text_8 = GUI:Text_Create(Panel_2, "Text_8", 133.00, 270.00, 12, "#ffffff", [[总价]])
	GUI:setAnchorPoint(Text_8, 0.50, 0.50)
	GUI:setTouchEnabled(Text_8, false)
	GUI:setTag(Text_8, 252)
	GUI:Text_enableOutline(Text_8, "#000000", 1)

	-- Create Image_26
	local Image_26 = GUI:Image_Create(Panel_2, "Image_26", 224.00, 270.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_26, 140, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_26, false)
	GUI:setAnchorPoint(Image_26, 0.50, 0.50)
	GUI:setTouchEnabled(Image_26, false)
	GUI:setTag(Image_26, 254)

	-- Create Image_27
	local Image_27 = GUI:Image_Create(Panel_2, "Image_27", 224.00, 270.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_27, 140, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_27, false)
	GUI:setAnchorPoint(Image_27, 0.50, 0.50)
	GUI:setTouchEnabled(Image_27, false)
	GUI:setTag(Image_27, 258)
	GUI:setVisible(Image_27, false)

	-- Create Node_money_total
	local Node_money_total = GUI:Node_Create(Panel_2, "Node_money_total", 170.00, 270.00)
	GUI:setChineseName(Node_money_total, "上架道具_总价货币节点")
	GUI:setAnchorPoint(Node_money_total, 0.50, 0.50)
	GUI:setTag(Node_money_total, 264)

	-- Create Text_total
	local Text_total = GUI:Text_Create(Panel_2, "Text_total", 200.00, 261.00, 12, "#ffffff", [[66655]])
	GUI:setTouchEnabled(Text_total, false)
	GUI:setTag(Text_total, 262)
	GUI:Text_enableOutline(Text_total, "#000000", 1)

	-- Create Panel_num
	local Panel_num = GUI:Layout_Create(Panel_2, "Panel_num", 56.00, 38.00, 198.00, 184.00, false)
	GUI:setTouchEnabled(Panel_num, true)
	GUI:setTag(Panel_num, 269)

	-- Create Button_ref
	local Button_ref = GUI:Button_Create(Panel_num, "Button_ref", 38.00, 29.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_ref, 15, 15, 11, 11)
	GUI:setContentSize(Button_ref, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_ref, false)
	GUI:Button_setTitleText(Button_ref, "")
	GUI:Button_setTitleColor(Button_ref, "#414146")
	GUI:Button_setTitleFontSize(Button_ref, 10)
	GUI:Button_titleEnableOutline(Button_ref, "#000000", 1)
	GUI:setAnchorPoint(Button_ref, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ref, true)
	GUI:setTag(Button_ref, 270)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Button_ref, "Image_4", 18.00, 20.00, "res/private/page_store_ui/quick_detail_ui/2.png")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 271)

	-- Create Button_sub
	local Button_sub = GUI:Button_Create(Panel_num, "Button_sub", 114.00, 29.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_sub, 15, 15, 11, 11)
	GUI:setContentSize(Button_sub, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_sub, false)
	GUI:Button_setTitleText(Button_sub, "")
	GUI:Button_setTitleColor(Button_sub, "#414146")
	GUI:Button_setTitleFontSize(Button_sub, 10)
	GUI:Button_titleEnableOutline(Button_sub, "#000000", 1)
	GUI:setAnchorPoint(Button_sub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sub, true)
	GUI:setTag(Button_sub, 272)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Button_sub, "Image_5", 18.00, 20.00, "res/private/page_store_ui/quick_detail_ui/1.png")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 273)

	-- Create Button_max
	local Button_max = GUI:Button_Create(Panel_num, "Button_max", 152.00, 29.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_max, 15, 15, 11, 11)
	GUI:setContentSize(Button_max, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_max, false)
	GUI:Button_setTitleText(Button_max, "最大值")
	GUI:Button_setTitleColor(Button_max, "#ffffff")
	GUI:Button_setTitleFontSize(Button_max, 10)
	GUI:Button_titleEnableOutline(Button_max, "#000000", 1)
	GUI:setAnchorPoint(Button_max, 0.50, 0.50)
	GUI:setTouchEnabled(Button_max, true)
	GUI:setTag(Button_max, 274)

	-- Create Button_min
	local Button_min = GUI:Button_Create(Panel_num, "Button_min", 152.00, 72.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_min, 15, 15, 11, 11)
	GUI:setContentSize(Button_min, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_min, false)
	GUI:Button_setTitleText(Button_min, "最小值")
	GUI:Button_setTitleColor(Button_min, "#ffffff")
	GUI:Button_setTitleFontSize(Button_min, 10)
	GUI:Button_titleEnableOutline(Button_min, "#000000", 1)
	GUI:setAnchorPoint(Button_min, 0.50, 0.50)
	GUI:setTouchEnabled(Button_min, true)
	GUI:setTag(Button_min, 275)

	-- Create Button_50
	local Button_50 = GUI:Button_Create(Panel_num, "Button_50", 152.00, 115.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_50, 15, 15, 11, 11)
	GUI:setContentSize(Button_50, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_50, false)
	GUI:Button_setTitleText(Button_50, "+50")
	GUI:Button_setTitleColor(Button_50, "#ffffff")
	GUI:Button_setTitleFontSize(Button_50, 12)
	GUI:Button_titleEnableOutline(Button_50, "#000000", 1)
	GUI:setAnchorPoint(Button_50, 0.50, 0.50)
	GUI:setTouchEnabled(Button_50, true)
	GUI:setTag(Button_50, 276)

	-- Create Button_10
	local Button_10 = GUI:Button_Create(Panel_num, "Button_10", 152.00, 158.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_10, 15, 15, 11, 11)
	GUI:setContentSize(Button_10, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_10, false)
	GUI:Button_setTitleText(Button_10, "+10")
	GUI:Button_setTitleColor(Button_10, "#ffffff")
	GUI:Button_setTitleFontSize(Button_10, 12)
	GUI:Button_titleEnableOutline(Button_10, "#000000", 1)
	GUI:setAnchorPoint(Button_10, 0.50, 0.50)
	GUI:setTouchEnabled(Button_10, true)
	GUI:setTag(Button_10, 277)

	-- Create Button_0
	local Button_0 = GUI:Button_Create(Panel_num, "Button_0", 76.00, 29.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_0, 15, 15, 11, 11)
	GUI:setContentSize(Button_0, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_0, false)
	GUI:Button_setTitleText(Button_0, "0")
	GUI:Button_setTitleColor(Button_0, "#ffffff")
	GUI:Button_setTitleFontSize(Button_0, 12)
	GUI:Button_titleEnableOutline(Button_0, "#000000", 1)
	GUI:setAnchorPoint(Button_0, 0.50, 0.50)
	GUI:setTouchEnabled(Button_0, true)
	GUI:setTag(Button_0, 278)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_num, "Button_1", 38.00, 72.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "1")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 12)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 279)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_num, "Button_2", 76.00, 72.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "2")
	GUI:Button_setTitleColor(Button_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_2, 12)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 280)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_num, "Button_3", 114.00, 72.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 11, 11)
	GUI:setContentSize(Button_3, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "3")
	GUI:Button_setTitleColor(Button_3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_3, 12)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 281)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_num, "Button_4", 38.00, 115.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_4, 15, 15, 11, 11)
	GUI:setContentSize(Button_4, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_4, false)
	GUI:Button_setTitleText(Button_4, "4")
	GUI:Button_setTitleColor(Button_4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_4, 12)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 282)

	-- Create Button_5
	local Button_5 = GUI:Button_Create(Panel_num, "Button_5", 76.00, 115.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_5, 15, 15, 11, 11)
	GUI:setContentSize(Button_5, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_5, false)
	GUI:Button_setTitleText(Button_5, "5")
	GUI:Button_setTitleColor(Button_5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_5, 12)
	GUI:Button_titleEnableOutline(Button_5, "#000000", 1)
	GUI:setAnchorPoint(Button_5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_5, true)
	GUI:setTag(Button_5, 283)

	-- Create Button_6
	local Button_6 = GUI:Button_Create(Panel_num, "Button_6", 114.00, 115.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_6, 15, 15, 11, 11)
	GUI:setContentSize(Button_6, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_6, false)
	GUI:Button_setTitleText(Button_6, "6")
	GUI:Button_setTitleColor(Button_6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_6, 12)
	GUI:Button_titleEnableOutline(Button_6, "#000000", 1)
	GUI:setAnchorPoint(Button_6, 0.50, 0.50)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, 284)

	-- Create Button_7
	local Button_7 = GUI:Button_Create(Panel_num, "Button_7", 37.00, 158.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_7, 15, 15, 11, 11)
	GUI:setContentSize(Button_7, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_7, false)
	GUI:Button_setTitleText(Button_7, "7")
	GUI:Button_setTitleColor(Button_7, "#ffffff")
	GUI:Button_setTitleFontSize(Button_7, 12)
	GUI:Button_titleEnableOutline(Button_7, "#000000", 1)
	GUI:setAnchorPoint(Button_7, 0.50, 0.50)
	GUI:setTouchEnabled(Button_7, true)
	GUI:setTag(Button_7, 285)

	-- Create Button_8
	local Button_8 = GUI:Button_Create(Panel_num, "Button_8", 76.00, 158.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_8, 15, 15, 11, 11)
	GUI:setContentSize(Button_8, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_8, false)
	GUI:Button_setTitleText(Button_8, "8")
	GUI:Button_setTitleColor(Button_8, "#ffffff")
	GUI:Button_setTitleFontSize(Button_8, 12)
	GUI:Button_titleEnableOutline(Button_8, "#000000", 1)
	GUI:setAnchorPoint(Button_8, 0.50, 0.50)
	GUI:setTouchEnabled(Button_8, true)
	GUI:setTag(Button_8, 286)

	-- Create Button_9
	local Button_9 = GUI:Button_Create(Panel_num, "Button_9", 114.00, 158.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_9, 15, 15, 11, 11)
	GUI:setContentSize(Button_9, 36, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_9, false)
	GUI:Button_setTitleText(Button_9, "9")
	GUI:Button_setTitleColor(Button_9, "#ffffff")
	GUI:Button_setTitleFontSize(Button_9, 12)
	GUI:Button_titleEnableOutline(Button_9, "#000000", 1)
	GUI:setAnchorPoint(Button_9, 0.50, 0.50)
	GUI:setTouchEnabled(Button_9, true)
	GUI:setTag(Button_9, 287)
end
return ui