local ui = {}
function ui.init(parent)
	-- Create Panel_item
	local Panel_item = GUI:Layout_Create(parent, "Panel_item", 0.00, 80.00, 390.00, 16.00, false)
	GUI:setChineseName(Panel_item, "物品展示组合")
	GUI:setTouchEnabled(Panel_item, true)
	GUI:setTag(Panel_item, 16)

	-- Create Text_point
	local Text_point = GUI:Text_Create(Panel_item, "Text_point", 3.00, 8.00, 24, "#ff0000", [[·]])
	GUI:setChineseName(Text_point, "物品_指向选择")
	GUI:setAnchorPoint(Text_point, 0.50, 0.50)
	GUI:setTouchEnabled(Text_point, false)
	GUI:setTag(Text_point, 21)
	GUI:setVisible(Text_point, false)
	GUI:Text_enableOutline(Text_point, "#000000", 1)

	-- Create Text_itemName
	local Text_itemName = GUI:Text_Create(Panel_item, "Text_itemName", 7.00, 8.00, 14, "#ffffff", [[物品名]])
	GUI:setChineseName(Text_itemName, "物品_名称_文本")
	GUI:setAnchorPoint(Text_itemName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemName, false)
	GUI:setTag(Text_itemName, 17)
	GUI:Text_enableOutline(Text_itemName, "#000000", 1)

	-- Create Text_itemPrice
	local Text_itemPrice = GUI:Text_Create(Panel_item, "Text_itemPrice", 205.00, 8.00, 16, "#ffffff", [[xxx金币]])
	GUI:setChineseName(Text_itemPrice, "物品_价值_文本")
	GUI:setAnchorPoint(Text_itemPrice, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemPrice, false)
	GUI:setTag(Text_itemPrice, 18)
	GUI:Text_enableOutline(Text_itemPrice, "#000000", 1)

	-- Create Text_itemDura
	local Text_itemDura = GUI:Text_Create(Panel_item, "Text_itemDura", 333.00, 8.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_itemDura, "物品_箭头_文本")
	GUI:setAnchorPoint(Text_itemDura, 0.00, 0.50)
	GUI:setTouchEnabled(Text_itemDura, false)
	GUI:setTag(Text_itemDura, 19)
	GUI:Text_enableOutline(Text_itemDura, "#000000", 1)
end
return ui