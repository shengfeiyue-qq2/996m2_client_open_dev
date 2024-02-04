local ui = {}
function ui.init(parent)
	-- Create Cell
	local Cell = GUI:Layout_Create(parent, "Cell", 0.00, 0.00, 451.00, 40.00, true)
	GUI:setTouchEnabled(Cell, true)
	GUI:setTag(Cell, -1)

	-- Create CellBg
	local CellBg = GUI:Image_Create(Cell, "CellBg", 0.00, 0.00, "res/private/rank_ui/rank_ui_mobile/1900020022.png")
	GUI:setTouchEnabled(CellBg, false)
	GUI:setTag(CellBg, -1)

	-- Create TRankBg
	local TRankBg = GUI:Image_Create(Cell, "TRankBg", 20.00, 20.00, "res/private/rank_ui/rank_ui_mobile/1900020023.png")
	GUI:setAnchorPoint(TRankBg, 0.50, 0.50)
	GUI:setTouchEnabled(TRankBg, false)
	GUI:setTag(TRankBg, -1)

	-- Create ImageRank
	local ImageRank = GUI:Image_Create(Cell, "ImageRank", 20.00, 20.00, "res/private/rank_ui/rank_ui_mobile/1900020025.png")
	GUI:setAnchorPoint(ImageRank, 0.50, 0.50)
	GUI:setTouchEnabled(ImageRank, false)
	GUI:setTag(ImageRank, -1)

	-- Create TextRank
	local TextRank = GUI:Text_Create(Cell, "TextRank", 20.00, 20.00, 18, "#ffffff", [[4]])
	GUI:setAnchorPoint(TextRank, 0.50, 0.50)
	GUI:setTouchEnabled(TextRank, false)
	GUI:setTag(TextRank, -1)
	GUI:Text_enableOutline(TextRank, "#000000", 1)

	-- Create TextName
	local TextName = GUI:Text_Create(Cell, "TextName", 118.00, 20.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(TextName, 0.50, 0.50)
	GUI:setTouchEnabled(TextName, false)
	GUI:setTag(TextName, -1)
	GUI:Text_enableOutline(TextName, "#000000", 1)

	-- Create TextLevel
	local TextLevel = GUI:Text_Create(Cell, "TextLevel", 250.00, 20.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(TextLevel, 0.50, 0.50)
	GUI:setTouchEnabled(TextLevel, false)
	GUI:setTag(TextLevel, -1)
	GUI:Text_enableOutline(TextLevel, "#000000", 1)

	-- Create TextGuildName
	local TextGuildName = GUI:Text_Create(Cell, "TextGuildName", 380.00, 20.00, 16, "#ffffff", [[]])
	GUI:setAnchorPoint(TextGuildName, 0.50, 0.50)
	GUI:setTouchEnabled(TextGuildName, false)
	GUI:setTag(TextGuildName, -1)
	GUI:Text_enableOutline(TextGuildName, "#000000", 1)

	-- Create SelRankBg
	local SelRankBg = GUI:Image_Create(Cell, "SelRankBg", 0.00, 0.00, "res/private/rank_ui/rank_ui_mobile/1900020028.png")
	GUI:setContentSize(SelRankBg, 451, 40)
	GUI:setIgnoreContentAdaptWithSize(SelRankBg, false)
	GUI:setTouchEnabled(SelRankBg, false)
	GUI:setTag(SelRankBg, -1)
	GUI:setVisible(SelRankBg, false)
end
return ui