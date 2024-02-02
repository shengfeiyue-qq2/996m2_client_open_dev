GUIShare = {}

-- 属性类型
local attTypeTable = {
    HP                          = 1, -- 生命
    MP                          = 2, -- 魔法
    Min_ATK                     = 3, -- 物攻下限
    Max_ATK                     = 4, -- 物攻上限
    Min_MAT                     = 5, -- 魔攻下限
    Max_MAT                     = 6, -- 魔攻上限
    Min_Daoshu                  = 7, -- 道术下限
    Max_Daoshu                  = 8, -- 道术上限
    Min_DEF                     = 9, -- 物防下限
    Max_DEF                     = 10, -- 物防上限
    Min_MDF                     = 11, -- 魔防下限
    Max_MDF                     = 12, -- 魔防上限
    Hit_Point                   = 13, -- 准确
    Speed_Point                 = 14, -- 敏捷
    Anti_Magic                  = 15, -- 魔法躲避
    Anti_Posion                 = 16, -- 毒物躲避
    Posion_Recover              = 17, -- 中毒恢复
    Health_Recover              = 18, -- 体力恢复
    Spell_Recover               = 19, -- 魔法恢复
    Hit_Speed                   = 20, -- 攻速
    Double_Rate                 = 21, -- 暴击
    Double_Damage               = 22, -- 爆伤
    Defence                     = 23, -- 韧性
    Double_Defence              = 24, -- 暴击抵抗
    More_Damage                 = 25, -- 增加伤害
    ATK_Defence                 = 26, -- 物伤减免
    MAT_Defence                 = 27, -- 魔伤减免
    Ignore_Defence              = 28, -- 忽视防御
    Bounce_Damage               = 29, -- 反弹伤害
    Health_Add                  = 30, -- 体力增加
    Magice_Add                  = 31, -- 魔力增加
    More_Item                   = 32, -- 爆率增加
    Less_Item                   = 33, -- 爆率降低
    Vampire                     = 34, -- 吸血
    A_M_D_Add                   = 35, -- 攻魔道加成
    Defence_Add                 = 36, -- 防御加成
    MDefence_Add                = 37, -- 魔防加成
    God_Damage                  = 38, -- 神圣伤害
    Lucky                       = 39, -- 幸运
    Monster_Damage_Value        = 40, -- 对怪增伤 固定值
    Monster_Damage_Per          = 41, -- 对怪增伤
    Anger_Recover               = 42, -- 怒气恢复
    Combine_Skill_Damage        = 43, -- 合击伤害
    Monster_DropItem            = 44, -- 怪物爆率
    No_Palsy                    = 45, -- 防止麻痹
    No_Protect                  = 46, -- 防止护身
    No_Rebirth                  = 47, -- 防止复活
    No_ALL                      = 48, -- 防止全度
    No_Charm                    = 49, -- 防止诱惑
    No_Fire                     = 50, -- 防止火墙
    No_Ice                      = 51, -- 防止冰冻
    No_Web                      = 52, -- 防止蛛网

    Att_UnKonw                  = 53, -- 没配 未知

    More_A_Damage               = 54, -- 对战士伤害增加
    Less_A_Damage               = 55, -- 受到战士伤害减免
    More_M_Damage               = 56, -- 对法师伤害增加
    Less_M_Damage               = 57, -- 受到法师伤害减免
    More_D_Damage               = 58, -- 对伤道士害增加
    Less_D_Damage               = 59, -- 受到道士伤害减免
    More_Health_Per             = 60, -- 生命加成
    HP_Recover                  = 61, -- 生命恢复
    MP_Recover                  = 62, -- 魔法恢复
    Block_Rate                  = 63, -- 格挡概率
    Block_Value                 = 64, -- 格挡概率
    Drop_Rate                   = 65, -- 掉落概率
    Exp_Add_Rate                = 66, -- 经验倍率
    Damage_Rate_Add             = 67, -- 基础倍攻
    Damage_Human                = 68, -- 对人伤害
    Ice_Rate                    = 69, -- 冰冻概率
    Defen_Ice                   = 70, -- 防止冰冻
    Sec_Recovery_HP             = 71, -- 每秒回血,
    Mon_Bj_Power_Rate           = 72, -- 对怪爆率,
    DC_Add_Rate                 = 73, -- 击力倍数,
    Monster_Damage              = 74, -- 对怪伤害
    Monster_Damage_Percent      = 75, -- 对怪增伤
    PK_Damage_Add_Percent       = 76, -- PK增伤
    PK_Damage_Dec_Percent       = 77, -- PK减伤
    Penetrate                   = 78, -- 穿透
    Death_Hit_Percent           = 79, -- 致命一击
    Death_Hit_Value             = 80, -- 致命伤害
    Monster_Suck_HP_Rate        = 81, -- 吸血比例
    Monster_Vampire             = 82, -- 对怪物吸血
    Less_Monster_Damage         = 83, -- 减少来自怪物的伤害
    Drug_Recover                = 84, -- 药品恢复
    Ignore_Def_Dec              = 85, -- 忽视防御抵抗
    Fire_Hit_Dec_Rate           = 86, -- 烈火减免
    Ergum_Hit_Dec_Rate          = 87, -- 刺杀减免
    Hit_Plus_Dec_Rate           = 88, -- 攻杀减免
    Health_Add_WPer             = 89, -- 生命加成（万分比
    Death_Hit_Dec_Percent       = 90, -- 致命一击几率减
    Sec_Recovery_MP             = 91, -- 每秒回蓝
    Strength                    = 92, -- 强度
    Curse                       = 93, -- 诅咒
    Weight                      = 94, -- 当前重量
    Max_Weight                  = 95, -- 玩家最大负重
    Wear_Weight                 = 96, -- 穿戴负重
    Max_Wear_Weight             = 97, -- 最大穿戴负重
    Hand_Weight                 = 98, -- 腕力
    Max_Hand_Weight             = 99, -- 当前最大可穿戴腕力
}
GUIShare.BaseAttTypeTable = attTypeTable

