local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 142.00, 39.00, false)
	GUI:setChineseName(Panel_1, "系统合成_物品组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 39)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 71.00, 3.00, "res/private/compound_items_ui/1900000667.png")
	GUI:setContentSize(Image_bg, 142, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "系统合成_装饰条")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 41)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 71.00, 20.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "系统合成_物品名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 42)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Image_tag
	local Image_tag = GUI:Image_Create(Panel_1, "Image_tag", 71.00, 23.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_tag, 42, 42, 10, 10)
	GUI:setContentSize(Image_tag, 142, 32)
	GUI:setIgnoreContentAdaptWithSize(Image_tag, false)
	GUI:setChineseName(Image_tag, "系统合成_物品激活背景图")
	GUI:setAnchorPoint(Image_tag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag, false)
	GUI:setTag(Image_tag, 43)
	GUI:setVisible(Image_tag, false)

	-- Create Image_red
	local Image_red = GUI:Image_Create(Panel_1, "Image_red", 133.00, 28.00, "res/public/btn_npcfh_04.png")
	GUI:setChineseName(Image_red, "系统合成_物品红点")
	GUI:setAnchorPoint(Image_red, 0.50, 0.50)
	GUI:setTouchEnabled(Image_red, false)
	GUI:setTag(Image_red, 45)
	GUI:setVisible(Image_red, false)
end
return ui