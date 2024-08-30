local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setTag(Node, -1.0)

	-- Create Item
	local Item = GUI:Layout_Create(parent, "Item", 0.00, 0.00, 171.00, 186.00, false)
	GUI:setChineseName(Item, "快捷使用组合")
	GUI:setTouchEnabled(Item, true)
	GUI:setTag(Item, -1.0)
	GUI:setVisible(Item, false)

	-- Create pBg
	local pBg = GUI:Image_Create(Item, "pBg", 0.00, 0.00, "res/public/bg_hhdb_02.jpg")
	GUI:setChineseName(pBg, "快捷使用_背景图")
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1.0)

	-- Create TextTitle
	local TextTitle = GUI:Text_Create(Item, "TextTitle", 72.00, 164.00, 18.0, "#ffffff", [[快捷使用]])
	GUI:setChineseName(TextTitle, "快捷使用_标题_文本")
	GUI:setAnchorPoint(TextTitle, 0.50, 0.50)
	GUI:setTouchEnabled(TextTitle, false)
	GUI:setTag(TextTitle, -1.0)
	GUI:Text_enableOutline(TextTitle, "#000000", 1.0)

	-- Create ItemBg
	local ItemBg = GUI:Image_Create(Item, "ItemBg", 72.00, 112.00, "res/public/1900000651.png")
	GUI:setChineseName(ItemBg, "快捷使用_物品_背景框")
	GUI:setAnchorPoint(ItemBg, 0.50, 0.50)
	GUI:setTouchEnabled(ItemBg, false)
	GUI:setTag(ItemBg, -1.0)

	-- Create ItemNode
	local ItemNode = GUI:Layout_Create(Item, "ItemNode", 72.00, 112.00, 0.00, 0.00, false)
	GUI:setChineseName(ItemNode, "快捷使用_物品_节点")
	GUI:setAnchorPoint(ItemNode, 0.50, 0.50)
	GUI:setTouchEnabled(ItemNode, false)
	GUI:setTag(ItemNode, -1.0)

	-- Create TextName
	local TextName = GUI:Text_Create(Item, "TextName", 72.00, 68.00, 16.0, "#ffffff", [[]])
	GUI:setChineseName(TextName, "快捷使用_物品名称_文本")
	GUI:setAnchorPoint(TextName, 0.50, 0.50)
	GUI:setTouchEnabled(TextName, false)
	GUI:setTag(TextName, -1.0)
	GUI:Text_enableOutline(TextName, "#000000", 1.0)

	-- Create TextTime
	local TextTime = GUI:Text_Create(Item, "TextTime", 123.00, 35.00, 16.0, "#ffffff", [[]])
	GUI:setChineseName(TextTime, "快捷使用_倒计时_文本")
	GUI:setAnchorPoint(TextTime, 0.50, 0.50)
	GUI:setTouchEnabled(TextTime, false)
	GUI:setTag(TextTime, -1.0)
	GUI:Text_enableOutline(TextTime, "#000000", 1.0)

	-- Create BtnUse
	local BtnUse = GUI:Button_Create(Item, "BtnUse", 72.00, 35.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(BtnUse, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(BtnUse, "使用")
	GUI:Button_setTitleColor(BtnUse, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnUse, 16.0)
	GUI:Button_titleEnableOutline(BtnUse, "#000000", 1.0)
	GUI:setChineseName(BtnUse, "快捷使用_使用_按钮")
	GUI:setAnchorPoint(BtnUse, 0.50, 0.50)
	GUI:setTouchEnabled(BtnUse, true)
	GUI:setTag(BtnUse, -1.0)

	-- Create BtnClose
	local BtnClose = GUI:Button_Create(Item, "BtnClose", 144.00, 144.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
	GUI:Button_setTitleText(BtnClose, "")
	GUI:Button_setTitleColor(BtnClose, "#ffffff")
	GUI:Button_setTitleFontSize(BtnClose, 10.0)
	GUI:Button_titleEnableOutline(BtnClose, "#000000", 1.0)
	GUI:setChineseName(BtnClose, "快捷使用_关闭_按钮")
	GUI:setTouchEnabled(BtnClose, true)
	GUI:setTag(BtnClose, -1.0)
end
return ui