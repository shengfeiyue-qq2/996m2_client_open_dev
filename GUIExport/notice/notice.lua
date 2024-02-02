local ui = {}
function ui.init(parent)
	-- Create Node_notice
	local Node_notice = GUI:Node_Create(parent, "Node_notice", 0.00, 0.00)
	GUI:setAnchorPoint(Node_notice, 0.50, 0.50)
	GUI:setTag(Node_notice, -1)

	-- Create Node_server_tips
	local Node_server_tips = GUI:Node_Create(Node_notice, "Node_server_tips", 0.00, 640.00)
	GUI:setAnchorPoint(Node_server_tips, 0.50, 0.50)
	GUI:setTag(Node_server_tips, 78)

	-- Create Node_system
	local Node_system = GUI:Node_Create(Node_notice, "Node_system", 568.00, 640.00)
	GUI:setAnchorPoint(Node_system, 0.50, 0.50)
	GUI:setTag(Node_system, 15)

	-- Create Node_system_xy
	local Node_system_xy = GUI:Node_Create(Node_notice, "Node_system_xy", 0.00, 0.00)
	GUI:setAnchorPoint(Node_system_xy, 0.50, 0.50)
	GUI:setTag(Node_system_xy, 8)

	-- Create Node_system_tips
	local Node_system_tips = GUI:Node_Create(Node_notice, "Node_system_tips", 568.00, 320.00)
	GUI:setAnchorPoint(Node_system_tips, 0.50, 0.50)
	GUI:setTag(Node_system_tips, 15)

	-- Create Node_normal_tips
	local Node_normal_tips = GUI:Node_Create(Node_notice, "Node_normal_tips", 568.00, 240.00)
	GUI:setAnchorPoint(Node_normal_tips, 0.50, 0.50)
	GUI:setTag(Node_normal_tips, 16)

	-- Create Node_timer_tips
	local Node_timer_tips = GUI:Node_Create(Node_notice, "Node_timer_tips", 568.00, 250.00)
	GUI:setAnchorPoint(Node_timer_tips, 0.50, 0.50)
	GUI:setTag(Node_timer_tips, 5)

	-- Create ListView_timer_tips
	local ListView_timer_tips = GUI:ListView_Create(Node_timer_tips, "ListView_timer_tips", 0.00, 0.00, 200.00, 200.00, 1)
	GUI:ListView_setGravity(ListView_timer_tips, 2)
	GUI:setAnchorPoint(ListView_timer_tips, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_timer_tips, false)
	GUI:setTag(ListView_timer_tips, 6)
	GUI:ListView_setClippingEnabled(ListView_timer_tips,false)

	-- Create Node_item_tips
	local Node_item_tips = GUI:Node_Create(Node_notice, "Node_item_tips", 50.00, 300.00)
	GUI:setAnchorPoint(Node_item_tips, 0.50, 0.50)
	GUI:setTag(Node_item_tips, 7)

	-- Create Node_attribute
	local Node_attribute = GUI:Node_Create(Node_notice, "Node_attribute", 850.00, 500.00)
	GUI:setAnchorPoint(Node_attribute, 0.50, 0.50)
	GUI:setTag(Node_attribute, 9)

	-- Create Node_timer_xy_tips
	local Node_timer_xy_tips = GUI:Node_Create(Node_notice, "Node_timer_xy_tips", 568.00, 250.00)
	GUI:setAnchorPoint(Node_timer_xy_tips, 0.50, 0.50)
	GUI:setTag(Node_timer_xy_tips, 10)

	-- Create Node_drop_tips
	local Node_drop_tips = GUI:Node_Create(Node_notice, "Node_drop_tips", 568.00, 590.00)
	GUI:setAnchorPoint(Node_drop_tips, 0.50, 0.50)
	GUI:setTag(Node_drop_tips, 11)
end
return ui