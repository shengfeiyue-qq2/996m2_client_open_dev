local ui = {}
function ui.init(parent)
	-- Create mission_cell
	local mission_cell = GUI:Layout_Create(parent, "mission_cell", 200.00, 200.00, 200.00, 60.00, false)
	GUI:setChineseName(mission_cell, "引导任务组合")
	GUI:setTouchEnabled(mission_cell, true)
	GUI:setTag(mission_cell, -1)

	-- Create Button_act
	local Button_act = GUI:Button_Create(mission_cell, "Button_act", 100.00, 30.00, "")
	GUI:Button_loadTexturePressed(Button_act, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Button_act, 200, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_act, false)
	GUI:Button_setTitleText(Button_act, "")
	GUI:Button_setTitleColor(Button_act, "#ffffff")
	GUI:Button_setTitleFontSize(Button_act, 10)
	GUI:Button_titleEnableOutline(Button_act, "#000000", 1)
	GUI:setChineseName(Button_act, "引导任务_按钮")
	GUI:setAnchorPoint(Button_act, 0.50, 0.50)
	GUI:setTouchEnabled(Button_act, true)
	GUI:setTag(Button_act, -1)

	-- Create image_line
	local image_line = GUI:Image_Create(mission_cell, "image_line", 100.00, 0.00, "res/public/1900000667_1.png")
	GUI:setContentSize(image_line, 200, 1)
	GUI:setIgnoreContentAdaptWithSize(image_line, false)
	GUI:setChineseName(image_line, "引导任务_装饰条")
	GUI:setAnchorPoint(image_line, 0.50, 0.00)
	GUI:setTouchEnabled(image_line, false)
	GUI:setTag(image_line, -1)

	-- Create Node_title
	local Node_title = GUI:Node_Create(mission_cell, "Node_title", 10.00, 55.00)
	GUI:setChineseName(Node_title, "引导任务_标题_节点")
	GUI:setTag(Node_title, -1)

	-- Create Node_content
	local Node_content = GUI:Node_Create(mission_cell, "Node_content", 10.00, 30.00)
	GUI:setChineseName(Node_content, "引导任务_内容_节点")
	GUI:setTag(Node_content, -1)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(mission_cell, "Node_sfx", 100.00, 30.00)
	GUI:setChineseName(Node_sfx, "引导任务_执行触发_节点")
	GUI:setTag(Node_sfx, -1)
end
return ui