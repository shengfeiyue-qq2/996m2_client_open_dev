GUIFunction = {}

local AttTypeTable = GUIDefine.AttTypeTable
local ExAttType = GUIDefine.ExAttType

-- 获取基础属性
function GUIFunction:PShowAttType()
    return AttTypeTable
end

function GUIFunction:GetExAttType()
    return ExAttType
end

-- 触发 与身上装备比较
function GUIFunction:CompareEquipOnBody(equipData)
    -- 装备数据
    if not equipData then 
        return false
    end 

    -- M2开关自动穿戴
    local autoDress = SL:GetMetaValue("SERVER_OPTION", "autoDress")
    if not autoDress or autoDress == 0 then 
        return false
    end 

    -- equip表 配置对比参数 -1不进行比较  
    local myComparison, myJob = SL:GetMetaValue("EQUIP_COMPARISON", equipData.Index)
    if myComparison then 
        if tonumber(myComparison) == -1 then 
            return false
        end
    end   

    -- 职业判断
    if (myJob and myJob ~= 3 and myJob ~= SL:GetMetaValue("JOB")) then 
        return false
    end

    -- 通过stdmode 获取装备位
    local pos = SL:GetMetaValue("EQUIP_POSLIST_BY_STDMODE", equipData.StdMode) 
    if not pos or next(pos) == nil then 
        return false
    end 

    -- 是否是该性别装备
    local sexOk = SL:GetMetaValue("IS_SAMESEX_EQUIP", equipData) 
    if not sexOk then 
        return false
    end 

    -- 药粉 护身符 不对比
    if equipData.StdMode == 25 then 
        return false
    end

    local myParam = {jobPower = true}
    local myPower, powerSortIndex = GUIFunction:GetEquipPower(equipData, myParam) -- 当前装备战力

    -- 比较身上装备
    local targetInfo = nil
    local targetParam = {jobPower = true, power = myPower, comparison = myComparison, powerSortIndex = powerSortIndex}
    local targetMinPower = 0 -- 身上穿戴最小战力
    for i, pos in ipairs(pos) do
        targetInfo = SL:GetMetaValue("EQUIP_DATA", pos)
        if not targetInfo then
            return true
        end

        local targetPower = GUIFunction:GetEquipPower(targetInfo, targetParam) -- 身上装备战力
        if targetMinPower == 0 or targetPower < targetMinPower then -- 拿到身上穿戴最小战力
            targetMinPower = targetPower
        end
    end

    if targetMinPower < myPower then 
        return true
    end 

    return false
end 

-- 获取战力
function GUIFunction:GetEquipPower(item, param)
    if not item or not next(item) then
        return 0
    end

    local param = param or {}

    -- 基础属性 对比
    local itemCfg = SL:GetMetaValue("ITEM_DATA", item.Index)
    if not itemCfg or not itemCfg.attribute then 
        return 0
    end 

    local attList = {} -- 属性列表
    local tAttribute = string.split(itemCfg.attribute or "", "|")
    for i, v in ipairs(tAttribute) do 
        if v and v ~= "" and string.len(v) > 0 then
            local tAttribute2 = string.split(v or "", "#")
            table.insert(attList, {id = tonumber(tAttribute2[2]) or 3, value = tonumber(tAttribute2[3]) or 0})
        end
    end 

    local powerValue, powerSortIndex = GUIFunction:CalculateAttPower(attList, param.jobPower, param.powerSortIndex) -- 计算装备属性战力
    local comparisonValue = SL:GetMetaValue("EQUIP_COMPARISON", item.Index) -- 装备配置战力


    local targetPower = param.power or 0 -- target 装备战力
    local targetComparison = param.comparison or comparisonValue --target 装备配置战力
    if comparisonValue > targetComparison or (param.powerSortIndex and param.powerSortIndex < powerSortIndex) then 
        powerValue = math.abs(powerValue) + targetPower + 1
    elseif comparisonValue < targetComparison then 
        powerValue = targetPower - math.abs(powerValue) - 1
    end 

    return powerValue, powerSortIndex
end

