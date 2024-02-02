HeroInternalState = {}  --内观面板 状态

HeroInternalState._ui = nil
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
        str = string.format(title, SL:GetMetaValue("H.INTERNAL_LEVEL"))
    elseif key == 2 then
        str = string.format(title, SL:GetMetaValue("H.INTERNAL_EXP"))
    elseif key == 3 then
        str = string.format(title, SL:GetMetaValue("H.INTERNAL_MAXEXP"))
    elseif key == 4 then
        local value = SL:GetMetaValue("H.INTERNAL_FORCE")
        local maxValue = SL:GetMetaValue("H.INTERNAL_MAXFORCE")
        str = string.format(title, value, maxValue)
    end
    return str
end

local function getAttrShow(idx)
    local att = GUIFunction:GetAttDataShow({id = idx, value = SL:GetMetaValue("H.ATT_BY_TYPE", idx) or 0}, nil)
    att = att[idx] or {}
    local str = (att.name or "") .. " " .. (att.value or "")
    if idx == 105 and next(att) then -- 斗转星移值
        str = str .. string.format("/%s", SL:GetMetaValue("H.INTERNAL_DZ_MAXVALUE"))
    end
    return str
end

function HeroInternalState.main()
    local parent = GUI:Attach_Parent()
    HeroInternalState._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    if HeroInternalState._isWIN32 then
        GUI:LoadExport(parent, "internal_hero/internal_state_node_win32")
    else
        GUI:LoadExport(parent, "internal_hero/internal_state_node")
    end

    HeroInternalState._ui = GUI:ui_delegate(parent)
    if not HeroInternalState._ui then
        return false
    end
    HeroInternalState._index = 0 --添加的属性条编号
    HeroInternalState.UpdateBaseAttri()

    HeroInternalState.RegisterEvent()
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
    local sizeH = HeroInternalState._isWIN32 and 20 or 30 
    local widget = GUI:Widget_Create(parent, "Attribute_" .. HeroInternalState._index, 0, 0, sizeW, HeroInternalState._index == 5 and (2 * sizeH) or sizeH)
    local fontSize = HeroInternalState._isWIN32 and 12 or 16
    local attrText = GUI:Text_Create(widget, "attrText", HeroInternalState._isWIN32 and 25 or 40, sizeH / 2, fontSize, "#FFFFFF", str)
    GUI:setAnchorPoint(attrText, 0, 0.5)
end

function HeroInternalState.OnClose()
    HeroInternalState.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function HeroInternalState.RegisterEvent()
    -- 内力值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE, "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 内功经验值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE, "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 斗转星移值改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE, "HeroInternalState", HeroInternalState.UpdateBaseAttri)
    -- 属性改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroInternalState", HeroInternalState.UpdateBaseAttri)
end

function HeroInternalState.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE, "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE, "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE, "HeroInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroInternalState")
end