function PShowAttType()
    return attTypeTable
end

-- 服务端下发的额外id对应的属性类型列表
local exAttList = {
    [0] = attTypeTable.Max_DEF,
    [1] = attTypeTable.Max_MDF,
    [2] = attTypeTable.Max_ATK,
    [3] = attTypeTable.Max_MAT,
    [4] = attTypeTable.Max_Daoshu,
    [5] = attTypeTable.Lucky,
    [6] = attTypeTable.Hit_Point,
    [7] = attTypeTable.Speed_Point,
    [8] = attTypeTable.Hit_Speed,
    [9] = attTypeTable.Anti_Magic,
    [10] = attTypeTable.Anti_Posion,
    [11] = attTypeTable.Spell_Recover,
    [12] = attTypeTable.Health_Recover,
    [13] = attTypeTable.Posion_Recover,
    [20] = attTypeTable.ATK_Defence,
    [21] = attTypeTable.MAT_Defence,
    [22] = attTypeTable.Ignore_Defence,
    [23] = attTypeTable.Bounce_Damage,
    [24] = attTypeTable.Health_Add,
    [25] = attTypeTable.Magice_Add,
    [26] = attTypeTable.More_Item,
    [27] = attTypeTable.God_Damage,
    [28] = attTypeTable.Strength,
    [29] = attTypeTable.Curse,
    [30] = attTypeTable.Double_Rate,
    [31] = attTypeTable.Double_Damage,
    [32] = attTypeTable.More_Damage
}
GUIShare.ExAttrList = exAttList

local exAttType = {
    Max_DEF         = 0,
    Max_MDF         = 1,
    Max_ATK         = 2,
    Max_MAT         = 3,
    Max_Daoshu      = 4,
    Lucky           = 5,
    Hit_Point       = 6,
    Speed_Point     = 7,
    Hit_Speed       = 8,
    Anti_Magic      = 9,
    Anti_Posion     = 10,
    Health_Recover  = 11,
    Spell_Recover   = 12,
    Posion_Recover  = 13,

    Star            = 16,
    Fail_Star       = 17,
    Lian_hun        = 18,
    Refining        = 19,
    ATK_Defence     = 20,
    MAT_Defence     = 21,
    Ignore_Defence  = 22,
    Bounce_Damage   = 23,
    Health_Add      = 24,
    Magice_Add      = 25,
    More_Item       = 26,
    God_Damage      = 27,
    Strength        = 28,
    Curse           = 29,
    Double_Rate     = 30,
    Double_Damage   = 31,
    More_Damage     = 32,
}

