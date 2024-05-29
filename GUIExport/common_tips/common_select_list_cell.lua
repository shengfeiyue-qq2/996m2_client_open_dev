local ui = {}
function ui.init(parent)
	-- Create Image_cell
	local Image_cell = GUI:Image_Create(parent, "Image_cell", 0.00, 0.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_cell, 33, 33, 8, 8)
	GUI:setContentSize(Image_cell, 260, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_cell, false)
	GUI:setChineseName(Image_cell, "通用列表层")
	GUI:setTouchEnabled(Image_cell, true)
	GUI:setTag(Image_cell, 443)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Image_cell, "Image_icon", 14.00, 14.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_icon, 25, 25)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "通用列表_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 19)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Image_cell, "Text_desc", 130.00, 14.00, 18, "#ffffff", [[保护设置]])
	GUI:setChineseName(Text_desc, "通用列表_标题")
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, false)
	GUI:setTag(Text_desc, 440)
	GUI:Text_enableOutline(Text_desc, "#000000", 1)
end
return ui