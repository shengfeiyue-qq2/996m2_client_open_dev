local ui = {}
function ui.init(parent)
	-- Create bgPanel
	local bgPanel = GUI:Layout_Create(parent, "bgPanel", 574.00, 311.00, 680.00, 400.00, false)
	GUI:Layout_setBackGroundImage(bgPanel, "res/public/1900000675.jpg")
	GUI:setAnchorPoint(bgPanel, 0.50, 0.50)
	GUI:setTouchEnabled(bgPanel, false)
	GUI:setTag(bgPanel, -1)

	-- Create MaskNode
	local MaskNode = GUI:Node_Create(bgPanel, "MaskNode", 340.00, 200.00)
	GUI:setTag(MaskNode, -1)

	-- Create MaskLayout
	local MaskLayout = GUI:Layout_Create(MaskNode, "MaskLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setAnchorPoint(MaskLayout, 0.50, 0.50)
	GUI:setTouchEnabled(MaskLayout, true)
	GUI:setTag(MaskLayout, -1)

	-- Create innerBg
	local innerBg = GUI:Image_Create(bgPanel, "innerBg", 340.00, 195.00, "res/private/team/1900014004.png")
	GUI:setAnchorPoint(innerBg, 0.50, 0.50)
	GUI:setTouchEnabled(innerBg, false)
	GUI:setTag(innerBg, -1)

	-- Create closeBtn
	local closeBtn = GUI:Button_Create(bgPanel, "closeBtn", 692.00, 378.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(closeBtn, "res/public/1900000511.png")
	GUI:Button_setTitleText(closeBtn, "")
	GUI:Button_setTitleColor(closeBtn, "#ffffff")
	GUI:Button_setTitleFontSize(closeBtn, 10)
	GUI:Button_titleEnableOutline(closeBtn, "#000000", 1)
	GUI:setAnchorPoint(closeBtn, 0.50, 0.50)
	GUI:setTouchEnabled(closeBtn, true)
	GUI:setTag(closeBtn, -1)

	-- Create titleImg
	local titleImg = GUI:Image_Create(bgPanel, "titleImg", 340.00, 369.00, "res/private/team/1900014002.png")
	GUI:setAnchorPoint(titleImg, 0.50, 0.50)
	GUI:setTouchEnabled(titleImg, false)
	GUI:setTag(titleImg, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(bgPanel, "ListView", 40.00, 43.00, 600.00, 280.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(bgPanel, "Text_name", 108.00, 328.00, 16, "#ffffff", [[玩家]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.00)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_guildname
	local Text_guildname = GUI:Text_Create(bgPanel, "Text_guildname", 241.00, 328.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(Text_guildname, 0.50, 0.00)
	GUI:setTouchEnabled(Text_guildname, false)
	GUI:setTag(Text_guildname, -1)
	GUI:Text_enableOutline(Text_guildname, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(bgPanel, "Text_level", 378.00, 328.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.00)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, -1)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_opt
	local Text_opt = GUI:Text_Create(bgPanel, "Text_opt", 544.00, 328.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_opt, 0.50, 0.00)
	GUI:setTouchEnabled(Text_opt, false)
	GUI:setTag(Text_opt, -1)
	GUI:Text_enableOutline(Text_opt, "#000000", 1)
end
return ui