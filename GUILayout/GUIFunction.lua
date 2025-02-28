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

-- 获取职业名
function GUIFunction:GetJobNameByID(jobID)
    if not jobID then return "" end
    if jobID == 4 then
        return SL:GetValue("I18N_STRING", 1100)
    elseif jobID >= 5 and jobID <= 15 then
        local jobData   = SL:GetValue("GAME_DATA", "MultipleJobSetMap")[jobID]
        local isOpen    = jobData and jobData.isOpen
        local str       = isOpen and jobData.name or string.format("%s%s", SL:GetValue("I18N_STRING", 1101), jobID)
        return str
    end
    return SL:GetValue("I18N_STRING", 1067+jobID)
end

-- 触发 与身上装备比较 [背包提升箭头使用]
function GUIFunction:CompareEquipOnBody(equipData, from)
    -- 装备数据
    if not equipData then 
        return false
    end 

    if not from then 
        from = GUIDefine.ItemFrom.BAG
    end 

    -- M2开关自动穿戴
    local autoDress = SL:GetValue("SERVER_OPTION", SW_KEY_AUTO_DRESS)
    if not autoDress or autoDress == 0 then 
        return false
    end 

    -- equip表 配置对比参数 -1不进行比较(非穿戴物品)  
    local myComparison, myJob = SL:GetValue("EQUIP_COMPARISON", equipData.Index)
    if myComparison then 
        if tonumber(myComparison) == -1 then 
            return false
        elseif tonumber(equipData.comparison) == -2 and from == GUIDefine.ItemFrom.BAG then
            return false
        elseif tonumber(equipData.comparison) == -3 and from == GUIDefine.ItemFrom.HERO_BAG then
            return false
        end
    end   

    local isHero = from == GUIDefine.ItemFrom.HERO_BAG
    -- 职业判断
    local job = isHero and SL:GetValue("H.JOB") or SL:GetValue("JOB")
    if myJob and myJob ~= 3 and myJob ~= job then 
        return false
    end

    -- 通过stdmode 获取装备位
    local posList = GUIDefine.EquipPosByStdMode[equipData.StdMode]
    if not posList or next(posList) == nil then 
        return false
    end 

    -- 是否是该性别装备
    local sexOk = SL:GetValue("IS_SAMESEX_EQUIP", equipData, isHero) 
    if not sexOk then 
        return false
    end 

    -- 药粉 护身符 不对比
    if equipData.StdMode == 25 then 
        return false
    end

    local myParam = {jobPower = true}
    local myPower, powerSortIndex = GUIFunction:GetEquipPower(equipData, myParam, isHero) -- 当前装备战力

    -- 比较身上装备
    local targetInfo = nil
    local targetParam = {jobPower = true, power = myPower, comparison = myComparison, powerSortIndex = powerSortIndex}
    local targetMinPower = 0 -- 身上穿戴最小战力
    for i, pos in ipairs(posList) do
        if isHero then
            targetInfo = SL:GetValue("H.EQUIP_DATA", pos)
        else
            targetInfo = SL:GetValue("EQUIP_DATA", pos)
        end
        if not targetInfo then
            return true
        end

        local targetPower = GUIFunction:GetEquipPower(targetInfo, targetParam, isHero) -- 身上装备战力
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
function GUIFunction:GetEquipPower(item, param, isHero)
    if not item or next(item) == nil then
        return 0
    end

    local param = param or {}

    -- 基础属性 对比
    local itemCfg = SL:GetValue("ITEM_DATA", item.Index)
    if not itemCfg or not itemCfg.Attribute then 
        return 0
    end 

    local attList = {} -- 属性列表
    local tAttribute = string.split(itemCfg.Attribute or "", "|")
    for i, v in ipairs(tAttribute) do 
        if v and v ~= "" and string.len(v) > 0 then
            local tAttribute2 = string.split(v or "", "#")
            table.insert(attList, {id = tonumber(tAttribute2[2]) or 3, value = tonumber(tAttribute2[3]) or 0})
        end
    end 

    local powerValue, powerSortIndex = GUIFunction:CalculateAttPower(attList, param.jobPower, param.powerSortIndex, isHero) 
    local comparisonValue = SL:GetValue("EQUIP_COMPARISON", item.Index)

    local targetPower = param.power or 0 -- 选中装备 属性战力
    local targetComparison = param.comparison or comparisonValue -- 选中装备 优先级
    if comparisonValue > targetComparison or (param.powerSortIndex and param.powerSortIndex < powerSortIndex) then 
        powerValue = math.abs(powerValue) + targetPower + 1 -- 比选中装备战力高 
    elseif comparisonValue < targetComparison then 
        powerValue = math.min(math.abs(powerValue), targetPower - 1) -- 比选中装备战力低 
    end 

    return powerValue, powerSortIndex
end

-- 计算战力 
-- attList: 属性   isJobPower：对比本职业   sortIndex：对比的属性下标(先比较职业属性  再比较物防  最后比较魔防  都是上限属性)
function GUIFunction:CalculateAttPower(attList, isJobPower, sortIndex, isHero)
    local power = -1
    local myJob = isHero and SL:GetValue("H.JOB") or SL:GetValue("JOB")
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

-- 获取对应战力最小装备位、战力、是否穿戴，通过StdMode
-- checkPosData：指定部位数据战力对比({[1]={data = data, pos = pos}})
function GUIFunction:GetMinPowerPosByStdMode(stdMode, param, checkPosData, isHero, excludePos)
    local stdMode = stdMode or 0
    local onEquipMinPower = 0
    local minPowerPos = -1
    local hasEquip = true
    local pos = checkPosData or SL:CopyData(GUIDefine.EquipPosByStdMode[stdMode])
    if not pos or next(pos) == nil then
        SL:Print("this StdMode is not a equip")
        return minPowerPos, onEquipMinPower, false
    end

    if param.checkPos then
        local index = table.indexof(pos, param.checkPos)
        if index then
            local firstPos = pos[1]
            pos[1] = param.checkPos
            pos[index] = firstPos
        end
    end

    local isCheckPosData = checkPosData and true or false

    if excludePos then
        for i, v in ipairs(pos) do
            if (isCheckPosData and v.pos == excludePos) or (not isCheckPosData and v == excludePos) then
                table.remove(pos, i)
            end
        end
    end
    for k, v in ipairs(pos) do
        local equipData = isCheckPosData and v.data
        if not equipData then
            if isHero then
                equipData = SL:GetValue("H.EQUIP_DATA", v)
            else
                equipData = SL:GetValue("EQUIP_DATA", v)
            end
        end
        if not equipData then
            minPowerPos = isCheckPosData and v.pos or v
            onEquipMinPower = 0
            hasEquip = false
            break
        end
        local equipPower = GUIFunction:GetEquipPower(equipData, param, isHero)
        if onEquipMinPower == 0 or equipPower < onEquipMinPower then
            onEquipMinPower = equipPower
            minPowerPos = isCheckPosData and v.pos or v
            if stdMode == 25 then
                break
            end
        end
    end
    return minPowerPos, onEquipMinPower, hasEquip
end

-- 检查装备禁止装戴位置
function GUIFunction:CheckEquipExcludePos(item)
    if not item.Article or item.Article == "" then
        return nil
    end

    local itemArticle = nil
    local parseArticle = string.split(item.Article, "|")
    for k, v in pairs(parseArticle) do
        local articleV = tonumber(v)
        if articleV == GUIDefine.ItemArticleType.TYPE_TAKE_ARMRINGL then
            return GUIDefine.EquipPosUI.Equip_Type_ArmRingL
        end
    end

    return nil
end

-- 检测显示自动使用Tips
-- checkItem: 检测装备数据     pos: 要穿戴的装备位置    playerType: 人物类型(1: 人物; 2: 英雄)
function GUIFunction:CheckAutoUseTips(checkItem, pos, playerType)
    playerType = playerType or 1
    local checkEquipIntoPos = pos
    local isHero = playerType == 2
    if checkItem and checkItem.StdMode then
        local function checkMinPower(item, checkPosData)
            local comparison = SL:GetValue("EQUIP_COMPARISON", item.Index)
            -- 是否有找到合适的位置 战力对比
            local myPower = 0
            local powerSortIndex = nil
            myPower, powerSortIndex = GUIFunction:GetEquipPower(item, {jobPower = true}, isHero)

            local param = {jobPower = true, power = myPower, comparison = comparison, powerSortIndex = powerSortIndex}
            local excludePos = GUIFunction:CheckEquipExcludePos(item)
            local minPowerPos, onEquipMinPower, hasEquip = GUIFunction:GetMinPowerPosByStdMode(item.StdMode, param, checkPosData, isHero, excludePos)
            local equipIntoPos = -1

            if minPowerPos >= 0 and (not hasEquip or onEquipMinPower < myPower) then
                equipIntoPos = minPowerPos
            end

            if equipIntoPos < 0 then
                return -1
            end
            return equipIntoPos
        end

        local posList = GUIDefine.EquipPosByStdMode[checkItem.StdMode]
        local isBreak = true
        for k, equipPos in ipairs(posList) do
            isBreak = true
            local excludePos = GUIFunction:CheckEquipExcludePos(checkItem)
            if not excludePos or excludePos ~= equipPos then
                -- 已有自动使用装备
                local tipsMakeIndex = AutoUseItemData.GetMakeIndexByPos(playerType, equipPos)
                if tipsMakeIndex then

                    local equipData = nil
                    if isHero then
                        equipData = HeroBagData.GetItemDataByMakeIndex(tipsMakeIndex) or BagData.GetItemDataByMakeIndex(tipsMakeIndex)
                    else
                        equipData = BagData.GetItemDataByMakeIndex(tipsMakeIndex)
                    end
                    checkEquipIntoPos = checkMinPower(checkItem, {{data = equipData, pos = equipPos}})
                else
                    local equipData = nil
                    if isHero then
                        equipData = SL:GetValue("H.EQUIP_DATA", equipPos)
                    else
                        equipData = SL:GetValue("EQUIP_DATA", equipPos)
                    end
                    if not equipData then
                        checkEquipIntoPos = equipPos
                    else
                        checkEquipIntoPos = checkMinPower(checkItem, {{data = equipData, pos = equipPos}})
                    end
                end

                if isBreak and checkEquipIntoPos >= 0 then
                    break
                end
            end
        end
    end
    return checkEquipIntoPos
end

-- 自动使用比对物品 （人物）
function GUIFunction:OnAutoUseCheckItem(item)
    if not item then
        return
    end

    -- 配置对比参数 -1、-2不进行比较
    if item.comparison and (tonumber(item.comparison) == -1 or tonumber(item.comparison) == -2) then
        return
    end

    -- 服务端自动使用开关
    local autoDress = SL:GetValue("SERVER_OPTION", SW_KEY_AUTO_DRESS)
    if not autoDress or autoDress ~= 1 then
        return
    end

    -- 禁止使用物品buff
    local ret, buffID = SL:GetValue("CHECK_USE_ITEM_BUFF", item.Index)
    if not ret then
        if buffID then
            local config = SL:GetValue("BUFF_CONFIG", buffID)
            if config and config.bufftitle then
                SL:ShowSystemTips(config.bufftitle)
            end
        end
        return
    end

    local isCanAutoUse = SL:GetValue("ITEM_CAN_AUTOUSE", item)
    local isSkillBook = SL:GetValue("ITEMTYPE", item) == SL:GetValue("ITEMTYPE_ENUM").SkillBook
    local pos = GUIDefine.EquipPosByStdMode[item.StdMode]
    if not isCanAutoUse and not isSkillBook and (not pos or not next(pos)) then
        return
    end

    local type = 1 -- 人物
    local isOk = false
    repeat
        -- 穿戴条件是否满足
        local canUse = SL:CheckItemUseNeed(item).canUse
        if not canUse then
            break
        end

        local equipIntoPos = nil
        -- 技能书
        if isSkillBook then
            if not SL:GetValue("SKILLBOOK_CAN_USE", item.Name) then
                break
            end
        -- 装备
        elseif pos and next(pos) then
            -- 性别判断
            if not SL:GetValue("IS_SAMESEX_EQUIP", item) and SL:GetValue("PLAYER_INITED") then
                break
            end

            -- 职业判断
            local comparison, job = SL:GetValue("EQUIP_COMPARISON", item.Index)
            if job and job ~= 3 and job ~= SL:GetValue("JOB") then
                break
            end

            -- 战力对比
            local myParam = {jobPower = true}
            -- 当前装备战力
            local myPower, powerSortIndex = GUIFunction:GetEquipPower(item, myParam)
            local param = {jobPower = true, power = myPower, comparison = comparison, powerSortIndex = powerSortIndex}
            -- 最小战力装备位
            local excludePos = GUIFunction:CheckEquipExcludePos(item)
            local minPowerPos, onEquipMinPower, hasEquip = GUIFunction:GetMinPowerPosByStdMode(item.StdMode, param, nil, false, excludePos)

            equipIntoPos = -1
            
            if minPowerPos >= 0 and (not hasEquip or onEquipMinPower < myPower) then
                equipIntoPos = minPowerPos
            end

            if equipIntoPos < 0 then
                break
            else
                -- 检测显示Tips 
                equipIntoPos = GUIFunction:CheckAutoUseTips(item, equipIntoPos, type)
                if not equipIntoPos or equipIntoPos < 0 then
                    break
                end
            end
        end
        if equipIntoPos then
            -- 已有自动使用装备
            local tipsMakeIndex = AutoUseItemData.GetMakeIndexByPos(type, equipIntoPos)
            UIOperator:CloseAutoUsePopUI(tipsMakeIndex)
            AutoUseItemData.SetMakeIndexByPos(type, equipIntoPos, item.MakeIndex)
        end

        isOk = true

        UIOperator:OpenAutoUsePopUI({item = item, targetPos = equipIntoPos, isSkillBook = isSkillBook})
    
    until true

    return isOk
