local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "商城货币节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_1, "商城货币组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 53)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 0.00, 0.00, "res/private/page_store_ui/page_store_ui_win32/bg_scbtt_01.png")
	GUI:setContentSize(Image_3, 606, 50)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "商城_可用货币_背景图")
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 63)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 25.00, 600.00, 40.00, 2)
	GUI:ListView_setGravity(ListView_cells, 3)
	GUI:setChineseName(ListView_cells, "商城_可用货币_列表")
	GUI:setAnchorPoint(ListView_cells, 0.00, 0.50)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 57)

	-- Create ScrollView_list
	local ScrollView_list = GUI:ScrollView_Create(Panel_1, "ScrollView_list", 0.00, 390.00, 606.00, 340.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_list, 606.00, 340.00)
	GUI:setChineseName(ScrollView_list, "商城_商品_列表")
	GUI:setAnchorPoint(ScrollView_list, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_list, true)
	GUI:setTag(ScrollView_list, 61)
end
return ui