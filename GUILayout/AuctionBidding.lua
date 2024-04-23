AuctionBidding = {}

function AuctionBidding.main( )
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width

    -- 底
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, 410)
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    local line1 = GUI:Image_Create(PMainUI, "line1", 0, 406, "res/public/bg_yyxsz_01.png")
    local line2 = GUI:Image_Create(PMainUI, "line2", 0, 373, "res/public/bg_yyxsz_01.png")

    local Text1 = GUI:Text_Create(PMainUI, "Text1", 85, 388, 16, "#FFFFFF", "竞拍道具")
    GUI:setAnchorPoint(Text1, 0.5, 0.5)
    local Text2 = GUI:Text_Create(PMainUI, "Text2", 275, 388, 16, "#FFFFFF", "剩余时间")
    GUI:setAnchorPoint(Text2, 0.5, 0.5)
    local Text3 = GUI:Text_Create(PMainUI, "Text3", 467, 388, 16, "#FFFFFF", "竞拍价格")
    GUI:setAnchorPoint(Text3, 0.5, 0.5)
    local Text4 = GUI:Text_Create(PMainUI, "Text4", 660, 388, 16, "#FFFFFF", "一口价")
    GUI:setAnchorPoint(Text4, 0.5, 0.5)

    local Image_empty = GUI:Image_Create(PMainUI, "Image_empty", attachW/2, 200, "res/private/auction/word_paimaihang_01.png")
    GUI:setAnchorPoint(Image_empty, 0.5, 0.5)

    local ListItems = GUI:ListView_Create(PMainUI, "ListItems", 0, 0, 730, 373, 1)
    local itemCell = AuctionBidding.createItemCell(PMainUI)
    GUI:setVisible(itemCell, false)

    local MaxTips = GUI:Text_Create(PMainUI, "MaxTips", 600, 20, 16, "#FFFFFF", "我的竞拍只显示100条竞拍")
    GUI:setVisible(MaxTips, false)

end

-- 道具列表 cell
function AuctionBidding.createItemCell(parent)
    local iCell = GUI:Layout_Create(parent, "iCell", 0, 0, 730, 85)

    local line = GUI:Image_Create(iCell, "iline", 0, 0, "res/public/1900000667.png")
    GUI:setContentSize(line, {width = 605, height = 2})

    local Image_item = GUI:Image_Create(iCell, "Image_item", 60, 42.5, "res/public/1900000664.png")
    GUI:setAnchorPoint(Image_item, 0.5, 0.5)

    local Text_name = GUI:Text_Create(iCell, "Text_name", 100, 42.5, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0, 0.5)

    local Text_remaining = GUI:Text_Create(iCell, "Text_remaining", 275, 42.5, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_remaining, 0.5, 0.5)

    local Text_status = GUI:Text_Create(iCell, "Text_status", 467, 70, 16, "#FFFFFF", "竞价被超过")
    GUI:setAnchorPoint(Text_status, 0.5, 0.5)
    local Text_acquire = GUI:Text_Create(iCell, "Text_acquire", 530, 42.5, 16, "#FFFFFF", "竞拍成功")
    GUI:setAnchorPoint(Text_acquire, 0.5, 0.5)
    local Node_bid_price = GUI:Node_Create(iCell, "Node_bid_price", 465, 42.5)
    local Button_bid = GUI:Button_Create(iCell, "Button_bid", 502, 42.5, "res/public/1900000652.png")
    GUI:setContentSize(Button_bid, {width = 65, height = 27})
    GUI:Button_setScale9Slice(Button_bid, 11, 11, 4, 4)
    GUI:setAnchorPoint(Button_bid, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_bid, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_bid, 18)
    GUI:Button_setTitleText(Button_bid, "竞价")

    local Text_unable_buy = GUI:Text_Create(iCell, "Text_unable_buy", 660, 42.5, 16, "#FFFFFF", "无法一口价")
    GUI:setAnchorPoint(Text_unable_buy, 0.5, 0.5)
    local Text_rebate = GUI:Text_Create(iCell, "Text_rebate", 575, 70, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_rebate, 0.5, 0.5)
    local Node_price = GUI:Node_Create(iCell, "Node_price", 655, 42.5)

    local Button_buy = GUI:Button_Create(iCell, "Button_buy", 690, 42.5, "res/public/1900000652.png")
    GUI:setContentSize(Button_buy, {width = 65, height = 27})
    GUI:Button_setScale9Slice(Button_buy, 11, 11, 4, 4)
    GUI:setAnchorPoint(Button_buy, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_buy, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_buy, 18)
    GUI:Button_setTitleText(Button_buy, "购买")

    local Button_acquire = GUI:Button_Create(iCell, "Button_acquire", 605, 42.5, "res/public/1900000652.png")
    GUI:setContentSize(Button_acquire, {width = 65, height = 27})
    GUI:Button_setScale9Slice(Button_acquire, 11, 11, 4, 4)
    GUI:setAnchorPoint(Button_acquire, 0.5, 0.5)
    GUI:Button_setTitleColor(Button_acquire, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_acquire, 18)
    GUI:Button_setTitleText(Button_acquire, "领取")
    
    return iCell
end

-- 价格 cell
function AuctionBidding.CreatePriceCell(parent)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction/auction_price_cell_win32" or "auction/auction_price_cell")
end