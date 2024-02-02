local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "区服列表场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Image_login_bg
	local Image_login_bg = GUI:Image_Create(Scene, "Image_login_bg", 568.00, 320.00, "Default/ImageFile.png")
	GUI:setContentSize(Image_login_bg, 1136, 640)
	GUI:setIgnoreContentAdaptWithSize(Image_login_bg, false)
	GUI:setChineseName(Image_login_bg, "区服列表_背景图")
	GUI:setAnchorPoint(Image_login_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_login_bg, false)
	GUI:setTag(Image_login_bg, 140)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Scene, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_touch, 0, -1, 0, -1)
	GUI:setChineseName(Panel_touch, "区服列表_触摸区域")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 41)
end
return ui