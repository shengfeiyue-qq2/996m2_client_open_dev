local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 377.00, 325.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 151)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 176.00, 161.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/bg_jewelry_1.png")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 152)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 177.00, 280.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_jewelry_1.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 153)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 177.00, 281.00, "res/public/word_sxbt_05.png")
	GUI:setContentSize(Image_3, 238, 11)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 154)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 30.00, 243.00, 292.00, 219.00, false)
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 155)

	-- Create Image_30
	local Image_30 = GUI:Image_Create(Panel_items, "Image_30", 35.00, 185.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_30, 0.50, 0.50)
	GUI:setTouchEnabled(Image_30, false)
	GUI:setTag(Image_30, 156)

	-- Create Image_tag30
	local Image_tag30 = GUI:Image_Create(Panel_items, "Image_tag30", 35.00, 185.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_1.png")
	GUI:setAnchorPoint(Image_tag30, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag30, false)
	GUI:setTag(Image_tag30, 157)

	-- Create Image_31
	local Image_31 = GUI:Image_Create(Panel_items, "Image_31", 108.00, 185.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_31, 0.50, 0.50)
	GUI:setTouchEnabled(Image_31, false)
	GUI:setTag(Image_31, 158)

	-- Create Image_tag31
	local Image_tag31 = GUI:Image_Create(Panel_items, "Image_tag31", 108.00, 185.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_2.png")
	GUI:setAnchorPoint(Image_tag31, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag31, false)
	GUI:setTag(Image_tag31, 159)

	-- Create Image_32
	local Image_32 = GUI:Image_Create(Panel_items, "Image_32", 182.00, 185.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_32, 0.50, 0.50)
	GUI:setTouchEnabled(Image_32, false)
	GUI:setTag(Image_32, 160)

	-- Create Image_tag32
	local Image_tag32 = GUI:Image_Create(Panel_items, "Image_tag32", 182.00, 185.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_3.png")
	GUI:setAnchorPoint(Image_tag32, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag32, false)
	GUI:setTag(Image_tag32, 161)

	-- Create Image_33
	local Image_33 = GUI:Image_Create(Panel_items, "Image_33", 255.00, 185.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_33, 0.50, 0.50)
	GUI:setTouchEnabled(Image_33, false)
	GUI:setTag(Image_33, 162)

	-- Create Image_tag33
	local Image_tag33 = GUI:Image_Create(Panel_items, "Image_tag33", 255.00, 185.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_4.png")
	GUI:setAnchorPoint(Image_tag33, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag33, false)
	GUI:setTag(Image_tag33, 163)

	-- Create Image_34
	local Image_34 = GUI:Image_Create(Panel_items, "Image_34", 35.00, 110.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_34, 0.50, 0.50)
	GUI:setTouchEnabled(Image_34, false)
	GUI:setTag(Image_34, 164)

	-- Create Image_tag34
	local Image_tag34 = GUI:Image_Create(Panel_items, "Image_tag34", 35.00, 110.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_5.png")
	GUI:setAnchorPoint(Image_tag34, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag34, false)
	GUI:setTag(Image_tag34, 165)

	-- Create Image_35
	local Image_35 = GUI:Image_Create(Panel_items, "Image_35", 108.00, 110.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_35, 0.50, 0.50)
	GUI:setTouchEnabled(Image_35, false)
	GUI:setTag(Image_35, 166)

	-- Create Image_tag35
	local Image_tag35 = GUI:Image_Create(Panel_items, "Image_tag35", 108.00, 110.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_6.png")
	GUI:setAnchorPoint(Image_tag35, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag35, false)
	GUI:setTag(Image_tag35, 167)

	-- Create Image_36
	local Image_36 = GUI:Image_Create(Panel_items, "Image_36", 182.00, 110.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_36, 0.50, 0.50)
	GUI:setTouchEnabled(Image_36, false)
	GUI:setTag(Image_36, 168)

	-- Create Image_tag36
	local Image_tag36 = GUI:Image_Create(Panel_items, "Image_tag36", 182.00, 110.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_7.png")
	GUI:setAnchorPoint(Image_tag36, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag36, false)
	GUI:setTag(Image_tag36, 169)

	-- Create Image_37
	local Image_37 = GUI:Image_Create(Panel_items, "Image_37", 255.00, 110.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_37, 0.50, 0.50)
	GUI:setTouchEnabled(Image_37, false)
	GUI:setTag(Image_37, 170)

	-- Create Image_tag37
	local Image_tag37 = GUI:Image_Create(Panel_items, "Image_tag37", 255.00, 110.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_8.png")
	GUI:setAnchorPoint(Image_tag37, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag37, false)
	GUI:setTag(Image_tag37, 171)

	-- Create Image_38
	local Image_38 = GUI:Image_Create(Panel_items, "Image_38", 35.00, 35.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_38, 0.50, 0.50)
	GUI:setTouchEnabled(Image_38, false)
	GUI:setTag(Image_38, 172)

	-- Create Image_tag38
	local Image_tag38 = GUI:Image_Create(Panel_items, "Image_tag38", 35.00, 35.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_9.png")
	GUI:setAnchorPoint(Image_tag38, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag38, false)
	GUI:setTag(Image_tag38, 173)

	-- Create Image_39
	local Image_39 = GUI:Image_Create(Panel_items, "Image_39", 108.00, 35.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_39, 0.50, 0.50)
	GUI:setTouchEnabled(Image_39, false)
	GUI:setTag(Image_39, 174)

	-- Create Image_tag39
	local Image_tag39 = GUI:Image_Create(Panel_items, "Image_tag39", 108.00, 35.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_10.png")
	GUI:setAnchorPoint(Image_tag39, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag39, false)
	GUI:setTag(Image_tag39, 175)

	-- Create Image_40
	local Image_40 = GUI:Image_Create(Panel_items, "Image_40", 182.00, 35.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_40, 0.50, 0.50)
	GUI:setTouchEnabled(Image_40, false)
	GUI:setTag(Image_40, 176)

	-- Create Image_tag40
	local Image_tag40 = GUI:Image_Create(Panel_items, "Image_tag40", 182.00, 35.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_11.png")
	GUI:setAnchorPoint(Image_tag40, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag40, false)
	GUI:setTag(Image_tag40, 177)

	-- Create Image_41
	local Image_41 = GUI:Image_Create(Panel_items, "Image_41", 255.00, 35.00, "res/public/1900000651.png")
	GUI:setAnchorPoint(Image_41, 0.50, 0.50)
	GUI:setTouchEnabled(Image_41, false)
	GUI:setTag(Image_41, 178)

	-- Create Image_tag41
	local Image_tag41 = GUI:Image_Create(Panel_items, "Image_tag41", 255.00, 35.00, "res/private/player_best_rings_ui/player_best_rings_ui_mobile/word_shengxiao_12.png")
	GUI:setAnchorPoint(Image_tag41, 0.50, 0.50)
	GUI:setTouchEnabled(Image_tag41, false)
	GUI:setTag(Image_tag41, 179)

	-- Create Node_30
	local Node_30 = GUI:Node_Create(Panel_items, "Node_30", 35.00, 185.00)
	GUI:setAnchorPoint(Node_30, 0.50, 0.50)
	GUI:setTag(Node_30, 180)

	-- Create Node_31
	local Node_31 = GUI:Node_Create(Panel_items, "Node_31", 108.00, 185.00)
	GUI:setAnchorPoint(Node_31, 0.50, 0.50)
	GUI:setTag(Node_31, 181)

	-- Create Node_32
	local Node_32 = GUI:Node_Create(Panel_items, "Node_32", 182.00, 185.00)
	GUI:setAnchorPoint(Node_32, 0.50, 0.50)
	GUI:setTag(Node_32, 182)

	-- Create Node_33
	local Node_33 = GUI:Node_Create(Panel_items, "Node_33", 255.00, 185.00)
	GUI:setAnchorPoint(Node_33, 0.50, 0.50)
	GUI:setTag(Node_33, 183)

	-- Create Node_34
	local Node_34 = GUI:Node_Create(Panel_items, "Node_34", 35.00, 110.00)
	GUI:setAnchorPoint(Node_34, 0.50, 0.50)
	GUI:setTag(Node_34, 184)

	-- Create Node_35
	local Node_35 = GUI:Node_Create(Panel_items, "Node_35", 108.00, 110.00)
	GUI:setAnchorPoint(Node_35, 0.50, 0.50)
	GUI:setTag(Node_35, 185)

	-- Create Node_36
	local Node_36 = GUI:Node_Create(Panel_items, "Node_36", 182.00, 110.00)
	GUI:setAnchorPoint(Node_36, 0.50, 0.50)
	GUI:setTag(Node_36, 186)

	-- Create Node_37
	local Node_37 = GUI:Node_Create(Panel_items, "Node_37", 255.00, 110.00)
	GUI:setAnchorPoint(Node_37, 0.50, 0.50)
	GUI:setTag(Node_37, 187)

	-- Create Node_38
	local Node_38 = GUI:Node_Create(Panel_items, "Node_38", 35.00, 35.00)
	GUI:setAnchorPoint(Node_38, 0.50, 0.50)
	GUI:setTag(Node_38, 188)

	-- Create Node_39
	local Node_39 = GUI:Node_Create(Panel_items, "Node_39", 108.00, 35.00)
	GUI:setAnchorPoint(Node_39, 0.50, 0.50)
	GUI:setTag(Node_39, 189)

	-- Create Node_40
	local Node_40 = GUI:Node_Create(Panel_items, "Node_40", 182.00, 35.00)
	GUI:setAnchorPoint(Node_40, 0.50, 0.50)
	GUI:setTag(Node_40, 190)

	-- Create Node_41
	local Node_41 = GUI:Node_Create(Panel_items, "Node_41", 255.00, 35.00)
	GUI:setAnchorPoint(Node_41, 0.50, 0.50)
	GUI:setTag(Node_41, 191)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Panel_1, "Panel_touch", 30.00, 243.00, 292.00, 219.00, false)
	GUI:setAnchorPoint(Panel_touch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 192)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 365.00, 302.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 193)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 0.00, 42.00, 39.00, 50.40, false)
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 194)
	GUI:setVisible(TouchSize, false)
end
return ui