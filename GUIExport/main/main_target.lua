local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 3.00, 190.00)
	GUI:setChineseName(Node, "选中目标节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 3.00, 0.00, 210.00, 37.00, false)
	GUI:setChineseName(Panel_1, "选中目标_组合")
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, -1)

	-- Create icon
	local icon = GUI:Image_Create(Panel_1, "icon", 18.00, 18.00, "res/private/main/Target/1900012534.png")
	GUI:setChineseName(icon, "选中目标_图标")
	GUI:setAnchorPoint(icon, 0.50, 0.50)
	GUI:setTouchEnabled(icon, false)
	GUI:setTag(icon, -1)

	-- Create nameBg
	local nameBg = GUI:Image_Create(Panel_1, "nameBg", 105.00, 35.00, "res/private/main/Target/1900012531.png")
	GUI:setChineseName(nameBg, "选中目标_目标名称_背景图")
	GUI:setAnchorPoint(nameBg, 0.50, 1.00)
	GUI:setTouchEnabled(nameBg, false)
	GUI:setTag(nameBg, -1)

	-- Create nameText
	local nameText = GUI:Text_Create(Panel_1, "nameText", 105.00, 27.00, 16, "#ffffff", [[目标名称]])
	GUI:setChineseName(nameText, "选中目标_目标名称")
	GUI:setAnchorPoint(nameText, 0.50, 0.50)
	GUI:setTouchEnabled(nameText, false)
	GUI:setTag(nameText, -1)
	GUI:Text_enableOutline(nameText, "#111111", 1)

	-- Create Image_hp
	local Image_hp = GUI:Image_Create(Panel_1, "Image_hp", 105.00, 8.00, "res/private/main/Target/1900012530.png")
	GUI:setChineseName(Image_hp, "选中目标_目标Hp_背景框")
	GUI:setAnchorPoint(Image_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hp, false)
	GUI:setTag(Image_hp, -1)

	-- Create hpLoadingBar
	local hpLoadingBar = GUI:LoadingBar_Create(Panel_1, "hpLoadingBar", 105.00, 8.00, "res/private/main/Target/1900012532.png", 0)
	GUI:LoadingBar_setPercent(hpLoadingBar, 50)
	GUI:LoadingBar_setColor(hpLoadingBar, "#ffffff")
	GUI:setChineseName(hpLoadingBar, "选中目标_目标Hp")
	GUI:setAnchorPoint(hpLoadingBar, 0.50, 0.50)
	GUI:setTouchEnabled(hpLoadingBar, false)
	GUI:setTag(hpLoadingBar, -1)

	-- Create hpText
	local hpText = GUI:Text_Create(Panel_1, "hpText", 105.00, 9.00, 16, "#ffffff", [[100%]])
	GUI:setChineseName(hpText, "选中目标_目标Hp_%比")
	GUI:setAnchorPoint(hpText, 0.50, 0.50)
	GUI:setTouchEnabled(hpText, false)
	GUI:setTag(hpText, -1)
	GUI:Text_enableOutline(hpText, "#111111", 1)

	-- Create cleanBtn
	local cleanBtn = GUI:Button_Create(Panel_1, "cleanBtn", 235.00, 18.00, "res/private/main/Target/btn_gban_01.png")
	GUI:Button_setTitleText(cleanBtn, "")
	GUI:Button_setTitleColor(cleanBtn, "#ffffff")
	GUI:Button_setTitleFontSize(cleanBtn, 10)
	GUI:Button_titleEnableOutline(cleanBtn, "#000000", 0)
	GUI:setChineseName(cleanBtn, "选中目标_关闭_按钮")
	GUI:setAnchorPoint(cleanBtn, 0.50, 0.50)
	GUI:setTouchEnabled(cleanBtn, true)
	GUI:setTag(cleanBtn, -1)

	-- Create LockPanel
	local LockPanel = GUI:Layout_Create(Panel_1, "LockPanel", 160.00, 0.00, 60.00, 37.00, false)
	GUI:setChineseName(LockPanel, "选中目标_锁定组合")
	GUI:setTouchEnabled(LockPanel, true)
	GUI:setTag(LockPanel, -1)

	-- Create LockBtn
	local LockBtn = GUI:Button_Create(LockPanel, "LockBtn", 38.00, 19.00, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTexturePressed(LockBtn, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTextureDisabled(LockBtn, "res/private/player_hero/btn_heji_05_1.png")
	GUI:Button_setTitleText(LockBtn, "")
	GUI:Button_setTitleColor(LockBtn, "#ffffff")
	GUI:Button_setTitleFontSize(LockBtn, 10)
	GUI:Button_titleEnableOutline(LockBtn, "#000000", 0)
	GUI:setChineseName(LockBtn, "选中目标_锁定_按钮")
	GUI:setAnchorPoint(LockBtn, 0.50, 0.50)
	GUI:setScaleX(LockBtn, 0.80)
	GUI:setScaleY(LockBtn, 0.80)
	GUI:setTouchEnabled(LockBtn, false)
	GUI:setTag(LockBtn, -1)
end
return ui