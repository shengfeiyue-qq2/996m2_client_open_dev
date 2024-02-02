local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "摆摊场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 868.00, 320.00, 386.00, 520.00, false)
	GUI:setChineseName(PMainUI, "摆摊组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 2)

	-- Create Image_move
	local Image_move = GUI:Image_Create(PMainUI, "Image_move", 176.00, 240.00, "res/private/baitan_ui/baitan_ui_mobile/bg_baitanzy01.jpg")
	GUI:setChineseName(Image_move, "摆摊_背景图")
	GUI:setAnchorPoint(Image_move, 0.50, 0.50)
	GUI:setTouchEnabled(Image_move, false)
	GUI:setTag(Image_move, 43)

	-- Create Image_info1
	local Image_info1 = GUI:Image_Create(PMainUI, "Image_info1", 68.00, 151.00, "res/private/baitan_ui/baitan_ui_mobile/word_baitanzy02.png")
	GUI:setChineseName(Image_info1, "摆摊_物品名称_图片")
	GUI:setAnchorPoint(Image_info1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_info1, false)
	GUI:setTag(Image_info1, 46)

	-- Create Image_info2
	local Image_info2 = GUI:Image_Create(PMainUI, "Image_info2", 68.00, 106.00, "res/private/baitan_ui/baitan_ui_mobile/word_baitanzy01.png")
	GUI:setChineseName(Image_info2, "摆摊_出售价格_图片")
	GUI:setAnchorPoint(Image_info2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_info2, false)
	GUI:setTag(Image_info2, 47)

	-- Create Image_frame1
	local Image_frame1 = GUI:Image_Create(PMainUI, "Image_frame1", 235.00, 151.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_frame1, 188, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_frame1, false)
	GUI:setChineseName(Image_frame1, "摆摊_物品名称_背景图")
	GUI:setAnchorPoint(Image_frame1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame1, false)
	GUI:setTag(Image_frame1, 50)

	-- Create Image_frame2
	local Image_frame2 = GUI:Image_Create(PMainUI, "Image_frame2", 235.00, 104.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_frame2, 188, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_frame2, false)
	GUI:setChineseName(Image_frame2, "摆摊_出售价格_背景图")
	GUI:setAnchorPoint(Image_frame2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame2, false)
	GUI:setTag(Image_frame2, 51)

	-- Create Image_title
	local Image_title = GUI:Image_Create(PMainUI, "Image_title", 174.00, 503.00, "res/private/baitan_ui/baitan_ui_mobile/bg_baitanzy03.png")
	GUI:Image_setScale9Slice(Image_title, 115, 131, 13, 27)
	GUI:setContentSize(Image_title, 350, 41)
	GUI:setIgnoreContentAdaptWithSize(Image_title, false)
	GUI:setChineseName(Image_title, "摆摊_摊位名称_背景框")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 28)

	-- Create Text_titleName
	local Text_titleName = GUI:Text_Create(PMainUI, "Text_titleName", 22.00, 497.00, 15, "#ffffff", [[]])
	GUI:setChineseName(Text_titleName, "摆摊_摊位名称_文本")
	GUI:setAnchorPoint(Text_titleName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_titleName, false)
	GUI:setTag(Text_titleName, 29)
	GUI:Text_enableOutline(Text_titleName, "#111111", 1)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(PMainUI, "Text_itemName", 235.00, 151.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_itemName, "摆摊_物品名称_文本")
	GUI:setAnchorPoint(Text_itemName, 0.50, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 68)
	GUI:Text_enableOutline(Text_itemName, "#111111", 1)

	-- Create Text_price
	local Text_price = GUI:Text_Create(PMainUI, "Text_price", 235.00, 104.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_price, "摆摊_出售价格_文本")
	GUI:setAnchorPoint(Text_price, 0.50, 0.50)
	GUI:setTouchEnabled(Text_price, false)
	GUI:setTag(Text_price, 69)
	GUI:Text_enableOutline(Text_price, "#111111", 1)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(PMainUI, "Panel_items", 18.00, 462.00, 316.00, 256.00, false)
	GUI:setChineseName(Panel_items, "摆摊_物品展示区域")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 37)

	-- Create Panel_addItem
	local Panel_addItem = GUI:Layout_Create(PMainUI, "Panel_addItem", 18.00, 462.00, 316.00, 256.00, false)
	GUI:setChineseName(Panel_addItem, "摆摊_添加物品区域")
	GUI:setAnchorPoint(Panel_addItem, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItem, true)
	GUI:setTag(Panel_addItem, 49)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 367.00, 500.00, "res/public/btn_sifud_01.png")
	GUI:Button_setScale9Slice(Button_close, 15, 15, 12, 10)
	GUI:setContentSize(Button_close, 66, 62)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "摆摊_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 48)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 100.00, 38.00, "res/public/btn_sifud_02.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 15, 12, 10)
	GUI:setContentSize(Button_cancel, 139, 59)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 18)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "摆摊_取消_按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 44)

	-- Create Button_do
	local Button_do = GUI:Button_Create(PMainUI, "Button_do", 257.00, 38.00, "res/public/btn_sifud_02.png")
	GUI:Button_setScale9Slice(Button_do, 15, 15, 12, 10)
	GUI:setContentSize(Button_do, 139, 59)
	GUI:setIgnoreContentAdaptWithSize(Button_do, false)
	GUI:Button_setTitleText(Button_do, "摆摊")
	GUI:Button_setTitleColor(Button_do, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_do, 18)
	GUI:Button_titleEnableOutline(Button_do, "#111111", 2)
	GUI:setChineseName(Button_do, "摆摊_摆摊_按钮")
	GUI:setAnchorPoint(Button_do, 0.50, 0.50)
	GUI:setTouchEnabled(Button_do, true)
	GUI:setTag(Button_do, 45)
end
return ui