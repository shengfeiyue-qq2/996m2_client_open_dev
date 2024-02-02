local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "拾取设置标题节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_1, "拾取设置标题组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 8)

	-- Create Panel_title
	local Panel_title = GUI:Layout_Create(Panel_1, "Panel_title", 0.00, 445.00, 732.00, 35.00, false)
	GUI:setChineseName(Panel_title, "设置标题组合")
	GUI:setAnchorPoint(Panel_title, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_title, true)
	GUI:setTag(Panel_title, 12)

	-- Create Text_type
	local Text_type = GUI:Text_Create(Panel_title, "Text_type", 73.20, 17.50, 16, "#ffffff", [[类型]])
	GUI:setChineseName(Text_type, "拾取设置_类型_文本")
	GUI:setAnchorPoint(Text_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_type, false)
	GUI:setTag(Text_type, 13)
	GUI:Text_enableOutline(Text_type, "#000000", 1)

	-- Create Text_drop
	local Text_drop = GUI:Text_Create(Panel_title, "Text_drop", 219.60, 17.50, 16, "#ffffff", [[显示名字]])
	GUI:setChineseName(Text_drop, "拾取设置_显示名字_文本")
	GUI:setAnchorPoint(Text_drop, 0.50, 0.50)
	GUI:setTouchEnabled(Text_drop, false)
	GUI:setTag(Text_drop, 14)
	GUI:Text_enableOutline(Text_drop, "#000000", 1)

	-- Create Text_pick
	local Text_pick = GUI:Text_Create(Panel_title, "Text_pick", 366.00, 17.50, 16, "#ffffff", [[手动拾取]])
	GUI:setChineseName(Text_pick, "拾取设置_手动拾取_文本")
	GUI:setAnchorPoint(Text_pick, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pick, false)
	GUI:setTag(Text_pick, 15)
	GUI:Text_enableOutline(Text_pick, "#000000", 1)

	-- Create Text_pick_hang_up
	local Text_pick_hang_up = GUI:Text_Create(Panel_title, "Text_pick_hang_up", 512.40, 17.50, 16, "#ffffff", [[挂机拾取]])
	GUI:setChineseName(Text_pick_hang_up, "拾取设置_挂机拾取_文本")
	GUI:setAnchorPoint(Text_pick_hang_up, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pick_hang_up, false)
	GUI:setTag(Text_pick_hang_up, 39)
	GUI:Text_enableOutline(Text_pick_hang_up, "#000000", 1)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Panel_title, "Text_desc", 658.80, 17.50, 16, "#ffffff", [[详细信息]])
	GUI:setChineseName(Text_desc, "拾取设置_详细信息_文本")
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, false)
	GUI:setTag(Text_desc, 16)
	GUI:Text_enableOutline(Text_desc, "#000000", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_title, "Image_1", 366.00, 0.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1, "拾取设置_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 17)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 410.00, 732.00, 410.00, 1)
	GUI:ListView_setGravity(ListView_cells, 5)
	GUI:setChineseName(ListView_cells, "拾取设置_详细列表")
	GUI:setAnchorPoint(ListView_cells, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 12)
end
return ui