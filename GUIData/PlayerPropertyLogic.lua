PlayerPropertyLogic = PlayerPropertyLogic or {}

local mfloor = math.floor

function PlayerPropertyLogic.Init()

    PlayerPropertyLogic._abilChangeNotice = false
    PlayerPropertyLogic._lastAttr = {}

    PlayerPropertyLogic.RegisterEvent()
end

function PlayerPropertyLogic.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "PlayerPropertyLogic", PlayerPropertyLogic.CompareAttribute)
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE_FAIL, "PlayerPropertyLogic", PlayerPropertyLogic.OnPKModeChangeFail)
end

local shareAbilPZ = {}
function PlayerPropertyLogic.CompareAttribute()
    -- 五秒内不播放
    if not PlayerPropertyLogic._abilChangeNotice then
        SL:ScheduleOnce(function()
            PlayerPropertyLogic._abilChangeNotice = true
        end, 5)
    end

    local attrType, nAttrType = SL:GetValue("ATTR_TYPES")

    local isInvalid = true
    local attrItems = {}
    for i = 1, nAttrType do
        local attID = attrType[i]
        local config = SL:GetValue("ATTR_CONFIG", attID)
        if config and not GUIDefineEx.NoHintAtts[attID] then
            local attrValue = 0
            if attID == 1 then
                attrValue = SL:GetValue("MAXHP")
            elseif attID == 2 then
                attrValue = SL:GetValue("MAXMP")
            else
                attrValue = SL:GetValue("CUR_ABIL_BY_ID", attID)
            end

            attrItems[attID] = attrValue
            if attrValue > 0 then
                isInvalid = false
            end
        end
    end

    -- invalid
    if isInvalid then
        return nil
    end

    -- init
    if not next(PlayerPropertyLogic._lastAttr) then
        PlayerPropertyLogic._lastAttr = attrItems
        return nil
    end

    local diffAttr = {}
    local n = 0

    for i = 1, nAttrType do
        local attID = attrType[i]
        local v = attID and attrItems[attID]
        if v then
            local diff = mfloor(v - (PlayerPropertyLogic._lastAttr[attID] or 0))
            if diff >= 1 then
                n = n + 1
                diffAttr[n] = {id = attID, value = diff}
            end
        end
    end

    if n > 0 and PlayerPropertyLogic._abilChangeNotice then
        local isShowAbilNotice = tonumber(SL:GetValue("GAME_DATA", "isShowAttributeTips")) ~= 0
        if isShowAbilNotice then
            shareAbilPZ.attributes = diffAttr
            shareAbilPZ.attr_type  = 0
            SL:onLUAEvent(LUA_EVENT_NOTICE_ATTRIBUTE, shareAbilPZ)
        end
    end

    PlayerPropertyLogic._lastAttr = attrItems
end

function PlayerPropertyLogic.CheckCanRequestChangePKMode(state)
    if not SL:GetValue("PKMODE_CAN_USE", state) then
        SL:ShowSystemTips("当前无法切换模式")
        return false
    end
    return true
end

function PlayerPropertyLogic.OnPKModeChangeFail()
    SL:ShowSystemTips("当前无法切换模式")
end