local ui = {}
function ui.init(parent)
	-- Create LayoutClip
	local LayoutClip = GUI:Layout_Create(parent, "LayoutClip", 0.00, 0.00, 640.00, 160.00, true)
	GUI:setChineseName(LayoutClip, "小地图面板")
	GUI:setAnchorPoint(LayoutClip, 1.00, 1.00)
	GUI:setTouchEnabled(LayoutClip, false)
	GUI:setTag(LayoutClip, -1)

	-- Create Node
	local Node = GUI:Node_Create(LayoutClip, "Node", 640.00, 160.00)
	GUI:setChineseName(Node, "小地图节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create PKModelCell
	local PKModelCell = GUI:Layout_Create(Node, "PKModelCell", -142.00, -80.00, 400.00, 80.00, false)
	GUI:setChineseName(PKModelCell, "攻击模式组合")
	GUI:setAnchorPoint(PKModelCell, 1.00, 1.00)
	GUI:setTouchEnabled(PKModelCell, false)
	GUI:setTag(PKModelCell, -1)
	GUI:setVisible(PKModelCell, false)

	-- Create PKModelCellsBg
	local PKModelCellsBg = GUI:Image_Create(PKModelCell, "PKModelCellsBg", 0.00, 40.00, "res/private/main/Button/1900012160.png")
	GUI:Image_setScale9Slice(PKModelCellsBg, 29, 29, 10, 10)
	GUI:setContentSize(PKModelCellsBg, 400, 80)
	GUI:setIgnoreContentAdaptWithSize(PKModelCellsBg, false)
	GUI:setChineseName(PKModelCellsBg, "攻击模式_背景图")
	GUI:setAnchorPoint(PKModelCellsBg, 0.00, 0.50)
	GUI:setTouchEnabled(PKModelCellsBg, false)
	GUI:setTag(PKModelCellsBg, -1)

	-- Create PKModelListView
	local PKModelListView = GUI:ListView_Create(PKModelCell, "PKModelListView", 0.00, 40.00, 400.00, 80.00, 2)
	GUI:ListView_setGravity(PKModelListView, 5)
	GUI:setChineseName(PKModelListView, "攻击模式_模式_列表")
	GUI:setAnchorPoint(PKModelListView, 0.00, 0.50)
	GUI:setTouchEnabled(PKModelListView, false)
	GUI:setTag(PKModelListView, -1)

	-- Create MapBG
	local MapBG = GUI:Image_Create(Node, "MapBG", 0.00, -30.00, "res/private/main/miniMap/1900012101.png")
	GUI:setChineseName(MapBG, "小地图_背景图")
	GUI:setAnchorPoint(MapBG, 1.00, 1.00)
	GUI:setTouchEnabled(MapBG, false)
	GUI:setTag(MapBG, -1)

	-- Create Map
	local Map = GUI:Layout_Create(Node, "Map", -4.00, -34.00, 133.00, 122.00, true)
	GUI:setChineseName(Map, "小地图组合")
	GUI:setAnchorPoint(Map, 1.00, 1.00)
	GUI:setTouchEnabled(Map, false)
	GUI:setTag(Map, -1)

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Map, "Panel_minimap", 71.00, 130.00, 143.00, 131.00, true)
	GUI:setChineseName(Panel_minimap, "小地图组合")
	GUI:setAnchorPoint(Panel_minimap, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_minimap, true)
	GUI:setTag(Panel_minimap, 22)

	-- Create Image_minimap
	local Image_minimap = GUI:Image_Create(Panel_minimap, "Image_minimap", 0.00, 0.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_minimap, 143, 131)
	GUI:setIgnoreContentAdaptWithSize(Image_minimap, false)
	GUI:setChineseName(Image_minimap, "小地图组合")
	GUI:setTouchEnabled(Image_minimap, false)
	GUI:setTag(Image_minimap, 46)

	-- Create Node_actors
	local Node_actors = GUI:Node_Create(Image_minimap, "Node_actors", 0.00, 0.00)
	GUI:setChineseName(Node_actors, "小地图_其他对象")
	GUI:setAnchorPoint(Node_actors, 0.50, 0.50)
	GUI:setTag(Node_actors, 40)

	-- Create Node_path
	local Node_path = GUI:Node_Create(Image_minimap, "Node_path", 0.00, 0.00)
	GUI:setChineseName(Node_path, "小地图_路径_节点")
	GUI:setAnchorPoint(Node_path, 0.50, 0.50)
	GUI:setTag(Node_path, 139)

	-- Create Node_player
	local Node_player = GUI:Node_Create(Panel_minimap, "Node_player", 0.00, 0.00)
	GUI:setChineseName(Node_player, "小地图_玩家_节点")
	GUI:setAnchorPoint(Node_player, 0.50, 0.50)
	GUI:setTag(Node_player, 23)

	-- Create Image_empty
	local Image_empty = GUI:Image_Create(Node, "Image_empty", -4.00, -35.00, "res/private/main/miniMap/1900012102.png")
	GUI:setContentSize(Image_empty, 133.5, 122)
	GUI:setIgnoreContentAdaptWithSize(Image_empty, false)
	GUI:setChineseName(Image_empty, "无小地图时_图片")
	GUI:setAnchorPoint(Image_empty, 1.00, 1.00)
	GUI:setTouchEnabled(Image_empty, false)
	GUI:setTag(Image_empty, -1)
	GUI:setVisible(Image_empty, false)

	-- Create MapNameBG
	local MapNameBG = GUI:Image_Create(Node, "MapNameBG", 0.00, 0.00, "res/private/main/miniMap/1900012100.png")
	GUI:setChineseName(MapNameBG, "小地图_名字_背景")
	GUI:setAnchorPoint(MapNameBG, 1.00, 1.00)
	GUI:setTouchEnabled(MapNameBG, false)
	GUI:setTag(MapNameBG, -1)

	-- Create MapName
	local MapName = GUI:Text_Create(Node, "MapName", -70.00, -15.00, 16, "#ffffff", [[-]])
	GUI:setChineseName(MapName, "小地图_名字_文本")
	GUI:setAnchorPoint(MapName, 0.50, 0.50)
	GUI:setTouchEnabled(MapName, false)
	GUI:setTag(MapName, -1)
	GUI:Text_enableOutline(MapName, "#000000", 1)

	-- Create MapStatusBG
	local MapStatusBG = GUI:Layout_Create(Node, "MapStatusBG", -4.00, -146.00, 135.00, 17.00, false)
	GUI:Layout_setBackGroundColorType(MapStatusBG, 1)
	GUI:Layout_setBackGroundColor(MapStatusBG, "#000000")
	GUI:Layout_setBackGroundColorOpacity(MapStatusBG, 100)
	GUI:setChineseName(MapStatusBG, "小地图_状态_背景图")
	GUI:setAnchorPoint(MapStatusBG, 1.00, 0.50)
	GUI:setTouchEnabled(MapStatusBG, false)
	GUI:setTag(MapStatusBG, -1)

	-- Create MapStatus
	local MapStatus = GUI:Text_Create(Node, "MapStatus", -136.00, -148.00, 14, "#ffffff", [[安全区域]])
	GUI:setChineseName(MapStatus, "小地图_状态_文本")
	GUI:setAnchorPoint(MapStatus, 0.00, 0.50)
	GUI:setTouchEnabled(MapStatus, false)
	GUI:setTag(MapStatus, -1)
	GUI:Text_enableOutline(MapStatus, "#000000", 1)

	-- Create PlayerPos
	local PlayerPos = GUI:Text_Create(Node, "PlayerPos", -4.00, -148.00, 14, "#ffffff", [[0:0]])
	GUI:setChineseName(PlayerPos, "玩家_坐标_文本")
	GUI:setAnchorPoint(PlayerPos, 1.00, 0.50)
	GUI:setTouchEnabled(PlayerPos, false)
	GUI:setTag(PlayerPos, -1)
	GUI:Text_enableOutline(PlayerPos, "#000000", 1)

	-- Create MapButton
	local MapButton = GUI:Button_Create(Node, "MapButton", -140.00, 0.00, "res/private/main/Button/1900012153.png")
	GUI:Button_loadTexturePressed(MapButton, "res/private/main/Button/1900012152.png")
	GUI:Button_setTitleText(MapButton, "")
	GUI:Button_setTitleColor(MapButton, "#ffffff")
	GUI:Button_setTitleFontSize(MapButton, 10)
	GUI:Button_titleEnableOutline(MapButton, "#000000", 1)
	GUI:setChineseName(MapButton, "地图_按钮组合")
	GUI:setAnchorPoint(MapButton, 1.00, 1.00)
	GUI:setTouchEnabled(MapButton, true)
	GUI:setTag(MapButton, -1)

	-- Create MapButtonText
	local MapButtonText = GUI:Image_Create(MapButton, "MapButtonText", 23.00, 40.00, "res/private/main/Button_1/1900012301.png")
	GUI:setContentSize(MapButtonText, 26, 52)
	GUI:setIgnoreContentAdaptWithSize(MapButtonText, false)
	GUI:setChineseName(MapButtonText, "地图_按钮_文本")
	GUI:setAnchorPoint(MapButtonText, 0.50, 0.50)
	GUI:setTouchEnabled(MapButtonText, false)
	GUI:setTag(MapButtonText, -1)

	-- Create PKModelButton
	local PKModelButton = GUI:Button_Create(Node, "PKModelButton", -140.00, -80.00, "res/private/main/Button/1900012153.png")
	GUI:Button_setTitleText(PKModelButton, "")
	GUI:Button_setTitleColor(PKModelButton, "#ffffff")
	GUI:Button_setTitleFontSize(PKModelButton, 10)
	GUI:Button_titleEnableOutline(PKModelButton, "#000000", 1)
	GUI:setChineseName(PKModelButton, "攻击模式_按钮组合")
	GUI:setAnchorPoint(PKModelButton, 1.00, 1.00)
	GUI:setTouchEnabled(PKModelButton, true)
	GUI:setTag(PKModelButton, -1)

	-- Create PKModelButtonText
	local PKModelButtonText = GUI:Image_Create(PKModelButton, "PKModelButtonText", 22.00, 40.00, "res/private/main/Pattern/1900012200.png")
	GUI:setContentSize(PKModelButtonText, 26, 52)
	GUI:setIgnoreContentAdaptWithSize(PKModelButtonText, false)
	GUI:setChineseName(PKModelButtonText, "攻击模式_按钮_文本")
	GUI:setAnchorPoint(PKModelButtonText, 0.50, 0.50)
	GUI:setTouchEnabled(PKModelButtonText, false)
	GUI:setTag(PKModelButtonText, -1)
end
return ui