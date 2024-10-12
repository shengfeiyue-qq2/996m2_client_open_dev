GUIFunction = GUIFunction or {}

--------------------------------------------------------------------------
local GetEquipUtil = function(type)
    if type == GUIDefine.EquipDataType.HEROEQUIP then
        return HeroEquipData
    elseif type == GUIDefine.EquipDataType.OTHER_EQUIP then
        return LookPlayerData
    elseif type == GUIDefine.EquipDataType.OTHER_HEROEQUIP then
        return LookPlayerData
    elseif type == GUIDefine.EquipDataType.TRADE_EQUIP or type == GUIDefine.EquipDataType.TRADE_HEROEQUIP then
        return TradingBankLookPlayerData
    else
        return EquipData
    end
end

-- 通过装备位置反向取装备显示部位
function GUIFunction:GetDeEquipMappingConfig(pos)
    if not pos then
        return nil
    end
    for belongPos, v in pairs(GUIDefine.EquipPosMappingEx) do
        for k, _pos in pairs(v) do
            if _pos == pos then
                return belongPos
            end
        end
    end
    return nil
end

function GUIFunction:GetEquipTakeOnPosByStdMode(stdMode, param, type)
    local stdMode      = stdMode or 0
    local minPowerPos  = -1
    local minWearPower = 0
    local hasEquip     = true

    local posArray = GUIDefine.EquipPosByStdMode[stdMode] or {}
    if not next(posArray) then
        return minPowerPos, minWearPower
    end

    local nPos = #posArray
    if nPos > 1 then
        for _, pos in pairs(posArray) do
            local equipData = GUIFunction:GetEquipDataByPos(pos, nil, type)
            if not equipData then
                minPowerPos  = pos
                minWearPower = 0
                hasEquip     = false
                break
            end
        end

        -- 如果没有空位
        if hasEquip then
            local pos = posArray[1]

            _G.LastTakeOnPosMask = _G.LastTakeOnPosMask or {}
            local choosePos = _G.LastTakeOnPosMask[pos] or 0
            choosePos = choosePos + 1
            if choosePos > nPos then
                choosePos = 1
            end
            _G.LastTakeOnPosMask[pos] = choosePos

            local equipData = GUIFunction:GetEquipDataByPos(choosePos, nil, type)
            if equipData then
                local equipPower = GUIFunction:GetEquipPower(equipData, param)
                minWearPower = equipPower
                minPowerPos = choosePos
            else
                minPowerPos = choosePos
                minWearPower = 0
                hasEquip = false
            end
        end
    else -- 单位置 直接为改位置
        local onlyPos = posArray[1]
        local equipData = GUIFunction:GetEquipDataByPos(onlyPos, nil, type)
        minPowerPos = onlyPos
        if not equipData then
            minWearPower = 0
            hasEquip = false
        else
            local equipPower = GUIFunction:GetEquipPower(equipData, param)
            minWearPower = equipPower
        end
    end
    return minPowerPos, minWearPower, hasEquip
end

-- 通过StdMode获取空装备位置
function GUIFunction:GetEmptyPosByStdMode(StdMode, type)
    local posList = GUIDefine.EquipPosByStdMode[StdMode] or {}
    for k, pos in ipairs(posList) do
        if not GUIFunction:GetEquipDataByPos(pos, nil, type) then
            return pos
        end
    end
    return posList[1]
end

-- 根据pos获取装备数据
function GUIFunction:GetEquipDataByPos(pos, beginOnMoving, type)
    local equipUtil = GetEquipUtil(type)
    local func = type == GUIDefine.EquipDataType.TRADE_HEROEQUIP and equipUtil.FindHeroEquipDataByPos or equipUtil.FindEquipDataByPos
    local data = func(pos)
    if beginOnMoving then
        local list = GUIFunction:GetEquipMappingConfig(pos) -- 单显示位置 多个装备位置共享
        if list then
            data = nil
            for _, v in ipairs(list) do
                data = func(v)
                if data then
                    break
                end
            end
        end
    end
    return data
