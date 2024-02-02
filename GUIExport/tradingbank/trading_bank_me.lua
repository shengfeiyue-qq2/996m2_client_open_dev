local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 89)

	-- Create Panel_show
	local Panel_show = GUI:Layout_Create(Panel_1, "Panel_show", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(Panel_show, true)
	GUI:setTag(Panel_show, 415)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show, "Text_1", 103.62, 408.73, 20, "#f8e6c6", [[我的交易币:]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 369)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_show, "Text_1_0", 112.62, 353.77, 20, "#f8e6c6", [[待入账交易币:]])
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 370)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Text_1_0_0
	local Text_1_0_0 = GUI:Text_Create(Panel_show, "Text_1_0_0", 252.64, 232.18, 18, "#2abb2a", [[提现需下载996盒子,点击提现跳转至对应下载入口]])
	GUI:setAnchorPoint(Text_1_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0_0, false)
	GUI:setTag(Text_1_0_0, 386)
	GUI:Text_enableOutline(Text_1_0_0, "#000000", 1)

	-- Create Text_me
	local Text_me = GUI:Text_Create(Panel_show, "Text_me", 162.94, 408.61, 20, "#f8e6c6", [[0]])
	GUI:setAnchorPoint(Text_me, 0.00, 0.50)
	GUI:setTouchEnabled(Text_me, false)
	GUI:setTag(Text_me, 371)
	GUI:Text_enableOutline(Text_me, "#000000", 1)

	-- Create Text_wait
	local Text_wait = GUI:Text_Create(Panel_show, "Text_wait", 181.29, 353.78, 20, "#f8e6c6", [[0]])
	GUI:setAnchorPoint(Text_wait, 0.00, 0.50)
	GUI:setTouchEnabled(Text_wait, false)
	GUI:setTag(Text_wait, 372)
	GUI:Text_enableOutline(Text_wait, "#000000", 1)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_show, "Button_4", 672.41, 406.00, "res/public/1900001024.png")
	GUI:Button_setTitleText(Button_4, "")
	GUI:Button_setTitleColor(Button_4, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_4, 24)
	GUI:Button_titleDisableOutLine(Button_4)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setScaleX(Button_4, 0.90)
	GUI:setScaleY(Button_4, 0.90)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 387)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_show, "Button_3", 107.85, 292.82, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 11, 11)
	GUI:setContentSize(Button_3, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "提现")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 24)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setScaleX(Button_3, 0.90)
	GUI:setScaleY(Button_3, 0.90)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 385)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show, "Text_2", 54.64, 176.87, 18, "#2abb2a", [[]])
	GUI:setAnchorPoint(Text_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 47)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Button_tips
	local Button_tips = GUI:Button_Create(Node, "Button_tips", 366.00, 176.99, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_tips, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_tips, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_tips, 15, 15, 11, 11)
	GUI:setContentSize(Button_tips, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_tips, false)
	GUI:Button_setTitleText(Button_tips, "验证身份")
	GUI:Button_setTitleColor(Button_tips, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_tips, 19)
	GUI:Button_titleEnableOutline(Button_tips, "#000000", 1)
	GUI:setAnchorPoint(Button_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Button_tips, true)
	GUI:setTag(Button_tips, 472)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Node, "Text_tips", 366.00, 222.00, 20, "#2abb2a", [[使用交易行需先验证身份信息,避免出现盗号现象]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 473)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)
end
return ui