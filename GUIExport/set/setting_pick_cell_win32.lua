local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "拾取设置_节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 430.00, 60.00, false)
	GUI:setChineseName(Panel_1, "拾取设置_组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 45)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 90.00, 31.00, 12, "#ffffff", [[类型]])
	GUI:setChineseName(Text_name, "拾取设置_类型_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 46)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 215.00, 0.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_3, 430, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "拾取设置_装饰条")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 49)

	-- Create Panel_drop
	local Panel_drop = GUI:Layout_Create(Panel_1, "Panel_drop", 158.00, 8.00, 80.00, 40.00, false)
	GUI:setChineseName(Panel_drop, "拾取设置_名字勾选组合")
	GUI:setTouchEnabled(Panel_drop, true)
	GUI:setTag(Panel_drop, -1)

	-- Create CheckBox_drop
	local CheckBox_drop = GUI:CheckBox_Create(Panel_drop, "CheckBox_drop", 42.00, 21.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_drop, true)
	GUI:setChineseName(CheckBox_drop, "拾取设置_名字勾选")
	GUI:setAnchorPoint(CheckBox_drop, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_drop, false)
	GUI:setTag(CheckBox_drop, 47)

	-- Create Panel_pick
	local Panel_pick = GUI:Layout_Create(Panel_1, "Panel_pick", 243.00, 8.00, 80.00, 40.00, false)
	GUI:setChineseName(Panel_pick, "拾取设置_手动拾取组合")
	GUI:setTouchEnabled(Panel_pick, true)
	GUI:setTag(Panel_pick, -1)

	-- Create CheckBox_pick
	local CheckBox_pick = GUI:CheckBox_Create(Panel_pick, "CheckBox_pick", 42.00, 21.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_pick, true)
	GUI:setChineseName(CheckBox_pick, "拾取设置_手动拾取")
	GUI:setAnchorPoint(CheckBox_pick, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick, false)
	GUI:setTag(CheckBox_pick, 48)

	-- Create Panel_pick_hang_up
	local Panel_pick_hang_up = GUI:Layout_Create(Panel_1, "Panel_pick_hang_up", 328.00, 8.00, 80.00, 40.00, false)
	GUI:setChineseName(Panel_pick_hang_up, "拾取设置_挂机拾取组合")
	GUI:setTouchEnabled(Panel_pick_hang_up, true)
	GUI:setTag(Panel_pick_hang_up, -1)

	-- Create CheckBox_pick_hang_up
	local CheckBox_pick_hang_up = GUI:CheckBox_Create(Panel_pick_hang_up, "CheckBox_pick_hang_up", 42.00, 21.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox_pick_hang_up, true)
	GUI:setChineseName(CheckBox_pick_hang_up, "拾取设置_挂机拾取")
	GUI:setAnchorPoint(CheckBox_pick_hang_up, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick_hang_up, false)
	GUI:setTag(CheckBox_pick_hang_up, 36)
end
return ui