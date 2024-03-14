local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "进度条场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "进度条_范围点击关闭")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 10)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 568.00, 320.00, 182.00, 55.00, false)
	GUI:setChineseName(Panel_2, "进度条组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 7)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 91.00, 27.50, "res/private/script_show/00230.png")
	GUI:Image_setScale9Slice(Image_1, 78, 78, 18, 18)
	GUI:setContentSize(Image_1, 182, 55)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "进度条_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 8)

	-- Create LoadingBar_1
	local LoadingBar_1 = GUI:LoadingBar_Create(Panel_2, "LoadingBar_1", 91.00, 20.00, "res/private/script_show/00231.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_1, 100)
	GUI:LoadingBar_setColor(LoadingBar_1, "#ffffff")
	GUI:setChineseName(LoadingBar_1, "进度条_进度")
	GUI:setAnchorPoint(LoadingBar_1, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_1, false)
	GUI:setTag(LoadingBar_1, 11)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Panel_2, "Text_desc", 91.00, 37.00, 16, "#ffffff", [[正在随机，进度%s]])
	GUI:setChineseName(Text_desc, "进度条_标题_文本")
	GUI:setAnchorPoint(Text_desc, 0.50, 0.50)
	GUI:setTouchEnabled(Text_desc, false)
	GUI:setTag(Text_desc, 12)
	GUI:Text_enableOutline(Text_desc, "#000000", 1)
end
return ui