local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 0)
	GUI:setChineseName(CloseLayout, "技能设置_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(FrameLayout, "技能设置_组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "技能设置_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "技能设置_装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 486.00, 20, "#d8c8ae", [[]])
	GUI:setChineseName(TitleText, "技能设置_标题_文本")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 793.00, 498.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#f8e6c6")
	GUI:Button_setTitleFontSize(CloseButton, 18)
	GUI:Button_titleDisableOutLine(CloseButton)
	GUI:setChineseName(CloseButton, "技能设置_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.50, 0.50)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, 50)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(FrameLayout, "PMainUI", 396.00, 255.00, 732.00, 445.00, false)
	GUI:setChineseName(PMainUI, "技能设置详情_内容组合")
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 6)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 0.00, 0.00, "res/private/skill/bg_jnsz_01.jpg")
	GUI:setChineseName(Image_1, "技能设置详情_背景图")
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 10)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(PMainUI, "Image_3", 159.00, 429.00, "res/private/skill/word_jnsz_01.png")
	GUI:setChineseName(Image_3, "技能设置详情_描述图片")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 12)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(PMainUI, "Image_4", 312.00, 222.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_4, 2, 445)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setChineseName(Image_4, "技能设置详情_装饰条")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 15)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 517.00, 418.00, 16, "#28ef01", [[左侧选择，右侧放入，即可设置]])
	GUI:setChineseName(Text_1, "技能设置详情_描述文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 13)
	GUI:Text_enableOutline(Text_1, "#111111", 1)

	-- Create ScrollView_skills
	local ScrollView_skills = GUI:ScrollView_Create(PMainUI, "ScrollView_skills", 10.00, 415.00, 285.00, 410.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_skills, 285.00, 410.00)
	GUI:setChineseName(ScrollView_skills, "技能设置详情_技能列表")
	GUI:setAnchorPoint(ScrollView_skills, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_skills, true)
	GUI:setTag(ScrollView_skills, 14)

	-- Create Panel_shortcut
	local Panel_shortcut = GUI:Layout_Create(PMainUI, "Panel_shortcut", 523.00, 65.00, 350.00, 340.00, false)
	GUI:setChineseName(Panel_shortcut, "技能设置详情_快捷组合")
	GUI:setAnchorPoint(Panel_shortcut, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_shortcut, true)
	GUI:setTag(Panel_shortcut, 37)

	-- Create Image_skill_1
	local Image_skill_1 = GUI:Image_Create(Panel_shortcut, "Image_skill_1", 262.00, 80.00, "res/private/skill/1900012700.png")
	GUI:setChineseName(Image_skill_1, "技能设置详情_技能1")
	GUI:setAnchorPoint(Image_skill_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_1, false)
	GUI:setTag(Image_skill_1, 38)

	-- Create Image_skill_2
	local Image_skill_2 = GUI:Image_Create(Panel_shortcut, "Image_skill_2", 138.00, 53.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_2, "技能设置详情_技能2")
	GUI:setAnchorPoint(Image_skill_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_2, false)
	GUI:setTag(Image_skill_2, 39)

	-- Create Image_skill_3
	local Image_skill_3 = GUI:Image_Create(Panel_shortcut, "Image_skill_3", 158.00, 128.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_3, "技能设置详情_技能3")
	GUI:setAnchorPoint(Image_skill_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_3, false)
	GUI:setTag(Image_skill_3, 40)

	-- Create Image_skill_4
	local Image_skill_4 = GUI:Image_Create(Panel_shortcut, "Image_skill_4", 213.00, 183.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_4, "技能设置详情_技能4")
	GUI:setAnchorPoint(Image_skill_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_4, false)
	GUI:setTag(Image_skill_4, 41)

	-- Create Image_skill_5
	local Image_skill_5 = GUI:Image_Create(Panel_shortcut, "Image_skill_5", 288.00, 202.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_5, "技能设置详情_技能5")
	GUI:setAnchorPoint(Image_skill_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_5, false)
	GUI:setTag(Image_skill_5, 42)

	-- Create Image_skill_6
	local Image_skill_6 = GUI:Image_Create(Panel_shortcut, "Image_skill_6", 58.00, 96.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_6, "技能设置详情_技能6")
	GUI:setAnchorPoint(Image_skill_6, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_6, false)
	GUI:setTag(Image_skill_6, 43)

	-- Create Image_skill_7
	local Image_skill_7 = GUI:Image_Create(Panel_shortcut, "Image_skill_7", 81.00, 189.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_7, "技能设置详情_技能7")
	GUI:setAnchorPoint(Image_skill_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_7, false)
	GUI:setTag(Image_skill_7, 44)

	-- Create Image_skill_8
	local Image_skill_8 = GUI:Image_Create(Panel_shortcut, "Image_skill_8", 148.00, 251.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_8, "技能设置详情_技能8")
	GUI:setAnchorPoint(Image_skill_8, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_8, false)
	GUI:setTag(Image_skill_8, 45)

	-- Create Image_skill_9
	local Image_skill_9 = GUI:Image_Create(Panel_shortcut, "Image_skill_9", 238.00, 279.00, "res/private/skill/1900012702.png")
	GUI:setChineseName(Image_skill_9, "技能设置详情_技能9")
	GUI:setAnchorPoint(Image_skill_9, 0.50, 0.50)
	GUI:setTouchEnabled(Image_skill_9, false)
	GUI:setTag(Image_skill_9, 46)

	-- Create Button_restore_basic
	local Button_restore_basic = GUI:Button_Create(PMainUI, "Button_restore_basic", 420.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_restore_basic, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_restore_basic, 15, 17, 11, 18)
	GUI:setContentSize(Button_restore_basic, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_restore_basic, false)
	GUI:Button_setTitleText(Button_restore_basic, "还原普攻")
	GUI:Button_setTitleColor(Button_restore_basic, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_restore_basic, 18)
	GUI:Button_titleEnableOutline(Button_restore_basic, "#111111", 2)
	GUI:setChineseName(Button_restore_basic, "技能设置详情_还原_按钮")
	GUI:setAnchorPoint(Button_restore_basic, 0.50, 0.50)
	GUI:setTouchEnabled(Button_restore_basic, true)
	GUI:setTag(Button_restore_basic, 50)

	-- Create Button_cleanup
	local Button_cleanup = GUI:Button_Create(PMainUI, "Button_cleanup", 605.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_cleanup, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_cleanup, 15, 17, 11, 18)
	GUI:setContentSize(Button_cleanup, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_cleanup, false)
	GUI:Button_setTitleText(Button_cleanup, "键位重置")
	GUI:Button_setTitleColor(Button_cleanup, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_cleanup, 18)
	GUI:Button_titleEnableOutline(Button_cleanup, "#111111", 2)
	GUI:setChineseName(Button_cleanup, "技能设置详情_重置_按钮")
	GUI:setAnchorPoint(Button_cleanup, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cleanup, true)
	GUI:setTag(Button_cleanup, 22)
end
return ui