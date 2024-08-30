local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "宝箱节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Node, "PMainUI", 568.00, 320.00, 250.00, 180.00, false)
	GUI:setChineseName(PMainUI, "宝箱组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 71)

	-- Create Node_box_normal
	local Node_box_normal = GUI:Node_Create(PMainUI, "Node_box_normal", 125.00, 135.00)
	GUI:setChineseName(Node_box_normal, "宝箱_正常_节点")
	GUI:setAnchorPoint(Node_box_normal, 0.50, 0.50)
	GUI:setTag(Node_box_normal, 9)

	-- Create Node_box_open
	local Node_box_open = GUI:Node_Create(PMainUI, "Node_box_open", 125.00, 265.00)
	GUI:setChineseName(Node_box_open, "宝箱_打开_节点")
	GUI:setAnchorPoint(Node_box_open, 0.50, 0.50)
	GUI:setTag(Node_box_open, 78)

	-- Create Node_open
	local Node_open = GUI:Node_Create(PMainUI, "Node_open", 125.00, 265.00)
	GUI:setChineseName(Node_open, "宝箱_打开")
	GUI:setAnchorPoint(Node_open, 0.50, 0.50)
	GUI:setTag(Node_open, 80)

	-- Create Panel_key
	local Panel_key = GUI:Layout_Create(PMainUI, "Panel_key", 130.00, 30.00, 60.00, 60.00, false)
	GUI:setChineseName(Panel_key, "宝箱_钥匙_拖拽区域")
	GUI:setTouchEnabled(Panel_key, true)
	GUI:setTag(Panel_key, 74)

	-- Create Text_tips
	local Text_tips = GUI:Text_Create(PMainUI, "Text_tips", 155.00, 55.00, 16, "#ffffff", [[拖动钥匙
到此开锁]])
	GUI:setChineseName(Text_tips, "开宝箱_提示_文本")
	GUI:setAnchorPoint(Text_tips, 0.50, 0.50)
	GUI:setTouchEnabled(Text_tips, false)
	GUI:setTag(Text_tips, 93)
	GUI:setVisible(Text_tips, false)
	GUI:Text_enableOutline(Text_tips, "#111111", 1)

	-- Create PanelPos
	local PanelPos = GUI:Layout_Create(PMainUI, "PanelPos", 54.00, 6.00, 160.00, 130.00, false)
	GUI:setChineseName(PanelPos, "宝箱_拖拽区域")
	GUI:setTouchEnabled(PanelPos, true)
	GUI:setTag(PanelPos, 73)
end
return ui