local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 115.00, 48.00, false)
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 143)

	-- Create Button_channel
	local Button_channel = GUI:Button_Create(Panel_cell, "Button_channel", 57.00, 24.00, "res/private/chat/1900012825-1.png")
	GUI:Button_loadTexturePressed(Button_channel, "res/private/chat/1900012825.png")
	GUI:Button_loadTextureDisabled(Button_channel, "res/private/chat/1900012825.png")
	GUI:Button_setScale9Slice(Button_channel, 15, 15, 11, 11)
	GUI:setContentSize(Button_channel, 108, 44)
	GUI:setIgnoreContentAdaptWithSize(Button_channel, false)
	GUI:Button_setTitleText(Button_channel, "")
	GUI:Button_setTitleColor(Button_channel, "#414146")
	GUI:Button_setTitleFontSize(Button_channel, 14)
	GUI:Button_titleDisableOutLine(Button_channel)
	GUI:setAnchorPoint(Button_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_channel, true)
	GUI:setTag(Button_channel, 142)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_cell, "Image_name", 74.00, 24.00, "res/private/chat/1900012840.png")
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 48)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 40.00, 24.00, 18, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create CheckBox_receiving
	local CheckBox_receiving = GUI:CheckBox_Create(Panel_cell, "CheckBox_receiving", 25.00, 24.00, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
	GUI:CheckBox_setSelected(CheckBox_receiving, true)
	GUI:setAnchorPoint(CheckBox_receiving, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_receiving, true)
	GUI:setTag(CheckBox_receiving, 147)
end
return ui