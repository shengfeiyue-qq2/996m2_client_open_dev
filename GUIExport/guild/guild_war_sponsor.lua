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
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 450.00, 179.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public/1900000600.png")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create NodeTitle
	local NodeTitle = GUI:Node_Create(FrameLayout, "NodeTitle", 225.00, 153.00)
	GUI:setAnchorPoint(NodeTitle, 0.50, 0.50)
	GUI:setTag(NodeTitle, -1)

	-- Create TextTime
	local TextTime = GUI:Text_Create(FrameLayout, "TextTime", 202.00, 118.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(TextTime, 1.00, 0.50)
	GUI:setTouchEnabled(TextTime, false)
	GUI:setTag(TextTime, -1)
	GUI:Text_enableOutline(TextTime, "#000000", 1)

	-- Create TimeBg
	local TimeBg = GUI:Image_Create(FrameLayout, "TimeBg", 255.00, 118.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(TimeBg, 22, 22, 4, 4)
	GUI:setContentSize(TimeBg, 100, 31)
	GUI:setIgnoreContentAdaptWithSize(TimeBg, false)
	GUI:setAnchorPoint(TimeBg, 0.50, 0.50)
	GUI:setTouchEnabled(TimeBg, true)
	GUI:setTag(TimeBg, -1)

	-- Create BtnArrow
	local BtnArrow = GUI:Button_Create(TimeBg, "BtnArrow", 80.00, 15.00, "res/public/btn_szjm_01.png")
	GUI:Button_setTitleText(BtnArrow, "")
	GUI:Button_setTitleColor(BtnArrow, "#ffffff")
	GUI:Button_setTitleFontSize(BtnArrow, 10)
	GUI:Button_titleEnableOutline(BtnArrow, "#000000", 1)
	GUI:setAnchorPoint(BtnArrow, 0.50, 0.50)
	GUI:setTouchEnabled(BtnArrow, true)
	GUI:setTag(BtnArrow, -1)

	-- Create Time
	local Time = GUI:Text_Create(TimeBg, "Time", 34.00, 16.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(Time, 0.50, 0.50)
	GUI:setTouchEnabled(Time, false)
	GUI:setTag(Time, -1)
	GUI:Text_enableOutline(Time, "#000000", 1)

	-- Create labCost
	local labCost = GUI:Text_Create(FrameLayout, "labCost", 212.00, 85.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(labCost, 1.00, 0.50)
	GUI:setTouchEnabled(labCost, false)
	GUI:setTag(labCost, -1)
	GUI:Text_enableOutline(labCost, "#000000", 1)

	-- Create TextCost
	local TextCost = GUI:Text_Create(FrameLayout, "TextCost", 214.00, 85.00, 16, "#0bc50b", [[]])
	GUI:setAnchorPoint(TextCost, 0.00, 0.50)
	GUI:setTouchEnabled(TextCost, false)
	GUI:setTag(TextCost, -1)
	GUI:Text_enableOutline(TextCost, "#000000", 1)

	-- Create BtnCancel
	local BtnCancel = GUI:Button_Create(FrameLayout, "BtnCancel", 74.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnCancel, "取消")
	GUI:Button_setTitleColor(BtnCancel, "#ffffff")
	GUI:Button_setTitleFontSize(BtnCancel, 16)
	GUI:Button_titleEnableOutline(BtnCancel, "#000000", 1)
	GUI:setAnchorPoint(BtnCancel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCancel, true)
	GUI:setTag(BtnCancel, -1)

	-- Create BtnOk
	local BtnOk = GUI:Button_Create(FrameLayout, "BtnOk", 378.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnOk, "确定")
	GUI:Button_setTitleColor(BtnOk, "#ffffff")
	GUI:Button_setTitleFontSize(BtnOk, 16)
	GUI:Button_titleEnableOutline(BtnOk, "#000000", 1)
	GUI:setAnchorPoint(BtnOk, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOk, true)
	GUI:setTag(BtnOk, -1)

	-- Create ListBg
	local ListBg = GUI:Image_Create(FrameLayout, "ListBg", 232.00, 100.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(ListBg, 15, 15, 20, 20)
	GUI:setContentSize(ListBg, 125, 155)
	GUI:setIgnoreContentAdaptWithSize(ListBg, false)
	GUI:setAnchorPoint(ListBg, 0.50, 1.00)
	GUI:setTouchEnabled(ListBg, false)
	GUI:setTag(ListBg, -1)
	GUI:setVisible(ListBg, false)

	-- Create ListView
	local ListView = GUI:ListView_Create(ListBg, "ListView", 5.00, 5.00, 115.00, 145.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create Item
	local Item = GUI:Layout_Create(FrameLayout, "Item", 194.00, -53.00, 115.00, 35.00, false)
	GUI:setTouchEnabled(Item, true)
	GUI:setTag(Item, -1)
	GUI:setVisible(Item, false)

	-- Create ImageSel
	local ImageSel = GUI:Image_Create(Item, "ImageSel", 0.00, 0.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(ImageSel, 20, 34, 5, 2)
	GUI:setContentSize(ImageSel, 115, 35)
	GUI:setIgnoreContentAdaptWithSize(ImageSel, false)
	GUI:setTouchEnabled(ImageSel, false)
	GUI:setTag(ImageSel, -1)

	-- Create Text
	local Text = GUI:Text_Create(Item, "Text", 57.00, 17.00, 16, "#f7f0e2", [[]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui