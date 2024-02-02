local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 53)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 0.00, 0.00, "res/private/page_store_ui/page_store_ui_win32/bg_scbtt_01.png")
	GUI:setContentSize(Image_3, 606, 50)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 63)

	-- Create Panel_costcell
	local Panel_costcell = GUI:Layout_Create(Panel_1, "Panel_costcell", 0.00, 25.00, 200.00, 40.00, false)
	GUI:setAnchorPoint(Panel_costcell, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_costcell, true)
	GUI:setTag(Panel_costcell, 53)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_costcell, "Text_num", 46.00, 21.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 54)
	GUI:Text_enableOutline(Text_num, "#000000", 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_costcell, "Image_bg", 115.00, 21.00, "res/public/1900000668.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 55)

	-- Create Panel_icon
	local Panel_icon = GUI:Layout_Create(Panel_costcell, "Panel_icon", 20.00, 22.00, 0.00, 0.00, false)
	GUI:setTouchEnabled(Panel_icon, true)
	GUI:setTag(Panel_icon, 56)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 25.00, 600.00, 40.00, 2)
	GUI:ListView_setGravity(ListView_cells, 3)
	GUI:setAnchorPoint(ListView_cells, 0.00, 0.50)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 57)

	-- Create ScrollView_list
	local ScrollView_list = GUI:ScrollView_Create(Panel_1, "ScrollView_list", 0.00, 390.00, 606.00, 340.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_list, 606.00, 340.00)
	GUI:setAnchorPoint(ScrollView_list, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_list, true)
	GUI:setTag(ScrollView_list, 61)
end
return ui