end

-- 自动使用比对物品 （英雄）
function GUIFunction:OnAutoUseCheckItem_Hero(item)
    if not item then
        return
    end

    -- 配置对比参数 -1、-3不进行比较
    if item.comparison and (tonumber(item.comparison) == -1 or tonumber(item.comparison) == -3) then
        return
    end

    -- 英雄是否召唤
    if not SL:GetValue("HERO_IS_ALIVE") then
        return
    end

    -- 服务端自动使用开关
    local autoDress = SL:GetValue("SERVER_OPTION", SW_KEY_AUTO_DRESS)
    if not autoDress or autoDress ~= 1 then
        return
    end

    local isCanAutoUse = SL:GetValue("ITEM_CAN_AUTOUSE", item)
    local isSkillBook = SL:GetValue("ITEMTYPE", item) == SL:GetValue("ITEMTYPE_ENUM").SkillBook
    local pos = GUIDefine.EquipPosByStdMode[item.StdMode]
    if not isCanAutoUse and not isSkillBook and (not pos or not next(pos)) then
        return
    end

    local type = 2 -- 英雄
    local isOk = false
    repeat
        -- 穿戴条件是否满足
        local canUse = SL:CheckItemUseNeed_Hero(item).canUse
        if not canUse then
            break
        end

        local equipIntoPos = nil
        -- 技能书
        if isSkillBook then
            local isFromHero = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", item.MakeIndex) == GUIDefine.ItemBelong.HEROBAG
            if not isFromHero then
                break
            end
            if not SL:GetValue("SKILLBOOK_CAN_USE", item.Name, true) then
                break
            end
        -- 装备
        elseif pos and next(pos) then
            -- 性别判断
            if not SL:GetValue("IS_SAMESEX_EQUIP", item, true) and SL:GetValue("HERO_INITED") then
                break
            end

            -- 职业判断
            local comparison, job = SL:GetValue("EQUIP_COMPARISON", item.Index)
            if job and job ~= 3 and job ~= SL:GetValue("H.JOB") then
                break
            end

            -- 战力对比
            local myParam = {jobPower = true}
            -- 当前装备战力
            local myPower, powerSortIndex = GUIFunction:GetEquipPower(item, myParam, true)
            local param = {jobPower = true, power = myPower, comparison = comparison, powerSortIndex = powerSortIndex}
            -- 最小战力装备位
            local excludePos = GUIFunction:CheckEquipExcludePos(item)
            local minPowerPos, onEquipMinPower, hasEquip = GUIFunction:GetMinPowerPosByStdMode(item.StdMode, param, nil, true, excludePos)

            equipIntoPos = -1
            
            if minPowerPos >= 0 and (not hasEquip or onEquipMinPower < myPower) then
                equipIntoPos = minPowerPos
            end

            if equipIntoPos < 0 then
                break
            else
                -- 检测显示Tips 
                equipIntoPos = GUIFunction:CheckAutoUseTips(item, equipIntoPos, type)
                if not equipIntoPos or equipIntoPos < 0 then
                    break
                end
            end
        end
        if equipIntoPos then
            -- 已有自动使用装备
            local tipsMakeIndex = AutoUseItemData.GetMakeIndexByPos(type, equipIntoPos)
            UIOperator:CloseAutoUsePopUI(tipsMakeIndex, nil, true)
            AutoUseItemData.SetMakeIndexByPos(type, equipIntoPos, item.MakeIndex)
        end

        isOk = true
        
        UIOperator:OpenAutoUsePopUI({item = item, targetPos = equipIntoPos, isSkillBook = isSkillBook, isHero = true})
    
    until true

    return isOk
end

-- 是否能挖肉
-- Race 51 52 53 60 90 105 106 82 84 85 可以挖的
local DIG_RACE_SERVER_LST = {
    [51] = 1,
    [52] = 1,
    [53] = 1,
    [60] = 1,
    [82] = 1,
    [84] = 1,
    [85] = 1,
    [90] = 1,
    [105] = 1,
    [106] = 1,
}
function GUIFunction:CheckTargetDigAble(targetID)
    -- 必须是死亡的
    if not SL:GetValue("ACTOR_IS_DIE", targetID) then
        return false
    end

    -- 怪物和人形怪才可以挖
    if not SL:GetValue("ACTOR_IS_MONSTER", targetID) and not SL:GetValue("ACTOR_IS_HUMAN", targetID) then
        return false
    end

    -- 是人形怪，但是有主人，可能是分身
    if SL:GetValue("ACTOR_IS_HUMAN", targetID) and SL:GetValue("ACTOR_HAVE_MASTER", targetID) then
        return false
    end

    if SL:GetValue("ACTOR_IS_MONSTER", targetID) then
        local raceServer = SL:GetValue("ACTOR_RACE_SERVER", targetID)
        if DIG_RACE_SERVER_LST[raceServer] == nil then
            return false
        end
    end

    if SL:GetValue("ACTOR_IS_MONSTER", targetID) or SL:GetValue("ACTOR_IS_HUMAN", targetID) then
        -- 配置不可以挖
        local typeIndex = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
        if GUIDefineEx.NoDigMonsterTypeMap and GUIDefineEx.NoDigMonsterTypeMap[typeIndex] then
            return false
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
                    max = 0,
                }
                if merges[1] and merges[1] >= GUIFunction:PShowAttType().Min_CustJobAttr_5 and merges[1] <= GUIFunction:PShowAttType().Max_CustJobAttr_15 then
                    newList[mergedId].maxID = merges[2]
                end
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
local function GetAttValueShowType(id, maxID)
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
    if maxID and maxID >= GUIFunction:PShowAttType().Min_CustJobAttr_5 and maxID <= GUIFunction:PShowAttType().Max_CustJobAttr_15 then
        return 2
    end
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
        [AttTypeTable.Health_Recover]   = 1,
        [AttTypeTable.Spell_Recover]    = 1
    }

    if id == AttTypeTable.Anti_Magic and not SL:GetValue("SERVER_OPTION", SW_KEY_MAGIC_MISS_TYPE) then
        return 1
    end

    if (id == AttTypeTable.Anti_Posion or id == AttTypeTable.Posion_Recover) and not SL:GetValue("SERVER_OPTION", SW_KEY_ANTI_POISON_TYPE) then
        return 1
    end

    return list[id]
end

-- Tips获取不同装备对比
function GUIFunction:GetDiffEquip(itemData, isHero)
    local posList = itemData and SL:GetValue("TIP_POSLIST_BY_STDMODE", itemData.StdMode, isHero)
    local equipList = {}
    if posList then
        local myPower = nil
        for _, pos in pairs(posList) do
            local equip = nil
            if isHero then
                equip = SL:GetValue("H.EQUIP_DATA", pos)
            else
                equip = SL:GetValue("EQUIP_DATA", pos)
            end
            if equip and next(equip) then
                table.insert(equipList, equip)
            end
        end
    end
    return equipList
end

