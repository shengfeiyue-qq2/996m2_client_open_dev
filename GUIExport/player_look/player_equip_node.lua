local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 31)

	-- Create Image_20
	local Image_20 = GUI:Image_Create(Panel_1, "Image_20", 174.00, 239.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/bg_juese_03.png")
	GUI:setAnchorPoint(Image_20, 0.50, 0.50)
	GUI:setTouchEnabled(Image_20, false)
	GUI:setTag(Image_20, 213)

	-- Create Node_playerModel
	local Node_playerModel = GUI:Node_Create(Panel_1, "Node_playerModel", 174.00, 219.00)
	GUI:setAnchorPoint(Node_playerModel, 0.50, 0.50)
	GUI:setTag(Node_playerModel, 48)

	-- Create Panel_pos0
	local Panel_pos0 = GUI:Layout_Create(Panel_1, "Panel_pos0", 174.00, 197.00, 180.00, 240.00, false)
	GUI:setAnchorPoint(Panel_pos0, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos0, true)
	GUI:setTag(Panel_pos0, 32)

	-- Create Panel_pos1
	local Panel_pos1 = GUI:Layout_Create(Panel_1, "Panel_pos1", 67.00, 306.00, 120.00, 206.00, false)
	GUI:setAnchorPoint(Panel_pos1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos1, true)
	GUI:setTag(Panel_pos1, 31)

	-- Create Panel_pos16
	local Panel_pos16 = GUI:Layout_Create(Panel_1, "Panel_pos16", 244.00, 208.00, 85.00, 140.00, false)
	GUI:setAnchorPoint(Panel_pos16, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos16, true)
	GUI:setTag(Panel_pos16, 82)

	-- Create Panel_pos4
	local Panel_pos4 = GUI:Layout_Create(Panel_1, "Panel_pos4", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setAnchorPoint(Panel_pos4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos4, true)
	GUI:setTag(Panel_pos4, 33)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos4, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 141)
	GUI:setVisible(Image_bg, false)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos4, "Image_icon", 25.00, 25.00, "Default/ImageFile.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 142)
	GUI:setVisible(Image_icon, false)

	-- Create Panel_pos13
	local Panel_pos13 = GUI:Layout_Create(Panel_1, "Panel_pos13", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setAnchorPoint(Panel_pos13, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos13, true)
	GUI:setTag(Panel_pos13, 143)
	GUI:setVisible(Panel_pos13, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos13, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 144)
	GUI:setVisible(Image_bg, false)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos13, "Image_icon", 25.00, 25.00, "Default/ImageFile.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 145)
	GUI:setVisible(Image_icon, false)

	-- Create Panel_pos55
	local Panel_pos55 = GUI:Layout_Create(Panel_1, "Panel_pos55", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setAnchorPoint(Panel_pos55, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos55, true)
	GUI:setTag(Panel_pos55, 78)

	-- Create Panel_pos101
	local Panel_pos101 = GUI:Layout_Create(Panel_1, "Panel_pos101", 36.00, 275.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos101, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos101, false)
	GUI:setTag(Panel_pos101, 34)
	GUI:setVisible(Panel_pos101, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos101, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos101, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos100
	local Panel_pos100 = GUI:Layout_Create(Panel_1, "Panel_pos100", 36.00, 215.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos100, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos100, false)
	GUI:setTag(Panel_pos100, 34)
	GUI:setVisible(Panel_pos100, false)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos100, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 0, 0, 0, 0)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos100, "Image_icon", 25.00, 25.00, "res/public/0.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos6
	local Panel_pos6 = GUI:Layout_Create(Panel_1, "Panel_pos6", 36.00, 156.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos6, true)
	GUI:setTag(Panel_pos6, 34)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos6, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos6, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 72)

	-- Create Panel_pos8
	local Panel_pos8 = GUI:Layout_Create(Panel_1, "Panel_pos8", 36.00, 95.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos8, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos8, true)
	GUI:setTag(Panel_pos8, 39)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos8, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 49)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos8, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 73)

	-- Create Panel_pos7
	local Panel_pos7 = GUI:Layout_Create(Panel_1, "Panel_pos7", 314.00, 95.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos7, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos7, true)
	GUI:setTag(Panel_pos7, 40)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos7, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 48)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos7, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 74)

	-- Create Panel_pos5
	local Panel_pos5 = GUI:Layout_Create(Panel_1, "Panel_pos5", 314.00, 156.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos5, true)
	GUI:setTag(Panel_pos5, 41)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos5, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 46)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos5, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 75)

	-- Create Panel_pos2
	local Panel_pos2 = GUI:Layout_Create(Panel_1, "Panel_pos2", 314.00, 216.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos2, true)
	GUI:setTag(Panel_pos2, 42)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos2, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 45)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos2, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015033.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 76)

	-- Create Panel_pos3
	local Panel_pos3 = GUI:Layout_Create(Panel_1, "Panel_pos3", 314.00, 277.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos3, true)
	GUI:setTag(Panel_pos3, 43)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos3, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 44)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos3, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015032.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 77)

	-- Create Panel_pos14
	local Panel_pos14 = GUI:Layout_Create(Panel_1, "Panel_pos14", 36.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos14, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos14, true)
	GUI:setTag(Panel_pos14, 179)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos14, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 180)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos14, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015040.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 181)

	-- Create Panel_pos15
	local Panel_pos15 = GUI:Layout_Create(Panel_1, "Panel_pos15", 314.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos15, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos15, true)
	GUI:setTag(Panel_pos15, 175)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos15, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 176)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos15, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015041.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 177)

	-- Create Panel_pos12
	local Panel_pos12 = GUI:Layout_Create(Panel_1, "Panel_pos12", 257.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos12, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos12, true)
	GUI:setTag(Panel_pos12, 60)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos12, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 61)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos12, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015039.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 78)

	-- Create Panel_pos11
	local Panel_pos11 = GUI:Layout_Create(Panel_1, "Panel_pos11", 203.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos11, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos11, true)
	GUI:setTag(Panel_pos11, 63)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos11, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 64)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos11, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015037.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 79)

	-- Create Panel_pos10
	local Panel_pos10 = GUI:Layout_Create(Panel_1, "Panel_pos10", 147.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos10, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos10, true)
	GUI:setTag(Panel_pos10, 66)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos10, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 67)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos10, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015038.png")
	GUI:setContentSize(Image_icon, 47, 37)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 80)

	-- Create Panel_pos9
	local Panel_pos9 = GUI:Layout_Create(Panel_1, "Panel_pos9", 92.00, 35.00, 51.00, 51.00, false)
	GUI:setAnchorPoint(Panel_pos9, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_pos9, true)
	GUI:setTag(Panel_pos9, 69)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_pos9, "Image_bg", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:Image_setScale9Slice(Image_bg, 17, 17, 16, 14)
	GUI:setContentSize(Image_bg, 52, 52)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 70)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_pos9, "Image_icon", 25.00, 25.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015036.png")
	GUI:setContentSize(Image_icon, 47, 43)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 81)

	-- Create Node_101
	local Node_101 = GUI:Node_Create(Panel_1, "Node_101", 36.00, 275.00)
	GUI:setAnchorPoint(Node_101, 0.50, 0.50)
	GUI:setTag(Node_101, 51)
	GUI:setVisible(Node_101, false)

	-- Create Node_100
	local Node_100 = GUI:Node_Create(Panel_1, "Node_100", 36.00, 215.00)
	GUI:setAnchorPoint(Node_100, 0.50, 0.50)
	GUI:setTag(Node_100, 51)
	GUI:setVisible(Node_100, false)

	-- Create Node_6
	local Node_6 = GUI:Node_Create(Panel_1, "Node_6", 36.00, 156.00)
	GUI:setAnchorPoint(Node_6, 0.50, 0.50)
	GUI:setTag(Node_6, 51)

	-- Create Node_8
	local Node_8 = GUI:Node_Create(Panel_1, "Node_8", 36.00, 95.00)
	GUI:setAnchorPoint(Node_8, 0.50, 0.50)
	GUI:setTag(Node_8, 52)

	-- Create Node_7
	local Node_7 = GUI:Node_Create(Panel_1, "Node_7", 314.00, 95.00)
	GUI:setAnchorPoint(Node_7, 0.50, 0.50)
	GUI:setTag(Node_7, 53)

	-- Create Node_5
	local Node_5 = GUI:Node_Create(Panel_1, "Node_5", 314.00, 156.00)
	GUI:setAnchorPoint(Node_5, 0.50, 0.50)
	GUI:setTag(Node_5, 54)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(Panel_1, "Node_2", 314.00, 216.00)
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 55)

	-- Create Node_3
	local Node_3 = GUI:Node_Create(Panel_1, "Node_3", 314.00, 277.00)
	GUI:setAnchorPoint(Node_3, 0.50, 0.50)
	GUI:setTag(Node_3, 56)

	-- Create Node_4
	local Node_4 = GUI:Node_Create(Panel_1, "Node_4", 174.00, 322.00)
	GUI:setAnchorPoint(Node_4, 0.50, 0.50)
	GUI:setTag(Node_4, 212)

	-- Create Node_13
	local Node_13 = GUI:Node_Create(Panel_1, "Node_13", 174.00, 322.00)
	GUI:setAnchorPoint(Node_13, 0.50, 0.50)
	GUI:setTag(Node_13, 213)

	-- Create Node_55
	local Node_55 = GUI:Node_Create(Panel_1, "Node_55", 174.00, 322.00)
	GUI:setAnchorPoint(Node_55, 0.50, 0.50)
	GUI:setTag(Node_55, 147)

	-- Create Node_14
	local Node_14 = GUI:Node_Create(Panel_1, "Node_14", 36.00, 35.00)
	GUI:setAnchorPoint(Node_14, 0.50, 0.50)
	GUI:setTag(Node_14, 182)

	-- Create Node_15
	local Node_15 = GUI:Node_Create(Panel_1, "Node_15", 314.00, 35.00)
	GUI:setAnchorPoint(Node_15, 0.50, 0.50)
	GUI:setTag(Node_15, 178)

	-- Create Node_12
	local Node_12 = GUI:Node_Create(Panel_1, "Node_12", 257.00, 35.00)
	GUI:setAnchorPoint(Node_12, 0.50, 0.50)
	GUI:setTag(Node_12, 62)

	-- Create Node_11
	local Node_11 = GUI:Node_Create(Panel_1, "Node_11", 203.00, 35.00)
	GUI:setAnchorPoint(Node_11, 0.50, 0.50)
	GUI:setTag(Node_11, 65)

	-- Create Node_10
	local Node_10 = GUI:Node_Create(Panel_1, "Node_10", 147.00, 35.00)
	GUI:setAnchorPoint(Node_10, 0.50, 0.50)
	GUI:setTag(Node_10, 68)

	-- Create Node_9
	local Node_9 = GUI:Node_Create(Panel_1, "Node_9", 92.00, 35.00)
	GUI:setAnchorPoint(Node_9, 0.50, 0.50)
	GUI:setTag(Node_9, 71)

	-- Create Text_guildinfo
	local Text_guildinfo = GUI:Text_Create(Panel_1, "Text_guildinfo", 10.00, 460.00, 18, "#ffe400", [[]])
	GUI:setAnchorPoint(Text_guildinfo, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildinfo, false)
	GUI:setTag(Text_guildinfo, 72)
	GUI:Text_enableOutline(Text_guildinfo, "#0e0e0e", 1)

	-- Create Best_ringBox
	local Best_ringBox = GUI:Layout_Create(Panel_1, "Best_ringBox", 287.00, 308.00, 54.00, 43.00, false)
	GUI:setTouchEnabled(Best_ringBox, true)
	GUI:setTag(Best_ringBox, 75)

	-- Create Image_box
	local Image_box = GUI:Image_Create(Best_ringBox, "Image_box", 25.00, 22.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/btn_jewelry_1_0.png")
	GUI:setAnchorPoint(Image_box, 0.50, 0.50)
	GUI:setTouchEnabled(Image_box, false)
	GUI:setTag(Image_box, 74)
end
return ui