local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "好友面板")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layer, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_1, "好友组合")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 4)

	-- Create Button_myFriend
	local Button_myFriend = GUI:Button_Create(Panel_1, "Button_myFriend", 53.00, 365.00, "res/public_win32/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_myFriend, "res/public_win32/1900000662.png")
	GUI:Button_setScale9Slice(Button_myFriend, 15, 4, 11, 7)
	GUI:setContentSize(Button_myFriend, 86, 28)
	GUI:setIgnoreContentAdaptWithSize(Button_myFriend, false)
	GUI:Button_setTitleText(Button_myFriend, "我的好友")
	GUI:Button_setTitleColor(Button_myFriend, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_myFriend, 14)
	GUI:Button_titleEnableOutline(Button_myFriend, "#111111", 2)
	GUI:setChineseName(Button_myFriend, "好友_我的好友_按钮")
	GUI:setAnchorPoint(Button_myFriend, 0.50, 0.50)
	GUI:setTouchEnabled(Button_myFriend, true)
	GUI:setTag(Button_myFriend, 5)

	-- Create Button_blackList
	local Button_blackList = GUI:Button_Create(Panel_1, "Button_blackList", 53.00, 330.00, "res/public_win32/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_blackList, "res/public_win32/1900000662.png")
	GUI:Button_setScale9Slice(Button_blackList, 15, 4, 11, 7)
	GUI:setContentSize(Button_blackList, 86, 28)
	GUI:setIgnoreContentAdaptWithSize(Button_blackList, false)
	GUI:Button_setTitleText(Button_blackList, "黑名单")
	GUI:Button_setTitleColor(Button_blackList, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_blackList, 14)
	GUI:Button_titleEnableOutline(Button_blackList, "#111111", 2)
	GUI:setChineseName(Button_blackList, "好友_黑名单_按钮")
	GUI:setAnchorPoint(Button_blackList, 0.50, 0.50)
	GUI:setTouchEnabled(Button_blackList, true)
	GUI:setTag(Button_blackList, 6)

	-- Create Text_friend_number
	local Text_friend_number = GUI:Text_Create(Panel_1, "Text_friend_number", 15.00, 18.00, 14, "#ffffff", [[好友:]])
	GUI:setChineseName(Text_friend_number, "好友_数量_文本")
	GUI:setAnchorPoint(Text_friend_number, 0.00, 0.50)
	GUI:setTouchEnabled(Text_friend_number, false)
	GUI:setTag(Text_friend_number, 19)
	GUI:Text_enableOutline(Text_friend_number, "#111111", 1)

	-- Create Panel_title
	local Panel_title = GUI:Layout_Create(Panel_1, "Panel_title", 0.00, 0.00, 617.00, 390.00, false)
	GUI:setChineseName(Panel_title, "好友标题组合")
	GUI:setTouchEnabled(Panel_title, false)
	GUI:setTag(Panel_title, 11)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_title, "Image_1", 0.00, 38.00, "res/private/team_win32/1900014008.png")
	GUI:setChineseName(Image_1, "标题_背景图")
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 85)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_title, "Text_name", 165.00, 378.00, 12, "#ffffff", [[名字]])
	GUI:setChineseName(Text_name, "标题_名字_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 12)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Panel_title, "Text_job", 272.00, 378.00, 12, "#ffffff", [[职位]])
	GUI:setChineseName(Text_job, "标题_职业_文本")
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 53)
	GUI:Text_enableOutline(Text_job, "#111111", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_title, "Text_level", 350.00, 378.00, 12, "#ffffff", [[等级]])
	GUI:setChineseName(Text_level, "标题_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 13)
	GUI:Text_enableOutline(Text_level, "#111111", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_title, "Text_guild", 440.00, 378.00, 12, "#ffffff", [[行会]])
	GUI:setChineseName(Text_guild, "标题_行会_文本")
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 14)
	GUI:Text_enableOutline(Text_guild, "#111111", 1)

	-- Create Text_state
	local Text_state = GUI:Text_Create(Panel_title, "Text_state", 550.00, 378.00, 12, "#ffffff", [[状态]])
	GUI:setChineseName(Text_state, "标题_状态_文本")
	GUI:setAnchorPoint(Text_state, 0.50, 0.50)
	GUI:setTouchEnabled(Text_state, false)
	GUI:setTag(Text_state, 15)
	GUI:Text_enableOutline(Text_state, "#111111", 1)

	-- Create Panel_myFriend
	local Panel_myFriend = GUI:Layout_Create(Panel_1, "Panel_myFriend", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_myFriend, "添加好友组合")
	GUI:setTouchEnabled(Panel_myFriend, false)
	GUI:setTag(Panel_myFriend, 16)

	-- Create Image_friend_none
	local Image_friend_none = GUI:Image_Create(Panel_myFriend, "Image_friend_none", 361.00, 191.00, "res/private/friend_win32/word_haoyou_01.png")
	GUI:setChineseName(Image_friend_none, "添加好友_提示_图片")
	GUI:setAnchorPoint(Image_friend_none, 0.50, 0.50)
	GUI:setScaleX(Image_friend_none, 0.80)
	GUI:setScaleY(Image_friend_none, 0.80)
	GUI:setTouchEnabled(Image_friend_none, false)
	GUI:setTag(Image_friend_none, 17)

	-- Create Button_add_friend
	local Button_add_friend = GUI:Button_Create(Panel_myFriend, "Button_add_friend", 563.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_add_friend, 15, 15, 11, 11)
	GUI:setContentSize(Button_add_friend, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_add_friend, false)
	GUI:Button_setTitleText(Button_add_friend, "添加好友")
	GUI:Button_setTitleColor(Button_add_friend, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_add_friend, 12)
	GUI:Button_titleEnableOutline(Button_add_friend, "#111111", 2)
	GUI:setChineseName(Button_add_friend, "添加好友_按钮")
	GUI:setAnchorPoint(Button_add_friend, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add_friend, true)
	GUI:setTag(Button_add_friend, 20)

	-- Create ListView_myFriend
	local ListView_myFriend = GUI:ListView_Create(Panel_myFriend, "ListView_myFriend", 108.00, 40.00, 500.00, 325.00, 1)
	GUI:ListView_setGravity(ListView_myFriend, 5)
	GUI:setChineseName(ListView_myFriend, "添加好友_好友列表")
	GUI:setTouchEnabled(ListView_myFriend, true)
	GUI:setTag(ListView_myFriend, 28)

	-- Create Panel_blackList
	local Panel_blackList = GUI:Layout_Create(Panel_1, "Panel_blackList", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_blackList, "添加黑名单组合")
	GUI:setTouchEnabled(Panel_blackList, false)
	GUI:setTag(Panel_blackList, 26)

	-- Create Image_blackList_none
	local Image_blackList_none = GUI:Image_Create(Panel_blackList, "Image_blackList_none", 361.00, 191.00, "res/private/friend_win32/word_haoyou_02.png")
	GUI:setChineseName(Image_blackList_none, "添加黑名单_提示_图片")
	GUI:setAnchorPoint(Image_blackList_none, 0.50, 0.50)
	GUI:setTouchEnabled(Image_blackList_none, false)
	GUI:setTag(Image_blackList_none, 27)

	-- Create ListView_blackList
	local ListView_blackList = GUI:ListView_Create(Panel_blackList, "ListView_blackList", 108.00, 40.00, 500.00, 325.00, 1)
	GUI:ListView_setGravity(ListView_blackList, 5)
	GUI:setChineseName(ListView_blackList, "添加黑名单_黑名单_列表")
	GUI:setTouchEnabled(ListView_blackList, true)
	GUI:setTag(ListView_blackList, 31)

	-- Create Text_black_title
	local Text_black_title = GUI:Text_Create(Panel_blackList, "Text_black_title", 195.00, 18.00, 14, "#f8e6c6", [[聊天频道内不会接收黑名单内玩家发送的信息]])
	GUI:setChineseName(Text_black_title, "添加黑名单_提示_文本")
	GUI:setAnchorPoint(Text_black_title, 0.20, 0.50)
	GUI:setTouchEnabled(Text_black_title, false)
	GUI:setTag(Text_black_title, 52)
	GUI:Text_enableOutline(Text_black_title, "#111111", 2)

	-- Create Button_add_blacklist
	local Button_add_blacklist = GUI:Button_Create(Panel_blackList, "Button_add_blacklist", 563.00, 18.00, "res/public_win32/1900000660.png")
	GUI:Button_setScale9Slice(Button_add_blacklist, 15, 15, 11, 11)
	GUI:setContentSize(Button_add_blacklist, 79, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_add_blacklist, false)
	GUI:Button_setTitleText(Button_add_blacklist, "添加黑名单")
	GUI:Button_setTitleColor(Button_add_blacklist, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_add_blacklist, 12)
	GUI:Button_titleEnableOutline(Button_add_blacklist, "#111111", 2)
	GUI:setChineseName(Button_add_blacklist, "添加黑名单_按钮")
	GUI:setAnchorPoint(Button_add_blacklist, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add_blacklist, true)
	GUI:setTag(Button_add_blacklist, 296)
end
return ui