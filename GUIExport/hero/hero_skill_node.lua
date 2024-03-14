local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "技能配置节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setChineseName(Panel_1, "技能配置组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/player_skill/1900015001.png")
	GUI:setContentSize(Image_bg, 348, 478)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "技能配置_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 42)

	-- Create ListView_cells
	local ListView_cells = GUI:ListView_Create(Panel_1, "ListView_cells", 0.00, 58.00, 348.00, 420.00, 1)
	GUI:setChineseName(ListView_cells, "技能配置_技能列表")
	GUI:setTouchEnabled(ListView_cells, true)
	GUI:setTag(ListView_cells, 13)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_1, "Image_5", 174.00, -1.00, "res/public/bg_hhdb_01.jpg")
	GUI:setContentSize(Image_5, 348, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_5, false)
	GUI:setChineseName(Image_5, "技能配置_配置_背景图")
	GUI:setAnchorPoint(Image_5, 0.50, 0.00)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 16)

	-- Create Button_setting
	local Button_setting = GUI:Button_Create(Panel_1, "Button_setting", 174.00, 30.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_setting, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_setting, 15, 17, 11, 18)
	GUI:setContentSize(Button_setting, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_setting, false)
	GUI:Button_setTitleText(Button_setting, "技能配置")
	GUI:Button_setTitleColor(Button_setting, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_setting, 18)
	GUI:Button_titleEnableOutline(Button_setting, "#111111", 2)
	GUI:setChineseName(Button_setting, "技能配置_配置_按钮")
	GUI:setAnchorPoint(Button_setting, 0.50, 0.50)
	GUI:setTouchEnabled(Button_setting, true)
	GUI:setTag(Button_setting, 15)
end
return ui