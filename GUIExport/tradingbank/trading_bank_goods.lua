local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 12)

	-- Create Panel_11
	local Panel_11 = GUI:Layout_Create(Panel_1, "Panel_11", 0.00, 414.80, 732.00, 33.00, false)
	GUI:setTouchEnabled(Panel_11, false)
	GUI:setTag(Panel_11, 9)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_11, "ListView_2", 366.00, -4.77, 732.00, 408.00, 1)
	GUI:setAnchorPoint(ListView_2, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 596)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_11, "Image_1_0", 0.00, -0.95, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_0, 75, 75, 0, 0)
	GUI:setContentSize(Image_1_0, 732, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setAnchorPoint(Image_1_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 10)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_11, "Text_3", 94.82, 14.32, 18, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 15)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Image_1_0_0
	local Image_1_0_0 = GUI:Image_Create(Panel_11, "Image_1_0_0", 190.37, 14.71, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_1_0_0, 0, 0, 0, 0)
	GUI:setContentSize(Image_1_0_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0_0, false)
	GUI:setAnchorPoint(Image_1_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0_0, false)
	GUI:setTag(Image_1_0_0, 590)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_11, "Text_4", 235.37, 14.32, 18, "#ffffff", [[数量]])
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 16)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Image_1_0_0_0
	local Image_1_0_0_0 = GUI:Image_Create(Panel_11, "Image_1_0_0_0", 277.07, 14.71, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_1_0_0_0, 0, 0, 0, 0)
	GUI:setContentSize(Image_1_0_0_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0_0_0, false)
	GUI:setAnchorPoint(Image_1_0_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0_0_0, false)
	GUI:setTag(Image_1_0_0_0, 593)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_11, "Text_5", 334.72, 14.32, 18, "#ffffff", [[价格]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 24)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Image_1_0_0_0_0
	local Image_1_0_0_0_0 = GUI:Image_Create(Panel_11, "Image_1_0_0_0_0", 393.40, 14.71, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_1_0_0_0_0, 0, 0, 0, 0)
	GUI:setContentSize(Image_1_0_0_0_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0_0_0_0, false)
	GUI:setAnchorPoint(Image_1_0_0_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0_0_0_0, false)
	GUI:setTag(Image_1_0_0_0_0, 594)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_11, "Text_6", 435.90, 14.32, 18, "#ffffff", [[状态]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 21)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Image_1_0_0_0_0_0
	local Image_1_0_0_0_0_0 = GUI:Image_Create(Panel_11, "Image_1_0_0_0_0_0", 476.66, 14.71, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_1_0_0_0_0_0, 0, 0, 0, 0)
	GUI:setContentSize(Image_1_0_0_0_0_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0_0_0_0_0, false)
	GUI:setAnchorPoint(Image_1_0_0_0_0_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0_0_0_0_0, false)
	GUI:setTag(Image_1_0_0_0_0_0, 595)

	-- Create Text_7
	local Text_7 = GUI:Text_Create(Panel_11, "Text_7", 599.91, 14.32, 18, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_7, 0.50, 0.50)
	GUI:setTouchEnabled(Text_7, false)
	GUI:setTag(Text_7, 26)
	GUI:Text_enableOutline(Text_7, "#000000", 1)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_1, "Panel_item", 365.65, 352.80, 732.00, 85.00, false)
	GUI:setAnchorPoint(Panel_item, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 43)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_item, "Image_bg", 1.02, 1.50, "res/private/TradingBankLayer/word_jiaoyh_019.png")
	GUI:Image_setScale9Slice(Image_bg, 201, 201, 28, 26)
	GUI:setContentSize(Image_bg, 732, 82)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 44)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_item, "Image_item", 42.32, 42.51, "res/private/TradingBankLayer/1900000651.png")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 45)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Image_item, "Image_head", 30.00, 30.00, "res/private/TradingBankLayer/img_011.png")
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 84)

	-- Create Text_goodname
	local Text_goodname = GUI:Text_Create(Panel_item, "Text_goodname", 120.78, 42.82, 16, "#ffffff", [[职业：战士]])
	GUI:setAnchorPoint(Text_goodname, 0.50, 0.50)
	GUI:setTouchEnabled(Text_goodname, false)
	GUI:setTag(Text_goodname, 46)
	GUI:Text_enableOutline(Text_goodname, "#000000", 1)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_item, "Text_num", 236.72, 42.82, 16, "#ffffff", [[100000]])
	GUI:setAnchorPoint(Text_num, 0.50, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 47)
	GUI:Text_enableOutline(Text_num, "#000000", 1)

	-- Create Text_pirce
	local Text_pirce = GUI:Text_Create(Panel_item, "Text_pirce", 334.07, 42.82, 16, "#ffffff", [[88888888]])
	GUI:setAnchorPoint(Text_pirce, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pirce, false)
	GUI:setTag(Text_pirce, 48)
	GUI:Text_enableOutline(Text_pirce, "#000000", 1)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_item, "Text_state", 438.38, 42.82, 16, "#ffffff", [[上架中]])
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 49)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_item, "Button_1", 524.75, 41.63, "res/public/1900000611.png")
	GUI:Button_setScale9Slice(Button_1, 16, 14, 12, 10)
	GUI:setContentSize(Button_1, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "上架")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 16)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 51)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_item, "Button_2", 603.53, 41.63, "res/public/1900000611.png")
	GUI:Button_setScale9Slice(Button_2, 16, 14, 12, 10)
	GUI:setContentSize(Button_2, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "取回")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 16)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 591)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_item, "Button_3", 682.32, 41.63, "res/public/1900000611.png")
	GUI:Button_setScale9Slice(Button_3, 16, 14, 12, 10)
	GUI:setContentSize(Button_3, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "修改")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 16)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 592)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Panel_1, "Text_tips", 366.00, 222.50, 20, "#2abb2a", [[使用交易行需先验证身份信息,避免出现盗号现象]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 86)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)

	-- Create Button_tips
	local Button_tips = GUI:Button_Create(Panel_1, "Button_tips", 366.00, 176.66, "res/public/1900000680.png")
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
	GUI:setTag(Button_tips, 273)
end
return ui