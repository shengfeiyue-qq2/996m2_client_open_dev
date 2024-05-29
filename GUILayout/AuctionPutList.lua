AuctionPutList = {}

AuctionPutList.ItemListCol = 2      -- 物品列表 列数
AuctionPutList.BagListCol  = 4      -- 背包物品列表 列数

function AuctionPutList.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list" or "auction/auction_put_list")

    AuctionPutList._ui = GUI:ui_delegate(parent)

    AuctionPutList._showBagItems = SL:GetMetaValue("AUCTION_MY_SHOW_LIST")

    AuctionPutList.InitPutList()
    SL:RequestAuctionPutList(1)

    AuctionPutList.InitBagList()
    AuctionPutList.UpdateShelfCount()

end

-- 寄售货架
function AuctionPutList.InitPutList()
    AuctionPutList._qCells = {}
    AuctionPutList._items = {}
    
    local itemSize = AuctionPutList.GetPutCellSize()
    local wid = itemSize.width
    local hei = itemSize.height
    local maxHeight = GUI:getContentSize(AuctionPutList._ui.ScrollView_items).height
    local limitCount = SL:GetMetaValue("AUCTION_DEFAULT_SHELF")

    local col = AuctionPutList.ItemListCol
    local innerWid = wid * col
    local innerHei = math.max(hei * math.ceil(limitCount / col), maxHeight)
    GUI:ScrollView_setInnerContainerSize(AuctionPutList._ui.ScrollView_items, innerWid, innerHei)

    local function checkActive(qCell)
        return GUIFunction:CheckAuctionCellShowInView(qCell, AuctionPutList._ui.ScrollView_items)
    end

    for i = 1, limitCount do
        local function createCell(parent)
            local cell = AuctionPutList.CreatePutCell(parent, i) 
            return cell 
        end
        local cell = GUI:QuickCell_Create(AuctionPutList._ui.ScrollView_items, "item_" .. i, 0, 0, wid, hei, createCell, checkActive, {tick_interval = 0.05})
        local row = math.ceil(i / col)
        local posX = i % col == 0 and wid or 0
        local posY = innerHei - hei * row
        GUI:setPosition(cell, posX, posY)
        table.insert(AuctionPutList._qCells, cell)
    end

end

function AuctionPutList.GetPutCellSize()
    local node = GUI:Node_Create(-1, "node", 0, 0)
    local cell = AuctionPutList.CreatePutCell(node, 1)
    local cellSize = GUI:getContentSize(cell)
    GUI:removeFromParent(cell)
    return cellSize
end

