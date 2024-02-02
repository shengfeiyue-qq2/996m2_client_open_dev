AuctionWorld = {}

AuctionWorld.MaxFilterCells        = 8              -- 筛选弹出列表最多显示条数
AuctionWorld.Group1CellColorSel    = "#f8e6c6"      -- 左侧页签选中时按钮文字颜色
AuctionWorld.Group1CellColorNormal = "#6c6861"      -- 左侧页签未选中时按钮文字颜色
AuctionWorld.FilterPriceArrowUp    = "res/public/btn_szjm_01_3.png"    -- 筛选价格向上箭头图片
AuctionWorld.FilterPriceArrowDown  = "res/public/btn_szjm_01_4.png"    -- 筛选价格向上箭头图片

function AuctionWorld.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_world" or "auction/auction_world")
end

-- 左侧列表 一级标签
function AuctionWorld.CreateFilterGroup1Cell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_filter_group1_cell" or "auction/auction_filter_group1_cell")
end

-- 左侧列表 二级标签
function AuctionWorld.CreateFilterGroup2Cell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_filter_group2_cell" or "auction/auction_filter_group2_cell")
end

-- 底部筛选 cell
function AuctionWorld.CreateFilterCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_filter_cell" or "auction/auction_filter_cell")
end

-- 筛选结果 cell
function AuctionWorld.CreateItemCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_world_cell" or "auction/auction_world_cell")
end

-- 价格 cell
function AuctionWorld.CreatePriceCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_price_cell" or "auction/auction_price_cell")
end