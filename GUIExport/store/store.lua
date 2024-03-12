local ui = {}
function ui.init(parent)
	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, -1)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(PMainUI, "Image_5", 366.00, 32.00, "res/private/store_ui/bg_scbtt_01.jpg")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(PMainUI, "ListView", 1.00, 63.00, 730.00, 377.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create ListViewCost
	local ListViewCost = GUI:ListView_Create(PMainUI, "ListViewCost", 4.00, 11.00, 600.00, 42.00, 1)
	GUI:ListView_setGravity(ListViewCost, 5)
	GUI:setTouchEnabled(ListViewCost, true)
	GUI:setTag(ListViewCost, -1)

	-- Create CostCell
	local CostCell = GUI:Layout_Create(PMainUI, "CostCell", 0.00, 0.00, 200.00, 42.00, true)
	GUI:setTouchEnabled(CostCell, true)
	GUI:setTag(CostCell, -1)
	GUI:setVisible(CostCell, false)

	-- Create pIcon
	local pIcon = GUI:Layout_Create(CostCell, "pIcon", 20.00, 21.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(pIcon, 0.50, 0.50)
	GUI:setTouchEnabled(pIcon, false)
	GUI:setTag(pIcon, -1)

	-- Create cBg
	local cBg = GUI:Image_Create(CostCell, "cBg", 115.00, 21.00, "res/public/1900000668.png")
	GUI:setAnchorPoint(cBg, 0.50, 0.50)
	GUI:setTouchEnabled(cBg, false)
	GUI:setTag(cBg, -1)

	-- Create Text_num
	local Text_num = GUI:Text_Create(CostCell, "Text_num", 45.00, 21.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, -1)
	GUI:Text_enableOutline(Text_num, "#000000", 1)
end
return ui