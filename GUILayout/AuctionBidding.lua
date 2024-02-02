AuctionBidding = {}

function AuctionBidding.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_bidding" or "auction/auction_bidding")
end

-- 道具列表 cell
function AuctionBidding.CreateItemCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_bidding_cell" or "auction/auction_bidding_cell")
end

-- 价格 cell
function AuctionBidding.CreatePriceCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_price_cell" or "auction/auction_price_cell")
end