-- 计算战力 
-- attList: 属性   isJobPower：对比本职业   sortIndex：对比的属性下标(先比较职业属性  再比较物防  最后比较魔防  都是上限属性)
function GUIFunction:CalculateAttPower(attList, isJobPower, sortIndex)
    local power = -1
    local myJob = SL:GetMetaValue("JOB")
    local jobPowerAttIds = {
        [AttTypeTable.Max_DEF] = 2,
        [AttTypeTable.Max_MDF] = 1
    }

    if isJobPower then
        if myJob == 0 then --战士
            jobPowerAttIds[AttTypeTable.Max_ATK] = 3
        elseif myJob == 1 then --法师
            jobPowerAttIds[AttTypeTable.Max_MAT] = 3
        elseif myJob == 2 then --道士
            jobPowerAttIds[AttTypeTable.Max_Daoshu] = 3
        end
    end

    local powers = {}
    local powerSortIndex = 0

    for k, v in pairs(attList) do
        if jobPowerAttIds[v.id] then
            local score = v.value
            powers[jobPowerAttIds[v.id]] = score
            if jobPowerAttIds[v.id] > powerSortIndex and score > 0 then        
                powerSortIndex = jobPowerAttIds[v.id]
            end
        end
    end

    if sortIndex and powerSortIndex <= sortIndex then
        powerSortIndex = sortIndex
    end

    power = powers[powerSortIndex] or -1
    return power, powerSortIndex
end

-- 是否能挖肉
-- Race 51 52 53 90 105 106 82 84 85 可以挖的
local DIG_RACE_SERVER_LST = {
    [51] = 1,
    [52] = 1,
    [53] = 1,
    [82] = 1,
    [84] = 1,
    [85] = 1,
    [90] = 1,
    [105] = 1,
    [106] = 1,
}
function GUIFunction:CheckTargetDigAble(targetID)
    -- 必须是死亡的
    if not SL:GetMetaValue("ACTOR_IS_DIE", targetID) then
        return false
    end

    -- 怪物和人形怪才可以挖
    if not SL:GetMetaValue("ACTOR_IS_MONSTER", targetID) and not SL:GetMetaValue("ACTOR_IS_HUMAN", targetID) then
        return false
    end

    -- 是人形怪，但是有主人，可能是分身
    if SL:GetMetaValue("ACTOR_IS_HUMAN", targetID) and SL:GetMetaValue("ACTOR_HAVE_MASTER", targetID) then
        return false
    end

    if SL:GetMetaValue("ACTOR_IS_MONSTER", targetID) then
        local raceServer = SL:GetMetaValue("ACTOR_RACE_SERVER", targetID)
        if DIG_RACE_SERVER_LST[raceServer] == nil then
            return false
        end

        -- 配置不可以挖
        local typeIndex = SL:GetMetaValue("ACTOR_TYPE_INDEX", targetID)
        local data      = SL:GetMetaValue("GAME_DATA", "noDigMonsters")
        if data and data ~= "" then
            local slices = string.split(data, "#")
            for key, value in pairs(slices) do
                if typeIndex == tonumber(value) then
                    return false
                end
            end
        end
    end

    return true
end

-- ItemTips 相关
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
        local merges = GUIDefine.MergeAttrConfig[v.id]
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
        [AttTypeTable.Anti_Posion]      = 1,
        [AttTypeTable.Anti_Magic]       = 1,
        [AttTypeTable.Health_Recover]   = 1,
        [AttTypeTable.Spell_Recover]    = 1
    }

    return list[id]
end

-- Tips获取属性数据显示
function GUIFunction:GetAttDataShow(att, stars, tipsShow)
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
            if id == AttTypeTable.Lucky then
                if min < 0 then
                    changeName = GetSpecialAttrName(100000000 + AttTypeTable.Curse)
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
                if GUIDefine.HPUnitAttrs[id] then
                    valueStr = SL:HPUnit(min) .. ""
                    if stars then
                        valueStr = "+" .. valueStr
                    end
                end
            end

            local showName = config.name
            if changeName then
                name = changeName
            elseif id == AttTypeTable.Strength or id == AttTypeTable.Curse then
                name = GetSpecialAttrName(100000000 + id)
            else
                name = showName
            end
        end

        name = name or ""
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

