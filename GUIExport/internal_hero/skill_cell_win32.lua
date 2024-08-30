local ui = {}
function ui.init(parent)
	-- Create Panel_skill_cell
	local Panel_skill_cell = GUI:Layout_Create(parent, "Panel_skill_cell", 0.00, 0.00, 244.00, 50.00, false)
	GUI:setChineseName(Panel_skill_cell, "内功技能_组合")
	GUI:setTouchEnabled(Panel_skill_cell, true)
	GUI:setTag(Panel_skill_cell, 14)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_skill_cell, "Image_bg", 58.00, 24.00, "res/private/player_skill-win32/1900015023.png")
	GUI:Image_setScale9Slice(Image_bg, 19, 19, 9, 9)
	GUI:setContentSize(Image_bg, 184, 44)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "内功技能_背景图")
	GUI:setAnchorPoint(Image_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 16)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_skill_cell, "Image_icon", 30.00, 25.00, "res/private/player_skill-win32/1900015022.png")
	GUI:setChineseName(Image_icon, "内功技能_技能图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 14)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_skill_cell, "Image_1", 138.00, 35.00, "res/private/player_skill-win32/1900015021.png")
	GUI:setChineseName(Image_1, "内功技能_Lv图片")
	GUI:setAnchorPoint(Image_1, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 16)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_skill_cell, "Image_2", 63.00, 15.00, "res/private/player_skill-win32/1900015020.png")
	GUI:setChineseName(Image_2, "内功技能_Exp图片")
	GUI:setAnchorPoint(Image_2, 0.00, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 17)

	-- Create Text_skillName
	local Text_skillName = GUI:Text_Create(Panel_skill_cell, "Text_skillName", 63.00, 35.00, 12, "#ffffff", [[技能名称]])
	GUI:setChineseName(Text_skillName, "内功技能_技能名称_文本")
	GUI:setAnchorPoint(Text_skillName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillName, false)
	GUI:setTag(Text_skillName, 18)
	GUI:Text_enableOutline(Text_skillName, "#111111", 1)

	-- Create Text_skillLevel
	local Text_skillLevel = GUI:Text_Create(Panel_skill_cell, "Text_skillLevel", 163.00, 35.00, 12, "#ffff0f", [[-]])
	GUI:setChineseName(Text_skillLevel, "内功技能_技能等级")
	GUI:setAnchorPoint(Text_skillLevel, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillLevel, false)
	GUI:setTag(Text_skillLevel, 19)
	GUI:Text_enableOutline(Text_skillLevel, "#111111", 1)

	-- Create Text_skillTrain
	local Text_skillTrain = GUI:Text_Create(Panel_skill_cell, "Text_skillTrain", 98.00, 15.00, 12, "#ffffff", [[-]])
	GUI:setChineseName(Text_skillTrain, "内功技能_技能经验_文本")
	GUI:setAnchorPoint(Text_skillTrain, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillTrain, false)
	GUI:setTag(Text_skillTrain, 20)
	GUI:Text_enableOutline(Text_skillTrain, "#000000", 1)

	-- Create Text_levelup
	local Text_levelup = GUI:Text_Create(Panel_skill_cell, "Text_levelup", 63.00, 15.00, 12, "#ffffff", [[强化-重]])
	GUI:setChineseName(Text_levelup, "内功技能_强化等级")
	GUI:setAnchorPoint(Text_levelup, 0.00, 0.50)
	GUI:setTouchEnabled(Text_levelup, false)
	GUI:setTag(Text_levelup, 15)
	GUI:Text_enableOutline(Text_levelup, "#111111", 1)

	-- Create Button_onoff
	local Button_onoff = GUI:Button_Create(Panel_skill_cell, "Button_onoff", 184.00, 25.00, "res/private/internal_win32/bg_jnkan_02.png")
	GUI:Button_loadTexturePressed(Button_onoff, "res/private/internal_win32/bg_jnkan_01.png")
	GUI:Button_loadTextureDisabled(Button_onoff, "res/private/internal_win32/bg_jnkan_01.png")
	GUI:Button_setTitleText(Button_onoff, "")
	GUI:Button_setTitleColor(Button_onoff, "#ffffff")
	GUI:Button_setTitleFontSize(Button_onoff, 14)
	GUI:Button_titleEnableOutline(Button_onoff, "#000000", 1)
	GUI:setChineseName(Button_onoff, "内功技能_开关")
	GUI:setAnchorPoint(Button_onoff, 0.00, 0.50)
	GUI:setTouchEnabled(Button_onoff, true)
	GUI:setTag(Button_onoff, -1)

	-- Create Image_onoff
	local Image_onoff = GUI:Image_Create(Button_onoff, "Image_onoff", 0.00, 11.00, "res/private/internal_win32/btn_jnkan_02.png")
	GUI:setChineseName(Image_onoff, "内功技能_圆圈图片")
	GUI:setAnchorPoint(Image_onoff, 0.00, 0.50)
	GUI:setTouchEnabled(Image_onoff, false)
	GUI:setTag(Image_onoff, -1)
end
return ui