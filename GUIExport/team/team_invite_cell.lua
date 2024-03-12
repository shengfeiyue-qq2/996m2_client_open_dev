local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 315.00, 305.00, 504.00, 40.00, false)
	GUI:setTouchEnabled(Cell, false)
	GUI:setTag(Cell, -1)

	-- Create cellBg
	local cellBg = GUI:Image_Create(Cell, "cellBg", 252.00, 20.00, "res/private/team/1900014007_1.png")
	GUI:setAnchorPoint(cellBg, 0.50, 0.50)
	GUI:setTouchEnabled(cellBg, false)
	GUI:setTag(cellBg, -1)

	-- Create nameLabel
	local nameLabel = GUI:Text_Create(Cell, "nameLabel", 68.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setAnchorPoint(nameLabel, 0.50, 0.50)
	GUI:setTouchEnabled(nameLabel, false)
	GUI:setTag(nameLabel, -1)
	GUI:Text_enableOutline(nameLabel, "#000000", 1)

	-- Create guildLabel
	local guildLabel = GUI:Text_Create(Cell, "guildLabel", 200.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setAnchorPoint(guildLabel, 0.50, 0.50)
	GUI:setTouchEnabled(guildLabel, false)
	GUI:setTag(guildLabel, -1)
	GUI:Text_enableOutline(guildLabel, "#000000", 1)

	-- Create levelLabel
	local levelLabel = GUI:Text_Create(Cell, "levelLabel", 340.00, 20.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(levelLabel, 0.50, 0.50)
	GUI:setTouchEnabled(levelLabel, false)
	GUI:setTag(levelLabel, -1)
	GUI:Text_enableOutline(levelLabel, "#000000", 1)

	-- Create operationBtn
	local operationBtn = GUI:Button_Create(Cell, "operationBtn", 458.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(operationBtn, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(operationBtn, "邀请")
	GUI:Button_setTitleColor(operationBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(operationBtn, 16)
	GUI:Button_titleEnableOutline(operationBtn, "#111111", 2)
	GUI:setAnchorPoint(operationBtn, 0.50, 0.50)
	GUI:setTouchEnabled(operationBtn, true)
	GUI:setTag(operationBtn, -1)

	-- Create operationLabel
	local operationLabel = GUI:Text_Create(Cell, "operationLabel", 458.00, 20.00, 16, "#f8e6c6", [[已邀请]])
	GUI:setAnchorPoint(operationLabel, 0.50, 0.50)
	GUI:setTouchEnabled(operationLabel, false)
	GUI:setTag(operationLabel, -1)
	GUI:Text_enableOutline(operationLabel, "#000000", 1)
end
return ui