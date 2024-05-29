local ui = {}
function ui.init(parent)
	-- Create item
	local item = GUI:Layout_Create(parent, "item", 0.00, 0.00, 220.00, 74.00, false)
	GUI:setChineseName(item, "邮件物品_组合")
	GUI:setTouchEnabled(item, true)
	GUI:setTag(item, 2)

	-- Create kuang01
	local kuang01 = GUI:Image_Create(item, "kuang01", 0.00, 0.00, "res/private/mail/1900020062.png")
	GUI:setChineseName(kuang01, "邮件物品_选中底图1")
	GUI:setTouchEnabled(kuang01, false)
	GUI:setTag(kuang01, 52)

	-- Create kuang02
	local kuang02 = GUI:Image_Create(item, "kuang02", 0.00, 0.00, "res/private/mail/1900020063.png")
	GUI:setChineseName(kuang02, "邮件物品_选中底图2")
	GUI:setTouchEnabled(kuang02, false)
	GUI:setTag(kuang02, 61)

	-- Create item_sender
	local item_sender = GUI:Text_Create(item, "item_sender", 15.00, 53.00, 18, "#a58e67", [[传奇团队]])
	GUI:setChineseName(item_sender, "邮件物品_发送对象")
	GUI:setAnchorPoint(item_sender, 0.00, 0.50)
	GUI:setTouchEnabled(item_sender, false)
	GUI:setTag(item_sender, 42)
	GUI:Text_enableOutline(item_sender, "#000000", 1)

	-- Create label_state
	local label_state = GUI:Text_Create(item, "label_state", 125.00, 53.00, 16, "#ff0500", [[已读]])
	GUI:setChineseName(label_state, "邮件物品_阅读状态_文本")
	GUI:setAnchorPoint(label_state, 0.50, 0.50)
	GUI:setTouchEnabled(label_state, false)
	GUI:setTag(label_state, 43)
	GUI:Text_enableOutline(label_state, "#111111", 1)

	-- Create item_title
	local item_title = GUI:Text_Create(item, "item_title", 15.00, 24.00, 18, "#897867", [[系统奖励]])
	GUI:setChineseName(item_title, "邮件物品_标题")
	GUI:setAnchorPoint(item_title, 0.00, 0.50)
	GUI:setTouchEnabled(item_title, false)
	GUI:setTag(item_title, 44)
	GUI:Text_enableOutline(item_title, "#000000", 1)

	-- Create btn_delete
	local btn_delete = GUI:Button_Create(item, "btn_delete", 190.00, 37.00, "res/private/mail/1900020065.png")
	GUI:Button_setTitleText(btn_delete, "")
	GUI:Button_setTitleColor(btn_delete, "#414146")
	GUI:Button_setTitleFontSize(btn_delete, 14)
	GUI:Button_titleDisableOutLine(btn_delete)
	GUI:setChineseName(btn_delete, "邮件物品_删除_图形按钮")
	GUI:setAnchorPoint(btn_delete, 0.50, 0.50)
	GUI:setScaleX(btn_delete, 0.80)
	GUI:setScaleY(btn_delete, 0.80)
	GUI:setTouchEnabled(btn_delete, true)
	GUI:setTag(btn_delete, 45)

	-- Create img_reward
	local img_reward = GUI:Image_Create(item, "img_reward", 251.00, 36.00, "Default/ImageFile.png")
	GUI:setContentSize(img_reward, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(img_reward, false)
	GUI:setChineseName(img_reward, "邮件物品_附件")
	GUI:setAnchorPoint(img_reward, 0.50, 0.50)
	GUI:setScaleX(img_reward, 0.80)
	GUI:setScaleY(img_reward, 0.80)
	GUI:setTouchEnabled(img_reward, false)
	GUI:setTag(img_reward, 46)
end
return ui