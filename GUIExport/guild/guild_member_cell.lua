local ui = {}
function ui.init(parent)
	-- Create mCell
	local mCell = GUI:Layout_Create(parent, "mCell", 0.00, 0.00, 732.00, 50.00, true)
	GUI:setTouchEnabled(mCell, false)
	GUI:setTag(mCell, -1)
	GUI:setVisible(mCell, false)

	-- Create line
	local line = GUI:Image_Create(mCell, "line", 0.00, 0.00, "res/public/img_line_long.png")
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, -1)

	-- Create username
	local username = GUI:Text_Create(mCell, "username", 92.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(username, 0.50, 0.50)
	GUI:setTouchEnabled(username, false)
	GUI:setTag(username, -1)
	GUI:Text_enableOutline(username, "#000000", 1)

	-- Create level
	local level = GUI:Text_Create(mCell, "level", 251.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(level, 0.50, 0.50)
	GUI:setTouchEnabled(level, false)
	GUI:setTag(level, -1)
	GUI:Text_enableOutline(level, "#000000", 1)

	-- Create job
	local job = GUI:Text_Create(mCell, "job", 401.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(job, 0.50, 0.50)
	GUI:setTouchEnabled(job, false)
	GUI:setTag(job, -1)
	GUI:Text_enableOutline(job, "#000000", 1)

	-- Create official
	local official = GUI:Text_Create(mCell, "official", 526.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(official, 0.50, 0.50)
	GUI:setTouchEnabled(official, false)
	GUI:setTag(official, -1)
	GUI:Text_enableOutline(official, "#000000", 1)

	-- Create online
	local online = GUI:Text_Create(mCell, "online", 674.00, 25.00, 16, "#f2e7cf", [[]])
	GUI:setAnchorPoint(online, 0.50, 0.50)
	GUI:setTouchEnabled(online, false)
	GUI:setTag(online, -1)
	GUI:setVisible(online, false)
	GUI:Text_enableOutline(online, "#000000", 1)
end
return ui