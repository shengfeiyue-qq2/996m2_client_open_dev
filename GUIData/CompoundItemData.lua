CompoundItemData = CompoundItemData or {}

local MoneyType = {
    YuanBao     = 2,
    BindYuanBao = 4,
}

function CompoundItemData.Init()

    CompoundItemData._config = {}
    CompoundItemData._pageNameList = {}
    CompoundItemData._showItemList = {}

    CompoundItemData._materialNeedList = {} -- 合成所需原材料
    CompoundItemData._moneyNeedList = {}    -- 合成所需货币

    CompoundItemData._effectList = {}       -- 对应合成ID特效列表

    CompoundItemData._onCompoundID = nil    -- 当前合成ID
    CompoundItemData._compoundRedState = {} -- 对应合成ID红点状态

    CompoundItemData._moneyChangeList = {}
    CompoundItemData._lastCheckMoneyList = {}
    CompoundItemData._lastCheckMoneyTime = 0


    CompoundItemData.LoadConfig()
    CompoundItemData.RegisterEvent()
end

function CompoundItemData.LoadConfig()
    CompoundItemData._config = {}
    local config = {}
    local filePath = "scripts/game_config/cfg_makeitems.lua"
    if SL:IsFileExist(filePath) then
        config = SL:Require(filePath)
    end

    for k, item in pairs(config) do
        local compoudID = item.id
        local pageIndex = item.page1 * 1000 + item.page2
        if not CompoundItemData._showItemList[pageIndex] then
            CompoundItemData._showItemList[pageIndex] = {}
        end
        -- 一级菜单名
        CompoundItemData._pageNameList[item.page1] = item.page1name
        -- 二级菜单名
        CompoundItemData._pageNameList[pageIndex] = item.page2name
        
        local moneyCost = {}

        local materialCost = {}
        -- 材料消耗
        local itemList = string.split(item.material or "", "&")
        for _, cost in ipairs(itemList) do
            if cost ~= "" then
                local costData = string.split(cost, "#")
                local costID = tonumber(costData[1])
                local costCount = tonumber(costData[2])
                if costID and costCount then
                    table.insert(materialCost, {
                        id = costID,
                        count = costCount
                    })
                    if not CompoundItemData._materialNeedList[costID] then
                        CompoundItemData._materialNeedList[costID] = {}
                    end
                    CompoundItemData._materialNeedList[costID][compoudID] = costCount
                    local isBind, bindIndex = SL:CheckItemBind(costID)
                    if isBind and bindIndex and bindIndex ~= costID then
                        if not CompoundItemData._materialNeedList[bindIndex] then
                            CompoundItemData._materialNeedList[bindIndex] = {}
                        end
                        CompoundItemData._materialNeedList[bindIndex][compoudID] = costCount
                    end
                end
            end
        end

        -- 货币消耗
        local moneyList = string.split(item.CYquantity or "", "&")
        for _, cost in ipairs(moneyList) do
            if cost ~= "" then
                local costData = string.split(cost, "#")
                local costID = tonumber(costData[1])
                local costCount = tonumber(costData[2])
                if costID and costCount then
                    if not CompoundItemData._moneyNeedList[costID] then
                        CompoundItemData._moneyNeedList[costID] = {}
                    end
                    table.insert(moneyCost, {
                        id = costID,
                        count = costCount
                    })

                    CompoundItemData._moneyNeedList[costID][compoudID] = costCount
                    local isBind, bindIndex = SL:CheckItemBind(costID)
                    if isBind and bindIndex and bindIndex ~= costID then
                        if not CompoundItemData._moneyNeedList[bindIndex] then
                            CompoundItemData._moneyNeedList[bindIndex] = {}
                        end
                        CompoundItemData._moneyNeedList[bindIndex][compoudID] = costCount
                    end
                end
            end
        end


        -- 合成目标物品
        local produceStr = item.product
        if produceStr and produceStr ~= "" then
            local obtainItem = string.split(produceStr or "", "#")
            local itemId = tonumber(obtainItem[1])
            local itemCount = tonumber(obtainItem[2])
            if itemId and itemCount then
                item.production = {
                    id = itemId,
                    count = itemCount
                }
            end
        end

        item.moneyCost = moneyCost
        item.materialCost = materialCost
        -- 同二级页签数据
        table.insert(CompoundItemData._showItemList[pageIndex], item)
        CompoundItemData._config[compoudID] = item
    end

    -- 排序
    local sortShowItemList = {}
    if CompoundItemData._showItemList and next(CompoundItemData._showItemList) then
        for pageIndex, v in pairs(CompoundItemData._showItemList) do
            if #v > 1 then
                table.sort(v, function(item1, item2)
                    return item1.page3 < item2.page3
                end)
            end
            sortShowItemList[pageIndex] = v
        end
        CompoundItemData._showItemList = sortShowItemList
    end

    local showConfig = SL:GetValue("GAME_DATA", "itemiconeffect")
    if showConfig and showConfig ~= "" then
        local effectType = string.split(showConfig, "|")
        for k, v in ipairs(effectType) do
            if v ~= "" then
                local effectList = string.split(v, "&")
                local listStr = effectList[1]
                local effectId = tonumber(effectList[2])
                local indexList = string.split(listStr, "#")
                for _, index in ipairs(indexList) do
                    local compoudID = tonumber(index)
                    if compoudID and effectId then
                        CompoundItemData._effectList[compoudID] = effectId
                    end
                end
            end
        end
    end
