local ui = {}
function ui.init(parent)
	-- Create Panel_skill_cell
	local Panel_skill_cell = GUI:Layout_Create(parent, "Panel_skill_cell", 0.00, 0.00, 348.00, 70.00, false)
	GUI:setChineseName(Panel_skill_cell, "玩家技能_组合")
	GUI:setTouchEnabled(Panel_skill_cell, true)
	GUI:setTag(Panel_skill_cell, 14)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_skill_cell, "Image_3", 75.00, 35.00, "res/private/player_skill/1900015004.png")
	GUI:Image_setScale9Slice(Image_3, 19, 19, 9, 9)
	GUI:setContentSize(Image_3, 270, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "玩家技能_背景图")
	GUI:setAnchorPoint(Image_3, 0.00, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 16)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_skill_cell, "Image_icon", 40.00, 35.00, "res/private/player_skill/1900015031.png")
	GUI:setChineseName(Image_icon, "玩家技能_技能图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 14)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_skill_cell, "Image_1", 163.57, 50.00, "res/private/player_skill/1900015021.png")
	GUI:setChineseName(Image_1, "玩家技能_Lv图片")
	GUI:setAnchorPoint(Image_1, 0.00, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 16)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_skill_cell, "Image_2", 80.00, 20.00, "res/private/player_skill/1900015020.png")
	GUI:setChineseName(Image_2, "玩家技能_Exp图片")
	GUI:setAnchorPoint(Image_2, 0.00, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 17)

	-- Create Text_skillName
	local Text_skillName = GUI:Text_Create(Panel_skill_cell, "Text_skillName", 80.00, 51.00, 16, "#ffffff", [[技能名称]])
	GUI:setChineseName(Text_skillName, "玩家技能_技能名称_文本")
	GUI:setAnchorPoint(Text_skillName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillName, false)
	GUI:setTag(Text_skillName, 18)
	GUI:Text_enableOutline(Text_skillName, "#111111", 1)

	-- Create Text_skillLevel
	local Text_skillLevel = GUI:Text_Create(Panel_skill_cell, "Text_skillLevel", 199.17, 50.00, 16, "#ffff0f", [[0]])
	GUI:setChineseName(Text_skillLevel, "玩家技能_技能等级")
	GUI:setAnchorPoint(Text_skillLevel, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillLevel, false)
	GUI:setTag(Text_skillLevel, 19)
	GUI:Text_enableOutline(Text_skillLevel, "#111111", 1)

	-- Create Text_skillTrain
	local Text_skillTrain = GUI:Text_Create(Panel_skill_cell, "Text_skillTrain", 130.00, 22.00, 16, "#ffffff", [[123]])
	GUI:setChineseName(Text_skillTrain, "玩家技能_技能经验_文本")
	GUI:setAnchorPoint(Text_skillTrain, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillTrain, false)
	GUI:setTag(Text_skillTrain, 20)
	GUI:Text_enableOutline(Text_skillTrain, "#000000", 1)

	-- Create Text_levelup
	local Text_levelup = GUI:Text_Create(Panel_skill_cell, "Text_levelup", 80.00, 22.00, 16, "#ffffff", [[强化一重]])
	GUI:setChineseName(Text_levelup, "玩家技能_强化等级")
	GUI:setAnchorPoint(Text_levelup, 0.00, 0.50)
	GUI:setTouchEnabled(Text_levelup, false)
	GUI:setTag(Text_levelup, 18)
	GUI:Text_enableOutline(Text_levelup, "#111111", 1)
end
return ui