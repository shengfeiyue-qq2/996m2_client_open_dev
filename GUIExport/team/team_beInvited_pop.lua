local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 556.00, 320.00, 331.00, 145.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(PMainUI, "pBg", 165.00, 72.00, "res/public/1900000650.png")
	GUI:setAnchorPoint(pBg, 0.50, 0.50)
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create ImageTitle
	local ImageTitle = GUI:Image_Create(PMainUI, "ImageTitle", 165.00, 115.00, "res/private/team/1900014002.png")
	GUI:setAnchorPoint(ImageTitle, 0.50, 0.50)
	GUI:setTouchEnabled(ImageTitle, false)
	GUI:setTag(ImageTitle, -1)

	-- Create TextInfo
	local TextInfo = GUI:Text_Create(PMainUI, "TextInfo", 165.00, 85.00, 16, "#ffffff", [[Text]])
	GUI:setAnchorPoint(TextInfo, 0.50, 0.50)
	GUI:setTouchEnabled(TextInfo, false)
	GUI:setTag(TextInfo, -1)
	GUI:Text_enableOutline(TextInfo, "#000000", 1)

	-- Create BtnAgree
	local BtnAgree = GUI:Button_Create(PMainUI, "BtnAgree", 90.00, 30.00, "res/public/1900000653.png")
	GUI:Button_loadTexturePressed(BtnAgree, "res/public/1900000661.png")
	GUI:Button_setTitleText(BtnAgree, "同意")
	GUI:Button_setTitleColor(BtnAgree, "#ffffff")
	GUI:Button_setTitleFontSize(BtnAgree, 16)
	GUI:Button_titleEnableOutline(BtnAgree, "#000000", 1)
	GUI:setAnchorPoint(BtnAgree, 0.50, 0.50)
	GUI:setTouchEnabled(BtnAgree, true)
	GUI:setTag(BtnAgree, -1)

	-- Create BtnDisAgree
	local BtnDisAgree = GUI:Button_Create(PMainUI, "BtnDisAgree", 240.00, 30.00, "res/public/1900000653.png")
	GUI:Button_loadTexturePressed(BtnDisAgree, "res/public/1900000661.png")
	GUI:Button_setTitleText(BtnDisAgree, "拒绝")
	GUI:Button_setTitleColor(BtnDisAgree, "#ffffff")
	GUI:Button_setTitleFontSize(BtnDisAgree, 16)
	GUI:Button_titleEnableOutline(BtnDisAgree, "#000000", 1)
	GUI:setAnchorPoint(BtnDisAgree, 0.50, 0.50)
	GUI:setTouchEnabled(BtnDisAgree, true)
	GUI:setTag(BtnDisAgree, -1)

	-- Create BtnClose
	local BtnClose = GUI:Button_Create(PMainUI, "BtnClose", 331.00, 145.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
	GUI:Button_setTitleText(BtnClose, "")
	GUI:Button_setTitleColor(BtnClose, "#ffffff")
	GUI:Button_setTitleFontSize(BtnClose, 10)
	GUI:Button_titleEnableOutline(BtnClose, "#000000", 1)
	GUI:setAnchorPoint(BtnClose, 0.00, 1.00)
	GUI:setTouchEnabled(BtnClose, true)
	GUI:setTag(BtnClose, -1)
end
return ui