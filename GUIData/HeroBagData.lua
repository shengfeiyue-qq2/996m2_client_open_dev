HeroBagData = HeroBagData or {}
local tinsert = table.insert
local SaveKey = "_HeroBagPosData_"
local bag_Level = {[10] = 1, [20] = 2, [30] = 3, [35] = 4, [40] = 5}

local function MAKE_OPER_DATA(item, isHad, number)
    local operator = {}
    operator.item = item
    operator.isHad = isHad
    operator.change = number
    operator.MakeIndex = item.MakeIndex
    return operator
end

function HeroBagData.Init()
    HeroBagData._bagItems            = {}    --{makeindex = {}}
    HeroBagData._bagItemsCount       = 0
    HeroBagData._bagMax              = SLDefine.MAX_ITEM_NUMBER  --背包数目
    HeroBagData._bagPos2MakeIndex    = {}    --{pos = {makeindex}}
    HeroBagData._bagMakeIndex2Pos    = {}    --{makeindex = pos}
    HeroBagData._bagNoPosItems       = {}    --{makeindex = {}}
    HeroBagData._itemCountByIndex    = {}    --{itemCount = Index}
    HeroBagData._isInit              = false
    HeroBagData._bagLevel            = 5
    -------------------------------------------------------
    HeroBagData._selfDropItems       = {}    -- 自己丢弃的物品
    HeroBagData._onSellRepaire       = nil   -- 正在交易或者修理中物品
    HeroBagData._collimatorMakeIndex = nil   -- 记录背包选中的准星道具
    HeroBagData._reconnect           = false -- 是否重连

    local posData = HeroBagData.GetPosData()
    if posData then 
        for pos, MakeIndex in pairs(posData) do
            HeroBagData.SetBagPosByMakeIndex(MakeIndex, pos)
        end
    end
    HeroBagData.RegisterEvent()
end

function HeroBagData.SetMaxBag(maxBag)
    HeroBagData._bagMax = maxBag
end

function HeroBagData.GetMaxBag()
    return HeroBagData._bagMax
end

function HeroBagData.GetBagLevel()
    return HeroBagData._bagLevel
end

function HeroBagData.GetSelfDropItems()
    return HeroBagData._selfDropItems
end

function HeroBagData.GetBagData()
    return HeroBagData._bagItems
end

function HeroBagData.GetTotalItemCount()
    return HeroBagData._bagItemsCount
end

--获得空位
function HeroBagData.GetEmptyPos()
    for i = 1, HeroBagData.GetMaxBag() do
        if not HeroBagData._bagPos2MakeIndex[i] then 
            return i
        end
    end
    return nil
end

function HeroBagData.isToBeFull(tips)
    local newPos = HeroBagData.GetEmptyPos()
    if tips and not newPos then
        SL:ShowSystemTips("背包已满,请清理背包后尝试")
    end
    return newPos == nil
end

-- 通过唯一id获取在背包中的切页
function HeroBagData.GetBagPageByMakeIndex(makeIndex)
    local posPage = nil
    makeIndex = makeIndex and tonumber(makeIndex) or nil
    if makeIndex then
        local pos = HeroBagData.GetBagPosByMakeIndex(makeIndex)
        if pos and type(pos) == "number" then
            posPage = math.ceil(pos / SLDefine.MAX_ITEM_NUMBER)
        end
    end
    return posPage
end

-- 通过唯一id获取在背包中的位置 
function HeroBagData.GetBagPosByMakeIndex(makeIndex)
    return HeroBagData._bagMakeIndex2Pos[makeIndex]
end

-- 通过在背包中的位置获取唯一id 
function HeroBagData.GetMakeIndexByBagPos(pos)
    return HeroBagData._bagPos2MakeIndex[pos]
end

function HeroBagData.SetBagPosByMakeIndex(makeIndex, pos)
    if pos then 
        HeroBagData._bagMakeIndex2Pos[makeIndex] = pos 
        HeroBagData._bagPos2MakeIndex[pos] = makeIndex
    else
        local oldPos = HeroBagData._bagMakeIndex2Pos[makeIndex]
        HeroBagData._bagMakeIndex2Pos[makeIndex] = pos
        if oldPos then 
            HeroBagData._bagPos2MakeIndex[oldPos] = nil
        end
    end
    HeroBagData.SavePosData()
