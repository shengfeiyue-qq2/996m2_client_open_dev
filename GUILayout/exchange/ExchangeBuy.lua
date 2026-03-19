ExchangeBuy = {}

ExchangeBuy._maxFilterCells           = 8                                 -- 筛选弹出列表最多显示条数
ExchangeBuy._group1CellColorSel       = "#f8e6c6"                         -- 左侧页签选中时按钮文字颜色
ExchangeBuy._group1CellColorNormal    = "#6c6861"                         -- 左侧页签未选中时按钮文字颜色
ExchangeBuy._priceArrowUpPath         = "res/public/btn_szjm_01_3.png"    -- 筛选价格向上箭头图片
ExchangeBuy._priceArrowDownPath       = "res/public/btn_szjm_01_4.png"    -- 筛选价格向上箭头图片
ExchangeBuy._type                     = 0                                 -- 世界购买

function ExchangeBuy.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_buy" or "exchange/exchange_buy")
    ExchangeBuy._ui = GUI:ui_delegate(parent)

    ExchangeBuy._filter1Index = 1
    ExchangeBuy._filter1State = true
    ExchangeBuy._filter1Cells = {}
    ExchangeBuy._filterID     = 1     -- 分类选择ID
    ExchangeBuy._sortType     = 0     -- 排序类型
    ExchangeBuy._currencyF    = ""    -- 货币筛选
    ExchangeBuy._curResPage   = 0     -- 页码
    ExchangeBuy._complete     = false -- 数据加载完成

    ExchangeBuy._currencies   = SL:GetValue("EXCHANGE_CURRENCIES")
    table.insert(ExchangeBuy._currencies, 1, {id = 0, name = "全部"})


    -- 单个列表cell 尺寸
    ExchangeBuy._itemSize = SL:GetValue("IS_PC_OPER_MODE") and {width = 505, height = 70} or {width = 605, height = 80}
    ExchangeBuy._items = {}
    ExchangeBuy._qCells = {}

    local status = true
    local function listViewEvent(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeBuy._ui.ListView_items)
            local itemHei = ExchangeBuy._itemSize and ExchangeBuy._itemSize.height or 80
            local count = GUI:ListView_getItemCount(ExchangeBuy._ui.ListView_items)
            local realHei = count * itemHei + (count - 1) * GUI:ListView_getItemsMargin(ExchangeBuy._ui.ListView_items)
            local contentSize = GUI:getContentSize(ExchangeBuy._ui.ListView_items)
            if innerPos.y == 0 then
                if false == ExchangeBuy._complete and status then
                    status = false
                    SL:scheduleOnce(ExchangeBuy._ui.ListView_items, function()
                        status = true
                    end, 0.5)

                    if realHei < contentSize.height then
                        return
                    end
                    SL:scheduleOnce(ExchangeBuy._ui.ListView_items, function()
                        ExchangeBuy.PullItemList()
                    end, 0.01)
                end
            end
        end
    end
    GUI:ListView_addOnScrollEvent(ExchangeBuy._ui.ListView_items, listViewEvent)
    GUI:ListView_addMouseScrollPercent(ExchangeBuy._ui.ListView_items)

    ExchangeBuy.InitLeftGroup()
    ExchangeBuy.InitFilter()
    ExchangeBuy.InitEvent()
end

function ExchangeBuy.InitLeftGroup()
    local items = SL:GetValue("EXCHANGE_FILTER_LIST")
    for _, v in ipairs(items) do
        local ui, cell = ExchangeBuy.CreateFilterGroup1Cell()
        GUI:ListView_pushBackCustomItem(ExchangeBuy._ui.ListView_filter_1, cell)
        ExchangeBuy._filter1Cells[v[1].firstlevel] = ui
        GUI:Button_setTitleText(ui.Button_1, v[1].firstlevelname)
        GUI:addOnClickEvent(ui.Button_1, function()
            if ExchangeBuy._filter1Index ~= v[1].firstlevel then
                ExchangeBuy._filter1State = true
                
            elseif ExchangeBuy._filter1Index ~= 1 then
                ExchangeBuy._filter1State = not ExchangeBuy._filter1State
            end

            if ExchangeBuy._filter1State then
                if ExchangeBuy._filter1Index ~= v[1].firstlevel then
                    ExchangeBuy._filterID = v[1].id
                    ExchangeBuy.OnClearItemList()
                    ExchangeBuy.PullItemList()
                end
            end
            ExchangeBuy:UpdateFilter1()

            ExchangeBuy._filter1Index = v[1].firstlevel
        end)
    end

    ExchangeBuy.OnClearItemList()
    ExchangeBuy.PullItemList()
    ExchangeBuy.UpdateFilter1()
