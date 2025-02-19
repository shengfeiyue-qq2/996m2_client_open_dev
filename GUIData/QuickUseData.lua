
QuickUseData = QuickUseData or  {}

--数据全部来自背包
function QuickUseData.Init()
    QuickUseData._ItemBelongType = GUIDefine.ItemBelong.QUICKUSE 
    QuickUseData._quickUseData = {}  --具体数据 key:pos v:itemData
    QuickUseData._quickUseList = {}  --初始化的时候读取本地列表用
    QuickUseData._quickUseSize = SLDefine.QUICK_USE_SIZE
    QuickUseData._quickUsableList = nil
    QuickUseData.InitQuickUseHistoryData()
end

function QuickUseData.InitQuickUseHistoryData()
    QuickUseData._quickUseList = QuickUseData.GetQuickUsePosMarkData() 
    QuickUseData._quickUsableList = SL:GetValue("CAN_USE_ITEMS_ON_QUICK")
end

function QuickUseData.SetHistoryQuickyUseList(list)
    QuickUseData._quickUseList = list
end

function QuickUseData.CheckIsInQuickUseList(item)
    if item and item.MakeIndex then
        for k, v in pairs(QuickUseData._quickUseList) do
            if v == item.MakeIndex then
                return k
            end
        end
    end
    return false
end

function QuickUseData.AutoAddBagItemToQuick(item, pos)
    if not item or next(item) == nil or not pos then
        return
    end
    local posData = QuickUseData.GetQuickUseDataByPos(pos)
    if posData then
        return
    end
    local autoAddItemMakeIndex = nil
    local itemIndex = item.Index
    local itemData = nil
    local sameItems = BagData.GetItemDataByItemIndex(itemIndex)
    if sameItems and next(sameItems) then
        itemData = sameItems[1]
        autoAddItemMakeIndex = itemData.MakeIndex
    end
    if itemData and autoAddItemMakeIndex and autoAddItemMakeIndex ~= 0 then
        BagData.DelItemData(itemData)
        QuickUseData.SetQuickUsePosData(pos, itemData)
    end
end

function QuickUseData.CheckQuickUseHasEmpty()
    local size = QuickUseData._quickUseSize or 6
    for i = 1, size do
        if not QuickUseData._quickUseList[i] then
            return i
        end
    end
    return false
end

function QuickUseData.CheckItemCanAddToQuickUse(itemData)
    if not itemData or not next(itemData) then
        return false
    end
    local itemStdMode = itemData.StdMode
    if itemStdMode and QuickUseData._quickUsableList[itemStdMode] then
        return true
    end
    return false
end

function QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
    if not makeIndex then
        return false
    end
    local size = QuickUseData._quickUseSize or 6
    for i = 1, size do
        if QuickUseData._quickUseList[i] and QuickUseData._quickUseList[i] == makeIndex then
            return i
        end
    end
    return false
end

function QuickUseData.GetItemCountByIndex(Index)
    local itemList = 0
    if not Index then
        return itemList
    end
    for k, v in pairs(QuickUseData._quickUseData) do
        if v.Index == Index then
            local count = v.OverLap and v.OverLap or 1
            itemList = itemList + count
        end
    end
    return itemList
end

function QuickUseData.GetQuickUseDataByMakeIndex(makeIndex)
    if not makeIndex then
        return false
    end
    for k, v in pairs(QuickUseData._quickUseData) do
        if v.MakeIndex == makeIndex then
            return v
        end
    end
    return false
end

function QuickUseData.GetQuickUseDataByPos(position)
    if not position then
        return false
    end
    return QuickUseData._quickUseData[position]
end

function QuickUseData.GetQuickUseData()
    return QuickUseData._quickUseData
end

function QuickUseData.GetQuickUseLocalList()
    return QuickUseData._quickUseList
end

function QuickUseData.GetQuickUseDataByIndex(index)
    local itemList = {}
    if not index then
        return itemList
    end
    for k, v in pairs(QuickUseData._quickUseData) do
        if v.Index == index then
            table.insert(itemList, v)
        end
    end
    return itemList
