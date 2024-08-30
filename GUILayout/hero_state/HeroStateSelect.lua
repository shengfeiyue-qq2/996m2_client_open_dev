-- 英雄状态选择面板 挂在左下角
HeroStateSelect = {}

-- 英雄状态系统 能设置的值3个或四个
local HERO_STATES_SYS_VALUES = SL:GetValue("HERO_STATES_SYS_VALUES")

local MAX_NUM = #HERO_STATES_SYS_VALUES == 4 and 4 or 3

function HeroStateSelect.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.HeroStateSelectGUI, 0, 0, 0, 0, nil, nil, nil, nil, nil, nil, GUIDefine.UIZ.NORMAL)
    GUI:LoadExport(parent, "hero/hero_state_select_node")
    local root = GUI:ui_delegate(parent)
    if not root then
        return false
    end

    GUI:Win_SetCloseCB(parent, HeroStateSelect.OnClose)

    if #HERO_STATES_SYS_VALUES == 4 then
        GUI:setVisible(root["Image_Normal"], true)
        GUI:setVisible(root["Image_Three"], false)
        HeroStateSelect._ui = root["Image_Normal"]
    else
        GUI:setVisible(root["Image_Normal"], false)
        GUI:setVisible(root["Image_Three"], true)
        HeroStateSelect._ui = root["Image_Three"]
    end

    GUI:ui_IterChilds(HeroStateSelect._ui, HeroStateSelect._ui)

    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    HeroStateSelect.InitUI(data)

    GUI:addOnClickEvent(root["Panel_2"], function() UIOperator:CloseHeroStateSelectUI() end)

    HeroStateSelect.OnUpdateLockState()

    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOCK_CHANGE, "HeroStateSelect", HeroStateSelect.OnUpdateLockState)
end

function HeroStateSelect.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LOCK_CHANGE, "HeroStateSelect")
end

function HeroStateSelect.AddDoubleEventListener(node, param)
    local clickCallBack = param.clickCallBack
    local doubleClickCallBack = param.doubleClickCallBack
    GUI:addOnTouchEvent(node,function(sender, type)
        if type == 0 then
            if node._clicking then
                if doubleClickCallBack then
                    doubleClickCallBack()
                end
                GUI:stopAllActions(node)
                node._clicking = false
            else
                node._clicking = true
                SL:scheduleOnce(node, function()
                    node._clicking = false
                    if clickCallBack then
                        clickCallBack()
                    end
                end, GUIDefine.CLICK_DOUBLE_TIME)
            end
        end
    end)
end

function HeroStateSelect.addLongClickListener(node, param)
    local shortCallBack = param.shortCallBack
    local longCallBack = param.longCallBack
    local longTime = 0.5--长按时间
    GUI:addOnTouchEvent(node,function(sender, type)
        if type == 0 then
            if not node._clicking then
                node._clicking = true
                SL:scheduleOnce(node, function()
                    node._clicking = false
                    if longCallBack then
                        longCallBack()
                    end
                end, longTime)
            end
        elseif type == 2 then
            if node._clicking then  --未触发长按触发短按
                GUI:stopAllActions(node)
                node._clicking = false
                if shortCallBack then
                    shortCallBack()
                end
            end
        end
    end)
end

