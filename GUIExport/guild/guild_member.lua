local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "行会列表组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Layer, "PMainUI", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(PMainUI, "行会列表组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 34)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 366.00, 30.00, "res/public/bg_hhdb_01.jpg")
	GUI:setChineseName(Image_bg, "行会列表操作_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 74)

	-- Create Image_line
	local Image_line = GUI:Image_Create(PMainUI, "Image_line", 366.00, 406.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_line, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 146)

	-- Create Image_line1
	local Image_line1 = GUI:Image_Create(Image_line, "Image_line1", 170.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line1, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line1, false)
	GUI:setChineseName(Image_line1, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line1, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line1, false)
	GUI:setTag(Image_line1, 147)

	-- Create Image_line2
	local Image_line2 = GUI:Image_Create(Image_line, "Image_line2", 334.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line2, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line2, false)
	GUI:setChineseName(Image_line2, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line2, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line2, false)
	GUI:setTag(Image_line2, 148)

	-- Create Image_line3
	local Image_line3 = GUI:Image_Create(Image_line, "Image_line3", 450.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line3, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line3, false)
	GUI:setChineseName(Image_line3, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line3, false)
	GUI:setTag(Image_line3, 149)

	-- Create Image_line4
	local Image_line4 = GUI:Image_Create(Image_line, "Image_line4", 590.00, 0.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line4, 2, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_line4, false)
	GUI:setChineseName(Image_line4, "行会列表_装饰条")
	GUI:setAnchorPoint(Image_line4, 0.50, 0.00)
	GUI:setTouchEnabled(Image_line4, false)
	GUI:setTag(Image_line4, 150)

	-- Create BtnApplyList
	local BtnApplyList = GUI:Button_Create(PMainUI, "BtnApplyList", 535.00, 30.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(BtnApplyList, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(BtnApplyList, 15, 15, 11, 11)
	GUI:setContentSize(BtnApplyList, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(BtnApplyList, false)
	GUI:Button_setTitleText(BtnApplyList, "申请列表")
	GUI:Button_setTitleColor(BtnApplyList, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnApplyList, 16)
	GUI:Button_titleEnableOutline(BtnApplyList, "#111111", 2)
	GUI:setChineseName(BtnApplyList, "行会列表_申请列表_按钮")
	GUI:setAnchorPoint(BtnApplyList, 0.50, 0.50)
	GUI:setTouchEnabled(BtnApplyList, true)
	GUI:setTag(BtnApplyList, 41)

	-- Create BtnDissolve
	local BtnDissolve = GUI:Button_Create(PMainUI, "BtnDissolve", 670.00, 30.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(BtnDissolve, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(BtnDissolve, 15, 15, 11, 11)
	GUI:setContentSize(BtnDissolve, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(BtnDissolve, false)
	GUI:Button_setTitleText(BtnDissolve, "解散行会")
	GUI:Button_setTitleColor(BtnDissolve, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnDissolve, 16)
	GUI:Button_titleEnableOutline(BtnDissolve, "#111111", 2)
	GUI:setChineseName(BtnDissolve, "行会列表_解散行会_按钮")
	GUI:setAnchorPoint(BtnDissolve, 0.50, 0.50)
	GUI:setTouchEnabled(BtnDissolve, true)
	GUI:setTag(BtnDissolve, 42)

	-- Create BtnEditTitle
	local BtnEditTitle = GUI:Button_Create(PMainUI, "BtnEditTitle", 400.00, 30.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(BtnEditTitle, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(BtnEditTitle, 15, 15, 11, 11)
	GUI:setContentSize(BtnEditTitle, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(BtnEditTitle, false)
	GUI:Button_setTitleText(BtnEditTitle, "编辑封号")
	GUI:Button_setTitleColor(BtnEditTitle, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnEditTitle, 16)
	GUI:Button_titleEnableOutline(BtnEditTitle, "#111111", 2)
	GUI:setChineseName(BtnEditTitle, "行会列表_编辑封号_按钮")
	GUI:setAnchorPoint(BtnEditTitle, 0.50, 0.50)
	GUI:setTouchEnabled(BtnEditTitle, true)
	GUI:setTag(BtnEditTitle, 86)

	-- Create BtnQuit
	local BtnQuit = GUI:Button_Create(PMainUI, "BtnQuit", 670.00, 30.00, "res/public/1900000660.png")
	GUI:Button_loadTexturePressed(BtnQuit, "res/public/1900000661.png")
	GUI:Button_setScale9Slice(BtnQuit, 15, 15, 11, 11)
	GUI:setContentSize(BtnQuit, 106, 40)
	GUI:setIgnoreContentAdaptWithSize(BtnQuit, false)
	GUI:Button_setTitleText(BtnQuit, "退出行会")
	GUI:Button_setTitleColor(BtnQuit, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnQuit, 16)
	GUI:Button_titleEnableOutline(BtnQuit, "#111111", 2)
	GUI:setChineseName(BtnQuit, "行会列表_退出行会_按钮")
	GUI:setAnchorPoint(BtnQuit, 0.50, 0.50)
	GUI:setTouchEnabled(BtnQuit, true)
	GUI:setTag(BtnQuit, 171)

	-- Create LabelOnline
	local LabelOnline = GUI:Text_Create(PMainUI, "LabelOnline", 20.00, 30.00, 16, "#28ef01", [[在线人数:]])
	GUI:setChineseName(LabelOnline, "行会列表_在线人数_文本")
	GUI:setAnchorPoint(LabelOnline, 0.00, 0.50)
	GUI:setTouchEnabled(LabelOnline, false)
	GUI:setTag(LabelOnline, 73)
	GUI:Text_enableOutline(LabelOnline, "#111111", 1)

	-- Create MemberList
	local MemberList = GUI:ListView_Create(PMainUI, "MemberList", 0.00, 62.00, 732.00, 342.00, 1)
	GUI:ListView_setGravity(MemberList, 5)
	GUI:setChineseName(MemberList, "行会列表_申请列表_按钮")
	GUI:setTouchEnabled(MemberList, true)
	GUI:setTag(MemberList, 75)

	-- Create Text_name
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 68.00, 425.00, 16, "#ffffff", [[玩家名字]])
	GUI:setChineseName(Text_name, "行会列表_行会名称")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 76)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(PMainUI, "Text_level", 252.00, 425.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Text_level, "行会列表_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, true)
	GUI:setTag(Text_level, 77)
	GUI:Text_enableOutline(Text_level, "#111111", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Text_level, "TouchSize", 42.00, 10.00, 70.00, 31.50, false)
	GUI:setChineseName(TouchSize, "行会列表_等级下拉_触摸")
	GUI:setAnchorPoint(TouchSize, 1.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 115)
	GUI:setVisible(TouchSize, false)

	-- Create Text_job
	local Text_job = GUI:Text_Create(PMainUI, "Text_job", 388.00, 425.00, 16, "#ffffff", [[职业]])
	GUI:setChineseName(Text_job, "行会列表_职业_文本")
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 78)
	GUI:Text_enableOutline(Text_job, "#111111", 1)

	-- Create Text_official
	local Text_official = GUI:Text_Create(PMainUI, "Text_official", 522.00, 425.00, 16, "#ffffff", [[职务]])
	GUI:setChineseName(Text_official, "行会列表_职务_文本")
	GUI:setAnchorPoint(Text_official, 0.50, 0.50)
	GUI:setTouchEnabled(Text_official, false)
	GUI:setTag(Text_official, 79)
	GUI:Text_enableOutline(Text_official, "#111111", 1)

	-- Create Text_state
	local Text_state = GUI:Text_Create(PMainUI, "Text_state", 660.00, 425.00, 16, "#ffffff", [[状态]])
	GUI:setChineseName(Text_state, "行会列表_状态_文本")
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 80)
	GUI:Text_enableOutline(Text_state, "#111111", 1)

	-- Create Image_none
	local Image_none = GUI:Image_Create(PMainUI, "Image_none", 366.00, 222.00, "res/private/guild_ui/word_hhzy_12.png")
	GUI:setChineseName(Image_none, "行会列表_无结果时展示_图片")
	GUI:setAnchorPoint(Image_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_none, false)
	GUI:setTag(Image_none, 114)
	GUI:setVisible(Image_none, false)

	-- Create BtnLevel
	local BtnLevel = GUI:Button_Create(PMainUI, "BtnLevel", 300.00, 425.00, "res/public/btn_szjm_01.png")
	GUI:Button_setScale9Slice(BtnLevel, 8, 8, 3, 3)
	GUI:setContentSize(BtnLevel, 25, 12)
	GUI:setIgnoreContentAdaptWithSize(BtnLevel, false)
	GUI:Button_setTitleText(BtnLevel, "")
	GUI:Button_setTitleColor(BtnLevel, "#414146")
	GUI:Button_setTitleFontSize(BtnLevel, 14)
	GUI:Button_titleDisableOutLine(BtnLevel)
	GUI:setChineseName(BtnLevel, "行会列表_等级下拉_图片")
	GUI:setAnchorPoint(BtnLevel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnLevel, true)
	GUI:setTag(BtnLevel, 143)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnLevel, "TouchSize", 12.00, 6.00, 37.50, 19.20, false)
	GUI:setChineseName(TouchSize, "行会列表_等级下拉_触摸")
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 144)
	GUI:setVisible(TouchSize, false)

	-- Create BtnJob
	local BtnJob = GUI:Button_Create(PMainUI, "BtnJob", 426.00, 425.00, "res/public/btn_szjm_01.png")
	GUI:Button_setScale9Slice(BtnJob, 8, 8, 3, 3)
	GUI:setContentSize(BtnJob, 25, 12)
	GUI:setIgnoreContentAdaptWithSize(BtnJob, false)
	GUI:Button_setTitleText(BtnJob, "")
	GUI:Button_setTitleColor(BtnJob, "#414146")
	GUI:Button_setTitleFontSize(BtnJob, 14)
	GUI:Button_titleDisableOutLine(BtnJob)
	GUI:setChineseName(BtnJob, "行会列表_职业下拉_图片")
	GUI:setAnchorPoint(BtnJob, 0.50, 0.50)
	GUI:setTouchEnabled(BtnJob, true)
	GUI:setTag(BtnJob, 145)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnJob, "TouchSize", 37.00, 6.00, 110.00, 24.00, false)
	GUI:setChineseName(TouchSize, "行会列表_职业下拉_触摸")
	GUI:setAnchorPoint(TouchSize, 1.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 146)
	GUI:setVisible(TouchSize, false)

	-- Create BtnOfficial
	local BtnOfficial = GUI:Button_Create(PMainUI, "BtnOfficial", 560.00, 425.00, "res/public/btn_szjm_01.png")
	GUI:Button_setScale9Slice(BtnOfficial, 8, 8, 3, 3)
	GUI:setContentSize(BtnOfficial, 25, 12)
	GUI:setIgnoreContentAdaptWithSize(BtnOfficial, false)
	GUI:Button_setTitleText(BtnOfficial, "")
	GUI:Button_setTitleColor(BtnOfficial, "#414146")
	GUI:Button_setTitleFontSize(BtnOfficial, 14)
	GUI:Button_titleDisableOutLine(BtnOfficial)
	GUI:setChineseName(BtnOfficial, "行会列表_职务下拉_图片")
	GUI:setAnchorPoint(BtnOfficial, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOfficial, true)
	GUI:setTag(BtnOfficial, 147)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnOfficial, "TouchSize", 37.00, 6.00, 120.00, 24.00, false)
	GUI:setChineseName(TouchSize, "行会列表_职务下拉_触摸")
	GUI:setAnchorPoint(TouchSize, 1.00, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 148)
	GUI:setVisible(TouchSize, false)

	-- Create FilterLevel
	local FilterLevel = GUI:Image_Create(PMainUI, "FilterLevel", 252.00, 400.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterLevel, 21, 21, 39, 27)
	GUI:setContentSize(FilterLevel, 110, 70)
	GUI:setIgnoreContentAdaptWithSize(FilterLevel, false)
	GUI:setChineseName(FilterLevel, "行会列表_等级下拉详细")
	GUI:setAnchorPoint(FilterLevel, 0.50, 1.00)
	GUI:setTouchEnabled(FilterLevel, false)
	GUI:setTag(FilterLevel, 149)
	GUI:setVisible(FilterLevel, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterLevel, "ListView_filter", 55.00, 7.00, 100.00, 56.00, 1)
	GUI:ListView_setGravity(ListView_filter, 2)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setChineseName(ListView_filter, "等级下拉选择组合")
	GUI:setAnchorPoint(ListView_filter, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, 150)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 30.00, 100.00, 26.00, false)
	GUI:setChineseName(filter1, "等级下拉_高到低组合")
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, 1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "等级_高至低_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 152)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter1, "Text", 50.00, 13.00, 16, "#ffffff", [[由高至低]])
	GUI:setChineseName(Text, "等级_高至低_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 153)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 2.00, 100.00, 26.00, false)
	GUI:setChineseName(filter2, "等级下拉_低到高组合")
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, 2)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "等级_低至高_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 155)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter2, "Text", 50.00, 13.00, 16, "#ffffff", [[由低至高]])
	GUI:setChineseName(Text, "等拉_低至高_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 156)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create FilterJob
	local FilterJob = GUI:Image_Create(PMainUI, "FilterJob", 388.00, 400.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterJob, 21, 21, 39, 27)
	GUI:setContentSize(FilterJob, 110, 126)
	GUI:setIgnoreContentAdaptWithSize(FilterJob, false)
	GUI:setChineseName(FilterJob, "行会列表_职业下拉详细")
	GUI:setAnchorPoint(FilterJob, 0.50, 1.00)
	GUI:setTouchEnabled(FilterJob, false)
	GUI:setTag(FilterJob, 182)
	GUI:setVisible(FilterJob, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterJob, "ListView_filter", 55.00, 7.00, 100.00, 112.00, 1)
	GUI:ListView_setGravity(ListView_filter, 2)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setChineseName(ListView_filter, "行会列表_等级下拉详细")
	GUI:setAnchorPoint(ListView_filter, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, 183)

	-- Create filter0
	local filter0 = GUI:Layout_Create(ListView_filter, "filter0", 0.00, 86.00, 100.00, 26.00, false)
	GUI:setChineseName(filter0, "职业_全部下拉_组合")
	GUI:setTouchEnabled(filter0, true)
	GUI:setTag(filter0, 0)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter0, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职业_全部_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 108)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter0, "Text", 50.00, 13.00, 16, "#ffffff", [[全部]])
	GUI:setChineseName(Text, "职业_全部_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 109)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 58.00, 100.00, 26.00, false)
	GUI:setChineseName(filter1, "职业_战士下拉_组合")
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, 1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职业_战士_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 185)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter1, "Text", 50.00, 13.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Text, "职业_战士_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 186)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 30.00, 100.00, 26.00, false)
	GUI:setChineseName(filter2, "职业_法师下拉_组合")
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, 2)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职业_法师_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 188)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter2, "Text", 50.00, 13.00, 16, "#ffffff", [[法师]])
	GUI:setChineseName(Text, "职业_法师_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 189)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter3
	local filter3 = GUI:Layout_Create(ListView_filter, "filter3", 0.00, 2.00, 100.00, 26.00, false)
	GUI:setChineseName(filter3, "职业_道士下拉_组合")
	GUI:setTouchEnabled(filter3, true)
	GUI:setTag(filter3, 3)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter3, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职业_道士_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 199)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter3, "Text", 50.00, 13.00, 16, "#ffffff", [[道士]])
	GUI:setChineseName(Text, "职业_道士_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 200)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create FilterOfficial
	local FilterOfficial = GUI:Image_Create(PMainUI, "FilterOfficial", 522.00, 400.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterOfficial, 21, 21, 39, 27)
	GUI:setContentSize(FilterOfficial, 140, 182)
	GUI:setIgnoreContentAdaptWithSize(FilterOfficial, false)
	GUI:setChineseName(FilterOfficial, "行会列表_职务下拉详细")
	GUI:setAnchorPoint(FilterOfficial, 0.50, 1.00)
	GUI:setTouchEnabled(FilterOfficial, false)
	GUI:setTag(FilterOfficial, 201)
	GUI:setVisible(FilterOfficial, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterOfficial, "ListView_filter", 70.00, 7.00, 130.00, 168.00, 1)
	GUI:ListView_setGravity(ListView_filter, 2)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setChineseName(ListView_filter, "职务下拉组合")
	GUI:setAnchorPoint(ListView_filter, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, 202)

	-- Create filter0
	local filter0 = GUI:Layout_Create(ListView_filter, "filter0", 0.00, 142.00, 130.00, 26.00, false)
	GUI:setChineseName(filter0, "职务_全部下拉_组合")
	GUI:setTouchEnabled(filter0, true)
	GUI:setTag(filter0, 0)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter0, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_全部_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 111)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter0, "Text", 65.00, 13.00, 16, "#ffffff", [[全部]])
	GUI:setChineseName(Text, "职务_全部_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 112)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 114.00, 130.00, 26.00, false)
	GUI:setChineseName(filter1, "职务_会长下拉_组合")
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, 1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_会长_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 204)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter1, "Text", 65.00, 13.00, 16, "#ffffff", [[会长]])
	GUI:setChineseName(Text, "职务_会长_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 205)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 86.00, 130.00, 26.00, false)
	GUI:setChineseName(filter2, "职务_精英下拉_组合")
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, 2)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_精英_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 207)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter2, "Text", 65.00, 13.00, 16, "#ffffff", [[精英]])
	GUI:setChineseName(Text, "职务_精英_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 208)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter3
	local filter3 = GUI:Layout_Create(ListView_filter, "filter3", 0.00, 58.00, 130.00, 26.00, false)
	GUI:setChineseName(filter3, "职务_会员下拉_组合")
	GUI:setTouchEnabled(filter3, true)
	GUI:setTag(filter3, 3)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter3, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_会员_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 210)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter3, "Text", 65.00, 13.00, 16, "#ffffff", [[会员]])
	GUI:setChineseName(Text, "职务_会员_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 211)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter4
	local filter4 = GUI:Layout_Create(ListView_filter, "filter4", 0.00, 30.00, 130.00, 26.00, false)
	GUI:setChineseName(filter4, "职务_会员下拉_组合")
	GUI:setTouchEnabled(filter4, true)
	GUI:setTag(filter4, 4)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter4, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_会员_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 143)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter4, "Text", 65.00, 13.00, 16, "#ffffff", [[会员]])
	GUI:setChineseName(Text, "职务_会员_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 144)
	GUI:Text_enableOutline(Text, "#111111", 1)

	-- Create filter5
	local filter5 = GUI:Layout_Create(ListView_filter, "filter5", 0.00, 2.00, 130.00, 26.00, false)
	GUI:setChineseName(filter5, "职务_会员下拉_组合")
	GUI:setTouchEnabled(filter5, true)
	GUI:setTag(filter5, 5)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter5, "Image_select", 65.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 130, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "职务_会员_选中背景图")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, 146)
	GUI:setVisible(Image_select, false)

	-- Create Text
	local Text = GUI:Text_Create(filter5, "Text", 65.00, 13.00, 16, "#ffffff", [[会员]])
	GUI:setChineseName(Text, "职务_会员_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 147)
	GUI:Text_enableOutline(Text, "#111111", 1)
end
return ui