--需要转换血量单位的属性
local HPUnitAttrs = {
    [attTypeTable.HP] = true,
    [attTypeTable.MP] = true,
    [attTypeTable.Min_ATK] = true,
    [attTypeTable.Max_ATK] = true,
    [attTypeTable.Min_ATK] = true,
    [attTypeTable.Max_ATK] = true,
    [attTypeTable.Min_MAT] = true,
    [attTypeTable.Max_MAT] = true,
    [attTypeTable.Min_Daoshu] = true,
    [attTypeTable.Max_Daoshu] = true,
    [attTypeTable.Min_DEF] = true,
    [attTypeTable.Max_DEF] = true,
    [attTypeTable.Min_MDF] = true,
    [attTypeTable.Max_MDF] = true
}

-- 合并属性
local mergeAttrConfig = {
    [attTypeTable.Min_ATK]      = {attTypeTable.Min_ATK, attTypeTable.Max_ATK},
    [attTypeTable.Max_ATK]      = {attTypeTable.Min_ATK, attTypeTable.Max_ATK},
    [attTypeTable.Min_MAT]      = {attTypeTable.Min_MAT, attTypeTable.Max_MAT},
    [attTypeTable.Max_MAT]      = {attTypeTable.Min_MAT, attTypeTable.Max_MAT},
    [attTypeTable.Min_Daoshu]   = {attTypeTable.Min_Daoshu, attTypeTable.Max_Daoshu},
    [attTypeTable.Max_Daoshu]   = {attTypeTable.Min_Daoshu, attTypeTable.Max_Daoshu},
    [attTypeTable.Min_DEF]      = {attTypeTable.Min_DEF, attTypeTable.Max_DEF},
    [attTypeTable.Max_DEF]      = {attTypeTable.Min_DEF, attTypeTable.Max_DEF},
    [attTypeTable.Min_MDF]      = {attTypeTable.Min_MDF, attTypeTable.Max_MDF},
    [attTypeTable.Max_MDF]      = {attTypeTable.Min_MDF, attTypeTable.Max_MDF},
    [attTypeTable.Weight]       = {attTypeTable.Weight, attTypeTable.Max_Weight},
    [attTypeTable.Max_Weight]   = {attTypeTable.Weight, attTypeTable.Max_Weight},
    [attTypeTable.Wear_Weight]  = {attTypeTable.Wear_Weight, attTypeTable.Max_Wear_Weight},
    [attTypeTable.Max_Wear_Weight] = {attTypeTable.Wear_Weight, attTypeTable.Max_Wear_Weight},
    [attTypeTable.Hand_Weight]     = {attTypeTable.Hand_Weight, attTypeTable.Max_Hand_Weight},
    [attTypeTable.Max_Hand_Weight] = {attTypeTable.Hand_Weight, attTypeTable.Max_Hand_Weight},
}

local function MergeAtts(list)
    local newList = {}
    -- 组合属性ID
    local function GetMergeAttID(min, max)
        if min and max then
            return min * 10000 + max
        else
            return min or max or 0
        end
    end
    for i, v in pairs(list) do
        local merges = mergeAttrConfig[v.id]
        if merges then
            local mergedId = GetMergeAttID(merges[1], merges[2])
            if not newList[mergedId] then
                newList[mergedId] = {
                    id = mergedId,
                    min = 0,
                    max = 0
                }
            end

            if v.id == merges[2] then
                newList[mergedId].max = v.value or 0
            else
                newList[mergedId].min = v.value or 0
            end
        else
            table.insert(newList, v)
        end
    end
    return newList
end

-- 获取属性展示方式
local function GetAttValueShowType(id)
    local list = {
        [30004] = 2,
        [50006] = 2,
        [70008] = 2,
        [90010] = 2,
        [110012] = 2,
        [940095] = 3,
        [960097] = 3,
        [980099] = 3
    }
    return list[id] or 1
end

-- 获取特殊属性名
local function GetSpecialAttrName(id)
    local strList = {
        [100000092] = "强度",
        [100000093] = "诅咒",
        [100030004] = "攻击",
        [100050006] = "魔法",
        [100070008] = "道术",
        [100090010] = "防御",
        [100110012] = "魔防",
        [100940095] = "背包负重",
        [100960097] = "装备负重",
        [100980099] = "手持负重"
    }
    return strList[id]
end

local function GetAttScaleType(id)
    local list = {
        [attTypeTable.Anti_Posion]      = 1,
        [attTypeTable.Anti_Magic]       = 1,
        [attTypeTable.Health_Recover]   = 1,
        [attTypeTable.Spell_Recover]    = 1
    }

    return list[id]
end

