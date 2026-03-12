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
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 621.00, 326.00, 655.00, 595.00, false)
	GUI:setChineseName(Panel_2, "上架道具组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 144)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 328.00, 298.00, "res/public/1900000601.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 655, 595)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "上架道具_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 146)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 655.00, 572.00, "res/public/1900000510.png")
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
	local Text_title = GUI:Text_Create(Panel_2, "Text_title", 318.00, 570.00, 18, "#f8e6c6", [[上架道具]])
	GUI:setChineseName(Text_title, "上架道具_标题")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 207)
	GUI:Text_enableOutline(Text_title, "#111111", 1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_2, "Image_14", 320.00, 552.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_14, 300, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_14, false)
	GUI:setChineseName(Image_14, "上架道具_装饰条")
	GUI:setAnchorPoint(Image_14, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, 208)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 172.00, 479.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_icon, "上架道具_物品框_背景框")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 150)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 175.00, 525.00, 16, "#ffffff", [[装备名称七个字]])
	GUI:setChineseName(Text_name, "上架道具_装备名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 151)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_16
	local Image_16 = GUI:Image_Create(Panel_2, "Image_16", 486.00, 386.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16, 52, 52, 10, 11)
	GUI:setContentSize(Image_16, 170, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_16, false)
	GUI:setChineseName(Image_16, "上架道具_上架数量_背景框")
	GUI:setAnchorPoint(Image_16, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16, false)
	GUI:setTag(Image_16, 154)

	-- Create Image_17
	local Image_17 = GUI:Image_Create(Image_16, "Image_17", 85.00, 16.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_17, 158, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_17, false)
	GUI:setChineseName(Image_17, "上架道具_上架数量_选中框")
	GUI:setAnchorPoint(Image_17, 0.50, 0.50)
	GUI:setTouchEnabled(Image_17, false)
	GUI:setTag(Image_17, 155)
	GUI:setVisible(Image_17, false)

	-- Create Text_selectnum
	local Text_selectnum = GUI:Text_Create(Image_16, "Text_selectnum", 85.00, 16.00, 16, "#ffffff", [[1/10]])
	GUI:setAnchorPoint(Text_selectnum, 0.50, 0.50)
	GUI:setTouchEnabled(Text_selectnum, false)
	GUI:setTag(Text_selectnum, 156)
	GUI:Text_enableOutline(Text_selectnum, "#000000", 1)

	-- Create Image_18
	local Image_18 = GUI:Image_Create(Panel_2, "Image_18", 152.00, 334.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_18, 278, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_18, false)
	GUI:setChineseName(Image_18, "上架道具_在售最低_背景框")
	GUI:setAnchorPoint(Image_18, 0.50, 0.50)
	GUI:setTouchEnabled(Image_18, false)
	GUI:setTag(Image_18, 157)
	GUI:setVisible(Image_18, false)

	-- Create Text_1_0_1
	local Text_1_0_1 = GUI:Text_Create(Image_18, "Text_1_0_1", 115.00, 16.00, 16, "#ffffff", [[在售最低单价：]])
	GUI:setChineseName(Text_1_0_1, "上架道具_在售最低_文本")
	GUI:setAnchorPoint(Text_1_0_1, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_1, false)
	GUI:setTag(Text_1_0_1, 160)
	GUI:Text_enableOutline(Text_1_0_1, "#000000", 1)

	-- Create Text_price_1
	local Text_price_1 = GUI:Text_Create(Image_18, "Text_price_1", 270.00, 16.00, 16, "#ffffff", [[100元宝]])
	GUI:setAnchorPoint(Text_price_1, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price_1, false)
	GUI:setTag(Text_price_1, 166)
	GUI:Text_enableOutline(Text_price_1, "#000000", 1)

	-- Create Image_19
	local Image_19 = GUI:Image_Create(Panel_2, "Image_19", 152.00, 286.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_19, 278, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_19, false)
	GUI:setAnchorPoint(Image_19, 0.50, 0.50)
	GUI:setTouchEnabled(Image_19, false)
	GUI:setTag(Image_19, 170)

	-- Create Text_1_0_2
	local Text_1_0_2 = GUI:Text_Create(Image_19, "Text_1_0_2", 115.00, 16.00, 16, "#ffffff", [[最新成交单价：]])
	GUI:setChineseName(Text_1_0_2, "上架道具_最新成交_文本")
	GUI:setAnchorPoint(Text_1_0_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_2, false)
	GUI:setTag(Text_1_0_2, 174)
	GUI:Text_enableOutline(Text_1_0_2, "#000000", 1)

	-- Create Text_price_2
	local Text_price_2 = GUI:Text_Create(Image_19, "Text_price_2", 270.00, 16.00, 16, "#ffffff", [[100元宝]])
	GUI:setAnchorPoint(Text_price_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price_2, false)
	GUI:setTag(Text_price_2, 180)
	GUI:Text_enableOutline(Text_price_2, "#000000", 1)

	-- Create Image_20
	local Image_20 = GUI:Image_Create(Panel_2, "Image_20", 152.00, 238.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_20, 278, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_20, false)
	GUI:setAnchorPoint(Image_20, 0.50, 0.50)
	GUI:setTouchEnabled(Image_20, false)
	GUI:setTag(Image_20, 184)
	GUI:setVisible(Image_20, false)

	-- Create Text_1_0_3
	local Text_1_0_3 = GUI:Text_Create(Image_20, "Text_1_0_3", 115.00, 16.00, 16, "#ffffff", [[挂单最高单价：]])
	GUI:setAnchorPoint(Text_1_0_3, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_3, false)
	GUI:setTag(Text_1_0_3, 188)
	GUI:Text_enableOutline(Text_1_0_3, "#000000", 1)

	-- Create Text_price_3
	local Text_price_3 = GUI:Text_Create(Image_20, "Text_price_3", 270.00, 16.00, 16, "#ffffff", [[1000元宝]])
	GUI:setAnchorPoint(Text_price_3, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price_3, false)
	GUI:setTag(Text_price_3, 194)
	GUI:Text_enableOutline(Text_price_3, "#000000", 1)

	-- Create Image_21
	local Image_21 = GUI:Image_Create(Panel_2, "Image_21", 152.00, 238.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_21, 278, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_21, false)
	GUI:setAnchorPoint(Image_21, 0.50, 0.50)
	GUI:setTouchEnabled(Image_21, false)
	GUI:setTag(Image_21, 198)

	-- Create Text_1_0_4
	local Text_1_0_4 = GUI:Text_Create(Image_21, "Text_1_0_4", 115.00, 16.00, 16, "#ffffff", [[挂单最低限价：]])
	GUI:setAnchorPoint(Text_1_0_4, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_4, false)
	GUI:setTag(Text_1_0_4, 204)
	GUI:Text_enableOutline(Text_1_0_4, "#000000", 1)

	-- Create Text_price_4
	local Text_price_4 = GUI:Text_Create(Image_21, "Text_price_4", 270.00, 16.00, 16, "#ffffff", [[10000元宝]])
	GUI:setAnchorPoint(Text_price_4, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price_4, false)
	GUI:setTag(Text_price_4, 210)
	GUI:Text_enableOutline(Text_price_4, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_2, "Text_1_0", 97.00, 401.00, 16, "#ffffff", [[出售货币：]])
	GUI:setChineseName(Text_1_0, "上架道具_出售货币_文本")
	GUI:setAnchorPoint(Text_1_0, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 211)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_2, "Text_5", 36.00, 121.00, 16, "#ffffff", [[扣除一定的费用作为手续费]])
	GUI:setAnchorPoint(Text_5, 0.00, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 214)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_countadd
	local Button_countadd = GUI:Button_Create(Panel_2, "Button_countadd", 592.00, 386.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(Button_countadd, "res/public/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_countadd, 11, 11, 13, 9)
	GUI:setContentSize(Button_countadd, 33, 33)
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
	local Button_countsub = GUI:Button_Create(Panel_2, "Button_countsub", 380.00, 386.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(Button_countsub, "res/public/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_countsub, 15, 6, 12, 3)
	GUI:setContentSize(Button_countsub, 33, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_countsub, false)
	GUI:Button_setTitleText(Button_countsub, "")
	GUI:Button_setTitleColor(Button_countsub, "#414146")
	GUI:Button_setTitleFontSize(Button_countsub, 14)
	GUI:Button_titleDisableOutLine(Button_countsub)
	GUI:setChineseName(Button_countsub, "上架道具_减少_按钮")
	GUI:setAnchorPoint(Button_countsub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_countsub, true)
	GUI:setTag(Button_countsub, 165)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 205.00, 34.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_cancel, 35, 36, 13, 14)
	GUI:setContentSize(Button_cancel, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取消上架")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 18)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "上架道具_取消上架_按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 209)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 464.00, 34.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 11, 11)
	GUI:setContentSize(Button_submit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "世界上架")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 18)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "上架道具_确认上架_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 160)

	-- Create Node_currency
	local Node_currency = GUI:Node_Create(Panel_2, "Node_currency", 171.00, 403.00)
	GUI:setChineseName(Node_currency, "上架道具_出售货币_节点")
	GUI:setAnchorPoint(Node_currency, 0.50, 0.50)
	GUI:setTag(Node_currency, 110)

	-- Create Image_currency
	local Image_currency = GUI:Image_Create(Panel_2, "Image_currency", 172.00, 389.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_currency, 21, 21, 39, 27)
	GUI:setContentSize(Image_currency, 150, 238)
	GUI:setIgnoreContentAdaptWithSize(Image_currency, false)
	GUI:setChineseName(Image_currency, "上架道具_出售货币下拉_背景图")
	GUI:setAnchorPoint(Image_currency, 0.50, 1.00)
	GUI:setTouchEnabled(Image_currency, false)
	GUI:setTag(Image_currency, 139)
	GUI:setVisible(Image_currency, false)

	-- Create ListView_currency
	local ListView_currency = GUI:ListView_Create(Panel_2, "ListView_currency", 172.00, 389.00, 150.00, 235.00, 1)
	GUI:ListView_setGravity(ListView_currency, 5)
	GUI:setChineseName(ListView_currency, "上架道具_出售货币下拉内容")
	GUI:setAnchorPoint(ListView_currency, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_currency, true)
	GUI:setTag(ListView_currency, 101)
	GUI:setVisible(ListView_currency, false)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_2, "Text_6", 368.00, 512.00, 16, "#ffffff", [[数量]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 218)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Image_22
	local Image_22 = GUI:Image_Create(Panel_2, "Image_22", 470.00, 510.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_22, 156, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_22, false)
	GUI:setAnchorPoint(Image_22, 0.50, 0.50)
	GUI:setTouchEnabled(Image_22, false)
	GUI:setTag(Image_22, 220)

	-- Create Image_23
	local Image_23 = GUI:Image_Create(Panel_2, "Image_23", 470.00, 510.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_23, 158, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_23, false)
	GUI:setAnchorPoint(Image_23, 0.50, 0.50)
	GUI:setTouchEnabled(Image_23, false)
	GUI:setTag(Image_23, 224)

	-- Create Text_itemNum
	local Text_itemNum = GUI:Text_Create(Panel_2, "Text_itemNum", 400.00, 500.00, 16, "#ffffff", [[222222000000]])
	GUI:setTouchEnabled(Text_itemNum, false)
	GUI:setTag(Text_itemNum, 228)
	GUI:Text_enableOutline(Text_itemNum, "#000000", 1)

	-- Create Text_7
	local Text_7 = GUI:Text_Create(Panel_2, "Text_7", 368.00, 470.00, 16, "#ffffff", [[单价]])
	GUI:setAnchorPoint(Text_7, 0.50, 0.50)
	GUI:setTouchEnabled(Text_7, false)
	GUI:setTag(Text_7, 236)
	GUI:Text_enableOutline(Text_7, "#000000", 1)

	-- Create Image_24
	local Image_24 = GUI:Image_Create(Panel_2, "Image_24", 470.00, 472.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_24, 156, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_24, false)
	GUI:setAnchorPoint(Image_24, 0.50, 0.50)
	GUI:setTouchEnabled(Image_24, false)
	GUI:setTag(Image_24, 240)

	-- Create Image_25
	local Image_25 = GUI:Image_Create(Panel_2, "Image_25", 470.00, 472.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_25, 156, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_25, false)
	GUI:setAnchorPoint(Image_25, 0.50, 0.50)
	GUI:setTouchEnabled(Image_25, false)
	GUI:setTag(Image_25, 244)

	-- Create Node_money_single
	local Node_money_single = GUI:Node_Create(Panel_2, "Node_money_single", 412.00, 472.00)
	GUI:setChineseName(Node_money_single, "上架道具_单价货币节点")
	GUI:setAnchorPoint(Node_money_single, 0.50, 0.50)
	GUI:setTag(Node_money_single, 248)

	-- Create Text_single
	local Text_single = GUI:Text_Create(Panel_2, "Text_single", 432.00, 462.00, 16, "#ffffff", [[666]])
	GUI:setTouchEnabled(Text_single, false)
	GUI:setTag(Text_single, 260)
	GUI:Text_enableOutline(Text_single, "#000000", 1)

	-- Create Text_8
	local Text_8 = GUI:Text_Create(Panel_2, "Text_8", 368.00, 430.00, 16, "#ffffff", [[总价]])
	GUI:setAnchorPoint(Text_8, 0.50, 0.50)
	GUI:setTouchEnabled(Text_8, false)
	GUI:setTag(Text_8, 252)
	GUI:Text_enableOutline(Text_8, "#000000", 1)

	-- Create Image_26
	local Image_26 = GUI:Image_Create(Panel_2, "Image_26", 482.00, 434.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_26, 178, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_26, false)
	GUI:setAnchorPoint(Image_26, 0.50, 0.50)
	GUI:setTouchEnabled(Image_26, false)
	GUI:setTag(Image_26, 254)

	-- Create Image_27
	local Image_27 = GUI:Image_Create(Panel_2, "Image_27", 482.00, 434.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_27, 178, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_27, false)
	GUI:setAnchorPoint(Image_27, 0.50, 0.50)
	GUI:setTouchEnabled(Image_27, false)
	GUI:setTag(Image_27, 258)
	GUI:setVisible(Image_27, false)

	-- Create Node_money_total
	local Node_money_total = GUI:Node_Create(Panel_2, "Node_money_total", 412.00, 432.00)
	GUI:setChineseName(Node_money_total, "上架道具_总价货币节点")
	GUI:setAnchorPoint(Node_money_total, 0.50, 0.50)
	GUI:setTag(Node_money_total, 264)

	-- Create Text_total
	local Text_total = GUI:Text_Create(Panel_2, "Text_total", 432.00, 424.00, 16, "#ffffff", [[66655]])
	GUI:setTouchEnabled(Text_total, false)
	GUI:setTag(Text_total, 262)
	GUI:Text_enableOutline(Text_total, "#000000", 1)

	-- Create Button_num
	local Button_num = GUI:Button_Create(Panel_2, "Button_num", 590.00, 510.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_num, "res/public/1900000661.png")
	GUI:setContentSize(Button_num, 70, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_num, false)
	GUI:Button_setTitleText(Button_num, "选择")
	GUI:Button_setTitleColor(Button_num, "#ffffff")
	GUI:Button_setTitleFontSize(Button_num, 14)
	GUI:Button_titleEnableOutline(Button_num, "#000000", 1)
	GUI:setAnchorPoint(Button_num, 0.50, 0.50)
	GUI:setTouchEnabled(Button_num, true)
	GUI:setTag(Button_num, 264)

	-- Create Button_single
	local Button_single = GUI:Button_Create(Panel_2, "Button_single", 590.00, 472.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_single, "res/public/1900000661.png")
	GUI:setContentSize(Button_single, 70, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_single, false)
	GUI:Button_setTitleText(Button_single, "选择")
	GUI:Button_setTitleColor(Button_single, "#ffffff")
	GUI:Button_setTitleFontSize(Button_single, 14)
	GUI:Button_titleEnableOutline(Button_single, "#000000", 1)
	GUI:setAnchorPoint(Button_single, 0.50, 0.50)
	GUI:setTouchEnabled(Button_single, true)
	GUI:setTag(Button_single, 268)

	-- Create Panel_num
	local Panel_num = GUI:Layout_Create(Panel_2, "Panel_num", 356.00, 85.00, 258.00, 284.00, false)
	GUI:setTouchEnabled(Panel_num, true)
	GUI:setTag(Panel_num, 269)

	-- Create Button_ref
	local Button_ref = GUI:Button_Create(Panel_num, "Button_ref", 37.00, 43.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_ref, 15, 15, 11, 11)
	GUI:setContentSize(Button_ref, 51.5, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_ref, false)
	GUI:Button_setTitleText(Button_ref, "")
	GUI:Button_setTitleColor(Button_ref, "#414146")
	GUI:Button_setTitleFontSize(Button_ref, 10)
	GUI:Button_titleEnableOutline(Button_ref, "#000000", 1)
	GUI:setAnchorPoint(Button_ref, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ref, true)
	GUI:setTag(Button_ref, 270)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Button_ref, "Image_4", 25.00, 30.00, "res/private/page_store_ui/quick_detail_ui/2.png")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 271)

	-- Create Button_sub
	local Button_sub = GUI:Button_Create(Panel_num, "Button_sub", 161.00, 43.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_sub, 15, 15, 11, 11)
	GUI:setContentSize(Button_sub, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_sub, false)
	GUI:Button_setTitleText(Button_sub, "")
	GUI:Button_setTitleColor(Button_sub, "#414146")
	GUI:Button_setTitleFontSize(Button_sub, 10)
	GUI:Button_titleEnableOutline(Button_sub, "#000000", 1)
	GUI:setAnchorPoint(Button_sub, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sub, true)
	GUI:setTag(Button_sub, 272)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Button_sub, "Image_5", 27.00, 30.00, "res/private/page_store_ui/quick_detail_ui/1.png")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 273)

	-- Create Button_max
	local Button_max = GUI:Button_Create(Panel_num, "Button_max", 221.00, 43.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_max, 15, 15, 11, 11)
	GUI:setContentSize(Button_max, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_max, false)
	GUI:Button_setTitleText(Button_max, "最大值")
	GUI:Button_setTitleColor(Button_max, "#ffffff")
	GUI:Button_setTitleFontSize(Button_max, 16)
	GUI:Button_titleEnableOutline(Button_max, "#000000", 1)
	GUI:setAnchorPoint(Button_max, 0.50, 0.50)
	GUI:setTouchEnabled(Button_max, true)
	GUI:setTag(Button_max, 274)

	-- Create Button_min
	local Button_min = GUI:Button_Create(Panel_num, "Button_min", 221.00, 110.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_min, 15, 15, 11, 11)
	GUI:setContentSize(Button_min, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_min, false)
	GUI:Button_setTitleText(Button_min, "最小值")
	GUI:Button_setTitleColor(Button_min, "#ffffff")
	GUI:Button_setTitleFontSize(Button_min, 16)
	GUI:Button_titleEnableOutline(Button_min, "#000000", 1)
	GUI:setAnchorPoint(Button_min, 0.50, 0.50)
	GUI:setTouchEnabled(Button_min, true)
	GUI:setTag(Button_min, 275)

	-- Create Button_50
	local Button_50 = GUI:Button_Create(Panel_num, "Button_50", 221.00, 175.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_50, 15, 15, 11, 11)
	GUI:setContentSize(Button_50, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_50, false)
	GUI:Button_setTitleText(Button_50, "+50")
	GUI:Button_setTitleColor(Button_50, "#ffffff")
	GUI:Button_setTitleFontSize(Button_50, 18)
	GUI:Button_titleEnableOutline(Button_50, "#000000", 1)
	GUI:setAnchorPoint(Button_50, 0.50, 0.50)
	GUI:setTouchEnabled(Button_50, true)
	GUI:setTag(Button_50, 276)

	-- Create Button_10
	local Button_10 = GUI:Button_Create(Panel_num, "Button_10", 221.00, 241.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_2.png")
	GUI:Button_setScale9Slice(Button_10, 15, 15, 11, 11)
	GUI:setContentSize(Button_10, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_10, false)
	GUI:Button_setTitleText(Button_10, "+10")
	GUI:Button_setTitleColor(Button_10, "#ffffff")
	GUI:Button_setTitleFontSize(Button_10, 18)
	GUI:Button_titleEnableOutline(Button_10, "#000000", 1)
	GUI:setAnchorPoint(Button_10, 0.50, 0.50)
	GUI:setTouchEnabled(Button_10, true)
	GUI:setTag(Button_10, 277)

	-- Create Button_0
	local Button_0 = GUI:Button_Create(Panel_num, "Button_0", 98.00, 43.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_0, 15, 15, 11, 11)
	GUI:setContentSize(Button_0, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_0, false)
	GUI:Button_setTitleText(Button_0, "0")
	GUI:Button_setTitleColor(Button_0, "#ffffff")
	GUI:Button_setTitleFontSize(Button_0, 20)
	GUI:Button_titleEnableOutline(Button_0, "#000000", 1)
	GUI:setAnchorPoint(Button_0, 0.50, 0.50)
	GUI:setTouchEnabled(Button_0, true)
	GUI:setTag(Button_0, 278)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_num, "Button_1", 37.00, 110.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "1")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 20)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 279)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_num, "Button_2", 98.00, 110.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "2")
	GUI:Button_setTitleColor(Button_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_2, 20)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 280)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_num, "Button_3", 161.00, 110.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 11, 11)
	GUI:setContentSize(Button_3, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "3")
	GUI:Button_setTitleColor(Button_3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_3, 20)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 281)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_num, "Button_4", 37.00, 175.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_4, 15, 15, 11, 11)
	GUI:setContentSize(Button_4, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_4, false)
	GUI:Button_setTitleText(Button_4, "4")
	GUI:Button_setTitleColor(Button_4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_4, 20)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 282)

	-- Create Button_5
	local Button_5 = GUI:Button_Create(Panel_num, "Button_5", 98.00, 175.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_5, 15, 15, 11, 11)
	GUI:setContentSize(Button_5, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_5, false)
	GUI:Button_setTitleText(Button_5, "5")
	GUI:Button_setTitleColor(Button_5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_5, 20)
	GUI:Button_titleEnableOutline(Button_5, "#000000", 1)
	GUI:setAnchorPoint(Button_5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_5, true)
	GUI:setTag(Button_5, 283)

	-- Create Button_6
	local Button_6 = GUI:Button_Create(Panel_num, "Button_6", 161.00, 175.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_6, 15, 15, 11, 11)
	GUI:setContentSize(Button_6, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_6, false)
	GUI:Button_setTitleText(Button_6, "6")
	GUI:Button_setTitleColor(Button_6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_6, 20)
	GUI:Button_titleEnableOutline(Button_6, "#000000", 1)
	GUI:setAnchorPoint(Button_6, 0.50, 0.50)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, 284)

	-- Create Button_7
	local Button_7 = GUI:Button_Create(Panel_num, "Button_7", 37.00, 241.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_7, 15, 15, 11, 11)
	GUI:setContentSize(Button_7, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_7, false)
	GUI:Button_setTitleText(Button_7, "7")
	GUI:Button_setTitleColor(Button_7, "#ffffff")
	GUI:Button_setTitleFontSize(Button_7, 20)
	GUI:Button_titleEnableOutline(Button_7, "#000000", 1)
	GUI:setAnchorPoint(Button_7, 0.50, 0.50)
	GUI:setTouchEnabled(Button_7, true)
	GUI:setTag(Button_7, 285)

	-- Create Button_8
	local Button_8 = GUI:Button_Create(Panel_num, "Button_8", 98.00, 241.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_8, 15, 15, 11, 11)
	GUI:setContentSize(Button_8, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_8, false)
	GUI:Button_setTitleText(Button_8, "8")
	GUI:Button_setTitleColor(Button_8, "#ffffff")
	GUI:Button_setTitleFontSize(Button_8, 20)
	GUI:Button_titleEnableOutline(Button_8, "#000000", 1)
	GUI:setAnchorPoint(Button_8, 0.50, 0.50)
	GUI:setTouchEnabled(Button_8, true)
	GUI:setTag(Button_8, 286)

	-- Create Button_9
	local Button_9 = GUI:Button_Create(Panel_num, "Button_9", 161.00, 241.00, "res/private/page_store_ui/quick_detail_ui/btn_calc_1.png")
	GUI:Button_setScale9Slice(Button_9, 15, 15, 11, 11)
	GUI:setContentSize(Button_9, 54, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_9, false)
	GUI:Button_setTitleText(Button_9, "9")
	GUI:Button_setTitleColor(Button_9, "#ffffff")
	GUI:Button_setTitleFontSize(Button_9, 20)
	GUI:Button_titleEnableOutline(Button_9, "#000000", 1)
	GUI:setAnchorPoint(Button_9, 0.50, 0.50)
	GUI:setTouchEnabled(Button_9, true)
	GUI:setTag(Button_9, 287)
end
return ui