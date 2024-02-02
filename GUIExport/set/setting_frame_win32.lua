local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 384.00, 645.00, 460.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 322.00, 230.00, "res/public_win32/1900000610.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(PMainUI, "DressIMG", 16.00, 442.00, "res/public_win32/1900000610_1.png")
	GUI:setAnchorPoint(DressIMG, 0.50, 0.50)
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create Text_title
	local Text_title = GUI:Text_Create(PMainUI, "Text_title", 23.00, 440.00, 14, "#d8c8ae", [[]])
	GUI:setAnchorPoint(Text_title, 0.00, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 5)
	GUI:Text_enableOutline(Text_title, "#111111", 2)

	-- Create AttachLayout
	local AttachLayout = GUI:Node_Create(PMainUI, "AttachLayout", 18.00, 28.00)
	GUI:setAnchorPoint(AttachLayout, 0.50, 0.50)
	GUI:setTag(AttachLayout, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 640.00, 436.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(CloseButton, 8, 8, 12, 10)
	GUI:setContentSize(CloseButton, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(CloseButton, false)
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#414146")
	GUI:Button_setTitleFontSize(CloseButton, 14)
	GUI:Button_titleDisableOutLine(CloseButton)
	GUI:setAnchorPoint(CloseButton, 0.00, 0.50)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create page_cell_1
	local page_cell_1 = GUI:Button_Create(PMainUI, "page_cell_1", 640.00, 336.00, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTexturePressed(page_cell_1, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTextureDisabled(page_cell_1, "res/public_win32/1900000683.png")
	GUI:Button_setTitleText(page_cell_1, "")
	GUI:Button_setTitleColor(page_cell_1, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_1, 14)
	GUI:Button_titleDisableOutLine(page_cell_1)
	GUI:setTouchEnabled(page_cell_1, false)
	GUI:setTag(page_cell_1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_1, "PageText", 10.00, 44.00, 13, "#807256", [[基
础]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_1, "TouchSize", 0.00, 67.00, 25.00, 62.00, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_2
	local page_cell_2 = GUI:Button_Create(PMainUI, "page_cell_2", 640.00, 276.00, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTexturePressed(page_cell_2, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTextureDisabled(page_cell_2, "res/public_win32/1900000683.png")
	GUI:Button_setTitleText(page_cell_2, "")
	GUI:Button_setTitleColor(page_cell_2, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_2, 14)
	GUI:Button_titleDisableOutLine(page_cell_2)
	GUI:setTouchEnabled(page_cell_2, false)
	GUI:setTag(page_cell_2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_2, "PageText", 10.00, 44.00, 13, "#807256", [[战
斗]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_2, "TouchSize", 0.00, 67.00, 25.00, 62.00, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_3
	local page_cell_3 = GUI:Button_Create(PMainUI, "page_cell_3", 640.00, 216.00, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTexturePressed(page_cell_3, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTextureDisabled(page_cell_3, "res/public_win32/1900000683.png")
	GUI:Button_setTitleText(page_cell_3, "")
	GUI:Button_setTitleColor(page_cell_3, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_3, 14)
	GUI:Button_titleEnableOutline(page_cell_3, "#000000", 1)
	GUI:setTouchEnabled(page_cell_3, false)
	GUI:setTag(page_cell_3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_3, "PageText", 10.00, 44.00, 13, "#807256", [[保
护]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_3, "TouchSize", 0.00, 67.00, 25.00, 62.00, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_4
	local page_cell_4 = GUI:Button_Create(PMainUI, "page_cell_4", 640.00, 156.00, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTexturePressed(page_cell_4, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTextureDisabled(page_cell_4, "res/public_win32/1900000683.png")
	GUI:Button_setTitleText(page_cell_4, "")
	GUI:Button_setTitleColor(page_cell_4, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_4, 14)
	GUI:Button_titleDisableOutLine(page_cell_4)
	GUI:setTouchEnabled(page_cell_4, false)
	GUI:setTag(page_cell_4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_4, "PageText", 10.00, 44.00, 13, "#807256", [[挂
机]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_4, "TouchSize", 0.00, 67.00, 25.00, 62.00, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_5
	local page_cell_5 = GUI:Button_Create(PMainUI, "page_cell_5", 640.00, 96.00, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTexturePressed(page_cell_5, "res/public_win32/1900000683_1.png")
	GUI:Button_loadTextureDisabled(page_cell_5, "res/public_win32/1900000683.png")
	GUI:Button_setTitleText(page_cell_5, "")
	GUI:Button_setTitleColor(page_cell_5, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_5, 14)
	GUI:Button_titleDisableOutLine(page_cell_5)
	GUI:setTouchEnabled(page_cell_5, false)
	GUI:setTag(page_cell_5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_5, "PageText", 10.00, 44.00, 13, "#807256", [[帮
助]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_5, "TouchSize", 0.00, 67.00, 25.00, 62.00, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)
end
return ui