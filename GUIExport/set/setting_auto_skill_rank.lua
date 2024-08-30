local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "挂机技能场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(Scene, "Panel_cancle", 569.00, 320.00, 3000.00, 3000.00, false)
	GUI:setChineseName(Panel_cancle, "挂机技能_范围点击关闭")
	GUI:setAnchorPoint(Panel_cancle, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 123)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 816.00, 325.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 110, 109, 142, 142)
	GUI:setContentSize(Panel_1, 335, 433)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setChineseName(Panel_1, "挂机技能_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 141)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_1, "Image_7", 167.00, 407.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_7, 33, 33, 9, 9)
	GUI:setContentSize(Image_7, 315, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_7, false)
	GUI:setChineseName(Image_7, "挂机技能_标题组合")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_7, "Text_1", 55.00, 13.00, 20, "#ffffff", [[优先级]])
	GUI:setChineseName(Text_1, "挂机技能_优先级_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Image_7, "Text_2", 200.00, 13.00, 20, "#ffffff", [[技能名称]])
	GUI:setChineseName(Text_2, "挂机技能_名称_文本")
	GUI:setAnchorPoint(Text_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, 240)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 12.00, 64.00, 312.00, 330.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:ListView_setItemsMargin(ListView_1, 1)
	GUI:setChineseName(ListView_1, "挂机技能_技能列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 224)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Panel_1, "Panel_touch", 10.00, 395.00, 315.00, 332.00, false)
	GUI:setChineseName(Panel_touch, "挂机技能_技能列表_触摸")
	GUI:setAnchorPoint(Panel_touch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 31)

	-- Create Button_add
	local Button_add = GUI:Button_Create(Panel_1, "Button_add", 78.00, 36.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_add, 16, 14, 12, 10)
	GUI:setContentSize(Button_add, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_add, false)
	GUI:Button_setTitleText(Button_add, "新增")
	GUI:Button_setTitleColor(Button_add, "#ffffff")
	GUI:Button_setTitleFontSize(Button_add, 18)
	GUI:Button_titleEnableOutline(Button_add, "#000000", 1)
	GUI:setChineseName(Button_add, "挂机技能_新增_按钮")
	GUI:setAnchorPoint(Button_add, 0.50, 0.50)
	GUI:setTouchEnabled(Button_add, true)
	GUI:setTag(Button_add, 126)

	-- Create Button_del
	local Button_del = GUI:Button_Create(Panel_1, "Button_del", 259.00, 36.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_del, 16, 14, 12, 10)
	GUI:setContentSize(Button_del, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_del, false)
	GUI:Button_setTitleText(Button_del, "删除")
	GUI:Button_setTitleColor(Button_del, "#ffffff")
	GUI:Button_setTitleFontSize(Button_del, 18)
	GUI:Button_titleEnableOutline(Button_del, "#000000", 1)
	GUI:setChineseName(Button_del, "挂机技能_删除_按钮")
	GUI:setAnchorPoint(Button_del, 0.50, 0.50)
	GUI:setTouchEnabled(Button_del, true)
	GUI:setTag(Button_del, 127)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 347.00, 412.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "挂机技能_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 408)
end
return ui