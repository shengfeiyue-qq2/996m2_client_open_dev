local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "英雄面板场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 654.00, 166.00, 305.00, 428.00, false)
	GUI:setChineseName(Panel_1, "英雄面板_组合")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 125)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 152.00, 214.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015000.png")
	GUI:setChineseName(Image_bg, "英雄面板_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 131)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 150.00, 392.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "英雄面板_英雄昵称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 132)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Panel_1, "ButtonClose", 312.00, 363.00, "res/public_win32/btn_02.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(ButtonClose, 7, 7, 11, 11)
	GUI:setContentSize(ButtonClose, 16, 27)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "英雄面板_关闭按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 133)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Panel_1, "Node_panel", 16.00, 14.00)
	GUI:setChineseName(Node_panel, "英雄面板_节点")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 134)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 304.00, 349.00, 24.00, 340.00, false)
	GUI:setChineseName(Panel_btnList, "英雄面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 130)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_btnList, "Button_1", 0.00, 340.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:setChineseName(Button_1, "英雄面板_装备_按钮")
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_1, "Text_name", 11.00, 62.00, 13, "#807256", [[装
备]])
	GUI:setChineseName(Text_name, "英雄面板_装备_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_btnList, "Button_2", 0.00, 283.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_2, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_2, 14)
	GUI:Button_titleDisableOutLine(Button_2)
	GUI:setChineseName(Button_2, "英雄面板_状态_按钮")
	GUI:setAnchorPoint(Button_2, 0.00, 1.00)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_2, "Text_name", 11.00, 62.00, 13, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "英雄面板_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_btnList, "Button_3", 0.00, 226.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_3, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_3, 14)
	GUI:Button_titleDisableOutLine(Button_3)
	GUI:setChineseName(Button_3, "英雄面板_属性_按钮")
	GUI:setAnchorPoint(Button_3, 0.00, 1.00)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_3, "Text_name", 11.00, 62.00, 13, "#807256", [[属
性]])
	GUI:setChineseName(Text_name, "英雄面板_属性_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_btnList, "Button_4", 0.00, 169.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_4, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_4, "")
	GUI:Button_setTitleColor(Button_4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_4, 14)
	GUI:Button_titleDisableOutLine(Button_4)
	GUI:setChineseName(Button_4, "英雄面板_技能_按钮")
	GUI:setAnchorPoint(Button_4, 0.00, 1.00)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_4, "Text_name", 11.00, 62.00, 13, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "英雄面板_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_6
	local Button_6 = GUI:Button_Create(Panel_btnList, "Button_6", 0.00, 112.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_6, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_6, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_6, "")
	GUI:Button_setTitleColor(Button_6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_6, 14)
	GUI:Button_titleDisableOutLine(Button_6)
	GUI:setChineseName(Button_6, "英雄面板_称号_按钮")
	GUI:setAnchorPoint(Button_6, 0.00, 1.00)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_6, "Text_name", 11.00, 62.00, 13, "#807256", [[称
号]])
	GUI:setChineseName(Text_name, "英雄面板_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_11
	local Button_11 = GUI:Button_Create(Panel_btnList, "Button_11", 0.00, 55.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
	GUI:Button_loadTexturePressed(Button_11, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_loadTextureDisabled(Button_11, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015010.png")
	GUI:Button_setTitleText(Button_11, "")
	GUI:Button_setTitleColor(Button_11, "#ffffff")
	GUI:Button_setTitleFontSize(Button_11, 14)
	GUI:Button_titleDisableOutLine(Button_11)
	GUI:setChineseName(Button_11, "英雄面板_时装_按钮")
	GUI:setAnchorPoint(Button_11, 0.00, 1.00)
	GUI:setTouchEnabled(Button_11, true)
	GUI:setTag(Button_11, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_11, "Text_name", 11.00, 62.00, 13, "#807256", [[时
装]])
	GUI:setChineseName(Text_name, "英雄面板_时装_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Panel_btnList_left
	local Panel_btnList_left = GUI:Layout_Create(Panel_1, "Panel_btnList_left", -24.00, 352.00, 24.00, 340.00, false)
	GUI:setChineseName(Panel_btnList_left, "英雄面板_左侧侧边条组合")
	GUI:setAnchorPoint(Panel_btnList_left, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList_left, false)
	GUI:setTag(Panel_btnList_left, 130)

	-- Create Button_20
	local Button_20 = GUI:Button_Create(Panel_btnList_left, "Button_20", 0.00, 340.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_20, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_20, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_20, "")
	GUI:Button_setTitleColor(Button_20, "#ffffff")
	GUI:Button_setTitleFontSize(Button_20, 14)
	GUI:Button_titleEnableOutline(Button_20, "#000000", 1)
	GUI:setChineseName(Button_20, "英雄面板_buff_按钮")
	GUI:setAnchorPoint(Button_20, 0.00, 1.00)
	GUI:setTouchEnabled(Button_20, true)
	GUI:setTag(Button_20, -1)
	GUI:setVisible(Button_20, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_20, "Text_name", 14.00, 62.00, 13, "#807256", [[天
赋]])
	GUI:setChineseName(Text_name, "英雄面板_buff_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)
end
return ui