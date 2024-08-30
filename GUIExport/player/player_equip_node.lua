local ui = {}
function ui.init(parent)
	-- Create EquipUI
	local EquipUI = GUI:Layout_Create(parent, "EquipUI", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(EquipUI, "玩家装备_组合")
	GUI:setTouchEnabled(EquipUI, false)
	GUI:setTag(EquipUI, 31.0)

	-- Create BG
	local BG = GUI:Image_Create(EquipUI, "BG", 174.00, 239.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/bg_juese_03.png")
	GUI:setChineseName(BG, "玩家装备_背景图")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, 213.0)

	-- Create Node_playerModel
	local Node_playerModel = GUI:Node_Create(EquipUI, "Node_playerModel", 174.00, 219.00)
	GUI:setChineseName(Node_playerModel, "玩家装备_裸模")
	GUI:setAnchorPoint(Node_playerModel, 0.50, 0.50)
	GUI:setTag(Node_playerModel, 48.0)

	-- Create Panel_posEx0
	local Panel_posEx0 = GUI:Layout_Create(EquipUI, "Panel_posEx0", 174.00, 197.00, 180.00, 240.00, false)
	GUI:setChineseName(Panel_posEx0, "玩家装备_裸模位置")
	GUI:setAnchorPoint(Panel_posEx0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_posEx0, true)
	GUI:setTag(Panel_posEx0, 32.0)

	-- Create Panel_posEx1
	local Panel_posEx1 = GUI:Layout_Create(EquipUI, "Panel_posEx1", 67.00, 306.00, 120.00, 206.00, false)
	GUI:setChineseName(Panel_posEx1, "玩家装备_武器位置")
	GUI:setAnchorPoint(Panel_posEx1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_posEx1, true)
	GUI:setTag(Panel_posEx1, 31.0)

	-- Create Panel_pos16
	local Panel_pos16 = GUI:Layout_Create(EquipUI, "Panel_pos16", 244.00, 208.00, 85.00, 140.00, false)
	GUI:setChineseName(Panel_pos16, "玩家装备_盾牌")
	GUI:setAnchorPoint(Panel_pos16, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos16, true)
	GUI:setTag(Panel_pos16, 82.0)

	-- Create Panel_pos4
	local Panel_pos4 = GUI:Layout_Create(EquipUI, "Panel_pos4", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setChineseName(Panel_pos4, "玩家装备_头盔_组合")
	GUI:setAnchorPoint(Panel_pos4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos4, true)
	GUI:setTag(Panel_pos4, 33.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos4, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_头盔_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 141.0)
	GUI:setVisible(PanelBg, false)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos4, "DefaultIcon", 25.00, 25.00, "Default/ImageFile.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_头盔_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 142.0)
	GUI:setVisible(DefaultIcon, false)

	-- Create Panel_pos13
	local Panel_pos13 = GUI:Layout_Create(EquipUI, "Panel_pos13", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setChineseName(Panel_pos13, "玩家装备_斗笠_组合")
	GUI:setAnchorPoint(Panel_pos13, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos13, true)
	GUI:setTag(Panel_pos13, 143.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos13, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setChineseName(PanelBg, "玩家装备_斗笠_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 144.0)
	GUI:setVisible(PanelBg, false)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos13, "DefaultIcon", 25.00, 25.00, "Default/ImageFile.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_斗笠_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 145.0)
	GUI:setVisible(DefaultIcon, false)

	-- Create Panel_pos55
	local Panel_pos55 = GUI:Layout_Create(EquipUI, "Panel_pos55", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setChineseName(Panel_pos55, "玩家装备_面巾_触摸位")
	GUI:setAnchorPoint(Panel_pos55, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos55, true)
	GUI:setTag(Panel_pos55, 78.0)

	-- Create Panel_pos6
	local Panel_pos6 = GUI:Layout_Create(EquipUI, "Panel_pos6", 36.00, 156.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos6, "玩家装备_左手镯_组合")
	GUI:setAnchorPoint(Panel_pos6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos6, true)
	GUI:setTag(Panel_pos6, 34.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos6, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_左手镯_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 50.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos6, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_左手镯_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 72.0)

	-- Create Panel_pos8
	local Panel_pos8 = GUI:Layout_Create(EquipUI, "Panel_pos8", 36.00, 95.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos8, "玩家装备_左戒指_组合")
	GUI:setAnchorPoint(Panel_pos8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos8, true)
	GUI:setTag(Panel_pos8, 39.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos8, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_左戒指_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 49.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos8, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_左戒指_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 73.0)

	-- Create Panel_pos7
	local Panel_pos7 = GUI:Layout_Create(EquipUI, "Panel_pos7", 314.00, 95.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos7, "玩家装备_右戒指_组合")
	GUI:setAnchorPoint(Panel_pos7, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos7, true)
	GUI:setTag(Panel_pos7, 40.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos7, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_右戒指_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 48.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos7, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_右戒指_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 74.0)

	-- Create Panel_pos5
	local Panel_pos5 = GUI:Layout_Create(EquipUI, "Panel_pos5", 314.00, 156.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos5, "玩家装备_右手镯_组合")
	GUI:setAnchorPoint(Panel_pos5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos5, true)
	GUI:setTag(Panel_pos5, 41.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos5, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_右手镯_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 46.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos5, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_右手镯_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 75.0)

	-- Create Panel_pos2
	local Panel_pos2 = GUI:Layout_Create(EquipUI, "Panel_pos2", 314.00, 216.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos2, "玩家装备_勋章_组合")
	GUI:setAnchorPoint(Panel_pos2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos2, true)
	GUI:setTag(Panel_pos2, 42.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos2, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_勋章_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 45.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos2, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015033.png")
	GUI:setContentSize(DefaultIcon, 47.0, 43.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_勋章_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 76.0)

	-- Create Panel_pos3
	local Panel_pos3 = GUI:Layout_Create(EquipUI, "Panel_pos3", 314.00, 277.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos3, "玩家装备_项链_组合")
	GUI:setAnchorPoint(Panel_pos3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos3, true)
	GUI:setTag(Panel_pos3, 43.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos3, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_项链_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 44.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos3, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015032.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_项链_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 77.0)

	-- Create Panel_pos14
	local Panel_pos14 = GUI:Layout_Create(EquipUI, "Panel_pos14", 36.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos14, "玩家装备_战鼓_组合")
	GUI:setAnchorPoint(Panel_pos14, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos14, true)
	GUI:setTag(Panel_pos14, 179.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos14, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_战鼓_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 180.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos14, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015040.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_战鼓_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 181.0)

	-- Create Panel_pos15
	local Panel_pos15 = GUI:Layout_Create(EquipUI, "Panel_pos15", 314.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos15, "玩家装备_坐骑_组合")
	GUI:setAnchorPoint(Panel_pos15, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos15, true)
	GUI:setTag(Panel_pos15, 175.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos15, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_坐骑_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 176.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos15, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015041.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_坐骑_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 177.0)

	-- Create Panel_pos12
	local Panel_pos12 = GUI:Layout_Create(EquipUI, "Panel_pos12", 257.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos12, "玩家装备_魔血石_组合")
	GUI:setAnchorPoint(Panel_pos12, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos12, true)
	GUI:setTag(Panel_pos12, 60.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos12, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_魔血石_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 61.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos12, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015039.png")
	GUI:setContentSize(DefaultIcon, 47.0, 43.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_魔血石_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 78.0)

	-- Create Panel_pos11
	local Panel_pos11 = GUI:Layout_Create(EquipUI, "Panel_pos11", 203.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos11, "玩家装备_靴子_组合")
	GUI:setAnchorPoint(Panel_pos11, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos11, true)
	GUI:setTag(Panel_pos11, 63.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos11, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_靴子_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 64.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos11, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015037.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_靴子_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 79.0)

	-- Create Panel_pos10
	local Panel_pos10 = GUI:Layout_Create(EquipUI, "Panel_pos10", 147.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos10, "玩家装备_腰带_组合")
	GUI:setAnchorPoint(Panel_pos10, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos10, true)
	GUI:setTag(Panel_pos10, 66.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos10, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_腰带_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 67.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos10, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015038.png")
	GUI:setContentSize(DefaultIcon, 47.0, 37.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_腰带_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 80.0)

	-- Create Panel_pos9
	local Panel_pos9 = GUI:Layout_Create(EquipUI, "Panel_pos9", 92.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos9, "玩家装备_护身符_组合")
	GUI:setAnchorPoint(Panel_pos9, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos9, true)
	GUI:setTag(Panel_pos9, 69.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos9, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_护身符_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 70.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos9, "DefaultIcon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015036.png")
	GUI:setContentSize(DefaultIcon, 47.0, 43.0)
	GUI:setIgnoreContentAdaptWithSize(DefaultIcon, false)
	GUI:setChineseName(DefaultIcon, "玩家装备_护身符_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 81.0)

	-- Create Node_6
	local Node_6 = GUI:Node_Create(EquipUI, "Node_6", 36.00, 156.00)
	GUI:setChineseName(Node_6, "玩家装备_左手镯_位置")
	GUI:setAnchorPoint(Node_6, 0.50, 0.50)
	GUI:setTag(Node_6, 51.0)

	-- Create Node_8
	local Node_8 = GUI:Node_Create(EquipUI, "Node_8", 36.00, 95.00)
	GUI:setChineseName(Node_8, "玩家装备_左戒指_位置")
	GUI:setAnchorPoint(Node_8, 0.50, 0.50)
	GUI:setTag(Node_8, 52.0)

	-- Create Node_7
	local Node_7 = GUI:Node_Create(EquipUI, "Node_7", 314.00, 95.00)
	GUI:setChineseName(Node_7, "玩家装备_右戒指_位置")
	GUI:setAnchorPoint(Node_7, 0.50, 0.50)
	GUI:setTag(Node_7, 53.0)

	-- Create Node_5
	local Node_5 = GUI:Node_Create(EquipUI, "Node_5", 314.00, 156.00)
	GUI:setChineseName(Node_5, "玩家装备_右手镯_位置")
	GUI:setAnchorPoint(Node_5, 0.50, 0.50)
	GUI:setTag(Node_5, 54.0)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(EquipUI, "Node_2", 314.00, 216.00)
	GUI:setChineseName(Node_2, "玩家装备_勋章_位置")
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 55.0)

	-- Create Node_3
	local Node_3 = GUI:Node_Create(EquipUI, "Node_3", 314.00, 277.00)
	GUI:setChineseName(Node_3, "玩家装备_项链_位置")
	GUI:setAnchorPoint(Node_3, 0.50, 0.50)
	GUI:setTag(Node_3, 56.0)

	-- Create Node_4
	local Node_4 = GUI:Node_Create(EquipUI, "Node_4", 174.00, 322.00)
	GUI:setChineseName(Node_4, "玩家装备_头盔_位置")
	GUI:setAnchorPoint(Node_4, 0.50, 0.50)
	GUI:setTag(Node_4, 212.0)

	-- Create Node_13
	local Node_13 = GUI:Node_Create(EquipUI, "Node_13", 174.00, 322.00)
	GUI:setChineseName(Node_13, "玩家装备_斗笠_位置")
	GUI:setAnchorPoint(Node_13, 0.50, 0.50)
	GUI:setTag(Node_13, 213.0)

	-- Create Node_55
	local Node_55 = GUI:Node_Create(EquipUI, "Node_55", 174.00, 322.00)
	GUI:setChineseName(Node_55, "玩家装备_面巾_位置(只能放头上)")
	GUI:setAnchorPoint(Node_55, 0.50, 0.50)
	GUI:setTag(Node_55, 147.0)

	-- Create Node_14
	local Node_14 = GUI:Node_Create(EquipUI, "Node_14", 36.00, 35.00)
	GUI:setChineseName(Node_14, "玩家装备_战鼓_位置")
	GUI:setAnchorPoint(Node_14, 0.50, 0.50)
	GUI:setTag(Node_14, 182.0)

	-- Create Node_15
	local Node_15 = GUI:Node_Create(EquipUI, "Node_15", 314.00, 35.00)
	GUI:setChineseName(Node_15, "玩家装备_坐骑_位置")
	GUI:setAnchorPoint(Node_15, 0.50, 0.50)
	GUI:setTag(Node_15, 178.0)

	-- Create Node_12
	local Node_12 = GUI:Node_Create(EquipUI, "Node_12", 257.00, 35.00)
	GUI:setChineseName(Node_12, "玩家装备_魔血石_位置")
	GUI:setAnchorPoint(Node_12, 0.50, 0.50)
	GUI:setTag(Node_12, 62.0)

	-- Create Node_11
	local Node_11 = GUI:Node_Create(EquipUI, "Node_11", 203.00, 35.00)
	GUI:setChineseName(Node_11, "玩家装备_靴子_位置")
	GUI:setAnchorPoint(Node_11, 0.50, 0.50)
	GUI:setTag(Node_11, 65.0)

	-- Create Node_10
	local Node_10 = GUI:Node_Create(EquipUI, "Node_10", 147.00, 35.00)
	GUI:setChineseName(Node_10, "玩家装备_腰带_位置")
	GUI:setAnchorPoint(Node_10, 0.50, 0.50)
	GUI:setTag(Node_10, 68.0)

	-- Create Node_9
	local Node_9 = GUI:Node_Create(EquipUI, "Node_9", 92.00, 35.00)
	GUI:setChineseName(Node_9, "玩家装备_护身符_位置")
	GUI:setAnchorPoint(Node_9, 0.50, 0.50)
	GUI:setTag(Node_9, 71.0)

	-- Create Text_guildinfo
	local Text_guildinfo = GUI:Text_Create(EquipUI, "Text_guildinfo", 10.00, 460.00, 18.0, "#ffffff", [[]])
	GUI:setChineseName(Text_guildinfo, "玩家装备_行会信息")
	GUI:setAnchorPoint(Text_guildinfo, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildinfo, false)
	GUI:setTag(Text_guildinfo, 72.0)
	GUI:Text_enableOutline(Text_guildinfo, "#0e0e0e", 1.0)

	-- Create Best_ringBox
	local Best_ringBox = GUI:Layout_Create(EquipUI, "Best_ringBox", 287.00, 308.00, 54.00, 43.00, false)
	GUI:setChineseName(Best_ringBox, "玩家装备_首饰盒组合")
	GUI:setTouchEnabled(Best_ringBox, true)
	GUI:setTag(Best_ringBox, 75.0)

	-- Create Image_box
	local Image_box = GUI:Image_Create(Best_ringBox, "Image_box", 25.00, 22.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/btn_jewelry_1_0.png")
	GUI:setChineseName(Image_box, "玩家装备_首饰盒")
	GUI:setAnchorPoint(Image_box, 0.50, 0.50)
	GUI:setTouchEnabled(Image_box, false)
	GUI:setTag(Image_box, 74.0)

	-- Create Panel_pos1
	local Panel_pos1 = GUI:Layout_Create(EquipUI, "Panel_pos1", 36.00, 277.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos1, "玩家装备_武器_组合")
	GUI:setAnchorPoint(Panel_pos1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1, true)
	GUI:setTag(Panel_pos1, 69.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos1, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_武器_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 70.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos1, "DefaultIcon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_武器_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 81.0)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(EquipUI, "Node_1", 36.00, 277.00)
	GUI:setChineseName(Node_1, "玩家装备_武器_位置")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 71.0)

	-- Create Panel_pos0
	local Panel_pos0 = GUI:Layout_Create(EquipUI, "Panel_pos0", 36.00, 216.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos0, "玩家装备_衣服_组合")
	GUI:setAnchorPoint(Panel_pos0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos0, true)
	GUI:setTag(Panel_pos0, 69.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(Panel_pos0, "PanelBg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(PanelBg, 17, 17.0, 16, 14.0)
	GUI:setContentSize(PanelBg, 52.0, 52.0)
	GUI:setIgnoreContentAdaptWithSize(PanelBg, false)
	GUI:setChineseName(PanelBg, "玩家装备_衣服_物品框")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, 70.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(Panel_pos0, "DefaultIcon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(DefaultIcon, "玩家装备_衣服_图标")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, 81.0)

	-- Create Node_1
	local Node_0 = GUI:Node_Create(EquipUI, "Node_0", 36.00, 216.00)
	GUI:setChineseName(Node_0, "玩家装备_衣服_位置")
	GUI:setAnchorPoint(Node_0, 0.50, 0.50)
	GUI:setTag(Node_0, 71.0)
end
return ui