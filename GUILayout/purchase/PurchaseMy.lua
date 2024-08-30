PurchaseMy = {}

PurchaseMy._groups = {
    {
        title = "求购列表",
    },
    {
        title = "已收列表",
    },
}

PurchaseMy._groupCellColorSel    = "#f8e6c6"         -- 左侧页签选中时按钮文字颜色
PurchaseMy._groupCellColorNormal = "#6c6861"         -- 左侧页签未选中时按钮文字颜色

function PurchaseMy.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "purchase_win32/purchase_my" or "purchase/purchase_my")
    
    PurchaseMy._ui = GUI:ui_delegate(parent)
    PurchaseMy._groupId     = 1
    PurchaseMy._type        = 1     -- 1: 我的求购 2: 我的已收
    PurchaseMy._curResPage  = 0     -- 页码
    PurchaseMy._complete    = false -- 数据加载完成

    PurchaseMy._groupCells  = {}
    PurchaseMy._items       = {}
    PurchaseMy._qCells      = {}

    -- 单个列表cell 尺寸
    PurchaseMy._itemSize = SL:GetValue("IS_PC_OPER_MODE") and {width = 505, height = 70} or {width = 605, height = 80}

    local status = true
    local function listViewEvent(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseMy._ui.ListView_items)
            local itemHei = PurchaseMy._itemSize and PurchaseMy._itemSize.height or 80
            local count = GUI:ListView_getItemCount(PurchaseMy._ui.ListView_items)
            local realHei = count * itemHei + (count - 1) * GUI:ListView_getItemsMargin(PurchaseMy._ui.ListView_items)
            local contentSize = GUI:getContentSize(PurchaseMy._ui.ListView_items)
            if innerPos.y == 0 then
                if false == PurchaseMy._complete and status then
                    status = false
                    SL:scheduleOnce(PurchaseMy._ui.ListView_items, function()
                        status = true
                    end, 0.5)

                    if realHei < contentSize.height then
                        return
                    end
                    SL:scheduleOnce(PurchaseMy._ui.ListView_items, function()
                        PurchaseMy.PullItemList()
                    end, 0.01)
                end
            end
        end
    end
    GUI:ListView_addOnScrollEvent(PurchaseMy._ui.ListView_items, listViewEvent)
    GUI:ListView_addMouseScrollPercent(PurchaseMy._ui.ListView_items)

    PurchaseMy.InitLeftGroup()
    PurchaseMy.InitBtnUI()
    PurchaseMy.InitEvent()
end

function PurchaseMy.InitLeftGroup()
    for idx, v in ipairs(PurchaseMy._groups) do
        local ui, cell = PurchaseMy.CreateFilterGroupCell()
        GUI:ListView_pushBackCustomItem(PurchaseMy._ui.ListView_filter_1, cell)
        PurchaseMy._groupCells[idx] = ui
        GUI:Button_setTitleText(ui.Button_1, v.title)
        GUI:addOnClickEvent(ui.Button_1, function()
            if PurchaseMy._groupId == idx then
                return
            end

            PurchaseMy._groupId = idx
            PurchaseMy._type = idx == 1 and 1 or 2
            PurchaseMy.UpdateGroupPanel()
        end)
    end

    PurchaseMy.UpdateGroupPanel()
end

function PurchaseMy.UpdateGroupPanel()
    for i, v in ipairs(PurchaseMy._groupCells) do
        local status = i == PurchaseMy._groupId
        GUI:Button_setBright(v.Button_1, status)
        local titleColor = status and PurchaseMy._groupCellColorSel or PurchaseMy._groupCellColorNormal
        GUI:Button_setTitleColor(v.Button_1, titleColor)
    end

    for i = 1, 2 do
        GUI:setVisible(PurchaseMy._ui["Panel_title_" .. i], i == PurchaseMy._groupId)
    end

    GUI:setVisible(PurchaseMy._ui.Button_cancel, 1 == PurchaseMy._groupId)
    GUI:setVisible(PurchaseMy._ui.Button_purchase, 1 == PurchaseMy._groupId)
    GUI:setVisible(PurchaseMy._ui.Button_take_out, 2 == PurchaseMy._groupId)

    PurchaseMy.OnClearItemList()
    PurchaseMy.PullItemList()
end

