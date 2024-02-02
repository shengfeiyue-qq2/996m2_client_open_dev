local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Node, "Image_bg", 0.00, 0.00, "res/private/TradingBankLayer/bg_jiaoyh_011.png")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 15, 15)
	GUI:setContentSize(Image_bg, 669, 507)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 309)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Image_bg, "Image_2", 517.00, 446.00, "res/public/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 310)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Image_bg, "Image_3", 515.00, 445.00, "res/private/TradingBankLayer/word_jiaoyh_01.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 311)

	-- Create Text_serverName
	local Text_serverName = GUI:Text_Create(Image_bg, "Text_serverName", 513.00, 392.00, 16, "#ffffff", [[传奇1区]])
	GUI:setAnchorPoint(Text_serverName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_serverName, false)
	GUI:setTag(Text_serverName, 312)
	GUI:Text_enableOutline(Text_serverName, "#000000", 1)

	-- Create Text_account
	local Text_account = GUI:Text_Create(Image_bg, "Text_account", 513.00, 349.00, 16, "#ffffff", [[12312312]])
	GUI:setAnchorPoint(Text_account, 0.00, 0.50)
	GUI:setTouchEnabled(Text_account, false)
	GUI:setTag(Text_account, 313)
	GUI:Text_enableOutline(Text_account, "#000000", 1)

	-- Create Text_money1
	local Text_money1 = GUI:Text_Create(Image_bg, "Text_money1", 513.00, 311.00, 16, "#ffffff", [[￥1200]])
	GUI:setAnchorPoint(Text_money1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_money1, false)
	GUI:setTag(Text_money1, 314)
	GUI:Text_enableOutline(Text_money1, "#000000", 1)

	-- Create Text_30_0_0
	local Text_30_0_0 = GUI:Text_Create(Image_bg, "Text_30_0_0", 432.00, 311.00, 16, "#ffffff", [[金        额: ]])
	GUI:setAnchorPoint(Text_30_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0_0, false)
	GUI:setTag(Text_30_0_0, 315)
	GUI:Text_enableOutline(Text_30_0_0, "#000000", 1)

	-- Create Text_30_0
	local Text_30_0 = GUI:Text_Create(Image_bg, "Text_30_0", 432.00, 350.00, 16, "#ffffff", [[购买账号: ]])
	GUI:setAnchorPoint(Text_30_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30_0, false)
	GUI:setTag(Text_30_0, 316)
	GUI:Text_enableOutline(Text_30_0, "#000000", 1)

	-- Create Text_30
	local Text_30 = GUI:Text_Create(Image_bg, "Text_30", 432.00, 392.00, 16, "#ffffff", [[本服名称: ]])
	GUI:setAnchorPoint(Text_30, 0.00, 0.50)
	GUI:setTouchEnabled(Text_30, false)
	GUI:setTag(Text_30, 317)
	GUI:Text_enableOutline(Text_30, "#000000", 1)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Image_bg, "Button_buy", 513.00, 60.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_buy, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_buy, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_buy, 15, 15, 11, 11)
	GUI:setContentSize(Button_buy, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "提交订单")
	GUI:Button_setTitleColor(Button_buy, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_buy, 18)
	GUI:Button_titleEnableOutline(Button_buy, "#000000", 1)
	GUI:setAnchorPoint(Button_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, 318)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_bg, "ButtonClose", 681.00, 484.00, "res/public/1900000510.png")
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
	GUI:setTag(ButtonClose, 319)

	-- Create Image_2_0_0
	local Image_2_0_0 = GUI:Image_Create(Image_bg, "Image_2_0_0", 188.00, 254.00, "res/private/TradingBankLayer/bg_jiaoyh_07.jpg")
	GUI:setAnchorPoint(Image_2_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2_0_0, false)
	GUI:setTag(Image_2_0_0, 320)

	-- Create Image_3_0_0
	local Image_3_0_0 = GUI:Image_Create(Image_bg, "Image_3_0_0", 363.00, 253.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_3_0_0, 2, 483)
	GUI:setIgnoreContentAdaptWithSize(Image_3_0_0, false)
	GUI:setAnchorPoint(Image_3_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3_0_0, false)
	GUI:setTag(Image_3_0_0, 321)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Image_bg, "Image_icon", 181.00, 299.00, "res/private/TradingBankLayer/1900000651.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 322)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Image_icon, "Image_head", 30.00, 30.00, "res/private/TradingBankLayer/img_cost.png")
	GUI:setContentSize(Image_head, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_head, false)
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 323)

	-- Create Text_money
	local Text_money = GUI:Text_Create(Image_bg, "Text_money", 181.00, 238.00, 20, "#ffffff", [[元 宝：100000]])
	GUI:setAnchorPoint(Text_money, 0.50, 0.50)
	GUI:setTouchEnabled(Text_money, false)
	GUI:setTag(Text_money, 324)
	GUI:Text_enableOutline(Text_money, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_bg, "Text_name", 182.00, 190.00, 20, "#ffffff", [[寄售人：哈哈]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 325)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Image_bg, "Text_tips", 515.00, 78.00, 16, "#00ee00", [[此商品已被其他用户拍单
但未付款，请稍后再查看]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 326)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)
end
return ui