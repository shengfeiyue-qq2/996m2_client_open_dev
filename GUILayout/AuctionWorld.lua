AuctionWorld = {}

AuctionWorld.MaxFilterCells        = 15             -- 筛选弹出列表最多显示条数
AuctionWorld.Group1CellColorSel    = "#f8e6c6"      -- 左侧页签选中时按钮文字颜色
AuctionWorld.Group1CellColorNormal = "#6c6861"      -- 左侧页签未选中时按钮文字颜色
AuctionWorld.FilterPriceArrowUp    = "res/public/btn_szjm_01_3.png"    -- 筛选价格向上箭头图片
AuctionWorld.FilterPriceArrowDown  = "res/public/btn_szjm_01_4.png"    -- 筛选价格向上箭头图片

function AuctionWorld.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_world" or "auction/auction_world")
    
    AuctionWorld._ui = GUI:ui_delegate(parent)

    -- 单个列表cell 尺寸
    AuctionWorld._itemSize = SL:GetMetaValue("WINPLAYMODE") and {width = 505, height = 70} or {width = 605, height = 85}

    AuctionWorld._source = data or 0    -- 0.世界拍卖 1.行会拍卖
    AuctionWorld._items = {}
    AuctionWorld._qCells = {}

    -- 单职业
    local isSingleJob = SL:GetMetaValue("GAME_DATA", "isSingleJob")
    if isSingleJob and tonumber(isSingleJob) ~= 0 then
        GUI:setVisible(AuctionWorld._ui.Node_filter_job, false)
    end
end

function AuctionWorld.OnClearItemList()
    AuctionWorld._items = {}
    AuctionWorld._qCells = {}
    GUI:ListView_removeAllItems(AuctionWorld._ui.ListView_items)
    GUI:ListView_jumpToTop(AuctionWorld._ui.ListView_items)
    GUI:setVisible(AuctionWorld._ui.Image_empty, true)
end

local function checkItemShowble(item)
    -- 超时隐藏!
    local status = SL:GetMetaValue("AUCTION_ITEM_STATE", item)
    if status == 3 then
        SL:Print("auction_error_timeout", string.format("MakeIndex=%s  Index=%s", item.MakeIndex, item.Index))
        return false
    end

    -- 拍卖成功/流拍
    if item.flag ~= 0 then
        return false
    end

    return true
end

function AuctionWorld.OnPullItemList(items)
    if items and next(items) then
        local lastIndex = #GUI:ListView_getItems(AuctionWorld._ui.ListView_items) - 1
        while next(items) do
            local item = table.remove(items, 1)

            if checkItemShowble(item) then
                local function createCell(parent)
                    local cell = AuctionWorld.CreateItemCell(parent, item) 
                    return cell 
                end
                local wid = AuctionWorld._itemSize.width
                local hei = AuctionWorld._itemSize.height
                local quickCell = GUI:QuickCell_Create(AuctionWorld._ui.ListView_items, "item_" .. item.MakeIndex, 0, 0, wid, hei, createCell)
                AuctionWorld._qCells[item.MakeIndex] = quickCell
                AuctionWorld._items[item.MakeIndex] = item
            end
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(AuctionWorld._ui.ListView_items, lastIndex)
        end
    end
    GUI:setVisible(AuctionWorld._ui.Image_empty, next(AuctionWorld._qCells) == nil)
end