end

-- 通过唯一id获取物品数据
function HeroBagData.GetItemDataByMakeIndex(makeIndex)
    return HeroBagData._bagItems[makeIndex]
end

-- 获取背包数据  startPos: 开始的位置   endPos: 结束的位置
function HeroBagData.GetBagDataByBagPos(startPos, endPos)
    local data = {}
    for pos = startPos, endPos do
        local makeIndex = HeroBagData._bagPos2MakeIndex[pos]
        if makeIndex then 
            data[makeIndex] = HeroBagData._bagItems[makeIndex]
        end
    end
    return data
end

-- 修正历史数据与当前数据位置信息
function HeroBagData.AmendHistoryPos(sort, data)
    local items = data or {}
    local newBagPos = {}
    local newQuickPos = {}
    local newItems = {}
    ----------------------------
    for i,item in pairs(items) do
        local makeIndex = item.MakeIndex
        local bagPos = HeroBagData.GetBagPosByMakeIndex(makeIndex)
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
    HeroBagData.CleanBagPosData()
    for makeIndex, pos in pairs(newBagPos) do
        HeroBagData.SetBagPosByMakeIndex(makeIndex, pos)
    end
    QuickUseData.SetHistoryQuickyUseList(newQuickPos)

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
        local newPos = HeroBagData.GetEmptyPos()
        if newPos then
            HeroBagData.SetBagPosByMakeIndex(makeIndex, newPos)
        else
            HeroBagData._bagNoPosItems[makeIndex] = item
        end
    end
end

-- 清理背包位置数据
function HeroBagData.CleanBagPosData()
    HeroBagData._bagPos2MakeIndex = {}
    HeroBagData._bagMakeIndex2Pos = {}
end

-- 通过itemIndex获取物品数据
function HeroBagData.GetItemDataByItemIndex(itemIndex)
    local someItems = {}
    if not itemIndex then
        return someItems
    end
    local items = HeroBagData.GetBagData()
    for _, v in pairs(items) do
        if v.Index == itemIndex then
            tinsert(someItems, v)
        end
    end
    return someItems
end

-- 通过物品名称获取物品数据
function HeroBagData.GetItemDataByItemName(itemName)
    if not itemName then
        return nil
    end
    local someItems = {}
    local items = HeroBagData.GetBagData()
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
function HeroBagData.GetItemCountByIndex(index, famlilar)
    index = index or 0
    local count = 0
    local isBind, bindIndex = SL:CheckItemBind(index)
    local myCount = HeroBagData._GetItemCountByIndex(index)
    local famlilarCount = 0
    if isBind and bindIndex ~= index and famlilar then
        famlilarCount = HeroBagData._GetItemCountByIndex(bindIndex)
    end
    local totalCount = myCount + famlilarCount
    return totalCount
end

-- 设置正在交易或修理中
function HeroBagData.SetOnSellOrRepaire(makeIndex)
    HeroBagData._onSellRepaire = makeIndex
    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE)
end

-- 获取是否在交易或修理
function HeroBagData.GetOnSellOrRepaire()
    return HeroBagData._onSellRepaire
end

-- 清理交易或修理
function HeroBagData.CleanOnSellOrRepaire()
    HeroBagData._onSellRepaire = nil
    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE)
end

--背包位置数据
function HeroBagData.GetPosData()
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

function HeroBagData.SavePosData()
    HeroBagData._bagPos2MakeIndex["time"] = os.time()
    local bagPosData = SL:JsonEncode(HeroBagData._bagPos2MakeIndex)
    SL:SetLocalString(SaveKey, bagPosData)
end