-- Tips获取属性数据显示
GUIShare.GetAttDataShow = function(att, stars, tipsShow)
    if not att or not next(att) then
        return {}
    end
    local attList = {}
    if att.id then -- 单条
        table.insert(attList, att)
    else
        attList = att
    end

    local function GetAttNumShow(id, min, max)
        local name = ""
        local valueStr = ""
        min = tonumber(min) or 0
        max = tonumber(max) or 0
        if id > 10000 then
            name = GetSpecialAttrName(100000000 + id)
            local type = GetAttValueShowType(id)
            local strWay = type == 2 and "%s-%s" or "%s/%s"
            valueStr = string.format(strWay, SL:HPUnit(min), SL:HPUnit(max))
            if stars then
                valueStr = min > 0 and valueStr or "+" .. SL:HPUnit(max)
            end
        else
            local config = SL:GetMetaValue("ATTR_CONFIG", id) or {}
            --[[
                type == 1 正常值 == 2 万分比 == 3 百分比
                目前服务器发送过来的万分比的数值 基本是 10% 中的 10/10
            ]]
            local changeName = nil
            if id == attTypeTable.Lucky then
                if min < 0 then
                    changeName = GetSpecialAttrName(100000000 + attTypeTable.Curse)
                    min = math.abs(min)
                end
            end
            valueStr = min .. ""
            valueStr = stars and "+" .. valueStr or valueStr
            local attNumType = config.type or 1

            if attNumType == 2 or attNumType == 3 then
                local percent = attNumType == 2 and 100 or 1
                local showValue = min / percent
                if GetAttScaleType(id) then
                    showValue = min * 10
                end
                if attNumType == 2 then --万分比都支持小数点后两位
                    showValue = string.format("%.2f", showValue) * 100 / 100
                    valueStr = string.format("%s%%", showValue)
                else
                    valueStr = string.format("%d%%", showValue)
                end
            else
                if HPUnitAttrs[id] then
                    valueStr = SL:HPUnit(min) .. ""
                    if stars then
                        valueStr = "+" .. valueStr
                    end
                end
            end

            local showName = config.name
            if changeName then
                name = changeName
            elseif id == attTypeTable.Strength or id == attTypeTable.Curse then
                name = GetSpecialAttrName(100000000 + id)
            else
                name = showName
            end
        end

        local lens = string.len(name)
        if lens == 6 then
            local addStr = "　　"
            local str1 = string.sub(name, 1, 3)
            local str2 = string.sub(name, 4, 6)
            local newStr = str1 .. addStr .. str2
            name = newStr
        elseif lens == 9 then
            local addStr = SL:GetMetaValue("WINPLAYMODE") and " " or "  "
            local addStr2 = SL:GetMetaValue("WINPLAYMODE") and " " or "  "
            local str1 = string.sub(name, 1, 3)
            local str2 = string.sub(name, 4, 6)
            local str3 = string.sub(name, 7, 9)
            local newStr = str1 .. addStr .. str2 .. addStr2 .. str3
            name = newStr
        end

        name = name .. "："
        return name, valueStr
    end

    attList = MergeAtts(attList)

    local attStrs = {}

    for k, v in pairs(attList) do
        local config = SL:GetMetaValue("ATTR_CONFIG", v.id)
        local configShow = config
        if tipsShow and configShow then
            configShow = config.noshowtips ~= 1
        end
        if v.id > 10000 or configShow then
            local name, value = GetAttNumShow(v.id, v.min or v.value, v.max)
            attStrs[v.id] = {
                name = name,
                value = value,
                id = v.id,
                color = config and config.color or nil
            }
        end
    end

    return attStrs
end

GUIShare.GetAttShowOrder = function(att, stars, tipsShow)
    local showList = GUIShare.GetAttDataShow(att, stars, tipsShow)
    if not att or next(att) == nil then
        return {}
    end
    local orederList = {}
    for k, v in pairs(showList) do
        table.insert(orederList, v)
    end

    table.sort(
        orederList,
        function(a, b)
            if a.id <= PShowAttType().Speed_Point and b.id <= PShowAttType().Speed_Point then
                return a.id < b.id
            elseif a.id > 10000 and b.id > 10000 then
                return a.id < b.id
            elseif a.id > 10000 and b.id <= PShowAttType().Speed_Point then
                return false
            elseif a.id <= PShowAttType().Speed_Point and b.id > 10000 then
                return true
            elseif a.id > 10000 then
                return true
            elseif b.id > 10000 then
                return false
            else
                return a.id < b.id
            end
        end
    )
    return orederList
end

function GetDuraStr(dura, maxdura, one)
    local txt
    if not one then
        txt = string.format("%s/%s", math.round(dura / 1000), math.round(maxdura / 1000))
    else
        txt = tostring(math.round(dura / 1000))
    end
    return txt
