local ui = {}
function ui.init(parent)
	-- Create TouchLayout
	local TouchLayout = GUI:Layout_Create(parent, "TouchLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(TouchLayout, "公告_触摸点击关闭")
	GUI:setTouchEnabled(TouchLayout, true)
	GUI:setTag(TouchLayout, -1)

	-- Create ConfirmBG
	local ConfirmBG = GUI:Image_Create(parent, "ConfirmBG", 568.00, 320.00, "res/private/announce/000030.png")
	GUI:setChineseName(ConfirmBG, "公告组合")
	GUI:setAnchorPoint(ConfirmBG, 0.50, 0.50)
	GUI:setTouchEnabled(ConfirmBG, false)
	GUI:setTag(ConfirmBG, -1)

	-- Create ContentLayout
	local ContentLayout = GUI:Layout_Create(ConfirmBG, "ContentLayout", 195.00, 478.00, 300.00, 456.00, false)
	GUI:setChineseName(ContentLayout, "公告_内容标签")
	GUI:setAnchorPoint(ContentLayout, 0.50, 1.00)
	GUI:setTouchEnabled(ContentLayout, false)
	GUI:setTag(ContentLayout, -1)

	-- Create ConfirmButton
	local ConfirmButton = GUI:Button_Create(ConfirmBG, "ConfirmButton", 184.00, 60.00, "res/private/announce/00000361.png")
	GUI:Button_loadTexturePressed(ConfirmButton, "res/private/announce/00000362.png")
	GUI:Button_setTitleText(ConfirmButton, "")
	GUI:Button_setTitleColor(ConfirmButton, "#ffffff")
	GUI:Button_setTitleFontSize(ConfirmButton, 10)
	GUI:Button_titleEnableOutline(ConfirmButton, "#000000", 1)
	GUI:setChineseName(ConfirmButton, "公告_确认_按钮")
	GUI:setAnchorPoint(ConfirmButton, 0.50, 0.50)
	GUI:setTouchEnabled(ConfirmButton, true)
	GUI:setTag(ConfirmButton, -1)

	-- Create RemainingText
	local RemainingText = GUI:Text_Create(ConfirmBG, "RemainingText", 244.00, 60.00, 18, "#ffffff", [[(3)]])
	GUI:setChineseName(RemainingText, "公告_倒计时_文本")
	GUI:setAnchorPoint(RemainingText, 0.00, 0.50)
	GUI:setTouchEnabled(RemainingText, false)
	GUI:setTag(RemainingText, -1)
	GUI:Text_enableOutline(RemainingText, "#000000", 1)
end
return ui