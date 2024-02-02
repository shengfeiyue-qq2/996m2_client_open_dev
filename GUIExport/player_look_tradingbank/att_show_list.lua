local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 348.00, 27.00, false)
	GUI:setChineseName(Panel_1, "玩家_属性组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 104)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 173.00, 13.50)
	GUI:setChineseName(Node_1, "玩家_属性_节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 112)

	-- Create Image_numBg
	local Image_numBg = GUI:Image_Create(Panel_1, "Image_numBg", 284.00, 13.50, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015004.png")
	GUI:Image_setScale9Slice(Image_numBg, 60, 60, 10, 8)
	GUI:setContentSize(Image_numBg, 110, 22)
	GUI:setIgnoreContentAdaptWithSize(Image_numBg, false)
	GUI:setChineseName(Image_numBg, "玩家_属性背景_图片")
	GUI:setAnchorPoint(Image_numBg, 1.00, 0.50)
	GUI:setTouchEnabled(Image_numBg, false)
	GUI:setTag(Image_numBg, 107)

	-- Create Text_attValue
	local Text_attValue = GUI:Text_Create(Panel_1, "Text_attValue", 176.00, 13.50, 16, "#ffffff", [[1-1]])
	GUI:setChineseName(Text_attValue, "玩家_属性_文本")
	GUI:setAnchorPoint(Text_attValue, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attValue, false)
	GUI:setTag(Text_attValue, 108)
	GUI:Text_enableOutline(Text_attValue, "#111111", 1)

	-- Create Text_attName
	local Text_attName = GUI:Text_Create(Panel_1, "Text_attName", 27.00, 13.50, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_attName, "玩家_属性名称_文本")
	GUI:setAnchorPoint(Text_attName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attName, false)
	GUI:setTag(Text_attName, 70)
	GUI:Text_enableOutline(Text_attName, "#111111", 1)
end
return ui