local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 281.00, 509.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 344)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 140.00, 254.00, "res/private/TradingBankLayer/bg_jiaoyh_011.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 345)

	-- Create Panel_11
	local Panel_11 = GUI:Layout_Create(Image_bg, "Panel_11", 0.00, 0.00, 281.00, 507.00, false)
	GUI:setTouchEnabled(Panel_11, true)
	GUI:setTag(Panel_11, 346)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_11, "Image_2", 141.00, 441.00, "res/public/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 347)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_11, "Image_3", 139.00, 440.00, "res/private/TradingBankLayer/word_jiaoyh_01.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 348)

	-- Create Text_30
	local Text_30 = GUI:Text_Create(Panel_11, "Text_30", 55.00, 389.00, 16, "#ffffff", [[本服名称: ]])
	GUI:setAnchorPoint(Text_30, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30, false)
	GUI:setTag(Text_30, 349)
	GUI:Text_enableOutline(Text_30, "#000000", 1)

	-- Create Text_30_0
	local Text_30_0 = GUI:Text_Create(Panel_11, "Text_30_0", 55.00, 347.00, 16, "#ffffff", [[购买账号: ]])
	GUI:setAnchorPoint(Text_30_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0, false)
	GUI:setTag(Text_30_0, 350)
	GUI:Text_enableOutline(Text_30_0, "#000000", 1)

	-- Create Text_30_0_0
	local Text_30_0_0 = GUI:Text_Create(Panel_11, "Text_30_0_0", 55.00, 308.00, 16, "#ffffff", [[金        额: ]])
	GUI:setAnchorPoint(Text_30_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0_0, false)
	GUI:setTag(Text_30_0_0, 351)
	GUI:Text_enableOutline(Text_30_0_0, "#000000", 1)

	-- Create Text_money1
	local Text_money1 = GUI:Text_Create(Panel_11, "Text_money1", 136.00, 308.00, 16, "#ffffff", [[￥1200]])
	GUI:setAnchorPoint(Text_money1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_money1, false)
	GUI:setTag(Text_money1, 352)
	GUI:Text_enableOutline(Text_money1, "#000000", 1)

	-- Create Text_account
	local Text_account = GUI:Text_Create(Panel_11, "Text_account", 136.00, 347.00, 16, "#ffffff", [[12312312]])
	GUI:setAnchorPoint(Text_account, 0.00, 0.50)
	GUI:setTouchEnabled(Text_account, false)
	GUI:setTag(Text_account, 353)
	GUI:Text_enableOutline(Text_account, "#000000", 1)

	-- Create Text_serverName
	local Text_serverName = GUI:Text_Create(Panel_11, "Text_serverName", 136.00, 389.00, 16, "#ffffff", [[传奇1区]])
	GUI:setAnchorPoint(Text_serverName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_serverName, false)
	GUI:setTag(Text_serverName, 354)
	GUI:Text_enableOutline(Text_serverName, "#000000", 1)

	-- Create Button_buy1
	local Button_buy1 = GUI:Button_Create(Panel_11, "Button_buy1", 141.00, 57.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_buy1, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_buy1, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_buy1, 15, 15, 11, 11)
	GUI:setContentSize(Button_buy1, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_buy1, false)
	GUI:Button_setTitleText(Button_buy1, "提交订单")
	GUI:Button_setTitleColor(Button_buy1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_buy1, 18)
	GUI:Button_titleEnableOutline(Button_buy1, "#000000", 1)
	GUI:setAnchorPoint(Button_buy1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy1, true)
	GUI:setTag(Button_buy1, 355)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Panel_11, "Text_tips", 139.00, 68.00, 16, "#00ee00", [[此商品已被其他用户拍单
但未付款，请稍后再查看]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 356)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_bg, "ButtonClose", 293.00, 484.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 6, 12, 10)
	GUI:setContentSize(ButtonClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 357)

	-- Create Panel_12
	local Panel_12 = GUI:Layout_Create(Image_bg, "Panel_12", 0.00, 0.00, 281.00, 507.00, false)
	GUI:setTouchEnabled(Panel_12, true)
	GUI:setTag(Panel_12, 358)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_12, "Image_1", 140.00, 334.00, "res/private/TradingBankLayer/bg_jiaoyh_08.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 359)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_12, "Image_2", 146.00, 461.00, "res/public/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 360)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_12, "Image_3", 143.00, 460.00, "res/private/TradingBankLayer/word_jiaoyh_01.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 361)

	-- Create Text_30
	local Text_30 = GUI:Text_Create(Panel_12, "Text_30", 39.00, 427.00, 16, "#ffffff", [[需支付的金额:]])
	GUI:setAnchorPoint(Text_30, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30, false)
	GUI:setTag(Text_30, 362)
	GUI:Text_enableOutline(Text_30, "#000000", 1)

	-- Create Text_30_0
	local Text_30_0 = GUI:Text_Create(Panel_12, "Text_30_0", 38.00, 394.00, 16, "#ffffff", [[剩余支付时间:]])
	GUI:setAnchorPoint(Text_30_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0, false)
	GUI:setTag(Text_30_0, 363)
	GUI:Text_enableOutline(Text_30_0, "#000000", 1)

	-- Create Text_30_0_0
	local Text_30_0_0 = GUI:Text_Create(Panel_12, "Text_30_0_0", 39.00, 352.00, 16, "#ffffff", [[请在指定时间内完成订单，否
则将取消订单]])
	GUI:setAnchorPoint(Text_30_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0_0, false)
	GUI:setTag(Text_30_0_0, 364)
	GUI:Text_enableOutline(Text_30_0_0, "#000000", 1)

	-- Create Text_money2
	local Text_money2 = GUI:Text_Create(Panel_12, "Text_money2", 146.00, 426.00, 16, "#ffffff", [[￥1200]])
	GUI:setAnchorPoint(Text_money2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_money2, false)
	GUI:setTag(Text_money2, 365)
	GUI:Text_enableOutline(Text_money2, "#000000", 1)

	-- Create Text_time2
	local Text_time2 = GUI:Text_Create(Panel_12, "Text_time2", 146.00, 394.00, 16, "#ffffff", [[180S]])
	GUI:setAnchorPoint(Text_time2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_time2, false)
	GUI:setTag(Text_time2, 366)
	GUI:Text_enableOutline(Text_time2, "#000000", 1)

	-- Create Image_2_0
	local Image_2_0 = GUI:Image_Create(Panel_12, "Image_2_0", 145.00, 270.00, "res/public/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_2_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2_0, false)
	GUI:setTag(Image_2_0, 367)

	-- Create Image_3_0
	local Image_3_0 = GUI:Image_Create(Panel_12, "Image_3_0", 143.00, 269.00, "res/private/TradingBankLayer/word_jiaoyh_02.png")
	GUI:setAnchorPoint(Image_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3_0, false)
	GUI:setTag(Image_3_0, 368)

	-- Create Button_buy2
	local Button_buy2 = GUI:Button_Create(Panel_12, "Button_buy2", 141.00, 57.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_buy2, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_buy2, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_buy2, 15, 15, 11, 11)
	GUI:setContentSize(Button_buy2, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_buy2, false)
	GUI:Button_setTitleText(Button_buy2, "确认支付")
	GUI:Button_setTitleColor(Button_buy2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_buy2, 18)
	GUI:Button_titleEnableOutline(Button_buy2, "#000000", 1)
	GUI:setAnchorPoint(Button_buy2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy2, true)
	GUI:setTag(Button_buy2, 369)

	-- Create Panel_pay4
	local Panel_pay4 = GUI:Layout_Create(Panel_12, "Panel_pay4", 46.00, 161.00, 198.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay4, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay4, false)
	GUI:setTag(Panel_pay4, 370)
	GUI:setVisible(Panel_pay4, false)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay4, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 371)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 372)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay4, "Text_1", 30.00, 11.00, 16, "#ffffff", [[996金币：0]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 373)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_pay3
	local Panel_pay3 = GUI:Layout_Create(Panel_12, "Panel_pay3", 46.00, 201.00, 198.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay3, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay3, true)
	GUI:setTag(Panel_pay3, 374)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay3, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 375)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 376)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay3, "Text_1", 30.00, 11.00, 16, "#ffffff", [[996盒币：0]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 377)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_pay1
	local Panel_pay1 = GUI:Layout_Create(Panel_12, "Panel_pay1", 46.00, 240.00, 97.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay1, true)
	GUI:setTag(Panel_pay1, 378)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay1, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 379)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 380)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay1, "Text_1", 30.00, 11.00, 16, "#ffffff", [[支付宝]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 381)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_pay2
	local Panel_pay2 = GUI:Layout_Create(Panel_12, "Panel_pay2", 46.00, 158.00, 96.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay2, true)
	GUI:setTag(Panel_pay2, 382)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay2, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 383)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 384)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay2, "Text_1", 30.00, 11.00, 16, "#ffffff", [[微信]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 385)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_more
	local Panel_more = GUI:Layout_Create(Panel_12, "Panel_more", 46.00, 158.00, 96.00, 25.00, false)
	GUI:setAnchorPoint(Panel_more, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_more, true)
	GUI:setTag(Panel_more, 386)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_more, "Text_1", 3.00, 11.00, 16, "#ffffff", [[更多支付]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 387)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_x
	local Image_x = GUI:Image_Create(Panel_more, "Image_x", 79.00, 10.00, "res/private/TradingBankLayer/word_jiaoyh_017.png")
	GUI:setAnchorPoint(Image_x, 0.50, 0.50)
	GUI:setTouchEnabled(Image_x, false)
	GUI:setTag(Image_x, 388)

	-- Create Panel_pay5
	local Panel_pay5 = GUI:Layout_Create(Panel_12, "Panel_pay5", 45.00, 129.00, 198.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay5, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay5, true)
	GUI:setTag(Panel_pay5, 128)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay5, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 129)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 130)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay5, "Text_1", 30.00, 11.00, 16, "#ffffff", [[支付宝二维码]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 131)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_pay6
	local Panel_pay6 = GUI:Layout_Create(Panel_12, "Panel_pay6", 45.00, 102.00, 198.00, 25.00, false)
	GUI:setAnchorPoint(Panel_pay6, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_pay6, true)
	GUI:setTag(Panel_pay6, 132)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_pay6, "Image_2", 14.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 133)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_2, "Image_1", 12.00, 12.00, "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 134)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_pay6, "Text_1", 30.00, 11.00, 16, "#ffffff", [[微信二维码]])
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 135)
	GUI:Text_enableOutline(Text_1, "#000000", 1)
end
return ui