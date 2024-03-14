local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "分辨率场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_cancel, "设置分辨率_范围点击关闭")
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 465)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 568.00, 320.00, 256.00, 359.00, false)
	GUI:setChineseName(PMainUI, "设置分辨率组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, false)
	GUI:setTag(PMainUI, 467)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 128.00, 179.00, "res/public/1900000666.jpg")
	GUI:setChineseName(Image_bg, "设置分辨率_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 305)

	-- Create Text_title
	local Text_title = GUI:Text_Create(PMainUI, "Text_title", 128.00, 337.00, 20, "#ffffff", [[设置分辨率]])
	GUI:setChineseName(Text_title, "设置分辨率_标题_文本")
	GUI:setAnchorPoint(Text_title, 0.50, 1.00)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 468)
	GUI:Text_disableOutLine(Text_title)

	-- Create Image_show
	local Image_show = GUI:Image_Create(PMainUI, "Image_show", 128.00, 289.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_show, 21, 21, 21, 21)
	GUI:setContentSize(Image_show, 118, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_show, false)
	GUI:setChineseName(Image_show, "设置分辨率_展示当前分辨率")
	GUI:setAnchorPoint(Image_show, 0.50, 0.50)
	GUI:setTouchEnabled(Image_show, true)
	GUI:setTag(Image_show, 307)

	-- Create Text_Resolution
	local Text_Resolution = GUI:Text_Create(Image_show, "Text_Resolution", 59.00, 12.00, 18, "#ffffff", [[1024x768]])
	GUI:setChineseName(Text_Resolution, "设置分辨率_分辨率_文本")
	GUI:setAnchorPoint(Text_Resolution, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Resolution, false)
	GUI:setTag(Text_Resolution, 309)
	GUI:Text_disableOutLine(Text_Resolution)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 270.00, 338.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 11, 11)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "设置分辨率_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 306)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(PMainUI, "Button_ok", 133.00, 40.00, "res/public/1900001000.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public/1900001001.png")
	GUI:Button_loadTextureDisabled(Button_ok, "res/public/1900001001.png")
	GUI:Button_setScale9Slice(Button_ok, 8, 8, 11, 11)
	GUI:setContentSize(Button_ok, 80, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "")
	GUI:Button_setTitleColor(Button_ok, "#414146")
	GUI:Button_setTitleFontSize(Button_ok, 14)
	GUI:Button_titleDisableOutLine(Button_ok)
	GUI:setChineseName(Button_ok, "设置分辨率_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 311)

	-- Create Panel_show
	local Panel_show = GUI:Layout_Create(PMainUI, "Panel_show", 128.00, 277.00, 118.00, 200.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_show, 21, 23, 21, 34)
	GUI:Layout_setBackGroundImage(Panel_show, "res/public/1900000677.png")
	GUI:setChineseName(Panel_show, "设置分辨率_选择列表组合")
	GUI:setAnchorPoint(Panel_show, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_show, true)
	GUI:setTag(Panel_show, 299)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_show, "ListView_1", 59.00, 200.00, 118.00, 200.00, 1)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:setChineseName(ListView_1, "设置_可选分辨率列表")
	GUI:setAnchorPoint(ListView_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 301)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Panel_show, "Panel_item", 60.00, 119.00, 114.00, 30.00, false)
	GUI:Layout_setBackGroundColorType(Panel_item, 1)
	GUI:Layout_setBackGroundColor(Panel_item, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_item, 255)
	GUI:setChineseName(Panel_item, "设置分辨率_单分辨率组合")
	GUI:setAnchorPoint(Panel_item, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 302)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_item, "Image_select", 57.00, 30.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 114, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "设置_单个选中_背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 1.00)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 303)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_item, "Text_1", 57.00, 15.00, 18, "#ffffff", [[1024x768]])
	GUI:setChineseName(Text_1, "设置_单分辨率_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 304)
	GUI:Text_disableOutLine(Text_1)
end
return ui