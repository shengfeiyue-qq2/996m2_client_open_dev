local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0.00, 0.00, 732.00, 445.00, true)
	GUI:setChineseName(PMainUI, "行会主界面_组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create BG
	local BG = GUI:Image_Create(PMainUI, "BG", 366.00, 222.00, "res/private/guild_ui/bg_guild.png")
	GUI:setChineseName(BG, "行会主界面_背景图")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, -1)

	-- Create GuildFlag
	local GuildFlag = GUI:Image_Create(PMainUI, "GuildFlag", 606.00, 407.00, "res/private/guild_ui/guild_icon.png")
	GUI:setChineseName(GuildFlag, "行会主界面_会长_文本")
	GUI:setAnchorPoint(GuildFlag, 0.50, 0.50)
	GUI:setTouchEnabled(GuildFlag, false)
	GUI:setTag(GuildFlag, -1)

	-- Create GuildName
	local GuildName = GUI:Text_Create(PMainUI, "GuildName", 243.00, 377.00, 16, "#fff600", [[]])
	GUI:setChineseName(GuildName, "行会主界面_行会名称_文本")
	GUI:setAnchorPoint(GuildName, 0.50, 0.50)
	GUI:setTouchEnabled(GuildName, false)
	GUI:setTag(GuildName, -1)

	-- Create MasterName
	local MasterName = GUI:Text_Create(PMainUI, "MasterName", 607.00, 377.00, 16, "#f2e7cf", [[]])
	GUI:setChineseName(MasterName, "行会主界面_会长名称_文本")
	GUI:setAnchorPoint(MasterName, 0.50, 0.50)
	GUI:setTouchEnabled(MasterName, false)
	GUI:setTag(MasterName, -1)

	-- Create Content_Bg
	local Content_Bg = GUI:Image_Create(PMainUI, "Content_Bg", 477.00, 25.00, "res/private/guild_ui/guild_att_bg.png")
	GUI:Image_setScale9Slice(Content_Bg, 5, 5, 6, 4)
	GUI:setContentSize(Content_Bg, 255, 240)
	GUI:setIgnoreContentAdaptWithSize(Content_Bg, false)
	GUI:setChineseName(Content_Bg, "行会主界面_行会公告_背景")
	GUI:setTouchEnabled(Content_Bg, false)
	GUI:setTag(Content_Bg, -1)

	-- Create NoticePic
	local NoticePic = GUI:Image_Create(PMainUI, "NoticePic", 607.00, 280.00, "res/private/guild_ui/title_guild.png")
	GUI:setChineseName(NoticePic, "行会主界面_行会公告_文本")
	GUI:setAnchorPoint(NoticePic, 0.50, 0.50)
	GUI:setTouchEnabled(NoticePic, false)
	GUI:setTag(NoticePic, -1)

	-- Create EditInput
	local EditInput = GUI:TextInput_Create(PMainUI, "EditInput", 483.00, 30.00, 243.00, 230.00, 16)
	GUI:TextInput_setString(EditInput, "")
	GUI:setChineseName(EditInput, "行会主界面_可输入行会公告")
	GUI:setTouchEnabled(EditInput, true)
	GUI:setTag(EditInput, -1)
end
return ui