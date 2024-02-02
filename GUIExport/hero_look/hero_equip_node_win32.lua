local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "英雄装备_场景")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(Panel_1, "英雄装备_组合")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 137)

	-- Create Image_equippanel
	local Image_equippanel = GUI:Image_Create(Panel_1, "Image_equippanel", 136.00, 174.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015001_1.jpg")
	GUI:setChineseName(Image_equippanel, "英雄装备_背景图")
	GUI:setAnchorPoint(Image_equippanel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_equippanel, false)
	GUI:setTag(Image_equippanel, 62)

	-- Create Node_playerModel
	local Node_playerModel = GUI:Node_Create(Panel_1, "Node_playerModel", 140.00, 138.00)
	GUI:setChineseName(Node_playerModel, "英雄装备_裸模")
	GUI:setAnchorPoint(Node_playerModel, 0.50, 0.50)
	GUI:setTag(Node_playerModel, 139)

	-- Create Panel_pos0
	local Panel_pos0 = GUI:Layout_Create(Panel_1, "Panel_pos0", 136.00, 120.00, 103.50, 144.00, false)
	GUI:setChineseName(Panel_pos0, "英雄装备_裸模位置")
	GUI:setAnchorPoint(Panel_pos0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos0, true)
	GUI:setTag(Panel_pos0, 140)

	-- Create Panel_pos1
	local Panel_pos1 = GUI:Layout_Create(Panel_1, "Panel_pos1", 65.00, 190.00, 80.73, 120.00, false)
	GUI:setChineseName(Panel_pos1, "英雄装备_武器位置")
	GUI:setAnchorPoint(Panel_pos1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1, true)
	GUI:setTag(Panel_pos1, 141)

	-- Create Panel_pos16
	local Panel_pos16 = GUI:Layout_Create(Panel_1, "Panel_pos16", 183.00, 132.00, 43.00, 71.60, false)
	GUI:setChineseName(Panel_pos16, "英雄装备_盾牌")
	GUI:setAnchorPoint(Panel_pos16, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos16, true)
	GUI:setTag(Panel_pos16, 142)

	-- Create Panel_pos4
	local Panel_pos4 = GUI:Layout_Create(Panel_1, "Panel_pos4", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos4, "英雄装备_头盔_组合")
	GUI:setAnchorPoint(Panel_pos4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos4, true)
	GUI:setTag(Panel_pos4, 143)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos4, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_头盔_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 205)
	GUI:setVisible(Image_bg, false)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos4, "Image_icon", 21.00, 21.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_icon, "英雄装备_头盔_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 206)
	GUI:setVisible(Image_icon, false)

	-- Create Panel_pos13
	local Panel_pos13 = GUI:Layout_Create(Panel_1, "Panel_pos13", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos13, "英雄装备_斗笠_组合")
	GUI:setAnchorPoint(Panel_pos13, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos13, true)
	GUI:setTag(Panel_pos13, 207)
	GUI:setVisible(Panel_pos13, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos13, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_斗笠_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 208)
	GUI:setVisible(Image_bg, false)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos13, "Image_icon", 21.00, 21.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_icon, "英雄装备_斗笠_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 209)
	GUI:setVisible(Image_icon, false)

	-- Create Panel_pos55
	local Panel_pos55 = GUI:Layout_Create(Panel_1, "Panel_pos55", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos55, "英雄装备_面巾_触摸位")
	GUI:setAnchorPoint(Panel_pos55, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos55, true)
	GUI:setTag(Panel_pos55, 145)

	-- Create Panel_pos6
	local Panel_pos6 = GUI:Layout_Create(Panel_1, "Panel_pos6", 24.00, 114.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos6, "英雄装备_左手镯_组合")
	GUI:setAnchorPoint(Panel_pos6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos6, true)
	GUI:setTag(Panel_pos6, 144)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos6, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_左手镯_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 145)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos6, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015034.png")
	GUI:setChineseName(Image_icon, "英雄装备_左手镯_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 146)

	-- Create Panel_pos8
	local Panel_pos8 = GUI:Layout_Create(Panel_1, "Panel_pos8", 24.00, 69.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos8, "英雄装备_左戒指_组合")
	GUI:setAnchorPoint(Panel_pos8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos8, true)
	GUI:setTag(Panel_pos8, 148)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos8, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_左戒指_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 149)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos8, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015035.png")
	GUI:setChineseName(Image_icon, "英雄装备_左戒指_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 150)

	-- Create Panel_pos7
	local Panel_pos7 = GUI:Layout_Create(Panel_1, "Panel_pos7", 248.00, 69.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos7, "英雄装备_右戒指_组合")
	GUI:setAnchorPoint(Panel_pos7, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos7, true)
	GUI:setTag(Panel_pos7, 152)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos7, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_右戒指_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 153)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos7, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015035.png")
	GUI:setChineseName(Image_icon, "英雄装备_右戒指_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 154)

	-- Create Panel_pos5
	local Panel_pos5 = GUI:Layout_Create(Panel_1, "Panel_pos5", 248.00, 114.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos5, "英雄装备_右手镯_组合")
	GUI:setAnchorPoint(Panel_pos5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos5, true)
	GUI:setTag(Panel_pos5, 156)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos5, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_右手镯_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 157)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos5, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015034.png")
	GUI:setChineseName(Image_icon, "英雄装备_右手镯_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 158)

	-- Create Panel_pos2
	local Panel_pos2 = GUI:Layout_Create(Panel_1, "Panel_pos2", 248.00, 160.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos2, "英雄装备_勋章_组合")
	GUI:setAnchorPoint(Panel_pos2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos2, true)
	GUI:setTag(Panel_pos2, 160)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos2, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_勋章_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 161)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos2, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015033.png")
	GUI:setChineseName(Image_icon, "英雄装备_勋章_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 162)

	-- Create Panel_pos3
	local Panel_pos3 = GUI:Layout_Create(Panel_1, "Panel_pos3", 248.00, 205.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos3, "英雄装备_项链_组合")
	GUI:setAnchorPoint(Panel_pos3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos3, true)
	GUI:setTag(Panel_pos3, 164)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos3, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_项链_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 165)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos3, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015032.png")
	GUI:setChineseName(Image_icon, "英雄装备_项链_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 166)

	-- Create Panel_pos14
	local Panel_pos14 = GUI:Layout_Create(Panel_1, "Panel_pos14", 24.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos14, "英雄装备_战鼓_组合")
	GUI:setAnchorPoint(Panel_pos14, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos14, true)
	GUI:setTag(Panel_pos14, 201)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos14, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_战鼓_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 202)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos14, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015040.png")
	GUI:setChineseName(Image_icon, "英雄装备_战鼓_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 203)

	-- Create Panel_pos15
	local Panel_pos15 = GUI:Layout_Create(Panel_1, "Panel_pos15", 248.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos15, "英雄装备_坐骑_组合")
	GUI:setAnchorPoint(Panel_pos15, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos15, true)
	GUI:setTag(Panel_pos15, 205)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos15, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_坐骑_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 206)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos15, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015041.png")
	GUI:setChineseName(Image_icon, "英雄装备_坐骑_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 207)

	-- Create Panel_pos12
	local Panel_pos12 = GUI:Layout_Create(Panel_1, "Panel_pos12", 204.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos12, "英雄装备_魔血石_组合")
	GUI:setAnchorPoint(Panel_pos12, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos12, true)
	GUI:setTag(Panel_pos12, 168)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos12, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_魔血石_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 169)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos12, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015039.png")
	GUI:setChineseName(Image_icon, "英雄装备_魔血石_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 170)

	-- Create Panel_pos11
	local Panel_pos11 = GUI:Layout_Create(Panel_1, "Panel_pos11", 159.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos11, "英雄装备_靴子_组合")
	GUI:setAnchorPoint(Panel_pos11, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos11, true)
	GUI:setTag(Panel_pos11, 172)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos11, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_靴子_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 173)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos11, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015037.png")
	GUI:setChineseName(Image_icon, "英雄装备_靴子_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 174)

	-- Create Panel_pos10
	local Panel_pos10 = GUI:Layout_Create(Panel_1, "Panel_pos10", 115.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos10, "英雄装备_腰带_组合")
	GUI:setAnchorPoint(Panel_pos10, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos10, true)
	GUI:setTag(Panel_pos10, 176)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos10, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_腰带_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 177)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos10, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015038.png")
	GUI:setChineseName(Image_icon, "英雄装备_腰带_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 178)

	-- Create Panel_pos9
	local Panel_pos9 = GUI:Layout_Create(Panel_1, "Panel_pos9", 69.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos9, "英雄装备_护身符_组合")
	GUI:setAnchorPoint(Panel_pos9, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos9, true)
	GUI:setTag(Panel_pos9, 180)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos9, "Image_bg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(Image_bg, "英雄装备_护身符_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 181)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos9, "Image_icon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015036.png")
	GUI:setChineseName(Image_icon, "英雄装备_护身符_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 182)

	-- Create Node_6
	local Node_6 = GUI:Node_Create(Panel_1, "Node_6", 24.00, 114.00)
	GUI:setChineseName(Node_6, "英雄装备_左手镯_位置")
	GUI:setAnchorPoint(Node_6, 0.50, 0.50)
	GUI:setTag(Node_6, 147)

	-- Create Node_8
	local Node_8 = GUI:Node_Create(Panel_1, "Node_8", 24.00, 69.00)
	GUI:setChineseName(Node_8, "英雄装备_左戒指_位置")
	GUI:setAnchorPoint(Node_8, 0.50, 0.50)
	GUI:setTag(Node_8, 151)

	-- Create Node_7
	local Node_7 = GUI:Node_Create(Panel_1, "Node_7", 248.00, 69.00)
	GUI:setChineseName(Node_7, "英雄装备_右戒指_位置")
	GUI:setAnchorPoint(Node_7, 0.50, 0.50)
	GUI:setTag(Node_7, 155)

	-- Create Node_5
	local Node_5 = GUI:Node_Create(Panel_1, "Node_5", 248.00, 114.00)
	GUI:setChineseName(Node_5, "英雄装备_右手镯_位置")
	GUI:setAnchorPoint(Node_5, 0.50, 0.50)
	GUI:setTag(Node_5, 159)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(Panel_1, "Node_2", 248.00, 160.00)
	GUI:setChineseName(Node_2, "英雄装备_勋章_位置")
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 163)

	-- Create Node_3
	local Node_3 = GUI:Node_Create(Panel_1, "Node_3", 248.00, 205.00)
	GUI:setChineseName(Node_3, "英雄装备_项链_位置")
	GUI:setAnchorPoint(Node_3, 0.50, 0.50)
	GUI:setTag(Node_3, 167)

	-- Create Node_4
	local Node_4 = GUI:Node_Create(Panel_1, "Node_4", 138.00, 207.00)
	GUI:setChineseName(Node_4, "英雄装备_头盔_位置")
	GUI:setAnchorPoint(Node_4, 0.50, 0.50)
	GUI:setTag(Node_4, 210)

	-- Create Node_13
	local Node_13 = GUI:Node_Create(Panel_1, "Node_13", 138.00, 207.00)
	GUI:setChineseName(Node_13, "英雄装备_斗笠_位置")
	GUI:setAnchorPoint(Node_13, 0.50, 0.50)
	GUI:setTag(Node_13, 211)

	-- Create Node_55
	local Node_55 = GUI:Node_Create(Panel_1, "Node_55", 138.00, 207.00)
	GUI:setChineseName(Node_55, "英雄装备_面巾_位置(只能放头上)")
	GUI:setAnchorPoint(Node_55, 0.50, 0.50)
	GUI:setTag(Node_55, 146)

	-- Create Node_14
	local Node_14 = GUI:Node_Create(Panel_1, "Node_14", 24.00, 24.00)
	GUI:setChineseName(Node_14, "英雄装备_战鼓_位置")
	GUI:setAnchorPoint(Node_14, 0.50, 0.50)
	GUI:setTag(Node_14, 204)

	-- Create Node_15
	local Node_15 = GUI:Node_Create(Panel_1, "Node_15", 248.00, 24.00)
	GUI:setChineseName(Node_15, "英雄装备_坐骑_位置")
	GUI:setAnchorPoint(Node_15, 0.50, 0.50)
	GUI:setTag(Node_15, 208)

	-- Create Node_12
	local Node_12 = GUI:Node_Create(Panel_1, "Node_12", 204.00, 24.00)
	GUI:setChineseName(Node_12, "英雄装备_魔血石_位置")
	GUI:setAnchorPoint(Node_12, 0.50, 0.50)
	GUI:setTag(Node_12, 171)

	-- Create Node_11
	local Node_11 = GUI:Node_Create(Panel_1, "Node_11", 159.00, 24.00)
	GUI:setChineseName(Node_11, "英雄装备_靴子_位置")
	GUI:setAnchorPoint(Node_11, 0.50, 0.50)
	GUI:setTag(Node_11, 175)

	-- Create Node_10
	local Node_10 = GUI:Node_Create(Panel_1, "Node_10", 115.00, 24.00)
	GUI:setChineseName(Node_10, "英雄装备_腰带_位置")
	GUI:setAnchorPoint(Node_10, 0.50, 0.50)
	GUI:setTag(Node_10, 179)

	-- Create Node_9
	local Node_9 = GUI:Node_Create(Panel_1, "Node_9", 69.00, 24.00)
	GUI:setChineseName(Node_9, "英雄装备_护身符_位置")
	GUI:setAnchorPoint(Node_9, 0.50, 0.50)
	GUI:setTag(Node_9, 183)

	-- Create Text_guildinfo
	local Text_guildinfo = GUI:Text_Create(Panel_1, "Text_guildinfo", 9.00, 335.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_guildinfo, "英雄装备_行会信息")
	GUI:setAnchorPoint(Text_guildinfo, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildinfo, false)
	GUI:setTag(Text_guildinfo, 138)
	GUI:Text_enableOutline(Text_guildinfo, "#0e0e0e", 1)

	-- Create Best_ringBox
	local Best_ringBox = GUI:Layout_Create(Panel_1, "Best_ringBox", 224.00, 233.00, 46.00, 36.00, false)
	GUI:setChineseName(Best_ringBox, "英雄装备_首饰盒组合")
	GUI:setTouchEnabled(Best_ringBox, true)
	GUI:setTag(Best_ringBox, 184)

	-- Create Image_box
	local Image_box = GUI:Image_Create(Best_ringBox, "Image_box", 22.00, 20.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/btn_jewelry_1_0.png")
	GUI:setChineseName(Image_box, "英雄装备_首饰盒")
	GUI:setAnchorPoint(Image_box, 0.50, 0.50)
	GUI:setTouchEnabled(Image_box, false)
	GUI:setTag(Image_box, 185)
end
return ui