local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "主界面操作节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 1024.00, 150.00, false)
	GUI:setChineseName(Panel_bg, "主界面操作_背景图")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, 222)

	-- Create Panel_hp
	local Panel_hp = GUI:Layout_Create(Panel_bg, "Panel_hp", 0.00, 0.00, 194.00, 252.00, false)
	GUI:setChineseName(Panel_hp, "主界面操作_HP组合")
	GUI:setTouchEnabled(Panel_hp, true)
	GUI:setTag(Panel_hp, 57)

	-- Create Image_hp_bg
	local Image_hp_bg = GUI:Image_Create(Panel_hp, "Image_hp_bg", 0.00, -2.00, "res/private/main-win32/1900010500.png")
	GUI:setChineseName(Image_hp_bg, "主界面操作_Hp_背景图")
	GUI:setTouchEnabled(Image_hp_bg, true)
	GUI:setTag(Image_hp_bg, 228)

	-- Create LoadingBar_hp
	local LoadingBar_hp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_hp", 60.00, 112.00, "res/private/main-win32/1900000502.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_hp, 100)
	GUI:LoadingBar_setColor(LoadingBar_hp, "#ffffff")
	GUI:setChineseName(LoadingBar_hp, "主界面操作_Hp")
	GUI:setAnchorPoint(LoadingBar_hp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_hp, 270.00)
	GUI:setRotationSkewX(LoadingBar_hp, 270.00)
	GUI:setRotationSkewY(LoadingBar_hp, 270.00)
	GUI:setTouchEnabled(LoadingBar_hp, false)
	GUI:setTag(LoadingBar_hp, 22)

	-- Create LoadingBar_mp
	local LoadingBar_mp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_mp", 108.00, 112.00, "res/private/main-win32/1900000503.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_mp, 100)
	GUI:LoadingBar_setColor(LoadingBar_mp, "#ffffff")
	GUI:setChineseName(LoadingBar_mp, "主界面操作_Mp")
	GUI:setAnchorPoint(LoadingBar_mp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_mp, 270.00)
	GUI:setRotationSkewX(LoadingBar_mp, 270.00)
	GUI:setRotationSkewY(LoadingBar_mp, 270.00)
	GUI:setTouchEnabled(LoadingBar_mp, false)
	GUI:setTag(LoadingBar_mp, 23)

	-- Create Image_fhp_bg
	local Image_fhp_bg = GUI:Image_Create(Panel_hp, "Image_fhp_bg", 85.00, 112.00, "res/private/main-win32/1900000500.png")
	GUI:setChineseName(Image_fhp_bg, "主界面操作_满Hp_背景图")
	GUI:setAnchorPoint(Image_fhp_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_fhp_bg, false)
	GUI:setTag(Image_fhp_bg, 25)

	-- Create LoadingBar_fhp
	local LoadingBar_fhp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_fhp", 85.00, 112.00, "res/private/main-win32/1900000501.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_fhp, 100)
	GUI:LoadingBar_setColor(LoadingBar_fhp, "#ffffff")
	GUI:setChineseName(LoadingBar_fhp, "主界面操作_满Hp")
	GUI:setAnchorPoint(LoadingBar_fhp, 0.50, 0.50)
	GUI:setRotation(LoadingBar_fhp, 270.00)
	GUI:setRotationSkewX(LoadingBar_fhp, 270.00)
	GUI:setRotationSkewY(LoadingBar_fhp, 270.00)
	GUI:setTouchEnabled(LoadingBar_fhp, false)
	GUI:setTag(LoadingBar_fhp, 24)

	-- Create Panel_hp_sfx
	local Panel_hp_sfx = GUI:Layout_Create(Panel_hp, "Panel_hp_sfx", 38.00, 65.00, 44.00, 94.00, true)
	GUI:setChineseName(Panel_hp_sfx, "主界面操作_Hp_特效")
	GUI:setTouchEnabled(Panel_hp_sfx, true)
	GUI:setTag(Panel_hp_sfx, 195)

	-- Create Panel_mp_sfx
	local Panel_mp_sfx = GUI:Layout_Create(Panel_hp, "Panel_mp_sfx", 86.00, 65.00, 44.00, 94.00, true)
	GUI:setChineseName(Panel_mp_sfx, "主界面操作_Mp_特效")
	GUI:setTouchEnabled(Panel_mp_sfx, true)
	GUI:setTag(Panel_mp_sfx, 196)

	-- Create Panel_fhp_sfx
	local Panel_fhp_sfx = GUI:Layout_Create(Panel_hp, "Panel_fhp_sfx", 38.00, 65.00, 94.00, 94.00, true)
	GUI:setChineseName(Panel_fhp_sfx, "主界面操作_满Hp_特效")
	GUI:setTouchEnabled(Panel_fhp_sfx, true)
	GUI:setTag(Panel_fhp_sfx, 197)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_hp, "Image_1", 85.00, 34.00, "res/private/main-win32/000009.png")
	GUI:setChineseName(Image_1, "Hp/Mp组合")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 53)

	-- Create Text_hp
	local Text_hp = GUI:BmpText_Create(Image_1, "Text_hp", 35.00, 12.00, "#ffffff", [[-]])
	GUI:setChineseName(Text_hp, "Hp值_文本")
	GUI:setAnchorPoint(Text_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_hp, false)
	GUI:setTag(Text_hp, 54)

	-- Create Text_mp
	local Text_mp = GUI:BmpText_Create(Image_1, "Text_mp", 97.00, 12.00, "#ffffff", [[-]])
	GUI:setChineseName(Text_mp, "Mp值_文本")
	GUI:setAnchorPoint(Text_mp, 0.50, 0.50)
	GUI:setTouchEnabled(Text_mp, false)
	GUI:setTag(Text_mp, 55)

	-- Create Text_position
	local Text_position = GUI:BmpText_Create(Panel_hp, "Text_position", 16.00, 12.00, "#ffffff", [[-]])
	GUI:setChineseName(Text_position, "主界面_坐标位置_文本")
	GUI:setAnchorPoint(Text_position, 0.00, 0.50)
	GUI:setTouchEnabled(Text_position, false)
	GUI:setTag(Text_position, 26)

	-- Create Button_chat_1
	local Button_chat_1 = GUI:Button_Create(Panel_hp, "Button_chat_1", 182.00, 133.00, "res/private/main-win32/190001100.png")
	GUI:Button_loadTexturePressed(Button_chat_1, "res/private/main-win32/190001100.png")
	GUI:Button_setScale9Slice(Button_chat_1, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_1, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_1, false)
	GUI:Button_setTitleText(Button_chat_1, "")
	GUI:Button_setTitleColor(Button_chat_1, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_1, 14)
	GUI:Button_titleDisableOutLine(Button_chat_1)
	GUI:setChineseName(Button_chat_1, "主界面_系统信息_开关")
	GUI:setAnchorPoint(Button_chat_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_1, true)
	GUI:setTag(Button_chat_1, 27)

	-- Create Button_chat_2
	local Button_chat_2 = GUI:Button_Create(Panel_hp, "Button_chat_2", 182.00, 113.00, "res/private/main-win32/190001102.png")
	GUI:Button_loadTexturePressed(Button_chat_2, "res/private/main-win32/190001102.png")
	GUI:Button_setScale9Slice(Button_chat_2, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_2, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_2, false)
	GUI:Button_setTitleText(Button_chat_2, "")
	GUI:Button_setTitleColor(Button_chat_2, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_2, 14)
	GUI:Button_titleDisableOutLine(Button_chat_2)
	GUI:setChineseName(Button_chat_2, "主界面_传音信息_开关")
	GUI:setAnchorPoint(Button_chat_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_2, true)
	GUI:setTag(Button_chat_2, 28)

	-- Create Button_chat_3
	local Button_chat_3 = GUI:Button_Create(Panel_hp, "Button_chat_3", 182.00, 93.00, "res/private/main-win32/190001104.png")
	GUI:Button_loadTexturePressed(Button_chat_3, "res/private/main-win32/190001104.png")
	GUI:Button_setScale9Slice(Button_chat_3, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_3, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_3, false)
	GUI:Button_setTitleText(Button_chat_3, "")
	GUI:Button_setTitleColor(Button_chat_3, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_3, 14)
	GUI:Button_titleDisableOutLine(Button_chat_3)
	GUI:setChineseName(Button_chat_3, "主界面_私聊信息_开关")
	GUI:setAnchorPoint(Button_chat_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_3, true)
	GUI:setTag(Button_chat_3, 29)

	-- Create Button_chat_4
	local Button_chat_4 = GUI:Button_Create(Panel_hp, "Button_chat_4", 182.00, 73.00, "res/private/main-win32/190001106.png")
	GUI:Button_loadTexturePressed(Button_chat_4, "res/private/main-win32/190001106.png")
	GUI:Button_setScale9Slice(Button_chat_4, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_4, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_4, false)
	GUI:Button_setTitleText(Button_chat_4, "")
	GUI:Button_setTitleColor(Button_chat_4, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_4, 14)
	GUI:Button_titleDisableOutLine(Button_chat_4)
	GUI:setChineseName(Button_chat_4, "主界面_行会聊天信息_开关")
	GUI:setAnchorPoint(Button_chat_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_4, true)
	GUI:setTag(Button_chat_4, 30)

	-- Create Button_chat_5
	local Button_chat_5 = GUI:Button_Create(Panel_hp, "Button_chat_5", 182.00, 53.00, "res/private/main-win32/190001108.png")
	GUI:Button_loadTexturePressed(Button_chat_5, "res/private/main-win32/190001108.png")
	GUI:Button_setScale9Slice(Button_chat_5, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_5, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_5, false)
	GUI:Button_setTitleText(Button_chat_5, "")
	GUI:Button_setTitleColor(Button_chat_5, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_5, 14)
	GUI:Button_titleDisableOutLine(Button_chat_5)
	GUI:setChineseName(Button_chat_5, "主界面_含糊信息_开关")
	GUI:setAnchorPoint(Button_chat_5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_5, true)
	GUI:setTag(Button_chat_5, 31)

	-- Create Button_chat_6
	local Button_chat_6 = GUI:Button_Create(Panel_hp, "Button_chat_6", 182.00, 33.00, "res/private/main-win32/190001110.png")
	GUI:Button_loadTexturePressed(Button_chat_6, "res/private/main-win32/190001110.png")
	GUI:Button_setScale9Slice(Button_chat_6, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_6, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_6, false)
	GUI:Button_setTitleText(Button_chat_6, "")
	GUI:Button_setTitleColor(Button_chat_6, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_6, 14)
	GUI:Button_titleDisableOutLine(Button_chat_6)
	GUI:setChineseName(Button_chat_6, "主界面_特殊命令_开关")
	GUI:setAnchorPoint(Button_chat_6, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_6, true)
	GUI:setTag(Button_chat_6, 32)

	-- Create Button_chat_7
	local Button_chat_7 = GUI:Button_Create(Panel_hp, "Button_chat_7", 182.00, 13.00, "res/private/main-win32/190001112.png")
	GUI:Button_loadTexturePressed(Button_chat_7, "res/private/main-win32/190001112.png")
	GUI:Button_setScale9Slice(Button_chat_7, 5, 5, 6, 4)
	GUI:setContentSize(Button_chat_7, 18, 17)
	GUI:setIgnoreContentAdaptWithSize(Button_chat_7, false)
	GUI:Button_setTitleText(Button_chat_7, "")
	GUI:Button_setTitleColor(Button_chat_7, "#414146")
	GUI:Button_setTitleFontSize(Button_chat_7, 14)
	GUI:Button_titleDisableOutLine(Button_chat_7)
	GUI:setChineseName(Button_chat_7, "主界面_自动喊话_开关")
	GUI:setAnchorPoint(Button_chat_7, 0.50, 0.50)
	GUI:setTouchEnabled(Button_chat_7, true)
	GUI:setTag(Button_chat_7, 85)

	-- Create Panel_dz
	local Panel_dz = GUI:Layout_Create(Panel_hp, "Panel_dz", 12.00, 40.00, 80.00, 142.00, false)
	GUI:setChineseName(Panel_dz, "主界面斗转组合")
	GUI:setTouchEnabled(Panel_dz, false)
	GUI:setTag(Panel_dz, -1)
	GUI:setVisible(Panel_dz, false)

	-- Create Image_dz_bg
	local Image_dz_bg = GUI:Image_Create(Panel_dz, "Image_dz_bg", 0.00, 0.00, "res/private/main-win32/dou_0.png")
	GUI:setChineseName(Image_dz_bg, "主界面_斗转框_背景图")
	GUI:setTouchEnabled(Image_dz_bg, false)
	GUI:setTag(Image_dz_bg, -1)

	-- Create Panel_bar_dz
	local Panel_bar_dz = GUI:Layout_Create(Panel_dz, "Panel_bar_dz", 0.00, 0.00, 84.00, 142.00, true)
	GUI:setChineseName(Panel_bar_dz, "主界面_斗转条组合")
	GUI:setTouchEnabled(Panel_bar_dz, false)
	GUI:setTag(Panel_bar_dz, -1)

	-- Create Image_bar_dz
	local Image_bar_dz = GUI:Image_Create(Panel_bar_dz, "Image_bar_dz", 0.00, 0.00, "res/private/main-win32/dou_11.png")
	GUI:setChineseName(Image_bar_dz, "主界面_斗转条")
	GUI:setTouchEnabled(Image_bar_dz, false)
	GUI:setTag(Image_bar_dz, -1)

	-- Create Panel_zj
	local Panel_zj = GUI:Layout_Create(Panel_hp, "Panel_zj", 77.00, 65.00, 12.00, 94.00, false)
	GUI:setChineseName(Panel_zj, "主界面_醉酒组合")
	GUI:setTouchEnabled(Panel_zj, false)
	GUI:setTag(Panel_zj, -1)
	GUI:setVisible(Panel_zj, false)

	-- Create Image_zj_bg
	local Image_zj_bg = GUI:Image_Create(Panel_zj, "Image_zj_bg", 0.00, 0.00, "res/private/main-win32/zuijiu_0.png")
	GUI:setChineseName(Image_zj_bg, "主界面_醉酒框_背景图")
	GUI:setTouchEnabled(Image_zj_bg, false)
	GUI:setTag(Image_zj_bg, -1)

	-- Create Panel_bar_zj
	local Panel_bar_zj = GUI:Layout_Create(Panel_zj, "Panel_bar_zj", 0.00, 0.00, 12.00, 94.00, true)
	GUI:setChineseName(Panel_bar_zj, "主界面_醉酒度组合")
	GUI:setTouchEnabled(Panel_bar_zj, false)
	GUI:setTag(Panel_bar_zj, -1)

	-- Create Image_bar_zj
	local Image_bar_zj = GUI:Image_Create(Panel_bar_zj, "Image_bar_zj", 0.00, 0.00, "res/private/main-win32/zuijiu_1.png")
	GUI:setChineseName(Image_bar_zj, "主界面_醉酒度")
	GUI:setTouchEnabled(Image_bar_zj, false)
	GUI:setTag(Image_bar_zj, -1)

	-- Create Panel_chat
	local Panel_chat = GUI:Layout_Create(Panel_bg, "Panel_chat", 512.00, 0.00, 636.00, 155.00, false)
	GUI:setChineseName(Panel_chat, "主界面聊天组合")
	GUI:setAnchorPoint(Panel_chat, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_chat, true)
	GUI:setTag(Panel_chat, 237)

	-- Create Image_chat_bg
	local Image_chat_bg = GUI:Image_Create(Panel_chat, "Image_chat_bg", 318.00, 0.00, "res/private/main-win32/00000056.png")
	GUI:Image_setScale9Slice(Image_chat_bg, 25, 25, 72, 71)
	GUI:setContentSize(Image_chat_bg, 636, 155)
	GUI:setIgnoreContentAdaptWithSize(Image_chat_bg, false)
	GUI:setChineseName(Image_chat_bg, "主界面_聊天_背景框")
	GUI:setAnchorPoint(Image_chat_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Image_chat_bg, false)
	GUI:setTag(Image_chat_bg, 238)

	-- Create Panel_chat_touch
	local Panel_chat_touch = GUI:Layout_Create(Panel_chat, "Panel_chat_touch", 318.00, 155.00, 636.00, 25.00, false)
	GUI:setChineseName(Panel_chat_touch, "主界面_聊天_触摸")
	GUI:setAnchorPoint(Panel_chat_touch, 0.50, 1.00)
	GUI:setTouchEnabled(Panel_chat_touch, true)
	GUI:setTag(Panel_chat_touch, 47)

	-- Create Panel_chat_funcs
	local Panel_chat_funcs = GUI:Layout_Create(Panel_chat, "Panel_chat_funcs", 13.00, 146.00, 200.00, 15.00, false)
	GUI:setChineseName(Panel_chat_funcs, "聊天_功能键组合")
	GUI:setAnchorPoint(Panel_chat_funcs, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_chat_funcs, false)
	GUI:setTag(Panel_chat_funcs, 33)

	-- Create Button_map
	local Button_map = GUI:Button_Create(Panel_chat_funcs, "Button_map", 14.00, 7.00, "res/private/main-win32/1900011009.png")
	GUI:Button_loadTexturePressed(Button_map, "res/private/main-win32/1900011010.png")
	GUI:Button_loadTextureDisabled(Button_map, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_map, 8, 8, 4, 4)
	GUI:setContentSize(Button_map, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_map, false)
	GUI:Button_setTitleText(Button_map, "")
	GUI:Button_setTitleColor(Button_map, "#414146")
	GUI:Button_setTitleFontSize(Button_map, 14)
	GUI:Button_titleDisableOutLine(Button_map)
	GUI:setChineseName(Button_map, "聊天_地图_按钮")
	GUI:setAnchorPoint(Button_map, 0.50, 0.50)
	GUI:setTouchEnabled(Button_map, true)
	GUI:setTag(Button_map, 34)

	-- Create Button_trade
	local Button_trade = GUI:Button_Create(Panel_chat_funcs, "Button_trade", 41.00, 7.00, "res/private/main-win32/1900011011.png")
	GUI:Button_loadTexturePressed(Button_trade, "res/private/main-win32/1900011012.png")
	GUI:Button_loadTextureDisabled(Button_trade, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_trade, 8, 8, 4, 4)
	GUI:setContentSize(Button_trade, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_trade, false)
	GUI:Button_setTitleText(Button_trade, "")
	GUI:Button_setTitleColor(Button_trade, "#414146")
	GUI:Button_setTitleFontSize(Button_trade, 14)
	GUI:Button_titleDisableOutLine(Button_trade)
	GUI:setChineseName(Button_trade, "聊天_交易_按钮")
	GUI:setAnchorPoint(Button_trade, 0.50, 0.50)
	GUI:setTouchEnabled(Button_trade, true)
	GUI:setTag(Button_trade, 35)

	-- Create Button_guild
	local Button_guild = GUI:Button_Create(Panel_chat_funcs, "Button_guild", 68.00, 7.00, "res/private/main-win32/1900011015.png")
	GUI:Button_loadTexturePressed(Button_guild, "res/private/main-win32/1900011016.png")
	GUI:Button_loadTextureDisabled(Button_guild, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_guild, 8, 8, 4, 4)
	GUI:setContentSize(Button_guild, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_guild, false)
	GUI:Button_setTitleText(Button_guild, "")
	GUI:Button_setTitleColor(Button_guild, "#414146")
	GUI:Button_setTitleFontSize(Button_guild, 14)
	GUI:Button_titleDisableOutLine(Button_guild)
	GUI:setChineseName(Button_guild, "聊天_行会_按钮")
	GUI:setAnchorPoint(Button_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Button_guild, true)
	GUI:setTag(Button_guild, 36)

	-- Create Button_near
	local Button_near = GUI:Button_Create(Panel_chat_funcs, "Button_near", 95.00, 7.00, "res/private/main-win32/1900011013.png")
	GUI:Button_loadTexturePressed(Button_near, "res/private/main-win32/1900011014.png")
	GUI:Button_loadTextureDisabled(Button_near, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_near, 8, 8, 4, 4)
	GUI:setContentSize(Button_near, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_near, false)
	GUI:Button_setTitleText(Button_near, "")
	GUI:Button_setTitleColor(Button_near, "#414146")
	GUI:Button_setTitleFontSize(Button_near, 14)
	GUI:Button_titleDisableOutLine(Button_near)
	GUI:setChineseName(Button_near, "聊天_队伍_按钮")
	GUI:setAnchorPoint(Button_near, 0.50, 0.50)
	GUI:setTouchEnabled(Button_near, true)
	GUI:setTag(Button_near, 37)

	-- Create Button_rank
	local Button_rank = GUI:Button_Create(Panel_chat_funcs, "Button_rank", 122.00, 7.00, "res/private/main-win32/1900011027.png")
	GUI:Button_loadTexturePressed(Button_rank, "res/private/main-win32/1900011028.png")
	GUI:Button_loadTextureDisabled(Button_rank, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_rank, 8, 8, 4, 4)
	GUI:setContentSize(Button_rank, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_rank, false)
	GUI:Button_setTitleText(Button_rank, "")
	GUI:Button_setTitleColor(Button_rank, "#414146")
	GUI:Button_setTitleFontSize(Button_rank, 14)
	GUI:Button_titleDisableOutLine(Button_rank)
	GUI:setChineseName(Button_rank, "聊天_排行_按钮")
	GUI:setAnchorPoint(Button_rank, 0.50, 0.50)
	GUI:setTouchEnabled(Button_rank, true)
	GUI:setTag(Button_rank, 59)

	-- Create Button_private
	local Button_private = GUI:Button_Create(Panel_chat_funcs, "Button_private", 149.00, 7.00, "res/private/main-win32/1900011029.png")
	GUI:Button_loadTexturePressed(Button_private, "res/private/main-win32/1900011030.png")
	GUI:Button_setScale9Slice(Button_private, 8, 8, 4, 4)
	GUI:setContentSize(Button_private, 28, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_private, false)
	GUI:Button_setTitleText(Button_private, "")
	GUI:Button_setTitleColor(Button_private, "#414146")
	GUI:Button_setTitleFontSize(Button_private, 14)
	GUI:Button_titleDisableOutLine(Button_private)
	GUI:setChineseName(Button_private, "聊天_私聊记录_按钮")
	GUI:setAnchorPoint(Button_private, 0.50, 0.50)
	GUI:setTouchEnabled(Button_private, true)
	GUI:setTag(Button_private, 227)

	-- Create Button_drop
	local Button_drop = GUI:Button_Create(Panel_chat_funcs, "Button_drop", 176.00, 7.00, "res/private/main-win32/1900011050.png")
	GUI:Button_loadTexturePressed(Button_drop, "res/private/main-win32/1900011051.png")
	GUI:Button_setScale9Slice(Button_drop, 9, 9, 4, 5)
	GUI:setContentSize(Button_drop, 28, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_drop, false)
	GUI:Button_setTitleText(Button_drop, "")
	GUI:Button_setTitleColor(Button_drop, "#414146")
	GUI:Button_setTitleFontSize(Button_drop, 14)
	GUI:Button_titleEnableOutline(Button_drop, "#000000", 1)
	GUI:setChineseName(Button_drop, "聊天_掉落_按钮")
	GUI:setAnchorPoint(Button_drop, 0.50, 0.50)
	GUI:setTouchEnabled(Button_drop, true)
	GUI:setTag(Button_drop, 227)

	-- Create btn_rein_add
	local btn_rein_add = GUI:Button_Create(Panel_chat_funcs, "btn_rein_add", 204.00, 8.00, "res/private/main-win32/1900011003.png")
	GUI:Button_loadTexturePressed(btn_rein_add, "res/private/main-win32/1900011004.png")
	GUI:Button_loadTextureDisabled(btn_rein_add, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_rein_add, 4, 4, 4, 4)
	GUI:setContentSize(btn_rein_add, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(btn_rein_add, false)
	GUI:Button_setTitleText(btn_rein_add, "")
	GUI:Button_setTitleColor(btn_rein_add, "#414146")
	GUI:Button_setTitleFontSize(btn_rein_add, 14)
	GUI:Button_titleDisableOutLine(btn_rein_add)
	GUI:setChineseName(btn_rein_add, "聊天_属性点_按钮")
	GUI:setAnchorPoint(btn_rein_add, 0.50, 0.50)
	GUI:setTouchEnabled(btn_rein_add, true)
	GUI:setTag(btn_rein_add, 64)
	GUI:setVisible(btn_rein_add, false)

	-- Create Panel_exit_funcs
	local Panel_exit_funcs = GUI:Layout_Create(Panel_chat, "Panel_exit_funcs", 628.00, 146.00, 60.00, 15.00, false)
	GUI:setChineseName(Panel_exit_funcs, "聊天_退出组合")
	GUI:setAnchorPoint(Panel_exit_funcs, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_exit_funcs, false)
	GUI:setTag(Panel_exit_funcs, 38)

	-- Create Button_out
	local Button_out = GUI:Button_Create(Panel_exit_funcs, "Button_out", 16.00, 7.00, "res/private/main-win32/1900011017.png")
	GUI:Button_loadTexturePressed(Button_out, "res/private/main-win32/1900011018.png")
	GUI:Button_loadTextureDisabled(Button_out, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_out, 8, 8, 4, 4)
	GUI:setContentSize(Button_out, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_out, false)
	GUI:Button_setTitleText(Button_out, "")
	GUI:Button_setTitleColor(Button_out, "#414146")
	GUI:Button_setTitleFontSize(Button_out, 14)
	GUI:Button_titleDisableOutLine(Button_out)
	GUI:setChineseName(Button_out, "聊天_小退_按钮")
	GUI:setAnchorPoint(Button_out, 0.50, 0.50)
	GUI:setTouchEnabled(Button_out, true)
	GUI:setTag(Button_out, 40)

	-- Create Button_end
	local Button_end = GUI:Button_Create(Panel_exit_funcs, "Button_end", 45.00, 7.00, "res/private/main-win32/1900011019.png")
	GUI:Button_loadTexturePressed(Button_end, "res/private/main-win32/1900011020.png")
	GUI:Button_loadTextureDisabled(Button_end, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_end, 8, 8, 4, 4)
	GUI:setContentSize(Button_end, 27, 13)
	GUI:setIgnoreContentAdaptWithSize(Button_end, false)
	GUI:Button_setTitleText(Button_end, "")
	GUI:Button_setTitleColor(Button_end, "#414146")
	GUI:Button_setTitleFontSize(Button_end, 14)
	GUI:Button_titleDisableOutLine(Button_end)
	GUI:setChineseName(Button_end, "聊天_大退_组合")
	GUI:setAnchorPoint(Button_end, 0.50, 0.50)
	GUI:setTouchEnabled(Button_end, true)
	GUI:setTag(Button_end, 42)

	-- Create ListView_chat
	local ListView_chat = GUI:ListView_Create(Panel_chat, "ListView_chat", 318.00, 23.00, 608.00, 105.00, 1)
	GUI:ListView_setGravity(ListView_chat, 5)
	GUI:setChineseName(ListView_chat, "聊天_内容列表")
	GUI:setAnchorPoint(ListView_chat, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_chat, true)
	GUI:setTag(ListView_chat, 239)

	-- Create Button_channel
	local Button_channel = GUI:Button_Create(Panel_chat, "Button_channel", 38.00, 14.00, "res/private/main-win32/btn_channel.png")
	GUI:Button_setScale9Slice(Button_channel, 15, 15, 5, 5)
	GUI:setContentSize(Button_channel, 49, 16)
	GUI:setIgnoreContentAdaptWithSize(Button_channel, false)
	GUI:Button_setTitleText(Button_channel, "")
	GUI:Button_setTitleColor(Button_channel, "#414146")
	GUI:Button_setTitleFontSize(Button_channel, 14)
	GUI:Button_titleDisableOutLine(Button_channel)
	GUI:setChineseName(Button_channel, "聊天_频道切换组合")
	GUI:setAnchorPoint(Button_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_channel, true)
	GUI:setTag(Button_channel, 143)
	GUI:setVisible(Button_channel, false)

	-- Create Text_channel
	local Text_channel = GUI:BmpText_Create(Button_channel, "Text_channel", 30.00, 8.00, "#ffffff", [[附 近]])
	GUI:setChineseName(Text_channel, "聊天_当前频道_内容")
	GUI:setAnchorPoint(Text_channel, 0.50, 0.50)
	GUI:setTouchEnabled(Text_channel, false)
	GUI:setTag(Text_channel, 144)

	-- Create TextField_input
	local TextField_input = GUI:TextInput_Create(Panel_chat, "TextField_input", 64.00, 6.00, 560.00, 15.00, 12)
	GUI:TextInput_setString(TextField_input, "")
	GUI:TextInput_setFontColor(TextField_input, "#000000")
	GUI:TextInput_setMaxLength(TextField_input, 10)
	GUI:setChineseName(TextField_input, "聊天_输入内容")
	GUI:setTouchEnabled(TextField_input, true)
	GUI:setTag(TextField_input, 17)

	-- Create ListView_chat_ex
	local ListView_chat_ex = GUI:ListView_Create(Panel_chat, "ListView_chat_ex", 318.00, 130.00, 608.00, 50.00, 1)
	GUI:ListView_setGravity(ListView_chat_ex, 5)
	GUI:setChineseName(ListView_chat_ex, "聊天_聊天公告_列表")
	GUI:setAnchorPoint(ListView_chat_ex, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_chat_ex, false)
	GUI:setTag(ListView_chat_ex, 48)

	-- Create Panel_channel_s
	local Panel_channel_s = GUI:Layout_Create(Panel_chat, "Panel_channel_s", 38.00, 22.00, 52.00, 108.00, false)
	GUI:setChineseName(Panel_channel_s, "聊天_频道切换组合")
	GUI:setAnchorPoint(Panel_channel_s, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_channel_s, false)
	GUI:setTag(Panel_channel_s, 145)
	GUI:setVisible(Panel_channel_s, false)

	-- Create Image_channel_bg
	local Image_channel_bg = GUI:Image_Create(Panel_channel_s, "Image_channel_bg", 26.00, 54.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_channel_bg, 21, 21, 37, 29)
	GUI:setContentSize(Image_channel_bg, 52, 108)
	GUI:setIgnoreContentAdaptWithSize(Image_channel_bg, false)
	GUI:setChineseName(Image_channel_bg, "聊天_频道切换_背景图")
	GUI:setAnchorPoint(Image_channel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_channel_bg, false)
	GUI:setTag(Image_channel_bg, 147)

	-- Create ListView_channel
	local ListView_channel = GUI:ListView_Create(Panel_channel_s, "ListView_channel", 26.00, 3.00, 48.00, 102.00, 1)
	GUI:ListView_setGravity(ListView_channel, 2)
	GUI:setChineseName(ListView_channel, "聊天_频道切换_列表")
	GUI:setAnchorPoint(ListView_channel, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_channel, true)
	GUI:setTag(ListView_channel, 146)

	-- Create channel_cell
	local channel_cell = GUI:Layout_Create(Panel_chat, "channel_cell", 14.00, 26.00, 48.00, 16.00, true)
	GUI:setChineseName(channel_cell, "聊天_子频道组合")
	GUI:setTouchEnabled(channel_cell, true)
	GUI:setTag(channel_cell, 148)
	GUI:setVisible(channel_cell, false)

	-- Create Image_selected
	local Image_selected = GUI:Image_Create(channel_cell, "Image_selected", 24.00, 8.00, "res/public/1900000678.png")
	GUI:setContentSize(Image_selected, 55, 16)
	GUI:setIgnoreContentAdaptWithSize(Image_selected, false)
	GUI:setChineseName(Image_selected, "聊天_子频道选择_背景图")
	GUI:setAnchorPoint(Image_selected, 0.50, 0.50)
	GUI:setTouchEnabled(Image_selected, false)
	GUI:setTag(Image_selected, 149)

	-- Create Text_title
	local Text_title = GUI:BmpText_Create(channel_cell, "Text_title", 24.00, 8.00, "#ffffff", [[xxx]])
	GUI:setChineseName(Text_title, "聊天_子频道_文本")
	GUI:setAnchorPoint(Text_title, 0.50, 0.50)
	GUI:setTouchEnabled(Text_title, false)
	GUI:setTag(Text_title, 150)

	-- Create Panel_act
	local Panel_act = GUI:Layout_Create(Panel_bg, "Panel_act", 1024.00, 0.00, 194.00, 252.00, false)
	GUI:setChineseName(Panel_act, "主界面_主操作组合")
	GUI:setAnchorPoint(Panel_act, 1.00, 0.00)
	GUI:setTouchEnabled(Panel_act, true)
	GUI:setTag(Panel_act, 58)

	-- Create Image_act_bg
	local Image_act_bg = GUI:Image_Create(Panel_act, "Image_act_bg", 194.00, -2.00, "res/private/main-win32/1900010501.png")
	GUI:setChineseName(Image_act_bg, "主界面_操作_背景图")
	GUI:setAnchorPoint(Image_act_bg, 1.00, 0.00)
	GUI:setTouchEnabled(Image_act_bg, false)
	GUI:setTag(Image_act_bg, 36)

	-- Create Button_role
	local Button_role = GUI:Button_Create(Panel_act, "Button_role", 48.00, 176.00, "res/public/0.png")
	GUI:Button_loadTexturePressed(Button_role, "res/private/main-win32/00000034.png")
	GUI:Button_setScale9Slice(Button_role, 1, 0, 1, 0)
	GUI:setContentSize(Button_role, 24, 24)
	GUI:setIgnoreContentAdaptWithSize(Button_role, false)
	GUI:Button_setTitleText(Button_role, "")
	GUI:Button_setTitleColor(Button_role, "#414146")
	GUI:Button_setTitleFontSize(Button_role, 14)
	GUI:Button_titleDisableOutLine(Button_role)
	GUI:setChineseName(Button_role, "主界面_人物_按钮")
	GUI:setAnchorPoint(Button_role, 0.50, 0.50)
	GUI:setTouchEnabled(Button_role, true)
	GUI:setTag(Button_role, 18)

	-- Create Button_bag
	local Button_bag = GUI:Button_Create(Panel_act, "Button_bag", 87.00, 196.00, "res/public/0.png")
	GUI:Button_loadTexturePressed(Button_bag, "res/private/main-win32/00000035.png")
	GUI:Button_setScale9Slice(Button_bag, 1, 0, 1, 0)
	GUI:setContentSize(Button_bag, 24, 24)
	GUI:setIgnoreContentAdaptWithSize(Button_bag, false)
	GUI:Button_setTitleText(Button_bag, "")
	GUI:Button_setTitleColor(Button_bag, "#414146")
	GUI:Button_setTitleFontSize(Button_bag, 14)
	GUI:Button_titleDisableOutLine(Button_bag)
	GUI:setChineseName(Button_bag, "主界面_背包_按钮")
	GUI:setAnchorPoint(Button_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_bag, true)
	GUI:setTag(Button_bag, 19)

	-- Create Button_skill
	local Button_skill = GUI:Button_Create(Panel_act, "Button_skill", 128.00, 216.00, "res/public/0.png")
	GUI:Button_loadTexturePressed(Button_skill, "res/private/main-win32/00000036.png")
	GUI:Button_setScale9Slice(Button_skill, 1, 0, 1, 0)
	GUI:setContentSize(Button_skill, 24, 24)
	GUI:setIgnoreContentAdaptWithSize(Button_skill, false)
	GUI:Button_setTitleText(Button_skill, "")
	GUI:Button_setTitleColor(Button_skill, "#414146")
	GUI:Button_setTitleFontSize(Button_skill, 14)
	GUI:Button_titleDisableOutLine(Button_skill)
	GUI:setChineseName(Button_skill, "主界面_技能_按钮")
	GUI:setAnchorPoint(Button_skill, 0.50, 0.50)
	GUI:setTouchEnabled(Button_skill, true)
	GUI:setTag(Button_skill, 20)

	-- Create Button_voice
	local Button_voice = GUI:Button_Create(Panel_act, "Button_voice", 170.00, 227.00, "res/public/0.png")
	GUI:Button_loadTexturePressed(Button_voice, "res/private/main-win32/00000037.png")
	GUI:Button_setScale9Slice(Button_voice, 1, 0, 1, 0)
	GUI:setContentSize(Button_voice, 24, 24)
	GUI:setIgnoreContentAdaptWithSize(Button_voice, false)
	GUI:Button_setTitleText(Button_voice, "")
	GUI:Button_setTitleColor(Button_voice, "#414146")
	GUI:Button_setTitleFontSize(Button_voice, 14)
	GUI:Button_titleDisableOutLine(Button_voice)
	GUI:setChineseName(Button_voice, "主界面_音量_按钮")
	GUI:setAnchorPoint(Button_voice, 0.50, 0.50)
	GUI:setTouchEnabled(Button_voice, true)
	GUI:setTag(Button_voice, 21)

	-- Create Button_store
	local Button_store = GUI:Button_Create(Panel_act, "Button_store", 160.00, 32.00, "res/private/main-win32/000038.png")
	GUI:Button_loadTexturePressed(Button_store, "res/private/main-win32/000039.png")
	GUI:Button_setScale9Slice(Button_store, 7, 7, 4, 4)
	GUI:setContentSize(Button_store, 28, 26)
	GUI:setIgnoreContentAdaptWithSize(Button_store, false)
	GUI:Button_setTitleText(Button_store, "")
	GUI:Button_setTitleColor(Button_store, "#414146")
	GUI:Button_setTitleFontSize(Button_store, 14)
	GUI:Button_titleDisableOutLine(Button_store)
	GUI:setChineseName(Button_store, "主界面_商城_按钮")
	GUI:setAnchorPoint(Button_store, 0.50, 0.50)
	GUI:setTouchEnabled(Button_store, true)
	GUI:setTag(Button_store, 49)

	-- Create Image_time
	local Image_time = GUI:Image_Create(Panel_act, "Image_time", 158.00, 142.00, "res/private/main-win32/00000045.png")
	GUI:setChineseName(Image_time, "主界面_时间_图片")
	GUI:setAnchorPoint(Image_time, 0.50, 0.50)
	GUI:setTouchEnabled(Image_time, true)
	GUI:setTag(Image_time, 235)

	-- Create LoadingBar_exp
	local LoadingBar_exp = GUI:LoadingBar_Create(Panel_act, "LoadingBar_exp", 97.00, 64.00, "res/private/main-win32/00000041.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_exp, 100)
	GUI:LoadingBar_setColor(LoadingBar_exp, "#ffffff")
	GUI:setChineseName(LoadingBar_exp, "主界面_经验条")
	GUI:setAnchorPoint(LoadingBar_exp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_exp, false)
	GUI:setTag(LoadingBar_exp, 282)

	-- Create LoadingBar_weight
	local LoadingBar_weight = GUI:LoadingBar_Create(Panel_act, "LoadingBar_weight", 97.00, 31.00, "res/private/main-win32/00000041.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_weight, 100)
	GUI:LoadingBar_setColor(LoadingBar_weight, "#ffffff")
	GUI:setChineseName(LoadingBar_weight, "主界面_负重条")
	GUI:setAnchorPoint(LoadingBar_weight, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_weight, false)
	GUI:setTag(LoadingBar_weight, 285)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_act, "Image_2", 89.00, 14.00, "res/private/main-win32/000018.png")
	GUI:setChineseName(Image_2, "主界面_时间_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 57)

	-- Create Text_time
	local Text_time = GUI:BmpText_Create(Panel_act, "Text_time", 89.00, 15.00, "#ffffff", [[50]])
	GUI:setChineseName(Text_time, "主界面_服务器时间")
	GUI:setAnchorPoint(Text_time, 0.50, 0.50)
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, 62)

	-- Create Text_level
	local Text_level = GUI:BmpText_Create(Panel_act, "Text_level", 71.00, 98.00, "#ffffff", [[50]])
	GUI:setChineseName(Text_level, "主界面_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 279)

	-- Create Text_FPS
	local Text_FPS = GUI:BmpText_Create(Panel_act, "Text_FPS", 161.00, 63.00, "#ffffff", [[FPS:60]])
	GUI:setChineseName(Text_FPS, "主界面_帧数_文本")
	GUI:setAnchorPoint(Text_FPS, 0.50, 0.50)
	GUI:setTouchEnabled(Text_FPS, false)
	GUI:setTag(Text_FPS, 93)

	-- Create Panel_hero
	local Panel_hero = GUI:Layout_Create(Panel_act, "Panel_hero", 30.00, 128.00, 92.00, 20.00, false)
	GUI:setChineseName(Panel_hero, "英雄操作组合")
	GUI:setTouchEnabled(Panel_hero, false)
	GUI:setTag(Panel_hero, 67)

	-- Create Button_herostate
	local Button_herostate = GUI:Button_Create(Panel_hero, "Button_herostate", 10.00, 9.00, "res/private/main-win32/00649.png")
	GUI:Button_loadTexturePressed(Button_herostate, "res/private/main-win32/00650.png")
	GUI:Button_setScale9Slice(Button_herostate, 7, 7, 6, 6)
	GUI:setContentSize(Button_herostate, 23, 19)
	GUI:setIgnoreContentAdaptWithSize(Button_herostate, false)
	GUI:Button_setTitleText(Button_herostate, "")
	GUI:Button_setTitleColor(Button_herostate, "#414146")
	GUI:Button_setTitleFontSize(Button_herostate, 14)
	GUI:Button_titleDisableOutLine(Button_herostate)
	GUI:setChineseName(Button_herostate, "英雄操作_召唤收回英雄")
	GUI:setAnchorPoint(Button_herostate, 0.50, 0.50)
	GUI:setTouchEnabled(Button_herostate, true)
	GUI:setTag(Button_herostate, 68)

	-- Create Button_heroinfo
	local Button_heroinfo = GUI:Button_Create(Panel_hero, "Button_heroinfo", 44.00, 9.00, "res/private/main-win32/00661.png")
	GUI:Button_loadTexturePressed(Button_heroinfo, "res/private/main-win32/00662.png")
	GUI:Button_setScale9Slice(Button_heroinfo, 7, 7, 13, 9)
	GUI:setContentSize(Button_heroinfo, 23, 19)
	GUI:setIgnoreContentAdaptWithSize(Button_heroinfo, false)
	GUI:Button_setTitleText(Button_heroinfo, "")
	GUI:Button_setTitleColor(Button_heroinfo, "#414146")
	GUI:Button_setTitleFontSize(Button_heroinfo, 14)
	GUI:Button_titleDisableOutLine(Button_heroinfo)
	GUI:setChineseName(Button_heroinfo, "英雄操作_英雄信息")
	GUI:setAnchorPoint(Button_heroinfo, 0.50, 0.50)
	GUI:setTouchEnabled(Button_heroinfo, true)
	GUI:setTag(Button_heroinfo, 69)

	-- Create Button_herobag
	local Button_herobag = GUI:Button_Create(Panel_hero, "Button_herobag", 76.00, 10.00, "res/private/main-win32/00655.png")
	GUI:Button_loadTexturePressed(Button_herobag, "res/private/main-win32/00656.png")
	GUI:Button_setScale9Slice(Button_herobag, 7, 7, 13, 9)
	GUI:setContentSize(Button_herobag, 23, 19)
	GUI:setIgnoreContentAdaptWithSize(Button_herobag, false)
	GUI:Button_setTitleText(Button_herobag, "")
	GUI:Button_setTitleColor(Button_herobag, "#414146")
	GUI:Button_setTitleFontSize(Button_herobag, 14)
	GUI:Button_titleDisableOutLine(Button_herobag)
	GUI:setChineseName(Button_herobag, "英雄操作_英雄包裹")
	GUI:setAnchorPoint(Button_herobag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_herobag, true)
	GUI:setTag(Button_herobag, 70)

	-- Create Image_laodBarbg
	local Image_laodBarbg = GUI:Image_Create(Panel_act, "Image_laodBarbg", 0.00, 0.00, "res/private/main-win32/01072.png")
	GUI:Image_setScale9Slice(Image_laodBarbg, 6, 6, 45, 43)
	GUI:setContentSize(Image_laodBarbg, 20, 154)
	GUI:setIgnoreContentAdaptWithSize(Image_laodBarbg, false)
	GUI:setChineseName(Image_laodBarbg, "英雄_怒气条组合")
	GUI:setTouchEnabled(Image_laodBarbg, false)
	GUI:setTag(Image_laodBarbg, 67)

	-- Create Panel_loadBar
	local Panel_loadBar = GUI:Layout_Create(Image_laodBarbg, "Panel_loadBar", 0.00, 0.00, 19.00, 156.00, true)
	GUI:setChineseName(Panel_loadBar, "英雄_怒气条组合")
	GUI:setTouchEnabled(Panel_loadBar, true)
	GUI:setTag(Panel_loadBar, 66)

	-- Create Image_loadbar1
	local Image_loadbar1 = GUI:Image_Create(Panel_loadBar, "Image_loadbar1", 0.00, 0.00, "res/private/main-win32/01070.png")
	GUI:Image_setScale9Slice(Image_loadbar1, 6, 6, 45, 43)
	GUI:setContentSize(Image_loadbar1, 20, 154)
	GUI:setIgnoreContentAdaptWithSize(Image_loadbar1, false)
	GUI:setChineseName(Image_loadbar1, "英雄_怒气条")
	GUI:setTouchEnabled(Image_loadbar1, false)
	GUI:setTag(Image_loadbar1, 68)

	-- Create Image_loadbar2
	local Image_loadbar2 = GUI:Image_Create(Panel_loadBar, "Image_loadbar2", 0.00, 0.00, "res/private/main-win32/01071.png")
	GUI:Image_setScale9Slice(Image_loadbar2, 6, 6, 45, 43)
	GUI:setContentSize(Image_loadbar2, 20, 155)
	GUI:setIgnoreContentAdaptWithSize(Image_loadbar2, false)
	GUI:setChineseName(Image_loadbar2, "英雄_怒气条满")
	GUI:setTouchEnabled(Image_loadbar2, false)
	GUI:setTag(Image_loadbar2, 69)
	GUI:setVisible(Image_loadbar2, false)

	-- Create Text_pkmode
	local Text_pkmode = GUI:BmpText_Create(Panel_act, "Text_pkmode", 78.00, 119.00, "#ffffff", [==========[[全体攻击模式]]==========])
	GUI:setChineseName(Text_pkmode, "主界面_当前攻击模式_文本")
	GUI:setAnchorPoint(Text_pkmode, 0.50, 0.50)
	GUI:setTouchEnabled(Text_pkmode, true)
	GUI:setTag(Text_pkmode, 41)

	-- Create Panel_channel
	local Panel_channel = GUI:Layout_Create(Panel_act, "Panel_channel", 0.00, 0.00, 50.00, 120.00, false)
	GUI:setChineseName(Panel_channel, "聊天过滤组合")
	GUI:setTouchEnabled(Panel_channel, false)
	GUI:setTag(Panel_channel, 237)
	GUI:setVisible(Panel_channel, false)

	-- Create Button_channel_0
	local Button_channel_0 = GUI:Button_Create(Panel_channel, "Button_channel_0", 25.00, 104.00, "res/private/main-win32/c0_2.png")
	GUI:Button_loadTexturePressed(Button_channel_0, "res/private/main-win32/c0_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_0, "res/private/main-win32/c0_1.png")
	GUI:Button_setScale9Slice(Button_channel_0, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_0, 48, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_0, false)
	GUI:Button_setTitleText(Button_channel_0, "")
	GUI:Button_setTitleColor(Button_channel_0, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_0, 14)
	GUI:Button_titleDisableOutLine(Button_channel_0)
	GUI:setChineseName(Button_channel_0, "聊天过滤_综合_按钮")
	GUI:setAnchorPoint(Button_channel_0, 0.50, 0.50)
	GUI:setTouchEnabled(Button_channel_0, true)
	GUI:setTag(Button_channel_0, 238)

	-- Create Button_channel_1
	local Button_channel_1 = GUI:Button_Create(Panel_channel, "Button_channel_1", 25.00, 81.00, "res/private/main-win32/c1_2.png")
	GUI:Button_loadTexturePressed(Button_channel_1, "res/private/main-win32/c1_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_1, "res/private/main-win32/c1_1.png")
	GUI:Button_setScale9Slice(Button_channel_1, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_1, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_1, false)
	GUI:Button_setTitleText(Button_channel_1, "")
	GUI:Button_setTitleColor(Button_channel_1, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_1, 14)
	GUI:Button_titleDisableOutLine(Button_channel_1)
	GUI:setChineseName(Button_channel_1, "聊天过滤_系统_按钮")
	GUI:setAnchorPoint(Button_channel_1, 1.00, 0.50)
	GUI:setTouchEnabled(Button_channel_1, true)
	GUI:setTag(Button_channel_1, 239)

	-- Create Button_channel_2
	local Button_channel_2 = GUI:Button_Create(Panel_channel, "Button_channel_2", 25.00, 81.00, "res/private/main-win32/c2_2.png")
	GUI:Button_loadTexturePressed(Button_channel_2, "res/private/main-win32/c2_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_2, "res/private/main-win32/c2_1.png")
	GUI:Button_setScale9Slice(Button_channel_2, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_2, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_2, false)
	GUI:Button_setTitleText(Button_channel_2, "")
	GUI:Button_setTitleColor(Button_channel_2, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_2, 14)
	GUI:Button_titleDisableOutLine(Button_channel_2)
	GUI:setChineseName(Button_channel_2, "聊天过滤_喊话_按钮")
	GUI:setAnchorPoint(Button_channel_2, 0.00, 0.50)
	GUI:setTouchEnabled(Button_channel_2, true)
	GUI:setTag(Button_channel_2, 240)

	-- Create Button_channel_3
	local Button_channel_3 = GUI:Button_Create(Panel_channel, "Button_channel_3", 25.00, 58.00, "res/private/main-win32/c3_2.png")
	GUI:Button_loadTexturePressed(Button_channel_3, "res/private/main-win32/c3_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_3, "res/private/main-win32/c3_1.png")
	GUI:Button_setScale9Slice(Button_channel_3, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_3, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_3, false)
	GUI:Button_setTitleText(Button_channel_3, "")
	GUI:Button_setTitleColor(Button_channel_3, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_3, 14)
	GUI:Button_titleDisableOutLine(Button_channel_3)
	GUI:setChineseName(Button_channel_3, "聊天过滤_私聊_按钮")
	GUI:setAnchorPoint(Button_channel_3, 1.00, 0.50)
	GUI:setTouchEnabled(Button_channel_3, true)
	GUI:setTag(Button_channel_3, 241)

	-- Create Button_channel_4
	local Button_channel_4 = GUI:Button_Create(Panel_channel, "Button_channel_4", 25.00, 58.00, "res/private/main-win32/c4_2.png")
	GUI:Button_loadTexturePressed(Button_channel_4, "res/private/main-win32/c4_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_4, "res/private/main-win32/c4_1.png")
	GUI:Button_setScale9Slice(Button_channel_4, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_4, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_4, false)
	GUI:Button_setTitleText(Button_channel_4, "")
	GUI:Button_setTitleColor(Button_channel_4, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_4, 14)
	GUI:Button_titleDisableOutLine(Button_channel_4)
	GUI:setChineseName(Button_channel_4, "聊天过滤_行会_按钮")
	GUI:setAnchorPoint(Button_channel_4, 0.00, 0.50)
	GUI:setTouchEnabled(Button_channel_4, true)
	GUI:setTag(Button_channel_4, 242)

	-- Create Button_channel_5
	local Button_channel_5 = GUI:Button_Create(Panel_channel, "Button_channel_5", 25.00, 35.00, "res/private/main-win32/c5_2.png")
	GUI:Button_loadTexturePressed(Button_channel_5, "res/private/main-win32/c5_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_5, "res/private/main-win32/c5_1.png")
	GUI:Button_setScale9Slice(Button_channel_5, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_5, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_5, false)
	GUI:Button_setTitleText(Button_channel_5, "")
	GUI:Button_setTitleColor(Button_channel_5, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_5, 14)
	GUI:Button_titleDisableOutLine(Button_channel_5)
	GUI:setChineseName(Button_channel_5, "聊天过滤_组队_按钮")
	GUI:setAnchorPoint(Button_channel_5, 1.00, 0.50)
	GUI:setTouchEnabled(Button_channel_5, true)
	GUI:setTag(Button_channel_5, 243)

	-- Create Button_channel_6
	local Button_channel_6 = GUI:Button_Create(Panel_channel, "Button_channel_6", 25.00, 35.00, "res/private/main-win32/c6_2.png")
	GUI:Button_loadTexturePressed(Button_channel_6, "res/private/main-win32/c6_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_6, "res/private/main-win32/c6_1.png")
	GUI:Button_setScale9Slice(Button_channel_6, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_6, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_6, false)
	GUI:Button_setTitleText(Button_channel_6, "")
	GUI:Button_setTitleColor(Button_channel_6, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_6, 14)
	GUI:Button_titleDisableOutLine(Button_channel_6)
	GUI:setChineseName(Button_channel_6, "聊天过滤_附近_按钮")
	GUI:setAnchorPoint(Button_channel_6, 0.00, 0.50)
	GUI:setTouchEnabled(Button_channel_6, true)
	GUI:setTag(Button_channel_6, 244)

	-- Create Button_channel_7
	local Button_channel_7 = GUI:Button_Create(Panel_channel, "Button_channel_7", 25.00, 12.00, "res/private/main-win32/c7_2.png")
	GUI:Button_loadTexturePressed(Button_channel_7, "res/private/main-win32/c7_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_7, "res/private/main-win32/c7_1.png")
	GUI:Button_setScale9Slice(Button_channel_7, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_7, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_7, false)
	GUI:Button_setTitleText(Button_channel_7, "")
	GUI:Button_setTitleColor(Button_channel_7, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_7, 14)
	GUI:Button_titleDisableOutLine(Button_channel_7)
	GUI:setChineseName(Button_channel_7, "聊天过滤_传音/世界_按钮")
	GUI:setAnchorPoint(Button_channel_7, 1.00, 0.50)
	GUI:setTouchEnabled(Button_channel_7, true)
	GUI:setTag(Button_channel_7, 245)

	-- Create Button_channel_8
	local Button_channel_8 = GUI:Button_Create(Panel_channel, "Button_channel_8", 25.00, 12.00, "res/private/main-win32/c8_2.png")
	GUI:Button_loadTexturePressed(Button_channel_8, "res/private/main-win32/c8_1.png")
	GUI:Button_loadTextureDisabled(Button_channel_8, "res/private/main-win32/c8_1.png")
	GUI:Button_setScale9Slice(Button_channel_8, 5, 5, 5, 5)
	GUI:setContentSize(Button_channel_8, 24, 23)
	GUI:setIgnoreContentAdaptWithSize(Button_channel_8, false)
	GUI:Button_setTitleText(Button_channel_8, "")
	GUI:Button_setTitleColor(Button_channel_8, "#414146")
	GUI:Button_setTitleFontSize(Button_channel_8, 14)
	GUI:Button_titleDisableOutLine(Button_channel_8)
	GUI:setChineseName(Button_channel_8, "聊天过滤_国家_按钮")
	GUI:setAnchorPoint(Button_channel_8, 0.00, 0.50)
	GUI:setTouchEnabled(Button_channel_8, true)
	GUI:setTag(Button_channel_8, 246)

	-- Create Button_pick
	local Button_pick = GUI:Button_Create(Panel_act, "Button_pick", 194.00, 330.00, "res/private/main-win32/btn_zhijiemian_05.png")
	GUI:Button_setScale9Slice(Button_pick, 15, 15, 12, 10)
	GUI:setContentSize(Button_pick, 59, 59)
	GUI:setIgnoreContentAdaptWithSize(Button_pick, false)
	GUI:Button_setTitleText(Button_pick, "")
	GUI:Button_setTitleColor(Button_pick, "#414146")
	GUI:Button_setTitleFontSize(Button_pick, 14)
	GUI:Button_titleDisableOutLine(Button_pick)
	GUI:setChineseName(Button_pick, "主界面_快速拾取_按钮")
	GUI:setAnchorPoint(Button_pick, 1.00, 0.00)
	GUI:setTouchEnabled(Button_pick, true)
	GUI:setTag(Button_pick, 59)

	-- Create Panel_ng_show
	local Panel_ng_show = GUI:Layout_Create(Panel_act, "Panel_ng_show", -2.00, 138.00, 20.00, 16.00, false)
	GUI:Layout_setBackGroundColorType(Panel_ng_show, 1)
	GUI:Layout_setBackGroundColor(Panel_ng_show, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(Panel_ng_show, 140)
	GUI:setChineseName(Panel_ng_show, "主界面_连击组合")
	GUI:setTouchEnabled(Panel_ng_show, false)
	GUI:setTag(Panel_ng_show, -1)
	GUI:setVisible(Panel_ng_show, false)

	-- Create ng_show_bg
	local ng_show_bg = GUI:Image_Create(Panel_ng_show, "ng_show_bg", 0.00, 0.00, "res/private/main-win32/01120.png")
	GUI:setChineseName(ng_show_bg, "主界面_连击_背景图")
	GUI:setTouchEnabled(ng_show_bg, false)
	GUI:setTag(ng_show_bg, -1)

	-- Create Image_ng_shan
	local Image_ng_shan = GUI:Image_Create(Panel_ng_show, "Image_ng_shan", 0.00, 0.00, "res/private/main-win32/01121.png")
	GUI:setChineseName(Image_ng_shan, "主界面_连击可用_图片")
	GUI:setTouchEnabled(Image_ng_shan, false)
	GUI:setTag(Image_ng_shan, -1)
	GUI:setVisible(Image_ng_shan, false)

	-- Create Panel_bubble_tips
	local Panel_bubble_tips = GUI:Layout_Create(Panel_bg, "Panel_bubble_tips", 195.00, 210.00, 150.00, 50.00, false)
	GUI:setChineseName(Panel_bubble_tips, "提示信息组合")
	GUI:setTouchEnabled(Panel_bubble_tips, false)
	GUI:setTag(Panel_bubble_tips, 55)

	-- Create ListView_bubble_tips
	local ListView_bubble_tips = GUI:ListView_Create(Panel_bubble_tips, "ListView_bubble_tips", 0.00, 0.00, 150.00, 50.00, 2)
	GUI:ListView_setGravity(ListView_bubble_tips, 3)
	GUI:setChineseName(ListView_bubble_tips, "提示信息列表(邮件/交易等)")
	GUI:setTouchEnabled(ListView_bubble_tips, false)
	GUI:setTag(ListView_bubble_tips, 56)

	-- Create Panel_mid
	local Panel_mid = GUI:Layout_Create(Node, "Panel_mid", 0.00, 4.00, 500.00, 300.00, false)
	GUI:setChineseName(Panel_mid, "主界面_内功_背景图")
	GUI:setAnchorPoint(Panel_mid, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_mid, false)
	GUI:setTag(Panel_mid, -1)

	-- Create Panel_quick
	local Panel_quick = GUI:Layout_Create(Panel_mid, "Panel_quick", 250.00, 150.00, 440.00, 55.00, false)
	GUI:setChineseName(Panel_quick, "主界面_快捷栏组合")
	GUI:setAnchorPoint(Panel_quick, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_quick, false)
	GUI:setTag(Panel_quick, 59)

	-- Create Image_quick_bg
	local Image_quick_bg = GUI:Image_Create(Panel_quick, "Image_quick_bg", 220.00, 0.00, "res/private/main-win32/00000040.png")
	GUI:Image_setScale9Slice(Image_quick_bg, 69, 69, 22, 22)
	GUI:setContentSize(Image_quick_bg, 440, 54)
	GUI:setIgnoreContentAdaptWithSize(Image_quick_bg, false)
	GUI:setChineseName(Image_quick_bg, "主界面_快捷栏_背景图")
	GUI:setAnchorPoint(Image_quick_bg, 0.50, 0.00)
	GUI:setTouchEnabled(Image_quick_bg, false)
	GUI:setTag(Image_quick_bg, 60)

	-- Create Panel_quick_use_1
	local Panel_quick_use_1 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_1", 111.00, 22.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_1, "主界面_快捷栏1")
	GUI:setAnchorPoint(Panel_quick_use_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_1, true)
	GUI:setTag(Panel_quick_use_1, 46)

	-- Create Panel_quick_use_2
	local Panel_quick_use_2 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_2", 154.00, 21.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_2, "主界面_快捷栏2")
	GUI:setAnchorPoint(Panel_quick_use_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_2, true)
	GUI:setTag(Panel_quick_use_2, 47)

	-- Create Panel_quick_use_3
	local Panel_quick_use_3 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_3", 198.00, 21.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_3, "主界面_快捷栏3")
	GUI:setAnchorPoint(Panel_quick_use_3, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_3, true)
	GUI:setTag(Panel_quick_use_3, 48)

	-- Create Panel_quick_use_4
	local Panel_quick_use_4 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_4", 241.00, 21.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_4, "主界面_快捷栏4")
	GUI:setAnchorPoint(Panel_quick_use_4, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_4, true)
	GUI:setTag(Panel_quick_use_4, 49)

	-- Create Panel_quick_use_5
	local Panel_quick_use_5 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_5", 285.00, 21.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_5, "主界面_快捷栏5")
	GUI:setAnchorPoint(Panel_quick_use_5, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_5, true)
	GUI:setTag(Panel_quick_use_5, 50)

	-- Create Panel_quick_use_6
	local Panel_quick_use_6 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_6", 329.00, 21.00, 30.00, 30.00, false)
	GUI:setChineseName(Panel_quick_use_6, "主界面_快捷栏6")
	GUI:setAnchorPoint(Panel_quick_use_6, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_quick_use_6, true)
	GUI:setTag(Panel_quick_use_6, 51)

	-- Create Node_quit_tip
	local Node_quit_tip = GUI:Node_Create(Panel_mid, "Node_quit_tip", 250.00, 220.00)
	GUI:setChineseName(Node_quit_tip, "主界面_提示文本_节点")
	GUI:setAnchorPoint(Node_quit_tip, 0.50, 0.50)
	GUI:setTag(Node_quit_tip, 305)

	-- Create Panel_auto_tips
	local Panel_auto_tips = GUI:Layout_Create(Panel_mid, "Panel_auto_tips", 250.00, 210.00, 300.00, 50.00, false)
	GUI:setChineseName(Panel_auto_tips, "主界面_自动挂机_提示")
	GUI:setAnchorPoint(Panel_auto_tips, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_auto_tips, false)
	GUI:setTag(Panel_auto_tips, 58)

	-- Create Panel_hide_drop
	local Panel_hide_drop = GUI:Layout_Create(Node, "Panel_hide_drop", 0.00, 0.00, 1024.00, 200.00, false)
	GUI:setAnchorPoint(Panel_hide_drop, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_hide_drop, false)
	GUI:setTag(Panel_hide_drop, -1)

	-- Create Panel_drop
	local Panel_drop = GUI:Layout_Create(Node, "Panel_drop", 227.00, 144.00, 88.00, 108.00, false)
	GUI:setChineseName(Panel_drop, "聊天_掉落屏蔽_组合")
	GUI:setAnchorPoint(Panel_drop, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_drop, false)
	GUI:setTag(Panel_drop, 145)
	GUI:setVisible(Panel_drop, false)

	-- Create Image_drop_bg
	local Image_drop_bg = GUI:Image_Create(Panel_drop, "Image_drop_bg", 44.00, 54.00, "res/public/1900000677.png")
	GUI:Image_setScale9Slice(Image_drop_bg, 21, 21, 37, 29)
	GUI:setContentSize(Image_drop_bg, 88, 108)
	GUI:setIgnoreContentAdaptWithSize(Image_drop_bg, false)
	GUI:setChineseName(Image_drop_bg, "聊天_掉落屏蔽_背景图")
	GUI:setAnchorPoint(Image_drop_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_drop_bg, false)
	GUI:setTag(Image_drop_bg, 147)

	-- Create ListView_drop
	local ListView_drop = GUI:ListView_Create(Panel_drop, "ListView_drop", 44.00, 3.00, 86.00, 102.00, 1)
	GUI:ListView_setClippingEnabled(ListView_drop, false)
	GUI:ListView_setGravity(ListView_drop, 2)
	GUI:setChineseName(ListView_drop, "聊天_掉落开关_列表")
	GUI:setAnchorPoint(ListView_drop, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_drop, true)
	GUI:setTag(ListView_drop, 146)
end
return ui