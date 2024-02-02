local ui = {}
function ui.init(parent)
	-- Create Panel_cells
	local Panel_cells = GUI:Layout_Create(parent, "Panel_cells", 200.00, 329.00, 370.00, 33.00, false)
	GUI:setChineseName(Panel_cells, "排行榜_组合")
	GUI:setTouchEnabled(Panel_cells, true)
	GUI:setTag(Panel_cells, 1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_cells, "Image_bg", 0.00, 0.00, "res/private/rank_ui/rank_ui_win32/1900020022.png")
	GUI:setChineseName(Image_bg, "排行榜_背景")
	GUI:setOpacity(Image_bg, 128)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 2)

	-- Create Text_rank
	local Text_rank = GUI:Text_Create(Panel_cells, "Text_rank", 4.00, 16.00, 18, "#ffffff", [[4]])
	GUI:setChineseName(Text_rank, "排行榜_名次_第三名后")
	GUI:setAnchorPoint(Text_rank, 0.00, 0.50)
	GUI:setTouchEnabled(Text_rank, false)
	GUI:setTag(Text_rank, 3)
	GUI:Text_enableOutline(Text_rank, "#000000", 1)

	-- Create Panel_ranks
	local Panel_ranks = GUI:Layout_Create(Panel_cells, "Panel_ranks", 0.00, -1.00, 34.00, 34.00, false)
	GUI:setChineseName(Panel_ranks, "排行榜_名次组合")
	GUI:setTouchEnabled(Panel_ranks, true)
	GUI:setTag(Panel_ranks, 4)

	-- Create Image_rank_bg
	local Image_rank_bg = GUI:Image_Create(Panel_ranks, "Image_rank_bg", 17.00, 17.00, "res/private/rank_ui/rank_ui_win32/1900020023.png")
	GUI:setChineseName(Image_rank_bg, "排行榜_名次背景")
	GUI:setAnchorPoint(Image_rank_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_rank_bg, false)
	GUI:setTag(Image_rank_bg, 5)

	-- Create Image_rank
	local Image_rank = GUI:Image_Create(Panel_ranks, "Image_rank", 17.00, 17.00, "res/private/rank_ui/rank_ui_win32/1900020025.png")
	GUI:setChineseName(Image_rank, "排行榜_名次_图片")
	GUI:setAnchorPoint(Image_rank, 0.50, 0.50)
	GUI:setTouchEnabled(Image_rank, false)
	GUI:setTag(Image_rank, 6)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_cells, "Text_1", 90.00, 16.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_1, "排行榜_玩家昵称_文本")
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 7)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_cells, "Text_3", 195.00, 16.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_3, "排行榜_行会名或自定义")
	GUI:setAnchorPoint(Text_3, 0.50, 0.50)
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, 8)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_cells, "Text_4", 307.00, 16.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_4, "排行榜_行会名(前一个为自定义时)")
	GUI:setAnchorPoint(Text_4, 0.50, 0.50)
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, 9)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_cells, "Image_select", 0.00, 0.00, "res/private/rank_ui/rank_ui_win32/1900020028.png")
	GUI:setContentSize(Image_select, 370, 33)
	GUI:setIgnoreContentAdaptWithSize(Image_select, false)
	GUI:setChineseName(Image_select, "排行榜_选中状态")
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(Panel_cells, "Panel_touch", 0.00, 0.00, 370.00, 33.00, false)
	GUI:setChineseName(Panel_touch, "排行榜_名次_触摸范围")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, 10)
end
return ui