AuctionPutout = {}

local function TimeFormatToStr(time)
    local day, hour, min, sec = 0, 0, 0, 0
    day  = math.floor(time / 86400)
    hour = math.fmod(math.floor(time / 3600), 24)
    min  = math.fmod(math.floor(time / 60), 60)
    sec  = math.fmod(time, 60)
    if day < 1 then
        return string.format("%02d:%02d:%02d", hour, min, sec)
    end
    return string.format("%02d天%02d时%02d分", day, hour, min)
end

function AuctionPutout.main(itemData)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_putout" or "auction/auction_putout")
    
    AuctionPutout._ui = GUI:ui_delegate(parent)

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(AuctionPutout._ui["Panel_2"], screenW / 2, posY)
    GUI:setContentSize(AuctionPutout._ui["Panel_1"], screenW, screenH)

    GUI:addOnClickEvent(AuctionPutout._ui["Button_cancel"], function ()
        SL:CloseAuctionPutoutUI()
    end)

    GUI:addOnClickEvent(AuctionPutout._ui["Button_submit"], function ()
        if not itemData then
            return
        end

        if SL:GetMetaValue("BAG_IS_FULL") then
            SL:ShowSystemTips("背包空间不足！")
            return
        end

        SL:RequestAuctionPutout(itemData.MakeIndex)
    end)

    -- item
    local Image_icon = AuctionPutout._ui["Image_icon"]
    local itemSize = GUI:getContentSize(Image_icon)
    GUI:removeAllChildren(Image_icon)
    local goodsInfo = {itemData=itemData, look=true, index=itemData.Index, disShowCount = true,}
    local goodsItem = GUI:ItemShow_Create(Image_icon, "goodsItem", itemSize.width/2, itemSize.height/2, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    
    -- name
    GUI:Text_setString(AuctionPutout._ui["Text_name"], SL:GetMetaValue("ITEM_NAME", itemData.Index))

    -- 数量
    GUI:Text_setString(AuctionPutout._ui["Text_count"], "数量："..(itemData.OverLap or 1))

    -- 状态
    local Text_status = AuctionPutout._ui["Text_status"]
    local Text_remaining = AuctionPutout._ui["Text_remaining"]
    local function callback()
        local status, remaining = SL:GetMetaValue("AUCTION_ITEM_STATE", itemData)
        if status == 0 then
            GUI:Text_setString(Text_status, "-")
            GUI:Text_setString(Text_remaining, "-")

        elseif status == 2 then
            GUI:Text_setString(Text_status, "竞拍中")
            GUI:Text_setTextColor(Text_status, "#28ef01")
            local timeStr = TimeFormatToStr(remaining)
            Text_remaining:setString("竞拍中 "..timeStr)
            GUI:Text_setTextColor(Text_remaining, "#28ef01")

        elseif status == 3 then
            GUI:Text_setString(Text_status, "超时")
            GUI:Text_setTextColor(Text_status, "#ff0500")
            Text_remaining:setString("超时")
            GUI:Text_setTextColor(Text_remaining, "#ff0500")
        end
    end
    SL:schedule(Text_remaining, callback, 1)
    callback()

    -- 竞拍价
    local money_bid = AuctionPutout._ui["Node_money_bid"]
    GUI:removeAllChildren(money_bid)
    local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", itemData)
    if bidAble then
        local goodsItem = GUI:ItemShow_Create(money_bid, "goodsBid", 0, 0, {index=itemData.type, look=true})
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, 0.7)
        GUI:Text_setString(AuctionPutout._ui["Text_bid_price"], itemData.price)
    else
        GUI:Text_setString(AuctionPutout._ui["Text_bid_price"], "无法竞价")
    end

    -- 一口价
    local money_buy = AuctionPutout._ui["Node_money_buy"]
    GUI:removeAllChildren(money_buy)
    local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", itemData)
    if buyAble then
        local goodsItem = GUI:ItemShow_Create(money_buy, "goodsBid", 0, 0, {index=itemData.type, look=true})
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:setScale(goodsItem, 0.7)
        GUI:Text_setString(AuctionPutout._ui["Text_buy_price"], itemData.lastprice)
    else
        GUI:Text_setString(AuctionPutout._ui["Text_buy_price"], "无法一口价")
    end
end