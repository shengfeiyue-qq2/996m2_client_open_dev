local ui = {}
function ui.init(parent)
	-- Create Main_Target_Big_Hp
	local Main_Target_Big_Hp = GUI:Layout_Create(parent, "Main_Target_Big_Hp", 0.00, 0.00, 0.00, 0.00, false)
	GUI:Layout_setBackGroundColorType(Main_Target_Big_Hp, 1)
	GUI:Layout_setBackGroundColor(Main_Target_Big_Hp, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(Main_Target_Big_Hp, 140.0)
	GUI:setTouchEnabled(Main_Target_Big_Hp, false)
	GUI:setTag(Main_Target_Big_Hp, -1.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Main_Target_Big_Hp, "Panel_1", -200.00, 0.00, 0.00, 0.00, false)
	GUI:setChineseName(Panel_1, "怪物大血条_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 3.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/main_monster_ui/00000.png")
	GUI:setChineseName(Image_bg, "怪物大血条_背景图")
	GUI:setAnchorPoint(Image_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 4.0)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Panel_1, "Image_icon", 47.00, -41.00, "res/private/main_monster_ui/monster/00001.png")
	GUI:setChineseName(Image_icon, "怪物大血条_怪物图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, true)
	GUI:setTag(Image_icon, 5.0)

	-- Create Text_lv
	local Text_lv = GUI:Text_Create(Panel_1, "Text_lv", 45.00, -92.00, 16.0, "#ffffff", [[LV.12]])
	GUI:setChineseName(Text_lv, "怪物大血条_等级")
	GUI:setAnchorPoint(Text_lv, 0.50, 0.50)
	GUI:setTouchEnabled(Text_lv, false)
	GUI:setTag(Text_lv, 6.0)
	GUI:Text_enableOutline(Text_lv, "#111111", 1.0)

	-- Create Text_belong
	local Text_belong = GUI:Text_Create(Panel_1, "Text_belong", 90.00, -70.00, 16.0, "#ffffff", [[归属：]])
	GUI:setChineseName(Text_belong, "怪物大血条_归属_文本")
	GUI:setAnchorPoint(Text_belong, 0.00, 0.50)
	GUI:setTouchEnabled(Text_belong, false)
	GUI:setTag(Text_belong, 7.0)
	GUI:Text_enableOutline(Text_belong, "#111111", 1.0)

	-- Create Text_belong_name
	local Text_belong_name = GUI:Text_Create(Panel_1, "Text_belong_name", 135.00, -70.00, 16.0, "#ffffff", [[玩家6个字名]])
	GUI:setChineseName(Text_belong_name, "怪物大血条_归属对象_文本")
	GUI:setAnchorPoint(Text_belong_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_belong_name, false)
	GUI:setTag(Text_belong_name, 8.0)
	GUI:Text_enableOutline(Text_belong_name, "#111111", 1.0)

	-- Create Text_monster_name
	local Text_monster_name = GUI:Text_Create(Panel_1, "Text_monster_name", 91.00, -25.00, 16.0, "#ffffff", [[怪物6个字名字]])
	GUI:setChineseName(Text_monster_name, "怪物大血条_怪物名称_文本")
	GUI:setAnchorPoint(Text_monster_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_monster_name, false)
	GUI:setTag(Text_monster_name, 9.0)
	GUI:Text_enableOutline(Text_monster_name, "#000000", 1.0)

	-- Create Image_loading_bg
	local Image_loading_bg = GUI:Image_Create(Panel_1, "Image_loading_bg", 89.00, -47.00, "res/private/main_monster_ui/hp/10.png")
	GUI:setChineseName(Image_loading_bg, "怪物大血条_加载背景图")
	GUI:setAnchorPoint(Image_loading_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_loading_bg, false)
	GUI:setTag(Image_loading_bg, 13.0)

	-- Create Panel_loding_hp_tx
	local Panel_loding_hp_tx = GUI:Layout_Create(Panel_1, "Panel_loding_hp_tx", 89.00, -37.00, 295.00, 20.00, false)
	GUI:setChineseName(Panel_loding_hp_tx, "怪物大血条_加载Hp_文本")
	GUI:setAnchorPoint(Panel_loding_hp_tx, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_loding_hp_tx, true)
	GUI:setTag(Panel_loding_hp_tx, 19.0)

	-- Create LoadingBar_hp_bar
	local LoadingBar_hp_bar = GUI:LoadingBar_Create(Panel_1, "LoadingBar_hp_bar", 89.00, -47.00, "res/private/gui_edit/LoadingBar.png", 0.0)
	GUI:setContentSize(LoadingBar_hp_bar, 296.0, 21.0)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_hp_bar, false)
	GUI:LoadingBar_setPercent(LoadingBar_hp_bar, 100.0)
	GUI:LoadingBar_setColor(LoadingBar_hp_bar, "#ffffff")
	GUI:setChineseName(LoadingBar_hp_bar, "怪物大血条_加载Hp")
	GUI:setAnchorPoint(LoadingBar_hp_bar, 0.00, 0.50)
	GUI:setTouchEnabled(LoadingBar_hp_bar, false)
	GUI:setTag(LoadingBar_hp_bar, 29.0)

	-- Create Node_bar_tip
	local Node_bar_tip = GUI:Node_Create(Panel_1, "Node_bar_tip", 89.00, -47.00)
	GUI:setChineseName(Node_bar_tip, "怪物大血条_血条_节点")
	GUI:setAnchorPoint(Node_bar_tip, 0.50, 0.50)
	GUI:setTag(Node_bar_tip, 18.0)

	-- Create Panel_bar_hp_tx
	local Panel_bar_hp_tx = GUI:Layout_Create(Panel_1, "Panel_bar_hp_tx", 89.00, -37.00, 295.00, 20.00, false)
	GUI:setChineseName(Panel_bar_hp_tx, "怪物大血条_Hp_特效")
	GUI:setAnchorPoint(Panel_bar_hp_tx, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_bar_hp_tx, true)
	GUI:setTag(Panel_bar_hp_tx, 18.0)

	-- Create Text_hp
	local Text_hp = GUI:Text_Create(Panel_1, "Text_hp", 96.00, -47.00, 16.0, "#ffffff", [[]])
	GUI:setChineseName(Text_hp, "怪物大血条_Hp%_文本")
	GUI:setAnchorPoint(Text_hp, 0.00, 0.50)
	GUI:setTouchEnabled(Text_hp, false)
	GUI:setTag(Text_hp, 13.0)
	GUI:Text_enableOutline(Text_hp, "#111111", 1.0)

	-- Create Panel_hp_tip
	local Panel_hp_tip = GUI:Layout_Create(Panel_1, "Panel_hp_tip", 378.00, -47.00, 287.00, 21.00, true)
	GUI:setChineseName(Panel_hp_tip, "怪物大血条_剩余Hp_组合")
	GUI:setAnchorPoint(Panel_hp_tip, 1.00, 0.50)
	GUI:setTouchEnabled(Panel_hp_tip, false)
	GUI:setTag(Panel_hp_tip, 15.0)

	-- Create Text_hp_tip
	local Text_hp_tip = GUI:Text_Create(Panel_hp_tip, "Text_hp_tip", 287.00, 10.00, 16.0, "#ffffff", [[]])
	GUI:setChineseName(Text_hp_tip, "怪物大血条_剩余Hp_文本")
	GUI:setAnchorPoint(Text_hp_tip, 1.00, 0.50)
	GUI:setTouchEnabled(Text_hp_tip, false)
	GUI:setTag(Text_hp_tip, 12.0)
	GUI:Text_enableOutline(Text_hp_tip, "#111111", 1.0)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 303.00, -20.00, "res/private/main_monster_ui/close1.png")
	GUI:Button_loadTexturePressed(Button_close, "res/private/main_monster_ui/close2.png")
	GUI:Button_setScale9Slice(Button_close, 19, 17.0, 11, 26.0)
	GUI:setContentSize(Button_close, 37.0, 38.0)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14.0)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "怪物大血条_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 19.0)

	-- Create Button_lock
	local Button_lock = GUI:Button_Create(Panel_1, "Button_lock", 425.00, -51.00, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTexturePressed(Button_lock, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_loadTextureDisabled(Button_lock, "res/private/player_hero/btn_heji_05.png")
	GUI:Button_setScale9Slice(Button_lock, 15, 15.0, 4, 4.0)
	GUI:setContentSize(Button_lock, 59.0, 59.0)
	GUI:setIgnoreContentAdaptWithSize(Button_lock, false)
	GUI:Button_setTitleText(Button_lock, "")
	GUI:Button_setTitleColor(Button_lock, "#414146")
	GUI:Button_setTitleFontSize(Button_lock, 14.0)
	GUI:Button_titleDisableOutLine(Button_lock)
	GUI:setChineseName(Button_lock, "怪物大血条_锁定_按钮")
	GUI:setAnchorPoint(Button_lock, 0.50, 0.50)
	GUI:setTouchEnabled(Button_lock, true)
	GUI:setTag(Button_lock, 29.0)
	GUI:setVisible(Button_lock, false)
end
return ui