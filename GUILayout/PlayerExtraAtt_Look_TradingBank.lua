PlayerExtraAtt_Look_TradingBank = {}----交易行 人物 属性

PlayerExtraAtt_Look_TradingBank._ui = nil
PlayerExtraAtt_Look_TradingBank._Attribute = GUIFunction:PShowAttType()--属性
PlayerExtraAtt_Look_TradingBank._extraAttributeStr = {
    PlayerExtraAtt_Look_TradingBank._Attribute.Max_Weight,
    PlayerExtraAtt_Look_TradingBank._Attribute.Wear_Weight,
    PlayerExtraAtt_Look_TradingBank._Attribute.Max_Wear_Weight,
    PlayerExtraAtt_Look_TradingBank._Attribute.Hand_Weight,
    PlayerExtraAtt_Look_TradingBank._Attribute.Max_Hand_Weight,
}
function PlayerExtraAtt_Look_TradingBank.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look_tradingbank/player_extra_attri_node")

    PlayerExtraAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    PlayerExtraAtt_Look_TradingBank._parent = parent
    if not PlayerExtraAtt_Look_TradingBank._ui then
        return false
    end
    PlayerExtraAtt_Look_TradingBank._index = 0 --添加的属性条编号
    PlayerExtraAtt_Look_TradingBank._updateCount = 0--请求更新次数
    PlayerExtraAtt_Look_TradingBank.UpdateBaseAttri()
end

function PlayerExtraAtt_Look_TradingBank.UpdateBaseAttri()
    ----------0.5秒刷新一次避免太频繁
    PlayerExtraAtt_Look_TradingBank._updateCount = PlayerExtraAtt_Look_TradingBank._updateCount + 1
    if PlayerExtraAtt_Look_TradingBank._updateCount > 1 then
        return
    end
    SL:scheduleOnce(PlayerExtraAtt_Look_TradingBank._parent, function()
        if PlayerExtraAtt_Look_TradingBank._updateCount > 0 then
            PlayerExtraAtt_Look_TradingBank._updateCount = 0
            PlayerExtraAtt_Look_TradingBank:UpdateBaseAttri()
        else
            PlayerExtraAtt_Look_TradingBank._updateCount = 0
        end
    end, 0.5)
    ---------------
    local list = PlayerExtraAtt_Look_TradingBank._ui.ListView_extraAtt
    local configs = SL:GetMetaValue("ATTR_CONFIGS")--获取属性配置(cfg_att_score表)


    local showList = {}
    local showListBehind = {}
    for id, attConfig in pairs(configs) do
        if id > 1000 then-- 检测属性的最大id 1000
            return
        end
        local attValue = SL:GetMetaValue("T.M.ATT_BY_TYPE", attConfig.Idx) or 0
        local jobShow = false
        if attConfig.isshow == 3 then
            local job = SL:GetMetaValue("JOB")
            if id == PlayerExtraAtt_Look_TradingBank._Attribute["Min_CustJobAttr_" .. job] or id == PlayerExtraAtt_Look_TradingBank._Attribute["Max_CustJobAttr_" .. job] then
                jobShow = true
            end
        end
        if (attConfig.isshow == 2 and attValue ~= 0) or attConfig.isshow == 1 or jobShow then
            local attData = {
                id = attConfig.Idx,
                value = attValue
            }
            if attConfig.Idx <= SL:GetMetaValue("SPD") then
                table.insert(showList, attData)
            else
                table.insert(showListBehind, attData)
            end
        end
    end
    for i, id in ipairs(PlayerExtraAtt_Look_TradingBank._extraAttributeStr) do
        local attData = {
            id = id,
            value = SL:GetMetaValue("T.M.ATT_BY_TYPE", id) or 0
        }
        table.insert(showList, attData)
    end
    local firstList = GUIFunction:GetAttDataShow(showList, nil)

    local maxHp = SL:GetMetaValue("T.M.MAXHP")
    local maxMp = SL:GetMetaValue("T.M.MAXMP")
    if firstList[PlayerExtraAtt_Look_TradingBank._Attribute.HP] then
        firstList[PlayerExtraAtt_Look_TradingBank._Attribute.HP].value = string.format("%s/%s", firstList[PlayerExtraAtt_Look_TradingBank._Attribute.HP].value, SL:HPUnit(maxHp))
    end
    if firstList[PlayerExtraAtt_Look_TradingBank._Attribute.MP] then
        firstList[PlayerExtraAtt_Look_TradingBank._Attribute.MP].value = string.format("%s/%s", firstList[PlayerExtraAtt_Look_TradingBank._Attribute.MP].value, SL:HPUnit(maxMp))
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
        if a.id <= PlayerExtraAtt_Look_TradingBank._Attribute.Speed_Point and b.id <= PlayerExtraAtt_Look_TradingBank._Attribute.Speed_Point then
            return a.id < b.id
        elseif a.id > 10000 and b.id > 10000 then
            return a.id < b.id
        elseif a.id > 10000 and b.id <= PlayerExtraAtt_Look_TradingBank._Attribute.Speed_Point then
            return false
        elseif a.id <= PlayerExtraAtt_Look_TradingBank._Attribute.Speed_Point and b.id > 10000 then
            return true
        elseif a.id > 10000 then
            return true
        elseif b.id > 10000 then
            return false
        else
            return a.id < b.id
        end
    end)

    local chs = GUI:getChildren(list)
    local existAttr = {}--已存在的属性
    for i, ch in ipairs(chs) do
        local tag = GUI:getTag(ch) or -1
        existAttr[tag] = 1
    end

    for k, v in ipairs(allList) do
        local listData = {
            id = v.id,
            name = v.name,
            value = v.value
        }
        if existAttr[v.id] then  
            local cell = GUI:getChildByTag(list, v.id)
            PlayerExtraAtt_Look_TradingBank.CreateAttri(nil, listData, cell)
            existAttr[v.id] = nil
        else 
            PlayerExtraAtt_Look_TradingBank.CreateAttri(list, listData)
        end
    end
    --删除没有的属性
    for id, _ in pairs(existAttr) do
        if id ~= -1 then 
            local cell = GUI:getChildByTag(list, id)
            if cell then 
                GUI:ListView_removeChild(list,cell)
            end
        end
    end

