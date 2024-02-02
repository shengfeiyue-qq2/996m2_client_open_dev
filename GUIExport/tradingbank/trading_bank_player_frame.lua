local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 455.00, 550.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 331)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 227.00, 254.00, "res/private/trading_bank/bg_jiaoyh_012.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 332)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Image_bg, "Node_panel", 17.00, 15.00)
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 333)

	-- Create Image_bg2
	local Image_bg2 = GUI:Image_Create(Panel_1, "Image_bg2", 209.00, 254.00, "res/private/trading_bank/bg_jiaoyh_01.png")
	GUI:setAnchorPoint(Image_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg2, false)
	GUI:setTag(Image_bg2, 334)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_bg2, "ListView_1", 16.00, 16.00, 386.00, 476.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 336)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 227.00, 523.00, 18, "#ffe400", [[]])
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 337)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_1, "Button_3", 432.00, 489.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_3, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_3, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_3, 8, 6, 12, 10)
	GUI:setContentSize(Button_3, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_3, false)
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#414146")
	GUI:Button_setTitleFontSize(Button_3, 14)
	GUI:Button_titleDisableOutLine(Button_3)
	GUI:setAnchorPoint(Button_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, 338)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_1, "Button_1", 96.00, 528.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "角色")
	GUI:Button_setTitleColor(Button_1, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_1, 20)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 339)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_1, "Button_2", 205.00, 528.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_2, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_2, 15, 15, 11, 11)
	GUI:setContentSize(Button_2, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "英雄")
	GUI:Button_setTitleColor(Button_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_2, 20)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 340)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_1, "Button_4", 314.00, 528.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_4, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_4, 15, 15, 11, 11)
	GUI:setContentSize(Button_4, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_4, false)
	GUI:Button_setTitleText(Button_4, "仓库")
	GUI:Button_setTitleColor(Button_4, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_4, 20)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setAnchorPoint(Button_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_4, false)
	GUI:setTag(Button_4, 341)
	GUI:setVisible(Button_4, false)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 419.00, 462.00, 32.00, 454.00, false)
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 86)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_btnList, "Button_page1", 0.00, 454.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleDisableOutLine(Button_page1)
	GUI:setAnchorPoint(Button_page1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page1, true)
	GUI:setTag(Button_page1, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page1, "Text_name", 12.00, 48.00, 16, "#807256", [[装
备]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_btnList, "Button_page2", 0.00, 396.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleDisableOutLine(Button_page2)
	GUI:setAnchorPoint(Button_page2, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page2, true)
	GUI:setTag(Button_page2, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page2, "Text_name", 12.00, 48.00, 16, "#807256", [[状
态]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_btnList, "Button_page3", 0.00, 338.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleDisableOutLine(Button_page3)
	GUI:setAnchorPoint(Button_page3, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page3, true)
	GUI:setTag(Button_page3, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page3, "Text_name", 12.00, 48.00, 16, "#807256", [[属
性]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_btnList, "Button_page4", 0.00, 280.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleDisableOutLine(Button_page4)
	GUI:setAnchorPoint(Button_page4, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page4, true)
	GUI:setTag(Button_page4, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page4, "Text_name", 12.00, 48.00, 16, "#807256", [[技
能]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page6
	local Button_page6 = GUI:Button_Create(Panel_btnList, "Button_page6", 0.00, 222.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page6, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page6, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page6, "")
	GUI:Button_setTitleColor(Button_page6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page6, 14)
	GUI:Button_titleDisableOutLine(Button_page6)
	GUI:setAnchorPoint(Button_page6, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page6, true)
	GUI:setTag(Button_page6, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page6, "Text_name", 12.00, 48.00, 16, "#807256", [[称
号]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page11
	local Button_page11 = GUI:Button_Create(Panel_btnList, "Button_page11", 0.00, 164.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page11, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page11, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page11, "")
	GUI:Button_setTitleColor(Button_page11, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page11, 14)
	GUI:Button_titleDisableOutLine(Button_page11)
	GUI:setAnchorPoint(Button_page11, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page11, true)
	GUI:setTag(Button_page11, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page11, "Text_name", 12.00, 48.00, 16, "#807256", [[时
装]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page100
	local Button_page100 = GUI:Button_Create(Panel_btnList, "Button_page100", 0.00, 106.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page100, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page100, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page100, "")
	GUI:Button_setTitleColor(Button_page100, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page100, 14)
	GUI:Button_titleDisableOutLine(Button_page100)
	GUI:setAnchorPoint(Button_page100, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page100, true)
	GUI:setTag(Button_page100, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page100, "Text_name", 12.00, 48.00, 16, "#807256", [[背
包]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Button_page101
	local Button_page101 = GUI:Button_Create(Panel_btnList, "Button_page101", 0.00, 48.00, "res/private/trading_bank/btn_select1.png")
	GUI:Button_loadTexturePressed(Button_page101, "res/private/trading_bank/btn_select2.png")
	GUI:Button_loadTextureDisabled(Button_page101, "res/private/trading_bank/btn_select2.png")
	GUI:Button_setTitleText(Button_page101, "")
	GUI:Button_setTitleColor(Button_page101, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page101, 14)
	GUI:Button_titleDisableOutLine(Button_page101)
	GUI:setAnchorPoint(Button_page101, 0.00, 1.00)
	GUI:setTouchEnabled(Button_page101, true)
	GUI:setTag(Button_page101, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Button_page101, "Text_name", 12.00, 48.00, 16, "#807256", [[仓
库]])
	GUI:setAnchorPoint(Text_name, 0.50, 1.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui