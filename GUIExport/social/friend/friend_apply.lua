local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "好友申请场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 546.00, 325.00, false)
	GUI:setChineseName(Panel_1, "好友申请组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 72)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 273.00, 162.00, "res/public/bg_npc_10.jpg")
	GUI:Image_setScale9Slice(Image_bg, 15, 15, 16, 14)
	GUI:setContentSize(Image_bg, 546, 325)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "好友申请_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 73)

	-- Create Image_list_bg
	local Image_list_bg = GUI:Image_Create(Panel_1, "Image_list_bg", 270.00, 162.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(Image_list_bg, 24, 24, 10, 10)
	GUI:setContentSize(Image_list_bg, 492, 226)
	GUI:setIgnoreContentAdaptWithSize(Image_list_bg, false)
	GUI:setChineseName(Image_list_bg, "好友申请_申请列表_背景图")
	GUI:setAnchorPoint(Image_list_bg, 0.50, 0.50)
	GUI:setRotation(Image_list_bg, 360.00)
	GUI:setRotationSkewX(Image_list_bg, 360.00)
	GUI:setRotationSkewY(Image_list_bg, 360.00)
	GUI:setTouchEnabled(Image_list_bg, false)
	GUI:setTag(Image_list_bg, 74)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 273.00, 294.00, "res/private/friend/word_haoyou_06.png")
	GUI:setChineseName(Image_title, "好友申请_标题_图片")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 75)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 559.00, 304.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "好友申请_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 79)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_1, "ListView", 26.00, 49.00, 490.00, 225.00, 1)
	GUI:ListView_setGravity(ListView, 2)
	GUI:setChineseName(ListView, "好友申请_申请列表")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 80)

	-- Create Text_close_title
	local Text_close_title = GUI:Text_Create(Panel_1, "Text_close_title", 445.00, 32.00, 16, "#28ef01", [[关闭后信息将被清空]])
	GUI:setChineseName(Text_close_title, "好友申请_关闭标题_文本")
	GUI:setAnchorPoint(Text_close_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_close_title, false)
	GUI:setTag(Text_close_title, 83)
	GUI:Text_enableOutline(Text_close_title, "#111111", 1)
end
return ui