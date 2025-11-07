AuctionWorld                       = {}

AuctionWorld.MaxFilterCells        = 15                             -- 筛选弹出列表最多显示条数
AuctionWorld.Group1CellColorSel    = "#f8e6c6"                      -- 左侧页签选中时按钮文字颜色
AuctionWorld.Group1CellColorNormal = "#6c6861"                      -- 左侧页签未选中时按钮文字颜色
AuctionWorld.FilterPriceArrowUp    = "res/public/btn_szjm_01_3.png" -- 筛选价格向上箭头图片
AuctionWorld.FilterPriceArrowDown  = "res/public/btn_szjm_01_4.png" -- 筛选价格向上箭头图片

local isFixedPrice = true   --是否一口价价格

function AuctionWorld.main()
    local data = GUI:GetLayerOpenParam()
    local parent = data.parent
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_world" or "auction/auction_world")

    AuctionWorld._ui       = GUI:ui_delegate(parent)

    -- 单个列表cell 尺寸
    AuctionWorld._itemSize = SL:GetValue("IS_PC_OPER_MODE") and { width = 505, height = 70 } or
        { width = 605, height = 85 }

    -- 职业 全部 战 法 道
    AuctionWorld.filterjob = {
        {
            value = 3,
            name  = "全部",
        },
    }
    local jobAble          = SL:GetValue("AUCTION_JOB_ABLE")
    for key, value in pairs(jobAble) do
        if value then
            local job = (key >= 1 and key <= 3) and (key - 1) or key
            table.insert(AuctionWorld.filterjob, { value = job, name = GUIFunction:GetJobNameByID(job) })
        end
    end

    -- 品阶
    AuctionWorld.qualities = SL:CopyData(SL:GetValue("AUCTION_QUALITIES"))
    table.insert(AuctionWorld.qualities, 1, {id = 0, name = "全部"})

    -- 货币
    AuctionWorld.currencies = SL:CopyData(SL:GetValue("AUCTION_CURRENCIES"))
    table.insert(AuctionWorld.currencies, 1, {id = 0, name = "全部"})

    -- 价格
    AuctionWorld.filter_price       = {
        {
            value = 1,
            name  = "价格",
        },
        {
            value = 2,
            name  = "价格",
        },
    }

    -- 一口价开关
    if isFixedPrice then
        -- 竞价1 2   一口价 3 4
        AuctionWorld.filter_price[1].iValue = 3
        AuctionWorld.filter_price[2].iValue = 4
    end

    AuctionWorld._source            = data.data or 0 -- 0.世界拍卖 1.行会拍卖
    AuctionWorld._items             = {}
    AuctionWorld._qCells            = {}

    AuctionWorld._filter1Index      = 1
    AuctionWorld._filter1State      = true
    AuctionWorld._filter1Cells      = {}

    AuctionWorld._filter            = {} -- 筛选 [1]类型  [2]职业(战法道全部0123)  [3]品级  [4]货币(1元宝 2传奇币)  [5]价格(1升序 2降序)
    AuctionWorld._filterJobCell     = nil
    AuctionWorld._filterQualityCell = nil
    AuctionWorld._filterMoneyCell   = nil
    AuctionWorld._filterPriceCell   = nil

    AuctionWorld._IsSearchItem      = nil
    AuctionWorld._itemConfig        = SL:GetValue("STD_ITEMS")

    -- 单职业
    local isSingleJob               = SL:GetValue("GAME_DATA", "isSingleJob")
    if isSingleJob and tonumber(isSingleJob) ~= 0 then
        GUI:setVisible(AuctionWorld._ui.Node_filter_job, false)
    end

    local status = true
    local function listviewEvent(_, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(AuctionWorld._ui.ListView_items)
            local itemHei = AuctionWorld._itemSize and AuctionWorld._itemSize.height or 80
            local count = #(GUI:getChildren(AuctionWorld._ui.ListView_items))
            local realHei = count * itemHei + (count - 1) * GUI:ListView_getItemsMargin(AuctionWorld._ui.ListView_items)
            local contentSize = GUI:getContentSize(AuctionWorld._ui.ListView_items)
            if innerPos.y == 0 then
                if false == SL:GetValue("AUCTION_IS_COMPLETE") and status then
                    status = false
                    SL:scheduleOnce(AuctionWorld._ui.ListView_items, function()
                        status = true
                    end, 0.5)

                    if realHei < contentSize.height then
                        return
                    end
                    SL:scheduleOnce(AuctionWorld._ui.ListView_items, function()
                        AuctionWorld.PullItemList()
                    end, 0.01)
                end
            end
        end
    end
    GUI:ListView_addOnScrollEvent(AuctionWorld._ui.ListView_items, listviewEvent)
    GUI:ListView_addMouseScrollPercent(AuctionWorld._ui.ListView_items)

    AuctionWorld.InitFilter()
    AuctionWorld.ClearItemList()
    AuctionWorld.PullItemList()

    AuctionWorld.RegisterEvent()

    -- 自定义组件挂接
    SL:AttachTXTSUI({
        root  = AuctionWorld._ui.Panel_1,
        index = AuctionWorld._source == 0 and SLDefine.SUIComponentTable.AuctionWorld or SLDefine.SUIComponentTable.AuctionGuild
    })
end

function AuctionWorld.InitFilter()
    -- 默认
    AuctionWorld._filter[1] = 1 -- 类型
    AuctionWorld._filter[2] = 1 -- 职业
    AuctionWorld._filter[3] = 1 -- 品阶
    AuctionWorld._filter[4] = 1 -- 货币
    AuctionWorld._filter[5] = 1 -- 价格升序降序

    -- 筛选 装备、材料...
    local items             = AuctionData.GetCTypeInGroup()
    for _, v in ipairs(items) do
        local cell = AuctionWorld.CreateFilterGroup1Cell1()
        GUI:ListView_pushBackCustomItem(AuctionWorld._ui.ListView_filter_1, cell.nativeUI)
        AuctionWorld._filter1Cells[v[1].firstlevel] = cell
        GUI:Button_setTitleText(cell.Button_1, v[1].firstlevelname)
        GUI:addOnClickEvent(cell.Button_1, function(sender)
            GUI:delayTouchEnabled(sender)
            if AuctionWorld._filter1Index ~= v[1].firstlevel then
                AuctionWorld._filter1State = true
            elseif AuctionWorld._filter1Index ~= 1 then
                AuctionWorld._filter1State = not AuctionWorld._filter1State
            end

            if AuctionWorld._filter1State then
                if AuctionWorld._filter1Index ~= v[1].firstlevel then
                    AuctionWorld._filter[1] = v[1].id
                    AuctionWorld.ClearItemList()
                    AuctionWorld.PullItemList()
                end
            end
            AuctionWorld.UpdateFilter1()

            AuctionWorld._filter1Index = v[1].firstlevel
        end)
    end

    -- 职业
    AuctionWorld._filterJobCell = AuctionWorld.CreateFilterCell1()
    GUI:addChild(AuctionWorld._ui.Node_filter_job, AuctionWorld._filterJobCell.nativeUI)
    GUI:setVisible(AuctionWorld._filterJobCell.Image_arrow, false)
    GUI:addOnClickEvent(AuctionWorld._filterJobCell.nativeUI, function()
        AuctionWorld.ShowFilterItems(1)
    end)

    -- 品级
    AuctionWorld._filterQualityCell = AuctionWorld.CreateFilterCell1()
    GUI:addChild(AuctionWorld._ui.Node_filter_quality, AuctionWorld._filterQualityCell.nativeUI)
    GUI:setVisible(AuctionWorld._filterQualityCell.Image_arrow, false)
    GUI:addOnClickEvent(AuctionWorld._filterQualityCell.nativeUI, function()
        AuctionWorld.ShowFilterItems(2)
    end)

    -- 货币
    AuctionWorld._filterMoneyCell = AuctionWorld.CreateFilterCell1()
    GUI:addChild(AuctionWorld._ui.Node_filter_money, AuctionWorld._filterMoneyCell.nativeUI)
    GUI:setVisible(AuctionWorld._filterMoneyCell.Image_arrow, false)
    GUI:addOnClickEvent(AuctionWorld._filterMoneyCell.nativeUI, function()
        AuctionWorld.ShowFilterItems(3)
    end)

    -- 价格
    AuctionWorld._filterPriceCell = AuctionWorld.CreateFilterCell1()
    GUI:addChild(AuctionWorld._ui.Node_filter_price, AuctionWorld._filterPriceCell.nativeUI)
    GUI:addOnClickEvent(AuctionWorld._filterPriceCell.nativeUI, function()
        AuctionWorld.ShowFilterItems(4)
    end)

    -- 隐藏筛选
    AuctionWorld.HideFilterItems()
    GUI:addOnClickEvent(AuctionWorld._ui.Panel_hide_filter, function()
        AuctionWorld.HideFilterItems()
    end)

    AuctionWorld.UpdateFilter1()
    AuctionWorld.UpdateFilter2()
end

function AuctionWorld.HideFilterItems()
    GUI:setVisible(AuctionWorld._ui.Image_filter_bg, false)
    GUI:setVisible(AuctionWorld._ui.Panel_hide_filter, false)
    GUI:ListView_removeAllItems(AuctionWorld._ui.ListView_filter_3)

    GUI:setFlippedY(AuctionWorld._filterJobCell.Image_pull, false)
    GUI:setFlippedY(AuctionWorld._filterQualityCell.Image_pull, false)
    GUI:setFlippedY(AuctionWorld._filterMoneyCell.Image_pull, false)
    GUI:setFlippedY(AuctionWorld._filterPriceCell.Image_pull, false)
end

function AuctionWorld.CreateFilterCell1(data)
    local root = GUI:Node_Create(-1, "root", 0, 0)
    AuctionWorld.CreateFilterCell(root)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = ui_delegate(layout)

    return ui
end

function AuctionWorld.CreateFilterGroup1Cell1(data)
    local root = GUI:Node_Create(-1, "root", 0, 0)
    AuctionWorld.CreateFilterGroup1Cell(root)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = ui_delegate(layout)

    return ui
end

function AuctionWorld.CreateFilterGroup2Cell1(data)
    local root = GUI:Node_Create(-1, "root", 0, 0)
    AuctionWorld.CreateFilterGroup2Cell(root)
    local layout = GUI:getChildByName(root, "Panel_1")
    GUI:removeFromParent(layout)
    local ui = ui_delegate(layout)

    return ui
end

function AuctionWorld.ClearItemList()
    SL:AuctionClear()
end

function AuctionWorld.PullItemList()
    local quality   = AuctionWorld.qualities[AuctionWorld._filter[3]].id
    local currency  = AuctionWorld.currencies[AuctionWorld._filter[4]].id
    local job       = AuctionWorld.filterjob[AuctionWorld._filter[2]].value
    local stdmode   = AuctionData.GetStdModeByID(AuctionWorld._filter[1])
    local filterSrv = {
        src = AuctionWorld._source,
        f1  = stdmode,
        f2  = job,
        f3  = quality,
        f4  = currency,
        f5  = AuctionWorld._filter[5],
    }

    local priceFilter = AuctionWorld.filter_price[AuctionWorld._filter[5]]
    if priceFilter and priceFilter.iValue then
        filterSrv.f5 = priceFilter.iValue
    end

    if AuctionWorld._filter[1] == 1 and AuctionWorld._source == 0 then
        filterSrv.f6 = AuctionWorld._IsSearchItem
    else
        AuctionWorld._IsSearchItem = nil
    end

    UIOperator:OpenLoadingBarUI(3)
    SL:RequestItemList(filterSrv)
end

function AuctionWorld.ShowFilterItems(index)
    local itemH = nil
    local filterBgPosX = 0
    local filter_bg = AuctionWorld._ui.Image_filter_bg
    local ListView_filter = AuctionWorld._ui.ListView_filter_3
    GUI:setVisible(filter_bg, true)
    GUI:ListView_removeAllItems(ListView_filter)
    GUI:setVisible(AuctionWorld._ui.Panel_hide_filter, true)

    local cells = {}
    local items = {}

    if index == 1 then
        items = AuctionWorld.filterjob
        GUI:setFlippedY(AuctionWorld._filterJobCell.Image_pull, true)
        filterBgPosX = GUI:getPositionX(AuctionWorld._ui.Node_filter_job)
    elseif index == 2 then
        items = AuctionWorld.qualities
        GUI:setFlippedY(AuctionWorld._filterQualityCell.Image_pull, true)
        filterBgPosX = GUI:getPositionX(AuctionWorld._ui.Node_filter_quality)
    elseif index == 3 then
        items = AuctionWorld.currencies
        GUI:setFlippedY(AuctionWorld._filterMoneyCell.Image_pull, true)
        filterBgPosX = GUI:getPositionX(AuctionWorld._ui.Node_filter_money)
    elseif index == 4 then
        items = AuctionWorld.filter_price
        GUI:setFlippedY(AuctionWorld._filterPriceCell.Image_pull, true)
        filterBgPosX = GUI:getPositionX(AuctionWorld._ui.Node_filter_price)
    end

    for i, v in ipairs(items) do
        local cell = AuctionWorld.CreateFilterCell1()
        table.insert(cells, cell)

        if not itemH then
            itemH = GUI:getContentSize(cell.nativeUI).height
        end

        GUI:Text_setString(cell.Text_1, v.name)
        GUI:setVisible(cell.Image_pull, false)
        GUI:setVisible(cell.Image_arrow, index == 4)
        GUI:Image_loadTexture(cell.Image_arrow,
            v.value == 1 and AuctionWorld.FilterPriceArrowUp or AuctionWorld.FilterPriceArrowDown)

        GUI:addOnClickEvent(cell.nativeUI, function(sender)
            GUI:delayTouchEnabled(sender)
            AuctionWorld._filter[index + 1] = i

            AuctionWorld.UpdateFilter2()
            AuctionWorld.HideFilterItems()

            AuctionWorld.ClearItemList()
            AuctionWorld.PullItemList()
        end)
    end

    local itemWid = GUI:getContentSize(ListView_filter).width
    local height  = math.min(#cells, AuctionWorld.MaxFilterCells) * (itemH or 32)
    GUI:setPositionX(filter_bg, filterBgPosX)
    GUI:setContentSize(filter_bg, itemWid + 5, height + 5)
    GUI:setContentSize(ListView_filter, itemWid, height)
    for i, v in ipairs(cells) do
        GUI:ListView_pushBackCustomItem(ListView_filter, v.nativeUI)
    end
    GUI:setTouchEnabled(ListView_filter, false)
end

function AuctionWorld.UpdateFilter1()
    -- 组1
    for i, v in ipairs(AuctionWorld._filter1Cells) do
        local config = AuctionData.GetCTypeByID(AuctionWorld._filter[1])
        local status = (i == config.firstlevel and AuctionWorld._filter1State)
        GUI:Button_setBright(v.Button_1, status)
        local titleColor = ConvertHexStrToColor3B(status and AuctionWorld.Group1CellColorSel or
            AuctionWorld.Group1CellColorNormal)
        GUI:Button_setTitleColor(v.Button_1, titleColor)
    end
    -- 组2
    if AuctionWorld._filter1State then
        local config = AuctionData.GetCTypeByID(AuctionWorld._filter[1])
        local items = AuctionData.GetCTypeItemsByGroup(config.firstlevel)

        -- rmv
        local ListView_filter_1 = AuctionWorld._ui.ListView_filter_1
        local child = GUI:getChildByName(ListView_filter_1, "listview")
        if child then
            GUI:ListView_removeChild(ListView_filter_1, child)
        end

        if #items > 0 then
            local listview = GUI:ListView_Create(-1, "listview", 0, 0, 0, 0, 1)
            GUI:ListView_setGravity(listview, 5)
            GUI:setAnchorPoint(listview, 0.50, 0.50)
            GUI:ListView_addMouseScrollPercent(listview)
            GUI:setTag(listview, 300)
            GUI:ListView_insertCustomItem(ListView_filter_1, listview, config.firstlevel)

            local cells = {}
            local jumpIndex = 0
            local itemSize = nil
            for i, v in ipairs(items) do
                local selected = (v.secondlevel == config.secondlevel)
                jumpIndex      = (selected and i or jumpIndex)

                local cell     = AuctionWorld.CreateFilterGroup2Cell1()
                GUI:ListView_pushBackCustomItem(listview, cell.nativeUI)
                table.insert(cells, cell)
                GUI:Text_setString(cell.Text_name, v.secondlevelname)
                GUI:setVisible(cell.Image_1, selected)
                GUI:setVisible(cell.Image_2, selected)

                GUI:addOnClickEvent(cell.nativeUI, function()
                    AuctionWorld._filter[1] = v.id
                    local tconfig = AuctionData.GetCTypeByID(AuctionWorld._filter[1])
                    for k, vcell in pairs(cells) do
                        GUI:setVisible(vcell.Image_1, items[k].secondlevel == tconfig.secondlevel)
                        GUI:setVisible(vcell.Image_2, items[k].secondlevel == tconfig.secondlevel)
                    end

                    -- pull list
                    AuctionWorld.ClearItemList()
                    AuctionWorld.PullItemList()
                end)

                if not itemSize then
                    itemSize = GUI:getContentSize(cell.nativeUI)
                end
            end
            local listWid = GUI:getContentSize(ListView_filter_1).width
            local listHei = math.min(itemSize.height * #items, 187)
            GUI:setContentSize(listview, listWid, listHei)

            jumpIndex = jumpIndex - 1
            GUI:ListView_jumpToItem(listview, jumpIndex)
        end
    else
        -- rmv
        local child = GUI:getChildByName(AuctionWorld._ui.ListView_filter_1, "listview")
        if child then
            GUI:ListView_removeChild(AuctionWorld._ui.ListView_filter_1, child)
        end
    end
end

function AuctionWorld.UpdateFilter2()
    -- 职业
    local item = AuctionWorld.filterjob[AuctionWorld._filter[2]]
    GUI:Text_setString(AuctionWorld._filterJobCell.Text_1, item and item.name)

    -- 品质
    local item = AuctionWorld.qualities[AuctionWorld._filter[3]]
    GUI:Text_setString(AuctionWorld._filterQualityCell.Text_1, item and item.name)

    -- 货币
    local item = AuctionWorld.currencies[AuctionWorld._filter[4]]
    GUI:Text_setString(AuctionWorld._filterMoneyCell.Text_1, item and item.name)

    -- 价格
    local item = AuctionWorld.filter_price[AuctionWorld._filter[5]]
    GUI:Text_setString(AuctionWorld._filterPriceCell.Text_1, item and item.name)
    local path = AuctionWorld._filter[5] == 1 and AuctionWorld.FilterPriceArrowUp or AuctionWorld.FilterPriceArrowDown
    AuctionWorld._filterPriceCell.Image_arrow:loadTexture(path)
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
    local status = SL:GetValue("AUCTION_ITEM_STATE", item)
    if status == 3 then
        SL:Print("auction_error_timeout", string.format("MakeIndex=%s  Index=%s", item.item.MakeIndex, item.item.Index))
        return false
    end

    -- 拍卖成功/流拍
    if item.btFlag ~= 0 then
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
                local quickCell = GUI:QuickCell_Create(AuctionWorld._ui.ListView_items, "item_" .. item.item.MakeIndex, 0, 0,
                    wid, hei, createCell)
                AuctionWorld._qCells[item.item.MakeIndex] = quickCell
                AuctionWorld._items[item.item.MakeIndex] = item
            end
        end
        if lastIndex >= 0 then
            GUI:ListView_jumpToItem(AuctionWorld._ui.ListView_items, lastIndex)
        end
    end
    GUI:setVisible(AuctionWorld._ui.Image_empty, next(AuctionWorld._qCells) == nil)
end

function AuctionWorld.OnAuctionItemDel(item)
    if not item or not item.item.MakeIndex then
        return
    end

    if nil == AuctionWorld._qCells[item.item.MakeIndex] then
        return
    end

    local cell = AuctionWorld._qCells[item.item.MakeIndex]
    local innerPos = GUI:ListView_getInnerContainerPosition(AuctionWorld._ui.ListView_items)
    local index = GUI:ListView_getItemIndex(AuctionWorld._ui.ListView_items, cell)
    GUI:ListView_removeItemByIndex(AuctionWorld._ui.ListView_items, index)
    GUI:ListView_doLayout(AuctionWorld._ui.ListView_items)
    innerPos.y = innerPos.y + AuctionWorld._itemSize.height
    innerPos.y = math.min(0, innerPos.y)
    GUI:ListView_setInnerContainerPosition(AuctionWorld._ui.ListView_items, innerPos)

    AuctionWorld._qCells[item.item.MakeIndex] = nil
    AuctionWorld._items[item.item.MakeIndex] = nil

    GUI:setVisible(AuctionWorld._ui.Image_empty, next(AuctionWorld._qCells) == nil)
end

function AuctionWorld.OnAuctionItemChange(item)
    if not item or not item.item.MakeIndex then
        return
    end

    if nil == AuctionWorld._qCells[item.item.MakeIndex] then
        return
    end

    -- 流拍/拍卖成功需要删除
    if checkItemShowble(item) then
        AuctionWorld._items[item.item.MakeIndex] = item
        GUI:QuickCell_Exit(AuctionWorld._qCells[item.item.MakeIndex])
        GUI:QuickCell_Refresh(AuctionWorld._qCells[item.item.MakeIndex])
    else
        AuctionWorld.OnAuctionItemDel(item)
    end
end

-- 左侧列表 一级标签
function AuctionWorld.CreateFilterGroup1Cell(parent)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_filter_group1_cell" or
        "auction/auction_filter_group1_cell")
end

-- 左侧列表 二级标签
function AuctionWorld.CreateFilterGroup2Cell(parent)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_filter_group2_cell" or
        "auction/auction_filter_group2_cell")
end

-- 底部筛选 cell
function AuctionWorld.CreateFilterCell(parent)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_filter_cell" or "auction/auction_filter_cell")
end

-- 筛选结果 cell
function AuctionWorld.CreateItemCell(parent, item)
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_world_cell" or "auction/auction_world_cell")

    local ui           = GUI:ui_delegate(parent)
    local cell         = GUI:getChildByName(parent, "Panel_1")

    local mainPlayerID = SL:GetValue("USER_ID")
    item               = AuctionWorld._items[item.item.MakeIndex]

    local itemBgSize   = GUI:getContentSize(ui.Image_item)
    local itemShow     = GUI:ItemShow_Create(ui.Image_item, "item", itemBgSize.width / 2, itemBgSize.height / 2, {
        index = item.item.Index,
        itemData = item.item,
        look = true,
        checkPower = true,
        diff = true,
        mouseCheckTimes = 8
    })
    GUI:setAnchorPoint(itemShow, 0.5, 0.5)

    -- 名字
    local color = (item.Color and item.Color > 0) and item.Color
    local colorHex = color and SL:GetHexColorByStyleId(color) or SL:GetValue("ITEM_NAME_COLOR_VALUE", item.item.Index)
    local itemName = SL:GetValue("ITEM_NAME", item.item.Index)
    GUI:Text_setString(ui.Text_name, "")
    local fontSize = GUI:Text_getFontSize(ui.Text_name)
    local scrollText = GUI:ScrollText_Create(ui.Text_name, "scrollText", 0, 0,
        SL:GetValue("IS_PC_OPER_MODE") and 100 or 105, fontSize, colorHex, itemName)
    GUI:ScrollText_setHorizontalAlignment(scrollText, 1)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0, 1)

    -- 我的拍品
    GUI:setVisible(ui.Text_me, item.UserId == mainPlayerID)

    -- 折扣
    if AuctionWorld._source and item.meguildRate then
        GUI:setVisible(ui.Text_rebate, AuctionWorld._source == 1 and item.meguildRate < 100 or false)
        GUI:Text_setString(ui.Text_rebate, string.format("%s折", item.meguildRate / 10))
    else
        GUI:setVisible(ui.Text_rebate, false)
    end

    -- 倒计时
    local function callback()
        local status, remaining = SL:GetValue("AUCTION_ITEM_STATE", item)

        local timeData          = SL:SecondToHMS(remaining)
        local hour              = timeData.h + 24 * timeData.d
        local timeStr           = string.format("%02d:%02d:%02d", hour, timeData.m, timeData.s)
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
        local bidAble = SL:GetValue("AUCTION_CAN_BID", item)
        if bidAble then
            if status == 2 then
                GUI:Button_setTitleColor(ui.Button_bid, "#FFFFFF")
                GUI:setVisible(ui.Text_status, true)

                if item.sCurUser == mainPlayerID then
                    GUI:Text_setString(ui.Text_status, "您目前竞价最高")
                    GUI:Text_setTextColor(ui.Text_status, "#28ef01")
                elseif item.sCurUser ~= mainPlayerID and item.joinuser == 1 then
                    GUI:Text_setString(ui.Text_status, "竞价被超过")
                    GUI:Text_setTextColor(ui.Text_status, "#ff0500")
                elseif item.sCurUser ~= "" then
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
        local buyAble = SL:GetValue("AUCTION_CAN_BUY", item)
        if buyAble then
            if status == 2 then
                GUI:Button_setTitleColor(ui.Button_buy, "#FFFFFF")
            else
                GUI:Button_setTitleColor(ui.Button_buy, "#A6A6A6")
            end
        end
    end
    SL:schedule(ui.Text_remaining, callback, 0.5)
    callback()

    -- 竞拍价
    local bidAble = SL:GetValue("AUCTION_CAN_BID", item)
    if bidAble then
        GUI:removeAllChildren(ui.Node_bid_price)
        AuctionWorld.CreatePriceCell(ui.Node_bid_price, { id = item.btType, count = item.nCurPrice })

        GUI:addOnClickEvent(ui.Button_bid, function()
            local status = SL:GetValue("AUCTION_ITEM_STATE", item)
            if status == 2 then
                if item.sCurUser == mainPlayerID then
                    SL:ShowSystemTips("无法连续出价")
                else
                    UIOperator:OpenAuctionBidUI(item)
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
    local buyAble = SL:GetValue("AUCTION_CAN_BUY", item)
    if buyAble then
        GUI:removeAllChildren(ui.Node_price)
        AuctionWorld.CreatePriceCell(ui.Node_price, { id = item.btType, count = item.nLastPrice })

        GUI:addOnClickEvent(ui.Button_buy, function()
            local status = SL:GetValue("AUCTION_ITEM_STATE", item)
            if status == 2 then
                UIOperator:OpenAuctionBuyUI(item)
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
    GUI:LoadExport(parent,
        SL:GetValue("IS_PC_OPER_MODE") and "auction_win32/auction_price_cell" or "auction/auction_price_cell")

    local ui = GUI:ui_delegate(parent)

    local fixPrice = GUIFunction:FixAuctionPrice(data.count, true)
    GUI:Text_setString(ui.Text_count, fixPrice)

    local item = GUI:ItemShow_Create(ui.Node_item, "item", 0, 0, { index = data.id, look = true, mouseCheckTimes = 8 })
    GUI:setAnchorPoint(item, 0.5, 0.5)
    GUI:setScale(item, 0.7)
end

function AuctionWorld.OnAuctionItemListResp(data)
    local items = data.items

    if data.source ~= AuctionWorld._source then
        return
    end
    AuctionWorld.OnPullItemList(items)
end

function AuctionWorld.OnAuctionWorldItemDel(data)
    local item = data.item
    AuctionWorld.OnAuctionItemDel(item)
end

function AuctionWorld.OnAuctionWorldItemChange(data)
    local item = data.item
    AuctionWorld.OnAuctionItemChange(item)
end

function AuctionWorld.OnAuctionWorldItemSearchByName(data)
    local matchIndexStr = AuctionWorld.SearchAllItemsByKeyWord(data)
    if not matchIndexStr or string.len(matchIndexStr) == 0 then
        AuctionWorld._IsSearchItem  = nil
    else
        AuctionWorld._IsSearchItem  = matchIndexStr
    end

    AuctionWorld._filter1State = true
    AuctionWorld._filter1Index = 1
    AuctionWorld._filter[1]    = 1         
    AuctionWorld._filter[2]    = 1         
    AuctionWorld._filter[3]    = 1         
    AuctionWorld._filter[4]    = 1         
    AuctionWorld._filter[5]    = 1        
    AuctionWorld.ClearItemList()
    AuctionWorld.PullItemList()

    AuctionWorld.UpdateFilter1()
    AuctionWorld.UpdateFilter2()
end

function AuctionWorld.SearchAllItemsByKeyWord(str)
    if not str or string.len(str) == 0 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end
   
    local matchItems = {}

    local specialR  = {"%[", "%]", "%(","%)","%*"}
    for _, key in ipairs(specialR) do
        str = string.gsub(str, key, "%"..key)
    end
    
    if string.len(str) > 32 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end

    for _, v  in pairs(AuctionWorld._itemConfig) do
        if #matchItems > 36 then
            break
        end
        if string.find(v.Name, str) then
            table.insert(matchItems, v.Index)
        end
    end

    if #matchItems > 35 then
        SL:ShowSystemTips("相似名称过多，请精确搜索内容")
        return nil
    elseif #matchItems == 0 then
        SL:ShowSystemTips("无法匹配，自动显示全部内容")
        return nil
    end

    local matchIndexStr = table.concat(matchItems, ",")
    return matchIndexStr
end

-- 界面关闭回调
function AuctionWorld.OnClose()
    AuctionWorld.UnRegisterEvent()
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.AuctionWorld
    })
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.AuctionGuild
    })
end

function AuctionWorld.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionWorld", AuctionMain.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_PUT_LIST, "AuctionWorld", AuctionWorld.OnAuctionItemListResp)
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_ITEM_LIST_CLEAR, "AuctionWorld", AuctionWorld.OnClearItemList)
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_DEL, "AuctionWorld", AuctionWorld.OnAuctionWorldItemDel)
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_CHANGE, "AuctionWorld", AuctionWorld.OnAuctionWorldItemChange)
    SL:RegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_SEARCH, "AuctionWorld", AuctionWorld.OnAuctionWorldItemSearchByName)
end

function AuctionWorld.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "AuctionWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_PUT_LIST, "AuctionWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_ITEM_LIST_CLEAR, "AuctionWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_DEL, "AuctionWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_CHANGE, "AuctionWorld")
    SL:UnRegisterLUAEvent(LUA_EVENT_AUCTION_WORLD_ITEM_SEARCH, "AuctionWorld")
end

AuctionWorld.main()
