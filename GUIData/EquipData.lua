EquipData = EquipData or {}

function EquipData.Init()
    -- 装备MakeIndex maps
    EquipData._equipMakeIndexDatas = {}

    -- 装备pos maps
    EquipData._equipPosDatas = {}

    -- 头发偏移
    EquipData._modelViewHairOff = {}
    -- 装备偏移
    EquipData._modelViewEquipOff = {}
    -- 生肖盒子状态
    EquipData._bestRingsOpen = false

    EquipData.LoadHairOffset()
    EquipData.LoadEquipOffset()
end

-- 加载头发偏移
function EquipData.LoadHairOffset()
    local filename = "data_config/hair_offest.txt"
    if not SL:IsFileExist(filename) then
        return false
    end

    local jsonStr  = SL:GetDataFromFileEx(filename)
    local jsonData = {}
    
    xpcall(
        function()
            jsonData = SL:JsonDecode(jsonStr)
        end,
    
        function()
            if SL._DEBUG then
                SL:ShowSystemTips(string.format("json文件格式错误: %s", filename))
            end
        end
    )

    for key, value in pairs(jsonData) do
        local offValue = {
            x = value.x,
            y = value.y
        }
        if SL:GetValue("IS_PC_OPER_MODE") then
            if value.x1 then
                offValue.x = value.x1
            end
            if value.y1 then
                offValue.y = value.y1
            end
        end
        EquipData._modelViewHairOff[tonumber(key)] = offValue
    end
end

-- 加载装备偏移
function EquipData.LoadEquipOffset()
    local function loadEquipOffset(filename, index)
        if not SL:IsFileExist(filename) then
            return false
        end

        local jsonStr  = SL:GetDataFromFileEx(filename)
        local jsonData = {}
        
        xpcall(
            function()
                jsonData = SL:JsonDecode(jsonStr)
            end,
        
            function()
                if SL._DEBUG then
                    SL:ShowSystemTips(string.format("json文件格式错误: %s", filename))
                end
            end
        )

        for key, value in pairs(jsonData) do
            local offValue = {
                x = value.x,
                y = value.y
            }

            if SL:GetValue("IS_PC_OPER_MODE") then
                if value.x1 then
                    offValue.x = value.x1
                end
                if value.y1 then
                    offValue.y = value.y1
                end
            end
            EquipData._modelViewEquipOff[tonumber(key) + index * 10000] = offValue
        end
    end

    for i = 0, 10 do
        local filename = string.format("res/player_show/player_show_%s/equip_offest.txt", i)
        loadEquipOffset(filename, i)
    end
end

-- 获取装备偏移值
function EquipData.GetEquipModelOffSet()
    return EquipData._modelViewEquipOff
end

-- 获取头发偏移值
function EquipData.GetModelHairOffSet()
    return EquipData._modelViewHairOff
end

function EquipData.ClearEquipData()
    EquipData._equipMakeIndexDatas = {}
    EquipData._equipPosDatas = {}
end

function EquipData.GetEquipData()
    return EquipData._equipMakeIndexDatas or {}
end

function EquipData.GetEquipPosData()
    return EquipData._equipPosDatas
end

function EquipData.GetEquipDataByMakeIndex(makeIndex)
    return EquipData._equipMakeIndexDatas[makeIndex]
end

-- 通过pos获取装备
function EquipData.FindEquipDataByPos(pos)
    local makeIndex = EquipData._equipPosDatas and EquipData._equipPosDatas[pos]
    if makeIndex then
        return EquipData.GetEquipDataByMakeIndex(makeIndex)
    else
        return nil
    end
end

function EquipData.GetBestRingsOpenState()
    return EquipData._bestRingsOpen
end

function EquipData.SetBestRingsOpenState(state)
    EquipData._bestRingsOpen = state
end

function EquipData.AddEquipData(item, isInit)
    local makeIndex = item.MakeIndex
    local pos       = item.Where

    -- 当前位置已有装备，先删除
    local lastItem = GUIFunction:GetEquipDataByPos(pos)
    if lastItem then
        EquipData.DelEquipData(lastItem)
    end

    -- 数据存储
    EquipData._equipMakeIndexDatas[makeIndex] = item
    EquipData._equipPosDatas[pos] = makeIndex

    -- 设置装备所属
    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex, GUIDefine.ItemBelong.EQUIP)

    if not isInit then
        local data = {
            MakeIndex = makeIndex,
            Where     = pos,
            ItemData  = item,
            opera     = GUIDefine.OperateType.ADD
        }
        SL:onLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, data)
    end
