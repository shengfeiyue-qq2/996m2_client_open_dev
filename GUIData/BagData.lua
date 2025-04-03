BagData = BagData or {}
local tinsert = table.insert
local SaveKey = "_BagPosData_"
local function MAKE_OPER_DATA(item, isHad, number)
    local operator = {}
    operator.item = item
    operator.isHad = isHad
    operator.change = number
    operator.MakeIndex = item.MakeIndex
    return operator
end

function BagData.Init()
    BagData._bagItems            = {}            -- {makeindex = {}}
    BagData._bagItemsCount       = 0
    BagData._bagMax              = SLDefine.MAX_ITEM_NUMBER + SLDefine.QUICK_USE_SIZE  --背包数目加快捷栏
    BagData._bagPos2MakeIndex    = {}           -- {pos = {makeindex}}
    BagData._bagMakeIndex2Pos    = {}           -- {makeindex = pos}
    BagData._bagNoPosItems       = {}           -- {makeindex = {}}
    BagData._itemCountByIndex    = {}           -- {itemCount = Index}
    BagData._isInit              = false
    -------------------------------------------------------
    BagData._curSelPage          = 1            -- 当前选中切页
    BagData._promptData          = nil          -- cfg_game_data的prompt
    BagData._selfDropItems       = {}           -- 自己丢弃的物品
    BagData._onSellRepaire       = nil          -- 正在交易或者修理中物品
    BagData._collimatorMakeIndex = nil          -- 记录背包选中的准星道具
    BagData._reconnect           = false        -- 是否重连

    local posData = BagData.GetPosData()
    if posData then 
        for pos, makeIndex in pairs(posData) do
            BagData.SetBagPosByMakeIndex(makeIndex, pos)
        end
    end
    BagData.RegisterEvent()
end

function BagData.SetMaxBag(maxBag)
    BagData._bagMax = maxBag
end

function BagData.GetMaxBagAndQuick()
    return BagData._bagMax
end

function BagData.GetMaxBag()
    local quickUseSize = QuickUseData.GetQuickUseSize()
    return BagData._bagMax - quickUseSize
end

function BagData.SetCurPage(curPage)
    BagData._curSelPage = curPage
end

function BagData.GetCurPage(curPage)
    return BagData._curSelPage
end

function BagData.GetSelfDropItems()
    return BagData._selfDropItems
end

-- item提示：类似右上角满 获取cfg_game_data表的prompt字段的数据
function BagData.GetPromptGameData()
    if not BagData._promptData then
        BagData._promptData = {}
        local prompt = SL:GetValue("GAME_DATA","prompt")
        if prompt and string.len(prompt) then
            local promptArray = string.split(prompt, "|")
            for _, v in ipairs(promptArray) do
                if v and string.len(v) > 0 then
                    local valueArray = string.split(v, "#")
                    tinsert(BagData._promptData, {
                        resPath = valueArray[1],
                        posX = valueArray[2] and tonumber(valueArray[2]) or nil,
                        posY = valueArray[3] and tonumber(valueArray[3]) or nil,
                        resScale = valueArray[4] and tonumber(valueArray[4]) or nil
                    })
                end
            end
        end
    end

    if SL:GetValue("IS_PC_OPER_MODE") then
        return BagData._promptData[1] or {}
    end

    return BagData._promptData[2] or {}
end

function BagData.SetReconnect(bool)
    BagData._reconnect = bool
end

function BagData.GetBagData()
    return BagData._bagItems
end

function BagData.GetTotalItemCount()
    return BagData._bagItemsCount
end

--获得空位
function BagData.GetEmptyPos()
    for i = 1, BagData.GetMaxBag() do
        if not BagData._bagPos2MakeIndex[i] then 
            return i
        end
    end
    return nil
end

function BagData.isToBeFull(tips)
    local newPos = BagData.GetEmptyPos()
    if tips and not newPos then
        SL:ShowSystemTips("背包已满,请清理背包后尝试")
    end
    return newPos == nil
