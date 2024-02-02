local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 450.00, 450.00, 645.00, 460.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 97)

	-- Create Image_frame_bg
	local Image_frame_bg = GUI:Image_Create(Panel_1, "Image_frame_bg", 0.00, 0.00, "res/private/compound_items_ui/win32/1900000610.png")
	GUI:setTouchEnabled(Image_frame_bg, false)
	GUI:setTag(Image_frame_bg, 102)

	-- Create Image_frame_3
	local Image_frame_3 = GUI:Image_Create(Panel_1, "Image_frame_3", 16.00, 442.00, "res/private/compound_items_ui/win32/1900000610_1.png")
	GUI:setAnchorPoint(Image_frame_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame_3, false)
	GUI:setTag(Image_frame_3, 101)

	-- Create Text_frame_title
	local Text_frame_title = GUI:Text_Create(Panel_1, "Text_frame_title", 21.00, 438.00, 14, "#d8c8ae", [[合成]])
	GUI:setAnchorPoint(Text_frame_title, 0.00, 0.50)
	GUI:setTouchEnabled(Text_frame_title, false)
	GUI:setTag(Text_frame_title, 100)
	GUI:Text_enableOutline(Text_frame_title, "#111111", 2)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 640.00, 435.00, "res/private/compound_items_ui/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/private/compound_items_ui/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.00, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 98)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 13.00, 21.00, 36.40, 58.80, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 99)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Panel_1, "Panel_bg", 18.00, 28.00, 610.00, 390.00, false)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 3)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 305.00, 195.00, "res/private/compound_items_ui/bg_clhczy_01.jpg")
	GUI:setContentSize(Image_bg, 610, 390)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 5)

	-- Create ListView_list1
	local ListView_list1 = GUI:ListView_Create(Panel_bg, "ListView_list1", 1.00, 1.00, 100.00, 390.00, 1)
	GUI:ListView_setGravity(ListView_list1, 5)
	GUI:setTouchEnabled(ListView_list1, true)
	GUI:setTag(ListView_list1, 6)

	-- Create Image_line1
	local Image_line1 = GUI:Image_Create(Panel_bg, "Image_line1", 102.00, 195.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line1, 2, 390)
	GUI:setIgnoreContentAdaptWithSize(Image_line1, false)
	GUI:setAnchorPoint(Image_line1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line1, false)
	GUI:setTag(Image_line1, 7)

	-- Create Image_line2
	local Image_line2 = GUI:Image_Create(Panel_bg, "Image_line2", 249.00, 195.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line2, 2, 390)
	GUI:setIgnoreContentAdaptWithSize(Image_line2, false)
	GUI:setAnchorPoint(Image_line2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line2, false)
	GUI:setTag(Image_line2, 8)

	-- Create ListView_list2
	local ListView_list2 = GUI:ListView_Create(Panel_bg, "ListView_list2", 105.00, 0.00, 142.00, 390.00, 1)
	GUI:ListView_setGravity(ListView_list2, 5)
	GUI:setTouchEnabled(ListView_list2, true)
	GUI:setTag(ListView_list2, 9)

	-- Create Panel_show
	local Panel_show = GUI:Layout_Create(Panel_bg, "Panel_show", 253.00, 1.00, 360.00, 390.00, false)
	GUI:setTouchEnabled(Panel_show, true)
	GUI:setTag(Panel_show, 10)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_show, "Image_7", 180.00, 354.00, "res/private/compound_items_ui/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setScaleX(Image_7, 0.77)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, 16)

	-- Create Image_6
	local Image_6 = GUI:Image_Create(Panel_show, "Image_6", 180.00, 354.00, "res/private/compound_items_ui/word_clhczy_02.png")
	GUI:setAnchorPoint(Image_6, 0.50, 0.50)
	GUI:setTouchEnabled(Image_6, false)
	GUI:setTag(Image_6, 15)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_show, "Image_5", 180.00, 223.00, "res/private/compound_items_ui/word_sxbt_05.png")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setScaleX(Image_5, 0.75)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 14)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_show, "Image_4", 180.00, 222.00, "res/private/compound_items_ui/word_clhczy_01.png")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 13)

	-- Create Panel_material
	local Panel_material = GUI:Layout_Create(Panel_show, "Panel_material", 0.00, 138.00, 360.00, 200.00, false)
	GUI:setTouchEnabled(Panel_material, false)
	GUI:setTag(Panel_material, 73)
	GUI:setVisible(Panel_material, false)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_material, "Image_2", 180.00, 170.00, "res/private/compound_items_ui/cailiao_dikuang.png")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 76)

	-- Create Image_8
	local Image_8 = GUI:Image_Create(Panel_material, "Image_8", 182.00, 114.00, "res/private/compound_items_ui/icon_arror_04.png")
	GUI:setAnchorPoint(Image_8, 0.50, 0.50)
	GUI:setRotation(Image_8, 90.00)
	GUI:setRotationSkewX(Image_8, 90.00)
	GUI:setRotationSkewY(Image_8, 90.00)
	GUI:setTouchEnabled(Image_8, false)
	GUI:setTag(Image_8, 74)

	-- Create Node_cost1
	local Node_cost1 = GUI:Node_Create(Panel_material, "Node_cost1", 180.00, 170.00)
	GUI:setAnchorPoint(Node_cost1, 0.50, 0.50)
	GUI:setTag(Node_cost1, 75)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_material, "ListView_2", 180.00, 120.00, 200.00, 65.00, 2)
	GUI:ListView_setGravity(ListView_2, 3)
	GUI:setAnchorPoint(ListView_2, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 77)

	-- Create Button_left
	local Button_left = GUI:Button_Create(Panel_material, "Button_left", 32.00, 170.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_left, 15, 15, 12, 10)
	GUI:setContentSize(Button_left, 47, 61)
	GUI:setIgnoreContentAdaptWithSize(Button_left, false)
	GUI:Button_setTitleText(Button_left, "")
	GUI:Button_setTitleColor(Button_left, "#414146")
	GUI:Button_setTitleFontSize(Button_left, 14)
	GUI:Button_titleDisableOutLine(Button_left)
	GUI:setAnchorPoint(Button_left, 0.50, 0.50)
	GUI:setTouchEnabled(Button_left, true)
	GUI:setTag(Button_left, 127)

	-- Create Button_right
	local Button_right = GUI:Button_Create(Panel_material, "Button_right", 329.00, 170.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_right, 15, 15, 12, 10)
	GUI:setContentSize(Button_right, 47, 61)
	GUI:setIgnoreContentAdaptWithSize(Button_right, false)
	GUI:Button_setTitleText(Button_right, "")
	GUI:Button_setTitleColor(Button_right, "#414146")
	GUI:Button_setTitleFontSize(Button_right, 14)
	GUI:Button_titleDisableOutLine(Button_right)
	GUI:setAnchorPoint(Button_right, 0.50, 0.50)
	GUI:setFlippedX(Button_right, true)
	GUI:setTouchEnabled(Button_right, true)
	GUI:setTag(Button_right, 126)

	-- Create Panel_get
	local Panel_get = GUI:Layout_Create(Panel_show, "Panel_get", 0.00, 0.00, 360.00, 200.00, false)
	GUI:setTouchEnabled(Panel_get, false)
	GUI:setTag(Panel_get, 79)
	GUI:setVisible(Panel_get, false)

	-- Create Image_get_bg
	local Image_get_bg = GUI:Image_Create(Panel_get, "Image_get_bg", 180.00, 173.00, "res/private/compound_items_ui/cailiao_dikuang.png")
	GUI:setAnchorPoint(Image_get_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_get_bg, false)
	GUI:setTag(Image_get_bg, 78)

	-- Create Node_get
	local Node_get = GUI:Node_Create(Panel_get, "Node_get", 180.00, 173.00)
	GUI:setAnchorPoint(Node_get, 0.50, 0.50)
	GUI:setTag(Node_get, 27)

	-- Create ListView_get
	local ListView_get = GUI:ListView_Create(Panel_get, "ListView_get", 180.00, 155.00, 200.00, 71.00, 2)
	GUI:ListView_setGravity(ListView_get, 3)
	GUI:setAnchorPoint(ListView_get, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_get, true)
	GUI:setTag(ListView_get, 72)

	-- Create Button_left
	local Button_left = GUI:Button_Create(Panel_get, "Button_left", 32.00, 173.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_left, 15, 15, 12, 10)
	GUI:setContentSize(Button_left, 47, 61)
	GUI:setIgnoreContentAdaptWithSize(Button_left, false)
	GUI:Button_setTitleText(Button_left, "")
	GUI:Button_setTitleColor(Button_left, "#414146")
	GUI:Button_setTitleFontSize(Button_left, 14)
	GUI:Button_titleDisableOutLine(Button_left)
	GUI:setAnchorPoint(Button_left, 0.50, 0.50)
	GUI:setTouchEnabled(Button_left, true)
	GUI:setTag(Button_left, 128)

	-- Create Button_right
	local Button_right = GUI:Button_Create(Panel_get, "Button_right", 329.00, 173.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_right, 15, 15, 12, 10)
	GUI:setContentSize(Button_right, 47, 61)
	GUI:setIgnoreContentAdaptWithSize(Button_right, false)
	GUI:Button_setTitleText(Button_right, "")
	GUI:Button_setTitleColor(Button_right, "#414146")
	GUI:Button_setTitleFontSize(Button_right, 14)
	GUI:Button_titleDisableOutLine(Button_right)
	GUI:setAnchorPoint(Button_right, 0.50, 0.50)
	GUI:setFlippedX(Button_right, true)
	GUI:setTouchEnabled(Button_right, true)
	GUI:setTag(Button_right, 129)

	-- Create Panel_money
	local Panel_money = GUI:Layout_Create(Panel_show, "Panel_money", 0.00, 0.00, 360.00, 200.00, false)
	GUI:setTouchEnabled(Panel_money, false)
	GUI:setTag(Panel_money, 84)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_money, "Text_1", 111.00, 70.00, 16, "#ffffff", [[消耗：]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 90)
	GUI:Text_enableOutline(Text_1, "#111111", 1)

	-- Create ListView_money
	local ListView_money = GUI:ListView_Create(Panel_money, "ListView_money", 106.00, 51.00, 200.00, 58.00, 1)
	GUI:ListView_setGravity(ListView_money, 5)
	GUI:setTouchEnabled(ListView_money, true)
	GUI:setTag(ListView_money, 89)

	-- Create Button_compound
	local Button_compound = GUI:Button_Create(Panel_show, "Button_compound", 180.00, 35.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_compound, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_compound, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(Button_compound, 15, 17, 11, 18)
	GUI:setContentSize(Button_compound, 104, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_compound, false)
	GUI:Button_setTitleText(Button_compound, "合成")
	GUI:Button_setTitleColor(Button_compound, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_compound, 18)
	GUI:Button_titleEnableOutline(Button_compound, "#111111", 2)
	GUI:setAnchorPoint(Button_compound, 0.50, 0.50)
	GUI:setTouchEnabled(Button_compound, true)
	GUI:setTag(Button_compound, 11)

	-- Create Button_help
	local Button_help = GUI:Button_Create(Panel_show, "Button_help", 329.00, 361.00, "res/public/1900001024.png")
	GUI:Button_setScale9Slice(Button_help, 15, 15, 12, 10)
	GUI:setContentSize(Button_help, 34, 34)
	GUI:setIgnoreContentAdaptWithSize(Button_help, false)
	GUI:Button_setTitleText(Button_help, "")
	GUI:Button_setTitleColor(Button_help, "#414146")
	GUI:Button_setTitleFontSize(Button_help, 14)
	GUI:Button_titleDisableOutLine(Button_help)
	GUI:setAnchorPoint(Button_help, 0.50, 0.50)
	GUI:setTouchEnabled(Button_help, true)
	GUI:setTag(Button_help, 130)
end
return ui