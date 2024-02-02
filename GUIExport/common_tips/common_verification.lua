local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "图片答题_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "图片答题_面板")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 10)

	-- Create Image_panel
	local Image_panel = GUI:Image_Create(Panel_1, "Image_panel", 569.00, 319.00, "res/public/common_verificationBG.png")
	GUI:setChineseName(Image_panel, "图片答题_组合")
	GUI:setAnchorPoint(Image_panel, 0.50, 0.50)
	GUI:setTouchEnabled(Image_panel, true)
	GUI:setTag(Image_panel, 12)

	-- Create Text_desc
	local Text_desc = GUI:Text_Create(Image_panel, "Text_desc", 65.00, 451.00, 18, "#ffe400", [[请将道具拖动到下列对应的位置：]])
	GUI:setChineseName(Text_desc, "图片答题_提示文本")
	GUI:setAnchorPoint(Text_desc, 0.00, 1.00)
	GUI:setTouchEnabled(Text_desc, false)
	GUI:setTag(Text_desc, 15)
	GUI:Text_enableOutline(Text_desc, "#111111", 1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Image_panel, "Image_1", 388.00, 359.00, "res/public/1900000667.png")
	GUI:Image_setScale9Slice(Image_1, 75, 75, 0, 0)
	GUI:setContentSize(Image_1, 700, 4)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setChineseName(Image_1, "图片答题_装饰条")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 11)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Image_panel, "Image_bg", 100.00, 307.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_bg, 612, 244)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "图片答题_全部结果_图片")
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 12)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Image_panel, "Image_icon", 638.00, 489.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_icon, 104, 104)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "图片答题_答案_图标")
	GUI:setAnchorPoint(Image_icon, 0.00, 1.00)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 10)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Image_panel, "Text_time", 765.00, 90.00, 18, "#ffe400", [[10S]])
	GUI:setChineseName(Text_time, "图片答题_倒计时_文本")
	GUI:setAnchorPoint(Text_time, 0.00, 1.00)
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, 29)
	GUI:Text_enableOutline(Text_time, "#111111", 1)
end
return ui