function AuctionWorld.OnAuctionItemDel(item)
    if not item or not item.MakeIndex then
        return
    end

    if nil == AuctionWorld._qCells[item.MakeIndex] then
        return
    end

    local cell = AuctionWorld._qCells[item.MakeIndex]
    local innerPos = GUI:ListView_getInnerContainerPosition(AuctionWorld._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(AuctionWorld._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(AuctionWorld._ui.ListView_items, index)
    GUI:ListView_doLayout(AuctionWorld._ui.ListView_items)
    innerPos.y = innerPos.y + AuctionWorld._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(AuctionWorld._ui.ListView_items, innerPos)

    AuctionWorld._qCells[item.MakeIndex] = nil
    AuctionWorld._items[item.MakeIndex] = nil

    AuctionWorld._ui.Image_empty:setVisible(next(AuctionWorld._qCells) == nil)
end

function AuctionWorld.OnAuctionItemChange(item)
    if not item or not item.MakeIndex then
        return
    end

    if nil == AuctionWorld._qCells[item.MakeIndex] then
        return
    end

    -- 流拍/拍卖成功需要删除 
    if checkItemShowble(item) then
        AuctionWorld._items[item.MakeIndex] = item
        GUI:QuickCell_Exit(AuctionWorld._qCells[item.MakeIndex])
        GUI:QuickCell_Refresh(AuctionWorld._qCells[item.MakeIndex])
    else
        AuctionWorld.OnAuctionItemDel(item)
    end
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
function AuctionWorld.CreateItemCell(parent, item)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_world_cell" or "auction/auction_world_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_1")
    
    local mainPlayerID  = SL:GetMetaValue("USER_ID")
    item                = AuctionWorld._items[item.MakeIndex]

    local itemBgSize = GUI:getContentSize(ui.Image_item)
    local itemShow = GUI:ItemShow_Create(ui.Image_item, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
        index = item.Index,
        itemData = item,
        look = true,
        checkPower = true,
        diff = true,
        mouseCheckTimes = 8
    })
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    -- 名字
    local color = (item.Color and item.Color > 0) and item.Color
    local colorHex = color and SL:GetHexColorByStyleId(color) or SL:GetMetaValue("ITEM_NAME_COLOR_VALUE", item.Index)
    local itemName = item.Name
    GUI:Text_setString(ui.Text_name, "")
    local fontSize = GUI:Text_getFontSize(ui.Text_name)
    local scrollText = GUI:ScrollText_Create(ui.Text_name, "scrollText", 0, 0, SL:GetMetaValue("WINPLAYMODE") and 100 or 105, fontSize, colorHex, itemName)
    GUI:ScrollText_setHorizontalAlignment(scrollText, 1)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0, 1)

    -- 我的拍品
    GUI:setVisible(ui.Text_me, item.userid == mainPlayerID)

    -- 折扣
    if AuctionWorld._source and item.meguildrate then
        GUI:setVisible(ui.Text_rebate, AuctionWorld._source == 1 and item.meguildrate < 100 or false)
        GUI:Text_setString(ui.Text_rebate, string.format("%s折", item.meguildrate / 10))
    else
        GUI:setVisible(ui.Text_rebate, false)
    end

    -- 倒计时
    local function callback()
        local status, remaining = SL:GetMetaValue("AUCTION_ITEM_STATE", item)

        local timeData = SL:SecondToHMS(remaining)
        local hour = timeData.h + 24 * timeData.d
        local timeStr  = string.format("%02d:%02d:%02d", hour, timeData.m, timeData.s)
        GUI:Text_setString(ui.Text_remaining, timeStr)

        if status == 0 then
            GUI:setVisible(ui.Text_tstatus, false)
            GUI:Text_setString(ui.Text_remaining, "-")
            GUI:Text_setTextColor(ui.Text_remaining, "#ffffff")

        elseif status == 2 then
            GUI:setVisible(ui.Text_tstatus, false)
            GUI:Text_setTextColor(ui.Text_remaining, remaining > 60 and "#ffffff" or "#ff0500")

        elseif status == 3 then
            GUI:setVisible(ui.Text_tstatus, false)
            GUI:Text_setString(ui.Text_remaining, "-")
            GUI:Text_setTextColor(ui.Text_remaining, "#ffffff")

            -- 超时, 删除该道具
            GUI:addRef(cell)
            GUI:autoDecRef(cell)
            AuctionWorld.OnAuctionItemChange(item)
        end

        -- 竞价
        local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", item)
        if bidAble then
            if status == 2 then
                GUI:Button_setTitleColor(ui.Button_bid, "#FFFFFF")
                GUI:setVisible(ui.Text_status, true)

                if item.curruserid == mainPlayerID then
                    GUI:Text_setString(ui.Text_status, "您目前竞价最高")
                    GUI:Text_setTextColor(ui.Text_status, "#28ef01")

                elseif item.curruserid ~= mainPlayerID and item.joinuser == 1 then
                    GUI:Text_setString(ui.Text_status, "竞价被超过")
                    GUI:Text_setTextColor(ui.Text_status, "#ff0500")
                    
                elseif item.curruserid ~= "" then
                    GUI:Text_setString(ui.Text_status, "竞价中")
                    GUI:Text_setTextColor(ui.Text_status, "#ffffff")
                else
                    GUI:setVisible(ui.Text_status, false)
                end
            else
                GUI:Button_setTitleColor(ui.Button_bid, "#A6A6A6")
                GUI:setVisible(ui.Text_status, false)
            end
        end

        -- 一口价
        local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", item)
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
    local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", item)
    if bidAble then
        GUI:removeAllChildren(ui.Node_bid_price)
        AuctionWorld.CreatePriceCell(ui.Node_bid_price, {id = item.type, count = item.price})

        GUI:addOnClickEvent(ui.Button_bid,function()
            local status = SL:GetMetaValue("AUCTION_ITEM_STATE", item)
            if status == 2 then
                if item.curruserid == mainPlayerID then
                    SL:ShowSystemTips("无法连续出价")
                else
                    SL:OpenAuctionBidUI(item)
                end
            else
                SL:ShowSystemTips("无法竞价")
            end
        end)
    else
        GUI:setVisible(ui.Button_bid, false)
        GUI:setPositionY(ui.Text_status, math.floor(AuctionWorld._itemSize.height / 2))
        GUI:Text_setTextColor(ui.Text_status, "#FFFFFF")
        GUI:Text_setString(ui.Text_status, "无法竞价")
    end

    -- 一口价
    local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", item)
    if buyAble then
        GUI:removeAllChildren(ui.Node_price)
        AuctionWorld.CreatePriceCell(ui.Node_price, {id = item.type, count = item.lastprice})

        GUI:addOnClickEvent(ui.Button_buy, function()
            local status = SL:GetMetaValue("AUCTION_ITEM_STATE", item)
            if status == 2 then
                SL:OpenAuctionBuyUI(item)
            else
                SL:ShowSystemTips("无法竞价")
            end
        end)
    end
    GUI:setVisible(ui.Button_buy, buyAble)
    GUI:setVisible(ui.Text_unable_buy, not buyAble)

    return cell
end

-- 价格 cell
function AuctionWorld.CreatePriceCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_price_cell" or "auction/auction_price_cell")

    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, {index = data.id, look = true, mouseCheckTimes = 8})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)

end