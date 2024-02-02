local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "二合一背包_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 98.00, 340.00, 568.00, 469.00, false)
	GUI:setChineseName(Panel_1, "背包_组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 2)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 284.00, 235.00, "res/private/bag_ui/bag_ui_mobile/bg_beibao_01.png")
	GUI:setChineseName(Image_bg, "背包_背景_图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 3)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_1, "Button_page1", -14.00, 410.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleEnableOutline(Button_page1, "#000000", 1)
	GUI:setChineseName(Button_page1, "背包_第一页_组合框")
	GUI:setAnchorPoint(Button_page1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page1, false)
	GUI:setTag(Button_page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page1, "PageText", 20.00, 60.00, 18, "#ffffff", [[一]])
	GUI:setChineseName(PageText, "背包_第一页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page1, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第一页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_1, "Button_page2", -14.00, 343.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleEnableOutline(Button_page2, "#000000", 1)
	GUI:setChineseName(Button_page2, "背包_第二页_组合框")
	GUI:setAnchorPoint(Button_page2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page2, false)
	GUI:setTag(Button_page2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page2, "PageText", 20.00, 60.00, 18, "#ffffff", [[二]])
	GUI:setChineseName(PageText, "背包_第二页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page2, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第二页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_1, "Button_page3", -14.00, 276.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleEnableOutline(Button_page3, "#000000", 1)
	GUI:setChineseName(Button_page3, "背包_第三页_组合框")
	GUI:setAnchorPoint(Button_page3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page3, false)
	GUI:setTag(Button_page3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page3, "PageText", 20.00, 60.00, 18, "#ffffff", [[三]])
	GUI:setChineseName(PageText, "背包_第三页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page3, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第三页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_1, "Button_page4", -14.00, 209.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleEnableOutline(Button_page4, "#000000", 1)
	GUI:setChineseName(Button_page4, "背包_第四页_组合框")
	GUI:setAnchorPoint(Button_page4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page4, false)
	GUI:setTag(Button_page4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page4, "PageText", 20.00, 60.00, 18, "#ffffff", [[四]])
	GUI:setChineseName(PageText, "背包_第四页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page4, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第四页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page5
	local Button_page5 = GUI:Button_Create(Panel_1, "Button_page5", -14.00, 142.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page5, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page5, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page5, "")
	GUI:Button_setTitleColor(Button_page5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page5, 14)
	GUI:Button_titleEnableOutline(Button_page5, "#000000", 1)
	GUI:setChineseName(Button_page5, "背包_第五页_组合框")
	GUI:setAnchorPoint(Button_page5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page5, false)
	GUI:setTag(Button_page5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page5, "PageText", 20.00, 60.00, 18, "#ffffff", [[五]])
	GUI:setChineseName(PageText, "背包_第五页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page5, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第五页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 543.00, 428.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 6, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "背包_关闭按钮")
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 8)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_1, "Image_gold", 25.00, 102.00, "res/private/bag_ui_mobile/1900015220.png")
	GUI:setChineseName(Image_gold, "背包_金币图片")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, true)
	GUI:setTag(Image_gold, 5)

	-- Create Button_store_mode
	local Button_store_mode = GUI:Button_Create(Panel_1, "Button_store_mode", 325.00, 110.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_store_mode, "res/public/1900000652_1.png")
	GUI:Button_loadTextureDisabled(Button_store_mode, "res/public/1900000652_1.png")
	GUI:setContentSize(Button_store_mode, 128, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_store_mode, false)
	GUI:Button_setTitleText(Button_store_mode, "存入英雄背包")
	GUI:Button_setTitleColor(Button_store_mode, "#ffffff")
	GUI:Button_setTitleFontSize(Button_store_mode, 18)
	GUI:Button_titleEnableOutline(Button_store_mode, "#000000", 1)
	GUI:setChineseName(Button_store_mode, "背包_存入英雄背包_按钮")
	GUI:setAnchorPoint(Button_store_mode, 0.50, 0.50)
	GUI:setTouchEnabled(Button_store_mode, true)
	GUI:setTag(Button_store_mode, 26)

	-- Create ScrollView_items
	local ScrollView_items = GUI:ScrollView_Create(Panel_1, "ScrollView_items", 24.00, 452.00, 500.00, 320.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_items, 500.00, 320.00)
	GUI:setChineseName(ScrollView_items, "背包_物品列表")
	GUI:setAnchorPoint(ScrollView_items, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_items, true)
	GUI:setTag(ScrollView_items, -1)

	-- Create Panel_addItems
	local Panel_addItems = GUI:Layout_Create(Panel_1, "Panel_addItems", 24.00, 452.00, 500.00, 320.00, false)
	GUI:setChineseName(Panel_addItems, "背包_添加物品层")
	GUI:setAnchorPoint(Panel_addItems, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItems, true)
	GUI:setTag(Panel_addItems, 10)

	-- Create BtnPlayer
	local BtnPlayer = GUI:Button_Create(Panel_1, "BtnPlayer", 544.00, 320.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(BtnPlayer, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(BtnPlayer, "res/public/1900000640.png")
	GUI:Button_setTitleText(BtnPlayer, "")
	GUI:Button_setTitleColor(BtnPlayer, "#ffffff")
	GUI:Button_setTitleFontSize(BtnPlayer, 10)
	GUI:Button_titleEnableOutline(BtnPlayer, "#000000", 1)
	GUI:setChineseName(BtnPlayer, "背包_主角_组合框")
	GUI:setTouchEnabled(BtnPlayer, false)
	GUI:setTag(BtnPlayer, -1)

	-- Create BtnText
	local BtnText = GUI:Text_Create(BtnPlayer, "BtnText", 13.00, 58.00, 16, "#ffffff", [[主
角]])
	GUI:setChineseName(BtnText, "背包_主角_文本")
	GUI:setAnchorPoint(BtnText, 0.50, 0.50)
	GUI:setTouchEnabled(BtnText, false)
	GUI:setTag(BtnText, -1)
	GUI:Text_enableOutline(BtnText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnPlayer, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_主角_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create BtnHero
	local BtnHero = GUI:Button_Create(Panel_1, "BtnHero", 544.00, 245.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(BtnHero, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(BtnHero, "res/public/1900000640.png")
	GUI:Button_setTitleText(BtnHero, "")
	GUI:Button_setTitleColor(BtnHero, "#ffffff")
	GUI:Button_setTitleFontSize(BtnHero, 10)
	GUI:Button_titleEnableOutline(BtnHero, "#000000", 1)
	GUI:setChineseName(BtnHero, "背包_英雄_组合框")
	GUI:setTouchEnabled(BtnHero, false)
	GUI:setTag(BtnHero, -1)

	-- Create BtnText
	local BtnText = GUI:Text_Create(BtnHero, "BtnText", 13.00, 58.00, 16, "#ffffff", [[英
雄]])
	GUI:setChineseName(BtnText, "背包_英雄_文本")
	GUI:setAnchorPoint(BtnText, 0.50, 0.50)
	GUI:setTouchEnabled(BtnText, false)
	GUI:setTag(BtnText, -1)
	GUI:Text_enableOutline(BtnText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnHero, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_英雄_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)
end
return ui