end

-- 获取配置数据
function CompoundItemData.GetConfigByID(id)
    return CompoundItemData._config[id]
end

-- 当前合成ID
function CompoundItemData.SetOnCompoundID(id)
    CompoundItemData._onCompoundID = id
end

function CompoundItemData.GetOnCompoundID()
    return CompoundItemData._onCompoundID
end

-- 获取当前合成ID对应配置
function CompoundItemData.GetOnCompoundData()
    if not CompoundItemData._onCompoundID then
        return nil
    end
    return CompoundItemData.GetConfigByID(CompoundItemData._onCompoundID)
end

-- 获取组合页签下标合成数据
function CompoundItemData.GetShowItemList()
    return CompoundItemData._showItemList
end

function CompoundItemData.GetShowItemListByPageIndex(pageIndex)
    if not pageIndex then
        return nil
    end
    return CompoundItemData._showItemList[pageIndex]
end

-- 获取合成红点状态 -- param:合成ID
function CompoundItemData.GetCompoundStateByID(id)
    return CompoundItemData._compoundRedState[id] == true
end

function CompoundItemData.GetPageName(pageIndex)
    return CompoundItemData._pageNameList[pageIndex]
end

function CompoundItemData.GetCompoundEffectByID(id)
    return CompoundItemData._effectList[id]
end

function CompoundItemData.CheckStrCondition(condition)
    if not condition or condition == "" then
        return true
    end

    return SL:CheckCondition(condition)
end

-- 检查页签是否可展示
function CompoundItemData.CheckTabIsShow(page1, page2)
    for pageIndex, itemList in pairs(CompoundItemData._showItemList) do
        local curPage1 = math.floor(pageIndex / 1000)
        local curPage2 = pageIndex - curPage1 * 1000
        local isSamePage1 = curPage1 == page1
        local isSamePage2 = curPage2 == page2
        if isSamePage1 and (not page2 or isSamePage2) then
            for _, v in ipairs(itemList) do
                local isShow = CompoundItemData.CheckStrCondition(v.showcondition)
                if isShow then
                    return isShow
                end
            end
        end
    end
    return false
end

-- 检查页签红点状态
function CompoundItemData.CheckTabRedState(page1, page2)
    for pageIndex, itemList in pairs(CompoundItemData._showItemList) do
        local curPage1 = math.floor(pageIndex / 1000)
        local curPage2 = pageIndex - curPage1 * 1000
        local isSamePage1 = curPage1 == page1
        local isSamePage2 = curPage2 == page2
        if isSamePage1 and (not page2 or isSamePage2) then
            for _, v in ipairs(itemList) do
                local isShow = CompoundItemData.GetCompoundStateByID(v.id)
                if isShow then
                    return isShow
                end
            end
        end
    end
    return false
end

function CompoundItemData.CheckItemCountEnoughEX(data)
    if not data.itemID or not data.itemNum then
        return true
    end

    local myCount = SL:GetValue("ITEM_COUNT", data.itemID, data.famlilar)
    local isEnough = myCount >= data.itemNum
    if not isEnough then
        if not data.noTips then
            SL:ShowSystemTips(string.format("%s不足，无法合成", SL:GetValue("ITEM_NAME", data.itemID)))
        end
        return false
    end

    return true
