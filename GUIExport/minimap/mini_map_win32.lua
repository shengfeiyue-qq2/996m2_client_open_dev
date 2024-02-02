local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "大地图_节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 568.00, 320.00, 676.00, 508.00, false)
	GUI:setChineseName(Panel_1, "大地图_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 55)

	-- Create Panel_map
	local Panel_map = GUI:Layout_Create(Panel_1, "Panel_map", 0.00, 0.00, 676.00, 508.00, false)
	GUI:setChineseName(Panel_map, "大地图_组合")
	GUI:setTouchEnabled(Panel_map, false)
	GUI:setTag(Panel_map, 56)

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Panel_map, "Panel_minimap", 338.00, 254.00, 500.00, 350.00, false)
	GUI:setChineseName(Panel_minimap, "大地图_组合")
	GUI:setAnchorPoint(Panel_minimap, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_minimap, false)
	GUI:setTag(Panel_minimap, 58)

	-- Create Image_mini_map
	local Image_mini_map = GUI:Image_Create(Panel_minimap, "Image_mini_map", 250.00, 175.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_mini_map, "大地图_大地图_图片")
	GUI:setAnchorPoint(Image_mini_map, 0.50, 0.50)
	GUI:setTouchEnabled(Image_mini_map, false)
	GUI:setTag(Image_mini_map, 59)

	-- Create Panel_event
	local Panel_event = GUI:Layout_Create(Panel_minimap, "Panel_event", 250.00, 175.00, 200.00, 200.00, false)
	GUI:setChineseName(Panel_event, "大地图_事件")
	GUI:setAnchorPoint(Panel_event, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_event, true)
	GUI:setTag(Panel_event, 61)

	-- Create Node_monster
	local Node_monster = GUI:Node_Create(Panel_minimap, "Node_monster", 0.00, 0.00)
	GUI:setChineseName(Node_monster, "大地图_怪物节点")
	GUI:setAnchorPoint(Node_monster, 0.50, 0.50)
	GUI:setTag(Node_monster, 70)

	-- Create Node_team
	local Node_team = GUI:Node_Create(Panel_minimap, "Node_team", 0.00, 0.00)
	GUI:setChineseName(Node_team, "大地图_队友节点")
	GUI:setAnchorPoint(Node_team, 0.50, 0.50)
	GUI:setTag(Node_team, 71)

	-- Create Node_portals
	local Node_portals = GUI:Node_Create(Panel_minimap, "Node_portals", 0.00, 0.00)
	GUI:setChineseName(Node_portals, "大地图_描述节点")
	GUI:setAnchorPoint(Node_portals, 0.50, 0.50)
	GUI:setTag(Node_portals, 72)

	-- Create Node_path
	local Node_path = GUI:Node_Create(Panel_minimap, "Node_path", 0.00, 0.00)
	GUI:setChineseName(Node_path, "大地图_路径")
	GUI:setAnchorPoint(Node_path, 0.50, 0.50)
	GUI:setTag(Node_path, 62)

	-- Create Image_point
	local Image_point = GUI:Layout_Create(Panel_minimap, "Image_point", 100.00, 80.00, 100.00, 20.00, false)
	GUI:Layout_setBackGroundImage(Image_point, "res/private/minimap/1900012108.png")
	GUI:Layout_setBackGroundColorType(Image_point, 1)
	GUI:Layout_setBackGroundColor(Image_point, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Image_point, 0)
	GUI:Layout_setBackGroundImageScale9Slice(Image_point, 50, 50, 0, 0)
	GUI:setChineseName(Image_point, "大地图_坐标组合")
	GUI:setAnchorPoint(Image_point, 0.50, 0.50)
	GUI:setTouchEnabled(Image_point, false)
	GUI:setTag(Image_point, 63)

	-- Create Text_point
	local Text_point = GUI:Text_Create(Image_point, "Text_point", 50.00, 10.00, 12, "#00ff00", [[(123，123）]])
	GUI:setAnchorPoint(Text_point, 0.50, 0.50)
	GUI:setTouchEnabled(Text_point, false)
	GUI:setTag(Text_point, 64)
	GUI:Text_enableOutline(Text_point, "#000000", 1)

	-- Create Image_player
	local Image_player = GUI:Image_Create(Panel_minimap, "Image_player", 100.00, 50.00, "res/private/minimap/icon_xdtzy_02.png")
	GUI:setChineseName(Image_player, "大地图_玩家位置_图片")
	GUI:setAnchorPoint(Image_player, 0.50, 0.50)
	GUI:setTouchEnabled(Image_player, false)
	GUI:setTag(Image_player, 65)

	-- Create Text_mouse_pos
	local Text_mouse_pos = GUI:Text_Create(Panel_minimap, "Text_mouse_pos", 500.00, 0.00, 12, "#ffffff", [[99:99]])
	GUI:setChineseName(Text_mouse_pos, "大地图_鼠标指针_坐标")
	GUI:setAnchorPoint(Text_mouse_pos, 1.00, 0.00)
	GUI:setTouchEnabled(Text_mouse_pos, false)
	GUI:setTag(Text_mouse_pos, 12)
	GUI:Text_enableOutline(Text_mouse_pos, "#000000", 1)
end
return ui