end

function GetDura100Str(dura, maxdura, one)
    local txt
    if not one then
        txt = string.format("%s/%s", math.round(dura), math.round(maxdura))
    else
        txt = tostring(math.round(dura))
    end
    return txt
end

GUIShare.ItemUseConditionColor = function(bEnable)
    if bEnable then
        return "#ffffff"
    end
    return "#ff0000"
end

GUIShare.ParseItemBaseAtt = function(att, job)
    local attList = {}
    if not att or att == "" or att == "0" or att == 0 then
        return attList
    end
    local attArray = string.split(att, "|")
    local myJob = job or SL:GetMetaValue("JOB")
    for k, v in pairs(attArray) do
        local attData = string.split(v, "#")
        local needJob = tonumber(attData[1])
        local attId = tonumber(attData[2])
        local attValue = tonumber(attData[3])
        if (myJob == 3 or needJob == 3 or needJob == myJob) then
            table.insert(
                attList,
                {
                    id = attId,
                    value = attValue
                }
            )
        end
    end
    return attList
end

GUIShare.CombineAttList = function(list1, list2)
    local newList = {}
    local attList = {}
    for k, v in pairs(list1) do
        if not newList[v.id] then
            newList[v.id] = v.value
        else
            newList[v.id] = newList[v.id] + v.value
        end
    end
    for k, v in pairs(list2) do
        if not newList[v.id] then
            newList[v.id] = v.value
        else
            newList[v.id] = newList[v.id] + v.value
        end
    end
    for k, v in pairs(newList) do
        table.insert(
            attList,
            {
                id = k,
                value = v or 0
            }
        )
    end
    return attList
end

function GetExAttType()
    return exAttType
end

GUIShare.GetExAttList = function(values)
    local att = {}
    if not values or next(values) == nil then
        return att
    end
    local strengStarKey = GetExAttType().Star
    local failStarKey = GetExAttType().Fail_Star
    for k, v in pairs(values) do
        if v.Id ~= strengStarKey and v.Id ~= failStarKey and GUIShare.ExAttrList and GUIShare.ExAttrList[v.Id] then
            local attParam = {
                id = GUIShare.ExAttrList[v.Id],
                value = v.Value
            }
            table.insert(att, attParam)
        end
    end
    return att
end

-- 道具属性描述
GUIShare.GetItemAttDesc = function(item)
    local sFormat = string.format
    local equipMap = SL:GetMetaValue("EQUIPMAP_BY_STDMODE")
    local showLasting = SL:GetMetaValue("EX_SHOWLAST_MAP")
    local line1 = {}
    local line2 = {}
    local line3 = {}
    if item.Name ~= "" and item.StdMode then
        -- 显示重量
        if item.Weight and item.Weight > 0 then
            table.insert(line1, sFormat("重量：%s", item.Weight))
        end
        if equipMap[item.StdMode] or showLasting[item.StdMode] then
            table.insert(line1, sFormat("持久：%s", GetDuraStr(item.Dura, item.DuraMax)))
        elseif item.StdMode == 25 then --护身符及毒药
            line2 = {}
            table.insert(line2, sFormat("数量:%s", GetDura100Str(item.Dura / 100, item.DuraMax / 100)))
        elseif item.StdMode == 40 then --肉
            table.insert(line1, sFormat("品质：%s", GetDuraStr(item.Dura, item.DuraMax)))
        elseif item.StdMode == 43 then --矿石
            table.insert(line1, sFormat("纯度：%s", math.round(item.Dura / 1000)))
        elseif item.StdMode == 2 and item.Dura > 0 then --使用次数
            table.insert(line1, sFormat("使用次数：%s", GetDura100Str(item.Dura / 1000, item.DuraMax / 1000)))
        elseif item.StdMode == 49 then --聚灵珠经验
            if item.Dura >= item.DuraMax then
                table.insert(line1, sFormat("经验值已储蓄满(%s)万 双击释放", math.round(item.DuraMax / 10000)))
            else
                table.insert(line1, sFormat("积累经验：%s万", GetDura100Str(item.Dura / 10000, item.DuraMax / 10000)))
            end
        end
        local pos = SL:GetMetaValue("EQUIP_POS_BY_STDMODE", item.StdMode)
        if not pos then
        else
            -- 基础属性
            local attList = GUIShare.ParseItemBaseAtt(item.attribute)

            local starsAtt = nil
            local starsAttShow = nil
            -- 极品属性
            local exAtt = GUIShare.GetExAttList(item.Values)
            -- 合并极品属性
            if exAtt and next(exAtt) then
                attList = GUIShare.CombineAttList(attList, exAtt)
            end

            -- 属性显示队列
            local stringAtt = GUIShare.GetAttDataShow(attList)
            -- 重新排序
            local ipairList = {}
            for k, v in pairs(stringAtt) do
                v.id = k
                local attOne = v
                attOne.id = k
                table.insert(ipairList, attOne)
            end

            table.sort(
                ipairList,
                function(a, b)
                    local aid = a.id or 0
                    local bid = b.id or 0
                    if (aid > 10000 and bid > 10000) or (aid < 10000 and bid < 10000) then
                        return a.id < b.id
                    elseif aid > 10000 then
                        return true
                    elseif bid > 10000 then
                        return false
                    end
                end
            )
            -- 按序加入队列
            for k, v in ipairs(ipairList) do
                table.insert(line2, v.name .. v.value)
            end
        end

        local strList = SL:CheckItemUseNeed(item).conditionStr

        if strList and next(strList) then
            for i, v in ipairs(strList) do
                if not v.can then
                    local color = GUIShare.ItemUseConditionColor(v.can)
                    local conditionStr = string.format("<font color = '%s'>%s</font>", color, v.str)
                    table.insert(line3, conditionStr)
                end
            end
        end

        local strTable = {}
        table.insert(strTable, line1)
        table.insert(strTable, line2)
        table.insert(strTable, line3)
        return strTable
    end
    return nil
