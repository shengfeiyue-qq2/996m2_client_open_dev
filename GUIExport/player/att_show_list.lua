local ui = {}
function ui.init(parent)
	-- Create att_cell
	local att_cell = GUI:Layout_Create(parent, "att_cell", 0.00, 0.00, 348.00, 27.00, false)
	GUI:setChineseName(att_cell, "玩家_属性组合")
	GUI:setTouchEnabled(att_cell, true)
	GUI:setTag(att_cell, 104.0)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(att_cell, "Node_1", 173.00, 13.00)
	GUI:setChineseName(Node_1, "玩家_属性节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 112.0)

	-- Create Image_numBg
	local Image_numBg = GUI:Image_Create(att_cell, "Image_numBg", 284.00, 13.00, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015004.png")
	GUI:Image_setScale9Slice(Image_numBg, 60, 60.0, 10, 8.0)
	GUI:setContentSize(Image_numBg, 110.0, 22.0)
	GUI:setIgnoreContentAdaptWithSize(Image_numBg, false)
	GUI:setChineseName(Image_numBg, "玩家_属性背景_图片")
	GUI:setAnchorPoint(Image_numBg, 1.00, 0.50)
	GUI:setTouchEnabled(Image_numBg, false)
	GUI:setTag(Image_numBg, 107.0)

	-- Create Text_attValue
	local Text_attValue = GUI:Text_Create(att_cell, "Text_attValue", 176.00, 13.00, 16.0, "#ffffff", [[1-1]])
	GUI:setChineseName(Text_attValue, "玩家_属性_文本")
	GUI:setAnchorPoint(Text_attValue, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attValue, false)
	GUI:setTag(Text_attValue, 108.0)
	GUI:Text_enableOutline(Text_attValue, "#111111", 1.0)

	-- Create Text_attName
	local Text_attName = GUI:Text_Create(att_cell, "Text_attName", 27.00, 13.00, 16.0, "#ffffff", [[]])
	GUI:setChineseName(Text_attName, "玩家_属性名称_文本")
	GUI:setAnchorPoint(Text_attName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attName, false)
	GUI:setTag(Text_attName, 70.0)
	GUI:Text_enableOutline(Text_attName, "#111111", 1.0)
end
return ui