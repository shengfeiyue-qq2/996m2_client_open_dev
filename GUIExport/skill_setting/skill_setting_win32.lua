local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "技能快捷键设置场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1.0)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_2, "快捷键设置_范围点击关闭")
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 16.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 537.00, 257.00, false)
	GUI:setChineseName(Panel_1, "快捷键设置组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 2.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 268.00, 128.00, "res/private/player_skill-win32/bg_jinengd_01.png")
	GUI:setChineseName(Image_bg, "快捷键设置_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 3.0)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 155.00, 180.00)
	GUI:setChineseName(Node_1, "快捷键设置_技能节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 15.0)

	-- Create Text_skillName
	local Text_skillName = GUI:Text_Create(Panel_1, "Text_skillName", 190.00, 180.00, 12.0, "#ffffff", [[-]])
	GUI:setChineseName(Text_skillName, "快捷键设置_技能名称_文本")
	GUI:setAnchorPoint(Text_skillName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_skillName, false)
	GUI:setTag(Text_skillName, 16.0)
	GUI:Text_enableOutline(Text_skillName, "#111111", 1.0)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(Panel_1, "Button_ok", 415.00, 80.00, "res/private/player_skill-win32/btn_jnan_2.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/private/player_skill-win32/btn_jnan_2_2.png")
	GUI:Button_setScale9Slice(Button_ok, 15, 15.0, 11, 11.0)
	GUI:setContentSize(Button_ok, 53.0, 32.0)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "")
	GUI:Button_setTitleColor(Button_ok, "#414146")
	GUI:Button_setTitleFontSize(Button_ok, 14.0)
	GUI:Button_titleDisableOutLine(Button_ok)
	GUI:setChineseName(Button_ok, "快捷键设置_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 4.0)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Button_ok, "Image_2", 26.00, 16.00, "res/private/player_skill-win32/word_lizi_18.png")
	GUI:setChineseName(Image_2, "快捷键设置_OK_图片")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 33.0)

	-- Create Button_clear
	local Button_clear = GUI:Button_Create(Panel_1, "Button_clear", 415.00, 130.00, "res/private/player_skill-win32/btn_jnan_2_1.png")
	GUI:Button_loadTexturePressed(Button_clear, "res/private/player_skill-win32/btn_jnan_2_2.png")
	GUI:Button_setScale9Slice(Button_clear, 15, 15.0, 4, 4.0)
	GUI:setContentSize(Button_clear, 53.0, 32.0)
	GUI:setIgnoreContentAdaptWithSize(Button_clear, false)
	GUI:Button_setTitleText(Button_clear, "")
	GUI:Button_setTitleColor(Button_clear, "#414146")
	GUI:Button_setTitleFontSize(Button_clear, 14.0)
	GUI:Button_titleDisableOutLine(Button_clear)
	GUI:setChineseName(Button_clear, "快捷键设置_清除_按钮")
	GUI:setAnchorPoint(Button_clear, 0.50, 0.50)
	GUI:setTouchEnabled(Button_clear, true)
	GUI:setTag(Button_clear, 0.0)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Button_clear, "Image_3", 26.00, 16.00, "res/private/player_skill-win32/word_lizi_17.png")
	GUI:setChineseName(Image_3, "快捷键设置_None_图片")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 43.0)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_1, "ListView_1", 105.00, 130.00, 280.00, 35.00, 2.0)
	GUI:ListView_setGravity(ListView_1, 3.0)
	GUI:setChineseName(ListView_1, "快捷键设置_快捷键_列表")
	GUI:setAnchorPoint(ListView_1, 0.00, 0.50)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 34.0)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_1, "ListView_2", 105.00, 80.00, 280.00, 35.00, 2.0)
	GUI:ListView_setGravity(ListView_2, 3.0)
	GUI:setChineseName(ListView_2, "快捷键设置_快捷键_列表")
	GUI:setAnchorPoint(ListView_2, 0.00, 0.50)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 38.0)
end
return ui