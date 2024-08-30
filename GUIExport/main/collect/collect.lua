local ui = {}
function ui.init(parent)
	-- Create Main_Collect
	local Main_Collect = GUI:Layout_Create(parent, "Main_Collect", 0.00, 200.00, 80.00, 80.00, false)
	GUI:setChineseName(Main_Collect, "采集_组合")
	GUI:setAnchorPoint(Main_Collect, 0.50, 0.00)
	GUI:setTouchEnabled(Main_Collect, true)
	GUI:setTag(Main_Collect, 22.0)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Main_Collect, "Image_1", 40.00, 48.00, "res/private/main/collect/btn_xbzy_03.png")
	GUI:setChineseName(Image_1, "采集_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 24.0)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Main_Collect, "Image_2", 40.00, 48.00, "res/private/main/collect/bg_xbzy_02.png")
	GUI:setChineseName(Image_2, "采集_圆形图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, 25.0)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Main_Collect, "Image_3", 40.00, 0.00, "res/private/main/collect/bg_xbzy_01.png")
	GUI:setChineseName(Image_3, "采集_文字背景图")
	GUI:setAnchorPoint(Image_3, 0.50, 0.00)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 27.0)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Main_Collect, "Text_1", 40.00, 10.00, 16.0, "#ffffff", [[采集]])
	GUI:setChineseName(Text_1, "采集_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 26.0)
	GUI:Text_enableOutline(Text_1, "#000000", 1.0)

	-- Create Layout_BG
	local Layout_BG = GUI:Layout_Create(Main_Collect, "Layout_BG", 68.00, 50.00, 200.00, 120.00, false)
	GUI:Layout_setBackGroundImage(Layout_BG, "res/private/item_tips/bg_tipszy_05.png")
	GUI:Layout_setBackGroundImageScale9Slice(Layout_BG, 0, 135.0, 0, 173.0)
	GUI:setTouchEnabled(Layout_BG, false)
	GUI:setTag(Layout_BG, -1.0)

	-- Create List_Collect_Select
	local List_Collect_Select = GUI:ListView_Create(Main_Collect, "List_Collect_Select", 68.00, 50.00, 200.00, 120.00, 1.0)
	GUI:ListView_setGravity(List_Collect_Select, 5.0)
	GUI:ListView_setItemsMargin(List_Collect_Select, 3.0)
	GUI:setTouchEnabled(List_Collect_Select, true)
	GUI:setTag(List_Collect_Select, -1.0)
end
return ui