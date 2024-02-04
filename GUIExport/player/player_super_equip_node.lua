local ui = {}
function ui.init(parent)
	-- Create SuperEquipUI
	local SuperEquipUI = GUI:Layout_Create(parent, "SuperEquipUI", 0.00, 0.00, 348.00, 478.00, true)
	GUI:setTouchEnabled(SuperEquipUI, true)
	GUI:setTag(SuperEquipUI, -1)

	-- Create BG
	local BG = GUI:Image_Create(SuperEquipUI, "BG", 0.00, 0.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/bg_juese_03.png")
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, -1)

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(SuperEquipUI, "CheckBox", 25.00, 453.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox, false)
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, -1)

	-- Create Text_CheckBox
	local Text_CheckBox = GUI:Text_Create(CheckBox, "Text_CheckBox", 35.00, 5.00, 16, "#41ca44", [[时装外显示]])
	GUI:setTouchEnabled(Text_CheckBox, false)
	GUI:setTag(Text_CheckBox, -1)
	GUI:Text_enableOutline(Text_CheckBox, "#000000", 1)

	-- Create NodePlayerModel
	local NodePlayerModel = GUI:Node_Create(SuperEquipUI, "NodePlayerModel", 174.00, 219.00)
	GUI:setAnchorPoint(NodePlayerModel, 0.50, 0.50)
	GUI:setTag(NodePlayerModel, -1)

	-- Create PanelPos17
	local PanelPos17 = GUI:Layout_Create(SuperEquipUI, "PanelPos17", 180.00, 240.00, 174.00, 197.00, false)
	GUI:setAnchorPoint(PanelPos17, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos17, true)
	GUI:setTag(PanelPos17, -1)

	-- Create PanelPos18
	local PanelPos18 = GUI:Layout_Create(SuperEquipUI, "PanelPos18", 67.00, 306.00, 120.00, 206.00, false)
	GUI:setAnchorPoint(PanelPos18, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos18, true)
	GUI:setTag(PanelPos18, -1)

	-- Create PanelPos45
	local PanelPos45 = GUI:Layout_Create(SuperEquipUI, "PanelPos45", 244.00, 208.00, 85.00, 140.00, false)
	GUI:setAnchorPoint(PanelPos45, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos45, false)
	GUI:setTag(PanelPos45, -1)

	-- Create PanelPos21
	local PanelPos21 = GUI:Layout_Create(SuperEquipUI, "PanelPos21", 174.00, 322.00, 50.00, 50.00, false)
	GUI:setAnchorPoint(PanelPos21, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos21, true)
	GUI:setTag(PanelPos21, -1)

	-- Create PanelPos26
	local PanelPos26 = GUI:Layout_Create(SuperEquipUI, "PanelPos26", 318.00, 202.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos26, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos26, false)
	GUI:setTag(PanelPos26, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos26, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos26, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015033.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node26
	local Node26 = GUI:Node_Create(SuperEquipUI, "Node26", 318.00, 202.00)
	GUI:setAnchorPoint(Node26, 0.50, 0.50)
	GUI:setTag(Node26, -1)

	-- Create PanelPos20
	local PanelPos20 = GUI:Layout_Create(SuperEquipUI, "PanelPos20", 318.00, 260.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos20, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos20, false)
	GUI:setTag(PanelPos20, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos20, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos20, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015032.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node20
	local Node20 = GUI:Node_Create(SuperEquipUI, "Node20", 318.00, 260.00)
	GUI:setAnchorPoint(Node20, 0.50, 0.50)
	GUI:setTag(Node20, -1)

	-- Create PanelPos22
	local PanelPos22 = GUI:Layout_Create(SuperEquipUI, "PanelPos22", 318.00, 145.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos22, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos22, false)
	GUI:setTag(PanelPos22, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos22, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos22, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node22
	local Node22 = GUI:Node_Create(SuperEquipUI, "Node22", 318.00, 145.00)
	GUI:setAnchorPoint(Node22, 0.50, 0.50)
	GUI:setTag(Node22, -1)

	-- Create PanelPos23
	local PanelPos23 = GUI:Layout_Create(SuperEquipUI, "PanelPos23", 30.00, 145.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos23, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos23, false)
	GUI:setTag(PanelPos23, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos23, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos23, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015034.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node23
	local Node23 = GUI:Node_Create(SuperEquipUI, "Node23", 30.00, 145.00)
	GUI:setAnchorPoint(Node23, 0.50, 0.50)
	GUI:setTag(Node23, -1)

	-- Create PanelPos24
	local PanelPos24 = GUI:Layout_Create(SuperEquipUI, "PanelPos24", 318.00, 87.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos24, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos24, false)
	GUI:setTag(PanelPos24, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos24, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos24, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node24
	local Node24 = GUI:Node_Create(SuperEquipUI, "Node24", 318.00, 87.00)
	GUI:setAnchorPoint(Node24, 0.50, 0.50)
	GUI:setTag(Node24, -1)

	-- Create PanelPos25
	local PanelPos25 = GUI:Layout_Create(SuperEquipUI, "PanelPos25", 30.00, 87.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos25, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos25, false)
	GUI:setTag(PanelPos25, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos25, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos25, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015035.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node25
	local Node25 = GUI:Node_Create(SuperEquipUI, "Node25", 30.00, 87.00)
	GUI:setAnchorPoint(Node25, 0.50, 0.50)
	GUI:setTag(Node25, -1)

	-- Create PanelPos43
	local PanelPos43 = GUI:Layout_Create(SuperEquipUI, "PanelPos43", 87.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos43, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos43, false)
	GUI:setTag(PanelPos43, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos43, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos43, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015036.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node43
	local Node43 = GUI:Node_Create(SuperEquipUI, "Node43", 87.00, 30.00)
	GUI:setAnchorPoint(Node43, 0.50, 0.50)
	GUI:setTag(Node43, -1)

	-- Create PanelPos27
	local PanelPos27 = GUI:Layout_Create(SuperEquipUI, "PanelPos27", 145.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos27, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos27, false)
	GUI:setTag(PanelPos27, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos27, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos27, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015038.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node27
	local Node27 = GUI:Node_Create(SuperEquipUI, "Node27", 145.00, 30.00)
	GUI:setAnchorPoint(Node27, 0.50, 0.50)
	GUI:setTag(Node27, -1)

	-- Create PanelPos28
	local PanelPos28 = GUI:Layout_Create(SuperEquipUI, "PanelPos28", 202.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos28, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos28, false)
	GUI:setTag(PanelPos28, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos28, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos28, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015037.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node28
	local Node28 = GUI:Node_Create(SuperEquipUI, "Node28", 202.00, 30.00)
	GUI:setAnchorPoint(Node28, 0.50, 0.50)
	GUI:setTag(Node28, -1)

	-- Create PanelPos29
	local PanelPos29 = GUI:Layout_Create(SuperEquipUI, "PanelPos29", 260.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos29, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos29, false)
	GUI:setTag(PanelPos29, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos29, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos29, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015039.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node29
	local Node29 = GUI:Node_Create(SuperEquipUI, "Node29", 260.00, 30.00)
	GUI:setAnchorPoint(Node29, 0.50, 0.50)
	GUI:setTag(Node29, -1)

	-- Create PanelPos44
	local PanelPos44 = GUI:Layout_Create(SuperEquipUI, "PanelPos44", 30.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos44, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos44, false)
	GUI:setTag(PanelPos44, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos44, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos44, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015040.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node44
	local Node44 = GUI:Node_Create(SuperEquipUI, "Node44", 30.00, 30.00)
	GUI:setAnchorPoint(Node44, 0.50, 0.50)
	GUI:setTag(Node44, -1)

	-- Create PanelPos42
	local PanelPos42 = GUI:Layout_Create(SuperEquipUI, "PanelPos42", 318.00, 30.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos42, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos42, false)
	GUI:setTag(PanelPos42, -1)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos42, "PanelBg", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/icon_chenghd_03.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos42, "DefaultIcon", 26.00, 26.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015041.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1)

	-- Create Node42
	local Node42 = GUI:Node_Create(SuperEquipUI, "Node42", 318.00, 30.00)
	GUI:setAnchorPoint(Node42, 0.50, 0.50)
	GUI:setTag(Node42, -1)
end
return ui