PlayerExtraAtt_Look_TradingBank = {}

-- 属性
local AttType = GUIFunction:PShowAttType()

local extraAttrs = {
    AttType.Weight,
    AttType.Wear_Weight,
    AttType.Hand_Weight,
}

function PlayerExtraAtt_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "player_look_tradingbank/player_extra_attri_node")

    PlayerExtraAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerExtraAtt_Look_TradingBank._ui then
        return false
    end

    PlayerExtraAtt_Look_TradingBank._listView = PlayerExtraAtt_Look_TradingBank._ui["ListView_extraAtt"]
    --添加的属性条编号
    PlayerExtraAtt_Look_TradingBank._index = 0 

    PlayerExtraAtt_Look_TradingBank.UpdateBaseAttri()
end

function PlayerExtraAtt_Look_TradingBank.UpdateBaseAttri()
    --获取属性配置(cfg_att_score表)
    local configs = SL:GetValue("ATTR_CONFIGS")

    local showList = {}
    local showListBehind = {}
    for id, attConfig in pairs(configs) do
        -- 检测属性的最大id 1000
        if id > 1000 then
            return
        end

        local attValue = TradingBankLookPlayerData.GetCurAbilByID(attConfig.Idx) or 0
        local jobShow = false
        if attConfig.isshow == 3 then
            local job = TradingBankLookPlayerData.GetPlayerJob()
            if id == AttType["Min_CustJobAttr_" .. job] or id == AttType["Max_CustJobAttr_" .. job] then
                jobShow = true
            end
        end

        if (attConfig.isshow == 2 and attValue ~= 0) or attConfig.isshow == 1 or jobShow then
            local attData = {
                id = attConfig.Idx, value = attValue
            }
            if attConfig.Idx <= SL:GetValue("SPD") then
                table.insert(showList, attData)
            else
                table.insert(showListBehind, attData)
            end
        end
    end

    for _, id in ipairs(extraAttrs) do
        local attData = {
            id = id, value = string.format("%s/%s",TradingBankLookPlayerData.GetCurAbilByID(id) or 0, TradingBankLookPlayerData.GetMaxAbilByID(id) or 0)
        }
        table.insert(showList, attData)
    end
    local firstList = GUIFunction:GetAttDataShow(showList, nil)

    local maxHp = TradingBankLookPlayerData.GetMaxAbilByID(GUIDefine.AttTypeTable.HP) 
    local maxMp = TradingBankLookPlayerData.GetMaxAbilByID(GUIDefine.AttTypeTable.MP) 
    if firstList[AttType.HP] then
        firstList[AttType.HP].value = string.format("%s/%s", firstList[AttType.HP].value, SL:HPUnit(maxHp))
    end

    if firstList[AttType.MP] then
        firstList[AttType.MP].value = string.format("%s/%s", firstList[AttType.MP].value, SL:HPUnit(maxMp))
    end

    local showAttList = {}
    for k, v in pairs(firstList) do
        showAttList[k] = v
    end

    local behindList = GUIFunction:GetAttDataShow(showListBehind, nil)

    for k, v in pairs(behindList) do
        showAttList[k] = v
    end
    local allList = {}
    for k, v in pairs(showAttList) do
        table.insert(allList, v)
    end

    table.sort(allList, function(a, b)
        if a.id <= AttType.Speed_Point and b.id <= AttType.Speed_Point then
            return a.id < b.id
        elseif a.id > 10000 and b.id > 10000 then
            return a.id < b.id
        elseif a.id > 10000 and b.id <= AttType.Speed_Point then
            return false
        elseif a.id <= AttType.Speed_Point and b.id > 10000 then
            return true
        elseif a.id > 10000 then
            return true
        elseif b.id > 10000 then
            return false
        else
            return a.id < b.id
        end
    end)

    for k, v in ipairs(allList) do
        local listData = {
            id = v.id, name = v.name, value = v.value
        }
        local cell = PlayerExtraAtt_Look_TradingBank.CreateAttriCell(v.id)
        PlayerExtraAtt_Look_TradingBank.LoadAttriCell(cell, listData)
    end
end

function PlayerExtraAtt_Look_TradingBank.LoadAttriCell(cell, data)
    local ui = GUI:ui_delegate(cell)
    GUI:Text_setString(ui["Text_attName"], data.name)
    GUI:Text_setString(ui["Text_attValue"], data.value or "")
end

function PlayerExtraAtt_Look_TradingBank.CreateAttriCell(tag)
    PlayerExtraAtt_Look_TradingBank._index = PlayerExtraAtt_Look_TradingBank._index + 1
    local cell = GUI:Widget_Create(PlayerExtraAtt_Look_TradingBank._listView, "Attribute_" .. PlayerExtraAtt_Look_TradingBank._index, 0, 0, 348, 27)
    GUI:LoadExport(cell, "player_look_tradingbank/att_show_list")
    GUI:setTag(cell, tag or -1)
    return cell
end

function PlayerExtraAtt_Look_TradingBank.OnClose()
end

PlayerExtraAtt_Look_TradingBank.main()