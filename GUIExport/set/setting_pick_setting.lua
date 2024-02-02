local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "拾取列表_场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancle
	local Panel_cancle = GUI:Layout_Create(Scene, "Panel_cancle", 0.00, 0.00, 3000.00, 3000.00, false)
	GUI:Layout_setBackGroundColorType(Panel_cancle, 1)
	GUI:Layout_setBackGroundColor(Panel_cancle, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cancle, 73)
	GUI:setChineseName(Panel_cancle, "拾取设置_范围点击关闭")
	GUI:setTouchEnabled(Panel_cancle, true)
	GUI:setTag(Panel_cancle, 89)

	-- Create Panel_1
	local Panel_1 = GUI:Image_Create(Scene, "Panel_1", 568.00, 320.00, "res/public/bg_npc_02.png")
	GUI:Image_setScale9Slice(Panel_1, 12, 10, 1, 1)
	GUI:setContentSize(Panel_1, 752, 467)
	GUI:setIgnoreContentAdaptWithSize(Panel_1, false)
	GUI:setChineseName(Panel_1, "拾取列表_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 141)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 765.00, 446.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_loadTextureDisabled(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "拾取列表_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 56)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 376.00, 481.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_title, 33, 33, 9, 9)
	GUI:setContentSize(Image_title, 136, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_title, false)
	GUI:setChineseName(Image_title, "拾取列表_标题组合")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 150)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Image_title, "Text_1", 68.00, 14.00, 20, "#ffffff", [[拾取列表]])
	GUI:setChineseName(Text_1, "拾取列表_标题_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 151)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 9.00, 10.00)
	GUI:setChineseName(Node_1, "拾取列表_节点")
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 68)
end
return ui