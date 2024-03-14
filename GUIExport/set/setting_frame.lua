local ui = {}
function ui.init(parent)
	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(parent, "Panel_cancle", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(Panel_cancle, 1)
	GUI:Layout_setBackGroundColor(Panel_cancle, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cancle, 73)
	GUI:setChineseName(Panel_cancle, "内挂_范围点击关闭")
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 123)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(PMainUI, "内挂主界面_组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "内挂主界面_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(PMainUI, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "内挂主界面_装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(PMainUI, "TitleText", 104.00, 486.00, 20, "#d8c8ae", [[]])
	GUI:setChineseName(TitleText, "内挂主界面_标题")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", 30.00, 32.00, 732.00, 445.00, false)
	GUI:setChineseName(AttachLayout, "内挂主界面_设置面板")
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 780.00, 477.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "内挂主界面_关闭_按钮")
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create page_cell_1
	local page_cell_1 = GUI:Button_Create(PMainUI, "page_cell_1", 780.00, 380.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_1, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_1, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_1, "")
	GUI:Button_setTitleColor(page_cell_1, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_1, 14)
	GUI:Button_titleDisableOutLine(page_cell_1)
	GUI:setChineseName(page_cell_1, "内挂主界面_基础组合")
	GUI:setTouchEnabled(page_cell_1, false)
	GUI:setTag(page_cell_1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_1, "PageText", 13.00, 56.00, 16, "#807256", [[基
础]])
	GUI:setChineseName(PageText, "内挂主界面_基础_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_1, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_基础_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_2
	local page_cell_2 = GUI:Button_Create(PMainUI, "page_cell_2", 780.00, 305.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_2, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_2, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_2, "")
	GUI:Button_setTitleColor(page_cell_2, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_2, 14)
	GUI:Button_titleDisableOutLine(page_cell_2)
	GUI:setChineseName(page_cell_2, "内挂主界面_视距组合")
	GUI:setTouchEnabled(page_cell_2, false)
	GUI:setTag(page_cell_2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_2, "PageText", 13.00, 56.00, 16, "#807256", [[视
距]])
	GUI:setChineseName(PageText, "内挂主界面_视距_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_2, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_视距_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_3
	local page_cell_3 = GUI:Button_Create(PMainUI, "page_cell_3", 780.00, 230.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_3, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_3, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_3, "")
	GUI:Button_setTitleColor(page_cell_3, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_3, 14)
	GUI:Button_titleDisableOutLine(page_cell_3)
	GUI:setChineseName(page_cell_3, "内挂主界面_战斗组合")
	GUI:setTouchEnabled(page_cell_3, false)
	GUI:setTag(page_cell_3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_3, "PageText", 13.00, 56.00, 16, "#807256", [[战
斗]])
	GUI:setChineseName(PageText, "内挂主界面_战斗_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_3, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_战斗_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_4
	local page_cell_4 = GUI:Button_Create(PMainUI, "page_cell_4", 780.00, 155.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_4, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_4, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_4, "")
	GUI:Button_setTitleColor(page_cell_4, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_4, 14)
	GUI:Button_titleDisableOutLine(page_cell_4)
	GUI:setChineseName(page_cell_4, "内挂主界面_保护组合")
	GUI:setTouchEnabled(page_cell_4, false)
	GUI:setTag(page_cell_4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_4, "PageText", 13.00, 56.00, 16, "#807256", [[保
护]])
	GUI:setChineseName(PageText, "内挂主界面_保护_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_4, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_保护_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_5
	local page_cell_5 = GUI:Button_Create(PMainUI, "page_cell_5", 780.00, 80.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_5, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_5, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_5, "")
	GUI:Button_setTitleColor(page_cell_5, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_5, 14)
	GUI:Button_titleDisableOutLine(page_cell_5)
	GUI:setChineseName(page_cell_5, "内挂主界面_挂机组合")
	GUI:setTouchEnabled(page_cell_5, false)
	GUI:setTag(page_cell_5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_5, "PageText", 13.00, 56.00, 16, "#807256", [[挂
机]])
	GUI:setChineseName(PageText, "内挂主界面_挂机_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_5, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_挂机_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_6
	local page_cell_6 = GUI:Button_Create(PMainUI, "page_cell_6", 780.00, 5.00, "res/public/1900000641.png")
	GUI:Button_loadTexturePressed(page_cell_6, "res/public/1900000640.png")
	GUI:Button_loadTextureDisabled(page_cell_6, "res/public/1900000640.png")
	GUI:Button_setTitleText(page_cell_6, "")
	GUI:Button_setTitleColor(page_cell_6, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_6, 14)
	GUI:Button_titleDisableOutLine(page_cell_6)
	GUI:setChineseName(page_cell_6, "内挂主界面_帮助组合")
	GUI:setTouchEnabled(page_cell_6, false)
	GUI:setTag(page_cell_6, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_6, "PageText", 13.00, 56.00, 16, "#807256", [[帮
助]])
	GUI:setChineseName(PageText, "内挂主界面_帮助_组合")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_6, "TouchSize", 0.00, 88.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "内挂主界面_帮助_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)
end
return ui