local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 489.00, 270.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0.00, 0.00, "res/private/skill-win32/img_bg.png")
	GUI:setContentSize(Image_bg, 489, 270)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create icon_bg
	local icon_bg = GUI:Image_Create(PMainUI, "icon_bg", 76.00, 214.00, "res/private/skill-win32/img_sel.png")
	GUI:setAnchorPoint(icon_bg, 0.00, 0.50)
	GUI:setTouchEnabled(icon_bg, false)
	GUI:setTag(icon_bg, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 131.00, 214.00, 16, "#ffffff", [[普通攻击快捷键设置为]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Button_F1
	local Button_F1 = GUI:Button_Create(PMainUI, "Button_F1", 36.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F1, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F1, "")
	GUI:Button_setTitleColor(Button_F1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F1, 10)
	GUI:Button_titleEnableOutline(Button_F1, "#000000", 1)
	GUI:setTouchEnabled(Button_F1, true)
	GUI:setTag(Button_F1, 1)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F1, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F1.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F1, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F9
	local Button_F9 = GUI:Button_Create(PMainUI, "Button_F9", 36.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F9, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F9, "")
	GUI:Button_setTitleColor(Button_F9, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F9, 10)
	GUI:Button_titleEnableOutline(Button_F9, "#000000", 1)
	GUI:setTouchEnabled(Button_F9, true)
	GUI:setTag(Button_F9, 9)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F9, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F9.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F9, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F2
	local Button_F2 = GUI:Button_Create(PMainUI, "Button_F2", 88.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F2, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F2, "")
	GUI:Button_setTitleColor(Button_F2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F2, 10)
	GUI:Button_titleEnableOutline(Button_F2, "#000000", 1)
	GUI:setTouchEnabled(Button_F2, true)
	GUI:setTag(Button_F2, 2)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F2, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F2.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F2, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F10
	local Button_F10 = GUI:Button_Create(PMainUI, "Button_F10", 88.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F10, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F10, "")
	GUI:Button_setTitleColor(Button_F10, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F10, 10)
	GUI:Button_titleEnableOutline(Button_F10, "#000000", 1)
	GUI:setTouchEnabled(Button_F10, true)
	GUI:setTag(Button_F10, 10)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F10, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F10.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F10, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F3
	local Button_F3 = GUI:Button_Create(PMainUI, "Button_F3", 140.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F3, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F3, "")
	GUI:Button_setTitleColor(Button_F3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F3, 10)
	GUI:Button_titleEnableOutline(Button_F3, "#000000", 1)
	GUI:setTouchEnabled(Button_F3, true)
	GUI:setTag(Button_F3, 3)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F3, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F3.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F3, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F11
	local Button_F11 = GUI:Button_Create(PMainUI, "Button_F11", 140.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F11, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F11, "")
	GUI:Button_setTitleColor(Button_F11, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F11, 10)
	GUI:Button_titleEnableOutline(Button_F11, "#000000", 1)
	GUI:setTouchEnabled(Button_F11, true)
	GUI:setTag(Button_F11, 11)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F11, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F11.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F11, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F4
	local Button_F4 = GUI:Button_Create(PMainUI, "Button_F4", 192.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F4, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F4, "")
	GUI:Button_setTitleColor(Button_F4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F4, 10)
	GUI:Button_titleEnableOutline(Button_F4, "#000000", 1)
	GUI:setTouchEnabled(Button_F4, true)
	GUI:setTag(Button_F4, 4)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F4, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F4.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F4, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F12
	local Button_F12 = GUI:Button_Create(PMainUI, "Button_F12", 192.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F12, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F12, "")
	GUI:Button_setTitleColor(Button_F12, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F12, 10)
	GUI:Button_titleEnableOutline(Button_F12, "#000000", 1)
	GUI:setTouchEnabled(Button_F12, true)
	GUI:setTag(Button_F12, 12)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F12, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F12.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F12, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F5
	local Button_F5 = GUI:Button_Create(PMainUI, "Button_F5", 244.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F5, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F5, "")
	GUI:Button_setTitleColor(Button_F5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F5, 10)
	GUI:Button_titleEnableOutline(Button_F5, "#000000", 1)
	GUI:setTouchEnabled(Button_F5, true)
	GUI:setTag(Button_F5, 5)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F5, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F5.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F5, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F13
	local Button_F13 = GUI:Button_Create(PMainUI, "Button_F13", 244.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F13, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F13, "")
	GUI:Button_setTitleColor(Button_F13, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F13, 10)
	GUI:Button_titleEnableOutline(Button_F13, "#000000", 1)
	GUI:setTouchEnabled(Button_F13, true)
	GUI:setTag(Button_F13, 13)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F13, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F13.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F13, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F6
	local Button_F6 = GUI:Button_Create(PMainUI, "Button_F6", 296.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F6, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F6, "")
	GUI:Button_setTitleColor(Button_F6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F6, 10)
	GUI:Button_titleEnableOutline(Button_F6, "#000000", 1)
	GUI:setTouchEnabled(Button_F6, true)
	GUI:setTag(Button_F6, 6)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F6, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F6.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F6, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F14
	local Button_F14 = GUI:Button_Create(PMainUI, "Button_F14", 296.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F14, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F14, "")
	GUI:Button_setTitleColor(Button_F14, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F14, 10)
	GUI:Button_titleEnableOutline(Button_F14, "#000000", 1)
	GUI:setTouchEnabled(Button_F14, true)
	GUI:setTag(Button_F14, 14)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F14, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F14.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F14, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F7
	local Button_F7 = GUI:Button_Create(PMainUI, "Button_F7", 348.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F7, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F7, "")
	GUI:Button_setTitleColor(Button_F7, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F7, 10)
	GUI:Button_titleEnableOutline(Button_F7, "#000000", 1)
	GUI:setTouchEnabled(Button_F7, true)
	GUI:setTag(Button_F7, 7)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F7, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F7.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F7, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F15
	local Button_F15 = GUI:Button_Create(PMainUI, "Button_F15", 348.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F15, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F15, "")
	GUI:Button_setTitleColor(Button_F15, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F15, 10)
	GUI:Button_titleEnableOutline(Button_F15, "#000000", 1)
	GUI:setTouchEnabled(Button_F15, true)
	GUI:setTag(Button_F15, 15)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F15, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F15.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F15, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F8
	local Button_F8 = GUI:Button_Create(PMainUI, "Button_F8", 400.00, 120.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F8, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F8, "")
	GUI:Button_setTitleColor(Button_F8, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F8, 10)
	GUI:Button_titleEnableOutline(Button_F8, "#000000", 1)
	GUI:setTouchEnabled(Button_F8, true)
	GUI:setTag(Button_F8, 8)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F8, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F8.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F8, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_F16
	local Button_F16 = GUI:Button_Create(PMainUI, "Button_F16", 400.00, 66.00, "res/private/skill-win32/btn_1.png")
	GUI:Button_loadTexturePressed(Button_F16, "res/private/skill-win32/btn_2.png")
	GUI:Button_setTitleText(Button_F16, "")
	GUI:Button_setTitleColor(Button_F16, "#ffffff")
	GUI:Button_setTitleFontSize(Button_F16, 10)
	GUI:Button_titleEnableOutline(Button_F16, "#000000", 1)
	GUI:setTouchEnabled(Button_F16, true)
	GUI:setTag(Button_F16, 16)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Button_F16, "Image_key", 26.00, 25.00, "res/private/skill-win32/key_F16.png")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, -1)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Button_F16, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
	GUI:setContentSize(Image_sel, 45, 45)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, -1)
	GUI:setVisible(Image_sel, false)

	-- Create Button_clean
	local Button_clean = GUI:Button_Create(PMainUI, "Button_clean", 130.00, 15.00, "res/private/skill-win32/btn_4.png")
	GUI:Button_loadTexturePressed(Button_clean, "res/private/skill-win32/btn_4_1.png")
	GUI:Button_setTitleText(Button_clean, "")
	GUI:Button_setTitleColor(Button_clean, "#ffffff")
	GUI:Button_setTitleFontSize(Button_clean, 10)
	GUI:Button_titleEnableOutline(Button_clean, "#000000", 1)
	GUI:setAnchorPoint(Button_clean, 0.50, 0.00)
	GUI:setTouchEnabled(Button_clean, true)
	GUI:setTag(Button_clean, -1)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 370.00, 15.00, "res/private/skill-win32/btn_3.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/private/skill-win32/btn_3_1.png")
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#ffffff")
	GUI:Button_setTitleFontSize(Button_submit, 10)
	GUI:Button_titleEnableOutline(Button_submit, "#000000", 1)
	GUI:setAnchorPoint(Button_submit, 0.50, 0.00)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 489.00, 270.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)
end
return ui