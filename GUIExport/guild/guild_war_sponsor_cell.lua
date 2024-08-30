local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 115.00, 35.00, false)
	GUI:setChineseName(Panel_cell, "行会_分类组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, -1)

	-- Create ImageSel
	local ImageSel = GUI:Image_Create(Panel_cell, "ImageSel", 0.00, 0.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(ImageSel, 20, 34, 5, 2)
	GUI:setContentSize(ImageSel, 115, 35)
	GUI:setIgnoreContentAdaptWithSize(ImageSel, false)
	GUI:setChineseName(ImageSel, "行会_分类_背景图")
	GUI:setTouchEnabled(ImageSel, false)
	GUI:setTag(ImageSel, -1)

	-- Create Text
	local Text = GUI:Text_Create(Panel_cell, "Text", 57.00, 17.00, 16, "#f7f0e2", [[]])
	GUI:setChineseName(Text, "行会_分类类型_文本")
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui