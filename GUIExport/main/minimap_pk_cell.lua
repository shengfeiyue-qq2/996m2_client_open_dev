local ui = {}
function ui.init(parent)
	-- Create PKModelListViewCell
	local PKModelListViewCell = GUI:Layout_Create(parent, "PKModelListViewCell", 0.00, 0.00, 56.00, 80.00, true)
	GUI:setChineseName(PKModelListViewCell, "攻击模式_模板组合")
	GUI:setTouchEnabled(PKModelListViewCell, true)
	GUI:setTag(PKModelListViewCell, -1)

	-- Create PKModeText
	local PKModeText = GUI:Text_Create(PKModelListViewCell, "PKModeText", 18.00, 16.00, 18, "#f9ebc0", [[全
体]])
	GUI:setTouchEnabled(PKModeText, false)
	GUI:setTag(PKModeText, -1)
	GUI:Text_enableOutline(PKModeText, "#000000", 2)
end
return ui