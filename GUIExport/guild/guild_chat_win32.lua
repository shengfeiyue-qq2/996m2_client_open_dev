local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "行会聊天组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Layer, "PMainUI", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(PMainUI, "行会聊天组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 34)

	-- Create Image_bottom
	local Image_bottom = GUI:Image_Create(PMainUI, "Image_bottom", 303.00, 0.00, "res/public/bg_hhdb_01.jpg")
	GUI:Image_setScale9Slice(Image_bottom, 242, 242, 21, 21)
	GUI:setContentSize(Image_bottom, 606, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_bottom, false)
	GUI:setChineseName(Image_bottom, "行会聊天_背景图")
	GUI:setAnchorPoint(Image_bottom, 0.50, 0.00)
	GUI:setTouchEnabled(Image_bottom, false)
	GUI:setTag(Image_bottom, 74)

	-- Create Input
	local Input = GUI:TextInput_Create(Image_bottom, "Input", 3.00, 2.00, 600.00, 25.00, 12)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setPlaceHolder(Input, "请输入行会聊天内容")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, -1)

	-- Create ListView_chat
	local ListView_chat = GUI:ListView_Create(PMainUI, "ListView_chat", 0.00, 30.00, 606.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_chat, 5)
	GUI:setChineseName(ListView_chat, "行会聊天_行会聊天内容")
	GUI:setTouchEnabled(ListView_chat, true)
	GUI:setTag(ListView_chat, 75)
end
return ui