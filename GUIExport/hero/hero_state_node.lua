local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 276.60, 614.48, 201.00, 94.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 66)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 4.00, 92.00, "res/private/player_hero/00010.png")
	GUI:setAnchorPoint(Image_2, 0.00, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 67)

	-- Create LoadingBar_1
	local LoadingBar_1 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_1", 135.13, 63.21, "res/private/player_hero/01061.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_1, 100)
	GUI:LoadingBar_setColor(LoadingBar_1, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_1, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_1, false)
	GUI:setTag(LoadingBar_1, 68)

	-- Create LoadingBar_2
	local LoadingBar_2 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_2", 138.82, 50.89, "res/private/player_hero/01062.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_2, 100)
	GUI:LoadingBar_setColor(LoadingBar_2, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_2, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_2, false)
	GUI:setTag(LoadingBar_2, 69)

	-- Create LoadingBar_3
	local LoadingBar_3 = GUI:LoadingBar_Create(Panel_1, "LoadingBar_3", 140.02, 37.98, "res/private/player_hero/01064.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_3, 100)
	GUI:LoadingBar_setColor(LoadingBar_3, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_3, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_3, false)
	GUI:setTag(LoadingBar_3, 70)

	-- Create Panel_info
	local Panel_info = GUI:Layout_Create(Panel_1, "Panel_info", 200.24, 90.68, 124.00, 82.00, false)
	GUI:setAnchorPoint(Panel_info, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_info, true)
	GUI:setTag(Panel_info, 20)

	-- Create Image_head
	local Image_head = GUI:Image_Create(Panel_1, "Image_head", 41.67, 42.68, "res/private/player_hero/01210.png")
	GUI:setAnchorPoint(Image_head, 0.50, 0.50)
	GUI:setScaleX(Image_head, 1.05)
	GUI:setScaleY(Image_head, 1.05)
	GUI:setTouchEnabled(Image_head, false)
	GUI:setTag(Image_head, 71)

	-- Create Image_levelbg
	local Image_levelbg = GUI:Image_Create(Panel_1, "Image_levelbg", 16.43, 15.15, "res/private/player_hero/btn_heji_01.png")
	GUI:setAnchorPoint(Image_levelbg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_levelbg, false)
	GUI:setTag(Image_levelbg, 72)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_1, "Text_level", 15.65, 15.52, 15, "#ffffff", [[30]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 73)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_z
	local Image_z = GUI:Image_Create(Panel_1, "Image_z", 92.15, 20.68, "res/private/player_hero/btn_heji_07.png")
	GUI:setAnchorPoint(Image_z, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z, false)
	GUI:setTag(Image_z, 74)

	-- Create Image_z2
	local Image_z2 = GUI:Image_Create(Panel_1, "Image_z2", 131.80, 20.68, "res/private/player_hero/btn_heji_06.png")
	GUI:setAnchorPoint(Image_z2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_z2, false)
	GUI:setTag(Image_z2, 75)

	-- Create Text_z
	local Text_z = GUI:Text_Create(Panel_1, "Text_z", 132.06, 20.68, 14, "#ffffff", [[100%]])
	GUI:setAnchorPoint(Text_z, 0.50, 0.50)
	GUI:setTouchEnabled(Text_z, false)
	GUI:setTag(Text_z, 76)
	GUI:Text_enableOutline(Text_z, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 132.38, 79.52, 13, "#ffffff", [[哈等哈哈]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 77)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_state
	local Image_state = GUI:Image_Create(Panel_1, "Image_state", 180.46, 20.68, "res/private/player_hero/btn_heji_02.png")
	GUI:setAnchorPoint(Image_state, 0.50, 0.50)
	GUI:setTouchEnabled(Image_state, true)
	GUI:setTag(Image_state, 78)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_1, "Text_state", 180.60, 21.03, 15, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 79)
	GUI:Text_enableOutline(Text_state, "#000000", 1)

	-- Create Button_bag
	local Button_bag = GUI:Button_Create(Panel_1, "Button_bag", 132.29, -12.83, "res/private/player_hero/btn_bag1.png")
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
	local Button_state = GUI:Button_Create(Panel_1, "Button_state", 43.80, -12.83, "res/private/player_hero/btn_state1.png")
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

	-- Create Button_hero
	local Button_hero = GUI:Button_Create(Scene, "Button_hero", 863.09, 447.73, "res/private/player_hero/btn_login1.png")
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