function PurchaseMy.InitBtnUI()
    -- 全部取消
    GUI:addOnClickEvent(PurchaseMy._ui.Button_cancel, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestPurchasePutOut()
    end)

    -- 我要采购
    GUI:addOnClickEvent(PurchaseMy._ui.Button_purchase, function()
        UIOperator:OpenPurchasePutInUI()
    end)

    -- 全部取出
    GUI:addOnClickEvent(PurchaseMy._ui.Button_take_out, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestPurchaseTakeOut()
    end)
end

function PurchaseMy.OnClearItemList()
    PurchaseMy._curResPage = 0
    PurchaseMy._items = {}
    PurchaseMy._qCells = {}
    PurchaseMy._complete = false
    GUI:ListView_removeAllItems(PurchaseMy._ui.ListView_items)
    GUI:ListView_jumpToTop(PurchaseMy._ui.ListView_items)
    GUI:setVisible(PurchaseMy._ui.Image_empty, true)
end

function PurchaseMy.PullItemList()
    local pullData = {
        type        = PurchaseMy._type,
        pageIndex   = PurchaseMy._curResPage,
    }
    UIOperator:OpenLoadingBarUI(3)
    SL:RequestPurchaseItemList(pullData)
end

function PurchaseMy.RespItemList(data)
    if data.type ~= PurchaseMy._type then
        return
    end
    UIOperator:CloseLoadingBarUI()
    PurchaseMy._curResPage = data.pageIndex + 1

    local items = data.items
    if items and next(items) then
        local lastIndex = #GUI:ListView_getItems(PurchaseMy._ui.ListView_items) - 1
        while next(items) do
            local item = table.remove(items, 1)

            local function createCell(parent)
                local cell = PurchaseMy.CreateItemCell(parent, item)
                return cell 
            end
            local wid = PurchaseMy._itemSize.width
            local hei = PurchaseMy._itemSize.height
            local quickCell = GUI:QuickCell_Create(PurchaseMy._ui.ListView_items, "item_" .. item.guid, 0, 0, wid, hei, createCell)
            PurchaseMy._qCells[item.guid] = quickCell
            PurchaseMy._items[item.guid] = item
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(PurchaseMy._ui.ListView_items, lastIndex)
        end
    end
    GUI:setVisible(PurchaseMy._ui.Image_empty, next(PurchaseMy._qCells) == nil)
end

function PurchaseMy.OnLoadComplete(data)
    if data.type ~= PurchaseMy._type then
        return
    end
    PurchaseMy._complete = true
end

function PurchaseMy.OnPurchaseItemAdd(data)
    local item = data

    local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseMy._ui.ListView_items)

    local function createCell(parent)
        local cell = PurchaseMy.CreateItemCell(parent, item) 
        return cell 
    end
    local quickCell = GUI:QuickCell_Create(PurchaseMy._ui.ListView_items, "item_" .. item.guid, 0, 0, PurchaseMy._itemSize.width, PurchaseMy._itemSize.height, createCell)
    PurchaseMy._qCells[item.guid] = quickCell
    PurchaseMy._items[item.guid] = item
    
    GUI:ListView_doLayout(PurchaseMy._ui.ListView_items)
    innerPos.y = innerPos.y + PurchaseMy._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(PurchaseMy._ui.ListView_items, innerPos)
    GUI:setVisible(PurchaseMy._ui.Image_empty, next(PurchaseMy._qCells) == nil)
end