-- Tips获取属性数据显示
local custTypeMap = {[0] = 1, [1] = 3, [2] = 2}
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

    local function GetAttNumShow(id, min, max, maxID)
        local name = ""
        local valueStr = ""
        min = tonumber(min) or 0
        max = tonumber(max) or 0
        if id > 10000 then
            name = GetSpecialAttrName(100000000 + id)
            if maxID then
                local config = SL:GetValue("ATTR_CONFIG", maxID) or {}
                name = config.name or ""
            end
            local type = GetAttValueShowType(id, maxID)
            local strWay = type == 2 and "%s-%s" or "%s/%s"
            valueStr = string.format(strWay, SL:HPUnit(min), SL:HPUnit(max))
            if stars then
                valueStr = min > 0 and valueStr or "+" .. SL:HPUnit(max)
            end
        else
            local config = SL:GetValue("ATTR_CONFIG", id) or {}
            local attNumType = config.type or 1
            --[[
                type == 1 正常值 == 2 万分比 == 3 百分比
                目前服务器发送过来的万分比的数值 基本是 10% 中的 10/10
            ]]
            local changeName = nil
            local custMap = SL:GetValue("CUST_ABIL_MAP")
            if custMap[id] and next(custMap[id]) then
                local type = custMap[id].type or 0
                if custMap[id].showCustomName then
                    changeName = config.name
                end
                id = custMap[id].id
                config = SL:GetValue("ATTR_CONFIG", id) or {}
                attNumType = custTypeMap[type] or 1
            end

            if id == AttTypeTable.Lucky then
                if min < 0 then
                    changeName = GetSpecialAttrName(100000000 + AttTypeTable.Curse)
                    min = math.abs(min)
                end
            end
            valueStr = min .. ""
            valueStr = stars and "+" .. valueStr or valueStr

            if attNumType == 2 or attNumType == 3 then
                local percent = attNumType == 2 and 100 or 1
                local showValue = min / percent
                if GetAttScaleType(id) then
                    showValue = showValue * 10
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
            local addStr = SL:GetValue("IS_PC_OPER_MODE") and " " or "  "
            local addStr2 = SL:GetValue("IS_PC_OPER_MODE") and " " or "  "
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
        local attId = v.id
        local custMap = SL:GetValue("CUST_ABIL_MAP")
        if custMap[attId] and next(custMap[attId]) then
            attId = custMap[attId].id or attId
        end
        local config = SL:GetValue("ATTR_CONFIG", attId)
        local configShow = config
        if tipsShow and configShow then
            configShow = config.noshowtips ~= 1
        end
        if v.id > 10000 or configShow then
            local min = tonumber(v.min or v.value) or 0
            local name, value = GetAttNumShow(v.id, min, v.max, v.maxID)
            attStrs[v.id] = {
                name = name,
                value = value,
                id = v.id,
                color = config and config.color or nil,
                isCurse = v.id == GUIDefine.AttTypeTable.Lucky and min < 0
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
    local orderList = {}
    for k, v in pairs(showList) do
        table.insert(orderList, v)
    end

    table.sort(
        orderList,
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
    return orderList
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

-- 装备基础属性
function GUIFunction:ParseItemBaseAtt(att, job)
    local attList = {}
    if not att or att == "" or att == "0" or att == 0 then
        return attList
    end
    local attArray = string.split(att, "|")
    local myJob = job or SL:GetValue("JOB")
    for k, v in ipairs(attArray) do
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

-- 装备极品属性
function GUIFunction:GetItemQualityAttr(itemData)
    local attList = {}
    if not itemData or not itemData.Quality or not next(itemData.Quality) then
        return attList
    end
    for _, att in ipairs(itemData.Quality) do
        if att.Idx and att.Idx > 0 and att.Value and att.Value ~= 0 then
            table.insert(attList, {
                id = att.Idx,
                value = att.Value
            })
        end
    end
    return attList
end

-- 解析自定义属性标题 (带装备变量)
function GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, titleName)
    local source = titleName
    local results = {}
    while true do
        local sIdx, eIdx, oriStr, param = string.find(source, "(<$ITEMVAR%((.-)%)>)")
        if not (oriStr and param) then
            break
        end
        results[oriStr] = SL:GetValue("ITEM_CUSTOM_VAR_BY_VNAME", itemMakeIndex, param) or ""
        local s1 = string.sub(source, 1, sIdx - 1)
        local s2 = string.sub(source, eIdx + 1, string.len(source))
        source = s1 .. s2
    end

    for key, result in pairs(results) do
        local sIdx, eIdx = string.find(titleName, key, 1, true)
        titleName = string.sub(titleName, 1, sIdx - 1) .. tostring(result) .. string.sub(titleName, eIdx + 1, string.len(titleName))
    end

    return titleName
end

-- 装备自定义属性
function GUIFunction:GetItemDiyAttr(itemData)
    local attList = {}
    if not itemData or not itemData.DiyAdv or not next(itemData.DiyAdv) then
        return attList
    end
    for _, att in ipairs(itemData.DiyAdv) do
        if att.Idx and att.Idx > 0 and att.Value and att.Value ~= 0 and att.Type then
            if not attList[att.Type] then
                attList[att.Type] = {}
            end
            table.insert(attList[att.Type], {
                id = att.Idx,
                value = att.Value
            })
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

-- 道具属性描述
function GUIFunction:GetItemAttDesc(item)
    local sFormat = string.format
    local equipMap = GUIDefine.EquipMapByStdMode
    local showLasting = SL:GetValue("EX_SHOWLAST_MAP")
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
        local pos =  GUIFunction:GetEmptyPosByStdMode(item.StdMode)
        if pos then
            -- 基础属性
            local attList = GUIFunction:ParseItemBaseAtt(item.Attribute)

            -- 极品属性
            local qualityAttrs = GUIFunction:GetItemQualityAttr(item)
            -- 合并极品属性
            if qualityAttrs and next(qualityAttrs) then
                attList = GUIFunction:CombineAttList(attList, qualityAttrs)
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

----------------- 物品自定义描述 ----------------------
local function parseDescEffect(value)
    local params = SL:Split(value or "", "#")
    local effectId = tonumber(params[1])
    if not effectId then
        return
    end
    
    local effectTab = {}
    effectTab.effectId = effectId
    effectTab.type = tonumber(params[2]) or 0  -- 0:顶部 1:底部
    effectTab.mode = tonumber(params[3]) or 1  -- 1:前面 2:后面
    effectTab.x = tonumber(params[4]) or 0
    effectTab.y = tonumber(params[5]) or 0

    return effectTab
end

function GUIFunction:GetItemDescList(itemData)
    local desc = itemData.Desc
    local descList = {}
    local effectList = {}
    if not desc or string.len(desc) == 0 then
        return nil
    end
    local function parse(desc)
        if tonumber(desc) then
            local config = GUIDefineEx.ItemDescConfig[tonumber(desc)]
            if not config or not next(config) then
                return
            end
            if config.type == 1 then
                if config.str and string.len(config.str) > 0 then
                    if not descList[config.group_id] then
                        descList[config.group_id] = {}
                    end
                    table.insert(descList[config.group_id], config.str)
                end
            else
                local effect = parseDescEffect(config.str)
                if effect then
                    table.insert(effectList, effect)
                end
            end
        end
    end
    
    for i, v in ipairs(SL:Split(tostring(desc), "#")) do
        parse(v)
    end

    return descList, effectList
end

function GUIFunction:GetItemDescStrByGroup(list, groupId)
    if not groupId or not list or not list[groupId] then
        return
    end
    
    local strList = list[groupId]
    local str = ""
    for i = 1, #strList do
        str = string.format("%s%s%s", str, strList[i], i ~= #strList and "<br>" or "")
    end
    return str
end
---------------------------------------------------

-- 物品是否显示拍卖行物品栏
function GUIFunction:CheckItemIsShowAuction(itemData)
    return true
end


--------------------------- 聊天解析  begin-------------------------------
-- check 是否私聊频道
local function checkIsPrivateChannel(channelId)
    return channelId == GUIDefine.ChatChannel.PRIVATE
end

-- fix chat Name
-- 处理发送者名字
function GUIFunction:ChatFixName(data)
    local sendName = data.SendName or ""
    local receiveName = data.ReceiveName or ""
    local name = sendName
    -- 私聊处理
    if checkIsPrivateChannel(data.ChannelId) then
        if data.SendId and SL:GetValue("ACTOR_IS_MAINPLAYER", data.SendId) then
            name = "你对" .. "[" .. receiveName .. "]" .. "说"
        else
            if SL:GetValue("IS_PC_OPER_MODE") then
                local levelStr = string.format(data.Suffix or "", data.Level or "")
                name = string.format("[%s]%s", sendName, levelStr) .. "对你说"
            else
                name = "[" .. sendName .. "]" .. "对你说" 
            end
        end
    end
    
    if name and string.len(name) > 0 then
        return name .. ":"
    end
    return name
end

-- fix chat private time
-- 私聊时间格式化
function GUIFunction:ChatFixPrivateTime(data)
    if checkIsPrivateChannel(data.ChannelId) then
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
    local prefix = data.Prefix or ""
    local name  = self:ChatFixName(data)
    local str   = string.format("<outline size='0'>%s%s%s</outline>", prefix, name, data.Msg or "")
    if isPrivateTime then
        return string.format("<outline size='0'>%s%s</outline>", self:ChatFixPrivateTime(data), str)
    end
    return str
end

-- fix chat msg outline
-- 使用类型：系统通知消息，需使用FColor富文本解析; 系统通知消息，需使用SRText富文本解析
function GUIFunction:ChatFixMsgWithoutOutline(data, isPrivateTime)
    local prefix = data.Prefix or ""
    local name  = self:ChatFixName(data)
    local str   = string.format("%s%s%s", prefix, name, data.Msg or "")
    if isPrivateTime then
        return string.format("%s%s", self:ChatFixPrivateTime(data), str)
    end
    return str
end

-- chat width
--- 获取单条聊天item宽度
---@param isMini boolean 是否是主界面的聊天item
---@param miniChatWidth integer 主界面的聊天item宽度
---@param isPCPrivate boolean 是否PC私聊页的聊天item
function GUIFunction:ChatGetWidth(isMini, miniChatWidth, isPCPrivate)
    if isMini then
        if SL:GetValue("IS_PC_OPER_MODE") then
            return miniChatWidth or 722
        else
            return miniChatWidth or 310
        end
    elseif isPCPrivate then
        return 345
    end
    return 310
end

-- 获取聊天的通知类型的字体配置 -- isMini:是否主界面
function GUIFunction:ChatGetNoticeMsgFont(isMini, data)
    local color         = nil   -- 字体颜色  0-255
    local fontPath      = nil   -- 字体文件路径
    local fontSize      = nil   -- 字体大小
    return {color = color, fontPath = fontPath, fontSize = fontSize}
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
        local emojiConfig = ChatData.GetEmoji()
        for _, v in pairs(emojiConfig) do
            emojiFindParam.replaceStr = emojiFindParam.replaceStr .. string.format("<%s&%d>", v.replace, v.ID)
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
    local emojiConfig = ChatData.GetEmoji()

    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 不透明度
    local fontPath      = nil   -- 字体文件路径
    local fontSize      = nil   -- 字体大小
    local outColor      = nil   -- 字体描边颜色
    local outlineSize   = nil   -- 字体描边大小

    local chatParseT = {}
    while string.len(msg) > 0 do
        local fStar,fEnd = string.find(msg, "#")
        if not fStar and not fEnd then
            table.insert(chatParseT, {
                text        = msg,
                color       = color,
                opacity     = opacity,
                fontPath    = fontPath,
                fontSize    = fontSize,
                outColor    = outColor,
                outlineSize = outlineSize
            })
            break
        end
        
        if fStar > 1 then
            local prefixEmoJi = string.sub(msg, 1, fStar - 1) --截取表情前部分
            msg               = string.sub(msg, fStar)
            table.insert(chatParseT, {
                text        = prefixEmoJi,
                color       = color,
                opacity     = opacity,
                fontPath    = fontPath,
                fontSize    = fontSize,
                outColor    = outColor,
                outlineSize = outlineSize
            })
        end
        
        -- 查找表情
        local findEmoji = nil
        local str, finLen = GetEmojiFindParam()
        for _len, v in pairs(finLen) do
            local emojiStr  = string.sub(msg, 1, _len)
            local regexS    = string.format("(<%s&%%d+>)", emojiStr)
            local matchS    = string.match(str, regexS)
            if emojiStr and matchS then
                msg                 = string.sub(msg, _len + 1)
                local mathcArray    = string.split(matchS, "&")
                local emojiID       = tonumber(string.sub(mathcArray[2] or "", 1, -2))
                if emojiID and emojiConfig[emojiID] then
                    findEmoji = emojiStr
                    table.insert(chatParseT, {sfxID = emojiConfig[emojiID].sfxid})
                end
                break
            end
        end

        -- 没找到表情, 截取出"#"
        if not findEmoji then
            msg = string.sub(msg, fStar + 1)
            table.insert(chatParseT, {
                text        = "#",
                color       = color,
                opacity     = opacity,
                fontPath    = fontPath,
                fontSize    = fontSize,
                outColor    = outColor,
                outlineSize = outlineSize
            })
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
    local opacity       = nil   -- 不透明度
    local fontPath      = nil   -- 字体文件路径
    local fontSize      = nil   -- 字体大小
    local outColor      = nil   -- 字体描边颜色
    local outlineSize   = nil   -- 字体描边大小

    local str       = string.format("[%s %s,%s]", jsonData.mapName, jsonData.mapX, jsonData.mapY)
    local posLink   = string.format("position#%s#%s#%s", jsonData.mapID, jsonData.mapX, jsonData.mapY)
    local data      = {}
    table.insert(data, {
        text        = str,
        link        = posLink,
        color       = color,
        opacity     = opacity,
        fontPath    = fontPath,
        fontSize    = fontSize,
        outColor    = outColor,
        outlineSize = outlineSize
    })
    return data
end

-- 解析装备类型聊天数据
function GUIFunction:ChatParseEItem(jsonData)
    if nil == jsonData then
        return {}
    end
    local color         = nil   -- 字体颜色  0-255
    local opacity       = nil   -- 不透明度
    -- 支持添加文本

    local chatParseT = {}
    table.insert(chatParseT, {equip = jsonData, color = color, opacity = opacity})
    return chatParseT
end

-- 获取聊天富文本默认大小
function GUIFunction:GetChatRichFontSize()
    return SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE")
end

-- 触发私聊
function GUIFunction:PrivateChat(data, richText)
    if data.SendId and data.SendName  then
        local mainPlayerID = SL:GetValue("USER_ID")
        if data.SendId == mainPlayerID then 
            return 
        end
        
        SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = data.SendName, uid = data.SendId})
    end 
end

-- 聊天item添加右键点击事件
function GUIFunction:ChatItemOnMouseRightEvent(data, richText)
    local mainPlayerID = SL:GetValue("USER_ID")
    local targetID = data.SendId
    if SL:GetValue("IS_PC_OPER_MODE") and targetID and targetID ~= mainPlayerID then
        local function OpenFuncDock(touchPos)
            if not SL:GetValue("ACTOR_IS_VALID", targetID) then
                return 0
            end
    
            local dockType = FuncDockData.FuncDockType
            if SL:GetValue("ACTOR_IS_PLAYER", targetID) and GUI:isClippingParentContainsPoint(richText, touchPos) then
                UIOperator:OpenFuncDockTips({
                    type        = SL:GetValue("ACTOR_IS_HUMAN", targetID) and dockType.Func_Monster_Head or dockType.Func_Player_Head,
                    targetId    = targetID,
                    targetName  = SL:GetValue("ACTOR_NAME", targetID) or "",
                    pos         = {x = touchPos.x + 15, y = touchPos.y}
                })
                return
            end
            return 0
        end
        GUI:addMouseButtonEvent(richText, {
            onRightDownFunc = OpenFuncDock,
            needTouchPos = true,
        })
    end
end

