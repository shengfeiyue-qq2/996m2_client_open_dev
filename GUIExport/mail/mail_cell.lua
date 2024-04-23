local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 383.00, 290.00, 220.00, 74.00, false)
	GUI:setTouchEnabled(Cell, true)
	GUI:setTag(Cell, -1)

	-- Create btnMail
	local btnMail = GUI:Button_Create(Cell, "btnMail", 0.00, 0.00, "res/private/mail/1900020062.png")
	GUI:Button_loadTexturePressed(btnMail, "res/private/mail/1900020063.png")
	GUI:Button_setTitleText(btnMail, "")
	GUI:Button_setTitleColor(btnMail, "#ffffff")
	GUI:Button_setTitleFontSize(btnMail, 10)
	GUI:Button_titleEnableOutline(btnMail, "#000000", 1)
	GUI:setTouchEnabled(btnMail, true)
	GUI:setTag(btnMail, -1)

	-- Create name
	local name = GUI:Text_Create(Cell, "name", 15.00, 53.00, 16, "#a58e67", [[传奇团队]])
	GUI:setAnchorPoint(name, 0.00, 0.50)
	GUI:setTouchEnabled(name, false)
	GUI:setTag(name, -1)
	GUI:Text_enableOutline(name, "#111111", 1)

	-- Create tips
	local tips = GUI:Text_Create(Cell, "tips", 15.00, 24.00, 16, "#897867", [[系统奖励]])
	GUI:setAnchorPoint(tips, 0.00, 0.50)
	GUI:setTouchEnabled(tips, false)
	GUI:setTag(tips, -1)
	GUI:Text_enableOutline(tips, "#111111", 1)

	-- Create select
	local select = GUI:Image_Create(Cell, "select", 6.00, 7.00, "res/public/1900000651_2.png")
	GUI:setContentSize(select, 206, 60)
	GUI:setIgnoreContentAdaptWithSize(select, false)
	GUI:setTouchEnabled(select, false)
	GUI:setTag(select, -1)
	GUI:setVisible(select, false)

	-- Create btnDel
	local btnDel = GUI:Button_Create(Cell, "btnDel", 190.00, 37.00, "res/private/mail/1900020065.png")
	GUI:Button_setTitleText(btnDel, "")
	GUI:Button_setTitleColor(btnDel, "#ffffff")
	GUI:Button_setTitleFontSize(btnDel, 10)
	GUI:Button_titleEnableOutline(btnDel, "#000000", 1)
	GUI:setAnchorPoint(btnDel, 0.50, 0.50)
	GUI:setScaleX(btnDel, 0.80)
	GUI:setScaleY(btnDel, 0.80)
	GUI:setTouchEnabled(btnDel, true)
	GUI:setTag(btnDel, -1)

	-- Create red
	local red = GUI:Image_Create(Cell, "red", 198.00, 51.00, "res/public/btn_npcfh_04.png")
	GUI:setTouchEnabled(red, false)
	GUI:setTag(red, -1)
end
return ui