end

function ExchangeBuy.UpdateFilter1()
    -- 组1
    local config = SL:GetValue("EXCHANGE_MENU_CONFIG_BY_ID", ExchangeBuy._filterID)
    for i, v in ipairs(ExchangeBuy._filter1Cells) do
        local status = (i == config.firstlevel and ExchangeBuy._filter1State)
        GUI:Button_setBright(v.Button_1, status)
        local titleColor = status and ExchangeBuy._group1CellColorSel or ExchangeBuy._group1CellColorNormal
        GUI:Button_setTitleColor(v.Button_1, titleColor)
    end
    -- 组2
    if ExchangeBuy._filter1State then
        local data = SL:GetValue("EXCHANGE_FILTER_LIST")[config.firstlevel] or {}
        local items = {}
        for i, v in ipairs(data) do
            if v.secondlevel and v.secondlevelname then
                table.insert(items, v)
            end
        end

        -- rmv
        local ListView_filter_1 = ExchangeBuy._ui.ListView_filter_1
        local child = GUI:getChildByName(ListView_filter_1, "exList")
        if child then
            GUI:ListView_removeChild(ListView_filter_1, child)
        end

        if #items > 0 then
            local listView = GUI:ListView_Create(-1, "exList", 0, 0, 0, 0, 1)
            GUI:ListView_addMouseScrollPercent(listView)
            GUI:ListView_insertCustomItem(ListView_filter_1, listView, config.firstlevel)

            local cells = {}
            local jumpIndex = 0
            local itemSize = nil
            for i, v in ipairs(items) do
                local selected  = (v.secondlevel == config.secondlevel)
                jumpIndex       = (selected and i or jumpIndex)

                local ui, cell = ExchangeBuy.CreateFilterGroup2Cell()
                GUI:ListView_pushBackCustomItem(listView, cell)
                table.insert(cells, ui)
                GUI:Text_setString(ui.Text_name, v.secondlevelname)
                GUI:setVisible(ui.Image_1, selected)
                GUI:setVisible(ui.Image_2, selected)

                GUI:addOnClickEvent(cell, function()
                    -- record
                    ExchangeBuy._filterID = v.id
                    local tconfig = SL:GetValue("EXCHANGE_MENU_CONFIG_BY_ID", ExchangeBuy._filterID)
                    for k, vcell in pairs(cells) do
                        GUI:setVisible(vcell.Image_1, items[k].secondlevel == tconfig.secondlevel)
                        GUI:setVisible(vcell.Image_2, items[k].secondlevel == tconfig.secondlevel)
                    end

                    -- pull list
                    ExchangeBuy.OnClearItemList()
                    ExchangeBuy.PullItemList()
                end)

                if not itemSize then
                    itemSize = GUI:getContentSize(cell)
                end
            end

            local listWid  = GUI:getContentSize(ListView_filter_1).width
            local listHei  = math.min(itemSize.height * #items, 187)
            GUI:setContentSize(listView, listWid, listHei)
            
            jumpIndex = jumpIndex - 1
            GUI:ListView_jumpToItem(listView, jumpIndex)
        end        
    else
        -- rmv
        local child = GUI:getChildByName(ExchangeBuy._ui.ListView_filter_1, "exList")
        if child then
            GUI:ListView_removeChild(ExchangeBuy._ui.ListView_filter_1, child)
        end
    end
end

function ExchangeBuy.InitFilter()
    ExchangeBuy._upSingle = true
    GUI:delayTouchEnabled(ExchangeBuy._ui.Image_sort_s, 0.5)
    GUI:addOnClickEvent(ExchangeBuy._ui.Image_sort_s, function()
        ExchangeBuy._upSingle = not ExchangeBuy._upSingle
        local path = ExchangeBuy._upSingle and ExchangeBuy._priceArrowUpPath or ExchangeBuy._priceArrowDownPath
        GUI:Image_loadTexture(ExchangeBuy._ui.Image_sort_s, path)
        ExchangeBuy._sortType = ExchangeBuy._upSingle and 1 or 2
        ExchangeBuy.OnClearItemList()
        ExchangeBuy.PullItemList()
    end)

    ExchangeBuy._upTotal = true
    GUI:delayTouchEnabled(ExchangeBuy._ui.Image_sort_t, 0.5)
    GUI:addOnClickEvent(ExchangeBuy._ui.Image_sort_t, function()
        ExchangeBuy._upTotal = not ExchangeBuy._upTotal
        local path = ExchangeBuy._upTotal and ExchangeBuy._priceArrowUpPath or ExchangeBuy._priceArrowDownPath
        GUI:Image_loadTexture(ExchangeBuy._ui.Image_sort_t, path)
        ExchangeBuy._sortType = ExchangeBuy._upTotal and 3 or 4
        ExchangeBuy.OnClearItemList()
        ExchangeBuy.PullItemList()
    end)

    ExchangeBuy.HideFilterItems()
    GUI:addOnClickEvent(ExchangeBuy._ui.Panel_hide_filter, function ()
        ExchangeBuy.HideFilterItems()
    end)
    GUI:addOnClickEvent(ExchangeBuy._ui.Image_filter_c, function ()
        ExchangeBuy.ShowFilterItems()
    end)
end

function ExchangeBuy.HideFilterItems()
    GUI:setVisible(ExchangeBuy._ui.Image_filter_bg, false)
    GUI:setVisible(ExchangeBuy._ui.Panel_hide_filter, false)
    GUI:ListView_removeAllItems(ExchangeBuy._ui.ListView_filter_c)

    GUI:setFlippedY(ExchangeBuy._ui.Image_filter_c, false)
end

function ExchangeBuy.ShowFilterItems()
    local items = ExchangeBuy._currencies
    local ListView_filter = ExchangeBuy._ui.ListView_filter_c
    GUI:setVisible(ExchangeBuy._ui.Image_filter_bg, true)
    GUI:setVisible(ExchangeBuy._ui.Panel_hide_filter, true)
    GUI:ListView_removeAllItems(ListView_filter)

    GUI:setFlippedY(ExchangeBuy._ui.Image_filter_c, true)

    local itemWid = GUI:getContentSize(ListView_filter).width
    local itemHei = SL:GetValue("IS_PC_OPER_MODE") and 24 or 30
    local cells = {}
    for i, v in ipairs(items) do
        local ui, layout = ExchangeBuy.CreateFilterCell(ListView_filter, i, itemWid, itemHei)
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
                ExchangeBuy._currencyF = value
            else
                ExchangeBuy._currencyF = tostring(v.id)
            end
            GUI:Text_setString(ExchangeBuy._ui.Text_coin_type, name)
            ExchangeBuy.HideFilterItems()

            ExchangeBuy.OnClearItemList()
            ExchangeBuy.PullItemList()
        end)
    end

    local height  = math.min(#cells, ExchangeBuy._maxFilterCells) * itemHei
    GUI:setContentSize(ExchangeBuy._ui.Image_filter_bg, itemWid + 5, height + 5)
    GUI:setContentSize(ListView_filter, itemWid, height)
end

function ExchangeBuy.OnClearItemList()
    ExchangeBuy._curResPage = 0
    ExchangeBuy._items = {}
    ExchangeBuy._qCells = {}
    GUI:ListView_removeAllItems(ExchangeBuy._ui.ListView_items)
    GUI:ListView_jumpToTop(ExchangeBuy._ui.ListView_items)
    GUI:setVisible(ExchangeBuy._ui.Image_empty, true)
end

function ExchangeBuy.PullItemList(searchItem)
    local config = SL:GetValue("EXCHANGE_MENU_CONFIG_BY_ID", ExchangeBuy._filterID)
    local stdModeStr = config.stdmode
    local currencyStr = nil
    if ExchangeBuy._currencyF and string.len(ExchangeBuy._currencyF) > 0 then
        currencyStr = ExchangeBuy._currencyF
    end
    local pullData = {
        type        = ExchangeBuy._type,
        stdmode     = stdModeStr,
        currency    = currencyStr,
        sort        = ExchangeBuy._sortType,
        pageIndex   = ExchangeBuy._curResPage,
        itemids     = searchItem,
    }
    UIOperator:OpenLoadingBarUI(3)
    SL:RequestExchangeList(pullData)
end

function ExchangeBuy.RespItemList(data)
    if data.type ~= ExchangeBuy._type then  -- 世界交易
        return
    end
    UIOperator:CloseLoadingBarUI()
    ExchangeBuy._curResPage = data.pageIndex + 1

    local items = data.items
    if items and next(items) then
        local lastIndex = #GUI:ListView_getItems(ExchangeBuy._ui.ListView_items) - 1
        while next(items) do
            local item = table.remove(items, 1)

            local function createCell(parent)
                local cell = ExchangeBuy.CreateItemCell(parent, item) 
                return cell 
            end
            local wid = ExchangeBuy._itemSize.width
            local hei = ExchangeBuy._itemSize.height
            local quickCell = GUI:QuickCell_Create(ExchangeBuy._ui.ListView_items, "item_" .. item.guid, 0, 0, wid, hei, createCell)
            ExchangeBuy._qCells[item.guid] = quickCell
            ExchangeBuy._items[item.guid] = item
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(ExchangeBuy._ui.ListView_items, lastIndex)
        end
    end
    GUI:setVisible(ExchangeBuy._ui.Image_empty, next(ExchangeBuy._qCells) == nil)
end

function ExchangeBuy.OnLoadComplete(data)
    if data.type ~= ExchangeBuy._type then  -- 世界交易
        return
    end
    ExchangeBuy._complete = true
end

function ExchangeBuy.OnSearchItem(data)
    if data and string.len(data) ~= 0 then
        ExchangeBuy._searchItem = data
    else
        ExchangeBuy._searchItem = nil
    end
    ExchangeBuy.OnClearItemList()
    ExchangeBuy.PullItemList(ExchangeBuy._searchItem)
end

function ExchangeBuy.OnExchangeItemAdd(data)
    local item = data

    local mainPlayerID = SL:GetValue("USER_ID")
    local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeBuy._ui.ListView_items)

    local function createCell(parent)
        local cell = ExchangeBuy.CreateItemCell(parent, item) 
        return cell 
    end
    local quickCell = GUI:QuickCell_Create(ExchangeBuy._ui.ListView_items, "item_" .. item.guid, 0, 0, ExchangeBuy._itemSize.width, ExchangeBuy._itemSize.height, createCell)
    ExchangeBuy._qCells[item.guid] = quickCell
    ExchangeBuy._items[item.guid] = item
    
    GUI:ListView_doLayout(ExchangeBuy._ui.ListView_items)
    innerPos.y = innerPos.y + ExchangeBuy._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(ExchangeBuy._ui.ListView_items, innerPos)
    GUI:setVisible(ExchangeBuy._ui.Image_empty, next(ExchangeBuy._qCells) == nil)
