local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 568.00, 320.00)
	GUI:setChineseName(Node, "物品框_节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 60.00, 60.00, false)
	GUI:setChineseName(Panel_bg, "物品框_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 21)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 30.00, 30.00, "res/private/item_tips/1900025001.png")
	GUI:setChineseName(Image_bg, "物品框_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 8)

	-- Create Node_sfx_under
	local Node_sfx_under = GUI:Node_Create(Panel_bg, "Node_sfx_under", 30.00, 30.00)
	GUI:setChineseName(Node_sfx_under, "物品框_特效层(分前后)")
	GUI:setAnchorPoint(Node_sfx_under, 0.50, 0.50)
	GUI:setTag(Node_sfx_under, 11)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 30.00, 30.00, "res/private/gui_edit/Button_Normal.png")
	GUI:setContentSize(Button_icon, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#414146")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleDisableOutLine(Button_icon)
	GUI:setChineseName(Button_icon, "物品框_图标")
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, false)
	GUI:setTag(Button_icon, 23)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 30.00, 30.00)
	GUI:setChineseName(Node_sfx, "物品框_特效节点")
	GUI:setAnchorPoint(Node_sfx, 0.50, 0.50)
	GUI:setTag(Node_sfx, 12)

	-- Create Node_lock
	local Node_lock = GUI:Node_Create(Panel_bg, "Node_lock", 30.00, 30.00)
	GUI:setChineseName(Node_lock, "物品框_锁节点")
	GUI:setAnchorPoint(Node_lock, 0.50, 0.50)
	GUI:setTag(Node_lock, 31)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_bg, "Text_count", 57.00, 11.00, 15, "#ffffff", [[1000]])
	GUI:setChineseName(Text_count, "物品框_数量_文本")
	GUI:setAnchorPoint(Text_count, 1.00, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 28)
	GUI:Text_enableOutline(Text_count, "#000000", 2)

	-- Create Text_star_lv
	local Text_star_lv = GUI:Text_Create(Panel_bg, "Text_star_lv", 4.00, 58.00, 18, "#efad21", [[0]])
	GUI:setChineseName(Text_star_lv, "物品框_强化等级_文本")
	GUI:setAnchorPoint(Text_star_lv, 0.00, 1.00)
	GUI:setTouchEnabled(Text_star_lv, false)
	GUI:setTag(Text_star_lv, 27)
	GUI:Text_enableOutline(Text_star_lv, "#111111", 1)

	-- Create Panel_extra
	local Panel_extra = GUI:Layout_Create(Panel_bg, "Panel_extra", 30.00, 30.00, 60.00, 60.00, false)
	GUI:setChineseName(Panel_extra, "物品框_挂接点")
	GUI:setAnchorPoint(Panel_extra, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_extra, false)
	GUI:setTag(Panel_extra, 6)

	-- Create Node_sfx_power
	local Node_sfx_power = GUI:Node_Create(Panel_bg, "Node_sfx_power", 30.00, 30.00)
	GUI:setChineseName(Node_sfx_power, "物品框_装备对比_特效节点")
	GUI:setAnchorPoint(Node_sfx_power, 0.50, 0.50)
	GUI:setTag(Node_sfx_power, 24)

	-- Create Image_power
	local Image_power = GUI:Image_Create(Panel_bg, "Image_power", 57.00, 34.00, "res/public/btn_szjm_01_3.png")
	GUI:setChineseName(Image_power, "物品框_装备对比_箭头图")
	GUI:setAnchorPoint(Image_power, 1.00, 0.00)
	GUI:setTouchEnabled(Image_power, false)
	GUI:setTag(Image_power, 7)

	-- Create Node_needNum
	local Node_needNum = GUI:Node_Create(Panel_bg, "Node_needNum", 60.00, 6.00)
	GUI:setChineseName(Node_needNum, "物品框_需求数量节点")
	GUI:setAnchorPoint(Node_needNum, 0.50, 0.50)
	GUI:setTag(Node_needNum, 10)

	-- Create Image_choosTag
	local Image_choosTag = GUI:Image_Create(Panel_bg, "Image_choosTag", 30.00, 30.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_choosTag, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_choosTag, false)
	GUI:setChineseName(Image_choosTag, "物品框_勾选图")
	GUI:setAnchorPoint(Image_choosTag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_choosTag, false)
	GUI:setTag(Image_choosTag, 13)
	GUI:setVisible(Image_choosTag, false)

	-- Create Node_left_top
	local Node_left_top = GUI:Node_Create(Panel_bg, "Node_left_top", 30.00, 30.00)
	GUI:setChineseName(Node_left_top, "物品框_挂接节点(红点等)")
	GUI:setAnchorPoint(Node_left_top, 0.50, 0.50)
	GUI:setTag(Node_left_top, 30)
end
return ui