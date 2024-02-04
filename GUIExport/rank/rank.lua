local ui = {}
function ui.init(parent)
	-- Create Layout
	local Layout = GUI:Layout_Create(parent, "Layout", 0.00, 0.00, 1024.00, 768.00, false)
	GUI:setTouchEnabled(Layout, true)
	GUI:setTag(Layout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 512.00, 384.00, 830.00, 536.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(PMainUI, "pBg", 415.00, 268.00, "res/private/rank_ui/rank_ui_mobile/1900020020.png")
	GUI:setAnchorPoint(pBg, 0.50, 0.50)
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create Image_title
	local Image_title = GUI:Image_Create(PMainUI, "Image_title", 425.00, 480.00, "res/private/rank_ui/rank_ui_mobile/1900020024.png")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 780.00, 450.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create BtnPlayer
	local BtnPlayer = GUI:Button_Create(PMainUI, "BtnPlayer", 810.00, 340.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(BtnPlayer, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(BtnPlayer, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(BtnPlayer, "")
	GUI:Button_setTitleColor(BtnPlayer, "#ffffff")
	GUI:Button_setTitleFontSize(BtnPlayer, 10)
	GUI:Button_titleEnableOutline(BtnPlayer, "#000000", 1)
	GUI:setAnchorPoint(BtnPlayer, 0.50, 0.50)
	GUI:setRotation(BtnPlayer, 180.00)
	GUI:setRotationSkewX(BtnPlayer, 180.00)
	GUI:setRotationSkewY(BtnPlayer, 180.00)
	GUI:setTouchEnabled(BtnPlayer, true)
	GUI:setTag(BtnPlayer, -1)

	-- Create Text
	local Text = GUI:Text_Create(BtnPlayer, "Text", 21.00, 44.00, 16, "#ffffff", [[玩
家]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setRotation(Text, -180.00)
	GUI:setRotationSkewX(Text, -180.00)
	GUI:setRotationSkewY(Text, -180.00)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create BtnHero
	local BtnHero = GUI:Button_Create(PMainUI, "BtnHero", 810.00, 250.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(BtnHero, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(BtnHero, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(BtnHero, "")
	GUI:Button_setTitleColor(BtnHero, "#ffffff")
	GUI:Button_setTitleFontSize(BtnHero, 10)
	GUI:Button_titleEnableOutline(BtnHero, "#000000", 1)
	GUI:setAnchorPoint(BtnHero, 0.50, 0.50)
	GUI:setRotation(BtnHero, 180.00)
	GUI:setRotationSkewX(BtnHero, 180.00)
	GUI:setRotationSkewY(BtnHero, 180.00)
	GUI:setTouchEnabled(BtnHero, true)
	GUI:setTag(BtnHero, -1)

	-- Create Text
	local Text = GUI:Text_Create(BtnHero, "Text", 21.00, 44.00, 16, "#ffffff", [[英
雄]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setRotation(Text, -180.00)
	GUI:setRotationSkewX(Text, -180.00)
	GUI:setRotationSkewY(Text, -180.00)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page1
	local Page1 = GUI:Button_Create(PMainUI, "Page1", 30.00, 330.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Page1, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Page1, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(Page1, "")
	GUI:Button_setTitleColor(Page1, "#ffffff")
	GUI:Button_setTitleFontSize(Page1, 10)
	GUI:Button_titleEnableOutline(Page1, "#000000", 1)
	GUI:setTouchEnabled(Page1, true)
	GUI:setTag(Page1, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page1, "Text", 20.00, 44.00, 16, "#ffffff", [[等
级]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page2
	local Page2 = GUI:Button_Create(PMainUI, "Page2", 30.00, 240.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Page2, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Page2, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(Page2, "")
	GUI:Button_setTitleColor(Page2, "#ffffff")
	GUI:Button_setTitleFontSize(Page2, 10)
	GUI:Button_titleEnableOutline(Page2, "#000000", 1)
	GUI:setTouchEnabled(Page2, true)
	GUI:setTag(Page2, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page2, "Text", 20.00, 44.00, 16, "#ffffff", [[战
士]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page3
	local Page3 = GUI:Button_Create(PMainUI, "Page3", 30.00, 150.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Page3, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Page3, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(Page3, "")
	GUI:Button_setTitleColor(Page3, "#ffffff")
	GUI:Button_setTitleFontSize(Page3, 10)
	GUI:Button_titleEnableOutline(Page3, "#000000", 1)
	GUI:setTouchEnabled(Page3, true)
	GUI:setTag(Page3, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page3, "Text", 20.00, 44.00, 16, "#ffffff", [[法
师]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page4
	local Page4 = GUI:Button_Create(PMainUI, "Page4", 30.00, 60.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Page4, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Page4, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setTitleText(Page4, "")
	GUI:Button_setTitleColor(Page4, "#ffffff")
	GUI:Button_setTitleFontSize(Page4, 10)
	GUI:Button_titleEnableOutline(Page4, "#000000", 1)
	GUI:setTouchEnabled(Page4, true)
	GUI:setTag(Page4, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page4, "Text", 20.00, 44.00, 16, "#ffffff", [[道
士]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create PanelMyInfo
	local PanelMyInfo = GUI:Layout_Create(PMainUI, "PanelMyInfo", 115.00, 30.00, 451.00, 30.00, true)
	GUI:setTouchEnabled(PanelMyInfo, false)
	GUI:setTag(PanelMyInfo, -1)

	-- Create Text1_1
	local Text1_1 = GUI:Text_Create(PanelMyInfo, "Text1_1", 88.00, 15.00, 16, "#ffffff", [[我的排名：]])
	GUI:setAnchorPoint(Text1_1, 1.00, 0.50)
	GUI:setTouchEnabled(Text1_1, false)
	GUI:setTag(Text1_1, -1)
	GUI:Text_enableOutline(Text1_1, "#000000", 1)

	-- Create pRank
	local pRank = GUI:Text_Create(PanelMyInfo, "pRank", 95.00, 15.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(pRank, 0.00, 0.50)
	GUI:setTouchEnabled(pRank, false)
	GUI:setTag(pRank, -1)
	GUI:Text_enableOutline(pRank, "#000000", 1)

	-- Create Text1_2
	local Text1_2 = GUI:Text_Create(PanelMyInfo, "Text1_2", 285.00, 15.00, 16, "#ffffff", [[所属行会：]])
	GUI:setAnchorPoint(Text1_2, 1.00, 0.50)
	GUI:setTouchEnabled(Text1_2, false)
	GUI:setTag(Text1_2, -1)
	GUI:Text_enableOutline(Text1_2, "#000000", 1)

	-- Create GuildName
	local GuildName = GUI:Text_Create(PanelMyInfo, "GuildName", 288.00, 15.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(GuildName, 0.00, 0.50)
	GUI:setTouchEnabled(GuildName, false)
	GUI:setTag(GuildName, -1)
	GUI:Text_enableOutline(GuildName, "#000000", 1)

	-- Create ListView
	local ListView = GUI:ListView_Create(PMainUI, "ListView", 115.00, 65.00, 451.00, 370.00, 1)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create Node_model
	local Node_model = GUI:Node_Create(PMainUI, "Node_model", 635.00, 220.00)
	GUI:setAnchorPoint(Node_model, 0.50, 0.50)
	GUI:setTag(Node_model, -1)

	-- Create BtnLook
	local BtnLook = GUI:Button_Create(PMainUI, "BtnLook", 637.00, 55.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(BtnLook, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(BtnLook, "查看")
	GUI:Button_setTitleColor(BtnLook, "#ffffff")
	GUI:Button_setTitleFontSize(BtnLook, 16)
	GUI:Button_titleEnableOutline(BtnLook, "#000000", 1)
	GUI:setAnchorPoint(BtnLook, 0.50, 0.50)
	GUI:setTouchEnabled(BtnLook, true)
	GUI:setTag(BtnLook, -1)
end
return ui