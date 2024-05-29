PurchaseWorld = {}

PurchaseWorld._maxFilterCells           = 8                                 -- 筛选弹出列表最多显示条数
PurchaseWorld._group1CellColorSel       = "#f8e6c6"                         -- 左侧页签选中时按钮文字颜色
PurchaseWorld._group1CellColorNormal    = "#6c6861"                         -- 左侧页签未选中时按钮文字颜色
PurchaseWorld._priceArrowUpPath         = "res/public/btn_szjm_01_3.png"    -- 筛选价格向上箭头图片
PurchaseWorld._priceArrowDownPath       = "res/public/btn_szjm_01_4.png"    -- 筛选价格向上箭头图片
PurchaseWorld._type                     = 0                                 -- 世界求购

function PurchaseWorld.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_world" or "purchase/purchase_world")
    
    PurchaseWorld._ui = GUI:ui_delegate(parent)

    PurchaseWorld._filter1Index = 1
    PurchaseWorld._filter1State = true
    PurchaseWorld._filter1Cells = {}
    PurchaseWorld._filterID     = 1     -- 分类选择ID
    PurchaseWorld._sortType     = 0     -- 排序类型
    PurchaseWorld._currencyF    = ""    -- 货币筛选
    PurchaseWorld._curResPage   = 0     -- 页码
    PurchaseWorld._complete     = false -- 数据加载完成

    PurchaseWorld._currencies   = SL:GetMetaValue("PURCHASE_CURRENCIES")
    table.insert(PurchaseWorld._currencies, 1, {id = 0, name = "全部"})


    -- 单个列表cell 尺寸
    PurchaseWorld._itemSize = SL:GetMetaValue("WINPLAYMODE") and {width = 505, height = 70} or {width = 605, height = 80}
    PurchaseWorld._items = {}
    PurchaseWorld._qCells = {}

    local status = true
    local function listViewEvent(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseWorld._ui.ListView_items)
            local itemHei = PurchaseWorld._itemSize and PurchaseWorld._itemSize.height or 80
            local count = GUI:ListView_getItemCount(PurchaseWorld._ui.ListView_items)
            local realHei = count * itemHei + (count - 1) * GUI:ListView_getItemsMargin(PurchaseWorld._ui.ListView_items)
            local contentSize = GUI:getContentSize(PurchaseWorld._ui.ListView_items)
            if innerPos.y == 0 then
                if false == PurchaseWorld._complete and status then
                    status = false
                    SL:scheduleOnce(PurchaseWorld._ui.ListView_items, function()
                        status = true
                    end, 0.5)

                    if realHei < contentSize.height then
                        return
                    end
                    SL:scheduleOnce(PurchaseWorld._ui.ListView_items, function()
                        PurchaseWorld.PullItemList()
                    end, 0.01)
                end
            end
        end
    end
    GUI:ListView_addOnScrollEvent(PurchaseWorld._ui.ListView_items, listViewEvent)
    GUI:ListView_addMouseScrollPercent(PurchaseWorld._ui.ListView_items)

    PurchaseWorld.InitLeftGroup()
    PurchaseWorld.InitFilter()
    PurchaseWorld.InitEvent()
end

function PurchaseWorld.InitLeftGroup()
    local items = SL:GetMetaValue("PURCHASE_FILTER_LIST")
    for _, v in ipairs(items) do
        local ui, cell = PurchaseWorld.CreateFilterGroup1Cell()
        GUI:ListView_pushBackCustomItem(PurchaseWorld._ui.ListView_filter_1, cell)
        PurchaseWorld._filter1Cells[v[1].firstlevel] = ui
        GUI:Button_setTitleText(ui.Button_1, v[1].firstlevelname)
        GUI:addOnClickEvent(ui.Button_1, function()
            if PurchaseWorld._filter1Index ~= v[1].firstlevel then
                PurchaseWorld._filter1State = true
                
            elseif PurchaseWorld._filter1Index ~= 1 then
                PurchaseWorld._filter1State = not PurchaseWorld._filter1State
            end

            if PurchaseWorld._filter1State then
                if PurchaseWorld._filter1Index ~= v[1].firstlevel then
                    PurchaseWorld._filterID = v[1].id
                    PurchaseWorld.OnClearItemList()
                    PurchaseWorld.PullItemList()
                end
            end
            PurchaseWorld:UpdateFilter1()

            PurchaseWorld._filter1Index = v[1].firstlevel
        end)
    end

    PurchaseWorld.OnClearItemList()
    PurchaseWorld.PullItemList()
    PurchaseWorld.UpdateFilter1()
