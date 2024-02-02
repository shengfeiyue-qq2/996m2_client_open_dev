local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 300.00, 300.00, 125.00, 42.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 254)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 62.50, 21.00, "res/public/1900000678.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 255)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 20.00, 21.00, "res/public/btn_szjm_01_5.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 256)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 62.50, 21.00, 16, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 257)
	GUI:Text_enableOutline(Text_name, "#111111", 1)
end
return ui