local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 272.00, 305.00, 600.00, 42.00, false)
	GUI:setTouchEnabled(Cell, false)
	GUI:setTag(Cell, -1)

	-- Create cellBg
	local cellBg = GUI:Image_Create(Cell, "cellBg", 300.00, 21.00, "res/private/team/19000140013_1.png")
	GUI:setAnchorPoint(cellBg, 0.50, 0.50)
	GUI:setTouchEnabled(cellBg, false)
	GUI:setTag(cellBg, -1)

	-- Create nameLabel
	local nameLabel = GUI:Text_Create(Cell, "nameLabel", 83.00, 21.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setAnchorPoint(nameLabel, 0.50, 0.50)
	GUI:setTouchEnabled(nameLabel, false)
	GUI:setTag(nameLabel, -1)
	GUI:Text_enableOutline(nameLabel, "#000000", 1)

	-- Create guildLabel
	local guildLabel = GUI:Text_Create(Cell, "guildLabel", 250.00, 21.00, 16, "#ffffff", [[行会名称]])
	GUI:setAnchorPoint(guildLabel, 0.50, 0.50)
	GUI:setTouchEnabled(guildLabel, false)
	GUI:setTag(guildLabel, -1)
	GUI:Text_enableOutline(guildLabel, "#000000", 1)

	-- Create numberLabel
	local numberLabel = GUI:Text_Create(Cell, "numberLabel", 410.00, 21.00, 16, "#ffffff", [[人数]])
	GUI:setAnchorPoint(numberLabel, 0.50, 0.50)
	GUI:setTouchEnabled(numberLabel, false)
	GUI:setTag(numberLabel, -1)
	GUI:Text_enableOutline(numberLabel, "#000000", 1)

	-- Create operationLabel
	local operationLabel = GUI:Text_Create(Cell, "operationLabel", 530.00, 21.00, 16, "#f8e6c6", [[已申请]])
	GUI:setAnchorPoint(operationLabel, 0.50, 0.50)
	GUI:setTouchEnabled(operationLabel, false)
	GUI:setTag(operationLabel, -1)
	GUI:Text_enableOutline(operationLabel, "#000000", 1)

	-- Create operationButton
	local operationButton = GUI:Button_Create(Cell, "operationButton", 530.00, 21.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(operationButton, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(operationButton, "申请")
	GUI:Button_setTitleColor(operationButton, "#f8e6c6")
	GUI:Button_setTitleFontSize(operationButton, 18)
	GUI:Button_titleEnableOutline(operationButton, "#111111", 2)
	GUI:setAnchorPoint(operationButton, 0.50, 0.50)
	GUI:setTouchEnabled(operationButton, true)
	GUI:setTag(operationButton, -1)
end
return ui