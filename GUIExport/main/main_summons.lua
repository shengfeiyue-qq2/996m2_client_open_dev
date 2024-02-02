local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", -225.00, 345.00)
	GUI:setChineseName(Node, "宠物节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 60.00, 60.00, false)
	GUI:setChineseName(Panel_1, "宠物战斗_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 65)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_1, "Image_icon", 30.00, 30.00, "res/private/main/summons/icon_sifud_04.png")
	GUI:setChineseName(Image_icon, "宠物战斗_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setScaleX(Image_icon, 0.95)
	GUI:setScaleY(Image_icon, 0.95)
	GUI:setTouchEnabled(Image_icon, true)
	GUI:setTag(Image_icon, 168)

	-- Create Image_mode
	local Image_mode = GUI:Image_Create(Panel_1, "Image_mode", 30.00, 15.00, "res/private/main/summons/word_zhaohuanwu_01.png")
	GUI:setChineseName(Image_mode, "宠物战斗_战斗文字_图片")
	GUI:setAnchorPoint(Image_mode, 0.50, 0.50)
	GUI:setTouchEnabled(Image_mode, false)
	GUI:setTag(Image_mode, 31)
end
return ui