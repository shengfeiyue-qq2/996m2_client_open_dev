local ui = {}
function ui.init(parent)
	-- Create Main_Target_Belong
	local Main_Target_Belong = GUI:Node_Create(parent, "Main_Target_Belong", 0.00, -50.00)
	GUI:setTag(Main_Target_Belong, -1.0)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Main_Target_Belong, "Image_icon", 28.00, -30.00, "res/private/monster_belong_netplayer/job_0_0.png")
	GUI:setChineseName(Image_icon, "怪物归属_头像_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, 57.0)

	-- Create Image_icon_bg
	local Image_icon_bg = GUI:Image_Create(Main_Target_Belong, "Image_icon_bg", 0.00, 0.00, "res/private/monster_belong_netplayer/icon_bg.png")
	GUI:setChineseName(Image_icon_bg, "怪物归属_头像_背景")
	GUI:setAnchorPoint(Image_icon_bg, 0.00, 1.00)
	GUI:setTouchEnabled(Image_icon_bg, false)
	GUI:setTag(Image_icon_bg, 56.0)

	-- Create Image_hp_bg
	local Image_hp_bg = GUI:Image_Create(Main_Target_Belong, "Image_hp_bg", 30.00, -65.00, "res/private/monster_belong_netplayer/hp_loading_bg.png")
	GUI:setChineseName(Image_hp_bg, "怪物归属_Hp_背景")
	GUI:setAnchorPoint(Image_hp_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hp_bg, false)
	GUI:setTag(Image_hp_bg, 60.0)

	-- Create LoadingBar_hp
	local LoadingBar_hp = GUI:LoadingBar_Create(Main_Target_Belong, "LoadingBar_hp", 30.00, -65.00, "res/private/monster_belong_netplayer/hp_loding.png", 0.0)
	GUI:LoadingBar_setPercent(LoadingBar_hp, 0.0)
	GUI:LoadingBar_setColor(LoadingBar_hp, "#ffffff")
	GUI:setChineseName(LoadingBar_hp, "怪物归属_Hp")
	GUI:setAnchorPoint(LoadingBar_hp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_hp, false)
	GUI:setTag(LoadingBar_hp, 59.0)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Main_Target_Belong, "Image_name", 29.00, -54.00, "res/private/monster_belong_netplayer/1900012531.png")
	GUI:Image_setScale9Slice(Image_name, 43, 43.0, 5, 5.0)
	GUI:setContentSize(Image_name, 132.0, 18.0)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setChineseName(Image_name, "怪物归属_对象昵称_背景图")
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setScaleX(Image_name, 0.45)
	GUI:setScaleY(Image_name, 0.87)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 27.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Main_Target_Belong, "Text_name", 29.00, -54.00, 14.0, "#ffffff", [[]])
	GUI:setChineseName(Text_name, "怪物归属_对象昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 63.0)
	GUI:Text_enableOutline(Text_name, "#000000", 1.0)

	-- Create Node_tx
	local Node_tx = GUI:Node_Create(Main_Target_Belong, "Node_tx", 28.00, -30.00)
	GUI:setChineseName(Node_tx, "怪物归属_节点")
	GUI:setAnchorPoint(Node_tx, 0.50, 0.50)
	GUI:setTag(Node_tx, 61.0)

	-- Create Panel_click
	local Panel_click = GUI:Layout_Create(Main_Target_Belong, "Panel_click", 0.00, 0.00, 56.00, 60.00, false)
	GUI:setChineseName(Panel_click, "怪物归属_点击选择")
	GUI:setAnchorPoint(Panel_click, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_click, true)
	GUI:setTag(Panel_click, 62.0)
end
return ui