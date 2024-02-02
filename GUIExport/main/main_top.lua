local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 1136.00, 30.00, false)
	GUI:setChineseName(Panel_1, "信号栏_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 568.00, 30.00, "res/private/main/1900012013.png")
	GUI:setContentSize(Image_1, 1136, 31)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "信号栏_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 20.00, 30.00, 200.00, 30.00, false)
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

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Panel_1, "Panel_3", 1116.00, 30.00, 160.00, 30.00, false)
	GUI:setChineseName(Panel_3, "信号栏_信号组合")
	GUI:setAnchorPoint(Panel_3, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_3, false)
	GUI:setTag(Panel_3, -1)

	-- Create Image_net
	local Image_net = GUI:Image_Create(Panel_3, "Image_net", 70.00, 15.00, "res/private/main/Other/1900012501.png")
	GUI:setChineseName(Image_net, "信号栏_wife_图片")
	GUI:setAnchorPoint(Image_net, 0.50, 0.50)
	GUI:setTouchEnabled(Image_net, false)
	GUI:setTag(Image_net, -1)

	-- Create Image_battery
	local Image_battery = GUI:Image_Create(Panel_3, "Image_battery", 133.00, 15.00, "res/private/main/Other/1900012502.png")
	GUI:setChineseName(Image_battery, "信号栏_电池边框_图片")
	GUI:setAnchorPoint(Image_battery, 0.50, 0.50)
	GUI:setTouchEnabled(Image_battery, false)
	GUI:setTag(Image_battery, -1)

	-- Create LoadingBar_battery
	local LoadingBar_battery = GUI:LoadingBar_Create(Panel_3, "LoadingBar_battery", 132.00, 15.00, "res/private/main/Other/1900012503.png", 0)
	GUI:setContentSize(LoadingBar_battery, 39, 15)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_battery, false)
	GUI:LoadingBar_setPercent(LoadingBar_battery, 100)
	GUI:setChineseName(LoadingBar_battery, "信号栏_电池")
	GUI:setAnchorPoint(LoadingBar_battery, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_battery, false)
	GUI:setTag(LoadingBar_battery, -1)
end
return ui