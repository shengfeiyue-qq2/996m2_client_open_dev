local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "仓库场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 400.00, 565.00, 450.00, false)
	GUI:setChineseName(Panel_1, "仓库组合框")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 19)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 269.00, 222.00, "res/public/bg_npc_06.png")
	GUI:setChineseName(Image_bg, "仓库_背景图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 20)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_1, "Button_page1", 538.00, 351.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/public/1900000641.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleEnableOutline(Button_page1, "#000000", 1)
	GUI:setChineseName(Button_page1, "仓库_第一页_组合框")
	GUI:setAnchorPoint(Button_page1, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page1, false)
	GUI:setTag(Button_page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page1, "PageText", 12.00, 60.00, 16, "#ffffff", [[一]])
	GUI:setChineseName(PageText, "仓库_第一页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page1, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "仓库_第一页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_1, "Button_page2", 538.00, 284.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/public/1900000641.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleEnableOutline(Button_page2, "#000000", 1)
	GUI:setChineseName(Button_page2, "仓库_第二页_组合框")
	GUI:setAnchorPoint(Button_page2, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page2, false)
	GUI:setTag(Button_page2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page2, "PageText", 12.00, 60.00, 16, "#ffffff", [[二]])
	GUI:setChineseName(PageText, "仓库_第二页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page2, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "仓库_第二页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_1, "Button_page3", 538.00, 217.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/public/1900000641.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleEnableOutline(Button_page3, "#000000", 1)
	GUI:setChineseName(Button_page3, "仓库_第三页_组合框")
	GUI:setAnchorPoint(Button_page3, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page3, false)
	GUI:setTag(Button_page3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page3, "PageText", 12.00, 60.00, 16, "#ffffff", [[三]])
	GUI:setChineseName(PageText, "仓库_第三页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page3, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "仓库_第三页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_1, "Button_page4", 538.00, 150.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/public/1900000641.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleEnableOutline(Button_page4, "#000000", 1)
	GUI:setChineseName(Button_page4, "仓库_第四页_组合框")
	GUI:setAnchorPoint(Button_page4, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page4, false)
	GUI:setTag(Button_page4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page4, "PageText", 12.00, 60.00, 16, "#ffffff", [[四]])
	GUI:setChineseName(PageText, "仓库_第四页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page4, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "仓库_第四页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page5
	local Button_page5 = GUI:Button_Create(Panel_1, "Button_page5", 538.00, 83.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_page5, "res/public/1900000641.png")
	GUI:Button_loadTextureDisabled(Button_page5, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_page5, "")
	GUI:Button_setTitleColor(Button_page5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page5, 14)
	GUI:Button_titleEnableOutline(Button_page5, "#000000", 1)
	GUI:setChineseName(Button_page5, "仓库_第五页_组合框")
	GUI:setAnchorPoint(Button_page5, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page5, false)
	GUI:setTag(Button_page5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page5, "PageText", 12.00, 60.00, 16, "#ffffff", [[五]])
	GUI:setChineseName(PageText, "仓库_第五页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page5, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "仓库_第五页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_quick
	local Button_quick = GUI:Button_Create(Panel_1, "Button_quick", 95.00, 18.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_quick, "res/public/1900000653.png")
	GUI:Button_setScale9Slice(Button_quick, 15, 15, 6, 2)
	GUI:setContentSize(Button_quick, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_quick, false)
	GUI:Button_setTitleText(Button_quick, "快速存取")
	GUI:Button_setTitleColor(Button_quick, "#ffe400")
	GUI:Button_setTitleFontSize(Button_quick, 16)
	GUI:Button_titleEnableOutline(Button_quick, "#111111", 2)
	GUI:setChineseName(Button_quick, "仓库_快速存取按钮")
	GUI:setAnchorPoint(Button_quick, 0.50, 0.50)
	GUI:setTouchEnabled(Button_quick, true)
	GUI:setTag(Button_quick, 21)

	-- Create Button_reset
	local Button_reset = GUI:Button_Create(Panel_1, "Button_reset", 416.00, 17.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_reset, "res/public/1900000653.png")
	GUI:Button_setScale9Slice(Button_reset, 15, 15, 6, 2)
	GUI:setContentSize(Button_reset, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_reset, false)
	GUI:Button_setTitleText(Button_reset, "仓库整理")
	GUI:Button_setTitleColor(Button_reset, "#ffe400")
	GUI:Button_setTitleFontSize(Button_reset, 16)
	GUI:Button_titleEnableOutline(Button_reset, "#111111", 2)
	GUI:setChineseName(Button_reset, "仓库_仓库整理按钮")
	GUI:setAnchorPoint(Button_reset, 0.50, 0.50)
	GUI:setTouchEnabled(Button_reset, true)
	GUI:setTag(Button_reset, 22)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 550.00, 422.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_close, 8, 6, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "仓库_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 24)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.00, 42.00, 39.00, 50.40, false)
	GUI:setChineseName(TouchSize, "仓库_关闭_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 17)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 15.00, 427.00, 508.00, 384.00, false)
	GUI:setChineseName(Panel_items, "仓库_物品")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 25)

	-- Create Panel_itemstouch
	local Panel_itemstouch = GUI:Layout_Create(Panel_1, "Panel_itemstouch", 15.00, 427.00, 508.00, 384.00, false)
	GUI:setChineseName(Panel_itemstouch, "仓库_物品触摸区域")
	GUI:setAnchorPoint(Panel_itemstouch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_itemstouch, false)
	GUI:setTag(Panel_itemstouch, 26)
end
return ui