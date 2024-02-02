local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 3)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/main_monster_ui/00000.png")
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 4)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_1, "Image_icon", 47.00, -41.00, "res/private/main_monster_ui/monster/00001.png")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 5)

	-- Create Text_lv
	local Text_lv = GUI:Text_Create(Panel_1, "Text_lv", 45.00, -92.00, 16, "#ffffff", [[LV.12]])
	GUI:setAnchorPoint(Text_lv, 0.50, 0.50)
	GUI:setTouchEnabled(Text_lv, false)
	GUI:setTag(Text_lv, 6)
	GUI:Text_enableOutline(Text_lv, "#111111", 1)

	-- Create Text_belong
	local Text_belong = GUI:Text_Create(Panel_1, "Text_belong", 90.00, -70.00, 16, "#ffffff", [[归属：]])
	GUI:setAnchorPoint(Text_belong, 0.00, 0.50)
	GUI:setTouchEnabled(Text_belong, false)
	GUI:setTag(Text_belong, 7)
	GUI:Text_enableOutline(Text_belong, "#111111", 1)

	-- Create Text_belong_name
	local Text_belong_name = GUI:Text_Create(Panel_1, "Text_belong_name", 135.00, -70.00, 16, "#ffffff", [[玩家6个字名]])
	GUI:setAnchorPoint(Text_belong_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_belong_name, false)
	GUI:setTag(Text_belong_name, 8)
	GUI:Text_enableOutline(Text_belong_name, "#111111", 1)

	-- Create Text_monster_name
	local Text_monster_name = GUI:Text_Create(Panel_1, "Text_monster_name", 91.00, -25.00, 16, "#ffffff", [[怪物6个字名字]])
	GUI:setAnchorPoint(Text_monster_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_monster_name, false)
	GUI:setTag(Text_monster_name, 9)
	GUI:Text_enableOutline(Text_monster_name, "#000000", 1)

	-- Create Image_loading_bg
	local Image_loading_bg = GUI:Image_Create(Panel_1, "Image_loading_bg", 89.00, -47.00, "res/private/main_monster_ui/hp/10.png")
	GUI:setAnchorPoint(Image_loading_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_loading_bg, false)
	GUI:setTag(Image_loading_bg, 13)

	-- Create Panel_loding_hp_tx
	local Panel_loding_hp_tx = GUI:Layout_Create(Panel_1, "Panel_loding_hp_tx", 89.00, -37.00, 295.00, 20.00, false)
	GUI:setAnchorPoint(Panel_loding_hp_tx, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_loding_hp_tx, true)
	GUI:setTag(Panel_loding_hp_tx, 19)

	-- Create LoadingBar_hp_bar
	local LoadingBar_hp_bar = GUI:LoadingBar_Create(Panel_1, "LoadingBar_hp_bar", 89.00, -47.00, "res/private/gui_edit/LoadingBar.png", 0)
	GUI:setContentSize(LoadingBar_hp_bar, 296, 21)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_hp_bar, false)
	GUI:LoadingBar_setPercent(LoadingBar_hp_bar, 100)
	GUI:LoadingBar_setColor(LoadingBar_hp_bar, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_hp_bar, 0.00, 0.50)
	GUI:setTouchEnabled(LoadingBar_hp_bar, false)
	GUI:setTag(LoadingBar_hp_bar, 29)

	-- Create Node_bar_tip
	local Node_bar_tip = GUI:Node_Create(Panel_1, "Node_bar_tip", 89.00, -47.00)
	GUI:setAnchorPoint(Node_bar_tip, 0.50, 0.50)
	GUI:setTag(Node_bar_tip, 18)

	-- Create Panel_bar_hp_tx
	local Panel_bar_hp_tx = GUI:Layout_Create(Panel_1, "Panel_bar_hp_tx", 89.00, -37.00, 295.00, 20.00, false)
	GUI:setAnchorPoint(Panel_bar_hp_tx, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_bar_hp_tx, true)
	GUI:setTag(Panel_bar_hp_tx, 18)

	-- Create Text_hp
	local Text_hp = GUI:Text_Create(Panel_1, "Text_hp", 96.00, -47.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_hp, 0.00, 0.50)
	GUI:setTouchEnabled(Text_hp, false)
	GUI:setTag(Text_hp, 13)
	GUI:Text_enableOutline(Text_hp, "#111111", 1)

	-- Create Panel_hp_tip
	local Panel_hp_tip = GUI:Layout_Create(Panel_1, "Panel_hp_tip", 378.00, -47.00, 287.00, 21.00, true)
	GUI:setAnchorPoint(Panel_hp_tip, 1.00, 0.50)
	GUI:setTouchEnabled(Panel_hp_tip, false)
	GUI:setTag(Panel_hp_tip, 15)

	-- Create Text_hp_tip
	local Text_hp_tip = GUI:Text_Create(Panel_hp_tip, "Text_hp_tip", 287.00, 10.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(Text_hp_tip, 1.00, 0.50)
	GUI:setTouchEnabled(Text_hp_tip, false)
	GUI:setTag(Text_hp_tip, 12)
	GUI:Text_enableOutline(Text_hp_tip, "#111111", 1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 303.00, -20.00, "res/private/main_monster_ui/close1.png")
	GUI:Button_loadTexturePressed(Button_close, "res/private/main_monster_ui/close2.png")
	GUI:Button_setScale9Slice(Button_close, 19, 17, 11, 26)
	GUI:setContentSize(Button_close, 37, 38)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 19)

	-- Create LockBtn
	local LockBtn = GUI:Button_Create(Panel_1, "LockBtn", 425.00, -51.00, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTexturePressed(LockBtn, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTextureDisabled(LockBtn, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_setScale9Slice(LockBtn, 15, 15, 4, 4)
	GUI:setContentSize(LockBtn, 59, 59)
	GUI:setIgnoreContentAdaptWithSize(LockBtn, false)
	GUI:Button_setTitleText(LockBtn, "")
	GUI:Button_setTitleColor(LockBtn, "#414146")
	GUI:Button_setTitleFontSize(LockBtn, 14)
	GUI:Button_titleDisableOutLine(LockBtn)
	GUI:setAnchorPoint(LockBtn, 0.50, 0.50)
	GUI:setTouchEnabled(LockBtn, true)
	GUI:setTag(LockBtn, 29)
end
return ui