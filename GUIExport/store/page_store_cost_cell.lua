local ui = {}
function ui.init(parent)
	-- Create Panel_costcell
	local Panel_costcell = GUI:Layout_Create(parent, "Panel_costcell", 5.00, 10.00, 200.00, 42.00, false)
	GUI:setChineseName(Panel_costcell, "商店货币展示组合")
	GUI:setTouchEnabled(Panel_costcell, true)
	GUI:setTag(Panel_costcell, 50)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_costcell, "Image_bg", 115.00, 21.00, "res/public/1900000668.png")
	GUI:setChineseName(Image_bg, "商店货币展示_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 24)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_costcell, "Text_num", 46.00, 21.00, 18, "#ffffff", [[]])
	GUI:setChineseName(Text_num, "商店货币展示_当前数量")
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 23)
	GUI:Text_enableOutline(Text_num, "#000000", 1)

	-- Create Panel_icon
	local Panel_icon = GUI:Layout_Create(Panel_costcell, "Panel_icon", 20.00, 22.00, 0.00, 0.00, false)
	GUI:setChineseName(Panel_icon, "商店货币展示_图标")
	GUI:setTouchEnabled(Panel_icon, true)
	GUI:setTag(Panel_icon, 52)
end
return ui