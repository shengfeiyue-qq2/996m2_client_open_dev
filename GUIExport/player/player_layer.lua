local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "玩家面板场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 900.00, 340.00, 382.00, 598.00, false)
	GUI:setChineseName(Panel_1, "玩家面板_组合")
	GUI:setAnchorPoint(Panel_1, 1.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 2)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 191.00, 300.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015000.png")
	GUI:setChineseName(Image_bg, "玩家面板_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 3)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 190.00, 540.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "玩家面板_玩家昵称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 75)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Panel_1, "ButtonClose", 394.00, 502.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(ButtonClose, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 6, 12, 10)
	GUI:setContentSize(ButtonClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "玩家面板_关闭按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 29)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Panel_1, "Node_panel", 18.00, 30.00)
	GUI:setChineseName(Node_panel, "玩家面板_节点")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 26)

	-- Create topLayout
	local topLayout = GUI:Layout_Create(Panel_1, "topLayout", 191.00, 494.00, 164.00, 35.00, false)
	GUI:setChineseName(topLayout, "玩家_基础与内功切换_组合")
	GUI:setAnchorPoint(topLayout, 0.50, 0.00)
	GUI:setTouchEnabled(topLayout, false)
	GUI:setTag(topLayout, -1)
	GUI:setVisible(topLayout, false)

	-- Create base_btn
	local base_btn = GUI:Button_Create(topLayout, "base_btn", -8.00, 3.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_2.png")
	GUI:Button_loadTexturePressed(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_loadTextureDisabled(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_setTitleText(base_btn, "")
	GUI:Button_setTitleColor(base_btn, "#ffffff")
	GUI:Button_setTitleFontSize(base_btn, 16)
	GUI:Button_titleEnableOutline(base_btn, "#000000", 1)
	GUI:setChineseName(base_btn, "玩家面板_基础_按钮")
	GUI:setTouchEnabled(base_btn, true)
	GUI:setTag(base_btn, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(base_btn, "Text_1", 38.00, 16.00, 16, "#807256", [[基础]])
	GUI:setChineseName(Text_1, "玩家面板_基础_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#111111", 2)

	-- Create ng_btn
	local ng_btn = GUI:Button_Create(topLayout, "ng_btn", 64.00, 3.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_2.png")
	GUI:Button_loadTexturePressed(ng_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_loadTextureDisabled(ng_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_setTitleText(ng_btn, "")
	GUI:Button_setTitleColor(ng_btn, "#ffffff")
	GUI:Button_setTitleFontSize(ng_btn, 16)
	GUI:Button_titleEnableOutline(ng_btn, "#000000", 1)
	GUI:setChineseName(ng_btn, "玩家内功面板_内功")
	GUI:setTouchEnabled(ng_btn, true)
	GUI:setTag(ng_btn, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(ng_btn, "Text_1", 38.00, 16.00, 16, "#807256", [[内功]])
	GUI:setChineseName(Text_1, "玩家内功面板_内功_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#111111", 2)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 382.00, 478.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList, "玩家面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 26)

	-- Create Button_101
	local Button_101 = GUI:Button_Create(Panel_btnList, "Button_101", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_101, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_101, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_101, "")
	GUI:Button_setTitleColor(Button_101, "#ffffff")
	GUI:Button_setTitleFontSize(Button_101, 14)
	GUI:Button_titleEnableOutline(Button_101, "#000000", 1)
	GUI:setChineseName(Button_101, "玩家面板_装备_按钮")
	GUI:setAnchorPoint(Button_101, 0.00, 1.00)
	GUI:setTouchEnabled(Button_101, true)
	GUI:setTag(Button_101, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_101, "Text_name", 13.00, 78.00, 16, "#807256", [[装
备]])
	GUI:setChineseName(Text_name, "玩家面板_装备_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_102
	local Button_102 = GUI:Button_Create(Panel_btnList, "Button_102", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_102, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_102, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_102, "")
	GUI:Button_setTitleColor(Button_102, "#ffffff")
	GUI:Button_setTitleFontSize(Button_102, 14)
	GUI:Button_titleEnableOutline(Button_102, "#000000", 1)
	GUI:setChineseName(Button_102, "玩家面板_状态_按钮")
	GUI:setAnchorPoint(Button_102, 0.00, 1.00)
	GUI:setTouchEnabled(Button_102, true)
	GUI:setTag(Button_102, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_102, "Text_name", 13.00, 78.00, 16, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "玩家面板_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_103
	local Button_103 = GUI:Button_Create(Panel_btnList, "Button_103", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_103, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_103, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_103, "")
	GUI:Button_setTitleColor(Button_103, "#ffffff")
	GUI:Button_setTitleFontSize(Button_103, 14)
	GUI:Button_titleEnableOutline(Button_103, "#000000", 1)
	GUI:setChineseName(Button_103, "玩家面板_属性_按钮")
	GUI:setAnchorPoint(Button_103, 0.00, 1.00)
	GUI:setTouchEnabled(Button_103, true)
	GUI:setTag(Button_103, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_103, "Text_name", 13.00, 78.00, 16, "#807256", [[属
性]])
	GUI:setChineseName(Text_name, "玩家面板_属性_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_104
	local Button_104 = GUI:Button_Create(Panel_btnList, "Button_104", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_104, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_104, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_104, "")
	GUI:Button_setTitleColor(Button_104, "#ffffff")
	GUI:Button_setTitleFontSize(Button_104, 14)
	GUI:Button_titleEnableOutline(Button_104, "#000000", 1)
	GUI:setChineseName(Button_104, "玩家面板_技能_按钮")
	GUI:setAnchorPoint(Button_104, 0.00, 1.00)
	GUI:setTouchEnabled(Button_104, true)
	GUI:setTag(Button_104, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_104, "Text_name", 13.00, 78.00, 16, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "玩家面板_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_105
	local Button_105 = GUI:Button_Create(Panel_btnList, "Button_105", 0.00, 166.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_105, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_105, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_105, "")
	GUI:Button_setTitleColor(Button_105, "#ffffff")
	GUI:Button_setTitleFontSize(Button_105, 14)
	GUI:Button_titleEnableOutline(Button_105, "#000000", 1)
	GUI:setChineseName(Button_105, "玩家面板_称号_按钮")
	GUI:setAnchorPoint(Button_105, 0.00, 1.00)
	GUI:setTouchEnabled(Button_105, true)
	GUI:setTag(Button_105, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_105, "Text_name", 13.00, 78.00, 16, "#807256", [[称
号]])
	GUI:setChineseName(Text_name, "玩家面板_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_106
	local Button_106 = GUI:Button_Create(Panel_btnList, "Button_106", 0.00, 94.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_106, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_106, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_106, "")
	GUI:Button_setTitleColor(Button_106, "#ffffff")
	GUI:Button_setTitleFontSize(Button_106, 14)
	GUI:Button_titleEnableOutline(Button_106, "#000000", 1)
	GUI:setChineseName(Button_106, "玩家面板_时装_按钮")
	GUI:setAnchorPoint(Button_106, 0.00, 1.00)
	GUI:setTouchEnabled(Button_106, true)
	GUI:setTag(Button_106, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_106, "Text_name", 13.00, 78.00, 16, "#807256", [[时
装]])
	GUI:setChineseName(Text_name, "玩家面板_时装_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Panel_btnList_ng
	local Panel_btnList_ng = GUI:Layout_Create(Panel_1, "Panel_btnList_ng", 382.00, 478.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList_ng, "玩家内功面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList_ng, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList_ng, false)
	GUI:setTag(Panel_btnList_ng, 26)
	GUI:setVisible(Panel_btnList_ng, false)

	-- Create Button_701
	local Button_701 = GUI:Button_Create(Panel_btnList_ng, "Button_701", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_701, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_701, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_701, "")
	GUI:Button_setTitleColor(Button_701, "#ffffff")
	GUI:Button_setTitleFontSize(Button_701, 14)
	GUI:Button_titleEnableOutline(Button_701, "#000000", 1)
	GUI:setChineseName(Button_701, "玩家内功面板_状态_按钮")
	GUI:setAnchorPoint(Button_701, 0.00, 1.00)
	GUI:setTouchEnabled(Button_701, true)
	GUI:setTag(Button_701, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_701, "Text_name", 13.00, 78.00, 16, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "玩家内功面板_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_702
	local Button_702 = GUI:Button_Create(Panel_btnList_ng, "Button_702", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_702, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_702, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_702, "")
	GUI:Button_setTitleColor(Button_702, "#ffffff")
	GUI:Button_setTitleFontSize(Button_702, 14)
	GUI:Button_titleEnableOutline(Button_702, "#000000", 1)
	GUI:setChineseName(Button_702, "玩家内功面板_技能_按钮")
	GUI:setAnchorPoint(Button_702, 0.00, 1.00)
	GUI:setTouchEnabled(Button_702, true)
	GUI:setTag(Button_702, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_702, "Text_name", 13.00, 78.00, 16, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "玩家内功面板_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_703
	local Button_703 = GUI:Button_Create(Panel_btnList_ng, "Button_703", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_703, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_703, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_703, "")
	GUI:Button_setTitleColor(Button_703, "#ffffff")
	GUI:Button_setTitleFontSize(Button_703, 14)
	GUI:Button_titleEnableOutline(Button_703, "#000000", 1)
	GUI:setChineseName(Button_703, "玩家内功面板_经络_按钮")
	GUI:setAnchorPoint(Button_703, 0.00, 1.00)
	GUI:setTouchEnabled(Button_703, true)
	GUI:setTag(Button_703, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_703, "Text_name", 13.00, 78.00, 16, "#807256", [[经
络]])
	GUI:setChineseName(Text_name, "玩家内功面板_经络_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_704
	local Button_704 = GUI:Button_Create(Panel_btnList_ng, "Button_704", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_704, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_704, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_704, "")
	GUI:Button_setTitleColor(Button_704, "#ffffff")
	GUI:Button_setTitleFontSize(Button_704, 14)
	GUI:Button_titleEnableOutline(Button_704, "#000000", 1)
	GUI:setChineseName(Button_704, "玩家内功面板_连击_按钮")
	GUI:setAnchorPoint(Button_704, 0.00, 1.00)
	GUI:setTouchEnabled(Button_704, true)
	GUI:setTag(Button_704, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_704, "Text_name", 13.00, 78.00, 16, "#807256", [[连
击]])
	GUI:setChineseName(Text_name, "玩家内功面板_连击_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Panel_btnList_left
	local Panel_btnList_left = GUI:Layout_Create(Panel_1, "Panel_btnList_left", -32.00, 478.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList_left, "玩家面板_左侧侧边条组合")
	GUI:setAnchorPoint(Panel_btnList_left, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList_left, false)
	GUI:setTag(Panel_btnList_left, 26)

	-- Create Button_112
	local Button_112 = GUI:Button_Create(Panel_btnList_left, "Button_112", 0.00, 454.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_112, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_112, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_112, "")
	GUI:Button_setTitleColor(Button_112, "#ffffff")
	GUI:Button_setTitleFontSize(Button_112, 14)
	GUI:Button_titleEnableOutline(Button_112, "#000000", 1)
	GUI:setChineseName(Button_112, "玩家面板_buff_按钮")
	GUI:setAnchorPoint(Button_112, 0.00, 1.00)
	GUI:setTouchEnabled(Button_112, true)
	GUI:setTag(Button_112, -1)
	GUI:setVisible(Button_112, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_112, "Text_name", 22.00, 84.00, 16, "#807256", [[天
赋]])
	GUI:setChineseName(Text_name, "玩家面板_buff_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)
end
return ui