local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "英雄战斗状态_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_2, "英雄战斗状态_范围点击关闭")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 621)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Scene, "Panel_3", 180.00, 180.00, 1.00, 1.00, false)
	GUI:setChineseName(Panel_3, "英雄战斗状态_组合")
	GUI:setTouchEnabled(Panel_3, true)
	GUI:setTag(Panel_3, 632)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_3, "Image_bg", 0.00, 0.00, "res/private/player_hero/btn_heji_03_3.png")
	GUI:setContentSize(Image_bg, 120, 120)
	GUI:setChineseName(Image_bg, "英雄战斗状态_背景图")
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 622)

	-- Create Image_bg1
	local Image_bg1 = GUI:Image_Create(Image_bg, "Image_bg1", 32.89, 77.69, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg1, "英雄战斗状态_选中图1")
	GUI:setAnchorPoint(Image_bg1, 0.50, 0.50)
	GUI:setRotationSkewX(Image_bg1, -120.00)
	GUI:setRotationSkewY(Image_bg1, -120.00)
	GUI:setTouchEnabled(Image_bg1, false)
	GUI:setTag(Image_bg1, 623)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Image_bg, "Image_bg2", 88.67, 75.30, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg2, "英雄战斗状态_选中图2")
	GUI:setAnchorPoint(Image_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 624)

	-- Create Image_bg3
	local Image_bg3 = GUI:Image_Create(Image_bg, "Image_bg3", 59.13, 27.42, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg3, "英雄战斗状态_选中图3")
	GUI:setAnchorPoint(Image_bg3, 0.50, 0.50)
	GUI:setRotationSkewX(Image_bg3, 120.00)
	GUI:setRotationSkewY(Image_bg3, 120.00)
	GUI:setTouchEnabled(Image_bg3, false)
	GUI:setTag(Image_bg3, 625)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_bg, "Text_1", 26.81, 79.93, 18, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_1, "英雄战斗状态_文本1")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 627)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_bg, "Text_2", 94.30, 79.93, 18, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_2, "英雄战斗状态_文本2")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 628)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Image_bg, "Text_3", 59.71, 22.49, 18, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_3, "英雄战斗状态_文本3")
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 629)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Image_bg, "Text_4", 59.50, 59.95, 18, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_4, "英雄战斗状态_文本4")
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 630)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Panel_touch1
	local Panel_touch1 = GUI:Layout_Create(Image_bg, "Panel_touch1", 22.95, 77.95, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch1, "英雄战斗状态_触摸1")
	GUI:setAnchorPoint(Panel_touch1, 0.50, 0.50)
	GUI:setRotationSkewX(Panel_touch1, -144.00)
	GUI:setRotationSkewY(Panel_touch1, -144.00)
	GUI:setTouchEnabled(Panel_touch1, true)
	GUI:setTag(Panel_touch1, 639)

	-- Create Panel_touch2
	local Panel_touch2 = GUI:Layout_Create(Image_bg, "Panel_touch2", 96.20, 82.66, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch2, "英雄战斗状态_触摸2")
	GUI:setAnchorPoint(Panel_touch2, 0.50, 0.50)
	GUI:setRotation(Panel_touch2, -34.00)
	GUI:setRotationSkewX(Panel_touch2, -34.00)
	GUI:setRotationSkewY(Panel_touch2, -34.00)
	GUI:setTouchEnabled(Panel_touch2, true)
	GUI:setTag(Panel_touch2, 640)

	-- Create Panel_touch3
	local Panel_touch3 = GUI:Layout_Create(Image_bg, "Panel_touch3", 58.76, 20.75, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch3, "英雄战斗状态_触摸3")
	GUI:setAnchorPoint(Panel_touch3, 0.50, 0.50)
	GUI:setRotation(Panel_touch3, 90.00)
	GUI:setRotationSkewX(Panel_touch3, 90.00)
	GUI:setRotationSkewY(Panel_touch3, 90.00)
	GUI:setTouchEnabled(Panel_touch3, true)
	GUI:setTag(Panel_touch3, 641)
end
return ui