end

GetItemAttDataNew = GUIShare.GetItemAttDesc

GUIShare.OldParseItemDescType = function(str)
    if str and string.len(str) > 0 then
        local pareses = {}
        local textIndex = nil --文字不换行, 记录pareses的文字类型下标
        local function checkParese(pareseStr)
            if pareseStr and string.len(pareseStr) > 0 then
                local parese   = {}
                local descType = 1 --文字

                local newPareseArray = string.split(pareseStr, "&")
                pareseStr = newPareseArray[1] or ""
                local sfind, efind = string.find(pareseStr, "#")
                local descContent = nil
                local pareseArray = {}
                if sfind and efind then
                    descContent = string.sub(pareseStr, 1, efind - 1)

                    local paramStr = string.sub(pareseStr, efind + 1, -1)
                    pareseArray = string.split(paramStr or "", "|")
                else
                    descContent = pareseStr
                end

                parese.tag = tonumber(newPareseArray[2]) or 0 -- 0: 中间   1: 顶部   2: 底部  3: 外框顶部  4：外框底部
                parese.frameOrder = tonumber(newPareseArray[3]) or 1 -- 0: 下层 1: 上层
                local fStar, fEnd = string.find(pareseStr, "IMG:")
                if fStar and fEnd then
                    descType = 2
                    descContent = string.sub(descContent, fEnd + 1)
                    parese.res = string.gsub(descContent, "\\", "/")
                end

                if descType == 1 then
                    fStar, fEnd = string.find(descContent, "TEXIAO:")
                    if fStar and fEnd then
                        descType = 3
                        descContent = string.sub(descContent, fEnd + 1)
                        parese.res = tonumber(descContent) or nil
                        parese.isSFX = true
                    end
                end

                if descType == 1 then
                    if descContent == "-" then
                        parese.newLine = true
                    else
                        descContent = string.gsub(descContent, "TXT:", "")
                        parese.text = descContent
                        local starChar = string.sub(descContent or "", 1, 1)
                        local endChar = string.sub(descContent or "", -1, -1)
                        if starChar ~= "<" and endChar ~= ">" then
                            local cStart, cEnd = string.find(parese.text, "/FCOLOR")
                            if cStart and cEnd then
                                parese.text = "<" .. descContent .. ">"
                            end
                        end

                        if not textIndex then
                            textIndex = #pareses + 1
                        end
                    end
                end

                if descType == 1 and textIndex and pareses[textIndex] then
                    pareses[textIndex].text = pareses[textIndex].text .. parese.text
                else
                    local mobileParam = string.split(pareseArray[1] or "", "#")
                    local pcParam = string.split(pareseArray[2] or "", "#")
                    parese.x = tonumber(mobileParam[1]) or 0
                    parese.y = tonumber(mobileParam[2]) or 0
                    parese.width = tonumber(mobileParam[3]) or 0
                    parese.height = tonumber(mobileParam[4]) or 0

                    if SL:GetMetaValue("WINPLAYMODE") then
                        parese.x = tonumber(pcParam[1]) or parese.x
                        parese.y = tonumber(pcParam[2]) or parese.y
                        parese.width = tonumber(pcParam[3]) or parese.width
                        parese.height = tonumber(pcParam[4]) or parese.height
                    end

                    table.insert(pareses, parese)
                end
            end
        end

        local fStar, fEnd = nil, nil
        while str do
            fStar, fEnd = string.find(str, "%b<>")
            if fStar and fEnd then
                local newDes = string.sub(str, fStar + 1, fEnd - 1)
                checkParese(newDes)
                str = string.sub(str, fEnd + 1, -1)
            else
                checkParese(str)
            end

            if not fStar or not fEnd then
                break
            end
        end

        return pareses
    end
    return nil
