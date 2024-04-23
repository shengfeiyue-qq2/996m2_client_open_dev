local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public/1900000610.png")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 32.00, 498.00, 18, "#ffffff", [[]])
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", 30.00, 40.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780.00, 492.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create Page1
	local Page1 = GUI:Button_Create(FrameLayout, "Page1", 780.00, 380.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page1, "")
	GUI:Button_setTitleColor(Page1, "#ffffff")
	GUI:Button_setTitleFontSize(Page1, 10)
	GUI:Button_titleEnableOutline(Page1, "#000000", 1)
	GUI:setTouchEnabled(Page1, true)
	GUI:setTag(Page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Page1, "PageText", 12.00, 61.00, 18, "#ffffff", [[行
会]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Page2
	local Page2 = GUI:Button_Create(FrameLayout, "Page2", 780.00, 305.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page2, "")
	GUI:Button_setTitleColor(Page2, "#ffffff")
	GUI:Button_setTitleFontSize(Page2, 10)
	GUI:Button_titleEnableOutline(Page2, "#000000", 1)
	GUI:setTouchEnabled(Page2, true)
	GUI:setTag(Page2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Page2, "PageText", 12.00, 61.00, 18, "#ffffff", [[成
员]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Page3
	local Page3 = GUI:Button_Create(FrameLayout, "Page3", 780.00, 230.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page3, "")
	GUI:Button_setTitleColor(Page3, "#ffffff")
	GUI:Button_setTitleFontSize(Page3, 10)
	GUI:Button_titleEnableOutline(Page3, "#000000", 1)
	GUI:setTouchEnabled(Page3, true)
	GUI:setTag(Page3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Page3, "PageText", 12.00, 61.00, 18, "#ffffff", [[列
表]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)
end
return ui