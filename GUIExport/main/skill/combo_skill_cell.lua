local ui = {}
function ui.init(parent)
	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0.00, 0.00, 64.00, 64.00, false)
	GUI:setChineseName(Panel_bg, "连击技能组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 0.00, 3.00, "res/private/main/bg_combo_skill.png")
	GUI:setContentSize(Image_bg, 64, 64)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "连击技能_背景")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 3.00, -4.00, "res/skill_icon_c/0.png")
	GUI:setContentSize(Button_icon, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#ffffff")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleEnableOutline(Button_icon, "#000000", 1)
	GUI:setChineseName(Button_icon, "连击技能_技能图标")
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, -1)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 8.00, 3.00)
	GUI:setChineseName(Node_sfx, "连击技能_节点")
	GUI:setTag(Node_sfx, -1)
end
return ui