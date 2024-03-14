local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "聊天_主节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "聊天_范围关闭区域")
	GUI:setAnchorPoint(Panel_1, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 54)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Node, "Panel_2", 0.00, 207.00, 371.00, 293.00, false)
	GUI:setChineseName(Panel_2, "聊天_扩展组合框")
	GUI:setAnchorPoint(Panel_2, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 89)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_2, "Image_bg", 0.00, 0.00, "res/private/chat/1900012804.png")
	GUI:Image_setScale9Slice(Image_bg, 20, 20, 20, 20)
	GUI:setContentSize(Image_bg, 371, 293)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "聊天_扩展背景_图片")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 408)

	-- Create Panel_group
	local Panel_group = GUI:Layout_Create(Panel_2, "Panel_group", 371.00, 5.00, 371.00, 60.00, false)
	GUI:setChineseName(Panel_group, "聊天_扩展组件_分组")
	GUI:setAnchorPoint(Panel_group, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_group, true)
	GUI:setTag(Panel_group, 401)

	-- Create Button_quick
	local Button_quick = GUI:Button_Create(Panel_group, "Button_quick", 74.00, 30.00, "res/private/chat/1900012861.png")
	GUI:Button_loadTexturePressed(Button_quick, "res/private/chat/1900012860.png")
	GUI:Button_setScale9Slice(Button_quick, 15, 15, 12, 10)
	GUI:setContentSize(Button_quick, 39, 41)
	GUI:setIgnoreContentAdaptWithSize(Button_quick, false)
	GUI:Button_setTitleText(Button_quick, "")
	GUI:Button_setTitleColor(Button_quick, "#414146")
	GUI:Button_setTitleFontSize(Button_quick, 14)
	GUI:Button_titleDisableOutLine(Button_quick)
	GUI:setChineseName(Button_quick, "聊天_扩展组件_历史内容")
	GUI:setAnchorPoint(Button_quick, 0.50, 0.50)
	GUI:setTouchEnabled(Button_quick, true)
	GUI:setTag(Button_quick, 407)

	-- Create Button_emoji
	local Button_emoji = GUI:Button_Create(Panel_group, "Button_emoji", 148.00, 30.00, "res/private/chat/1900012853.png")
	GUI:Button_loadTexturePressed(Button_emoji, "res/private/chat/1900012852.png")
	GUI:Button_setScale9Slice(Button_emoji, 15, 15, 12, 10)
	GUI:setContentSize(Button_emoji, 39, 41)
	GUI:setIgnoreContentAdaptWithSize(Button_emoji, false)
	GUI:Button_setTitleText(Button_emoji, "")
	GUI:Button_setTitleColor(Button_emoji, "#414146")
	GUI:Button_setTitleFontSize(Button_emoji, 14)
	GUI:Button_titleDisableOutLine(Button_emoji)
	GUI:setChineseName(Button_emoji, "聊天_扩展组件_表情按钮")
	GUI:setAnchorPoint(Button_emoji, 0.50, 0.50)
	GUI:setTouchEnabled(Button_emoji, true)
	GUI:setTag(Button_emoji, 403)

	-- Create Button_items
	local Button_items = GUI:Button_Create(Panel_group, "Button_items", 222.00, 30.00, "res/private/chat/1900012857.png")
	GUI:Button_loadTexturePressed(Button_items, "res/private/chat/1900012856.png")
	GUI:Button_setScale9Slice(Button_items, 15, 15, 12, 10)
	GUI:setContentSize(Button_items, 39, 41)
	GUI:setIgnoreContentAdaptWithSize(Button_items, false)
	GUI:Button_setTitleText(Button_items, "")
	GUI:Button_setTitleColor(Button_items, "#414146")
	GUI:Button_setTitleFontSize(Button_items, 14)
	GUI:Button_titleDisableOutLine(Button_items)
	GUI:setChineseName(Button_items, "聊天_扩展组件_背包物品")
	GUI:setAnchorPoint(Button_items, 0.50, 0.50)
	GUI:setTouchEnabled(Button_items, true)
	GUI:setTag(Button_items, 406)

	-- Create Button_position
	local Button_position = GUI:Button_Create(Panel_group, "Button_position", 296.00, 30.00, "res/private/chat/1900012858.png")
	GUI:Button_setScale9Slice(Button_position, 15, 15, 12, 10)
	GUI:setContentSize(Button_position, 39, 41)
	GUI:setIgnoreContentAdaptWithSize(Button_position, false)
	GUI:Button_setTitleText(Button_position, "")
	GUI:Button_setTitleColor(Button_position, "#414146")
	GUI:Button_setTitleFontSize(Button_position, 14)
	GUI:Button_titleDisableOutLine(Button_position)
	GUI:setChineseName(Button_position, "聊天_扩展组件_当前位置")
	GUI:setAnchorPoint(Button_position, 0.50, 0.50)
	GUI:setTouchEnabled(Button_position, true)
	GUI:setTag(Button_position, 405)

	-- Create Panel_quick
	local Panel_quick = GUI:Layout_Create(Panel_2, "Panel_quick", 20.00, 68.00, 330.00, 211.00, false)
	GUI:setChineseName(Panel_quick, "聊天_扩展组件_聊天组合")
	GUI:setTouchEnabled(Panel_quick, true)
	GUI:setTag(Panel_quick, 32)

	-- Create ScrollView_content
	local ScrollView_content = GUI:ScrollView_Create(Panel_quick, "ScrollView_content", 165.00, 0.00, 330.00, 211.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_content, 330.00, 211.00)
	GUI:setChineseName(ScrollView_content, "聊天_扩展组件_聊天展示")
	GUI:setAnchorPoint(ScrollView_content, 0.50, 0.00)
	GUI:setTouchEnabled(ScrollView_content, true)
	GUI:setTag(ScrollView_content, 33)
	GUI:setVisible(ScrollView_content, false)

	-- Create Panel_emoji
	local Panel_emoji = GUI:Layout_Create(Panel_2, "Panel_emoji", 20.00, 68.00, 330.00, 211.00, false)
	GUI:setChineseName(Panel_emoji, "聊天_扩展组件_表情组合")
	GUI:setTouchEnabled(Panel_emoji, true)
	GUI:setTag(Panel_emoji, 409)

	-- Create ScrollView_content
	local ScrollView_content = GUI:ScrollView_Create(Panel_emoji, "ScrollView_content", 165.00, 0.00, 330.00, 211.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_content, 330.00, 211.00)
	GUI:setChineseName(ScrollView_content, "聊天_扩展组件_表情展示")
	GUI:setAnchorPoint(ScrollView_content, 0.50, 0.00)
	GUI:setTouchEnabled(ScrollView_content, true)
	GUI:setTag(ScrollView_content, 410)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_2, "Panel_items", 20.00, 68.00, 330.00, 211.00, false)
	GUI:setChineseName(Panel_items, "聊天_扩展组件_物品组合")
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 30)

	-- Create ScrollView_content
	local ScrollView_content = GUI:ScrollView_Create(Panel_items, "ScrollView_content", 165.00, 0.00, 330.00, 211.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_content, 330.00, 211.00)
	GUI:setChineseName(ScrollView_content, "聊天_扩展组件_物品组合")
	GUI:setAnchorPoint(ScrollView_content, 0.50, 0.00)
	GUI:setTouchEnabled(ScrollView_content, true)
	GUI:setTag(ScrollView_content, 31)
end
return ui