function GUIFunction:GetAttShowOrder(att, stars, tipsShow)
    local showList = GUIFunction:GetAttDataShow(att, stars, tipsShow)
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
            if a.id <= AttTypeTable.Speed_Point and b.id <= AttTypeTable.Speed_Point then
                return a.id < b.id
            elseif a.id > 10000 and b.id > 10000 then
                return a.id < b.id
            elseif a.id > 10000 and b.id <= AttTypeTable.Speed_Point then
                return false
            elseif a.id <= AttTypeTable.Speed_Point and b.id > 10000 then
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

function GUIFunction:GetDuraStr(dura, maxdura, one)
    local txt
    if not one then
        txt = string.format("%s/%s", math.round(dura / 1000), math.round(maxdura / 1000))
    else
        txt = tostring(math.round(dura / 1000))
    end
    return txt
end

function GUIFunction:GetDura100Str(dura, maxdura, one)
    local txt
    if not one then
        txt = string.format("%s/%s", math.round(dura), math.round(maxdura))
    else
        txt = tostring(math.round(dura))
    end
    return txt
end

function GUIFunction:ItemUseConditionColor(bEnable)
    if bEnable then
        return "#ffffff"
    end
    return "#ff0000"
end

function GUIFunction:ParseItemBaseAtt(att, job)
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

function GUIFunction:CombineAttList(list1, list2)
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

function GUIFunction:GetExAttList(values)
    local att = {}
    if not values or next(values) == nil then
        return att
    end
    local strengStarKey = ExAttType.Star
    local failStarKey = ExAttType.Fail_Star
    for k, v in pairs(values) do
        if v.Id ~= strengStarKey and v.Id ~= failStarKey and GUIDefine.ExAttrList and GUIDefine.ExAttrList[v.Id] then
            local attParam = {
                id = GUIDefine.ExAttrList[v.Id],
                value = v.Value
            }
            table.insert(att, attParam)
        end
    end
    return att
end

-- 道具属性描述
function GUIFunction:GetItemAttDesc(item)
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
            table.insert(line1, sFormat("持久：%s", GUIFunction:GetDuraStr(item.Dura, item.DuraMax)))
        elseif item.StdMode == 25 then --护身符及毒药
            line2 = {}
            table.insert(line2, sFormat("数量:%s", GUIFunction:GetDura100Str(item.Dura / 100, item.DuraMax / 100)))
        elseif item.StdMode == 40 then --肉
            table.insert(line1, sFormat("品质：%s", GUIFunction:GetDuraStr(item.Dura, item.DuraMax)))
        elseif item.StdMode == 43 then --矿石
            table.insert(line1, sFormat("纯度：%s", math.round(item.Dura / 1000)))
        elseif item.StdMode == 2 and item.Dura > 0 then --使用次数
            table.insert(line1, sFormat("使用次数：%s", GUIFunction:GetDura100Str(item.Dura / 1000, item.DuraMax / 1000)))
        elseif item.StdMode == 49 then --聚灵珠经验
            if item.Dura >= item.DuraMax then
                table.insert(line1, sFormat("经验值已储蓄满(%s)万 双击释放", math.round(item.DuraMax / 10000)))
            else
                table.insert(line1, sFormat("积累经验：%s万", GUIFunction:GetDura100Str(item.Dura / 10000, item.DuraMax / 10000)))
            end
        end
        local pos = SL:GetMetaValue("EQUIP_POS_BY_STDMODE", item.StdMode)
        if not pos then
        else
            -- 基础属性
            local attList = GUIFunction:ParseItemBaseAtt(item.attribute)

            local starsAtt = nil
            local starsAttShow = nil
            -- 极品属性
            local exAtt = GUIFunction:GetExAttList(item.Values)
            -- 合并极品属性
            if exAtt and next(exAtt) then
                attList = GUIFunction:CombineAttList(attList, exAtt)
            end

            -- 属性显示队列
            local stringAtt = GUIFunction:GetAttDataShow(attList)
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
                    local color = GUIFunction:ItemUseConditionColor(v.can)
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

function GUIFunction:OldParseItemDescType(str)
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

function GUIFunction:ParseItemDecsType(signStr)
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

