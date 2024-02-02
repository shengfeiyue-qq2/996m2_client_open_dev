PlayerInternalState = {}  --内观面板 状态

PlayerInternalState._ui = nil
PlayerInternalState._stateStr = {
    "当前内功等级:   %s",
    "当前内功经验:   %s",
    "升级内功经验:   %s",
    "内 力 值:   %s/%s",
}

PlayerInternalState._attrList = {
    101,
    102,
    104,
    103,
    105,
}

local function getAttStr(title, key)
    local str = ""
    if key == 1 then
        str = string.format(title, SL:GetMetaValue("INTERNAL_LEVEL"))
    elseif key == 2 then
        str = string.format(title, SL:GetMetaValue("INTERNAL_EXP"))
    elseif key == 3 then
        str = string.format(title, SL:GetMetaValue("INTERNAL_MAXEXP"))
    elseif key == 4 then
        local value = SL:GetMetaValue("INTERNAL_FORCE")
        local maxValue = SL:GetMetaValue("INTERNAL_MAXFORCE")
        str = string.format(title, value, maxValue)
    end
    return str
end

local function getAttrShow(idx)
    local att = GUIFunction:GetAttDataShow({id = idx, value = SL:GetMetaValue("ATT_BY_TYPE", idx) or 0}, nil)
    att = att[idx] or {}
    local str = (att.name or "") .. " " .. (att.value or "")
    if idx == 105 and next(att) then -- 斗转星移值
        str = str .. string.format("/%s", SL:GetMetaValue("INTERNAL_DZ_MAXVALUE"))
    end
    return str
end

function PlayerInternalState.main()
    local parent = GUI:Attach_Parent()
    PlayerInternalState._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    if PlayerInternalState._isWIN32 then
        GUI:LoadExport(parent, "internal_player/internal_state_node_win32")
    else
        GUI:LoadExport(parent, "internal_player/internal_state_node")
    end

    PlayerInternalState._ui = GUI:ui_delegate(parent)
    if not PlayerInternalState._ui then
        return false
    end
    PlayerInternalState._index = 0 --添加的属性条编号
    PlayerInternalState.UpdateBaseAttri()

    PlayerInternalState.RegisterEvent()
end

function PlayerInternalState.UpdateBaseAttri()
    local list = PlayerInternalState._ui.ListView_state
    GUI:removeAllChildren(list)
    PlayerInternalState._index = 0
    for i, v in ipairs(PlayerInternalState._stateStr) do
        local str = getAttStr(v, i)
        PlayerInternalState.CreateAttri(list, str)
    end
    -- 属性
    for i, v in ipairs(PlayerInternalState._attrList) do
        local str = getAttrShow(v, i)
        PlayerInternalState.CreateAttri(list, str)
    end
end

function PlayerInternalState.CreateAttri(parent, str)
    PlayerInternalState._index = PlayerInternalState._index + 1
    local sizeW = GUI:getContentSize(parent).width
    local sizeH = PlayerInternalState._isWIN32 and 20 or 30 
    local widget = GUI:Widget_Create(parent, "Attribute_" .. PlayerInternalState._index, 0, 0, sizeW, PlayerInternalState._index == 5 and (2 * sizeH) or sizeH)
    local fontSize = PlayerInternalState._isWIN32 and 12 or 16
    local attrText = GUI:Text_Create(widget, "attrText", PlayerInternalState._isWIN32 and 25 or 40, sizeH / 2, fontSize, "#FFFFFF", str)
    GUI:setAnchorPoint(attrText, 0, 0.5)
end

function PlayerInternalState.OnClose()
    PlayerInternalState.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function PlayerInternalState.RegisterEvent()
    -- 内力值改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_FORCE_CHANGE, "PlayerInternalState", PlayerInternalState.UpdateBaseAttri)
    -- 内功经验值改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_EXP_CHANGE, "PlayerInternalState", PlayerInternalState.UpdateBaseAttri)
    -- 斗转星移值改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_DZVALUE_CHANGE, "PlayerInternalState", PlayerInternalState.UpdateBaseAttri)
    -- 属性改变
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "PlayerInternalState", PlayerInternalState.UpdateBaseAttri)
end

function PlayerInternalState.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_FORCE_CHANGE, "PlayerInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_EXP_CHANGE, "PlayerInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_DZVALUE_CHANGE, "PlayerInternalState")
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "PlayerInternalState")
end