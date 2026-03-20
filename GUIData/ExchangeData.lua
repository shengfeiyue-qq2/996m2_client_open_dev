ExchangeData = ExchangeData or {}

function ExchangeData.Init()
    ExchangeData._config_type   = {} -- 类型配置


    ExchangeData._limitShelf      = 8  -- 货架数量


    ExchangeData._currencies    = {}       
    ExchangeData._currencyMap   = {}


    ExchangeData._receivelist   = {}        -- 我的 - 记录列表
    ExchangeData._putlist       = {}        -- 我的 - 上架列表
    ExchangeData._src           = 0         -- 请求来源 0.世界交易  1.我的上架 2.我的记录
    ExchangeData._sort          = 0         -- 排序 0.默认 1.单价正序 2.单价倒序 3.总价正序 4.总价倒序
    ExchangeData._page          = 0
    ExchangeData._complete      = false

    ExchangeData._itemConfig    = {}

    ExchangeData._requestMinTime    = 600       -- 交易所数据请求最小时间间隔(毫秒)
    ExchangeData._lastRequestTime   = nil

    ExchangeData._filter1Item       = nil       -- 分类一级数据
    ExchangeData._itemListByType    = {}        -- 按类分物品列表
    ExchangeData.LoadConfig()
    ExchangeData.RegisterEvent()

end

function ExchangeData.CalcItemStatus(item)
    if not item then
        return 3, 0
    end
    local status    = 0 
    local endTime = item.endtime or 0 
    local remaining = 0
    if endTime == 0 then--endtime为0不限制下架时间
        return status, remaining
    end
    local  showTime = item.endtime -item.starttime
    if  showTime > 0 then
        status = 2
        remaining = item.endtime -SL:GetValue("SERVER_TIME")
    else
        status = 3
        remaining = 0
    end
    remaining = math.max(remaining, 0)
    return status, remaining
end


function ExchangeData.GetShowBagItems()

    local bagData          = BagData.GetBagData()
    local quickData        = QuickUseData.GetQuickUseData()
    local articleType      = GUIDefine.ItemArticleType
    local bagItems         = {}
    local itemMaps         = {}
    for _, vItem in pairs(quickData) do
        local _, isMeetType = SL:GetValue("ITEM_IS_BIND",vItem,articleType.TYPE_TRADE_AUCTION)
        local equipData = SL:GetValue("ITEM_DATA", vItem.Index)
        if not isMeetType and equipData.JiaoYiSuoLimit  then
            table.insert(bagItems, vItem)
            itemMaps[vItem.MakeIndex] = vItem
        end
    end

    for _, vItem in pairs(bagData) do
        local _, isMeetType = SL:GetValue("ITEM_IS_BIND",vItem,articleType.TYPE_TRADE_AUCTION)
        local itemData = SL:GetValue("ITEM_DATA", vItem.Index)
        if not isMeetType and itemData.JiaoYiSuoLimit  then
            table.insert(bagItems, vItem)
            itemMaps[vItem.MakeIndex] = vItem
        end
    end

    return bagItems, itemMaps
end

function ExchangeData.LoadConfig()
    ExchangeData._config_type = clone(SL:RequireFile("game_config/cfg_auction_type"))
end
function ExchangeData.InitItemConfig(...)
    ExchangeData._itemConfig = SL:GetValue("STD_ITEMS")
end
function ExchangeData.Clear()
    ExchangeData._page = 0
    ExchangeData._complete = false
end

function ExchangeData.IsComplete()
    return ExchangeData._complete
end


function ExchangeData.GetLimitShelf()
    return ExchangeData._limitShelf or 8
end

function ExchangeData.SetLimitShelf(count)
    ExchangeData._limitShelf = count
end

function ExchangeData.GetCurrencies()
    return ExchangeData._currencies
end

-- #分隔
function ExchangeData.SetCurrencies(str)
    if str and string.len(str) > 0 then
        local data = SL:Split(str, "#")
        for k, v in ipairs(data) do
            local id = tonumber(v)
            if id and not ExchangeData._currencyMap[id] then
                ExchangeData._currencyMap[id] = true
                table.insert(ExchangeData._currencies, {id = id})
            end
        end
    end
