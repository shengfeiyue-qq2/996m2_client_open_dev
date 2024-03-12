local ui = {}
function ui.init(parent)
	-- Create bgPanel
	local bgPanel = GUI:Layout_Create(parent, "bgPanel", 573.00, 324.00, 680.00, 400.00, false)
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
	local innerBg = GUI:Image_Create(bgPanel, "innerBg", 395.00, 190.00, "res/private/team/1900014007.png")
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

	-- Create nearBtn
	local nearBtn = GUI:Button_Create(bgPanel, "nearBtn", 80.00, 335.00, "res/public/1900000663.png")
	GUI:Button_loadTexturePressed(nearBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(nearBtn, "附近")
	GUI:Button_setTitleColor(nearBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(nearBtn, 18)
	GUI:Button_titleEnableOutline(nearBtn, "#111111", 2)
	GUI:setAnchorPoint(nearBtn, 0.50, 0.50)
	GUI:setTouchEnabled(nearBtn, true)
	GUI:setTag(nearBtn, -1)

	-- Create friendBtn
	local friendBtn = GUI:Button_Create(bgPanel, "friendBtn", 80.00, 295.00, "res/public/1900000663.png")
	GUI:Button_loadTexturePressed(friendBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(friendBtn, "好友")
	GUI:Button_setTitleColor(friendBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(friendBtn, 18)
	GUI:Button_titleEnableOutline(friendBtn, "#111111", 2)
	GUI:setAnchorPoint(friendBtn, 0.50, 0.50)
	GUI:setTouchEnabled(friendBtn, true)
	GUI:setTag(friendBtn, -1)

	-- Create guildBtn
	local guildBtn = GUI:Button_Create(bgPanel, "guildBtn", 80.00, 255.00, "res/public/1900000663.png")
	GUI:Button_loadTexturePressed(guildBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(guildBtn, "行会")
	GUI:Button_setTitleColor(guildBtn, "#f8e6c6")
	GUI:Button_setTitleFontSize(guildBtn, 18)
	GUI:Button_titleEnableOutline(guildBtn, "#111111", 2)
	GUI:setAnchorPoint(guildBtn, 0.50, 0.50)
	GUI:setTouchEnabled(guildBtn, true)
	GUI:setTag(guildBtn, -1)

	-- Create nameBtn
	local nameBtn = GUI:Button_Create(bgPanel, "nameBtn", 80.00, 215.00, "res/public/1900000663.png")
	GUI:Button_loadTexturePressed(nameBtn, "res/public/1900000662.png")
	GUI:Button_setTitleText(nameBtn, "输入名字")
	GUI:Button_setTitleColor(nameBtn, "#6c6861")
	GUI:Button_setTitleFontSize(nameBtn, 18)
	GUI:Button_titleEnableOutline(nameBtn, "#111111", 2)
	GUI:setAnchorPoint(nameBtn, 0.50, 0.50)
	GUI:setTouchEnabled(nameBtn, true)
	GUI:setTag(nameBtn, -1)

	-- Create titleImg
	local titleImg = GUI:Image_Create(bgPanel, "titleImg", 340.00, 369.00, "res/private/team/1900014005.png")
	GUI:setAnchorPoint(titleImg, 0.50, 0.50)
	GUI:setTouchEnabled(titleImg, false)
	GUI:setTag(titleImg, -1)

	-- Create guildText
	local guildText = GUI:Text_Create(bgPanel, "guildText", 340.00, 339.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(guildText, 0.50, 0.50)
	GUI:setTouchEnabled(guildText, false)
	GUI:setTag(guildText, -1)
	GUI:Text_enableOutline(guildText, "#000000", 1)

	-- Create levelText
	local levelText = GUI:Text_Create(bgPanel, "levelText", 480.00, 339.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(levelText, 0.50, 0.50)
	GUI:setTouchEnabled(levelText, false)
	GUI:setTag(levelText, -1)
	GUI:Text_enableOutline(levelText, "#000000", 1)

	-- Create operationText
	local operationText = GUI:Text_Create(bgPanel, "operationText", 600.00, 339.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(operationText, 0.50, 0.50)
	GUI:setTouchEnabled(operationText, false)
	GUI:setTag(operationText, -1)
	GUI:Text_enableOutline(operationText, "#000000", 1)

	-- Create ListView
	local ListView = GUI:ListView_Create(bgPanel, "ListView", 143.00, 33.00, 504.00, 290.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, -1)
end
return ui