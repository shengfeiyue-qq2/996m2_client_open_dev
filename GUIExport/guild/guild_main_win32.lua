local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "行会主界面_组合")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Layer, "PMainUI", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(PMainUI, "行会主界面_组合")
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 34)

	-- Create BG
	local BG = GUI:Image_Create(PMainUI, "BG", 303.00, 195.00, "res/public/bg_hhjm_01.jpg")
	GUI:setContentSize(BG, 606, 390)
	GUI:setIgnoreContentAdaptWithSize(BG, false)
	GUI:setChineseName(BG, "行会主界面_背景图")
	GUI:setAnchorPoint(BG, 0.50, 0.50)
	GUI:setTouchEnabled(BG, false)
	GUI:setTag(BG, 44)

	-- Create BG2
	local BG2 = GUI:Image_Create(PMainUI, "BG2", 190.00, 210.00, "res/private/guild_ui/icon_hhzy_01.png")
	GUI:setChineseName(BG2, "行会主界面_旗帜图片")
	GUI:setAnchorPoint(BG2, 0.50, 0.50)
	GUI:setTouchEnabled(BG2, false)
	GUI:setTag(BG2, 49)

	-- Create Image_frame1
	local Image_frame1 = GUI:Image_Create(PMainUI, "Image_frame1", 460.00, 370.00, "res/public/bg_hhzy_01.png")
	GUI:Image_setScale9Slice(Image_frame1, 110, 108, 45, 43)
	GUI:setContentSize(Image_frame1, 333, 82)
	GUI:setIgnoreContentAdaptWithSize(Image_frame1, false)
	GUI:setChineseName(Image_frame1, "行会主界面_会长_背景图")
	GUI:setAnchorPoint(Image_frame1, 0.50, 1.00)
	GUI:setScaleX(Image_frame1, 0.90)
	GUI:setScaleY(Image_frame1, 0.90)
	GUI:setTouchEnabled(Image_frame1, false)
	GUI:setTag(Image_frame1, 50)

	-- Create Image_master
	local Image_master = GUI:Image_Create(PMainUI, "Image_master", 460.00, 361.00, "res/private/guild_ui_win32/word_hhzy_04.png")
	GUI:setChineseName(Image_master, "行会主界面_会长_文字图片")
	GUI:setAnchorPoint(Image_master, 0.50, 0.50)
	GUI:setTouchEnabled(Image_master, false)
	GUI:setTag(Image_master, 38)

	-- Create GuildName
	local GuildName = GUI:Text_Create(PMainUI, "GuildName", 190.00, 340.00, 12, "#ffffff", [[]])
	GUI:setChineseName(GuildName, "行会主界面_行会名称_文本")
	GUI:setAnchorPoint(GuildName, 0.50, 0.50)
	GUI:setTouchEnabled(GuildName, false)
	GUI:setTag(GuildName, 120)
	GUI:Text_enableOutline(GuildName, "#111111", 1)

	-- Create MasterName
	local MasterName = GUI:Text_Create(PMainUI, "MasterName", 460.00, 325.00, 12, "#ffffff", [[]])
	GUI:setChineseName(MasterName, "行会主界面_会长名称_文本")
	GUI:setAnchorPoint(MasterName, 0.50, 0.50)
	GUI:setTouchEnabled(MasterName, false)
	GUI:setTag(MasterName, 37)
	GUI:Text_enableOutline(MasterName, "#111111", 1)

	-- Create Image_frame2
	local Image_frame2 = GUI:Image_Create(PMainUI, "Image_frame2", 460.00, 284.00, "res/public/bg_hhzy_01.png")
	GUI:Image_setScale9Slice(Image_frame2, 110, 108, 45, 43)
	GUI:setContentSize(Image_frame2, 333, 198)
	GUI:setIgnoreContentAdaptWithSize(Image_frame2, false)
	GUI:setChineseName(Image_frame2, "行会主界面_行会公告_背景")
	GUI:setAnchorPoint(Image_frame2, 0.50, 1.00)
	GUI:setScaleX(Image_frame2, 0.90)
	GUI:setScaleY(Image_frame2, 0.90)
	GUI:setTouchEnabled(Image_frame2, false)
	GUI:setTag(Image_frame2, 53)

	-- Create Image_notice
	local Image_notice = GUI:Image_Create(PMainUI, "Image_notice", 460.00, 270.00, "res/private/guild_ui_win32/word_hhzy_02.png")
	GUI:setChineseName(Image_notice, "行会主界面_行会公告_文字图片")
	GUI:setAnchorPoint(Image_notice, 0.50, 0.50)
	GUI:setTouchEnabled(Image_notice, false)
	GUI:setTag(Image_notice, 40)

	-- Create EditInput
	local EditInput = GUI:TextInput_Create(PMainUI, "EditInput", 460.00, 257.00, 260.00, 142.00, 13)
	GUI:TextInput_setString(EditInput, "")
	GUI:TextInput_setFontColor(EditInput, "#ffffff")
	GUI:TextInput_setMaxLength(EditInput, 100)
	GUI:setChineseName(EditInput, "行会主界面_可输入行会公告")
	GUI:setAnchorPoint(EditInput, 0.50, 1.00)
	GUI:setTouchEnabled(EditInput, true)
	GUI:setTag(EditInput, 57)
end
return ui