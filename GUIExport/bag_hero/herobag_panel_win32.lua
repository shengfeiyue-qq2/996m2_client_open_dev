local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 154.00, 615.00, 268.00, 191.00, false)
	GUI:setChineseName(Panel_1, "背包_一级节点")
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 25)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/bag_ui_hero_win32/bg1.png")
	GUI:setChineseName(Image_bg, "背包_背景图片")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 26)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 0.00, 0.00, 246.00, 190.00, false)
	GUI:setChineseName(Panel_2, "背包_二级节点")
	GUI:setTouchEnabled(Panel_2, false)
	GUI:setTag(Panel_2, 30)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 252.00, 172.00, "res/public_win32/1900000530.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "背包_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 27)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_2, "Panel_items", 15.00, 174.00, 213.00, 88.00, false)
	GUI:setChineseName(Panel_items, "背包_物品框")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 29)

	-- Create Panel_addItems
	local Panel_addItems = GUI:Layout_Create(Panel_2, "Panel_addItems", 15.00, 174.00, 213.00, 88.00, false)
	GUI:setChineseName(Panel_addItems, "背包_添加物品")
	GUI:setAnchorPoint(Panel_addItems, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItems, true)
	GUI:setTag(Panel_addItems, 28)

	-- Create Button_store_human_bag
	local Button_store_human_bag = GUI:Button_Create(Panel_2, "Button_store_human_bag", 72.00, 35.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_store_human_bag, "res/public/1900000652_1.png")
	GUI:Button_loadTextureDisabled(Button_store_human_bag, "res/public/1900000652_1.png")
	GUI:setContentSize(Button_store_human_bag, 100, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_store_human_bag, false)
	GUI:Button_setTitleText(Button_store_human_bag, "存入人物背包")
	GUI:Button_setTitleColor(Button_store_human_bag, "#ffffff")
	GUI:Button_setTitleFontSize(Button_store_human_bag, 15)
	GUI:Button_titleEnableOutline(Button_store_human_bag, "#000000", 1)
	GUI:setChineseName(Button_store_human_bag, "背包_存入人物背包按钮")
	GUI:setAnchorPoint(Button_store_human_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_store_human_bag, true)
	GUI:setTag(Button_store_human_bag, 28)
end
return ui