function AuctionPutList.CreatePutCell(parent, index)
    local item = AuctionPutList._items[index]
    if not item then
        AuctionPutList.CreateEmptyCell(parent)

        local cell = GUI:getChildByName(parent, "Panel_1")
        -- 点击
        GUI:addOnClickEvent(cell, function()
            SL:ShowSystemTips("请在右侧选择上架道具")
        end)
        return cell
    else
        AuctionPutList.CreateItemCell(parent)
        local ui = GUI:ui_delegate(parent)
        local cell = GUI:getChildByName(parent, "Panel_1")
        
        local itemBgSize = GUI:getContentSize(ui.Image_item)
        local itemShow = GUI:ItemShow_Create(ui.Image_item, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
            index = item.Index,
            itemData = item,
            look = true
        })
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        
        -- 名字
        local color = (item.Color and item.Color > 0) and item.Color
        local colorHex = color and SL:GetHexColorByStyleId(color) or SL:GetMetaValue("ITEM_NAME_COLOR_VALUE", item.Index)
        GUI:Text_setString(ui.Text_name, item.Name)
        GUI:Text_setTextColor(ui.Text_name, colorHex)
        
        -- 状态
        local function callback()
            local status, remaining = SL:GetMetaValue("AUCTION_ITEM_STATE", item)
            local timeData = SL:SecondToHMS(remaining)
            local hour = timeData.h + 24 * timeData.d
            local timeStr  = string.format("%02d:%02d:%02d", hour, timeData.m, timeData.s)

            if status == 0 then
                GUI:Text_setString(ui.Text_status, "-")

            elseif status == 2 then
                GUI:Text_setString(ui.Text_status, string.format("竞拍中 %s", timeStr))
                GUI:Text_setTextColor(ui.Text_status, "#28ef01")

            elseif status == 3 then
                GUI:Text_setString(ui.Text_status, "超时")
                GUI:Text_setTextColor(ui.Text_status, "#ff0500")
            end
        end
        SL:schedule(ui.Text_status, callback, 1)
        callback()

        -- 竞拍价
        local bidAble = SL:GetMetaValue("AUCTION_CAN_BID", item)
        GUI:setVisible(ui.Node_money, bidAble)
        GUI:setVisible(ui.Text_price, bidAble)
        GUI:setVisible(ui.Text_unable_bid, not bidAble)
        if bidAble then
            local itemShow = GUI:ItemShow_Create(ui.Node_money, "money_item", 0, 0, item.type)
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
            GUI:setScale(itemShow, 0.5)

            local fixBidPrice = GUIFunction:FixAuctionPrice(item.price, true)
            GUI:Text_setString(ui.Text_price, fixBidPrice)
        end

        -- 一口价
        local buyAble = SL:GetMetaValue("AUCTION_CAN_BUY", item)
        GUI:setVisible(ui.Node_buy_money, buyAble)
        GUI:setVisible(ui.Text_buy_price, buyAble)
        GUI:setVisible(ui.Text_unable_buy, not buyAble)
        if buyAble then
            local itemShow = GUI:ItemShow_Create(ui.Node_buy_money, "money_item", 0, 0, item.type)
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
            GUI:setScale(itemShow, 0.5)

            local fixBuyPrice = GUIFunction:FixAuctionPrice(item.lastprice, true)
            GUI:Text_setString(ui.Text_buy_price, fixBuyPrice)
        end

        -- 点击
        GUI:addOnClickEvent(cell, function()
            local status = SL:GetMetaValue("AUCTION_ITEM_STATE", item)
            if status == 3 then
                SL:OpenAuctionTimeoutUI(item)
            else
                SL:OpenAuctionPutoutUI(item)
            end
        end)
        
        return cell
    end
end

function AuctionPutList.UpdateShelfCount()
    local count = SL:GetMetaValue("AUCTION_PUT_LIST_CNT")
    GUI:Text_setString(AuctionPutList._ui.Text_tile, string.format("寄售货架(%s/%s)", count, SL:GetMetaValue("AUCTION_DEFAULT_SHELF")))
end

-- 寄售列表刷新
function AuctionPutList.OnUpdatePutList(items)
    AuctionPutList._items = items
    for k, v in ipairs(AuctionPutList._qCells) do
        GUI:QuickCell_Exit(v)
        GUI:QuickCell_Refresh(v)
    end

    AuctionPutList.UpdateShelfCount()
end

-- 上架道具
function AuctionPutList.OnPutInItem(item)
    if not item then
        return
    end
    
    -- 修改
    local exist = false
    for k, v in ipairs(AuctionPutList._items) do
        if v.MakeIndex == item.MakeIndex then
            AuctionPutList._items[k] = item
            local qCell = AuctionPutList._qCells[k]
            if qCell then
                GUI:QuickCell_Exit(qCell)
                GUI:QuickCell_Refresh(qCell)
            end
            exist = true
            break
        end
    end

    -- 新增
    if false == exist then
        local limitCount = SL:GetMetaValue("AUCTION_DEFAULT_SHELF")
        if #AuctionPutList._items >= limitCount then
            return nil
        end
        table.insert(AuctionPutList._items, item)
        local index = #AuctionPutList._items
        local qCell = AuctionPutList._qCells[index]
        if qCell then
            GUI:QuickCell_Exit(qCell)
            GUI:QuickCell_Refresh(qCell)
        end
    end

    AuctionPutList.UpdateShelfCount()
    AuctionPutList.UpdateShowBagList()
end

