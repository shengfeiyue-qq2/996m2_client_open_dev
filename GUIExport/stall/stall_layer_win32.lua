local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "摆摊场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 854.00, 448.00, 245.00, 335.00, false)
	GUI:setChineseName(PMainUI, "摆摊组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 52)

	-- Create Image_move
	local Image_move = GUI:Image_Create(PMainUI, "Image_move", 114.00, 152.00, "res/private/baitan_ui/baitan_ui_win32/bg_baitanzy05.png")
	GUI:setChineseName(Image_move, "摆摊_背景图")
	GUI:setAnchorPoint(Image_move, 0.50, 0.50)
	GUI:setTouchEnabled(Image_move, false)
	GUI:setTag(Image_move, 53)

	-- Create Image_info1
	local Image_info1 = GUI:Image_Create(PMainUI, "Image_info1", 62.00, 104.00, "res/private/baitan_ui/baitan_ui_win32/word_baitanzy06.png")
	GUI:setContentSize(Image_info1, 60, 15)
	GUI:setIgnoreContentAdaptWithSize(Image_info1, false)
	GUI:setChineseName(Image_info1, "摆摊_物品名称_图片")
	GUI:setAnchorPoint(Image_info1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_info1, false)
	GUI:setTag(Image_info1, 54)

	-- Create Image_info2
	local Image_info2 = GUI:Image_Create(PMainUI, "Image_info2", 62.00, 74.00, "res/private/baitan_ui/baitan_ui_win32/word_baitanzy05.png")
	GUI:setChineseName(Image_info2, "摆摊_出售价格_图片")
	GUI:setAnchorPoint(Image_info2, 0.50, 0.50)
	GUI:setScaleX(Image_info2, 0.88)
	GUI:setScaleY(Image_info2, 0.88)
	GUI:setTouchEnabled(Image_info2, false)
	GUI:setTag(Image_info2, 55)

	-- Create Image_frame1
	local Image_frame1 = GUI:Image_Create(PMainUI, "Image_frame1", 157.00, 103.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_frame1, 108, 17)
	GUI:setIgnoreContentAdaptWithSize(Image_frame1, false)
	GUI:setChineseName(Image_frame1, "摆摊_物品名称_背景图")
	GUI:setAnchorPoint(Image_frame1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame1, false)
	GUI:setTag(Image_frame1, 56)

	-- Create Image_frame2
	local Image_frame2 = GUI:Image_Create(PMainUI, "Image_frame2", 157.00, 74.00, "res/public/1900000668.png")
	GUI:setContentSize(Image_frame2, 108, 17)
	GUI:setIgnoreContentAdaptWithSize(Image_frame2, false)
	GUI:setChineseName(Image_frame2, "摆摊_出售价格_背景图")
	GUI:setAnchorPoint(Image_frame2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame2, false)
	GUI:setTag(Image_frame2, 57)

	-- Create Image_title
	local Image_title = GUI:Image_Create(PMainUI, "Image_title", 114.00, 319.00, "res/private/baitan_ui/baitan_ui_win32/bg_baitanzy07.png")
	GUI:Image_setScale9Slice(Image_title, 35, 35, 8, 4)
	GUI:setContentSize(Image_title, 226, 21)
	GUI:setIgnoreContentAdaptWithSize(Image_title, false)
	GUI:setChineseName(Image_title, "摆摊_摊位名称_背景框")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 58)

	-- Create Text_titleName
	local Text_titleName = GUI:Text_Create(PMainUI, "Text_titleName", 13.00, 318.00, 15, "#ffffff", [[]])
	GUI:setChineseName(Text_titleName, "摆摊_摊位名称_文本")
	GUI:setAnchorPoint(Text_titleName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_titleName, false)
	GUI:setTag(Text_titleName, 59)
	GUI:Text_enableOutline(Text_titleName, "#111111", 1)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(PMainUI, "Text_itemName", 155.00, 104.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_itemName, "摆摊_物品名称_文本")
	GUI:setAnchorPoint(Text_itemName, 0.50, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 60)
	GUI:Text_enableOutline(Text_itemName, "#111111", 1)

	-- Create Text_price
	local Text_price = GUI:Text_Create(PMainUI, "Text_price", 155.00, 74.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_price, "摆摊_出售价格_文本")
	GUI:setAnchorPoint(Text_price, 0.50, 0.50)
	GUI:setTouchEnabled(Text_price, false)
	GUI:setTag(Text_price, 61)
	GUI:Text_enableOutline(Text_price, "#111111", 1)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(PMainUI, "Panel_items", 11.00, 299.00, 208.00, 168.00, false)
	GUI:setChineseName(Panel_items, "摆摊_物品展示区域")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 62)

	-- Create Panel_addItem
	local Panel_addItem = GUI:Layout_Create(PMainUI, "Panel_addItem", 11.00, 299.00, 208.00, 168.00, false)
	GUI:setChineseName(Panel_addItem, "摆摊_添加物品区域")
	GUI:setAnchorPoint(Panel_addItem, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItem, true)
	GUI:setTag(Panel_addItem, 63)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 239.00, 293.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setScale9Slice(Button_close, 5, 9, 11, 16)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "摆摊_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 64)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 65.00, 32.00, "res/public_win32/1900000673.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public_win32/1900000674.png")
	GUI:Button_setScale9Slice(Button_cancel, 15, 15, 11, 11)
	GUI:setContentSize(Button_cancel, 69, 26)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 14)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "摆摊_取消_按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 65)

	-- Create Button_do
	local Button_do = GUI:Button_Create(PMainUI, "Button_do", 165.00, 32.00, "res/public_win32/1900000673.png")
	GUI:Button_loadTexturePressed(Button_do, "res/public_win32/1900000674.png")
	GUI:Button_setScale9Slice(Button_do, 15, 15, 11, 11)
	GUI:setContentSize(Button_do, 69, 26)
	GUI:setIgnoreContentAdaptWithSize(Button_do, false)
	GUI:Button_setTitleText(Button_do, "摆摊")
	GUI:Button_setTitleColor(Button_do, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_do, 14)
	GUI:Button_titleEnableOutline(Button_do, "#111111", 2)
	GUI:setChineseName(Button_do, "摆摊_摆摊_按钮")
	GUI:setAnchorPoint(Button_do, 0.50, 0.50)
	GUI:setTouchEnabled(Button_do, true)
	GUI:setTag(Button_do, 66)
end
return ui