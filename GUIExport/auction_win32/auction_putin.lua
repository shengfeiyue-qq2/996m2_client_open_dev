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
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 355.00, 495.00, false)
	GUI:setChineseName(Panel_2, "上架道具组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 144)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 177.00, 247.00, "res/public/1900000601.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 355, 495)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "上架道具_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 146)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 354.00, 494.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "上架道具_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 149)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_2, "Text_title", 177.00, 470.00, 16, "#f8e6c6", [[上架道具]])
	GUI:setChineseName(Text_title, "上架道具_标题")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 207)
	GUI:Text_enableOutline(Text_title, "#111111", 1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_2, "Image_14", 177.00, 455.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_14, 300, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_14, false)
	GUI:setChineseName(Image_14, "上架道具_装饰条")
	GUI:setAnchorPoint(Image_14, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, 208)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 177.00, 395.00, "res/public_win32/1900000664.png")
	GUI:setChineseName(Image_icon, "上架道具_物品框_背景框")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 150)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 177.00, 435.00, 12, "#ffffff", [[装备名称七个字]])
	GUI:setChineseName(Text_name, "上架道具_装备名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 151)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_16
	local Image_16 = GUI:Image_Create(Panel_2, "Image_16", 212.00, 316.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16, 29, 29, 9, 9)
	GUI:setContentSize(Image_16, 102, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_16, false)
	GUI:setChineseName(Image_16, "上架道具_上架数量_背景框")
	GUI:setAnchorPoint(Image_16, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16, false)
	GUI:setTag(Image_16, 154)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_2, "Text_1", 108.00, 316.00, 12, "#ffffff", [[上架数量：]])
	GUI:setChineseName(Text_1, "上架道具_上架数量_文本")
	GUI:setAnchorPoint(Text_1, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 210)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_2, "Text_1_0", 108.00, 275.00, 12, "#ffffff", [[出售货币：]])
	GUI:setChineseName(Text_1_0, "上架道具_出售货币_文本")
	GUI:setAnchorPoint(Text_1_0, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 211)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_0_0
	local Text_1_0_0 = GUI:Text_Create(Panel_2, "Text_1_0_0", 108.00, 240.00, 12, "#ffffff", [[行会折扣：]])
	GUI:setChineseName(Text_1_0_0, "上架道具_行会折扣_文本")
	GUI:setAnchorPoint(Text_1_0_0, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_0, false)
	GUI:setTag(Text_1_0_0, 179)
	GUI:Text_enableOutline(Text_1_0_0, "#000000", 1)

	-- Create Text_1_0_2
	local Text_1_0_2 = GUI:Text_Create(Panel_2, "Text_1_0_2", 108.00, 190.00, 12, "#ffffff", [[竞拍价：]])
	GUI:setChineseName(Text_1_0_2, "上架道具_竞拍价_文本")
	GUI:setAnchorPoint(Text_1_0_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_2, false)
	GUI:setTag(Text_1_0_2, 218)
	GUI:Text_enableOutline(Text_1_0_2, "#000000", 1)

	-- Create Text_1_0_3
	local Text_1_0_3 = GUI:Text_Create(Panel_2, "Text_1_0_3", 108.00, 145.00, 12, "#ffffff", [[一口价：]])
	GUI:setChineseName(Text_1_0_3, "上架道具_一口价_文本")
	GUI:setAnchorPoint(Text_1_0_3, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0_3, false)
	GUI:setTag(Text_1_0_3, 219)
	GUI:Text_enableOutline(Text_1_0_3, "#000000", 1)

	-- Create Button_countadd
	local Button_countadd = GUI:Button_Create(Panel_2, "Button_countadd", 285.00, 316.00, "res/public_win32/1900000621.png")
	GUI:Button_loadTexturePressed(Button_countadd, "res/public_win32/1900000621_1.png")
	GUI:Button_setScale9Slice(Button_countadd, 15, 15, 12, 10)
	GUI:setContentSize(Button_countadd, 36, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_countadd, false)
	GUI:Button_setTitleText(Button_countadd, "")
	GUI:Button_setTitleColor(Button_countadd, "#414146")
	GUI:Button_setTitleFontSize(Button_countadd, 12)
	GUI:Button_titleDisableOutLine(Button_countadd)
	GUI:setChineseName(Button_countadd, "上架道具_增加_按钮")
	GUI:setAnchorPoint(Button_countadd, 0.50, 0.50)
	GUI:setScaleX(Button_countadd, 0.75)
	GUI:setScaleY(Button_countadd, 0.75)
	GUI:setTouchEnabled(Button_countadd, true)
	GUI:setTag(Button_countadd, 164)

	-- Create Button_countsub
	local Button_countsub = GUI:Button_Create(Panel_2, "Button_countsub", 137.00, 316.00, "res/public_win32/1900000620.png")
	GUI:Button_loadTexturePressed(Button_countsub, "res/public_win32/1900000620_1.png")
	GUI:Button_setScale9Slice(Button_countsub, 15, 15, 12, 10)
	GUI:setContentSize(Button_countsub, 36, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_countsub, false)
	GUI:Button_setTitleText(Button_countsub, "")
	GUI:Button_setTitleColor(Button_countsub, "#414146")
	GUI:Button_setTitleFontSize(Button_countsub, 14)
	GUI:Button_titleDisableOutLine(Button_countsub)
	GUI:setChineseName(Button_countsub, "上架道具_减少_按钮")
	GUI:setAnchorPoint(Button_countsub, 0.50, 0.50)
	GUI:setScaleX(Button_countsub, 0.75)
	GUI:setScaleY(Button_countsub, 0.75)
	GUI:setTouchEnabled(Button_countsub, true)
	GUI:setTag(Button_countsub, 165)

	-- Create TextField_count
	local TextField_count = GUI:TextInput_Create(Panel_2, "TextField_count", 212.00, 316.00, 102.00, 24.00, 12)
	GUI:TextInput_setString(TextField_count, "")
	GUI:TextInput_setFontColor(TextField_count, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_count, 10)
	GUI:setChineseName(TextField_count, "上架道具_上架数量")
	GUI:setAnchorPoint(TextField_count, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_count, true)
	GUI:setTag(TextField_count, 163)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 90.00, 50.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public_win32/1900000661.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 15, 11, 11)
	GUI:setContentSize(Button_cancel, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取消上架")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 14)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "上架道具_取消上架_按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 209)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 255.00, 50.00, "res/public_win32/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public_win32/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 11, 11)
	GUI:setContentSize(Button_submit, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "世界上架")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 14)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "上架道具_确认上架_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 160)

	-- Create Image_16_0
	local Image_16_0 = GUI:Image_Create(Panel_2, "Image_16_0", 207.00, 145.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0, 160, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0, false)
	GUI:setChineseName(Image_16_0, "上架道具_一口价输入背景框")
	GUI:setAnchorPoint(Image_16_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0, false)
	GUI:setTag(Image_16_0, 155)

	-- Create Image_16_0_0
	local Image_16_0_0 = GUI:Image_Create(Panel_2, "Image_16_0_0", 207.00, 190.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0_0, 160, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0_0, false)
	GUI:setChineseName(Image_16_0_0, "上架道具_竞拍输入背景框")
	GUI:setAnchorPoint(Image_16_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0_0, false)
	GUI:setTag(Image_16_0_0, 167)

	-- Create Node_money_bid
	local Node_money_bid = GUI:Node_Create(Panel_2, "Node_money_bid", 150.00, 190.00)
	GUI:setChineseName(Node_money_bid, "上架道具_竞拍货币节点")
	GUI:setAnchorPoint(Node_money_bid, 0.50, 0.50)
	GUI:setTag(Node_money_bid, 169)

	-- Create Node_money_buy
	local Node_money_buy = GUI:Node_Create(Panel_2, "Node_money_buy", 150.00, 145.00)
	GUI:setChineseName(Node_money_buy, "上架道具_一口价货币节点")
	GUI:setAnchorPoint(Node_money_buy, 0.50, 0.50)
	GUI:setTag(Node_money_buy, 158)

	-- Create TextField_bid_price
	local TextField_bid_price = GUI:TextInput_Create(Panel_2, "TextField_bid_price", 222.00, 190.00, 124.00, 22.00, 12)
	GUI:TextInput_setString(TextField_bid_price, "0")
	GUI:TextInput_setFontColor(TextField_bid_price, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_bid_price, 10)
	GUI:setChineseName(TextField_bid_price, "上架道具_竞拍价输入")
	GUI:setAnchorPoint(TextField_bid_price, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_bid_price, true)
	GUI:setTag(TextField_bid_price, 216)

	-- Create TextField_buy_price
	local TextField_buy_price = GUI:TextInput_Create(Panel_2, "TextField_buy_price", 222.00, 145.00, 124.00, 22.00, 12)
	GUI:TextInput_setString(TextField_buy_price, "0")
	GUI:TextInput_setFontColor(TextField_buy_price, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_buy_price, 10)
	GUI:setChineseName(TextField_buy_price, "上架道具_一口价输入")
	GUI:setAnchorPoint(TextField_buy_price, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_buy_price, true)
	GUI:setTag(TextField_buy_price, 217)

	-- Create Image_bid_input
	local Image_bid_input = GUI:Image_Create(Panel_2, "Image_bid_input", 275.00, 190.00, "res/public/btn_szjm_04.png")
	GUI:setChineseName(Image_bid_input, "上架道具_可输入标识_图片")
	GUI:setAnchorPoint(Image_bid_input, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bid_input, false)
	GUI:setTag(Image_bid_input, 90)

	-- Create Image_buy_input
	local Image_buy_input = GUI:Image_Create(Panel_2, "Image_buy_input", 275.00, 145.00, "res/public/btn_szjm_04.png")
	GUI:setChineseName(Image_buy_input, "上架道具_可输入标识_图片")
	GUI:setAnchorPoint(Image_buy_input, 0.50, 0.50)
	GUI:setTouchEnabled(Image_buy_input, false)
	GUI:setTag(Image_buy_input, 91)

	-- Create Panel_bid_able
	local Panel_bid_able = GUI:Layout_Create(Panel_2, "Panel_bid_able", 45.00, 190.00, 245.00, 34.00, false)
	GUI:Layout_setBackGroundColorType(Panel_bid_able, 1)
	GUI:Layout_setBackGroundColor(Panel_bid_able, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_bid_able, 178)
	GUI:setChineseName(Panel_bid_able, "上架道具_竞拍禁止输入遮罩")
	GUI:setAnchorPoint(Panel_bid_able, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_bid_able, true)
	GUI:setTag(Panel_bid_able, 135)

	-- Create CheckBox_bid
	local CheckBox_bid = GUI:CheckBox_Create(Panel_2, "CheckBox_bid", 305.00, 190.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_bid, true)
	GUI:setChineseName(CheckBox_bid, "上架道具_竞拍价_勾选框")
	GUI:setAnchorPoint(CheckBox_bid, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_bid, true)
	GUI:setTag(CheckBox_bid, 137)

	-- Create Panel_buy_able
	local Panel_buy_able = GUI:Layout_Create(Panel_2, "Panel_buy_able", 45.00, 145.00, 245.00, 34.00, false)
	GUI:Layout_setBackGroundColorType(Panel_buy_able, 1)
	GUI:Layout_setBackGroundColor(Panel_buy_able, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_buy_able, 178)
	GUI:setChineseName(Panel_buy_able, "上架道具_一口价禁止输入遮罩")
	GUI:setAnchorPoint(Panel_buy_able, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_buy_able, true)
	GUI:setTag(Panel_buy_able, 136)

	-- Create CheckBox_buy
	local CheckBox_buy = GUI:CheckBox_Create(Panel_2, "CheckBox_buy", 305.00, 145.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_buy, true)
	GUI:setChineseName(CheckBox_buy, "上架道具_一口价_勾选框")
	GUI:setAnchorPoint(CheckBox_buy, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_buy, true)
	GUI:setTag(CheckBox_buy, 138)

	-- Create Node_currency
	local Node_currency = GUI:Node_Create(Panel_2, "Node_currency", 207.00, 275.00)
	GUI:setChineseName(Node_currency, "上架道具_出售货币_节点")
	GUI:setAnchorPoint(Node_currency, 0.50, 0.50)
	GUI:setTag(Node_currency, 110)

	-- Create Node_rebate
	local Node_rebate = GUI:Node_Create(Panel_2, "Node_rebate", 207.00, 240.00)
	GUI:setChineseName(Node_rebate, "上架道具_行会折扣_节点")
	GUI:setAnchorPoint(Node_rebate, 0.50, 0.50)
	GUI:setTag(Node_rebate, 182)

	-- Create Image_rebate
	local Image_rebate = GUI:Image_Create(Panel_2, "Image_rebate", 207.00, 222.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_rebate, 21, 21, 39, 27)
	GUI:setContentSize(Image_rebate, 150, 238)
	GUI:setIgnoreContentAdaptWithSize(Image_rebate, false)
	GUI:setChineseName(Image_rebate, "上架道具_行会折扣下拉_背景图")
	GUI:setAnchorPoint(Image_rebate, 0.50, 1.00)
	GUI:setTouchEnabled(Image_rebate, false)
	GUI:setTag(Image_rebate, 180)

	-- Create ListView_rebate
	local ListView_rebate = GUI:ListView_Create(Panel_2, "ListView_rebate", 207.00, 220.00, 150.00, 235.00, 1)
	GUI:ListView_setGravity(ListView_rebate, 5)
	GUI:setChineseName(ListView_rebate, "上架道具_行会折扣下拉内容")
	GUI:setAnchorPoint(ListView_rebate, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_rebate, true)
	GUI:setTag(ListView_rebate, 181)

	-- Create Image_currency
	local Image_currency = GUI:Image_Create(Panel_2, "Image_currency", 207.00, 257.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_currency, 21, 21, 39, 27)
	GUI:setContentSize(Image_currency, 150, 238)
	GUI:setIgnoreContentAdaptWithSize(Image_currency, false)
	GUI:setChineseName(Image_currency, "上架道具_出售货币下拉_背景图")
	GUI:setAnchorPoint(Image_currency, 0.50, 1.00)
	GUI:setTouchEnabled(Image_currency, false)
	GUI:setTag(Image_currency, 139)

	-- Create ListView_currency
	local ListView_currency = GUI:ListView_Create(Panel_2, "ListView_currency", 207.00, 255.00, 150.00, 235.00, 1)
	GUI:ListView_setGravity(ListView_currency, 5)
	GUI:setChineseName(ListView_currency, "上架道具_出售货币下拉内容")
	GUI:setAnchorPoint(ListView_currency, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_currency, true)
	GUI:setTag(ListView_currency, 101)
end
return ui