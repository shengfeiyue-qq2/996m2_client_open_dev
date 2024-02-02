local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "属性场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 320.00, 346.00, false)
	GUI:Layout_setBackGroundImage(Panel_1, "res/public/bg_npc_06.jpg")
	GUI:Layout_setBackGroundImageScale9Slice(Panel_1, 0, 400, 0, 573)
	GUI:setChineseName(Panel_1, "属性组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 122)

	-- Create Text_tip
	local Text_tip = GUI:Text_Create(Panel_1, "Text_tip", 32.00, 302.00, 12, "#ffffff", [[-]])
	GUI:setChineseName(Text_tip, "属性点_描述_文本")
	GUI:setAnchorPoint(Text_tip, 0.00, 0.50)
	GUI:setTouchEnabled(Text_tip, false)
	GUI:setTag(Text_tip, 158)
	GUI:Text_enableOutline(Text_tip, "#111111", 1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 20.00, 32.00, "res/private/rein_attr_ui/attr_ui_win32/word_zswz_01.png")
	GUI:setChineseName(Image_3, "属性点_属性列表_图片")
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 159)

	-- Create Panel_data
	local Panel_data = GUI:Layout_Create(Panel_1, "Panel_data", 94.00, 75.00, 218.00, 175.00, false)
	GUI:setChineseName(Panel_data, "属性点_属性组合")
	GUI:setTouchEnabled(Panel_data, true)
	GUI:setTag(Panel_data, 151)

	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(Panel_data, "Panel_cell", 0.00, 0.00, 218.00, 18.00, false)
	GUI:setChineseName(Panel_cell, "属性点_加点分组")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 152)

	-- Create Text_data
	local Text_data = GUI:Text_Create(Panel_cell, "Text_data", 2.00, 9.00, 12, "#ffffff", [[-]])
	GUI:setChineseName(Text_data, "属性点_当前属性点数")
	GUI:setAnchorPoint(Text_data, 0.00, 0.50)
	GUI:setTouchEnabled(Text_data, false)
	GUI:setTag(Text_data, 153)
	GUI:Text_enableOutline(Text_data, "#111111", 1)

	-- Create btn_add
	local btn_add = GUI:Button_Create(Panel_cell, "btn_add", 178.00, 9.00, "res/public/1900000621.png")
	GUI:Button_loadTexturePressed(btn_add, "res/public/1900000621_1.png")
	GUI:Button_loadTextureDisabled(btn_add, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_add, 15, 13, 11, 9)
	GUI:setContentSize(btn_add, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(btn_add, false)
	GUI:Button_setTitleText(btn_add, "")
	GUI:Button_setTitleColor(btn_add, "#414146")
	GUI:Button_setTitleFontSize(btn_add, 14)
	GUI:Button_titleDisableOutLine(btn_add)
	GUI:setChineseName(btn_add, "属性点_加属性点_按钮")
	GUI:setAnchorPoint(btn_add, 0.50, 0.50)
	GUI:setScaleX(btn_add, 0.70)
	GUI:setScaleY(btn_add, 0.70)
	GUI:setTouchEnabled(btn_add, true)
	GUI:setTag(btn_add, 154)

	-- Create btn_sub
	local btn_sub = GUI:Button_Create(Panel_cell, "btn_sub", 199.00, 9.00, "res/public/1900000620.png")
	GUI:Button_loadTexturePressed(btn_sub, "res/public/1900000620_1.png")
	GUI:Button_loadTextureDisabled(btn_sub, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_sub, 15, 13, 11, 9)
	GUI:setContentSize(btn_sub, 35, 35)
	GUI:setIgnoreContentAdaptWithSize(btn_sub, false)
	GUI:Button_setTitleText(btn_sub, "")
	GUI:Button_setTitleColor(btn_sub, "#414146")
	GUI:Button_setTitleFontSize(btn_sub, 14)
	GUI:Button_titleDisableOutLine(btn_sub)
	GUI:setChineseName(btn_sub, "属性点_减属性点_按钮")
	GUI:setAnchorPoint(btn_sub, 0.50, 0.50)
	GUI:setScaleX(btn_sub, 0.70)
	GUI:setScaleY(btn_sub, 0.70)
	GUI:setTouchEnabled(btn_sub, true)
	GUI:setTag(btn_sub, 155)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_cell, "Image_4", 77.00, 9.00, "res/public/1900015004.png")
	GUI:setContentSize(Image_4, 85, 18)
	GUI:setIgnoreContentAdaptWithSize(Image_4, false)
	GUI:setChineseName(Image_4, "属性点_属性点_背景框")
	GUI:setAnchorPoint(Image_4, 0.00, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 156)

	-- Create Text_num
	local Text_num = GUI:Text_Create(Panel_cell, "Text_num", 82.00, 9.00, 12, "#ffffff", [[1/20]])
	GUI:setChineseName(Text_num, "属性点_加点_数量规则")
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, 157)
	GUI:Text_enableOutline(Text_num, "#111111", 1)

	-- Create Panel_data_new
	local Panel_data_new = GUI:Layout_Create(Panel_1, "Panel_data_new", 32.00, 75.00, 280.00, 175.00, false)
	GUI:setChineseName(Panel_data_new, "属性点_属性组合_新")
	GUI:setTouchEnabled(Panel_data_new, true)
	GUI:setTag(Panel_data_new, 151)
	GUI:setVisible(Panel_data_new, false)

	-- Create ListView_data
	local ListView_data = GUI:ListView_Create(Panel_data_new, "ListView_data", 0.00, 0.00, 280.00, 175.00, 1)
	GUI:ListView_setGravity(ListView_data, 5)
	GUI:ListView_setItemsMargin(ListView_data, 2)
	GUI:setChineseName(ListView_data, "属性点列表_新")
	GUI:setTouchEnabled(ListView_data, true)
	GUI:setTag(ListView_data, -1)

	-- Create attr_pointN
	local attr_pointN = GUI:Text_Create(Panel_1, "attr_pointN", 98.00, 40.00, 14, "#ffe400", [[-]])
	GUI:setChineseName(attr_pointN, "属性点_剩余属性点")
	GUI:setAnchorPoint(attr_pointN, 0.00, 0.50)
	GUI:setTouchEnabled(attr_pointN, false)
	GUI:setTag(attr_pointN, 150)
	GUI:Text_enableOutline(attr_pointN, "#000000", 1)

	-- Create Text_point
	local Text_point = GUI:Text_Create(Panel_1, "Text_point", 32.00, 40.00, 12, "#ffffff", [[可分配点数]])
	GUI:setChineseName(Text_point, "属性点_当前属性点数标题")
	GUI:setAnchorPoint(Text_point, 0.00, 0.50)
	GUI:setTouchEnabled(Text_point, false)
	GUI:setTag(Text_point, 153)
	GUI:setVisible(Text_point, false)
	GUI:Text_enableOutline(Text_point, "#111111", 1)

	-- Create btn_agree
	local btn_agree = GUI:Button_Create(Panel_1, "btn_agree", 263.00, 43.00, "res/public/1900000611.png")
	GUI:Button_setScale9Slice(btn_agree, 15, 15, 11, 11)
	GUI:setContentSize(btn_agree, 74, 32)
	GUI:setIgnoreContentAdaptWithSize(btn_agree, false)
	GUI:Button_setTitleText(btn_agree, "同意")
	GUI:Button_setTitleColor(btn_agree, "#f8e6c6")
	GUI:Button_setTitleFontSize(btn_agree, 14)
	GUI:Button_titleEnableOutline(btn_agree, "#000000", 1)
	GUI:setChineseName(btn_agree, "属性点_确认_按钮")
	GUI:setAnchorPoint(btn_agree, 0.50, 0.50)
	GUI:setTouchEnabled(btn_agree, true)
	GUI:setTag(btn_agree, 149)

	-- Create btn_close
	local btn_close = GUI:Button_Create(Panel_1, "btn_close", 330.00, 330.00, "res/public_win32/1900000530.png")
	GUI:Button_loadTextureDisabled(btn_close, "Default/Button_Disable.png")
	GUI:Button_setScale9Slice(btn_close, 8, 8, 11, 11)
	GUI:setContentSize(btn_close, 20, 32)
	GUI:setIgnoreContentAdaptWithSize(btn_close, false)
	GUI:Button_setTitleText(btn_close, "")
	GUI:Button_setTitleColor(btn_close, "#414146")
	GUI:Button_setTitleFontSize(btn_close, 14)
	GUI:Button_titleDisableOutLine(btn_close)
	GUI:setChineseName(btn_close, "属性点_关闭_按钮")
	GUI:setAnchorPoint(btn_close, 0.50, 0.50)
	GUI:setTouchEnabled(btn_close, true)
	GUI:setTag(btn_close, 148)
end
return ui