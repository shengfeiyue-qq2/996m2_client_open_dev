local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "英雄战斗状态_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1.0)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_2, "英雄战斗状态_范围点击关闭")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 621.0)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Scene, "Panel_3", 340.00, 400.00, 1.00, 1.00, false)
	GUI:setChineseName(Panel_3, "英雄战斗状态_组合")
	GUI:setTouchEnabled(Panel_3, true)
	GUI:setTag(Panel_3, 632.0)

	-- Create Image_Normal
	local Image_Normal = GUI:Image_Create(Panel_3, "Image_Normal", 0.00, 0.00, "res/private/player_hero/btn_heji_03.png")
	GUI:setChineseName(Image_Normal, "英雄战斗状态_背景图")
	GUI:setAnchorPoint(Image_Normal, 0.50, 0.50)
	GUI:setTouchEnabled(Image_Normal, false)
	GUI:setTag(Image_Normal, 622.0)

	-- Create Image_bg1
	local Image_bg1 = GUI:Image_Create(Image_Normal, "Image_bg1", 30.00, 89.00, "res/private/player_hero/btn_heji_04.png")
	GUI:setChineseName(Image_bg1, "英雄战斗状态_选中图1")
	GUI:setAnchorPoint(Image_bg1, 0.50, 0.50)
	GUI:setRotation(Image_bg1, -90.00)
	GUI:setRotationSkewX(Image_bg1, -90.00)
	GUI:setRotationSkewY(Image_bg1, -90.00)
	GUI:setTouchEnabled(Image_bg1, false)
	GUI:setTag(Image_bg1, 623.0)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Image_Normal, "Image_bg2", 88.00, 88.00, "res/private/player_hero/btn_heji_04.png")
	GUI:setChineseName(Image_bg2, "英雄战斗状态_选中图2")
	GUI:setAnchorPoint(Image_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 624.0)

	-- Create Image_bg3
	local Image_bg3 = GUI:Image_Create(Image_Normal, "Image_bg3", 89.00, 30.00, "res/private/player_hero/btn_heji_04.png")
	GUI:setChineseName(Image_bg3, "英雄战斗状态_选中图3")
	GUI:setAnchorPoint(Image_bg3, 0.50, 0.50)
	GUI:setRotation(Image_bg3, 90.00)
	GUI:setRotationSkewX(Image_bg3, 90.00)
	GUI:setRotationSkewY(Image_bg3, 90.00)
	GUI:setTouchEnabled(Image_bg3, false)
	GUI:setTag(Image_bg3, 625.0)

	-- Create Image_bg4
	local Image_bg4 = GUI:Image_Create(Image_Normal, "Image_bg4", 30.00, 29.00, "res/private/player_hero/btn_heji_04.png")
	GUI:setChineseName(Image_bg4, "英雄战斗状态_选中图4")
	GUI:setAnchorPoint(Image_bg4, 0.50, 0.50)
	GUI:setRotation(Image_bg4, -180.00)
	GUI:setRotationSkewX(Image_bg4, -180.00)
	GUI:setRotationSkewY(Image_bg4, -180.00)
	GUI:setTouchEnabled(Image_bg4, false)
	GUI:setTag(Image_bg4, 626.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_Normal, "Text_1", 32.00, 88.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_1, "英雄战斗状态_文本1")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 627.0)
	GUI:Text_enableOutline(Text_1, "#000000", 1.0)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_Normal, "Text_2", 85.00, 88.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_2, "英雄战斗状态_文本2")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 628.0)
	GUI:Text_enableOutline(Text_2, "#000000", 1.0)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Image_Normal, "Text_3", 87.00, 34.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_3, "英雄战斗状态_文本3")
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 629.0)
	GUI:Text_enableOutline(Text_3, "#000000", 1.0)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Image_Normal, "Text_4", 30.00, 34.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_4, "英雄战斗状态_文本4")
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 630.0)
	GUI:Text_enableOutline(Text_4, "#000000", 1.0)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Image_Normal, "Text_state", 58.00, 60.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_state, "英雄战斗状态_当前状态_文本")
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 631.0)
	GUI:Text_enableOutline(Text_state, "#000000", 1.0)

	-- Create Panel_touch1
	local Panel_touch1 = GUI:Layout_Create(Image_Normal, "Panel_touch1", 30.00, 89.00, 55.00, 55.00, false)
	GUI:setChineseName(Panel_touch1, "英雄战斗状态_触摸1")
	GUI:setAnchorPoint(Panel_touch1, 0.50, 0.50)
	GUI:setRotation(Panel_touch1, -90.00)
	GUI:setRotationSkewX(Panel_touch1, -90.00)
	GUI:setRotationSkewY(Panel_touch1, -90.00)
	GUI:setTouchEnabled(Panel_touch1, true)
	GUI:setTag(Panel_touch1, 639.0)

	-- Create Panel_touch2
	local Panel_touch2 = GUI:Layout_Create(Image_Normal, "Panel_touch2", 88.00, 88.00, 55.00, 55.00, false)
	GUI:setChineseName(Panel_touch2, "英雄战斗状态_触摸2")
	GUI:setAnchorPoint(Panel_touch2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_touch2, true)
	GUI:setTag(Panel_touch2, 640.0)

	-- Create Panel_touch3
	local Panel_touch3 = GUI:Layout_Create(Image_Normal, "Panel_touch3", 89.00, 30.00, 55.00, 55.00, false)
	GUI:setChineseName(Panel_touch3, "英雄战斗状态_触摸3")
	GUI:setAnchorPoint(Panel_touch3, 0.50, 0.50)
	GUI:setRotation(Panel_touch3, 90.00)
	GUI:setRotationSkewX(Panel_touch3, 90.00)
	GUI:setRotationSkewY(Panel_touch3, 90.00)
	GUI:setTouchEnabled(Panel_touch3, true)
	GUI:setTag(Panel_touch3, 641.0)

	-- Create Panel_touch4
	local Panel_touch4 = GUI:Layout_Create(Image_Normal, "Panel_touch4", 30.00, 30.00, 55.00, 55.00, false)
	GUI:setChineseName(Panel_touch4, "英雄战斗状态_触摸4")
	GUI:setAnchorPoint(Panel_touch4, 0.50, 0.50)
	GUI:setRotation(Panel_touch4, -90.00)
	GUI:setRotationSkewX(Panel_touch4, -90.00)
	GUI:setRotationSkewY(Panel_touch4, -90.00)
	GUI:setTouchEnabled(Panel_touch4, true)
	GUI:setTag(Panel_touch4, 642.0)

	-- Create Image_Three
	local Image_Three = GUI:Image_Create(Panel_3, "Image_Three", 0.00, 0.00, "res/private/player_hero/btn_heji_03_3.png")
	GUI:setContentSize(Image_Three, 120.0, 120.0)
	GUI:setIgnoreContentAdaptWithSize(Image_Three, false)
	GUI:setChineseName(Image_Three, "英雄战斗状态_背景图")
	GUI:setAnchorPoint(Image_Three, 0.50, 0.50)
	GUI:setTouchEnabled(Image_Three, false)
	GUI:setTag(Image_Three, 622.0)
	GUI:setVisible(Image_Three, false)

	-- Create Image_bg1
	local Image_bg1 = GUI:Image_Create(Image_Three, "Image_bg1", 32.00, 77.00, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg1, "英雄战斗状态_选中图1")
	GUI:setAnchorPoint(Image_bg1, 0.50, 0.50)
	GUI:setRotation(Image_bg1, -120.00)
	GUI:setRotationSkewX(Image_bg1, -120.00)
	GUI:setRotationSkewY(Image_bg1, -120.00)
	GUI:setTouchEnabled(Image_bg1, false)
	GUI:setTag(Image_bg1, 623.0)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Image_Three, "Image_bg2", 88.00, 75.00, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg2, "英雄战斗状态_选中图2")
	GUI:setAnchorPoint(Image_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 624.0)

	-- Create Image_bg3
	local Image_bg3 = GUI:Image_Create(Image_Three, "Image_bg3", 59.00, 27.00, "res/private/player_hero/btn_heji_04_3.png")
	GUI:setChineseName(Image_bg3, "英雄战斗状态_选中图3")
	GUI:setAnchorPoint(Image_bg3, 0.50, 0.50)
	GUI:setRotation(Image_bg3, 120.00)
	GUI:setRotationSkewX(Image_bg3, 120.00)
	GUI:setRotationSkewY(Image_bg3, 120.00)
	GUI:setTouchEnabled(Image_bg3, false)
	GUI:setTag(Image_bg3, 625.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_Three, "Text_1", 26.00, 79.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_1, "英雄战斗状态_文本1")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 627.0)
	GUI:Text_enableOutline(Text_1, "#000000", 1.0)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_Three, "Text_2", 94.00, 79.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_2, "英雄战斗状态_文本2")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 628.0)
	GUI:Text_enableOutline(Text_2, "#000000", 1.0)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Image_Three, "Text_3", 59.00, 22.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_3, "英雄战斗状态_文本3")
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 629.0)
	GUI:Text_enableOutline(Text_3, "#000000", 1.0)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Image_Three, "Text_4", 59.00, 59.00, 18.0, "#ffffff", [[战斗]])
	GUI:setChineseName(Text_4, "英雄战斗状态_文本4")
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 630.0)
	GUI:Text_enableOutline(Text_4, "#000000", 1.0)

	-- Create Panel_touch1
	local Panel_touch1 = GUI:Layout_Create(Image_Three, "Panel_touch1", 22.00, 77.00, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch1, "英雄战斗状态_触摸1")
	GUI:setAnchorPoint(Panel_touch1, 0.50, 0.50)
	GUI:setRotation(Panel_touch1, -144.00)
	GUI:setRotationSkewX(Panel_touch1, -144.00)
	GUI:setRotationSkewY(Panel_touch1, -144.00)
	GUI:setTouchEnabled(Panel_touch1, true)
	GUI:setTag(Panel_touch1, 639.0)

	-- Create Panel_touch2
	local Panel_touch2 = GUI:Layout_Create(Image_Three, "Panel_touch2", 96.00, 82.00, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch2, "英雄战斗状态_触摸2")
	GUI:setAnchorPoint(Panel_touch2, 0.50, 0.50)
	GUI:setRotation(Panel_touch2, -34.00)
	GUI:setRotationSkewX(Panel_touch2, -34.00)
	GUI:setRotationSkewY(Panel_touch2, -34.00)
	GUI:setTouchEnabled(Panel_touch2, true)
	GUI:setTag(Panel_touch2, 640.0)

	-- Create Panel_touch3
	local Panel_touch3 = GUI:Layout_Create(Image_Three, "Panel_touch3", 58.00, 20.00, 39.00, 84.00, false)
	GUI:setChineseName(Panel_touch3, "英雄战斗状态_触摸3")
	GUI:setAnchorPoint(Panel_touch3, 0.50, 0.50)
	GUI:setRotation(Panel_touch3, 90.00)
	GUI:setRotationSkewX(Panel_touch3, 90.00)
	GUI:setRotationSkewY(Panel_touch3, 90.00)
	GUI:setTouchEnabled(Panel_touch3, true)
	GUI:setTag(Panel_touch3, 641.0)
end
return ui