end

-- 检查能否合成 -- item: 该合成配置数据 isTips: 是否提示
function CompoundItemData.CheckIsCanCompoud(item, isTips)
    if not item then
        return
    end

    local compoundCount = nil
    local takeoffPlayerEquip = {}

    if isTips ~= true then
        isTips = false
    end

    local materialCost = item.materialCost or {}
    if next(materialCost) then
        for _, costItem in pairs(materialCost) do
            local costData = {
                itemID = costItem.id,
                itemNum = costItem.count,
                noTips = not isTips,
            }
            local isCanCompound = CompoundItemData.CheckItemCountEnoughEX(costData)
            if not isCanCompound then
                return false
            end
        end
    end

    local moneyCost = item.moneyCost or {}
    if next(moneyCost) then
        for _, costItem in pairs(moneyCost) do
            local costData = {
                itemID = costItem.id,
                itemNum = costItem.count,
                noTips = not isTips,
                famlilar = true,
            }
            local isCanCompound = CompoundItemData.CheckItemCountEnoughEX(costData)
            if not isCanCompound then
                return false
            end
        end
    end

    local condition = item.condition
    if condition then
        if not CompoundItemData.CheckStrCondition(condition) then
            return false
        end
    end

    local needSpace = 0
    local productItem = item.production
    if productItem and next(productItem) then
        local itemID = productItem.id
        local itemCount = productItem.count
        local itemData = SL:GetValue("ITEM_DATA", itemID)
        local isOverLap = itemData and SL:CheckItemOverLap(itemData)
        if itemID > 100 then -- 货币不占背包格子
            if isOverLap then
                needSpace = needSpace + 1
            else
                needSpace = needSpace + itemCount
            end
        end
    end

    local bagItemNum =  BagData.GetTotalItemCount()
    local maxBag = BagData.GetMaxBag()
    if bagItemNum + needSpace > maxBag then
        if isTips then
            SL:ShowSystemTips("背包空间不足")
        end
        return false
    end
    return true
end

--[[
    避免货币频繁变动导致检测过于频繁
    5秒内不重复检测
    CD内的变动在delay中检测
]]
function CompoundItemData.OnMoneyChangeCount(data)
    if not data or next(data) == nil then
        return
    end

    local moneyId = data.id
    local moneyCount = data.count

    if moneyId == MoneyType.YuanBao then -- 元宝类型改成绑定元宝类型检测（消耗货币只检测绑定元宝， 但是元宝又可以和绑定元宝一起消耗）
        moneyId = MoneyType.BindYuanBao
    end

    CompoundItemData._moneyChangeList[moneyId] = moneyCount

    local function updateFunc()
        local nowServerTime = SL:GetValue("SERVER_TIME")
        for id, count in pairs(CompoundItemData._moneyChangeList) do
            local lastCount = CompoundItemData._lastCheckMoneyList[id] or 0
            if count ~= lastCount then
                local isAdd = count > lastCount
                CompoundItemData.OnRefreshMoney(id, isAdd)
            end
            CompoundItemData._lastCheckMoneyList[id] = count
        end

        CompoundItemData._moneyChangeList = {}
        CompoundItemData._lastCheckMoneyTime = nowServerTime
    end
    
    if not CompoundItemData._updateMoneyTimer then
        CompoundItemData._updateMoneyTimer = SL:ScheduleOnce(function()
            updateFunc()
            CompoundItemData._updateMoneyTimer = nil
        end, 5)
    end

    local serverTime = SL:GetValue("SERVER_TIME")
    if serverTime > CompoundItemData._lastCheckMoneyTime + 5 or serverTime < CompoundItemData._lastCheckMoneyTime then
        updateFunc()
    end

end

function CompoundItemData.OnRefreshMoney(id, isAdd)
    local needCurMoneyList = CompoundItemData._moneyNeedList[id]
    if needCurMoneyList and next(needCurMoneyList) then
        for compoundID, count in pairs(needCurMoneyList) do
            -- 增删检测不同状态
            local state = CompoundItemData._compoundRedState[compoundID]
            local newState = true
            if (not state and isAdd) or (state and not isAdd) then
                local config = CompoundItemData.GetConfigByID(compoundID)
                local isCanCompound = true

                local showConditionStr = config.showcondition
                if isCanCompound and showConditionStr then
                    isCanCompound = CompoundItemData.CheckStrCondition(showConditionStr)
                end

                if isCanCompound then
                    isCanCompound = CompoundItemData.CheckIsCanCompoud(config, false)
                end

                newState = isCanCompound
                CompoundItemData._compoundRedState[compoundID] = isCanCompound
            end

            SL:onLUAEvent(LUA_EVENT_COMPOUND_RED_POINT, {
                change = state ~= newState,
                id = compoundID,
            })
        end
    end
