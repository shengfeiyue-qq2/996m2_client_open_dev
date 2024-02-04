local ui = {}
function ui.init(parent)
	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 0.00, 0.00, 732.00, 445.00, true)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create BG
	local BG = GUI:Image_Create(FrameLayout, "BG", 366.00, 222.00, "res/private/guild_ui/bg_guild.png")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, -1)

	-- Create GuildFlag
	local GuildFlag = GUI:Image_Create(FrameLayout, "GuildFlag", 606.00, 407.00, "res/private/guild_ui/guild_icon.png")
	GUI:setAnchorPoint(GuildFlag, 0.50, 0.50)
	GUI:setTouchEnabled(GuildFlag, false)
	GUI:setTag(GuildFlag, -1)

	-- Create GuildName
	local GuildName = GUI:Text_Create(FrameLayout, "GuildName", 243.00, 377.00, 16, "#fff600", [[]])
	GUI:setAnchorPoint(GuildName, 0.50, 0.50)
	GUI:setTouchEnabled(GuildName, false)
	GUI:setTag(GuildName, -1)
	GUI:Text_enableOutline(GuildName, "#000000", 1)

	-- Create MasterName
	local MasterName = GUI:Text_Create(FrameLayout, "MasterName", 607.00, 377.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(MasterName, 0.50, 0.50)
	GUI:setTouchEnabled(MasterName, false)
	GUI:setTag(MasterName, -1)
	GUI:Text_enableOutline(MasterName, "#000000", 1)

	-- Create Content_Bg
	local Content_Bg = GUI:Image_Create(FrameLayout, "Content_Bg", 477.00, 25.00, "res/private/guild_ui/guild_att_bg.png")
	GUI:Image_setScale9Slice(Content_Bg, 5, 5, 5, 5)
	GUI:setContentSize(Content_Bg, 255, 240)
	GUI:setIgnoreContentAdaptWithSize(Content_Bg, false)
	GUI:setTouchEnabled(Content_Bg, false)
	GUI:setTag(Content_Bg, -1)

	-- Create NoticePic
	local NoticePic = GUI:Image_Create(FrameLayout, "NoticePic", 607.00, 280.00, "res/private/guild_ui/title_guild.png")
	GUI:setAnchorPoint(NoticePic, 0.50, 0.50)
	GUI:setTouchEnabled(NoticePic, false)
	GUI:setTag(NoticePic, -1)

	-- Create Input
	local Input = GUI:TextInput_Create(FrameLayout, "Input", 483.00, 30.00, 243.00, 230.00, 16)
	GUI:TextInput_setString(Input, "")
	GUI:TextInput_setFontColor(Input, "#ffffff")
	GUI:setTouchEnabled(Input, true)
	GUI:setTag(Input, -1)
end
return ui