end

GUIShare.ParseItemDecsType = function(signStr)
    if signStr and string.len(signStr) > 0 then
        local pareses = {}
        local parese = {}
        local isParese = false
        local fStar, fEnd = string.find(signStr, "<ID")

        if fStar and fEnd then
            isParese = true
            signStr = string.gsub(signStr, "^<*(.-)>*$", "%1")
        end

        local descContent = nil
        local contentArray = {}
        local descContentArray = {}
        if isParese then
            local sfind, efind = string.find(signStr, "|")
            local id = 0
            if sfind and efind then
                id = string.sub(signStr, 1, efind)
                id = tonumber(string.match(id or "", "%d+"))
                signStr = string.sub(signStr, efind + 1, -1)
            end
            parese.id = id or 0
            contentArray = string.split(signStr or "", "&")
            signStr = contentArray[1] or ""
            sfind, efind = string.find(signStr, "#")
            if sfind and efind then
                descContent = string.sub(signStr, 1, efind - 1)

                local paramStr = string.sub(signStr, efind + 1, -1)
                descContentArray = string.split(paramStr or "", "|")
            else
                descContent = signStr
            end
        else
            descContent = signStr
        end

        parese.tag = tonumber(contentArray[2]) or 0 -- 0: 中间   1: 顶部   2: 底部  3: 外框顶部  4：外框底部
        parese.frameOrder = tonumber(contentArray[3]) or 1 -- 0: 下层 1: 上层
        if descContent and descContent ~= "" then
            local descType = 1 --文字
            fStar, fEnd = string.find(descContent, "IMG:")
            if fStar and fEnd then
                descType = 2
                descContent = string.sub(descContent, fEnd + 1)
                parese.res = string.gsub(descContent, "\\", "/")
            end

            if descType == 1 then
                fStar, fEnd = string.find(descContent, "TEXIAO:")
                if fStar and fEnd then
                    descType = 3
                    descContent = string.sub(descContent, fEnd + 1)
                    parese.res = tonumber(descContent) or nil
                    parese.isSFX = true
                end
            end

            --EX
            if descType == 1 then
                fStar, fEnd = string.find(descContent, "IMGEX:")
                if fStar and fEnd then
                    descType = 4
                    descContent = string.sub(descContent, fEnd + 1)
                    parese.res = string.gsub(descContent, "\\", "/")
                end
            end

            if descType == 1 then
                fStar, fEnd = string.find(descContent, "TEXIAOEX:")
                if fStar and fEnd then
                    descType = 5
                    descContent = string.sub(descContent, fEnd + 1)
                    parese.res = tonumber(descContent) or nil
                    parese.isSFX = true
                end
            end

            if descType == 1 then
                fStar, fEnd = string.find(descContent, "TXTEX:")
                if fStar and fEnd then
                    descType = 6
                    descContent = string.gsub(descContent, "TXTEX:", "")
                    parese.text = descContent
                    local starChar = string.sub(descContent or "", 1, 1)
                    local endChar = string.sub(descContent or "", -1, -1)
                    if starChar ~= "<" and endChar ~= ">" then
                        local cStart, cEnd = string.find(parese.text, "/FCOLOR")
                        if cStart and cEnd then
                            parese.text = "<" .. descContent .. ">"
                        end
                    end
                end
            end
            ---

            if descType == 1 then
                if descContent == "-" then
                    parese.newLine = true
                else
                    descContent = string.gsub(descContent, "TXT:", "")
                    parese.text = descContent
                    local starChar = string.sub(descContent or "", 1, 1)
                    local endChar = string.sub(descContent or "", -1, -1)
                    if starChar ~= "<" and endChar ~= ">" then
                        local cStart, cEnd = string.find(parese.text, "/FCOLOR")
                        if cStart and cEnd then
                            parese.text = "<" .. descContent .. ">"
                        end
                    end
                end
            end

            local mobileParam = string.split(descContentArray[1] or "", "#")
            local pcParam = string.split(descContentArray[2] or "", "#")
            parese.x = tonumber(mobileParam[1]) or 0
            parese.y = tonumber(mobileParam[2]) or 0
            if descType < 4 then
                parese.width = tonumber(mobileParam[3]) or 0
                parese.height = tonumber(mobileParam[4]) or 0
            else
                parese.width = 0
                parese.height = 0
            end

            if (descType == 4 or descType == 5) then
                parese.scale = tonumber(mobileParam[3]) or 0
            elseif descType == 6 then
                parese.fontsize = tonumber(mobileParam[3]) or 0
            end

            if SL:GetMetaValue("WINPLAYMODE") then
                parese.x = tonumber(pcParam[1]) or parese.x
                parese.y = tonumber(pcParam[2]) or parese.y
                if descType < 4 then
                    parese.width = tonumber(pcParam[3]) or parese.width
                    parese.height = tonumber(pcParam[4]) or parese.height
                end
                if (descType == 4 or descType == 5) then
                    parese.scale = tonumber(pcParam[3]) or 0
                elseif descType == 6 then
                    parese.fontsize = tonumber(pcParam[3]) or 0
                end
            end

            table.insert(pareses, parese)
        end
        return pareses
    end
    return nil
