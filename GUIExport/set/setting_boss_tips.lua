local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "BOSS提示场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(Scene, "Panel_cancle", 0.00, 0.00, 3000.00, 3000.00, false)
	GUI:Layout_setBackGroundColorType(Panel_cancle, 1)
	GUI:Layout_setBackGroundColor(Panel_cancle, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cancle, 73)
	GUI:setChineseName(Panel_cancle, "BOSS提示_范围点击关闭")
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 68)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 568.00, 320.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 110, 109, 142, 142)
	GUI:setContentSize(Panel_1, 752, 467)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setChineseName(Panel_1, "BOSS提示_背景图")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 141)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 765.00, 446.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "BOSS提示_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 56)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 376.00, 481.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_title, 33, 33, 9, 9)
	GUI:setContentSize(Image_title, 136, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_title, false)
	GUI:setChineseName(Image_title, "BOSS提示_标题组合")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_title, "Text_1", 68.00, 14.00, 20, "#ffffff", [[怪物提示列表]])
	GUI:setChineseName(Text_1, "BOSS提示_标题_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 11.00, 11.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_2, "BOSS提示组合")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 296)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 99.00, 432.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 102, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "BOSS提示_名称组合")
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 297)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_1, "Text_1", 50.00, 14.00, 18, "#ffffff", [[BOSS名称]])
	GUI:setChineseName(Text_1, "BOSS提示_名称_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 298)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_1_0
	local Image_1_0 = GUI:Image_Create(Panel_2, "Image_1_0", 363.00, 432.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1_0, 33, 33, 9, 9)
	GUI:setContentSize(Image_1_0, 102, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0, false)
	GUI:setChineseName(Image_1_0, "BOSS提示_提醒组合")
	GUI:setAnchorPoint(Image_1_0, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_0, false)
	GUI:setTag(Image_1_0, 299)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_1_0, "Text_1", 50.00, 14.00, 18, "#ffffff", [[提醒]])
	GUI:setChineseName(Text_1, "BOSS提示_提醒_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 300)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_1_0_0
	local Image_1_0_0 = GUI:Image_Create(Panel_2, "Image_1_0_0", 588.00, 432.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1_0_0, 33, 33, 9, 9)
	GUI:setContentSize(Image_1_0_0, 102, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_1_0_0, false)
	GUI:setChineseName(Image_1_0_0, "BOSS提示_类别组合")
	GUI:setAnchorPoint(Image_1_0_0, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1_0_0, false)
	GUI:setTag(Image_1_0_0, 301)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_1_0_0, "Text_1", 50.00, 14.00, 18, "#ffffff", [[类别]])
	GUI:setChineseName(Text_1, "BOSS提示_类别_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 302)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_2, "Image_4", 24.00, 400.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_4, 33, 33, 9, 9)
	GUI:setContentSize(Image_4, 685, 320)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setChineseName(Image_4, "BOSS提示_BOSS列表组合")
	GUI:setAnchorPoint(Image_4, 0.00, 1.00)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 303)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_4, "ListView_1", 0.00, 320.00, 685.00, 320.00, 1)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setChineseName(ListView_1, "BOSS提示_添加数据列表")
	GUI:setAnchorPoint(ListView_1, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 304)

	-- Create Button_addMonster
	local Button_addMonster = GUI:Button_Create(Panel_2, "Button_addMonster", 106.00, 36.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_addMonster, 16, 14, 12, 10)
	GUI:setContentSize(Button_addMonster, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_addMonster, false)
	GUI:Button_setTitleText(Button_addMonster, "新增怪物")
	GUI:Button_setTitleColor(Button_addMonster, "#ffffff")
	GUI:Button_setTitleFontSize(Button_addMonster, 18)
	GUI:Button_titleEnableOutline(Button_addMonster, "#000000", 1)
	GUI:setChineseName(Button_addMonster, "BOSS提示_添加怪物_按钮")
	GUI:setAnchorPoint(Button_addMonster, 0.50, 0.50)
	GUI:setTouchEnabled(Button_addMonster, true)
	GUI:setTag(Button_addMonster, 305)

	-- Create Button_addType
	local Button_addType = GUI:Button_Create(Panel_2, "Button_addType", 359.00, 36.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_addType, 33, 34, 12, 11)
	GUI:setContentSize(Button_addType, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_addType, false)
	GUI:Button_setTitleText(Button_addType, "新增类别")
	GUI:Button_setTitleColor(Button_addType, "#ffffff")
	GUI:Button_setTitleFontSize(Button_addType, 18)
	GUI:Button_titleEnableOutline(Button_addType, "#000000", 1)
	GUI:setChineseName(Button_addType, "BOSS提示_添加类别_按钮")
	GUI:setAnchorPoint(Button_addType, 0.50, 0.50)
	GUI:setTouchEnabled(Button_addType, true)
	GUI:setTag(Button_addType, 306)

	-- Create Button_del
	local Button_del = GUI:Button_Create(Panel_2, "Button_del", 612.00, 36.00, "res/private/new_setting/btnbg.png")
	GUI:Button_setScale9Slice(Button_del, 16, 14, 12, 10)
	GUI:setContentSize(Button_del, 100, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_del, false)
	GUI:Button_setTitleText(Button_del, "删除")
	GUI:Button_setTitleColor(Button_del, "#ffffff")
	GUI:Button_setTitleFontSize(Button_del, 18)
	GUI:Button_titleEnableOutline(Button_del, "#000000", 1)
	GUI:setChineseName(Button_del, "BOSS提示_删除_按钮")
	GUI:setAnchorPoint(Button_del, 0.50, 0.50)
	GUI:setTouchEnabled(Button_del, true)
	GUI:setTag(Button_del, 307)
end
return ui