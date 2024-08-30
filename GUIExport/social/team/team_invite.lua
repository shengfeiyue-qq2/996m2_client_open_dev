local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "邀请成员场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_2, "邀请成员_范围点击关闭")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 96)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 680.00, 400.00, false)
	GUI:setChineseName(Panel_1, "邀请成员组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 340.00, 200.00, "res/public/1900000675.jpg")
	GUI:setChineseName(Image_1, "邀请成员_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 37)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 395.00, 190.00, "res/private/team/1900014007.png")
	GUI:setChineseName(Image_3, "邀请成员_内背景图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 43)

	-- Create Layout_line_bg
	local Layout_line_bg = GUI:Layout_Create(Image_3, "Layout_line_bg", 0.00, 0.00, 505.00, 5.00, true)
	GUI:setChineseName(Layout_line_bg, "邀请成员_装饰条")
	GUI:setTouchEnabled(Layout_line_bg, false)
	GUI:setTag(Layout_line_bg, -1)

	-- Create line
	local line = GUI:Image_Create(Layout_line_bg, "line", 0.00, 2.00, "res/private/team/1900014007.png")
	GUI:setChineseName(line, "邀请成员_装饰条")
	GUI:setAnchorPoint(line, 0.00, 1.00)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 701.00, 388.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "邀请成员_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 38)

	-- Create Button_near
	local Button_near = GUI:Button_Create(Panel_1, "Button_near", 80.00, 335.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_near, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_near, 15, 15, 11, 11)
	GUI:setContentSize(Button_near, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_near, false)
	GUI:Button_setTitleText(Button_near, "附近")
	GUI:Button_setTitleColor(Button_near, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_near, 18)
	GUI:Button_titleEnableOutline(Button_near, "#111111", 2)
	GUI:setChineseName(Button_near, "邀请成员_附近_按钮")
	GUI:setAnchorPoint(Button_near, 0.50, 0.50)
	GUI:setTouchEnabled(Button_near, true)
	GUI:setTag(Button_near, 40)

	-- Create Button_friend
	local Button_friend = GUI:Button_Create(Panel_1, "Button_friend", 80.00, 295.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_friend, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_friend, 15, 15, 11, 11)
	GUI:setContentSize(Button_friend, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_friend, false)
	GUI:Button_setTitleText(Button_friend, "好友")
	GUI:Button_setTitleColor(Button_friend, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_friend, 18)
	GUI:Button_titleEnableOutline(Button_friend, "#111111", 2)
	GUI:setChineseName(Button_friend, "邀请成员_好友_按钮")
	GUI:setAnchorPoint(Button_friend, 0.50, 0.50)
	GUI:setTouchEnabled(Button_friend, true)
	GUI:setTag(Button_friend, 39)

	-- Create Button_guild
	local Button_guild = GUI:Button_Create(Panel_1, "Button_guild", 80.00, 255.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_guild, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_guild, 15, 15, 11, 11)
	GUI:setContentSize(Button_guild, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_guild, false)
	GUI:Button_setTitleText(Button_guild, "行会")
	GUI:Button_setTitleColor(Button_guild, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_guild, 18)
	GUI:Button_titleEnableOutline(Button_guild, "#111111", 2)
	GUI:setChineseName(Button_guild, "邀请成员_行会_按钮")
	GUI:setAnchorPoint(Button_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Button_guild, true)
	GUI:setTag(Button_guild, 44)

	-- Create Button_name
	local Button_name = GUI:Button_Create(Panel_1, "Button_name", 80.00, 215.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_name, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_name, 15, 15, 11, 11)
	GUI:setContentSize(Button_name, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_name, false)
	GUI:Button_setTitleText(Button_name, "输入名字")
	GUI:Button_setTitleColor(Button_name, "#6c6861")
	GUI:Button_setTitleFontSize(Button_name, 18)
	GUI:Button_titleEnableOutline(Button_name, "#111111", 2)
	GUI:setChineseName(Button_name, "邀请成员_输入名字_按钮")
	GUI:setAnchorPoint(Button_name, 0.50, 0.50)
	GUI:setTouchEnabled(Button_name, true)
	GUI:setTag(Button_name, 142)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 340.00, 369.00, "res/private/team/1900014005.png")
	GUI:setChineseName(Image_title, "邀请成员_标题_图片")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 41)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 210.00, 339.00, 16, "#ffffff", [[名字]])
	GUI:setChineseName(Text_name, "邀请成员_名字_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 47)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_1, "Text_guild", 340.00, 339.00, 16, "#ffffff", [[行会]])
	GUI:setChineseName(Text_guild, "邀请成员_行会_文本")
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 45)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_1, "Text_level", 480.00, 339.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Text_level, "邀请成员_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 46)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_operation
	local Text_operation = GUI:Text_Create(Panel_1, "Text_operation", 600.00, 339.00, 16, "#ffffff", [[操作]])
	GUI:setChineseName(Text_operation, "邀请成员_操作_文本")
	GUI:setAnchorPoint(Text_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Text_operation, false)
	GUI:setTag(Text_operation, 48)
	GUI:Text_enableOutline(Text_operation, "#000000", 1)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_1, "ListView", 143.00, 325.00, 504.00, 295.00, 1)
	GUI:ListView_setGravity(ListView, 2)
	GUI:setChineseName(ListView, "邀请成员_申请列表")
	GUI:setAnchorPoint(ListView, 0.00, 1.00)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 42)
end
return ui