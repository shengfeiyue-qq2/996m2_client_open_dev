local ui = {}
function ui.init(parent)
	-- Create tipsLayout
	local tipsLayout = GUI:Layout_Create(parent, "tipsLayout", 265.00, 400.00, 135.00, 173.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(tipsLayout, 44, 44, 57, 57)
	GUI:Layout_setBackGroundImage(tipsLayout, "res/private/item_tips/bg_tipszy_05.png")
	GUI:setChineseName(tipsLayout, "物品展示布局")
	GUI:setAnchorPoint(tipsLayout, 0.00, 1.00)
	GUI:setTouchEnabled(tipsLayout, false)
	GUI:setTag(tipsLayout, -1)
end
return ui