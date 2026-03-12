ExchangeRecord = {}

ExchangeRecord._maxFilterCells           = 8                                 -- 筛选弹出列表最多显示条数
ExchangeRecord._group1CellColorSel       = "#f8e6c6"                         -- 左侧页签选中时按钮文字颜色
ExchangeRecord._group1CellColorNormal    = "#6c6861"                         -- 左侧页签未选中时按钮文字颜色
ExchangeRecord._priceArrowUpPath         = "res/public/btn_szjm_01_3.png"    -- 筛选价格向上箭头图片
ExchangeRecord._priceArrowDownPath       = "res/public/btn_szjm_01_4.png"    -- 筛选价格向上箭头图片
ExchangeRecord._type                     = 2                                 -- 我的记录

function ExchangeRecord.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_record" or "exchange/exchange_record")
    
    ExchangeRecord._ui = GUI:ui_delegate(parent)

    ExchangeRecord._filter1Index = 1
    ExchangeRecord._filter1State = true
    ExchangeRecord._filter1Cells = {}
    ExchangeRecord._filterID     = 1     -- 分类选择ID
    ExchangeRecord._sortType     = 0     -- 排序类型
    ExchangeRecord._currencyF    = ""    -- 货币筛选
    ExchangeRecord._curResPage   = 0     -- 页码
    ExchangeRecord._curPagecount = 10     -- 条数
    ExchangeRecord._complete     = false -- 数据加载完成

    ExchangeRecord._currencies   = SL:GetValue("EXCHANGE_CURRENCIES")
    table.insert(ExchangeRecord._currencies, 1, {id = 0, name = "全部"})


    -- 单个列表cell 尺寸
    ExchangeRecord._itemSize = SL:GetValue("IS_PC_OPER_MODE") and {width = 505, height = 70} or {width = 640, height = 80}
    ExchangeRecord._items = {}
    ExchangeRecord._qCells = {}

    local status = true
    local function listViewEvent(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeRecord._ui.ListView_items)
            local itemHei = ExchangeRecord._itemSize and ExchangeRecord._itemSize.height or 80
            local count = GUI:ListView_getItemCount(ExchangeRecord._ui.ListView_items)
            local realHei = count * itemHei + (count - 1) * GUI:ListView_getItemsMargin(ExchangeRecord._ui.ListView_items)
            local contentSize = GUI:getContentSize(ExchangeRecord._ui.ListView_items)
            if innerPos.y == 0 then
                if false == ExchangeRecord._complete and status then
                    status = false
                    SL:scheduleOnce(ExchangeRecord._ui.ListView_items, function()
                        status = true
                    end, 0.5)

                    if realHei < contentSize.height then
                        return
                    end
                    SL:scheduleOnce(ExchangeRecord._ui.ListView_items, function()
                        ExchangeRecord.PullItemList()
                    end, 0.01)
                end
            end
        end
    end
    GUI:ListView_addOnScrollEvent(ExchangeRecord._ui.ListView_items, listViewEvent)
    GUI:ListView_addMouseScrollPercent(ExchangeRecord._ui.ListView_items)

    ExchangeRecord.InitLeftGroup()
    ExchangeRecord.InitFilter()
    ExchangeRecord.InitEvent()
end

function ExchangeRecord.InitLeftGroup()
   

    ExchangeRecord.OnClearItemList()
    ExchangeRecord.PullItemList()

end

