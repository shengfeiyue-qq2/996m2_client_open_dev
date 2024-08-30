local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 360.00, 325.00, 305.00, 428.00, false)
	GUI:setChineseName(Panel_1, "玩家面板_组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 125.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 152.00, 214.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015000.png")
	GUI:setChineseName(Image_bg, "玩家面板_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 131.0)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 150.00, 392.00, 18.0, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "玩家面板_玩家昵称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 132.0)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1.0)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Panel_1, "ButtonClose", 312.00, 364.00, "res/public_win32/btn_02.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14.0)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "玩家面板_关闭按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 133.0)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Panel_1, "Node_panel", 16.00, 14.00)
	GUI:setChineseName(Node_panel, "玩家面板_节点")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 134.0)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 304.00, 348.00, 24.00, 340.00, false)
	GUI:setChineseName(Panel_btnList, "玩家面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 130.0)

	-- Create Button_101
	local Button_101 = GUI:Button_Create(Panel_btnList, "Button_101", 0.00, 340.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_101, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTextureDisabled(Button_101, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_101, "")
	GUI:Button_setTitleColor(Button_101, "#414146")
	GUI:Button_setTitleFontSize(Button_101, 14.0)
	GUI:Button_titleDisableOutLine(Button_101)
	GUI:setChineseName(Button_101, "玩家面板_装备_按钮")
	GUI:setAnchorPoint(Button_101, 0.00, 1.00)
	GUI:setTouchEnabled(Button_101, true)
	GUI:setTag(Button_101, 127.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_101, "Text_name", 11.00, 62.00, 13.0, "#807256", [[装
备]])
	GUI:setChineseName(Text_name, "玩家面板_装备_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 128.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_105
	local Button_105 = GUI:Button_Create(Panel_btnList, "Button_105", 0.00, 283.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_105, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_105, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_105, "")
	GUI:Button_setTitleColor(Button_105, "#414146")
	GUI:Button_setTitleFontSize(Button_105, 14.0)
	GUI:Button_titleDisableOutLine(Button_105)
	GUI:setChineseName(Button_105, "玩家面板_称号_按钮")
	GUI:setAnchorPoint(Button_105, 0.00, 1.00)
	GUI:setTouchEnabled(Button_105, true)
	GUI:setTag(Button_105, 127.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_105, "Text_name", 11.00, 62.00, 13.0, "#807256", [[称
号]])
	GUI:setChineseName(Text_name, "玩家面板_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 128.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_106
	local Button_106 = GUI:Button_Create(Panel_btnList, "Button_106", 0.00, 226.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_106, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_106, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_106, "")
	GUI:Button_setTitleColor(Button_106, "#414146")
	GUI:Button_setTitleFontSize(Button_106, 14.0)
	GUI:Button_titleDisableOutLine(Button_106)
	GUI:setChineseName(Button_106, "玩家面板_时装_按钮")
	GUI:setAnchorPoint(Button_106, 0.00, 1.00)
	GUI:setTouchEnabled(Button_106, true)
	GUI:setTag(Button_106, 127.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_106, "Text_name", 11.00, 62.00, 13.0, "#807256", [[时
装]])
	GUI:setChineseName(Text_name, "玩家面板_时装_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 128.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)
end
return ui