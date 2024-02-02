local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 568.00, 320.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 32.00, 32.00, false)
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 12)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 16.00, 16.00, "res/public/1900000651.png")
	GUI:setContentSize(Image_bg, 32, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 13)

	-- Create Node_sfx_under
	local Node_sfx_under = GUI:Node_Create(Panel_bg, "Node_sfx_under", 16.00, 16.00)
	GUI:setAnchorPoint(Node_sfx_under, 0.50, 0.50)
	GUI:setTag(Node_sfx_under, 22)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 16.00, 16.00, "res/private/gui_edit/Button_Normal.png")
	GUI:setContentSize(Button_icon, 25, 25)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#414146")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleDisableOutLine(Button_icon)
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, false)
	GUI:setTag(Button_icon, 15)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 16.00, 16.00)
	GUI:setAnchorPoint(Node_sfx, 0.50, 0.50)
	GUI:setTag(Node_sfx, 16)

	-- Create Node_lock
	local Node_lock = GUI:Node_Create(Panel_bg, "Node_lock", 16.00, 16.00)
	GUI:setAnchorPoint(Node_lock, 0.50, 0.50)
	GUI:setTag(Node_lock, 32)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_bg, "Text_count", 30.00, 7.00, 13, "#ffffff", [[1]])
	GUI:setAnchorPoint(Text_count, 1.00, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 17)
	GUI:Text_enableOutline(Text_count, "#000000", 2)

	-- Create Text_star_lv
	local Text_star_lv = GUI:Text_Create(Panel_bg, "Text_star_lv", 0.00, 32.00, 18, "#efad21", [[0]])
	GUI:setAnchorPoint(Text_star_lv, 0.00, 1.00)
	GUI:setTouchEnabled(Text_star_lv, false)
	GUI:setTag(Text_star_lv, 28)
	GUI:Text_enableOutline(Text_star_lv, "#111111", 1)

	-- Create Panel_extra
	local Panel_extra = GUI:Layout_Create(Panel_bg, "Panel_extra", 16.00, 16.00, 32.00, 32.00, false)
	GUI:setAnchorPoint(Panel_extra, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_extra, false)
	GUI:setTag(Panel_extra, 18)

	-- Create Node_sfx_power
	local Node_sfx_power = GUI:Node_Create(Panel_bg, "Node_sfx_power", 16.00, 16.00)
	GUI:setAnchorPoint(Node_sfx_power, 0.50, 0.50)
	GUI:setTag(Node_sfx_power, 25)

	-- Create Image_power
	local Image_power = GUI:Image_Create(Panel_bg, "Image_power", 30.00, 20.00, "res/public/btn_szjm_01_3.png")
	GUI:setAnchorPoint(Image_power, 1.00, 0.50)
	GUI:setTouchEnabled(Image_power, false)
	GUI:setTag(Image_power, 19)

	-- Create Node_needNum
	local Node_needNum = GUI:Node_Create(Panel_bg, "Node_needNum", 34.00, 2.00)
	GUI:setAnchorPoint(Node_needNum, 0.50, 0.50)
	GUI:setTag(Node_needNum, 20)

	-- Create Image_choosTag
	local Image_choosTag = GUI:Image_Create(Panel_bg, "Image_choosTag", 16.00, 16.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_choosTag, 32, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_choosTag, false)
	GUI:setAnchorPoint(Image_choosTag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_choosTag, false)
	GUI:setTag(Image_choosTag, 26)
	GUI:setVisible(Image_choosTag, false)

	-- Create Node_left_top
	local Node_left_top = GUI:Node_Create(Panel_bg, "Node_left_top", 16.00, 16.00)
	GUI:setAnchorPoint(Node_left_top, 0.50, 0.50)
	GUI:setTag(Node_left_top, 29)
end
return ui