end

function QuickUseData.GetQuickUseItemNum(index, famlilar)
    index = index or 0
    local count = 0
    local isBind, bindIndex = SL:CheckItemBind(index)

    local function GetQuickUseNumByIndex(ItemIndex)
        local itemCount = 0
        local itemList = QuickUseData.GetQuickUseDataByIndex(ItemIndex)
        if itemList and next(itemList) then
            for k, v in pairs(itemList) do
                local itemNum = v.OverLap > 0 and v.OverLap or 1
                itemCount = itemCount + itemNum
            end
        end
        return itemCount
    end

    local myCount = GetQuickUseNumByIndex(index)
    local famlilarCount = 0
    if isBind and bindIndex ~= index and famlilar then
        famlilarCount = GetQuickUseNumByIndex(bindIndex)
    end
    local totalCount = myCount + famlilarCount
    return totalCount
end

function QuickUseData.UpdateQuickUseItemData(item)
    if not item then
        return
    end
    local makeIndex = item.MakeIndex
    local pos = QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
    if pos and QuickUseData._quickUseData[pos] then
        local oldNum = QuickUseData._quickUseData[pos].OverLap or 1
        local newNum = item.OverLap or 1
        local changeNum = newNum - oldNum
        if changeNum ~= 0 then
            BagData.ShowGetOrCostItems(changeNum, item.Name)
        end
        QuickUseData._quickUseData[pos] = item
        local msgData = {
            index = pos,
            itemData = item,
            isAdd = changeNum and changeNum > 0 
        }
        SL:onLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, {opera = 3, param = msgData})
    end
end

function QuickUseData.SetQuickUsePosData(pos, data, isDelete)
    QuickUseData._quickUseData[pos] = (not isDelete) and data or nil

    QuickUseData._quickUseList[pos] = (not isDelete) and data.MakeIndex or nil

    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", data.MakeIndex, (not isDelete) and QuickUseData._ItemBelongType or nil)

    QuickUseData.SaveQuickPosData()

    local msgData = {
        index = pos,
        itemData = data
    }
    SL:onLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, {opera = isDelete and 2 or 1, param = msgData})
end

--快捷栏
function QuickUseData.GetQuickUsePosMarkData()
    local clientData = SL:GetLocalString("quickUsePos")
    if not clientData or clientData == "" then
        return {}
    end
    local lastJsonData = SL:JsonDecode(clientData) or {}
    local res = {}
    for k,v in pairs(lastJsonData) do
        local pos = tonumber(k)
        if pos then 
            res[pos] = v
        end
    end
    return res
end

function QuickUseData.SaveQuickPosData()
    QuickUseData._quickUseList["time"] = os.time()
    local bagPosData = SL:JsonEncode(QuickUseData._quickUseList)
    SL:SetLocalString("quickUsePos", bagPosData)
end

function QuickUseData.GetQuickUseItemTotalCount()
    local size = QuickUseData._quickUseSize or 6
    local count = 0
    for i = 1, size do
        if QuickUseData._quickUseList[i]then
            count = count + 1
        end
    end
    return count
end

function QuickUseData.GetQuickUseItemLeftNum()
    local size = QuickUseData._quickUseSize or 6
    local count = QuickUseData.GetQuickUseItemTotalCount()
    return size - count
end

function QuickUseData.SetQuickUseSize(num)
    if num and tonumber(num) then
        num = math.max(math.min(num, 6), 0)
        QuickUseData._quickUseSize = tonumber(num)
        local bagMaxCount = BagData.GetMaxBagAndQuick()
        if bagMaxCount ~= 0 then
            local maxBag = bagMaxCount + SLDefine.QUICK_USE_SIZE - QuickUseData._quickUseSize
            BagData.SetMaxBag(maxBag)
        end
    end
end

function QuickUseData.GetQuickUseSize(num)
    return QuickUseData._quickUseSize
end

