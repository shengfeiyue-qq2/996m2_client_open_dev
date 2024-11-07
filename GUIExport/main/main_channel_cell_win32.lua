local ui = {}
function ui.init(parent)
	-- Create channel_cell
	local channel_cell = GUI:Layout_Create(parent, "channel_cell", 0.00, 0.00, 48.00, 16.00, true)
	GUI:setChineseName(channel_cell, "聊天_子频道组合")
	GUI:setTouchEnabled(channel_cell, true)
	GUI:setTag(channel_cell, 148)

	-- Create Image_selected
	local Image_selected = GUI:Image_Create(channel_cell, "Image_selected", 24.00, 8.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_selected, 55, 16)
	GUI:setIgnoreContentAdaptWithSize(Image_selected, false)
	GUI:setChineseName(Image_selected, "聊天_子频道选择_背景图")
	GUI:setAnchorPoint(Image_selected, 0.50, 0.50)
	GUI:setTouchEnabled(Image_selected, false)
	GUI:setTag(Image_selected, 149)

	-- Create Text_title
	local Text_title = GUI:BmpText_Create(channel_cell, "Text_title", 24.00, 8.00, "#ffffff", [[xxx]])
	GUI:setChineseName(Text_title, "聊天_子频道_文本")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 150)
end
return ui