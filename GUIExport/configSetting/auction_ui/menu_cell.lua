local ui = {}
function ui.init(parent)
	-- Create page_cell
	local page_cell = GUI:Layout_Create(parent, "page_cell", 260.00, 330.00, 200.00, 65.00, false)
	GUI:Layout_setBackGroundColorType(page_cell, 1)
	GUI:Layout_setBackGroundColor(page_cell, "#000000")
	GUI:Layout_setBackGroundColorOpacity(page_cell, 140)
	GUI:setTouchEnabled(page_cell, true)
	GUI:setTag(page_cell, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell, "PageText", 100.00, 33.00, 16, "#ffffff", [[拍卖行配置]])
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_disableOutLine(PageText)
end
return ui