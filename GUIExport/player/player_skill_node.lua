local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家技能组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/player_skill/1900015001.png")
	GUI:setContentSize(Image_bg, 348.0, 478.0)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家技能_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 42.0)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 2.00, 60.00, 344.00, 416.00, 1.0)
	GUI:ListView_setGravity(ListView_cells, 5.0)
	GUI:setChineseName(ListView_cells, "玩家技能_技能列表")
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 13.0)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_1, "Image_5", 174.00, -1.00, "res/public/bg_hhdb_01.jpg")
	GUI:setContentSize(Image_5, 348.0, 60.0)
	GUI:setIgnoreContentAdaptWithSize(Image_5, false)
	GUI:setChineseName(Image_5, "玩家技能_技能配置_背景图")
	GUI:setAnchorPoint(Image_5, 0.50, 0.00)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 16.0)

	-- Create Button_setting
	local Button_setting = GUI:Button_Create(Panel_1, "Button_setting", 174.00, 30.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_setting, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_setting, 15, 17.0, 11, 18.0)
	GUI:setContentSize(Button_setting, 104.0, 33.0)
	GUI:setIgnoreContentAdaptWithSize(Button_setting, false)
	GUI:Button_setTitleText(Button_setting, "技能配置")
	GUI:Button_setTitleColor(Button_setting, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_setting, 18.0)
	GUI:Button_titleEnableOutline(Button_setting, "#111111", 2.0)
	GUI:setChineseName(Button_setting, "玩家技能_技能配置_按钮")
	GUI:setAnchorPoint(Button_setting, 0.50, 0.50)
	GUI:setTouchEnabled(Button_setting, true)
	GUI:setTag(Button_setting, 15.0)
end
return ui