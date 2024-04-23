local ui = {}
function ui.init(parent)
	-- Create Layout
	local Layout = GUI:Layout_Create(parent, "Layout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Layout, true)
	GUI:setTag(Layout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 873.00, 555.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(PMainUI, "pBg", 436.00, 277.00, "res/public/1900000672.png")
	GUI:setAnchorPoint(pBg, 0.50, 0.50)
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create Image_title
	local Image_title = GUI:Image_Create(PMainUI, "Image_title", 436.00, 505.00, "res/private/store_ui/word_scbtt.png")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 828.00, 435.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)

	-- Create Page1
	local Page1 = GUI:Button_Create(PMainUI, "Page1", 845.00, 320.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page1, "")
	GUI:Button_setTitleColor(Page1, "#ffffff")
	GUI:Button_setTitleFontSize(Page1, 10)
	GUI:Button_titleEnableOutline(Page1, "#000000", 1)
	GUI:setTouchEnabled(Page1, true)
	GUI:setTag(Page1, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page1, "Text", 15.00, 60.00, 16, "#ffffff", [[灵
符]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page2
	local Page2 = GUI:Button_Create(PMainUI, "Page2", 845.00, 245.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page2, "")
	GUI:Button_setTitleColor(Page2, "#ffffff")
	GUI:Button_setTitleFontSize(Page2, 10)
	GUI:Button_titleEnableOutline(Page2, "#000000", 1)
	GUI:setTouchEnabled(Page2, true)
	GUI:setTag(Page2, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page2, "Text", 15.00, 60.00, 16, "#ffffff", [[元
宝]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page3
	local Page3 = GUI:Button_Create(PMainUI, "Page3", 845.00, 170.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page3, "")
	GUI:Button_setTitleColor(Page3, "#ffffff")
	GUI:Button_setTitleFontSize(Page3, 10)
	GUI:Button_titleEnableOutline(Page3, "#000000", 1)
	GUI:setTouchEnabled(Page3, true)
	GUI:setTag(Page3, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page3, "Text", 15.00, 60.00, 16, "#ffffff", [[技
能]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page4
	local Page4 = GUI:Button_Create(PMainUI, "Page4", 845.00, 95.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page4, "")
	GUI:Button_setTitleColor(Page4, "#ffffff")
	GUI:Button_setTitleFontSize(Page4, 10)
	GUI:Button_titleEnableOutline(Page4, "#000000", 1)
	GUI:setTouchEnabled(Page4, true)
	GUI:setTag(Page4, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page4, "Text", 15.00, 60.00, 16, "#ffffff", [[货
币]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create Page5
	local Page5 = GUI:Button_Create(PMainUI, "Page5", 845.00, 20.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
	GUI:Button_setTitleText(Page5, "")
	GUI:Button_setTitleColor(Page5, "#ffffff")
	GUI:Button_setTitleFontSize(Page5, 10)
	GUI:Button_titleEnableOutline(Page5, "#000000", 1)
	GUI:setTouchEnabled(Page5, true)
	GUI:setTag(Page5, -1)

	-- Create Text
	local Text = GUI:Text_Create(Page5, "Text", 15.00, 60.00, 16, "#ffffff", [[充
值]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", 70.00, 30.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)
end
return ui