AutoUseItemData = AutoUseItemData or {}

function AutoUseItemData.Init()
    -- 不显示的装备
    AutoUseItemData._hideEquips = {
        [1]  = {},              -- key: MakeIndex
        [2]  = {},              -- key: Index
        [3]  = {},              -- key: Name, value: 次数(可能有好几个)
        [99] = false,           -- 总开关 是否打开提示 默认不提示
    }

    -- tips的装备数据 {key: 装备位  value: 装备唯一id}
    AutoUseItemData._tipsEquip = {
        [GUIDefine.TitleType.PLAYER] = {},   -- 人物
        [GUIDefine.TitleType.HERO]   = {}    -- 英雄
    }

    -- 记录脱下的装备
    AutoUseItemData._takeOffEquipMask = {}
end

-- 记录脱下装备
function AutoUseItemData.SetTakeOffEquipMask(makeIndex)
    AutoUseItemData._takeOffEquipMask = AutoUseItemData._takeOffEquipMask or {}
    AutoUseItemData._takeOffEquipMask[makeIndex] = true 
end

-- 判断是否是脱下的装备
function AutoUseItemData.IsEquipOffByMakeIndex(makeIndex)
    if AutoUseItemData._takeOffEquipMask and AutoUseItemData._takeOffEquipMask[makeIndex] then
        AutoUseItemData._takeOffEquipMask[makeIndex] = nil
        return true
    end
    return false
end

-- 装备是否不弹出
function AutoUseItemData.IsEquipNotTip(data)
    if AutoUseItemData._hideEquips[99] then
        return true
    end

    if not data or not next(data) then
        return true
    end

    local name      = tostring(data.Name) or -1
    local index     = tostring(data.Index) or -1
    local makeIndex = tostring(data.MakeIndex) or -1

    if AutoUseItemData._hideEquips[1][makeIndex] or AutoUseItemData._hideEquips[2][index] or AutoUseItemData._hideEquips[3][name] then
        return true
    end

    return false
end

-- 通过makeIndex获取tips装备部位
function AutoUseItemData.GetBagPosByMakeIndex(makeIndex)
    for _, data in ipairs(AutoUseItemData._tipsEquip) do
        for pos, v in pairs(data) do
            if v == makeIndex then
                return pos
            end
        end
    end
    return nil
end

-- 已添加的弹窗物品唯一ID param1: 类型 1: 人物 2: 英雄 param2: 装备位
function AutoUseItemData.GetMakeIndexByPos(type, pos)
    if (type ~= GUIDefine.TitleType.PLAYER and type ~= GUIDefine.TitleType.HERO) or not pos then
        return nil
    end

    local list = AutoUseItemData._tipsEquip[type] or {}
    return list[pos]
end

function AutoUseItemData.SetMakeIndexByPos(type, pos, makeIndex)
    type = type or GUIDefine.TitleType.PLAYER
    if (type ~= GUIDefine.TitleType.PLAYER and type ~= GUIDefine.TitleType.HERO) or not pos then
        return nil
    end

    AutoUseItemData._tipsEquip[type][pos] = makeIndex
end

-- 移除tips的装备数据 pos: 装备位 playerType:人物类型(1: 人物; 2: 英雄)
function AutoUseItemData.RemoveEquipTip(pos, type)
    if not pos then
        return false
    end

    AutoUseItemData._tipsEquip[type or GUIDefine.TitleType.PLAYER][pos] = nil
end

-- 服务端通知不显示自动穿戴的消息
function AutoUseItemData.handle_MSG_SC_NOT_AUTO_TIPS_EQUIPS(data)
    local result = data.result
    local reason = data.reason      -- 1：删除； 否则添加
    local value  = data.value

    if result == 1 or result == 2 or result == 3 then
        local key = tostring(value)
        local num = AutoUseItemData._hideEquips[result][key] or 0
        if reason == 1 then
            num = num - 1
        else
            num = num + 1
        end

        if num > 0 then
            AutoUseItemData._hideEquips[result][key] = num
        else
            AutoUseItemData._hideEquips[result][key] = nil
        end
    elseif result == 99 then
        -- 1关闭; 否则开启
        AutoUseItemData._hideEquips[99] = not (tonumber(value or 0) ~= 1)
    end
end
