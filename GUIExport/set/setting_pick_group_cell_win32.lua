local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 606.00, 45.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 18)

	-- Create Text_type
	local Text_type = GUI:Text_Create(Panel_1, "Text_type", 60.00, 22.00, 12, "#ffffff", [[1-25级装备]])
	GUI:setAnchorPoint(Text_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_type, false)
	GUI:setTag(Text_type, 19)
	GUI:Text_enableOutline(Text_type, "#111111", 1)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Panel_1, "Text_desc", 545.00, 22.00, 12, "#ebf291", [[查看]])
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, true)
	GUI:setTag(Text_desc, 22)
	GUI:Text_enableOutline(Text_desc, "#111111", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 303.00, 0.00, "res/public/bg_yyxsz_01.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 23)

	-- Create Panel_drop
	local Panel_drop = GUI:Layout_Create(Panel_1, "Panel_drop", 125.00, 4.00, 110.00, 35.00, false)
	GUI:setTouchEnabled(Panel_drop, true)
	GUI:setTag(Panel_drop, -1)

	-- Create CheckBox_drop
	local CheckBox_drop = GUI:CheckBox_Create(Panel_drop, "CheckBox_drop", 60.00, 17.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_drop, true)
	GUI:setAnchorPoint(CheckBox_drop, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_drop, false)
	GUI:setTag(CheckBox_drop, 24)

	-- Create Panel_pick
	local Panel_pick = GUI:Layout_Create(Panel_1, "Panel_pick", 245.00, 4.00, 110.00, 35.00, false)
	GUI:setTouchEnabled(Panel_pick, true)
	GUI:setTag(Panel_pick, -1)

	-- Create CheckBox_pick
	local CheckBox_pick = GUI:CheckBox_Create(Panel_pick, "CheckBox_pick", 60.00, 17.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_pick, true)
	GUI:setAnchorPoint(CheckBox_pick, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick, false)
	GUI:setTag(CheckBox_pick, 25)

	-- Create Panel_pick_hang_up
	local Panel_pick_hang_up = GUI:Layout_Create(Panel_1, "Panel_pick_hang_up", 370.00, 4.00, 110.00, 35.00, false)
	GUI:setTouchEnabled(Panel_pick_hang_up, true)
	GUI:setTag(Panel_pick_hang_up, -1)

	-- Create CheckBox_pick_hang_up
	local CheckBox_pick_hang_up = GUI:CheckBox_Create(Panel_pick_hang_up, "CheckBox_pick_hang_up", 60.00, 17.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_pick_hang_up, true)
	GUI:setAnchorPoint(CheckBox_pick_hang_up, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick_hang_up, false)
	GUI:setTag(CheckBox_pick_hang_up, 18)
end
return ui