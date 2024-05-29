local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "任务节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_assist
	local Panel_assist = GUI:Layout_Create(Node, "Panel_assist", 0.00, 0.00, 244.00, 188.00, false)
	GUI:setChineseName(Panel_assist, "任务_组合")
	GUI:setAnchorPoint(Panel_assist, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_assist, true)
	GUI:setTag(Panel_assist, 50)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_assist, "Panel_content", 42.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_content, "任务详细面板")
	GUI:setTouchEnabled(Panel_content, true)
	GUI:setTag(Panel_content, 59)

	-- Create Image_25
	local Image_25 = GUI:Image_Create(Panel_content, "Image_25", 101.00, 94.00, "res/private/main/assist/1900012571.png")
	GUI:setChineseName(Image_25, "任务详细_背景图")
	GUI:setAnchorPoint(Image_25, 0.50, 0.50)
	GUI:setTouchEnabled(Image_25, false)
	GUI:setTag(Image_25, 75)

	-- Create Panel_mission
	local Panel_mission = GUI:Layout_Create(Panel_content, "Panel_mission", 0.00, 0.00, 202.00, 188.00, false)
	GUI:setChineseName(Panel_mission, "任务详细组合")
	GUI:setTouchEnabled(Panel_mission, true)
	GUI:setTag(Panel_mission, 63)

	-- Create ListView_mission
	local ListView_mission = GUI:ListView_Create(Panel_mission, "ListView_mission", 101.00, 94.00, 200.00, 185.00, 1)
	GUI:setChineseName(ListView_mission, "任务详细_列表")
	GUI:setAnchorPoint(ListView_mission, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_mission, true)
	GUI:setTag(ListView_mission, 85)

	-- Create Panel_group
	local Panel_group = GUI:Layout_Create(Panel_assist, "Panel_group", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(Panel_group, "队伍组合")
	GUI:setTouchEnabled(Panel_group, true)
	GUI:setTag(Panel_group, 224)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_group, "Panel_content", 0.00, 0.00, 42.00, 188.00, false)
	GUI:setChineseName(Panel_content, "任务_任务_点击切换内容")
	GUI:setTouchEnabled(Panel_content, true)
	GUI:setTag(Panel_content, 225)

	-- Create Button_mission
	local Button_mission = GUI:Button_Create(Panel_content, "Button_mission", 21.00, 105.00, "res/private/main/assist/1900012554.png")
	GUI:Button_loadTexturePressed(Button_mission, "res/private/main/assist/1900012554.png")
	GUI:Button_setTitleText(Button_mission, "")
	GUI:Button_setTitleColor(Button_mission, "#414146")
	GUI:Button_setTitleFontSize(Button_mission, 14)
	GUI:Button_titleDisableOutLine(Button_mission)
	GUI:setChineseName(Button_mission, "任务_按钮")
	GUI:setAnchorPoint(Button_mission, 0.50, 0.00)
	GUI:setTouchEnabled(Button_mission, true)
	GUI:setTag(Button_mission, 226)

	-- Create Button_near
	local Button_near = GUI:Button_Create(Panel_content, "Button_near", 21.00, 83.00, "res/private/main/assist/near2.png")
	GUI:Button_loadTexturePressed(Button_near, "res/private/main/assist/near1.png")
	GUI:setContentSize(Button_near, 39, 85)
	GUI:setIgnoreContentAdaptWithSize(Button_near, false)
	GUI:Button_setTitleText(Button_near, "")
	GUI:Button_setTitleColor(Button_near, "#414146")
	GUI:Button_setTitleFontSize(Button_near, 14)
	GUI:Button_titleDisableOutLine(Button_near)
	GUI:setChineseName(Button_near, "附近_按钮")
	GUI:setAnchorPoint(Button_near, 0.50, 1.00)
	GUI:setTouchEnabled(Button_near, true)
	GUI:setTag(Button_near, 227)

	-- Create Button_change
	local Button_change = GUI:Button_Create(Panel_group, "Button_change", 21.00, 94.00, "res/private/main/assist/1900012558.png")
	GUI:Button_loadTexturePressed(Button_change, "res/private/main/assist/1900012559.png")
	GUI:Button_setScale9Slice(Button_change, 15, 15, 12, 10)
	GUI:setContentSize(Button_change, 40, 41)
	GUI:setIgnoreContentAdaptWithSize(Button_change, false)
	GUI:Button_setTitleText(Button_change, "")
	GUI:Button_setTitleColor(Button_change, "#414146")
	GUI:Button_setTitleFontSize(Button_change, 14)
	GUI:Button_titleDisableOutLine(Button_change)
	GUI:setChineseName(Button_change, "任务_切换_按钮")
	GUI:setAnchorPoint(Button_change, 0.50, 0.50)
	GUI:setTouchEnabled(Button_change, true)
	GUI:setTag(Button_change, 234)

	-- Create Panel_hide
	local Panel_hide = GUI:Layout_Create(Node, "Panel_hide", 245.00, 0.00, 21.00, 188.00, false)
	GUI:setChineseName(Panel_hide, "任务伸缩组合")
	GUI:setAnchorPoint(Panel_hide, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_hide, true)
	GUI:setTag(Panel_hide, 60)

	-- Create Image_24
	local Image_24 = GUI:Image_Create(Panel_hide, "Image_24", 10.50, 94.00, "res/private/main/assist/1900012573.png")
	GUI:setChineseName(Image_24, "任务伸缩_背景图")
	GUI:setAnchorPoint(Image_24, 0.50, 0.50)
	GUI:setTouchEnabled(Image_24, false)
	GUI:setTag(Image_24, 61)

	-- Create Button_hide
	local Button_hide = GUI:Button_Create(Panel_hide, "Button_hide", 10.50, 94.00, "res/private/main/assist/1900012566.png")
	GUI:Button_setScale9Slice(Button_hide, 3, 3, 11, 11)
	GUI:setContentSize(Button_hide, 12, 46)
	GUI:setIgnoreContentAdaptWithSize(Button_hide, false)
	GUI:Button_setTitleText(Button_hide, "")
	GUI:Button_setTitleColor(Button_hide, "#414146")
	GUI:Button_setTitleFontSize(Button_hide, 14)
	GUI:Button_titleDisableOutLine(Button_hide)
	GUI:setChineseName(Button_hide, "任务伸缩_缩进")
	GUI:setAnchorPoint(Button_hide, 0.50, 0.50)
	GUI:setTouchEnabled(Button_hide, true)
	GUI:setTag(Button_hide, 62)
end
return ui