end

function ExchangeBuy.OnExchangeItemDel(item)
    if not item or not item.guid then
        return
    end

    if nil == ExchangeBuy._qCells[item.guid] then
        return
    end

    local cell = ExchangeBuy._qCells[item.guid]
    local innerPos = GUI:ListView_getInnerContainerPosition(ExchangeBuy._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(ExchangeBuy._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(ExchangeBuy._ui.ListView_items, index)
    GUI:ListView_doLayout(ExchangeBuy._ui.ListView_items)
    innerPos.y = innerPos.y + ExchangeBuy._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(ExchangeBuy._ui.ListView_items, innerPos)

    ExchangeBuy._qCells[item.guid] = nil
    ExchangeBuy._items[item.guid] = nil

    GUI:setVisible(ExchangeBuy._ui.Image_empty, next(ExchangeBuy._qCells) == nil)
end

function ExchangeBuy.OnExchangeItemChange(item)
    if not item or not item.guid then
        return
    end

    if nil == ExchangeBuy._qCells[item.guid] then
        return
    end
    ExchangeBuy._items[item.guid] = item
    GUI:QuickCell_Exit(ExchangeBuy._qCells[item.guid])
    GUI:QuickCell_Refresh(ExchangeBuy._qCells[item.guid])
end

function ExchangeBuy.OnExchangeUpdate(data)
    -- type 1：新增 2: 删除 3：刷新
    local type = data.type
    if type == 1 then
        ExchangeBuy.OnExchangeItemAdd(data.item)
    elseif type == 2 then
        ExchangeBuy.OnExchangeItemDel(data.item)
    elseif type == 3 then
        ExchangeBuy.OnExchangeItemChange(data.item)
    end
end

function ExchangeBuy.InitEvent()
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangeBuy", ExchangeBuy.RespItemList)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_COMPLETE, "ExchangeBuy", ExchangeBuy.OnLoadComplete)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, "ExchangeBuy", ExchangeBuy.OnSearchItem)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, "ExchangeBuy", ExchangeBuy.OnExchangeUpdate)
end

function ExchangeBuy.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_PULL, "ExchangeBuy")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_ITEM_LIST_COMPLETE, "ExchangeBuy")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_SEARCH_ITEM_UPDATE, "ExchangeBuy")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, "ExchangeBuy")
end

