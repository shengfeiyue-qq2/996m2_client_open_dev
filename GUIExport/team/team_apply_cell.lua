local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 267.00, 312.00, 600.00, 40.00, false)
	GUI:setTouchEnabled(Cell, false)
	GUI:setTag(Cell, -1)

	-- Create cellBg
	local cellBg = GUI:Image_Create(Cell, "cellBg", 300.00, 20.00, "res/private/team/1900014004_1.png")
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

	-- Create disagreeBtn
	local disagreeBtn = GUI:Button_Create(Cell, "disagreeBtn", 458.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(disagreeBtn, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(disagreeBtn, "拒绝")
	GUI:Button_setTitleColor(disagreeBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(disagreeBtn, 16)
	GUI:Button_titleEnableOutline(disagreeBtn, "#111111", 2)
	GUI:setAnchorPoint(disagreeBtn, 0.50, 0.50)
	GUI:setTouchEnabled(disagreeBtn, true)
	GUI:setTag(disagreeBtn, -1)

	-- Create agreeBtn
	local agreeBtn = GUI:Button_Create(Cell, "agreeBtn", 553.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(agreeBtn, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(agreeBtn, "同意")
	GUI:Button_setTitleColor(agreeBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(agreeBtn, 16)
	GUI:Button_titleEnableOutline(agreeBtn, "#111111", 2)
	GUI:setAnchorPoint(agreeBtn, 0.50, 0.50)
	GUI:setTouchEnabled(agreeBtn, true)
	GUI:setTag(agreeBtn, -1)
end
return ui