function ExchangeRecord.InitFilter()
    ExchangeRecord._upSingle = true
    GUI:delayTouchEnabled(ExchangeRecord._ui.Image_sort_s, 0.5)
    GUI:addOnClickEvent(ExchangeRecord._ui.Image_sort_s, function()
        ExchangeRecord._upSingle = not ExchangeRecord._upSingle
        local path = ExchangeRecord._upSingle and ExchangeRecord._priceArrowUpPath or ExchangeRecord._priceArrowDownPath
        GUI:Image_loadTexture(ExchangeRecord._ui.Image_sort_s, path)
        ExchangeRecord._sortType = ExchangeRecord._upSingle and 3 or 4
        ExchangeRecord.OnClearItemList()
        ExchangeRecord.PullItemList()
    end)

    ExchangeRecord.HideFilterItems()
    GUI:addOnClickEvent(ExchangeRecord._ui.Panel_hide_filter, function ()
        ExchangeRecord.HideFilterItems()
    end)
    GUI:addOnClickEvent(ExchangeRecord._ui.Image_filter_c, function ()
        ExchangeRecord.ShowFilterItems()
    end)
end

function ExchangeRecord.HideFilterItems()
    GUI:setVisible(ExchangeRecord._ui.Image_filter_bg, false)
    GUI:setVisible(ExchangeRecord._ui.Panel_hide_filter, false)
    GUI:ListView_removeAllItems(ExchangeRecord._ui.ListView_filter_c)

    GUI:setFlippedY(ExchangeRecord._ui.Image_filter_c, false)
end