end

function BagData.CheckNeedSpace(itemID, itemCount, tips)
    local itemData = SL:GetValue("ITEM_DATA", itemID) 
    local isLap = SL:CheckItemOverLap(itemData) 
    local needPos = itemCount
    if isLap then
        needPos = math.ceil(itemCount / itemData.OverLap)
    end
    local bagItemNum = BagData.GetTotalItemCount()
    local maxBag = BagData.GetMaxBag()
    local onTradingNum = SL:GetValue("TRADE_MY_ITEM_NUM")
    local totalBagItemNum = bagItemNum + onTradingNum
    if totalBagItemNum + needPos > maxBag then
        if tips then
            SL:ShowSystemTips("背包空间不足！")
        end
        return false
    end
    return true
end

-- 通过唯一id获取在背包中的切页
function BagData.GetBagPageByMakeIndex(makeIndex)
    local posPage = nil
    makeIndex = makeIndex and tonumber(makeIndex) or nil
    if makeIndex then
        local pos = BagData.GetBagPosByMakeIndex(makeIndex)
        if pos and type(pos) == "number" then
            posPage = math.ceil(pos / SLDefine.MAX_ITEM_NUMBER)
        end
    end
    return posPage
end

-- 通过唯一id获取在背包中的位置 
function BagData.GetBagPosByMakeIndex(makeIndex)
    return BagData._bagMakeIndex2Pos[makeIndex]
end

-- 通过在背包中的位置获取唯一id 
function BagData.GetMakeIndexByBagPos(pos)
    return BagData._bagPos2MakeIndex[pos]
end

function BagData.SetBagPosByMakeIndex(makeIndex, pos)
    if pos then 
        BagData._bagMakeIndex2Pos[makeIndex] = pos 
        BagData._bagPos2MakeIndex[pos] = makeIndex
    else
        local oldPos = BagData._bagMakeIndex2Pos[makeIndex]
        BagData._bagMakeIndex2Pos[makeIndex] = pos
        if oldPos then 
            BagData._bagPos2MakeIndex[oldPos] = nil
        end
    end
    BagData.SavePosData()
end

-- 通过唯一id获取物品数据
function BagData.GetItemDataByMakeIndex(makeIndex)
    return BagData._bagItems[makeIndex]
end

-- 获取背包数据  startPos: 开始的位置   endPos: 结束的位置
function BagData.GetBagDataByBagPos(startPos, endPos)
    local data = {}
    for pos = startPos, endPos do
        local makeIndex = BagData._bagPos2MakeIndex[pos]
        if makeIndex then 
            data[makeIndex] = BagData._bagItems[makeIndex]
        end
    end
    return data
end

-- 修正历史数据与当前数据位置信息
function BagData.AmendHistoryPos(sort, data)
    local items = data or {}
    local newBagPos = {}
    local newQuickPos = {}
    local newItems = {}
    ----------------------------
    for i,item in pairs(items) do
        local makeIndex = item.MakeIndex
        local bagPos = BagData.GetBagPosByMakeIndex(makeIndex)
        if bagPos and not sort then 
            newBagPos[makeIndex] = bagPos
        else
            local quickPos = QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
            if quickPos then 
                newQuickPos[quickPos] = makeIndex
            else
                tinsert(newItems, item)
            end
        end
    end
    -----------------------------
    BagData.CleanBagPosData()
    for makeIndex, pos in pairs(newBagPos) do
        BagData.SetBagPosByMakeIndex(makeIndex, pos)
    end

    if next(newQuickPos) then
        QuickUseData.SetHistoryQuickyUseList(newQuickPos)
    end

    if sort then
        if newItems and next(newItems) and #newItems > 1 then
            table.sort(newItems, function(a, b)
                if a.Index ~= b.Index then
                    return a.Index < b.Index
                else
                    return a.MakeIndex < b.MakeIndex
                end
            end)
        end
    end
    for i, item in pairs(newItems) do
        local makeIndex = item.MakeIndex
        local newPos = BagData.GetEmptyPos()
        if newPos then
            BagData.SetBagPosByMakeIndex(makeIndex, newPos)
        else
            BagData._bagNoPosItems[makeIndex] = item
        end
    end
