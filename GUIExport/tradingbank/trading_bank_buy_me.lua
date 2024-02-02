local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 612.00, 368.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 89)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 0.00, 339.00, 612.00, 33.00, false)
	GUI:setTouchEnabled(Panel_2, false)
	GUI:setTag(Panel_2, 184)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_2, "Image_1_0", -0.00, -0.00, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_0, 75, 75, 0, 0)
	GUI:setContentSize(Image_1_0, 610, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setAnchorPoint(Image_1_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 185)

	-- Create Image_32
	local Image_32 = GUI:Image_Create(Panel_2, "Image_32", 213.14, 15.21, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_32, 0, 0, 199, 199)
	GUI:setContentSize(Image_32, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_32, false)
	GUI:setAnchorPoint(Image_32, 0.50, 0.50)
	GUI:setTouchEnabled(Image_32, false)
	GUI:setTag(Image_32, 186)

	-- Create Image_32_0
	local Image_32_0 = GUI:Image_Create(Panel_2, "Image_32_0", 376.18, 15.94, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_32_0, 0, 0, 199, 199)
	GUI:setContentSize(Image_32_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_32_0, false)
	GUI:setAnchorPoint(Image_32_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_32_0, false)
	GUI:setTag(Image_32_0, 187)

	-- Create Image_32_0_0_0
	local Image_32_0_0_0 = GUI:Image_Create(Panel_2, "Image_32_0_0_0", 480.65, 15.72, "res/public/bg_yyxsz_02.png")
	GUI:Image_setScale9Slice(Image_32_0_0_0, 0, 0, 199, 199)
	GUI:setContentSize(Image_32_0_0_0, 2, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_32_0_0_0, false)
	GUI:setAnchorPoint(Image_32_0_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_32_0_0_0, false)
	GUI:setTag(Image_32_0_0_0, 188)

	-- Create Panel_type3
	local Panel_type3 = GUI:Layout_Create(Panel_2, "Panel_type3", 0.17, 30.29, 213.00, 30.00, false)
	GUI:setAnchorPoint(Panel_type3, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_type3, true)
	GUI:setTag(Panel_type3, 189)

	-- Create Text_type3
	local Text_type3 = GUI:Text_Create(Panel_type3, "Text_type3", 102.09, 14.95, 18, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_type3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_type3, false)
	GUI:setTag(Text_type3, 190)
	GUI:Text_enableOutline(Text_type3, "#000000", 1)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_type3, "Image_8", 131.67, 14.18, "res/private/TradingBankLayer/word_jiaoyh_017.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 191)

	-- Create Text_3_0
	local Text_3_0 = GUI:Text_Create(Panel_2, "Text_3_0", 291.11, 15.24, 18, "#ffffff", [[寄售人]])
	GUI:setAnchorPoint(Text_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_0, false)
	GUI:setTag(Text_3_0, 200)
	GUI:Text_enableOutline(Text_3_0, "#000000", 1)

	-- Create Panel_price3
	local Panel_price3 = GUI:Layout_Create(Panel_2, "Panel_price3", 377.27, 1.07, 104.00, 30.00, false)
	GUI:setTouchEnabled(Panel_price3, true)
	GUI:setTag(Panel_price3, 201)

	-- Create Text_3_0
	local Text_3_0 = GUI:Text_Create(Panel_price3, "Text_3_0", 46.76, 14.18, 18, "#ffffff", [[价格]])
	GUI:setAnchorPoint(Text_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_0, false)
	GUI:setTag(Text_3_0, 202)
	GUI:Text_enableOutline(Text_3_0, "#000000", 1)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_price3, "Image_8", 77.34, 14.18, "res/private/TradingBankLayer/word_jiaoyh_016.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 203)

	-- Create Text_3_1
	local Text_3_1 = GUI:Text_Create(Panel_2, "Text_3_1", 541.50, 15.24, 18, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_3_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_1, false)
	GUI:setTag(Text_3_1, 204)
	GUI:Text_enableOutline(Text_3_1, "#000000", 1)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_1, "ListView_2", 306.00, 337.93, 612.00, 337.93, 1)
	GUI:setAnchorPoint(ListView_2, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 115)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_1, "Panel_item", 306.01, 148.42, 612.00, 85.00, false)
	GUI:setAnchorPoint(Panel_item, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 116)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_item, "Image_bg", 0.86, 1.50, "res/private/TradingBankLayer/word_jiaoyh_019.png")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 117)

	-- Create Image_item
	local Image_item = GUI:Image_Create(Panel_item, "Image_item", 41.32, 42.51, "res/private/TradingBankLayer/1900000651.png")
	GUI:setAnchorPoint(Image_item, 0.50, 0.50)
	GUI:setTouchEnabled(Image_item, false)
	GUI:setTag(Image_item, 118)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Image_item, "Image_head", 30.00, 30.00, "res/private/TradingBankLayer/img_011.png")
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 133)

	-- Create Text_goodname
	local Text_goodname = GUI:Text_Create(Panel_item, "Text_goodname", 138.33, 44.75, 16, "#ffffff", [[名字七个字啊啊]])
	GUI:setAnchorPoint(Text_goodname, 0.50, 0.50)
	GUI:setTouchEnabled(Text_goodname, false)
	GUI:setTag(Text_goodname, 119)
	GUI:Text_enableOutline(Text_goodname, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_item, "Text_name", 292.51, 44.09, 16, "#ffffff", [[法师]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 120)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_pirce
	local Text_pirce = GUI:Text_Create(Panel_item, "Text_pirce", 432.73, 42.74, 16, "#ffffff", [[99]])
	GUI:setAnchorPoint(Text_pirce, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pirce, false)
	GUI:setTag(Text_pirce, 121)
	GUI:Text_enableOutline(Text_pirce, "#000000", 1)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_item, "Button_buy", 547.60, 41.89, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
	GUI:Button_loadTexturePressed(Button_buy, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_loadTextureDisabled(Button_buy, "res/private/TradingBankLayer/btn_jiaoyh_02.png")
	GUI:Button_setScale9Slice(Button_buy, 15, 15, 12, 10)
	GUI:setContentSize(Button_buy, 91, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_buy, false)
	GUI:Button_setTitleText(Button_buy, "购买")
	GUI:Button_setTitleColor(Button_buy, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_buy, 16)
	GUI:Button_titleEnableOutline(Button_buy, "#000000", 1)
	GUI:setAnchorPoint(Button_buy, 0.50, 0.50)
	GUI:setTouchEnabled(Button_buy, true)
	GUI:setTag(Button_buy, 123)
end
return ui