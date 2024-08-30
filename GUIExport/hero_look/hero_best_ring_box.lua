local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 577.00, 293.00, 366.00, 339.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1.0)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/bg_jewelry_1.png")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1.0)

	-- Create line
	local line = GUI:Image_Create(PMainUI, "line", 184.00, 285.00, "res/public/word_sxbt_05.png")
	GUI:setAnchorPoint(line, 0.50, 0.50)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1.0)

	-- Create ImageTitle
	local ImageTitle = GUI:Image_Create(PMainUI, "ImageTitle", 181.00, 285.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_jewelry_1.png")
	GUI:setAnchorPoint(ImageTitle, 0.50, 0.50)
	GUI:setTouchEnabled(ImageTitle, false)
	GUI:setTag(ImageTitle, -1.0)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 364.00, 338.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10.0)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1.0)
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1.0)

	-- Create PanelItems
	local PanelItems = GUI:Layout_Create(PMainUI, "PanelItems", 38.00, 30.00, 292.00, 219.00, true)
	GUI:setTouchEnabled(PanelItems, false)
	GUI:setTag(PanelItems, -1.0)

	-- Create PanelPos30
	local PanelPos30 = GUI:Layout_Create(PanelItems, "PanelPos30", 35.00, 185.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos30, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos30, true)
	GUI:setTag(PanelPos30, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos30, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos30, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_1.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos30, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos31
	local PanelPos31 = GUI:Layout_Create(PanelItems, "PanelPos31", 108.00, 185.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos31, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos31, true)
	GUI:setTag(PanelPos31, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos31, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos31, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_2.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos31, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos32
	local PanelPos32 = GUI:Layout_Create(PanelItems, "PanelPos32", 182.00, 185.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos32, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos32, true)
	GUI:setTag(PanelPos32, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos32, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos32, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_3.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos32, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos33
	local PanelPos33 = GUI:Layout_Create(PanelItems, "PanelPos33", 255.00, 185.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos33, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos33, true)
	GUI:setTag(PanelPos33, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos33, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos33, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_4.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos33, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos34
	local PanelPos34 = GUI:Layout_Create(PanelItems, "PanelPos34", 35.00, 110.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos34, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos34, true)
	GUI:setTag(PanelPos34, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos34, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos34, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_5.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos34, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos35
	local PanelPos35 = GUI:Layout_Create(PanelItems, "PanelPos35", 108.00, 110.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos35, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos35, true)
	GUI:setTag(PanelPos35, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos35, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos35, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_6.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos35, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos36
	local PanelPos36 = GUI:Layout_Create(PanelItems, "PanelPos36", 182.00, 110.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos36, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos36, true)
	GUI:setTag(PanelPos36, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos36, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos36, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_7.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos36, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos37
	local PanelPos37 = GUI:Layout_Create(PanelItems, "PanelPos37", 255.00, 110.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos37, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos37, true)
	GUI:setTag(PanelPos37, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos37, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos37, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_8.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos37, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos38
	local PanelPos38 = GUI:Layout_Create(PanelItems, "PanelPos38", 35.00, 35.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos38, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos38, true)
	GUI:setTag(PanelPos38, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos38, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos38, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_9.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos38, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos39
	local PanelPos39 = GUI:Layout_Create(PanelItems, "PanelPos39", 108.00, 35.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos39, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos39, true)
	GUI:setTag(PanelPos39, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos39, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos39, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_10.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos39, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos40
	local PanelPos40 = GUI:Layout_Create(PanelItems, "PanelPos40", 182.00, 35.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos40, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos40, true)
	GUI:setTag(PanelPos40, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos40, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos40, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_11.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos40, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelPos41
	local PanelPos41 = GUI:Layout_Create(PanelItems, "PanelPos41", 255.00, 35.00, 52.00, 52.00, false)
	GUI:setAnchorPoint(PanelPos41, 0.50, 0.50)
	GUI:setTouchEnabled(PanelPos41, true)
	GUI:setTag(PanelPos41, -1.0)

	-- Create PanelBg
	local PanelBg = GUI:Image_Create(PanelPos41, "PanelBg", 26.00, 26.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(PanelBg, 0.50, 0.50)
	GUI:setTouchEnabled(PanelBg, false)
	GUI:setTag(PanelBg, -1.0)

	-- Create DefaultIcon
	local DefaultIcon = GUI:Image_Create(PanelPos41, "DefaultIcon", 26.00, 26.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_12.png")
	GUI:setAnchorPoint(DefaultIcon, 0.50, 0.50)
	GUI:setTouchEnabled(DefaultIcon, false)
	GUI:setTag(DefaultIcon, -1.0)

	-- Create Node
	local Node = GUI:Node_Create(PanelPos41, "Node", 26.00, 26.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create PanelTouch
	local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 38.00, 30.00, 292.00, 219.00, true)
	GUI:setTouchEnabled(PanelTouch, false)
	GUI:setTag(PanelTouch, -1.0)
end
return ui