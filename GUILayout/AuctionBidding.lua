AuctionBidding = {}

function AuctionBidding.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_bidding" or "auction/auction_bidding")
    AuctionBidding._ui = GUI:ui_delegate(parent)

    local isPC = SL:GetMetaValue("WINPLAYMODE")
    -- 单个列表cell 尺寸
    AuctionBidding._itemSize = isPC and {width = 606, height = 70} or {width = 730, height = 85}

    AuctionBidding._quickCells = {}
    AuctionBidding._itemList = {}
    SL:RequestAuctionPutList(2)

    GUI:ListView_addMouseScrollPercent(AuctionBidding._ui.ListView_items)
end

-- 道具列表 cell
function AuctionBidding.CreateItemCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_bidding_cell" or "auction/auction_bidding_cell")

    if not data then
        return nil
    end

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_1")
    
    local mainPlayerID = SL:GetMetaValue("USER_ID")
    data = AuctionBidding._itemList[data.MakeIndex]

    local iconSize = GUI:getContentSize(ui.Image_item)
    local item = GUI:ItemShow_Create(ui.Image_item, "item", iconSize.width / 2, iconSize.height / 2, {
        index = data.Index,
        itemData = data,
        look = true,
        checkPower = true,
        diff = true,
        mouseCheckTimes = 8
    })
    GUI:setAnchorPoint(item, 0.5, 0.5)

    -- 名字
    local color = (data.Color and data.Color > 0) and data.Color
    local colorHex = color and SL:GetHexColorByStyleId(color) or SL:GetMetaValue("ITEM_NAME_COLOR_VALUE", data.Index)
    local itemName = data.Name
    GUI:Text_setString(ui.Text_name, "")
    local fontSize = GUI:Text_getFontSize(ui.Text_name)
    local scrollText = GUI:ScrollText_Create(ui.Text_name, "scrollText", 0, 0, 98, fontSize, colorHex, itemName)
    GUI:ScrollText_setHorizontalAlignment(scrollText, 1)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0, 1)

    -- 倒计时
    local function callback()
        local status, remaining = SL:GetMetaValue("AUCTION_ITEM_STATE", data)

        local timeData = SL:SecondToHMS(remaining)
        local hour = timeData.h + 24 * timeData.d
        local timeStr  = string.format("%02d:%02d:%02d", hour, timeData.m, timeData.s)
        GUI:Text_setString(ui.Text_remaining, timeStr)

        if status == 0 or status == 3 then
            GUI:Text_setString(ui.Text_remaining, "-")
            GUI:Text_setTextColor(ui.Text_remaining, "#FFFFFF")

        elseif status == 1 then
            GUI:Text_setTextColor(ui.Text_remaining, "#FFFF0F")

        elseif status == 2 then
            GUI:Text_setTextColor(ui.Text_remaining, remaining > 60 and "#FFFFFF" or "#ff0500")
        end

        -- 竞价
        local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", data)
        if bidAble then
            if status == 2 then
                GUI:Button_setTitleColor(ui.Button_bid, "#FFFFFF")
                GUI:setVisible(ui.Text_status, true)
                
                if data.curruserid == mainPlayerID then
                    GUI:Text_setString(ui.Text_status, "您目前竞价最高")
                    GUI:Text_setTextColor(ui.Text_status, "#28ef01")

                elseif data.curruserid ~= mainPlayerID and data.joinuser == 1 then
                    GUI:Text_setString(ui.Text_status, "竞价被超过")
                    GUI:Text_setTextColor(ui.Text_status, "#ff0500")
                    
                elseif data.curruserid ~= "" then
                    GUI:Text_setString(ui.Text_status, "竞价中")
                    GUI:Text_setTextColor(ui.Text_status, "#FFFFFF")
                else
                    GUI:setVisible(ui.Text_status, false)
                end
            else
                GUI:Button_setTitleColor(ui.Button_bid, "#A6A6A6")
                GUI:setVisible(ui.Text_status, false)
            end
        end

        -- 一口价
        local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", data)
        if buyAble then
            if status == 2 then
                GUI:Button_setTitleColor(ui.Button_buy, "#FFFFFF")
            else
                GUI:Button_setTitleColor(ui.Button_buy, "#A6A6A6")
            end
        end
    end
    SL:schedule(ui.Text_remaining, callback, 1)
    callback()

    -- 竞拍价
    local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", data)
    if bidAble then
        GUI:removeAllChildren(ui.Node_bid_price)
        AuctionBidding.CreatePriceCell(ui.Node_bid_price, {id = data.type, count = data.price})

        GUI:addOnClickEvent(ui.Button_bid, function()
            local status = SL:GetMetaValue("AUCTION_ITEM_STATE", data)
            if status == 2 then
                if data.curruserid == mainPlayerID then
                    SL:ShowSystemTips("无法连续出价")
                else
                    SL:OpenAuctionBidUI(data)
                end
            elseif status == 1 then
                SL:ShowSystemTips("还未到开拍时间")
            else
                SL:ShowSystemTips("无法竞价")
            end
        end)
    else
        GUI:setVisible(ui.Button_bid, false)
        GUI:setPositionY(ui.Text_status, math.floor(AuctionBidding._itemSize.height / 2))
        GUI:Text_setTextColor(ui.Text_status, "#FFFFFF")
        GUI:Text_setString(ui.Text_status, "无法竞价")
    end

    -- 一口价
    local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", data)
    if buyAble then
        GUI:removeAllChildren(ui.Node_price)
        AuctionBidding.CreatePriceCell(ui.Node_price, {id = data.type, count = data.lastprice})
        
        GUI:addOnClickEvent(ui.Button_buy, function()
            local status = SL:GetMetaValue("AUCTION_ITEM_STATE", data)
            if status == 2 then
                SL:OpenAuctionBuyUI(data)
            elseif status == 1 then
                SL:ShowSystemTips("还未到开拍时间")
            else
                SL:ShowSystemTips("无法竞价")
            end
        end)
    end
    GUI:setVisible(ui.Button_buy, buyAble)
    GUI:setVisible(ui.Text_unable_buy, not buyAble)

    -- 领取
    GUI:addOnClickEvent(ui.Button_acquire, function()
        if SL:GetMetaValue("BAG_IS_FULL") then
            SL:ShowSystemTips("背包空间不足！")
            return
        end
        SL:RequestAcquireBidItem(data.MakeIndex)
    end)

    -- 领取or拍卖
    if data.flag == 1 and data.curruserid == mainPlayerID then
        GUI:setVisible(ui.Text_acquire, true)
        GUI:setVisible(ui.Button_acquire, true)
        GUI:setPositionX(ui.Node_bid_price, SL:GetMetaValue("WINPLAYMODE") and 430 or 520)

        GUI:stopAllActions(ui.Text_remaining)
        GUI:Text_setString(ui.Text_remaining, "-")
        GUI:setVisible(ui.Text_unable_buy, false)
        GUI:setVisible(ui.Button_buy, false)
        GUI:setVisible(ui.Node_price, false)
        GUI:setVisible(ui.Text_status, false)
        GUI:setVisible(ui.Button_bid, false)
        
    else
        GUI:setVisible(ui.Text_acquire, false)
        GUI:setVisible(ui.Button_acquire, false)
    end

    return cell
