PurchasePutIn = {}

PurchasePutIn._maxFilterCells       = 10
PurchasePutIn._groupCellColorSel    = "#f8e6c6"         -- 左侧页签选中时按钮文字颜色
PurchasePutIn._groupCellColorNormal = "#6c6861"         -- 左侧页签未选中时按钮文字颜色

function PurchasePutIn.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_putin" or "purchase/purchase_putin")
    
    PurchasePutIn._ui = GUI:ui_delegate(parent)

    PurchasePutIn._filter1Cells = {}
    PurchasePutIn._filter2Cells = {}
    PurchasePutIn._filterID     = 1     -- 分类选择ID

    PurchasePutIn._itemSizeHei  = SL:GetMetaValue("WINPLAYMODE") and 32 or 42
    PurchasePutIn._currencyList = SL:GetMetaValue("PURCHASE_CURRENCIES")
    PurchasePutIn._limitMinPrice = {}   -- 不同货币限制最小值
    PurchasePutIn._itemTblView = nil

    -- 显示适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(PurchasePutIn._ui.FrameLayout, screenW / 2, posY)

    -- 关闭
    if PurchasePutIn._ui.CloseLayout then
        GUI:setContentSize(PurchasePutIn._ui.CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(PurchasePutIn._ui.CloseLayout, function()
            SL:ClosePurchasePutInUI()
        end)
    end
    GUI:addOnClickEvent(PurchasePutIn._ui.CloseButton, function()
        SL:ClosePurchasePutInUI()
    end)

    -- 上架
    GUI:addOnClickEvent(PurchasePutIn._ui.Button_add, function()
        local minNum = tonumber(GUI:TextInput_getString(PurchasePutIn._ui.Input_min_num)) or 0
        if minNum <= 0 then
            SL:ShowSystemTips("求购最小数量需大于0")
            return
        end
        local num = tonumber(GUI:TextInput_getString(PurchasePutIn._ui.Input_num)) or 0
        if num <= 0 then
            SL:ShowSystemTips("求购数量需大于0")
            return
        end
        local singlePrice = tonumber(GUI:TextInput_getString(PurchasePutIn._ui.Input_single)) or 0
        if singlePrice <= 0 then
            SL:ShowSystemTips("求购单价需大于0")
            return
        end
        local data = {
            qty     = num,
            minqty  = minNum,
            price   = singlePrice,
            itemid  = PurchasePutIn._selItemID,
            currency = PurchasePutIn._selCoinID,
        }
        SL:RequestPurchasePutIn(data)

        GUI:delayTouchEnabled(PurchasePutIn._ui.Button_add)
    end)
    
    PurchasePutIn.InitSearchPanel()
    PurchasePutIn.InitLeftGroup()
    PurchasePutIn.InitParamPanel()
end

function PurchasePutIn.InitSearchPanel()
    
    local function Confirm_Search()
        local itemName = GUI:TextInput_getString(PurchasePutIn._ui.SearchInput)
        PurchasePutIn.UpdateItemList(itemName)
    end

    GUI:TextInput_addOnEvent(PurchasePutIn._ui.SearchInput, function(sender, eventType)
        if eventType == 0 then
            GUI:TextInput_setString(PurchasePutIn._ui.SearchInput, "")
        elseif eventType == 2 then
            local str = GUI:TextInput_getString(sender)
            if string.find(str, "\n") then
                GUI:TextInput_closeInput(sender)
                GUI:TextInput_setString(PurchasePutIn._ui.SearchInput, string.trim(str))
                SL:scheduleOnce(PurchasePutIn._ui.SearchInput, function() Confirm_Search() end, 0.01)
            end
        end
    end)

    GUI:addOnClickEvent(PurchasePutIn._ui.Button_confirm, Confirm_Search)
end

function PurchasePutIn.SearchAllItemsByKeyWord(str, itemList)
    if not str or string.len(str) == 0 then
        SL:ShowSystemTips("搜索内容为空!")
        return nil
    end
   
    local matchItems = {}

    local specialR  = {"%[", "%]", "%(","%)","%*"}
    for _, key in ipairs(specialR) do
        str = string.gsub(str, key, "%"..key)
    end
    
    if string.len(str) > 32 then
        SL:ShowSystemTips("无法匹配，仍显示当前分页内容")
        return nil
    end

    for i = 1, #itemList do
        local name = SL:GetMetaValue("ITEM_NAME", itemList[i])
        if string.find(name, str) then
            table.insert(matchItems, itemList[i])
        end
    end

    return matchItems
end

function PurchasePutIn.InitLeftGroup()
    local items = SL:GetMetaValue("PURCHASE_FILTER_LIST")
    for _, v in ipairs(items) do
        local ui, cell = PurchasePutIn.CreateFilterGroupCell()
        GUI:ListView_pushBackCustomItem(PurchasePutIn._ui.ListView_filter_1, cell)
        PurchasePutIn._filter1Cells[v[1].firstlevel] = ui
        GUI:Button_setTitleText(ui.Button_1, v[1].firstlevelname)
        GUI:addOnClickEvent(ui.Button_1, function()
            if PurchasePutIn._filterID == v[1].id then
                return
            end
            PurchasePutIn._filterID = v[1].id
            PurchasePutIn.UpdateFilter()
            PurchasePutIn.UpdateItemList()
        end)
    end

    PurchasePutIn.UpdateFilter()
    PurchasePutIn.UpdateItemList()
end

function PurchasePutIn.UpdateFilter(noNeedLoad)
    local config = SL:GetMetaValue("PURCHASE_MENU_CONFIG_BY_ID", PurchasePutIn._filterID)

    if noNeedLoad then
        for i, v in pairs(PurchasePutIn._filter2Cells) do
            local status = i == config.secondlevel
            GUI:Button_setBright(v.Button_1, status)
            local titleColor = status and PurchasePutIn._groupCellColorSel or PurchasePutIn._groupCellColorNormal
            GUI:Button_setTitleColor(v.Button_1, titleColor)
        end
        return
    end
    -- 组1
    for i, v in pairs(PurchasePutIn._filter1Cells) do
        local status = i == config.firstlevel
        GUI:Button_setBright(v.Button_1, status)
        local titleColor = status and PurchasePutIn._groupCellColorSel or PurchasePutIn._groupCellColorNormal
        GUI:Button_setTitleColor(v.Button_1, titleColor)
    end

    -- 组2
    local items = SL:GetMetaValue("PURCHASE_FILTER_LIST")[config.firstlevel] or {}
    GUI:ListView_removeAllItems(PurchasePutIn._ui.ListView_filter_2)
    PurchasePutIn._filter2Cells = {}

    if #items > 0 then
        for i, v in ipairs(items) do
            if v.secondlevel and v.secondlevelname then
                local selected  = (v.secondlevel == config.secondlevel)

                local ui, cell = PurchasePutIn.CreateFilterGroupCell()
                GUI:ListView_pushBackCustomItem(PurchasePutIn._ui.ListView_filter_2, cell)
                PurchasePutIn._filter2Cells[v.secondlevel] = ui
                GUI:Button_setTitleText(ui.Button_1, v.secondlevelname)
                GUI:Button_setBright(ui.Button_1, selected)
                local titleColor = selected and PurchasePutIn._groupCellColorSel or PurchasePutIn._groupCellColorNormal
                GUI:Button_setTitleColor(ui.Button_1, titleColor)

                GUI:addOnClickEvent(ui.Button_1, function()
                    if PurchasePutIn._filterID == v.id then
                        return
                    end
                    PurchasePutIn._filterID = v.id
                    PurchasePutIn.UpdateFilter(true)
                    PurchasePutIn.UpdateItemList()
                end)
            end
        end
    end      
end

function PurchasePutIn.UpdateItemList(searchStr)
    local config = SL:GetMetaValue("PURCHASE_MENU_CONFIG_BY_ID", PurchasePutIn._filterID)
    PurchasePutIn._itemUIItem = {}
    PurchasePutIn._itemList = {}
    PurchasePutIn._selItemIdx = 1
    local itemList = SL:GetMetaValue("PURCHASE_ITEM_LIST_BY_TYPE", config.firstlevel, config.secondlevel)
    local searchItemList = nil
    if searchStr then
        searchItemList = PurchasePutIn.SearchAllItemsByKeyWord(searchStr, itemList)
    end
    PurchasePutIn._itemList = searchItemList or itemList or {}
    if #PurchasePutIn._itemList > 0 then
        -- 物品列表
        local size = GUI:getContentSize(PurchasePutIn._ui.Layout_item)
        if not PurchasePutIn._itemTblView then
            PurchasePutIn._itemTblView = GUI:TableView_Create(PurchasePutIn._ui.Layout_item, "TableView_item", 0, 0, size.width, size.height, 1, size.width, PurchasePutIn._itemSizeHei, #PurchasePutIn._itemList)
            
            local function touchCellFunc(tv, cell)
                local lastIdx = PurchasePutIn._selItemIdx
                local idx = GUI:TableViewCell_getIdx(cell)
                if lastIdx == idx then
                    return
                end
                PurchasePutIn._selItemIdx = idx
                PurchasePutIn._selItemID = PurchasePutIn._itemList[idx]
                if PurchasePutIn._itemUIItem[lastIdx] and not tolua.isnull(PurchasePutIn._itemUIItem[lastIdx].Image_sel) then
                    GUI:setVisible(PurchasePutIn._itemUIItem[lastIdx].Image_sel, false)
                end
                GUI:setVisible(PurchasePutIn._itemUIItem[idx].Image_sel, true)
                PurchasePutIn.UpadateParamPanel()
            end
            GUI:TableView_addOnTouchedCellEvent(PurchasePutIn._itemTblView, touchCellFunc)
            GUI:TableView_addMouseScrollEvent(PurchasePutIn._itemTblView)

            GUI:TableView_setCellCreateEvent(PurchasePutIn._itemTblView, function(parent, idx, ID)
                if ID == "TableView_item" then
                    local ui, cell = PurchasePutIn.CreateFilterItemCell()
                    GUI:addChild(parent, cell)
                    local name = SL:GetMetaValue("ITEM_NAME", PurchasePutIn._itemList[idx])
                    GUI:Text_setString(ui.Text_name, name)
                    GUI:setVisible(ui.Image_sel, PurchasePutIn._selItemIdx == idx)
                    PurchasePutIn._itemUIItem[idx] = ui
                end
            end)
        end
        PurchasePutIn._selItemID = PurchasePutIn._itemList[PurchasePutIn._selItemIdx]
        GUI:TableView_setTableViewCellsNumHandler(PurchasePutIn._itemTblView, #PurchasePutIn._itemList)
        GUI:TableView_reloadData(PurchasePutIn._itemTblView)
    else
        if GUI:getChildByName(PurchasePutIn._ui.Layout_item, "TableView_item") then
            GUI:removeChildByName(PurchasePutIn._ui.Layout_item, "TableView_item")
        end
        PurchasePutIn._itemTblView = nil    
    end

    PurchasePutIn.UpadateParamPanel()
end

function PurchasePutIn.InitParamPanel()
    GUI:TextInput_setInputMode(PurchasePutIn._ui.Input_single, 2)
    GUI:TextInput_setInputMode(PurchasePutIn._ui.Input_num, 2)
    GUI:TextInput_setInputMode(PurchasePutIn._ui.Input_min_num, 2)

    GUI:TextInput_addOnEvent(PurchasePutIn._ui.Input_single, function(sender, type)
        if type == 1 then
            if PurchasePutIn._selCoinID then
                local input = tonumber(GUI:TextInput_getString(sender)) or 0
                local inputMin = PurchasePutIn._limitMinPrice[PurchasePutIn._selCoinID]

                if inputMin and input < inputMin then
                    SL:ShowSystemTips(string.format("限制单价最小值%s", inputMin))
                    input = math.max(input, inputMin)
                end

                GUI:TextInput_setString(sender, input)
                PurchasePutIn.ChangeSelCurrency()
            end
        end   
    end)

    GUI:TextInput_addOnEvent(PurchasePutIn._ui.Input_num, function(sender, type)
        if type == 1 then
            local input = tonumber(GUI:TextInput_getString(sender)) or 0
            local inputMax = PurchasePutIn._curLimitMaxNum

            if inputMax and input > inputMax then
                SL:ShowSystemTips(string.format("限制求购数量最大值", inputMax))
                input = math.min(input, inputMax)
            end
            GUI:TextInput_setString(sender, input)
            PurchasePutIn.ChangeSelCurrency()
        end   
    end)

    PurchasePutIn.HideFilterItems()
    GUI:addOnClickEvent(PurchasePutIn._ui.Panel_hide_filter, function()
        PurchasePutIn.HideFilterItems()
    end)
    GUI:addOnClickEvent(PurchasePutIn._ui.Image_filter_c, function()
        PurchasePutIn.ShowFilterItems()
    end)
    GUI:addOnClickEvent(PurchasePutIn._ui.Panel_currency, function()
        PurchasePutIn.ShowFilterItems()
    end)
end

function PurchasePutIn.HideFilterItems()
    GUI:setVisible(PurchasePutIn._ui.Image_filter_bg, false)
    GUI:setVisible(PurchasePutIn._ui.Panel_hide_filter, false)
    GUI:ListView_removeAllItems(PurchasePutIn._ui.ListView_filter_c)

    GUI:setFlippedY(PurchasePutIn._ui.Image_filter_c, false)
end

function PurchasePutIn.ShowFilterItems()
    local items = PurchasePutIn._limitCurrency
    if #items == 0 then
        return
    end
    local ListView_filter = PurchasePutIn._ui.ListView_filter_c
    GUI:setVisible(PurchasePutIn._ui.Image_filter_bg, true)
    GUI:setVisible(PurchasePutIn._ui.Panel_hide_filter, true)
    GUI:ListView_removeAllItems(ListView_filter)

    GUI:setFlippedY(PurchasePutIn._ui.Image_filter_c, true)

    local itemWid = GUI:getContentSize(ListView_filter).width
    local itemHei = SL:GetMetaValue("WINPLAYMODE") and 24 or 30
    local cells = {}
    for i, v in ipairs(items) do
        local ui, layout = PurchasePutIn.CreateFilterCell(ListView_filter, i, itemWid, itemHei)
        table.insert(cells, ui)
        local name = v.name or SL:GetMetaValue("ITEM_NAME", v.id)
        GUI:Text_setString(ui.Text_1, name)
        GUI:addOnClickEvent(layout, function()
            PurchasePutIn._selCoinID = v.id
            PurchasePutIn.ChangeSelCurrency(name)
            PurchasePutIn.HideFilterItems()
        end)
    end

    local height  = math.min(#cells, PurchasePutIn._maxFilterCells) * itemHei
    GUI:setContentSize(PurchasePutIn._ui.Image_filter_bg, itemWid + 5, height + 5)
    GUI:setContentSize(ListView_filter, itemWid, height)
end

function PurchasePutIn.UpadateParamPanel()
    local itemData = SL:GetMetaValue("ITEM_DATA", PurchasePutIn._selItemID)
    -- 物品名
    local name = SL:GetMetaValue("ITEM_NAME", PurchasePutIn._selItemID)
    GUI:Text_setString(PurchasePutIn._ui.Text_item_name, name)

    PurchasePutIn._curLimitMaxNum = itemData.QiugouMaxCnt ~= 0 and itemData.QiugouMaxCnt or nil

    -- 货币
    PurchasePutIn._limitMinPrice = {}
    PurchasePutIn._limitCurrency = {}
    local currencyStr = itemData.QiugouGoldList
    local limitCurrency = {}
    if currencyStr and string.len(currencyStr) > 0 then
        local data = string.split(currencyStr, "|")
        for i, v in ipairs(data) do
            local param = string.split(v, "#")
            if tonumber(param[1]) and tonumber(param[2]) then
                local index = tonumber(param[1])
                local name = SL:GetMetaValue("ITEM_NAME", index)
                table.insert(limitCurrency, {id = index, name = name})
                PurchasePutIn._limitMinPrice[tonumber(param[1])] = tonumber(param[2])
            end
        end
    end
    local currencyList = #limitCurrency > 0 and limitCurrency or PurchasePutIn._currencyList
    PurchasePutIn._limitCurrency = currencyList

    -- 默认第一个货币
    if #currencyList > 0 then
        local coinId = currencyList[1].id
        PurchasePutIn._selCoinID = coinId
        PurchasePutIn.ChangeSelCurrency()
    end
end

function PurchasePutIn.ChangeSelCurrency(name)
    if not PurchasePutIn._selCoinID then
        return
    end
    local coinId = PurchasePutIn._selCoinID
    name = name or SL:GetMetaValue("ITEM_NAME", coinId)

    local singlePrice = tonumber(GUI:TextInput_getString(PurchasePutIn._ui.Input_single)) or 0
    local num = tonumber(GUI:TextInput_getString(PurchasePutIn._ui.Input_num)) or 0

    GUI:Text_setString(PurchasePutIn._ui.Text_coin_type, name)
    GUI:Text_setString(PurchasePutIn._ui.Text_price_base, PurchasePutIn._limitMinPrice[coinId] or 0)
    GUI:Text_setString(PurchasePutIn._ui.Text_price_total, singlePrice * num)
    GUI:Text_setString(PurchasePutIn._ui.Text_coin_num, SL:GetMetaValue("MONEY", coinId))
end

-- 左侧列表cell
function PurchasePutIn.CreateFilterGroupCell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_filter_group1_cell" or "purchase/purchase_filter_group1_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

function PurchasePutIn.CreateFilterItemCell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetMetaValue("WINPLAYMODE") and "purchase_win32/purchase_filter_item_cell" or "purchase/purchase_filter_item_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

-- 筛选 cell
function PurchasePutIn.CreateFilterCell(parent, i, itemWid, itemHei)
    local layout = GUI:Layout_Create(parent, "Panel_" .. i, 0, 0, itemWid, itemHei)
    GUI:setTouchEnabled(layout, true)
    local text = GUI:Text_Create(layout, "Text_1", itemWid / 2, itemHei / 2, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", "")
    GUI:setAnchorPoint(text, 0.5, 0.5)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end