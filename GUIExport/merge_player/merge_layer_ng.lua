local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "二合一内功场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 137.00, 330.00, 465.00, 595.00, false)
	GUI:setChineseName(Panel_1, "二合一组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 12)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 227.00, 298.00, "res/private/player_hero/img_bg1_ng.png")
	GUI:setChineseName(Image_1, "二合一组合")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 74)

	-- Create Button_player
	local Button_player = GUI:Button_Create(Image_1, "Button_player", 6.00, 379.00, "res/private/player_hero/img_btn3.png")
	GUI:Button_loadTextureDisabled(Button_player, "res/private/player_hero/img_btn4.png")
	GUI:Button_setScale9Slice(Button_player, 15, 15, 4, 4)
	GUI:setContentSize(Button_player, 56, 56)
	GUI:setIgnoreContentAdaptWithSize(Button_player, false)
	GUI:Button_setTitleText(Button_player, "")
	GUI:Button_setTitleColor(Button_player, "#414146")
	GUI:Button_setTitleFontSize(Button_player, 14)
	GUI:Button_titleDisableOutLine(Button_player)
	GUI:setChineseName(Button_player, "二合一_主角_按钮")
	GUI:setAnchorPoint(Button_player, 0.50, 0.50)
	GUI:setTouchEnabled(Button_player, true)
	GUI:setTag(Button_player, 75)

	-- Create Button_hero
	local Button_hero = GUI:Button_Create(Image_1, "Button_hero", 6.00, 301.00, "res/private/player_hero/img_btn1.png")
	GUI:Button_loadTextureDisabled(Button_hero, "res/private/player_hero/img_btn2.png")
	GUI:Button_setScale9Slice(Button_hero, 15, 15, 4, 4)
	GUI:setContentSize(Button_hero, 56, 56)
	GUI:setIgnoreContentAdaptWithSize(Button_hero, false)
	GUI:Button_setTitleText(Button_hero, "")
	GUI:Button_setTitleColor(Button_hero, "#414146")
	GUI:Button_setTitleFontSize(Button_hero, 14)
	GUI:Button_titleDisableOutLine(Button_hero)
	GUI:setChineseName(Button_hero, "二合一_英雄_按钮")
	GUI:setAnchorPoint(Button_hero, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hero, true)
	GUI:setTag(Button_hero, 76)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_1, "ButtonClose", 417.00, 506.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 8, 4, 4)
	GUI:setContentSize(ButtonClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setChineseName(ButtonClose, "二合一_关闭_按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 78)

	-- Create topLayout
	local topLayout = GUI:Layout_Create(Image_1, "topLayout", 215.00, 488.00, 164.00, 35.00, false)
	GUI:setChineseName(topLayout, "二合一内功_组合")
	GUI:setAnchorPoint(topLayout, 0.50, 0.00)
	GUI:setTouchEnabled(topLayout, false)
	GUI:setTag(topLayout, -1)

	-- Create base_btn
	local base_btn = GUI:Button_Create(topLayout, "base_btn", -8.00, 3.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_2.png")
	GUI:Button_loadTexturePressed(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_loadTextureDisabled(base_btn, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/top_btn_1.png")
	GUI:Button_setTitleText(base_btn, "")
	GUI:Button_setTitleColor(base_btn, "#ffffff")
	GUI:Button_setTitleFontSize(base_btn, 16)
	GUI:Button_titleEnableOutline(base_btn, "#000000", 1)
	GUI:setChineseName(base_btn, "二合一内功_基础_按钮")
	GUI:setTouchEnabled(base_btn, true)
	GUI:setTag(base_btn, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(base_btn, "Text_1", 38.00, 16.00, 16, "#807256", [[基础]])
	GUI:setChineseName(Text_1, "二合一内功_基础_文本")
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
	GUI:setChineseName(ng_btn, "二合一内功_内功_按钮")
	GUI:setTouchEnabled(ng_btn, true)
	GUI:setTag(ng_btn, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(ng_btn, "Text_1", 38.00, 16.00, 16, "#807256", [[内功]])
	GUI:setChineseName(Text_1, "二合一内功_内功_文本")
	GUI:setAnchorPoint(Text_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#111111", 2)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Image_1, "Panel_btnList", 402.00, 480.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList, "二合一_侧边栏列表_组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, true)
	GUI:setTag(Panel_btnList, 79)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_btnList, "Button_1", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#414146")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:setChineseName(Button_1, "二合一_状态_按钮")
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_1, "Text_name", 13.00, 78.00, 16, "#807256", [[装
备]])
	GUI:setChineseName(Text_name, "二合一_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_btnList, "Button_2", 0.00, 384.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#414146")
	GUI:Button_setTitleFontSize(Button_2, 14)
	GUI:Button_titleDisableOutLine(Button_2)
	GUI:setChineseName(Button_2, "二合一_技能_按钮")
	GUI:setAnchorPoint(Button_2, 0.00, 1.00)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_2, "Text_name", 13.00, 78.00, 16, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "二合一_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_btnList, "Button_3", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#414146")
	GUI:Button_setTitleFontSize(Button_3, 14)
	GUI:Button_titleDisableOutLine(Button_3)
	GUI:setChineseName(Button_3, "二合一_经络_按钮")
	GUI:setAnchorPoint(Button_3, 0.00, 1.00)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_3, "Text_name", 13.00, 78.00, 16, "#807256", [[属
性]])
	GUI:setChineseName(Text_name, "二合一_经络_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_btnList, "Button_4", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_4, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_4, "")
	GUI:Button_setTitleColor(Button_4, "#414146")
	GUI:Button_setTitleFontSize(Button_4, 14)
	GUI:Button_titleDisableOutLine(Button_4)
	GUI:setChineseName(Button_4, "二合一_连击_按钮")
	GUI:setAnchorPoint(Button_4, 0.00, 1.00)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_4, "Text_name", 13.00, 78.00, 16, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "二合一_连击_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_6
	local Button_6 = GUI:Button_Create(Panel_btnList, "Button_6", 0.00, 166.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_6, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_6, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_6, "")
	GUI:Button_setTitleColor(Button_6, "#414146")
	GUI:Button_setTitleFontSize(Button_6, 14)
	GUI:Button_titleDisableOutLine(Button_6)
	GUI:setChineseName(Button_6, "二合一_称号_按钮")
	GUI:setAnchorPoint(Button_6, 0.00, 1.00)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_6, "Text_name", 13.00, 78.00, 16, "#807256", [[称
号]])
	GUI:setChineseName(Text_name, "二合一_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_11
	local Button_11 = GUI:Button_Create(Panel_btnList, "Button_11", 0.00, 94.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_11, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_11, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_11, "")
	GUI:Button_setTitleColor(Button_11, "#414146")
	GUI:Button_setTitleFontSize(Button_11, 14)
	GUI:Button_titleDisableOutLine(Button_11)
	GUI:setChineseName(Button_11, "二合一_时装_按钮")
	GUI:setAnchorPoint(Button_11, 0.00, 1.00)
	GUI:setTouchEnabled(Button_11, true)
	GUI:setTag(Button_11, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_11, "Text_name", 13.00, 78.00, 16, "#807256", [[时
装]])
	GUI:setChineseName(Text_name, "二合一_时装_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Panel_btnList_ng
	local Panel_btnList_ng = GUI:Layout_Create(Image_1, "Panel_btnList_ng", 402.00, 480.00, 32.00, 454.00, false)
	GUI:setChineseName(Panel_btnList_ng, "二合一内功_侧边栏组合")
	GUI:setAnchorPoint(Panel_btnList_ng, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList_ng, false)
	GUI:setTag(Panel_btnList_ng, 26)
	GUI:setVisible(Panel_btnList_ng, false)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_btnList_ng, "Button_1", 0.00, 454.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setChineseName(Button_1, "二合一内功_状态_按钮")
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_1, "Text_name", 13.00, 78.00, 16, "#807256", [[状
态]])
	GUI:setChineseName(Text_name, "二合一内功_状态_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_btnList_ng, "Button_2", 0.00, 382.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_2, 14)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setChineseName(Button_2, "二合一内功_技能_按钮")
	GUI:setAnchorPoint(Button_2, 0.00, 1.00)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_2, "Text_name", 13.00, 78.00, 16, "#807256", [[技
能]])
	GUI:setChineseName(Text_name, "二合一内功_技能_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_btnList_ng, "Button_3", 0.00, 310.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_3, 14)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setChineseName(Button_3, "二合一内功_经络_按钮")
	GUI:setAnchorPoint(Button_3, 0.00, 1.00)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_3, "Text_name", 13.00, 78.00, 16, "#807256", [[经
络]])
	GUI:setChineseName(Text_name, "二合一内功_经络_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_btnList_ng, "Button_4", 0.00, 238.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Button_4, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/public/1900000640.png")
	GUI:Button_setTitleText(Button_4, "")
	GUI:Button_setTitleColor(Button_4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_4, 14)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setChineseName(Button_4, "二合一内功_连击_按钮")
	GUI:setAnchorPoint(Button_4, 0.00, 1.00)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_4, "Text_name", 13.00, 78.00, 16, "#807256", [[连
击]])
	GUI:setChineseName(Text_name, "二合一内功_连击_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Image_1, "Node_panel", 39.00, 16.00)
	GUI:setChineseName(Node_panel, "二合一_节点_面板")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 77)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Image_1, "Text_Name", 215.00, 548.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "二合一_名称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 95)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)
end
return ui