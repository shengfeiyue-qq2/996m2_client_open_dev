local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"), false)
	GUI:setAnchorPoint(Panel_1, 0.00, 0.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 0)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", SL:GetValue("SCREEN_WIDTH") * 0.5, SL:GetValue("SCREEN_HEIGHT"), "res/private/hurt_tips/hurt_tips_image_1.png")
	GUI:setContentSize(Image_1, SL:GetValue("SCREEN_WIDTH"), 95)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.50, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 0)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT") * 0.5, "res/private/hurt_tips/hurt_tips_image_2.png")
	GUI:setContentSize(Image_2, 95, SL:GetValue("SCREEN_HEIGHT"))
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 1.00, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 0)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", SL:GetValue("SCREEN_WIDTH") * 0.5, 0.00, "res/private/hurt_tips/hurt_tips_image_3.png")
	GUI:setContentSize(Image_3, SL:GetValue("SCREEN_WIDTH"), 95)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 0)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_1, "Image_4", 0.00, SL:GetValue("SCREEN_HEIGHT") * 0.5, "res/private/hurt_tips/hurt_tips_image_4.png")
	GUI:setContentSize(Image_4, 95, SL:GetValue("SCREEN_HEIGHT"))
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setAnchorPoint(Image_4, 0.00, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 0)

	return Panel_1
end
return ui
