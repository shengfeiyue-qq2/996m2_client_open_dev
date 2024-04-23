local ui = {}
function ui.init(parent)
	-- Create Layout
	local Layout = GUI:Layout_Create(parent, "Layout", 0.00, 0.00, 265.00, 188.00, true)
	GUI:setAnchorPoint(Layout, 0.00, 1.00)
	GUI:setTouchEnabled(Layout, false)
	GUI:setTag(Layout, -1)

	-- Create Panel_assist
	local Panel_assist = GUI:Layout_Create(Layout, "Panel_assist", 0.00, 0.00, 244.00, 188.00, false)
	GUI:setTouchEnabled(Panel_assist, false)
	GUI:setTag(Panel_assist, -1)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_assist, "Panel_content", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_content, false)
	GUI:setTag(Panel_content, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_content, "Image_1", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Panel_task
	local Panel_task = GUI:Layout_Create(Panel_content, "Panel_task", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_task, false)
	GUI:setTag(Panel_task, -1)

	-- Create ListView_task
	local ListView_task = GUI:ListView_Create(Panel_task, "ListView_task", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_task, 5)
	GUI:setAnchorPoint(ListView_task, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_task, true)
	GUI:setTag(ListView_task, -1)

	-- Create Panel_team
	local Panel_team = GUI:Layout_Create(Panel_content, "Panel_team", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_team, false)
	GUI:setTag(Panel_team, -1)
	GUI:setVisible(Panel_team, false)

	-- Create Panel_member
	local Panel_member = GUI:Layout_Create(Panel_team, "Panel_member", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_member, false)
	GUI:setTag(Panel_member, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_member, "Image_2", 101.00, 190.00, "res/private/main/assist/1900012571.png")
	GUI:setAnchorPoint(Image_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create ListView_member
	local ListView_member = GUI:ListView_Create(Panel_member, "ListView_member", 101.00, 187.00, 200.00, 157.00, 1)
	GUI:ListView_setGravity(ListView_member, 5)
	GUI:setAnchorPoint(ListView_member, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_member, true)
	GUI:setTag(ListView_member, -1)

	-- Create Button_invite
	local Button_invite = GUI:Button_Create(Panel_member, "Button_invite", 101.00, 1.00, "res/private/main/assist/btn_zudui_02.png")
	GUI:Button_loadTexturePressed(Button_invite, "res/private/main/assist/btn_zudui_01.png")
	GUI:Button_setTitleText(Button_invite, "邀请队员")
	GUI:Button_setTitleColor(Button_invite, "#ffffff")
	GUI:Button_setTitleFontSize(Button_invite, 14)
	GUI:Button_titleEnableOutline(Button_invite, "#111111", 1)
	GUI:setAnchorPoint(Button_invite, 1.00, 0.00)
	GUI:setTouchEnabled(Button_invite, true)
	GUI:setTag(Button_invite, -1)

	-- Create Button_member
	local Button_member = GUI:Button_Create(Panel_member, "Button_member", 101.00, 1.00, "res/private/main/assist/btn_zudui_02.png")
	GUI:Button_loadTexturePressed(Button_member, "res/private/main/assist/btn_zudui_01.png")
	GUI:Button_setTitleText(Button_member, "队伍列表")
	GUI:Button_setTitleColor(Button_member, "#ffffff")
	GUI:Button_setTitleFontSize(Button_member, 14)
	GUI:Button_titleEnableOutline(Button_member, "#111111", 1)
	GUI:setTouchEnabled(Button_member, true)
	GUI:setTag(Button_member, -1)

	-- Create Panel_empty
	local Panel_empty = GUI:Layout_Create(Panel_team, "Panel_empty", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_empty, false)
	GUI:setTag(Panel_empty, -1)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_empty, "Button_create", 101.00, 132.00, "res/private/main/assist/1900000652.png")
	GUI:Button_setTitleText(Button_create, "创建队伍")
	GUI:Button_setTitleColor(Button_create, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_create, 16)
	GUI:Button_titleEnableOutline(Button_create, "#111111", 2)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, -1)

	-- Create Button_near
	local Button_near = GUI:Button_Create(Panel_empty, "Button_near", 101.00, 75.00, "res/private/main/assist/1900000653.png")
	GUI:Button_setTitleText(Button_near, "附近队伍")
	GUI:Button_setTitleColor(Button_near, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_near, 16)
	GUI:Button_titleEnableOutline(Button_near, "#111111", 2)
	GUI:setAnchorPoint(Button_near, 0.50, 0.50)
	GUI:setTouchEnabled(Button_near, true)
	GUI:setTag(Button_near, -1)

	-- Create Panel_enemy
	local Panel_enemy = GUI:Layout_Create(Panel_assist, "Panel_enemy", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_enemy, false)
	GUI:setTag(Panel_enemy, -1)
	GUI:setVisible(Panel_enemy, false)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_enemy, "Image_3", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, -1)

	-- Create Panel_player
	local Panel_player = GUI:Layout_Create(Panel_enemy, "Panel_player", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_player, false)
	GUI:setTag(Panel_player, -1)

	-- Create ListView_player
	local ListView_player = GUI:ListView_Create(Panel_player, "ListView_player", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_player, 5)
	GUI:setAnchorPoint(ListView_player, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_player, true)
	GUI:setTag(ListView_player, -1)

	-- Create Panel_monster
	local Panel_monster = GUI:Layout_Create(Panel_enemy, "Panel_monster", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setTouchEnabled(Panel_monster, false)
	GUI:setTag(Panel_monster, -1)

	-- Create ListView_monster
	local ListView_monster = GUI:ListView_Create(Panel_monster, "ListView_monster", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:ListView_setGravity(ListView_monster, 5)
	GUI:setAnchorPoint(ListView_monster, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_monster, true)
	GUI:setTag(ListView_monster, -1)

	-- Create Panel_group
	local Panel_group = GUI:Layout_Create(Panel_assist, "Panel_group", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setTouchEnabled(Panel_group, false)
	GUI:setTag(Panel_group, -1)

	-- Create BtnG_content
	local BtnG_content = GUI:Layout_Create(Panel_group, "BtnG_content", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setTouchEnabled(BtnG_content, false)
	GUI:setTag(BtnG_content, -1)

	-- Create Button_task
	local Button_task = GUI:Button_Create(BtnG_content, "Button_task", 21.00, 105.00, "res/private/main/assist/1900012554.png")
	GUI:Button_loadTexturePressed(Button_task, "res/private/main/assist/1900012554.png")
	GUI:Button_loadTextureDisabled(Button_task, "res/private/main/assist/1900012555.png")
	GUI:Button_setTitleText(Button_task, "")
	GUI:Button_setTitleColor(Button_task, "#ffffff")
	GUI:Button_setTitleFontSize(Button_task, 10)
	GUI:Button_titleEnableOutline(Button_task, "#000000", 1)
	GUI:setAnchorPoint(Button_task, 0.50, 0.00)
	GUI:setTouchEnabled(Button_task, true)
	GUI:setTag(Button_task, -1)

	-- Create Button_team
	local Button_team = GUI:Button_Create(BtnG_content, "Button_team", 21.00, 83.00, "res/private/main/assist/1900012556.png")
	GUI:Button_loadTexturePressed(Button_team, "res/private/main/assist/1900012556.png")
	GUI:Button_loadTextureDisabled(Button_team, "res/private/main/assist/1900012557.png")
	GUI:Button_setTitleText(Button_team, "")
	GUI:Button_setTitleColor(Button_team, "#ffffff")
	GUI:Button_setTitleFontSize(Button_team, 10)
	GUI:Button_titleEnableOutline(Button_team, "#000000", 1)
	GUI:setAnchorPoint(Button_team, 0.50, 1.00)
	GUI:setTouchEnabled(Button_team, true)
	GUI:setTag(Button_team, -1)

	-- Create BtnG_enemy
	local BtnG_enemy = GUI:Layout_Create(Panel_group, "BtnG_enemy", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setTouchEnabled(BtnG_enemy, false)
	GUI:setTag(BtnG_enemy, -1)

	-- Create Button_player
	local Button_player = GUI:Button_Create(BtnG_enemy, "Button_player", 21.00, 105.00, "res/private/main/assist/1900012550.png")
	GUI:Button_loadTexturePressed(Button_player, "res/private/main/assist/1900012550.png")
	GUI:Button_loadTextureDisabled(Button_player, "res/private/main/assist/1900012551.png")
	GUI:Button_setTitleText(Button_player, "")
	GUI:Button_setTitleColor(Button_player, "#ffffff")
	GUI:Button_setTitleFontSize(Button_player, 10)
	GUI:Button_titleEnableOutline(Button_player, "#000000", 1)
	GUI:setAnchorPoint(Button_player, 0.50, 0.00)
	GUI:setTouchEnabled(Button_player, true)
	GUI:setTag(Button_player, -1)

	-- Create Button_monster
	local Button_monster = GUI:Button_Create(BtnG_enemy, "Button_monster", 21.00, 83.00, "res/private/main/assist/1900012552.png")
	GUI:Button_loadTexturePressed(Button_monster, "res/private/main/assist/1900012552.png")
	GUI:Button_loadTextureDisabled(Button_monster, "res/private/main/assist/1900012553.png")
	GUI:Button_setTitleText(Button_monster, "")
	GUI:Button_setTitleColor(Button_monster, "#ffffff")
	GUI:Button_setTitleFontSize(Button_monster, 10)
	GUI:Button_titleEnableOutline(Button_monster, "#000000", 1)
	GUI:setAnchorPoint(Button_monster, 0.50, 1.00)
	GUI:setTouchEnabled(Button_monster, true)
	GUI:setTag(Button_monster, -1)

	-- Create Button_change
	local Button_change = GUI:Button_Create(Panel_group, "Button_change", 21.00, 94.00, "res/private/main/assist/1900012558.png")
	GUI:Button_loadTexturePressed(Button_change, "res/private/main/assist/1900012559.png")
	GUI:Button_setTitleText(Button_change, "")
	GUI:Button_setTitleColor(Button_change, "#ffffff")
	GUI:Button_setTitleFontSize(Button_change, 10)
	GUI:Button_titleEnableOutline(Button_change, "#000000", 1)
	GUI:setAnchorPoint(Button_change, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change, true)
	GUI:setTag(Button_change, -1)

	-- Create Panel_hide
	local Panel_hide = GUI:Layout_Create(Layout, "Panel_hide", 245.00, 0.00, 21.00, 188.00, false)
	GUI:setTouchEnabled(Panel_hide, false)
	GUI:setTag(Panel_hide, -1)

	-- Create Image_hide_bg
	local Image_hide_bg = GUI:Image_Create(Panel_hide, "Image_hide_bg", 10.00, 94.00, "res/private/main/assist/1900012573.png")
	GUI:setAnchorPoint(Image_hide_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hide_bg, false)
	GUI:setTag(Image_hide_bg, -1)

	-- Create Button_hide
	local Button_hide = GUI:Button_Create(Panel_hide, "Button_hide", 10.00, 94.00, "res/private/main/assist/1900012566.png")
	GUI:Button_setTitleText(Button_hide, "")
	GUI:Button_setTitleColor(Button_hide, "#ffffff")
	GUI:Button_setTitleFontSize(Button_hide, 10)
	GUI:Button_titleEnableOutline(Button_hide, "#000000", 1)
	GUI:setAnchorPoint(Button_hide, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hide, true)
	GUI:setTag(Button_hide, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_hide, "TouchSize", -5.00, -71.00, 24.00, 188.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)
end
return ui