-- 生成主界面聊天item
function GUIFunction:GenerateChatMiniItem(data)
    local CHANNEL   = GUIDefine.ChatChannel
    local MSG_TYPE  = GUIDefine.ChatTextType
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")

    local FColorHEX = SL:GetHexColorByStyleId(data.FColor)
    local BColorEnable = data.BColor ~= -1
    local BColorHEX = SL:GetHexColorByStyleId(data.BColor)

    -- 默认字体字号
    local defaultSize       = GUIFunction:GetChatRichFontSize()
    local defaultfontPath   = GUIDefineEx.ChatRichFontPath

    local miniWid   = MainProperty and MainProperty.GetChatWidth()
    local width     = math.max(GUIFunction:ChatGetWidth(true, miniWid), 20)
    local richText  = nil

    local cell      = GUI:Widget_Create(-1, "cell", 0, 0, 0, 0)

    local msgFont   = GUIFunction:ChatGetNoticeMsgFont(true, data) or {}
    local fontSize  = msgFont.fontSize or defaultSize
    local fontColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color) or FColorHEX
    local fontPath  = msgFont.fontPath or defaultfontPath
    local space     = GUIDefineEx.ChatContentInterval.richVspace

    if (data.textType and data.textType == MSG_TYPE.SYSTEMTIPS) or (data.ChannelId == CHANNEL.GUILDTIPS) then
        local str = GUIFunction:ChatFixMsg(data)
        local hexColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color)
        richText = GUI:RichText_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)
        
    elseif data.textType and data.textType == MSG_TYPE.FCTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data)
        richText = GUI:RichTextFCOLOR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath, {outlineSize = 0})

    elseif data.textType and data.textType == MSG_TYPE.SRTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data)
        richText = GUI:RichTextSR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)

    else
        local elements  = {}

        -- prefix
        if data.Prefix and data.Prefix ~= "" then
            local element   = GUI:RichTextCombineCell_Create(-1, "prefix_show", 0, 0, "TEXT", {
                str         = data.Prefix,
                color       = FColorHEX,
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- vip label
        if data.viplabel and data.viplabel ~= "" and data.vipcolor then
            local element   = GUI:RichTextCombineCell_Create(-1, "vip_show", 0, 0, "TEXT", {
                str         = data.viplabel,
                color       = SL:GetHexColorByStyleId(data.vipcolor),
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- name
        local str       = GUIFunction:ChatFixName(data)
        local element   = GUI:RichTextCombineCell_Create(-1, "name_show", 0, 0, "TEXT", {
            str         = str,
            color       = FColorHEX,
            fontPath    = defaultfontPath,
            fontSize    = defaultSize
        })
        table.insert(elements, element)

        -- msg
        local telements = GUIFunction:CreateChatRichElements(data)
        for _, v in ipairs(telements) do
            table.insert(elements, v)
        end

        -- 填充
        richText = GUI:RichTextCombine_Create(cell, "RichText", 0, 0, width, space)
        GUI:RichTextCombine_pushBackElements(richText, elements)

        -- 
        GUI:RichText_setOpenUrlEvent(richText, function(sender, str)
            local slices  = string.split(str, "#")
            local command = slices[1]
            if command == "position" then
                local originScale = GUI:getScale(sender)
                GUI:setScale(sender, originScale + 0.2)
                local function reback()
                    GUI:setScale(sender, originScale)
                end
                SL:scheduleOnce(sender, reback, 0.03)
                
                -- find position
                local mapID   = slices[2]
                local x       = tonumber(slices[3])
                local y       = tonumber(slices[4])
                local moveType = GUIDefine.AutoMoveType.CHAT
                SL:SetValue("BATTLE_MOVE_BEGIN", mapID, x, y, nil, moveType)

                return nil
            end
        end)

        GUI:RichTextCombine_format(richText)
    end
    if BColorEnable then 
        GUI:RichText_setBackgroundColor(richText, BColorHEX)
    end

    -- 与发送者私聊
    if isWinMode then
        local needFillInput = data.textType == MSG_TYPE.NORMAL
        GUI:setTouchEnabled(richText, true)
        GUI:setSwallowTouches(richText, false)
        GUI:addOnClickEvent(richText, function()
            local mainPlayerID = SL:GetValue("USER_ID")
            if data.SendId and data.SendName and data.SendId ~= mainPlayerID then
                GUIFunction:PrivateChat(data, richText)
            elseif needFillInput then
                SL:onLUAEvent(LUA_EVENT_PC_FILL_CHAT_INPUT, data.Msg)
            end
        end)
    end

    local richSize = GUI:getContentSize(richText)
    GUI:setContentSize(cell, width, richSize.height)
    -- 右键展示功能栏
    if isWinMode then
        if data.SendId and data.SendName then
            GUIFunction:ChatItemOnMouseRightEvent(data, cell)
        end
    end

    return cell
end

-- 生成聊天页聊天item
function GUIFunction:GenerateChatItem(data)
    local CHANNEL   = GUIDefine.ChatChannel
    local MSG_TYPE  = GUIDefine.ChatTextType

    data.FColor     = data.FColor or 0
    data.BColor     = data.BColor or 255
    local FColorHEX = SL:GetHexColorByStyleId(data.FColor)
    local BColorEnable = data.BColor ~= -1
    local BColorHEX = SL:GetHexColorByStyleId(data.BColor)

    -- 默认字体字号
    local defaultSize       = GUIFunction:GetChatRichFontSize()
    local defaultfontPath   = GUIDefineEx.ChatRichFontPath

    local width     = GUIFunction:ChatGetWidth(false)
    local richText  = nil

    local cell      = GUI:Widget_Create(-1, "cell", 0, 0, 0, 0)

    local msgFont   = GUIFunction:ChatGetNoticeMsgFont(false, data) or {}
    local fontSize  = msgFont.fontSize or defaultSize
    local fontColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color) or FColorHEX
    local fontPath  = msgFont.fontPath or defaultfontPath
    local space     = GUIDefineEx.ChatContentInterval.richVspace

    if (data.textType and data.textType == MSG_TYPE.SYSTEMTIPS) or (data.ChannelId == CHANNEL.GUILDTIPS) then
        local str = GUIFunction:ChatFixMsg(data)
        local hexColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color)
        richText = GUI:RichText_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)
        
    elseif data.textType and data.textType == MSG_TYPE.FCTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data)
        richText = GUI:RichTextFCOLOR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath, {outlineSize = 0})

    elseif data.textType and data.textType == MSG_TYPE.SRTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data)
        richText = GUI:RichTextSR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)

    else
        local elements  = {}

        -- prefix
        if data.Prefix and data.Prefix ~= "" then
            local element   = GUI:RichTextCombineCell_Create(-1, "prefix_show", 0, 0, "TEXT", {
                str         = data.Prefix,
                color       = FColorHEX,
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- vip label
        if data.viplabel and data.viplabel ~= "" and data.vipcolor then
            local element   = GUI:RichTextCombineCell_Create(-1, "vip_show", 0, 0, "TEXT", {
                str         = data.viplabel,
                color       = SL:GetHexColorByStyleId(data.vipcolor),
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- name
        local str       = GUIFunction:ChatFixName(data)
        local element   = GUI:RichTextCombineCell_Create(-1, "name_show", 0, 0, "TEXT", {
            str         = str,
            color       = FColorHEX,
            fontPath    = defaultfontPath,
            fontSize    = defaultSize
        })
        table.insert(elements, element)

        -- msg
        local telements = GUIFunction:CreateChatRichElements(data)
        for _, v in ipairs(telements) do
            table.insert(elements, v)
        end

        -- 填充
        richText = GUI:RichTextCombine_Create(cell, "RichText", 0, 0, width, space)
        GUI:RichTextCombine_pushBackElements(richText, elements)

        -- 
        GUI:RichText_setOpenUrlEvent(richText, function(sender, str)
            local slices  = string.split(str, "#")
            local command = slices[1]
            if command == "position" then
                local originScale = GUI:getScale(sender)
                GUI:setScale(sender, originScale + 0.2)
                local function reback()
                    GUI:setScale(sender, originScale)
                end
                SL:scheduleOnce(sender, reback, 0.03)
                
                -- find position
                local mapID   = slices[2]
                local x       = tonumber(slices[3])
                local y       = tonumber(slices[4])
                local moveType = GUIDefine.AutoMoveType.CHAT
                SL:SetValue("BATTLE_MOVE_BEGIN", mapID, x, y, nil, moveType)

                return nil
            end
        end)

        GUI:RichTextCombine_format(richText)
    end
    if BColorEnable then 
        GUI:RichText_setBackgroundColor(richText, BColorHEX)
    end

    -- 与发送者私聊
    GUI:setTouchEnabled(richText, true)
    GUI:setSwallowTouches(richText, false)
    GUI:addOnClickEvent(richText, function()
        local mainPlayerID = SL:GetValue("USER_ID")
        if data.SendId and data.SendName and data.SendId ~= mainPlayerID then
            GUIFunction:PrivateChat(data, richText)
        end
    end)

    local richSize = GUI:getContentSize(richText)
    GUI:setAnchorPoint(richText, 0, 1)
    GUI:setPosition(richText, 0, richSize.height)

    GUI:setContentSize(cell, width, richSize.height)
    GUI:setAnchorPoint(cell, 0, 0)
    GUI:setPosition(cell, 40, 0)

    if cell then
        SL:onLUAEvent(LUA_EVENT_CHAT_ITEM_ADD, {item = cell, channel = data.ChannelId})
    end

    return cell
end

-- 生成PC私聊页聊天item
function GUIFunction:GenerateChatPCPrivateItem(data)
    local CHANNEL   = GUIDefine.ChatChannel
    local MSG_TYPE  = GUIDefine.ChatTextType
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")

    data.FColor     = data.FColor or 0
    data.BColor     = data.BColor or 255
    local FColorHEX = SL:GetHexColorByStyleId(data.FColor)
    local BColorEnable = data.BColor ~= -1
    local BColorHEX = SL:GetHexColorByStyleId(data.BColor)

    -- 默认字体字号
    local defaultSize       = GUIFunction:GetChatRichFontSize()
    local defaultfontPath   = GUIDefineEx.ChatRichFontPath

    local width     = GUIFunction:ChatGetWidth(false, nil, true)
    local richText  = nil

    local cell      = GUI:Widget_Create(-1, "cell", 0, 0, 0, 0)

    local msgFont   = GUIFunction:ChatGetNoticeMsgFont() or {}
    local fontSize  = msgFont.fontSize or defaultSize
    local fontColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color) or FColorHEX
    local fontPath  = msgFont.fontPath or defaultfontPath
    local space     = GUIDefineEx.ChatContentInterval.richVspace

    if (data.textType and data.textType == MSG_TYPE.SYSTEMTIPS) or (data.ChannelId == CHANNEL.GUILDTIPS) then
        local str = GUIFunction:ChatFixMsg(data, true)
        local hexColor = msgFont.color and SL:GetHexColorByStyleId(msgFont.color)
        richText = GUI:RichText_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)
        
    elseif data.textType and data.textType == MSG_TYPE.FCTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data, true)
        richText = GUI:RichTextFCOLOR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath, {outlineSize = 0})

    elseif data.textType and data.textType == MSG_TYPE.SRTEXT then
        local str = GUIFunction:ChatFixMsgWithoutOutline(data, true)
        richText = GUI:RichTextSR_Create(cell, "RichText", 0, 0, str, width, fontSize, fontColor, space, nil, fontPath)

    else
        local elements  = {}

        -- 时间
        local timeStr = GUIFunction:ChatFixPrivateTime(data)
        if timeStr and timeStr ~= "" then
            local element   = GUI:RichTextCombineCell_Create(-1, "private_time", 0, 0, "TEXT", {
                str         = timeStr,
                color       = FColorHEX,
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- prefix
        if data.Prefix and data.Prefix ~= "" then
            local element   = GUI:RichTextCombineCell_Create(-1, "prefix_show", 0, 0, "TEXT", {
                str         = data.Prefix,
                color       = FColorHEX,
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- vip label
        if data.viplabel and data.viplabel ~= "" and data.vipcolor then
            local element   = GUI:RichTextCombineCell_Create(-1, "vip_show", 0, 0, "TEXT", {
                str         = data.viplabel,
                color       = SL:GetHexColorByStyleId(data.vipcolor),
                fontPath    = defaultfontPath,
                fontSize    = defaultSize
            })
            table.insert(elements, element)
        end

        -- name
        local str       = GUIFunction:ChatFixName(data)
        local element   = GUI:RichTextCombineCell_Create(-1, "name_show", 0, 0, "TEXT", {
            str         = str,
            color       = FColorHEX,
            fontPath    = defaultfontPath,
            fontSize    = defaultSize
        })
        table.insert(elements, element)

        -- msg
        local telements = GUIFunction:CreateChatRichElements(data)
        for _, v in ipairs(telements) do
            table.insert(elements, v)
        end

        -- 填充
        richText = GUI:RichTextCombine_Create(cell, "RichText", 0, 0, width, space)
        GUI:RichTextCombine_pushBackElements(richText, elements)

        -- 
        GUI:RichText_setOpenUrlEvent(richText, function(sender, str)
            local slices  = string.split(str, "#")
            local command = slices[1]
            if command == "position" then
                local originScale = GUI:getScale(sender)
                GUI:setScale(sender, originScale + 0.2)
                local function reback()
                    GUI:setScale(sender, originScale)
                end
                SL:scheduleOnce(sender, reback, 0.03)
                
                -- find position
                local mapID   = slices[2]
                local x       = tonumber(slices[3])
                local y       = tonumber(slices[4])
                local moveType = GUIDefine.AutoMoveType.CHAT
                SL:SetValue("BATTLE_MOVE_BEGIN", mapID, x, y, nil, moveType)

                return nil
            end
        end)

        GUI:RichTextCombine_format(richText)
    end
    if BColorEnable then 
        GUI:RichText_setBackgroundColor(richText, BColorHEX)
    end

    -- 与发送者私聊
    if isWinMode then
        GUI:setTouchEnabled(richText, true)
        GUI:setSwallowTouches(richText, false)
        GUI:addOnClickEvent(richText, function()
            local mainPlayerID = SL:GetValue("USER_ID")
            if data.SendId and data.SendName and data.SendId ~= mainPlayerID then
                GUIFunction:PrivateChat(data, richText)
            end
        end)
    end

    local richSize = GUI:getContentSize(richText)
    GUI:setAnchorPoint(richText, 0, 1)
    GUI:setPosition(richText, 0, richSize.height)

    GUI:setContentSize(cell, width, richSize.height)
    GUI:setAnchorPoint(cell, 0, 0)
    GUI:setPosition(cell, 40, 0)
    -- 右键展示功能栏
    if isWinMode then
        if data.SendId and data.SendName then
            GUIFunction:ChatItemOnMouseRightEvent(data, cell)
        end
    end

    return cell
end

-------- 解析消息元素
-- 普通
local function createNormalElements(msg, defaultfontPath, defaultSize, color, outlineColor, outlineSize, isActorSay)
    local elements  = {}
    local defaultOutlineColor = outlineColor or "#000000"
    local defaultOutlineSize = outlineSize or 0
    local emojiOffSetY = isActorSay and -4 or 0
    local parseT = GUIFunction:ChatParseNormal(msg)
    for i, v in ipairs(parseT) do
        if v.text then
            local element = GUI:RichTextCombineCell_Create(-1, "normal_text", 0, 0, "TEXT", {
                str             = v.text,
                color           = v.color and SL:GetHexColorByStyleId(v.color) or color,
                opacity         = v.opacity,
                fontPath        = v.fontPath or defaultfontPath,
                fontSize        = v.fontSize or defaultSize,
                outlineColor    = v.outColor and SL:GetHexColorByStyleId(v.outColor) or defaultOutlineColor,
                outlineSize     = v.outlineSize or defaultOutlineSize
            })
            table.insert(elements, element)
        elseif v.sfxID then
            -- 创建一个表情
            local layout = GUI:Layout_Create(-1, "emoji_panel", 0, 0, 36, 36)
            GUI:addStateEvent(layout, function(state)
                if state == "enter" then
                    GUI:removeAllChildren(layout)
                    local size = GUI:getContentSize(layout)
                    local emojiSfx = GUI:Effect_Create(layout, "emoji_sfx", size.width / 2, size.height / 2 + emojiOffSetY, 0, v.sfxID)
                    GUI:setScale(emojiSfx, 0.7)
                end
            end)
            local element = GUI:RichTextCombineCell_Create(-1, "emoji_element", 0, 0, "NODE", {node = layout})
            table.insert(elements, element)
        end
    end
    return elements
end

-- 坐标
local function parseEPosition(msg, defaultfontPath, defaultSize)
    local elements  = {}
    local jsonData  = SL:JsonDecode(msg)
    local parseT    = GUIFunction:ChatParseEPosition(jsonData)
    local color     = "#00cb52"         -- 默认色值
    for i, v in ipairs(parseT) do
        if v.text then  
            local element = GUI:RichTextCombineCell_Create(-1, "position_text", 0, 0, "TEXT", {
                str             = v.text,
                color           = v.color and SL:GetHexColorByStyleId(v.color) or color,
                opacity         = v.opacity,
                fontPath        = v.fontPath or defaultfontPath,
                fontSize        = v.fontSize or defaultSize,
                link            = v.link or "",
                outlineColor    = v.outColor and SL:GetHexColorByStyleId(v.outColor) or "#000000",
                outlineSize     = v.outlineSize or 0
            })
            table.insert(elements, element)
        end
    end
    return elements
end

-- 装备
local function parseEItem(msg, defaultfontPath, defaultSize, color)
    local jsonData = SL:JsonDecode(msg)
    if type(jsonData.ExtendInfo) == "string" then
        jsonData.ExtendInfo = SL:JsonDecode(jsonData.ExtendInfo)
    end
    jsonData = SL:TransItemDataIntoChatShow(jsonData)

    local elements = {}
    local parseT = GUIFunction:ChatParseEItem(jsonData)
    local isPc = SL:GetValue("IS_PC_OPER_MODE")
    local size = isPc and {width = 40, height = 40} or {width = 66, height = 66}
    for i, v in ipairs(parseT) do
        if v.text then
            local element = GUI:RichTextCombineCell_Create(-1, "equip_text", 0, 0, "TEXT", {
                str             = v.text,
                color           = v.color and SL:GetHexColorByStyleId(v.color) or color,
                opacity         = v.opacity,
                fontPath        = v.fontPath or defaultfontPath,
                fontSize        = v.fontSize or defaultSize,
                link            = v.link or "",
                outlineColor    = v.outColor and SL:GetHexColorByStyleId(v.outColor) or "#000000",
                outlineSize     = v.outlineSize or 0
            })
            table.insert(elements, element)
        elseif v.equip then
            -- 创建道具item
            local layout = GUI:Layout_Create(-1, "item_panel", 0, 0, size.width, size.height)
            GUI:addStateEvent(layout, function(state)
                if state == "enter" then
                    GUI:removeAllChildren(layout)
                    local item = GUI:ItemShow_Create(layout, "item", size.width / 2, size.height / 2, {
                        index       = v.equip.Index,
                        itemData    = v.equip,
                        look        = true,
                        bgVisible   = true,
                        checkPower  = true
                    })
                    GUI:setAnchorPoint(item, 0.5, 0.5)
                end
            end)
            local element = GUI:RichTextCombineCell_Create(-1, "equip_element", 0, 0, "NODE", {
                node    = layout,
                color   = v.color and SL:GetHexColorByStyleId(v.color) or "#FFFFFF",
                opacity = v.opacity or 255
            })
            table.insert(elements, element)
        end
    end
    return elements
end

-- 创建不同类型聊天富文本元素
function GUIFunction:CreateChatRichElements(data)
    data.FColor     = data.FColor or 0
    data.BColor     = data.BColor or 255
    local FColorHEX = SL:GetHexColorByStyleId(data.FColor)
    local BColorHEX = SL:GetHexColorByStyleId(data.BColor)

    -- 默认字体字号
    local defaultSize       = GUIFunction:GetChatRichFontSize()
    local defaultfontPath   = GUIDefineEx.ChatRichFontPath

    local mt        = tonumber(data.MT) or 0
    local msg       = data.Msg

    if mt == GUIDefine.ChatMsgType.POSITION then
        return parseEPosition(msg, defaultfontPath, defaultSize)
        
    elseif mt == GUIDefine.ChatMsgType.EQUIP then
        return parseEItem(msg, defaultfontPath, defaultSize, FColorHEX)
    end

    return createNormalElements(msg, defaultfontPath, defaultSize, FColorHEX)
end

-- 处理私聊名字后接空格状况
function GUIFunction:FixPrivateChatMsgWithSpace(findInfo)
    local name = string.trim(findInfo[3]) or ""
    local fStar, fEnd = string.find(name, " ")
    local content = ""
    if fStar and fEnd then
        content = string.sub(name, fEnd + 1, -1)
        name = string.sub(name, 1, fStar - 1)
    end
    content = content .. (findInfo[4] or "")
    return name, content
end

-- 根据聊天消息内容获取对应频道
function GUIFunction:GetChannelByChatMsg(msg)
    local channel = nil
    local content = msg
    local targetName = nil
    for _, v in ipairs(GUIDefine.ChatChannelPrefix) do
        local pattern = v.pattern or "^" .. v.prefix .. "(.+)"
        local findInfo = {string.find(msg, pattern)}
        if findInfo[1] and findInfo[2] then
            channel = v.channel
            local rContent = findInfo[3]
            if channel == GUIDefine.ChatChannel.PRIVATE then
                local fName, fContent = GUIFunction:FixPrivateChatMsgWithSpace(findInfo)
                rContent = fContent
                if fName and string.len(fName) > 0 then
                    targetName = fName
                end
            end
            content = rContent
            break
        end
    end

    if not channel then  -- 新增 /名字 直接私聊
        local findInfo = {string.find(msg, "^/.+")}
        if findInfo[1] and findInfo[2] then
            channel = GUIDefine.ChatChannel.PRIVATE
            content = " "
        end
    end

    return channel, content, targetName
end

-- 根据聊天消息内容获取聊天对象
function GUIFunction:FindTargetByChatMsg(msg)
    local pattern = nil
    local res = nil
    for _, v in pairs(GUIDefine.ChatChannelPrefix) do
        if v.channel == GUIDefine.ChatChannel.PRIVATE then
            pattern = v.pattern
            break
        end
    end
    
    if not pattern then
        return res
    else
        local findInfo = {string.find(msg, pattern)}
        if findInfo[1] and findInfo[2] then
            local rName, rContent = GUIFunction:FixPrivateChatMsgWithSpace(findInfo)
            res = rName
        end
        if not res then
            findInfo = {string.find(msg, "^/(.+)")}
            if findInfo[1] and findInfo[2] then
                res = string.gsub(findInfo[3], " ", "")
            end
        end
    end

    return res
end

-- 检查频道能否发送聊天
function GUIFunction:CheckAbleToSayByChannel(channel)
    if GUIDefine.ChatChannel.PRIVATE == channel then
        -- 私聊
        local targets = ChatData.GetTargets()
        if not targets or not targets[1] then
            SL:ShowSystemTips("没有可以发送的目标")
            return false
        end

    elseif GUIDefine.ChatChannel.SYSTEM == channel then
        -- 系统
        SL:ShowSystemTips("系统频道无法发言")
        return false
    end

    -- cding
    if ChatData.GetCDTime(channel) > 0 then
        SL:ShowSystemTips(string.format("您还需等待%s秒才能发言", ChatData.GetCDTime(channel)))
        return false
    end

    local ret, buffID = SL:GetValue("BUFF_CHECK_CHAT_ENABLE")
    if not ret then
        if buffID then
            local config = SL:GetValue("BUFF_CONFIG", buffID) or {}
            if config.bufftitle then
                SL:ShowSystemTips(config.bufftitle)
            end
        end
        return false
    end

    return true
end

-- 处理聊天消息长度限制
function GUIFunction:HandleLimitChatMsg(data)
    if data and type(data.Msg) == "string" then
        if data and string.utf8len(data.Msg or "") > GUIDefine.ChatConfig.MSG_LIMIT_COUNT then
            data.Msg = SL:GetUTF8SubString(data.Msg, 1, GUIDefine.ChatConfig.MSG_LIMIT_COUNT)
        end
    end

    if data and type(data.oriMsg) == "string" then
        if data and string.utf8len(data.oriMsg or "") > GUIDefine.ChatConfig.MSG_LIMIT_COUNT then
            data.oriMsg = SL:GetUTF8SubString(data.Msg, 1, GUIDefine.ChatConfig.MSG_LIMIT_COUNT)
        end
    end
    return data
end

-- 获取聊天频道默认CD
function GUIFunction:GetChatCDParam(channel)
    if not GUIDefine.ChatCDTime then
        GUIDefine.ChatCDTime = {}
    end

    if not next(GUIDefine.ChatCDTime) then
        local chatCDs = SL:GetValue("GAME_DATA", "CHATCDS")
        if chatCDs and chatCDs ~= "" then
            local cdvec = string.split(chatCDs, "|")
            GUIDefine.ChatCDTime = {
                [GUIDefine.ChatChannel.PRIVATE]  = tonumber(cdvec[GUIDefine.ChatChannel.PRIVATE]),            -- 私聊
                [GUIDefine.ChatChannel.NEAR]     = tonumber(cdvec[GUIDefine.ChatChannel.NEAR]),               -- 附近
                [GUIDefine.ChatChannel.SHOUT]    = tonumber(cdvec[GUIDefine.ChatChannel.SHOUT]),              -- 世界
                [GUIDefine.ChatChannel.TEAM]     = tonumber(cdvec[GUIDefine.ChatChannel.TEAM]),               -- 组队
                [GUIDefine.ChatChannel.GUILD]    = tonumber(cdvec[GUIDefine.ChatChannel.GUILD]),              -- 行会
                [GUIDefine.ChatChannel.UNION]    = tonumber(cdvec[GUIDefine.ChatChannel.UNION]),              -- 联盟
                [GUIDefine.ChatChannel.WORLD]    = tonumber(cdvec[GUIDefine.ChatChannel.WORLD]),              -- 传音
                [GUIDefine.ChatChannel.NATION]   = tonumber(cdvec[GUIDefine.ChatChannel.NATION]),             -- 国家
                [GUIDefine.ChatChannel.SYSTEM]   = tonumber(cdvec[GUIDefine.ChatChannel.SYSTEM]) or 0,        -- 系统
                [GUIDefine.ChatChannel.CROSS]    = tonumber(cdvec[GUIDefine.ChatChannel.CROSS]),              -- 跨服
            }
        end
    end

    return GUIDefine.ChatCDTime[channel] or 1
end

-- 发送聊天消息
function GUIFunction:SendChatMsg(data)
    local CHANNEL = GUIDefine.ChatChannel
    local isPCMode = SL:GetValue("IS_PC_OPER_MODE")

    if SL:GetValue("M2_FORBID_SAY") then
        -- exclude gm
        if not (type(data.msg) == "string" and string.find(data.msg, "^@.-")) then
            SL:ShowSystemChat("本地图禁止说话聊天", 255, 249)
            return
        end
    end

    if not data or not data.msg then
        SL:Print("error: function GUIFunction:SendChatMsg(data) 1")
        return nil
    end

    data.textType  = data.textType or GUIDefine.ChatTextType.NORMAL
    data.msg       = data.msg
    data.originMsg = data.msg

    -- PC端指定频道, 但内容为私聊则发送私聊
    if isPCMode and data.channel and type(data.msg) == "string" then
        local channel, content = GUIFunction:GetChannelByChatMsg(data.msg)
        if channel and channel == CHANNEL.PRIVATE then
            data.msg     = content
            data.channel = channel

            local targetName = GUIFunction:FindTargetByChatMsg(data.originMsg)
            if targetName then
                ChatData.AddTarget({name = targetName})
            end
        end
    end

    -- PC端不指定频道，由内容决定
    if isPCMode and nil == data.channel and type(data.msg) == "string" then
        local channel, content = GUIFunction:GetChannelByChatMsg(data.msg)
        channel      = channel or CHANNEL.NEAR
        data.msg     = content
        data.channel = channel

        if data.channel == CHANNEL.PRIVATE then
            local targetName = GUIFunction:FindTargetByChatMsg(data.originMsg)
            if targetName then
                ChatData.AddTarget({name = targetName})
            end
        end
    end

    -- 兼容PC端前缀
    if not isPCMode and type(data.msg) == "string" then
        local channel, content = GUIFunction:GetChannelByChatMsg(data.msg)
        if channel and channel ~= CHANNEL.PRIVATE then
            data.msg     = content
            data.channel = channel
        end
    end

    -- 手机端添加 任何频道都能私聊的功能
    if not isPCMode and type(data.msg) == "string" then
        local channel, content = GUIFunction:GetChannelByChatMsg(data.msg)
        if channel and channel == CHANNEL.PRIVATE then
            data.msg     = content
            data.channel = channel
            local targetName = GUIFunction:FindTargetByChatMsg(data.originMsg)
            if targetName then
                ChatData.AddTarget({name = targetName})
            end
        end
    end

    if not data.channel then
        SL:Print("error: function GUIFunction:OnSendChatMsg(data) 2")
        return nil
    end

    -- 是否可发送
    if not GUIFunction:CheckAbleToSayByChannel(data.channel) then
        local checkMsg = data.originMsg or data.msg or ""
        if not (type(checkMsg) == "string" and string.sub(checkMsg, 1, 1) == "@") then -- 如果是@开头的GM命令，要进行发送
            return nil
        end
    end

    -- 消息结构
    local item      = {}
    item.MT         = data.mt
    item.Msg        = data.msg
    item.Type       = data.channel

    -- 行会
    if data.channel == CHANNEL.GUILD then
        if not SL:GetValue("GUILD_IS_JOINED") then
            SL:ShowSystemTips("当前无行会，无法发送行会消息，请加入行会")
            return nil
        end
    end
    -- 队伍
    if data.channel == CHANNEL.TEAM then
        if not SL:GetValue("TEAM_IS_MEMBER") then
            SL:ShowSystemTips("当前无队伍，无法发送组队消息")
            return nil
        end
    end
    -- 私聊
    if data.channel == CHANNEL.PRIVATE then
        local target = ChatData.GetTargets()[1]
        if not target then
            SL:ShowSystemTips("请选择私聊对象")
            return nil
        end
        -- 黑名单
        if SL:GetValue("SOCIAL_IS_BLICKLIST", target.name) then
            SL:ShowSystemTips("对方在你的黑名单，无法向其发送信息")
            return nil
        end

        item.Target     = target.uid
        item.TargetName = target.name
    end

    if data.channel == CHANNEL.NATION then
        if not SL:GetValue("NATION_IS_JOINED") then
            SL:ShowSystemTips("当前无国家，无法发送国家消息，请加入国家")
            return
        end
    end

    -- 风险等级
    item.risk = data.risk
    -- 原始文本
    item.oriMsg = data.oriMsg
    -- 匹配到的敏感词
    item.sensitiveWords = data.sensitiveWords
    -- 敏感词状态 0: 无标记 1: 被隐藏 2: 静默 3: 静默+被隐藏  
    item.status = data.status

    -- send...
    item = GUIFunction:HandleLimitChatMsg(item)
    SL:RequestSendChatMsg(item)

    -- cd... exclude gm
    if not (type(data.msg) == "string" and string.find(data.msg, "^@.-")) then
        local cd = GUIFunction:GetChatCDParam(data.channel)
        ChatData.SetCDTime(data.channel, cd)
    end
end

--------------------------- 聊天解析    end-------------------------------

--------------------------- 拍卖行相关 -------------------------------
-- 拍卖行价格显示 格式
function GUIFunction:FixAuctionPrice(price, unit)
    if unit then
        if price >= 100000000 then
            return string.format("%.1f%s", price / 100000000, "亿")
        end
        if price >= 10000 then
            return string.format("%.1f%s", price / 10000, "万")
        end
        return tostring(price)
    end
    return tostring(price)
end

-- 检查寄售cell是否显示在视图内
function GUIFunction:CheckAuctionCellShowInView(cell, view)
    local posY = GUI:getPositionY(cell)
    local cellH = GUI:getContentSize(cell).height
    local anchorY = GUI:getAnchorPoint(cell).y
    local sizeH = GUI:getContentSize(view).height
    local innerPosY = GUI:ScrollView_getInnerContainerPosition(view).y
    local isShow = (posY + (1 - anchorY) * cellH) >= -innerPosY and posY <= (-innerPosY + sizeH)
    return isShow
end
---------------------------------------------------------------------
-------------------------------------------------------------------------
-- 客户端释放技能前是否允许执行
function GUIFunction:OnCheckAllowLaunchSkillBefore(skillID)

    -- 是否继续释放技能
    return true
end
-------------------------------------------------------------------------

--是否英雄人物面板合并
function GUIFunction:IsPlayerHeroMergeMode()
    if not SL:GetValue("IS_PC_OPER_MODE") and tostring(SL:GetValue("GAME_DATA","playerInfoMode")) == "1" and tostring(SL:GetValue("GAME_DATA","syshero")) == "1" then 
        return true 
    end
    return false
end

-- 是否是自己
function GUIFunction:IsMe(actorID)
    return actorID == SL:GetValue("USERID")
end

function GUIFunction:KeyMapXY(x, y)
    return y * 65536 + x
end

local MOVE_ACTIONS = {
    [GUIDefine.Action.WALK]     = true,        -- 走
    [GUIDefine.Action.RUN]      = true,        -- 跑
    [GUIDefine.Action.RIDE_RUN] = true,        -- 坐骑跑
    [GUIDefine.Action.DASH]     = true,        -- 野蛮
    [GUIDefine.Action.ONPUSH]   = true,        -- 被野蛮/被推开
    [GUIDefine.Action.TELEPORT] = true,        -- 瞬移
    [GUIDefine.Action.ZXC]      = true,        -- 追心刺
    [GUIDefine.Action.SBYS]     = true,        -- 十步一杀
    [GUIDefine.Action.ASSASSIN_SNEAK] = true   -- 潜行
}
    
-- actor移动
function GUIFunction:IsMoveAction(act)
    return MOVE_ACTIONS[act]
end

-- 野蛮互斥动作
local dashActions = {
    [GUIDefine.Action.DASH]             = true, -- 野蛮
    [GUIDefine.Action.ONPUSH]           = true, -- 被野蛮
    [GUIDefine.Action.TELEPORT]         = true, -- 瞬移
    [GUIDefine.Action.SBYS]             = true, -- 十步一杀
    [GUIDefine.Action.DASH_FAIL]        = true, -- 野蛮失败
    [GUIDefine.Action.DASH_WAITING]     = true, -- 野蛮等待
}

-- 检查能否野蛮冲撞
function GUIFunction:CheckActionDashAble(act)
    if not act then
        return false
    end
    return dashActions[act] == nil
end

-- 是否是战士
function GUIFunction:IsFighter(job)
    return GUIDefine.Job.FIGHTER == job
end

-- 是否是法师
function GUIFunction:IsWizzard(job)
    return GUIDefine.Job.WIZZARD == job 
end

-- 是否是道士
function GUIFunction:IsTaoist(job)
    return GUIDefine.Job.TAOIST == job
end

-------------------------------------------------------------------------
-- 战斗相关
local function squLen(x, y)
    return x * x + y * y
end

-- 检测Actor能否攻击 actorID
function GUIFunction:CheckLaunchEnableByID(actorID)
    if not actorID or not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return false
    end
    -- player & monster, only!!!!
    if not SL:GetValue("ACTOR_IS_PLAYER", actorID) and not SL:GetValue("ACTOR_IS_MONSTER", actorID) then
        return false
    end

    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end
    
    local actorMasterID = SL:GetValue("ACTOR_MASTER_ID", actorID)
    
    if SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        ---- hero player / master is main hero
        local heroID = SL:GetValue("HERO_ID")
        local mainPlayerID = SL:GetValue("USER_ID")
        if heroID and (actorID == heroID or actorMasterID == heroID) then
            return false
        end

        -- main player / master is main player
        if (SL:GetValue("ACTOR_IS_PLAYER", actorID) and SL:GetValue("ACTOR_IS_MAINPLAYER", actorID)) or actorMasterID == mainPlayerID then
            return false
        end
    end

    -- dead & born
    if SL:GetValue("ACTOR_IS_DIE", actorID) or SL:GetValue("ACTOR_IS_DEATH", actorID) or SL:GetValue("ACTOR_IS_BORN", actorID) or SL:GetValue("ACTOR_IS_CAVE", actorID) then
        return false
    end
    
    -- hp 0
    if SL:GetValue("ACTOR_HP", actorID) <= 0 then
        return false
    end

    -- humanoid
    if SL:GetValue("ACTOR_IS_PLAYER", actorID) and SL:GetValue("ACTOR_IS_HUMAN", actorID) then
        if actorMasterID and SL:GetValue("ACTOR_RELATION_TAG", actorMasterID) ~= 1 then -- 人形怪如果有MasterID, 要判断Master是否是敌友
            return false
        end
        return true
    end

    -- player, check is enmey
    if SL:GetValue("ACTOR_IS_PLAYER", actorID) and SL:GetValue("ACTOR_RELATION_TAG", actorID) ~= 1 then
        return false
    end

    if SL:GetValue("ACTOR_IS_HERO", actorID) and SL:GetValue("ACTOR_RELATION_TAG", actorID) ~= 1 then
        return false
    end

    -- 采集物
    if SL:GetValue("ACTOR_IS_COLLECTION", actorID) then
        return false
    end

    return true
end

-- 检查Actor能否作为自动战斗目标
function GUIFunction.CheckAutoTargetEnableByID(actorID)
    if not actorID or not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return false
    end

    -- 被忽略
    if SL:GetValue("ACTOR_IS_IGNORED", actorID) then
        return false
    end

    -- 1.可攻击
    if false == GUIFunction:CheckLaunchEnableByID(actorID) then
        return false
    end

    -- 2.守卫/宝宝 -- 有主人的人型怪也不打,分身等
    if not SL:GetValue("ACTOR_IS_HERO", actorID) and (SL:GetValue("ACTOR_IS_DEFENDER", actorID) or SL:GetValue("ACTOR_HAVE_MASTER", actorID)) then
        return false
    end

    -- 3.归属不是自己的
    local ownerID = SL:GetValue("ACTOR_OWNER_ID", actorID)
    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_NO_ATTACK_HAVE_BELONG) == 1 and ownerID and ownerID ~= SL:GetValue("USER_ID") then 
        return false
    end

    -- 内挂忽略的怪
    local ignoreNames = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER)
    local name = SL:GetValue("ACTOR_NAME", actorID)
    if not ignoreNames or (type(ignoreNames) ~= "table") then 
        ignoreNames = {} 
    end
    if name and ignoreNames[name] then 
        return false
    end

    return true
end

-- 查找最近怪物
function GUIFunction:FindNearestMonster(monsterVec, monsterVecNum)
    -- 不自动选: 守卫/石化状态下祖玛卫士 
    local target     = nil
    local cost       = GUIDefine.MAX_COST
    local pMapX      = SL:GetValue("X")
    local pMapY      = SL:GetValue("Y")
    local mX         = 0
    local mY         = 0

    for i = 1, monsterVecNum do
        local monsterID = monsterVec[i]
        if SL:GetValue("ACTOR_IS_VALID", monsterID) then
            mX = SL:GetValue("ACTOR_MAP_X", monsterID)
            mY = SL:GetValue("ACTOR_MAP_Y", monsterID)
            if not (mX == pMapX and mY == pMapY) and GUIFunction.CheckAutoTargetEnableByID(monsterID) then
                local len = squLen(mX - pMapX, mY - pMapY)
                if len < cost then
                    target = monsterID
                    cost = len
                end
            end
        end
    end
    
    return target
end

function GUIFunction:GetMonsterVec(monsters, ncount)
    local monsterVec = {}
    local num = 0

    for i = 1, ncount do
        local monsterID = monsters[i]
        if GUIFunction.CheckAutoTargetEnableByID(monsterID) then
            num = num + 1
            monsterVec[num] = monsterID
        end
    end

    return monsterVec, num
end

-- 自动找怪, 设定目标
function GUIFunction:OnAutoFindMonsterFunc()
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return nil
    end

    local autoTarget = SL:GetValue("AUTO_TARGET")
    local targetIndex = autoTarget.targetIndex
    local targetType = autoTarget.targetType

    local monsterVec  = {}
    local monsterVecNum = 0
    
    if targetType ~= GUIDefine.ActorType.MONSTER or not targetIndex or GUIDefine.AUTO_FIND_TARGET_NONE == targetIndex or 0 == targetIndex then -- not target index,find nearst monster
        local monsters, ncount = SL:GetValue("FIND_IN_VIEW_MONSTER_LIST", true, true)
        monsterVec, monsterVecNum = GUIFunction:GetMonsterVec(monsters, ncount)
    else
        local monsters, ncount = SL:GetValue("FIND_IN_VIEW_MONSTER_LIST_BY_TYPEINDEX", targetIndex, true, true)
        monsterVec, monsterVecNum = GUIFunction:GetMonsterVec(monsters, ncount)
        
        if monsterVecNum < 1 then
            local monsters, ncount = SL:GetValue("FIND_IN_VIEW_MONSTER_LIST")
            monsterVec, monsterVecNum = GUIFunction:GetMonsterVec(monsters, ncount)
        end
    end

    if monsterVecNum < 1 then
        return false
    end
    
    -- find nearest monster
    local targetID = GUIFunction:FindNearestMonster(monsterVec, monsterVecNum)
    if SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_TARGET_ID", targetID)
    end
end

-- 自动找人形怪/怪, 设定目标
function GUIFunction:OnAutoFindHumanoidFunc()
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return nil
    end

    local targetID   = nil
    local cost       = GUIDefine.MAX_COST
    local pMapX      = SL:GetValue("X")
    local pMapY      = SL:GetValue("Y")
    local aX         = 0
    local aY         = 0

    local playerVec, playerVecNum = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, playerVecNum do
        local playerID = playerVec[i]
        if SL:GetValue("ACTOR_IS_VALID", playerID) and SL:GetValue("ACTOR_IS_HUMAN", playerID) then
            aX = SL:GetValue("ACTOR_MAP_X", playerID)
            aY = SL:GetValue("ACTOR_MAP_Y", playerID)
            if not (aX == pMapX and aY == pMapY) and GUIFunction.CheckAutoTargetEnableByID(playerID) then
                local len = squLen(aX - pMapX, aY - pMapY)
                if len < cost then
                    targetID = playerID
                    cost = len
                end
            end
        end
    end
    
    if targetID and SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_TARGET_ID", targetID)
    else
        -- 没找到, 找其他怪
        GUIFunction:OnAutoFindMonsterFunc()
    end
end

-- 受攻击后自动反击
function GUIFunction:OnAutoFightBackFunc(attackActorID, actorID)
    
    actorID = actorID or SL:GetValue("USER_ID")

    local setValues = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_BEDAMAGED_PLAYER)  -- 被玩家攻击 1不处理 2反击 3逃跑
    if not setValues or not setValues[1] or not (setValues[1] == 2 or setValues[1] == 3) then
        return
    end

    if not attackActorID or not SL:GetValue("ACTOR_IS_VALID", attackActorID) then  -- 没有攻击者
        return
    end

    local attackMasterID = SL:GetValue("ACTOR_MASTER_ID", attackActorID)
    if (SL:GetValue("ACTOR_IS_HUMAN", attackActorID) or SL:GetValue("ACTOR_IS_MONSTER", attackActorID)) and not (attackMasterID and attackMasterID ~= "") then
        return 
    end

    if not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return
    end

    local mainPlayerID = SL:GetValue("USER_ID")
    local heroActorID = SL:GetValue("HERO_ID")
    local masterID = SL:GetValue("ACTOR_MASTER_ID", actorID)

    -- 攻击 我的宠物/元神/主角
    if not (masterID == mainPlayerID or actorID == heroActorID or actorID == mainPlayerID) then
        return
    end

    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then 
        return
    end

    -- 挂机
    if not SL:GetValue("BATTLE_IS_AFK") and not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return
    end

    if setValues[1] == 2 then
        local attackBackID = nil -- 要反击的对象id
        if attackMasterID and attackMasterID ~= "" and SL:GetValue("ACTOR_IS_VALID", attackMasterID) then
            local value = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_FIRST_ATTACK_MASTER)  -- 优先打主人
            if value[1] == 1 and SL:GetValue("ACTOR_IS_PLAYER", attackMasterID) and not SL:GetValue("ACTOR_IS_HUMAN", attackMasterID) then 
                attackBackID = attackMasterID
            end
        end

        if not attackBackID then 
            attackBackID = attackActorID
        end

        local hateID = SL:GetValue("HATE_ID")
        if hateID and SL:GetValue("ACTOR_IS_VALID", hateID) then
            return 
        end

        -- 没仇恨对象
        SL:SetValue("SELECT_SHIFT_ATTACK_ID", nil)
        SL:SetValue("SELECT_TARGET_ID", nil)
        SL:SetValue("CLEAR_CUR_MOVE")
        SL:SetValue("SELECT_TARGET_ID", attackBackID)
        SL:SetValue("HATE_ID", attackBackID)
            
    -- 攻击者必须是玩家  不是我的宠物/元神/主角
    elseif setValues[1] == 3 and not SL:GetValue("ACTOR_IS_MAINPLAYER", attackActorID) and attackMasterID ~= mainPlayerID then
        SL:SetValue("SELECT_SHIFT_ATTACK_ID", nil)
        SL:SetValue("SELECT_TARGET_ID", nil)
        SL:SetValue("AFK_CHECK_AIMLESS_MOVE")
    end
