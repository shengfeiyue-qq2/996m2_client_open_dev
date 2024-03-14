local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "采集节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 200.00, 80.00, 80.00, false)
	GUI:setChineseName(Panel_1, "采集_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 22)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 40.00, 48.00, "res/private/main/collect/btn_xbzy_03.png")
	GUI:setChineseName(Image_1, "采集_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 24)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 40.00, 48.00, "res/private/main/collect/bg_xbzy_02.png")
	GUI:setChineseName(Image_2, "采集_圆形图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 25)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 40.00, 0.00, "res/private/main/collect/bg_xbzy_01.png")
	GUI:setChineseName(Image_3, "采集_文字背景图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 27)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 40.00, 10.00, 16, "#ffffff", [[采集]])
	GUI:setChineseName(Text_1, "采集_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 26)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Layout_BG
	local Layout_BG = GUI:Layout_Create(Panel_1, "Layout_BG", 68.00, 50.00, 200.00, 120.00, false)
	GUI:Layout_setBackGroundImage(Layout_BG, "res/private/item_tips/bg_tipszy_05.png")
	GUI:Layout_setBackGroundImageScale9Slice(Layout_BG, 0, 135, 0, 173)
	GUI:setTouchEnabled(Layout_BG, false)
	GUI:setTag(Layout_BG, -1)

	-- Create List_Collect_Select
	local List_Collect_Select = GUI:ListView_Create(Panel_1, "List_Collect_Select", 68.00, 50.00, 200.00, 120.00, 1)
	GUI:ListView_setGravity(List_Collect_Select, 5)
	GUI:ListView_setItemsMargin(List_Collect_Select, 3)
	GUI:setTouchEnabled(List_Collect_Select, true)
	GUI:setTag(List_Collect_Select, -1)

	-- Create Layout_Item
	local Layout_Item = GUI:Layout_Create(Panel_1, "Layout_Item", 0.00, 0.00, 200.00, 40.00, false)
	GUI:setTouchEnabled(Layout_Item, true)
	GUI:setTag(Layout_Item, -1)
	GUI:setVisible(Layout_Item, false)

	-- Create Image_Icon
	local Image_Icon = GUI:Image_Create(Layout_Item, "Image_Icon", 10.00, 20.00, "res/private/main/Target/1900012536.png")
	GUI:setAnchorPoint(Image_Icon, 0.00, 0.50)
	GUI:setTouchEnabled(Image_Icon, false)
	GUI:setTag(Image_Icon, -1)

	-- Create Image_Name_Bg
	local Image_Name_Bg = GUI:Image_Create(Layout_Item, "Image_Name_Bg", 50.00, 20.00, "res/private/main/Target/1900012531.png")
	GUI:setAnchorPoint(Image_Name_Bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_Name_Bg, false)
	GUI:setTag(Image_Name_Bg, -1)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Layout_Item, "Text_Name", 116.00, 20.00, 15, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, -1)
	GUI:Text_enableOutline(Text_Name, "#000000", 1)
end
return ui