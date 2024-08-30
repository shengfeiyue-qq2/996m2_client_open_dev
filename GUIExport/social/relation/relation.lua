local ui = {}
function ui.init(parent)
	-- Create relationLayer
	local relationLayer = GUI:Node_Create(parent, "relationLayer", 0.00, 0.00)
	GUI:setChineseName(relationLayer, "关系组合")
	GUI:setAnchorPoint(relationLayer, 0.50, 0.50)
	GUI:setTag(relationLayer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(relationLayer, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create ListView_type
	local ListView_type = GUI:ListView_Create(Panel_1, "ListView_type", 4.00, 56.00, 124.00, 384.00, 1)
	GUI:ListView_setGravity(ListView_type, 5)
	GUI:ListView_setItemsMargin(ListView_type, 4)
	GUI:setTouchEnabled(ListView_type, true)
	GUI:setTag(ListView_type, -1)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_1, "Panel_content", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(Panel_content, false)
	GUI:setTag(Panel_content, 31)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_content, "Image_1", 0.00, 52.00, "res/private/team/1900014008.png")
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 38)

	-- Create Image_none
	local Image_none = GUI:Image_Create(Panel_content, "Image_none", 430.00, 244.00, "res/private/team/1900014011.png")
	GUI:setAnchorPoint(Image_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_none, false)
	GUI:setTag(Image_none, 42)
	GUI:setVisible(Image_none, false)

	-- Create Button_call
	local Button_call = GUI:Button_Create(Panel_content, "Button_call", 556.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_call, 15, 15, 11, 11)
	GUI:setContentSize(Button_call, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_call, false)
	GUI:Button_setTitleText(Button_call, "召集成员")
	GUI:Button_setTitleColor(Button_call, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_call, 16)
	GUI:Button_titleEnableOutline(Button_call, "#111111", 2)
	GUI:setAnchorPoint(Button_call, 0.50, 0.50)
	GUI:setTouchEnabled(Button_call, true)
	GUI:setTag(Button_call, 57)
	GUI:setVisible(Button_call, false)

	-- Create Button_invite
	local Button_invite = GUI:Button_Create(Panel_content, "Button_invite", 672.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_invite, 15, 15, 11, 11)
	GUI:setContentSize(Button_invite, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_invite, false)
	GUI:Button_setTitleText(Button_invite, "邀请成员")
	GUI:Button_setTitleColor(Button_invite, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_invite, 16)
	GUI:Button_titleEnableOutline(Button_invite, "#111111", 2)
	GUI:setChineseName(Button_invite, "邀请成员_按钮")
	GUI:setAnchorPoint(Button_invite, 0.50, 0.50)
	GUI:setTouchEnabled(Button_invite, true)
	GUI:setTag(Button_invite, 56)
	GUI:setVisible(Button_invite, false)

	-- Create Button_exit
	local Button_exit = GUI:Button_Create(Panel_content, "Button_exit", 672.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_exit, 15, 15, 11, 11)
	GUI:setContentSize(Button_exit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_exit, false)
	GUI:Button_setTitleText(Button_exit, "解除关系")
	GUI:Button_setTitleColor(Button_exit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_exit, 16)
	GUI:Button_titleEnableOutline(Button_exit, "#111111", 2)
	GUI:setChineseName(Button_exit, "解除关系_按钮")
	GUI:setAnchorPoint(Button_exit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_exit, true)
	GUI:setTag(Button_exit, 65)
	GUI:setVisible(Button_exit, false)

	-- Create Button_dissolve
	local Button_dissolve = GUI:Button_Create(Panel_content, "Button_dissolve", 440.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_dissolve, 15, 15, 11, 11)
	GUI:setContentSize(Button_dissolve, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_dissolve, false)
	GUI:Button_setTitleText(Button_dissolve, "解散关系")
	GUI:Button_setTitleColor(Button_dissolve, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_dissolve, 16)
	GUI:Button_titleEnableOutline(Button_dissolve, "#111111", 2)
	GUI:setChineseName(Button_dissolve, "解散关系_按钮")
	GUI:setAnchorPoint(Button_dissolve, 0.50, 0.50)
	GUI:setTouchEnabled(Button_dissolve, true)
	GUI:setTag(Button_dissolve, 65)
	GUI:setVisible(Button_dissolve, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_content, "Text_name", 215.00, 432.00, 16, "#ffffff", [[名字]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 43)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_content, "Text_job", 346.00, 432.00, 16, "#ffffff", [[职业]])
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 44)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_content, "Text_level", 427.00, 432.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 45)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_content, "Text_guild", 528.00, 432.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 46)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_map
	local Text_map = GUI:Text_Create(Panel_content, "Text_map", 660.00, 432.00, 16, "#ffffff", [[所在地图]])
	GUI:setAnchorPoint(Text_map, 0.50, 0.50)
	GUI:setTouchEnabled(Text_map, false)
	GUI:setTag(Text_map, 47)
	GUI:Text_enableOutline(Text_map, "#000000", 1)

	-- Create CheckBox_permit_call
	local CheckBox_permit_call = GUI:CheckBox_Create(Panel_content, "CheckBox_permit_call", 26.00, 27.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_permit_call, false)
	GUI:setChineseName(CheckBox_permit_call, "允许召集_勾选框")
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
	local Text_permit_call = GUI:Text_Create(CheckBox_permit_call, "Text_permit_call", 25.00, 9.00, 16, "#ffffff", [[允许召集]])
	GUI:setAnchorPoint(Text_permit_call, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit_call, false)
	GUI:setTag(Text_permit_call, 61)
	GUI:Text_enableOutline(Text_permit_call, "#000000", 1)

	-- Create CheckBox_permit
	local CheckBox_permit = GUI:CheckBox_Create(Panel_content, "CheckBox_permit", 150.00, 27.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_permit, false)
	GUI:setChineseName(CheckBox_permit, "允许建立_勾选框")
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
	local Text_permit = GUI:Text_Create(CheckBox_permit, "Text_permit", 25.00, 9.00, 16, "#ffffff", [[允许创建关系]])
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 61)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create ListView_member
	local ListView_member = GUI:ListView_Create(Panel_content, "ListView_member", 131.00, 55.00, 600.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_member, 2)
	GUI:setTouchEnabled(ListView_member, true)
	GUI:setTag(ListView_member, 48)
end
return ui