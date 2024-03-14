local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setChineseName(CloseLayout, "编辑封号_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 400.00, 286.00, false)
	GUI:setChineseName(PMainUI, "编辑封号_组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setContentSize(FrameBG, 400, 286)
	GUI:setIgnoreContentAdaptWithSize(FrameBG, false)
	GUI:setChineseName(FrameBG, "编辑封号_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create BtnOk
	local BtnOk = GUI:Button_Create(PMainUI, "BtnOk", 280.00, 40.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(BtnOk, "确定")
	GUI:Button_setTitleColor(BtnOk, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnOk, 16)
	GUI:Button_titleEnableOutline(BtnOk, "#111111", 1)
	GUI:setChineseName(BtnOk, "编辑封号_确认_按钮")
	GUI:setAnchorPoint(BtnOk, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOk, true)
	GUI:setTag(BtnOk, -1)

	-- Create BtnCancel
	local BtnCancel = GUI:Button_Create(PMainUI, "BtnCancel", 120.00, 40.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(BtnCancel, "取消")
	GUI:Button_setTitleColor(BtnCancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnCancel, 16)
	GUI:Button_titleEnableOutline(BtnCancel, "#111111", 1)
	GUI:setChineseName(BtnCancel, "编辑封号_取消_按钮")
	GUI:setAnchorPoint(BtnCancel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCancel, true)
	GUI:setTag(BtnCancel, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 400.00, 287.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "编辑封号_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create List
	local List = GUI:ListView_Create(PMainUI, "List", 15.00, 77.00, 370.00, 195.00, 1)
	GUI:ListView_setGravity(List, 5)
	GUI:ListView_setItemsMargin(List, 10)
	GUI:setChineseName(List, "编辑封号_称谓列表")
	GUI:setTouchEnabled(List, true)
	GUI:setTag(List, -1)

	-- Create item
	local item = GUI:Image_Create(PMainUI, "item", 92.00, 16.00, "res/public/1900000668.png")
	GUI:setChineseName(item, "编辑封号_称谓组合")
	GUI:setAnchorPoint(item, 0.00, 0.50)
	GUI:setTouchEnabled(item, false)
	GUI:setTag(item, -1)
	GUI:setVisible(item, false)

	-- Create EditInput
	local EditInput = GUI:TextInput_Create(item, "EditInput", 0.00, 8.00, 148.00, 20.00, 16)
	GUI:TextInput_setString(EditInput, "")
	GUI:TextInput_setFontColor(EditInput, "#ffffff")
	GUI:setChineseName(EditInput, "编辑封号_称谓输入")
	GUI:setAnchorPoint(EditInput, 0.00, 0.50)
	GUI:setTouchEnabled(EditInput, true)
	GUI:setTag(EditInput, -1)

	-- Create Text
	local Text = GUI:Text_Create(item, "Text", 80.00, 16.00, 8, "#f2e7cf", [[称谓]])
	GUI:setChineseName(Text, "编辑封号_称谓_文本")
	GUI:setAnchorPoint(Text, 1.00, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui