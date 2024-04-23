local ui = {}
function ui.init(parent)
	-- Create task_cell
	local task_cell = GUI:Layout_Create(parent, "task_cell", 0.00, 0.00, 200.00, 60.00, false)
	GUI:setTouchEnabled(task_cell, true)
	GUI:setTag(task_cell, -1)

	-- Create Button_act
	local Button_act = GUI:Button_Create(task_cell, "Button_act", 100.00, 30.00, "res/public/0.png")
	GUI:Button_loadTexturePressed(Button_act, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Button_act, 200, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_act, false)
	GUI:Button_setTitleText(Button_act, "")
	GUI:Button_setTitleColor(Button_act, "#ffffff")
	GUI:Button_setTitleFontSize(Button_act, 10)
	GUI:Button_titleEnableOutline(Button_act, "#000000", 1)
	GUI:setAnchorPoint(Button_act, 0.50, 0.50)
	GUI:setTouchEnabled(Button_act, true)
	GUI:setTag(Button_act, -1)

	-- Create image_line
	local image_line = GUI:Image_Create(task_cell, "image_line", 100.00, 0.00, "res/public/1900000667_1.png")
	GUI:setContentSize(image_line, 200, 1)
	GUI:setIgnoreContentAdaptWithSize(image_line, false)
	GUI:setAnchorPoint(image_line, 0.50, 0.00)
	GUI:setTouchEnabled(image_line, false)
	GUI:setTag(image_line, -1)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(task_cell, "Node_1", 10.00, 55.00)
	GUI:setTag(Node_1, -1)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(task_cell, "Node_2", 10.00, 30.00)
	GUI:setTag(Node_2, -1)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(task_cell, "Node_sfx", 100.00, 30.00)
	GUI:setTag(Node_sfx, -1)
end
return ui