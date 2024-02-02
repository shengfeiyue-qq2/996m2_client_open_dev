local ui = {}
function ui.init(parent)
	-- Create Layer
	local Layer = GUI:Node_Create(parent, "Layer", 0.00, 0.00)
	GUI:setChineseName(Layer, "右键弹出层")
	GUI:setAnchorPoint(Layer, 0.50, 0.50)
	GUI:setTag(Layer, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Layer, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "右键弹出_范围点击关闭")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 7)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Layer, "Image_bg", 0.00, 0.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_bg, 21, 21, 33, 33)
	GUI:setContentSize(Image_bg, 85, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "右键弹出_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 8)

	-- Create ListView
	local ListView = GUI:ListView_Create(Image_bg, "ListView", 0.00, 0.00, 85.00, 100.00, 1)
	GUI:ListView_setGravity(ListView, 2)
	GUI:ListView_setItemsMargin(ListView, 5)
	GUI:setChineseName(ListView, "右键弹出_列表")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 5)
end
return ui