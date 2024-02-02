local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "邮件场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create bg
	local bg = GUI:Layout_Create(Scene, "bg", 0.00, 0.00, 606.00, 390.00, true)
	GUI:setChineseName(bg, "邮件组合")
	GUI:setTouchEnabled(bg, true)
	GUI:setTag(bg, 2)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(bg, "Image_7", 0.00, 0.00, "res/private/mail_win32/1900020061.png")
	GUI:setChineseName(Image_7, "邮件_装饰图")
	GUI:setContentSize(Image_7, 606, 390)
	GUI:setIgnoreContentAdaptWithSize(Image_7, false)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 98)

	-- Create list
	local list = GUI:ListView_Create(bg, "list", 5.00, 50.00, 187.00, 330.00, 1)
	GUI:ListView_setGravity(list, 5)
	GUI:setChineseName(list, "邮件_列表")
	GUI:setTouchEnabled(list, true)
	GUI:setTag(list, 37)

	-- Create btn_takeOut_all
	local btn_takeOut_all = GUI:Button_Create(bg, "btn_takeOut_all", 52.00, 25.00, "res/public_win32/1900000612.png")
	GUI:Button_setTitleText(btn_takeOut_all, "全部提取")
	GUI:Button_setTitleColor(btn_takeOut_all, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_takeOut_all, 12)
	GUI:Button_titleEnableOutline(btn_takeOut_all, "#111111", 2)
	GUI:setChineseName(btn_takeOut_all, "邮件_全部提取_按钮")
	GUI:setAnchorPoint(btn_takeOut_all, 0.50, 0.50)
	GUI:setTouchEnabled(btn_takeOut_all, true)
	GUI:setTag(btn_takeOut_all, 4)

	-- Create btn_delete_read
	local btn_delete_read = GUI:Button_Create(bg, "btn_delete_read", 145.00, 25.00, "res/public_win32/1900000612.png")
	GUI:Button_setTitleText(btn_delete_read, "删除已读")
	GUI:Button_setTitleColor(btn_delete_read, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_delete_read, 12)
	GUI:Button_titleEnableOutline(btn_delete_read, "#111111", 2)
	GUI:setChineseName(btn_delete_read, "邮件_删除已读_按钮")
	GUI:setAnchorPoint(btn_delete_read, 0.50, 0.50)
	GUI:setTouchEnabled(btn_delete_read, true)
	GUI:setTag(btn_delete_read, 5)

	-- Create panel_main
	local panel_main = GUI:Layout_Create(bg, "panel_main", 200.00, 0.00, 414.00, 390.00, true)
	GUI:setChineseName(panel_main, "邮件详情")
	GUI:setTouchEnabled(panel_main, false)
	GUI:setTag(panel_main, 6)

	-- Create panel_title
	local panel_title = GUI:Layout_Create(panel_main, "panel_title", 2.00, 360.00, 400.00, 24.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(panel_title, 11, -2544, 11, 88)
	GUI:Layout_setBackGroundImage(panel_title, "res/private/mail/1900020064.png")
	GUI:setChineseName(panel_title, "邮件主题组合")
	GUI:setTouchEnabled(panel_title, false)
	GUI:setTag(panel_title, 7)

	-- Create mail_title
	local mail_title = GUI:Text_Create(panel_title, "mail_title", 10.00, 13.00, 12, "#a58e67", [[主题：]])
	GUI:setChineseName(mail_title, "邮件_主题_文本")
	GUI:setAnchorPoint(mail_title, 0.00, 0.50)
	GUI:setTouchEnabled(mail_title, false)
	GUI:setTag(mail_title, 8)
	GUI:Text_enableOutline(mail_title, "#000000", 1)

	-- Create label_title
	local label_title = GUI:Text_Create(panel_title, "label_title", 60.00, 13.00, 12, "#f8e6c6", [[]])
	GUI:setChineseName(label_title, "邮件_主题内容_文本")
	GUI:setAnchorPoint(label_title, 0.00, 0.50)
	GUI:setTouchEnabled(label_title, false)
	GUI:setTag(label_title, 9)
	GUI:Text_enableOutline(label_title, "#111111", 2)

	-- Create panel_sender
	local panel_sender = GUI:Layout_Create(panel_main, "panel_sender", 2.00, 338.00, 400.00, 24.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(panel_sender, 11, -2544, 11, 88)
	GUI:Layout_setBackGroundImage(panel_sender, "res/private/mail/1900020064.png")
	GUI:setChineseName(panel_sender, "邮件发送者组合")
	GUI:setTouchEnabled(panel_sender, false)
	GUI:setTag(panel_sender, 10)

	-- Create mail_sender
	local mail_sender = GUI:Text_Create(panel_sender, "mail_sender", 10.00, 13.00, 12, "#a58e67", [[发送者：]])
	GUI:setChineseName(mail_sender, "邮件_发送者_文本")
	GUI:setAnchorPoint(mail_sender, 0.00, 0.50)
	GUI:setTouchEnabled(mail_sender, false)
	GUI:setTag(mail_sender, 11)
	GUI:Text_enableOutline(mail_sender, "#000000", 1)

	-- Create label_sender
	local label_sender = GUI:Text_Create(panel_sender, "label_sender", 80.00, 13.00, 12, "#f8e6c6", [[]])
	GUI:setChineseName(label_sender, "邮件_发送者内容_文本")
	GUI:setAnchorPoint(label_sender, 0.00, 0.50)
	GUI:setTouchEnabled(label_sender, false)
	GUI:setTag(label_sender, 12)
	GUI:Text_enableOutline(label_sender, "#111111", 2)

	-- Create panel_time
	local panel_time = GUI:Layout_Create(panel_main, "panel_time", 2.00, 315.00, 400.00, 24.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(panel_time, 11, -2544, 11, 88)
	GUI:Layout_setBackGroundImage(panel_time, "res/private/mail/1900020064.png")
	GUI:setChineseName(panel_time, "邮件时间组合")
	GUI:setTouchEnabled(panel_time, false)
	GUI:setTag(panel_time, 13)

	-- Create time
	local time = GUI:Text_Create(panel_time, "time", 10.00, 13.00, 12, "#a58e67", [[时间：]])
	GUI:setChineseName(time, "邮件_时间_文本")
	GUI:setAnchorPoint(time, 0.00, 0.50)
	GUI:setTouchEnabled(time, false)
	GUI:setTag(time, 14)
	GUI:Text_enableOutline(time, "#000000", 1)

	-- Create label_time
	local label_time = GUI:Text_Create(panel_time, "label_time", 60.00, 13.00, 12, "#f8e6c6", [[]])
	GUI:setChineseName(label_time, "邮件_时间内容_文本")
	GUI:setAnchorPoint(label_time, 0.00, 0.50)
	GUI:setTouchEnabled(label_time, false)
	GUI:setTag(label_time, 15)
	GUI:Text_enableOutline(label_time, "#111111", 2)

	-- Create panel_mailContent
	local panel_mailContent = GUI:Layout_Create(panel_main, "panel_mailContent", 7.00, 125.00, 390.00, 185.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(panel_mailContent, 11, -2474, 11, -1039)
	GUI:Layout_setBackGroundImage(panel_mailContent, "res/private/mail/1900020064.png")
	GUI:setChineseName(panel_mailContent, "邮件_详细内容_文本")
	GUI:setTouchEnabled(panel_mailContent, false)
	GUI:setTag(panel_mailContent, 16)

	-- Create list_mailContent
	local list_mailContent = GUI:ListView_Create(panel_main, "list_mailContent", 12.00, 132.00, 380.00, 173.00, 1)
	GUI:ListView_setGravity(list_mailContent, 5)
	GUI:setChineseName(list_mailContent, "邮件_详细内容_列表")
	GUI:setTouchEnabled(list_mailContent, true)
	GUI:setTag(list_mailContent, 36)

	-- Create Text_item
	local Text_item = GUI:Text_Create(panel_main, "Text_item", 23.00, 84.00, 12, "#ffffff", [[附
件]])
	GUI:setChineseName(Text_item, "邮件_附件_文本")
	GUI:setAnchorPoint(Text_item, 0.50, 0.50)
	GUI:setTouchEnabled(Text_item, false)
	GUI:setTag(Text_item, 42)
	GUI:Text_enableOutline(Text_item, "#000000", 1)

	-- Create list_items
	local list_items = GUI:ListView_Create(panel_main, "list_items", 35.00, 50.00, 342.00, 70.00, 2)
	GUI:ListView_setGravity(list_items, 5)
	GUI:ListView_setItemsMargin(list_items, 5)
	GUI:setChineseName(list_items, "邮件_附件物品_列表")
	GUI:setTouchEnabled(list_items, true)
	GUI:setTag(list_items, 48)

	-- Create rewardFlag_icon
	local rewardFlag_icon = GUI:Image_Create(panel_main, "rewardFlag_icon", 200.00, 85.00, "res/public/word_bqzy_01.png")
	GUI:setChineseName(rewardFlag_icon, "邮件_领取状态_图标")
	GUI:setAnchorPoint(rewardFlag_icon, 0.50, 0.50)
	GUI:setTouchEnabled(rewardFlag_icon, false)
	GUI:setTag(rewardFlag_icon, 48)
	GUI:setVisible(rewardFlag_icon, false)

	-- Create btn_takeOut
	local btn_takeOut = GUI:Button_Create(panel_main, "btn_takeOut", 270.00, 25.00, "res/public_win32/1900000611.png")
	GUI:Button_setTitleText(btn_takeOut, "提  取")
	GUI:Button_setTitleColor(btn_takeOut, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_takeOut, 12)
	GUI:Button_titleEnableOutline(btn_takeOut, "#111111", 2)
	GUI:setChineseName(btn_takeOut, "邮件_提取_按钮")
	GUI:setAnchorPoint(btn_takeOut, 0.50, 0.50)
	GUI:setTouchEnabled(btn_takeOut, true)
	GUI:setTag(btn_takeOut, 19)

	-- Create btn_delete
	local btn_delete = GUI:Button_Create(panel_main, "btn_delete", 360.00, 25.00, "res/public_win32/1900000611.png")
	GUI:Button_setTitleText(btn_delete, "删  除")
	GUI:Button_setTitleColor(btn_delete, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_delete, 12)
	GUI:Button_titleEnableOutline(btn_delete, "#111111", 2)
	GUI:setChineseName(btn_delete, "邮件_删除_按钮")
	GUI:setAnchorPoint(btn_delete, 0.50, 0.50)
	GUI:setTouchEnabled(btn_delete, true)
	GUI:setTag(btn_delete, 20)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(btn_delete, "TouchSize", 28.00, 12.00, 79.80, 35.00, false)
	GUI:Layout_setBackGroundColorType(TouchSize, 1)
	GUI:Layout_setBackGroundColor(TouchSize, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(TouchSize, 102)
	GUI:setChineseName(TouchSize, "邮件_删除_图标")
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 47)
	GUI:setVisible(TouchSize, false)
end
return ui