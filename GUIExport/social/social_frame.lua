local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 76)
	GUI:setChineseName(CloseLayout, "社交_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(FrameLayout, "社交_组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "社交_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "社交_装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 486.00, 20, "#d8c8ae", [[]])
	GUI:setChineseName(TitleText, "社交_标题_文本")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", 30.00, 32.00, 732.00, 445.00, false)
	GUI:setChineseName(AttachLayout, "社交_详情面板")
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780.00, 477.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "社交_关闭_按钮")
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create page_cell_1
	local page_cell_1 = GUI:Button_Create(FrameLayout, "page_cell_1", 780.00, 380.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_1, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_1, "")
	GUI:Button_setTitleColor(page_cell_1, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_1, 14)
	GUI:Button_titleDisableOutLine(page_cell_1)
	GUI:setChineseName(page_cell_1, "社交_附近_组合")
	GUI:setTouchEnabled(page_cell_1, false)
	GUI:setTag(page_cell_1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_1, "PageText", 13.00, 56.00, 16, "#807256", [[附
近]])
	GUI:setChineseName(PageText, "社交_附近_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_1, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "社交_附近_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_2
	local page_cell_2 = GUI:Button_Create(FrameLayout, "page_cell_2", 780.00, 305.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_2, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_2, "")
	GUI:Button_setTitleColor(page_cell_2, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_2, 14)
	GUI:Button_titleDisableOutLine(page_cell_2)
	GUI:setChineseName(page_cell_2, "社交_组队_组合")
	GUI:setTouchEnabled(page_cell_2, false)
	GUI:setTag(page_cell_2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_2, "PageText", 13.00, 56.00, 16, "#807256", [[组
队]])
	GUI:setChineseName(PageText, "社交_组队_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_2, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "社交_组队_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_3
	local page_cell_3 = GUI:Button_Create(FrameLayout, "page_cell_3", 780.00, 230.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_3, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_3, "")
	GUI:Button_setTitleColor(page_cell_3, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_3, 14)
	GUI:Button_titleDisableOutLine(page_cell_3)
	GUI:setChineseName(page_cell_3, "社交_好友_组合")
	GUI:setTouchEnabled(page_cell_3, false)
	GUI:setTag(page_cell_3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_3, "PageText", 13.00, 56.00, 16, "#807256", [[好
友]])
	GUI:setChineseName(PageText, "社交_好友_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_3, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "社交_好友_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_4
	local page_cell_4 = GUI:Button_Create(FrameLayout, "page_cell_4", 780.00, 155.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_4, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_4, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_4, "")
	GUI:Button_setTitleColor(page_cell_4, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_4, 14)
	GUI:Button_titleDisableOutLine(page_cell_4)
	GUI:setChineseName(page_cell_4, "社交_邮件_组合")
	GUI:setTouchEnabled(page_cell_4, false)
	GUI:setTag(page_cell_4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_4, "PageText", 13.00, 56.00, 16, "#807256", [[邮
件]])
	GUI:setChineseName(PageText, "社交_邮件_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_4, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "社交_邮件_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)
end
return ui