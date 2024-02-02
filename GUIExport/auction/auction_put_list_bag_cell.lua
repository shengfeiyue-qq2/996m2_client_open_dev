local ui = {}
function ui.init(parent)
	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0.00, 0.00, 67.50, 67.50, false)
	GUI:setChineseName(Panel_bg, "竞拍_物品框组合框")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 27)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 33.00, 33.00, "res/public/1900000651.png")
	GUI:setChineseName(Image_bg, "竞拍_物品框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 28)
end
return ui