end

-- 清理背包位置数据
function BagData.CleanBagPosData()
    BagData._bagPos2MakeIndex = {}
    BagData._bagMakeIndex2Pos = {}
end

-- 通过itemIndex获取物品数据
function BagData.GetItemDataByItemIndex(itemIndex)
    local someItems = {}
    if not itemIndex then
        return someItems
    end
    local items = BagData.GetBagData()
    for _, v in pairs(items) do
        if v.Index == itemIndex then
            tinsert(someItems, v)
        end
    end
    return someItems
end

-- 通过物品名称获取物品数据
function BagData.GetItemDataByItemName(itemName)
    if not itemName then
        return nil
    end
    local someItems = {}
    local items = BagData.GetBagData()
    for _, v in pairs(items) do
        if v.Name == itemName then
            tinsert(someItems, v)
        end
    end
    if not next(someItems) then
        return nil
    end
    return someItems
end

-- 通过itemIndex获取物品数量 famlilar是否包含绑定数量
function BagData.GetItemCountByIndex(index, famlilar)
    index = index or 0
    local count = 0
    local isBind, bindIndex = SL:CheckItemBind(index)
    local myCount = BagData._GetItemCountByIndex(index)
    local famlilarCount = 0
    if isBind and bindIndex and bindIndex ~= index and famlilar then
        famlilarCount = BagData._GetItemCountByIndex(bindIndex)
    end
    local totalCount = myCount + famlilarCount
    return totalCount
end

-- 设置正在交易或修理中
function BagData.SetOnSellOrRepaire(makeIndex)
    BagData._onSellRepaire = makeIndex
    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, {makeIndex})
end

-- 获取是否在交易或修理
function BagData.GetOnSellOrRepaire()
    return BagData._onSellRepaire
end

-- 清理交易或修理
function BagData.CleanOnSellOrRepaire()
    local makeIndex = BagData._onSellRepaire
    BagData._onSellRepaire = nil
    
    -- 刷新一遍背包 将隐藏的刷出来
    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, makeIndex and {makeIndex})
end

--背包位置数据
function BagData.GetPosData()
	local clientData = SL:GetLocalString(SaveKey)
    if not clientData or clientData == "" then
        return nil
    end
    local lastJsonData = SL:JsonDecode(clientData)
    local res = {}
    for k,v in pairs(lastJsonData) do
        local pos = tonumber(k)
        if pos then 
            res[pos] = v
        end
    end
    return res
end

function BagData.SavePosData()
    BagData._bagPos2MakeIndex["time"] = os.time()
    local bagPosData = SL:JsonEncode(BagData._bagPos2MakeIndex)
    SL:SetLocalString(SaveKey, bagPosData)
end

-- 添加物品
function BagData.AddItemData(item, noNotice)
    if not item then
        return
    end
    local makeIndex = item.MakeIndex
    local index = item.Index
    local newCount =  item.OverLap or 1
    local itemPos = BagData.GetBagPosByMakeIndex(makeIndex) or BagData.GetEmptyPos()
    if itemPos then
        BagData.SetBagPosByMakeIndex(makeIndex, itemPos)
    else
        BagData._bagNoPosItems[makeIndex] = item
    end

    if not noNotice then
        BagData.ShowGetOrCostItems(newCount, item.Name)
    end

    BagData._bagItems[makeIndex] = item
    BagData._bagItemsCount = BagData._bagItemsCount + 1

    BagData.ChangeItemCountByindex(index, newCount)

    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex, GUIDefine.ItemBelong.BAG)
end