-- 添加物品
function HeroBagData.AddItemData(item, noNotice)
    if not item then
        return
    end
    local makeIndex = item.MakeIndex
    local index = item.Index
    local newCount =  item.OverLap or 1
    local itemPos = HeroBagData.GetBagPosByMakeIndex(makeIndex) or HeroBagData.GetEmptyPos()
    if itemPos then
        HeroBagData.SetBagPosByMakeIndex(makeIndex, itemPos)
    else
        HeroBagData._bagNoPosItems[makeIndex] = item
    end

    if not noNotice then
        HeroBagData.ShowGetOrCostItems(newCount, item.Name)
    end

    HeroBagData._bagItems[makeIndex] = item
    HeroBagData._bagItemsCount = HeroBagData._bagItemsCount + 1

    HeroBagData.ChangeItemCountByindex(index, newCount)

    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex, GUIDefine.ItemBelong.HEROBAG)
end

-- 显示获得或消耗物品
function HeroBagData.ShowGetOrCostItems(diff, name)
    if not HeroBagData._isInit then
        return
    end

    local nData = {}
    nData.name = name
    nData.num = math.abs(diff)
    if diff > 0  then 
        SL:ShowGetHeroBagItem(nData)
    else
        SL:ShowCostHeroItem(nData)
    end
end

-- 增加物品并通知
function HeroBagData.AddItemDataAndNotice(item)
    HeroBagData.AddItemData(item)

    local operator = {}
    operator.opera = GUIDefine.OperateType.ADD
    operator.operID = {}
    tinsert(operator.operID, MAKE_OPER_DATA(item, false))

    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, operator)
    -- 延迟通知
    HeroBagData.DelayNotifyBagOper()
end

-- 延迟通知，部分系统不需要实时监听背包改变，并且不需要知道背包操作类型，节省性能
function HeroBagData.DelayNotifyBagOper()
    if HeroBagData._delayNotifyTimerID then
        SL:UnSchedule(HeroBagData._delayNotifyTimerID)
        HeroBagData._delayNotifyTimerID = nil
    end

    HeroBagData._delayNotifyTimerID = SL:ScheduleOnce(function()
        SL:BagDataDelayNotice()
    end, 0.5)
end

-- 删除物品
function HeroBagData.DelItemData(data, showTip, noCleanPos, noNotify, isBaitan)
    if not data or not next(data) then
        return
    end

    local makeIndex = data.MakeIndex
    local index = data.Index
    local count = data.OverLap or 1
    local itemHasPos = true
    local noPosData = HeroBagData._bagNoPosItems[makeIndex] 
    local item = HeroBagData.GetItemDataByMakeIndex(makeIndex)

    if noPosData then
        itemHasPos = false
        item = noPosData
    end

    if item then
        if not HeroBagData._isInit then
            UIOperator:CloseAutoUsePopUI(item.MakeIndex, nil, true)
        end

        local operator = {}
        operator.opera = GUIDefine.OperateType.DEL
        operator.operID = {}
        operator.isBaitan = isBaitan
        local operitem = HeroBagData.BagOperItemByMakeIndex(makeIndex, itemHasPos)
        tinsert(operator.operID, operitem)

        HeroBagData._bagItems[makeIndex] = nil 
        HeroBagData._bagNoPosItems[makeIndex] = nil 
        HeroBagData._bagItemsCount = HeroBagData._bagItemsCount - 1 

        HeroBagData.ChangeItemCountByindex(index, -count)

        if not noCleanPos then
            HeroBagData.SetBagPosByMakeIndex(makeIndex, nil)
        end

        SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", item.MakeIndex, nil)

        if not noNotify then
            SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, operator)

            -- 延迟通知
            HeroBagData.DelayNotifyBagOper()
        end

        if showTip then
            HeroBagData.ShowGetOrCostItems(-(count or 1), item.Name)
        end

        -- 缓存中的数据自动补充到背包
        if HeroBagData._bagNoPosItems and next(HeroBagData._bagNoPosItems) and itemHasPos then
            for _, v in pairs(HeroBagData._bagNoPosItems) do
                if v and next(v) then
                    HeroBagData.DelItemData(v, nil, nil, true)
                    HeroBagData.AddItemDataAndNotice(v)
                    break
                end
            end
        end
    end
end