function GUIFunction:GetParseItemDesc(desc)
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
                    parseData = GUIFunction:ParseItemDecsType(paramStr)
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
                    parseData = GUIFunction:ParseItemDecsType(lineDesc)
                    lineDesc = ""
                else
                    if string.sub(desc, 1, 1) == "\\" or string.len(desc or "") == 0 then
                        desc = string.sub(desc, 2, -1)
                        parseData = GUIFunction:OldParseItemDescType(lineDesc)
                        lineDesc = ""
                    end
                end
            else
                if not isUnfixParam and desc and string.len(desc) > 0 then
                    parseData = GUIFunction:ParseItemDecsType(desc)
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

-- 物品是否显示拍卖行物品栏
function GUIFunction:CheckItemIsShowAuction(itemData)
    return true
end


--------------------------- 聊天解析  begin-------------------------------
-- fix chat Name
-- 处理发送者名字
function GUIFunction:ChatFixName(data)
    local name = data.SendName or ""
    -- 私聊处理
    if SL:GetMetaValue("CHAT_IS_PRIVATE_CHANNEL", data.ChannelId) then
        if data.SendId and SL:GetMetaValue("ACTOR_IS_MAINPLAYER", data.SendId) then
            name = "你对" .. "[" .. name .. "]" .. "说"
        else
            if SL:GetMetaValue("WINPLAYMODE") then
                local levelStr = string.format(data.Suffix or "", data.Level or "")
                name = string.format("[%s]%s", name, levelStr) .. "对你说"
            else
                name = "[" .. name .. "]" .. "对你说" 
            end
        end
    end
    
    if data.SendName and string.len(data.SendName) > 0 then
        return name .. ":"
    end
    return name
end

