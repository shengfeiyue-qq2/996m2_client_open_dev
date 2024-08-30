local ui = {}
function ui.init(parent)
	-- Create Collect_cell
	local Collect_cell = GUI:Layout_Create(parent, "Collect_cell", 0.00, 0.00, 200.00, 40.00, false)
	GUI:setTouchEnabled(Collect_cell, true)
	GUI:setTag(Collect_cell, -1.0)
	GUI:setVisible(Collect_cell, false)

	-- Create Image_Icon
	local Image_Icon = GUI:Image_Create(Collect_cell, "Image_Icon", 10.00, 20.00, "res/private/main/Target/1900012536.png")
	GUI:setAnchorPoint(Image_Icon, 0.00, 0.50)
	GUI:setTouchEnabled(Image_Icon, false)
	GUI:setTag(Image_Icon, -1.0)

	-- Create Image_Name_Bg
	local Image_Name_Bg = GUI:Image_Create(Collect_cell, "Image_Name_Bg", 50.00, 20.00, "res/private/main/Target/1900012531.png")
	GUI:setAnchorPoint(Image_Name_Bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_Name_Bg, false)
	GUI:setTag(Image_Name_Bg, -1.0)

	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Collect_cell, "Text_Name", 116.00, 20.00, 15.0, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, -1.0)
	GUI:Text_enableOutline(Text_Name, "#000000", 1.0)
end
return ui