-- 显示获得或消耗物品
function BagData.ShowGetOrCostItems(diff, name)
    if BagData._isInit then
        return
    end

    local nData = {}
    nData.name = name
    nData.num = math.abs(diff)
    if diff > 0  then 
        SL:ShowGetBagItem(nData)
    else
        SL:ShowCostItem(nData)
    end
end

-- 增加物品并通知
function BagData.AddItemDataAndNotice(item)
    BagData.AddItemData(item)

    local operator = {}
    operator.opera = GUIDefine.OperateType.ADD
    operator.operID = {}
    tinsert(operator.operID, MAKE_OPER_DATA(item, false))

    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, operator)
    -- 延迟通知
    BagData.DelayNotifyBagOper()
end

-- 延迟通知，部分系统不需要实时监听背包改变，并且不需要知道背包操作类型，节省性能
function BagData.DelayNotifyBagOper()
    if BagData._delayNotifyTimerID then
        SL:UnSchedule(BagData._delayNotifyTimerID)
        BagData._delayNotifyTimerID = nil
    end

    BagData._delayNotifyTimerID = SL:ScheduleOnce(function()
        SL:BagDataDelayNotice()
    end, 0.5)
end

-- 删除物品
function BagData.DelItemData(data, showTip, noCleanPos, noNotify, isBaitan)
    if not data or not next(data) then
        return
    end

    local makeIndex = data.MakeIndex
    local index = data.Index
    local count = data.OverLap or 1
    local itemHasPos = true
    local noPosData = BagData._bagNoPosItems[makeIndex] 
    local item = BagData.GetItemDataByMakeIndex(makeIndex)

    if noPosData then
        itemHasPos = false
        item = noPosData
    end

    if item then
        if not BagData._isInit then
            UIOperator:CloseAutoUsePopUI(item.MakeIndex)
        end

        local operator = {}
        operator.opera = GUIDefine.OperateType.DEL
        operator.operID = {}
        operator.isBaitan = isBaitan
        local operitem = BagData.BagOperItemByMakeIndex(makeIndex, itemHasPos)
        tinsert(operator.operID, operitem)

        BagData._bagItems[makeIndex] = nil 
        BagData._bagNoPosItems[makeIndex] = nil 
        BagData._bagItemsCount = BagData._bagItemsCount - 1 

        BagData.ChangeItemCountByindex(index, -count)

        if not noCleanPos then
            BagData.SetBagPosByMakeIndex(makeIndex, nil)
        end

        SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", item.MakeIndex, nil)

        if not noNotify then
            SL:onLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, operator)

            -- 延迟通知
            BagData.DelayNotifyBagOper()
        end

        if showTip then
            BagData.ShowGetOrCostItems(-(count or 1), item.Name)
        end

        -- 缓存中的数据自动补充到背包
        if BagData._bagNoPosItems and next(BagData._bagNoPosItems) and itemHasPos then
            for _, v in pairs(BagData._bagNoPosItems) do
                if v and next(v) then
                    BagData.DelItemData(v, nil, nil, true)
                    BagData.AddItemDataAndNotice(v)
                    break
                end
            end
        end

        -- 清理删除红点
        SL:DeleteBagRedDot(makeIndex)
    end
end

function BagData.BagOperItemByMakeIndex(makeIndex, isShowInBag)
    local item = BagData.GetItemDataByMakeIndex(makeIndex)
    if not isShowInBag then
        item = BagData._bagNoPosItems[makeIndex]
    end

    local operator = {}
    if item then
        local makeIndex = item.MakeIndex
        operator.MakeIndex = makeIndex
        operator.item = item
    end
    return operator
end

function BagData.ChangeItemCountByindex(index, diff)
    local count = BagData._GetItemCountByIndex(index)
    count = count + diff
    BagData._SetItemCountByIndex(index, count)
end

function BagData._GetItemCountByIndex(index)
    if not index then
        return 0
    end
    BagData._itemCountByIndex[index] = BagData._itemCountByIndex[index] or 0 
    return BagData._itemCountByIndex[index]
