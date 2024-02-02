local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 276.00, 614.00, 201.00, 94.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 66)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 4.00, 92.00, "res/private/player_hero/00010.png")
	GUI:setAnchorPoint(Image_2, 0.00, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 67)

	-- Create LoadingBar_1
	local LoadingBar_1 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_1", 135.00, 63.00, "res/private/player_hero/01061.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_1, 100)
	GUI:LoadingBar_setColor(LoadingBar_1, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_1, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_1, false)
	GUI:setTag(LoadingBar_1, 68)

	-- Create LoadingBar_2
	local LoadingBar_2 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_2", 138.00, 50.00, "res/private/player_hero/01062.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_2, 100)
	GUI:LoadingBar_setColor(LoadingBar_2, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_2, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_2, false)
	GUI:setTag(LoadingBar_2, 69)

	-- Create LoadingBar_3
	local LoadingBar_3 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_3", 140.00, 37.00, "res/private/player_hero/01064.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_3, 100)
	GUI:LoadingBar_setColor(LoadingBar_3, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_3, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_3, false)
	GUI:setTag(LoadingBar_3, 70)

	-- Create Panel_info
	local Panel_info = GUI:Layout_Create(Panel_1, "Panel_info", 200.00, 90.00, 124.00, 82.00, false)
	GUI:setAnchorPoint(Panel_info, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_info, false)
	GUI:setTag(Panel_info, 20)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Panel_1, "Image_head", 41.00, 42.00, "res/private/player_hero/01210.png")
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setScaleX(Image_head, 1.05)
	GUI:setScaleY(Image_head, 1.05)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 71)

	-- Create Image_levelbg
	local Image_levelbg = GUI:Image_Create(Panel_1, "Image_levelbg", 16.00, 15.00, "res/private/player_hero/btn_heji_01.png")
	GUI:setAnchorPoint(Image_levelbg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_levelbg, false)
	GUI:setTag(Image_levelbg, 72)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_1, "Text_level", 15.00, 15.00, 15, "#ffffff", [[30]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 73)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_z
	local Image_z = GUI:Image_Create(Panel_1, "Image_z", 92.00, 20.00, "res/private/player_hero/btn_heji_07.png")
	GUI:setAnchorPoint(Image_z, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z, false)
	GUI:setTag(Image_z, 74)

	-- Create Image_z2
	local Image_z2 = GUI:Image_Create(Panel_1, "Image_z2", 131.00, 20.00, "res/private/player_hero/btn_heji_06.png")
	GUI:setAnchorPoint(Image_z2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z2, false)
	GUI:setTag(Image_z2, 75)

	-- Create Text_z
	local Text_z = GUI:Text_Create(Panel_1, "Text_z", 132.00, 20.00, 14, "#ffffff", [[100%]])
	GUI:setAnchorPoint(Text_z, 0.50, 0.50)
	GUI:setTouchEnabled(Text_z, false)
	GUI:setTag(Text_z, 76)
	GUI:Text_enableOutline(Text_z, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 132.00, 79.00, 13, "#ffffff", [[哈等哈哈]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 77)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_state
	local Image_state = GUI:Image_Create(Panel_1, "Image_state", 180.00, 20.00, "res/private/player_hero/btn_heji_02.png")
	GUI:setAnchorPoint(Image_state, 0.50, 0.50)
	GUI:setTouchEnabled(Image_state, true)
	GUI:setTag(Image_state, 78)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_1, "Text_state", 180.00, 21.00, 15, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 79)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Button_bag
	local Button_bag = GUI:Button_Create(Panel_1, "Button_bag", 132.00, -13.00, "res/private/player_hero/btn_bag1.png")
	GUI:Button_loadTexturePressed(Button_bag, "res/private/player_hero/btn_bag2.png")
	GUI:Button_setScale9Slice(Button_bag, 15, 15, 11, 11)
	GUI:setContentSize(Button_bag, 79, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_bag, false)
	GUI:Button_setTitleText(Button_bag, "")
	GUI:Button_setTitleColor(Button_bag, "#ffffff")
	GUI:Button_setTitleFontSize(Button_bag, 15)
	GUI:Button_titleEnableOutline(Button_bag, "#000000", 1)
	GUI:setAnchorPoint(Button_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_bag, true)
	GUI:setTag(Button_bag, 84)

	-- Create Button_state
	local Button_state = GUI:Button_Create(Panel_1, "Button_state", 43.00, -13.00, "res/private/player_hero/btn_state1.png")
	GUI:Button_loadTexturePressed(Button_state, "res/private/player_hero/btn_state2.png")
	GUI:Button_setScale9Slice(Button_state, 15, 15, 11, 11)
	GUI:setContentSize(Button_state, 79, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_state, false)
	GUI:Button_setTitleText(Button_state, "")
	GUI:Button_setTitleColor(Button_state, "#ffffff")
	GUI:Button_setTitleFontSize(Button_state, 15)
	GUI:Button_titleEnableOutline(Button_state, "#000000", 1)
	GUI:setAnchorPoint(Button_state, 0.50, 0.50)
	GUI:setTouchEnabled(Button_state, true)
	GUI:setTag(Button_state, 85)

	-- Create Panel_ng
	local Panel_ng = GUI:Layout_Create(Scene, "Panel_ng", 276.00, 614.00, 201.00, 94.00, false)
	GUI:setAnchorPoint(Panel_ng, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_ng, true)
	GUI:setTag(Panel_ng, 66)
	GUI:setVisible(Panel_ng, false)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_ng, "Image_2", 4.00, 90.00, "res/private/player_hero/00010_1.png")
	GUI:setAnchorPoint(Image_2, 0.00, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 67)

	-- Create LoadingBar_1
	local LoadingBar_1 = GUI:LoadingBar_Create(Panel_ng, "LoadingBar_1", 136.00, 63.00, "res/private/player_hero/01061.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_1, 100)
	GUI:LoadingBar_setColor(LoadingBar_1, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_1, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_1, false)
	GUI:setTag(LoadingBar_1, 68)

	-- Create LoadingBar_2
	local LoadingBar_2 = GUI:LoadingBar_Create(Panel_ng, "LoadingBar_2", 139.00, 51.00, "res/private/player_hero/01062.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_2, 100)
	GUI:LoadingBar_setColor(LoadingBar_2, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_2, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_2, false)
	GUI:setTag(LoadingBar_2, 69)

	-- Create LoadingBar_ng
	local LoadingBar_ng = GUI:LoadingBar_Create(Panel_ng, "LoadingBar_ng", 140.00, 39.00, "res/private/player_hero/01065.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_ng, 100)
	GUI:LoadingBar_setColor(LoadingBar_ng, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_ng, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_ng, false)
	GUI:setTag(LoadingBar_ng, 70)

	-- Create LoadingBar_3
	local LoadingBar_3 = GUI:LoadingBar_Create(Panel_ng, "LoadingBar_3", 140.00, 27.00, "res/private/player_hero/01064.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_3, 100)
	GUI:LoadingBar_setColor(LoadingBar_3, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_3, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_3, false)
	GUI:setTag(LoadingBar_3, 70)

	-- Create Panel_info
	local Panel_info = GUI:Layout_Create(Panel_ng, "Panel_info", 200.00, 90.00, 124.00, 82.00, false)
	GUI:setAnchorPoint(Panel_info, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_info, false)
	GUI:setTag(Panel_info, 20)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Panel_ng, "Image_head", 41.00, 42.00, "res/private/player_hero/01210.png")
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setScaleX(Image_head, 1.05)
	GUI:setScaleY(Image_head, 1.05)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 71)

	-- Create Image_dz_bg
	local Image_dz_bg = GUI:Image_Create(Panel_ng, "Image_dz_bg", 5.00, 8.00, "res/private/player_hero/00510.png")
	GUI:setTouchEnabled(Image_dz_bg, false)
	GUI:setTag(Image_dz_bg, -1)

	-- Create Panel_bar_dz
	local Panel_bar_dz = GUI:Layout_Create(Image_dz_bg, "Panel_bar_dz", 0.00, 0.00, 28.00, 68.00, true)
	GUI:setTouchEnabled(Panel_bar_dz, false)
	GUI:setTag(Panel_bar_dz, -1)

	-- Create Image_bar_dz
	local Image_bar_dz = GUI:LoadingBar_Create(Panel_bar_dz, "Image_bar_dz", 0.00, 0.00, "res/private/player_hero/00511.png", 0)
	GUI:LoadingBar_setPercent(Image_bar_dz, 100)
	GUI:LoadingBar_setColor(Image_bar_dz, "#ffffff")
	GUI:setTouchEnabled(Image_bar_dz, false)
	GUI:setTag(Image_bar_dz, -1)

	-- Create Image_zj_bg
	local Image_zj_bg = GUI:Image_Create(Panel_ng, "Image_zj_bg", 32.00, 5.00, "res/private/player_hero/00512.png")
	GUI:setTouchEnabled(Image_zj_bg, false)
	GUI:setTag(Image_zj_bg, -1)

	-- Create Panel_bar_zj
	local Panel_bar_zj = GUI:Layout_Create(Image_zj_bg, "Panel_bar_zj", 0.00, 0.00, 48.00, 72.00, true)
	GUI:setTouchEnabled(Panel_bar_zj, false)
	GUI:setTag(Panel_bar_zj, -1)

	-- Create Image_bar_zj
	local Image_bar_zj = GUI:LoadingBar_Create(Panel_bar_zj, "Image_bar_zj", 0.00, 0.00, "res/private/player_hero/00514.png", 0)
	GUI:LoadingBar_setPercent(Image_bar_zj, 100)
	GUI:LoadingBar_setColor(Image_bar_zj, "#ffffff")
	GUI:setTouchEnabled(Image_bar_zj, false)
	GUI:setTag(Image_bar_zj, -1)

	-- Create Image_levelbg
	local Image_levelbg = GUI:Image_Create(Panel_ng, "Image_levelbg", 16.00, 15.00, "res/private/player_hero/btn_heji_01.png")
	GUI:setAnchorPoint(Image_levelbg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_levelbg, false)
	GUI:setTag(Image_levelbg, 72)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_ng, "Text_level", 15.00, 15.00, 15, "#ffffff", [[30]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 73)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_z
	local Image_z = GUI:Image_Create(Panel_ng, "Image_z", 84.00, 9.00, "res/private/player_hero/btn_heji_07.png")
	GUI:setAnchorPoint(Image_z, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z, false)
	GUI:setTag(Image_z, 74)

	-- Create Image_z2
	local Image_z2 = GUI:Image_Create(Panel_ng, "Image_z2", 123.00, 9.00, "res/private/player_hero/btn_heji_06.png")
	GUI:setAnchorPoint(Image_z2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z2, false)
	GUI:setTag(Image_z2, 75)

	-- Create Text_z
	local Text_z = GUI:Text_Create(Panel_ng, "Text_z", 124.00, 9.00, 14, "#ffffff", [[100%]])
	GUI:setAnchorPoint(Text_z, 0.50, 0.50)
	GUI:setTouchEnabled(Text_z, false)
	GUI:setTag(Text_z, 76)
	GUI:Text_enableOutline(Text_z, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_ng, "Text_name", 132.00, 79.00, 13, "#ffffff", [[哈等哈哈]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 77)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_state
	local Image_state = GUI:Image_Create(Panel_ng, "Image_state", 172.00, 9.00, "res/private/player_hero/btn_heji_02.png")
	GUI:setAnchorPoint(Image_state, 0.50, 0.50)
	GUI:setTouchEnabled(Image_state, true)
	GUI:setTag(Image_state, 78)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_ng, "Text_state", 172.00, 10.00, 15, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 79)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Button_bag
	local Button_bag = GUI:Button_Create(Panel_ng, "Button_bag", 132.00, -19.00, "res/private/player_hero/btn_bag1.png")
	GUI:Button_loadTexturePressed(Button_bag, "res/private/player_hero/btn_bag2.png")
	GUI:Button_setScale9Slice(Button_bag, 0, 0, 0, 0)
	GUI:setContentSize(Button_bag, 79, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_bag, false)
	GUI:Button_setTitleText(Button_bag, "")
	GUI:Button_setTitleColor(Button_bag, "#ffffff")
	GUI:Button_setTitleFontSize(Button_bag, 15)
	GUI:Button_titleEnableOutline(Button_bag, "#000000", 1)
	GUI:setAnchorPoint(Button_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_bag, true)
	GUI:setTag(Button_bag, 84)

	-- Create Button_state
	local Button_state = GUI:Button_Create(Panel_ng, "Button_state", 43.00, -19.00, "res/private/player_hero/btn_state1.png")
	GUI:Button_loadTexturePressed(Button_state, "res/private/player_hero/btn_state2.png")
	GUI:Button_setScale9Slice(Button_state, 0, 0, 0, 0)
	GUI:setContentSize(Button_state, 79, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_state, false)
	GUI:Button_setTitleText(Button_state, "")
	GUI:Button_setTitleColor(Button_state, "#ffffff")
	GUI:Button_setTitleFontSize(Button_state, 15)
	GUI:Button_titleEnableOutline(Button_state, "#000000", 1)
	GUI:setAnchorPoint(Button_state, 0.50, 0.50)
	GUI:setTouchEnabled(Button_state, true)
	GUI:setTag(Button_state, 85)

	-- Create Button_hero
	local Button_hero = GUI:Button_Create(Scene, "Button_hero", 863.00, 447.00, "res/private/player_hero/btn_login1.png")
	GUI:Button_loadTexturePressed(Button_hero, "res/private/player_hero/btn_login2.png")
	GUI:Button_setScale9Slice(Button_hero, 15, 15, 11, 11)
	GUI:setContentSize(Button_hero, 79, 27)
	GUI:setIgnoreContentAdaptWithSize(Button_hero, false)
	GUI:Button_setTitleText(Button_hero, "")
	GUI:Button_setTitleColor(Button_hero, "#ffffff")
	GUI:Button_setTitleFontSize(Button_hero, 15)
	GUI:Button_titleEnableOutline(Button_hero, "#000000", 1)
	GUI:setAnchorPoint(Button_hero, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hero, true)
	GUI:setTag(Button_hero, 107)
end
return ui