end
-------------------------------------------------------------------------
-- 检查NPC气泡显示
local npcTalkNode = nil
function GUIFunction:CheckNpcTalkTips()
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return
    end

    local x = SL:GetValue("X")
    local y = SL:GetValue("Y")

    local targetNpcID = nil

    local npcVec, nCount = SL:GetValue("FIND_IN_VIEW_NPC_LIST")
    for i = 1, nCount do
        local npcID = npcVec[i]
        local npcMapX = SL:GetValue("ACTOR_MAP_X", npcID)
        local npcMapY = SL:GetValue("ACTOR_MAP_Y", npcID)
        if SL:GetValue("ACTOR_IS_VALID", npcID) and math.abs(x - npcMapX) <= 2 and math.abs(y - npcMapY) <= 2 then
            targetNpcID = npcID
            break
        end
    end

    if not targetNpcID then
        if npcTalkNode then
            GUI:removeAllChildren(npcTalkNode)
        end
        return
    end

    GUIFunction:OnShowNpcTalkTips(targetNpcID)

end

-- NPC气泡显示
function GUIFunction:OnShowNpcTalkTips(npcID)
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return
    end

    if not SL:GetValue("SERVER_OPTION", SW_KEY_NPC_BUTTON) then
        return
    end

    if npcTalkNode then
        GUI:removeAllChildren(npcTalkNode)
    else
        local winSize = SL:GetValue("SCREEN_SIZE")
        local moveY = SL:GetValue("IS_PC_OPER_MODE") and 0 or -88
        npcTalkNode = GUI:Widget_Create(GUI:Attach_Center(), "npcTalkNode", winSize.width / 2 + 18, winSize.height / 2 + moveY, 0, 0)
    end

    local imagePopBg = GUI:Image_Create(npcTalkNode, "touch", 0, 0, "res/public/bg_bubble_1.png")
    GUI:setTouchEnabled(imagePopBg, true)
    GUI:addOnClickEvent(imagePopBg, function()
        SL:RequestNPCTalk(npcID)
    end)

    local size = GUI:getContentSize(imagePopBg)
    local npcName = SL:GetValue("ACTOR_NAME", npcID)
    if npcName then
        local _, _, showName = string.find(npcName, ".-%#(.-)%#")
        if showName then
            npcName = showName
        end
    end
    local contentText = GUI:Text_Create(imagePopBg, "content", size.width / 2, size.height * 0.6, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16, "#FFFFFF", npcName)
    GUI:setAnchorPoint(contentText, 0.5, 0.5)
    GUI:Text_enableOutline(contentText, "#111111", 1)
