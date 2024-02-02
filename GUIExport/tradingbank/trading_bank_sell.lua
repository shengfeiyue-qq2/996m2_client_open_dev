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

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 0.00, 382.00, 732.00, 382.00, false)
	GUI:setAnchorPoint(Panel_2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_2, false)
	GUI:setTag(Panel_2, 180)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_2, "Text_1", 76.31, 327.74, 20, "#f8e6c6", [[寄 售 角 色:]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 182)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_2, "Text_2", 139.09, 327.37, 20, "#ffffff", [[当前角色 ]])
	GUI:setAnchorPoint(Text_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 183)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_2, "Text_3", 76.31, 236.88, 20, "#f8e6c6", [[出 售 总 价:]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 184)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_sxf1
	local Text_sxf1 = GUI:Text_Create(Panel_2, "Text_sxf1", 422.41, 237.57, 20, "#ffffff", [[手续费10%]])
	GUI:setAnchorPoint(Text_sxf1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_sxf1, false)
	GUI:setTag(Text_sxf1, 188)
	GUI:Text_enableOutline(Text_sxf1, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_2, "Text_5", 14.08, 233.16, 22, "#ff0000", [[*]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 189)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 247.90, 236.88, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_1, 8, 8, 10, 10)
	GUI:setContentSize(Image_1, 220, 34)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 186)

	-- Create Text_most1
	local Text_most1 = GUI:Text_Create(Image_1, "Text_most1", 1.03, -14.06, 16, "#76684f", [[最低售价]])
	GUI:setAnchorPoint(Text_most1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_most1, false)
	GUI:setTag(Text_most1, 124)
	GUI:Text_enableOutline(Text_most1, "#000000", 1)

	-- Create TextField_1
	local TextField_1 = GUI:TextInput_Create(Image_1, "TextField_1", 110.00, 17.00, 220.00, 34.00, 20)
	GUI:TextInput_setString(TextField_1, "")
	GUI:TextInput_setFontColor(TextField_1, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_1, 13)
	GUI:setAnchorPoint(TextField_1, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_1, true)
	GUI:setTag(TextField_1, 185)

	-- Create Text_most3_0
	local Text_most3_0 = GUI:Text_Create(Panel_2, "Text_most3_0", 142.31, 297.13, 16, "#76684f", [[寄售后的角色将无法登录]])
	GUI:setAnchorPoint(Text_most3_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_most3_0, false)
	GUI:setTag(Text_most3_0, 106)
	GUI:Text_enableOutline(Text_most3_0, "#000000", 1)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Panel_1, "Panel_3", 0.00, 0.00, 732.00, 382.00, false)
	GUI:setTouchEnabled(Panel_3, false)
	GUI:setTag(Panel_3, 119)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_3, "Text_1", 74.81, 350.45, 20, "#f8e6c6", [[货 币 种 类:]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 120)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_3, "Text_2", 74.81, 282.31, 20, "#f8e6c6", [[出 售 数 量:]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 142)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_3, "Text_3", 74.81, 214.16, 20, "#f8e6c6", [[出 售 总 价:]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 122)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_sxf2
	local Text_sxf2 = GUI:Text_Create(Panel_3, "Text_sxf2", 422.42, 214.21, 20, "#ffffff", [[手续费10%]])
	GUI:setAnchorPoint(Text_sxf2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_sxf2, false)
	GUI:setTag(Text_sxf2, 123)
	GUI:Text_enableOutline(Text_sxf2, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_3, "Text_5", 14.08, 209.80, 22, "#ff0000", [[*]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 124)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Text_13
	local Text_13 = GUI:Text_Create(Panel_3, "Text_13", 15.08, 280.51, 22, "#ff0000", [[*]])
	GUI:setAnchorPoint(Text_13, 0.50, 0.50)
	GUI:setTouchEnabled(Text_13, false)
	GUI:setTag(Text_13, 145)
	GUI:Text_enableOutline(Text_13, "#000000", 1)

	-- Create Image_0
	local Image_0 = GUI:Image_Create(Panel_3, "Image_0", 247.90, 282.23, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_0, 8, 8, 10, 10)
	GUI:setContentSize(Image_0, 220, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_0, false)
	GUI:setAnchorPoint(Image_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_0, false)
	GUI:setTag(Image_0, 143)

	-- Create TextField_2
	local TextField_2 = GUI:TextInput_Create(Image_0, "TextField_2", 110.00, 16.00, 220.00, 32.00, 20)
	GUI:TextInput_setString(TextField_2, "")
	GUI:TextInput_setFontColor(TextField_2, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_2, 13)
	GUI:setAnchorPoint(TextField_2, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_2, true)
	GUI:setTag(TextField_2, 144)

	-- Create Panel_mask1
	local Panel_mask1 = GUI:Layout_Create(Image_0, "Panel_mask1", 0.00, 0.00, 220.00, 32.00, false)
	GUI:setTouchEnabled(Panel_mask1, true)
	GUI:setTag(Panel_mask1, 90)

	-- Create Text_most3
	local Text_most3 = GUI:Text_Create(Image_0, "Text_most3", 1.72, -11.78, 16, "#76684f", [[最低出售数量]])
	GUI:setAnchorPoint(Text_most3, 0.00, 0.50)
	GUI:setTouchEnabled(Text_most3, false)
	GUI:setTag(Text_most3, 54)
	GUI:Text_enableOutline(Text_most3, "#000000", 1)

	-- Create Text_mostdi
	local Text_mostdi = GUI:Text_Create(Image_0, "Text_mostdi", 227.60, 16.41, 16, "#76684f", [[最低售价:]])
	GUI:setAnchorPoint(Text_mostdi, 0.00, 0.50)
	GUI:setTouchEnabled(Text_mostdi, false)
	GUI:setTag(Text_mostdi, 271)
	GUI:Text_enableOutline(Text_mostdi, "#000000", 1)

	-- Create ScrollView_money
	local ScrollView_money = GUI:ScrollView_Create(Panel_3, "ScrollView_money", 139.21, 370.40, 500.00, 41.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_money, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_money, 500.00, 94.00)
	GUI:setAnchorPoint(ScrollView_money, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_money, true)
	GUI:setTag(ScrollView_money, 327)

	-- Create Panel_CheckBox
	local Panel_CheckBox = GUI:Layout_Create(Panel_3, "Panel_CheckBox", 145.57, 370.33, 218.00, 40.00, false)
	GUI:setAnchorPoint(Panel_CheckBox, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_CheckBox, true)
	GUI:setTag(Panel_CheckBox, 322)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(Panel_CheckBox, "CheckBox", 16.66, 20.14, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox, true)
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, false)
	GUI:setTag(CheckBox, 146)

	-- Create Text_money
	local Text_money = GUI:Text_Create(Panel_CheckBox, "Text_money", 32.28, 20.14, 20, "#ffffff", [[金币(余:200000000)]])
	GUI:setAnchorPoint(Text_money, 0.00, 0.50)
	GUI:setTouchEnabled(Text_money, false)
	GUI:setTag(Text_money, 148)
	GUI:Text_enableOutline(Text_money, "#000000", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_3, "Image_1", 247.90, 213.51, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_1, 8, 8, 10, 10)
	GUI:setContentSize(Image_1, 220, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 132)

	-- Create Text_most2
	local Text_most2 = GUI:Text_Create(Image_1, "Text_most2", 1.72, -12.51, 16, "#76684f", [[最低售价]])
	GUI:setAnchorPoint(Text_most2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_most2, false)
	GUI:setTag(Text_most2, 125)
	GUI:Text_enableOutline(Text_most2, "#000000", 1)

	-- Create TextField_3
	local TextField_3 = GUI:TextInput_Create(Image_1, "TextField_3", 110.00, 16.00, 220.00, 32.00, 20)
	GUI:TextInput_setString(TextField_3, "")
	GUI:TextInput_setFontColor(TextField_3, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_3, 13)
	GUI:setAnchorPoint(TextField_3, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_3, true)
	GUI:setTag(TextField_3, 133)

	-- Create Panel_mask2
	local Panel_mask2 = GUI:Layout_Create(Image_1, "Panel_mask2", -1.20, -1.04, 220.00, 32.00, false)
	GUI:setTouchEnabled(Panel_mask2, true)
	GUI:setTag(Panel_mask2, 91)

	-- Create Panel_common
	local Panel_common = GUI:Layout_Create(Panel_1, "Panel_common", 0.00, 445.00, 732.00, 445.00, false)
	GUI:setAnchorPoint(Panel_common, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_common, false)
	GUI:setTag(Panel_common, 174)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_common, "Text_1_0", 74.81, 418.59, 20, "#f8e6c6", [[售 卖 类 型:]])
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 173)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create CheckBox_1
	local CheckBox_1 = GUI:CheckBox_Create(Panel_common, "CheckBox_1", 152.47, 418.75, "res/private/TradingBankLayer/word_jiaoyh_022.png", "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:CheckBox_setSelected(CheckBox_1, false)
	GUI:setAnchorPoint(CheckBox_1, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_1, true)
	GUI:setTag(CheckBox_1, 175)

	-- Create CheckBox_2
	local CheckBox_2 = GUI:CheckBox_Create(Panel_common, "CheckBox_2", 269.48, 418.75, "res/private/TradingBankLayer/word_jiaoyh_022.png", "res/private/TradingBankLayer/word_jiaoyh_021.png")
	GUI:CheckBox_setSelected(CheckBox_2, true)
	GUI:setAnchorPoint(CheckBox_2, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_2, true)
	GUI:setTag(CheckBox_2, 187)

	-- Create Text_1_1
	local Text_1_1 = GUI:Text_Create(Panel_common, "Text_1_1", 195.10, 419.28, 20, "#f8e6c6", [[角色]])
	GUI:setAnchorPoint(Text_1_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_1, false)
	GUI:setTag(Text_1_1, 177)
	GUI:Text_enableOutline(Text_1_1, "#000000", 1)

	-- Create Text_1_2
	local Text_1_2 = GUI:Text_Create(Panel_common, "Text_1_2", 314.16, 419.28, 20, "#f8e6c6", [[货币]])
	GUI:setAnchorPoint(Text_1_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_2, false)
	GUI:setTag(Text_1_2, 179)
	GUI:Text_enableOutline(Text_1_2, "#000000", 1)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_common, "Text_6", 74.81, 146.52, 19, "#f8e6c6", [[指定购买人:]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 125)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Text_7
	local Text_7 = GUI:Text_Create(Panel_common, "Text_7", 375.05, 145.64, 16, "#ff0000", [[查无此人]])
	GUI:setAnchorPoint(Text_7, 0.00, 0.50)
	GUI:setTouchEnabled(Text_7, false)
	GUI:setTag(Text_7, 126)
	GUI:Text_enableOutline(Text_7, "#000000", 1)

	-- Create Text_8
	local Text_8 = GUI:Text_Create(Panel_common, "Text_8", 138.80, 114.65, 16, "#76684f", [[如需指定售卖,需输入对方的角色名称]])
	GUI:setAnchorPoint(Text_8, 0.00, 0.50)
	GUI:setTouchEnabled(Text_8, false)
	GUI:setTag(Text_8, 127)
	GUI:Text_enableOutline(Text_8, "#000000", 1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_common, "Image_2", 247.90, 145.65, "res/private/TradingBankLayer/word_jiaoyh_022.png")
	GUI:Image_setScale9Slice(Image_2, 8, 8, 10, 10)
	GUI:setContentSize(Image_2, 220, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 134)

	-- Create TextField_4
	local TextField_4 = GUI:TextInput_Create(Image_2, "TextField_4", 110.00, 16.00, 220.00, 32.00, 20)
	GUI:TextInput_setString(TextField_4, "")
	GUI:TextInput_setFontColor(TextField_4, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_4, 32)
	GUI:setAnchorPoint(TextField_4, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_4, true)
	GUI:setTag(TextField_4, 135)

	-- Create Panel_mask3
	local Panel_mask3 = GUI:Layout_Create(Image_2, "Panel_mask3", -0.60, 0.16, 220.00, 32.00, false)
	GUI:setTouchEnabled(Panel_mask3, true)
	GUI:setTag(Panel_mask3, 92)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_common, "Button_1", 694.08, 418.27, "res/public/1900001024.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 12, 10)
	GUI:setContentSize(Button_1, 34, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#414146")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 181)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_common, "Button_2", 366.00, 36.39, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "下一步")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 19)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 141)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(Panel_1, "Text_tips", 366.00, 222.50, 20, "#2abb2a", [[使用交易行需先验证身份信息,避免出现盗号现象]])
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 45)
	GUI:Text_enableOutline(Text_tips, "#000000", 1)

	-- Create Button_tips
	local Button_tips = GUI:Button_Create(Panel_1, "Button_tips", 366.00, 178.99, "res/public/1900000680.png")
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
	GUI:setTag(Button_tips, 272)
end
return ui