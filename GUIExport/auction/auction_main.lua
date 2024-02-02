local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 76)
	GUI:setChineseName(CloseLayout, "拍卖行主窗体_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(FrameLayout, "拍卖行主窗体组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "拍卖行主窗体_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "拍卖行主窗体_装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 486.00, 20, "#d8c8ae", [[拍卖行]])
	GUI:setChineseName(TitleText, "拍卖行主窗体_标题")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780.00, 477.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "拍卖行主窗体_关闭_按钮")
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create ListView_group
	local ListView_group = GUI:ListView_Create(FrameLayout, "ListView_group", 35.00, 477.00, 490.00, 35.00, 2)
	GUI:ListView_setGravity(ListView_group, 3)
	GUI:setChineseName(ListView_group, "拍卖行主窗体_拍卖分组")
	GUI:setAnchorPoint(ListView_group, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_group, false)
	GUI:setTag(ListView_group, 59)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", 30.00, 32.00, 732.00, 445.00, false)
	GUI:setChineseName(AttachLayout, "拍卖行主窗体_详细内容")
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)

	-- Create Panel_search
	local Panel_search = GUI:Layout_Create(FrameLayout, "Panel_search", 745.00, 442.00, 220.00, 35.00, false)
	GUI:setChineseName(Panel_search, "拍卖行主窗体_搜索组合")
	GUI:setAnchorPoint(Panel_search, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_search, true)
	GUI:setTag(Panel_search, 94)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_search, "Image_1", 20.00, 17.00, "res/public/btn_szjm_02.png")
	GUI:setChineseName(Image_1, "拍卖行主窗体_查询_装饰图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 95)

	-- Create ImageView
	local ImageView = GUI:Image_Create(Panel_search, "ImageView", 38.00, 17.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(ImageView, 52, 52, 12, 8)
	GUI:setContentSize(ImageView, 120, 34)
	GUI:setIgnoreContentAdaptWithSize(ImageView, false)
	GUI:setChineseName(ImageView, "拍卖行主窗体_搜索_背景框")
	GUI:setAnchorPoint(ImageView, 0.00, 0.50)
	GUI:setTouchEnabled(ImageView, false)
	GUI:setTag(ImageView, -1)

	-- Create SearchInput
	local SearchInput = GUI:TextInput_Create(Panel_search, "SearchInput", 40.00, 17.00, 118.00, 30.00, 16)
	GUI:TextInput_setString(SearchInput, "")
	GUI:TextInput_setPlaceHolder(SearchInput, "请输入物品名")
	GUI:TextInput_setFontColor(SearchInput, "#ffffff")
	GUI:TextInput_setMaxLength(SearchInput, 10)
	GUI:setChineseName(SearchInput, "拍卖行主窗体_搜索内容")
	GUI:setAnchorPoint(SearchInput, 0.00, 0.50)
	GUI:setTouchEnabled(SearchInput, true)
	GUI:setTag(SearchInput, 93)

	-- Create Button_confirm
	local Button_confirm = GUI:Button_Create(Panel_search, "Button_confirm", 190.00, 17.00, "res/public/btn_fanye_03.png")
	GUI:Button_loadTexturePressed(Button_confirm, "res/public/btn_fanye_03_1.png")
	GUI:Button_loadTextureDisabled(Button_confirm, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_confirm, 15, 15, 12, 10)
	GUI:setContentSize(Button_confirm, 63, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_confirm, false)
	GUI:Button_setTitleText(Button_confirm, "确认")
	GUI:Button_setTitleColor(Button_confirm, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_confirm, 16)
	GUI:Button_titleEnableOutline(Button_confirm, "#111111", 2)
	GUI:setChineseName(Button_confirm, "拍卖行主窗体_确认搜索_按钮")
	GUI:setAnchorPoint(Button_confirm, 0.50, 0.50)
	GUI:setTouchEnabled(Button_confirm, true)
	GUI:setTag(Button_confirm, 96)
end
return ui