-- 下架道具
function AuctionPutList.OnPutOutItem(item)
    if not item then
        return
    end

    for k, v in ipairs(AuctionPutList._items) do
        if v.MakeIndex == item.makeindex then
            table.remove(AuctionPutList._items, k)
            for i = k, #AuctionPutList._qCells do
                local qCell = AuctionPutList._qCells[i]
                if qCell then
                    GUI:QuickCell_Exit(qCell)
                    GUI:QuickCell_Refresh(qCell)
                end
            end
            break
        end
    end

    AuctionPutList.UpdateShelfCount()
    AuctionPutList.UpdateShowBagList()
end

-- 可选寄售道具列表
function AuctionPutList.InitBagList()
    AuctionPutList._bagQCells = {}

    local totalNum = SL:GetMetaValue("MAX_BAG") + SL:GetMetaValue("QUICK_USE_NUM")
    local col = AuctionPutList.BagListCol
    local row = math.ceil(totalNum / col)
    local itemSize = AuctionPutList.GetBagCellSize()
    local wid = itemSize.width
    local hei = itemSize.height

    local innerWid = GUI:getContentSize(AuctionPutList._ui.ScrollView_bag).width
    local innerHei = hei * row
    GUI:ScrollView_setInnerContainerSize(AuctionPutList._ui.ScrollView_bag, innerWid, innerHei)

    local function checkActive(qCell)
        return GUIFunction:CheckAuctionCellShowInView(qCell, AuctionPutList._ui.ScrollView_bag)
    end

    for i = 1, totalNum do
        local function createCell(parent)
            local cell = AuctionPutList.CreateBagCell(parent, i) 
            return cell 
        end
        local cell = GUI:QuickCell_Create(AuctionPutList._ui.ScrollView_bag, "item_" .. i, 0, 0, wid, hei, createCell, checkActive)
        local iRow = math.ceil(i / col)
        local iCol = (i - 1) % col
        local posX = wid * iCol
        local posY = innerHei - hei * iRow
        GUI:setPosition(cell, posX, posY)
        table.insert(AuctionPutList._bagQCells, cell)
    end
    AuctionPutList._init = false
end

function AuctionPutList.GetBagCellSize()
    local node = GUI:Node_Create(-1, "node", 0, 0)
    local cell = AuctionPutList.CreateBagCell(node, 1)
    local cellSize = GUI:getContentSize(cell)
    GUI:removeFromParent(cell)
    return cellSize
end

-- 更新寄售道具选择列表
function AuctionPutList.UpdateShowBagList()
    AuctionPutList._showBagItems = SL:GetMetaValue("AUCTION_MY_SHOW_LIST")
    for k, v in ipairs(AuctionPutList._bagQCells) do
        GUI:QuickCell_Exit(v)
        GUI:QuickCell_Refresh(v)
    end
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
function AuctionPutList.CreateBagCell(parent, i)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "auction_win32/auction_put_list_bag_cell" or "auction/auction_put_list_bag_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_bg")
    local itemData = AuctionPutList._showBagItems[i]
    if itemData then
        local itemBgSize = GUI:getContentSize(ui.Image_bg)
        local item = GUI:ItemShow_Create(ui.Image_bg, "bag_item", itemBgSize.width / 2, itemBgSize.height / 2, {
            index = itemData.Index,
            itemData = itemData,
            look = true
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)

        GUI:ItemShow_addPressEvent(item, function()
            local data = SL:GetMetaValue("ITEM_DATA_BY_MAKEINDEX", itemData.MakeIndex)
            if not data then
                data = SL:GetMetaValue("QUICKUSE_DATA_BY_MAKEINDEX", itemData.MakeIndex)
            end
            if not data then
                SL:ShowSystemTips("道具不存在")
                return
            end
            SL:OpenItemTips({itemData = data})
        end)
        GUI:ItemShow_addReplaceClickEvent(item, function()
            local data = SL:GetMetaValue("ITEM_DATA_BY_MAKEINDEX", itemData.MakeIndex)
            if not data then
                data = SL:GetMetaValue("QUICKUSE_DATA_BY_MAKEINDEX", itemData.MakeIndex)
            end
            if not data then
                SL:ShowSystemTips("道具不存在")
                return
            end
            SL:OpenAuctionPutinUI(data)
        end)
    end
    return cell
end