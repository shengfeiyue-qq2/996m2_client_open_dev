ExchangePutList             = {}

ExchangePutList.ItemListCol = 2 -- 物品列表 列数
ExchangePutList.BagListCol  = 4 -- 背包物品列表 列数

function ExchangePutList.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_put_list" or "exchange/exchange_put_list")

    ExchangePutList._ui = GUI:ui_delegate(parent)

    ExchangePutList._showBagItems = SL:GetValue("EXCHANGE_MY_SHOW_LIST")

    ExchangePutList.InitPutList()
    SL:RequestExchangeList({type = 1})

    ExchangePutList.InitBagList()
    ExchangePutList.UpdateShelfCount()

    ExchangePutList:RegisterEvent()

    SL:AttachTXTSUI({
        root  = ExchangePutList._ui.Panel_1,
        index = SLDefine.SUIComponentTable.ExchangePulist
    })
end

-- 寄售货架
function ExchangePutList.InitPutList()
    ExchangePutList._qCells = {}
    ExchangePutList._items = {}

    local itemSize = ExchangePutList.GetPutCellSize()
    local wid = itemSize.width
    local hei = itemSize.height
    local maxHeight = GUI:getContentSize(ExchangePutList._ui.ScrollView_items).height
    local limitCount = SL:GetValue("EXCHANGE_DEFAULT_SHELF")

    local col = ExchangePutList.ItemListCol
    local innerWid = wid * col
    local innerHei = math.max(hei * math.ceil(limitCount / col), maxHeight)
    GUI:ScrollView_setInnerContainerSize(ExchangePutList._ui.ScrollView_items, innerWid, innerHei)

    local function checkActive(qCell)
        return GUIFunction:CheckAuctionCellShowInView(qCell, ExchangePutList._ui.ScrollView_items)
    end

    for i = 1, limitCount do
        local function createCell(parent)
            local cell = ExchangePutList.CreatePutCell(parent, i)
            return cell
        end
        local cell = GUI:QuickCell_Create(ExchangePutList._ui.ScrollView_items, "item_" .. i, 0, 0, wid, hei, createCell,
            checkActive, { tick_interval = 0.05 })
        local row = math.ceil(i / col)
        local posX = i % col == 0 and wid or 0
        local posY = innerHei - hei * row
        GUI:setPosition(cell, posX, posY)
        table.insert(ExchangePutList._qCells, cell)
    end
end

function ExchangePutList.GetPutCellSize()
    local node = GUI:Node_Create(-1, "node", 0, 0)
    local cell = ExchangePutList.CreatePutCell(node, 1)
    local cellSize = GUI:getContentSize(cell)
    GUI:removeFromParent(cell)
    return cellSize
end

function ExchangePutList.CreatePutCell(parent, index)
    local item = ExchangePutList._items[index]
    if not item then
        ExchangePutList.CreateEmptyCell(parent)

        local cell = GUI:getChildByName(parent, "Panel_1")
        -- 点击
        GUI:addOnClickEvent(cell, function()
            SL:ShowSystemTips("请在右侧选择上架道具")
        end)
        return cell
    else
        ExchangePutList.CreateItemCell(parent)
        local ui = GUI:ui_delegate(parent)
        local cell = GUI:getChildByName(parent, "Panel_1")

        local itemBgSize = GUI:getContentSize(ui.Image_item)
        local data = BagData.GetItemDataByMakeIndex(item.guid)
        if not data then
            data = QuickUseData.GetQuickUseDataByMakeIndex(item.guid)
        end
        local itemShow = GUI:ItemShow_Create(ui.Image_item, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
            -- index = item.item.Index,
            index = item.itemid,
            itemData = data,
            look = true
        })
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        -- 名字
        local color = (item.Color and item.Color > 0) and item.Color
        local colorHex = color and SL:GetHexColorByStyleId(color) or
        SL:GetValue("ITEM_NAME_COLOR_VALUE", item.itemid)
        local itemName =  SL:GetValue("ITEM_NAME", item.itemid)
        GUI:Text_setString(ui.Text_name, itemName)
        GUI:Text_setTextColor(ui.Text_name, colorHex)
        GUI:Text_setString(ui.Text_itemnum, item.remainqty)
        GUI:Text_setString(ui.Text_buy_price, item.amount)
        local itemShow = GUI:ItemShow_Create(ui.Node_buy_money, "money_item", 0, 0, item.currency)
        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
        GUI:setScale(itemShow, 0.5)

        -- 状态
        local function callback()
            local status, remaining = SL:GetValue("EXCHANGE_ITEM_STATE", item)
            local timeData          = SL:SecondToHMS(remaining)
            local hour              = timeData.h + 24 * timeData.d
            local timeStr           = string.format("%02d:%02d:%02d", hour, timeData.m, timeData.s)

            if status == 0 then
                GUI:setVisible(ui.Text_status, false)
            elseif status == 2 then
                GUI:Text_setString(ui.Text_status, string.format("出售中 %s", timeStr))
                GUI:Text_setTextColor(ui.Text_status, "#28ef01")
            elseif status == 3 then
                GUI:Text_setString(ui.Text_status, "超时")
                GUI:Text_setTextColor(ui.Text_status, "#ff0500")
            end
        end
        SL:schedule(ui.Text_status, callback, 0.5)
        callback()

        -- 点击
        GUI:addOnClickEvent(cell, function()
            local status = SL:GetValue("EXCHANGE_ITEM_STATE", item)
                UIOperator:OpenExchangePutOutUI(item);
        end)

        return cell
    end
