local ui = {}
function ui.init(parent)
	-- Create Panel_skill
	local Panel_skill = GUI:Layout_Create(parent, "Panel_skill", 0.00, 0.00, 320.00, 260.00, false)
	GUI:setAnchorPoint(Panel_skill, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_skill, false)
	GUI:setTag(Panel_skill, -1)

	-- Create Node_skill_1
	local Node_skill_1 = GUI:Node_Create(Panel_skill, "Node_skill_1", 241.00, 86.00)
	GUI:setTag(Node_skill_1, -1)

	-- Create Node_skill_2
	local Node_skill_2 = GUI:Node_Create(Panel_skill, "Node_skill_2", 130.00, 31.00)
	GUI:setTag(Node_skill_2, -1)

	-- Create Node_skill_3
	local Node_skill_3 = GUI:Node_Create(Panel_skill, "Node_skill_3", 142.00, 109.00)
	GUI:setTag(Node_skill_3, -1)

	-- Create Node_skill_4
	local Node_skill_4 = GUI:Node_Create(Panel_skill, "Node_skill_4", 186.00, 177.00)
	GUI:setTag(Node_skill_4, -1)

	-- Create Node_skill_5
	local Node_skill_5 = GUI:Node_Create(Panel_skill, "Node_skill_5", 260.00, 212.00)
	GUI:setTag(Node_skill_5, -1)

	-- Create Node_skill_6
	local Node_skill_6 = GUI:Node_Create(Panel_skill, "Node_skill_6", 51.00, 41.00)
	GUI:setTag(Node_skill_6, -1)

	-- Create Node_skill_7
	local Node_skill_7 = GUI:Node_Create(Panel_skill, "Node_skill_7", 62.00, 114.00)
	GUI:setTag(Node_skill_7, -1)

	-- Create Node_skill_8
	local Node_skill_8 = GUI:Node_Create(Panel_skill, "Node_skill_8", 93.00, 183.00)
	GUI:setTag(Node_skill_8, -1)

	-- Create Node_skill_9
	local Node_skill_9 = GUI:Node_Create(Panel_skill, "Node_skill_9", 147.00, 243.00)
	GUI:setTag(Node_skill_9, -1)

	-- Create Panel_quick_find
	local Panel_quick_find = GUI:Layout_Create(Panel_skill, "Panel_quick_find", 240.00, 85.00, 120.00, 120.00, false)
	GUI:setAnchorPoint(Panel_quick_find, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_find, true)
	GUI:setTag(Panel_quick_find, -1)

	-- Create Image_player
	local Image_player = GUI:Image_Create(Panel_quick_find, "Image_player", 120.00, 120.00, "res/private/main/Skill/1900012706.png")
	GUI:setAnchorPoint(Image_player, 1.00, 1.00)
	GUI:setTouchEnabled(Image_player, false)
	GUI:setTag(Image_player, -1)

	-- Create Image_monster
	local Image_monster = GUI:Image_Create(Panel_quick_find, "Image_monster", 0.00, 0.00, "res/private/main/Skill/1900012704.png")
	GUI:setTouchEnabled(Image_monster, false)
	GUI:setTag(Image_monster, -1)

	-- Create Image_hero
	local Image_hero = GUI:Image_Create(Panel_quick_find, "Image_hero", 0.00, 120.00, "res/private/main/Skill/1900012710.png")
	GUI:setAnchorPoint(Image_hero, 0.00, 1.00)
	GUI:setTouchEnabled(Image_hero, false)
	GUI:setTag(Image_hero, -1)

	-- Create Button_attack
	local Button_attack = GUI:Button_Create(Panel_skill, "Button_attack", 320.00, 0.00, "res/private/main/Skill/icon_sifud_02.png")
	GUI:Button_loadTexturePressed(Button_attack, "res/private/main/Skill/icon_sifud_03.png")
	GUI:Button_setTitleText(Button_attack, "")
	GUI:Button_setTitleColor(Button_attack, "#ffffff")
	GUI:Button_setTitleFontSize(Button_attack, 10)
	GUI:Button_titleEnableOutline(Button_attack, "#000000", 1)
	GUI:setAnchorPoint(Button_attack, 1.00, 0.00)
	GUI:setTouchEnabled(Button_attack, true)
	GUI:setTag(Button_attack, -1)

	-- Create Panel_hide
	local Panel_hide = GUI:Layout_Create(parent, "Panel_hide", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Panel_hide, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_hide, true)
	GUI:setTag(Panel_hide, -1)

	-- Create Panel_button
	local Panel_button = GUI:Layout_Create(parent, "Panel_button", 0.00, 0.00, 225.00, 355.00, false)
	GUI:setAnchorPoint(Panel_button, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_button, false)
	GUI:setTag(Panel_button, -1)

	-- Create Panel_constant
	local Panel_constant = GUI:Layout_Create(Panel_button, "Panel_constant", 225.00, 355.00, 225.00, 70.00, false)
	GUI:setAnchorPoint(Panel_constant, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_constant, false)
	GUI:setTag(Panel_constant, -1)

	-- Create Button_change
	local Button_change = GUI:Button_Create(Panel_constant, "Button_change", 225.00, 35.00, "res/private/main/bottom/1900012580.png")
	GUI:Button_loadTexturePressed(Button_change, "res/private/main/bottom/1900012580.png")
	GUI:Button_setTitleText(Button_change, "")
	GUI:Button_setTitleColor(Button_change, "#ffffff")
	GUI:Button_setTitleFontSize(Button_change, 10)
	GUI:Button_titleEnableOutline(Button_change, "#000000", 1)
	GUI:setAnchorPoint(Button_change, 1.00, 0.50)
	GUI:setTouchEnabled(Button_change, true)
	GUI:setTag(Button_change, -1)

	-- Create Image_change_act
	local Image_change_act = GUI:Image_Create(Button_change, "Image_change_act", 30.00, 33.00, "res/private/main/bottom/1900012538.png")
	GUI:setAnchorPoint(Image_change_act, 0.50, 0.50)
	GUI:setTouchEnabled(Image_change_act, false)
	GUI:setTag(Image_change_act, -1)

	-- Create Panel_active
	local Panel_active = GUI:Layout_Create(Panel_button, "Panel_active", 0.00, 285.00, 225.00, 280.00, false)
	GUI:setAnchorPoint(Panel_active, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_active, false)
	GUI:setTag(Panel_active, -1)

	-- Create Button_pick
	local Button_pick = GUI:Button_Create(parent, "Button_pick", -160.00, 320.00, "res/private/main/Skill/btn_zhijiemian_05.png")
	GUI:Button_loadTextureDisabled(Button_pick, "res/private/main/Skill/btn_zhijiemian_06.png")
	GUI:Button_setTitleText(Button_pick, "")
	GUI:Button_setTitleColor(Button_pick, "#ffffff")
	GUI:Button_setTitleFontSize(Button_pick, 10)
	GUI:Button_titleEnableOutline(Button_pick, "#000000", 1)
	GUI:setAnchorPoint(Button_pick, 0.50, 0.50)
	GUI:setTouchEnabled(Button_pick, true)
	GUI:setTag(Button_pick, -1)

	-- Create Node_hj_skill
	local Node_hj_skill = GUI:Node_Create(parent, "Node_hj_skill", -345.00, 244.00)
	GUI:setTag(Node_hj_skill, -1)
end
return ui