end

function BagData._SetItemCountByIndex(index, count)
    BagData._itemCountByIndex[index] = count 
    if BagData._itemCountByIndex[index] and BagData._itemCountByIndex[index] < 0 then 
        BagData._itemCountByIndex[index] = nil
    end
end

-- 更改物品数据
function BagData.ChangeItemData(item)
    local makeIndex = item.MakeIndex
    local index = item.Index
    local newnum = item.OverLap or 1
    local diff = 0
    local data = BagData.GetItemDataByMakeIndex(makeIndex)
    if data then
        local oldnum = data.OverLap or 1
        diff = newnum - oldnum
        BagData._bagItems[makeIndex] = item
        BagData.ChangeItemCountByindex(index, diff)
        if diff ~= 0 then
            BagData.ShowGetOrCostItems(diff, item.Name)
        end
    end
    return diff
end

-- 清理背包
function BagData.ClearItemData(isReconnect)
    for k,v in pairs(BagData._bagItems) do
        BagData.DelItemData(v, nil, true, isReconnect)
    end
    BagData._bagItems = {}-- {makeindex = {}}
    BagData._bagItemsCount = 0
    BagData._bagMax = SLDefine.MAX_ITEM_NUMBER + SLDefine.QUICK_USE_SIZE
    BagData._bagNoPosItems = {}-- {makeindex = {}}
    BagData._itemCountByIndex = {}
    BagData._isInit = false
end

-- 换位
function BagData.ExchangePos(makeIndex1, pos1, makeIndex2, pos2)
    BagData.SetBagPosByMakeIndex(makeIndex1, pos1)
    BagData.SetBagPosByMakeIndex(makeIndex2, pos2)
    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, {makeIndex1, makeIndex2})
end

-- 修改位置数据
function BagData.SetItemPosData(makeIndex, pos)
    BagData.SetBagPosByMakeIndex(makeIndex, nil)
    BagData.SetBagPosByMakeIndex(makeIndex, pos)
    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, {makeIndex})
end

-- 获取背包道具的使用状态(0：使用 1：使用准星道具 2：取消准星 3：不可使用)
function BagData.GetOnBagItemUseState(data)
    if BagData._collimatorMakeIndex then
        if BagData._collimatorMakeIndex == -1 then -- 脚本
            return 1
        end

        if data and BagData._collimatorMakeIndex == data.MakeIndex then
            return 2
        end

        return 1
    end

    return 0
end

-- 设置准星道具
function BagData.SetBagCollimator(data)
    BagData._collimatorMakeIndex = data
end

-- 获取准星道具
function BagData.GetBagCollimator()
    return BagData._collimatorMakeIndex
end

-- 清理准星道具
function BagData.ClearBagCollimator()
    BagData._collimatorMakeIndex = nil
end
--------------------------------------------------------------------------------------------
----------------------------------------------请求触发
-- 请求背包数据
function BagData.RequestBagData()
    BagData._isInit = true
end

-- 叠加道具
function BagData.RequestItemTwoToOne(data)
    local makeIndex1 = data.MakeIndex1
    local makeIndex2 = data.MakeIndex2
end

-- 拆分道具
function BagData.RequestCountItem(data)
    local makeIndex = data.MakeIndex
    local num = data.num
end

-- 请求准星瞄准消息(使用)
function BagData.RequestCollimator(data)
    local makeIndex = data.MakeIndex
end

-- 请求取消准星瞄准
function BagData.RequestCancelCollimator()
end

