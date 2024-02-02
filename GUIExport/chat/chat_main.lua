local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Node, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(Panel_touch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 133)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 462.00, 640.00, false)
	GUI:setAnchorPoint(Panel_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 121)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 0.00, 640.00, "res/private/chat/1900012800.png")
	GUI:Image_setScale9Slice(Image_bg, 173, 173, 301, 299)
	GUI:setContentSize(Image_bg, 462, 612)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, true)
	GUI:setTag(Image_bg, 123)

	-- Create Image_list_bg
	local Image_list_bg = GUI:Image_Create(Panel_bg, "Image_list_bg", 120.00, 635.00, "res/private/chat/1900012801.png")
	GUI:Image_setScale9Slice(Image_list_bg, 138, 138, 172, 172)
	GUI:setContentSize(Image_list_bg, 327, 485)
	GUI:setIgnoreContentAdaptWithSize(Image_list_bg, false)
	GUI:setAnchorPoint(Image_list_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_list_bg, false)
	GUI:setTag(Image_list_bg, 149)

	-- Create ListView_receive
	local ListView_receive = GUI:ListView_Create(Panel_bg, "ListView_receive", 0.00, 635.00, 115.00, 500.00, 1)
	GUI:setAnchorPoint(ListView_receive, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_receive, false)
	GUI:setTag(ListView_receive, 75)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_bg, "ListView_cells", 125.00, 635.00, 315.00, 475.00, 1)
	GUI:setAnchorPoint(ListView_cells, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 92)

	-- Create ListView_ex
	local ListView_ex = GUI:ListView_Create(Panel_bg, "ListView_ex", 125.00, 635.00, 315.00, 90.00, 1)
	GUI:setAnchorPoint(ListView_ex, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_ex, true)
	GUI:setTag(ListView_ex, 43)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_bg, "Image_line", 231.00, 151.00, "res/private/chat/1900012806.png")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 51)

	-- Create Image_close
	local Image_close = GUI:Image_Create(Panel_bg, "Image_close", 462.00, 320.00, "res/private/chat/1900012803.png")
	GUI:setAnchorPoint(Image_close, 1.00, 0.50)
	GUI:setTouchEnabled(Image_close, false)
	GUI:setTag(Image_close, 41)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 483.00, 640.00, "res/private/chat/1900012802.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 11, 11)
	GUI:setContentSize(Button_close, 83, 95)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 1.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 51)

	-- Create Panel_input
	local Panel_input = GUI:Layout_Create(Panel_bg, "Panel_input", 0.00, 30.00, 465.00, 120.00, false)
	GUI:setTouchEnabled(Panel_input, true)
	GUI:setTag(Panel_input, 109)

	-- Create Image_input
	local Image_input = GUI:Image_Create(Panel_input, "Image_input", 9.00, 32.00, "res/private/chat/1900012805.png")
	GUI:Image_setScale9Slice(Image_input, 50, 50, 10, 10)
	GUI:setContentSize(Image_input, 355, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_input, false)
	GUI:setAnchorPoint(Image_input, 0.00, 0.50)
	GUI:setTouchEnabled(Image_input, false)
	GUI:setTag(Image_input, 152)

	-- Create Image_channel
	local Image_channel = GUI:Image_Create(Panel_input, "Image_channel", 54.00, 31.00, "res/private/chat/1900012834.png")
	GUI:setAnchorPoint(Image_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_channel, false)
	GUI:setTag(Image_channel, 154)

	-- Create Image_arrow
	local Image_arrow = GUI:Image_Create(Panel_input, "Image_arrow", 95.00, 31.00, "res/private/chat/1900012828.png")
	GUI:setAnchorPoint(Image_arrow, 0.50, 0.50)
	GUI:setTouchEnabled(Image_arrow, false)
	GUI:setTag(Image_arrow, 155)

	-- Create Image_33
	local Image_33 = GUI:Image_Create(Panel_input, "Image_33", 120.00, 32.00, "res/private/chat/bg_liaotianzy_07.png")
	GUI:setAnchorPoint(Image_33, 0.50, 0.50)
	GUI:setTouchEnabled(Image_33, false)
	GUI:setTag(Image_33, 152)

	-- Create TextField_input
	local TextField_input = GUI:TextInput_Create(Panel_input, "TextField_input", 360.00, 32.00, 240.00, 33.00, 24)
	GUI:TextInput_setString(TextField_input, "")
	GUI:TextInput_setPlaceHolder(TextField_input, "点击输入内容")
	GUI:TextInput_setFontColor(TextField_input, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_input, 30)
	GUI:setAnchorPoint(TextField_input, 1.00, 0.50)
	GUI:setTouchEnabled(TextField_input, true)
	GUI:setTag(TextField_input, 154)

	-- Create Image_target
	local Image_target = GUI:Image_Create(Panel_input, "Image_target", 119.81, 65.13, "res/private/chat/bg_siliao_01.png")
	GUI:setContentSize(Image_target, 160, 27)
	GUI:setIgnoreContentAdaptWithSize(Image_target, false)
	GUI:setAnchorPoint(Image_target, 0.00, 0.50)
	GUI:setTouchEnabled(Image_target, true)
	GUI:setTag(Image_target, 97)

	-- Create Text_target
	local Text_target = GUI:Text_Create(Image_target, "Text_target", 5.00, 13.50, 18, "#ffff00", [[玩家名字八个字]])
	GUI:setAnchorPoint(Text_target, 0.00, 0.50)
	GUI:setTouchEnabled(Text_target, false)
	GUI:setTag(Text_target, 40)
	GUI:Text_enableOutline(Text_target, "#000000", 1)

	-- Create Image_target_a
	local Image_target_a = GUI:Image_Create(Image_target, "Image_target_a", 160.00, 13.50, "res/private/chat/1900012827.png")
	GUI:setAnchorPoint(Image_target_a, 1.00, 0.50)
	GUI:setTouchEnabled(Image_target_a, false)
	GUI:setTag(Image_target_a, 98)

	-- Create Button_send
	local Button_send = GUI:Button_Create(Panel_input, "Button_send", 411.00, 32.00, "res/private/chat/1900012823.png")
	GUI:Button_loadTexturePressed(Button_send, "res/private/chat/1900012824.png")
	GUI:Button_setTitleText(Button_send, "")
	GUI:Button_setTitleColor(Button_send, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_send, 18)
	GUI:Button_titleEnableOutline(Button_send, "#111111", 2)
	GUI:setAnchorPoint(Button_send, 0.50, 0.50)
	GUI:setTouchEnabled(Button_send, true)
	GUI:setTag(Button_send, 155)

	-- Create Image_send
	local Image_send = GUI:Image_Create(Button_send, "Image_send", 34.00, 20.00, "res/private/chat/1900012835.png")
	GUI:setAnchorPoint(Image_send, 0.50, 0.50)
	GUI:setTouchEnabled(Image_send, false)
	GUI:setTag(Image_send, 78)

	-- Create Button_input_2
	local Button_input_2 = GUI:Button_Create(Panel_input, "Button_input_2", 150.00, 100.00, "res/private/chat/1900012852.png")
	GUI:Button_setTitleText(Button_input_2, "")
	GUI:Button_setTitleColor(Button_input_2, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_input_2, 18)
	GUI:Button_titleEnableOutline(Button_input_2, "#111111", 2)
	GUI:setAnchorPoint(Button_input_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_input_2, true)
	GUI:setTag(Button_input_2, 27)

	-- Create Button_input_3
	local Button_input_3 = GUI:Button_Create(Panel_input, "Button_input_3", 230.00, 100.00, "res/private/chat/1900012856.png")
	GUI:Button_setTitleText(Button_input_3, "")
	GUI:Button_setTitleColor(Button_input_3, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_input_3, 18)
	GUI:Button_titleEnableOutline(Button_input_3, "#111111", 2)
	GUI:setAnchorPoint(Button_input_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_input_3, true)
	GUI:setTag(Button_input_3, 140)

	-- Create Button_input_4
	local Button_input_4 = GUI:Button_Create(Panel_input, "Button_input_4", 310.00, 100.00, "res/private/chat/1900012858.png")
	GUI:Button_setTitleText(Button_input_4, "")
	GUI:Button_setTitleColor(Button_input_4, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_input_4, 18)
	GUI:Button_titleEnableOutline(Button_input_4, "#111111", 2)
	GUI:setAnchorPoint(Button_input_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_input_4, true)
	GUI:setTag(Button_input_4, 141)

	-- Create Button_input_5
	local Button_input_5 = GUI:Button_Create(Panel_input, "Button_input_5", 390.00, 100.00, "res/private/chat/1900012861.png")
	GUI:Button_loadTexturePressed(Button_input_5, "res/private/chat/1900012860.png")
	GUI:Button_setTitleText(Button_input_5, "")
	GUI:Button_setTitleColor(Button_input_5, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_input_5, 18)
	GUI:Button_titleEnableOutline(Button_input_5, "#111111", 2)
	GUI:setAnchorPoint(Button_input_5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_input_5, true)
	GUI:setTag(Button_input_5, 41)

	-- Create Panel_channel
	local Panel_channel = GUI:Layout_Create(Panel_bg, "Panel_channel", 10.00, 80.00, 90.00, 212.00, false)
	GUI:setTouchEnabled(Panel_channel, true)
	GUI:setTag(Panel_channel, 186)

	-- Create Image_channel
	local Image_channel = GUI:Image_Create(Panel_channel, "Image_channel", 45.00, 106.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_channel, 19, 19, 15, 15)
	GUI:setContentSize(Image_channel, 90, 212)
	GUI:setIgnoreContentAdaptWithSize(Image_channel, false)
	GUI:setAnchorPoint(Image_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_channel, false)
	GUI:setTag(Image_channel, 187)

	-- Create ListView_channel
	local ListView_channel = GUI:ListView_Create(Panel_channel, "ListView_channel", 45.00, 106.00, 90.00, 208.00, 1)
	GUI:ListView_setGravity(ListView_channel, 2)
	GUI:setAnchorPoint(ListView_channel, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_channel, false)
	GUI:setTag(ListView_channel, 188)

	-- Create Image_shout
	local Image_shout = GUI:Image_Create(ListView_channel, "Image_shout", 45.00, 195.00, "res/private/chat/1900012834.png")
	GUI:setAnchorPoint(Image_shout, 0.50, 0.50)
	GUI:setTouchEnabled(Image_shout, false)
	GUI:setTag(Image_shout, 190)

	-- Create Image_private
	local Image_private = GUI:Image_Create(ListView_channel, "Image_private", 45.00, 169.00, "res/private/chat/1900012833.png")
	GUI:setAnchorPoint(Image_private, 0.50, 0.50)
	GUI:setTouchEnabled(Image_private, false)
	GUI:setTag(Image_private, 191)

	-- Create Image_guild
	local Image_guild = GUI:Image_Create(ListView_channel, "Image_guild", 45.00, 143.00, "res/private/chat/1900012831.png")
	GUI:setAnchorPoint(Image_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Image_guild, false)
	GUI:setTag(Image_guild, 192)

	-- Create Image_team
	local Image_team = GUI:Image_Create(ListView_channel, "Image_team", 45.00, 117.00, "res/private/chat/1900012832.png")
	GUI:setAnchorPoint(Image_team, 0.50, 0.50)
	GUI:setTouchEnabled(Image_team, false)
	GUI:setTag(Image_team, 193)

	-- Create Image_near
	local Image_near = GUI:Image_Create(ListView_channel, "Image_near", 45.00, 91.00, "res/private/chat/1900012830.png")
	GUI:setAnchorPoint(Image_near, 0.50, 0.50)
	GUI:setTouchEnabled(Image_near, false)
	GUI:setTag(Image_near, 194)

	-- Create Image_world
	local Image_world = GUI:Image_Create(ListView_channel, "Image_world", 45.00, 65.00, "res/private/chat/1900012836.png")
	GUI:setAnchorPoint(Image_world, 0.50, 0.50)
	GUI:setTouchEnabled(Image_world, false)
	GUI:setTag(Image_world, 30)

	-- Create Image_nation
	local Image_nation = GUI:Image_Create(ListView_channel, "Image_nation", 45.00, 39.00, "res/private/chat/1900012837.png")
	GUI:setAnchorPoint(Image_nation, 0.50, 0.50)
	GUI:setTouchEnabled(Image_nation, false)
	GUI:setTag(Image_nation, 93)

	-- Create Image_union
	local Image_union = GUI:Image_Create(ListView_channel, "Image_union", 45.00, 13.00, "res/private/chat/1900012838.png")
	GUI:setAnchorPoint(Image_union, 0.50, 0.50)
	GUI:setTouchEnabled(Image_union, false)
	GUI:setTag(Image_union, 94)

	-- Create Panel_targets
	local Panel_targets = GUI:Layout_Create(Panel_bg, "Panel_targets", 120.00, 110.00, 135.00, 200.00, false)
	GUI:setTouchEnabled(Panel_targets, true)
	GUI:setTag(Panel_targets, 38)

	-- Create Image_targets
	local Image_targets = GUI:Image_Create(Panel_targets, "Image_targets", -2.00, -2.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_targets, 21, 21, 34, 32)
	GUI:setContentSize(Image_targets, 139, 204)
	GUI:setIgnoreContentAdaptWithSize(Image_targets, false)
	GUI:setTouchEnabled(Image_targets, false)
	GUI:setTag(Image_targets, 100)

	-- Create ListView_targets
	local ListView_targets = GUI:ListView_Create(Panel_targets, "ListView_targets", 0.00, 0.00, 135.00, 200.00, 1)
	GUI:setTouchEnabled(ListView_targets, true)
	GUI:setTag(ListView_targets, 39)

	local targetCell = GUI:Layout_Create(parent, "targetCell", 0, 0, 135, 27)
    GUI:setTouchEnabled(targetCell, true)
	GUI:setVisible(targetCell, false)
    local imgSelect = GUI:Image_Create(targetCell, "imgSelect", 67.5, 13.5, "res/public/1900000678")
    GUI:setAnchorPoint(imgSelect, 0.5, 0.5)
    local textName = GUI:Text_Create(targetCell, "textName", 5, 13.8, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(textName, 0, 0.5)

	local receiving_cell = GUI:Layout_Create(Node, "receiving_cell", 0.00, 0.00, 115.00, 48.00, false)
	GUI:setTouchEnabled(receiving_cell, true)
	
	local Button_channel = GUI:Button_Create(receiving_cell, "Button_channel", 57.50, 24.00, "res/private/chat/1900012825-1.png")
	GUI:Button_loadTexturePressed(Button_channel, "res/private/chat/1900012825.png")
	GUI:Button_setScale9Slice(Button_channel, 16, 14, 11, 11)
	GUI:setContentSize(Button_channel, 108, 44)
	GUI:setIgnoreContentAdaptWithSize(Button_channel, false)
	GUI:Button_setTitleText(Button_channel, "")
	GUI:Button_setTitleColor(Button_channel, "#414146")
	GUI:Button_setTitleFontSize(Button_channel, 14)
	GUI:Button_titleDisableOutLine(Button_channel)
	GUI:setAnchorPoint(Button_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_channel, true)

	local Image_name = GUI:Image_Create(receiving_cell, "Image_name", 74.75, 24.00, "res/private/chat/1900012840.png")
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)

	local CheckBox_receiving = GUI:CheckBox_Create(receiving_cell, "CheckBox_receiving", 25.00, 24.00, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
	GUI:CheckBox_setSelected(CheckBox_receiving, true)
	GUI:setAnchorPoint(CheckBox_receiving, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_receiving, true)
end

return ui