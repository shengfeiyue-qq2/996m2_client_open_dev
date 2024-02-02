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
	GUI:setTag(Panel_2, 90)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_2, "Image_1_0", 0.00, 0.05, "res/public/bg_yyxsz_01.png")
	GUI:Image_setScale9Slice(Image_1_0, 75, 75, 0, 0)
	GUI:setContentSize(Image_1_0, 610, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setAnchorPoint(Image_1_0, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 91)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_2, "Image_7", 344.96, 14.87, "res/private/TradingBankLayer/word_jiaoyh_015.png")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 92)

	-- Create Text_roleName
	local Text_roleName = GUI:Text_Create(Panel_2, "Text_roleName", 122.82, 13.47, 18, "#ffffff", [[角色名称]])
	GUI:setAnchorPoint(Text_roleName, 0.50, 0.50)
	GUI:setTouchEnabled(Text_roleName, false)
	GUI:setTag(Text_roleName, 93)
	GUI:Text_enableOutline(Text_roleName, "#000000", 1)

	-- Create Panel_job1
	local Panel_job1 = GUI:Layout_Create(Panel_2, "Panel_job1", 221.81, 30.17, 68.00, 30.00, false)
	GUI:setAnchorPoint(Panel_job1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_job1, true)
	GUI:setTag(Panel_job1, 94)

	-- Create Text_job1
	local Text_job1 = GUI:Text_Create(Panel_job1, "Text_job1", 25.30, 13.29, 18, "#ffffff", [[职业]])
	GUI:setAnchorPoint(Text_job1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job1, false)
	GUI:setTag(Text_job1, 95)
	GUI:Text_enableOutline(Text_job1, "#000000", 1)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_job1, "Image_8", 54.31, 12.18, "res/private/TradingBankLayer/word_jiaoyh_017.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 96)

	-- Create Panel_level1
	local Panel_level1 = GUI:Layout_Create(Panel_2, "Panel_level1", 290.66, 30.83, 68.00, 30.00, false)
	GUI:setAnchorPoint(Panel_level1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_level1, true)
	GUI:setTag(Panel_level1, 107)

	-- Create Text_3_0
	local Text_3_0 = GUI:Text_Create(Panel_level1, "Text_3_0", 25.30, 12.63, 18, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_0, false)
	GUI:setTag(Text_3_0, 108)
	GUI:Text_enableOutline(Text_3_0, "#000000", 1)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_level1, "Image_8", 54.31, 12.18, "res/private/TradingBankLayer/word_jiaoyh_016.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 109)

	-- Create Panel_price1
	local Panel_price1 = GUI:Layout_Create(Panel_2, "Panel_price1", 359.27, 31.12, 109.00, 30.00, false)
	GUI:setAnchorPoint(Panel_price1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_price1, true)
	GUI:setTag(Panel_price1, 110)

	-- Create Text_3_0
	local Text_3_0 = GUI:Text_Create(Panel_price1, "Text_3_0", 48.33, 12.35, 18, "#ffffff", [[价格]])
	GUI:setAnchorPoint(Text_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_0, false)
	GUI:setTag(Text_3_0, 111)
	GUI:Text_enableOutline(Text_3_0, "#000000", 1)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_price1, "Image_8", 79.34, 12.35, "res/private/TradingBankLayer/word_jiaoyh_016.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 112)

	-- Create Text_3_0
	local Text_3_0 = GUI:Text_Create(Panel_2, "Text_3_0", 542.07, 13.47, 18, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_3_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3_0, false)
	GUI:setTag(Text_3_0, 113)
	GUI:Text_enableOutline(Text_3_0, "#000000", 1)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_1, "Panel_item", 318.69, 193.00, 612.00, 85.00, false)
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
	GUI:setTag(Image_head, 201)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_item, "Text_name", 138.33, 44.75, 16, "#ffffff", [[名字七个字啊啊]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 119)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_item, "Text_job", 252.51, 44.09, 16, "#ffffff", [[法师]])
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 120)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_item, "Text_level", 318.73, 42.74, 16, "#ffffff", [[99]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 121)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_pirce
	local Text_pirce = GUI:Text_Create(Panel_item, "Text_pirce", 416.93, 41.17, 16, "#ffffff", [[9999]])
	GUI:setAnchorPoint(Text_pirce, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pirce, false)
	GUI:setTag(Text_pirce, 122)
	GUI:Text_enableOutline(Text_pirce, "#000000", 1)

	-- Create Button_buy
	local Button_buy = GUI:Button_Create(Panel_item, "Button_buy", 540.60, 41.89, "res/private/TradingBankLayer/btn_jiaoyh_01.png")
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

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_1, "ListView_2", 306.00, 337.93, 612.00, 320.00, 1)
	GUI:setAnchorPoint(ListView_2, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 115)
end
return ui