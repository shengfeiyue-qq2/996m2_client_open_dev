local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 8)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_1, "ListView", 278.00, 410.00, 320.00, 157.00, 1)
	GUI:ListView_setBackGroundImageScale9Slice(ListView, 83, 83, 11, 11)
	GUI:ListView_setBackGroundImage(ListView, "res/private/item_tips/btn_tipszy_01.png")
	GUI:ListView_setGravity(ListView, 2)
	GUI:setAnchorPoint(ListView, 0.00, 1.00)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 11)

	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(Panel_1, "Panel_cell", 278.00, 258.00, 320.00, 52.00, false)
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 12)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_cell, "Image_line", 160.00, 52.00, "res/public/1900000667.png")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 16)

	-- Create Text_info
	local Text_info = GUI:Text_Create(Panel_cell, "Text_info", 10.00, 26.00, 16, "#ffffff", [[行会名字七个字 邀请你加入行会]])
	GUI:setAnchorPoint(Text_info, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info, false)
	GUI:setTag(Text_info, 13)
	GUI:Text_enableOutline(Text_info, "#000000", 1)

	-- Create Button_agree
	local Button_agree = GUI:Button_Create(Panel_cell, "Button_agree", 300.00, 26.00, "res/public/btn_queding_01.png")
	GUI:Button_loadTexturePressed(Button_agree, "res/public/btn_queding_02.png")
	GUI:Button_setScale9Slice(Button_agree, 15, 15, 11, 11)
	GUI:setContentSize(Button_agree, 32, 31)
	GUI:setIgnoreContentAdaptWithSize(Button_agree, false)
	GUI:Button_setTitleText(Button_agree, "")
	GUI:Button_setTitleColor(Button_agree, "#414146")
	GUI:Button_setTitleFontSize(Button_agree, 14)
	GUI:Button_titleDisableOutLine(Button_agree)
	GUI:setAnchorPoint(Button_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_agree, true)
	GUI:setTag(Button_agree, 14)

	-- Create Button_disAgree
	local Button_disAgree = GUI:Button_Create(Panel_cell, "Button_disAgree", 260.00, 26.00, "res/public/btn_quxiao_01.png")
	GUI:Button_loadTexturePressed(Button_disAgree, "res/public/btn_quxiao_02.png")
	GUI:Button_setScale9Slice(Button_disAgree, 15, 15, 11, 11)
	GUI:setContentSize(Button_disAgree, 32, 31)
	GUI:setIgnoreContentAdaptWithSize(Button_disAgree, false)
	GUI:Button_setTitleText(Button_disAgree, "")
	GUI:Button_setTitleColor(Button_disAgree, "#414146")
	GUI:Button_setTitleFontSize(Button_disAgree, 14)
	GUI:Button_titleDisableOutLine(Button_disAgree)
	GUI:setAnchorPoint(Button_disAgree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_disAgree, true)
	GUI:setTag(Button_disAgree, 15)
end
return ui