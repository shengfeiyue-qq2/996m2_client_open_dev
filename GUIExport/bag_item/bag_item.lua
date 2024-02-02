local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "背包物品节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 60.00, 60.00, false)
	GUI:setChineseName(Panel_bg, "背包物品组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 21)

	-- Create Node_sfx_under
	local Node_sfx_under = GUI:Node_Create(Panel_bg, "Node_sfx_under", 30.00, 30.00)
	GUI:setChineseName(Node_sfx_under, "背包物品_下层特效_节点")
	GUI:setAnchorPoint(Node_sfx_under, 0.50, 0.50)
	GUI:setTag(Node_sfx_under, 11)
	GUI:setVisible(Node_sfx_under, false)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 30.00, 30.00, "res/private/gui_edit/Button_Normal.png")
	GUI:setContentSize(Button_icon, 50, 50)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#414146")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleDisableOutLine(Button_icon)
	GUI:setChineseName(Button_icon, "背包物品_图标")
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, false)
	GUI:setTag(Button_icon, 23)

	-- Create Node_sfx
	local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 30.00, 30.00)
	GUI:setChineseName(Node_sfx, "背包物品_上层特效_节点")
	GUI:setAnchorPoint(Node_sfx, 0.50, 0.50)
	GUI:setTag(Node_sfx, 12)
	GUI:setVisible(Node_sfx, false)

	-- Create Image_choosTag
	local Image_choosTag = GUI:Image_Create(Panel_bg, "Image_choosTag", 30.00, 30.00, "res/public/1900000678_2.png")
	GUI:setContentSize(Image_choosTag, 60, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_choosTag, false)
	GUI:setChineseName(Image_choosTag, "背包物品_勾选时_图片")
	GUI:setAnchorPoint(Image_choosTag, 0.50, 0.50)
	GUI:setTouchEnabled(Image_choosTag, false)
	GUI:setTag(Image_choosTag, 13)
	GUI:setVisible(Image_choosTag, false)

	-- Create Image_bindLock
	local Image_bindLock = GUI:Image_Create(Panel_bg, "Image_bindLock", 12.00, 12.00, "res/public/lock.png")
	GUI:setChineseName(Image_bindLock, "背包物品_绑定_图片")
	GUI:setAnchorPoint(Image_bindLock, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bindLock, false)
	GUI:setTag(Image_bindLock, 13)
	GUI:setVisible(Image_bindLock, false)

	-- Create Image_redMask
	local Image_redMask = GUI:Image_Create(Panel_bg, "Image_redMask", 30.00, 30.00, "res/public/icon_zhezhao_02025.png")
	GUI:setChineseName(Image_redMask, "背包物品_红色遮罩")
	GUI:setAnchorPoint(Image_redMask, 0.50, 0.50)
	GUI:setTouchEnabled(Image_redMask, false)
	GUI:setTag(Image_redMask, 13)
	GUI:setVisible(Image_redMask, false)
end
return ui