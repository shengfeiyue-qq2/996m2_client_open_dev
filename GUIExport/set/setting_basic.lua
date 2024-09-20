local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 732.00, 445.00, false)
	GUI:setChineseName(Panel_1, "基础面板组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 124.00, 421.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 200, 300)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "基础面板_面板1组合")
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_1, "ListView_1", 0.00, 2.00, 200.00, 296.00, 1)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:setChineseName(ListView_1, "基础面板_面板1列表")
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 367.00, 421.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
	GUI:setContentSize(Image_2, 200, 300)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setChineseName(Image_2, "基础面板_面板2组合")
	GUI:setAnchorPoint(Image_2, 0.50, 1.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Image_2, "ListView_2", 0.00, 2.00, 200.00, 296.00, 1)
	GUI:ListView_setGravity(ListView_2, 2)
	GUI:setChineseName(ListView_2, "基础面板_面板2列表")
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, -1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 609.00, 421.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_3, 33, 33, 9, 9)
	GUI:setContentSize(Image_3, 200, 300)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "基础面板_面板3组合")
	GUI:setAnchorPoint(Image_3, 0.50, 1.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, -1)

	-- Create ListView_3
	local ListView_3 = GUI:ListView_Create(Image_3, "ListView_3", 0.00, 2.00, 200.00, 296.00, 1)
	GUI:ListView_setGravity(ListView_3, 2)
	GUI:setChineseName(ListView_3, "基础面板_面板3列表")
	GUI:setTouchEnabled(ListView_3, true)
	GUI:setTag(ListView_3, -1)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_1, "Image_4", 24.00, 112.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_4, 33, 33, 9, 9)
	GUI:setContentSize(Image_4, 685, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setChineseName(Image_4, "基础面板_面板4组合")
	GUI:setAnchorPoint(Image_4, 0.00, 1.00)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, -1)

	-- Create ListView_4
	local ListView_4 = GUI:ListView_Create(Image_4, "ListView_4", 0.00, 2.00, 685.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_4, 5)
	GUI:setChineseName(ListView_4, "基础面板_面板4列表")
	GUI:setTouchEnabled(ListView_4, true)
	GUI:setTag(ListView_4, -1)

	-- Create Image_4_1
	local Image_4_1 = GUI:Image_Create(Panel_1, "Image_4_1", 24.00, 112.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_4_1, 33, 33, 9, 3)
	GUI:setContentSize(Image_4_1, 443, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_4_1, false)
	GUI:setAnchorPoint(Image_4_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_4_1, false)
	GUI:setTag(Image_4_1, -1)
	GUI:setVisible(Image_4_1, false)

	-- Create ListView_4_1
	local ListView_4_1 = GUI:ListView_Create(Image_4_1, "ListView_4_1", 0.00, 2.00, 440.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_4_1, 5)
	GUI:setTouchEnabled(ListView_4_1, true)
	GUI:setTag(ListView_4_1, -1)

	-- Create Image_4_1_1
	local Image_4_1_1 = GUI:Image_Create(Panel_1, "Image_4_1_1", 510.00, 112.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_4_1_1, 33, 33, 9, 3)
	GUI:setContentSize(Image_4_1_1, 200, 100)
	GUI:setIgnoreContentAdaptWithSize(Image_4_1_1, false)
	GUI:setAnchorPoint(Image_4_1_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_4_1_1, false)
	GUI:setTag(Image_4_1_1, -1)
	GUI:setVisible(Image_4_1_1, false)

	-- Create ListView_4_2
	local ListView_4_2 = GUI:ListView_Create(Image_4_1_1, "ListView_4_2", 0.00, 2.00, 200.00, 95.00, 1)
	GUI:ListView_setGravity(ListView_4_2, 5)
	GUI:setTouchEnabled(ListView_4_2, true)
	GUI:setTag(ListView_4_2, -1)
end
return ui