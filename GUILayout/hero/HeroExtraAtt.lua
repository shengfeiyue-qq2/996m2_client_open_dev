HeroExtraAtt = {}

-- 属性
local AttType = GUIFunction:PShowAttType()

local extraAttrs = {
    AttType.Weight,
    AttType.Wear_Weight,
    AttType.Hand_Weight
}

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function HeroExtraAtt.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_extra_attri_node_win32" or "hero/hero_extra_attri_node")

    HeroExtraAtt._ui = GUI:ui_delegate(parent)
    if not HeroExtraAtt._ui then
        return false
    end

    HeroExtraAtt._listView = HeroExtraAtt._ui["ListView_extraAtt"]

    -- 请求更新次数
    HeroExtraAtt._updateCount = 0

    HeroExtraAtt.UpdateBaseAttri()

    GUI:RefPosByParent(parent)

    HeroExtraAtt.RegistEvent()

    -- 自定义组件
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerAttr_hero})
end

-- 界面关闭回调
function HeroExtraAtt.OnClose()
    HeroExtraAtt._updateCount = 0

    HeroExtraAtt.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerAttr_hero
    })
end

function HeroExtraAtt.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroExtraAtt", HeroExtraAtt.UpdateBaseAttri)
    SL:RegisterLUAEvent(LUA_EVENT_WEIGHT_CHANGE, "HeroExtraAtt", HeroExtraAtt.UpdateBaseAttri)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_HPMP_CHANGE, "HeroExtraAtt", HeroExtraAtt.OnRefreshHPMP)
end

-- 取消事件
function HeroExtraAtt.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroExtraAtt")
    SL:UnRegisterLUAEvent(LUA_EVENT_WEIGHT_CHANGE, "HeroExtraAtt")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_HPMP_CHANGE, "HeroExtraAtt")
end

function HeroExtraAtt.UpdateBaseAttri()
    -- 0.5秒刷新一次避免太频繁
    HeroExtraAtt._updateCount = HeroExtraAtt._updateCount + 1
    if HeroExtraAtt._updateCount > 1 then
        return
    end

    SL:scheduleOnce(HeroExtraAtt._ui["Panel_1"], function()
        if HeroExtraAtt._updateCount > 0 then
            HeroExtraAtt._updateCount = 0
            HeroExtraAtt:UpdateBaseAttri()
        else
            HeroExtraAtt._updateCount = 0
        end
    end, 0.5)


    --获取属性配置(cfg_att_score表)
    local configs = SL:GetValue("ATTR_CONFIGS")

    local showList = {}
    local showListBehind = {}
    for id, attConfig in pairs(configs) do
        -- 检测属性的最大id 1000
        if id > 1000 then
            return
        end

        local attValue = SL:GetValue("H.CUR_ABIL_BY_ID", attConfig.Idx) or 0
        local jobShow = false
        if attConfig.isshow == 3 then
            local job = SL:GetValue("H.JOB")
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
            id = id, value = string.format("%s/%s", SL:GetValue("H.CUR_ABIL_BY_ID", id) or 0, SL:GetValue("H.MAX_ABIL_BY_ID", id) or 0)
        }
        table.insert(showList, attData)
    end
    local firstList = GUIFunction:GetAttDataShow(showList, nil)

    local maxHp = SL:GetValue("H.MAXHP")
    local maxMp = SL:GetValue("H.MAXMP")
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

    local chs = GUI:getChildren(HeroExtraAtt._listView)

    -- 已存在的属性
    local existAttr = {}
    for i, ch in ipairs(chs) do
        local tag = GUI:getTag(ch) or -1
        existAttr[tag] = 1
    end

    for k, v in ipairs(allList) do
        local listData = {
            id = v.id, name = v.name, value = v.value
        }

        local cell = GUI:getChildByTag(HeroExtraAtt._listView, v.id) or HeroExtraAtt.CreateAttriCell(v.id)
        HeroExtraAtt.LoadAttriCell(cell, listData)
        existAttr[v.id] = nil
    end

    -- 删除没有的属性
    for id, _ in pairs(existAttr) do
        if id ~= -1 then 
            local cell = GUI:getChildByTag(HeroExtraAtt._listView, id)
            if cell then 
                GUI:ListView_removeChild(HeroExtraAtt._listView,cell)
            end
        end
    end
end

function HeroExtraAtt.LoadAttriCell(ui, data)
    GUI:Text_setString(ui["Text_attName"], data.name)
    GUI:Text_setString(ui["Text_attValue"], data.value or "")
end

function HeroExtraAtt.CreateAttriCell(tag)
    local ui = GUI:LoadExportEx2(isPC and "hero/att_show_list_win32" or "hero/att_show_list", "att_cell")
    GUI:ListView_pushBackCustomItem(HeroExtraAtt._listView, ui)
    GUI:ui_IterChilds(ui, ui)
    GUI:setTag(ui, tag or -1)
    return ui
end

--[[   
    attrs = {
        {id, name, value}
    }
]]
-- 刷新固定的属性
function HeroExtraAtt.RefreshFixedAttr(attrs)
    local attrList = GUIFunction:GetAttDataShow(attrs or {})
    for k, v in ipairs(attrList) do
        if v.id then
            local config = SL:GetValue("ATTR_CONFIG", v.id)
            if (config.isshow == 2 and v.value ~= 0) or config.isshow == 1 then
                local fixAttr = attrs[v.id]
                if fixAttr and fixAttr.sformat and fixAttr.max then
                    v.value = string.format(fixAttr.sformat, v.value, fixAttr.max)
                end
                local cell = GUI:getChildByTag(HeroExtraAtt._listView, v.id) or HeroExtraAtt.CreateAttriCell(v.id)
                HeroExtraAtt.LoadAttriCell(cell, v)
            end
        end
    end
end

-- 刷新HP MP属性
function HeroExtraAtt.OnRefreshHPMP()
    local HPMPAttr = {
        { id = AttType.HP, value = SL:GetValue("H.HP") or 0, max = SL:HPUnit(SL:GetValue("H.MAXHP")), sformat = "%s/%s" },
        { id = AttType.MP, value = SL:GetValue("H.MP") or 0, max = SL:HPUnit(SL:GetValue("H.MAXMP")), sformat = "%s/%s" },
    }
    HeroExtraAtt.RefreshFixedAttr(HPMPAttr)
end

HeroExtraAtt.main()