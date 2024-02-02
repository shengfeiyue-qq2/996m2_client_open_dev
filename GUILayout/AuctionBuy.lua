AuctionBuy = {}

local fixMinPrice = 1
local fixMaxPrice = 2000000000

function AuctionBuy.main(itemData)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_buy" or "auction/auction_buy")

    AuctionBuy._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(AuctionBuy._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(AuctionBuy._ui["Panel_1"], screenW, screenH)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_close"], function()
        SL:CloseAuctionBuyUI()
    end)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_cancel"], function()
        SL:CloseAuctionBuyUI()
    end)

    GUI:addOnClickEvent(AuctionBuy._ui["Button_submit"], function()
        if not itemData then
            return
        end

        -- 背包已满
        if SL:GetMetaValue("BAG_IS_FULL", true) then
            return
        end

        -- 货币不足
        local currencyCount = tonumber(SL:GetMetaValue("ITEM_COUNT", itemData.type))
        if currencyCount and currencyCount < itemData.lastprice then
            SL:ShowSystemTips(string.format("您的%s不足", SL:GetMetaValue("ITEM_NAME", itemData.type)))
            return
        end

        SL:RequestAuctionBid(itemData.MakeIndex, itemData.lastprice)
    end)

    -- item
    local Image_icon = AuctionBuy._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = { itemData = itemData, look = true, index = itemData.Index }
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width / 2, itemSize.height / 2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

    -- name
    GUI:Text_setString(AuctionBuy._ui["Text_name"], SL:GetMetaValue("ITEM_NAME", itemData.Index))

    local goodsItem = GUI:ItemShow_Create(AuctionBuy._ui["Node_money"], "goodsItem", 0, 0, itemData.type)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    GUI:setScale(goodsItem, 0.7)

    GUI:Text_setString(AuctionBuy._ui["Text_count"], itemData.OverLap)
    GUI:Text_setString(AuctionBuy._ui["Text_price"], itemData.lastprice)
end