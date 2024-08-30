local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 0.0)
	GUI:setChineseName(CloseLayout, "技能设置_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1.0)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 320.00, 790.00, 536.00, false)
	GUI:setChineseName(FrameLayout, "技能设置_组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1.0)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/public/1900000610.png")
	GUI:setChineseName(FrameBG, "技能设置_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1.0)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setChineseName(DressIMG, "技能设置_装饰图")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1.0)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 486.00, 20.0, "#d8c8ae", [[]])
	GUI:setChineseName(TitleText, "技能设置_标题_文本")
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1.0)
	GUI:Text_enableOutline(TitleText, "#000000", 1.0)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 793.00, 498.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#f8e6c6")
	GUI:Button_setTitleFontSize(CloseButton, 18.0)
	GUI:Button_titleDisableOutLine(CloseButton)
	GUI:setChineseName(CloseButton, "技能设置_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.50, 0.50)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, 50.0)

	-- Create SetUI
	local SetUI = GUI:Layout_Create(FrameLayout, "SetUI", 396.00, 255.00, 732.00, 445.00, false)
	GUI:setChineseName(SetUI, "技能设置详情_内容组合")
	GUI:setAnchorPoint(SetUI, 0.50, 0.50)
	GUI:setTouchEnabled(SetUI, true)
	GUI:setTag(SetUI, 6.0)

	-- Create pBg
	local pBg = GUI:Image_Create(SetUI, "pBg", 0.00, 0.00, "res/private/skill/bg_jnsz_01.jpg")
	GUI:setChineseName(pBg, "技能设置详情_背景图")
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, 10.0)

	-- Create Image_title
	local Image_title = GUI:Image_Create(SetUI, "Image_title", 159.00, 429.00, "res/private/skill/word_jnsz_01.png")
	GUI:setChineseName(Image_title, "技能设置详情_描述图片")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 12.0)

	-- Create line
	local line = GUI:Image_Create(SetUI, "line", 312.00, 222.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(line, 2.0, 445.0)
	GUI:setIgnoreContentAdaptWithSize(line, false)
	GUI:setChineseName(line, "技能设置详情_装饰条")
	GUI:setAnchorPoint(line, 0.50, 0.50)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, 15.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(SetUI, "Text_1", 517.00, 418.00, 16.0, "#28ef01", [[左侧选择，右侧放入，即可设置]])
	GUI:setChineseName(Text_1, "技能设置详情_描述文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 13.0)
	GUI:Text_enableOutline(Text_1, "#111111", 1.0)

	-- Create ScrollView_skills
	local ScrollView_skills = GUI:ScrollView_Create(SetUI, "ScrollView_skills", 10.00, 415.00, 285.00, 410.00, 1.0)
	GUI:ScrollView_setInnerContainerSize(ScrollView_skills, 285.00, 410.00)
	GUI:setChineseName(ScrollView_skills, "技能设置详情_技能列表")
	GUI:setAnchorPoint(ScrollView_skills, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_skills, true)
	GUI:setTag(ScrollView_skills, 14.0)

	-- Create ImageSkill_1
	local ImageSkill_1 = GUI:Image_Create(SetUI, "ImageSkill_1", 610.00, 145.00, "res/private/skill/1900012700.png")
	GUI:setAnchorPoint(ImageSkill_1, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_1, true)
	GUI:setTag(ImageSkill_1, 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_1, "iSkill", 5.00, 3.50, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 78, 78)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_2
	local ImageSkill_2 = GUI:Image_Create(SetUI, "ImageSkill_2", 486.00, 118.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_2, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_2, true)
	GUI:setTag(ImageSkill_2, 2)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_2, "labNum", 0.00, 55.00, 16, "#ffffff", [[1]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_2, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_3
	local ImageSkill_3 = GUI:Image_Create(SetUI, "ImageSkill_3", 506.00, 193.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_3, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_3, true)
	GUI:setTag(ImageSkill_3, 3)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_3, "labNum", 0.00, 55.00, 16, "#ffffff", [[2]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_3, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_4
	local ImageSkill_4 = GUI:Image_Create(SetUI, "ImageSkill_4", 562.00, 248.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_4, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_4, true)
	GUI:setTag(ImageSkill_4, 4)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_4, "labNum", 0.00, 55.00, 16, "#ffffff", [[3]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_4, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_5
	local ImageSkill_5 = GUI:Image_Create(SetUI, "ImageSkill_5", 637.00, 268.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_5, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_5, true)
	GUI:setTag(ImageSkill_5, 5)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_5, "labNum", 0.00, 55.00, 16, "#ffffff", [[4]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_5, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_6
	local ImageSkill_6 = GUI:Image_Create(SetUI, "ImageSkill_6", 406.00, 162.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_6, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_6, true)
	GUI:setTag(ImageSkill_6, 6)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_6, "labNum", 0.00, 55.00, 16, "#ffffff", [[5]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_6, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_7
	local ImageSkill_7 = GUI:Image_Create(SetUI, "ImageSkill_7", 429.00, 255.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_7, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_7, true)
	GUI:setTag(ImageSkill_7, 7)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_7, "labNum", 0.00, 55.00, 16, "#ffffff", [[6]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_7, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_8
	local ImageSkill_8 = GUI:Image_Create(SetUI, "ImageSkill_8", 496.00, 316.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_8, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_8, true)
	GUI:setTag(ImageSkill_8, 8)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_8, "labNum", 0.00, 55.00, 16, "#ffffff", [[7]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_8, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create ImageSkill_9
	local ImageSkill_9 = GUI:Image_Create(SetUI, "ImageSkill_9", 586.00, 345.00, "res/private/skill/1900012702.png")
	GUI:setAnchorPoint(ImageSkill_9, 0.50, 0.50)
	GUI:setTouchEnabled(ImageSkill_9, true)
	GUI:setTag(ImageSkill_9, 9)

	-- Create labNum
	local labNum = GUI:Text_Create(ImageSkill_9, "labNum", 0.00, 55.00, 16, "#ffffff", [[8]])
	GUI:setTouchEnabled(labNum, false)
	GUI:setTag(labNum, -1)
	GUI:Text_enableOutline(labNum, "#000000", 1)

	-- Create iSkill
	local iSkill = GUI:Image_Create(ImageSkill_9, "iSkill", 6.00, 6.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(iSkill, 53, 53)
	GUI:setIgnoreContentAdaptWithSize(iSkill, false)
	GUI:setTouchEnabled(iSkill, false)
	GUI:setTag(iSkill, -1)
	GUI:setVisible(iSkill, false)

	-- Create btnRestore
	local btnRestore = GUI:Button_Create(SetUI, "btnRestore", 420.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(btnRestore, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(btnRestore, 15, 17.0, 11, 18.0)
	GUI:setContentSize(btnRestore, 104.0, 33.0)
	GUI:setIgnoreContentAdaptWithSize(btnRestore, false)
	GUI:Button_setTitleText(btnRestore, "还原普攻")
	GUI:Button_setTitleColor(btnRestore, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnRestore, 18.0)
	GUI:Button_titleEnableOutline(btnRestore, "#111111", 2.0)
	GUI:setChineseName(btnRestore, "技能设置详情_还原_按钮")
	GUI:setAnchorPoint(btnRestore, 0.50, 0.50)
	GUI:setTouchEnabled(btnRestore, true)
	GUI:setTag(btnRestore, 50.0)

	-- Create btnReset
	local btnReset = GUI:Button_Create(SetUI, "btnReset", 605.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(btnReset, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(btnReset, 15, 17.0, 11, 18.0)
	GUI:setContentSize(btnReset, 104.0, 33.0)
	GUI:setIgnoreContentAdaptWithSize(btnReset, false)
	GUI:Button_setTitleText(btnReset, "键位重置")
	GUI:Button_setTitleColor(btnReset, "#f8e6c6")
	GUI:Button_setTitleFontSize(btnReset, 18.0)
	GUI:Button_titleEnableOutline(btnReset, "#111111", 2.0)
	GUI:setChineseName(btnReset, "技能设置详情_重置_按钮")
	GUI:setAnchorPoint(btnReset, 0.50, 0.50)
	GUI:setTouchEnabled(btnReset, true)
	GUI:setTag(btnReset, 22.0)
end
return ui