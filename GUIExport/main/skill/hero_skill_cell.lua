local ui = {}
function ui.init(parent)
	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0.00, 0.00, 65.00, 65.00, false)
	GUI:setChineseName(Panel_bg, "合击技能组合")
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 32.00, 39.00, "res/private/main/bg_hejidj_01.png")
	GUI:setContentSize(Image_bg, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "合击技能_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Image_progress
	local Image_progress = GUI:Image_Create(Panel_bg, "Image_progress", 32.00, 32.00, "res/private/main/bg_hejidj_02.png")
	GUI:setChineseName(Image_progress, "合击技能_进度条")
	GUI:setAnchorPoint(Image_progress, 0.50, 0.50)
	GUI:setTouchEnabled(Image_progress, false)
	GUI:setTag(Image_progress, -1)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 32.00, 32.00, "res/private/main/bg_hejidj_01.png")
	GUI:setContentSize(Button_icon, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#ffffff")
	GUI:Button_setTitleFontSize(Button_icon, 10)
	GUI:Button_titleEnableOutline(Button_icon, "#000000", 1)
	GUI:setChineseName(Button_icon, "合击技能_图标")
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, -1)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 32.00, 32.00)
	GUI:setChineseName(Node_sfx, "合击技能_节点")
	GUI:setAnchorPoint(Node_sfx, 0.50, 0.50)
	GUI:setTag(Node_sfx, -1)
end
return ui