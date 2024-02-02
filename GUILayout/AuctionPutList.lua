AuctionPutList = {}

AuctionPutList.ItemListCol = 2      -- 物品列表 列数
AuctionPutList.BagListCol  = 4      -- 背包物品列表 列数
AuctionPutList.ShelfCount  = 8      -- 默认货架数量

function AuctionPutList.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list" or "auction/auction_put_list")
end

-- 道具列表 cell
function AuctionPutList.CreateItemCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list_cell" or "auction/auction_put_list_cell")
end

-- 空列表 cell
function AuctionPutList.CreateEmptyCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list_empty_cell" or "auction/auction_put_list_empty_cell")
end

-- 背包物品 cell
function AuctionPutList.CreateBagCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list_bag_cell" or "auction/auction_put_list_bag_cell")
end