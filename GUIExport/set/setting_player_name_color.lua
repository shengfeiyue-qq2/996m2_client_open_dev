local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 568.00, 320.00, 3000.00, 3000.00, false)
	GUI:setAnchorPoint(Panel_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 82)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 602.00, 320.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 112, 111, 144, 145)
	GUI:setContentSize(Panel_1, 460, 433)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 141)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_1, "Image_7", 237.00, 407.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_7, 33, 33, 9, 9)
	GUI:setContentSize(Image_7, 315, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_7, false)
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_7, "Text_1", 158.00, 14.00, 20, "#ffffff", [[附近玩家]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 12.00, 57.00, 440.00, 334.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 224)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 472.00, 412.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 383)

	-- Create Button_sure
	local Button_sure = GUI:Button_Create(Panel_1, "Button_sure", 183.00, 10.00, "res/public/1900000660.png")
	GUI:Button_setTitleText(Button_sure, "保 存")
	GUI:Button_setTitleColor(Button_sure, "#ffffff")
	GUI:Button_setTitleFontSize(Button_sure, 16)
	GUI:Button_titleEnableOutline(Button_sure, "#000000", 1)
	GUI:setTouchEnabled(Button_sure, true)
	GUI:setTag(Button_sure, -1)
end
return ui