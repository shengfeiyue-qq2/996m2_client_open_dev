local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "商城货币节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_1, "商城货币组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 18)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_1, "Image_5", 367.00, 32.00, "res/private/page_store_ui/page_store_ui_mobile/bg_scbtt_01.jpg")
	GUI:setChineseName(Image_5, "商城_可用货币_背景图")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 49)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 5.00, 10.00, 600.00, 40.00, 2)
	GUI:ListView_setGravity(ListView_cells, 3)
	GUI:setChineseName(ListView_cells, "商城_可用货币_列表")
	GUI:setTouchEnabled(ListView_cells, false)
	GUI:setTag(ListView_cells, 51)

	-- Create ScrollView_list
	local ScrollView_list = GUI:ScrollView_Create(Panel_1, "ScrollView_list", 1.00, 445.00, 730.00, 380.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_list, 770.00, 380.00)
	GUI:setChineseName(ScrollView_list, "商城_商品_列表")
	GUI:setAnchorPoint(ScrollView_list, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_list, true)
	GUI:setTag(ScrollView_list, 26)
end
return ui