local ui = {}
function ui.init(parent)
	-- Create relationLayer
	local relationLayer = GUI:Node_Create(parent, "relationLayer", 0.00, 0.00)
	GUI:setAnchorPoint(relationLayer, 0.50, 0.50)
	GUI:setTag(relationLayer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(relationLayer, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create ListView_type
	local ListView_type = GUI:ListView_Create(Panel_1, "ListView_type", 4.00, 42.00, 100.00, 344.00, 1)
	GUI:ListView_setGravity(ListView_type, 2)
	GUI:ListView_setItemsMargin(ListView_type, 4)
	GUI:setTouchEnabled(ListView_type, true)
	GUI:setTag(ListView_type, -1)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_1, "Panel_content", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setTouchEnabled(Panel_content, false)
	GUI:setTag(Panel_content, 31)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_content, "Image_1", 0.00, 38.00, "res/private/team_win32/1900014008.png")
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 38)

	-- Create Image_none
	local Image_none = GUI:Image_Create(Panel_content, "Image_none", 340.00, 200.00, "res/private/team_win32/1900014011.png")
	GUI:setAnchorPoint(Image_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_none, false)
	GUI:setTag(Image_none, 42)
	GUI:setVisible(Image_none, false)

	-- Create Button_call
	local Button_call = GUI:Button_Create(Panel_content, "Button_call", 470.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_call, 15, 15, 11, 11)
	GUI:setContentSize(Button_call, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_call, false)
	GUI:Button_setTitleText(Button_call, "召集成员")
	GUI:Button_setTitleColor(Button_call, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_call, 12)
	GUI:Button_titleEnableOutline(Button_call, "#111111", 2)
	GUI:setAnchorPoint(Button_call, 0.50, 0.50)
	GUI:setTouchEnabled(Button_call, true)
	GUI:setTag(Button_call, 57)
	GUI:setVisible(Button_call, false)

	-- Create Button_invite
	local Button_invite = GUI:Button_Create(Panel_content, "Button_invite", 560.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_invite, 15, 15, 11, 11)
	GUI:setContentSize(Button_invite, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_invite, false)
	GUI:Button_setTitleText(Button_invite, "邀请成员")
	GUI:Button_setTitleColor(Button_invite, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_invite, 12)
	GUI:Button_titleEnableOutline(Button_invite, "#111111", 2)
	GUI:setAnchorPoint(Button_invite, 0.50, 0.50)
	GUI:setTouchEnabled(Button_invite, true)
	GUI:setTag(Button_invite, 56)
	GUI:setVisible(Button_invite, false)

	-- Create Button_exit
	local Button_exit = GUI:Button_Create(Panel_content, "Button_exit", 560.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_exit, 15, 15, 11, 11)
	GUI:setContentSize(Button_exit, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_exit, false)
	GUI:Button_setTitleText(Button_exit, "解除关系")
	GUI:Button_setTitleColor(Button_exit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_exit, 12)
	GUI:Button_titleEnableOutline(Button_exit, "#111111", 2)
	GUI:setAnchorPoint(Button_exit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_exit, true)
	GUI:setTag(Button_exit, 65)
	GUI:setVisible(Button_exit, false)

	-- Create Button_dissolve
	local Button_dissolve = GUI:Button_Create(Panel_content, "Button_dissolve", 375.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_dissolve, 15, 15, 11, 11)
	GUI:setContentSize(Button_dissolve, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_dissolve, false)
	GUI:Button_setTitleText(Button_dissolve, "解散关系")
	GUI:Button_setTitleColor(Button_dissolve, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_dissolve, 12)
	GUI:Button_titleEnableOutline(Button_dissolve, "#111111", 2)
	GUI:setAnchorPoint(Button_dissolve, 0.50, 0.50)
	GUI:setTouchEnabled(Button_dissolve, true)
	GUI:setTag(Button_dissolve, 58)
	GUI:setVisible(Button_dissolve, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_content, "Text_name", 165.00, 378.00, 12, "#ffffff", [[名字]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 43)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_content, "Text_job", 272.00, 378.00, 12, "#ffffff", [[职业]])
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 44)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_content, "Text_level", 350.00, 378.00, 12, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 45)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_content, "Text_guild", 440.00, 378.00, 12, "#ffffff", [[行会]])
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 46)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_map
	local Text_map = GUI:Text_Create(Panel_content, "Text_map", 550.00, 378.00, 12, "#ffffff", [[所在地图]])
	GUI:setAnchorPoint(Text_map, 0.50, 0.50)
	GUI:setTouchEnabled(Text_map, false)
	GUI:setTag(Text_map, 47)
	GUI:Text_enableOutline(Text_map, "#000000", 1)

	-- Create CheckBox_permit_call
	local CheckBox_permit_call = GUI:CheckBox_Create(Panel_content, "CheckBox_permit_call", 26.00, 18.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_permit_call, false)
	GUI:setChineseName(CheckBox_permit_call, "允许组队_勾选框")
	GUI:setAnchorPoint(CheckBox_permit_call, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_permit_call, true)
	GUI:setTag(CheckBox_permit_call, 60)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_permit_call, "TouchSize", 8.00, 9.00, 34.00, 38.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 64)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit_call
	local Text_permit_call = GUI:Text_Create(CheckBox_permit_call, "Text_permit_call", 25.00, 9.00, 12, "#ffffff", [[允许召集]])
	GUI:setAnchorPoint(Text_permit_call, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit_call, false)
	GUI:setTag(Text_permit_call, 61)
	GUI:Text_enableOutline(Text_permit_call, "#000000", 1)

	-- Create CheckBox_permit
	local CheckBox_permit = GUI:CheckBox_Create(Panel_content, "CheckBox_permit", 120.00, 18.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_permit, false)
	GUI:setChineseName(CheckBox_permit, "允许组队_勾选框")
	GUI:setAnchorPoint(CheckBox_permit, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_permit, true)
	GUI:setTag(CheckBox_permit, 60)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_permit, "TouchSize", 8.00, 9.00, 34.00, 38.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 64)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_permit, "Text_permit", 25.00, 9.00, 12, "#ffffff", [[允许创建关系]])
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 61)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create ListView_member
	local ListView_member = GUI:ListView_Create(Panel_content, "ListView_member", 108.00, 40.00, 500.00, 325.00, 1)
	GUI:ListView_setGravity(ListView_member, 2)
	GUI:setTouchEnabled(ListView_member, true)
	GUI:setTag(ListView_member, 48)
end
return ui