-- 请求解锁背包格子
function BagData.RequestUnlockBagSize()
end
--------------------------------------------------------------------------------------------
-- 背包数据初始化
function BagData.ResponseBagItemData(data)
    local data = data.data

    if BagData._isInit then
        BagData.ClearItemData()
    end

    -- 修正本地位置信息数据
    BagData.AmendHistoryPos(false, data)
    
    local operator = {}
    operator.initbool = false
    operator.opera = GUIDefine.OperateType.INIT
    operator.operID = {}

    for _, item in pairs(data) do
        local quickUsePos = QuickUseData.CheckIsInQuickUseList(item)
        if quickUsePos then -- 快捷栏道具
            QuickUseData.SetQuickUsePosData(quickUsePos, item)
        else
            BagData.AddItemData(item, true)
            tinsert(operator.operID, MAKE_OPER_DATA(item, false))
        end
    end

    if not BagData._reconnect then
        SL:onLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, operator)
        SL:onLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, {opera = 0})

        -- 延迟通知
        BagData.DelayNotifyBagOper()
    end

    if BagData._reconnect then 
        BagData._reconnect = false
    end
end

-- 增加道具
function BagData.ResponseAddItem(data)
    local header = data.header 
    local data = data.data
    local recog = header.recog
    if recog == -1 then
        if SL._DEBUG then
            local _ditem = BagData.GetItemDataByMakeIndex(data.MakeIndex)
            if _ditem then
                SL:Print("ERROR BAG ITEM EXIST, CAN'T ADD IT AGAIN", data.MakeIndex)
            end
        end

        local isCanAddToQuick = QuickUseData.CheckItemCanAddToQuickUse(data)
        local quickUsePos = QuickUseData.CheckQuickUseHasEmpty()
        -- 快捷栏道具
        if isCanAddToQuick and quickUsePos then
            BagData.ShowGetOrCostItems(data.OverLap or 1, data.Name)
            QuickUseData.SetQuickUsePosData(quickUsePos, data)
        else
            BagData.AddItemData(data)

            local operator = {}
            operator.opera = GUIDefine.OperateType.ADD
            operator.operID = {}
            tinsert(operator.operID, MAKE_OPER_DATA(data, false))
            SL:onLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, operator)

            -- 延迟通知
            BagData.DelayNotifyBagOper()
        end

    else
        data.Where = recog
        EquipData.AddEquipData(data)
    end
end

-- 删除道具
function BagData.ResponseDelItem(data)
    local header = data.header
    local makeIndex = header.Guid
    local itemBelong =  SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex) 
    if not itemBelong then
        SL:Print("delete item error, can't find item belong")
        return
    end

    if itemBelong == GUIDefine.ItemBelong.BAG then
        local itemData = BagData.GetItemDataByMakeIndex(makeIndex)
        if not itemData then
            SL:Print("delete item error, can't find item")
            return
        end
        BagData.DelItemData(itemData, true)
    elseif itemBelong == GUIDefine.ItemBelong.EQUIP then
        local itemData = EquipData.GetEquipDataByMakeIndex( makeIndex)
        if not itemData then
            SL:Print("delete item error, can't find item")
            return
        end
        EquipData.DelEquipData(itemData)

    elseif itemBelong == GUIDefine.ItemBelong.QUICKUSE then
        local itemData = QuickUseData.GetQuickUseDataByMakeIndex(makeIndex)
        if not itemData then
            SL:Print("delete item error, can't find item")
            return
        end

        BagData.ShowGetOrCostItems(-(itemData.OverLap or 1), itemData.Name)

        -- 自动补充
        local pos = QuickUseData.GetQuickUsePosByMakeIndex(itemData.MakeIndex)
        QuickUseData.SetQuickUsePosData(pos, itemData, true)
        local function delayAutoAddd()
            QuickUseData.AutoAddBagItemToQuick(itemData, pos)
        end
        SL:ScheduleOnce(delayAutoAddd, 0.5)

    elseif itemBelong == GUIDefine.ItemBelong.STALL then
        local item = SL:StallRmvMySellItem(makeIndex)
        SL:onLUAEvent(LUA_EVENT_STALL_SELF_ITEM_CHANGE, item)

    elseif itemBelong == GUIDefine.ItemBelong.STORAGE then
        local item = SL:GetValue("STORAGE_DATA_BY_MAKEINDEX", makeIndex)
        if not item then
            SL:Print("delete item error, can't find item")
            return
        end
        SL:DeleteStorageData(item)
    end
