local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "玩家时装节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家时装_组合")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 31)

	-- Create Image_20
	local Image_20 = GUI:Image_Create(Panel_1, "Image_20", 174.00, 239.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/bg_juese_03.png")
	GUI:setChineseName(Image_20, "玩家时装_背景图")
	GUI:setAnchorPoint(Image_20, 0.50, 0.50)
	GUI:setTouchEnabled(Image_20, false)
	GUI:setTag(Image_20, 213)

	-- Create Panel_pos17
	local Panel_pos17 = GUI:Layout_Create(Panel_1, "Panel_pos17", 174.00, 197.00, 180.00, 240.00, false)
	GUI:setChineseName(Panel_pos17, "玩家时装_衣服位置")
	GUI:setAnchorPoint(Panel_pos17, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos17, true)
	GUI:setTag(Panel_pos17, 32)

	-- Create Panel_pos21
	local Panel_pos21 = GUI:Layout_Create(Panel_1, "Panel_pos21", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setChineseName(Panel_pos21, "玩家时装_头盔位置")
	GUI:setAnchorPoint(Panel_pos21, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos21, true)
	GUI:setTag(Panel_pos21, 33)

	-- Create Panel_pos45
	local Panel_pos45 = GUI:Layout_Create(Panel_1, "Panel_pos45", 244.00, 208.00, 85.00, 140.00, false)
	GUI:setChineseName(Panel_pos45, "玩家时装_盾牌位置")
	GUI:setAnchorPoint(Panel_pos45, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos45, true)
	GUI:setTag(Panel_pos45, 82)

	-- Create Panel_pos18
	local Panel_pos18 = GUI:Layout_Create(Panel_1, "Panel_pos18", 67.00, 306.00, 120.00, 206.00, false)
	GUI:setChineseName(Panel_pos18, "玩家时装_武器位置")
	GUI:setAnchorPoint(Panel_pos18, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos18, true)
	GUI:setTag(Panel_pos18, 31)

	-- Create Node_playerModel
	local Node_playerModel = GUI:Node_Create(Panel_1, "Node_playerModel", 174.00, 219.00)
	GUI:setChineseName(Node_playerModel, "玩家时装_裸模位置")
	GUI:setAnchorPoint(Node_playerModel, 0.50, 0.50)
	GUI:setTag(Node_playerModel, 48)

	-- Create Text_guildinfo
	local Text_guildinfo = GUI:Text_Create(Panel_1, "Text_guildinfo", 10.00, 460.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_guildinfo, "玩家时装_行会名称")
	GUI:setAnchorPoint(Text_guildinfo, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildinfo, false)
	GUI:setTag(Text_guildinfo, 72)
	GUI:Text_enableOutline(Text_guildinfo, "#0e0e0e", 1)

	-- Create Panel_pos1019
	local Panel_pos1019 = GUI:Layout_Create(Panel_1, "Panel_pos1019", 314.00, 397.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos1019, "玩家时装_斗笠组合")
	GUI:setAnchorPoint(Panel_pos1019, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1019, true)
	GUI:setTag(Panel_pos1019, 34)
	GUI:setVisible(Panel_pos1019, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos1019, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_斗笠_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos1019, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(Image_icon, "玩家时装_斗笠_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos1021
	local Panel_pos1021 = GUI:Layout_Create(Panel_1, "Panel_pos1021", 314.00, 337.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos1021, "玩家时装_头盔组合")
	GUI:setAnchorPoint(Panel_pos1021, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1021, true)
	GUI:setTag(Panel_pos1021, 34)
	GUI:setVisible(Panel_pos1021, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos1021, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_头盔_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos1021, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(Image_icon, "玩家时装_头盔_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos1018
	local Panel_pos1018 = GUI:Layout_Create(Panel_1, "Panel_pos1018", 36.00, 276.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos1018, "玩家时装_武器组合")
	GUI:setAnchorPoint(Panel_pos1018, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1018, true)
	GUI:setTag(Panel_pos1018, 34)
	GUI:setVisible(Panel_pos1018, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos1018, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_武器_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos1018, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(Image_icon, "玩家时装_武器_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos1017
	local Panel_pos1017 = GUI:Layout_Create(Panel_1, "Panel_pos1017", 36.00, 216.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos1017, "玩家时装_衣服组合")
	GUI:setAnchorPoint(Panel_pos1017, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1017, true)
	GUI:setTag(Panel_pos1017, 34)
	GUI:setVisible(Panel_pos1017, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos1017, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_衣服_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos1017, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setChineseName(Image_icon, "玩家时装_衣服_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos23
	local Panel_pos23 = GUI:Layout_Create(Panel_1, "Panel_pos23", 36.00, 156.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos23, "玩家时装_右手镯组合")
	GUI:setAnchorPoint(Panel_pos23, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos23, true)
	GUI:setTag(Panel_pos23, 34)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos23, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_右手镯_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos23, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_右手镯_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos25
	local Panel_pos25 = GUI:Layout_Create(Panel_1, "Panel_pos25", 36.00, 95.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos25, "玩家时装_右戒指组合")
	GUI:setAnchorPoint(Panel_pos25, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos25, true)
	GUI:setTag(Panel_pos25, 39)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos25, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_右戒指_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 49)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos25, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_右戒指_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 73)

	-- Create Panel_pos24
	local Panel_pos24 = GUI:Layout_Create(Panel_1, "Panel_pos24", 314.00, 95.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos24, "玩家时装_左戒指_组合")
	GUI:setAnchorPoint(Panel_pos24, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos24, true)
	GUI:setTag(Panel_pos24, 40)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos24, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_左戒指_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 48)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos24, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_左戒指_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 74)

	-- Create Panel_pos22
	local Panel_pos22 = GUI:Layout_Create(Panel_1, "Panel_pos22", 314.00, 156.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos22, "玩家时装_左手镯_组合")
	GUI:setAnchorPoint(Panel_pos22, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos22, true)
	GUI:setTag(Panel_pos22, 41)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos22, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_左手镯_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 46)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos22, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_左手镯_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 75)

	-- Create Panel_pos26
	local Panel_pos26 = GUI:Layout_Create(Panel_1, "Panel_pos26", 314.00, 216.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos26, "玩家时装_勋章_组合")
	GUI:setAnchorPoint(Panel_pos26, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos26, true)
	GUI:setTag(Panel_pos26, 42)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos26, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_勋章_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 45)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos26, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015033.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_勋章_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 76)

	-- Create Panel_pos20
	local Panel_pos20 = GUI:Layout_Create(Panel_1, "Panel_pos20", 314.00, 277.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos20, "玩家时装_项链_组合")
	GUI:setAnchorPoint(Panel_pos20, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos20, true)
	GUI:setTag(Panel_pos20, 43)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos20, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_项链_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 44)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos20, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015032.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_项链_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 77)

	-- Create Panel_pos44
	local Panel_pos44 = GUI:Layout_Create(Panel_1, "Panel_pos44", 36.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos44, "玩家时装_战鼓_组合")
	GUI:setAnchorPoint(Panel_pos44, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos44, true)
	GUI:setTag(Panel_pos44, 179)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos44, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_战鼓_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 180)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos44, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015040.png")
	GUI:setChineseName(Image_icon, "玩家时装_战鼓_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 181)

	-- Create Panel_pos42
	local Panel_pos42 = GUI:Layout_Create(Panel_1, "Panel_pos42", 314.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos42, "玩家时装_坐骑_组合")
	GUI:setAnchorPoint(Panel_pos42, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos42, true)
	GUI:setTag(Panel_pos42, 175)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos42, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_坐骑_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 176)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos42, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015041.png")
	GUI:setChineseName(Image_icon, "玩家时装_坐骑_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 177)

	-- Create Panel_pos29
	local Panel_pos29 = GUI:Layout_Create(Panel_1, "Panel_pos29", 257.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos29, "玩家时装_魔血石_组合")
	GUI:setAnchorPoint(Panel_pos29, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos29, true)
	GUI:setTag(Panel_pos29, 60)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos29, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_魔血石_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 61)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos29, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015039.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_魔血石_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 78)

	-- Create Panel_pos28
	local Panel_pos28 = GUI:Layout_Create(Panel_1, "Panel_pos28", 203.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos28, "玩家时装_靴子_组合")
	GUI:setAnchorPoint(Panel_pos28, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos28, true)
	GUI:setTag(Panel_pos28, 63)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos28, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_靴子_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 64)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos28, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015037.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_靴子_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 79)

	-- Create Panel_pos27
	local Panel_pos27 = GUI:Layout_Create(Panel_1, "Panel_pos27", 147.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos27, "玩家时装_腰带_组合")
	GUI:setAnchorPoint(Panel_pos27, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos27, true)
	GUI:setTag(Panel_pos27, 66)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos27, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_腰带_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 67)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos27, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015038.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_腰带_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 80)

	-- Create Panel_pos43
	local Panel_pos43 = GUI:Layout_Create(Panel_1, "Panel_pos43", 92.00, 35.00, 51.00, 51.00, false)
	GUI:setChineseName(Panel_pos43, "玩家时装_护身符_组合")
	GUI:setAnchorPoint(Panel_pos43, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos43, true)
	GUI:setTag(Panel_pos43, 69)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos43, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家时装_护身符_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 70)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos43, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015036.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "玩家时装_护身符_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 81)

	-- Create Node_1019
	local Node_1019 = GUI:Node_Create(Panel_1, "Node_1019", 314.00, 397.00)
	GUI:setChineseName(Node_1019, "玩家时装_斗笠_物品框")
	GUI:setAnchorPoint(Node_1019, 0.50, 0.50)
	GUI:setTag(Node_1019, 56)
	GUI:setVisible(Node_1019, false)

	-- Create Node_1021
	local Node_1021 = GUI:Node_Create(Panel_1, "Node_1021", 314.00, 337.00)
	GUI:setChineseName(Node_1021, "玩家时装_头盔_位置")
	GUI:setAnchorPoint(Node_1021, 0.50, 0.50)
	GUI:setTag(Node_1021, 56)
	GUI:setVisible(Node_1021, false)

	-- Create Node_1018
	local Node_1018 = GUI:Node_Create(Panel_1, "Node_1018", 36.00, 276.00)
	GUI:setChineseName(Node_1018, "玩家时装_武器_位置")
	GUI:setAnchorPoint(Node_1018, 0.50, 0.50)
	GUI:setTag(Node_1018, 51)
	GUI:setVisible(Node_1018, false)

	-- Create Node_1017
	local Node_1017 = GUI:Node_Create(Panel_1, "Node_1017", 36.00, 216.00)
	GUI:setChineseName(Node_1017, "玩家时装_衣服_位置")
	GUI:setAnchorPoint(Node_1017, 0.50, 0.50)
	GUI:setTag(Node_1017, 51)
	GUI:setVisible(Node_1017, false)

	-- Create Node_23
	local Node_23 = GUI:Node_Create(Panel_1, "Node_23", 36.00, 156.00)
	GUI:setChineseName(Node_23, "玩家时装_右手镯_位置")
	GUI:setAnchorPoint(Node_23, 0.50, 0.50)
	GUI:setTag(Node_23, 51)

	-- Create Node_25
	local Node_25 = GUI:Node_Create(Panel_1, "Node_25", 36.00, 95.00)
	GUI:setChineseName(Node_25, "玩家时装_右戒指_位置")
	GUI:setAnchorPoint(Node_25, 0.50, 0.50)
	GUI:setTag(Node_25, 52)

	-- Create Node_24
	local Node_24 = GUI:Node_Create(Panel_1, "Node_24", 314.00, 95.00)
	GUI:setChineseName(Node_24, "玩家时装_左戒指_位置")
	GUI:setAnchorPoint(Node_24, 0.50, 0.50)
	GUI:setTag(Node_24, 53)

	-- Create Node_22
	local Node_22 = GUI:Node_Create(Panel_1, "Node_22", 314.00, 156.00)
	GUI:setChineseName(Node_22, "玩家时装_左手镯_位置")
	GUI:setAnchorPoint(Node_22, 0.50, 0.50)
	GUI:setTag(Node_22, 54)

	-- Create Node_26
	local Node_26 = GUI:Node_Create(Panel_1, "Node_26", 314.00, 216.00)
	GUI:setChineseName(Node_26, "玩家时装_勋章_位置")
	GUI:setAnchorPoint(Node_26, 0.50, 0.50)
	GUI:setTag(Node_26, 55)

	-- Create Node_20
	local Node_20 = GUI:Node_Create(Panel_1, "Node_20", 314.00, 277.00)
	GUI:setChineseName(Node_20, "玩家时装_项链_位置")
	GUI:setAnchorPoint(Node_20, 0.50, 0.50)
	GUI:setTag(Node_20, 56)

	-- Create Node_44
	local Node_44 = GUI:Node_Create(Panel_1, "Node_44", 36.00, 35.00)
	GUI:setChineseName(Node_44, "玩家时装_战鼓_位置")
	GUI:setAnchorPoint(Node_44, 0.50, 0.50)
	GUI:setTag(Node_44, 182)

	-- Create Node_42
	local Node_42 = GUI:Node_Create(Panel_1, "Node_42", 314.00, 35.00)
	GUI:setChineseName(Node_42, "玩家时装_坐骑_位置")
	GUI:setAnchorPoint(Node_42, 0.50, 0.50)
	GUI:setTag(Node_42, 178)

	-- Create Node_29
	local Node_29 = GUI:Node_Create(Panel_1, "Node_29", 257.00, 35.00)
	GUI:setChineseName(Node_29, "玩家时装_魔血石_位置")
	GUI:setAnchorPoint(Node_29, 0.50, 0.50)
	GUI:setTag(Node_29, 62)

	-- Create Node_28
	local Node_28 = GUI:Node_Create(Panel_1, "Node_28", 203.00, 35.00)
	GUI:setChineseName(Node_28, "玩家时装_靴子_位置")
	GUI:setAnchorPoint(Node_28, 0.50, 0.50)
	GUI:setTag(Node_28, 65)

	-- Create Node_27
	local Node_27 = GUI:Node_Create(Panel_1, "Node_27", 147.00, 35.00)
	GUI:setChineseName(Node_27, "玩家时装_腰带_位置")
	GUI:setAnchorPoint(Node_27, 0.50, 0.50)
	GUI:setTag(Node_27, 68)

	-- Create Node_43
	local Node_43 = GUI:Node_Create(Panel_1, "Node_43", 92.00, 35.00)
	GUI:setChineseName(Node_43, "玩家时装_护身符_位置")
	GUI:setAnchorPoint(Node_43, 0.50, 0.50)
	GUI:setTag(Node_43, 71)

	-- Create Text_shizhuang
	local Text_shizhuang = GUI:Text_Create(Panel_1, "Text_shizhuang", 264.00, 453.00, 16, "#ffe400", [[时装外显示]])
	GUI:setChineseName(Text_shizhuang, "玩家时装_外显_文本")
	GUI:setAnchorPoint(Text_shizhuang, 0.00, 0.50)
	GUI:setTouchEnabled(Text_shizhuang, false)
	GUI:setTag(Text_shizhuang, 352)
	GUI:Text_enableOutline(Text_shizhuang, "#111111", 1)

	-- Create CheckBox_shizhuang
	local CheckBox_shizhuang = GUI:CheckBox_Create(Panel_1, "CheckBox_shizhuang", 250.00, 453.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_shizhuang, true)
	GUI:setChineseName(CheckBox_shizhuang, "玩家时装_外显_勾选框")
	GUI:setAnchorPoint(CheckBox_shizhuang, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_shizhuang, true)
	GUI:setTag(CheckBox_shizhuang, 351)
end
return ui