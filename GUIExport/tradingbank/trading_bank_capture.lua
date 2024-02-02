local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 311)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 568.00, 320.00, "res/private/TradingBankLayer/bg_jiaoyh_06.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, true)
	GUI:setTag(Image_bg, 312)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Image_bg, "Button_1", 457.89, 51.51, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "上一步")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 19)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 313)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Image_bg, "Button_2", 609.26, 51.33, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "生成图片")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 19)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 314)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Image_bg, "Button_3", 671.52, 409.77, "res/public/1900001024.png")
	GUI:Button_setScale9Slice(Button_3, 15, 15, 12, 10)
	GUI:setContentSize(Button_3, 34, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_3, 19)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 315)

	-- Create Panel_1_1
	local Panel_1_1 = GUI:Layout_Create(Image_bg, "Panel_1_1", 0.00, 0.00, 714.00, 450.00, false)
	GUI:setTouchEnabled(Panel_1_1, false)
	GUI:setTag(Panel_1_1, 316)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1_1, "Text_1", 62.51, 322.00, 16, "#ffffff", [[步骤1:]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 317)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_1_1, "Text_2", 271.11, 322.00, 16, "#ffffff", [[步骤2:]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 318)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_1_1, "Text_3", 500.55, 322.00, 16, "#ffffff", [[步骤3:]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 319)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_1_1, "Text_4", 87.51, 293.22, 16, "#01c52c", [[点击生成图片]])
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 320)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_1_1, "Text_5", 352.61, 293.22, 16, "#01c52c", [[静候三秒将自动截取角色信息]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 321)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Text_6
	local Text_6 = GUI:Text_Create(Panel_1_1, "Text_6", 557.55, 293.22, 16, "#01c52c", [[点击寄售角色完成寄售]])
	GUI:setAnchorPoint(Text_6, 0.50, 0.50)
	GUI:setTouchEnabled(Text_6, false)
	GUI:setTag(Text_6, 322)
	GUI:Text_enableOutline(Text_6, "#000000", 1)

	-- Create Image_show3
	local Image_show3 = GUI:Image_Create(Panel_1_1, "Image_show3", 577.79, 202.12, "res/private/TradingBankLayer/word_jiaoyh_025.png")
	GUI:setContentSize(Image_show3, 198, 125)
	GUI:setIgnoreContentAdaptWithSize(Image_show3, false)
	GUI:setAnchorPoint(Image_show3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_show3, true)
	GUI:setTag(Image_show3, 323)

	-- Create Image_jt
	local Image_jt = GUI:Image_Create(Image_show3, "Image_jt", 173.13, 47.05, "res/private/TradingBankLayer/word_jiaoyh_020.png")
	GUI:setContentSize(Image_jt, 35.996398925781, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_jt, false)
	GUI:setAnchorPoint(Image_jt, 0.50, 0.50)
	GUI:setTouchEnabled(Image_jt, false)
	GUI:setTag(Image_jt, 324)

	-- Create Image_show2
	local Image_show2 = GUI:Image_Create(Panel_1_1, "Image_show2", 357.26, 203.60, "res/private/TradingBankLayer/word_jiaoyh_024.png")
	GUI:setContentSize(Image_show2, 198, 125)
	GUI:setIgnoreContentAdaptWithSize(Image_show2, false)
	GUI:setAnchorPoint(Image_show2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_show2, true)
	GUI:setTag(Image_show2, 325)

	-- Create Image_show1
	local Image_show1 = GUI:Image_Create(Panel_1_1, "Image_show1", 135.52, 205.07, "res/private/TradingBankLayer/word_jiaoyh_023.png")
	GUI:setContentSize(Image_show1, 198, 125)
	GUI:setIgnoreContentAdaptWithSize(Image_show1, false)
	GUI:setAnchorPoint(Image_show1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_show1, true)
	GUI:setTag(Image_show1, 326)

	-- Create Image_jt
	local Image_jt = GUI:Image_Create(Image_show1, "Image_jt", 173.55, 47.08, "res/private/TradingBankLayer/word_jiaoyh_020.png")
	GUI:setContentSize(Image_jt, 35.996398925781, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_jt, false)
	GUI:setAnchorPoint(Image_jt, 0.50, 0.50)
	GUI:setTouchEnabled(Image_jt, false)
	GUI:setTag(Image_jt, 327)

	-- Create Panel_1_2
	local Panel_1_2 = GUI:Layout_Create(Image_bg, "Panel_1_2", 0.00, 0.00, 714.00, 450.00, false)
	GUI:setTouchEnabled(Panel_1_2, false)
	GUI:setTag(Panel_1_2, 328)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1_2, "Text_1", 355.55, 365.06, 16, "#ffffff", [[          点击图片生成按钮，自动截取关键页面数据，提高角色售卖概率截取图片过程中请不要进行其他操作，截取时间为三秒左右]])
	GUI:setIgnoreContentAdaptWithSize(Text_1,false)
	GUI:setContentSize(Text_1,650,55)
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 329)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_1_2, "Button_4", 64.19, 410.85, "res/public/1900000611.png")
	GUI:Button_setScale9Slice(Button_4, 16, 14, 12, 10)
	GUI:setContentSize(Button_4, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_4, false)
	GUI:Button_setTitleText(Button_4, "重新生成")
	GUI:Button_setTitleColor(Button_4, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_4, 16)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 330)

	-- Create Panel_p
	local Panel_p = GUI:ScrollView_Create(Panel_1_2, "Panel_p", 19.14, 349.66, 680.00, 206.00, 1)
	GUI:ScrollView_setBounceEnabled(Panel_p, true)
	GUI:ScrollView_setInnerContainerSize(Panel_p, 680.00, 206.00)
	GUI:setAnchorPoint(Panel_p, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_p, true)
	GUI:setTag(Panel_p, 331)

	-- Create Image_cp
	local Image_cp = GUI:Image_Create(Panel_1_2, "Image_cp", 87.47, 307.15, "Default/ImageFile.png")
	GUI:setContentSize(Image_cp, 113.59999847412, 64)
	GUI:setIgnoreContentAdaptWithSize(Image_cp, false)
	GUI:setAnchorPoint(Image_cp, 0.50, 0.50)
	GUI:setTouchEnabled(Image_cp, true)
	GUI:setTag(Image_cp, 332)

	-- Create Panel_look
	local Panel_look = GUI:Layout_Create(Image_bg, "Panel_look", 358.11, 226.27, 1.00, 1.00, false)
	GUI:setAnchorPoint(Panel_look, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_look, false)
	GUI:setTag(Panel_look, 333)

	-- Create Button_5
	local Button_5 = GUI:Button_Create(Image_bg, "Button_5", 724.95, 427.24, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_5, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_5, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_5, 8, 6, 12, 10)
	GUI:setContentSize(Button_5, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_5, false)
	GUI:Button_setTitleText(Button_5, "")
	GUI:Button_setTitleColor(Button_5, "#414146")
	GUI:Button_setTitleFontSize(Button_5, 14)
	GUI:Button_titleDisableOutLine(Button_5)
	GUI:setAnchorPoint(Button_5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_5, true)
	GUI:setTag(Button_5, 334)

	-- Create Panel_1_3
	local Panel_1_3 = GUI:Layout_Create(Panel_2, "Panel_1_3", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(Panel_1_3, 1)
	GUI:Layout_setBackGroundColor(Panel_1_3, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_1_3, 102)
	GUI:setTouchEnabled(Panel_1_3, true)
	GUI:setTag(Panel_1_3, 335)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Panel_1_3, "Panel_3", 568.00, 320.00, 244.00, 244.00, false)
	GUI:setAnchorPoint(Panel_3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_3, true)
	GUI:setTag(Panel_3, 336)

	-- Create Image_rotate
	local Image_rotate = GUI:Image_Create(Panel_3, "Image_rotate", 122.00, 122.00, "res/private/TradingBankLayer/progressbg.png")
	GUI:setAnchorPoint(Image_rotate, 0.50, 0.50)
	GUI:setScaleX(Image_rotate, -1.00)
	GUI:setTouchEnabled(Image_rotate, false)
	GUI:setTag(Image_rotate, 337)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_3, "Text_1", 122.68, 148.34, 35, "#ffffff", [[寄售中:]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 338)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_pp
	local Text_pp = GUI:Text_Create(Panel_3, "Text_pp", 122.06, 104.91, 35, "#ffffff", [[0%]])
	GUI:setAnchorPoint(Text_pp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pp, false)
	GUI:setTag(Text_pp, 339)
	GUI:Text_enableOutline(Text_pp, "#000000", 1)
end
return ui