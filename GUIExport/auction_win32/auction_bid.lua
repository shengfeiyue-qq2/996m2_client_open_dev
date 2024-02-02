local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "竞拍场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "竞拍_范围点击关闭区域")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 137)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 350.00, 210.00, false)
	GUI:setChineseName(Panel_2, "竞拍_组合框")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 120)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 175.00, 105.00, "res/public/1900000600.png")
	GUI:Image_setScale9Slice(Image_bg, 149, 147, 59, 58)
	GUI:setContentSize(Image_bg, 350, 210)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "竞拍_背景图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 122)

	-- Create Image_6
	local Image_6 = GUI:Image_Create(Panel_2, "Image_6", 175.00, 180.00, "res/private/auction-win32/word_paimaihang_02.png")
	GUI:setChineseName(Image_6, "竞拍_抬头文字")
	GUI:setAnchorPoint(Image_6, 0.50, 0.50)
	GUI:setTouchEnabled(Image_6, false)
	GUI:setTag(Image_6, 46)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_2, "Image_2", 175.00, 165.00, "res/public/1900000667.png")
	GUI:setChineseName(Image_2, "竞拍_分隔符")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 88)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 349.00, 210.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "竞拍_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 125)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_2, "Image_icon", 60.00, 120.00, "res/public_win32/1900000664.png")
	GUI:setChineseName(Image_icon, "竞拍_物品框")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 126)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_2, "Text_name", 60.00, 80.00, 12, "#ffffff", [[装备名称]])
	GUI:setChineseName(Text_name, "竞拍_装备名称_文字")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 127)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_name_0
	local Text_name_0 = GUI:Text_Create(Panel_2, "Text_name_0", 145.00, 140.00, 12, "#ffffff", [[当前竞价:]])
	GUI:setChineseName(Text_name_0, "竞拍_当前竞价_文字")
	GUI:setAnchorPoint(Text_name_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_0, false)
	GUI:setTag(Text_name_0, 47)
	GUI:Text_enableOutline(Text_name_0, "#000000", 1)

	-- Create Text_name_0_0
	local Text_name_0_0 = GUI:Text_Create(Panel_2, "Text_name_0_0", 145.00, 115.00, 12, "#ffffff", [[加价金额:]])
	GUI:setChineseName(Text_name_0_0, "竞拍_加价金额_文字")
	GUI:setAnchorPoint(Text_name_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_0_0, false)
	GUI:setTag(Text_name_0_0, 48)
	GUI:Text_enableOutline(Text_name_0_0, "#000000", 1)

	-- Create Text_name_0_1
	local Text_name_0_1 = GUI:Text_Create(Panel_2, "Text_name_0_1", 145.00, 70.00, 12, "#ffffff", [[出价金额:]])
	GUI:setChineseName(Text_name_0_1, "竞拍_出价金额_文字")
	GUI:setAnchorPoint(Text_name_0_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_0_1, false)
	GUI:setTag(Text_name_0_1, 49)
	GUI:Text_enableOutline(Text_name_0_1, "#000000", 1)

	-- Create Image_16_0
	local Image_16_0 = GUI:Image_Create(Panel_2, "Image_16_0", 235.00, 140.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0, 95, 15)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0, false)
	GUI:setChineseName(Image_16_0, "竞拍_当前竞价_文本框")
	GUI:setAnchorPoint(Image_16_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0, false)
	GUI:setTag(Image_16_0, 131)

	-- Create Image_16_0_0
	local Image_16_0_0 = GUI:Image_Create(Panel_2, "Image_16_0_0", 235.00, 115.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0_0, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0_0, 95, 15)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0_0, false)
	GUI:setChineseName(Image_16_0_0, "竞拍_加价金额_文本框")
	GUI:setAnchorPoint(Image_16_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0_0, false)
	GUI:setTag(Image_16_0_0, 50)

	-- Create Image_16_0_1
	local Image_16_0_1 = GUI:Image_Create(Panel_2, "Image_16_0_1", 235.00, 70.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_16_0_1, 29, 29, 9, 9)
	GUI:setContentSize(Image_16_0_1, 95, 15)
	GUI:setIgnoreContentAdaptWithSize(Image_16_0_1, false)
	GUI:setChineseName(Image_16_0_1, "竞拍_出价金额_文本框")
	GUI:setAnchorPoint(Image_16_0_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_16_0_1, false)
	GUI:setTag(Image_16_0_1, 51)

	-- Create Text_price
	local Text_price = GUI:Text_Create(Panel_2, "Text_price", 280.00, 140.00, 12, "#ffffff", [[1500]])
	GUI:setChineseName(Text_price, "竞拍_当前竞价_显示文本")
	GUI:setAnchorPoint(Text_price, 1.00, 0.50)
	GUI:setTouchEnabled(Text_price, false)
	GUI:setTag(Text_price, 132)
	GUI:Text_enableOutline(Text_price, "#111111", 1)

	-- Create TextField_add_price
	local TextField_add_price = GUI:TextInput_Create(Panel_2, "TextField_add_price", 275.00, 115.00, 70.00, 15.00, 12)
	GUI:TextInput_setString(TextField_add_price, "6666666")
	GUI:TextInput_setFontColor(TextField_add_price, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_add_price, 10)
	GUI:setChineseName(TextField_add_price, "竞拍_加价金额_可编辑文本")
	GUI:setAnchorPoint(TextField_add_price, 1.00, 0.50)
	GUI:setTouchEnabled(TextField_add_price, true)
	GUI:setTag(TextField_add_price, 317)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 290.00, 115.00, "res/public/btn_szjm_04.png")
	GUI:setChineseName(Image_1, "竞拍_加价金额_可编辑标识")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setScaleX(Image_1, 0.70)
	GUI:setScaleY(Image_1, 0.70)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 86)

	-- Create Text_bid_price
	local Text_bid_price = GUI:Text_Create(Panel_2, "Text_bid_price", 280.00, 70.00, 12, "#ffff0f", [[6666]])
	GUI:setChineseName(Text_bid_price, "竞拍_出价金额_显示文本")
	GUI:setAnchorPoint(Text_bid_price, 1.00, 0.50)
	GUI:setTouchEnabled(Text_bid_price, false)
	GUI:setTag(Text_bid_price, 142)
	GUI:Text_enableOutline(Text_bid_price, "#111111", 1)

	-- Create Node_money1
	local Node_money1 = GUI:Node_Create(Panel_2, "Node_money1", 200.00, 140.00)
	GUI:setChineseName(Node_money1, "竞拍_当前竞价_货币节点")
	GUI:setAnchorPoint(Node_money1, 0.50, 0.50)
	GUI:setTag(Node_money1, 138)

	-- Create Node_money2
	local Node_money2 = GUI:Node_Create(Panel_2, "Node_money2", 200.00, 115.00)
	GUI:setChineseName(Node_money2, "竞拍_加价金额_货币节点")
	GUI:setAnchorPoint(Node_money2, 0.50, 0.50)
	GUI:setTag(Node_money2, 139)

	-- Create Node_money3
	local Node_money3 = GUI:Node_Create(Panel_2, "Node_money3", 200.00, 70.00)
	GUI:setChineseName(Node_money3, "竞拍_出价金额_货币节点")
	GUI:setAnchorPoint(Node_money3, 0.50, 0.50)
	GUI:setTag(Node_money3, 134)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 105.00, 30.00, "res/public_win32/1900000679.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public_win32/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 30, 11, 18)
	GUI:setContentSize(Button_cancel, 57, 25)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取  消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 12)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "竞拍_取消按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 135)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_2, "Button_submit", 245.00, 30.00, "res/public_win32/1900000679.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/public_win32/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_submit, 15, 30, 11, 18)
	GUI:setContentSize(Button_submit, 57, 25)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "确认出价")
	GUI:Button_setTitleColor(Button_submit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_submit, 12)
	GUI:Button_titleEnableOutline(Button_submit, "#111111", 2)
	GUI:setChineseName(Button_submit, "竞拍_确定按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 136)
end
return ui