function PurchaseMy.OnPurchaseItemDel(item)
    if not item or not item.guid then
        return
    end

    if nil == PurchaseMy._qCells[item.guid] then
        return
    end

    local cell = PurchaseMy._qCells[item.guid]
    local innerPos = GUI:ListView_getInnerContainerPosition(PurchaseMy._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(PurchaseMy._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(PurchaseMy._ui.ListView_items, index)
    GUI:ListView_doLayout(PurchaseMy._ui.ListView_items)
    innerPos.y = innerPos.y + PurchaseMy._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(PurchaseMy._ui.ListView_items, innerPos)

    PurchaseMy._qCells[item.guid] = nil
    PurchaseMy._items[item.guid] = nil

    PurchaseMy._ui.Image_empty:setVisible(next(PurchaseMy._qCells) == nil)
end

function PurchaseMy.OnPurchaseItemChange(item)
    if not item or not item.guid then
        return
    end

    if nil == PurchaseMy._qCells[item.guid] then
        return
    end

    PurchaseMy._items[item.guid] = item
    GUI:QuickCell_Exit(PurchaseMy._qCells[item.guid])
    GUI:QuickCell_Refresh(PurchaseMy._qCells[item.guid])
end

function PurchaseMy.OnPurchaseUpdate(data)
    -- type 1：新增 2: 删除 3：刷新
    local type = data.type
    local isReceive = data.isReceive
    local needOper = false
    if isReceive and PurchaseMy._type == 2 then
        needOper = true
    elseif not isReceive and PurchaseMy._type == 1 then
        needOper = true
    end
    if type == 1 then
        if needOper then
            PurchaseMy.OnPurchaseItemAdd(data.item)
        end
    elseif type == 2 then
        if needOper then
            PurchaseMy.OnPurchaseItemDel(data.item)
        end
    elseif type == 3 then
        local item = data.item
        if isReceive and PurchaseMy._type == 2 and not PurchaseMy._items[item.guid] then
            PurchaseMy.OnPurchaseItemAdd(data.item)  
        else
            PurchaseMy.OnPurchaseItemChange(data.item)
        end
    end
end

function PurchaseMy.InitEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_PULL, "PurchaseMy", PurchaseMy.RespItemList)
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_COMPLETE, "PurchaseMy", PurchaseMy.OnLoadComplete)
    SL:RegisterLUAEvent(LUA_EVENT_PURCHASE_MYITEM_UPDATE, "PurchaseMy", PurchaseMy.OnPurchaseUpdate)

end

function PurchaseMy.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_PULL, "PurchaseMy")
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_ITEM_LIST_COMPLETE, "PurchaseMy")
    SL:UnRegisterLUAEvent(LUA_EVENT_PURCHASE_MYITEM_UPDATE, "PurchaseMy")
end

function PurchaseMy.CreateItemCell(parent, item)
    if PurchaseMy._groupId == 1 then
        return PurchaseMy.CreateMyPurchaseCell(parent, item)
    elseif PurchaseMy._groupId == 2 then
        return PurchaseMy.CreateMyReceiveCell(parent, item)
    end
end

function PurchaseMy.CreateMyPurchaseCell(parent, item)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "purchase_win32/purchase_my_cell" or "purchase/purchase_my_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_cell")
    
    item = PurchaseMy._items[item.guid]

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

    -- 剩余数量
    GUI:Text_setString(ui.Text_remain, item.remainqty)
    -- 最小数量
    GUI:Text_setString(ui.Text_min_num, item.minqty)
    -- 货币类型
    local coinName = SL:GetValue("ITEM_NAME", item.currency)
    GUI:Text_setString(ui.Text_coin, coinName)
    -- 单价
    GUI:Text_setString(ui.Text_single, item.price)
    -- 剩余总价
    GUI:Text_setString(ui.Text_remain_total, item.remainqty * item.price)
    -- 取消
    GUI:addOnClickEvent(ui.Button_oper, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestPurchasePutOut(item.guid)
    end)

    return cell
end

function PurchaseMy.CreateMyReceiveCell(parent, item)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "purchase_win32/purchase_my_receive_cell" or "purchase/purchase_my_receive_cell")

    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_cell")
    
    item = PurchaseMy._items[item.guid]

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

   -- 单价
   GUI:Text_setString(ui.Text_single, item.price)
   -- 货币类型
   local coinName = SL:GetValue("ITEM_NAME", item.currency)
   GUI:Text_setString(ui.Text_coin, coinName)
   -- 剩余数量
   GUI:Text_setString(ui.Text_remain, item.remainqty)
   -- 已收数量
   GUI:Text_setString(ui.Text_receive, item.recedqty)
    -- 取出
    GUI:addOnClickEvent(ui.Button_oper, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestPurchaseTakeOut(item.guid)
    end)

    return cell
end

-- 左侧列表cell
function PurchaseMy.CreateFilterGroupCell()
    local root = GUI:Node_Create(-1, "node", 0, 0)
    GUI:LoadExport(root, SL:GetValue("IS_PC_OPER_MODE") and "purchase_win32/purchase_filter_group1_cell" or "purchase/purchase_filter_group1_cell")
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = GUI:ui_delegate(layout)

    return ui, layout
end

PurchaseMy.main()