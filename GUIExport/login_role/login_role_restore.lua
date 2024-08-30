local ui = {}
function ui.init(parent)
	-- Create Layout_restore
	local Layout_restore = GUI:Layout_Create(parent, "Layout_restore", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Layout_restore, "恢复角色面板")
	GUI:setAnchorPoint(Layout_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Layout_restore, false)
	GUI:setTag(Layout_restore, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layout_restore, "Panel_1", 568.00, 570.00, 350.00, 420.00, false)
	GUI:Layout_setBackGroundColorType(Panel_1, 1)
	GUI:Layout_setBackGroundColor(Panel_1, "#4d4d4d")
	GUI:Layout_setBackGroundColorOpacity(Panel_1, 102)
	GUI:setChineseName(Panel_1, "恢复角色组合")
	GUI:setAnchorPoint(Panel_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_1, "Text_1", 80.00, 400.00, 20, "#ffffff", [[角色名字]])
	GUI:setChineseName(Text_1, "恢复角色_角色名字_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_1_0
	local Text_1_0 = GUI:Text_Create(Panel_1, "Text_1_0", 200.00, 400.00, 20, "#ffffff", [[等级]])
	GUI:setChineseName(Text_1_0, "恢复角色_等级_文本")
	GUI:setAnchorPoint(Text_1_0, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1_0, false)
	GUI:setTag(Text_1_0, -1)
	GUI:Text_enableOutline(Text_1_0, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 19.00, 12.00, 300.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:ListView_setItemsMargin(ListView_1, 8)
	GUI:setChineseName(ListView_1, "恢复角色_可恢复_列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 330.00, 400.00, "res/public/btn_normal_2.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/btn_pressed_2.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setChineseName(Button_close, "恢复角色_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)
end
return ui