end

function CompoundItemData.OnUpdateItemChange(data)
    if not data or not next(data) then
        return
    end
    
    local itemList = data.operID or {}
    if data.opera == GUIDefine.OprateType.INIT then
        for k, v in pairs(itemList) do
            CompoundItemData.OnCheckItemCount(v.item.Index, true)
        end
    elseif data.opera == GUIDefine.OprateType.ADD then
        for k, v in pairs(itemList) do
            CompoundItemData.OnCheckItemCount(v.item.Index, true)
        end
    elseif data.opera == GUIDefine.OprateType.DEL then
        for k, v in pairs(itemList) do
            CompoundItemData.OnCheckItemCount(v.item.Index, false)
        end
    elseif data.opera == GUIDefine.OprateType.CHANGE then
        for k, v in pairs(itemList) do
            local change = v.change or 0
            if change ~= 0 then
                CompoundItemData.OnCheckItemCount(v.item.Index, change > 0)
            else
                local itemType = SL:GetValue("ITEMTYPE", v.item)
                if itemType == SL:GetValue("ITEMTYPE_ENUM").Equip then
                    CompoundItemData.OnCheckItemCount(v.item.Index, false)
                end
            end
        end
    end
end

function CompoundItemData.OnCheckItemCount(index, isAdd)
    local needCurMaterialList = CompoundItemData._materialNeedList[index]
    if needCurMaterialList and next(needCurMaterialList) then
        for compoundID, count in pairs(needCurMaterialList) do
            -- 增删检测不同状态
            local state = CompoundItemData._compoundRedState[compoundID]
            local newState = true
            if (not state and isAdd) or (state and not isAdd) then
                local config = CompoundItemData.GetConfigByID(compoundID)
                local isCanCompound = true

                local showConditionStr = config.showcondition
                if isCanCompound and showConditionStr then
                    isCanCompound = CompoundItemData.CheckStrCondition(showConditionStr)
                end

                if isCanCompound then
                    isCanCompound = CompoundItemData.CheckIsCanCompoud(config, false)
                end

                newState = isCanCompound
                CompoundItemData._compoundRedState[compoundID] = isCanCompound
            end

            SL:onLUAEvent(LUA_EVENT_COMPOUND_RED_POINT, {
                change = state ~= newState,
                id = compoundID,
            })
        end
    end
end


function CompoundItemData.OnUpdateQuickUseItem(data)
    if not data or not next(data) or not data.itemData then
        return
    end

    local operType = data.oper
    if operType == GUIDefine.OprateType.CHANGE then
        operType = data.isAdd and GUIDefine.OprateType.ADD or GUIDefine.OprateType.DEL
    end

    local operData = {
        oper = operType,
        operID = {}
    }
    table.insert(operData.operID, {item = data.itemData})
    CompoundItemData.OnUpdateItemChange(operData)

end

-- 合成物品结果
function CompoundItemData.OnCompoundItemResult(data)
    local code = data.code
    local id = data.id

    local config = id and CompoundItemData.GetConfigByID(id) or {}
    if code == 0 then -- 成功
        if config.CGmessage then
            SL:ShowSystemTips(config.CGmessage)
        end
    elseif code == -1 or code == -2 then -- 失败
        if config.CGmessage then
            SL:ShowSystemTips(config.SBmessage)
        end
    end
end

----------------------------------------------------------
function CompoundItemData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MONEY_CHANGE, "CompoundItemData", CompoundItemData.OnMoneyChangeCount)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "CompoundItemData", CompoundItemData.OnUpdateItemChange)
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, "CompoundItemData", CompoundItemData.OnUpdateQuickUseItem)
    SL:RegisterLUAEvent(LUA_EVENT_COMPOUND_ITEM_RESULT, "CompoundItemData", CompoundItemData.OnCompoundItemResult)
end
----------------------------------------------------------

CompoundItemData.Init()