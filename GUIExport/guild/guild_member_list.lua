local ui = {}
function ui.init(parent)
	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 0.00, 0.00, 732.00, 445.00, true)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create BG
	local BG = GUI:Image_Create(FrameLayout, "BG", 366.00, 222.00, "res/private/guild_ui/bg_member.png")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, true)
	GUI:setTag(BG, -1)

	-- Create MemberList
	local MemberList = GUI:ListView_Create(FrameLayout, "MemberList", 0.00, 72.00, 732.00, 347.00, 1)
	GUI:ListView_setGravity(MemberList, 5)
	GUI:setTouchEnabled(MemberList, true)
	GUI:setTag(MemberList, -1)

	-- Create Title1
	local Title1 = GUI:Text_Create(FrameLayout, "Title1", 92.00, 435.00, 16, "#f2e7cf", [[玩家名字]])
	GUI:setAnchorPoint(Title1, 0.50, 0.50)
	GUI:setTouchEnabled(Title1, false)
	GUI:setTag(Title1, -1)
	GUI:Text_enableOutline(Title1, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(FrameLayout, "Text_level", 251.00, 435.00, 16, "#f2e7cf", [[等级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, true)
	GUI:setTag(Text_level, -1)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Text_level, "TouchSize", 0.00, -1.00, 45.00, 30.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create Title3
	local Title3 = GUI:Text_Create(FrameLayout, "Title3", 401.00, 435.00, 16, "#f2e7cf", [[职业]])
	GUI:setAnchorPoint(Title3, 0.50, 0.50)
	GUI:setTouchEnabled(Title3, false)
	GUI:setTag(Title3, -1)
	GUI:Text_enableOutline(Title3, "#000000", 1)

	-- Create Title4
	local Title4 = GUI:Text_Create(FrameLayout, "Title4", 526.00, 435.00, 16, "#f2e7cf", [[职务]])
	GUI:setAnchorPoint(Title4, 0.50, 0.50)
	GUI:setTouchEnabled(Title4, false)
	GUI:setTag(Title4, -1)
	GUI:Text_enableOutline(Title4, "#000000", 1)

	-- Create Title5
	local Title5 = GUI:Text_Create(FrameLayout, "Title5", 674.00, 435.00, 16, "#f2e7cf", [[状态]])
	GUI:setAnchorPoint(Title5, 0.50, 0.50)
	GUI:setTouchEnabled(Title5, false)
	GUI:setTag(Title5, -1)
	GUI:Text_enableOutline(Title5, "#000000", 1)

	-- Create FilterLevel
	local FilterLevel = GUI:Image_Create(FrameLayout, "FilterLevel", 251.00, 418.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterLevel, 15, 15, 20, 20)
	GUI:setContentSize(FilterLevel, 110, 70)
	GUI:setIgnoreContentAdaptWithSize(FilterLevel, false)
	GUI:setAnchorPoint(FilterLevel, 0.50, 1.00)
	GUI:setTouchEnabled(FilterLevel, false)
	GUI:setTag(FilterLevel, -1)
	GUI:setVisible(FilterLevel, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterLevel, "ListView_filter", 5.00, 7.00, 100.00, 56.00, 1)
	GUI:ListView_setGravity(ListView_filter, 5)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, -1)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 30.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter1, "text", 50.00, 13.00, 16, "#f7f0e2", [[由高到低]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 2.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter2, "text", 50.00, 13.00, 16, "#f7f0e2", [[由低到高]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create FilterJob
	local FilterJob = GUI:Image_Create(FrameLayout, "FilterJob", 421.00, 418.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterJob, 15, 15, 20, 20)
	GUI:setContentSize(FilterJob, 110, 126)
	GUI:setIgnoreContentAdaptWithSize(FilterJob, false)
	GUI:setAnchorPoint(FilterJob, 0.50, 1.00)
	GUI:setTouchEnabled(FilterJob, false)
	GUI:setTag(FilterJob, -1)
	GUI:setVisible(FilterJob, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterJob, "ListView_filter", 5.00, 7.00, 100.00, 112.00, 1)
	GUI:ListView_setGravity(ListView_filter, 5)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, -1)

	-- Create filter0
	local filter0 = GUI:Layout_Create(ListView_filter, "filter0", 0.00, 86.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter0, true)
	GUI:setTag(filter0, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter0, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter0, "text", 50.00, 13.00, 16, "#f7f0e2", [[全部]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 58.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter1, "text", 50.00, 13.00, 16, "#f7f0e2", [[战士]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 30.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter2, "text", 50.00, 13.00, 16, "#f7f0e2", [[法师]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter3
	local filter3 = GUI:Layout_Create(ListView_filter, "filter3", 0.00, 2.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter3, true)
	GUI:setTag(filter3, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter3, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter3, "text", 50.00, 13.00, 16, "#f7f0e2", [[道士]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create FilterOfficial
	local FilterOfficial = GUI:Image_Create(FrameLayout, "FilterOfficial", 550.00, 418.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(FilterOfficial, 15, 15, 20, 20)
	GUI:setContentSize(FilterOfficial, 110, 182)
	GUI:setIgnoreContentAdaptWithSize(FilterOfficial, false)
	GUI:setAnchorPoint(FilterOfficial, 0.50, 1.00)
	GUI:setTouchEnabled(FilterOfficial, false)
	GUI:setTag(FilterOfficial, -1)
	GUI:setVisible(FilterOfficial, false)

	-- Create ListView_filter
	local ListView_filter = GUI:ListView_Create(FilterOfficial, "ListView_filter", 5.00, 7.00, 100.00, 168.00, 1)
	GUI:ListView_setGravity(ListView_filter, 5)
	GUI:ListView_setItemsMargin(ListView_filter, 2)
	GUI:setTouchEnabled(ListView_filter, true)
	GUI:setTag(ListView_filter, -1)

	-- Create filter0
	local filter0 = GUI:Layout_Create(ListView_filter, "filter0", 0.00, 142.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter0, true)
	GUI:setTag(filter0, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter0, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter0, "text", 50.00, 13.00, 16, "#f7f0e2", [[全部]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter1
	local filter1 = GUI:Layout_Create(ListView_filter, "filter1", 0.00, 114.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter1, true)
	GUI:setTag(filter1, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter1, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter1, "text", 50.00, 13.00, 16, "#f7f0e2", [[会长]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter2
	local filter2 = GUI:Layout_Create(ListView_filter, "filter2", 0.00, 86.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter2, true)
	GUI:setTag(filter2, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter2, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter2, "text", 50.00, 13.00, 16, "#f7f0e2", [[副会长]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter3
	local filter3 = GUI:Layout_Create(ListView_filter, "filter3", 0.00, 58.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter3, true)
	GUI:setTag(filter3, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter3, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter3, "text", 50.00, 13.00, 16, "#f7f0e2", [[长老]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter4
	local filter4 = GUI:Layout_Create(ListView_filter, "filter4", 0.00, 30.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter4, true)
	GUI:setTag(filter4, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter4, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter4, "text", 50.00, 13.00, 16, "#f7f0e2", [[精英]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create filter5
	local filter5 = GUI:Layout_Create(ListView_filter, "filter5", 0.00, 2.00, 100.00, 26.00, true)
	GUI:setTouchEnabled(filter5, true)
	GUI:setTag(filter5, -1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(filter5, "Image_select", 50.00, 13.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_select, 100, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)

	-- Create text
	local text = GUI:Text_Create(filter5, "text", 50.00, 13.00, 16, "#f7f0e2", [[成员]])
	GUI:setAnchorPoint(text, 0.50, 0.50)
	GUI:setTouchEnabled(text, false)
	GUI:setTag(text, -1)
	GUI:Text_enableOutline(text, "#000000", 1)

	-- Create BtnLevel
	local BtnLevel = GUI:Button_Create(FrameLayout, "BtnLevel", 336.00, 432.00, "res/public/btn_arrow_down.png")
	GUI:Button_setTitleText(BtnLevel, "")
	GUI:Button_setTitleColor(BtnLevel, "#ffffff")
	GUI:Button_setTitleFontSize(BtnLevel, 10)
	GUI:Button_titleEnableOutline(BtnLevel, "#000000", 1)
	GUI:setAnchorPoint(BtnLevel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnLevel, true)
	GUI:setTag(BtnLevel, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnLevel, "TouchSize", -15.00, -1.00, 75.00, 30.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create BtnJob
	local BtnJob = GUI:Button_Create(FrameLayout, "BtnJob", 461.00, 432.00, "res/public/btn_arrow_down.png")
	GUI:Button_setTitleText(BtnJob, "")
	GUI:Button_setTitleColor(BtnJob, "#ffffff")
	GUI:Button_setTitleFontSize(BtnJob, 10)
	GUI:Button_titleEnableOutline(BtnJob, "#000000", 1)
	GUI:setAnchorPoint(BtnJob, 0.50, 0.50)
	GUI:setTouchEnabled(BtnJob, true)
	GUI:setTag(BtnJob, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnJob, "TouchSize", -15.00, -1.00, 75.00, 30.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create BtnOfficial
	local BtnOfficial = GUI:Button_Create(FrameLayout, "BtnOfficial", 586.00, 432.00, "res/public/btn_arrow_down.png")
	GUI:Button_setTitleText(BtnOfficial, "")
	GUI:Button_setTitleColor(BtnOfficial, "#ffffff")
	GUI:Button_setTitleFontSize(BtnOfficial, 10)
	GUI:Button_titleEnableOutline(BtnOfficial, "#000000", 1)
	GUI:setAnchorPoint(BtnOfficial, 0.50, 0.50)
	GUI:setTouchEnabled(BtnOfficial, true)
	GUI:setTag(BtnOfficial, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(BtnOfficial, "TouchSize", -15.00, -1.00, 75.00, 30.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create btnCreate
	local btnCreate = GUI:Button_Create(FrameLayout, "btnCreate", 665.00, 35.00, "res/public/btn_push_common.png")
	GUI:Button_setTitleText(btnCreate, "创建行会")
	GUI:Button_setTitleColor(btnCreate, "#f7f0e2")
	GUI:Button_setTitleFontSize(btnCreate, 16)
	GUI:Button_titleEnableOutline(btnCreate, "#000000", 1)
	GUI:setAnchorPoint(btnCreate, 0.50, 0.50)
	GUI:setTouchEnabled(btnCreate, true)
	GUI:setTag(btnCreate, -1)
	GUI:setVisible(btnCreate, false)

	-- Create LabelOnline
	local LabelOnline = GUI:Text_Create(FrameLayout, "LabelOnline", 25.00, 35.00, 16, "#41ca44", [[]])
	GUI:setAnchorPoint(LabelOnline, 0.00, 0.50)
	GUI:setTouchEnabled(LabelOnline, false)
	GUI:setTag(LabelOnline, -1)
	GUI:Text_enableOutline(LabelOnline, "#000000", 1)

	-- Create BtnApplyList
	local BtnApplyList = GUI:Button_Create(FrameLayout, "BtnApplyList", 530.00, 35.00, "res/public/btn_push_common.png")
	GUI:Button_setTitleText(BtnApplyList, "申请列表")
	GUI:Button_setTitleColor(BtnApplyList, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnApplyList, 16)
	GUI:Button_titleEnableOutline(BtnApplyList, "#000000", 1)
	GUI:setAnchorPoint(BtnApplyList, 0.50, 0.50)
	GUI:setTouchEnabled(BtnApplyList, true)
	GUI:setTag(BtnApplyList, -1)
	GUI:setVisible(BtnApplyList, false)

	-- Create BtnEditTitle
	local BtnEditTitle = GUI:Button_Create(FrameLayout, "BtnEditTitle", 390.00, 35.00, "res/public/btn_push_common.png")
	GUI:Button_setTitleText(BtnEditTitle, "编辑封号")
	GUI:Button_setTitleColor(BtnEditTitle, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnEditTitle, 16)
	GUI:Button_titleEnableOutline(BtnEditTitle, "#000000", 1)
	GUI:setAnchorPoint(BtnEditTitle, 0.50, 0.50)
	GUI:setTouchEnabled(BtnEditTitle, true)
	GUI:setTag(BtnEditTitle, -1)
	GUI:setVisible(BtnEditTitle, false)

	-- Create BtnQuit
	local BtnQuit = GUI:Button_Create(FrameLayout, "BtnQuit", 670.00, 35.00, "res/public/btn_push_common.png")
	GUI:Button_setTitleText(BtnQuit, "退出行会")
	GUI:Button_setTitleColor(BtnQuit, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnQuit, 16)
	GUI:Button_titleEnableOutline(BtnQuit, "#000000", 1)
	GUI:setAnchorPoint(BtnQuit, 0.50, 0.50)
	GUI:setTouchEnabled(BtnQuit, true)
	GUI:setTag(BtnQuit, -1)
	GUI:setVisible(BtnQuit, false)

	-- Create BtnDissolve
	local BtnDissolve = GUI:Button_Create(FrameLayout, "BtnDissolve", 670.00, 35.00, "res/public/btn_push_common.png")
	GUI:Button_setTitleText(BtnDissolve, "解散行会")
	GUI:Button_setTitleColor(BtnDissolve, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnDissolve, 16)
	GUI:Button_titleEnableOutline(BtnDissolve, "#000000", 1)
	GUI:setAnchorPoint(BtnDissolve, 0.50, 0.50)
	GUI:setTouchEnabled(BtnDissolve, true)
	GUI:setTag(BtnDissolve, -1)
	GUI:setVisible(BtnDissolve, false)

	-- Create Image_none
	local Image_none = GUI:Image_Create(FrameLayout, "Image_none", 366.00, 245.00, "res/private/guild_ui/word_hhzy_12.png")
	GUI:setAnchorPoint(Image_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_none, false)
	GUI:setTag(Image_none, -1)
	GUI:setVisible(Image_none, false)
end
return ui