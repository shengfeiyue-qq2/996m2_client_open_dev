local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 24)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 568.00, 320.00, 500.00, 400.00, false)
	GUI:Layout_setBackGroundColorType(PMainUI, 1)
	GUI:Layout_setBackGroundColor(PMainUI, "#000000")
	GUI:Layout_setBackGroundColorOpacity(PMainUI, 178)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 21)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(PMainUI, "Image_2", 250.00, 200.00, "res/public/1900000675.jpg")
	GUI:setContentSize(Image_2, 500, 400)
	GUI:setIgnoreContentAdaptWithSize(Image_2, false)
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 25)

	-- Create Button_close
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", 500.00, 402.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 5, 5, 11, 11)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.00, 1.00)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 26)

	-- Create Node_qrcode_tips
	local Node_qrcode_tips = GUI:Node_Create(PMainUI, "Node_qrcode_tips", 250.00, 30.00)
	GUI:setAnchorPoint(Node_qrcode_tips, 0.50, 0.50)
	GUI:setTag(Node_qrcode_tips, 28)

	-- Create Node_qrcode
	local Node_qrcode = GUI:Node_Create(PMainUI, "Node_qrcode", 250.00, 200.00)
	GUI:setAnchorPoint(Node_qrcode, 0.50, 0.50)
	GUI:setTag(Node_qrcode, 27)
end
return ui