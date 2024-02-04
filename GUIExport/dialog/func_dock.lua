local ui = {}
function ui.init(parent)
	-- Create TouchPanel
	local TouchPanel = GUI:Layout_Create(parent, "TouchPanel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(TouchPanel, true)
	GUI:setTag(TouchPanel, -1)

	-- Create BgImg
	local BgImg = GUI:Image_Create(parent, "BgImg", 0.00, 0.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(BgImg, 21, 21, 33, 33)
	GUI:setContentSize(BgImg, 85, 100)
	GUI:setIgnoreContentAdaptWithSize(BgImg, false)
	GUI:setTouchEnabled(BgImg, false)
	GUI:setTag(BgImg, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(BgImg, "ListView", 0.00, 0.00, 85.00, 100.00, 1)
	GUI:ListView_setGravity(ListView, 2)
	GUI:ListView_setItemsMargin(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 0.00, 0.00, 85.00, 30.00, false)
	GUI:setTouchEnabled(Cell, true)
	GUI:setTag(Cell, -1)

	-- Create Name
	local Name = GUI:Text_Create(Cell, "Name", 42.00, 15.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Name, 0.50, 0.50)
	GUI:setTouchEnabled(Name, false)
	GUI:setTag(Name, -1)
	GUI:Text_enableOutline(Name, "#111111", 1)
end
return ui