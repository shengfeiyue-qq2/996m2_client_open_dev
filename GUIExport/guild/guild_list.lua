local ui = {}
function ui.init(parent)
	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 0.00, 0.00, 732.00, 445.00, true)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create BG
	local BG = GUI:Image_Create(FrameLayout, "BG", 366.00, 222.00, "res/private/guild_ui/bg_guild_list.png")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, true)
	GUI:setTag(BG, -1)

	-- Create Title1
	local Title1 = GUI:Text_Create(FrameLayout, "Title1", 76.00, 435.00, 16, "#f2e7cf", [[行会名字]])
	GUI:setAnchorPoint(Title1, 0.50, 0.50)
	GUI:setTouchEnabled(Title1, false)
	GUI:setTag(Title1, -1)
	GUI:Text_enableOutline(Title1, "#000000", 1)

	-- Create Title2
	local Title2 = GUI:Text_Create(FrameLayout, "Title2", 228.00, 435.00, 16, "#f2e7cf", [[会长]])
	GUI:setAnchorPoint(Title2, 0.50, 0.50)
	GUI:setTouchEnabled(Title2, false)
	GUI:setTag(Title2, -1)
	GUI:Text_enableOutline(Title2, "#000000", 1)

	-- Create Title3
	local Title3 = GUI:Text_Create(FrameLayout, "Title3", 365.00, 435.00, 16, "#f2e7cf", [[人数]])
	GUI:setAnchorPoint(Title3, 0.50, 0.50)
	GUI:setTouchEnabled(Title3, false)
	GUI:setTag(Title3, -1)
	GUI:Text_enableOutline(Title3, "#000000", 1)

	-- Create Title4
	local Title4 = GUI:Text_Create(FrameLayout, "Title4", 480.00, 435.00, 16, "#f2e7cf", [[加入条件]])
	GUI:setAnchorPoint(Title4, 0.50, 0.50)
	GUI:setTouchEnabled(Title4, false)
	GUI:setTag(Title4, -1)
	GUI:Text_enableOutline(Title4, "#000000", 1)

	-- Create Title5
	local Title5 = GUI:Text_Create(FrameLayout, "Title5", 635.00, 435.00, 16, "#f2e7cf", [[操作]])
	GUI:setAnchorPoint(Title5, 0.50, 0.50)
	GUI:setTouchEnabled(Title5, false)
	GUI:setTag(Title5, -1)
	GUI:Text_enableOutline(Title5, "#000000", 1)

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

	-- Create CheckBox
	local CheckBox = GUI:CheckBox_Create(FrameLayout, "CheckBox", 45.00, 35.00, "res/public/1900000550.png", "res/public/1900000551.png")
	GUI:CheckBox_setSelected(CheckBox, false)
	GUI:setAnchorPoint(CheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(CheckBox, true)
	GUI:setTag(CheckBox, -1)

	-- Create Label
	local Label = GUI:Text_Create(CheckBox, "Label", 35.00, 2.00, 16, "#41ca44", [[只显示会长在线的行会]])
	GUI:setTouchEnabled(Label, false)
	GUI:setTag(Label, -1)
	GUI:Text_enableOutline(Label, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(CheckBox, "TouchSize", 0.00, -1.00, 189.00, 28.00, false)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create List
	local List = GUI:ListView_Create(FrameLayout, "List", 0.00, 72.00, 732.00, 347.00, 1)
	GUI:ListView_setGravity(List, 5)
	GUI:setTouchEnabled(List, true)
	GUI:setTag(List, -1)

	-- Create Item
	local Item = GUI:Layout_Create(FrameLayout, "Item", 0.00, 104.00, 732.00, 50.00, true)
	GUI:setTouchEnabled(Item, false)
	GUI:setTag(Item, -1)
	GUI:setVisible(Item, false)

	-- Create line
	local line = GUI:Image_Create(Item, "line", 0.00, 0.00, "res/public/img_line_long.png")
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create TName
	local TName = GUI:Text_Create(Item, "TName", 76.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(TName, 0.50, 0.50)
	GUI:setTouchEnabled(TName, false)
	GUI:setTag(TName, -1)
	GUI:Text_enableOutline(TName, "#000000", 1)

	-- Create TChairman
	local TChairman = GUI:Text_Create(Item, "TChairman", 228.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(TChairman, 0.50, 0.50)
	GUI:setTouchEnabled(TChairman, false)
	GUI:setTag(TChairman, -1)
	GUI:Text_enableOutline(TChairman, "#000000", 1)

	-- Create TCount
	local TCount = GUI:Text_Create(Item, "TCount", 365.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(TCount, 0.50, 0.50)
	GUI:setTouchEnabled(TCount, false)
	GUI:setTag(TCount, -1)
	GUI:Text_enableOutline(TCount, "#000000", 1)

	-- Create TCondition
	local TCondition = GUI:Text_Create(Item, "TCondition", 480.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(TCondition, 0.50, 0.50)
	GUI:setTouchEnabled(TCondition, false)
	GUI:setTag(TCondition, -1)
	GUI:Text_enableOutline(TCondition, "#000000", 1)

	-- Create TDesc
	local TDesc = GUI:Text_Create(Item, "TDesc", 635.00, 25.00, 16, "#f2e7cf", [[已申请]])
	GUI:setAnchorPoint(TDesc, 0.50, 0.50)
	GUI:setTouchEnabled(TDesc, false)
	GUI:setTag(TDesc, -1)
	GUI:setVisible(TDesc, false)
	GUI:Text_enableOutline(TDesc, "#000000", 1)

	-- Create BtnWar
	local BtnWar = GUI:Button_Create(Item, "BtnWar", 590.00, 25.00, "res/public/btn_push_short.png")
	GUI:Button_setTitleText(BtnWar, "宣战")
	GUI:Button_setTitleColor(BtnWar, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnWar, 16)
	GUI:Button_titleEnableOutline(BtnWar, "#000000", 1)
	GUI:setAnchorPoint(BtnWar, 0.50, 0.50)
	GUI:setTouchEnabled(BtnWar, true)
	GUI:setTag(BtnWar, -1)

	-- Create BtnAlly
	local BtnAlly = GUI:Button_Create(Item, "BtnAlly", 680.00, 25.00, "res/public/btn_push_short.png")
	GUI:Button_setTitleText(BtnAlly, "结盟")
	GUI:Button_setTitleColor(BtnAlly, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnAlly, 16)
	GUI:Button_titleEnableOutline(BtnAlly, "#000000", 1)
	GUI:setAnchorPoint(BtnAlly, 0.50, 0.50)
	GUI:setTouchEnabled(BtnAlly, true)
	GUI:setTag(BtnAlly, -1)

	-- Create BtnJoin
	local BtnJoin = GUI:Button_Create(Item, "BtnJoin", 635.00, 25.00, "res/public/btn_push_short.png")
	GUI:Button_setTitleText(BtnJoin, "")
	GUI:Button_setTitleColor(BtnJoin, "#f7f0e2")
	GUI:Button_setTitleFontSize(BtnJoin, 16)
	GUI:Button_titleEnableOutline(BtnJoin, "#000000", 1)
	GUI:setAnchorPoint(BtnJoin, 0.50, 0.50)
	GUI:setTouchEnabled(BtnJoin, true)
	GUI:setTag(BtnJoin, -1)

	-- Create BtnCancel
	local BtnCancel = GUI:Button_Create(Item, "BtnCancel", 720.00, 25.00, "res/public/btn_gban_01.png")
	GUI:Button_setTitleText(BtnCancel, "")
	GUI:Button_setTitleColor(BtnCancel, "#ffffff")
	GUI:Button_setTitleFontSize(BtnCancel, 10)
	GUI:Button_titleEnableOutline(BtnCancel, "#000000", 1)
	GUI:setAnchorPoint(BtnCancel, 0.50, 0.50)
	GUI:setTouchEnabled(BtnCancel, true)
	GUI:setTag(BtnCancel, -1)
end
return ui