end

-- NPC气泡隐藏
function GUIFunction:OnHideNpcTalkTips()
    if npcTalkNode then
        GUI:removeAllChildren(npcTalkNode)
    end
end

-- NPC气泡清理
function GUIFunction:OnClearNpcTalkTips()
    if npcTalkNode then
        npcTalkNode = nil
    end
end
-------------------------------------------------------------------------
-- 人物头顶说话 富文本
function GUIFunction:GenerateActorSayItem(data)

    local content = string.format("%s:%s", data.SendName, data.Msg)
    local elements = createNormalElements(content, "fonts/font2.ttf", 12, "#FFFFFF", "#000000", 1, true)

    local richText = GUI:RichTextCombine_Create(-1, "sayRichText", 0, 0, 200, 0)
    GUI:setAnchorPoint(richText, 0.5, 0)
    -- 填充
    GUI:RichTextCombine_pushBackElements(richText, elements)

    return richText
end

-------------------------------------------------------------------------
-- 技能相关
function GUIFunction:CheckSkillAbleToLaunch(skillID, isUserInput)
    --[[
     1: able
    -1: not learned
    -2: is cd
    -3: not enough mana
    -4: buff not allowed
    -5: not enough mount mana
    -6: map limit
    -8: stiffness
    -9: isOff
    -10: horse
    -11: 延迟释放
    -12: 内力值不够
    -13: 目标buff有禁止技能 launch
    -14: 目标buff有禁止技能 User Input
    ]]
    -- 挖矿使用普攻CD
    if skillID == SKILL_ID_DIG and not SL:GetValue("SKILL_IS_CDING", SKILL_ID_PuGong) then
        return 1
    end

    local skillData = SL:GetValue("SKILL_DATA", skillID) or SL:GetValue("COMBO_SKILL_DATA", skillID)
    if not skillData then
        return -1
    end

    local isCD, currCDTime = SL:GetValue("SKILL_IS_CDING", skillID)
    if isCD then
        if SL:GetValue("SKILL_NEED_CDHINT", skillID) then 
            currCDTime = currCDTime or 0
            local lastHintTime = skillData.lastHintTime or 0
            if lastHintTime - currCDTime >= 1 or (lastHintTime == 0 and skillData.DelayTime > 1000) then
                local data = {}
                data.ChannelId = GUIDefine.ChatChannel.SYSTEM
                data.BColor = 249
                data.FColor = 255
                data.Msg = string.format("系统：请在%d秒后使用该技能", math.ceil(currCDTime))
                SL:onLUAEvent(LUA_EVENT_CHAT_MSG_ADD, data)

                skillData.lastHintTime = currCDTime
            end
        end
        return -2
    end

    if not SL:GetValue("SKILL_IS_ENOUGH_MP", skillID) then
        return -3
    end

    if not SL:GetValue("SKILL_IS_ENOUGH_IV", skillID) then
        return -12
    end

    if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) and not SL:GetValue("SKILL_IS_ON_SKILL", skillID) then
        return -9
    end

    if not SL:GetValue("HORSE_CAN_LAUNCH_SKILL", skillID) then
        return -10
    end

    if not SL:GetValue("BUFF_CHECK_SKILL_ENABLE", skillID) then
        return -4
    end

    if SL:GetValue("MAP_FORBID_LAUNCH_SKILL", skillID) then
        return -6
    end

    if SL:GetValue("SKILL_IS_DELAY_LAUNCH", skillID) then
        return -11
    end

    local targetID = SL:GetValue("SELECT_SHIFT_ATTACK_ID") or SL:GetValue("SELECT_TARGET_ID")
    if targetID then
        if isUserInput then
            -- 手动释放时是否有不能释放该技能BUFF
            local buffID = SL:GetValue("TARGET_FORBID_SKILL_LAUNCH_BUFF", targetID, skillID)
            if buffID then
                return -13, buffID
            end
            -- 自动释放时是否有不能释放该技能BUFF
        elseif SL:GetValue("TARGET_FORBID_SKILL_AUTO_BUFF", targetID, skillID) then
            return -14
        end
    end
    
    if skillData then 
        skillData.lastHintTime = 0
    end
    return 1
