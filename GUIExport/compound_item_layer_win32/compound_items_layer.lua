local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "系统合成节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1.0)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 450.00, 450.00, 645.00, 460.00, false)
	GUI:setChineseName(Panel_1, "系统合成组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 97.0)

	-- Create Image_frame_bg
	local Image_frame_bg = GUI:Image_Create(Panel_1, "Image_frame_bg", 0.00, 0.00, "res/private/compound_items_ui/win32/1900000610.png")
	GUI:setChineseName(Image_frame_bg, "系统合成_背景图")
	GUI:setTouchEnabled(Image_frame_bg, false)
	GUI:setTag(Image_frame_bg, 102.0)

	-- Create Image_frame_bg2
	local Image_frame_bg2 = GUI:Image_Create(Panel_1, "Image_frame_bg2", 16.00, 442.00, "res/private/compound_items_ui/win32/1900000610_1.png")
	GUI:setChineseName(Image_frame_bg2, "系统合成_装饰图")
	GUI:setAnchorPoint(Image_frame_bg2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_frame_bg2, false)
	GUI:setTag(Image_frame_bg2, 101.0)

	-- Create Text_frame_title
	local Text_frame_title = GUI:Text_Create(Panel_1, "Text_frame_title", 21.00, 438.00, 14.0, "#d8c8ae", [[合成]])
	GUI:setChineseName(Text_frame_title, "系统合成_标题")
	GUI:setAnchorPoint(Text_frame_title, 0.00, 0.50)
	GUI:setTouchEnabled(Text_frame_title, false)
	GUI:setTag(Text_frame_title, 100.0)
	GUI:Text_enableOutline(Text_frame_title, "#111111", 2.0)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 640.00, 435.00, "res/private/compound_items_ui/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/private/compound_items_ui/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8.0, 12, 10.0)
	GUI:setContentSize(Button_close, 26.0, 42.0)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14.0)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "系统合成_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.00, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 98.0)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 13.00, 21.00, 36.40, 58.80, false)
	GUI:setChineseName(TouchSize, "系统合成_触摸关闭")
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 99.0)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Panel_1, "Panel_bg", 18.00, 28.00, 610.00, 390.00, false)
	GUI:setChineseName(Panel_bg, "系统合成操作组合")
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 3.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 305.00, 195.00, "res/private/compound_items_ui/bg_clhczy_01.jpg")
	GUI:setContentSize(Image_bg, 610.0, 390.0)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "合成操作_背景图")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 5.0)

	-- Create ListView_list1
	local ListView_list1 = GUI:ListView_Create(Panel_bg, "ListView_list1", 1.00, 1.00, 100.00, 390.00, 1.0)
	GUI:ListView_setGravity(ListView_list1, 5.0)
	GUI:setChineseName(ListView_list1, "合成操作_一级菜单列表")
	GUI:setTouchEnabled(ListView_list1, true)
	GUI:setTag(ListView_list1, 6.0)

	-- Create Image_line1
	local Image_line1 = GUI:Image_Create(Panel_bg, "Image_line1", 102.00, 195.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line1, 2.0, 390.0)
	GUI:setIgnoreContentAdaptWithSize(Image_line1, false)
	GUI:setChineseName(Image_line1, "合成操作_装饰条")
	GUI:setAnchorPoint(Image_line1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line1, false)
	GUI:setTag(Image_line1, 7.0)

	-- Create Image_line2
	local Image_line2 = GUI:Image_Create(Panel_bg, "Image_line2", 249.00, 195.00, "res/public/bg_yyxsz_02.png")
	GUI:setContentSize(Image_line2, 2.0, 390.0)
	GUI:setIgnoreContentAdaptWithSize(Image_line2, false)
	GUI:setChineseName(Image_line2, "合成操作_装饰条")
	GUI:setAnchorPoint(Image_line2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line2, false)
	GUI:setTag(Image_line2, 8.0)

	-- Create ListView_list2
	local ListView_list2 = GUI:ListView_Create(Panel_bg, "ListView_list2", 105.00, 0.00, 142.00, 390.00, 1.0)
	GUI:ListView_setGravity(ListView_list2, 5.0)
	GUI:setChineseName(ListView_list2, "合成操作_二级菜单列表")
	GUI:setTouchEnabled(ListView_list2, true)
	GUI:setTag(ListView_list2, 9.0)

	-- Create Panel_show
	local Panel_show = GUI:Layout_Create(Panel_bg, "Panel_show", 253.00, 1.00, 360.00, 390.00, false)
	GUI:setChineseName(Panel_show, "合成操作需求组合")
	GUI:setTouchEnabled(Panel_show, true)
	GUI:setTag(Panel_show, 10.0)

	-- Create Image_show1
	local Image_show1 = GUI:Image_Create(Panel_show, "Image_show1", 180.00, 354.00, "res/private/compound_items_ui/word_sxbt_05.png")
	GUI:setChineseName(Image_show1, "合成操作_装饰图")
	GUI:setAnchorPoint(Image_show1, 0.50, 0.50)
	GUI:setScaleX(Image_show1, 0.77)
	GUI:setTouchEnabled(Image_show1, false)
	GUI:setTag(Image_show1, 16.0)

	-- Create Image_cailiao
	local Image_cailiao = GUI:Image_Create(Image_show1, "Image_cailiao", 150.00, 5.00, "res/private/compound_items_ui/word_clhczy_02.png")
	GUI:setChineseName(Image_cailiao, "合成操作_材料消耗_图片")
	GUI:setAnchorPoint(Image_cailiao, 0.50, 0.50)
	GUI:setTouchEnabled(Image_cailiao, false)
	GUI:setTag(Image_cailiao, 15.0)

	-- Create Image_show2
	local Image_show2 = GUI:Image_Create(Panel_show, "Image_show2", 180.00, 223.00, "res/private/compound_items_ui/word_sxbt_05.png")
	GUI:setChineseName(Image_show2, "合成操作_装饰图")
	GUI:setAnchorPoint(Image_show2, 0.50, 0.50)
	GUI:setScaleX(Image_show2, 0.75)
	GUI:setTouchEnabled(Image_show2, false)
	GUI:setTag(Image_show2, 14.0)

	-- Create Image_hecheng
	local Image_hecheng = GUI:Image_Create(Image_show2, "Image_hecheng", 150.00, 5.00, "res/private/compound_items_ui/word_clhczy_01.png")
	GUI:setChineseName(Image_hecheng, "合成操作_合成获得_图片")
	GUI:setAnchorPoint(Image_hecheng, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hecheng, false)
	GUI:setTag(Image_hecheng, 13.0)

	-- Create Panel_material
	local Panel_material = GUI:Layout_Create(Panel_show, "Panel_material", 0.00, 138.00, 360.00, 200.00, false)
	GUI:setChineseName(Panel_material, "合成示条件组合")
	GUI:setTouchEnabled(Panel_material, false)
	GUI:setTag(Panel_material, 73.0)

	-- Create Image_material_bg
	local Image_material_bg = GUI:Image_Create(Panel_material, "Image_material_bg", 180.00, 170.00, "res/private/compound_items_ui/cailiao_dikuang.png")
	GUI:setChineseName(Image_material_bg, "合成示条件_背景图")
	GUI:setAnchorPoint(Image_material_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_material_bg, false)
	GUI:setTag(Image_material_bg, 76.0)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Panel_material, "ListView_2", 180.00, 138.00, 250.00, 64.00, 2.0)
	GUI:ListView_setGravity(ListView_2, 5.0)
	GUI:setChineseName(ListView_2, "合成示条件_条件容器")
	GUI:setAnchorPoint(ListView_2, 0.50, 0.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 77.0)

	-- Create Button_left
	local Button_left = GUI:Button_Create(Panel_material, "Button_left", 32.00, 170.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_left, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_left, 47.0, 61.0)
	GUI:setIgnoreContentAdaptWithSize(Button_left, false)
	GUI:Button_setTitleText(Button_left, "")
	GUI:Button_setTitleColor(Button_left, "#414146")
	GUI:Button_setTitleFontSize(Button_left, 14.0)
	GUI:Button_titleDisableOutLine(Button_left)
	GUI:setChineseName(Button_left, "合成示条件_左箭头_按钮")
	GUI:setAnchorPoint(Button_left, 0.50, 0.50)
	GUI:setTouchEnabled(Button_left, true)
	GUI:setTag(Button_left, 127.0)
	GUI:setVisible(Button_left, false)

	-- Create Button_right
	local Button_right = GUI:Button_Create(Panel_material, "Button_right", 329.00, 170.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_right, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_right, 47.0, 61.0)
	GUI:setIgnoreContentAdaptWithSize(Button_right, false)
	GUI:Button_setTitleText(Button_right, "")
	GUI:Button_setTitleColor(Button_right, "#414146")
	GUI:Button_setTitleFontSize(Button_right, 14.0)
	GUI:Button_titleDisableOutLine(Button_right)
	GUI:setChineseName(Button_right, "合成示条件_右箭头_按钮")
	GUI:setAnchorPoint(Button_right, 0.50, 0.50)
	GUI:setFlippedX(Button_right, true)
	GUI:setTouchEnabled(Button_right, true)
	GUI:setTag(Button_right, 126.0)
	GUI:setVisible(Button_right, false)

	-- Create Panel_get
	local Panel_get = GUI:Layout_Create(Panel_show, "Panel_get", 0.00, 0.00, 360.00, 200.00, false)
	GUI:setChineseName(Panel_get, "合成结果组合")
	GUI:setTouchEnabled(Panel_get, false)
	GUI:setTag(Panel_get, 79.0)

	-- Create Image_get_bg
	local Image_get_bg = GUI:Image_Create(Panel_get, "Image_get_bg", 180.00, 173.00, "res/private/compound_items_ui/cailiao_dikuang.png")
	GUI:setChineseName(Image_get_bg, "合成结果_背景图")
	GUI:setAnchorPoint(Image_get_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_get_bg, false)
	GUI:setTag(Image_get_bg, 78.0)

	-- Create ListView_get
	local ListView_get = GUI:ListView_Create(Panel_get, "ListView_get", 180.00, 172.00, 250.00, 64.00, 2.0)
	GUI:ListView_setGravity(ListView_get, 5.0)
	GUI:setChineseName(ListView_get, "合成结果_结果容器")
	GUI:setAnchorPoint(ListView_get, 0.50, 0.50)
	GUI:setTouchEnabled(ListView_get, true)
	GUI:setTag(ListView_get, 72.0)

	-- Create Button_left2
	local Button_left2 = GUI:Button_Create(Panel_get, "Button_left2", 32.00, 173.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_left2, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_left2, 47.0, 61.0)
	GUI:setIgnoreContentAdaptWithSize(Button_left2, false)
	GUI:Button_setTitleText(Button_left2, "")
	GUI:Button_setTitleColor(Button_left2, "#414146")
	GUI:Button_setTitleFontSize(Button_left2, 14.0)
	GUI:Button_titleDisableOutLine(Button_left2)
	GUI:setChineseName(Button_left2, "合成结果_左箭头_按钮")
	GUI:setAnchorPoint(Button_left2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_left2, true)
	GUI:setTag(Button_left2, 128.0)
	GUI:setVisible(Button_left2, false)

	-- Create Button_right2
	local Button_right2 = GUI:Button_Create(Panel_get, "Button_right2", 329.00, 173.00, "res/private/compound_items_ui/btn_szjm_01_1.png")
	GUI:Button_setScale9Slice(Button_right2, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_right2, 47.0, 61.0)
	GUI:setIgnoreContentAdaptWithSize(Button_right2, false)
	GUI:Button_setTitleText(Button_right2, "")
	GUI:Button_setTitleColor(Button_right2, "#414146")
	GUI:Button_setTitleFontSize(Button_right2, 14.0)
	GUI:Button_titleDisableOutLine(Button_right2)
	GUI:setChineseName(Button_right2, "合成结果_右箭头_按钮")
	GUI:setAnchorPoint(Button_right2, 0.50, 0.50)
	GUI:setFlippedX(Button_right2, true)
	GUI:setTouchEnabled(Button_right2, true)
	GUI:setTag(Button_right2, 129.0)
	GUI:setVisible(Button_right2, false)

	-- Create Panel_money
	local Panel_money = GUI:Layout_Create(Panel_show, "Panel_money", 0.00, 0.00, 360.00, 200.00, false)
	GUI:setChineseName(Panel_money, "合成货币需求组合")
	GUI:setTouchEnabled(Panel_money, false)
	GUI:setTag(Panel_money, 84.0)

	-- Create ListView_money
	local ListView_money = GUI:ListView_Create(Panel_money, "ListView_money", 120.00, 50.00, 150.00, 58.00, 1.0)
	GUI:ListView_setClippingEnabled(ListView_money, false)
	GUI:ListView_setGravity(ListView_money, 5.0)
	GUI:setChineseName(ListView_money, "合成货币需求_货币容器")
	GUI:setTouchEnabled(ListView_money, true)
	GUI:setTag(ListView_money, 89.0)

	-- Create Button_compound
	local Button_compound = GUI:Button_Create(Panel_show, "Button_compound", 180.00, 30.00, "res/public/1900000680.png")
	GUI:Button_loadTexturePressed(Button_compound, "res/public/1900000680_1.png")
	GUI:Button_loadTextureDisabled(Button_compound, "res/public/1900000680_1.png")
	GUI:Button_setScale9Slice(Button_compound, 15, 17.0, 11, 18.0)
	GUI:setContentSize(Button_compound, 104.0, 33.0)
	GUI:setIgnoreContentAdaptWithSize(Button_compound, false)
	GUI:Button_setTitleText(Button_compound, "合成")
	GUI:Button_setTitleColor(Button_compound, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_compound, 18.0)
	GUI:Button_titleEnableOutline(Button_compound, "#111111", 2.0)
	GUI:setChineseName(Button_compound, "合成操作_合成_按钮")
	GUI:setAnchorPoint(Button_compound, 0.50, 0.50)
	GUI:setTouchEnabled(Button_compound, true)
	GUI:setTag(Button_compound, 11.0)

	-- Create Button_help
	local Button_help = GUI:Button_Create(Panel_show, "Button_help", 329.00, 361.00, "res/public/1900001024.png")
	GUI:Button_setScale9Slice(Button_help, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_help, 34.0, 34.0)
	GUI:setIgnoreContentAdaptWithSize(Button_help, false)
	GUI:Button_setTitleText(Button_help, "")
	GUI:Button_setTitleColor(Button_help, "#414146")
	GUI:Button_setTitleFontSize(Button_help, 14.0)
	GUI:Button_titleDisableOutLine(Button_help)
	GUI:setChineseName(Button_help, "合成操作_帮助_按钮")
	GUI:setAnchorPoint(Button_help, 0.50, 0.50)
	GUI:setTouchEnabled(Button_help, true)
	GUI:setTag(Button_help, 130.0)
end
return ui