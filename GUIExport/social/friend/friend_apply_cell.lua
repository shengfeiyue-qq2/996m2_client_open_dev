local ui = {}
function ui.init(parent)
	-- Create apply_cell
	local apply_cell = GUI:Layout_Create(parent, "apply_cell", 0.00, 0.00, 490.00, 58.00, false)
	GUI:setChineseName(apply_cell, "好友申请_组合")
	GUI:setTouchEnabled(apply_cell, true)
	GUI:setTag(apply_cell, 76)

	-- Create Text_apply_name
	local Text_apply_name = GUI:Text_Create(apply_cell, "Text_apply_name", 16.00, 29.00, 16, "#ffffff", [[玩家名字   请求添加您为好友！]])
	GUI:setChineseName(Text_apply_name, "好友申请_提示文案_文本")
	GUI:setAnchorPoint(Text_apply_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_apply_name, false)
	GUI:setTag(Text_apply_name, 85)
	GUI:Text_enableOutline(Text_apply_name, "#000000", 1)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(apply_cell, "Button_ok", 440.00, 28.00, "res/public/1900000679_1.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public/1900000679.png")
	GUI:Button_setScale9Slice(Button_ok, 16, 14, 13, 9)
	GUI:setContentSize(Button_ok, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "确定")
	GUI:Button_setTitleColor(Button_ok, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_ok, 18)
	GUI:Button_titleEnableOutline(Button_ok, "#111111", 2)
	GUI:setChineseName(Button_ok, "好友申请_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 96)

	-- Create Button_no
	local Button_no = GUI:Button_Create(apply_cell, "Button_no", 346.00, 29.00, "res/public/1900000679_1.png")
	GUI:Button_loadTexturePressed(Button_no, "res/public/1900000679.png")
	GUI:Button_setScale9Slice(Button_no, 16, 14, 13, 9)
	GUI:setContentSize(Button_no, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_no, false)
	GUI:Button_setTitleText(Button_no, "取消")
	GUI:Button_setTitleColor(Button_no, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_no, 18)
	GUI:Button_titleEnableOutline(Button_no, "#111111", 2)
	GUI:setChineseName(Button_no, "好友申请_取消_按钮")
	GUI:setAnchorPoint(Button_no, 0.50, 0.50)
	GUI:setTouchEnabled(Button_no, true)
	GUI:setTag(Button_no, 97)

	-- Create Image_line
	local Image_line = GUI:Image_Create(apply_cell, "Image_line", 230.00, 1.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_line, 523, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_line, false)
	GUI:setChineseName(Image_line, "好友申请_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 74)
end
return ui