local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 210.00, 732.00, 50.00, false)
	GUI:setChineseName(Panel_cell, "行会操作_组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 81)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_cell, "Image_line", 366.00, 0.00, "res/public/bg_yyxsz_01.png")
	GUI:setChineseName(Image_line, "行会操作_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 160)

	-- Create label_name
	local label_name = GUI:Text_Create(Panel_cell, "label_name", 68.00, 25.00, 16, "#ffffff", [[行会名字]])
	GUI:setChineseName(label_name, "行会操作_行会名称_文本")
	GUI:setAnchorPoint(label_name, 0.50, 0.50)
	GUI:setTouchEnabled(label_name, false)
	GUI:setTag(label_name, 82)
	GUI:Text_enableOutline(label_name, "#111111", 1)

	-- Create label_master
	local label_master = GUI:Text_Create(Panel_cell, "label_master", 244.00, 25.00, 16, "#ffffff", [[会长名字]])
	GUI:setChineseName(label_master, "行会操作_会长名字_文本")
	GUI:setAnchorPoint(label_master, 0.50, 0.50)
	GUI:setTouchEnabled(label_master, false)
	GUI:setTag(label_master, 83)
	GUI:Text_enableOutline(label_master, "#111111", 1)

	-- Create label_count
	local label_count = GUI:Text_Create(Panel_cell, "label_count", 384.00, 25.00, 16, "#ffffff", [[100]])
	GUI:setChineseName(label_count, "行会操作_行会人数_文本")
	GUI:setAnchorPoint(label_count, 0.50, 0.50)
	GUI:setTouchEnabled(label_count, false)
	GUI:setTag(label_count, 84)
	GUI:Text_enableOutline(label_count, "#111111", 1)

	-- Create label_condition
	local label_condition = GUI:Text_Create(Panel_cell, "label_condition", 500.00, 25.00, 16, "#ffffff", [[100级以上]])
	GUI:setChineseName(label_condition, "行会操作_加入条件_文本")
	GUI:setAnchorPoint(label_condition, 0.50, 0.50)
	GUI:setTouchEnabled(label_condition, false)
	GUI:setTag(label_condition, 85)
	GUI:Text_enableOutline(label_condition, "#111111", 1)

	-- Create label_desc
	local label_desc = GUI:Text_Create(Panel_cell, "label_desc", 645.00, 25.00, 16, "#ffffff", [[已申请]])
	GUI:setChineseName(label_desc, "行会操作_申请状态_文本")
	GUI:setAnchorPoint(label_desc, 0.50, 0.50)
	GUI:setTouchEnabled(label_desc, false)
	GUI:setTag(label_desc, 86)
	GUI:Text_enableOutline(label_desc, "#111111", 1)

	-- Create Button_join
	local Button_join = GUI:Button_Create(Panel_cell, "Button_join", 645.00, 25.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_join, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_join, 16, 14, 13, 9)
	GUI:setContentSize(Button_join, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_join, false)
	GUI:Button_setTitleText(Button_join, "加入")
	GUI:Button_setTitleColor(Button_join, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_join, 18)
	GUI:Button_titleEnableOutline(Button_join, "#111111", 2)
	GUI:setChineseName(Button_join, "行会操作_加入按钮")
	GUI:setAnchorPoint(Button_join, 0.50, 0.50)
	GUI:setTouchEnabled(Button_join, true)
	GUI:setTag(Button_join, 141)

	-- Create Button_war
	local Button_war = GUI:Button_Create(Panel_cell, "Button_war", 610.00, 25.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_war, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_war, 16, 14, 13, 9)
	GUI:setContentSize(Button_war, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_war, false)
	GUI:Button_setTitleText(Button_war, "宣战")
	GUI:Button_setTitleColor(Button_war, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_war, 18)
	GUI:Button_titleEnableOutline(Button_war, "#111111", 2)
	GUI:setChineseName(Button_war, "行会操作_宣战按钮")
	GUI:setAnchorPoint(Button_war, 0.50, 0.50)
	GUI:setTouchEnabled(Button_war, true)
	GUI:setTag(Button_war, 118)

	-- Create Button_ally
	local Button_ally = GUI:Button_Create(Panel_cell, "Button_ally", 690.00, 25.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_ally, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_ally, 16, 14, 13, 9)
	GUI:setContentSize(Button_ally, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_ally, false)
	GUI:Button_setTitleText(Button_ally, "结盟")
	GUI:Button_setTitleColor(Button_ally, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_ally, 18)
	GUI:Button_titleEnableOutline(Button_ally, "#111111", 2)
	GUI:setChineseName(Button_ally, "行会操作_结盟按钮")
	GUI:setAnchorPoint(Button_ally, 0.50, 0.50)
	GUI:setTouchEnabled(Button_ally, true)
	GUI:setTag(Button_ally, 119)

	-- Create Button_cancel
	local Button_cancel = GUI:Button_Create(Panel_cell, "Button_cancel", 717.00, 25.00, "res/public/btn_gban_01.png")
	GUI:Button_loadTexturePressed(Button_cancel, "res/public/btn_gban_02.png")
	GUI:Button_setScale9Slice(Button_cancel, 7, 7, 11, 10)
	GUI:setContentSize(Button_cancel, 23, 22)
	GUI:setIgnoreContentAdaptWithSize(Button_cancel, false)
	GUI:Button_setTitleText(Button_cancel, "")
	GUI:Button_setTitleColor(Button_cancel, "#414146")
	GUI:Button_setTitleFontSize(Button_cancel, 14)
	GUI:Button_titleDisableOutLine(Button_cancel)
	GUI:setChineseName(Button_cancel, "行会操作_结束宣战")
	GUI:setAnchorPoint(Button_cancel, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cancel, true)
	GUI:setTag(Button_cancel, 55)
	GUI:setVisible(Button_cancel, false)
end
return ui