AuctionPutList = {}

function AuctionPutList.main( )
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width

    -- 底
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, 410)
    GUI:setTouchEnabled(PMainUI, true)

    local line1 = GUI:Image_Create(PMainUI, "line1", 0, 406, "res/public/bg_yyxsz_01.png")
    local line2 = GUI:Image_Create(PMainUI, "line2", 455, 405.5, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(line2, {width = 361, height = 2})
    GUI:setRotation(line2, 90)
    local line3 = GUI:Image_Create(PMainUI, "line3", 0, 45, "res/public/bg_yyxsz_01.png")
    

    -- 上架物品
    local Text_tile = GUI:Text_Create(PMainUI, "Text_tile", 228, 390, 16, "#FFFFFF", "寄售货架")
    GUI:setAnchorPoint(Text_tile, 0.5, 0.5)
    local ScrollView_items = GUI:ScrollView_Create(PMainUI, "ScrollView_items", 1, 47, 450, 330, 1)

    local itemEmptyCell = AuctionPutList.createItemEmptyCell(PMainUI)
    GUI:setVisible(itemEmptyCell, false)

    local itemCell = AuctionPutList.createItemCell(PMainUI)
    GUI:setVisible(itemCell, false)


    -- 背包物品
    local Text_tile2 = GUI:Text_Create(PMainUI, "Text_tile2", 595, 390, 16, "#FFFFFF", "选择寄售道具")
    GUI:setAnchorPoint(Text_tile2, 0.5, 0.5)
    local ScrollView_bag = GUI:ScrollView_Create(PMainUI, "ScrollView_bag", 458, 47, 270, 330, 1)

    local bagCell = AuctionPutList.createBagCell(PMainUI)
    GUI:setVisible(bagCell, false)
end

-- 上架物品 cell
function AuctionPutList.createItemCell(parent)
    local iCell = GUI:Layout_Create(parent, "iCell", 0, 0, 225, 110)
    GUI:setTouchEnabled(iCell, true)

    local Image_bg = GUI:Image_Create(iCell, "Image_bg", 2.5, 0, "res/public/1900000665.png")
    GUI:setContentSize(Image_bg, {width = 220, height = 105})

    local Image_item = GUI:Image_Create(iCell, "Image_item", 45, 40, "res/public/1900000651.png")
    GUI:setContentSize(Image_item, {width = 60, height = 60})
    GUI:setAnchorPoint(Image_item, 0.5, 0.5)

    local Text_name = GUI:Text_Create(iCell, "Text_name", 112.5, 90, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)

    local Panel_money = GUI:Layout_Create(iCell, "Panel_money", 145, 65, 0, 0)

    local Text_price_name = GUI:Text_Create(iCell, "Text_price_name", 105, 65, 16, "#FFFFFF", "竞　价:")
    GUI:setAnchorPoint(Text_price_name, 0.5, 0.5)
    local Text_price = GUI:Text_Create(iCell, "Text_price", 165, 65, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_price, 0, 0.5)

    local Text_unable_bid = GUI:Text_Create(iCell, "Text_unable_bid", 135, 65, 16, "#FFFFFF", "无法竞价")
    GUI:setAnchorPoint(Text_unable_bid, 0, 0.5)

    local Panel_buy_money = GUI:Layout_Create(iCell, "Panel_buy_money", 145, 45, 0 , 0)

    local Text_buy_name = GUI:Text_Create(iCell, "Text_buy_name", 77.5, 45, 16, "#FFFFFF", "一口价:")
    GUI:setAnchorPoint(Text_buy_name, 0, 0.5)

    local Text_buy_price = GUI:Text_Create(iCell, "Text_buy_price", 165, 45, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_buy_price, 0, 0.5)

    local Text_unable_buy = GUI:Text_Create(iCell, "Text_unable_buy", 165, 45, 16, "#FFFFFF", "无法一口价")
    GUI:setAnchorPoint(Text_unable_buy, 0, 0.5)

    local Text_status = GUI:Text_Create(iCell, "Text_status", 140, 25, 16, "#FFFFFF", "超时")
    GUI:setAnchorPoint(Text_status, 0.5, 0.5)

    return iCell
end

-- 上架物品 没物品的 cell
function AuctionPutList.createItemEmptyCell(parent)
    local iEmptyCell = GUI:Layout_Create(parent, "iEmptyCell", 0, 0, 225, 110)
    GUI:setTouchEnabled(iEmptyCell, true)

    local Image_bg = GUI:Image_Create(iEmptyCell, "Image_bg", 2.5, 0, "res/public/1900000665.png")
    GUI:setContentSize(Image_bg, {width = 220, height = 105})

    local Image_item = GUI:Image_Create(iEmptyCell, "Image_item", 45, 40, "res/public/1900000651.png")
    GUI:setContentSize(Image_item, {width = 60, height = 60})
    GUI:setAnchorPoint(Image_item, 0.5, 0.5)

    local Image_Add = GUI:Image_Create(iEmptyCell, "Image_Add", 45, 40, "res/public/btn_jiahao_01.png")
    GUI:setContentSize(Image_Add, {width = 30, height = 30})
    GUI:setAnchorPoint(Image_Add, 0.5, 0.5)

    local Text_name = GUI:Text_Create(iEmptyCell, "Text_name", 145, 45, 16, "#FFFFFF", "右侧点击道具\n上架")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:Text_setTextHorizontalAlignment(Text_name, 1)

    return iEmptyCell
end

-- 背包物品 cell
function AuctionPutList.createBagCell(parent)
    local bCell = GUI:Layout_Create(parent, "bCell", 0, 0, 67.5, 67.5)
    GUI:setAnchorPoint(bCell, {x=0.5, y=0.5})
    GUI:setTouchEnabled(bCell, true)
    local Image_bg = GUI:Image_Create(bCell, "Image_bg", 33.75, 33.75, "res/public/1900000651.png")
    GUI:setContentSize(Image_bg, {width = 60, height = 60})
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)

    return bCell
end