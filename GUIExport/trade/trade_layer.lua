local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "交易场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 660.00, 25.00, 400.00, 480.00, false)
	GUI:setChineseName(PMainUI, "交易组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 2)

	-- Create Panel_self
	local Panel_self = GUI:Layout_Create(PMainUI, "Panel_self", 5.00, 0.00, 400.00, 280.00, false)
	GUI:setChineseName(Panel_self, "自己交易组合")
	GUI:setTouchEnabled(Panel_self, true)
	GUI:setTag(Panel_self, 4)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_self, "Image_bg", 185.00, 130.00, "res/private/trade/trade_ui_mobile/bg_jiaoyidi_01.png")
	GUI:setChineseName(Image_bg, "自己交易_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 6)

	-- Create Panel_addGold
	local Panel_addGold = GUI:Layout_Create(Panel_self, "Panel_addGold", 10.00, 8.00, 185.00, 45.00, false)
	GUI:setChineseName(Panel_addGold, "自己交易_添加货币")
	GUI:setTouchEnabled(Panel_addGold, true)
	GUI:setTag(Panel_addGold, 30)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_self, "Image_gold", 27.00, 27.00, "res/private/bag_ui/bag_ui_mobile/1900015220.png")
	GUI:setChineseName(Image_gold, "自己交易_货币图标")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, true)
	GUI:setTag(Image_gold, 13)

	-- Create Image_forbid
	local Image_forbid = GUI:Image_Create(Panel_self, "Image_forbid", 27.00, 27.00, "res/private/trade/trade_ui_mobile/jinzhi.png")
	GUI:setChineseName(Image_forbid, "自己交易_禁止_图片")
	GUI:setAnchorPoint(Image_forbid, 0.50, 0.50)
	GUI:setTouchEnabled(Image_forbid, true)
	GUI:setTag(Image_forbid, 14)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_self, "Panel_item", 19.00, 198.00, 340.00, 136.00, false)
	GUI:setChineseName(Panel_item, "自己交易_物品放置")
	GUI:setAnchorPoint(Panel_item, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 16)

	-- Create Panel_itemTouch
	local Panel_itemTouch = GUI:Layout_Create(Panel_self, "Panel_itemTouch", 19.00, 198.00, 340.00, 136.00, false)
	GUI:setChineseName(Panel_itemTouch, "自己交易_物品放置_触摸")
	GUI:setAnchorPoint(Panel_itemTouch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_itemTouch, false)
	GUI:setTag(Panel_itemTouch, 17)

	-- Create Panel_lockStatus
	local Panel_lockStatus = GUI:Layout_Create(Panel_self, "Panel_lockStatus", 19.00, 198.00, 340.00, 136.00, false)
	GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
	GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 102)
	GUI:setChineseName(Panel_lockStatus, "自己交易_锁定")
	GUI:setAnchorPoint(Panel_lockStatus, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_lockStatus, false)
	GUI:setTag(Panel_lockStatus, 36)
	GUI:setVisible(Panel_lockStatus, false)

	-- Create Image_lock
	local Image_lock = GUI:Image_Create(Panel_lockStatus, "Image_lock", 170.00, 68.00, "res/public/icon_tyzys_01.png")
	GUI:setChineseName(Image_lock, "自己交易_锁定_背景图")
	GUI:setAnchorPoint(Image_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Image_lock, false)
	GUI:setTag(Image_lock, 37)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_self, "Text_name", 102.00, 249.00, 18, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "自己交易_昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 8)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_gold
	local Text_gold = GUI:Text_Create(Panel_self, "Text_gold", 63.00, 37.00, 16, "#ffffff", [[0]])
	GUI:setChineseName(Text_gold, "自己交易_货币数量_文本")
	GUI:setAnchorPoint(Text_gold, 0.00, 0.50)
	GUI:setTouchEnabled(Text_gold, false)
	GUI:setTag(Text_gold, 9)
	GUI:Text_enableOutline(Text_gold, "#111111", 1)

	-- Create Image_locked
	local Image_locked = GUI:Image_Create(Panel_self, "Image_locked", 19.00, 199.00, "res/public/1900000678_3.png")
	GUI:setContentSize(Image_locked, 340, 136)
	GUI:setIgnoreContentAdaptWithSize(Image_locked, false)
	GUI:setChineseName(Image_locked, "自己交易_锁定_图片")
	GUI:setAnchorPoint(Image_locked, 0.00, 1.00)
	GUI:setTouchEnabled(Image_locked, false)
	GUI:setTag(Image_locked, 24)
	GUI:setVisible(Image_locked, false)

	-- Create Text_locked
	local Text_locked = GUI:Text_Create(Panel_self, "Text_locked", 281.00, 39.00, 16, "#ffe400", [[已锁定]])
	GUI:setChineseName(Text_locked, "自己交易_已锁定_文本")
	GUI:setAnchorPoint(Text_locked, 0.50, 0.50)
	GUI:setTouchEnabled(Text_locked, false)
	GUI:setTag(Text_locked, 23)
	GUI:setVisible(Text_locked, false)
	GUI:Text_enableOutline(Text_locked, "#111111", 2)

	-- Create Button_trade
	local Button_trade = GUI:Button_Create(Panel_self, "Button_trade", 324.00, 36.00, "res/private/bag_ui/bag_ui_mobile/1900015210.png")
	GUI:Button_loadTexturePressed(Button_trade, "res/private/bag_ui/bag_ui_mobile/1900015211.png")
	GUI:Button_setScale9Slice(Button_trade, 15, 15, 12, 10)
	GUI:setContentSize(Button_trade, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_trade, false)
	GUI:Button_setTitleText(Button_trade, "交易")
	GUI:Button_setTitleColor(Button_trade, "#ffe400")
	GUI:Button_setTitleFontSize(Button_trade, 16)
	GUI:Button_titleEnableOutline(Button_trade, "#111111", 2)
	GUI:setChineseName(Button_trade, "自己交易_交易_按钮")
	GUI:setAnchorPoint(Button_trade, 0.50, 0.50)
	GUI:setTouchEnabled(Button_trade, true)
	GUI:setTag(Button_trade, 11)

	-- Create Button_lock
	local Button_lock = GUI:Button_Create(Panel_self, "Button_lock", 235.00, 36.00, "res/private/bag_ui/bag_ui_mobile/1900015210.png")
	GUI:Button_loadTexturePressed(Button_lock, "res/private/bag_ui/bag_ui_mobile/1900015211.png")
	GUI:Button_setScale9Slice(Button_lock, 15, 15, 12, 10)
	GUI:setContentSize(Button_lock, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_lock, false)
	GUI:Button_setTitleText(Button_lock, "锁定")
	GUI:Button_setTitleColor(Button_lock, "#ffe400")
	GUI:Button_setTitleFontSize(Button_lock, 16)
	GUI:Button_titleEnableOutline(Button_lock, "#111111", 2)
	GUI:setChineseName(Button_lock, "自己交易_锁定_按钮")
	GUI:setAnchorPoint(Button_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Button_lock, true)
	GUI:setTag(Button_lock, 40)

	-- Create btnClose
	local btnClose = GUI:Button_Create(Panel_self, "btnClose", 383.00, 188.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(btnClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(btnClose, 8, 6, 12, 10)
	GUI:setContentSize(btnClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(btnClose, false)
	GUI:Button_setTitleText(btnClose, "")
	GUI:Button_setTitleColor(btnClose, "#414146")
	GUI:Button_setTitleFontSize(btnClose, 14)
	GUI:Button_titleDisableOutLine(btnClose)
	GUI:setChineseName(btnClose, "自己交易_关闭_按钮")
	GUI:setAnchorPoint(btnClose, 0.50, 0.50)
	GUI:setTouchEnabled(btnClose, true)
	GUI:setTag(btnClose, 12)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(btnClose, "TouchSize", 0.00, -5.00, 40.00, 45.00, false)
	GUI:setChineseName(TouchSize, "自己交易_触摸")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 15)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_other
	local Panel_other = GUI:Layout_Create(PMainUI, "Panel_other", 5.00, 285.00, 400.00, 280.00, false)
	GUI:setChineseName(Panel_other, "对方交易组合")
	GUI:setTouchEnabled(Panel_other, true)
	GUI:setTag(Panel_other, 3)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_other, "Image_bg", 184.00, 138.00, "res/private/trade/trade_ui_mobile/bg_jiaoyidi_01.png")
	GUI:setChineseName(Image_bg, "对方交易_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 5)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_other, "Image_gold", 25.00, 35.00, "res/private/bag_ui/bag_ui_mobile/1900015220.png")
	GUI:setChineseName(Image_gold, "对方交易_货币图标")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, false)
	GUI:setTag(Image_gold, 14)

	-- Create Image_forbid
	local Image_forbid = GUI:Image_Create(Panel_other, "Image_forbid", 25.00, 35.00, "res/private/trade/trade_ui_mobile/jinzhi.png")
	GUI:setChineseName(Image_forbid, "对方交易_禁止_图片")
	GUI:setAnchorPoint(Image_forbid, 0.50, 0.50)
	GUI:setTouchEnabled(Image_forbid, true)
	GUI:setTag(Image_forbid, 15)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_other, "Panel_item", 19.00, 205.00, 340.00, 136.00, false)
	GUI:setChineseName(Panel_item, "对方交易_物品放置")
	GUI:setAnchorPoint(Panel_item, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 18)

	-- Create Panel_lockStatus
	local Panel_lockStatus = GUI:Layout_Create(Panel_other, "Panel_lockStatus", 19.00, 205.00, 340.00, 136.00, false)
	GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
	GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 102)
	GUI:setChineseName(Panel_lockStatus, "对方交易_锁定")
	GUI:setAnchorPoint(Panel_lockStatus, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_lockStatus, false)
	GUI:setTag(Panel_lockStatus, 38)
	GUI:setVisible(Panel_lockStatus, false)

	-- Create Image_lock
	local Image_lock = GUI:Image_Create(Panel_lockStatus, "Image_lock", 170.00, 68.00, "res/public/icon_tyzys_01.png")
	GUI:setChineseName(Image_lock, "对方交易_锁定_背景图")
	GUI:setAnchorPoint(Image_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Image_lock, false)
	GUI:setTag(Image_lock, 39)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_other, "Text_name", 100.00, 256.00, 18, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "对方交易_昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 7)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_gold
	local Text_gold = GUI:Text_Create(Panel_other, "Text_gold", 64.00, 43.00, 16, "#ffffff", [[0]])
	GUI:setChineseName(Text_gold, "对方交易_货币数量_文本")
	GUI:setAnchorPoint(Text_gold, 0.00, 0.50)
	GUI:setTouchEnabled(Text_gold, false)
	GUI:setTag(Text_gold, 10)
	GUI:Text_enableOutline(Text_gold, "#111111", 1)

	-- Create Text_locked
	local Text_locked = GUI:Text_Create(Panel_other, "Text_locked", 282.00, 45.00, 16, "#ffe400", [[已锁定]])
	GUI:setChineseName(Text_locked, "对方交易_已锁定_文本")
	GUI:setAnchorPoint(Text_locked, 0.50, 0.50)
	GUI:setTouchEnabled(Text_locked, false)
	GUI:setTag(Text_locked, 22)
	GUI:setVisible(Text_locked, false)
	GUI:Text_enableOutline(Text_locked, "#111111", 2)

	-- Create Image_locked
	local Image_locked = GUI:Image_Create(Panel_other, "Image_locked", 19.00, 205.00, "res/public/1900000678_3.png")
	GUI:setContentSize(Image_locked, 340, 136)
	GUI:setIgnoreContentAdaptWithSize(Image_locked, false)
	GUI:setChineseName(Image_locked, "对方交易_锁定_图片")
	GUI:setAnchorPoint(Image_locked, 0.00, 1.00)
	GUI:setTouchEnabled(Image_locked, false)
	GUI:setTag(Image_locked, 25)
	GUI:setVisible(Image_locked, false)

	-- Create btnClose
	local btnClose = GUI:Button_Create(Panel_other, "btnClose", 383.00, 196.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(btnClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(btnClose, 8, 6, 12, 10)
	GUI:setContentSize(btnClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(btnClose, false)
	GUI:Button_setTitleText(btnClose, "")
	GUI:Button_setTitleColor(btnClose, "#414146")
	GUI:Button_setTitleFontSize(btnClose, 14)
	GUI:Button_titleDisableOutLine(btnClose)
	GUI:setChineseName(btnClose, "对方交易_关闭_按钮")
	GUI:setAnchorPoint(btnClose, 0.50, 0.50)
	GUI:setTouchEnabled(btnClose, true)
	GUI:setTag(btnClose, 20)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(btnClose, "TouchSize", 0.00, -5.00, 40.00, 46.00, false)
	GUI:setChineseName(TouchSize, "对方交易_关闭_触摸")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 21)
	GUI:setVisible(TouchSize, false)
end
return ui