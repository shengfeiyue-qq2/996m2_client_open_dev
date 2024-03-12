local ui = {}
function ui.init(parent)
	-- Create mainPanel
	local mainPanel = GUI:Layout_Create(parent, "mainPanel", 207.00, 94.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(mainPanel, false)
	GUI:setTag(mainPanel, -1)

	-- Create myTeamBtn
	local myTeamBtn = GUI:Button_Create(mainPanel, "myTeamBtn", 65.00, 420.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(myTeamBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(myTeamBtn, "我的队伍")
	GUI:Button_setTitleColor(myTeamBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(myTeamBtn, 18)
	GUI:Button_titleEnableOutline(myTeamBtn, "#111111", 2)
	GUI:setAnchorPoint(myTeamBtn, 0.50, 0.50)
	GUI:setTouchEnabled(myTeamBtn, true)
	GUI:setTag(myTeamBtn, -1)

	-- Create nearTeamBtn
	local nearTeamBtn = GUI:Button_Create(mainPanel, "nearTeamBtn", 65.00, 378.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(nearTeamBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(nearTeamBtn, "附近队伍")
	GUI:Button_setTitleColor(nearTeamBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(nearTeamBtn, 18)
	GUI:Button_titleEnableOutline(nearTeamBtn, "#111111", 2)
	GUI:setAnchorPoint(nearTeamBtn, 0.50, 0.50)
	GUI:setTouchEnabled(nearTeamBtn, true)
	GUI:setTag(nearTeamBtn, -1)

	-- Create myTeamPanel
	local myTeamPanel = GUI:Layout_Create(mainPanel, "myTeamPanel", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(myTeamPanel, false)
	GUI:setTag(myTeamPanel, -1)

	-- Create lineBg
	local lineBg = GUI:Image_Create(myTeamPanel, "lineBg", 0.00, 52.00, "res/private/team/1900014008.png")
	GUI:setTouchEnabled(lineBg, false)
	GUI:setTag(lineBg, -1)

	-- Create noneTip
	local noneTip = GUI:Image_Create(myTeamPanel, "noneTip", 430.00, 244.00, "res/private/team/1900014011.png")
	GUI:setAnchorPoint(noneTip, 0.50, 0.50)
	GUI:setTouchEnabled(noneTip, false)
	GUI:setTag(noneTip, -1)

	-- Create createTeamBtn
	local createTeamBtn = GUI:Button_Create(myTeamPanel, "createTeamBtn", 673.00, 24.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(createTeamBtn, "创建队伍")
	GUI:Button_setTitleColor(createTeamBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(createTeamBtn, 18)
	GUI:Button_titleEnableOutline(createTeamBtn, "#111111", 2)
	GUI:setAnchorPoint(createTeamBtn, 0.50, 0.50)
	GUI:setTouchEnabled(createTeamBtn, true)
	GUI:setTag(createTeamBtn, -1)

	-- Create applyListBtn
	local applyListBtn = GUI:Button_Create(myTeamPanel, "applyListBtn", 340.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(applyListBtn, "申请列表")
	GUI:Button_setTitleColor(applyListBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(applyListBtn, 18)
	GUI:Button_titleEnableOutline(applyListBtn, "#111111", 2)
	GUI:setAnchorPoint(applyListBtn, 0.50, 0.50)
	GUI:setTouchEnabled(applyListBtn, true)
	GUI:setTag(applyListBtn, -1)

	-- Create callBtn
	local callBtn = GUI:Button_Create(myTeamPanel, "callBtn", 450.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(callBtn, "召集队友")
	GUI:Button_setTitleColor(callBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(callBtn, 18)
	GUI:Button_titleEnableOutline(callBtn, "#111111", 2)
	GUI:setAnchorPoint(callBtn, 0.50, 0.50)
	GUI:setTouchEnabled(callBtn, true)
	GUI:setTag(callBtn, -1)

	-- Create inviteBtn
	local inviteBtn = GUI:Button_Create(myTeamPanel, "inviteBtn", 560.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(inviteBtn, "邀请成员")
	GUI:Button_setTitleColor(inviteBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(inviteBtn, 18)
	GUI:Button_titleEnableOutline(inviteBtn, "#111111", 2)
	GUI:setAnchorPoint(inviteBtn, 0.50, 0.50)
	GUI:setTouchEnabled(inviteBtn, true)
	GUI:setTag(inviteBtn, -1)

	-- Create exitBtn
	local exitBtn = GUI:Button_Create(myTeamPanel, "exitBtn", 673.00, 26.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(exitBtn, "离开队伍")
	GUI:Button_setTitleColor(exitBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(exitBtn, 18)
	GUI:Button_titleEnableOutline(exitBtn, "#111111", 2)
	GUI:setAnchorPoint(exitBtn, 0.50, 0.50)
	GUI:setTouchEnabled(exitBtn, true)
	GUI:setTag(exitBtn, -1)

	-- Create nameText
	local nameText = GUI:Text_Create(myTeamPanel, "nameText", 218.00, 432.00, 16, "#ffffff", [[名字]])
	GUI:setAnchorPoint(nameText, 0.50, 0.50)
	GUI:setTouchEnabled(nameText, false)
	GUI:setTag(nameText, -1)
	GUI:Text_enableOutline(nameText, "#111111", 1)

	-- Create jobText
	local jobText = GUI:Text_Create(myTeamPanel, "jobText", 345.00, 432.00, 16, "#ffffff", [[职业]])
	GUI:setAnchorPoint(jobText, 0.50, 0.50)
	GUI:setTouchEnabled(jobText, false)
	GUI:setTag(jobText, -1)
	GUI:Text_enableOutline(jobText, "#111111", 1)

	-- Create levelText
	local levelText = GUI:Text_Create(myTeamPanel, "levelText", 423.00, 432.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(levelText, 0.50, 0.50)
	GUI:setTouchEnabled(levelText, false)
	GUI:setTag(levelText, -1)
	GUI:Text_enableOutline(levelText, "#111111", 1)

	-- Create guildText
	local guildText = GUI:Text_Create(myTeamPanel, "guildText", 530.00, 432.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(guildText, 0.50, 0.50)
	GUI:setTouchEnabled(guildText, false)
	GUI:setTag(guildText, -1)
	GUI:Text_enableOutline(guildText, "#111111", 1)

	-- Create mapText
	local mapText = GUI:Text_Create(myTeamPanel, "mapText", 665.00, 432.00, 16, "#ffffff", [[所在地图]])
	GUI:setAnchorPoint(mapText, 0.50, 0.50)
	GUI:setTouchEnabled(mapText, false)
	GUI:setTag(mapText, -1)
	GUI:Text_enableOutline(mapText, "#111111", 1)

	-- Create expText
	local expText = GUI:Text_Create(myTeamPanel, "expText", 150.00, 27.00, 16, "#ffffff", [[经验加成]])
	GUI:setAnchorPoint(expText, 0.00, 0.50)
	GUI:setTouchEnabled(expText, false)
	GUI:setTag(expText, -1)
	GUI:Text_enableOutline(expText, "#111111", 1)

	-- Create permitCheckBox
	local permitCheckBox = GUI:CheckBox_Create(myTeamPanel, "permitCheckBox", 26.00, 27.00, "res/public/1900000654.png", "res/public/1900000655.png")
	GUI:CheckBox_setSelected(permitCheckBox, false)
	GUI:setAnchorPoint(permitCheckBox, 0.50, 0.50)
	GUI:setTouchEnabled(permitCheckBox, true)
	GUI:setTag(permitCheckBox, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(permitCheckBox, "TouchSize", -9.00, 9.00, 100.00, 28.50, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 0.50)
	GUI:setTouchEnabled(TouchSize, false)
	GUI:setTag(TouchSize, -1)

	-- Create permitText
	local permitText = GUI:Text_Create(permitCheckBox, "permitText", 25.00, 9.00, 16, "#28ef01", [[允许组队]])
	GUI:setAnchorPoint(permitText, 0.00, 0.50)
	GUI:setTouchEnabled(permitText, false)
	GUI:setTag(permitText, -1)
	GUI:Text_enableOutline(permitText, "#111111", 1)

	-- Create memberListView
	local memberListView = GUI:ListView_Create(myTeamPanel, "memberListView", 131.00, 58.00, 600.00, 360.00, 1)
	GUI:ListView_setGravity(memberListView, 2)
	GUI:setTouchEnabled(memberListView, true)
	GUI:setTag(memberListView, -1)

	-- Create nearTeamPanel
	local nearTeamPanel = GUI:Layout_Create(mainPanel, "nearTeamPanel", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(nearTeamPanel, false)
	GUI:setTag(nearTeamPanel, -1)
	GUI:setVisible(nearTeamPanel, false)

	-- Create lineBg
	local lineBg = GUI:Image_Create(nearTeamPanel, "lineBg", 0.00, 52.00, "res/private/team/19000140013.png")
	GUI:setTouchEnabled(lineBg, false)
	GUI:setTag(lineBg, -1)

	-- Create teamText
	local teamText = GUI:Text_Create(nearTeamPanel, "teamText", 215.00, 432.00, 16, "#ffffff", [[队伍]])
	GUI:setAnchorPoint(teamText, 0.50, 0.50)
	GUI:setTouchEnabled(teamText, false)
	GUI:setTag(teamText, -1)
	GUI:Text_enableOutline(teamText, "#000000", 1)

	-- Create guild1Text
	local guild1Text = GUI:Text_Create(nearTeamPanel, "guild1Text", 383.00, 432.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(guild1Text, 0.50, 0.50)
	GUI:setTouchEnabled(guild1Text, false)
	GUI:setTag(guild1Text, -1)
	GUI:Text_enableOutline(guild1Text, "#000000", 1)

	-- Create numberText
	local numberText = GUI:Text_Create(nearTeamPanel, "numberText", 540.00, 432.00, 16, "#ffffff", [[人数]])
	GUI:setAnchorPoint(numberText, 0.50, 0.50)
	GUI:setTouchEnabled(numberText, false)
	GUI:setTag(numberText, -1)
	GUI:Text_enableOutline(numberText, "#000000", 1)

	-- Create operationText
	local operationText = GUI:Text_Create(nearTeamPanel, "operationText", 660.00, 432.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(operationText, 0.50, 0.50)
	GUI:setTouchEnabled(operationText, false)
	GUI:setTag(operationText, -1)
	GUI:Text_enableOutline(operationText, "#000000", 1)

	-- Create nearListView
	local nearListView = GUI:ListView_Create(nearTeamPanel, "nearListView", 131.00, 58.00, 600.00, 360.00, 1)
	GUI:ListView_setGravity(nearListView, 5)
	GUI:setTouchEnabled(nearListView, true)
	GUI:setTag(nearListView, -1)
end
return ui