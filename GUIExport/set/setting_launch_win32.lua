local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setChineseName(Panel_1, "战斗设置组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 6)

	-- Create ImageBG1
	local ImageBG1 = GUI:Image_Create(Panel_1, "ImageBG1", 15.00, 217.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(ImageBG1, 5, 5, 5, 5)
	GUI:setContentSize(ImageBG1, 578, 147)
	GUI:setIgnoreContentAdaptWithSize(ImageBG1, false)
	GUI:setChineseName(ImageBG1, "战斗设置_分布1组合")
	GUI:setTouchEnabled(ImageBG1, false)
	GUI:setTag(ImageBG1, -1)

	-- Create ScrollView_1
	local ScrollView_1 = GUI:ScrollView_Create(ImageBG1, "ScrollView_1", 0.00, 2.00, 578.00, 143.00, 1)
	GUI:ScrollView_setBackGroundImageScale9Slice(ScrollView_1, 33, 33, 9, 9)
	GUI:ScrollView_setBounceEnabled(ScrollView_1, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_1, 686.00, 300.00)
	GUI:setChineseName(ScrollView_1, "战斗设置_分布1_详细设置")
	GUI:setTouchEnabled(ScrollView_1, true)
	GUI:setTag(ScrollView_1, 104)

	-- Create Panel_3
	local Panel_3 = GUI:Layout_Create(Panel_1, "Panel_3", 15.00, 47.00, 578.00, 168.00, false)
	GUI:setChineseName(Panel_3, "战斗设置_分布2组合")
	GUI:setTouchEnabled(Panel_3, true)
	GUI:setTag(Panel_3, 24)

	-- Create ImageBG2
	local ImageBG2 = GUI:Image_Create(Panel_3, "ImageBG2", 0.00, 0.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(ImageBG2, 34, 34, 9, 10)
	GUI:setContentSize(ImageBG2, 191, 168)
	GUI:setIgnoreContentAdaptWithSize(ImageBG2, false)
	GUI:setChineseName(ImageBG2, "战斗设置_分布2-1组合")
	GUI:setTouchEnabled(ImageBG2, false)
	GUI:setTag(ImageBG2, -1)

	-- Create ScrollView_2
	local ScrollView_2 = GUI:ScrollView_Create(ImageBG2, "ScrollView_2", 0.00, 2.00, 191.00, 164.00, 1)
	GUI:ScrollView_setBackGroundImageScale9Slice(ScrollView_2, 33, 33, 9, 9)
	GUI:ScrollView_setBounceEnabled(ScrollView_2, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_2, 194.00, 164.00)
	GUI:setChineseName(ScrollView_2, "战斗设置_分布2-1详细信息")
	GUI:setTouchEnabled(ScrollView_2, true)
	GUI:setTag(ScrollView_2, 105)

	-- Create ImageBG3
	local ImageBG3 = GUI:Image_Create(Panel_3, "ImageBG3", 191.00, 0.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(ImageBG3, 5, 5, 5, 5)
	GUI:setContentSize(ImageBG3, 386, 168)
	GUI:setIgnoreContentAdaptWithSize(ImageBG3, false)
	GUI:setChineseName(ImageBG3, "战斗设置_分布2-2组合")
	GUI:setTouchEnabled(ImageBG3, false)
	GUI:setTag(ImageBG3, -1)

	-- Create ScrollView_3
	local ScrollView_3 = GUI:ScrollView_Create(ImageBG3, "ScrollView_3", 0.00, 2.00, 386.00, 164.00, 1)
	GUI:ScrollView_setBackGroundImageScale9Slice(ScrollView_3, 33, 33, 9, 9)
	GUI:ScrollView_setBounceEnabled(ScrollView_3, true)
	GUI:ScrollView_setInnerContainerSize(ScrollView_3, 386.00, 164.00)
	GUI:setChineseName(ScrollView_3, "战斗设置_分布2-2详细信息")
	GUI:setTouchEnabled(ScrollView_3, true)
	GUI:setTag(ScrollView_3, 22)

	-- Create ScrollView_4
	local ScrollView_4 = GUI:ScrollView_Create(Panel_1, "ScrollView_4", 15.00, 2.00, 580.00, 40.00, 1)
	GUI:ScrollView_setBackGroundImageScale9Slice(ScrollView_4, -33, -33, -9, -9)
	GUI:ScrollView_setInnerContainerSize(ScrollView_4, 580.00, 40.00)
	GUI:setChineseName(ScrollView_4, "战斗设置_分布3组合")
	GUI:setTouchEnabled(ScrollView_4, false)
	GUI:setTag(ScrollView_4, 637)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(ScrollView_4, "Image_bg", 0.00, 0.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_bg, 33, 33, 9, 9)
	GUI:setContentSize(Image_bg, 578, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "战斗设置_分布3_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 638)
end
return ui