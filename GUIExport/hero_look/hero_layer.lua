local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 360.00, 340.00, 382.00, 571.00, false)
	GUI:setChineseName(Panel_1, "玩家面板_组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 2.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 191.00, 285.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015000.png")
	GUI:setChineseName(Image_bg, "玩家面板_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 3.0)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 191.00, 523.00, 18.0, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "玩家面板_玩家昵称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, true)
	GUI:setTag(Text_Name, 75.0)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1.0)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Panel_1, "ButtonClose", 397.00, 487.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 6.0, 12, 10.0)
	GUI:setContentSize(ButtonClose, 26.0, 42.0)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14.0)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "玩家面板_关闭按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 29.0)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Panel_1, "Node_panel", 17.00, 12.00)
	GUI:setChineseName(Node_panel, "玩家面板_节点")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 26.0)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 382.00, 456.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList, "玩家面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 26.0)

	-- Create Button_101
	local Button_101 = GUI:Button_Create(Panel_btnList, "Button_101", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_101, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_101, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_101, "")
	GUI:Button_setTitleColor(Button_101, "#ffffff")
	GUI:Button_setTitleFontSize(Button_101, 14.0)
	GUI:Button_titleDisableOutLine(Button_101)
	GUI:setChineseName(Button_101, "玩家面板_装备_按钮")
	GUI:setAnchorPoint(Button_101, 0.00, 1.00)
	GUI:setTouchEnabled(Button_101, true)
	GUI:setTag(Button_101, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_101, "Text_name", 13.00, 78.00, 16.0, "#807256", [[装
备]])
	GUI:setChineseName(Text_name, "玩家面板_装备_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_105
	local Button_105 = GUI:Button_Create(Panel_btnList, "Button_105", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_105, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_105, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_105, "")
	GUI:Button_setTitleColor(Button_105, "#ffffff")
	GUI:Button_setTitleFontSize(Button_105, 14.0)
	GUI:Button_titleDisableOutLine(Button_105)
	GUI:setChineseName(Button_105, "玩家面板_称号_按钮")
	GUI:setAnchorPoint(Button_105, 0.00, 1.00)
	GUI:setTouchEnabled(Button_105, true)
	GUI:setTag(Button_105, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_105, "Text_name", 13.00, 78.00, 16.0, "#807256", [[称
号]])
	GUI:setChineseName(Text_name, "玩家面板_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_106
	local Button_106 = GUI:Button_Create(Panel_btnList, "Button_106", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_106, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_106, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_106, "")
	GUI:Button_setTitleColor(Button_106, "#ffffff")
	GUI:Button_setTitleFontSize(Button_106, 14.0)
	GUI:Button_titleDisableOutLine(Button_106)
	GUI:setChineseName(Button_106, "玩家面板_时装_按钮")
	GUI:setAnchorPoint(Button_106, 0.00, 1.00)
	GUI:setTouchEnabled(Button_106, true)
	GUI:setTag(Button_106, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_106, "Text_name", 13.00, 78.00, 16.0, "#807256", [[时
装]])
	GUI:setChineseName(Text_name, "玩家面板_时装_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)
end
return ui