end



-- 更新道具
function BagData.ResponseUpdateItem(data)
    local data = data.data
    local itemMakeIndex = data.MakeIndex
    local itemBelong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX" ,itemMakeIndex)
    if not itemBelong then
        return
    end
    if GUIDefine.ItemBelong.BAG == itemBelong then
        local operator = {}
        operator.opera = GUIDefine.OperateType.CHANGE
        operator.operID = {}
        local diff = BagData.ChangeItemData(data)
        tinsert(operator.operID, MAKE_OPER_DATA(data, true, diff))
        SL:onLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, operator)

        -- 延迟通知
        BagData.DelayNotifyBagOper()

    elseif GUIDefine.ItemBelong.EQUIP == itemBelong then
        EquipData.ChangeEquipData(data, true, true)

    elseif itemBelong == GUIDefine.ItemBelong.QUICKUSE then
        QuickUseData.UpdateQuickUseItemData(data)

    elseif itemBelong == GUIDefine.ItemBelong.STORAGE then
        SL:UpdateStorageData(data)
    end

    -- for item update.
    local updateData = {
        from = itemBelong,
        item = data
    }
    SL:ItemUpdateNotice(updateData)
end

function BagData.ResponseUseSuccess(data) 
    local header = data.header
    local ItemIndex = header.recog
end

-- 道具使用失败
function BagData.ResponseUseItemFail(data) 
    local header = data.header
    SL:Print("道具使用失败消息")
    local makeIndex = header.recog
    local itemData = BagData.GetItemDataByMakeIndex(makeIndex)
    if itemData and itemData.StdMode == 49 then
        -- 49类型道具使用失败提醒 0关闭  非0开启
        if SL:GetValue("GAME_DATA","Pearl_on_off") ~= 0 then
            SL:ShowSystemTips("条件不满足")
        end
    end
end

-- 道具拾取失败 -1背包满 -2负重满 -3物品禁止拾取 
function BagData.ResponseGetItemFail(data)
    local header = data.header
    local recog = header.recog
    if recog == -1 then
        SL:ShowSystemTips("背包已满,请清理背包后尝试")
    elseif recog == -2 then
        SL:ShowSystemTips("负重已达上限，无法拾取！")
    elseif recog == -3 then
        SL:ShowSystemTips("物品禁止拾取")
    end
end

-- 丢弃道具成功
function BagData.ResponseDropSuccess(data)
    local header = data.header
    local makeIndex = header.Guid
    if makeIndex then
        tinsert(BagData._selfDropItems, makeIndex)
        if #BagData._selfDropItems > 100 then -- 记录自己丢弃的物品   挂机拾取的时候忽略
            table.remove(BagData._selfDropItems, 1)
        end
        
        local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
        if GUIDefine.ItemBelong.BAG == belong then
            -- 背包中的重新刷出来
            local data = {
                dropping = {
                    MakeIndex = makeIndex,
                    state = 1
                }
            }
            SL:onLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, data)

        elseif GUIDefine.ItemBelong.QUICKUSE == belong then
            local itemPos = QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
            local data = {
                pos = itemPos,
                state = 1
            }
            SL:onLUAEvent(LUA_EVENT_QUICKUSE_ITEM_REFRESH, data)
        end
    end

    SL:ClearAutoMining()
end

