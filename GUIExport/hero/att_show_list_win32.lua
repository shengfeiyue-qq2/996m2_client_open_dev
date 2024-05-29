local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 272.00, 22.00, false)
	GUI:setChineseName(Panel_1, "英雄_属性组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 197)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 127.50, 11.00)
	GUI:setChineseName(Node_1, "英雄_属性节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 198)

	-- Create Image_numBg
	local Image_numBg = GUI:Image_Create(Panel_1, "Image_numBg", 239.00, 10.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015004.png")
	GUI:Image_setScale9Slice(Image_numBg, 25, 25, 10, 7)
	GUI:setContentSize(Image_numBg, 112, 21)
	GUI:setIgnoreContentAdaptWithSize(Image_numBg, false)
	GUI:setChineseName(Image_numBg, "英雄_属性背景_图片")
	GUI:setAnchorPoint(Image_numBg, 1.00, 0.50)
	GUI:setTouchEnabled(Image_numBg, false)
	GUI:setTag(Image_numBg, 199)

	-- Create Text_attValue
	local Text_attValue = GUI:Text_Create(Panel_1, "Text_attValue", 131.00, 10.00, 12, "#ffffff", [[1-1]])
	GUI:setChineseName(Text_attValue, "英雄_属性_文本")
	GUI:setAnchorPoint(Text_attValue, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attValue, false)
	GUI:setTag(Text_attValue, 200)
	GUI:Text_enableOutline(Text_attValue, "#111111", 1)

	-- Create Text_attName
	local Text_attName = GUI:Text_Create(Panel_1, "Text_attName", 15.00, 10.00, 12, "#ffffff", [[]])
	GUI:setChineseName(Text_attName, "英雄_属性名称_文本")
	GUI:setAnchorPoint(Text_attName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attName, false)
	GUI:setTag(Text_attName, 201)
	GUI:Text_enableOutline(Text_attName, "#111111", 1)
end
return ui