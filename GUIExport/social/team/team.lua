local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "队伍组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layer, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_1, "队伍组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create Button_myTeam
	local Button_myTeam = GUI:Button_Create(Panel_1, "Button_myTeam", 66.00, 420.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_myTeam, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_myTeam, 15, 15, 11, 11)
	GUI:setContentSize(Button_myTeam, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_myTeam, false)
	GUI:Button_setTitleText(Button_myTeam, "我的队伍")
	GUI:Button_setTitleColor(Button_myTeam, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_myTeam, 18)
	GUI:Button_titleEnableOutline(Button_myTeam, "#111111", 2)
	GUI:setChineseName(Button_myTeam, "队伍_我的队伍_按钮")
	GUI:setAnchorPoint(Button_myTeam, 0.50, 0.50)
	GUI:setTouchEnabled(Button_myTeam, true)
	GUI:setTag(Button_myTeam, 39)

	-- Create Button_nearTeam
	local Button_nearTeam = GUI:Button_Create(Panel_1, "Button_nearTeam", 66.00, 380.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_nearTeam, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_nearTeam, 15, 15, 11, 11)
	GUI:setContentSize(Button_nearTeam, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_nearTeam, false)
	GUI:Button_setTitleText(Button_nearTeam, "附近队伍")
	GUI:Button_setTitleColor(Button_nearTeam, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_nearTeam, 18)
	GUI:Button_titleEnableOutline(Button_nearTeam, "#111111", 2)
	GUI:setChineseName(Button_nearTeam, "队伍_附近队伍_按钮")
	GUI:setAnchorPoint(Button_nearTeam, 0.50, 0.50)
	GUI:setTouchEnabled(Button_nearTeam, true)
	GUI:setTag(Button_nearTeam, 40)

	-- Create Panel_myTeam
	local Panel_myTeam = GUI:Layout_Create(Panel_1, "Panel_myTeam", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_myTeam, "我的队伍组合")
	GUI:setTouchEnabled(Panel_myTeam, false)
	GUI:setTag(Panel_myTeam, 31)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_myTeam, "Image_1", 0.00, 52.00, "res/private/team/1900014008.png")
	GUI:setChineseName(Image_1, "我的队伍_装饰条")
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 38)

	-- Create Image_none
	local Image_none = GUI:Image_Create(Panel_myTeam, "Image_none", 430.00, 244.00, "res/private/team/1900014011.png")
	GUI:setChineseName(Image_none, "我的队伍_提示_图标")
	GUI:setAnchorPoint(Image_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_none, false)
	GUI:setTag(Image_none, 42)

	-- Create Button_createTeam
	local Button_createTeam = GUI:Button_Create(Panel_myTeam, "Button_createTeam", 673.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_createTeam, 15, 15, 11, 11)
	GUI:setContentSize(Button_createTeam, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_createTeam, false)
	GUI:Button_setTitleText(Button_createTeam, "创建队伍")
	GUI:Button_setTitleColor(Button_createTeam, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_createTeam, 16)
	GUI:Button_titleEnableOutline(Button_createTeam, "#111111", 2)
	GUI:setChineseName(Button_createTeam, "我的队伍_创建队伍_按钮")
	GUI:setAnchorPoint(Button_createTeam, 0.50, 0.50)
	GUI:setTouchEnabled(Button_createTeam, true)
	GUI:setTag(Button_createTeam, 41)

	-- Create Button_applyList
	local Button_applyList = GUI:Button_Create(Panel_myTeam, "Button_applyList", 340.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_applyList, 15, 15, 11, 11)
	GUI:setContentSize(Button_applyList, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_applyList, false)
	GUI:Button_setTitleText(Button_applyList, "申请列表")
	GUI:Button_setTitleColor(Button_applyList, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_applyList, 16)
	GUI:Button_titleEnableOutline(Button_applyList, "#111111", 2)
	GUI:setChineseName(Button_applyList, "我的队伍_申请列表_按钮")
	GUI:setAnchorPoint(Button_applyList, 0.50, 0.50)
	GUI:setTouchEnabled(Button_applyList, true)
	GUI:setTag(Button_applyList, 58)

	-- Create Button_call
	local Button_call = GUI:Button_Create(Panel_myTeam, "Button_call", 450.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_call, 15, 15, 11, 11)
	GUI:setContentSize(Button_call, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_call, false)
	GUI:Button_setTitleText(Button_call, "召集队友")
	GUI:Button_setTitleColor(Button_call, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_call, 16)
	GUI:Button_titleEnableOutline(Button_call, "#111111", 2)
	GUI:setChineseName(Button_call, "我的队伍_召集队友_按钮")
	GUI:setAnchorPoint(Button_call, 0.50, 0.50)
	GUI:setTouchEnabled(Button_call, true)
	GUI:setTag(Button_call, 57)

	-- Create Button_invite
	local Button_invite = GUI:Button_Create(Panel_myTeam, "Button_invite", 562.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_invite, 15, 15, 11, 11)
	GUI:setContentSize(Button_invite, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_invite, false)
	GUI:Button_setTitleText(Button_invite, "邀请成员")
	GUI:Button_setTitleColor(Button_invite, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_invite, 16)
	GUI:Button_titleEnableOutline(Button_invite, "#111111", 2)
	GUI:setChineseName(Button_invite, "我的队伍_邀请成员_按钮")
	GUI:setAnchorPoint(Button_invite, 0.50, 0.50)
	GUI:setTouchEnabled(Button_invite, true)
	GUI:setTag(Button_invite, 56)

	-- Create Button_exit
	local Button_exit = GUI:Button_Create(Panel_myTeam, "Button_exit", 673.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setScale9Slice(Button_exit, 15, 15, 11, 11)
	GUI:setContentSize(Button_exit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_exit, false)
	GUI:Button_setTitleText(Button_exit, "离开队伍")
	GUI:Button_setTitleColor(Button_exit, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_exit, 16)
	GUI:Button_titleEnableOutline(Button_exit, "#111111", 2)
	GUI:setChineseName(Button_exit, "我的队伍_离开队伍_按钮")
	GUI:setAnchorPoint(Button_exit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_exit, true)
	GUI:setTag(Button_exit, 65)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_myTeam, "Text_name", 215.00, 432.00, 16, "#ffffff", [[名字]])
	GUI:setChineseName(Text_name, "我的队伍_名字_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 43)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_myTeam, "Text_job", 346.00, 432.00, 16, "#ffffff", [[职业]])
	GUI:setChineseName(Text_job, "我的队伍_职业_文本")
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 44)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_myTeam, "Text_level", 427.00, 432.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Text_level, "我的队伍_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 45)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_myTeam, "Text_guild", 528.00, 432.00, 16, "#ffffff", [[行会]])
	GUI:setChineseName(Text_guild, "我的队伍_行会_文本")
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 46)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_map
	local Text_map = GUI:Text_Create(Panel_myTeam, "Text_map", 660.00, 432.00, 16, "#ffffff", [[所在地图]])
	GUI:setChineseName(Text_map, "我的队伍_地图_文本")
	GUI:setAnchorPoint(Text_map, 0.50, 0.50)
	GUI:setTouchEnabled(Text_map, false)
	GUI:setTag(Text_map, 47)
	GUI:Text_enableOutline(Text_map, "#000000", 1)

	-- Create Text_exp
	local Text_exp = GUI:Text_Create(Panel_myTeam, "Text_exp", 150.00, 27.00, 16, "#ffffff", [[经验加成]])
	GUI:setChineseName(Text_exp, "我的队伍_经验加成_文本")
	GUI:setAnchorPoint(Text_exp, 0.00, 0.50)
	GUI:setTouchEnabled(Text_exp, false)
	GUI:setTag(Text_exp, 59)
	GUI:Text_enableOutline(Text_exp, "#111111", 1)

	-- Create CheckBox_permit
	local CheckBox_permit = GUI:CheckBox_Create(Panel_myTeam, "CheckBox_permit", 26.00, 27.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_permit, true)
	GUI:setChineseName(CheckBox_permit, "允许组队_勾选框")
	GUI:setAnchorPoint(CheckBox_permit, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_permit, true)
	GUI:setTag(CheckBox_permit, 60)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_permit, "TouchSize", 8.00, 9.00, 34.00, 38.00, false)
	GUI:setChineseName(TouchSize, "允许组队_触摸")
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 64)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_permit, "Text_permit", 25.00, 9.00, 16, "#ffffff", [[允许组队]])
	GUI:setChineseName(Text_permit, "允许组队_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 61)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create ListView_member
	local ListView_member = GUI:ListView_Create(Panel_myTeam, "ListView_member", 131.00, 55.00, 600.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_member, 2)
	GUI:setChineseName(ListView_member, "组队_队伍成员_列表")
	GUI:setTouchEnabled(ListView_member, true)
	GUI:setTag(ListView_member, 48)

	-- Create Panel_nearTeam
	local Panel_nearTeam = GUI:Layout_Create(Panel_1, "Panel_nearTeam", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_nearTeam, "附近队伍组合")
	GUI:setTouchEnabled(Panel_nearTeam, false)
	GUI:setTag(Panel_nearTeam, 32)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_nearTeam, "Image_2", 0.00, 52.00, "res/private/team/19000140013.png")
	GUI:setChineseName(Image_2, "附近队伍_装饰条")
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 95)

	-- Create Text_team
	local Text_team = GUI:Text_Create(Panel_nearTeam, "Text_team", 215.00, 432.00, 16, "#ffffff", [[队伍]])
	GUI:setChineseName(Text_team, "附近队伍_队伍_文本")
	GUI:setAnchorPoint(Text_team, 0.50, 0.50)
	GUI:setTouchEnabled(Text_team, false)
	GUI:setTag(Text_team, 97)
	GUI:Text_enableOutline(Text_team, "#000000", 1)

	-- Create Text_guild1
	local Text_guild1 = GUI:Text_Create(Panel_nearTeam, "Text_guild1", 383.00, 432.00, 16, "#ffffff", [[行会]])
	GUI:setChineseName(Text_guild1, "附近队伍_行会_文本")
	GUI:setAnchorPoint(Text_guild1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild1, false)
	GUI:setTag(Text_guild1, 98)
	GUI:Text_enableOutline(Text_guild1, "#000000", 1)

	-- Create Text_number
	local Text_number = GUI:Text_Create(Panel_nearTeam, "Text_number", 540.00, 432.00, 16, "#ffffff", [[人数]])
	GUI:setChineseName(Text_number, "附近队伍_人数_文本")
	GUI:setAnchorPoint(Text_number, 0.50, 0.50)
	GUI:setTouchEnabled(Text_number, false)
	GUI:setTag(Text_number, 99)
	GUI:Text_enableOutline(Text_number, "#000000", 1)

	-- Create Text_operation
	local Text_operation = GUI:Text_Create(Panel_nearTeam, "Text_operation", 660.00, 432.00, 16, "#ffffff", [[操作]])
	GUI:setChineseName(Text_operation, "附近队伍_操作_文本")
	GUI:setAnchorPoint(Text_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Text_operation, false)
	GUI:setTag(Text_operation, 100)
	GUI:Text_enableOutline(Text_operation, "#000000", 1)

	-- Create ListView_near
	local ListView_near = GUI:ListView_Create(Panel_nearTeam, "ListView_near", 131.00, 55.00, 600.00, 360.00, 1)
	GUI:ListView_setGravity(ListView_near, 5)
	GUI:setChineseName(ListView_near, "附近队伍_附近队伍_列表")
	GUI:setTouchEnabled(ListView_near, true)
	GUI:setTag(ListView_near, 110)
end
return ui