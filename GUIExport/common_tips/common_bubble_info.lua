local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "邀请入会弹窗场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "邀请入会弹窗组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 8)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_1, "ListView", 278.00, 410.00, 320.00, 157.00, 1)
	GUI:ListView_setBackGroundImage(ListView, "res/private/item_tips/btn_tipszy_01.png")
	GUI:ListView_setBackGroundImageScale9Slice(ListView, 0, 254, 0, 35)
	GUI:ListView_setGravity(ListView, 2)
	GUI:setChineseName(ListView, "邀请入会弹窗_列表")
	GUI:setAnchorPoint(ListView, 0.00, 1.00)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 11)
end
return ui