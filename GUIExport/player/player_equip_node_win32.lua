local ui = {}
function ui.init(parent)
	-- Create EquipUI
	local EquipUI = GUI:Layout_Create(parent, "EquipUI", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(EquipUI, "玩家装备_组合")
	GUI:setTouchEnabled(EquipUI, false)
	GUI:setTag(EquipUI, 137)

	-- Create BG
	local BG = GUI:Image_Create(EquipUI, "BG", 136.00, 174.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015001_1.jpg")
	GUI:setChineseName(BG, "玩家装备_背景图")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, 62)

	-- Create Node_playerModel
	local Node_playerModel = GUI:Node_Create(EquipUI, "Node_playerModel", 140.00, 138.00)
	GUI:setChineseName(Node_playerModel, "玩家装备_裸模")
	GUI:setAnchorPoint(Node_playerModel, 0.50, 0.50)
	GUI:setTag(Node_playerModel, 139)

	-- Create Panel_posEx0
	local Panel_posEx0 = GUI:Layout_Create(EquipUI, "Panel_posEx0", 136.00, 120.00, 80.00, 144.00, false)
	GUI:setChineseName(Panel_posEx0, "玩家装备_裸模位置")
	GUI:setAnchorPoint(Panel_posEx0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_posEx0, true)
	GUI:setTag(Panel_posEx0, 140)

	-- Create Panel_posEx1
	local Panel_posEx1 = GUI:Layout_Create(EquipUI, "Panel_posEx1", 80.00, 190.00, 60.00, 120.00, false)
	GUI:setChineseName(Panel_posEx1, "玩家装备_武器位置")
	GUI:setAnchorPoint(Panel_posEx1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_posEx1, true)
	GUI:setTag(Panel_posEx1, 141)

	-- Create Panel_pos16
	local Panel_pos16 = GUI:Layout_Create(EquipUI, "Panel_pos16", 183.00, 132.00, 43.00, 71.60, false)
	GUI:setChineseName(Panel_pos16, "玩家装备_盾牌")
	GUI:setAnchorPoint(Panel_pos16, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos16, true)
	GUI:setTag(Panel_pos16, 142)

	-- Create Panel_pos4
	local Panel_pos4 = GUI:Layout_Create(EquipUI, "Panel_pos4", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos4, "玩家装备_头盔_组合")
	GUI:setAnchorPoint(Panel_pos4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos4, true)
	GUI:setTag(Panel_pos4, 143)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos4, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_头盔_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 205)
	GUI:setVisible(PanelBg, false)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos4, "DefaultIcon", 21.00, 21.00, "Default/ImageFile.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_头盔_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 206)
	GUI:setVisible(DefaultIcon, false)

	-- Create Panel_pos13
	local Panel_pos13 = GUI:Layout_Create(EquipUI, "Panel_pos13", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos13, "玩家装备_斗笠_组合")
	GUI:setAnchorPoint(Panel_pos13, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos13, true)
	GUI:setTag(Panel_pos13, 207)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos13, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_斗笠_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 208)
	GUI:setVisible(PanelBg, false)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos13, "DefaultIcon", 21.00, 21.00, "Default/ImageFile.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_斗笠_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 209)
	GUI:setVisible(DefaultIcon, false)

	-- Create Panel_pos55
	local Panel_pos55 = GUI:Layout_Create(EquipUI, "Panel_pos55", 138.00, 207.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos55, "玩家装备_面巾_触摸位")
	GUI:setAnchorPoint(Panel_pos55, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos55, true)
	GUI:setTag(Panel_pos55, 145)

	-- Create Panel_pos6
	local Panel_pos6 = GUI:Layout_Create(EquipUI, "Panel_pos6", 24.00, 114.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos6, "玩家装备_左手镯_组合")
	GUI:setAnchorPoint(Panel_pos6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos6, true)
	GUI:setTag(Panel_pos6, 144)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos6, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_左手镯_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 145)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos6, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015034.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_左手镯_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 146)

	-- Create Panel_pos8
	local Panel_pos8 = GUI:Layout_Create(EquipUI, "Panel_pos8", 24.00, 69.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos8, "玩家装备_左戒指_组合")
	GUI:setAnchorPoint(Panel_pos8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos8, true)
	GUI:setTag(Panel_pos8, 148)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos8, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_左戒指_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 149)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos8, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015035.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_左戒指_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 150)

	-- Create Panel_pos7
	local Panel_pos7 = GUI:Layout_Create(EquipUI, "Panel_pos7", 248.00, 69.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos7, "玩家装备_右戒指_组合")
	GUI:setAnchorPoint(Panel_pos7, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos7, true)
	GUI:setTag(Panel_pos7, 152)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos7, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_右戒指_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 153)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos7, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015035.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_右戒指_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 154)

	-- Create Panel_pos5
	local Panel_pos5 = GUI:Layout_Create(EquipUI, "Panel_pos5", 248.00, 114.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos5, "玩家装备_右手镯_组合")
	GUI:setAnchorPoint(Panel_pos5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos5, true)
	GUI:setTag(Panel_pos5, 156)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos5, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_右手镯_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 157)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos5, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015034.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_右手镯_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 158)

	-- Create Panel_pos2
	local Panel_pos2 = GUI:Layout_Create(EquipUI, "Panel_pos2", 248.00, 160.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos2, "玩家装备_勋章_组合")
	GUI:setAnchorPoint(Panel_pos2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos2, true)
	GUI:setTag(Panel_pos2, 160)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos2, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_勋章_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 161)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos2, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015033.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_勋章_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 162)

	-- Create Panel_pos3
	local Panel_pos3 = GUI:Layout_Create(EquipUI, "Panel_pos3", 248.00, 205.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos3, "玩家装备_项链_组合")
	GUI:setAnchorPoint(Panel_pos3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos3, true)
	GUI:setTag(Panel_pos3, 164)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos3, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_项链_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 165)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos3, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015032.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_项链_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 166)

	-- Create Panel_pos14
	local Panel_pos14 = GUI:Layout_Create(EquipUI, "Panel_pos14", 24.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos14, "玩家装备_战鼓_组合")
	GUI:setAnchorPoint(Panel_pos14, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos14, true)
	GUI:setTag(Panel_pos14, 201)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos14, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_战鼓_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 202)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos14, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015040.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_战鼓_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 203)

	-- Create Panel_pos15
	local Panel_pos15 = GUI:Layout_Create(EquipUI, "Panel_pos15", 248.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos15, "玩家装备_坐骑_组合")
	GUI:setAnchorPoint(Panel_pos15, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos15, true)
	GUI:setTag(Panel_pos15, 205)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos15, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_坐骑_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 206)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos15, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015041.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_坐骑_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 207)

	-- Create Panel_pos12
	local Panel_pos12 = GUI:Layout_Create(EquipUI, "Panel_pos12", 204.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos12, "玩家装备_魔血石_组合")
	GUI:setAnchorPoint(Panel_pos12, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos12, true)
	GUI:setTag(Panel_pos12, 168)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos12, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_魔血石_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 169)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos12, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015039.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_魔血石_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 170)

	-- Create Panel_pos11
	local Panel_pos11 = GUI:Layout_Create(EquipUI, "Panel_pos11", 159.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos11, "玩家装备_靴子_组合")
	GUI:setAnchorPoint(Panel_pos11, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos11, true)
	GUI:setTag(Panel_pos11, 172)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos11, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_靴子_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 173)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos11, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015037.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_靴子_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 174)

	-- Create Panel_pos10
	local Panel_pos10 = GUI:Layout_Create(EquipUI, "Panel_pos10", 115.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos10, "玩家装备_腰带_组合")
	GUI:setAnchorPoint(Panel_pos10, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos10, true)
	GUI:setTag(Panel_pos10, 176)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos10, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_腰带_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 177)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos10, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015038.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_腰带_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 178)

	-- Create Panel_pos9
	local Panel_pos9 = GUI:Layout_Create(EquipUI, "Panel_pos9", 69.00, 24.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos9, "玩家装备_护身符_组合")
	GUI:setAnchorPoint(Panel_pos9, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos9, true)
	GUI:setTag(Panel_pos9, 180)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos9, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_护身符_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 181)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos9, "DefaultIcon", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015036.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_护身符_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 182)

	-- Create Node_6
	local Node_6 = GUI:Node_Create(EquipUI, "Node_6", 24.00, 114.00)
	GUI:setChineseName(Node_6, "玩家装备_左手镯_位置")
	GUI:setAnchorPoint(Node_6, 0.50, 0.50)
	GUI:setTag(Node_6, 147)

	-- Create Node_8
	local Node_8 = GUI:Node_Create(EquipUI, "Node_8", 24.00, 69.00)
	GUI:setChineseName(Node_8, "玩家装备_左戒指_位置")
	GUI:setAnchorPoint(Node_8, 0.50, 0.50)
	GUI:setTag(Node_8, 151)

	-- Create Node_7
	local Node_7 = GUI:Node_Create(EquipUI, "Node_7", 248.00, 69.00)
	GUI:setChineseName(Node_7, "玩家装备_右戒指_位置")
	GUI:setAnchorPoint(Node_7, 0.50, 0.50)
	GUI:setTag(Node_7, 155)

	-- Create Node_5
	local Node_5 = GUI:Node_Create(EquipUI, "Node_5", 248.00, 114.00)
	GUI:setChineseName(Node_5, "玩家装备_右手镯_位置")
	GUI:setAnchorPoint(Node_5, 0.50, 0.50)
	GUI:setTag(Node_5, 159)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(EquipUI, "Node_2", 248.00, 160.00)
	GUI:setChineseName(Node_2, "玩家装备_勋章_位置")
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 163)

	-- Create Node_3
	local Node_3 = GUI:Node_Create(EquipUI, "Node_3", 248.00, 205.00)
	GUI:setChineseName(Node_3, "玩家装备_项链_位置")
	GUI:setAnchorPoint(Node_3, 0.50, 0.50)
	GUI:setTag(Node_3, 167)

	-- Create Node_4
	local Node_4 = GUI:Node_Create(EquipUI, "Node_4", 138.00, 207.00)
	GUI:setChineseName(Node_4, "玩家装备_头盔_位置")
	GUI:setAnchorPoint(Node_4, 0.50, 0.50)
	GUI:setTag(Node_4, 210)

	-- Create Node_13
	local Node_13 = GUI:Node_Create(EquipUI, "Node_13", 138.00, 207.00)
	GUI:setChineseName(Node_13, "玩家装备_斗笠_位置")
	GUI:setAnchorPoint(Node_13, 0.50, 0.50)
	GUI:setTag(Node_13, 211)

	-- Create Node_55
	local Node_55 = GUI:Node_Create(EquipUI, "Node_55", 138.00, 207.00)
	GUI:setChineseName(Node_55, "玩家装备_面巾_位置(只能放头上)")
	GUI:setAnchorPoint(Node_55, 0.50, 0.50)
	GUI:setTag(Node_55, 146)

	-- Create Node_14
	local Node_14 = GUI:Node_Create(EquipUI, "Node_14", 24.00, 24.00)
	GUI:setChineseName(Node_14, "玩家装备_战鼓_位置")
	GUI:setAnchorPoint(Node_14, 0.50, 0.50)
	GUI:setTag(Node_14, 204)

	-- Create Node_15
	local Node_15 = GUI:Node_Create(EquipUI, "Node_15", 248.00, 24.00)
	GUI:setChineseName(Node_15, "玩家装备_坐骑_位置")
	GUI:setAnchorPoint(Node_15, 0.50, 0.50)
	GUI:setTag(Node_15, 208)

	-- Create Node_12
	local Node_12 = GUI:Node_Create(EquipUI, "Node_12", 204.00, 24.00)
	GUI:setChineseName(Node_12, "玩家装备_魔血石_位置")
	GUI:setAnchorPoint(Node_12, 0.50, 0.50)
	GUI:setTag(Node_12, 171)

	-- Create Node_11
	local Node_11 = GUI:Node_Create(EquipUI, "Node_11", 159.00, 24.00)
	GUI:setChineseName(Node_11, "玩家装备_靴子_位置")
	GUI:setAnchorPoint(Node_11, 0.50, 0.50)
	GUI:setTag(Node_11, 175)

	-- Create Node_10
	local Node_10 = GUI:Node_Create(EquipUI, "Node_10", 115.00, 24.00)
	GUI:setChineseName(Node_10, "玩家装备_腰带_位置")
	GUI:setAnchorPoint(Node_10, 0.50, 0.50)
	GUI:setTag(Node_10, 179)

	-- Create Node_9
	local Node_9 = GUI:Node_Create(EquipUI, "Node_9", 69.00, 24.00)
	GUI:setChineseName(Node_9, "玩家装备_护身符_位置")
	GUI:setAnchorPoint(Node_9, 0.50, 0.50)
	GUI:setTag(Node_9, 183)

	-- Create Text_guildinfo
	local Text_guildinfo = GUI:Text_Create(EquipUI, "Text_guildinfo", 9.00, 335.00, 18, "#ffffff", [[]])
	GUI:setChineseName(Text_guildinfo, "玩家装备_行会信息")
	GUI:setAnchorPoint(Text_guildinfo, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildinfo, false)
	GUI:setTag(Text_guildinfo, 138)
	GUI:Text_enableOutline(Text_guildinfo, "#0e0e0e", 1)

	-- Create Best_ringBox
	local Best_ringBox = GUI:Layout_Create(EquipUI, "Best_ringBox", 224.00, 233.00, 46.00, 36.00, false)
	GUI:setChineseName(Best_ringBox, "玩家装备_首饰盒组合")
	GUI:setTouchEnabled(Best_ringBox, true)
	GUI:setTag(Best_ringBox, 184)

	-- Create Image_box
	local Image_box = GUI:Image_Create(Best_ringBox, "Image_box", 22.00, 20.00, "res/private/player_best_rings_ui/player_best_rings_ui_win32/btn_jewelry_1_0.png")
	GUI:setChineseName(Image_box, "玩家装备_首饰盒")
	GUI:setAnchorPoint(Image_box, 0.50, 0.50)
	GUI:setTouchEnabled(Image_box, false)
	GUI:setTag(Image_box, 185)

	-- Create Panel_pos1
	local Panel_pos1 = GUI:Layout_Create(EquipUI, "Panel_pos1", 24.00, 205.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos1, "玩家装备_武器_组合")
	GUI:setAnchorPoint(Panel_pos1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1, true)
	GUI:setTag(Panel_pos1, 69)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos1, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_武器_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 70)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos1, "DefaultIcon", 21.00, 21.00, "res/public/0.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_武器_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 81)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(EquipUI, "Node_1", 24.00, 205.00)
	GUI:setChineseName(Node_1, "玩家装备_武器_位置")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 71)

	-- Create Panel_pos0
	local Panel_pos0 = GUI:Layout_Create(EquipUI, "Panel_pos0", 24.00, 160.00, 42.00, 42.00, false)
	GUI:setChineseName(Panel_pos0, "玩家装备_衣服_组合")
	GUI:setAnchorPoint(Panel_pos0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos0, true)
	GUI:setTag(Panel_pos0, 69)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos0, "PanelBg", 21.00, 21.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_衣服_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 70)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos0, "DefaultIcon", 21.00, 21.00, "res/public/0.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_衣服_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 81)

	-- Create Node_0
	local Node_0 = GUI:Node_Create(EquipUI, "Node_0", 24.00, 160.00)
	GUI:setChineseName(Node_0, "玩家装备_衣服_位置")
	GUI:setAnchorPoint(Node_0, 0.50, 0.50)
	GUI:setTag(Node_0, 71)
end
return ui