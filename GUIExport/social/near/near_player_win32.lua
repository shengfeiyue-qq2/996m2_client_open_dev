local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "附近组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layer, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_1, "附近组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create CheckBox_add
	local CheckBox_add = GUI:CheckBox_Create(Panel_1, "CheckBox_add", 20.00, 365.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_add, true)
	GUI:setChineseName(CheckBox_add, "附近_允许添加_勾选框")
	GUI:setAnchorPoint(CheckBox_add, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_add, true)
	GUI:setTag(CheckBox_add, 194)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_add, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setChineseName(TouchSize, "附近_允许添加_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 195)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_add, "Text_permit", 20.00, 9.00, 14, "#ffffff", [[允许添加]])
	GUI:setChineseName(Text_permit, "附近_允许添加_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 196)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create CheckBox_team
	local CheckBox_team = GUI:CheckBox_Create(Panel_1, "CheckBox_team", 20.00, 330.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_team, true)
	GUI:setChineseName(CheckBox_team, "附近_允许组队_勾选框")
	GUI:setAnchorPoint(CheckBox_team, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_team, true)
	GUI:setTag(CheckBox_team, 197)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_team, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setChineseName(TouchSize, "附近_允许组队_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 198)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_team, "Text_permit", 20.00, 9.00, 14, "#ffffff", [[允许组队]])
	GUI:setChineseName(Text_permit, "附近_允许组队_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 199)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create CheckBox_deal
	local CheckBox_deal = GUI:CheckBox_Create(Panel_1, "CheckBox_deal", 20.00, 295.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_deal, true)
	GUI:setChineseName(CheckBox_deal, "附近_允许交易_勾选框")
	GUI:setAnchorPoint(CheckBox_deal, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_deal, true)
	GUI:setTag(CheckBox_deal, 200)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_deal, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setChineseName(TouchSize, "附近_允许交易_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 201)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_deal, "Text_permit", 20.00, 9.00, 14, "#ffffff", [[允许交易]])
	GUI:setChineseName(Text_permit, "附近_允许交易_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 202)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create CheckBox_challenge
	local CheckBox_challenge = GUI:CheckBox_Create(Panel_1, "CheckBox_challenge", 20.00, 260.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_challenge, true)
	GUI:setChineseName(CheckBox_challenge, "附近_允许挑战_勾选框")
	GUI:setAnchorPoint(CheckBox_challenge, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_challenge, true)
	GUI:setTag(CheckBox_challenge, 203)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_challenge, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setChineseName(TouchSize, "附近_允许挑战_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 204)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_challenge, "Text_permit", 20.00, 9.00, 14, "#ffffff", [[允许挑战]])
	GUI:setChineseName(Text_permit, "附近_允许挑战_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 205)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create CheckBox_show
	local CheckBox_show = GUI:CheckBox_Create(Panel_1, "CheckBox_show", 20.00, 225.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(CheckBox_show, true)
	GUI:setChineseName(CheckBox_show, "附近_允许显示_勾选框")
	GUI:setAnchorPoint(CheckBox_show, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox_show, true)
	GUI:setTag(CheckBox_show, 206)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox_show, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setChineseName(TouchSize, "附近_允许显示_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 207)
	GUI:setVisible(TouchSize, false)

	-- Create Text_permit
	local Text_permit = GUI:Text_Create(CheckBox_show, "Text_permit", 20.00, 9.00, 14, "#ffffff", [[允许显示]])
	GUI:setChineseName(Text_permit, "附近_允许显示_文本")
	GUI:setAnchorPoint(Text_permit, 0.00, 0.50)
	GUI:setTouchEnabled(Text_permit, false)
	GUI:setTag(Text_permit, 208)
	GUI:Text_enableOutline(Text_permit, "#000000", 1)

	-- Create Panel_near
	local Panel_near = GUI:Layout_Create(Panel_1, "Panel_near", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_near, "附近_队伍组合")
	GUI:setTouchEnabled(Panel_near, false)
	GUI:setTag(Panel_near, 32)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_near, "Image_2", 0.00, 38.00, "res/private/team_win32/1900014008.png")
	GUI:setChineseName(Image_2, "附近_装饰条")
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 95)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_near, "Text_name", 165.00, 378.00, 12, "#ffffff", [[队伍]])
	GUI:setChineseName(Text_name, "附近_队伍_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 97)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_near, "Text_job", 272.00, 378.00, 12, "#ffffff", [[职业]])
	GUI:setChineseName(Text_job, "附近_职业_文本")
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 98)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_near, "Text_level", 350.00, 378.00, 12, "#ffffff", [[等级]])
	GUI:setChineseName(Text_level, "附近_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 99)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_near, "Text_guild", 440.00, 378.00, 12, "#ffffff", [[行会]])
	GUI:setChineseName(Text_guild, "附近_行会_文本")
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 192)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_operation
	local Text_operation = GUI:Text_Create(Panel_near, "Text_operation", 550.00, 378.00, 12, "#ffffff", [[操作]])
	GUI:setChineseName(Text_operation, "附近_操作_文本")
	GUI:setAnchorPoint(Text_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Text_operation, false)
	GUI:setTag(Text_operation, 100)
	GUI:Text_enableOutline(Text_operation, "#000000", 1)

	-- Create ListView_near
	local ListView_near = GUI:ListView_Create(Panel_near, "ListView_near", 108.00, 40.00, 500.00, 325.00, 1)
	GUI:ListView_setGravity(ListView_near, 5)
	GUI:setChineseName(ListView_near, "附近_队伍列表")
	GUI:setTouchEnabled(ListView_near, true)
	GUI:setTag(ListView_near, 110)
end
return ui