end

-- 获取装备位置列表
function GUIFunction:GetEquipDataListByPos(pos, type)
    local equipUtil = GetEquipUtil(type)
    local FindEquipDataByPos = type == GUIDefine.EquipDataType.TRADE_HEROEQUIP and equipUtil.FindHeroEquipDataByPos or equipUtil.FindEquipDataByPos
    -- 单显示位置 多个装备位置共享
    local list = GUIFunction:GetEquipMappingConfig(pos)
    local data = {}

    if list then
        for _, v in ipairs(list) do
            local equipData = FindEquipDataByPos(v)
            if equipData then
                data[#data + 1] = equipData
            end
        end
    else
        local equipData = FindEquipDataByPos(pos)
        if equipData then
            data[#data + 1] = equipData
        end
    end

    return next(data) and data or nil
end

-- 通过MakeIndex获取数据
function GUIFunction:GetEquipDataByMakeIndex(makeIndex, type)
    local equipUtil = GetEquipUtil(type)
    local func = type == GUIDefine.EquipDataType.TRADE_HEROEQUIP and equipUtil.GetHeroEquipDataByMakeIndex or equipUtil.GetEquipDataByMakeIndex
    local data = func(makeIndex)
    return data
end

-- 获取身上装备数据
function GUIFunction:GetEquipPosData(type)
    local equipUtil = GetEquipUtil(type)
    local func = type == GUIDefine.EquipDataType.TRADE_HEROEQUIP and equipUtil.GetHeroEquipPosData or equipUtil.GetEquipPosData
    local data = func()
    return data or {}
end

-- 获取法阵
function GUIFunction:GetEmbattle(type)
    local equipUtil = GetEquipUtil(type)
    local data = equipUtil.GetEmbattle()
    return data
end

-- 玩家头发
function GUIFunction:GetRoleHair(type)
    local hairs = {
        [GUIDefine.RoleUIType.PLAYER]       = function () return SL:GetValue("HAIR") end,
        [GUIDefine.RoleUIType.HERO]         = function () return SL:GetValue("H.HAIR") end,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerData.GetPlayerHair,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookPlayerData.GetPlayerHair,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = TradingBankLookPlayerData.GetPlayerHair,
        [GUIDefine.RoleUIType.TRADE_HERO]   = TradingBankLookPlayerData.GetHeroHair,
    }
    return (hairs[type] or hairs[GUIDefine.RoleUIType.PLAYER])()
end

function GUIFunction:GetRoleSex(type)
    local hairs = {
        [GUIDefine.RoleUIType.PLAYER]       = function () return SL:GetValue("SEX") end,
        [GUIDefine.RoleUIType.HERO]         = function () return SL:GetValue("H.SEX") end,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerData.GetPlayerSex,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookPlayerData.GetPlayerSex,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = TradingBankLookPlayerData.GetPlayerSex,
        [GUIDefine.RoleUIType.TRADE_HERO]   = TradingBankLookPlayerData.GetHeroSex,
    }
    return (hairs[type] or hairs[GUIDefine.RoleUIType.PLAYER])()
end

function GUIFunction:GetRoleJob(type)
    local hairs = {
        [GUIDefine.RoleUIType.PLAYER]       = function () return SL:GetValue("JOB") end,
        [GUIDefine.RoleUIType.HERO]         = function () return SL:GetValue("H.JOB") end,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerData.GetPlayerSex,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookPlayerData.GetPlayerSex,
    }
    return (hairs[type] or hairs[GUIDefine.RoleUIType.PLAYER])()
end

function GUIFunction:GetBestRingsState(type)
    local equipUtil = GetEquipUtil(type)
    local func = type == GUIDefine.EquipDataType.TRADE_HEROEQUIP and equipUtil.GetHeroBestRingsOpenState or equipUtil.GetBestRingsOpenState
    local status = func()
    return status
end
-- 通过名字获取装备数据
function GUIFunction:GetEquipDataByName(name, type)
    if not name or name == "" then
        return {}
    end

    local equipUtil = GetEquipUtil(type)
    if not equipUtil then
        return {}
    end

    local data = equipUtil.GetEquipData()

    if not next(data) then
        return {}
    end
    
    local items = {}
    for k, v in pairs(data) do
        if v.originName == name or v.Name == name then
            items[#items + 1] = v
        end
    end
    return items
end

-- 检测装备所需性别
function GUIFunction:CheckEquipNeedSex(item, sex, type)
    if not item or not next(item) then
        return false
    end

    local stdMode = item.StdMode
    local sexOk = true
    local needSex = sex

    if not sex then
        if type == GUIDefine.EquipDataType.EQUIP then
            sex = SL:GetValue("SEX")
        elseif type == GUIDefine.EquipDataType.HEROEQUIP then
            sex = SL:GetValue("H.SEX")
        end
    end

    local equipNeedSexConfig = GUIDefine.EquipSexNeed or {}
    if equipNeedSexConfig[stdMode] and equipNeedSexConfig[stdMode] ~= needSex then
        sexOk = false
    end
    
    return sexOk
end

-- 检测负重
function GUIFunction:CheckEquipWeight(onItem, pos, type)
    if not onItem or not next(onItem) or not pos or pos < 0 then
        return false
    end

    local offItem = GUIFunction:GetEquipDataByPos(pos, nil, type)

    local equipNeedSexConfig = GUIDefine.EquipHandWeightType or {}

    local abilID = equipNeedSexConfig[onItem.StdMode] and GUIFunction:PShowAttType().Hand_Weight or GUIFunction:PShowAttType().Wear_Weight

    local onItemWeight  = onItem.Weight or 0
    local offItemWeight = offItem and offItem.Weight or 0

    local curWeight = 0
    local maxWeight = 0

    if type == GUIDefine.EquipDataType.EQUIP then
        curWeight = SL:GetValue("CUR_ABIL_BY_ID", abilID) or 0
        maxWeight = SL:GetValue("MAX_ABIL_BY_ID", abilID) or 0
    elseif type == GUIDefine.EquipDataType.HEROEQUIP then
        curWeight = SL:GetValue("H.CUR_ABIL_BY_ID", abilID) or 0
        maxWeight = SL:GetValue("H.MAX_ABIL_BY_ID", abilID) or 0
    end

    local afterEquip = onItemWeight - offItemWeight + curWeight

    return afterEquip <= maxWeight
end

--检测附身符使用  (因为护身符可以穿戴在右手镯，当附身符有穿戴，双击以及自动使用时不能穿戴，只能拖拽穿戴)
function GUIFunction:CheckBujukUse(item)
    local stdMode = item and item.StdMode
    if stdMode == GUIDefine.EquipPosUI.Equip_Type_Super_RingR then
        return true, GUIDefine.EquipPosUI.Equip_Type_Bujuk
    end
    return stdMode
end

-- 是否是十二生肖
function GUIFunction:CheckBestRingsSpace(type)
    for pos = GUIDefine.EquipPosUI.Equip_Type_BestRing1, GUIDefine.EquipPosUI.Equip_Type_BestRing12 do
        local data = GUIFunction:GetEquipDataByPos(pos, nil, type)
        if not data then
            return pos
        end
    end
    return false
end

-- 检测装备条件
function GUIFunction:CheckEquipCondition(pos)
    -- 获取装备条件
    if not EquipData.equipConditions then
        EquipData.equipConditions = {}
        local equipConditions = SL:GetValue("GAME_DATA","zhanguxianshi") or ""
        if equipConditions and equipConditions ~= "" then
            local paramStr = string.split(equipConditions, "-")
            for i,v in ipairs(paramStr) do
                local equipPosAndCondtions = v
                if equipPosAndCondtions and equipPosAndCondtions ~= "" then
                    local param = string.split(equipPosAndCondtions, "&")
                    local equipPos = tonumber(param[1])
                    local conditions = param[2]
                    if equipPos then
                        EquipData.equipConditions[equipPos] = conditions
                    end
                end
            end
        end
    end
    
    local equipCondition = EquipData.equipConditions[pos]
    if equipCondition then
        local checkConditions = equipCondition or ""
        local ConditionProxy = global.Facade:retrieveProxy(global.ProxyTable.ConditionProxy)
        if ConditionProxy:CheckCondition(checkConditions) then
            return true
        else
            return false
        end
    end
    return true
end

-- 自定义装备使用
function GUIFunction:SetCustomPlayerEquip(customData)
    if not customData or string.len(customData) <= 0 then
        return
    end

    local itemArray = string.split(customData, "#")
    for _, v in ipairs(itemArray) do
        local posArray   = string.split(v, "=")
        local pos        = tonumber(posArray[1])
        local stdModeStr = posArray[2]
        if pos and stdModeStr and string.len(stdModeStr) > 0 then
            local stdModeArray = string.split(stdModeStr, ",")
            for _, stdMode in ipairs(stdModeArray) do
                stdMode = tonumber(stdMode)
                if stdMode then
                    GUIDefine.EquipPosByStdMode[stdMode] = GUIDefine.EquipPosByStdMode[stdMode] or {}
                    table.insert(GUIDefine.EquipPosByStdMode[stdMode], pos)
                    GUIDefine.EquipMapByStdMode[stdMode] = true
                end
            end
        end
    end
end

-- 获取当前位置的装备位
function GUIFunction:GetEquipMappingConfig(pos)
    return GUIDefine.EquipPosMappingEx[pos]
end

--------------------------------------------------------装备面板装备操作---------------------------------------------------------------------------
function GUIFunction:DealEquipTouch(widget, eventType, params)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local IsPC = SL:GetValue("IS_PC_OPER_MODE")

    local pos         = params.pos
    local from        = params.from
    local moveCallBack = params.moveCallBack
    local onClick     = params.onClick
    local onPress     = params.onPress
    local onDouble    = params.onDouble
    local dataType    = params.dataType

    local MoveEvent   = {
        BEGAN         = 1,
        MOVEING       = 2,
        ENDED         = 3
    }

    local updateEquipState = function(state, where, movePos)
        if MoveEvent.MOVEING == state then
            SL:ItemMoveUpdate({pos = movePos})
        elseif MoveEvent.ENDED == state then
            SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_END, movePos)
        else
            -- BEGAN
            local itemData = GUIFunction:GetEquipDataByPos(where, nil, dataType)
            if not itemData then
                return false
            end

            if SL:GetValue("ITEM_MOVE_STATE") then
                return false
            end
        
            UIOperator:CloseItemTips()
        
            local beginCallBack = moveCallBack
            local endCallBack   = moveCallBack
            
            -- 开始
            if beginCallBack then
                beginCallBack(widget, true, where)
            end

            SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_BEGIN, {
                from = from,
                pos  = movePos,
                itemData = itemData,
                cancelCallBack = function ()
                    if endCallBack then
                        widget.__hasEventCallOnTouchBegin = false
                        widget.__lastClickTime = false
                        endCallBack(widget, false, where)
                    end
                end
            }) 
        end
    end

    local delayCallback = function ()
        if not onPress then
            return false
        end

        widget.__isPress = true
    
        if not widget.__isMoving then
            return onPress(widget, pos)
        end
        
        local movedPos = GUI:getTouchMovePosition(widget)
        local beganPos = GUI:getTouchBeganPosition(widget)

        local dis = SL:GetPointLengthSQ(SL:GetSubPoint(movedPos, beganPos))
        if dis > 100 then
            return false
        end

        onPress(widget, pos)
    end

    if eventType == GUIDefine.TouchEventType.BEGAN then
        widget.__isPress = false
        widget.__isMoving = false
        widget.__hasEventCallOnTouchBegin = true

        SL:scheduleOnce(widget, function () delayCallback() end, GUIDefine.CLICK_DOUBLE_TIME)
    elseif eventType == GUIDefine.TouchEventType.MOVED then
        if IsPC then
            return false
        end

        local movedPos = GUI:getTouchMovePosition(widget)
        local beganPos = GUI:getTouchBeganPosition(widget)        
        if not widget.__isMoving then
            local dis = SL:GetPointLengthSQ(SL:GetSubPoint(movedPos, beganPos))
            if dis > 100 then
                widget.__isMoving = true
                updateEquipState(MoveEvent.BEGAN, pos, movedPos)
            end
        end
        updateEquipState(MoveEvent.MOVEING, pos, movedPos)
    elseif eventType == GUIDefine.TouchEventType.ENDED then
        GUI:stopAllActions(widget)
        if widget.__isMoving then
            updateEquipState(MoveEvent.ENDED, pos, GUI:getTouchEndPosition(widget))
        elseif widget.__isPress then
        elseif onDouble then
            if widget.__lastClickTime then
                if widget.__clickDelayHandler then
                    SL:UnSchedule(widget.__clickDelayHandler)
                    widget.__clickDelayHandler = nil
                end
                onDouble(pos)
                widget.__lastClickTime = false
            else
                widget.__lastClickTime = true
                -- 记录单击触发
                -- 记录进入此处时的状态，避免在延时操作后状态被改变
                widget.__clickDelayHandler = SL:ScheduleOnce(function ()
                    if onClick and widget.__hasEventCallOnTouchBegin then
                        if IsPC then
                            if widget._movingState then
                                SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL)
                                widget._movingState = false
                            else
                                updateEquipState(MoveEvent.BEGAN, pos, GUI:getWorldPosition(widget))
                            end
                        else
                            onClick(widget, pos)
                        end
                    end
                    widget.__hasEventCallOnTouchBegin = false
                    widget.__lastClickTime = false
                end, 0.2)
            end
        elseif onClick then
            if IsPC and not widget._movingState then
                updateEquipState(MoveEvent.BEGAN, pos, GUI:getWorldPosition(widget))
            else
                onClick(widget, pos)
            end
        end
    elseif eventType == GUIDefine.TouchEventType.CANCALED then
        if not IsPC then
            updateEquipState(MoveEvent.ENDED, pos, GUI:getTouchEndPosition(widget))
        end
        widget.__hasEventCallOnTouchBegin = false
    end
end

-- PC鼠标放在装备框上滚动事件
function GUIFunction:InitItemTipsScrollEvent(widget, tag)
    if GUI:Win_IsNull(widget) then
        return false
    end

    local callBack = function (data)
        local event = ItemTips and ItemTips.OnMouseScroll
        if event then
            event(data)
        end
    end

    SL:RegisterWndEvent(widget, tag, WND_EVENT_MOUSE_WHEEL, callBack)
end

-- PC注册鼠标经过装备框事件
function GUIFunction:InitMouseMoveToEquipEvent(widget, pos, callback)
    local function onShowItemTips()
        local isMoving = SL:GetValue("ITEM_MOVE_STATE")
        if isMoving then
            return false
        end

        if callback then
            callback(widget, pos)
        end
    end

    local function onLeaveFunc() 
        UIOperator:CloseItemTips()
    end

    local function onEnterFunc()
        SL:scheduleOnce(widget, onShowItemTips, 0.2)
    end

    GUI:addMouseMoveEvent(widget, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})
end
--------------------------------------------------------------------------------------------------------------------------------------------------