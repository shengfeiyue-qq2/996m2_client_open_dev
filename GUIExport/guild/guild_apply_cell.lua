local ui = {}
function ui.init(parent)
	-- Create ListCell
	local ListCell = GUI:Layout_Create(parent, "ListCell", 0.00, 0.00, 653.00, 50.00, true)
	GUI:setTouchEnabled(ListCell, false)
	GUI:setTag(ListCell, -1)

	-- Create line
	local line = GUI:Image_Create(ListCell, "line", 0.00, 1.00, "res/public/bg_yyxsz_01.png")
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create username
	local username = GUI:Text_Create(ListCell, "username", 77.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(username, 0.50, 0.50)
	GUI:setTouchEnabled(username, false)
	GUI:setTag(username, -1)
	GUI:Text_enableOutline(username, "#000000", 1)

	-- Create level
	local level = GUI:Text_Create(ListCell, "level", 250.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(level, 0.50, 0.50)
	GUI:setTouchEnabled(level, false)
	GUI:setTag(level, -1)
	GUI:Text_enableOutline(level, "#000000", 1)

	-- Create job
	local job = GUI:Text_Create(ListCell, "job", 387.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(job, 0.50, 0.50)
	GUI:setTouchEnabled(job, false)
	GUI:setTag(job, -1)
	GUI:Text_enableOutline(job, "#000000", 1)

	-- Create btnDisAgree
	local btnDisAgree = GUI:Button_Create(ListCell, "btnDisAgree", 500.00, 25.00, "res/public/1900000679.png")
	GUI:Button_setTitleText(btnDisAgree, "拒绝")
	GUI:Button_setTitleColor(btnDisAgree, "#f7f0e2")
	GUI:Button_setTitleFontSize(btnDisAgree, 16)
	GUI:Button_titleEnableOutline(btnDisAgree, "#000000", 1)
	GUI:setAnchorPoint(btnDisAgree, 0.50, 0.50)
	GUI:setTouchEnabled(btnDisAgree, true)
	GUI:setTag(btnDisAgree, -1)

	-- Create btnAgree
	local btnAgree = GUI:Button_Create(ListCell, "btnAgree", 600.00, 25.00, "res/public/1900000679.png")
	GUI:Button_setTitleText(btnAgree, "同意")
	GUI:Button_setTitleColor(btnAgree, "#f7f0e2")
	GUI:Button_setTitleFontSize(btnAgree, 16)
	GUI:Button_titleEnableOutline(btnAgree, "#000000", 1)
	GUI:setAnchorPoint(btnAgree, 0.50, 0.50)
	GUI:setTouchEnabled(btnAgree, true)
	GUI:setTag(btnAgree, -1)
end
return ui