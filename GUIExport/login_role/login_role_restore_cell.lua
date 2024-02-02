local ui = {}
function ui.init(parent)
	-- Create restore_cell
	local restore_cell = GUI:Layout_Create(parent, "restore_cell", 0.00, 0.00, 300.00, 30.00, false)
	GUI:Layout_setBackGroundColorType(restore_cell, 1)
	GUI:Layout_setBackGroundColor(restore_cell, "#8b6914")
	GUI:Layout_setBackGroundColorOpacity(restore_cell, 102)
	GUI:setChineseName(restore_cell, "恢复角色层")
	GUI:setTouchEnabled(restore_cell, false)
	GUI:setTag(restore_cell, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(restore_cell, "Text_name", 15.00, 15.00, 20, "#ffffff", [[-]])
	GUI:setChineseName(Text_name, "恢复角色_角色昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(restore_cell, "Text_level", 170.00, 15.00, 20, "#ffffff", [[-]])
	GUI:setChineseName(Text_level, "恢复角色_角色等级_文本")
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
	GUI:setChineseName(btn_restore, "恢复角色_恢复角色_按钮")
	GUI:setAnchorPoint(btn_restore, 0.50, 0.50)
	GUI:setTouchEnabled(btn_restore, true)
	GUI:setTag(btn_restore, -1)
end
return ui