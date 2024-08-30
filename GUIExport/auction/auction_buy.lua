local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "竞拍一口价场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "竞拍_范围点击关闭区域")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 113)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 410.00, 270.00, false)
	GUI:setChineseName(Panel_2, "竞拍_一口价_组合框")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 89)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 205.00, 135.00, "res/public/1900000600.png")
	GUI:Image_setScale9Slice(Image_bg, 133, 131, 10, 10)
	GUI:setContentSize(Image_bg, 406, 265)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "竞拍_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 91)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_2, "Image_3", 204.00, 234.00, "res/private/auction/word_paimaihang_03.png")
	GUI:setChineseName(Image_3, "竞拍_一口价文字图片")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 92)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 421.00, 246.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "竞拍_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 115)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 107.00, 158.00, "res/public/1900000664.png")
	GUI:setChineseName(Image_icon, "竞拍_物品框")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 107.00, 112.00, 16, "#ffffff", [[装备名称]])
	GUI:setChineseName(Text_name, "竞拍_装备名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 95)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_name_0
	local Text_name_0 = GUI:Text_Create(Panel_2, "Text_name_0", 210.00, 165.00, 16, "#ffffff", [[购买数量:]])
	GUI:setChineseName(Text_name_0, "竞拍_购买数量_文本")
	GUI:setAnchorPoint(Text_name_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_0, false)
	GUI:setTag(Text_name_0, 73)
	GUI:Text_enableOutline(Text_name_0, "#000000", 1)

	-- Create Text_name_0_0
	local Text_name_0_0 = GUI:Text_Create(Panel_2, "Text_name_0_0", 210.00, 125.00, 16, "#ffffff", [[购买价格:]])
	GUI:setChineseName(Text_name_0_0, "竞拍_购买价格_文本")
	GUI:setAnchorPoint(Text_name_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_0_0, false)
	GUI:setTag(Text_name_0_0, 72)
	GUI:Text_enableOutline(Text_name_0_0, "#000000", 1)

	-- Create Image_16
	local Image_16 = GUI:Image_Create(Panel_2, "Image_16", 305.00, 165.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16, 29, 29, 9, 9)
	GUI:setContentSize(Image_16, 96, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_16, false)
	GUI:setChineseName(Image_16, "竞拍_购买数量输入框_图片")
	GUI:setAnchorPoint(Image_16, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16, false)
	GUI:setTag(Image_16, 117)

	-- Create Image_16_0
	local Image_16_0 = GUI:Image_Create(Panel_2, "Image_16_0", 305.00, 125.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0, 96, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0, false)
	GUI:setChineseName(Image_16_0, "竞拍_购买价格输入框_图片")
	GUI:setAnchorPoint(Image_16_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0, false)
	GUI:setTag(Image_16_0, 118)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_2, "Text_count", 305.00, 165.00, 16, "#ffffff", [[111]])
	GUI:setChineseName(Text_count, "竞拍_购买数量_文本")
	GUI:setAnchorPoint(Text_count, 0.50, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 98)
	GUI:Text_enableOutline(Text_count, "#111111", 1)

	-- Create Text_price
	local Text_price = GUI:Text_Create(Panel_2, "Text_price", 350.00, 125.00, 16, "#ffffff", [[6666]])
	GUI:setChineseName(Text_price, "竞拍_购买价格_文本")
	GUI:setAnchorPoint(Text_price, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price, false)
	GUI:setTag(Text_price, 101)
	GUI:Text_enableOutline(Text_price, "#111111", 1)

	-- Create Node_money
	local Node_money = GUI:Node_Create(Panel_2, "Node_money", 270.00, 125.00)
	GUI:setChineseName(Node_money, "竞拍_购买货币节点")
	GUI:setAnchorPoint(Node_money, 0.50, 0.50)
	GUI:setTag(Node_money, 102)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 115.00, 48.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 15, 11, 11)
	GUI:setContentSize(Button_cancel, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取  消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 18)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "竞拍_取消按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 111)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 295.00, 48.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 15, 11, 11)
	GUI:setContentSize(Button_submit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "确认购买")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 18)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "竞拍_确认购买按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 112)
end
return ui