end

function ExchangePutList.UpdateShelfCount()
    local count = #ExchangePutList._items
    GUI:Text_setString(ExchangePutList._ui.Text_tile,
        string.format("寄售货架(%s/%s)", count, SL:GetValue("EXCHANGE_DEFAULT_SHELF")))
end

-- 寄售列表刷新
function ExchangePutList.OnUpdatePutList(items)
    ExchangePutList._items = items
    for k, v in ipairs(ExchangePutList._qCells) do
        GUI:QuickCell_Exit(v)
        GUI:QuickCell_Refresh(v)
    end

    ExchangePutList.UpdateShelfCount()
end

-- 上架道具
function ExchangePutList.OnPutInItem(item)
    if not item then
        return
    end
    local exist = false
    -- 修改
    for k, v in ipairs(ExchangePutList._items) do
        if v.guid == item.guid then
            ExchangePutList._items[k] = item
            local qCell = ExchangePutList._qCells[k]
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
        local limitCount = SL:GetValue("EXCHANGE_DEFAULT_SHELF")
        if #ExchangePutList._items >= limitCount then
            return nil
        end
        for k, v in ipairs(item) do
            table.insert(ExchangePutList._items, v)
            local index = k
            local qCell = ExchangePutList._qCells[index]
            if qCell then
                GUI:QuickCell_Exit(qCell)
                GUI:QuickCell_Refresh(qCell)
            end
        end

    end

    ExchangePutList.UpdateShelfCount()
    ExchangePutList.UpdateShowBagList()
end

-- 下架道具
function ExchangePutList.OnPutOutItem(item)
    if not item then
        return
    end

    for k, v in ipairs(ExchangePutList._items) do
        if v.guid == item.guid then
            table.remove(ExchangePutList._items, k)
            for i = k, #ExchangePutList._qCells do
                local qCell = ExchangePutList._qCells[i]
                if qCell then
                    GUI:QuickCell_Exit(qCell)
                    GUI:QuickCell_Refresh(qCell)
                end
            end
            break
        end
    end
    ExchangePutList.UpdateShelfCount()
    ExchangePutList.UpdateShowBagList()
end

-- 可选寄售道具列表
function ExchangePutList.InitBagList()
    ExchangePutList._bagQCells = {}

    local totalNum = BagData.GetMaxBag() + QuickUseData.GetQuickUseSize()
    local col = ExchangePutList.BagListCol
    local row = math.ceil(totalNum / col)
    local itemSize = ExchangePutList.GetBagCellSize()
    local wid = itemSize.width
    local hei = itemSize.height

    local innerWid = GUI:getContentSize(ExchangePutList._ui.ScrollView_bag).width
    local innerHei = hei * row
    GUI:ScrollView_setInnerContainerSize(ExchangePutList._ui.ScrollView_bag, innerWid, innerHei)

    local function checkActive(qCell)
        return GUIFunction:CheckAuctionCellShowInView(qCell, ExchangePutList._ui.ScrollView_bag)
    end
    for i = 1, totalNum do
        local function createCell(parent)
            local cell = ExchangePutList.CreateBagCell(parent, i)
            return cell
        end
        local cell = GUI:QuickCell_Create(ExchangePutList._ui.ScrollView_bag, "item_" .. i, 0, 0, wid, hei, createCell,
            checkActive)
        local iRow = math.ceil(i / col)
        local iCol = (i - 1) % col
        local posX = wid * iCol
        local posY = innerHei - hei * iRow
        GUI:setPosition(cell, posX, posY)
        table.insert(ExchangePutList._bagQCells, cell)
    end
    ExchangePutList._init = false
