local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "玩家其他属性节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "玩家其他属性组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 39)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 174.00, 239.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_1, 348, 478)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "玩家其他属性_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 244)
	GUI:setVisible(Image_1, false)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_2, "玩家其他属性组合")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 247)

	-- Create ListView_extraAtt
	local ListView_extraAtt = GUI:ListView_Create(Panel_2, "ListView_extraAtt", 0.00, 0.00, 348.00, 478.00, 1)
	GUI:setChineseName(ListView_extraAtt, "玩家其他属性_列表")
	GUI:setTouchEnabled(ListView_extraAtt, true)
	GUI:setTag(ListView_extraAtt, 111)
end
return ui