function ExchangeRecord.ShowFilterItems()
    local items = ExchangeRecord._currencies
    local ListView_filter = ExchangeRecord._ui.ListView_filter_c
    GUI:setVisible(ExchangeRecord._ui.Image_filter_bg, true)
    GUI:setVisible(ExchangeRecord._ui.Panel_hide_filter, true)
    GUI:ListView_removeAllItems(ListView_filter)

    GUI:setFlippedY(ExchangeRecord._ui.Image_filter_c, true)

    local itemWid = GUI:getContentSize(ListView_filter).width
    local itemHei = SL:GetValue("IS_PC_OPER_MODE") and 24 or 30
    local cells = {}
    for i, v in ipairs(items) do
        local ui, layout = ExchangeRecord.CreateFilterCell(ListView_filter, i, itemWid, itemHei)
        table.insert(cells, ui)
        local name = v.name or SL:GetValue("ITEM_NAME", v.id)
        GUI:Text_setString(ui.Text_1, name)
        GUI:addOnClickEvent(layout, function()
            if v.id == 0 then
                local value = ""
                for k, data in ipairs(items) do
                    if data.id ~= 0 then
                        value = string.format("%s%s%s", value, data.id, k ~= #items and "," or "")
                    end
                end
                ExchangeRecord._currencyF = value
            else
                ExchangeRecord._currencyF = tostring(v.id)
            end
            GUI:Text_setString(ExchangeRecord._ui.Text_coin_type, name)
            ExchangeRecord.HideFilterItems()

            ExchangeRecord.OnClearItemList()
            ExchangeRecord.PullItemList()
        end)
    end

    local height  = math.min(#cells, ExchangeRecord._maxFilterCells) * itemHei
    GUI:setContentSize(ExchangeRecord._ui.Image_filter_bg, itemWid + 5, height + 5)
    GUI:setContentSize(ListView_filter, itemWid, height)
end

function ExchangeRecord.OnClearItemList()
    ExchangeRecord._curResPage = 0
    ExchangeRecord._items = {}
    ExchangeRecord._qCells = {}
    GUI:ListView_removeAllItems(ExchangeRecord._ui.ListView_items)
    GUI:ListView_jumpToTop(ExchangeRecord._ui.ListView_items)
end

function ExchangeRecord.PullItemList(searchItem)
    local config = SL:GetValue("EXCHANGE_MENU_CONFIG_BY_ID", ExchangeRecord._filterID)
    local stdModeStr = config.stdmode
    local currencyStr = nil
    if ExchangeRecord._currencyF and string.len(ExchangeRecord._currencyF) > 0 then
        currencyStr = ExchangeRecord._currencyF
    end
    local pullData = {
        type        = ExchangeRecord._type,
        stdmode     = stdModeStr,
        currency    = currencyStr,
        sort        = ExchangeRecord._sortType,
        pageIndex   = ExchangeRecord._curResPage,
        pagecount   = ExchangeRecord._curPagecount,
        itemids     = searchItem,
    }
    UIOperator:OpenLoadingBarUI(3)
    SL:RequestExchangeList(pullData)
end

function ExchangeRecord.RespItemList(data)
    if data.type ~= ExchangeRecord._type then  -- 我的记录
        return
    end
    UIOperator:CloseLoadingBarUI()
    ExchangeRecord._curResPage = data.pageIndex + 1
    local items = data.items
    if items and next(items) then
        local lastIndex = #GUI:ListView_getItems(ExchangeRecord._ui.ListView_items) - 1
        while next(items) do
            local item = table.remove(items, 1)
            local num = tonumber(item.totalqty) - tonumber(item.remainqty)
            local shouldCreateCell = false
            if item.buyqty > 0 then
                shouldCreateCell = true
            else
                shouldCreateCell = (num > 0)  -- 出售才记录的逻辑保留
            end
            if shouldCreateCell then
                local function createCell(parent)
                    local cell = ExchangeRecord.CreateItemCell(parent, item) 
                    return cell 
                end
                local wid = ExchangeRecord._itemSize.width
                local hei = ExchangeRecord._itemSize.height
                local quickCell = GUI:QuickCell_Create(ExchangeRecord._ui.ListView_items, "item_" .. item.guid, 0, 0, wid, hei, createCell)
                ExchangeRecord._qCells[item.guid] = quickCell
                ExchangeRecord._items[item.guid] = item
            end
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(ExchangeRecord._ui.ListView_items, lastIndex)
        end
    end
end

function ExchangeRecord.OnLoadComplete(data)
    if data.type ~= ExchangeRecord._type then  -- 我的记录
        return
    end
    ExchangeRecord._complete = true
end

function ExchangeRecord.OnSearchItem(data)
    if data and string.len(data) ~= 0 then
        ExchangeRecord._searchItem = data
    else
        ExchangeRecord._searchItem = nil
    end
    ExchangeRecord.OnClearItemList()
    ExchangeRecord.PullItemList(ExchangeRecord._searchItem)
end

function ExchangeRecord.OnExchangeItemAdd(data)
    local item = data

    local mainPlayerID = SL:GetValue("USER_ID")
    local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeRecord._ui.ListView_items)

    local function createCell(parent)
        local cell = ExchangeRecord.CreateItemCell(parent, item) 
        return cell 
    end
    local quickCell = GUI:QuickCell_Create(ExchangeRecord._ui.ListView_items, "item_" .. item.guid, 0, 0, ExchangeRecord._itemSize.width, ExchangeRecord._itemSize.height, createCell)
    ExchangeRecord._qCells[item.guid] = quickCell
    ExchangeRecord._items[item.guid] = item
    
    GUI:ListView_doLayout(ExchangeRecord._ui.ListView_items)
    innerPos.y = innerPos.y + ExchangeRecord._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(ExchangeRecord._ui.ListView_items, innerPos)
end

function ExchangeRecord.OnExchangeItemDel(item)
    if not item or not item.guid then
        return
    end

    if nil == ExchangeRecord._qCells[item.guid] then
        return
    end

    local cell = ExchangeRecord._qCells[item.guid]
    local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeRecord._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(ExchangeRecord._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(ExchangeRecord._ui.ListView_items, index)
    GUI:ListView_doLayout(ExchangeRecord._ui.ListView_items)
    innerPos.y = innerPos.y + ExchangeRecord._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(ExchangeRecord._ui.ListView_items, innerPos)

    ExchangeRecord._qCells[item.guid] = nil
    ExchangeRecord._items[item.guid] = nil
end

function ExchangeRecord.OnExchangeItemChange(item)
    if not item or not item.guid then
        return
    end

    if nil == ExchangeRecord._qCells[item.guid] then
        return
    end

    ExchangeRecord._items[item.guid] = item
    GUI:QuickCell_Exit(ExchangeRecord._qCells[item.guid])
    GUI:QuickCell_Refresh(ExchangeRecord._qCells[item.guid])
end

function ExchangeRecord.OnExchangeUpdate(data)
    -- type 1：新增 2: 删除 3：刷新
    local type = data.type
    if type == 1 then
        ExchangeRecord.OnExchangeItemAdd(data.item)
    elseif type == 2 then
        ExchangeRecord.OnExchangeItemDel(data.item)
    elseif type == 3 then
        if not data.item or not data.item.guid then
            return
        end
        if nil == ExchangeRecord._qCells[data.item.guid] then
            ExchangeRecord.OnExchangeItemAdd(data.item)
        else
            ExchangeRecord.OnExchangeItemChange(data.item)
        end
    end
end

function ExchangeRecord.InitEvent()
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangeRecord", ExchangeRecord.RespItemList)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_COMPLETE, "ExchangeRecord", ExchangeRecord.OnLoadComplete)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, "ExchangeRecord", ExchangeRecord.OnSearchItem)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, "ExchangeRecord", ExchangeRecord.OnExchangeUpdate)
end

function ExchangeRecord.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangeRecord")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_COMPLETE, "ExchangeRecord")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, "ExchangeRecord")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, "ExchangeRecord")
end


-- 筛选 cell
function ExchangeRecord.CreateFilterCell(parent, i, itemWid, itemHei)
    local layout = GUI:Layout_Create(parent, "Panel_" .. i, 0, 0, itemWid, itemHei)
    GUI:setTouchEnabled(layout, true)
    local text = GUI:Text_Create(layout, "Text_1", itemWid / 2, itemHei / 2, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", "")
    GUI:setAnchorPoint(text, 0.5, 0.5)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 列表cell
function ExchangeRecord.CreateItemCell(parent, item)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_record_cell" or "exchange/exchange_record_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_cell")
    
    local mainPlayerID  = SL:GetValue("USER_ID")
    item                = ExchangeRecord._items[item.guid]

    local itemBgSize = GUI:getContentSize(ui.Image_bg)
    local itemShow = GUI:ItemShow_Create(ui.Image_bg, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
        index = item.itemid,
        look = true,
        mouseCheckTimes = 8
    })
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    -- 名字
    local colorHex = SL:GetValue("ITEM_NAME_COLOR_VALUE", item.itemid)
    local itemName = SL:GetValue("ITEM_NAME", item.itemid)
    GUI:Text_setString(ui.Text_name, "")
    local fontSize = GUI:Text_getFontSize(ui.Text_name)
    local scrollText = GUI:ScrollText_Create(ui.Text_name, "scrollText", 0, 0, SL:GetValue("IS_PC_OPER_MODE") and 100 or 105, fontSize, colorHex, itemName)
    GUI:ScrollText_setHorizontalAlignment(scrollText, 1)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0, 0.5)
    local num = item.totalqty - item.remainqty

    --数量
    GUI:Text_setString(ui.Text_p_num, tonumber(item.buyqty) == 0 and num or item.buyqty)
    -- 货币类型
    local coinName = SL:GetValue("ITEM_NAME", item.currency)
    GUI:Text_setString(ui.Text_coin, coinName)
    -- 总价
    GUI:Text_setString(ui.Text_total, item.amount)
    local date = os.date("*t", item.starttime)
    local timeStr = string.format("%d-%02d-%02d", date.year, date.month, date.day)

    GUI:Text_setString(ui.Text_time, timeStr)

    GUI:Text_setString(ui.Text_state, tonumber(item.buyqty) == 0 and "出售" or "购买")


    return cell
end

-- 价格 cell
function ExchangeRecord.CreatePriceCell(parent, data)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_price_cell" or "exchange/exchange_price_cell")

    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, {index = data.id, look = true, mouseCheckTimes = 8})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)
end

ExchangeRecord.main()