-- 丢弃道具失败
function BagData.ResponseDropFail(data)
    local header = data.header
    local makeIndex = header.Guid
    local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
    if GUIDefine.ItemBelong.BAG == belong then
        -- 背包中的重新刷出来
        local data = {
            dropping = {
                MakeIndex = makeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, data)

    elseif GUIDefine.ItemBelong.QUICKUSE == belong then
        local itemPos = QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
        local data = {
            pos = itemPos,
            state = 1
        }
        SL:onLUAEvent(LUA_EVENT_QUICKUSE_ITEM_REFRESH, data)
    end
end

-- 移动到英雄背包失败
function BagData.ResponseItemToHeroBagFail(data)
    local header = data.header
    local makeIndex = header.Guid
    local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
    if GUIDefine.ItemBelong.BAG == belong then
        -- 背包中的重新刷出来
        local data = {
            dropping = {
                MakeIndex = makeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, data)

    elseif GUIDefine.ItemBelong.QUICKUSE == belong then
        local itemPos = QuickUseData.GetQuickUsePosByMakeIndex(makeIndex)
        local data = {
            pos = itemPos,
            state = 1
        }
        SL:onLUAEvent(LUA_EVENT_QUICKUSE_ITEM_REFRESH, data)
    end
end

-- 整理背包
function BagData.ResponseResetBagPos()
    local bagData = BagData.GetBagData()
    for _, v in pairs(bagData) do
        local isCanAddToQuick = QuickUseData.CheckItemCanAddToQuickUse(v)
        local quickUsePos = QuickUseData.CheckQuickUseHasEmpty()
        -- 快捷栏道具
        if isCanAddToQuick and quickUsePos then
            QuickUseData.AutoAddBagItemToQuick(v, quickUsePos)
        end
    end

    local newData = BagData.GetBagData()
    BagData.AmendHistoryPos(true, newData)

    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_LIST_REFRESH)
end

-- 开启准星
function BagData.ResponseCollomator(data)
    local header = data.header
    local makeIndex = header.Guid
    if header.p2 == 0 then
        BagData.SetBagCollimator(makeIndex)
        SL:onLUAEvent(LUA_EVENT_BAG_ITEM_COLLIMATOR, makeIndex)

    else
        BagData.SetBagCollimator(makeIndex)
        SL:onLUAEvent(LUA_EVENT_SIGHT_BEAD_SHOW)
    end
end
------------注册事件
function BagData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_REQ_BAGDATA, "BagData", BagData.RequestBagData)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_REQ_TWO_TO_ONE, "BagData", BagData.RequestItemTwoToOne)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_REQ_NUMBER_CHANGE, "BagData", BagData.RequestCountItem)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_REQ_COLLIMATOR, "BagData", BagData.RequestCollimator)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_REQ_CANCELCOLLIMATOR, "BagData", BagData.RequestCancelCollimator)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_REQ_UNLOCK_BAG_SIZE, "BagData", BagData.RequestUnlockBagSize)
    
    SL:RegisterLUAEvent(LUA_EVENT_RETURN_BAGDATA, "BagData", BagData.ResponseBagItemData)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ADD_ITEM, "BagData", BagData.ResponseAddItem)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_DEL_ITEM, "BagData", BagData.ResponseDelItem)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_UPDATE_ITEM, "BagData", BagData.ResponseUpdateItem)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_USE_SUCCESS, "BagData", BagData.ResponseUseSuccess)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_USE_FAIL, "BagData", BagData.ResponseUseItemFail)
    SL:RegisterLUAEvent(LUA_EVENT_DROP_ITEM_GET_FAIL, "BagData", BagData.ResponseGetItemFail)
    SL:RegisterLUAEvent(LUA_EVENT_DROP_ITEM_SUCCESS, "BagData", BagData.ResponseDropSuccess)
    SL:RegisterLUAEvent(LUA_EVENT_DROP_ITEM_FAIL, "BagData", BagData.ResponseDropFail)
    SL:RegisterLUAEvent(LUA_EVENT_HUMBAG_TO_HEROBAG_FAIL, "BagData", BagData.ResponseItemToHeroBagFail)
    SL:RegisterLUAEvent(LUA_EVENT_RESET_BAG_POS, "BagData", BagData.ResponseResetBagPos)
    SL:RegisterLUAEvent(LUA_EVENT_COLLIMATOR_RESPONSE, "BagData", BagData.ResponseCollomator)
end