end

function PurchaseWorld.UpdateFilter1()
    -- 组1
    local config = SL:GetMetaValue("PURCHASE_MENU_CONFIG_BY_ID", PurchaseWorld._filterID)
    for i, v in ipairs(PurchaseWorld._filter1Cells) do
        local status = (i == config.firstlevel and PurchaseWorld._filter1State)
        GUI:Button_setBright(v.Button_1, status)
        local titleColor = status and PurchaseWorld._group1CellColorSel or PurchaseWorld._group1CellColorNormal
        GUI:Button_setTitleColor(v.Button_1, titleColor)
    end
    -- 组2
    if PurchaseWorld._filter1State then
        local data = SL:GetMetaValue("PURCHASE_FILTER_LIST")[config.firstlevel] or {}
        local items = {}
        for i, v in ipairs(data) do
            if v.secondlevel and v.secondlevelname then
                table.insert(items, v)
            end
        end

        -- rmv
        local ListView_filter_1 = PurchaseWorld._ui.ListView_filter_1
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

                local ui, cell = PurchaseWorld.CreateFilterGroup2Cell()
                GUI:ListView_pushBackCustomItem(listView, cell)
                table.insert(cells, ui)
                GUI:Text_setString(ui.Text_name, v.secondlevelname)
                GUI:setVisible(ui.Image_1, selected)
                GUI:setVisible(ui.Image_2, selected)

                cell:addClickEventListener(function()
                    -- record
                    PurchaseWorld._filterID = v.id
                    local tconfig = SL:GetMetaValue("PURCHASE_MENU_CONFIG_BY_ID", PurchaseWorld._filterID)
                    for k, vcell in pairs(cells) do
                        GUI:setVisible(vcell.Image_1, items[k].secondlevel == tconfig.secondlevel)
                        GUI:setVisible(vcell.Image_2, items[k].secondlevel == tconfig.secondlevel)
                    end

                    -- pull list
                    PurchaseWorld.OnClearItemList()
                    PurchaseWorld.PullItemList()
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
        local child = GUI:getChildByName(PurchaseWorld._ui.ListView_filter_1, "exList")
        if child then
            GUI:ListView_removeChild(PurchaseWorld._ui.ListView_filter_1, child)
        end
    end
end

function PurchaseWorld.InitFilter()
    PurchaseWorld._upSingle = true
    GUI:delayTouchEnabled(PurchaseWorld._ui.Image_sort_s, 0.5)
    GUI:addOnClickEvent(PurchaseWorld._ui.Image_sort_s, function()
        PurchaseWorld._upSingle = not PurchaseWorld._upSingle
        local path = PurchaseWorld._upSingle and PurchaseWorld._priceArrowUpPath or PurchaseWorld._priceArrowDownPath
        GUI:Image_loadTexture(PurchaseWorld._ui.Image_sort_s, path)
        PurchaseWorld._sortType = PurchaseWorld._upSingle and 1 or 2
        PurchaseWorld.OnClearItemList()
        PurchaseWorld.PullItemList()
    end)

    PurchaseWorld._upTotal = true
    GUI:addOnClickEvent(PurchaseWorld._ui.Image_sort_t, function()
        PurchaseWorld._upTotal = not PurchaseWorld._upTotal
        local path = PurchaseWorld._upTotal and PurchaseWorld._priceArrowUpPath or PurchaseWorld._priceArrowDownPath
        GUI:Image_loadTexture(PurchaseWorld._ui.Image_sort_t, path)
        PurchaseWorld._sortType = PurchaseWorld._upTotal and 3 or 4
        PurchaseWorld.OnClearItemList()
        PurchaseWorld.PullItemList()

        GUI:delayTouchEnabled(PurchaseWorld._ui.Image_sort_t, 0.5)
    end)

    PurchaseWorld.HideFilterItems()
    GUI:addOnClickEvent(PurchaseWorld._ui.Panel_hide_filter, function ()
        PurchaseWorld.HideFilterItems()
    end)
    GUI:addOnClickEvent(PurchaseWorld._ui.Image_filter_c, function ()
        PurchaseWorld.ShowFilterItems()
    end)
end

function PurchaseWorld.HideFilterItems()
    GUI:setVisible(PurchaseWorld._ui.Image_filter_bg, false)
    GUI:setVisible(PurchaseWorld._ui.Panel_hide_filter, false)
    GUI:ListView_removeAllItems(PurchaseWorld._ui.ListView_filter_c)

    GUI:setFlippedY(PurchaseWorld._ui.Image_filter_c, false)
end

function PurchaseWorld.ShowFilterItems()
    local items = PurchaseWorld._currencies
    local ListView_filter = PurchaseWorld._ui.ListView_filter_c
    GUI:setVisible(PurchaseWorld._ui.Image_filter_bg, true)
    GUI:setVisible(PurchaseWorld._ui.Panel_hide_filter, true)
    GUI:ListView_removeAllItems(ListView_filter)

    GUI:setFlippedY(PurchaseWorld._ui.Image_filter_c, true)

    local itemWid = GUI:getContentSize(ListView_filter).width
    local itemHei = SL:GetMetaValue("WINPLAYMODE") and 24 or 30
    local cells = {}
    for i, v in ipairs(items) do
        local ui, layout = PurchaseWorld.CreateFilterCell(ListView_filter, i, itemWid, itemHei)
        table.insert(cells, ui)
        local name = v.name or SL:GetMetaValue("ITEM_NAME", v.id)
        GUI:Text_setString(ui.Text_1, name)
        GUI:addOnClickEvent(layout, function()
            if v.id == 0 then
                local value = ""
                for k, data in ipairs(items) do
                    if data.id ~= 0 then
                        value = string.format("%s%s%s", value, data.id, k ~= #items and "," or "")
                    end
                end
                PurchaseWorld._currencyF = value
            else
                PurchaseWorld._currencyF = tostring(v.id)
            end
            GUI:Text_setString(PurchaseWorld._ui.Text_coin_type, name)
            PurchaseWorld.HideFilterItems()

            PurchaseWorld.OnClearItemList()
            PurchaseWorld.PullItemList()
        end)
    end

    local height  = math.min(#cells, PurchaseWorld._maxFilterCells) * itemHei
    GUI:setContentSize(PurchaseWorld._ui.Image_filter_bg, itemWid + 5, height + 5)
    GUI:setContentSize(ListView_filter, itemWid, height)
end

function PurchaseWorld.OnClearItemList()
    PurchaseWorld._curResPage = 0
    PurchaseWorld._items = {}
    PurchaseWorld._qCells = {}
    GUI:ListView_removeAllItems(PurchaseWorld._ui.ListView_items)
    GUI:ListView_jumpToTop(PurchaseWorld._ui.ListView_items)
    GUI:setVisible(PurchaseWorld._ui.Image_empty, true)
end

function PurchaseWorld.PullItemList(searchItem)
    local config = SL:GetMetaValue("PURCHASE_MENU_CONFIG_BY_ID", PurchaseWorld._filterID)
    local stdModeStr = config.stdmode
    local currencyStr = nil
    if PurchaseWorld._currencyF and string.len(PurchaseWorld._currencyF) > 0 then
        currencyStr = PurchaseWorld._currencyF
    end
    local pullData = {
        type        = PurchaseWorld._type,
        stdmode     = stdModeStr,
        currency    = currencyStr,
        sort        = PurchaseWorld._sortType,
        pageIndex   = PurchaseWorld._curResPage,
        itemids     = searchItem,
    }
    SL:ShowLoadingBar(3)
    SL:RequestPurchaseItemList(pullData)
end

function PurchaseWorld.RespItemList(data)
    if data.type ~= PurchaseWorld._type then  -- 世界求购
        return
    end
    SL:HideLoadingBar()
    PurchaseWorld._curResPage = data.pageIndex + 1

    local items = data.items
    if items and next(items) then
        local lastIndex = #GUI:ListView_getItems(PurchaseWorld._ui.ListView_items) - 1
        while next(items) do
            local item = table.remove(items, 1)

            local function createCell(parent)
                local cell = PurchaseWorld.CreateItemCell(parent, item) 
                return cell 
            end
            local wid = PurchaseWorld._itemSize.width
            local hei = PurchaseWorld._itemSize.height
            local quickCell = GUI:QuickCell_Create(PurchaseWorld._ui.ListView_items, "item_" .. item.guid, 0, 0, wid, hei, createCell)
            PurchaseWorld._qCells[item.guid] = quickCell
            PurchaseWorld._items[item.guid] = item
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(PurchaseWorld._ui.ListView_items, lastIndex)
        end
    end
    GUI:setVisible(PurchaseWorld._ui.Image_empty, next(PurchaseWorld._qCells) == nil)
end

function PurchaseWorld.OnLoadComplete(data)
    if data.type ~= PurchaseWorld._type then  -- 世界求购
        return
    end
    PurchaseWorld._complete = true
end

function PurchaseWorld.OnSearchItem(data)
    if data and string.len(data) ~= 0 then
        PurchaseWorld._searchItem = data
    else
        PurchaseWorld._searchItem = nil
    end
    PurchaseWorld.OnClearItemList()
    PurchaseWorld.PullItemList(PurchaseWorld._searchItem)
end

function PurchaseWorld.OnPurchaseItemAdd(data)
    local item = data

    local mainPlayerID = SL:GetMetaValue("USER_ID")
    local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseWorld._ui.ListView_items)

    local function createCell(parent)
        local cell = PurchaseWorld.CreateItemCell(parent, item) 
        return cell 
    end
    local quickCell = GUI:QuickCell_Create(PurchaseWorld._ui.ListView_items, "item_" .. item.guid, 0, 0, PurchaseWorld._itemSize.width, PurchaseWorld._itemSize.height, createCell)
    PurchaseWorld._qCells[item.guid] = quickCell
    PurchaseWorld._items[item.guid] = item
    
    GUI:ListView_doLayout(PurchaseWorld._ui.ListView_items)
    innerPos.y = innerPos.y + PurchaseWorld._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(PurchaseWorld._ui.ListView_items, innerPos)
    GUI:setVisible(PurchaseWorld._ui.Image_empty, next(PurchaseWorld._qCells) == nil)
end

function PurchaseWorld.OnPurchaseItemDel(item)
    if not item or not item.guid then
        return
    end

    if nil == PurchaseWorld._qCells[item.guid] then
        return
    end

    local cell = PurchaseWorld._qCells[item.guid]
    local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseWorld._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(PurchaseWorld._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(PurchaseWorld._ui.ListView_items, index)
    GUI:ListView_doLayout(PurchaseWorld._ui.ListView_items)
    innerPos.y = innerPos.y + PurchaseWorld._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(PurchaseWorld._ui.ListView_items, innerPos)

    PurchaseWorld._qCells[item.guid] = nil
    PurchaseWorld._items[item.guid] = nil

    PurchaseWorld._ui.Image_empty:setVisible(next(PurchaseWorld._qCells) == nil)
end

function PurchaseWorld.OnPurchaseItemChange(item)
    if not item or not item.guid then
        return
    end

    if nil == PurchaseWorld._qCells[item.guid] then
        return
    end

    PurchaseWorld._items[item.guid] = item
    GUI:QuickCell_Exit(PurchaseWorld._qCells[item.guid])
    GUI:QuickCell_Refresh(PurchaseWorld._qCells[item.guid])
end

function PurchaseWorld.OnPurchaseUpdate(data)
    -- type 1：新增 2: 删除 3：刷新
    local type = data.type
    if type == 1 then
        -- PurchaseWorld.OnPurchaseItemAdd(data.item)
    elseif type == 2 then
        PurchaseWorld.OnPurchaseItemDel(data.item)
    elseif type == 3 then
        PurchaseWorld.OnPurchaseItemChange(data.item)
    end
end

function PurchaseWorld.InitEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_PULL, "PurchaseWorld", PurchaseWorld.RespItemList)
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_COMPLETE, "PurchaseWorld", PurchaseWorld.OnLoadComplete)
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_SEARCH_ITEM_UPDATE, "PurchaseWorld", PurchaseWorld.OnSearchItem)
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_WORLDITEM_UPDATE, "PurchaseWorld", PurchaseWorld.OnPurchaseUpdate)
end

