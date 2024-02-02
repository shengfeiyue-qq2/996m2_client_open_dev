HeroExtraAtt_Look_TradingBank = {}----交易行 英雄 属性

HeroExtraAtt_Look_TradingBank._ui = nil
HeroExtraAtt_Look_TradingBank._Attribute = GUIFunction:PShowAttType()--属性
HeroExtraAtt_Look_TradingBank._extraAttributeStr = {
    HeroExtraAtt_Look_TradingBank._Attribute.Max_Weight,
    HeroExtraAtt_Look_TradingBank._Attribute.Wear_Weight,
    HeroExtraAtt_Look_TradingBank._Attribute.Max_Wear_Weight,
    HeroExtraAtt_Look_TradingBank._Attribute.Hand_Weight,
    HeroExtraAtt_Look_TradingBank._Attribute.Max_Hand_Weight,
}
function HeroExtraAtt_Look_TradingBank.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_extra_attri_node")

    HeroExtraAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    HeroExtraAtt_Look_TradingBank._parent = parent
    if not HeroExtraAtt_Look_TradingBank._ui then
        return false
    end
    HeroExtraAtt_Look_TradingBank._index = 0 --添加的属性条编号
    HeroExtraAtt_Look_TradingBank._updateCount = 0--请求更新次数
    HeroExtraAtt_Look_TradingBank.UpdateBaseAttri()
end

function HeroExtraAtt_Look_TradingBank.UpdateBaseAttri()
    ----------0.5秒刷新一次避免太频繁
    HeroExtraAtt_Look_TradingBank._updateCount = HeroExtraAtt_Look_TradingBank._updateCount + 1
    if HeroExtraAtt_Look_TradingBank._updateCount > 1 then
        return
    end
    SL:scheduleOnce(HeroExtraAtt_Look_TradingBank._parent, function()
        if HeroExtraAtt_Look_TradingBank._updateCount > 0 then
            HeroExtraAtt_Look_TradingBank._updateCount = 0
            HeroExtraAtt_Look_TradingBank:UpdateBaseAttri()
        else
            HeroExtraAtt_Look_TradingBank._updateCount = 0
        end
    end, 0.5)
    ---------------
    local list = HeroExtraAtt_Look_TradingBank._ui.ListView_extraAtt
    -- GUI:removeAllChildren(list)
    local configs = SL:GetMetaValue("ATTR_CONFIGS")--获取属性配置(cfg_att_score表)


    local showList = {}
    local showListBehind = {}
    for id, attConfig in pairs(configs) do
        if id > 1000 then-- 检测属性的最大id 1000
            return
        end
        local attValue = SL:GetMetaValue("T.H.ATT_BY_TYPE", attConfig.Idx) or 0
        if (attConfig.isshow == 2 and attValue ~= 0) or attConfig.isshow == 1 then
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
    for i, id in ipairs(HeroExtraAtt_Look_TradingBank._extraAttributeStr) do
        local attData = {
            id = id,
            value = SL:GetMetaValue("T.H.ATT_BY_TYPE", id) or 0
        }
        table.insert(showList, attData)
    end
    local firstList = GUIFunction:GetAttDataShow(showList, nil)

    local maxHp = SL:GetMetaValue("T.H.MAXHP")
    local maxMp = SL:GetMetaValue("T.H.MAXMP")
    if firstList[HeroExtraAtt_Look_TradingBank._Attribute.HP] then
        firstList[HeroExtraAtt_Look_TradingBank._Attribute.HP].value = string.format("%s/%s", firstList[HeroExtraAtt_Look_TradingBank._Attribute.HP].value, SL:HPUnit(maxHp))
    end
    if firstList[HeroExtraAtt_Look_TradingBank._Attribute.MP] then
        firstList[HeroExtraAtt_Look_TradingBank._Attribute.MP].value = string.format("%s/%s", firstList[HeroExtraAtt_Look_TradingBank._Attribute.MP].value, SL:HPUnit(maxMp))
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
        if a.id <= HeroExtraAtt_Look_TradingBank._Attribute.Speed_Point and b.id <= HeroExtraAtt_Look_TradingBank._Attribute.Speed_Point then
            return a.id < b.id
        elseif a.id > 10000 and b.id > 10000 then
            return a.id < b.id
        elseif a.id > 10000 and b.id <= HeroExtraAtt_Look_TradingBank._Attribute.Speed_Point then
            return false
        elseif a.id <= HeroExtraAtt_Look_TradingBank._Attribute.Speed_Point and b.id > 10000 then
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
            HeroExtraAtt_Look_TradingBank.CreateAttri(nil, listData, cell)
            existAttr[v.id] = nil
        else 
            HeroExtraAtt_Look_TradingBank.CreateAttri(list, listData)
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

function HeroExtraAtt_Look_TradingBank.CreateAttri(parent, data, cell)
    local isCreate = false
    if not cell then
        isCreate = true
        HeroExtraAtt_Look_TradingBank._index = HeroExtraAtt_Look_TradingBank._index + 1
        cell = GUI:Widget_Create(parent, "Attribute_" .. HeroExtraAtt_Look_TradingBank._index, 0, 0, 348, 27)
        GUI:LoadExport(cell, "hero_look_tradingbank/att_show_list")
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
function HeroExtraAtt_Look_TradingBank.RefreshFixedAttr(attrs)
    local list = HeroExtraAtt_Look_TradingBank._ui.ListView_extraAtt
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
                    cell = HeroExtraAtt_Look_TradingBank.CreateAttri(list, v)
                else
                    HeroExtraAtt_Look_TradingBank.CreateAttri(nil, v, cell)
                end
            end
        end
    end
end

-- 刷新HP MP属性
function HeroExtraAtt_Look_TradingBank.OnRefreshHPMP()
    local HPMPAttr = {
        { id = HeroExtraAtt_Look_TradingBank._Attribute.HP, value = SL:GetMetaValue("T.H.HP") or 0, max = SL:HPUnit(SL:GetMetaValue("T.H.MAXHP")), sformat = "%s/%s" },
        { id = HeroExtraAtt_Look_TradingBank._Attribute.MP, value = SL:GetMetaValue("T.H.MP") or 0, max = SL:HPUnit(SL:GetMetaValue("T.H.MAXMP")), sformat = "%s/%s" },
    }
    HeroExtraAtt_Look_TradingBank.RefreshFixedAttr(HPMPAttr)
end

function HeroExtraAtt_Look_TradingBank.CloseCallback()
    HeroExtraAtt_Look_TradingBank._updateCount = 0
end