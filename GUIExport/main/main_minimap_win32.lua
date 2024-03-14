local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "小地图节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Node, "Panel_minimap", 0.00, 0.00, 112.00, 111.00, true)
	GUI:setChineseName(Panel_minimap, "小地图_组合")
	GUI:setAnchorPoint(Panel_minimap, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_minimap, true)
	GUI:setTag(Panel_minimap, 22)

	-- Create Image_minimap
	local Image_minimap = GUI:Image_Create(Panel_minimap, "Image_minimap", 0.00, 0.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_minimap, "小地图_图片")
	GUI:setTouchEnabled(Image_minimap, false)
	GUI:setTag(Image_minimap, 46)

	-- Create Node_actors
	local Node_actors = GUI:Node_Create(Image_minimap, "Node_actors", 0.00, 0.00)
	GUI:setChineseName(Node_actors, "小地图_节点")
	GUI:setAnchorPoint(Node_actors, 0.50, 0.50)
	GUI:setTag(Node_actors, 63)

	-- Create Node_player
	local Node_player = GUI:Node_Create(Panel_minimap, "Node_player", 0.00, 0.00)
	GUI:setChineseName(Node_player, "地图_区域节点")
	GUI:setAnchorPoint(Node_player, 0.50, 0.50)
	GUI:setTag(Node_player, 23)

	-- Create Text_mouse_pos
	local Text_mouse_pos = GUI:Text_Create(Panel_minimap, "Text_mouse_pos", 112.00, 0.00, 12, "#ffffff", [[99.99]])
	GUI:setChineseName(Text_mouse_pos, "小地图_坐标_文本")
	GUI:setAnchorPoint(Text_mouse_pos, 1.00, 0.00)
	GUI:setTouchEnabled(Text_mouse_pos, false)
	GUI:setTag(Text_mouse_pos, 60)
	GUI:Text_enableOutline(Text_mouse_pos, "#000000", 1)

	-- Create Image_mapFlag
	local Image_mapFlag = GUI:Image_Create(Node, "Image_mapFlag", 0.00, 0.00, "res/private/main-win32/00150.png")
	GUI:setChineseName(Image_mapFlag, "小地图_是否可战斗图标")
	GUI:setAnchorPoint(Image_mapFlag, 1.00, 1.00)
	GUI:setTouchEnabled(Image_mapFlag, false)
	GUI:setTag(Image_mapFlag, 65)
	GUI:setVisible(Image_mapFlag, false)
end
return ui