end

GUIShare.GetParseItemDesc = function(desc)
    local descs = {}
    if desc and string.len(desc) > 0 then
        local fStar, fEnd = nil, nil
        local lineDesc = ""
        while true do
            local parseData = nil
            fStar, fEnd = string.find(desc, "%b<>", 1)
            local isUnfixParam = false
            if fStar and fStar ~= 1 then
                isUnfixParam = true
                local paramStr = string.sub(desc, 1, fStar - 1)
                desc = string.sub(desc, fStar, -1)
                if string.len(paramStr) > 0 then
                    parseData = GUIShare.ParseItemDecsType(paramStr)
                end
            end

            if not isUnfixParam and fStar and fEnd then
                lineDesc = lineDesc .. string.sub(desc, fStar, fEnd)
                desc = string.sub(desc, fEnd + 1, -1)

                local isNewParse = false
                if string.sub(lineDesc, 1, 3) == "<ID" then
                    isNewParse = true
                else
                    local font_fStar, font_fEnd = string.find(lineDesc, "<font^*(.-)>*$", 1)
                    if font_fStar and font_fEnd then
                        isNewParse = true
                        lineDesc = lineDesc .. desc
                        desc = ""
                    end
                end

                if isNewParse then
                    parseData = GUIShare.ParseItemDecsType(lineDesc)
                    lineDesc = ""
                else
                    if string.sub(desc, 1, 1) == "\\" or string.len(desc or "") == 0 then
                        desc = string.sub(desc, 2, -1)
                        parseData = GUIShare.OldParseItemDescType(lineDesc)
                        lineDesc = ""
                    end
                end
            else
                if not isUnfixParam and desc and string.len(desc) > 0 then
                    parseData = GUIShare.ParseItemDecsType(desc)
                end
            end

            if parseData then
                for i, parseStr in ipairs(parseData) do
                    -- 0: 中间   1: 顶部   2: 底部  3: 外框顶部  4：外框底部
                    if parseStr.tag == 0 then
                        if not descs.desc then
                            descs.desc = {}
                        end
                        table.insert(descs.desc, parseStr)
                    elseif parseStr.tag == 1 then
                        if not descs.top_desc then
                            descs.top_desc = {}
                        end
                        table.insert(descs.top_desc, parseStr)
                    elseif parseStr.tag == 2 then
                        if not descs.bottom_desc then
                            descs.bottom_desc = {}
                        end
                        table.insert(descs.bottom_desc, parseStr)
                    elseif parseStr.tag == 3 then
                        if not descs.frame_top_desc then
                            descs.frame_top_desc = {}
                        end
                        table.insert(descs.frame_top_desc, parseStr)
                    elseif parseStr.tag == 4 then
                        if not descs.frame_bottom_desc then
                            descs.frame_bottom_desc = {}
                        end
                        table.insert(descs.frame_bottom_desc, parseStr)
                    end
                end
            end

            if not fStar or not fEnd then
                break
            end
        end
    end
    return descs
end
