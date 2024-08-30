local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "二合一内功场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 900.00, 330.00, 465.00, 595.00, false)
	GUI:setChineseName(Panel_1, "二合一组合")
	GUI:setAnchorPoint(Panel_1, 1.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 12.0)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 227.00, 298.00, "res/private/player_hero/img_bg1_ng.png")
	GUI:setChineseName(Image_1, "二合一组合")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 74.0)

	-- Create Button_player
	local Button_player = GUI:Button_Create(Image_1, "Button_player", 6.00, 379.00, "res/private/player_hero/img_btn3.png")
	GUI:Button_loadTextureDisabled(Button_player, "res/private/player_hero/img_btn4.png")
	GUI:Button_setScale9Slice(Button_player, 15, 15.0, 4, 4.0)
	GUI:setContentSize(Button_player, 56.0, 56.0)
	GUI:setIgnoreContentAdaptWithSize(Button_player, false)
	GUI:Button_setTitleText(Button_player, "")
	GUI:Button_setTitleColor(Button_player, "#414146")
	GUI:Button_setTitleFontSize(Button_player, 14.0)
	GUI:Button_titleDisableOutLine(Button_player)
	GUI:setChineseName(Button_player, "二合一_主角_按钮")
	GUI:setAnchorPoint(Button_player, 0.50, 0.50)
	GUI:setTouchEnabled(Button_player, true)
	GUI:setTag(Button_player, 75.0)

	-- Create Button_hero
	local Button_hero = GUI:Button_Create(Image_1, "Button_hero", 6.00, 301.00, "res/private/player_hero/img_btn1.png")
	GUI:Button_loadTextureDisabled(Button_hero, "res/private/player_hero/img_btn2.png")
	GUI:Button_setScale9Slice(Button_hero, 15, 15.0, 4, 4.0)
	GUI:setContentSize(Button_hero, 56.0, 56.0)
	GUI:setIgnoreContentAdaptWithSize(Button_hero, false)
	GUI:Button_setTitleText(Button_hero, "")
	GUI:Button_setTitleColor(Button_hero, "#414146")
	GUI:Button_setTitleFontSize(Button_hero, 14.0)
	GUI:Button_titleDisableOutLine(Button_hero)
	GUI:setChineseName(Button_hero, "二合一_英雄_按钮")
	GUI:setAnchorPoint(Button_hero, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hero, true)
	GUI:setTag(Button_hero, 76.0)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_1, "ButtonClose", 417.00, 506.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 8.0, 4, 4.0)
	GUI:setContentSize(ButtonClose, 26.0, 42.0)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14.0)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "二合一_关闭_按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 78.0)

	-- Create topLayout
	local topLayout = GUI:Layout_Create(Image_1, "topLayout", 215.00, 488.00, 164.00, 35.00, false)
	GUI:setChineseName(topLayout, "二合一内功_组合")
	GUI:setAnchorPoint(topLayout, 0.50, 0.00)
	GUI:setTouchEnabled(topLayout, false)
	GUI:setTag(topLayout, -1.0)

	-- Create base_btn
	local base_btn = GUI:Button_Create(topLayout, "base_btn", -8.00, 3.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_2.png")
	GUI:Button_loadTexturePressed(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_loadTextureDisabled(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_setTitleText(base_btn, "")
	GUI:Button_setTitleColor(base_btn, "#ffffff")
	GUI:Button_setTitleFontSize(base_btn, 16.0)
	GUI:Button_titleEnableOutline(base_btn, "#000000", 1.0)
	GUI:setChineseName(base_btn, "二合一内功_基础_按钮")
	GUI:setTouchEnabled(base_btn, true)
	GUI:setTag(base_btn, -1.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(base_btn, "Text_1", 38.00, 16.00, 16.0, "#807256", [[基础]])
	GUI:setChineseName(Text_1, "二合一内功_基础_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1.0)
	GUI:Text_enableOutline(Text_1, "#111111", 2.0)

	-- Create ng_btn
	local ng_btn = GUI:Button_Create(topLayout, "ng_btn", 64.00, 3.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_2.png")
	GUI:Button_loadTexturePressed(ng_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_loadTextureDisabled(ng_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_setTitleText(ng_btn, "")
	GUI:Button_setTitleColor(ng_btn, "#ffffff")
	GUI:Button_setTitleFontSize(ng_btn, 16.0)
	GUI:Button_titleEnableOutline(ng_btn, "#000000", 1.0)
	GUI:setChineseName(ng_btn, "二合一内功_内功_按钮")
	GUI:setTouchEnabled(ng_btn, true)
	GUI:setTag(ng_btn, -1.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(ng_btn, "Text_1", 38.00, 16.00, 16.0, "#807256", [[内功]])
	GUI:setChineseName(Text_1, "二合一内功_内功_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1.0)
	GUI:Text_enableOutline(Text_1, "#111111", 2.0)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Image_1, "Panel_btnList", 405.00, 478.00, 32.00, 454.00, false)
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
	GUI:Button_titleEnableOutline(Button_101, "#000000", 1.0)
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

	-- Create Button_102
	local Button_102 = GUI:Button_Create(Panel_btnList, "Button_102", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_102, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_102, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_102, "")
	GUI:Button_setTitleColor(Button_102, "#ffffff")
	GUI:Button_setTitleFontSize(Button_102, 14.0)
	GUI:Button_titleEnableOutline(Button_102, "#000000", 1.0)
	GUI:setChineseName(Button_102, "玩家面板_状态_按钮")
	GUI:setAnchorPoint(Button_102, 0.00, 1.00)
	GUI:setTouchEnabled(Button_102, true)
	GUI:setTag(Button_102, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_102, "Text_name", 13.00, 78.00, 16.0, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "玩家面板_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_103
	local Button_103 = GUI:Button_Create(Panel_btnList, "Button_103", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_103, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_103, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_103, "")
	GUI:Button_setTitleColor(Button_103, "#ffffff")
	GUI:Button_setTitleFontSize(Button_103, 14.0)
	GUI:Button_titleEnableOutline(Button_103, "#000000", 1.0)
	GUI:setChineseName(Button_103, "玩家面板_属性_按钮")
	GUI:setAnchorPoint(Button_103, 0.00, 1.00)
	GUI:setTouchEnabled(Button_103, true)
	GUI:setTag(Button_103, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_103, "Text_name", 13.00, 78.00, 16.0, "#807256", [[属
性]])
	GUI:setChineseName(Text_name, "玩家面板_属性_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_104
	local Button_104 = GUI:Button_Create(Panel_btnList, "Button_104", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_104, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_104, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_104, "")
	GUI:Button_setTitleColor(Button_104, "#ffffff")
	GUI:Button_setTitleFontSize(Button_104, 14.0)
	GUI:Button_titleEnableOutline(Button_104, "#000000", 1.0)
	GUI:setChineseName(Button_104, "玩家面板_技能_按钮")
	GUI:setAnchorPoint(Button_104, 0.00, 1.00)
	GUI:setTouchEnabled(Button_104, true)
	GUI:setTag(Button_104, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_104, "Text_name", 13.00, 78.00, 16.0, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "玩家面板_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_105
	local Button_105 = GUI:Button_Create(Panel_btnList, "Button_105", 0.00, 166.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_105, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_105, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_105, "")
	GUI:Button_setTitleColor(Button_105, "#ffffff")
	GUI:Button_setTitleFontSize(Button_105, 14.0)
	GUI:Button_titleEnableOutline(Button_105, "#000000", 1.0)
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
	local Button_106 = GUI:Button_Create(Panel_btnList, "Button_106", 0.00, 94.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_106, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_106, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_106, "")
	GUI:Button_setTitleColor(Button_106, "#ffffff")
	GUI:Button_setTitleFontSize(Button_106, 14.0)
	GUI:Button_titleEnableOutline(Button_106, "#000000", 1.0)
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

	-- Create Panel_btnList_ng
	local Panel_btnList_ng = GUI:Layout_Create(Image_1, "Panel_btnList_ng", 404.00, 478.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList_ng, "玩家内功面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList_ng, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList_ng, false)
	GUI:setTag(Panel_btnList_ng, 26.0)
	GUI:setVisible(Panel_btnList_ng, false)

	-- Create Button_701
	local Button_701 = GUI:Button_Create(Panel_btnList_ng, "Button_701", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_701, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_701, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_701, "")
	GUI:Button_setTitleColor(Button_701, "#ffffff")
	GUI:Button_setTitleFontSize(Button_701, 14.0)
	GUI:Button_titleEnableOutline(Button_701, "#000000", 1.0)
	GUI:setChineseName(Button_701, "玩家内功面板_状态_按钮")
	GUI:setAnchorPoint(Button_701, 0.00, 1.00)
	GUI:setTouchEnabled(Button_701, true)
	GUI:setTag(Button_701, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_701, "Text_name", 13.00, 78.00, 16.0, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "玩家内功面板_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_702
	local Button_702 = GUI:Button_Create(Panel_btnList_ng, "Button_702", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_702, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_702, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_702, "")
	GUI:Button_setTitleColor(Button_702, "#ffffff")
	GUI:Button_setTitleFontSize(Button_702, 14.0)
	GUI:Button_titleEnableOutline(Button_702, "#000000", 1.0)
	GUI:setChineseName(Button_702, "玩家内功面板_技能_按钮")
	GUI:setAnchorPoint(Button_702, 0.00, 1.00)
	GUI:setTouchEnabled(Button_702, true)
	GUI:setTag(Button_702, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_702, "Text_name", 13.00, 78.00, 16.0, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "玩家内功面板_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_703
	local Button_703 = GUI:Button_Create(Panel_btnList_ng, "Button_703", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_703, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_703, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_703, "")
	GUI:Button_setTitleColor(Button_703, "#ffffff")
	GUI:Button_setTitleFontSize(Button_703, 14.0)
	GUI:Button_titleEnableOutline(Button_703, "#000000", 1.0)
	GUI:setChineseName(Button_703, "玩家内功面板_经络_按钮")
	GUI:setAnchorPoint(Button_703, 0.00, 1.00)
	GUI:setTouchEnabled(Button_703, true)
	GUI:setTag(Button_703, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_703, "Text_name", 13.00, 78.00, 16.0, "#807256", [[经
络]])
	GUI:setChineseName(Text_name, "玩家内功面板_经络_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Button_704
	local Button_704 = GUI:Button_Create(Panel_btnList_ng, "Button_704", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_704, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_704, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_704, "")
	GUI:Button_setTitleColor(Button_704, "#ffffff")
	GUI:Button_setTitleFontSize(Button_704, 14.0)
	GUI:Button_titleEnableOutline(Button_704, "#000000", 1.0)
	GUI:setChineseName(Button_704, "玩家内功面板_连击_按钮")
	GUI:setAnchorPoint(Button_704, 0.00, 1.00)
	GUI:setTouchEnabled(Button_704, true)
	GUI:setTag(Button_704, -1.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_704, "Text_name", 13.00, 78.00, 16.0, "#807256", [[连
击]])
	GUI:setChineseName(Text_name, "玩家内功面板_连击_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1.0)
	GUI:Text_enableOutline(Text_name, "#111111", 2.0)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Image_1, "Node_panel", 39.00, 16.00)
	GUI:setChineseName(Node_panel, "二合一_节点_面板")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 77.0)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Image_1, "Text_Name", 215.00, 548.00, 18.0, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "二合一_名称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, true)
	GUI:setTag(Text_Name, 95.0)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1.0)
end
return ui