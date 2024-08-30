local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 160.00, 32.00, false)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 254)

	-- Create Image_sel
	local Image_sel = GUI:Image_Create(Panel_1, "Image_sel", 80.00, 16.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_sel, 43, 43, 11, 10)
	GUI:setContentSize(Image_sel, 160, 26)
	GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
	GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_sel, false)
	GUI:setTag(Image_sel, 255)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 80.00, 16.00, 12, "#ffffff", [[物品名]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 257)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui