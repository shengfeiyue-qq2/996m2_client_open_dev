local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "保护设置场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(Scene, "Panel_cancle", 568.00, 320.00, 3000.00, 3000.00, false)
	GUI:setChineseName(Panel_cancle, "保护设置_范围点击关闭")
	GUI:setAnchorPoint(Panel_cancle, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 107)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 831.00, 325.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 110, 109, 142, 142)
	GUI:setContentSize(Panel_1, 335, 433)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setChineseName(Panel_1, "保护设置组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 141)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_1, "Image_7", 167.00, 407.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_7, 33, 33, 9, 9)
	GUI:setContentSize(Image_7, 317, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_7, false)
	GUI:setChineseName(Image_7, "保护设置_标题_组合")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_7, "Text_1", 55.00, 14.00, 20, "#ffffff", [[优先级]])
	GUI:setChineseName(Text_1, "保护设置_优先级_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_7, "Text_2", 200.00, 14.00, 20, "#ffffff", [[物品名称]])
	GUI:setChineseName(Text_2, "保护设置_物品名称_文本")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 240)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 12.00, 86.00, 312.00, 306.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:ListView_setItemsMargin(ListView_1, 1)
	GUI:setChineseName(ListView_1, "保护设置_物品_列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 224)

	-- Create Panel_tips
	local Panel_tips = GUI:Layout_Create(Panel_1, "Panel_tips", 16.00, 43.00, 304.00, 37.00, false)
	GUI:setChineseName(Panel_tips, "保护设置_提示_文本")
	GUI:setTouchEnabled(Panel_tips, false)
	GUI:setTag(Panel_tips, 195)

	-- Create Panel_time1
	local Panel_time1 = GUI:Layout_Create(Panel_1, "Panel_time1", 10.00, 10.00, 314.00, 39.00, false)
	GUI:setChineseName(Panel_time1, "保护设置_使用间隔组合")
	GUI:setTouchEnabled(Panel_time1, true)
	GUI:setTag(Panel_time1, 15)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_time1, "Text_1_0", 118.00, 17.00, 16, "#ffffff", [[使用间隔]])
	GUI:setChineseName(Text_1_0, "保护设置_使用间隔_文本")
	GUI:setAnchorPoint(Text_1_0, 1.00, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, 14)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create Image_10
	local Image_10 = GUI:Image_Create(Panel_time1, "Image_10", 126.00, 17.00, "res/private/new_setting/textBg.png")
	GUI:setContentSize(Image_10, 88, 29)
	GUI:setIgnoreContentAdaptWithSize(Image_10, false)
	GUI:setChineseName(Image_10, "保护设置_间隔_背景框")
	GUI:setAnchorPoint(Image_10, 0.00, 0.50)
	GUI:setTouchEnabled(Image_10, false)
	GUI:setTag(Image_10, 410)

	-- Create TextField_input
	local TextField_input = GUI:TextInput_Create(Image_10, "TextField_input", 4.00, 15.00, 79.00, 25.00, 20)
	GUI:TextInput_setString(TextField_input, "")
	GUI:TextInput_setPlaceHolder(TextField_input, "1000")
	GUI:TextInput_setFontColor(TextField_input, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_input, 10)
	GUI:setChineseName(TextField_input, "保护设置_输入内容")
	GUI:setAnchorPoint(TextField_input, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_input, true)
	GUI:setTag(TextField_input, 241)

	-- Create Text_1_0_0
	local Text_1_0_0 = GUI:Text_Create(Panel_time1, "Text_1_0_0", 237.00, 17.00, 16, "#ffffff", [[毫秒]])
	GUI:setChineseName(Text_1_0_0, "保护设置_毫秒_文本")
	GUI:setAnchorPoint(Text_1_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0_0, false)
	GUI:setTag(Text_1_0_0, 16)
	GUI:Text_enableOutline(Text_1_0_0, "#000000", 1)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Panel_1, "Panel_touch", 10.00, 395.00, 315.00, 306.00, false)
	GUI:setChineseName(Panel_touch, "保护设置_触摸")
	GUI:setAnchorPoint(Panel_touch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 31)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 348.00, 412.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "保护设置_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 408)
end
return ui