local ui = {}
function ui.init(parent)
	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0.00, 0.00, 1136.00, 150.00, false)
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, -1)

	-- Create bottomImg
	local bottomImg = GUI:Image_Create(Panel_bg, "bottomImg", 468.00, -3.00, "res/private/main/1900012003.png")
	GUI:setContentSize(bottomImg, 1336, 30)
	GUI:setIgnoreContentAdaptWithSize(bottomImg, false)
	GUI:setAnchorPoint(bottomImg, 0.50, 0.00)
	GUI:setTouchEnabled(bottomImg, true)
	GUI:setTag(bottomImg, -1)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_bg, "Image_4", 403.00, 26.00, "res/private/main/1900012000.png")
	GUI:setAnchorPoint(Image_4, 0.50, 0.00)
	GUI:setTouchEnabled(Image_4, true)
	GUI:setTag(Image_4, -1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_bg, "Image_14", 350.00, 13.00, "res/private/main/1900012006.png")
	GUI:setAnchorPoint(Image_14, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, -1)

	-- Create Image_14_0
	local Image_14_0 = GUI:Image_Create(Panel_bg, "Image_14_0", 457.00, 13.00, "res/private/main/1900012006.png")
	GUI:setAnchorPoint(Image_14_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14_0, false)
	GUI:setTag(Image_14_0, -1)

	-- Create Image_14_0_0
	local Image_14_0_0 = GUI:Image_Create(Panel_bg, "Image_14_0_0", 650.00, 13.00, "res/private/main/1900012006.png")
	GUI:setAnchorPoint(Image_14_0_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_14_0_0, false)
	GUI:setTag(Image_14_0_0, -1)

	-- Create btn_rein_add
	local btn_rein_add = GUI:Button_Create(Panel_bg, "btn_rein_add", 535.00, 13.00, "res/private/main/00641.png")
	GUI:Button_loadTexturePressed(btn_rein_add, "res/private/main/00641.png")
	GUI:Button_loadTextureDisabled(btn_rein_add, "res/private/main/00643.png")
	GUI:Button_setTitleText(btn_rein_add, "")
	GUI:Button_setTitleColor(btn_rein_add, "#ffffff")
	GUI:Button_setTitleFontSize(btn_rein_add, 10)
	GUI:Button_titleEnableOutline(btn_rein_add, "#000000", 1)
	GUI:setAnchorPoint(btn_rein_add, 0.50, 0.50)
	GUI:setTouchEnabled(btn_rein_add, true)
	GUI:setTag(btn_rein_add, -1)

	-- Create Image_17
	local Image_17 = GUI:Image_Create(Panel_bg, "Image_17", 570.00, 13.00, "res/private/main/1900012015.png")
	GUI:setAnchorPoint(Image_17, 0.50, 0.50)
	GUI:setTouchEnabled(Image_17, false)
	GUI:setTag(Image_17, -1)

	-- Create Image_19
	local Image_19 = GUI:Image_Create(Panel_bg, "Image_19", 896.00, 13.00, "res/private/main/1900012009.png")
	GUI:setContentSize(Image_19, 258, 14)
	GUI:setIgnoreContentAdaptWithSize(Image_19, false)
	GUI:setAnchorPoint(Image_19, 0.50, 0.50)
	GUI:setTouchEnabled(Image_19, false)
	GUI:setTag(Image_19, -1)

	-- Create LoadingBar_exp
	local LoadingBar_exp = GUI:LoadingBar_Create(Panel_bg, "LoadingBar_exp", 895.00, 13.00, "res/private/main/1900012010.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_exp, 100)
	GUI:LoadingBar_setColor(LoadingBar_exp, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_exp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_exp, false)
	GUI:setTag(LoadingBar_exp, -1)

	-- Create Image_net
	local Image_net = GUI:Image_Create(Panel_bg, "Image_net", 84.00, 11.00, "res/private/main/Other/1900012501.png")
	GUI:setAnchorPoint(Image_net, 0.50, 0.50)
	GUI:setTouchEnabled(Image_net, false)
	GUI:setTag(Image_net, -1)

	-- Create Image_battery
	local Image_battery = GUI:Image_Create(Panel_bg, "Image_battery", 147.00, 11.00, "res/private/main/Other/1900012502.png")
	GUI:setAnchorPoint(Image_battery, 0.50, 0.50)
	GUI:setTouchEnabled(Image_battery, false)
	GUI:setTag(Image_battery, -1)

	-- Create LoadingBar_battery
	local LoadingBar_battery = GUI:LoadingBar_Create(Panel_bg, "LoadingBar_battery", 146.00, 11.00, "res/private/main/Other/1900012503.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_battery, 100)
	GUI:LoadingBar_setColor(LoadingBar_battery, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_battery, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_battery, false)
	GUI:setTag(LoadingBar_battery, -1)

	-- Create Text_FPS
	local Text_FPS = GUI:Text_Create(Panel_bg, "Text_FPS", 230.00, 13.00, 16, "#ffffff", [[FPS:60]])
	GUI:setAnchorPoint(Text_FPS, 0.50, 0.50)
	GUI:setTouchEnabled(Text_FPS, false)
	GUI:setTag(Text_FPS, -1)
	GUI:Text_enableOutline(Text_FPS, "#000000", 1)

	-- Create Panel_hp
	local Panel_hp = GUI:Layout_Create(Panel_bg, "Panel_hp", 404.00, 88.00, 70.00, 70.00, false)
	GUI:setAnchorPoint(Panel_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_hp, false)
	GUI:setTag(Panel_hp, -1)

	-- Create Image_divide
	local Image_divide = GUI:Image_Create(Panel_hp, "Image_divide", 35.00, 35.00, "res/private/main/1900012507.png")
	GUI:setAnchorPoint(Image_divide, 0.50, 0.50)
	GUI:setTouchEnabled(Image_divide, false)
	GUI:setTag(Image_divide, -1)

	-- Create LoadingBar_hp
	local LoadingBar_hp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_hp", 16.00, 35.00, "res/private/main/1900012032.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_hp, 100)
	GUI:LoadingBar_setColor(LoadingBar_hp, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_hp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_hp, 270.00)
	GUI:setRotationSkewX(LoadingBar_hp, 270.00)
	GUI:setRotationSkewY(LoadingBar_hp, 270.00)
	GUI:setTouchEnabled(LoadingBar_hp, false)
	GUI:setTag(LoadingBar_hp, -1)

	-- Create LoadingBar_mp
	local LoadingBar_mp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_mp", 53.00, 35.00, "res/private/main/1900012033.png", 0)
	GUI:setContentSize(LoadingBar_mp, 70, 33)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_mp, false)
	GUI:LoadingBar_setPercent(LoadingBar_mp, 100)
	GUI:LoadingBar_setColor(LoadingBar_mp, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_mp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_mp, 270.00)
	GUI:setRotationSkewX(LoadingBar_mp, 270.00)
	GUI:setRotationSkewY(LoadingBar_mp, 270.00)
	GUI:setTouchEnabled(LoadingBar_mp, false)
	GUI:setTag(LoadingBar_mp, -1)

	-- Create LoadingBar_fhp
	local LoadingBar_fhp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_fhp", 35.00, 35.00, "res/private/main/1900012504.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_fhp, 100)
	GUI:LoadingBar_setColor(LoadingBar_fhp, "#ffffff")
	GUI:setAnchorPoint(LoadingBar_fhp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_fhp, 270.00)
	GUI:setRotationSkewX(LoadingBar_fhp, 270.00)
	GUI:setRotationSkewY(LoadingBar_fhp, 270.00)
	GUI:setTouchEnabled(LoadingBar_fhp, false)
	GUI:setTag(LoadingBar_fhp, -1)

	-- Create Panel_hp_sfx
	local Panel_hp_sfx = GUI:Layout_Create(Panel_hp, "Panel_hp_sfx", 0.00, 0.00, 33.00, 70.00, true)
	GUI:setTouchEnabled(Panel_hp_sfx, false)
	GUI:setTag(Panel_hp_sfx, -1)

	-- Create Panel_mp_sfx
	local Panel_mp_sfx = GUI:Layout_Create(Panel_hp, "Panel_mp_sfx", 37.00, 0.00, 33.00, 70.00, true)
	GUI:setTouchEnabled(Panel_mp_sfx, false)
	GUI:setTag(Panel_mp_sfx, -1)

	-- Create Panel_fhp_sfx
	local Panel_fhp_sfx = GUI:Layout_Create(Panel_hp, "Panel_fhp_sfx", 0.00, 0.00, 70.00, 70.00, true)
	GUI:setTouchEnabled(Panel_fhp_sfx, false)
	GUI:setTag(Panel_fhp_sfx, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 1080.00, 14.00, "res/private/main/m_time.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Text_hp
	local Text_hp = GUI:Text_Create(Panel_bg, "Text_hp", 350.00, 14.00, 16, "#ffffff", [[11/11]])
	GUI:setAnchorPoint(Text_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_hp, false)
	GUI:setTag(Text_hp, -1)
	GUI:Text_enableOutline(Text_hp, "#000000", 1)

	-- Create Text_mp
	local Text_mp = GUI:Text_Create(Panel_bg, "Text_mp", 457.00, 14.00, 16, "#ffffff", [[11/11]])
	GUI:setAnchorPoint(Text_mp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_mp, false)
	GUI:setTag(Text_mp, -1)
	GUI:Text_enableOutline(Text_mp, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_bg, "Text_level", 650.00, 14.00, 16, "#ffffff", [[1级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, -1)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Panel_bg, "Text_time", 1080.00, 14.00, 16, "#ffffff", [[-]])
	GUI:setAnchorPoint(Text_time, 0.50, 0.50)
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, -1)
	GUI:Text_enableOutline(Text_time, "#000000", 1)

	-- Create Text_exp
	local Text_exp = GUI:Text_Create(Panel_bg, "Text_exp", 895.00, 14.00, 16, "#ffffff", [[0%]])
	GUI:setAnchorPoint(Text_exp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_exp, false)
	GUI:setTag(Text_exp, -1)
	GUI:Text_enableOutline(Text_exp, "#000000", 1)

	-- Create Image_17_0
	local Image_17_0 = GUI:Image_Create(Panel_bg, "Image_17_0", 740.00, 13.00, "res/private/main/1900012016.png")
	GUI:setAnchorPoint(Image_17_0, 0.50, 0.50)
	GUI:setTouchEnabled(Image_17_0, false)
	GUI:setTag(Image_17_0, -1)

	-- Create Panel_mini_chat
	local Panel_mini_chat = GUI:Layout_Create(parent, "Panel_mini_chat", -50.00, 26.00, 316.00, 108.00, false)
	GUI:setTouchEnabled(Panel_mini_chat, false)
	GUI:setTag(Panel_mini_chat, -1)

	-- Create Image_minichat_bg
	local Image_minichat_bg = GUI:Image_Create(Panel_mini_chat, "Image_minichat_bg", 158.00, 0.00, "res/private/main/1900012019.png")
	GUI:Image_setScale9Slice(Image_minichat_bg, 69, 69, 22, 22)
	GUI:setContentSize(Image_minichat_bg, 316, 108)
	GUI:setIgnoreContentAdaptWithSize(Image_minichat_bg, false)
	GUI:setAnchorPoint(Image_minichat_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Image_minichat_bg, false)
	GUI:setTag(Image_minichat_bg, -1)

	-- Create ListView_minichat
	local ListView_minichat = GUI:ListView_Create(Panel_mini_chat, "ListView_minichat", 158.00, 0.00, 310.00, 105.00, 1)
	GUI:ListView_setGravity(ListView_minichat, 5)
	GUI:setAnchorPoint(ListView_minichat, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_minichat, false)
	GUI:setTag(ListView_minichat, -1)

	-- Create ListView_chat_ex
	local ListView_chat_ex = GUI:ListView_Create(Panel_mini_chat, "ListView_chat_ex", 158.00, 105.00, 310.00, 25.00, 1)
	GUI:ListView_setGravity(ListView_chat_ex, 5)
	GUI:setAnchorPoint(ListView_chat_ex, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_chat_ex, false)
	GUI:setTag(ListView_chat_ex, -1)

	-- Create Panel_mini_chat_touch
	local Panel_mini_chat_touch = GUI:Layout_Create(Panel_mini_chat, "Panel_mini_chat_touch", 0.00, -1.00, 316.00, 108.00, false)
	GUI:setTouchEnabled(Panel_mini_chat_touch, true)
	GUI:setTag(Panel_mini_chat_touch, -1)

	-- Create Image_barbg
	local Image_barbg = GUI:Image_Create(parent, "Image_barbg", -56.00, 27.00, "res/private/main/angerBg2.png")
	GUI:setAnchorPoint(Image_barbg, 0.50, 0.00)
	GUI:setTouchEnabled(Image_barbg, false)
	GUI:setTag(Image_barbg, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Image_barbg, "Image_2", 6.00, 2.00, "res/private/main/angerBg.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.00)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create Panel_bar
	local Panel_bar = GUI:Layout_Create(Image_barbg, "Panel_bar", 6.00, 0.00, 13.00, 108.00, true)
	GUI:setAnchorPoint(Panel_bar, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_bar, false)
	GUI:setTag(Panel_bar, -1)

	-- Create Image_bar
	local Image_bar = GUI:Image_Create(Panel_bar, "Image_bar", 7.00, 2.00, "res/private/main/angerBar.png")
	GUI:setAnchorPoint(Image_bar, 0.50, 0.00)
	GUI:setTouchEnabled(Image_bar, false)
	GUI:setTag(Image_bar, -1)

	-- Create Panel_quick_use
	local Panel_quick_use = GUI:Layout_Create(parent, "Panel_quick_use", -50.00, 137.00, 316.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use, false)
	GUI:setTag(Panel_quick_use, -1)

	-- Create Panel_quick_use_1
	local Panel_quick_use_1 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_1", 0.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_1, true)
	GUI:setTag(Panel_quick_use_1, -1)

	-- Create Panel_quick_use_2
	local Panel_quick_use_2 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_2", 53.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_2, true)
	GUI:setTag(Panel_quick_use_2, -1)

	-- Create Panel_quick_use_3
	local Panel_quick_use_3 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_3", 106.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_3, true)
	GUI:setTag(Panel_quick_use_3, -1)

	-- Create Panel_quick_use_4
	local Panel_quick_use_4 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_4", 159.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_4, true)
	GUI:setTag(Panel_quick_use_4, -1)

	-- Create Panel_quick_use_5
	local Panel_quick_use_5 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_5", 212.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_5, true)
	GUI:setTag(Panel_quick_use_5, -1)

	-- Create Panel_quick_use_6
	local Panel_quick_use_6 = GUI:Layout_Create(Panel_quick_use, "Panel_quick_use_6", 265.00, 0.00, 50.00, 50.00, false)
	GUI:setTouchEnabled(Panel_quick_use_6, true)
	GUI:setTag(Panel_quick_use_6, -1)

	-- Create Panel_bubble_tips
	local Panel_bubble_tips = GUI:Layout_Create(parent, "Panel_bubble_tips", -165.00, 175.00, 150.00, 50.00, false)
	GUI:setAnchorPoint(Panel_bubble_tips, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_bubble_tips, false)
	GUI:setTag(Panel_bubble_tips, -1)

	-- Create ListView_bubble_tips
	local ListView_bubble_tips = GUI:ListView_Create(Panel_bubble_tips, "ListView_bubble_tips", 0.00, 0.00, 150.00, 50.00, 2)
	GUI:ListView_setGravity(ListView_bubble_tips, 3)
	GUI:setTouchEnabled(ListView_bubble_tips, false)
	GUI:setTag(ListView_bubble_tips, -1)

	-- Create Panel_auto_tips
	local Panel_auto_tips = GUI:Layout_Create(parent, "Panel_auto_tips", -50.00, 190.00, 316.00, 60.00, false)
	GUI:setTouchEnabled(Panel_auto_tips, false)
	GUI:setTag(Panel_auto_tips, -1)

	-- Create Button_chat_hide
	local Button_chat_hide = GUI:Button_Create(parent, "Button_chat_hide", -75.00, 120.00, "res/private/main/chat_hide.png")
	GUI:Button_loadTextureDisabled(Button_chat_hide, "res/private/main/chat_hide_1.png")
	GUI:Button_setTitleText(Button_chat_hide, "")
	GUI:Button_setTitleColor(Button_chat_hide, "#ffffff")
	GUI:Button_setTitleFontSize(Button_chat_hide, 10)
	GUI:Button_titleEnableOutline(Button_chat_hide, "#000000", 1)
	GUI:setTouchEnabled(Button_chat_hide, true)
	GUI:setTag(Button_chat_hide, -1)

	-- Create Node_quit_tip
	local Node_quit_tip = GUI:Node_Create(parent, "Node_quit_tip", 0.00, 237.00)
	GUI:setTag(Node_quit_tip, -1)
end
return ui