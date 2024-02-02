local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "英雄称号节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "英雄称号组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 174.00, 239.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_1, 348, 478)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "英雄称号_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 232)
	GUI:setVisible(Image_1, false)
	
	-- Create Image_cur
	local Image_cur = GUI:Image_Create(Panel_1, "Image_cur", 40.00, 430.00, "res/private/title_layer_ui/title_5.png")
	GUI:setChineseName(Image_cur, "英雄称号图标组合")
	GUI:setAnchorPoint(Image_cur, 0.50, 0.50)
	GUI:setTouchEnabled(Image_cur, false)
	GUI:setTag(Image_cur, 32)

	-- Create Button_curTitle
	local Button_curTitle = GUI:Button_Create(Image_cur, "Button_curTitle", 25.50, 26.50, "res/private/title_layer_ui/title_3.png")
	GUI:Button_setScale9Slice(Button_curTitle, 15, 15, 12, 10)
	GUI:setContentSize(Button_curTitle, 56, 58)
	GUI:setIgnoreContentAdaptWithSize(Button_curTitle, false)
	GUI:Button_setTitleText(Button_curTitle, "")
	GUI:Button_setTitleColor(Button_curTitle, "#414146")
	GUI:Button_setTitleFontSize(Button_curTitle, 14)
	GUI:Button_titleDisableOutLine(Button_curTitle)
	GUI:setChineseName(Button_curTitle, "英雄称号_图标")
	GUI:setAnchorPoint(Button_curTitle, 0.50, 0.50)
	GUI:setTouchEnabled(Button_curTitle, true)
	GUI:setTag(Button_curTitle, 18)

	-- Create Image_11
	local Image_11 = GUI:Image_Create(Image_cur, "Image_11", 80.00, 26.50, "res/private/title_layer_ui/title_1.png")
	GUI:setChineseName(Image_11, "英雄称号_背景框")
	GUI:setAnchorPoint(Image_11, 0.00, 0.50)
	GUI:setTouchEnabled(Image_11, false)
	GUI:setTag(Image_11, 34)

	-- Create Text_curTitle
	local Text_curTitle = GUI:Text_Create(Image_11, "Text_curTitle", 10.00, 23.50, 16, "#00b300", [[]])
	GUI:setChineseName(Text_curTitle, "英雄称号_当前称号")
	GUI:setAnchorPoint(Text_curTitle, 0.00, 0.50)
	GUI:setTouchEnabled(Text_curTitle, false)
	GUI:setTag(Text_curTitle, 35)
	GUI:Text_enableOutline(Text_curTitle, "#111111", 1)

	-- Create Image_12
	local Image_12 = GUI:Image_Create(Panel_1, "Image_12", 174.00, 375.00, "res/private/title_layer_ui/title_0.png")
	GUI:setChineseName(Image_12, "英雄称号_名称_背景图")
	GUI:setAnchorPoint(Image_12, 0.50, 0.50)
	GUI:setTouchEnabled(Image_12, false)
	GUI:setTag(Image_12, 36)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 5.00, 348.00, 350.00, 1)
	GUI:setChineseName(ListView_cells, "英雄称号_列表")
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 13)
end
return ui