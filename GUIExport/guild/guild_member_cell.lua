local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 210.00, 732.00, 50.00, false)
	GUI:setChineseName(Panel_cell, "行会列表_标题组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 81)

	-- Create line
	local line = GUI:Image_Create(Panel_cell, "line", 366.00, 0.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(line, "行会列表_标题_装饰条")
	GUI:setAnchorPoint(line, 0.50, 0.50)
	GUI:setTouchEnabled(line, false)
	GUI:setTag(line, 151)

	-- Create username
	local username = GUI:Text_Create(Panel_cell, "username", 68.00, 25.00, 16, "#ffffff", [[玩家名字]])
	GUI:setChineseName(username, "行会列表_标题_玩家名字")
	GUI:setAnchorPoint(username, 0.50, 0.50)
	GUI:setTouchEnabled(username, false)
	GUI:setTag(username, 82)
	GUI:Text_enableOutline(username, "#111111", 1)

	-- Create level
	local level = GUI:Text_Create(Panel_cell, "level", 252.00, 25.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(level, "行会列表_标题_玩家等级")
	GUI:setAnchorPoint(level, 0.50, 0.50)
	GUI:setTouchEnabled(level, false)
	GUI:setTag(level, 83)
	GUI:Text_enableOutline(level, "#111111", 1)

	-- Create job
	local job = GUI:Text_Create(Panel_cell, "job", 388.00, 25.00, 16, "#ffffff", [[职业]])
	GUI:setChineseName(job, "行会列表_标题_玩家职业")
	GUI:setAnchorPoint(job, 0.50, 0.50)
	GUI:setTouchEnabled(job, false)
	GUI:setTag(job, 84)
	GUI:Text_enableOutline(job, "#111111", 1)

	-- Create official
	local official = GUI:Text_Create(Panel_cell, "official", 522.00, 25.00, 16, "#ffffff", [[职务]])
	GUI:setChineseName(official, "行会列表_标题_玩家职务")
	GUI:setAnchorPoint(official, 0.50, 0.50)
	GUI:setTouchEnabled(official, false)
	GUI:setTag(official, 85)
	GUI:Text_enableOutline(official, "#111111", 1)

	-- Create online
	local online = GUI:Text_Create(Panel_cell, "online", 660.00, 25.00, 16, "#ffffff", [[状态]])
	GUI:setChineseName(online, "行会列表_标题_玩家状态")
	GUI:setAnchorPoint(online, 0.50, 0.50)
	GUI:setTouchEnabled(online, false)
	GUI:setTag(online, 86)
	GUI:Text_enableOutline(online, "#111111", 1)
end
return ui