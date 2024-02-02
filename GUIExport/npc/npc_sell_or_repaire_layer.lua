local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "出售节点")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 545.00, 465.00, 180.00, 205.00, false)
	GUI:setChineseName(Panel_1, "出售_组合")
	GUI:setAnchorPoint(Panel_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 52)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 180.00, 205.00, "res/public/bg_npc_03.png")
	GUI:setChineseName(Image_bg, "出售_背景图")
	GUI:setAnchorPoint(Image_bg, 1.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 53)

	-- Create Text_way
	local Text_way = GUI:Text_Create(Panel_1, "Text_way", 38.00, 184.00, 16, "#ffffff", [[出售：]])
	GUI:setChineseName(Text_way, "出售_出售_文本")
	GUI:setAnchorPoint(Text_way, 0.00, 0.50)
	GUI:setTouchEnabled(Text_way, false)
	GUI:setTag(Text_way, 54)
	GUI:Text_enableOutline(Text_way, "#111111", 1)

	-- Create Text_price
	local Text_price = GUI:Text_Create(Panel_1, "Text_price", 83.00, 182.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_price, "出售_价格_文本")
	GUI:setAnchorPoint(Text_price, 0.00, 0.50)
	GUI:setTouchEnabled(Text_price, false)
	GUI:setTag(Text_price, 55)
	GUI:Text_enableOutline(Text_price, "#111111", 1)

	-- Create Node_item
	local Node_item = GUI:Node_Create(Panel_1, "Node_item", 108.00, 98.00)
	GUI:setChineseName(Node_item, "出售_物品节点")
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTag(Node_item, 56)

	-- Create Button_ok
	local Button_ok = GUI:Button_Create(Panel_1, "Button_ok", 156.00, 44.00, "res/public/btn_npcsm_01.png")
	GUI:Button_loadTexturePressed(Button_ok, "res/public/btn_npcsm_02.png")
	GUI:Button_setScale9Slice(Button_ok, 15, 15, 4, 4)
	GUI:setContentSize(Button_ok, 70, 70)
	GUI:setIgnoreContentAdaptWithSize(Button_ok, false)
	GUI:Button_setTitleText(Button_ok, "确定")
	GUI:Button_setTitleColor(Button_ok, "#ffffff")
	GUI:Button_setTitleFontSize(Button_ok, 16)
	GUI:Button_titleEnableOutline(Button_ok, "#111111", 1)
	GUI:setChineseName(Button_ok, "出售_确认_按钮")
	GUI:setAnchorPoint(Button_ok, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ok, true)
	GUI:setTag(Button_ok, 57)

	-- Create Panel_touchEvents
	local Panel_touchEvents = GUI:Layout_Create(Panel_1, "Panel_touchEvents", 59.00, 46.00, 100.00, 100.00, false)
	GUI:setChineseName(Panel_touchEvents, "出售_触摸事件")
	GUI:setTouchEnabled(Panel_touchEvents, false)
	GUI:setTag(Panel_touchEvents, 37)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 190.00, 181.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 6, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "出售_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 58)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.00, 40.00, 26.00, 40.00, false)
	GUI:setChineseName(TouchSize, "出售_触摸关闭区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 59)
	GUI:setVisible(TouchSize, false)
end
return ui