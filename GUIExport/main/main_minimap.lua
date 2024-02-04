local ui = {}
function ui.init(parent)
	-- Create LayoutClip
	local LayoutClip = GUI:Layout_Create(parent, "LayoutClip", 0.00, 0.00, 600.00, 160.00, true)
	GUI:setAnchorPoint(LayoutClip, 1.00, 1.00)
	GUI:setTouchEnabled(LayoutClip, false)
	GUI:setTag(LayoutClip, -1)

	-- Create Node
	local Node = GUI:Node_Create(LayoutClip, "Node", 600.00, 160.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create PKModelCell
	local PKModelCell = GUI:Layout_Create(Node, "PKModelCell", -142.00, -80.00, 400.00, 80.00, false)
	GUI:setAnchorPoint(PKModelCell, 1.00, 1.00)
	GUI:setTouchEnabled(PKModelCell, false)
	GUI:setTag(PKModelCell, -1)
	GUI:setVisible(PKModelCell, false)

	-- Create PKModelCellsBg
	local PKModelCellsBg = GUI:Image_Create(PKModelCell, "PKModelCellsBg", 0.00, 40.00, "res/private/main/Button/1900012160.png")
	GUI:Image_setScale9Slice(PKModelCellsBg, 29, 29, 10, 10)
	GUI:setContentSize(PKModelCellsBg, 400, 80)
	GUI:setIgnoreContentAdaptWithSize(PKModelCellsBg, false)
	GUI:setAnchorPoint(PKModelCellsBg, 0.00, 0.50)
	GUI:setTouchEnabled(PKModelCellsBg, false)
	GUI:setTag(PKModelCellsBg, -1)

	-- Create PKModelListView
	local PKModelListView = GUI:ListView_Create(PKModelCell, "PKModelListView", 0.00, 40.00, 400.00, 80.00, 2)
	GUI:ListView_setGravity(PKModelListView, 5)
	GUI:setAnchorPoint(PKModelListView, 0.00, 0.50)
	GUI:setTouchEnabled(PKModelListView, true)
	GUI:setTag(PKModelListView, -1)

	-- Create PKModelListViewCell
	local PKModelListViewCell = GUI:Layout_Create(PKModelCell, "PKModelListViewCell", 0.00, 0.00, 55.00, 80.00, true)
	GUI:setTouchEnabled(PKModelListViewCell, true)
	GUI:setTag(PKModelListViewCell, -1)
	GUI:setVisible(PKModelListViewCell, false)

	-- Create ImageName
	local ImageName = GUI:Image_Create(PKModelListViewCell, "ImageName", 27.00, 40.00, "res/private/main/Pattern/1900012200.png")
	GUI:setAnchorPoint(ImageName, 0.50, 0.50)
	GUI:setTouchEnabled(ImageName, false)
	GUI:setTag(ImageName, -1)

	-- Create MapBG
	local MapBG = GUI:Image_Create(Node, "MapBG", 0.00, -30.00, "res/private/main/miniMap/1900012101.png")
	GUI:setAnchorPoint(MapBG, 1.00, 1.00)
	GUI:setTouchEnabled(MapBG, false)
	GUI:setTag(MapBG, -1)

	-- Create Map
	local Map = GUI:Layout_Create(Node, "Map", -5.00, -35.00, 133.00, 122.00, true)
	GUI:setAnchorPoint(Map, 1.00, 1.00)
	GUI:setTouchEnabled(Map, false)
	GUI:setTag(Map, -1)

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Map, "Panel_minimap", 71.00, 130.00, 143.00, 131.00, true)
	GUI:setAnchorPoint(Panel_minimap, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_minimap, true)
	GUI:setTag(Panel_minimap, 22)

	-- Create Image_minimap
	local Image_minimap = GUI:Image_Create(Panel_minimap, "Image_minimap", 0.00, 0.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_minimap, 143, 131)
	GUI:setIgnoreContentAdaptWithSize(Image_minimap, false)
	GUI:setTouchEnabled(Image_minimap, false)
	GUI:setTag(Image_minimap, 46)

	-- Create Node_actors
	local Node_actors = GUI:Node_Create(Image_minimap, "Node_actors", 0.00, 0.00)
	GUI:setAnchorPoint(Node_actors, 0.50, 0.50)
	GUI:setTag(Node_actors, 40)

	-- Create Node_path
	local Node_path = GUI:Node_Create(Image_minimap, "Node_path", 0.00, 0.00)
	GUI:setAnchorPoint(Node_path, 0.50, 0.50)
	GUI:setTag(Node_path, 139)

	-- Create Node_player
	local Node_player = GUI:Node_Create(Panel_minimap, "Node_player", 0.00, 0.00)
	GUI:setAnchorPoint(Node_player, 0.50, 0.50)
	GUI:setTag(Node_player, 23)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Node, "Image_empty", -4.00, -35.00, "res/private/main/miniMap/1900012102.png")
	GUI:setContentSize(Image_empty, 133.5, 122)
	GUI:setIgnoreContentAdaptWithSize(Image_empty, false)
	GUI:setAnchorPoint(Image_empty, 1.00, 1.00)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, -1)
	GUI:setVisible(Image_empty, false)

	-- Create MapNameBG
	local MapNameBG = GUI:Image_Create(Node, "MapNameBG", 0.00, 0.00, "res/private/main/miniMap/1900012100.png")
	GUI:setAnchorPoint(MapNameBG, 1.00, 1.00)
	GUI:setTouchEnabled(MapNameBG, false)
	GUI:setTag(MapNameBG, -1)

	-- Create MapName
	local MapName = GUI:Text_Create(Node, "MapName", -70.00, -15.00, 16, "#ffffff", [[-]])
	GUI:setAnchorPoint(MapName, 0.50, 0.50)
	GUI:setTouchEnabled(MapName, false)
	GUI:setTag(MapName, -1)
	GUI:Text_enableOutline(MapName, "#000000", 1)

	-- Create MapStatusBG
	local MapStatusBG = GUI:Layout_Create(Node, "MapStatusBG", -4.00, -148.00, 135.00, 17.00, false)
	GUI:Layout_setBackGroundColorType(MapStatusBG, 1)
	GUI:Layout_setBackGroundColor(MapStatusBG, "#000000")
	GUI:Layout_setBackGroundColorOpacity(MapStatusBG, 100)
	GUI:setAnchorPoint(MapStatusBG, 1.00, 0.50)
	GUI:setTouchEnabled(MapStatusBG, false)
	GUI:setTag(MapStatusBG, -1)

	-- Create MapStatus
	local MapStatus = GUI:Text_Create(Node, "MapStatus", -136.00, -150.00, 14, "#ffffff", [[安全区域]])
	GUI:setAnchorPoint(MapStatus, 0.00, 0.50)
	GUI:setTouchEnabled(MapStatus, false)
	GUI:setTag(MapStatus, -1)
	GUI:Text_enableOutline(MapStatus, "#000000", 1)

	-- Create PlayerPos
	local PlayerPos = GUI:Text_Create(Node, "PlayerPos", -4.00, -148.00, 14, "#ffffff", [[0:0]])
	GUI:setAnchorPoint(PlayerPos, 1.00, 0.50)
	GUI:setTouchEnabled(PlayerPos, false)
	GUI:setTag(PlayerPos, -1)
	GUI:Text_enableOutline(PlayerPos, "#000000", 1)

	-- Create MapButton
	local MapButton = GUI:Button_Create(Node, "MapButton", -142.00, -1.00, "res/private/main/Button/1900012153.png")
	GUI:Button_loadTexturePressed(MapButton, "res/private/main/Button/1900012152.png")
	GUI:Button_setTitleText(MapButton, "")
	GUI:Button_setTitleColor(MapButton, "#ffffff")
	GUI:Button_setTitleFontSize(MapButton, 10)
	GUI:Button_titleEnableOutline(MapButton, "#000000", 1)
	GUI:setAnchorPoint(MapButton, 1.00, 1.00)
	GUI:setTouchEnabled(MapButton, true)
	GUI:setTag(MapButton, -1)

	-- Create MapButtonText
	local MapButtonText = GUI:Image_Create(MapButton, "MapButtonText", 20.00, 40.00, "res/private/main/Button_1/1900012301.png")
	GUI:setContentSize(MapButtonText, 26, 52)
	GUI:setIgnoreContentAdaptWithSize(MapButtonText, false)
	GUI:setAnchorPoint(MapButtonText, 0.50, 0.50)
	GUI:setTouchEnabled(MapButtonText, false)
	GUI:setTag(MapButtonText, -1)

	-- Create PKModelButton
	local PKModelButton = GUI:Button_Create(Node, "PKModelButton", -142.00, -80.00, "res/private/main/Button/1900012153.png")
	GUI:Button_setTitleText(PKModelButton, "")
	GUI:Button_setTitleColor(PKModelButton, "#ffffff")
	GUI:Button_setTitleFontSize(PKModelButton, 10)
	GUI:Button_titleEnableOutline(PKModelButton, "#000000", 1)
	GUI:setAnchorPoint(PKModelButton, 1.00, 1.00)
	GUI:setTouchEnabled(PKModelButton, true)
	GUI:setTag(PKModelButton, -1)

	-- Create PKModelButtonText
	local PKModelButtonText = GUI:Image_Create(PKModelButton, "PKModelButtonText", 20.00, 40.00, "res/private/main/Pattern/1900012200.png")
	GUI:setContentSize(PKModelButtonText, 26, 52)
	GUI:setIgnoreContentAdaptWithSize(PKModelButtonText, false)
	GUI:setAnchorPoint(PKModelButtonText, 0.50, 0.50)
	GUI:setTouchEnabled(PKModelButtonText, false)
	GUI:setTag(PKModelButtonText, -1)
end
return ui