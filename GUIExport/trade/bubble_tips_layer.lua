local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Scene, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 38)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 386.00, 257.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 26)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 181.00, 128.00, "res/public/1900000601.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setRotation(Image_1, -90.00)
	GUI:setRotationSkewX(Image_1, -90.00)
	GUI:setRotationSkewY(Image_1, -90.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 28)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 182.52, 223.50, "res/public/word_jyxszy_03.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 32)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 182.61, 204.24, "res/public/1900000667_1.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 37)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(Panel_1, "Node_2", 182.00, 145.00)
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 36)

	-- Create Button_no
	local Button_no = GUI:Button_Create(Panel_1, "Button_no", 91.18, 64.69, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_no, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_no, 15, 17, 11, 18)
	GUI:setContentSize(Button_no, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_no, false)
	GUI:Button_setTitleText(Button_no, "拒绝")
	GUI:Button_setTitleColor(Button_no, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_no, 18)
	GUI:Button_titleEnableOutline(Button_no, "#111111", 2)
	GUI:setAnchorPoint(Button_no, 0.50, 0.50)
	GUI:setTouchEnabled(Button_no, true)
	GUI:setTag(Button_no, 30)

	-- Create Button_agree
	local Button_agree = GUI:Button_Create(Panel_1, "Button_agree", 269.06, 64.66, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_agree, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_agree, 15, 17, 11, 18)
	GUI:setContentSize(Button_agree, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_agree, false)
	GUI:Button_setTitleText(Button_agree, "同意")
	GUI:Button_setTitleColor(Button_agree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_agree, 18)
	GUI:Button_titleEnableOutline(Button_agree, "#111111", 2)
	GUI:setAnchorPoint(Button_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_agree, true)
	GUI:setTag(Button_agree, 31)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 373.53, 235.64, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 29)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.46, 42.64, 40.00, 60.00, false)
	GUI:Layout_setBackGroundColorType(TouchSize, 1)
	GUI:Layout_setBackGroundColor(TouchSize, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(TouchSize, 102)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 33)
	GUI:setVisible(TouchSize, false)
end
return ui