end

function ExchangePutList.GetBagCellSize()
    local node = GUI:Node_Create(-1, "node", 0, 0)
    local cell = ExchangePutList.CreateBagCell(node, 1)
    local cellSize = GUI:getContentSize(cell)
    GUI:removeFromParent(cell)
    return cellSize
end

-- 更新寄售道具选择列表
function ExchangePutList.UpdateShowBagList()
    ExchangePutList._showBagItems = SL:GetValue("EXCHANGE_MY_SHOW_LIST")
    for k, v in ipairs(ExchangePutList._bagQCells) do
        GUI:QuickCell_Exit(v)
        GUI:QuickCell_Refresh(v)
    end
end

-- 道具列表 cell
function ExchangePutList.CreateItemCell(parent)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_put_list_cell" or "exchange/exchange_put_list_cell")
end

-- 空列表 cell
function ExchangePutList.CreateEmptyCell(parent)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_put_list_empty_cell" or
        "exchange/exchange_put_list_empty_cell")
end

-- 背包物品 cell
function ExchangePutList.CreateBagCell(parent, i)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_put_list_bag_cell" or
        "exchange/exchange_put_list_bag_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_bg")
    local itemData = ExchangePutList._showBagItems[i]
    if itemData then
        local itemBgSize = GUI:getContentSize(ui.Image_bg)
        local item = GUI:ItemShow_Create(ui.Image_bg, "bag_item", itemBgSize.width / 2, itemBgSize.height / 2, {
            index = itemData.Index,
            itemData = itemData,
            look = true
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)

        GUI:ItemShow_addPressEvent(item, function()
            local data = BagData.GetItemDataByMakeIndex(itemData.MakeIndex)
            if not data then
                data = QuickUseData.GetQuickUseDataByMakeIndex(itemData.MakeIndex)
            end
            if not data then
                SL:ShowSystemTips("道具不存在")
                return
            end
            UIOperator:OpenItemTips({ itemData = data })
        end)
        GUI:ItemShow_addReplaceClickEvent(item, function()
            local data = BagData.GetItemDataByMakeIndex(itemData.MakeIndex)
            if not data then
                data = QuickUseData.GetQuickUseDataByMakeIndex(itemData.MakeIndex)
            end
            if not data then
                SL:ShowSystemTips("道具不存在")
                return
            end
            SL:RequestExchangePutInPrice(data.Index)
            UIOperator:OpenExchangePutInUI(data)
        end)
    end
    return cell
end

function ExchangePutList.OnExchangePutinResp(data)
    local item = data.items
    ExchangePutList.OnPutInItem(item)
end

function ExchangePutList.OnExchangePutListResp(data)
    local item = data.items
    if not item then
        return
    end
    local exist = false
    for k, v in ipairs(ExchangePutList._items) do
        if v.guid == item.guid then
            ExchangePutList._items[k] = item
            local qCell = ExchangePutList._qCells[k]
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
        local limitCount = SL:GetValue("EXCHANGE_DEFAULT_SHELF")
        if #ExchangePutList._items >= limitCount then
            return nil
        end
        table.insert(ExchangePutList._items, item)
        local index = #ExchangePutList._items
        local qCell = ExchangePutList._qCells[index]
        if qCell then
            GUI:QuickCell_Exit(qCell)
            GUI:QuickCell_Refresh(qCell)
        end
    end

    ExchangePutList.UpdateShelfCount()
    ExchangePutList.UpdateShowBagList()
end

function ExchangePutList.OnExchangePutoutResp(data)
    if not data then
        return
    end
    ExchangePutList.OnPutOutItem(data.items)
end

-- 界面关闭回调
function ExchangePutList.OnClose()
    ExchangePutList.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.ExchangePulist
    })
end

function ExchangePutList.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ExchangePutList", ExchangeMain.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangePutList", ExchangePutList.OnExchangePutinResp)     --上架道具
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_LIST, "ExchangePutList", ExchangePutList.OnExchangePutListResp)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT, "ExchangePutList", ExchangePutList.OnExchangePutoutResp)
end

function ExchangePutList.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ExchangePutList")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangePutList")   --上架道具
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_LIST, "ExchangePutList")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT, "ExchangePutList")
end

ExchangePutList.main()
