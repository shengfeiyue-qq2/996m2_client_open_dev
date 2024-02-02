local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "附近怪物场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(Scene, "Panel_cancle", 568.00, 320.00, 3000.00, 3000.00, false)
	GUI:setChineseName(Panel_cancle, "附近怪物_范围点击关闭")
	GUI:setAnchorPoint(Panel_cancle, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 82)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 304.00, 320.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 110, 109, 142, 142)
	GUI:setContentSize(Panel_1, 335, 433)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setChineseName(Panel_1, "附近怪物组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 141)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_1, "Image_7", 167.00, 407.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_7, 33, 33, 9, 9)
	GUI:setContentSize(Image_7, 315, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_7, false)
	GUI:setChineseName(Image_7, "附近怪物_标题组合")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_7, "Text_1", 158.00, 14.00, 20, "#ffffff", [[附近怪物名称]])
	GUI:setChineseName(Text_1, "附近怪物_标题_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 12.00, 57.00, 312.00, 334.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setChineseName(ListView_1, "附近怪物_怪物列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 224)

	-- Create Image_10
	local Image_10 = GUI:Image_Create(Panel_1, "Image_10", 14.00, 34.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_10, 34, 34, 10, 8)
	GUI:setContentSize(Image_10, 166, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_10, false)
	GUI:setChineseName(Image_10, "附近怪物_输入框")
	GUI:setAnchorPoint(Image_10, 0.00, 0.50)
	GUI:setTouchEnabled(Image_10, false)
	GUI:setTag(Image_10, 409)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 347.00, 411.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "附近怪物_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 383)

	-- Create Button_addMonster
	local Button_addMonster = GUI:Button_Create(Panel_1, "Button_addMonster", 267.00, 33.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_addMonster, 16, 14, 12, 10)
	GUI:setContentSize(Button_addMonster, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_addMonster, false)
	GUI:Button_setTitleText(Button_addMonster, "新增")
	GUI:Button_setTitleColor(Button_addMonster, "#ffffff")
	GUI:Button_setTitleFontSize(Button_addMonster, 18)
	GUI:Button_titleEnableOutline(Button_addMonster, "#000000", 1)
	GUI:setChineseName(Button_addMonster, "附近怪物_新增怪物_按钮")
	GUI:setAnchorPoint(Button_addMonster, 0.50, 0.50)
	GUI:setTouchEnabled(Button_addMonster, true)
	GUI:setTag(Button_addMonster, 242)
end
return ui