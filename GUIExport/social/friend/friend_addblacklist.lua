local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "添加好友场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "添加好友_范围点击关闭")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 80)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 360.00, 145.00, false)
	GUI:setChineseName(Panel_2, "添加好友_组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 81)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 0.00, 0.00, "res/public/1900000650.png")
	GUI:setChineseName(Image_bg, "添加好友_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 82)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_2, "Text_title", 165.00, 122.00, 18, "#ffffff", [[添加黑名单]])
	GUI:setChineseName(Text_title, "添加好友_标题")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 90)
	GUI:Text_enableOutline(Text_title, "#000000", 1)

	-- Create Text_friend_search
	local Text_friend_search = GUI:Text_Create(Panel_2, "Text_friend_search", 100.00, 90.00, 16, "#ffffff", [[黑名单搜索]])
	GUI:setChineseName(Text_friend_search, "添加好友_搜索_文本")
	GUI:setAnchorPoint(Text_friend_search, 1.00, 0.50)
	GUI:setTouchEnabled(Text_friend_search, false)
	GUI:setTag(Text_friend_search, 86)
	GUI:Text_enableOutline(Text_friend_search, "#000000", 1)

	-- Create Image_field_friend_search
	local Image_field_friend_search = GUI:Image_Create(Panel_2, "Image_field_friend_search", 196.00, 88.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_field_friend_search, 51, 51, 10, 10)
	GUI:setContentSize(Image_field_friend_search, 180, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_field_friend_search, false)
	GUI:setChineseName(Image_field_friend_search, "添加好友_输入组合")
	GUI:setAnchorPoint(Image_field_friend_search, 0.50, 0.50)
	GUI:setTouchEnabled(Image_field_friend_search, false)
	GUI:setTag(Image_field_friend_search, 72)

	-- Create TextField_friend_search
	local TextField_friend_search = GUI:TextInput_Create(Image_field_friend_search, "TextField_friend_search", 90.00, 15.00, 180.00, 28.00, 16)
	GUI:TextInput_setString(TextField_friend_search, "")
	GUI:TextInput_setPlaceHolder(TextField_friend_search, "输入玩家昵称")
	GUI:TextInput_setFontColor(TextField_friend_search, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_friend_search, 1000)
	GUI:setChineseName(TextField_friend_search, "添加好友_占位符")
	GUI:setAnchorPoint(TextField_friend_search, 0.50, 0.50)
	GUI:setTouchEnabled(TextField_friend_search, true)
	GUI:setTag(TextField_friend_search, 87)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_2, "Button_cancel", 105.00, 38.00, "res/public/1900000679.png")
	GUI:Button_loadTextureDisabled(Button_cancel, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_cancel, 16, 14, 13, 9)
	GUI:setContentSize(Button_cancel, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "取消")
	GUI:Button_setTitleColor(Button_cancel, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cancel, 16)
	GUI:Button_titleEnableOutline(Button_cancel, "#111111", 2)
	GUI:setChineseName(Button_cancel, "添加好友_取消_按钮")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 88)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(Panel_2, "Button_ok", 231.00, 38.00, "res/public/1900000679.png")
	GUI:Button_loadTextureDisabled(Button_ok, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_ok, 16, 14, 13, 9)
	GUI:setContentSize(Button_ok, 85, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "拉入黑名单")
	GUI:Button_setTitleColor(Button_ok, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_ok, 16)
	GUI:Button_titleEnableOutline(Button_ok, "#111111", 2)
	GUI:setChineseName(Button_ok, "添加好友_拉入黑名单_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 89)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_2, "Button_close", 343.00, 124.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "添加好友_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 85)
end
return ui