function HeroStateSelect.InitUI(data)
    -- 当前状态
    local curstate = SL:GetValue("HERO_GUARDSTATE") and 3 or SL:GetValue("HERO_STATE")
    HeroStateSelect._curIndex = table.indexof(HERO_STATES_SYS_VALUES, curstate)

    -- 英雄激活的状态
    local states = SL:GetValue("HERO_ACTIVES_STATES")

    -- 1选择状态 2单击切换 3不能点击,滑动
    local mode = data.mode or 2
    
    if mode == 3 or mode == 2 then
        for i = 1, MAX_NUM do
            local txt = HeroStateSelect._ui["Text_" .. i]
            local img = HeroStateSelect._ui["Image_bg" .. i]
            if HERO_STATES_SYS_VALUES[i] then
                local showStrs = { "战斗", "跟随", "休息", "守护"}
                GUI:Text_setString(txt, showStrs[HERO_STATES_SYS_VALUES[i]+1])
                GUI:setVisible(img, i == HeroStateSelect._curIndex)
            end
            local shortCallBack = function()
                if HERO_STATES_SYS_VALUES[i] == 3 then
                    local state = SL:GetValue("HERO_GUARD_ISCLICK")
                    SL:SetValue("HERO_GUARD_ISCLICK", not state)
                else
                    SL:RequestChangeHeroMode(HERO_STATES_SYS_VALUES[i])
                end
                UIOperator:CloseHeroStateSelectUI()
            end
            local longCallBack = shortCallBack
            local Panel_touch = HeroStateSelect._ui["Panel_touch" .. i]
            if mode == 2 then
                HeroStateSelect.addLongClickListener(Panel_touch, { shortCallBack = shortCallBack, longCallBack = longCallBack })
            end
        end
    else
        for i = 1, MAX_NUM do
            local txt = HeroStateSelect._ui["Text_" .. i]
            local img = HeroStateSelect._ui["Image_bg" .. i]
            if HERO_STATES_SYS_VALUES[i] then
                local showStrs = { "战斗", "跟随", "休息", "守护"}
                GUI:Text_setString(txt, showStrs[HERO_STATES_SYS_VALUES[i]+1])
                GUI:setVisible(img, table.indexof(states, HERO_STATES_SYS_VALUES[i]) ~= false)
            end
            local clickCallBack = function()
                if HERO_STATES_SYS_VALUES[i] == 3 then
                    local state = SL:GetValue("HERO_GUARD_ISCLICK")
                    SL:SetValue("HERO_GUARD_ISCLICK", not state)
                else
                    SL:RequestChangeHeroMode(HERO_STATES_SYS_VALUES[i])
                end
                UIOperator:CloseHeroStateSelectUI()
            end
            local doubleClickCallBack = function()
                local idx = table.indexof(states, HERO_STATES_SYS_VALUES[i])
                if idx then
                    table.remove(states, idx)
                    GUI:setVisible(img, false)
                else
                    GUI:setVisible(img, true)
                    table.insert(states, HERO_STATES_SYS_VALUES[i])
                end
                SL:SetValue("HERO_ACTIVES_STATES", states)
            end
            local Panel_touch = HeroStateSelect._ui["Panel_touch" .. i]
            HeroStateSelect.AddDoubleEventListener(Panel_touch, { clickCallBack = clickCallBack, doubleClickCallBack = doubleClickCallBack })
        end
    end
end

-- 选中触发
function HeroStateSelect.refSelect(val)
    local index = val.index
    if index == -1 then
        if HeroStateSelect._selIndex and HeroStateSelect._selIndex ~= HeroStateSelect._curIndex then
            if HERO_STATES_SYS_VALUES[HeroStateSelect._selIndex] == 3 then
                local state = SL:GetValue("HERO_GUARD_ISCLICK")
                SL:SetValue("HERO_GUARD_ISCLICK", not state)
            else
                SL:RequestChangeHeroMode(HERO_STATES_SYS_VALUES[HeroStateSelect._selIndex])
            end
        end
        return UIOperator:CloseHeroStateSelectUI()
    end

    HeroStateSelect._selIndex = index

    for i = 1, MAX_NUM do
        GUI:setVisible(HeroStateSelect._ui["Image_bg" .. i], i == index)
    end
end

-- 状态改变
function HeroStateSelect.OnUpdateLockState()
    local stateStr = ""
    if SL:GetValue("HERO_GUARDSTATE") then
        stateStr = "守护"
    else
        local state = SL:GetValue("HERO_STATE") 
        local showStrs = {"战斗", "跟随", "休息"}
        stateStr = showStrs[state+1]
    end
    GUI:Text_setString(HeroStateSelect._ui["Text_state"], stateStr)
    
    GUI:setVisible(HeroStateSelect._ui["Text_state"], true)
end

HeroStateSelect.main()