end

-- 查找背包物品
local function findBagItem(stdMode, shape)
    local items = BagData.GetBagData()
    for _, item in pairs(items) do
        if item.StdMode == stdMode and item.Shape == shape then
            return item
        end
    end
    return nil
end

-- 检查毒符
function GUIFunction:CheckDuItem(type)
    local dressType = SL:GetValue("SERVER_OPTION", "UseAmuletType")-- 0 穿戴 1 背包 2 无

    local dressEquip = GUIFunction:GetEquipDataByPos(GUIDefine.EquipPosUI.Equip_Type_Bujuk)
    if dressType == 2 then 
        return true
    end
    if type == 1 then

        if dressEquip then 
            return dressEquip.Shape == 1 or findBagItem(25, 1)  
        else
            return findBagItem(25, 1)  
        end
    elseif type == 2 then 
        if dressEquip then 
            return dressEquip.Shape == 2 or findBagItem(25, 2)  
        else
            return findBagItem(25, 2)  
        end
    end
end

-- 是否护身符
local function isAmuletItem(item)
    if not item then
        return false
    end
    return item.StdMode == 25 and item.Shape == 5
end

-- 是否毒药粉
local function isPoisonItem(item)
    if not item then
        return false
    end
    return item.StdMode == 25 and (item.Shape == 1 or item.Shape == 2)
end

-- 使用护身符的技能
local useAmuletSkill = {
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
    [17] = true,
    [18] = true,
    [19] = true,
    [30] = true,
    [55] = true,
    [57] = true,
    [76] = true,
}

-- 使用毒药粉技能
local usePoisonSkill = {
    [6]     = true,
    [51]    = true,
}

-- 检查是否穿戴对应技能装备
function GUIFunction:CheckDressEquipSkillID(skillID)
    if not (useAmuletSkill[skillID] or usePoisonSkill[skillID]) then
        return true
    end

    local dressEquip = GUIFunction:GetEquipDataByPos(GUIDefine.EquipPosUI.Equip_Type_Bujuk)

    -- 没穿
    if not dressEquip then
        return false
    end

    -- 符
    if useAmuletSkill[skillID] and isAmuletItem(dressEquip) then
        return true
    end
    
    -- 毒
    if usePoisonSkill[skillID] and isPoisonItem(dressEquip) then
        return true
    end

    return false
end