-- fix chat private time
-- 私聊时间格式化
function GUIFunction:ChatFixPrivateTime(data)
    if SL:GetMetaValue("CHAT_IS_PRIVATE_CHANNEL", data.ChannelId) then
        if data.SendTime then
            local date = os.date("*t", data.SendTime)
            return string.format("%d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)
        end
    end
    return ""
end

-- fix chat msg
-- 使用类型：系统通知消息，需使用特定的富文本解析; 行会通知
function GUIFunction:ChatFixMsg(data, isPrivateTime)
    local name  = self:ChatFixName(data)
    local str   = string.format("<outline size='0'>%s%s</outline>", name, data.Msg or "")
    if isPrivateTime then
        return string.format("<outline size='0'>%s%s</outline>", self:ChatFixPrivateTime(data), str)
    end
    return str
end

-- fix chat msg outline
-- 使用类型：系统通知消息，需使用FColor富文本解析; 系统通知消息，需使用SRText富文本解析
function GUIFunction:ChatFixMsgWithoutOutline(data, isPrivateTime)
    local name  = self:ChatFixName(data)
    local str   = string.format("%s%s", name, data.Msg or "")
    if isPrivateTime then
        return string.format("%s%s", self:ChatFixPrivateTime(data), str)
    end
    return str
end

-- chat width
--- 获取单条聊天item宽度
---@param isMini boolean 是否是主界面的聊天item
---@param miniChatWidth integer 主界面的聊天item宽度
function GUIFunction:ChatGetWidth(isMini, miniChatWidth)
    if isMini then
        if SL:GetMetaValue("WINPLAYMODE") then
            return miniChatWidth or 722
        else
            return miniChatWidth or 310
        end
    end
    return 310
end

-- 获取聊天栏的通知类型的字体配置
function GUIFunction:ChatGetNoticeMsgFont(isMini, data)
    local color         = nil   -- 字体颜色  0-255
    local fontPath      = nil   -- 字体     字体位置
    local fontSize      = nil   -- 字体大小
    return {color=color, fontPath=fontPath, fontSize=fontSize}
end

-- 查找表情
local emojiFindParam = {
    replaceStr      = nil,    --表情字符串
    findReplaceLen  = {}     --表情字符串的长度
}
-- 查找表情的数据解析
local function GetEmojiFindParam()
    if not emojiFindParam.replaceStr then
        emojiFindParam.replaceStr = ""
        local emojiConfig = SL:GetMetaValue("CHAT_EMOJI")
        for _,v in pairs(emojiConfig) do
            emojiFindParam.replaceStr = emojiFindParam.replaceStr .. string.format("<%s&%d>",v.replace,v.ID)
            if not emojiFindParam.findReplaceLen[string.len(v.replace)] then
                emojiFindParam.findReplaceLen[string.len(v.replace)] = true
            end
        end
    end
    return emojiFindParam.replaceStr, emojiFindParam.findReplaceLen
end

-- chat parse
-- 解析普通类型的聊天数据
function GUIFunction:ChatParseNormal(msg)
    msg = string.gsub(msg or "", "\n", " ")
    local emojiConfig = SL:GetMetaValue("CHAT_EMOJI")

    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 透明的
    local fontPath      = nil   -- 字体     字体位置
    local fontSize      = nil   -- 字体大小
    local outColor      = nil   -- 字体描边颜色
    local outlineSize   = nil   -- 字体描边大小

    local chatParseT = {}
    while string.len(msg) > 0 do
        local fStar,fEnd = string.find(msg, "#")
        if not fStar and not fEnd then
            table.insert(chatParseT, {text=msg, color=color, opacity=opacity, fontPath=fontPath, fontSize=fontSize, outColor=outColor, outlineSize=outlineSize})
            break
        end
        
        if fStar > 1 then
            local prefixEmoJi = string.sub(msg, 1, fStar-1) --截取表情前部分
            msg               = string.sub(msg, fStar)
            table.insert(chatParseT, {text=prefixEmoJi, color=color, opacity=opacity, fontPath=fontPath, fontSize=fontSize, outColor=outColor, outlineSize=outlineSize})
        end
        
        -- 查找表情
        local findEmoji = nil
        local str,finLen = GetEmojiFindParam()
        for _len,v in pairs(finLen) do
            local emojiStr  = string.sub(msg, 1, _len)
            local regexS    = string.format("(<%s&%%d+>)", emojiStr)
            local matchS    = string.match(str, regexS)
            if emojiStr and matchS then
                msg                 = string.sub(msg, _len+1)
                local mathcArray    = string.split(matchS, "&")
                local emojiID       = tonumber(string.sub(mathcArray[2] or "",1,-2))
                if emojiID and emojiConfig[emojiID] then
                    findEmoji = emojiStr
                    table.insert(chatParseT, {sfxID=emojiConfig[emojiID].sfxid})
                end
                break
            end
        end

        -- 没找到表情, 截取出"#"
        if not findEmoji then
            msg = string.sub(msg, fStar+1)
            table.insert(chatParseT, {text="#", color=color, opacity=opacity, fontPath=fontPath, fontSize=fontSize, outColor=outColor, outlineSize=outlineSize})
        end
    end
    
    return chatParseT
end

-- 解析坐标类型聊天数据
function GUIFunction:ChatParseEPosition(jsonData)
    if nil == jsonData then
        return {}
    end
    
    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 透明的
    local fontPath      = nil   -- 字体     字体位置
    local fontSize      = nil   -- 字体大小
    local outColor      = nil   -- 字体描边颜色
    local outlineSize   = nil   -- 字体描边大小

    local str       = string.format("[%s %s,%s]", jsonData.mapName, jsonData.mapX, jsonData.mapY)
    local posLink   = string.format("position#%s#%s#%s", jsonData.mapID, jsonData.mapX, jsonData.mapY)
    return {[1]={text=str, link=posLink, color=color, opacity=opacity, fontPath=fontPath, fontSize=fontSize, outColor=outColor, outlineSize=outlineSize}}
end

-- 解析装备类型聊天数据
function GUIFunction:ChatParseEItem(jsonData)
    if nil == jsonData then
        return {}
    end
    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 透明的
    -- 支持添加文本

    local chatParseT = {}
    table.insert(chatParseT, {equip=jsonData, color=color, opacity=opacity})
    return chatParseT
end

-- 解析骰子类型聊天数据
function GUIFunction:ChatParseDice(msg)
    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 透明的
    -- 支持添加文本

    local diceIndex = math.max(1, math.min(6, tonumber(msg) or 1))
    local chatParseT = {}
    table.insert(chatParseT, {dice=diceIndex, color=color, opacity=opacity})
    return chatParseT
end

-- 与发送者私聊
function GUIFunction:ChatClickSenderGUIWidget(senderID, senderName, GUIWidget)
    SL:PrivateChatWithTarget(senderID, senderName)
end
--------------------------- 聊天解析    end-------------------------------