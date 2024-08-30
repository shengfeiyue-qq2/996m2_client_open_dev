local ui = {}
function ui.init(parent)
	-- Create att_cell
	local att_cell = GUI:Layout_Create(parent, "att_cell", 0.00, 0.00, 272.00, 22.00, false)
	GUI:setChineseName(att_cell, "玩家_属性组合")
	GUI:setTouchEnabled(att_cell, true)
	GUI:setTag(att_cell, 197.0)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(att_cell, "Node_1", 127.00, 11.00)
	GUI:setChineseName(Node_1, "玩家_属性节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 198.0)

	-- Create Image_numBg
	local Image_numBg = GUI:Image_Create(att_cell, "Image_numBg", 239.00, 10.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015004.png")
	GUI:Image_setScale9Slice(Image_numBg, 25, 25.0, 10, 7.0)
	GUI:setContentSize(Image_numBg, 112.0, 21.0)
	GUI:setIgnoreContentAdaptWithSize(Image_numBg, false)
	GUI:setChineseName(Image_numBg, "玩家_属性背景_图片")
	GUI:setAnchorPoint(Image_numBg, 1.00, 0.50)
	GUI:setTouchEnabled(Image_numBg, false)
	GUI:setTag(Image_numBg, 199.0)

	-- Create Text_attValue
	local Text_attValue = GUI:Text_Create(att_cell, "Text_attValue", 131.00, 10.00, 12.0, "#ffffff", [[1-1]])
	GUI:setChineseName(Text_attValue, "玩家_属性_文本")
	GUI:setAnchorPoint(Text_attValue, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attValue, false)
	GUI:setTag(Text_attValue, 200.0)
	GUI:Text_enableOutline(Text_attValue, "#111111", 1.0)

	-- Create Text_attName
	local Text_attName = GUI:Text_Create(att_cell, "Text_attName", 15.00, 10.00, 12.0, "#ffffff", [[]])
	GUI:setChineseName(Text_attName, "玩家_属性名称_文本")
	GUI:setAnchorPoint(Text_attName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attName, false)
	GUI:setTag(Text_attName, 201.0)
	GUI:Text_enableOutline(Text_attName, "#111111", 1.0)
end
return ui