end

function ExchangeData.SetTypeItemList(list)
    ExchangeData._itemListByType = list or {}
end

function ExchangeData.GetItemListByType(key)
    return ExchangeData._itemListByType and ExchangeData._itemListByType[key] or {}
end

function ExchangeData.clearData()
    ExchangeData._itemListByType = {}
end

function ExchangeData.SetSortType(type)
    ExchangeData._sort = type
end

function ExchangeData.GetSortType()
    return ExchangeData._sort
end

function ExchangeData.GetCTypeByID(id)
    return ExchangeData._config_type[id]
end

function ExchangeData.GetStdModeByID(id)
    local config = ExchangeData.GetCTypeByID(id)
    if not config then
        return {}
    end
    local slices = SL:Split(tostring(config.stdmode), "#")
    local stdmode = {}
    for key, value in ipairs(slices) do
        table.insert(stdmode, tonumber(value))
    end
    return stdmode
end
-- 一级页签
function ExchangeData.GetFirstFilterItem()
    if not ExchangeData._filter1Item then
        local items = {}
        for i, v in pairs(ExchangeData._config_type) do
            if not items[v.firstlevel] then
                items[v.firstlevel] = {}
            end
            table.insert(items[v.firstlevel], v)
        end

        for i, v in pairs(items) do 
            table.sort(v, function(a, b) return a.id < b.id end)
        end 
        ExchangeData._filter1Item = items
    end
    return ExchangeData._filter1Item
end

-- 二级页签
function ExchangeData.GetSecondFilterItem(g)
    local items = ExchangeData.GetFirstFilterItem()[g] or {}
    return items
end

function ExchangeData.SetRequestMinTime(time)
    ExchangeData._requestMinTime = time
end

function ExchangeData.RespExchangeDataUpdate(data)
    local isMy = data.isMy
    local action = data.action
    local jsonData = data.item
    
    -- type: 1 新增
    local TYPE = {
        ADD = 1,
        REMOVE = 2,
        UPDATE = 3,
    }
    if action == 1 then -- 上架
        if isMy then
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_PUT_LIST, {items = jsonData})
        else
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, {type = TYPE.ADD, item = jsonData})
        end
    elseif action == 2 then --购买更新
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, { type = TYPE.UPDATE, item = jsonData})
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_PUT_LIST, { type = TYPE.UPDATE, items = jsonData})
    elseif action == 3 then -- 下架 
        if isMy then
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT, { items = jsonData})
        else
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_WORLDITEM_UPDATE, {type = TYPE.REMOVE, item = jsonData})
        end
    end
end

function ExchangeData.Operaback(data)
    local type = data.type
    local errorcode = data.errorcode
    if errorcode == 0 then
        SL:ShowSystemTips("成功")
        if  type == 1  then
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_PUT_IN)
        elseif type == 4 then
            SLBridge:onLUAEvent(LUA_EVENT_EXCHANGE_PUT_OUT)
        end

    elseif errorcode == -1 then
        SL:ShowSystemTips("道具不合法")
    elseif errorcode == -2 then
        SL:ShowSystemTips("单价不合法")
    elseif errorcode == -3 then
        SL:ShowSystemTips("最小数量不合法")
    elseif errorcode == -4 then
        SL:ShowSystemTips("货币类型不合法")
    elseif errorcode == -5 then
        SL:ShowSystemTips("数量不合法")
    elseif errorcode == -6 then
        SL:ShowSystemTips("金额不合法")
    elseif errorcode == -7 then
        SL:ShowSystemTips("货币不足")
    elseif errorcode == -8 then
        SL:ShowSystemTips("有未提取道具不允许下架")
    elseif errorcode == -9 then
        SL:ShowSystemTips("不允许操作绑定物品")
    elseif errorcode == -11 then
        SL:ShowSystemTips("不允许购买")    
    end
end
function ExchangeData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_REQ_EXCHANGEDATA, "ExchangeData", ExchangeData.RespExchangeDataUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_EXCHANGE_OPERABACK, "ExchangeData", ExchangeData.Operaback)
end