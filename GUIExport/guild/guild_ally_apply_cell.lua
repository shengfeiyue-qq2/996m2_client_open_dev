local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 653.00, 50.00, true)
	GUI:setTouchEnabled(Panel_cell, false)
	GUI:setTag(Panel_cell, -1)

	-- Create line
	local line = GUI:Image_Create(Panel_cell, "line", 0.00, 1.00, "res/public/bg_yyxsz_01.png")
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create Node_tips
	local Node_tips = GUI:Node_Create(Panel_cell, "Node_tips", 15.00, 25.00)
	GUI:setAnchorPoint(Node_tips, 0.00, 0.50)
	GUI:setTag(Node_tips, -1)

	-- Create btnDisAgree
	local btnDisAgree = GUI:Button_Create(Panel_cell, "btnDisAgree", 500.00, 25.00, "res/public/1900000679.png")
	GUI:Button_setTitleText(btnDisAgree, "拒绝")
	GUI:Button_setTitleColor(btnDisAgree, "#f7f0e2")
	GUI:Button_setTitleFontSize(btnDisAgree, 16)
	GUI:Button_titleEnableOutline(btnDisAgree, "#000000", 1)
	GUI:setAnchorPoint(btnDisAgree, 0.50, 0.50)
	GUI:setTouchEnabled(btnDisAgree, true)
	GUI:setTag(btnDisAgree, -1)

	-- Create btnAgree
	local btnAgree = GUI:Button_Create(Panel_cell, "btnAgree", 600.00, 25.00, "res/public/1900000679.png")
	GUI:Button_setTitleText(btnAgree, "同意")
	GUI:Button_setTitleColor(btnAgree, "#f7f0e2")
	GUI:Button_setTitleFontSize(btnAgree, 16)
	GUI:Button_titleEnableOutline(btnAgree, "#000000", 1)
	GUI:setAnchorPoint(btnAgree, 0.50, 0.50)
	GUI:setTouchEnabled(btnAgree, true)
	GUI:setTag(btnAgree, -1)
end
return ui