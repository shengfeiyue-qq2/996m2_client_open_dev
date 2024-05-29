local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setChineseName(CloseLayout, "宣战_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568.00, 320.00, 450.00, 179.00, false)
	GUI:setChineseName(PMainUI, "宣战组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0.00, 0.00, "res/public/1900000600.png")
	GUI:setChineseName(FrameBG, "宣战_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create NodeTitle
	local NodeTitle = GUI:Node_Create(PMainUI, "NodeTitle", 225.00, 153.00)
	GUI:setChineseName(NodeTitle, "宣战_标题节点")
	GUI:setAnchorPoint(NodeTitle, 0.50, 0.50)
	GUI:setTag(NodeTitle, -1)

	-- Create TextTime
	local TextTime = GUI:Text_Create(PMainUI, "TextTime", 212.00, 118.00, 16, "#f2e7cf", [[]])
	GUI:setChineseName(TextTime, "宣战_时长_文本")
	GUI:setAnchorPoint(TextTime, 1.00, 0.50)
	GUI:setTouchEnabled(TextTime, false)
	GUI:setTag(TextTime, -1)
	GUI:Text_enableOutline(TextTime, "#000000", 1)

	-- Create TimeBg
	local TimeBg = GUI:Image_Create(PMainUI, "TimeBg", 265.00, 118.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(TimeBg, 23, 21, 4, 4)
	GUI:setContentSize(TimeBg, 100, 31)
	GUI:setIgnoreContentAdaptWithSize(TimeBg, false)
	GUI:setChineseName(TimeBg, "宣战_时长_背景框")
	GUI:setAnchorPoint(TimeBg, 0.50, 0.50)
	GUI:setTouchEnabled(TimeBg, true)
	GUI:setTag(TimeBg, -1)

	-- Create BtnArrow
	local BtnArrow = GUI:Button_Create(TimeBg, "BtnArrow", 80.00, 15.00, "res/public/btn_szjm_01.png")
	GUI:Button_setTitleText(BtnArrow, "")
	GUI:Button_setTitleColor(BtnArrow, "#ffffff")
	GUI:Button_setTitleFontSize(BtnArrow, 10)
	GUI:Button_titleEnableOutline(BtnArrow, "#000000", 1)
	GUI:setChineseName(BtnArrow, "宣战_时长_下拉按钮")
	GUI:setAnchorPoint(BtnArrow, 0.50, 0.50)
	GUI:setTouchEnabled(BtnArrow, true)
	GUI:setTag(BtnArrow, -1)

	-- Create Time
	local Time = GUI:Text_Create(TimeBg, "Time", 34.00, 16.00, 16, "#f2e7cf", [[]])
	GUI:setChineseName(Time, "宣战_时长")
	GUI:setAnchorPoint(Time, 0.50, 0.50)
	GUI:setTouchEnabled(Time, false)
	GUI:setTag(Time, -1)
	GUI:Text_enableOutline(Time, "#000000", 1)

	-- Create labCost
	local labCost = GUI:Text_Create(PMainUI, "labCost", 212.00, 85.00, 16, "#f2e7cf", [[]])
	GUI:setChineseName(labCost, "宣战_花费_文本")
	GUI:setAnchorPoint(labCost, 1.00, 0.50)
	GUI:setTouchEnabled(labCost, false)
	GUI:setTag(labCost, -1)
	GUI:Text_enableOutline(labCost, "#000000", 1)

	-- Create TextCost
	local TextCost = GUI:Text_Create(PMainUI, "TextCost", 214.00, 85.00, 16, "#0bc50b", [[]])
	GUI:setChineseName(TextCost, "宣战_货币数量_文本")
	GUI:setAnchorPoint(TextCost, 0.00, 0.50)
	GUI:setTouchEnabled(TextCost, false)
	GUI:setTag(TextCost, -1)
	GUI:Text_enableOutline(TextCost, "#000000", 1)

	-- Create BtnCancel
	local BtnCancel = GUI:Button_Create(PMainUI, "BtnCancel", 112.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnCancel, "取消")
	GUI:Button_setTitleColor(BtnCancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnCancel, 16)
	GUI:Button_titleEnableOutline(BtnCancel, "#111111", 2)
	GUI:setChineseName(BtnCancel, "宣战_取消_按钮")
	GUI:setAnchorPoint(BtnCancel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCancel, true)
	GUI:setTag(BtnCancel, -1)

	-- Create BtnOk
	local BtnOk = GUI:Button_Create(PMainUI, "BtnOk", 344.00, 40.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(BtnOk, "确定")
	GUI:Button_setTitleColor(BtnOk, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnOk, 16)
	GUI:Button_titleEnableOutline(BtnOk, "#111111", 2)
	GUI:setChineseName(BtnOk, "宣战_确认_按钮")
	GUI:setAnchorPoint(BtnOk, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOk, true)
	GUI:setTag(BtnOk, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 449.00, 179.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "宣战_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 1.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create ListBg
	local ListBg = GUI:Image_Create(PMainUI, "ListBg", 265.00, 100.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(ListBg, 15, 15, 20, 19)
	GUI:setContentSize(ListBg, 125, 155)
	GUI:setIgnoreContentAdaptWithSize(ListBg, false)
	GUI:setChineseName(ListBg, "宣战_下拉时间_背景图")
	GUI:setAnchorPoint(ListBg, 0.50, 1.00)
	GUI:setTouchEnabled(ListBg, false)
	GUI:setTag(ListBg, -1)
	GUI:setVisible(ListBg, false)

	-- Create ListView
	local ListView = GUI:ListView_Create(ListBg, "ListView", 5.00, 5.00, 115.00, 145.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setChineseName(ListView, "宣战_下拉时间_列表")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create ListCell
	local ListCell = GUI:Layout_Create(PMainUI, "ListCell", 0.00, 0.00, 115.00, 35.00, false)
	GUI:setChineseName(ListCell, "宣战_下拉时间组合")
	GUI:setTouchEnabled(ListCell, true)
	GUI:setTag(ListCell, -1)
	GUI:setVisible(ListCell, false)

	-- Create ImageSel
	local ImageSel = GUI:Image_Create(ListCell, "ImageSel", 0.00, 0.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(ImageSel, 20, 34, 5, 2)
	GUI:setContentSize(ImageSel, 115, 35)
	GUI:setIgnoreContentAdaptWithSize(ImageSel, false)
	GUI:setChineseName(ImageSel, "宣战_下拉时间_选中背景")
	GUI:setTouchEnabled(ImageSel, false)
	GUI:setTag(ImageSel, -1)

	-- Create Text
	local Text = GUI:Text_Create(ListCell, "Text", 57.00, 17.00, 16, "#f7f0e2", [[]])
	GUI:setChineseName(Text, "宣战_下拉选中_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui