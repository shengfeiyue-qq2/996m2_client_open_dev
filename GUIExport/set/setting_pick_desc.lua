local ui = {}
function ui.init(parent)
	-- Create Panel_PickDesc
	local Panel_PickDesc = GUI:Layout_Create(parent, "Panel_PickDesc", 0.00, 0.00, 732.00, 445.00, false)
	GUI:Layout_setBackGroundColorType(Panel_PickDesc, 1)
	GUI:Layout_setBackGroundColor(Panel_PickDesc, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_PickDesc, 127)
	GUI:setChineseName(Panel_PickDesc, "拾取查看组合")
	GUI:setTouchEnabled(Panel_PickDesc, true)
	GUI:setTag(Panel_PickDesc, 62)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_PickDesc, "Panel_2", 366.00, 222.00, 430.00, 445.00, false)
	GUI:setChineseName(Panel_2, "查看组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 54)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_2, "Image_4", 0.00, 0.00, "res/public/bg_npc_05.png")
	GUI:Image_setScale9Slice(Image_4, 80, 80, 69, 69)
	GUI:setContentSize(Image_4, 430, 447)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setChineseName(Image_4, "查看_背景图")
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 55)

	-- Create Panel_title
	local Panel_title = GUI:Layout_Create(Panel_2, "Panel_title", 0.00, 442.00, 430.00, 50.00, false)
	GUI:setChineseName(Panel_title, "查看标题组合")
	GUI:setAnchorPoint(Panel_title, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_title, true)
	GUI:setTag(Panel_title, 56)

	-- Create Text_type
	local Text_type = GUI:Text_Create(Panel_title, "Text_type", 90.00, 25.00, 16, "#ffffff", [[类型]])
	GUI:setChineseName(Text_type, "查看_类型_文本")
	GUI:setAnchorPoint(Text_type, 0.50, 0.50)
	GUI:setTouchEnabled(Text_type, false)
	GUI:setTag(Text_type, 57)
	GUI:Text_enableOutline(Text_type, "#000000", 1)

	-- Create Text_drop
	local Text_drop = GUI:Text_Create(Panel_title, "Text_drop", 200.00, 25.00, 16, "#ffffff", [[显示名字]])
	GUI:setChineseName(Text_drop, "查看_显示名字_文本")
	GUI:setAnchorPoint(Text_drop, 0.50, 0.50)
	GUI:setTouchEnabled(Text_drop, false)
	GUI:setTag(Text_drop, 58)
	GUI:Text_enableOutline(Text_drop, "#000000", 1)

	-- Create Text_pick
	local Text_pick = GUI:Text_Create(Panel_title, "Text_pick", 285.00, 25.00, 16, "#ffffff", [[手动拾取]])
	GUI:setChineseName(Text_pick, "查看_手动拾取_文本")
	GUI:setAnchorPoint(Text_pick, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pick, false)
	GUI:setTag(Text_pick, 59)
	GUI:Text_enableOutline(Text_pick, "#000000", 1)

	-- Create Text_pick_hang_up
	local Text_pick_hang_up = GUI:Text_Create(Panel_title, "Text_pick_hang_up", 370.00, 25.00, 16, "#ffffff", [[挂机拾取]])
	GUI:setChineseName(Text_pick_hang_up, "查看_挂机拾取_文本")
	GUI:setAnchorPoint(Text_pick_hang_up, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pick_hang_up, false)
	GUI:setTag(Text_pick_hang_up, 43)
	GUI:Text_enableOutline(Text_pick_hang_up, "#000000", 1)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_title, "Image_5", 215.00, 0.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_5, 430, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_5, false)
	GUI:setChineseName(Image_5, "查看_装饰条")
	GUI:setAnchorPoint(Image_5, 0.50, 0.00)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 60)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_2, "ListView_1", 215.00, 390.00, 430.00, 390.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setChineseName(ListView_1, "查看_物品列表")
	GUI:setAnchorPoint(ListView_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 61)
end
return ui