end

-- 价格 cell
function AuctionBidding.CreatePriceCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_price_cell" or "auction/auction_price_cell")
    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, {index = data.id, look = true, mouseCheckTimes = 8})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)

    return ui
end

function AuctionBidding.UpdateBiddingList(items)
    GUI:ListView_removeAllItems(AuctionBidding._ui.ListView_items)
    GUI:ListView_jumpToTop(AuctionBidding._ui.ListView_items)
    AuctionBidding._quickCells = {}
    AuctionBidding._itemList = {}

    local count = items and #items or 0
    GUI:setVisible(AuctionBidding._ui.TextMaxTips, count >= 100)
    GUI:setVisible(AuctionBidding._ui.Image_empty, count == 0)

    if items and next(items) then
        while next(items) do
            local item = table.remove(items, 1)

            local function createCell(parent)
                local cell = AuctionBidding.CreateItemCell(parent, item) 
                return cell 
            end
            local quickCell = GUI:QuickCell_Create(AuctionBidding._ui.ListView_items, "item_" .. item.MakeIndex, 0, 0, AuctionBidding._itemSize.width, AuctionBidding._itemSize.height, createCell)
            AuctionBidding._quickCells[item.MakeIndex] = quickCell
            AuctionBidding._itemList[item.MakeIndex] = item
        end
    end
