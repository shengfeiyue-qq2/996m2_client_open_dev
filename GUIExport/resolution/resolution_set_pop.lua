local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create pnlTouch
	local pnlTouch = GUI:Layout_Create(Scene, "pnlTouch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(pnlTouch, true)
	GUI:setTag(pnlTouch, 465)

	-- Create PMainUI
	local PMainUI = GUI:Layout_Create(Scene, "PMainUI", 568.00, 320.00, 256.00, 359.00, false)
	GUI:setAnchorPoint(PMainUI, 0.50, 0.50)
	GUI:setTouchEnabled(PMainUI, true)
	GUI:setTag(PMainUI, 467)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(PMainUI, "Image_7", 128.00, 179.00, "res/public/1900000666.jpg")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 305)

	-- Create txtTitle
	local txtTitle = GUI:Text_Create(PMainUI, "txtTitle", 128.00, 334.00, 18, "#ffffff", [[设置分辨率]])
	GUI:Text_setTextHorizontalAlignment(txtTitle, 1)
	GUI:setAnchorPoint(txtTitle, 0.50, 1.00)
	GUI:setTouchEnabled(txtTitle, false)
	GUI:setTag(txtTitle, 468)
	GUI:Text_enableOutline(txtTitle, "#000000", 1)

	-- Create imgShow
	local imgShow = GUI:Image_Create(PMainUI, "imgShow", 128.00, 289.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(imgShow, 21, 21, 10, 10)
	GUI:setContentSize(imgShow, 126, 30)
	GUI:setIgnoreContentAdaptWithSize(imgShow, false)
	GUI:setAnchorPoint(imgShow, 0.50, 0.50)
	GUI:setTouchEnabled(imgShow, true)
	GUI:setTag(imgShow, 307)

	-- Create txtResolution
	local txtResolution = GUI:Text_Create(imgShow, "txtResolution", 63.00, 15.00, 16, "#9d0000", [[1024x768]])
	GUI:Text_setTextHorizontalAlignment(txtResolution, 1)
	GUI:setAnchorPoint(txtResolution, 0.50, 0.50)
	GUI:setTouchEnabled(txtResolution, false)
	GUI:setTag(txtResolution, 309)
	GUI:Text_enableOutline(txtResolution, "#000000", 1)

	-- Create btnClose
	local btnClose = GUI:Button_Create(PMainUI, "btnClose", 269.00, 336.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(btnClose, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(btnClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(btnClose, 8, 9, 11, 12)
	GUI:setContentSize(btnClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(btnClose, false)
	GUI:Button_setTitleText(btnClose, "")
	GUI:Button_setTitleColor(btnClose, "#414146")
	GUI:Button_setTitleFontSize(btnClose, 14)
	GUI:Button_titleDisableOutLine(btnClose)
	GUI:setAnchorPoint(btnClose, 0.50, 0.50)
	GUI:setTouchEnabled(btnClose, true)
	GUI:setTag(btnClose, 306)

	-- Create btnOk
	local btnOk = GUI:Button_Create(PMainUI, "btnOk", 126.00, 40.00, "res/public/1900001000.png")
	GUI:Button_loadTexturePressed(btnOk, "res/public/1900001001.png")
	GUI:Button_loadTextureDisabled(btnOk, "res/public/1900001001.png")
	GUI:Button_setScale9Slice(btnOk, 8, 8, 11, 11)
	GUI:setContentSize(btnOk, 80, 34)
	GUI:setIgnoreContentAdaptWithSize(btnOk, false)
	GUI:Button_setTitleText(btnOk, "")
	GUI:Button_setTitleColor(btnOk, "#414146")
	GUI:Button_setTitleFontSize(btnOk, 14)
	GUI:Button_titleDisableOutLine(btnOk)
	GUI:setAnchorPoint(btnOk, 0.50, 0.50)
	GUI:setTouchEnabled(btnOk, true)
	GUI:setTag(btnOk, 311)

	-- Create pnlShow
	local pnlShow = GUI:Layout_Create(PMainUI, "pnlShow", 128.00, 271.00, 126.00, 200.00, false)
	GUI:setAnchorPoint(pnlShow, 0.50, 1.00)
	GUI:setTouchEnabled(pnlShow, true)
	GUI:setTag(pnlShow, 299)

	-- Create pnlShowBg
	local pnlShowBg = GUI:Image_Create(pnlShow, "pnlShowBg", 63.00, 200.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(pnlShowBg, 21, 21, 21, 21)
	GUI:setContentSize(pnlShowBg, 126, 200)
	GUI:setIgnoreContentAdaptWithSize(pnlShowBg, false)
	GUI:setAnchorPoint(pnlShowBg, 0.50, 1.00)
	GUI:setTouchEnabled(pnlShowBg, false)
	GUI:setTag(pnlShowBg, 300)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(pnlShow, "ListView_1", 63.00, 195.00, 118.00, 190.00, 1)
	GUI:ListView_setBounceEnabled(ListView_1, true)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:ListView_setItemsMargin(ListView_1, 1)
	GUI:setAnchorPoint(ListView_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 301)

	-- Create item
	local item = GUI:Layout_Create(pnlShow, "item", 59.00, 119.00, 113.28, 30.00, false)
	GUI:Layout_setBackGroundColorType(item, 1)
	GUI:Layout_setBackGroundColor(item, "#000000")
	GUI:Layout_setBackGroundColorOpacity(item, 255)
	GUI:setAnchorPoint(item, 0.50, 1.00)
	GUI:setTouchEnabled(item, true)
	GUI:setTag(item, 302)
	GUI:setVisible(item, false)

	-- Create imgSelect
	local imgSelect = GUI:Image_Create(item, "imgSelect", 56.00, 30.00, "res/public/1900000678.png")
	GUI:setContentSize(imgSelect, 113.2799987793, 30)
	GUI:setIgnoreContentAdaptWithSize(imgSelect, false)
	GUI:setAnchorPoint(imgSelect, 0.50, 1.00)
	GUI:setTouchEnabled(imgSelect, false)
	GUI:setTag(imgSelect, 303)

	-- Create Text
	local Text = GUI:Text_Create(item, "Text", 56.00, 15.00, 16, "#ffffff", [[全部]])
	GUI:setAnchorPoint(Text, 0.50, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, 304)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui