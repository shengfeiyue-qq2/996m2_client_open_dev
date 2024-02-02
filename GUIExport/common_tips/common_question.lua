local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 10)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 568.00, 320.00, "res/public/common_questionBG.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, true)
	GUI:setTag(Image_bg, 12)

	-- Create Text_question
	local Text_question = GUI:Text_Create(Image_bg, "Text_question", 22.00, 361.00, 18, "#ffe400", [[绝对地址前面应使用下列哪个符号？]])
	GUI:setAnchorPoint(Text_question, 0.00, 1.00)
	GUI:setTouchEnabled(Text_question, false)
	GUI:setTag(Text_question, 15)
	GUI:Text_enableOutline(Text_question, "#111111", 1)

	-- Create ListView
	local ListView = GUI:ListView_Create(Image_bg, "ListView", 21.00, 134.00, 538.00, 228.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setAnchorPoint(ListView, 0.00, 0.50)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 72)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Image_bg, "Text_time", 571.00, 63.00, 18, "#ffe400", [[10S]])
	GUI:setAnchorPoint(Text_time, 0.00, 1.00)
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, 73)
	GUI:Text_enableOutline(Text_time, "#111111", 1)

	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(Image_bg, "Panel_item", 25.00, 137.00, 538.00, 57.00, false)
	GUI:setAnchorPoint(Panel_item, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 75)

	-- Create Text_answer
	local Text_answer = GUI:Text_Create(Panel_item, "Text_answer", 35.00, 28.00, 18, "#ffe400", [[这是答案]])
	GUI:setAnchorPoint(Text_answer, 0.00, 0.50)
	GUI:setTouchEnabled(Text_answer, false)
	GUI:setTag(Text_answer, 76)
	GUI:Text_enableOutline(Text_answer, "#111111", 1)

	-- Create CheckBox_1
	local CheckBox_1 = GUI:CheckBox_Create(Panel_item, "CheckBox_1", 2.00, 27.00, "res/public/1900000682.png", "res/public/1900000683.png")
	GUI:CheckBox_setSelected(CheckBox_1, true)
	GUI:setAnchorPoint(CheckBox_1, 0.00, 0.50)
	GUI:setTouchEnabled(CheckBox_1, true)
	GUI:setTag(CheckBox_1, 74)
end
return ui