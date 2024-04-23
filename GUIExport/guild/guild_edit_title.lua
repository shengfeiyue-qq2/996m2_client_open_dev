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
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 400.00, 286.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public/1900000675.jpg")
	GUI:setContentSize(FrameBG, 400, 286)
	GUI:setIgnoreContentAdaptWithSize(FrameBG, false)
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create BtnOk
	local BtnOk = GUI:Button_Create(FrameLayout, "BtnOk", 280.00, 40.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(BtnOk, "确定")
	GUI:Button_setTitleColor(BtnOk, "#ffffff")
	GUI:Button_setTitleFontSize(BtnOk, 16)
	GUI:Button_titleEnableOutline(BtnOk, "#000000", 1)
	GUI:setAnchorPoint(BtnOk, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOk, true)
	GUI:setTag(BtnOk, -1)

	-- Create BtnCancel
	local BtnCancel = GUI:Button_Create(FrameLayout, "BtnCancel", 120.00, 40.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(BtnCancel, "取消")
	GUI:Button_setTitleColor(BtnCancel, "#ffffff")
	GUI:Button_setTitleFontSize(BtnCancel, 16)
	GUI:Button_titleEnableOutline(BtnCancel, "#000000", 1)
	GUI:setAnchorPoint(BtnCancel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCancel, true)
	GUI:setTag(BtnCancel, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 400.00, 286.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create List
	local List = GUI:ListView_Create(FrameLayout, "List", 15.00, 77.00, 370.00, 195.00, 1)
	GUI:ListView_setGravity(List, 5)
	GUI:ListView_setItemsMargin(List, 5)
	GUI:setTouchEnabled(List, true)
	GUI:setTag(List, -1)

	-- Create Item
	local Item = GUI:Layout_Create(FrameLayout, "Item", 15.00, 189.00, 370.00, 32.00, true)
	GUI:setTouchEnabled(Item, false)
	GUI:setTag(Item, -1)
	GUI:setVisible(Item, false)

	-- Create Input_bg
	local Input_bg = GUI:Image_Create(Item, "Input_bg", 92.00, 16.00, "res/public/1900000668.png")
	GUI:setAnchorPoint(Input_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Input_bg, false)
	GUI:setTag(Input_bg, -1)

	-- Create Text
	local Text = GUI:Text_Create(Item, "Text", 80.00, 16.00, 16, "#f2e7cf", [[称谓]])
	GUI:setAnchorPoint(Text, 1.00, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui