local ui = {}
function ui.init(parent)
	-- Create Panel_swallow
	local Panel_swallow = GUI:Layout_Create(parent, "Panel_swallow", 0.00, 0.00, 240.00, 270.00, false)
	GUI:setChineseName(Panel_swallow, "防点击穿透区域1")
	GUI:setAnchorPoint(Panel_swallow, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_swallow, true)
	GUI:setTag(Panel_swallow, -1)

	-- Create Panel_swallow_0
	local Panel_swallow_0 = GUI:Layout_Create(parent, "Panel_swallow_0", -240.00, 0.00, 50.00, 150.00, false)
	GUI:setChineseName(Panel_swallow_0, "防点击穿透区域2")
	GUI:setAnchorPoint(Panel_swallow_0, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_swallow_0, true)
	GUI:setTag(Panel_swallow_0, -1)

	-- Create Panel_skill
	local Panel_skill = GUI:Layout_Create(parent, "Panel_skill", 0.00, 0.00, 320.00, 260.00, false)
	GUI:setChineseName(Panel_skill, "主技能组合")
	GUI:setAnchorPoint(Panel_skill, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_skill, false)
	GUI:setTag(Panel_skill, -1)

	-- Create Node_cell_1
	local Node_cell_1 = GUI:Node_Create(Panel_skill, "Node_cell_1", 241.00, 86.00)
	GUI:setChineseName(Node_cell_1, "主技能_技能节点1")
	GUI:setAnchorPoint(Node_cell_1, 0.50, 0.50)
	GUI:setTag(Node_cell_1, -1)

	-- Create Node_cell_2
	local Node_cell_2 = GUI:Node_Create(Panel_skill, "Node_cell_2", 130.00, 31.00)
	GUI:setChineseName(Node_cell_2, "主技能_技能节点2")
	GUI:setAnchorPoint(Node_cell_2, 0.50, 0.50)
	GUI:setTag(Node_cell_2, -1)

	-- Create Node_cell_3
	local Node_cell_3 = GUI:Node_Create(Panel_skill, "Node_cell_3", 142.00, 109.00)
	GUI:setChineseName(Node_cell_3, "主技能_技能节点3")
	GUI:setAnchorPoint(Node_cell_3, 0.50, 0.50)
	GUI:setTag(Node_cell_3, -1)

	-- Create Node_cell_4
	local Node_cell_4 = GUI:Node_Create(Panel_skill, "Node_cell_4", 186.00, 177.00)
	GUI:setChineseName(Node_cell_4, "主技能_技能节点4")
	GUI:setAnchorPoint(Node_cell_4, 0.50, 0.50)
	GUI:setTag(Node_cell_4, -1)

	-- Create Node_cell_5
	local Node_cell_5 = GUI:Node_Create(Panel_skill, "Node_cell_5", 260.00, 212.00)
	GUI:setChineseName(Node_cell_5, "主技能_技能节点5")
	GUI:setAnchorPoint(Node_cell_5, 0.50, 0.50)
	GUI:setTag(Node_cell_5, -1)

	-- Create Node_cell_6
	local Node_cell_6 = GUI:Node_Create(Panel_skill, "Node_cell_6", 51.00, 41.00)
	GUI:setChineseName(Node_cell_6, "主技能_技能节点6")
	GUI:setAnchorPoint(Node_cell_6, 0.50, 0.50)
	GUI:setTag(Node_cell_6, -1)

	-- Create Node_cell_7
	local Node_cell_7 = GUI:Node_Create(Panel_skill, "Node_cell_7", 62.00, 114.00)
	GUI:setChineseName(Node_cell_7, "主技能_技能节点7")
	GUI:setAnchorPoint(Node_cell_7, 0.50, 0.50)
	GUI:setTag(Node_cell_7, -1)

	-- Create Node_cell_8
	local Node_cell_8 = GUI:Node_Create(Panel_skill, "Node_cell_8", 93.00, 183.00)
	GUI:setChineseName(Node_cell_8, "主技能_技能节点8")
	GUI:setAnchorPoint(Node_cell_8, 0.50, 0.50)
	GUI:setTag(Node_cell_8, -1)

	-- Create Node_cell_9
	local Node_cell_9 = GUI:Node_Create(Panel_skill, "Node_cell_9", 147.00, 243.00)
	GUI:setChineseName(Node_cell_9, "主技能_技能节点9")
	GUI:setAnchorPoint(Node_cell_9, 0.50, 0.50)
	GUI:setTag(Node_cell_9, -1)

	-- Create Panel_quick_find
	local Panel_quick_find = GUI:Layout_Create(Panel_skill, "Panel_quick_find", 240.00, 85.00, 120.00, 120.00, false)
	GUI:setChineseName(Panel_quick_find, "快速寻找目标组合")
	GUI:setAnchorPoint(Panel_quick_find, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_find, true)
	GUI:setTag(Panel_quick_find, -1)

	-- Create Image_player
	local Image_player = GUI:Image_Create(Panel_quick_find, "Image_player", 120.00, 120.00, "res/private/main/Skill/1900012706.png")
	GUI:setChineseName(Image_player, "寻找目标_玩家_图片")
	GUI:setAnchorPoint(Image_player, 1.00, 1.00)
	GUI:setTouchEnabled(Image_player, false)
	GUI:setTag(Image_player, -1)

	-- Create Image_monster
	local Image_monster = GUI:Image_Create(Panel_quick_find, "Image_monster", 0.00, 0.00, "res/private/main/Skill/1900012704.png")
	GUI:setChineseName(Image_monster, "寻找目标_怪物_图片")
	GUI:setTouchEnabled(Image_monster, false)
	GUI:setTag(Image_monster, -1)

	-- Create Image_hero
	local Image_hero = GUI:Image_Create(Panel_quick_find, "Image_hero", 0.00, 120.00, "res/private/main/Skill/1900012710.png")
	GUI:setChineseName(Image_hero, "寻找目标_英雄_图片")
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
	GUI:setChineseName(Button_attack, "寻找目标_强攻_按钮")
	GUI:setAnchorPoint(Button_attack, 1.00, 0.00)
	GUI:setTouchEnabled(Button_attack, true)
	GUI:setTag(Button_attack, -1)

	-- Create Panel_hide
	local Panel_hide = GUI:Layout_Create(parent, "Panel_hide", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_hide, "菜单_触摸还原区域")
	GUI:setAnchorPoint(Panel_hide, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_hide, true)
	GUI:setTag(Panel_hide, -1)

	-- Create Panel_button
	local Panel_button = GUI:Layout_Create(parent, "Panel_button", 0.00, 0.00, 225.00, 355.00, false)
	GUI:setChineseName(Panel_button, "菜单切换组合")
	GUI:setAnchorPoint(Panel_button, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_button, false)
	GUI:setTag(Panel_button, -1)

	-- Create Panel_constant
	local Panel_constant = GUI:Layout_Create(Panel_button, "Panel_constant", 225.00, 355.00, 225.00, 70.00, false)
	GUI:setChineseName(Panel_constant, "菜单快捷组合")
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
	GUI:setChineseName(Button_change, "菜单_切换_按钮")
	GUI:setAnchorPoint(Button_change, 1.00, 0.50)
	GUI:setTouchEnabled(Button_change, true)
	GUI:setTag(Button_change, -1)

	-- Create Image_change_act
	local Image_change_act = GUI:Image_Create(Button_change, "Image_change_act", 30.00, 33.00, "res/private/main/bottom/1900012538.png")
	GUI:setChineseName(Image_change_act, "菜单_装饰_图片")
	GUI:setAnchorPoint(Image_change_act, 0.50, 0.50)
	GUI:setTouchEnabled(Image_change_act, false)
	GUI:setTag(Image_change_act, -1)

	-- Create Panel_active
	local Panel_active = GUI:Layout_Create(Panel_button, "Panel_active", 0.00, 305.00, 225.00, 280.00, false)
	GUI:setChineseName(Panel_active, "菜单_按钮区域")
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
	GUI:setChineseName(Button_pick, "一键拾取_按钮")
	GUI:setAnchorPoint(Button_pick, 0.50, 0.50)
	GUI:setTouchEnabled(Button_pick, true)
	GUI:setTag(Button_pick, -1)

	-- Create Node_hj_skill
	local Node_hj_skill = GUI:Node_Create(parent, "Node_hj_skill", -345.00, 244.00)
	GUI:setChineseName(Node_hj_skill, "技能_合击技能_节点")
	GUI:setAnchorPoint(Node_hj_skill, 0.50, 0.50)
	GUI:setTag(Node_hj_skill, -1)

	-- Create Node_combo_skill
	local Node_combo_skill = GUI:Node_Create(parent, "Node_combo_skill", -402.00, 278.00)
	GUI:setChineseName(Node_combo_skill, "技能_连击技能_节点")
	GUI:setAnchorPoint(Node_combo_skill, 0.50, 0.50)
	GUI:setTag(Node_combo_skill, -1)

	-- Create Button_Lock
	local Button_Lock = GUI:Button_Create(parent, "Button_Lock", -240.00, 290.00, "res/private/player_hero/btn_heji_05_1.png")
	GUI:Button_loadTexturePressed(Button_Lock, "res/private/player_hero/btn_heji_05_1.png")
	GUI:Button_loadTextureDisabled(Button_Lock, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_setTitleText(Button_Lock, "")
	GUI:Button_setTitleColor(Button_Lock, "#ffffff")
	GUI:Button_setTitleFontSize(Button_Lock, 10)
	GUI:Button_titleEnableOutline(Button_Lock, "#000000", 1)
	GUI:setChineseName(Button_Lock, "目标_锁定_按钮")
	GUI:setAnchorPoint(Button_Lock, 0.50, 0.50)
	GUI:setTouchEnabled(Button_Lock, true)
	GUI:setTag(Button_Lock, -1)
end
return ui