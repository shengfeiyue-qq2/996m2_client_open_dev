local ui = {}
function ui.init(parent)
	-- Create Panel_cell_new
	local Panel_cell_new = GUI:Layout_Create(parent, "Panel_cell_new", 0.00, 0.00, 410.00, 30.00, false)
	GUI:setChineseName(Panel_cell_new, "属性点_加点分组")
	GUI:setTouchEnabled(Panel_cell_new, true)
	GUI:setTag(Panel_cell_new, 126)

	-- Create Text_title
	local Text_title = GUI:Text_Create(Panel_cell_new, "Text_title", 0.00, 15.00, 16, "#ffffff", [[-]])
	GUI:setChineseName(Text_title, "属性点_当前属性点数")
	GUI:setAnchorPoint(Text_title, 0.00, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 128)
	GUI:Text_enableOutline(Text_title, "#111111", 1)

	-- Create Text_data
	local Text_data = GUI:Text_Create(Panel_cell_new, "Text_data", 90.00, 15.00, 16, "#ffffff", [[-]])
	GUI:setChineseName(Text_data, "属性点_当前属性点数")
	GUI:setAnchorPoint(Text_data, 0.00, 0.50)
	GUI:setTouchEnabled(Text_data, false)
	GUI:setTag(Text_data, 128)
	GUI:Text_enableOutline(Text_data, "#111111", 1)

	-- Create btn_add
	local btn_add = GUI:Button_Create(Panel_cell_new, "btn_add", 215.00, 15.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(btn_add, "res/public/1900000621_1.png")
	GUI:Button_loadTextureDisabled(btn_add, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_add, 15, 13, 11, 9)
	GUI:setContentSize(btn_add, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(btn_add, false)
	GUI:Button_setTitleText(btn_add, "")
	GUI:Button_setTitleColor(btn_add, "#414146")
	GUI:Button_setTitleFontSize(btn_add, 14)
	GUI:Button_titleEnableOutline(btn_add, "#000000", 1)
	GUI:setChineseName(btn_add, "属性点_加属性点_按钮")
	GUI:setAnchorPoint(btn_add, 0.50, 0.50)
	GUI:setTouchEnabled(btn_add, true)
	GUI:setTag(btn_add, 129)

	-- Create btn_sub
	local btn_sub = GUI:Button_Create(Panel_cell_new, "btn_sub", 245.00, 15.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(btn_sub, "res/public/1900000620_1.png")
	GUI:Button_loadTextureDisabled(btn_sub, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_sub, 15, 13, 11, 9)
	GUI:setContentSize(btn_sub, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(btn_sub, false)
	GUI:Button_setTitleText(btn_sub, "")
	GUI:Button_setTitleColor(btn_sub, "#414146")
	GUI:Button_setTitleFontSize(btn_sub, 14)
	GUI:Button_titleEnableOutline(btn_sub, "#000000", 1)
	GUI:setChineseName(btn_sub, "属性点_减属性点_按钮")
	GUI:setAnchorPoint(btn_sub, 0.50, 0.50)
	GUI:setTouchEnabled(btn_sub, true)
	GUI:setTag(btn_sub, 130)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_cell_new, "Image_bg", 264.00, 15.00, "res/public/1900015004.png")
	GUI:setContentSize(Image_bg, 128, 30)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "属性点_属性点_背景框")
	GUI:setAnchorPoint(Image_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 135)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_cell_new, "Text_num", 273.00, 15.00, 16, "#ffffff", [[1/20]])
	GUI:setChineseName(Text_num, "属性点_加点_数量规则")
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 131)
	GUI:Text_enableOutline(Text_num, "#111111", 1)
end
return ui