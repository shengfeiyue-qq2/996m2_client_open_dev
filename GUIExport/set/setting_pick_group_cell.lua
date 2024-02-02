local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 732.00, 45.00, false)
	GUI:setChineseName(Panel_1, "拾取组别组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 18)

	-- Create Text_type
	local Text_type = GUI:Text_Create(Panel_1, "Text_type", 73.20, 22.50, 16, "#ffffff", [[1-25级装备]])
	GUI:setChineseName(Text_type, "拾取设置_组别_文本")
	GUI:setAnchorPoint(Text_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_type, false)
	GUI:setTag(Text_type, 19)
	GUI:Text_enableOutline(Text_type, "#111111", 1)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Panel_1, "Text_desc", 658.00, 22.00, 16, "#ebf291", [[查看]])
	GUI:setChineseName(Text_desc, "拾取设置_查看_文本")
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, true)
	GUI:setTag(Text_desc, 22)
	GUI:Text_enableOutline(Text_desc, "#111111", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 366.00, 0.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_1, "拾取设置_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 23)

	-- Create Panel_drop
	local Panel_drop = GUI:Layout_Create(Panel_1, "Panel_drop", 169.00, 4.00, 120.00, 36.00, false)
	GUI:setChineseName(Panel_drop, "拾取设置_显示名字_组合")
	GUI:setTouchEnabled(Panel_drop, true)
	GUI:setTag(Panel_drop, -1)

	-- Create CheckBox_drop
	local CheckBox_drop = GUI:CheckBox_Create(Panel_drop, "CheckBox_drop", 50.00, 18.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:setContentSize(CheckBox_drop, 29, 28)
	GUI:setIgnoreContentAdaptWithSize(CheckBox_drop, false)
	GUI:CheckBox_setSelected(CheckBox_drop, true)
	GUI:setChineseName(CheckBox_drop, "拾取设置_显示名字_勾选")
	GUI:setAnchorPoint(CheckBox_drop, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_drop, false)
	GUI:setTag(CheckBox_drop, 24)

	-- Create Panel_pick
	local Panel_pick = GUI:Layout_Create(Panel_1, "Panel_pick", 317.00, 3.00, 120.00, 36.00, false)
	GUI:setChineseName(Panel_pick, "拾取设置_手动拾取_组合")
	GUI:setTouchEnabled(Panel_pick, true)
	GUI:setTag(Panel_pick, -1)

	-- Create CheckBox_pick
	local CheckBox_pick = GUI:CheckBox_Create(Panel_pick, "CheckBox_pick", 50.00, 18.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:setContentSize(CheckBox_pick, 29, 28)
	GUI:setIgnoreContentAdaptWithSize(CheckBox_pick, false)
	GUI:CheckBox_setSelected(CheckBox_pick, true)
	GUI:setChineseName(CheckBox_pick, "拾取设置_手动拾取_勾选")
	GUI:setAnchorPoint(CheckBox_pick, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick, false)
	GUI:setTag(CheckBox_pick, 24)

	-- Create Panel_pick_hang_up
	local Panel_pick_hang_up = GUI:Layout_Create(Panel_1, "Panel_pick_hang_up", 463.00, 3.00, 120.00, 36.00, false)
	GUI:setChineseName(Panel_pick_hang_up, "拾取设置_挂机拾取_组合")
	GUI:setTouchEnabled(Panel_pick_hang_up, true)
	GUI:setTag(Panel_pick_hang_up, -1)

	-- Create CheckBox_pick_hang_up
	local CheckBox_pick_hang_up = GUI:CheckBox_Create(Panel_pick_hang_up, "CheckBox_pick_hang_up", 50.00, 18.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:setContentSize(CheckBox_pick_hang_up, 29, 28)
	GUI:setIgnoreContentAdaptWithSize(CheckBox_pick_hang_up, false)
	GUI:CheckBox_setSelected(CheckBox_pick_hang_up, true)
	GUI:setChineseName(CheckBox_pick_hang_up, "拾取设置_挂机拾取_勾选")
	GUI:setAnchorPoint(CheckBox_pick_hang_up, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_pick_hang_up, false)
	GUI:setTag(CheckBox_pick_hang_up, 24)
end
return ui