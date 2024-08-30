local ui = {}
function ui.init(parent)
	-- Create Main_Top
	local Main_Top = GUI:Layout_Create(parent, "Main_Top", 0.00, 0.00, 1136.00, 30.00, false)
	GUI:setChineseName(Main_Top, "信号栏_组合")
	GUI:setAnchorPoint(Main_Top, 0.00, 1.00)
	GUI:setTouchEnabled(Main_Top, false)
	GUI:setTag(Main_Top, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Main_Top, "Image_1", 0.00, 30.00, "res/private/main/1900012013.png")
	GUI:setContentSize(Image_1, 1136, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "信号栏_背景图")
	GUI:setAnchorPoint(Image_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Main_Top, "Panel_2", 20.00, 30.00, 200.00, 30.00, false)
	GUI:setChineseName(Panel_2, "信号栏_箭头装饰组合")
	GUI:setAnchorPoint(Panel_2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_2, false)
	GUI:setTag(Panel_2, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_2, "Image_2", 25.00, 15.00, "res/private/main/1900012014.png")
	GUI:setChineseName(Image_2, "信号栏_箭头_图片")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)
end
return ui