function PurchaseWorld.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_PULL, "PurchaseWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_COMPLETE, "PurchaseWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_SEARCH_ITEM_UPDATE, "PurchaseWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_WORLDITEM_UPDATE, "PurchaseWorld")
end

-- 左侧列表 一级标签
function PurchaseWorld.CreateFilterGroup1Cell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_filter_group1_cell" or "purchase/purchase_filter_group1_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 左侧列表 二级标签
function PurchaseWorld.CreateFilterGroup2Cell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_filter_group2_cell" or "purchase/purchase_filter_group2_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 筛选 cell
function PurchaseWorld.CreateFilterCell(parent, i, itemWid, itemHei)
    local layout = GUI:Layout_Create(parent, "Panel_" .. i, 0, 0, itemWid, itemHei)
    GUI:setTouchEnabled(layout, true)
    local text = GUI:Text_Create(layout, "Text_1", itemWid / 2, itemHei / 2, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", "")
    GUI:setAnchorPoint(text, 0.5, 0.5)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 列表cell
function PurchaseWorld.CreateItemCell(parent, item)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_world_cell" or "purchase/purchase_world_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_cell")
    
    local mainPlayerID  = SL:GetMetaValue("USER_ID")
    item                = PurchaseWorld._items[item.guid]

    local itemBgSize = GUI:getContentSize(ui.Image_bg)
    local itemShow = GUI:ItemShow_Create(ui.Image_bg, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
        index = item.itemid,
        look = true,
        mouseCheckTimes = 8
    })
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    -- 名字
    local colorHex = SL:GetMetaValue("ITEM_NAME_COLOR_VALUE", item.itemid)
    local itemName = SL:GetMetaValue("ITEM_NAME", item.itemid)
    GUI:Text_setString(ui.Text_name, "")
    local fontSize = GUI:Text_getFontSize(ui.Text_name)
    local scrollText = GUI:ScrollText_Create(ui.Text_name, "scrollText", 0, 0, SL:GetMetaValue("WINPLAYMODE") and 100 or 105, fontSize, colorHex, itemName)
    GUI:ScrollText_setHorizontalAlignment(scrollText, 1)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0, 0.5)

    -- 求购数量
    local str = string.format("%s/%s", item.totalqty - item.remainqty, item.totalqty)
    GUI:Text_setString(ui.Text_p_num, str)
    -- 最小数量
    GUI:Text_setString(ui.Text_min_num, item.minqty)
    -- 货币类型
    local coinName = SL:GetMetaValue("ITEM_NAME", item.currency)
    GUI:Text_setString(ui.Text_coin, coinName)
    -- 单价
    GUI:Text_setString(ui.Text_single, item.price)
    -- 总价
    GUI:Text_setString(ui.Text_total, item.price * item.totalqty)
    -- 卖出
    GUI:addOnClickEvent(ui.Button_oper, function()
        SL:OpenPurchaseSellUI(item)
    end)

    return cell
end

-- 价格 cell
function PurchaseWorld.CreatePriceCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_price_cell" or "purchase/purchase_price_cell")

    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, {index = data.id, look = true, mouseCheckTimes = 8})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)
end