end

function AuctionBidding.OnAuctionItemAdd(data)
    local item = data

    local mainPlayerID = SL:GetMetaValue("USER_ID")
    if item.joinuser == 1 and (item.flag == 0 or (item.flag == 1 and item.curruserid == mainPlayerID)) then
        local innerPos = GUI:ListView_getInnerContainerPosition(AuctionBidding._ui.ListView_items)

        local function createCell(parent)
            local cell = AuctionBidding.CreateItemCell(parent, item) 
            return cell 
        end
        local quickCell = GUI:QuickCell_Create(AuctionBidding._ui.ListView_items, "item_" .. item.MakeIndex, 0, 0, AuctionBidding._itemSize.width, AuctionBidding._itemSize.height, createCell)
        AuctionBidding._quickCells[item.MakeIndex] = quickCell
        AuctionBidding._itemList[item.MakeIndex] = item
        
        GUI:ListView_doLayout(AuctionBidding._ui.ListView_items)
        innerPos.y = innerPos.y + AuctionBidding._itemSize.height
        innerPos.y = math.min(0, innerPos.y)
        GUI:ListView_setInnerContainerPosition(AuctionBidding._ui.ListView_items, innerPos)
    end
    GUI:setVisible(AuctionBidding._ui.Image_empty, next(AuctionBidding._quickCells) == nil)
end

function AuctionBidding.OnAuctionItemDel(data)
    local item = data

    -- not exist
    if not AuctionBidding._itemList[item.MakeIndex] or not AuctionBidding._quickCells[item.MakeIndex] then
        return nil
    end

    local cell = AuctionBidding._quickCells[item.MakeIndex]
    local idx = GUI:ListView_getItemIndex(AuctionBidding._ui.ListView_items, cell)
    local innerPos = GUI:ListView_getInnerContainerPosition(AuctionBidding._ui.ListView_items)
    GUI:ListView_removeItemByIndex(AuctionBidding._ui.ListView_items, idx)
    GUI:ListView_doLayout(AuctionBidding._ui.ListView_items)
    innerPos.y = innerPos.y + AuctionBidding._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(AuctionBidding._ui.ListView_items, innerPos)

    AuctionBidding._quickCells[item.MakeIndex] = nil
    AuctionBidding._itemList[item.MakeIndex] = nil

    GUI:setVisible(AuctionBidding._ui.Image_empty, next(AuctionBidding._quickCells) == nil)
end

function AuctionBidding.OnAuctionItemChange(data)
    local item = data

    -- not exist
    if not AuctionBidding._itemList[item.MakeIndex] or not AuctionBidding._quickCells[item.MakeIndex] then
        return nil
    end

    local quickCell = AuctionBidding._quickCells[item.MakeIndex]
    local mainPlayerID = SL:GetMetaValue("USER_ID")
    if (item.flag == 0 or (item.flag == 1 and item.curruserid == mainPlayerID)) then
        AuctionBidding._itemList[item.MakeIndex] = item
        GUI:QuickCell_Exit(quickCell)
        GUI:QuickCell_Refresh(quickCell)
    else
        AuctionBidding.OnAuctionItemDel(item)
    end
end