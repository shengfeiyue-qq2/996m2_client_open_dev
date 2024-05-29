local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "任务节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_assist
	local Panel_assist = GUI:Layout_Create(Node, "Panel_assist", 0.00, 0.00, 244.00, 188.00, false)
	GUI:setChineseName(Panel_assist, "任务_组合")
	GUI:setAnchorPoint(Panel_assist, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_assist, false)
	GUI:setTag(Panel_assist, -1)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_assist, "Panel_content", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_content, "任务详细面板")
	GUI:setTouchEnabled(Panel_content, false)
	GUI:setTag(Panel_content, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_content, "Image_1", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setChineseName(Image_1, "任务详细_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Panel_mission
	local Panel_mission = GUI:Layout_Create(Panel_content, "Panel_mission", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_mission, "任务详细组合")
	GUI:setTouchEnabled(Panel_mission, false)
	GUI:setTag(Panel_mission, -1)

	-- Create ListView_mission
	local ListView_mission = GUI:ListView_Create(Panel_mission, "ListView_mission", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_mission, 5)
	GUI:setChineseName(ListView_mission, "任务详细_列表")
	GUI:setAnchorPoint(ListView_mission, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_mission, true)
	GUI:setTag(ListView_mission, -1)

	-- Create Panel_team
	local Panel_team = GUI:Layout_Create(Panel_content, "Panel_team", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_team, "队伍组合")
	GUI:setTouchEnabled(Panel_team, false)
	GUI:setTag(Panel_team, -1)

	-- Create Panel_member
	local Panel_member = GUI:Layout_Create(Panel_team, "Panel_member", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_member, "队伍_菜单组合")
	GUI:setTouchEnabled(Panel_member, false)
	GUI:setTag(Panel_member, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_member, "Image_2", 101.00, 190.00, "res/private/main/assist/1900012571.png")
	GUI:setChineseName(Image_2, "队伍_菜单_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create ListView_member
	local ListView_member = GUI:ListView_Create(Panel_member, "ListView_member", 101.00, 187.00, 200.00, 157.00, 1)
	GUI:ListView_setGravity(ListView_member, 5)
	GUI:setChineseName(ListView_member, "队伍_成员_列表")
	GUI:setAnchorPoint(ListView_member, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_member, true)
	GUI:setTag(ListView_member, -1)

	-- Create Button_invite
	local Button_invite = GUI:Button_Create(Panel_member, "Button_invite", 101.00, 1.00, "res/private/main/assist/btn_zudui_02.png")
	GUI:Button_loadTexturePressed(Button_invite, "res/private/main/assist/btn_zudui_01.png")
	GUI:Button_setTitleText(Button_invite, "邀请队员")
	GUI:Button_setTitleColor(Button_invite, "#ffffff")
	GUI:Button_setTitleFontSize(Button_invite, 14)
	GUI:Button_titleEnableOutline(Button_invite, "#000000", 1)
	GUI:setChineseName(Button_invite, "队伍_邀请队员_按钮")
	GUI:setAnchorPoint(Button_invite, 1.00, 0.00)
	GUI:setTouchEnabled(Button_invite, true)
	GUI:setTag(Button_invite, -1)

	-- Create Button_member
	local Button_member = GUI:Button_Create(Panel_member, "Button_member", 101.00, 1.00, "res/private/main/assist/btn_zudui_02.png")
	GUI:Button_loadTexturePressed(Button_member, "res/private/main/assist/btn_zudui_01.png")
	GUI:Button_setTitleText(Button_member, "队伍列表")
	GUI:Button_setTitleColor(Button_member, "#ffffff")
	GUI:Button_setTitleFontSize(Button_member, 14)
	GUI:Button_titleEnableOutline(Button_member, "#000000", 1)
	GUI:setChineseName(Button_member, "队伍_队伍列表_按钮")
	GUI:setTouchEnabled(Button_member, true)
	GUI:setTag(Button_member, -1)

	-- Create Panel_empty
	local Panel_empty = GUI:Layout_Create(Panel_team, "Panel_empty", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_empty, "队伍_无队伍时")
	GUI:setTouchEnabled(Panel_empty, false)
	GUI:setTag(Panel_empty, -1)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_empty, "Button_create", 101.00, 132.00, "res/private/main/assist/1900000652.png")
	GUI:Button_setTitleText(Button_create, "创建队伍")
	GUI:Button_setTitleColor(Button_create, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_create, 16)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setChineseName(Button_create, "队伍_创建队伍_按钮")
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, -1)

	-- Create Button_near
	local Button_near = GUI:Button_Create(Panel_empty, "Button_near", 101.00, 75.00, "res/private/main/assist/1900000653.png")
	GUI:Button_setTitleText(Button_near, "附近队伍")
	GUI:Button_setTitleColor(Button_near, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_near, 16)
	GUI:Button_titleEnableOutline(Button_near, "#000000", 1)
	GUI:setChineseName(Button_near, "队伍_附近队伍_按钮")
	GUI:setAnchorPoint(Button_near, 0.50, 0.50)
	GUI:setTouchEnabled(Button_near, true)
	GUI:setTag(Button_near, -1)

	-- Create Panel_enemy
	local Panel_enemy = GUI:Layout_Create(Panel_assist, "Panel_enemy", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_enemy, "队员_无人物_组合")
	GUI:setTouchEnabled(Panel_enemy, false)
	GUI:setTag(Panel_enemy, -1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_enemy, "Image_3", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setChineseName(Image_3, "队员_无人物_背景图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, -1)

	-- Create Panel_player
	local Panel_player = GUI:Layout_Create(Panel_enemy, "Panel_player", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_player, "队员_玩家_组合")
	GUI:setTouchEnabled(Panel_player, false)
	GUI:setTag(Panel_player, -1)

	-- Create ListView_player
	local ListView_player = GUI:ListView_Create(Panel_player, "ListView_player", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_player, 5)
	GUI:setChineseName(ListView_player, "队员_玩家_列表")
	GUI:setAnchorPoint(ListView_player, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_player, true)
	GUI:setTag(ListView_player, -1)

	-- Create Panel_monster
	local Panel_monster = GUI:Layout_Create(Panel_enemy, "Panel_monster", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_monster, "怪物组合")
	GUI:setTouchEnabled(Panel_monster, false)
	GUI:setTag(Panel_monster, -1)

	-- Create ListView_monster
	local ListView_monster = GUI:ListView_Create(Panel_monster, "ListView_monster", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_monster, 5)
	GUI:setChineseName(ListView_monster, "怪物_列表")
	GUI:setAnchorPoint(ListView_monster, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_monster, true)
	GUI:setTag(ListView_monster, -1)

	-- Create Panel_hero
	local Panel_hero = GUI:Layout_Create(Panel_assist, "Panel_hero", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_hero, "英雄_组合")
	GUI:setTouchEnabled(Panel_hero, false)
	GUI:setTag(Panel_hero, -1)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_hero, "Image_4", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setChineseName(Image_4, "英雄_背景图")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, -1)

	-- Create Panel_hero_in
	local Panel_hero_in = GUI:Layout_Create(Panel_hero, "Panel_hero_in", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_hero_in, "英雄_组合")
	GUI:setTouchEnabled(Panel_hero_in, false)
	GUI:setTag(Panel_hero_in, -1)

	-- Create ListView_hero
	local ListView_hero = GUI:ListView_Create(Panel_hero_in, "ListView_hero", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_hero, 5)
	GUI:setChineseName(ListView_hero, "英雄_列表")
	GUI:setAnchorPoint(ListView_hero, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_hero, true)
	GUI:setTag(ListView_hero, -1)

	-- Create Panel_group
	local Panel_group = GUI:Layout_Create(Panel_assist, "Panel_group", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(Panel_group, "切换频道组合")
	GUI:setTouchEnabled(Panel_group, false)
	GUI:setTag(Panel_group, -1)

	-- Create BtnG_content
	local BtnG_content = GUI:Layout_Create(Panel_group, "BtnG_content", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(BtnG_content, "任务_任务_点击切换内容")
	GUI:setTouchEnabled(BtnG_content, false)
	GUI:setTag(BtnG_content, -1)

	-- Create Button_mission
	local Button_mission = GUI:Button_Create(BtnG_content, "Button_mission", 21.00, 104.00, "res/private/main/assist/1900012554.png")
	GUI:Button_loadTexturePressed(Button_mission, "res/private/main/assist/1900012554.png")
	GUI:Button_loadTextureDisabled(Button_mission, "res/private/main/assist/1900012555.png")
	GUI:Button_setTitleText(Button_mission, "")
	GUI:Button_setTitleColor(Button_mission, "#ffffff")
	GUI:Button_setTitleFontSize(Button_mission, 10)
	GUI:Button_titleEnableOutline(Button_mission, "#000000", 1)
	GUI:setChineseName(Button_mission, "任务_按钮")
	GUI:setAnchorPoint(Button_mission, 0.50, 0.00)
	GUI:setTouchEnabled(Button_mission, true)
	GUI:setTag(Button_mission, -1)

	-- Create Button_team
	local Button_team = GUI:Button_Create(BtnG_content, "Button_team", 21.00, 85.00, "res/private/main/assist/1900012556.png")
	GUI:Button_loadTexturePressed(Button_team, "res/private/main/assist/1900012556.png")
	GUI:Button_loadTextureDisabled(Button_team, "res/private/main/assist/1900012557.png")
	GUI:Button_setTitleText(Button_team, "")
	GUI:Button_setTitleColor(Button_team, "#ffffff")
	GUI:Button_setTitleFontSize(Button_team, 10)
	GUI:Button_titleEnableOutline(Button_team, "#000000", 1)
	GUI:setChineseName(Button_team, "队伍_按钮")
	GUI:setAnchorPoint(Button_team, 0.50, 1.00)
	GUI:setTouchEnabled(Button_team, true)
	GUI:setTag(Button_team, -1)

	-- Create BtnG_enemy
	local BtnG_enemy = GUI:Layout_Create(Panel_group, "BtnG_enemy", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(BtnG_enemy, "任务_敌人_点击切换内容")
	GUI:setTouchEnabled(BtnG_enemy, false)
	GUI:setTag(BtnG_enemy, -1)

	-- Create Button_player
	local Button_player = GUI:Button_Create(BtnG_enemy, "Button_player", 21.00, 104.00, "res/private/main/assist/1900012550.png")
	GUI:Button_loadTexturePressed(Button_player, "res/private/main/assist/1900012550.png")
	GUI:Button_loadTextureDisabled(Button_player, "res/private/main/assist/1900012551.png")
	GUI:Button_setTitleText(Button_player, "")
	GUI:Button_setTitleColor(Button_player, "#ffffff")
	GUI:Button_setTitleFontSize(Button_player, 10)
	GUI:Button_titleEnableOutline(Button_player, "#000000", 1)
	GUI:setChineseName(Button_player, "玩家_按钮")
	GUI:setAnchorPoint(Button_player, 0.50, 0.00)
	GUI:setTouchEnabled(Button_player, true)
	GUI:setTag(Button_player, -1)

	-- Create Button_monster
	local Button_monster = GUI:Button_Create(BtnG_enemy, "Button_monster", 21.00, 85.00, "res/private/main/assist/1900012552.png")
	GUI:Button_loadTexturePressed(Button_monster, "res/private/main/assist/1900012552.png")
	GUI:Button_loadTextureDisabled(Button_monster, "res/private/main/assist/1900012553.png")
	GUI:Button_setTitleText(Button_monster, "")
	GUI:Button_setTitleColor(Button_monster, "#ffffff")
	GUI:Button_setTitleFontSize(Button_monster, 10)
	GUI:Button_titleEnableOutline(Button_monster, "#000000", 1)
	GUI:setChineseName(Button_monster, "怪物_按钮")
	GUI:setAnchorPoint(Button_monster, 0.50, 1.00)
	GUI:setTouchEnabled(Button_monster, true)
	GUI:setTag(Button_monster, -1)

	-- Create BtnG_hero
	local BtnG_hero = GUI:Layout_Create(Panel_group, "BtnG_hero", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(BtnG_hero, "任务_英雄_点击切换内容")
	GUI:setTouchEnabled(BtnG_hero, false)
	GUI:setTag(BtnG_hero, -1)

	-- Create Button_hero
	local Button_hero = GUI:Button_Create(BtnG_hero, "Button_hero", 21.00, 104.00, "res/private/main/assist/hero1.png")
	GUI:Button_loadTexturePressed(Button_hero, "res/private/main/assist/hero1.png")
	GUI:Button_loadTextureDisabled(Button_hero, "res/private/main/assist/hero2.png")
	GUI:Button_setTitleText(Button_hero, "")
	GUI:Button_setTitleColor(Button_hero, "#ffffff")
	GUI:Button_setTitleFontSize(Button_hero, 10)
	GUI:Button_titleEnableOutline(Button_hero, "#000000", 1)
	GUI:setChineseName(Button_hero, "英雄_按钮")
	GUI:setAnchorPoint(Button_hero, 0.50, 0.00)
	GUI:setTouchEnabled(Button_hero, true)
	GUI:setTag(Button_hero, -1)

	-- Create Button_empty
	local Button_empty = GUI:Button_Create(BtnG_hero, "Button_empty", 21.00, 85.00, "res/private/main/assist/empty2.png")
	GUI:Button_loadTexturePressed(Button_empty, "res/private/main/assist/empty1.png")
	GUI:Button_loadTextureDisabled(Button_empty, "res/private/main/assist/empty2.png")
	GUI:Button_setTitleText(Button_empty, "")
	GUI:Button_setTitleColor(Button_empty, "#ffffff")
	GUI:Button_setTitleFontSize(Button_empty, 10)
	GUI:Button_titleEnableOutline(Button_empty, "#000000", 1)
	GUI:setChineseName(Button_empty, "空_按钮")
	GUI:setAnchorPoint(Button_empty, 0.50, 1.00)
	GUI:setTouchEnabled(Button_empty, true)
	GUI:setTag(Button_empty, -1)

	-- Create Button_change
	local Button_change = GUI:Button_Create(Panel_group, "Button_change", 21.00, 94.00, "res/private/main/assist/1900012558.png")
	GUI:Button_loadTexturePressed(Button_change, "res/private/main/assist/1900012559.png")
	GUI:Button_setTitleText(Button_change, "")
	GUI:Button_setTitleColor(Button_change, "#ffffff")
	GUI:Button_setTitleFontSize(Button_change, 10)
	GUI:Button_titleEnableOutline(Button_change, "#000000", 1)
	GUI:setChineseName(Button_change, "任务_切换_按钮")
	GUI:setAnchorPoint(Button_change, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change, true)
	GUI:setTag(Button_change, -1)

	-- Create Panel_hide
	local Panel_hide = GUI:Layout_Create(Node, "Panel_hide", 245.00, 0.00, 21.00, 188.00, false)
	GUI:setChineseName(Panel_hide, "任务伸缩组合")
	GUI:setAnchorPoint(Panel_hide, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_hide, true)
	GUI:setTag(Panel_hide, -1)

	-- Create Image_24
	local Image_24 = GUI:Image_Create(Panel_hide, "Image_24", 10.00, 94.00, "res/private/main/assist/1900012573.png")
	GUI:setChineseName(Image_24, "任务伸缩_背景图")
	GUI:setAnchorPoint(Image_24, 0.50, 0.50)
	GUI:setTouchEnabled(Image_24, false)
	GUI:setTag(Image_24, -1)

	-- Create Button_hide
	local Button_hide = GUI:Button_Create(Panel_hide, "Button_hide", 10.00, 94.00, "res/private/main/assist/1900012566.png")
	GUI:Button_setTitleText(Button_hide, "")
	GUI:Button_setTitleColor(Button_hide, "#ffffff")
	GUI:Button_setTitleFontSize(Button_hide, 10)
	GUI:Button_titleEnableOutline(Button_hide, "#000000", 1)
	GUI:setChineseName(Button_hide, "任务伸缩_缩进")
	GUI:setAnchorPoint(Button_hide, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hide, true)
	GUI:setTag(Button_hide, -1)
end
return ui