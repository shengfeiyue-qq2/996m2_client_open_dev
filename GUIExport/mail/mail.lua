local ui = {}
function ui.init(parent)
	-- Create bgPanel
	local bgPanel = GUI:Layout_Create(parent, "bgPanel", 0.00, 0.00, 732.00, 445.00, true)
	GUI:setTouchEnabled(bgPanel, true)
	GUI:setTag(bgPanel, -1)

	-- Create bgImg
	local bgImg = GUI:Image_Create(bgPanel, "bgImg", 366.00, 222.00, "res/private/mail/1900020061.png")
	GUI:setAnchorPoint(bgImg, 0.50, 0.50)
	GUI:setTouchEnabled(bgImg, false)
	GUI:setTag(bgImg, -1)

	-- Create mailList
	local mailList = GUI:ListView_Create(bgPanel, "mailList", 12.00, 54.00, 220.00, 380.00, 1)
	GUI:ListView_setBounceEnabled(mailList, true)
	GUI:ListView_setGravity(mailList, 5)
	GUI:setTouchEnabled(mailList, true)
	GUI:setTag(mailList, -1)

	-- Create btnGetAll
	local btnGetAll = GUI:Button_Create(bgPanel, "btnGetAll", 67.00, 28.00, "res/public/1900000612.png")
	GUI:Button_setTitleText(btnGetAll, "全部提取")
	GUI:Button_setTitleColor(btnGetAll, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnGetAll, 16)
	GUI:Button_titleEnableOutline(btnGetAll, "#111111", 1)
	GUI:setAnchorPoint(btnGetAll, 0.50, 0.50)
	GUI:setTouchEnabled(btnGetAll, true)
	GUI:setTag(btnGetAll, -1)

	-- Create btnDelRead
	local btnDelRead = GUI:Button_Create(bgPanel, "btnDelRead", 176.00, 28.00, "res/public/1900000612.png")
	GUI:Button_setTitleText(btnDelRead, "删除已读")
	GUI:Button_setTitleColor(btnDelRead, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnDelRead, 16)
	GUI:Button_titleEnableOutline(btnDelRead, "#111111", 1)
	GUI:setAnchorPoint(btnDelRead, 0.50, 0.50)
	GUI:setTouchEnabled(btnDelRead, true)
	GUI:setTag(btnDelRead, -1)

	-- Create mainPanel
	local mainPanel = GUI:Layout_Create(bgPanel, "mainPanel", 240.00, 0.00, 490.00, 450.00, true)
	GUI:setTouchEnabled(mainPanel, false)
	GUI:setTag(mainPanel, -1)

	-- Create titlePanel
	local titlePanel = GUI:Layout_Create(mainPanel, "titlePanel", 15.00, 400.00, 460.00, 30.00, false)
	GUI:Layout_setBackGroundImage(titlePanel, "res/private/mail/1900020064.png")
	GUI:Layout_setBackGroundImageScale9Slice(titlePanel, 11, 11, 11, 11)
	GUI:setTouchEnabled(titlePanel, false)
	GUI:setTag(titlePanel, -1)

	-- Create lblTitle
	local lblTitle = GUI:Text_Create(titlePanel, "lblTitle", 10.00, 15.00, 16, "#a58e67", [[主题:]])
	GUI:setAnchorPoint(lblTitle, 0.00, 0.50)
	GUI:setTouchEnabled(lblTitle, false)
	GUI:setTag(lblTitle, -1)
	GUI:Text_enableOutline(lblTitle, "#000000", 1)

	-- Create title
	local title = GUI:Text_Create(titlePanel, "title", 60.00, 15.00, 16, "#f8e6c6", [[xxxxx]])
	GUI:setAnchorPoint(title, 0.00, 0.50)
	GUI:setTouchEnabled(title, false)
	GUI:setTag(title, -1)
	GUI:Text_enableOutline(title, "#000000", 1)

	-- Create senderPanel
	local senderPanel = GUI:Layout_Create(mainPanel, "senderPanel", 15.00, 364.00, 460.00, 30.00, false)
	GUI:Layout_setBackGroundImage(senderPanel, "res/private/mail/1900020064.png")
	GUI:Layout_setBackGroundImageScale9Slice(senderPanel, 11, 11, 11, 11)
	GUI:setTouchEnabled(senderPanel, false)
	GUI:setTag(senderPanel, -1)

	-- Create lblSender
	local lblSender = GUI:Text_Create(senderPanel, "lblSender", 10.00, 15.00, 16, "#a58e67", [[发送者:]])
	GUI:setAnchorPoint(lblSender, 0.00, 0.50)
	GUI:setTouchEnabled(lblSender, false)
	GUI:setTag(lblSender, -1)
	GUI:Text_enableOutline(lblSender, "#000000", 1)

	-- Create sender
	local sender = GUI:Text_Create(senderPanel, "sender", 80.00, 15.00, 16, "#f8e6c6", [[xxxxx]])
	GUI:setAnchorPoint(sender, 0.00, 0.50)
	GUI:setTouchEnabled(sender, false)
	GUI:setTag(sender, -1)
	GUI:Text_enableOutline(sender, "#000000", 1)

	-- Create timePanel
	local timePanel = GUI:Layout_Create(mainPanel, "timePanel", 15.00, 327.00, 460.00, 30.00, false)
	GUI:Layout_setBackGroundImage(timePanel, "res/private/mail/1900020064.png")
	GUI:Layout_setBackGroundImageScale9Slice(timePanel, 11, 11, 11, 11)
	GUI:setTouchEnabled(timePanel, false)
	GUI:setTag(timePanel, -1)

	-- Create lblTime
	local lblTime = GUI:Text_Create(timePanel, "lblTime", 10.00, 15.00, 16, "#a58e67", [[时间:]])
	GUI:setAnchorPoint(lblTime, 0.00, 0.50)
	GUI:setTouchEnabled(lblTime, false)
	GUI:setTag(lblTime, -1)
	GUI:Text_enableOutline(lblTime, "#000000", 1)

	-- Create time
	local time = GUI:Text_Create(timePanel, "time", 60.00, 15.00, 16, "#f8e6c6", [[xxxxx]])
	GUI:setAnchorPoint(time, 0.00, 0.50)
	GUI:setTouchEnabled(time, false)
	GUI:setTag(time, -1)
	GUI:Text_enableOutline(time, "#000000", 1)

	-- Create contentBg
	local contentBg = GUI:Layout_Create(mainPanel, "contentBg", 15.00, 138.00, 460.00, 185.00, false)
	GUI:Layout_setBackGroundImage(contentBg, "res/private/mail/1900020064.png")
	GUI:Layout_setBackGroundImageScale9Slice(contentBg, 11, 11, 11, 11)
	GUI:setTouchEnabled(contentBg, false)
	GUI:setTag(contentBg, -1)

	-- Create contentList
	local contentList = GUI:ListView_Create(mainPanel, "contentList", 25.00, 145.00, 440.00, 170.00, 1)
	GUI:ListView_setGravity(contentList, 5)
	GUI:setTouchEnabled(contentList, true)
	GUI:setTag(contentList, -1)

	-- Create lblItem
	local lblItem = GUI:Text_Create(mainPanel, "lblItem", 35.00, 93.00, 20, "#d8c8ae", [[附
件]])
	GUI:setAnchorPoint(lblItem, 0.50, 0.50)
	GUI:setTouchEnabled(lblItem, false)
	GUI:setTag(lblItem, -1)
	GUI:Text_enableOutline(lblItem, "#111111", 2)

	-- Create itemsList
	local itemsList = GUI:ListView_Create(mainPanel, "itemsList", 50.00, 59.00, 420.00, 70.00, 2)
	GUI:ListView_setGravity(itemsList, 5)
	GUI:ListView_setItemsMargin(itemsList, 5)
	GUI:setTouchEnabled(itemsList, true)
	GUI:setTag(itemsList, -1)

	-- Create completed
	local completed = GUI:Image_Create(mainPanel, "completed", 260.00, 90.00, "res/public/word_bqzy_01.png")
	GUI:setAnchorPoint(completed, 0.50, 0.50)
	GUI:setTouchEnabled(completed, false)
	GUI:setTag(completed, -1)

	-- Create btnGet
	local btnGet = GUI:Button_Create(mainPanel, "btnGet", 434.00, 34.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(btnGet, "提取")
	GUI:Button_setTitleColor(btnGet, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnGet, 16)
	GUI:Button_titleEnableOutline(btnGet, "#111111", 2)
	GUI:setAnchorPoint(btnGet, 0.50, 0.50)
	GUI:setTouchEnabled(btnGet, true)
	GUI:setTag(btnGet, -1)

	-- Create btnDel
	local btnDel = GUI:Button_Create(mainPanel, "btnDel", 434.00, 34.00, "res/public/1900000611.png")
	GUI:Button_setTitleText(btnDel, "删除")
	GUI:Button_setTitleColor(btnDel, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnDel, 16)
	GUI:Button_titleEnableOutline(btnDel, "#111111", 2)
	GUI:setAnchorPoint(btnDel, 0.50, 0.50)
	GUI:setTouchEnabled(btnDel, true)
	GUI:setTag(btnDel, -1)
end
return ui