-- 左侧列表 一级标签
function ExchangeBuy.CreateFilterGroup1Cell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_filter_group1_cell" or "exchange/exchange_filter_group1_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 左侧列表 二级标签
function ExchangeBuy.CreateFilterGroup2Cell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_filter_group2_cell" or "exchange/exchange_filter_group2_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 筛选 cell
function ExchangeBuy.CreateFilterCell(parent, i, itemWid, itemHei)
    local layout = GUI:Layout_Create(parent, "Panel_" .. i, 0, 0, itemWid, itemHei)
    GUI:setTouchEnabled(layout, true)
    local text = GUI:Text_Create(layout, "Text_1", itemWid / 2, itemHei / 2, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", "")
    GUI:setAnchorPoint(text, 0.5, 0.5)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 列表cell
function ExchangeBuy.CreateItemCell(parent, item)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_buy_cell" or "exchange/exchange_buy_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_cell")
    
    local mainPlayerID  = SL:GetValue("USER_ID")
    item                = ExchangeBuy._items[item.guid]

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

    -- 数量
    GUI:Text_setString(ui.Text_p_num, item.remainqty)
    -- 货币类型
    local coinName = SL:GetValue("ITEM_NAME", item.currency)
    GUI:Text_setString(ui.Text_coin, coinName)
    -- 单价
    GUI:Text_setString(ui.Text_single, item.price)
    -- 总价
    GUI:Text_setString(ui.Text_total, item.price * item.remainqty)
    -- 购买
    GUI:addOnClickEvent(ui.Button_oper, function()
        if item.remainqty == 1 then
            local function callback(bType)
                if bType == 1 then
                    SL:RequestExchangeBuyPanel({ guid = item.guid, qty = item.remainqty })
                end
            end
            local data = {}
            data.str = "是否确定购买该物品？"
            data.btnDesc = {"确定", "取消"}
            data.callback = callback
            UIOperator:OpenCommonTipsUI(data)
        else
            UIOperator:OpenExchangeBuyUI(item)
        end
        
    end)

    return cell
end

-- 价格 cell
function ExchangeBuy.CreatePriceCell(parent, data)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "exchange_win32/exchange_price_cell" or "exchange/exchange_price_cell")

    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, {index = data.id, look = true, mouseCheckTimes = 8})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)
end

ExchangeBuy.main()