function HeroBagData.BagOperItemByMakeIndex(makeIndex, isShowInBag)
    local item = HeroBagData.GetItemDataByMakeIndex(makeIndex)
    if not isShowInBag then
        item = HeroBagData._bagNoPosItems[makeIndex]
    end

    local operator = {}
    if item then
        local makeIndex = item.MakeIndex
        operator.MakeIndex = makeIndex
        operator.item = item
    end
    return operator
end

function HeroBagData.ChangeItemCountByindex(index, diff)
    local count = HeroBagData._GetItemCountByIndex(index)
    count = count + diff
    HeroBagData._SetItemCountByIndex(index, count)
end

function HeroBagData._GetItemCountByIndex(index)
    HeroBagData._itemCountByIndex[index] = HeroBagData._itemCountByIndex[index] or 0 
    return HeroBagData._itemCountByIndex[index]
end

function HeroBagData._SetItemCountByIndex(index, count)
    HeroBagData._itemCountByIndex[index] = count 
    if HeroBagData._itemCountByIndex[index] and HeroBagData._itemCountByIndex[index] < 0 then 
        HeroBagData._itemCountByIndex[index] = nil
    end
end
-- 更改物品数据
function HeroBagData.ChangeItemData(item)
    local makeIndex = item.MakeIndex
    local index = item.Index
    local newnum = item.OverLap or 1
    local diff = 0
    local data = HeroBagData.GetItemDataByMakeIndex(makeIndex)
    if data then
        local oldnum = data.OverLap or 1
        diff = newnum - oldnum
        HeroBagData._bagItems[makeIndex] = item
        HeroBagData.ChangeItemCountByindex(index, diff)
        if diff ~= 0 then
            HeroBagData.ShowGetOrCostItems(diff, item.Name)
        end
    end
    return diff
end

-- 清理背包
function HeroBagData.ClearItemData(isReconnect)
    for k,v in pairs(HeroBagData._bagItems) do
        HeroBagData.DelItemData(v, nil, true, isReconnect)
    end
    HeroBagData._bagItems = {}-- {makeindex = {}}
    HeroBagData._bagItemsCount = 0
    HeroBagData._bagMax = SLDefine.MAX_ITEM_NUMBER
    HeroBagData._bagNoPosItems = {}-- {makeindex = {}}
    HeroBagData._itemCountByIndex = {}
    HeroBagData._isInit = false
    if not isReconnect then 
        self:CleanBagPosData()
    end
end

-- 换位
function HeroBagData.ExchangePos(makeIndex1, pos1, makeIndex2, pos2)
    HeroBagData.SetBagPosByMakeIndex(makeIndex1, pos1)
    HeroBagData.SetBagPosByMakeIndex(makeIndex2, pos2)
    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE, {makeIndex1, makeIndex2})
end

-- 修改位置数据
function HeroBagData.SetItemPosData(makeIndex, pos)
    HeroBagData.SetBagPosByMakeIndex(makeIndex, nil)
    HeroBagData.SetBagPosByMakeIndex(makeIndex, pos)
    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE, {makeIndex})
end

-- 获取背包道具的使用状态(0：使用 1：使用准星道具 2：取消准星 3：不可使用)
function HeroBagData.GetOnBagItemUseState(data)
    if HeroBagData._collimatorMakeIndex then
        if HeroBagData._collimatorMakeIndex == -1 then -- 脚本
            return 1
        end

        if data and HeroBagData._collimatorMakeIndex == data.MakeIndex then
            return 2
        end

        return 1
    end

    return 0
end

-- 设置准星道具
function HeroBagData.SetBagCollimator(data)
    HeroBagData._collimatorMakeIndex = data
end

-- 获取准星道具
function HeroBagData.GetBagCollimator()
    return HeroBagData._collimatorMakeIndex
end

-- 清理准星道具
function HeroBagData.ClearBagCollimator()
    HeroBagData._collimatorMakeIndex = nil
end

-- 整理背包
function HeroBagData.ResetBagPos()
    local newData = HeroBagData.GetBagData()
    HeroBagData.AmendHistoryPos(true, newData)

    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_LIST_REFRESH)
end
--------------------------------------------------------------------------------------------
----------------------------------------------请求触发
-- 请求背包数据
function HeroBagData.RequestBagData()
    HeroBagData._isInit = true
