local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "充值节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_input
	local Panel_input = GUI:Layout_Create(Node, "Panel_input", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_input, "充值组合")
	GUI:setTouchEnabled(Panel_input, true)
	GUI:setTag(Panel_input, 16)

	-- Create Image_bg1
	local Image_bg1 = GUI:Image_Create(Panel_input, "Image_bg1", 366.00, 425.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_bg1, 51, 51, 10, 10)
	GUI:setContentSize(Image_bg1, 725, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_bg1, false)
	GUI:setChineseName(Image_bg1, "充值_标题_背景图")
	GUI:setAnchorPoint(Image_bg1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg1, false)
	GUI:setTag(Image_bg1, 53)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Panel_input, "Image_bg2", 366.00, 405.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_bg2, 51, 51, 10, 10)
	GUI:setContentSize(Image_bg2, 725, 195)
	GUI:setIgnoreContentAdaptWithSize(Image_bg2, false)
	GUI:setChineseName(Image_bg2, "充值_支付方式_背景图")
	GUI:setAnchorPoint(Image_bg2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 54)

	-- Create Image_bg3
	local Image_bg3 = GUI:Image_Create(Panel_input, "Image_bg3", 366.00, 205.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_bg3, 51, 51, 10, 10)
	GUI:setContentSize(Image_bg3, 725, 200)
	GUI:setIgnoreContentAdaptWithSize(Image_bg3, false)
	GUI:setChineseName(Image_bg3, "充值_单笔赠送_背景图")
	GUI:setAnchorPoint(Image_bg3, 0.50, 1.00)
	GUI:setTouchEnabled(Image_bg3, false)
	GUI:setTag(Image_bg3, 60)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_input, "Text_1", 10.00, 425.00, 18, "#f8e6c6", [[本服名称:]])
	GUI:setChineseName(Text_1, "充值_本服名称_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 24)
	GUI:Text_enableOutline(Text_1, "#111111", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_input, "Text_2", 300.00, 425.00, 18, "#f8e6c6", [[充值角色:]])
	GUI:setChineseName(Text_2, "充值_充值角色_文本")
	GUI:setAnchorPoint(Text_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 25)
	GUI:Text_enableOutline(Text_2, "#111111", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_input, "Text_3", 10.00, 370.00, 18, "#f8e6c6", [[货币种类:]])
	GUI:setChineseName(Text_3, "充值_货币种类_文本")
	GUI:setAnchorPoint(Text_3, 0.00, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 20)
	GUI:Text_enableOutline(Text_3, "#111111", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_input, "Text_4", 10.00, 310.00, 18, "#f8e6c6", [[充值金额:]])
	GUI:setChineseName(Text_4, "充值_充值金额_文本")
	GUI:setAnchorPoint(Text_4, 0.00, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 31)
	GUI:Text_enableOutline(Text_4, "#111111", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_input, "Text_5", 10.00, 260.00, 18, "#f8e6c6", [[充值方式:]])
	GUI:setChineseName(Text_5, "充值_充值方式_文本")
	GUI:setAnchorPoint(Text_5, 0.00, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 33)
	GUI:Text_enableOutline(Text_5, "#111111", 1)

	-- Create Text_servername
	local Text_servername = GUI:Text_Create(Panel_input, "Text_servername", 95.00, 425.00, 18, "#f8e6c6", [[本服名称]])
	GUI:setChineseName(Text_servername, "充值_服务器名称_文本")
	GUI:setAnchorPoint(Text_servername, 0.00, 0.50)
	GUI:setTouchEnabled(Text_servername, false)
	GUI:setTag(Text_servername, 18)
	GUI:Text_enableOutline(Text_servername, "#111111", 1)

	-- Create Text_rolename
	local Text_rolename = GUI:Text_Create(Panel_input, "Text_rolename", 385.00, 425.00, 18, "#f8e6c6", [[充值角色]])
	GUI:setChineseName(Text_rolename, "充值_角色名字_文本")
	GUI:setAnchorPoint(Text_rolename, 0.00, 0.50)
	GUI:setTouchEnabled(Text_rolename, false)
	GUI:setTag(Text_rolename, 19)
	GUI:Text_enableOutline(Text_rolename, "#111111", 1)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_input, "ListView_cells", 100.00, 370.00, 600.00, 50.00, 2)
	GUI:ListView_setGravity(ListView_cells, 3)
	GUI:ListView_setItemsMargin(ListView_cells, 70)
	GUI:setChineseName(ListView_cells, "充值_主货币_列表")
	GUI:setAnchorPoint(ListView_cells, 0.00, 0.50)
	GUI:setTouchEnabled(ListView_cells, false)
	GUI:setTag(ListView_cells, 51)

	-- Create Image_input_bg
	local Image_input_bg = GUI:Image_Create(Panel_input, "Image_input_bg", 95.00, 310.00, "res/private/powerful_secret/input_bg.png")
	GUI:Image_setScale9Slice(Image_input_bg, 21, 21, 10, 8)
	GUI:setContentSize(Image_input_bg, 110, 27)
	GUI:setIgnoreContentAdaptWithSize(Image_input_bg, false)
	GUI:setChineseName(Image_input_bg, "充值_输入金额_背景图")
	GUI:setAnchorPoint(Image_input_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_input_bg, false)
	GUI:setTag(Image_input_bg, 56)

	-- Create TextField_input
	local TextField_input = GUI:TextInput_Create(Panel_input, "TextField_input", 97.00, 310.00, 105.00, 24.00, 18)
	GUI:TextInput_setString(TextField_input, "10")
	GUI:TextInput_setFontColor(TextField_input, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_input, 10)
	GUI:setChineseName(TextField_input, "充值_输入内容")
	GUI:setAnchorPoint(TextField_input, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_input, true)
	GUI:setTag(TextField_input, 22)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_input, "Text_6", 17.00, 293.00, 14, "#ffff00", [[输入金额]])
	GUI:setChineseName(Text_6, "充值_引导提示_文本")
	GUI:setAnchorPoint(Text_6, 0.00, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 24)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Text_exchange
	local Text_exchange = GUI:Text_Create(Panel_input, "Text_exchange", 210.00, 310.00, 18, "#f8e6c6", [[ss]])
	GUI:setChineseName(Text_exchange, "充值_获得结果_文本")
	GUI:setAnchorPoint(Text_exchange, 0.00, 0.50)
	GUI:setTouchEnabled(Text_exchange, false)
	GUI:setTag(Text_exchange, 32)
	GUI:Text_enableOutline(Text_exchange, "#111111", 1)

	-- Create Button_alipay
	local Button_alipay = GUI:Button_Create(Panel_input, "Button_alipay", 140.00, 260.00, "res/private/powerful_secret/bg_czzya_05.png")
	GUI:Button_setScale9Slice(Button_alipay, 15, 14, 13, 9)
	GUI:setContentSize(Button_alipay, 88, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_alipay, false)
	GUI:Button_setTitleText(Button_alipay, "")
	GUI:Button_setTitleColor(Button_alipay, "#414146")
	GUI:Button_setTitleFontSize(Button_alipay, 14)
	GUI:Button_titleEnableOutline(Button_alipay, "#000000", 1)
	GUI:setChineseName(Button_alipay, "充值_支付宝_图片")
	GUI:setAnchorPoint(Button_alipay, 0.50, 0.50)
	GUI:setTouchEnabled(Button_alipay, true)
	GUI:setTag(Button_alipay, 34)

	-- Create Image_flag
	local Image_flag = GUI:Image_Create(Button_alipay, "Image_flag", 88.00, 33.00, "res/private/powerful_secret/bg_czzya_05_1.png")
	GUI:setChineseName(Image_flag, "充值_支付宝选中_图片")
	GUI:setAnchorPoint(Image_flag, 1.00, 1.00)
	GUI:setTouchEnabled(Image_flag, false)
	GUI:setTag(Image_flag, 58)

	-- Create Button_huabei
	local Button_huabei = GUI:Button_Create(Panel_input, "Button_huabei", 250.00, 260.00, "res/private/powerful_secret/bg_czzya_06.png")
	GUI:Button_setScale9Slice(Button_huabei, 15, 14, 13, 9)
	GUI:setContentSize(Button_huabei, 88, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_huabei, false)
	GUI:Button_setTitleText(Button_huabei, "")
	GUI:Button_setTitleColor(Button_huabei, "#414146")
	GUI:Button_setTitleFontSize(Button_huabei, 14)
	GUI:Button_titleEnableOutline(Button_huabei, "#000000", 1)
	GUI:setChineseName(Button_huabei, "充值_花呗_图片")
	GUI:setAnchorPoint(Button_huabei, 0.50, 0.50)
	GUI:setTouchEnabled(Button_huabei, true)
	GUI:setTag(Button_huabei, 56)

	-- Create Image_flag
	local Image_flag = GUI:Image_Create(Button_huabei, "Image_flag", 88.00, 33.00, "res/private/powerful_secret/bg_czzya_06_1.png")
	GUI:setChineseName(Image_flag, "充值_花呗选中_图片")
	GUI:setAnchorPoint(Image_flag, 1.00, 1.00)
	GUI:setTouchEnabled(Image_flag, false)
	GUI:setTag(Image_flag, 57)

	-- Create Button_weixin
	local Button_weixin = GUI:Button_Create(Panel_input, "Button_weixin", 360.00, 260.00, "res/private/powerful_secret/bg_czzya_04.png")
	GUI:Button_setScale9Slice(Button_weixin, 15, 14, 13, 9)
	GUI:setContentSize(Button_weixin, 88, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_weixin, false)
	GUI:Button_setTitleText(Button_weixin, "")
	GUI:Button_setTitleColor(Button_weixin, "#414146")
	GUI:Button_setTitleFontSize(Button_weixin, 14)
	GUI:Button_titleEnableOutline(Button_weixin, "#000000", 1)
	GUI:setChineseName(Button_weixin, "充值_微信_图片")
	GUI:setAnchorPoint(Button_weixin, 0.50, 0.50)
	GUI:setTouchEnabled(Button_weixin, true)
	GUI:setTag(Button_weixin, 35)
	GUI:setVisible(Button_weixin, false)

	-- Create Image_flag
	local Image_flag = GUI:Image_Create(Button_weixin, "Image_flag", 88.00, 33.00, "res/private/powerful_secret/bg_czzya_04_1.png")
	GUI:setContentSize(Image_flag, 21, 21)
	GUI:setIgnoreContentAdaptWithSize(Image_flag, false)
	GUI:setChineseName(Image_flag, "充值_微信选中_图片")
	GUI:setAnchorPoint(Image_flag, 1.00, 1.00)
	GUI:setTouchEnabled(Image_flag, false)
	GUI:setTag(Image_flag, 59)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_input, "Button_submit", 640.00, 260.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 11, 11)
	GUI:setContentSize(Button_submit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "确认支付")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 18)
	GUI:Button_titleEnableOutline(Button_submit, "#000000", 1)
	GUI:setChineseName(Button_submit, "充值_确认支付_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 21)

	-- Create Node_desc
	local Node_desc = GUI:Node_Create(Panel_input, "Node_desc", 10.00, 195.00)
	GUI:setChineseName(Node_desc, "充值_充值说明_节点")
	GUI:setAnchorPoint(Node_desc, 0.50, 0.50)
	GUI:setTag(Node_desc, 50)

	-- Create Text_more
	local Text_more = GUI:Text_Create(Panel_input, "Text_more", 320.00, 260.00, 18, "#f8e6c6", [[更多支付方式]])
	GUI:setChineseName(Text_more, "充值_更多支付方式_文本")
	GUI:setAnchorPoint(Text_more, 0.00, 0.50)
	GUI:setTouchEnabled(Text_more, true)
	GUI:setTag(Text_more, 58)
	GUI:Text_enableOutline(Text_more, "#111111", 1)
end
return ui