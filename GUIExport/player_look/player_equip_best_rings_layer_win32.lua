local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "十二生肖_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 512.00, 384.00, 300.00, 220.00, false)
	GUI:setChineseName(Panel_1, "十二生肖_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 105)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 140.00, 111.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/bg_sx_01.png")
	GUI:setChineseName(Image_1, "十二生肖_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 106)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 142.00, 190.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_jewelry_1.png")
	GUI:setChineseName(Image_2, "十二生肖_标题图片")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 107)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 140.00, 191.00, "res/public/word_sxbt_05.png")
	GUI:setContentSize(Image_3, 238, 11)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "十二生肖_装饰图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 108)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 36.00, 170.00, 210.00, 153.00, false)
	GUI:setChineseName(Panel_items, "十二生肖_物品组合")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 109)

	-- Create Image_30
	local Image_30 = GUI:Image_Create(Panel_items, "Image_30", 26.00, 127.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_30, 19, 19, 20, 18)
	GUI:setContentSize(Image_30, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_30, false)
	GUI:setChineseName(Image_30, "十二生肖_鼠_物品框")
	GUI:setAnchorPoint(Image_30, 0.50, 0.50)
	GUI:setTouchEnabled(Image_30, false)
	GUI:setTag(Image_30, 110)

	-- Create Image_tag30
	local Image_tag30 = GUI:Image_Create(Panel_items, "Image_tag30", 26.00, 127.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_1.png")
	GUI:setChineseName(Image_tag30, "十二生肖_鼠字_图片")
	GUI:setAnchorPoint(Image_tag30, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag30, false)
	GUI:setTag(Image_tag30, 138)

	-- Create Image_31
	local Image_31 = GUI:Image_Create(Panel_items, "Image_31", 78.00, 127.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_31, 19, 19, 20, 18)
	GUI:setContentSize(Image_31, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_31, false)
	GUI:setChineseName(Image_31, "十二生肖_牛_物品框")
	GUI:setAnchorPoint(Image_31, 0.50, 0.50)
	GUI:setTouchEnabled(Image_31, false)
	GUI:setTag(Image_31, 111)

	-- Create Image_tag31
	local Image_tag31 = GUI:Image_Create(Panel_items, "Image_tag31", 78.00, 127.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_2.png")
	GUI:setChineseName(Image_tag31, "十二生肖_牛字_图片")
	GUI:setAnchorPoint(Image_tag31, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag31, false)
	GUI:setTag(Image_tag31, 139)

	-- Create Image_32
	local Image_32 = GUI:Image_Create(Panel_items, "Image_32", 130.00, 127.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_32, 19, 19, 20, 18)
	GUI:setContentSize(Image_32, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_32, false)
	GUI:setChineseName(Image_32, "十二生肖_虎_物品框")
	GUI:setAnchorPoint(Image_32, 0.50, 0.50)
	GUI:setTouchEnabled(Image_32, false)
	GUI:setTag(Image_32, 112)

	-- Create Image_tag32
	local Image_tag32 = GUI:Image_Create(Panel_items, "Image_tag32", 130.00, 127.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_3.png")
	GUI:setChineseName(Image_tag32, "十二生肖_虎字_图片")
	GUI:setAnchorPoint(Image_tag32, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag32, false)
	GUI:setTag(Image_tag32, 149)

	-- Create Image_33
	local Image_33 = GUI:Image_Create(Panel_items, "Image_33", 183.00, 127.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_33, 19, 19, 20, 18)
	GUI:setChineseName(Image_33, "十二生肖_兔_物品框")
	GUI:setContentSize(Image_33, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_33, false)
	GUI:setAnchorPoint(Image_33, 0.50, 0.50)
	GUI:setTouchEnabled(Image_33, false)
	GUI:setTag(Image_33, 113)

	-- Create Image_tag33
	local Image_tag33 = GUI:Image_Create(Panel_items, "Image_tag33", 183.00, 127.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_4.png")
	GUI:setChineseName(Image_tag33, "十二生肖_兔字_图片")
	GUI:setAnchorPoint(Image_tag33, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag33, false)
	GUI:setTag(Image_tag33, 148)

	-- Create Image_34
	local Image_34 = GUI:Image_Create(Panel_items, "Image_34", 26.00, 76.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_34, 19, 19, 20, 18)
	GUI:setContentSize(Image_34, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_34, false)
	GUI:setChineseName(Image_34, "十二生肖_龙_物品框")
	GUI:setAnchorPoint(Image_34, 0.50, 0.50)
	GUI:setTouchEnabled(Image_34, false)
	GUI:setTag(Image_34, 114)

	-- Create Image_tag34
	local Image_tag34 = GUI:Image_Create(Panel_items, "Image_tag34", 27.00, 76.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_5.png")
	GUI:setChineseName(Image_tag34, "十二生肖_龙字_图片")
	GUI:setAnchorPoint(Image_tag34, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag34, false)
	GUI:setTag(Image_tag34, 140)

	-- Create Image_35
	local Image_35 = GUI:Image_Create(Panel_items, "Image_35", 78.00, 76.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_35, 19, 19, 20, 18)
	GUI:setContentSize(Image_35, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_35, false)
	GUI:setChineseName(Image_35, "十二生肖_蛇_物品框")
	GUI:setAnchorPoint(Image_35, 0.50, 0.50)
	GUI:setTouchEnabled(Image_35, false)
	GUI:setTag(Image_35, 115)

	-- Create Image_tag35
	local Image_tag35 = GUI:Image_Create(Panel_items, "Image_tag35", 78.00, 76.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_6.png")
	GUI:setChineseName(Image_tag35, "十二生肖_蛇字_图片")
	GUI:setAnchorPoint(Image_tag35, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag35, false)
	GUI:setTag(Image_tag35, 147)

	-- Create Image_36
	local Image_36 = GUI:Image_Create(Panel_items, "Image_36", 130.00, 76.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_36, 19, 19, 20, 18)
	GUI:setContentSize(Image_36, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_36, false)
	GUI:setChineseName(Image_36, "十二生肖_马_物品框")
	GUI:setAnchorPoint(Image_36, 0.50, 0.50)
	GUI:setTouchEnabled(Image_36, false)
	GUI:setTag(Image_36, 116)

	-- Create Image_tag36
	local Image_tag36 = GUI:Image_Create(Panel_items, "Image_tag36", 130.00, 76.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_7.png")
	GUI:setChineseName(Image_tag36, "十二生肖_马字_图片")
	GUI:setAnchorPoint(Image_tag36, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag36, false)
	GUI:setTag(Image_tag36, 141)

	-- Create Image_37
	local Image_37 = GUI:Image_Create(Panel_items, "Image_37", 183.00, 76.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_37, 19, 19, 20, 18)
	GUI:setContentSize(Image_37, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_37, false)
	GUI:setChineseName(Image_37, "十二生肖_羊_物品框")
	GUI:setAnchorPoint(Image_37, 0.50, 0.50)
	GUI:setTouchEnabled(Image_37, false)
	GUI:setTag(Image_37, 117)

	-- Create Image_tag37
	local Image_tag37 = GUI:Image_Create(Panel_items, "Image_tag37", 183.00, 76.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_8.png")
	GUI:setChineseName(Image_tag37, "十二生肖_羊字_图片")
	GUI:setAnchorPoint(Image_tag37, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag37, false)
	GUI:setTag(Image_tag37, 142)

	-- Create Image_38
	local Image_38 = GUI:Image_Create(Panel_items, "Image_38", 26.00, 24.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_38, 19, 19, 20, 18)
	GUI:setContentSize(Image_38, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_38, false)
	GUI:setChineseName(Image_38, "十二生肖_猴_物品框")
	GUI:setAnchorPoint(Image_38, 0.50, 0.50)
	GUI:setTouchEnabled(Image_38, false)
	GUI:setTag(Image_38, 118)

	-- Create Image_tag38
	local Image_tag38 = GUI:Image_Create(Panel_items, "Image_tag38", 26.00, 24.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_9.png")
	GUI:setChineseName(Image_tag38, "十二生肖_猴字_图片")
	GUI:setAnchorPoint(Image_tag38, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag38, false)
	GUI:setTag(Image_tag38, 146)

	-- Create Image_39
	local Image_39 = GUI:Image_Create(Panel_items, "Image_39", 78.00, 24.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_39, 19, 19, 20, 18)
	GUI:setContentSize(Image_39, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_39, false)
	GUI:setChineseName(Image_39, "十二生肖_鸡_物品框")
	GUI:setAnchorPoint(Image_39, 0.50, 0.50)
	GUI:setTouchEnabled(Image_39, false)
	GUI:setTag(Image_39, 119)

	-- Create Image_tag39
	local Image_tag39 = GUI:Image_Create(Panel_items, "Image_tag39", 78.00, 24.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_10.png")
	GUI:setChineseName(Image_tag39, "十二生肖_鸡字_图片")
	GUI:setAnchorPoint(Image_tag39, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag39, false)
	GUI:setTag(Image_tag39, 143)

	-- Create Image_40
	local Image_40 = GUI:Image_Create(Panel_items, "Image_40", 130.00, 24.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_40, 19, 19, 20, 18)
	GUI:setContentSize(Image_40, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_40, false)
	GUI:setChineseName(Image_40, "十二生肖_狗_物品框")
	GUI:setAnchorPoint(Image_40, 0.50, 0.50)
	GUI:setTouchEnabled(Image_40, false)
	GUI:setTag(Image_40, 120)

	-- Create Image_tag40
	local Image_tag40 = GUI:Image_Create(Panel_items, "Image_tag40", 130.00, 24.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_11.png")
	GUI:setChineseName(Image_tag40, "十二生肖_狗字_图片")
	GUI:setAnchorPoint(Image_tag40, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag40, false)
	GUI:setTag(Image_tag40, 144)

	-- Create Image_41
	local Image_41 = GUI:Image_Create(Panel_items, "Image_41", 183.00, 24.00, "res/public_win32/bg_daoju_00.png")
	GUI:Image_setScale9Slice(Image_41, 19, 19, 20, 18)
	GUI:setContentSize(Image_41, 47, 48)
	GUI:setIgnoreContentAdaptWithSize(Image_41, false)
	GUI:setChineseName(Image_41, "十二生肖_猪_物品框")
	GUI:setAnchorPoint(Image_41, 0.50, 0.50)
	GUI:setTouchEnabled(Image_41, false)
	GUI:setTag(Image_41, 121)

	-- Create Image_tag41
	local Image_tag41 = GUI:Image_Create(Panel_items, "Image_tag41", 183.00, 24.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/word_shengxiao_12.png")
	GUI:setChineseName(Image_tag41, "十二生肖_猪字_图片")
	GUI:setAnchorPoint(Image_tag41, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag41, false)
	GUI:setTag(Image_tag41, 145)

	-- Create Node_30
	local Node_30 = GUI:Node_Create(Panel_items, "Node_30", 26.00, 127.00)
	GUI:setChineseName(Node_30, "十二生肖_鼠_节点")
	GUI:setAnchorPoint(Node_30, 0.50, 0.50)
	GUI:setTag(Node_30, 122)

	-- Create Node_31
	local Node_31 = GUI:Node_Create(Panel_items, "Node_31", 78.00, 126.00)
	GUI:setChineseName(Node_31, "十二生肖_牛_节点")
	GUI:setAnchorPoint(Node_31, 0.50, 0.50)
	GUI:setTag(Node_31, 123)

	-- Create Node_32
	local Node_32 = GUI:Node_Create(Panel_items, "Node_32", 130.00, 126.00)
	GUI:setChineseName(Node_32, "十二生肖_虎_节点")
	GUI:setAnchorPoint(Node_32, 0.50, 0.50)
	GUI:setTag(Node_32, 124)

	-- Create Node_33
	local Node_33 = GUI:Node_Create(Panel_items, "Node_33", 183.00, 127.00)
	GUI:setChineseName(Node_33, "十二生肖_兔_节点")
	GUI:setAnchorPoint(Node_33, 0.50, 0.50)
	GUI:setTag(Node_33, 125)

	-- Create Node_34
	local Node_34 = GUI:Node_Create(Panel_items, "Node_34", 26.00, 76.00)
	GUI:setChineseName(Node_34, "十二生肖_龙_节点")
	GUI:setAnchorPoint(Node_34, 0.50, 0.50)
	GUI:setTag(Node_34, 126)

	-- Create Node_35
	local Node_35 = GUI:Node_Create(Panel_items, "Node_35", 78.00, 76.00)
	GUI:setChineseName(Node_35, "十二生肖_蛇_节点")
	GUI:setAnchorPoint(Node_35, 0.50, 0.50)
	GUI:setTag(Node_35, 127)

	-- Create Node_36
	local Node_36 = GUI:Node_Create(Panel_items, "Node_36", 130.00, 76.00)
	GUI:setChineseName(Node_36, "十二生肖_马_节点")
	GUI:setAnchorPoint(Node_36, 0.50, 0.50)
	GUI:setTag(Node_36, 128)

	-- Create Node_37
	local Node_37 = GUI:Node_Create(Panel_items, "Node_37", 183.00, 76.00)
	GUI:setChineseName(Node_37, "十二生肖_羊_节点")
	GUI:setAnchorPoint(Node_37, 0.50, 0.50)
	GUI:setTag(Node_37, 129)

	-- Create Node_38
	local Node_38 = GUI:Node_Create(Panel_items, "Node_38", 26.00, 24.00)
	GUI:setChineseName(Node_38, "十二生肖_猴_节点")
	GUI:setAnchorPoint(Node_38, 0.50, 0.50)
	GUI:setTag(Node_38, 130)

	-- Create Node_39
	local Node_39 = GUI:Node_Create(Panel_items, "Node_39", 78.00, 24.00)
	GUI:setChineseName(Node_39, "十二生肖_鸡_节点")
	GUI:setAnchorPoint(Node_39, 0.50, 0.50)
	GUI:setTag(Node_39, 131)

	-- Create Node_40
	local Node_40 = GUI:Node_Create(Panel_items, "Node_40", 130.00, 24.00)
	GUI:setChineseName(Node_40, "十二生肖_狗_节点")
	GUI:setAnchorPoint(Node_40, 0.50, 0.50)
	GUI:setTag(Node_40, 132)

	-- Create Node_41
	local Node_41 = GUI:Node_Create(Panel_items, "Node_41", 183.00, 24.00)
	GUI:setChineseName(Node_41, "十二生肖_猪_节点")
	GUI:setAnchorPoint(Node_41, 0.50, 0.50)
	GUI:setTag(Node_41, 133)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Panel_1, "Panel_touch", 36.00, 170.00, 210.00, 153.00, false)
	GUI:setChineseName(Panel_touch, "十二生肖_触摸区域")
	GUI:setAnchorPoint(Panel_touch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 134)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 289.00, 206.00, "res/public_win32/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setScale9Slice(Button_close, 8, 11, 11, 16)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "十二生肖_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 135)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.00, 27.00, 24.00, 32.40, false)
	GUI:setChineseName(TouchSize, "十二生肖_触摸关闭")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 136)
	GUI:setVisible(TouchSize, false)
end
return ui