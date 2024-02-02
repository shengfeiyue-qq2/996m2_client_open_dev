local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 137.00, 330.00, 465.00, 576.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 12)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 227.00, 288.00, "res/private/player_hero/img_bg1.png")
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
	GUI:setAnchorPoint(Button_hero, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hero, true)
	GUI:setTag(Button_hero, 76)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Image_1, "ButtonClose", 417.00, 487.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(ButtonClose, 8, 8, 4, 4)
	GUI:setContentSize(ButtonClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(ButtonClose, false)
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 78)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Image_1, "Panel_btnList", 402.00, 462.00, 32.00, 454.00, false)
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
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_1, "Text_name", 13.00, 85.00, 16, "#807256", [[装
备]])
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
	GUI:setAnchorPoint(Button_2, 0.00, 1.00)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_2, "Text_name", 13.00, 85.00, 16, "#807256", [[状
态]])
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
	GUI:setAnchorPoint(Button_3, 0.00, 1.00)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_3, "Text_name", 13.00, 85.00, 16, "#807256", [[属
性]])
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
	GUI:setAnchorPoint(Button_4, 0.00, 1.00)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_4, "Text_name", 13.00, 85.00, 16, "#807256", [[技
能]])
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
	GUI:setAnchorPoint(Button_6, 0.00, 1.00)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_6, "Text_name", 13.00, 85.00, 16, "#807256", [[称
号]])
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
	GUI:setAnchorPoint(Button_11, 0.00, 1.00)
	GUI:setTouchEnabled(Button_11, true)
	GUI:setTag(Button_11, 93)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_11, "Text_name", 13.00, 85.00, 16, "#807256", [[时
装]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 94)
	GUI:Text_enableOutline(Text_name, "#111111", 2)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Image_1, "Node_panel", 39.00, 16.00)
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 77)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Image_1, "Text_Name", 215.00, 523.00, 18, "#ffe400", [[]])
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 95)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)
end
return ui