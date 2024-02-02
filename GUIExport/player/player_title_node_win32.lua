local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "玩家称号节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(Panel_1, "玩家称号组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 136.00, 174.50, "Default/ImageFile.png")
	GUI:setContentSize(Image_1, 272, 349)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "玩家称号_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 237)
	GUI:setVisible(Image_1, false)

	-- Create Image_cur
	local Image_cur = GUI:Image_Create(Panel_1, "Image_cur", 30.00, 315.00, "res/private/title_layer_ui_win32/title_5.png")
	GUI:setChineseName(Image_cur, "玩家称号图标组合")
	GUI:setAnchorPoint(Image_cur, 0.50, 0.50)
	GUI:setTouchEnabled(Image_cur, false)
	GUI:setTag(Image_cur, 26)

	-- Create Button_curTitle
	local Button_curTitle = GUI:Button_Create(Image_cur, "Button_curTitle", 17.50, 17.50, "res/private/title_layer_ui_win32/title_3.png")
	GUI:Button_setScale9Slice(Button_curTitle, 15, 15, 11, 11)
	GUI:setContentSize(Button_curTitle, 40, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_curTitle, false)
	GUI:Button_setTitleText(Button_curTitle, "")
	GUI:Button_setTitleColor(Button_curTitle, "#414146")
	GUI:Button_setTitleFontSize(Button_curTitle, 14)
	GUI:Button_titleDisableOutLine(Button_curTitle)
	GUI:setChineseName(Button_curTitle, "玩家称号_图标")
	GUI:setAnchorPoint(Button_curTitle, 0.50, 0.50)
	GUI:setTouchEnabled(Button_curTitle, true)
	GUI:setTag(Button_curTitle, 27)

	-- Create Image_11
	local Image_11 = GUI:Image_Create(Image_cur, "Image_11", 50.00, 17.50, "res/private/title_layer_ui_win32/title_1.png")
	GUI:setChineseName(Image_11, "玩家称号_背景框")
	GUI:setAnchorPoint(Image_11, 0.00, 0.50)
	GUI:setTouchEnabled(Image_11, false)
	GUI:setTag(Image_11, 28)

	-- Create Text_curTitle
	local Text_curTitle = GUI:Text_Create(Image_11, "Text_curTitle", 10.00, 15.50, 16, "#00b300", [[]])
	GUI:setChineseName(Text_curTitle, "玩家称号_当前称号")
	GUI:setAnchorPoint(Text_curTitle, 0.00, 0.50)
	GUI:setTouchEnabled(Text_curTitle, false)
	GUI:setTag(Text_curTitle, 29)
	GUI:Text_enableOutline(Text_curTitle, "#111111", 1)

	-- Create Image_12
	local Image_12 = GUI:Image_Create(Panel_1, "Image_12", 136.00, 280.00, "res/private/title_layer_ui_win32/title_0.png")
	GUI:setChineseName(Image_12, "玩家称号_名称_背景图")
	GUI:setAnchorPoint(Image_12, 0.50, 0.50)
	GUI:setTouchEnabled(Image_12, false)
	GUI:setTag(Image_12, 25)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 5.00, 272.00, 260.00, 1)
	GUI:setChineseName(ListView_cells, "玩家称号_列表")
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 24)
end
return ui