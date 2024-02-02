local ui = {}
function ui.init(parent)
	-- Create PPopUI
	local PPopUI = GUI:Layout_Create(parent, "PPopUI", 0.00, 0.00, 171.00, 186.00, false)
	GUI:setChineseName(PPopUI, "快捷使用组合")
	GUI:setTouchEnabled(PPopUI, true)
	GUI:setTag(PPopUI, -1)

	-- Create pBg
	local pBg = GUI:Image_Create(PPopUI, "pBg", 0.00, 0.00, "res/public/bg_hhdb_02.jpg")
	GUI:setChineseName(pBg, "快捷使用_背景图")
	GUI:setTouchEnabled(pBg, false)
	GUI:setTag(pBg, -1)

	-- Create TextTitle
	local TextTitle = GUI:Text_Create(PPopUI, "TextTitle", 72.00, 164.00, 18, "#ffffff", [[快捷使用]])
	GUI:setChineseName(TextTitle, "快捷使用_标题_文本")
	GUI:setAnchorPoint(TextTitle, 0.50, 0.50)
	GUI:setTouchEnabled(TextTitle, false)
	GUI:setTag(TextTitle, -1)
	GUI:Text_enableOutline(TextTitle, "#000000", 1)

	-- Create ItemBg
	local ItemBg = GUI:Image_Create(PPopUI, "ItemBg", 72.00, 112.00, "res/public/1900000651.png")
	GUI:setChineseName(ItemBg, "快捷使用_物品_背景框")
	GUI:setAnchorPoint(ItemBg, 0.50, 0.50)
	GUI:setTouchEnabled(ItemBg, false)
	GUI:setTag(ItemBg, -1)

	-- Create ItemNode
	local ItemNode = GUI:Layout_Create(PPopUI, "ItemNode", 72.00, 112.00, 0.00, 0.00, false)
	GUI:setChineseName(ItemNode, "快捷使用_物品_节点")
	GUI:setAnchorPoint(ItemNode, 0.50, 0.50)
	GUI:setTouchEnabled(ItemNode, false)
	GUI:setTag(ItemNode, -1)

	-- Create TextName
	local TextName = GUI:Text_Create(PPopUI, "TextName", 72.00, 68.00, 16, "#ffffff", [[]])
	GUI:setChineseName(TextName, "快捷使用_物品名称_文本")
	GUI:setAnchorPoint(TextName, 0.50, 0.50)
	GUI:setTouchEnabled(TextName, false)
	GUI:setTag(TextName, -1)
	GUI:Text_enableOutline(TextName, "#000000", 1)

	-- Create TextTime
	local TextTime = GUI:Text_Create(PPopUI, "TextTime", 123.00, 35.00, 16, "#ffffff", [[]])
	GUI:setChineseName(TextTime, "快捷使用_倒计时_文本")
	GUI:setAnchorPoint(TextTime, 0.50, 0.50)
	GUI:setTouchEnabled(TextTime, false)
	GUI:setTag(TextTime, -1)
	GUI:Text_enableOutline(TextTime, "#000000", 1)

	-- Create BtnUse
	local BtnUse = GUI:Button_Create(PPopUI, "BtnUse", 72.00, 35.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(BtnUse, "res/public/1900000679_1.png")
	GUI:Button_setTitleText(BtnUse, "使用")
	GUI:Button_setTitleColor(BtnUse, "#f8e6c6")
	GUI:Button_setTitleFontSize(BtnUse, 16)
	GUI:Button_titleEnableOutline(BtnUse, "#000000", 1)
	GUI:setChineseName(BtnUse, "快捷使用_使用_按钮")
	GUI:setAnchorPoint(BtnUse, 0.50, 0.50)
	GUI:setTouchEnabled(BtnUse, true)
	GUI:setTag(BtnUse, -1)

	-- Create BtnClose
	local BtnClose = GUI:Button_Create(PPopUI, "BtnClose", 144.00, 144.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
	GUI:Button_setTitleText(BtnClose, "")
	GUI:Button_setTitleColor(BtnClose, "#ffffff")
	GUI:Button_setTitleFontSize(BtnClose, 10)
	GUI:Button_titleEnableOutline(BtnClose, "#000000", 1)
	GUI:setChineseName(BtnClose, "快捷使用_关闭_按钮")
	GUI:setTouchEnabled(BtnClose, true)
	GUI:setTag(BtnClose, -1)
end
return ui