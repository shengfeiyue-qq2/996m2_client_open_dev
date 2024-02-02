local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "连击技能节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(Panel_1, "连击组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 189)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 136.00, 174.00, "res/private/internal_win32/ng_bg.png")
	GUI:setChineseName(Image_1, "连击技能_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 237)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 136.00, 310.00, "res/private/internal_win32/ng_state_title.png")
	GUI:setChineseName(Image_title, "连击技能_标题")
	GUI:setAnchorPoint(Image_title, 0.50, 0.00)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 136.00, 17.00, 244.00, 288.00, false)
	GUI:setChineseName(Panel_2, "连击技能列表组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 238)

	-- Create ListView_state
	local ListView_state = GUI:ListView_Create(Panel_2, "ListView_state", 0.00, 0.00, 244.00, 288.00, 1)
	GUI:ListView_setGravity(ListView_state, 5)
	GUI:setChineseName(ListView_state, "连击技能_技能列表")
	GUI:setTouchEnabled(ListView_state, true)
	GUI:setTag(ListView_state, 190)
end
return ui