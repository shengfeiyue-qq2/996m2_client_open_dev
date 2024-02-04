local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 269.00, 299.00, 600.00, 40.00, false)
	GUI:setTouchEnabled(Cell, false)
	GUI:setTag(Cell, -1)

	-- Create leaderImg
	local leaderImg = GUI:Image_Create(Cell, "leaderImg", 0.00, 20.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(leaderImg, 26, 26, 5, 5)
	GUI:setContentSize(leaderImg, 129, 32)
	GUI:setIgnoreContentAdaptWithSize(leaderImg, false)
	GUI:setAnchorPoint(leaderImg, 0.00, 0.50)
	GUI:setTouchEnabled(leaderImg, false)
	GUI:setTag(leaderImg, -1)

	-- Create icon
	local icon = GUI:Image_Create(Cell, "icon", 20.00, 20.00, "res/private/team/1900014001.png")
	GUI:setAnchorPoint(icon, 0.50, 0.50)
	GUI:setTouchEnabled(icon, false)
	GUI:setTag(icon, -1)

	-- Create cellBg
	local cellBg = GUI:Image_Create(Cell, "cellBg", 300.00, 20.00, "res/private/team/1900014010.png")
	GUI:setAnchorPoint(cellBg, 0.50, 0.50)
	GUI:setTouchEnabled(cellBg, false)
	GUI:setTag(cellBg, -1)

	-- Create nameLabel
	local nameLabel = GUI:Text_Create(Cell, "nameLabel", 94.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setAnchorPoint(nameLabel, 0.50, 0.50)
	GUI:setTouchEnabled(nameLabel, false)
	GUI:setTag(nameLabel, -1)
	GUI:Text_enableOutline(nameLabel, "#000000", 1)

	-- Create jobLabel
	local jobLabel = GUI:Text_Create(Cell, "jobLabel", 215.00, 20.00, 16, "#ffffff", [[战士]])
	GUI:setAnchorPoint(jobLabel, 0.50, 0.50)
	GUI:setTouchEnabled(jobLabel, false)
	GUI:setTag(jobLabel, -1)
	GUI:Text_enableOutline(jobLabel, "#000000", 1)

	-- Create levelLabel
	local levelLabel = GUI:Text_Create(Cell, "levelLabel", 293.00, 20.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(levelLabel, 0.50, 0.50)
	GUI:setTouchEnabled(levelLabel, false)
	GUI:setTag(levelLabel, -1)
	GUI:Text_enableOutline(levelLabel, "#000000", 1)

	-- Create guildLabel
	local guildLabel = GUI:Text_Create(Cell, "guildLabel", 400.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setAnchorPoint(guildLabel, 0.50, 0.50)
	GUI:setTouchEnabled(guildLabel, false)
	GUI:setTag(guildLabel, -1)
	GUI:Text_enableOutline(guildLabel, "#000000", 1)

	-- Create mapLabel
	local mapLabel = GUI:Text_Create(Cell, "mapLabel", 535.00, 20.00, 16, "#ffffff", [[地图名字七个字]])
	GUI:setAnchorPoint(mapLabel, 0.50, 0.50)
	GUI:setTouchEnabled(mapLabel, false)
	GUI:setTag(mapLabel, -1)
	GUI:Text_enableOutline(mapLabel, "#000000", 1)
end
return ui