-- 检查背包中是否有释放技能装备
function GUIFunction:CheckBagEquipSkillID(skillID)
    if not (useAmuletSkill[skillID] or usePoisonSkill[skillID]) then
        return true
    end

    -- 符
    if useAmuletSkill[skillID] and findBagItem(25, 5) then
        return true
    end
    
    -- 毒
    if usePoisonSkill[skillID] and (findBagItem(25, 1) or findBagItem(25, 2)) then
        return true
    end

    return false
end

-- 获取技能最小攻击距离
function GUIFunction:GetSkillMinLaunchDistance(skillID)
    local config = SL:GetValue("SKILL_CONFIG", skillID)
    if not config then
        return 1
    end

    -- 寻路阻塞
    if SL:GetValue("IS_MOVE_BLOCKED") then
        return config.minDis or 1
    end

    -- 刺杀剑术
    if skillID == SKILL_ID_CiSha then
        return SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_MOVE_GEWEI_CISHA) == 1 and 2 or 0
    end
    
    -- 自动走位
    if SL:GetValue("BATTLE_IS_AFK") and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_MOVE) == 1 then
        return config.autoMinDis or 1
    end

    return config.minDis or 1
end

-- 获取技能最大攻击距离
function GUIFunction:GetSkillMaxLaunchDistance(skillID)
    local config = SL:GetValue("SKILL_CONFIG", skillID)
    if not config then
        return 1
    end

    -- 刺杀剑术
    if skillID == SKILL_ID_CiSha then
        return (SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_DAODAOCISHA) ~= 1 and SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_GEWEICISHA) ~= 1) and 1 or 2
    end

    -- 自动战斗使用手机端范围
    if SL:GetValue("BATTLE_IS_AFK") then
        return config.maxDis
    end

    local maxDis = SL:GetValue("IS_PC_OPER_MODE") and config.maxDis_pc or config.maxDis
    return maxDis
end

-- 地图坐标计算方向
function GUIFunction:CalcMapDirection(dX, dY, sX, sY)
    local diffX = dX - sX
    local diffY = dY - sY
    local angle = math.deg(math.atan2(diffY, diffX))
    local ret = SLDefine.Direction.INVALID
    if (angle > -22.5 and angle <= 22.5) then
        ret = SLDefine.Direction.RIGHT
    
    elseif (angle > 22.5 and angle <= 67.5) then
        ret = SLDefine.Direction.RIGHT_BOTTOM
    
    elseif (angle > 67.5 and angle <= 112.5) then
        ret = SLDefine.Direction.BOTTOM
    
    elseif (angle > 112.5 and angle <= 157.5) then
        ret = SLDefine.Direction.LEFT_BOTTOM
    
    elseif ((angle > 157.5 and angle <= 180) or (angle <= -157.5 and angle > -180)) then
        ret = SLDefine.Direction.LEFT
    
    elseif (angle <= -112.5 and angle > -157.5) then
        ret = SLDefine.Direction.LEFT_UP
    
    elseif (angle <= -67.5 and angle > -112.5) then
        ret = SLDefine.Direction.UP
    
    elseif (angle <= -22.5 and angle > -67.5) then
        ret = SLDefine.Direction.RIGHT_UP
    end
    return ret
end

-- 计算地图距离
function GUIFunction:CalcMapDistance(sX, sY, dX, dY)
    return math.max(math.abs(sX - dX), math.abs(sY - dY))
end

---------------------------------------检测技能释放--------------------------------------------
local SharedInputLaunchData = {}
local SharedInputMoveData = {}
local SharedInputMiningData = {}
-- 自动检测技能行为
function GUIFunction:AutoFindSkillBehavior()
    if GUIFunction:CheckLaunchFirstSkill() then
        return true
    end

    if GUIFunction:CheckLaunchComboSkill() then
        return true
    end

    if GUIFunction:CheckLaunchAutoSkill() then
        return true
    end

    if GUIFunction:CheckLaunchSimpleSkill() then
        return true
    end

    if GUIFunction:CheckLaunchLockSkill() then
        return true
    end

    if GUIFunction:CheckAutoMining() then
        return true
    end

    return false
end

function GUIFunction:CheckLaunchFirstSkill()
    if not SL:GetValue("SELECT_TARGET_ID") then
        return false
    end

    if SL:GetValue("INPUT_LAUNCH_SKILLID") then
        return false
    end

    if not SL:GetValue("ATTACK_STATE") and not SL:GetValue("BATTLE_IS_AUTO_LOCK_STATE") and not SL:GetValue("BATTLE_IS_AFK") and
        not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return false
    end

    local skillID, destPosX, destPosY = SkillUtils.FindFirstLaunchSkill()
    if not skillID then
        return false
    end

    local lastMouseInsideActorID     = SL:GetValue("MOUSE_INSIDE_ACTORID")
    SharedInputLaunchData.launchType = SL:GetValue("INPUT_LAUNCH_TYPE")
    SharedInputLaunchData.priority   = SL:GetValue("INPUT_LAUNCH_PRIORITY")
    SharedInputLaunchData.targetID   = lastMouseInsideActorID or SL:GetValue("SELECT_TARGET_ID")
    SharedInputLaunchData.skillID    = skillID
    SharedInputLaunchData.destPosX   = destPosX
    SharedInputLaunchData.destPosY   = destPosY
    SL:InputLaunch(SharedInputLaunchData)
    return true
end

function GUIFunction:CheckLaunchComboSkill()
    if not SL:GetValue("SELECT_TARGET_ID") then
        return false
    end

    if SL:GetValue("INPUT_LAUNCH_SKILLID") then
        return false
    end

    local isAttackState = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("ATTACK_STATE") or false
    if not isAttackState and not SL:GetValue("BATTLE_IS_AUTO_LOCK_STATE") and not SL:GetValue("BATTLE_IS_AFK") and not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return false
    end

    local skillID, destPosX, destPosY, isAuto = SkillUtils.FindComboLaunchSkill()
    if not skillID then
        return false
    end

    SharedInputLaunchData.launchType = isAuto and GUIDefine.LaunchType.AUTO or GUIDefine.LaunchType.USER
    SharedInputLaunchData.priority = GUIDefine.LaunchPriority.SYSTEM
    SharedInputLaunchData.targetID = SL:GetValue("SELECT_TARGET_ID")
    SharedInputLaunchData.skillID = skillID
    SharedInputLaunchData.destPosX = destPosX
    SharedInputLaunchData.destPosY = destPosY
    SL:InputLaunch(SharedInputLaunchData)
    return true
end

function GUIFunction:CheckLaunchAutoSkill()
    -- 挂机/自动战斗
    if not SL:GetValue("BATTLE_IS_AFK") and not SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return false
    end

    if SL:GetValue("INPUT_LAUNCH_SKILLID") then
        return false
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID then
        return false
    end

    if not GUIFunction:CheckLaunchEnableByID(targetID) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        return false
    end

    -- 挂机目标死亡，原地等待一段时间
    if SL:GetValue("AFK_TARGET_DEATH") then
        return true
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        return false
    end

    -- 闪避技能
    local skillID, destPosX, destPosY = SkillUtils.FindAvoidDangerSkill()
    if skillID then
        SL:SetValue("AUTO_LAUNCH_AVOID_STAMP")
    else
        -- 自动释放技能
        skillID, destPosX, destPosY = SkillUtils.FindAutoLaunchSkill()
    end

    if skillID then
        SharedInputLaunchData.launchType = GUIDefine.LaunchType.AUTO
        SharedInputLaunchData.priority = GUIDefine.LaunchPriority.SYSTEM
        SharedInputLaunchData.targetID = targetID
        SharedInputLaunchData.skillID = skillID
        SharedInputLaunchData.destPosX = destPosX
        SharedInputLaunchData.destPosY = destPosY
        SL:InputLaunch(SharedInputLaunchData)
        return true
    end

    -- 闪避走位
    destPosX, destPosY = SkillUtils.FindAvoidDangerPos()
    if destPosX and destPosY then
        SharedInputMoveData.mapID = SL:GetValue("MAP_ID")
        SharedInputMoveData.x = destPosX
        SharedInputMoveData.y = destPosY
        SharedInputMoveData.type = GUIDefine.InputMoveType.AUTOMOVE
        SL:InputMove(SharedInputMoveData)
        return true
    end
    return false
end

function GUIFunction:CheckLaunchSimpleSkill()
    if SL:GetValue("INPUT_LAUNCH_SKILLID") then
        return false
    end

    local targetID = SL:GetValue("SELECT_TARGET_ID")
    if not targetID then
        return false
    end

    -- 锁定目标状态
    if not SL:GetValue("BATTLE_IS_AUTO_LOCK_STATE") then
        return false
    end

    if not GUIFunction:CheckLaunchEnableByID(targetID) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        return false
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_TARGET_ID", nil)
        return false
    end

    if SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_ALWAYS_ATTACK) ~= 1 then
        return false
    end

    local skillID, destPosX, destPosY = SkillUtils.FindSimpleLaunchSkill()
    if skillID then
        SharedInputLaunchData.launchType = GUIDefine.LaunchType.LOCK
        SharedInputLaunchData.priority = GUIDefine.LaunchPriority.SYSTEM
        SharedInputLaunchData.targetID = targetID
        SharedInputLaunchData.skillID = skillID
        SharedInputLaunchData.destPosX = destPosX
        SharedInputLaunchData.destPosY = destPosY
        SL:InputLaunch(SharedInputLaunchData)
        return true
    end

    return false
end

function GUIFunction:CheckLaunchLockSkill()
    -- shift锁定
    if not SL:GetValue("IS_PC_OPER_MODE") then
        return false
    end

    -- 不在锁定攻击状态
    if not SL:GetValue("ATTACK_STATE") then
        return false
    end

    local targetID = SL:GetValue("SELECT_SHIFT_ATTACK_ID")
    if not targetID then
        return false
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        SL:SetValue("SELECT_SHIFT_ATTACK_ID", nil)
        return false
    end

    -- 免shift
    local optionAble = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_NOT_NEED_SHIFT) == 1
    local shiftAble = SL:GetValue("IS_PRESSED_SHIFT")

    if (SL:GetValue("ACTOR_IS_PLAYER", targetID) and (optionAble or shiftAble)) or SL:GetValue("ACTOR_IS_MONSTER", targetID) then
        -- 骑马检测
        if not SL:GetValue("HORSE_CAN_LAUNCH_SKILL", SKILL_ID_PuGong) then
            if not SL:RequestHorseDown() then
                SL:SetValue("ATTACK_STATE", false)
            end
            return false
        end

        local skillID, destPosX, destPosY = SkillUtils.FindLockLaunchSkill()
        if skillID then
            SharedInputLaunchData.launchType = GUIDefine.LaunchType.LOCK
            SharedInputLaunchData.priority = GUIDefine.LaunchPriority.SYSTEM
            SharedInputLaunchData.targetID = targetID
            SharedInputLaunchData.skillID = skillID
            SharedInputLaunchData.destPosX = destPosX
            SharedInputLaunchData.destPosY = destPosY
            SL:InputLaunch(SharedInputLaunchData)
        end
        return true
    end
    return false
end

-- 检查能否挖矿
function GUIFunction:CheckMiningAble()
    local equip = GUIFunction:GetEquipDataByPos(GUIDefine.EquipPosUI.Equip_Type_Weapon)
	if equip and equip.Shape == 19 and equip.Dura and equip.Dura > 0 then
		return true
	end
	return false
end

-- 自动挖矿
function GUIFunction:CheckAutoMining()
    if SL:GetValue("BATTLE_IS_AUTO_FIGHT_STATE") then
        return false
    end

    local autoMiningDir, autoMiningDstX, autoMiningDstY = SL:GetValue("AUTO_MINING_DATA")
    if not autoMiningDir or not autoMiningDstX or not autoMiningDstY then
        return false
    end

    if not GUIFunction:CheckMiningAble() then
        SL:SetValue("AUTO_MINING_DATA", nil, nil, nil)
        return false
    end

    SharedInputMiningData.dir  = autoMiningDir
    SharedInputMiningData.destX = autoMiningDstX
    SharedInputMiningData.destY = autoMiningDstY
    SL:InputMining(SharedInputMiningData)

    return true
end

-------------------------------------------------------------------------
-- 新建条件红点控件
local conditionRedID = 0
function GUIFunction:InitConditionRedWidget(parent, conditionStr, isTxt)
    if not parent then
        return
    end
    if not conditionStr or string.len(tostring(conditionStr)) <= 0 then
        return
    end
    local conditionList = SL:Split(conditionStr, "#")
    local conditionID = tonumber(conditionList[1])
    if not conditionID then
        return
    end
    local x = tonumber(conditionList[2]) or 0
    local y = tonumber(conditionList[3]) or 0
    local type = tonumber(conditionList[4]) or 0
    local param = conditionList[5]
    if isTxt then
        local parentSize = GUI:getContentSize(parent)
        y = parentSize.height - y
    end

    conditionRedID = conditionRedID + 1
    local name = type == 0 and string.format("red_img_%s", conditionRedID) or string.format("red_sfx_%s", conditionRedID)
    local widget = GUI:RedDot_Create(parent, name, x, y, type, param)
    if widget then
        GUI:RedDot_setGID(widget, conditionRedID)
        GUI:RedDot_setBindConditionID(widget, conditionID)
    end
end
-------------------------------------------