end

function EquipData.DelEquipData(item)
    local makeIndex = item.MakeIndex
    local pos       = item.Where

    local oldItem   = EquipData.GetEquipDataByMakeIndex(makeIndex)
    if not oldItem then
        return
    end

    -- 记录脱下的装备
    AutoUseItemData.SetTakeOffEquipMask(makeIndex)

    -- 存储数据
    EquipData._equipPosDatas[pos] = nil
    EquipData._equipMakeIndexDatas[makeIndex] = nil

    -- 清空装备所属
    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex, nil)

    -- 通知
    local data = {
        MakeIndex = makeIndex,
        Where     = pos,
        ItemData  = item,
        opera     = GUIDefine.OperateType.DEL
    }
    SL:onLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, data)
end

function EquipData.ChangeEquipData(item, bagDelayUpdate, isChangeLook)
    local makeIndex = item.MakeIndex
    local pos       = item.Where
    local oldItem = EquipData.GetEquipDataByMakeIndex(makeIndex)
    if not oldItem then
        return
    end
    
    -- 数据存储
    EquipData._equipMakeIndexDatas[makeIndex] = item

    -- 通知
    local data = {
        MakeIndex      = makeIndex,
        Where          = pos,
        item           = item,
        bagDelayUpdate = bagDelayUpdate,
        isChangeLook   = isChangeLook,
        opera          = GUIDefine.OperateType.CHANGE
    }

    SL:onLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, data)
end

function EquipData.GetEmbattle()
    return EquipData._embattle
end

function EquipData.SetEmbattle(embattle)
    EquipData._embattle = embattle
end

function EquipData.handle_MSG_SC_EQUIP_Embattle_RESPONSE(embattle)
    EquipData.SetEmbattle(embattle)
    SL:onLUAEvent(LUA_EVENT_PLAYER_EMBATTLE_CHANGE)
end

-- 装备穿戴成功
function EquipData.handle_MSG_SC_PLAYER_EQUIP_ON_SUCCESS(pos)
    SL:onLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, {isSuccess = true, pos = pos})
    SL:SetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX", nil)
end

-- 装备穿戴失败
function EquipData.handle_MSG_SC_PLAYER_EQUIP_ON_FAIL(pos)
    SL:onLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, {isSuccess = false, pos = pos})
    -- 刷新移动穿戴失败道具
    if SL:GetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX") then
        SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE, {SL:GetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX")})
        SL:SetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX", nil)
    end
end

-- 装备脱下成功
function EquipData.handle_MSG_SC_PLAYER_EQUIP_OFF_SUCCESS(pos)
    SL:onLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, {isSuccess = true, pos = pos})
end

-- 装备脱下失败
function EquipData.handle_MSG_SC_PLAYER_EQUIP_OFF_FAIL(data)
    SL:onLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, {isSuccess = false})

    local makeIndex = data.makeIndex
    if makeIndex ~= 0 then
        SL:onLUAEvent(LUA_EVENT_EQUIP_STATE_CHANGE, {MakeIndex = makeIndex, state = 1})
    end

    if data.errorCode == 0 then
        return
    end

    local stringCodes = {
        [-1]  = "位置错误",
        [-2]  = "未穿戴该位置物品",
        [-4]  = "无法取下",
        [-5]  = "背包已满",
        [-6]  = "未开启人物英雄背包互通",
        [-99] = "未知错误",
    }
    SL:ShowSystemTips(stringCodes[data.errorCode] or stringCodes[-99])
end

-- 登录服务器下发的装备数据
function EquipData.handle_MSG_SC_PLAYER_EQUIP_INFO(items)
    local nItem = #items
    for i = 1, nItem do
        EquipData.AddEquipData(items[i], true)
    end
    SL:onLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, {opera = GUIDefine.OperateType.INIT})
    SL:onLUAEvent(LUA_EVENT_PLAYER_EQUIP_INIT)
end

function EquipData.handle_MSG_SC_PLAYER_EQUIP_BEST_RINGS_STATE(state)
    local isOpen = false
    if EquipData._bestRingsOpen and state then
        isOpen = true
    end
    EquipData.SetBestRingsOpenState(state)
    SL:onLUAEvent(LUA_EVENT_BESTRINGBOX_STATE, isOpen)
end

return EquipData