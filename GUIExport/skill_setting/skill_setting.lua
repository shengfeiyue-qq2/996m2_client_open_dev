local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1700.00, 768.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 850.00, 384.00, 790.00, 536.00, false)
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, false)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/public/1900000610.png")
	GUI:setTouchEnabled(FrameBG, true)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14.00, 474.00, "res/public/1900000610_1.png")
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 32.00, 498.00, 18, "#ffffff", [[技能配置]])
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780.00, 492.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create SetUI
	local SetUI = GUI:Layout_Create(FrameLayout, "SetUI", 30.00, 40.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(SetUI, true)
	GUI:setTag(SetUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(SetUI, "pBg", 0.00, 0.00, "res/private/skill/bg_jnsz_01.jpg")
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create Image_title
	local Image_title = GUI:Image_Create(SetUI, "Image_title", 160.00, 430.00, "res/private/skill/word_jnsz_01.png")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, -1)

	-- Create line
	local line = GUI:Image_Create(SetUI, "line", 311.00, 0.00, "res/private/skill/word_jnsz_01.png")
	GUI:setContentSize(line, 2, 445)
	GUI:setIgnoreContentAdaptWithSize(line, false)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(SetUI, "Text_1", 518.00, 418.00, 16, "#ffffff", [[左侧选择，右侧放入，即可设置]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create ScrollView_skills
	local ScrollView_skills = GUI:ScrollView_Create(SetUI, "ScrollView_skills", 10.00, 5.00, 285.00, 410.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_skills, 285.00, 410.00)
	GUI:setTouchEnabled(ScrollView_skills, true)
	GUI:setTag(ScrollView_skills, -1)

	-- Create btnRestore
	local btnRestore = GUI:Button_Create(SetUI, "btnRestore", 420.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(btnRestore, "res/public/1900000680_1.png")
	GUI:Button_setTitleText(btnRestore, "还原普攻")
	GUI:Button_setTitleColor(btnRestore, "#ffffff")
	GUI:Button_setTitleFontSize(btnRestore, 16)
	GUI:Button_titleEnableOutline(btnRestore, "#000000", 1)
	GUI:setAnchorPoint(btnRestore, 0.50, 0.50)
	GUI:setTouchEnabled(btnRestore, true)
	GUI:setTag(btnRestore, -1)

	-- Create btnReset
	local btnReset = GUI:Button_Create(SetUI, "btnReset", 600.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(btnReset, "res/public/1900000680_1.png")
	GUI:Button_setTitleText(btnReset, "键位重置")
	GUI:Button_setTitleColor(btnReset, "#ffffff")
	GUI:Button_setTitleFontSize(btnReset, 16)
	GUI:Button_titleEnableOutline(btnReset, "#000000", 1)
	GUI:setAnchorPoint(btnReset, 0.50, 0.50)
	GUI:setTouchEnabled(btnReset, true)
	GUI:setTag(btnReset, -1)

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
end
return ui