end

-- 叠加道具
function HeroBagData.RequestItemTwoToOne(data)
    local makeIndex1 = data.MakeIndex1
    local makeIndex2 = data.MakeIndex2
end

-- 拆分道具
function HeroBagData.RequestCountItem(data)
    local makeIndex = data.MakeIndex
    local num = data.num
end

-- 请求人物背包到英雄背包
function HeroBagData.RequestHumBagToHeroBag(data)
    local makeIndex = data.MakeIndex
    local itemName = data.ItemName
end

-- 请求英雄背包到人物背包
function HeroBagData.RequestHeroBagToHumBag(data)
    local makeIndex = data.MakeIndex
    local itemName = data.ItemName
end

--------------------------------------------------------------------------------------------
-- 背包数据初始化
function HeroBagData.ResponseBagItemData(data)
    local header = data.header
    if header.recog == 1 then --整理背包
        HeroBagData.ResetBagPos()
        return 
    end
    local data = data.data
    -- 修正本地位置信息数据
    HeroBagData.AmendHistoryPos(false, data)
    
    local operator = {}
    operator.initbool = false
    operator.opera = GUIDefine.OperateType.INIT
    operator.operID = {}

    for _, item in pairs(data) do
        HeroBagData.AddItemData(item, true)
        tinsert(operator.operID, MAKE_OPER_DATA(item, false))
    end
    SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, operator)
    -- 延迟通知
    HeroBagData.DelayNotifyBagOper()
    HeroBagData._isInit = true
end

-- 增加道具
function HeroBagData.ResponseAddItem(data)
    local header = data.header 
    local data = data.data
    local recog = header.recog
    if recog == -1 then
        if SL._DEBUG then
            local _ditem = HeroBagData.GetItemDataByMakeIndex(data.MakeIndex)
            if _ditem then
                SL:Print("ERROR HERO BAG ITEM EXIST, CAN'T ADD IT AGAIN", data.MakeIndex)
            end
        end
        HeroBagData.AddItemData(data)
        local operator = {}
        operator.opera = GUIDefine.OperateType.ADD
        operator.operID = {}
        tinsert(operator.operID, MAKE_OPER_DATA(data, false))
        SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, operator)

        -- 延迟通知
        HeroBagData.DelayNotifyBagOper()

    else
        data.Where = recog
        HeroEquipData.AddEquipData(data)
    end
end

-- 删除道具
function HeroBagData.ResponseDelItem(data)
    local header = data.header
    local makeIndex = header.Guid
    local itemBelong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex) 
    if not itemBelong then
        SL:Print("delete item error, can't find item belong")
        return
    end

    if itemBelong == GUIDefine.ItemBelong.HEROBAG then
        local itemData = HeroBagData.GetItemDataByMakeIndex(makeIndex)
        if not itemData then
            SL:Print("delete item error, can't find item")
            return
        end
        HeroBagData.DelItemData(itemData, true)
    elseif itemBelong == GUIDefine.ItemBelong.HEROEQUIP then
        local itemData = HeroEquipData.GetEquipDataByMakeIndex(makeIndex)
        if not itemData then
            SL:Print("delete item error, can't find item")
            return
        end
        HeroEquipData.DelEquipData(itemData)
    end
end

-- 更新道具
function HeroBagData.ResponseUpdateItem(data)
    local data = data.data
    local itemMakeIndex = data.MakeIndex
    local itemBelong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX" ,itemMakeIndex)
    if not itemBelong then
        return
    end
    if GUIDefine.ItemBelong.HEROBAG == itemBelong then
        local operator = {}
        operator.opera = GUIDefine.OperateType.CHANGE
        operator.operID = {}
        local diff = HeroBagData.ChangeItemData(data)
        tinsert(operator.operID, MAKE_OPER_DATA(data, true, diff))
        SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, operator)

        -- 延迟通知
        HeroBagData.DelayNotifyBagOper()

    elseif GUIDefine.ItemBelong.HEROEQUIP == itemBelong then
        HeroEquipData.ChangeEquipData(data, true, true)
    end

    -- for item update.
    local updateData = {
        from = itemBelong,
        item = data
    }
    SL:ItemUpdateNotice(updateData)