end

function PlayerExtraAtt_Look_TradingBank.CreateAttri(parent, data, cell)
    local isCreate = false
    if not cell then
        isCreate = true
        PlayerExtraAtt_Look_TradingBank._index = PlayerExtraAtt_Look_TradingBank._index + 1
        cell = GUI:Widget_Create(parent, "Attribute_" .. PlayerExtraAtt_Look_TradingBank._index, 0, 0, 348, 27)
        GUI:LoadExport(cell, "player_look_tradingbank/att_show_list")
        GUI:setTag(cell,data.id or -1)
    end
    local ui = GUI:ui_delegate(cell)
    GUI:Text_setString(ui.Text_attName, data.name)
    GUI:Text_setString(ui.Text_attValue, data.value or "")

end

--[[    attrs={
        { id, name, value}
    }
]]
-- 刷新固定的属性
function PlayerExtraAtt_Look_TradingBank.RefreshFixedAttr(attrs)
    local list = PlayerExtraAtt_Look_TradingBank._ui.ListView_extraAtt
    local attrList = GUIFunction:GetAttDataShow(attrs or {})
    for k, v in ipairs(attrList) do
        if v.id then
            local config = SL:GetMetaValue("ATTR_CONFIG", v.id)
            if (config.isshow == 2 and v.value ~= 0) or config.isshow == 1 then
                local fixAttr = attrs[v.id]
                if fixAttr and fixAttr.sformat and fixAttr.max then
                    v.value = string.format(fixAttr.sformat, v.value, fixAttr.max)
                end
                local cell = GUI:getChildByTag(list, v.id)
                if not cell then
                    cell = PlayerExtraAtt_Look_TradingBank.CreateAttri(list, v)
                else
                    PlayerExtraAtt_Look_TradingBank.CreateAttri(nil, v, cell)
                end
            end
        end
    end
end

-- 刷新HP MP属性
function PlayerExtraAtt_Look_TradingBank.OnRefreshHPMP()
    local HPMPAttr = {
        { id = PlayerExtraAtt_Look_TradingBank._Attribute.HP, value = SL:GetMetaValue("T.M.HP") or 0, max = SL:HPUnit(SL:GetMetaValue("T.M.MAXHP")), sformat = "%s/%s" },
        { id = PlayerExtraAtt_Look_TradingBank._Attribute.MP, value = SL:GetMetaValue("T.M.MP") or 0, max = SL:HPUnit(SL:GetMetaValue("T.M.MAXMP")), sformat = "%s/%s" },
    }
    PlayerExtraAtt_Look_TradingBank.RefreshFixedAttr(HPMPAttr)
end

function PlayerExtraAtt_Look_TradingBank.CloseCallback()
    PlayerExtraAtt_Look_TradingBank._updateCount = 0
end