local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "宝箱场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "宝箱场景_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 2)

	-- Create Panel_main
	local Panel_main = GUI:Layout_Create(Panel_1, "Panel_main", 568.00, 400.00, 363.00, 376.00, false)
	GUI:setChineseName(Panel_main, "宝箱_组合")
	GUI:setAnchorPoint(Panel_main, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_main, false)
	GUI:setTag(Panel_main, 49)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_main, "Button_close", 284.00, 257.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 6, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "宝箱_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 8)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_main, "Image_bg", 181.00, 188.00, "res/private/treasure_box/000510.png")
	GUI:setChineseName(Image_bg, "宝箱_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setScaleX(Image_bg, 0.90)
	GUI:setScaleY(Image_bg, 0.90)
	GUI:setTouchEnabled(Image_bg, true)
	GUI:setTag(Image_bg, 3)

	-- Create Node_bg
	local Node_bg = GUI:Node_Create(Panel_main, "Node_bg", 181.00, 194.00)
	GUI:setChineseName(Node_bg, "宝箱_奖品节点")
	GUI:setAnchorPoint(Node_bg, 0.50, 0.50)
	GUI:setTag(Node_bg, 124)

	-- Create Image_0
	local Image_0 = GUI:Image_Create(Node_bg, "Image_0", 0.00, 0.00, "res/private/treasure_box/000513.png")
	GUI:setChineseName(Image_0, "宝箱_中奖_背景图")
	GUI:setAnchorPoint(Image_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_0, false)
	GUI:setTag(Image_0, 37)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Node_bg, "Image_1", -55.00, 50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_1, "宝箱_1号奖品_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 62)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Node_bg, "Image_2", 0.00, 50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_2, "宝箱_2号奖品_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 63)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Node_bg, "Image_3", 55.00, 50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_3, "宝箱_3号奖品_背景图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 64)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Node_bg, "Image_4", 55.00, 0.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_4, "宝箱_4号奖品_背景图")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 65)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Node_bg, "Image_5", 55.00, -50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_5, "宝箱_5号奖品_背景图")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 66)

	-- Create Image_6
	local Image_6 = GUI:Image_Create(Node_bg, "Image_6", 0.00, -50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_6, "宝箱_6号奖品_背景图")
	GUI:setAnchorPoint(Image_6, 0.50, 0.50)
	GUI:setTouchEnabled(Image_6, false)
	GUI:setTag(Image_6, 67)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Node_bg, "Image_7", -55.00, -50.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_7, "宝箱_7号奖品_背景图")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 68)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Node_bg, "Image_8", -55.00, 0.00, "res/private/treasure_box/000514.png")
	GUI:setChineseName(Image_8, "宝箱_8号奖品_背景图")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 69)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_main, "Node_icon", 181.00, 195.00)
	GUI:setChineseName(Node_icon, "宝箱_图标节点")
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 121)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Node_icon, "Node_1", -55.00, 50.00)
	GUI:setChineseName(Node_1, "宝箱_1号奖品_图标节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 40)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(Node_icon, "Node_2", 0.00, 50.00)
	GUI:setChineseName(Node_2, "宝箱_2号奖品_图标节点")
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 41)

	-- Create Node_3
	local Node_3 = GUI:Node_Create(Node_icon, "Node_3", 55.00, 50.00)
	GUI:setChineseName(Node_3, "宝箱_3号奖品_图标节点")
	GUI:setAnchorPoint(Node_3, 0.50, 0.50)
	GUI:setTag(Node_3, 42)

	-- Create Node_4
	local Node_4 = GUI:Node_Create(Node_icon, "Node_4", 55.00, 0.00)
	GUI:setChineseName(Node_4, "宝箱_4号奖品_图标节点")
	GUI:setAnchorPoint(Node_4, 0.50, 0.50)
	GUI:setTag(Node_4, 43)

	-- Create Node_5
	local Node_5 = GUI:Node_Create(Node_icon, "Node_5", 55.00, -50.00)
	GUI:setChineseName(Node_5, "宝箱_5号奖品_图标节点")
	GUI:setAnchorPoint(Node_5, 0.50, 0.50)
	GUI:setTag(Node_5, 44)

	-- Create Node_6
	local Node_6 = GUI:Node_Create(Node_icon, "Node_6", 0.00, -50.00)
	GUI:setChineseName(Node_6, "宝箱_6号奖品_图标节点")
	GUI:setAnchorPoint(Node_6, 0.50, 0.50)
	GUI:setTag(Node_6, 45)

	-- Create Node_7
	local Node_7 = GUI:Node_Create(Node_icon, "Node_7", -55.00, -50.00)
	GUI:setChineseName(Node_7, "宝箱_7号奖品_图标节点")
	GUI:setAnchorPoint(Node_7, 0.50, 0.50)
	GUI:setTag(Node_7, 46)

	-- Create Node_8
	local Node_8 = GUI:Node_Create(Node_icon, "Node_8", -55.00, 0.00)
	GUI:setChineseName(Node_8, "宝箱_8号奖品_图标节点")
	GUI:setAnchorPoint(Node_8, 0.50, 0.50)
	GUI:setTag(Node_8, 47)

	-- Create Node_0
	local Node_0 = GUI:Node_Create(Node_icon, "Node_0", 0.00, 0.00)
	GUI:setChineseName(Node_0, "宝箱_中奖节点")
	GUI:setAnchorPoint(Node_0, 0.50, 0.50)
	GUI:setTag(Node_0, 48)

	-- Create Node_anim
	local Node_anim = GUI:Node_Create(Panel_main, "Node_anim", 181.00, 195.00)
	GUI:setChineseName(Node_anim, "宝箱_特效组合")
	GUI:setAnchorPoint(Node_anim, 0.50, 0.50)
	GUI:setTag(Node_anim, 42)

	-- Create Node_pos1
	local Node_pos1 = GUI:Node_Create(Node_anim, "Node_pos1", -55.00, 50.00)
	GUI:setChineseName(Node_pos1, "宝箱_1号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos1, 0.50, 0.50)
	GUI:setTag(Node_pos1, 45)

	-- Create Panel_cover1
	local Panel_cover1 = GUI:Layout_Create(Node_pos1, "Panel_cover1", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover1, "宝箱_1号中奖")
	GUI:setAnchorPoint(Panel_cover1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover1, true)
	GUI:setTag(Panel_cover1, 53)
	GUI:setVisible(Panel_cover1, false)

	-- Create Node_pos2
	local Node_pos2 = GUI:Node_Create(Node_anim, "Node_pos2", 0.00, 50.00)
	GUI:setChineseName(Node_pos2, "宝箱_2号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos2, 0.50, 0.50)
	GUI:setTag(Node_pos2, 46)

	-- Create Panel_cover2
	local Panel_cover2 = GUI:Layout_Create(Node_pos2, "Panel_cover2", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover2, "宝箱_2号中奖")
	GUI:setAnchorPoint(Panel_cover2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover2, true)
	GUI:setTag(Panel_cover2, 54)
	GUI:setVisible(Panel_cover2, false)

	-- Create Node_pos3
	local Node_pos3 = GUI:Node_Create(Node_anim, "Node_pos3", 55.00, 50.00)
	GUI:setChineseName(Node_pos3, "宝箱_3号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos3, 0.50, 0.50)
	GUI:setTag(Node_pos3, 47)

	-- Create Panel_cover3
	local Panel_cover3 = GUI:Layout_Create(Node_pos3, "Panel_cover3", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover3, "宝箱_3号中奖")
	GUI:setAnchorPoint(Panel_cover3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover3, true)
	GUI:setTag(Panel_cover3, 55)
	GUI:setVisible(Panel_cover3, false)

	-- Create Node_pos4
	local Node_pos4 = GUI:Node_Create(Node_anim, "Node_pos4", 55.00, 0.00)
	GUI:setChineseName(Node_pos4, "宝箱_4号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos4, 0.50, 0.50)
	GUI:setTag(Node_pos4, 48)

	-- Create Panel_cover4
	local Panel_cover4 = GUI:Layout_Create(Node_pos4, "Panel_cover4", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover4, "宝箱_4号中奖")
	GUI:setAnchorPoint(Panel_cover4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover4, true)
	GUI:setTag(Panel_cover4, 56)
	GUI:setVisible(Panel_cover4, false)

	-- Create Node_pos5
	local Node_pos5 = GUI:Node_Create(Node_anim, "Node_pos5", 55.00, -50.00)
	GUI:setChineseName(Node_pos5, "宝箱_5号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos5, 0.50, 0.50)
	GUI:setTag(Node_pos5, 49)

	-- Create Panel_cover5
	local Panel_cover5 = GUI:Layout_Create(Node_pos5, "Panel_cover5", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover5, "宝箱_5号中奖")
	GUI:setAnchorPoint(Panel_cover5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover5, true)
	GUI:setTag(Panel_cover5, 57)
	GUI:setVisible(Panel_cover5, false)

	-- Create Node_pos6
	local Node_pos6 = GUI:Node_Create(Node_anim, "Node_pos6", 0.00, -50.00)
	GUI:setChineseName(Node_pos6, "宝箱_6号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos6, 0.50, 0.50)
	GUI:setTag(Node_pos6, 50)

	-- Create Panel_cover6
	local Panel_cover6 = GUI:Layout_Create(Node_pos6, "Panel_cover6", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover6, "宝箱_6号中奖")
	GUI:setAnchorPoint(Panel_cover6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover6, true)
	GUI:setTag(Panel_cover6, 58)
	GUI:setVisible(Panel_cover6, false)

	-- Create Node_pos7
	local Node_pos7 = GUI:Node_Create(Node_anim, "Node_pos7", -55.00, -50.00)
	GUI:setChineseName(Node_pos7, "宝箱_7号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos7, 0.50, 0.50)
	GUI:setTag(Node_pos7, 51)

	-- Create Panel_cover7
	local Panel_cover7 = GUI:Layout_Create(Node_pos7, "Panel_cover7", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover7, "宝箱_7号中奖")
	GUI:setAnchorPoint(Panel_cover7, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover7, true)
	GUI:setTag(Panel_cover7, 59)
	GUI:setVisible(Panel_cover7, false)

	-- Create Node_pos8
	local Node_pos8 = GUI:Node_Create(Node_anim, "Node_pos8", -55.00, 0.00)
	GUI:setChineseName(Node_pos8, "宝箱_8号奖品中奖位置节点")
	GUI:setAnchorPoint(Node_pos8, 0.50, 0.50)
	GUI:setTag(Node_pos8, 52)

	-- Create Panel_cover8
	local Panel_cover8 = GUI:Layout_Create(Node_pos8, "Panel_cover8", 0.00, 0.00, 40.00, 37.00, false)
	GUI:setChineseName(Panel_cover8, "宝箱_8号中奖")
	GUI:setAnchorPoint(Panel_cover8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover8, true)
	GUI:setTag(Panel_cover8, 60)
	GUI:setVisible(Panel_cover8, false)

	-- Create Node_pos0
	local Node_pos0 = GUI:Node_Create(Node_anim, "Node_pos0", 0.00, 0.00)
	GUI:setChineseName(Node_pos0, "宝箱_当前中奖位置节点")
	GUI:setAnchorPoint(Node_pos0, 0.50, 0.50)
	GUI:setTag(Node_pos0, 75)

	-- Create Panel_cover0
	local Panel_cover0 = GUI:Layout_Create(Node_pos0, "Panel_cover0", 0.00, 0.00, 52.00, 48.00, false)
	GUI:setChineseName(Panel_cover0, "宝箱_当前中奖")
	GUI:setAnchorPoint(Panel_cover0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cover0, true)
	GUI:setTag(Panel_cover0, 76)
	GUI:setVisible(Panel_cover0, false)

	-- Create Button_open
	local Button_open = GUI:Button_Create(Panel_main, "Button_open", 181.00, 109.00, "res/private/treasure_box/000511.png")
	GUI:Button_loadTexturePressed(Button_open, "res/private/treasure_box/000511.png")
	GUI:Button_loadTextureDisabled(Button_open, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_open, 15, 15, 11, 11)
	GUI:setContentSize(Button_open, 48, 28)
	GUI:setIgnoreContentAdaptWithSize(Button_open, false)
	GUI:Button_setTitleText(Button_open, "")
	GUI:Button_setTitleColor(Button_open, "#414146")
	GUI:Button_setTitleFontSize(Button_open, 14)
	GUI:Button_titleDisableOutLine(Button_open)
	GUI:setChineseName(Button_open, "宝箱_抽奖_按钮")
	GUI:setAnchorPoint(Button_open, 0.50, 0.50)
	GUI:setTouchEnabled(Button_open, true)
	GUI:setTag(Button_open, 77)

	-- Create Node_btn
	local Node_btn = GUI:Node_Create(Panel_main, "Node_btn", 181.00, 109.00)
	GUI:setChineseName(Node_btn, "宝箱_按钮特效_节点")
	GUI:setAnchorPoint(Node_btn, 0.50, 0.50)
	GUI:setTag(Node_btn, 92)
end
return ui