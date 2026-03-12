HeroEquipData = HeroEquipData or {}

function HeroEquipData.Init()
    -- 装备MakeIndex maps
    HeroEquipData._equipMakeIndexDatas = {}
    
    -- 装备pos maps
    HeroEquipData._equipPosDatas = {}

    -- 生肖盒子状态
    HeroEquipData._bestRingsOpen = false
end

function HeroEquipData.ClearEquipData()
    HeroEquipData._equipMakeIndexDatas = {}
    HeroEquipData._equipPosDatas = {}
end

function HeroEquipData.GetEquipData()
    return HeroEquipData._equipMakeIndexDatas or {}
end

function HeroEquipData.GetEquipPosData()
    return HeroEquipData._equipPosDatas
end

function HeroEquipData.GetEquipDataByMakeIndex(makeIndex)
    return HeroEquipData._equipMakeIndexDatas[makeIndex]
end

-- 通过pos获取装备
function HeroEquipData.FindEquipDataByPos(pos)
    local makeIndex = HeroEquipData._equipPosDatas and HeroEquipData._equipPosDatas[pos]
    if makeIndex then
        return HeroEquipData.GetEquipDataByMakeIndex(makeIndex)
    else
        return nil
    end
end

function HeroEquipData.GetBestRingsOpenState()
    return HeroEquipData._bestRingsOpen
end

function HeroEquipData.SetBestRingsOpenState(state)
    HeroEquipData._bestRingsOpen = state
end

function HeroEquipData.AddEquipData(item, isInit)
    local makeIndex = item.MakeIndex
    local pos       = item.Where

    -- 当前位置已有装备，先删除
    local lastItem = GUIFunction:GetEquipDataByPos(pos, nil, GUIDefine.EquipDataType.HEROEQUIP)
    if lastItem then
        HeroEquipData.DelEquipData(lastItem)
    end

    -- 数据存储
    HeroEquipData._equipMakeIndexDatas = HeroEquipData._equipMakeIndexDatas or {}
    HeroEquipData._equipMakeIndexDatas[makeIndex] = item

    HeroEquipData._equipPosDatas = HeroEquipData._equipPosDatas or {}
    HeroEquipData._equipPosDatas[pos] = makeIndex

    -- 设置装备所属
    SL:SetValue("ITEM_BELONG_BY_MAKEINDEX", makeIndex, GUIDefine.ItemBelong.HEROEQUIP)

    if not isInit then
        local data = {
            MakeIndex = makeIndex,
            Where     = pos,
            ItemData  = item,
            opera     = GUIDefine.OperateType.ADD
        }
        SL:onLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, data)
    end
end

function HeroEquipData.DelEquipData(item, noTakeOff)
    local makeIndex = item.MakeIndex
    local pos       = item.Where

    local oldItem   = HeroEquipData.GetEquipDataByMakeIndex(makeIndex)
    if not oldItem then
        return
    end

    if not noTakeOff then
        AutoUseItemData.SetTakeOffEquipMask(makeIndex)
    end

    -- 存储数据
    HeroEquipData._equipPosDatas[pos] = nil
    HeroEquipData._equipMakeIndexDatas[makeIndex] = nil

    -- 通知
    local data = {
        MakeIndex = makeIndex,
        Where     = pos,
        ItemData  = item,
        opera     = GUIDefine.OperateType.DEL
    }

    SL:onLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, data)
end

function HeroEquipData.ChangeEquipData(item, bagDelayUpdate, isChangeLook)
    local makeIndex = item.MakeIndex
    local pos       = item.Where

    local oldItem = HeroEquipData.GetEquipDataByMakeIndex(makeIndex)
    if not oldItem then
        return
    end
    
    -- 数据存储
    HeroEquipData._equipMakeIndexDatas[makeIndex] = item

    -- 通知
    local data = {
        MakeIndex      = makeIndex,
        Where          = pos,
        bagDelayUpdate = bagDelayUpdate,
        isChangeLook   = isChangeLook,
        opera          = GUIDefine.OperateType.CHANGE
    }

    SL:onLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, data)
end

function HeroEquipData.GetEmbattle()
    return HeroEquipData._embattle
end

function HeroEquipData.SetEmbattle(embattle)
    HeroEquipData._embattle = embattle
end

function HeroEquipData.handle_MSG_SC_EQUIP_Embattle_RESPONSE(embattle)
    HeroEquipData.SetEmbattle(embattle)
    SL:onLUAEvent(LUA_EVENT_HERO_EMBATTLE_CHANGE)
end

-- 装备穿戴成功
function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_ON_SUCCESS(pos)
    SL:onLUAEvent(LUA_EVENT_HERO_TAKE_ON_EQUIP, {isSuccess = true, pos = pos})
    SL:SetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX", nil)
end

-- 装备穿戴失败
function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_ON_FAIL(pos)
    SL:onLUAEvent(LUA_EVENT_HERO_TAKE_ON_EQUIP, {isSuccess = false, pos = pos})
    if SL:GetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX") then
        SL:onLUAEvent(LUA_EVENT_HERO_BAG_ITEM_POS_CHANGE, {SL:GetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX")})
        SL:SetValue("LAST_MOVE_TAKEON_ITEM_MAKEINDEX", nil)
    end
end

-- 装备脱下成功
function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_OFF_SUCCESS(pos)
    SL:onLUAEvent(LUA_EVENT_HERO_TAKE_OFF_EQUIP, {isSuccess = true, pos = pos})
end

-- 装备脱下失败
function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_OFF_FAIL(data)
    SL:onLUAEvent(LUA_EVENT_HERO_TAKE_OFF_EQUIP, {isSuccess = false})

    local makeIndex = data.makeIndex
    if makeIndex ~= 0 then
        SL:onLUAEvent(LUA_EVENT_HERO_STATE_CHANGE, {MakeIndex = makeIndex, state = 1})
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
function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_INFO(items)
    local nItem = #items
    for i = 1, nItem do
        HeroEquipData.AddEquipData(items[i], true)
    end
    SL:onLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, {opera = GUIDefine.OperateType.INIT})
end

function HeroEquipData.handle_MSG_SC_PLAYER_EQUIP_BEST_RINGS_STATE(state)
    local isOpen = false
    if EquipData._bestRingsOpen and state then
        isOpen = true
    end
    HeroEquipData.SetBestRingsOpenState(state)
    SL:onLUAEvent(LUA_EVENT_HERO_BESTRINGBOX_STATE, isOpen)
end

return HeroEquipData