end

function HeroBagData.ResponseUseSuccess(data) 
    local header = data.header
    local ItemIndex = header.recog
end

-- 道具使用失败
function HeroBagData.ResponseUseItemFail(data) 
    local header = data.header
    SL:Print("道具使用失败消息")
    local makeIndex = header.recog
    local itemData = HeroBagData.GetItemDataByMakeIndex(makeIndex)
    if itemData and itemData.StdMode == 49 then
        -- 49类型道具使用失败提醒 0关闭  非0开启
        if SL:GetValue("GAME_DATA", "Pearl_on_off") ~= 0 then
            SL:ShowSystemTips("条件不满足")
        end
    end
end

-- 道具拾取失败 -1背包满 -2负重满 -3物品禁止拾取 
function HeroBagData.ResponseGetItemFail(data)
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
function HeroBagData.ResponseDropSuccess(data)
    local header = data.header
    local makeIndex = header.Guid
    if makeIndex then
        tinsert(HeroBagData._selfDropItems, makeIndex)
        if #HeroBagData._selfDropItems > 100 then -- 记录自己丢弃的物品   挂机拾取的时候忽略
            table.remove(HeroBagData._selfDropItems, 1)
        end
        
        local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
        if GUIDefine.ItemBelong.HEROBAG == belong then
            local data = {
                dropping = {
                    MakeIndex = makeIndex,
                    state = 1
                }
            }
            SL:onLUAEvent(LUA_EVENT_HERO_BAG_STATE_CHANGE, data)
        end
    end
end

-- 丢弃道具失败
function HeroBagData.ResponseDropFail(data)
    local header = data.header
    local makeIndex = header.Guid
    local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
    if GUIDefine.ItemBelong.HEROBAG == belong then
        -- 背包中的重新刷出来
        local data = {
            dropping = {
                MakeIndex = makeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_HERO_BAG_STATE_CHANGE, data)
    end
end

-- 移动到人物背包失败
function HeroBagData.ResponseItemToHumanBagFail(data)
    local header = data.header
    local makeIndex = header.Guid
    local belong = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex)
    if GUIDefine.ItemBelong.HEROBAG == belong then
        -- 背包中的重新刷出来
        local data = {
            dropping = {
                MakeIndex = makeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_HERO_BAG_STATE_CHANGE, data)
    end
end

------------注册事件
function HeroBagData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_REQ_TWO_TO_ONE, "HeroBagData", HeroBagData.RequestItemTwoToOne)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_REQ_NUMBER_CHANGE, "HeroBagData", HeroBagData.RequestCountItem)
    SL:RegisterLUAEvent(LUA_EVENT_REQ_HUM_BAG_TO_HERO_BAG, "HeroBagData", HeroBagData.RequestHumBagToHeroBag)
    SL:RegisterLUAEvent(LUA_EVENT_REQ_HERO_BAG_TO_HUM_BAG, "HeroBagData", HeroBagData.RequestHeroBagToHumBag)
    
    SL:RegisterLUAEvent(LUA_EVENT_RETURN_HERO_BAGDATA, "HeroBagData", HeroBagData.ResponseBagItemData)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ADD_ITEM, "HeroBagData", HeroBagData.ResponseAddItem)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_DEL_ITEM, "HeroBagData", HeroBagData.ResponseDelItem)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_UPDATE_ITEM, "HeroBagData", HeroBagData.ResponseUpdateItem)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_USE_FAIL, "HeroBagData", HeroBagData.ResponseUseItemFail)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_DROP_ITEM_GET_FAIL, "HeroBagData", HeroBagData.ResponseGetItemFail)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_DROP_ITEM_SUCCESS, "HeroBagData", HeroBagData.ResponseDropSuccess)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_DROP_ITEM_FAIL, "HeroBagData", HeroBagData.ResponseDropFail)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_TO_HUMAN_BAG_FAIL, "HeroBagData", HeroBagData.ResponseItemToHumanBagFail)
end