HeroInternalState = {}  --内观面板 状态

HeroInternalState._ui = nil

local isPC = SL:GetValue("IS_PC_OPER_MODE")

HeroInternalState._stateStr = {
    "当前内功等级:   %s",
    "当前内功经验:   %s",
    "升级内功经验:   %s",
    "内 力 值:   %s/%s",
}

HeroInternalState._attrList = {
    101,
    102,
    104,
    103,
    105,
}

local function getAttStr(title, key)
    local str = ""
    if key == 1 then
        str = string.format(title, SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_LEVEL))
    elseif key == 2 then
        str = string.format(title, SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_EXP))
    elseif key == 3 then
        str = string.format(title, SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_EXP))
    elseif key == 4 then
        local value    = SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
        local maxValue = SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
        str = string.format(title, value, maxValue)
    end
    return str
end

local function getAttrShow(idx)
    local att = GUIFunction:GetAttDataShow({id = idx, value = SL:GetValue("H.CUR_ABIL_BY_ID", idx) or 0}, nil)
    att = att[idx] or {}
    local str = (att.name or "") .. " " .. (att.value or "")
    if idx == 105 and next(att) then -- 斗转星移值
        str = str .. string.format("/%s", SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue))
    end
    return str
end

function HeroInternalState.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "internal_hero/internal_state_node_win32" or "internal_hero/internal_state_node")

    HeroInternalState._ui = GUI:ui_delegate(parent)
    if not HeroInternalState._ui then
        return false
    end
    HeroInternalState._index = 0 --添加的属性条编号
    HeroInternalState.UpdateBaseAttri()

    HeroInternalState.RegisterEvent()

    SL:AttachTXTSUI({root = HeroInternalState._ui["Panel_1"], index = SLDefine.SUIComponentTable.HeroInternalState})
end

function HeroInternalState.UpdateBaseAttri()
    local list = HeroInternalState._ui.ListView_state
    GUI:removeAllChildren(list)
    HeroInternalState._index = 0
    for i, v in ipairs(HeroInternalState._stateStr) do
        local str = getAttStr(v, i)
        HeroInternalState.CreateAttri(list, str)
    end
    -- 属性
    for i, v in ipairs(HeroInternalState._attrList) do
        local str = getAttrShow(v, i)
        HeroInternalState.CreateAttri(list, str)
    end
end

function HeroInternalState.CreateAttri(parent, str)
    HeroInternalState._index = HeroInternalState._index + 1
    local sizeW = GUI:getContentSize(parent).width
    local sizeH = isPC and 20 or 30 
    local widget = GUI:Widget_Create(parent, "Attribute_" .. HeroInternalState._index, 0, 0, sizeW, HeroInternalState._index == 5 and (2 * sizeH) or sizeH)
    local fontSize = isPC and 12 or 16
    local attrText = GUI:Text_Create(widget, "attrText", isPC and 25 or 40, sizeH / 2, fontSize, "#FFFFFF", str)
    GUI:setAnchorPoint(attrText, 0, 0.5)
end

function HeroInternalState.OnClose()
    HeroInternalState.UnRegisterEvent()

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.HeroInternalState
    })
end

-----------------------------------注册事件--------------------------------------
function HeroInternalState.RegisterEvent()
    -- 内力值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE,   "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 内功经验值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE,     "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 斗转星移值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE, "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 属性改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE,         "HeroInternalState", HeroInternalState.UpdateBaseAttri)
end

function HeroInternalState.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE,     "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE,       "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE,   "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE,           "HeroInternalState")
end

HeroInternalState.main()