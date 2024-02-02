local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "自动挂机节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_1, "自动挂机组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 6)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 14.00, 380.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 578, 370)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "自动挂机_背景图")
	GUI:setAnchorPoint(Image_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 19)

	-- Create ScrollView_1
	local ScrollView_1 = GUI:ScrollView_Create(Image_1, "ScrollView_1", 0.00, 0.00, 578.00, 370.00, 1)
	GUI:ScrollView_setBounceEnabled(ScrollView_1, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_1, 578.00, 370.00)
	GUI:setChineseName(ScrollView_1, "自动挂机面板")
	GUI:setTouchEnabled(ScrollView_1, true)
	GUI:setTag(ScrollView_1, 128)
end
return ui