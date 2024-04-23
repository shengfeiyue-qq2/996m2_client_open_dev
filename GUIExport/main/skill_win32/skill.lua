local ui = {}
function ui.init(parent)
	-- Create skill
	local skill = GUI:Layout_Create(parent, "skill", 0.00, -190.00, 55.00, 460.00, false)
	GUI:setAnchorPoint(skill, 1.00, 1.00)
	GUI:setTouchEnabled(skill, false)
	GUI:setTag(skill, -1)

	-- Create arr_bg
	local arr_bg = GUI:Image_Create(skill, "arr_bg", 27.00, 460.00, "res/private/main-win32/skill/1900012573.png")
	GUI:Image_setScale9Slice(arr_bg, 3, 2, 25, 163)
	GUI:setContentSize(arr_bg, 20, 50)
	GUI:setIgnoreContentAdaptWithSize(arr_bg, false)
	GUI:setAnchorPoint(arr_bg, 0.00, 0.50)
	GUI:setRotation(arr_bg, 90.00)
	GUI:setRotationSkewX(arr_bg, 90.00)
	GUI:setRotationSkewY(arr_bg, 90.00)
	GUI:setTouchEnabled(arr_bg, false)
	GUI:setTag(arr_bg, -1)

	-- Create Button_arr
	local Button_arr = GUI:Button_Create(arr_bg, "Button_arr", 10.00, 25.00, "res/private/main-win32/skill/1900012567.png")
	GUI:Button_setTitleText(Button_arr, "")
	GUI:Button_setTitleColor(Button_arr, "#ffffff")
	GUI:Button_setTitleFontSize(Button_arr, 10)
	GUI:Button_titleEnableOutline(Button_arr, "#000000", 1)
	GUI:setAnchorPoint(Button_arr, 0.50, 0.50)
	GUI:setTouchEnabled(Button_arr, true)
	GUI:setTag(Button_arr, -1)

	-- Create ListView_skill
	local ListView_skill = GUI:ScrollView_Create(skill, "ListView_skill", 0.00, 440.00, 55.00, 440.00, 1)
	GUI:ScrollView_setInnerContainerSize(ListView_skill, 55.00, 440.00)
	GUI:setAnchorPoint(ListView_skill, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_skill, true)
	GUI:setTag(ListView_skill, -1)
end
return ui