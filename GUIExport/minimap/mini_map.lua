local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "大地图节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(Node, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setChineseName(CloseLayout, "大地图_范围关闭区域")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(Panel_1, "大地图 _组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 20)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(Panel_1, "FrameLayout", 395.00, 268.00, 790.00, 536.00, false)
	GUI:setChineseName(FrameLayout, "大地图 _外组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "大地图 _背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "大地图 _装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 486.00, 20, "#d8c8ae", [[地图]])
	GUI:setChineseName(TitleText, "大地图 _标题_文本")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780.00, 477.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "大地图 _关闭_按钮")
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create Panel_map
	local Panel_map = GUI:Layout_Create(Panel_1, "Panel_map", 30.00, 34.00, 604.00, 442.00, true)
	GUI:setChineseName(Panel_map, "大地图 _内组合")
	GUI:setTouchEnabled(Panel_map, true)
	GUI:setTag(Panel_map, 21)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_map, "Image_bg", 302.00, 221.00, "res/private/minimap/1900012103.png")
	GUI:setChineseName(Image_bg, "大地图 _地图背景")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 54)

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Panel_map, "Panel_minimap", 303.00, 222.00, 604.00, 442.00, false)
	GUI:setChineseName(Panel_minimap, "大地图 _地图组合")
	GUI:setAnchorPoint(Panel_minimap, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_minimap, true)
	GUI:setTag(Panel_minimap, 39)

	-- Create Image_mini_map
	local Image_mini_map = GUI:Image_Create(Panel_minimap, "Image_mini_map", 302.00, 221.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_mini_map, "大地图 _大地图 _图")
	GUI:setAnchorPoint(Image_mini_map, 0.50, 0.50)
	GUI:setTouchEnabled(Image_mini_map, false)
	GUI:setTag(Image_mini_map, 40)

	-- Create Panel_event
	local Panel_event = GUI:Layout_Create(Panel_minimap, "Panel_event", 302.00, 221.00, 200.00, 200.00, false)
	GUI:setChineseName(Panel_event, "大地图 _事件")
	GUI:setAnchorPoint(Panel_event, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_event, true)
	GUI:setTag(Panel_event, 41)

	-- Create Node_path
	local Node_path = GUI:Node_Create(Panel_minimap, "Node_path", 0.00, 0.00)
	GUI:setChineseName(Node_path, "大地图 _节点路径")
	GUI:setAnchorPoint(Node_path, 0.50, 0.50)
	GUI:setTag(Node_path, 46)

	-- Create Image_point
	local Image_point = GUI:Layout_Create(Panel_minimap, "Image_point", 100.00, 80.00, 100.00, 24.00, false)
	GUI:Layout_setBackGroundImage(Image_point, "res/private/minimap/1900012108.png")
	GUI:Layout_setBackGroundColorType(Image_point, 1)
	GUI:Layout_setBackGroundColor(Image_point, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Image_point, 0)
	GUI:Layout_setBackGroundImageScale9Slice(Image_point, 22, 22, 5, 5)
	GUI:setChineseName(Image_point, "大地图 _坐标组合")
	GUI:setAnchorPoint(Image_point, 0.50, 0.50)
	GUI:setTouchEnabled(Image_point, true)
	GUI:setTag(Image_point, 48)

	-- Create Text_point
	local Text_point = GUI:Text_Create(Image_point, "Text_point", 50.00, 12.00, 15, "#00ff00", [[(123，123）]])
	GUI:setChineseName(Text_point, "大地图 _坐标_文本")
	GUI:setAnchorPoint(Text_point, 0.50, 0.50)
	GUI:setTouchEnabled(Text_point, false)
	GUI:setTag(Text_point, 49)
	GUI:Text_enableOutline(Text_point, "#000000", 1)

	-- Create Image_player
	local Image_player = GUI:Image_Create(Panel_minimap, "Image_player", 100.00, 50.00, "res/private/minimap/icon_xdtzy_02.png")
	GUI:setChineseName(Image_player, "大地图 _当前位置_图片")
	GUI:setAnchorPoint(Image_player, 0.50, 0.50)
	GUI:setTouchEnabled(Image_player, false)
	GUI:setTag(Image_player, 50)

	-- Create Image_mapNameBG
	local Image_mapNameBG = GUI:Image_Create(Panel_1, "Image_mapNameBG", 395.00, 510.00, "res/private/minimap/1900012107.png")
	GUI:setChineseName(Image_mapNameBG, "大地图 _地图标题_背景")
	GUI:setAnchorPoint(Image_mapNameBG, 0.50, 1.00)
	GUI:setTouchEnabled(Image_mapNameBG, false)
	GUI:setTag(Image_mapNameBG, -1)

	-- Create Text_mapName
	local Text_mapName = GUI:Text_Create(Panel_1, "Text_mapName", 395.00, 508.00, 16, "#ffffff", [[地图]])
	GUI:setChineseName(Text_mapName, "大地图 _地图名称_文本")
	GUI:setAnchorPoint(Text_mapName, 0.50, 1.00)
	GUI:setTouchEnabled(Text_mapName, false)
	GUI:setTag(Text_mapName, -1)
	GUI:Text_enableOutline(Text_mapName, "#000000", 1)
end
return ui