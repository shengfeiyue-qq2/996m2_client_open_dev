local ui = {}
function ui.init(parent)
	-- Create Layout_restore
	local Layout_restore = GUI:Layout_Create(parent, "Layout_restore", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Layout_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Layout_restore, false)
	GUI:setTag(Layout_restore, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layout_restore, "Panel_1", 568.00, 570.00, 350.00, 420.00, false)
	GUI:Layout_setBackGroundColorType(Panel_1, 1)
	GUI:Layout_setBackGroundColor(Panel_1, "#4d4d4d")
	GUI:Layout_setBackGroundColorOpacity(Panel_1, 102)
	GUI:setAnchorPoint(Panel_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 80.00, 400.00, 20, "#ffffff", [[角色名字]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_1, "Text_1_0", 200.00, 400.00, 20, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, -1)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 19.00, 12.00, 300.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:ListView_setItemsMargin(ListView_1, 8)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, -1)

	-- Create restore_cell
	local restore_cell = GUI:Layout_Create(Panel_1, "restore_cell", 0.00, 0.00, 300.00, 30.00, false)
	GUI:Layout_setBackGroundColorType(restore_cell, 1)
	GUI:Layout_setBackGroundColor(restore_cell, "#8b6914")
	GUI:Layout_setBackGroundColorOpacity(restore_cell, 102)
	GUI:setTouchEnabled(restore_cell, false)
	GUI:setTag(restore_cell, -1)
	GUI:setVisible(restore_cell, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(restore_cell, "Text_name", 15.00, 15.00, 20, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(restore_cell, "Text_level", 170.00, 15.00, 20, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, -1)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create btn_restore
	local btn_restore = GUI:Button_Create(restore_cell, "btn_restore", 255.00, 15.00, "Default/Button_Normal.png")
	GUI:Button_setScale9Slice(btn_restore, 16, 14, 13, 9)
	GUI:setContentSize(btn_restore, 80, 28)
	GUI:setIgnoreContentAdaptWithSize(btn_restore, false)
	GUI:Button_setTitleText(btn_restore, "恢复角色")
	GUI:Button_setTitleColor(btn_restore, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_restore, 18)
	GUI:Button_titleEnableOutline(btn_restore, "#000000", 1)
	GUI:setAnchorPoint(btn_restore, 0.50, 0.50)
	GUI:setTouchEnabled(btn_restore, true)
	GUI:setTag(btn_restore, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 330.00, 400.00, "res/public/btn_normal_2.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/btn_pressed_2.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)
end
return ui