Store = {}

local GetTagImage = function (index)
    if not index then
        return nil
    end

    local tagImage = {
        [1] = "res/private/store_ui/1900020100.png",
        [2] = "res/private/store_ui/1900020103.png",
        [3] = "res/private/store_ui/1900020104.png",
        [4] = "res/private/store_ui/1900020101.png",
        [5] = "res/private/store_ui/1900020105.png",
        [6] = "res/private/store_ui/1900020102.png"
    }

    return tagImage[index]
end

function Store.main(page)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "store/store")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    Store._ui = ui

    Store._showList = ui["ListView"]
    Store._costList = ui["ListViewCost"]

    GUI:removeAllChildren(Store._showList)

    Store._selpage = page or 1
    Store._isFirst = true
    Store._cells = {}

    SL:RegisterLUAEvent(LUA_EVENT_STORE_REFRESH, "Store", Store.UpdateList)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, "Store", Store.UpdateMoney)
    SL:RequestStoreData(Store._selpage)
end

function Store.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_STORE_REFRESH, "Store")
    SL:UnRegisterLUAEvent(LUA_EVENT_MONEYCHANGE, "Store", Store.UpdateMoney)
end

function Store.UpdateList(page)
    if not page or page ~= Store._selpage then
        return false
    end

    local list = Store._showList
    GUI:stopAllActions(list)

    local page = Store._selpage

    -- 上次数据
    local preData = Store._data or {}

    -- 当前数据
    Store._data = SL:GetStoreDataByPage(page) or {}
    
    -- 按sortindex排序
    table.sort(Store._data, function ( a,b )
        return (a and b and a.sortindex and b.sortindex) and a.sortindex < b.sortindex
    end)


    local realRow = math.ceil(#Store._data / 3)
    local lastRow = #GUI:ListView_getItems(list)
    local moveRow = 0

    local isDel = lastRow > realRow
    if isDel then
        GUI:ListView_removeLastItem(list)
        GUI:ListView_setInnerContainerSize(list, GUI:getContentSize(list).width, GUI:ListView_getInnerContainerSize(list).height - 140)

        Store._cells[lastRow] = nil

        moveRow = Store.getPreIndex(preData, Store._data)
        moveRow = moveRow > realRow and realRow or moveRow
    end

    if Store._isFirst then
        local costs = nil
        for k,v in ipairs(Store._data) do
            if SL:CheckCondition(v.condis) then
                costs = costs or {}
                costs[v.CostID] = true
            end
        end
        if costs then
            Store.InitMoneyCell(table.keys(costs))
        end
        Store._isFirst = false
    end

    local isCell = false
    for _, cell in pairs(Store._cells) do
        if cell then
            isCell = true
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end
    end

    if moveRow > 0 then
        GUI:ListView_jumpToItem(list, moveRow)
    end

    if isCell then 
        return false 
    end

    local iRow = math.ceil(#Store._data/3)
    local index = 1
    Store._cells = {}

    local itemLoad = nil
    itemLoad = function(_, initIndex)
        local idx = initIndex and initIndex or index
        if idx < iRow+1 and idx > 0 then
            local quickCell = GUI:QuickCell_Create(list, "cell" .. idx, 0, 0, 730, 140, function (parent) return Store.CreateCell(parent, idx) end)
            Store._cells[idx] = quickCell
            index = index + 1

            if index < 4 then
                performWithDelay(list, itemLoad, 1 / 60)
            elseif not initIndex then
                for showI = index, iRow do
                    itemLoad(nil, showI)
                end
            end
        end
    end
    itemLoad(nil, nil)
end

function Store.getPreIndex(preTable, curTable)
    local idx = 1
    for i,v in ipairs(preTable) do
        local isHaveData = false
        for k,v2 in ipairs(curTable) do
            if v2 and v2.Id == v.Id then
                isHaveData = true
                break
            end
        end
        if isHaveData == false then
            idx = i
            break
        end
    end
    return math.ceil(idx / 3)
end

function Store.refreshItemData(item, data)
    if not data then
        return GUI:setVisible(item, false)
    end

    GUI:ui_IterChilds(item, item)

    local ui_textName      = item["Text_name"]
    local ui_nodeIcon      = item["pIcon"]
    local ui_textCondition = item["Text_condition"]
    local ui_nodePriceNow  = item["pPriceNow"]
    local ui_nodePrice     = item["pPrice"]
    local ui_image_tag     = item["ImageTag"]

    GUI:removeAllChildren(ui_nodePriceNow)
    GUI:removeAllChildren(ui_nodePrice)
    GUI:removeAllChildren(ui_nodeIcon)

    local imageName = GetTagImage(data.ShowLable)
    if imageName then
        GUI:Image_loadTexture(ui_image_tag, imageName)
        GUI:setVisible(ui_image_tag, true)
    else
        GUI:setVisible(ui_image_tag, false)
    end

    if data.Name then
        GUI:Text_setString(ui_textName, data.Name)
    end

    if data.Color then
        GUI:Text_setTextColor(ui_textName, SL:GetColorByID(data.Color))
    end

    if data.Id and data.Look then
        local goodsItem = GUI:ItemShow_Create(-1, "item", 0, 0, {index = data.Id, look = true, checkPower = true})
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
        GUI:addChild(ui_nodeIcon, goodsItem)
    end

    local limitCount = data.LimitCount or 0
    local limitType  = data.LimitType
    local isLimit    = false
    local isBuyMax   = false

    if limitCount > 0 and limitType then
        local buyCount = data.BuyCount or 0
        isBuyMax = buyCount >= limitCount and true or isBuyMax

        local limitTypes = {
            [1] = "今日限购",
            [2] = "每周限购",
            [3] = "永久限购"
        }
        
        local str = isBuyMax and "售罄" or string.format("%s: %s/%s", limitTypes[limitType], limitCount - buyCount, limitCount)
        if not isBuyMax then
            GUI:Text_setTextColor(ui_textName, "#F2E7CE")
            GUI:Text_setFontSize(ui_textCondition, 16)
        end
        
        isLimit = true
        GUI:Text_setString(ui_textCondition, str or "")
    else
        GUI:Text_setString(ui_textCondition, "")
    end

    local nowPrice = data.NowPrice or 0
    local price    = data.Price or 0
    local isLack   = Store.IsLackMoney(data)

    -- 现价
    if nowPrice > 0 then
        local info = {
            abbr = true, pointBit = 2, titleText = "现价:", enbaled = true
        }
        local priceCell = GUI:CreateCostItemCell(string.format("%s#%s", data.CostID, nowPrice), info)
        GUI:setAnchorPoint(priceCell, 0, 0.5)
        GUI:addChild(ui_nodePriceNow, priceCell)
    end

    -- 原价
    if isLimit == false and price > 0 then
        local info = {
            abbr = true, pointBit = 2, titleText = nowPrice > 0 and "原价:" or "现价:", enbaled = true, cutLineData = nowPrice > 0 and {} or nil
        }
        local priceCell = GUI:CreateCostItemCell(string.format("%s#%s", data.CostID, price), info)
        GUI:setAnchorPoint(priceCell, 0, 0.5)
        GUI:addChild(ui_nodePrice, priceCell)
    end

    -- 只有现价标签是文本居中显示
    local posY = (price < 1 and isLimit == false) and 55 or 40
    GUI:setPositionY(ui_nodePriceNow, posY)

    GUI:addOnClickEvent(item, function ()
        if isBuyMax then
            return false
        end
        SL:OpenStoreBuyPop(data)
    end)

    GUI:setVisible(item, true)
end

function Store.CreateCell(parent, i)
    GUI:LoadExport(parent, "store/store_cell")
    local item = GUI:getChildByName(parent, "Cell")
    Store.refreshItemData(GUI:getChildByName(item, "Image_1"), Store._data[i*3-2])
    Store.refreshItemData(GUI:getChildByName(item, "Image_2"), Store._data[i*3-1])
    Store.refreshItemData(GUI:getChildByName(item, "Image_3"), Store._data[i*3])
    return item
end

function Store.InitMoneyCell(costs)
    local cell = Store._ui["CostCell"]
    local list = Store._costList

    GUI:ListView_removeAllItems(list)

    table.sort(costs, function(a, b) return a and b and a < b end)

    for _, moneyID in ipairs(costs) do
        if moneyID then
            local ui = GUI:Clone(cell)
            GUI:ListView_pushBackCustomItem(list, ui)

            GUI:ui_IterChilds(ui, ui)

            GUI:setTag(ui, moneyID)

            -- count
            local count = SL:GetItemNumberByIndex(moneyID)
            GUI:Text_setString(ui["Text_num"], count)

            -- pic
            GUI:removeAllChildren(ui["pIcon"])
            local goodsItem = GUI:ItemShow_Create(ui["pIcon"], moneyID, 0, 0, {index = moneyID, scale = 0.7})
            GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

            GUI:setVisible(ui, true)
        end
    end
end

-- 是否缺少货币
function Store.IsLackMoney(data)
    local SurPrice = data.NowPrice > 0 and data.NowPrice or data.Price
    local ArrConstID = data.ArrConstID
    if ArrConstID then
        for _, CostID in ipairs(ArrConstID) do
            if SurPrice <= 0 then
                break
            end
            local num = SL:GetItemNumberByIndex(CostID, true)
            SurPrice = SurPrice - num
        end
    else
        local num = SL:GetItemNumberByIndex(data.CostID, true)
        SurPrice = SurPrice - num
    end
    return SurPrice > 0
end

function Store.UpdateMoney(data)
    if not data or not data.id then
        return false
    end

    local id = tonumber(data.id) or 0
    if id < 1 then
        return false
    end

    local item = GUI:getChildByTag(Store._costList, id)
    if not item then
        return false
    end

    local count = SL:GetItemNumberByIndex(id)
    GUI:Text_setString(GUI:getChildByName(item, "Text_num"), count)
end