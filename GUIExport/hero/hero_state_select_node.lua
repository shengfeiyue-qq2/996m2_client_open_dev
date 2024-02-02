local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 621)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Scene, "Panel_3", 180.00, 180.00, 1.00, 1.00, false)
	GUI:setTouchEnabled(Panel_3, true)
	GUI:setTag(Panel_3, 632)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_3, "Image_bg", 0.00, 0.00, "res/private/player_hero/btn_heji_03.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 622)

	-- Create Image_bg1
	local Image_bg1 = GUI:Image_Create(Image_bg, "Image_bg1", 30.60, 89.43, "res/private/player_hero/btn_heji_04.png")
	GUI:setAnchorPoint(Image_bg1, 0.50, 0.50)
	GUI:setRotation(Image_bg1, -90.00)
	GUI:setRotationSkewX(Image_bg1, -90.00)
	GUI:setRotationSkewY(Image_bg1, -90.00)
	GUI:setTouchEnabled(Image_bg1, false)
	GUI:setTag(Image_bg1, 623)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Image_bg, "Image_bg2", 88.54, 88.88, "res/private/player_hero/btn_heji_04.png")
	GUI:setAnchorPoint(Image_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 624)

	-- Create Image_bg3
	local Image_bg3 = GUI:Image_Create(Image_bg, "Image_bg3", 89.83, 30.46, "res/private/player_hero/btn_heji_04.png")
	GUI:setAnchorPoint(Image_bg3, 0.50, 0.50)
	GUI:setRotationSkewX(Image_bg3, 90.00)
	GUI:setRotationSkewY(Image_bg3, 90.00)
	GUI:setTouchEnabled(Image_bg3, false)
	GUI:setTag(Image_bg3, 625)

	-- Create Image_bg4
	local Image_bg4 = GUI:Image_Create(Image_bg, "Image_bg4", 30.30, 29.35, "res/private/player_hero/btn_heji_04.png")
	GUI:setAnchorPoint(Image_bg4, 0.50, 0.50)
	GUI:setRotationSkewX(Image_bg4, -180.00)
	GUI:setRotationSkewY(Image_bg4, -180.00)
	GUI:setTouchEnabled(Image_bg4, false)
	GUI:setTag(Image_bg4, 626)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_bg, "Text_1", 32.18, 88.11, 18, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 627)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_bg, "Text_2", 85.22, 88.11, 18, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 628)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Image_bg, "Text_3", 87.77, 34.60, 18, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 629)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Image_bg, "Text_4", 30.32, 34.11, 18, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 630)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Image_bg, "Text_5", 58.94, 60.12, 18, "#ffffff", [[战斗]])
	GUI:setAnchorPoint(Text_5, 0.50, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 631)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Panel_touch1
	local Panel_touch1 = GUI:Layout_Create(Image_bg, "Panel_touch1", 30.60, 89.43, 55.00, 55.00, false)
	GUI:setAnchorPoint(Panel_touch1, 0.50, 0.50)
	GUI:setRotation(Panel_touch1, -90.00)
	GUI:setRotationSkewX(Panel_touch1, -90.00)
	GUI:setRotationSkewY(Panel_touch1, -90.00)
	GUI:setTouchEnabled(Panel_touch1, true)
	GUI:setTag(Panel_touch1, 639)

	-- Create Panel_touch2
	local Panel_touch2 = GUI:Layout_Create(Image_bg, "Panel_touch2", 88.54, 88.88, 55.00, 55.00, false)
	GUI:setAnchorPoint(Panel_touch2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_touch2, true)
	GUI:setTag(Panel_touch2, 640)

	-- Create Panel_touch3
	local Panel_touch3 = GUI:Layout_Create(Image_bg, "Panel_touch3", 89.83, 30.46, 55.00, 55.00, false)
	GUI:setAnchorPoint(Panel_touch3, 0.50, 0.50)
	GUI:setRotation(Panel_touch3, 90.00)
	GUI:setRotationSkewX(Panel_touch3, 90.00)
	GUI:setRotationSkewY(Panel_touch3, 90.00)
	GUI:setTouchEnabled(Panel_touch3, true)
	GUI:setTag(Panel_touch3, 641)

	-- Create Panel_touch4
	local Panel_touch4 = GUI:Layout_Create(Image_bg, "Panel_touch4", 30.31, 30.05, 55.00, 55.00, false)
	GUI:setAnchorPoint(Panel_touch4, 0.50, 0.50)
	GUI:setRotation(Panel_touch4, -90.00)
	GUI:setRotationSkewX(Panel_touch4, -90.00)
	GUI:setRotationSkewY(Panel_touch4, -90.00)
	GUI:setTouchEnabled(Panel_touch4, true)
	GUI:setTag(Panel_touch4, 642)
end
return ui