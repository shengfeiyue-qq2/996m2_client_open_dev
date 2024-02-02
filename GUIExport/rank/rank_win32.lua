local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "排行榜场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 349.00, 700.00, 442.00, false)
	GUI:setChineseName(Panel_1, "排行榜组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 30)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Panel_1, "Panel_bg", 9.00, 226.00, 686.00, 444.00, false)
	GUI:setChineseName(Panel_bg, "排行榜_背景组合")
	GUI:setAnchorPoint(Panel_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, 31)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 343.00, 222.00, "res/private/rank_ui/rank_ui_win32/1900020020.png")
	GUI:Image_setScale9Slice(Image_bg, 340, 340, 204, 204)
	GUI:setContentSize(Image_bg, 686, 444)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "排行榜_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 32)

	-- Create Panel_type
	local Panel_type = GUI:Layout_Create(Panel_1, "Panel_type", 94.00, 373.00, 185.00, 45.00, false)
	GUI:setChineseName(Panel_type, "排行榜_玩家和英雄组合")
	GUI:setTouchEnabled(Panel_type, true)
	GUI:setTag(Panel_type, 107)

	-- Create Panel_player
	local Panel_player = GUI:Layout_Create(Panel_type, "Panel_player", 47.00, 19.00, 88.00, 33.00, false)
	GUI:setChineseName(Panel_player, "排行榜_玩家组合")
	GUI:setAnchorPoint(Panel_player, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_player, false)
	GUI:setTag(Panel_player, 108)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_player, "Button_1", 44.00, 16.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setScale9Slice(Button_1, 16, 14, 11, 11)
	GUI:setContentSize(Button_1, 33, 88)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#414146")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:setChineseName(Button_1, "排行榜_玩家_按钮")
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setRotation(Button_1, 90.00)
	GUI:setRotationSkewX(Button_1, 90.00)
	GUI:setRotationSkewY(Button_1, 90.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 109)

	-- Create Text_title1
	local Text_title1 = GUI:Text_Create(Panel_player, "Text_title1", 41.00, 26.00, 18, "#6c6861", [[玩家]])
	GUI:setChineseName(Text_title1, "排行榜_玩家_文本")
	GUI:setAnchorPoint(Text_title1, 0.50, 1.00)
	GUI:setTouchEnabled(Text_title1, false)
	GUI:setTag(Text_title1, 110)
	GUI:Text_enableOutline(Text_title1, "#111111", 2)

	-- Create Panel_hero
	local Panel_hero = GUI:Layout_Create(Panel_type, "Panel_hero", 137.00, 19.00, 88.00, 33.00, false)
	GUI:setChineseName(Panel_hero, "排行榜_英雄组合")
	GUI:setAnchorPoint(Panel_hero, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_hero, false)
	GUI:setTag(Panel_hero, 111)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_hero, "Button_2", 44.00, 16.00, "res/private/rank_ui/rank_ui_mobile/1900012110.png")
	GUI:Button_loadTexturePressed(Button_2, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/private/rank_ui/rank_ui_mobile/1900012111.png")
	GUI:Button_setScale9Slice(Button_2, 16, 14, 11, 11)
	GUI:setContentSize(Button_2, 33, 88)
	GUI:setIgnoreContentAdaptWithSize(Button_2, false)
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#414146")
	GUI:Button_setTitleFontSize(Button_2, 14)
	GUI:Button_titleDisableOutLine(Button_2)
	GUI:setChineseName(Button_2, "排行榜_英雄_按钮")
	GUI:setAnchorPoint(Button_2, 0.50, 0.50)
	GUI:setRotation(Button_2, 90.00)
	GUI:setRotationSkewX(Button_2, 90.00)
	GUI:setRotationSkewY(Button_2, 90.00)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, 112)

	-- Create Text_title2
	local Text_title2 = GUI:Text_Create(Panel_hero, "Text_title2", 41.00, 26.00, 18, "#6c6861", [[英雄]])
	GUI:setChineseName(Text_title2, "排行榜_英雄_文本")
	GUI:setAnchorPoint(Text_title2, 0.50, 1.00)
	GUI:setTouchEnabled(Text_title2, false)
	GUI:setTag(Text_title2, 113)
	GUI:Text_enableOutline(Text_title2, "#111111", 2)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 16.00, 34.00, 60.00, 310.00, false)
	GUI:setChineseName(Panel_btnList, "排行榜_排行分类组合")
	GUI:setTouchEnabled(Panel_btnList, true)
	GUI:setTag(Panel_btnList, 33)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Panel_btnList, "ListView_1", 33.00, 308.00, 27.00, 310.00, 1)
	GUI:ListView_setGravity(ListView_1, 2)
	GUI:ListView_setItemsMargin(ListView_1, 5)
	GUI:setChineseName(ListView_1, "排行榜_排行分类_列表")
	GUI:setAnchorPoint(ListView_1, 0.50, 1.00)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 34)

	-- Create Image_13
	local Image_13 = GUI:Image_Create(Panel_1, "Image_13", 361.00, 399.00, "res/private/rank_ui/rank_ui_win32/1900020024.png")
	GUI:setChineseName(Image_13, "排行榜_标题_图片")
	GUI:setAnchorPoint(Image_13, 0.50, 0.50)
	GUI:setTouchEnabled(Image_13, false)
	GUI:setTag(Image_13, 35)

	-- Create ListView_list
	local ListView_list = GUI:ListView_Create(Panel_1, "ListView_list", 100.00, 57.00, 370.00, 307.00, 1)
	GUI:ListView_setGravity(ListView_list, 5)
	GUI:setChineseName(ListView_list, "排行榜_排行详细_列表")
	GUI:setTouchEnabled(ListView_list, true)
	GUI:setTag(ListView_list, 46)

	-- Create Node_model
	local Node_model = GUI:Node_Create(Panel_1, "Node_model", 525.00, 192.00)
	GUI:setChineseName(Node_model, "排行榜_模型_节点")
	GUI:setAnchorPoint(Node_model, 0.50, 0.50)
	GUI:setTag(Node_model, 47)

	-- Create Button_looks
	local Button_looks = GUI:Button_Create(Panel_1, "Button_looks", 529.00, 70.00, "res/public_win32/1900000679.png")
	GUI:Button_loadTexturePressed(Button_looks, "res/public_win32/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_looks, 15, 15, 11, 11)
	GUI:setContentSize(Button_looks, 72, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_looks, false)
	GUI:Button_setTitleText(Button_looks, "查看")
	GUI:Button_setTitleColor(Button_looks, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_looks, 18)
	GUI:Button_titleEnableOutline(Button_looks, "#111111", 2)
	GUI:setChineseName(Button_looks, "排行榜_查看_按钮")
	GUI:setAnchorPoint(Button_looks, 0.50, 0.50)
	GUI:setTouchEnabled(Button_looks, true)
	GUI:setTag(Button_looks, 48)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 647.00, 362.00, "res/public_win32/1900000530.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public_win32/1900000531.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 11, 11)
	GUI:setContentSize(Button_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "排行榜_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 49)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", -23.00, -17.00, 70.00, 70.00, false)
	GUI:setChineseName(TouchSize, "排行榜_关闭_触摸")
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 50)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_myInfo
	local Panel_myInfo = GUI:Layout_Create(Panel_1, "Panel_myInfo", 100.00, 30.00, 370.00, 26.00, false)
	GUI:setChineseName(Panel_myInfo, "排行榜_我的信息组合")
	GUI:setTouchEnabled(Panel_myInfo, true)
	GUI:setTag(Panel_myInfo, 57)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_myInfo, "Text_5", 101.00, 12.00, 14, "#ffffff", [[我的排名：]])
	GUI:setChineseName(Text_5, "排行榜_我的排名_文本")
	GUI:setAnchorPoint(Text_5, 1.00, 0.50)
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, 58)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_myInfo, "Text_level", 106.00, 13.00, 14, "#ffffff", [[未上榜]])
	GUI:setChineseName(Text_level, "排行榜_名次_文本")
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 59)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_7
	local Text_7 = GUI:Text_Create(Panel_myInfo, "Text_7", 264.00, 12.00, 14, "#ffffff", [[所属行会：]])
	GUI:setChineseName(Text_7, "排行榜_所属行会_文本")
	GUI:setAnchorPoint(Text_7, 1.00, 0.50)
	GUI:setTouchEnabled(Text_7, false)
	GUI:setTag(Text_7, 60)
	GUI:Text_enableOutline(Text_7, "#000000", 1)

	-- Create Text_guildName
	local Text_guildName = GUI:Text_Create(Panel_myInfo, "Text_guildName", 269.00, 13.00, 14, "#ffffff", [[无]])
	GUI:setChineseName(Text_guildName, "排行榜_行会名称_文本")
	GUI:setAnchorPoint(Text_guildName, 0.00, 0.50)
	GUI:setTouchEnabled(Text_guildName, false)
	GUI:setTag(Text_guildName, 61)
	GUI:Text_enableOutline(Text_guildName, "#000000", 1)
end
return ui