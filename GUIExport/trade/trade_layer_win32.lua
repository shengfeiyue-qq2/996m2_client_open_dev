local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "交易场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 594.00, 190.00, 280.00, 480.00, false)
	GUI:setChineseName(PMainUI, "交易组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 43)

	-- Create Panel_self
	local Panel_self = GUI:Layout_Create(PMainUI, "Panel_self", 0.00, 26.00, 280.00, 200.00, false)
	GUI:setChineseName(Panel_self, "自己交易组合")
	GUI:setTouchEnabled(Panel_self, true)
	GUI:setTag(Panel_self, 44)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_self, "Image_bg", 140.00, 100.00, "res/private/trade/trade_ui_win32/bg_jiaoyidi_02.png")
	GUI:setChineseName(Image_bg, "自己交易_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 45)

	-- Create Panel_addGold
	local Panel_addGold = GUI:Layout_Create(Panel_self, "Panel_addGold", 25.00, 16.00, 132.00, 40.00, false)
	GUI:setChineseName(Panel_addGold, "自己交易_添加货币")
	GUI:setTouchEnabled(Panel_addGold, true)
	GUI:setTag(Panel_addGold, 46)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_self, "Image_gold", 45.00, 35.00, "res/private/bag_ui/bag_ui_win32/1900015220.png")
	GUI:setChineseName(Image_gold, "自己交易_货币图标")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, true)
	GUI:setTag(Image_gold, 47)

	-- Create Image_forbid
	local Image_forbid = GUI:Image_Create(Panel_self, "Image_forbid", 45.00, 35.00, "res/private/trade/trade_ui_win32/jinzhi.png")
	GUI:setChineseName(Image_forbid, "自己交易_禁止_图片")
	GUI:setAnchorPoint(Image_forbid, 0.50, 0.50)
	GUI:setTouchEnabled(Image_forbid, true)
	GUI:setTag(Image_forbid, 14)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_self, "Panel_item", 33.00, 146.00, 210.00, 84.00, false)
	GUI:setChineseName(Panel_item, "自己交易_物品放置")
	GUI:setAnchorPoint(Panel_item, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 48)

	-- Create Panel_itemTouch
	local Panel_itemTouch = GUI:Layout_Create(Panel_self, "Panel_itemTouch", 33.00, 146.00, 210.00, 84.00, false)
	GUI:setChineseName(Panel_itemTouch, "自己交易_物品放置_触摸")
	GUI:setAnchorPoint(Panel_itemTouch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_itemTouch, false)
	GUI:setTag(Panel_itemTouch, 49)

	-- Create Panel_lockStatus
	local Panel_lockStatus = GUI:Layout_Create(Panel_self, "Panel_lockStatus", 33.00, 146.00, 210.00, 84.00, false)
	GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
	GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 102)
	GUI:setChineseName(Panel_lockStatus, "自己交易_锁定")
	GUI:setAnchorPoint(Panel_lockStatus, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_lockStatus, false)
	GUI:setTag(Panel_lockStatus, 50)
	GUI:setVisible(Panel_lockStatus, false)

	-- Create Image_lock
	local Image_lock = GUI:Image_Create(Panel_lockStatus, "Image_lock", 105.00, 42.00, "res/public/icon_tyzys_01.png")
	GUI:setChineseName(Image_lock, "自己交易_锁定_背景图")
	GUI:setAnchorPoint(Image_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Image_lock, false)
	GUI:setTag(Image_lock, 51)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_self, "Text_name", 140.00, 175.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "自己交易_昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 52)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_gold
	local Text_gold = GUI:Text_Create(Panel_self, "Text_gold", 80.00, 47.00, 16, "#ffffff", [[0]])
	GUI:setChineseName(Text_gold, "自己交易_货币数量_文本")
	GUI:setAnchorPoint(Text_gold, 0.00, 0.50)
	GUI:setTouchEnabled(Text_gold, false)
	GUI:setTag(Text_gold, 53)
	GUI:Text_enableOutline(Text_gold, "#111111", 1)

	-- Create Image_locked
	local Image_locked = GUI:Image_Create(Panel_self, "Image_locked", 33.00, 146.00, "res/public/1900000678_3.png")
	GUI:setContentSize(Image_locked, 210, 84)
	GUI:setIgnoreContentAdaptWithSize(Image_locked, false)
	GUI:setChineseName(Image_locked, "自己交易_锁定_图片")
	GUI:setAnchorPoint(Image_locked, 0.00, 1.00)
	GUI:setTouchEnabled(Image_locked, false)
	GUI:setTag(Image_locked, 54)
	GUI:setVisible(Image_locked, false)

	-- Create Text_locked
	local Text_locked = GUI:Text_Create(Panel_self, "Text_locked", 201.00, 47.00, 16, "#ffe400", [[已锁定]])
	GUI:setChineseName(Text_locked, "自己交易_已锁定_文本")
	GUI:setAnchorPoint(Text_locked, 0.50, 0.50)
	GUI:setTouchEnabled(Text_locked, false)
	GUI:setTag(Text_locked, 55)
	GUI:setVisible(Text_locked, false)
	GUI:Text_enableOutline(Text_locked, "#111111", 2)

	-- Create Button_trade
	local Button_trade = GUI:Button_Create(Panel_self, "Button_trade", 200.00, 47.00, "res/private/bag_ui/bag_ui_win32/1900015210.png")
	GUI:Button_loadTexturePressed(Button_trade, "res/private/bag_ui/bag_ui_win32/1900015211.png")
	GUI:Button_setScale9Slice(Button_trade, 15, 15, 8, 4)
	GUI:setContentSize(Button_trade, 59, 21)
	GUI:setIgnoreContentAdaptWithSize(Button_trade, false)
	GUI:Button_setTitleText(Button_trade, "锁定")
	GUI:Button_setTitleColor(Button_trade, "#ffe400")
	GUI:Button_setTitleFontSize(Button_trade, 12)
	GUI:Button_titleEnableOutline(Button_trade, "#111111", 2)
	GUI:setChineseName(Button_trade, "自己交易_交易_按钮")
	GUI:setAnchorPoint(Button_trade, 0.50, 0.50)
	GUI:setTouchEnabled(Button_trade, true)
	GUI:setTag(Button_trade, 56)

	-- Create btnClose
	local btnClose = GUI:Button_Create(Panel_self, "btnClose", 259.00, 143.00, "res/public_win32/btn_02.png")
	GUI:Button_setScale9Slice(btnClose, 7, 7, 11, 11)
	GUI:setContentSize(btnClose, 16, 27)
	GUI:setIgnoreContentAdaptWithSize(btnClose, false)
	GUI:Button_setTitleText(btnClose, "")
	GUI:Button_setTitleColor(btnClose, "#414146")
	GUI:Button_setTitleFontSize(btnClose, 14)
	GUI:Button_titleDisableOutLine(btnClose)
	GUI:setChineseName(btnClose, "自己交易_关闭_按钮")
	GUI:setAnchorPoint(btnClose, 0.50, 0.50)
	GUI:setTouchEnabled(btnClose, true)
	GUI:setTag(btnClose, 58)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(btnClose, "TouchSize", 0.00, -2.00, 21.00, 35.00, false)
	GUI:setChineseName(TouchSize, "自己交易_触摸")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 59)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_other
	local Panel_other = GUI:Layout_Create(PMainUI, "Panel_other", 0.00, 234.00, 280.00, 200.00, false)
	GUI:setChineseName(Panel_other, "对方交易组合")
	GUI:setTouchEnabled(Panel_other, true)
	GUI:setTag(Panel_other, 60)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_other, "Image_bg", 140.00, 100.00, "res/private/trade/trade_ui_win32/bg_jiaoyidi_02.png")
	GUI:setChineseName(Image_bg, "对方交易_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 61)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_other, "Image_gold", 44.00, 34.00, "res/private/bag_ui/bag_ui_mobile/1900015220.png")
	GUI:setChineseName(Image_gold, "对方交易_货币图标")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, false)
	GUI:setTag(Image_gold, 62)

	-- Create Image_forbid
	local Image_forbid = GUI:Image_Create(Panel_other, "Image_forbid", 44.00, 34.00, "res/private/trade/trade_ui_win32/jinzhi.png")
	GUI:setChineseName(Image_forbid, "对方交易_禁止_图片")
	GUI:setAnchorPoint(Image_forbid, 0.50, 0.50)
	GUI:setTouchEnabled(Image_forbid, true)
	GUI:setTag(Image_forbid, 14)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_other, "Panel_item", 33.00, 146.00, 210.00, 84.00, false)
	GUI:setChineseName(Panel_item, "对方交易_物品放置")
	GUI:setAnchorPoint(Panel_item, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 63)

	-- Create Panel_lockStatus
	local Panel_lockStatus = GUI:Layout_Create(Panel_other, "Panel_lockStatus", 33.00, 146.00, 210.00, 84.00, false)
	GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
	GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 102)
	GUI:setChineseName(Panel_lockStatus, "对方交易_锁定")
	GUI:setAnchorPoint(Panel_lockStatus, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_lockStatus, false)
	GUI:setTag(Panel_lockStatus, 64)
	GUI:setVisible(Panel_lockStatus, false)

	-- Create Image_lock
	local Image_lock = GUI:Image_Create(Panel_lockStatus, "Image_lock", 105.00, 42.00, "res/public/icon_tyzys_01.png")
	GUI:setChineseName(Image_lock, "对方交易_锁定_背景图")
	GUI:setAnchorPoint(Image_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Image_lock, false)
	GUI:setTag(Image_lock, 65)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_other, "Text_name", 141.00, 175.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "对方交易_昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 66)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_gold
	local Text_gold = GUI:Text_Create(Panel_other, "Text_gold", 79.00, 47.00, 16, "#ffffff", [[0]])
	GUI:setChineseName(Text_gold, "对方交易_货币数量_文本")
	GUI:setAnchorPoint(Text_gold, 0.00, 0.50)
	GUI:setTouchEnabled(Text_gold, false)
	GUI:setTag(Text_gold, 67)
	GUI:Text_enableOutline(Text_gold, "#111111", 1)

	-- Create Text_locked
	local Text_locked = GUI:Text_Create(Panel_other, "Text_locked", 201.00, 48.00, 16, "#ffe400", [[已锁定]])
	GUI:setChineseName(Text_locked, "对方交易_已锁定_文本")
	GUI:setAnchorPoint(Text_locked, 0.50, 0.50)
	GUI:setTouchEnabled(Text_locked, false)
	GUI:setTag(Text_locked, 68)
	GUI:setVisible(Text_locked, false)
	GUI:Text_enableOutline(Text_locked, "#111111", 2)

	-- Create Image_locked
	local Image_locked = GUI:Image_Create(Panel_other, "Image_locked", 33.00, 146.00, "res/public/1900000678_3.png")
	GUI:setContentSize(Image_locked, 210, 84)
	GUI:setIgnoreContentAdaptWithSize(Image_locked, false)
	GUI:setChineseName(Image_locked, "对方交易_锁定_图片")
	GUI:setAnchorPoint(Image_locked, 0.00, 1.00)
	GUI:setTouchEnabled(Image_locked, false)
	GUI:setTag(Image_locked, 69)
	GUI:setVisible(Image_locked, false)

	-- Create btnClose
	local btnClose = GUI:Button_Create(Panel_other, "btnClose", 260.00, 143.00, "res/public_win32/btn_02.png")
	GUI:Button_setScale9Slice(btnClose, 7, 7, 11, 11)
	GUI:setContentSize(btnClose, 16, 27)
	GUI:setIgnoreContentAdaptWithSize(btnClose, false)
	GUI:Button_setTitleText(btnClose, "")
	GUI:Button_setTitleColor(btnClose, "#414146")
	GUI:Button_setTitleFontSize(btnClose, 14)
	GUI:Button_titleDisableOutLine(btnClose)
	GUI:setChineseName(btnClose, "对方交易_关闭_按钮")
	GUI:setAnchorPoint(btnClose, 0.50, 0.50)
	GUI:setTouchEnabled(btnClose, true)
	GUI:setTag(btnClose, 70)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(btnClose, "TouchSize", 0.00, -3.00, 22.00, 34.00, false)
	GUI:setChineseName(TouchSize, "对方交易_关闭_触摸")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 71)
	GUI:setVisible(TouchSize, false)
end
return ui