local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 370.00, 30.00, true)
	GUI:Layout_setBackGroundColorType(Panel_cell, 1)
	GUI:Layout_setBackGroundColor(Panel_cell, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cell, 0)
	GUI:setChineseName(Panel_cell, "行会_称谓组合")
	GUI:setTouchEnabled(Panel_cell, false)
	GUI:setTag(Panel_cell, -1)

	-- Create ImgBg
	local ImgBg = GUI:Image_Create(Panel_cell, "ImgBg", 120.00, 0.00, "res/public/1900000668.png")
	GUI:Image_setScale9Slice(ImgBg, 52, 52, 13, 7)
	GUI:setContentSize(ImgBg, 200, 30)
	GUI:setIgnoreContentAdaptWithSize(ImgBg, false)
	GUI:setChineseName(ImgBg, "行会_称谓输入框_背景")
	GUI:setTouchEnabled(ImgBg, false)
	GUI:setTag(ImgBg, -1)

	-- Create EditInput
	local EditInput = GUI:TextInput_Create(Panel_cell, "EditInput", 120.00, 15.00, 200.00, 20.00, 14)
	GUI:TextInput_setString(EditInput, "")
	GUI:TextInput_setFontColor(EditInput, "#ffffff")
	GUI:setChineseName(EditInput, "行会_称谓_输入框")
	GUI:setAnchorPoint(EditInput, 0.00, 0.50)
	GUI:setTouchEnabled(EditInput, true)
	GUI:setTag(EditInput, -1)

	-- Create Text
	local Text = GUI:Text_Create(Panel_cell, "Text", 60.00, 15.00, 16, "#f2e7cf", [[称谓]])
	GUI:setChineseName(Text, "行会_称谓_文本")
	GUI:setAnchorPoint(Text, 0.00, 0.50)
	GUI:setTouchEnabled(Text, false)
	GUI:setTag(Text, -1)
	GUI:Text_enableOutline(Text, "#000000", 1)
end
return ui