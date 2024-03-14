-- 英雄状态选择面板 挂在左下角
HeroStateThreeSelect = {}
HeroStateThreeSelect._ui = nil

function HeroStateThreeSelect.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_state_three_select_node")

    HeroStateThreeSelect._ui = GUI:ui_delegate(parent)
    if not HeroStateThreeSelect._ui then
        return false
    end
    HeroStateThreeSelect._parent = parent
    HeroStateThreeSelect.isWinPlayMode = SL:GetMetaValue("WINPLAYMODE")
    HeroStateThreeSelect._mode = data.mode or 2 --1选择状态 2单击切换  3不能点击,滑动
    HeroStateThreeSelect.InitUI(data)
end

function HeroStateThreeSelect.addDoubleEventListener(node, param)
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
                end, SLDefine.CLICK_DOUBLE_TIME)
            end
        end
    end)

end

function HeroStateThreeSelect.addLongClickListener(node, param)
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

function HeroStateThreeSelect.InitUI(data)
    local states =  SL:GetMetaValue("HERO_ACTIVES_STATES") --英雄激活的状态
    local stateSys = SL:GetMetaValue("HERO_STATES_SYS_VALUES")--英雄状态系统 能设置的值3个或四个
    local curstate = 0
    if SL:GetMetaValue("HERO_GUARDSTATE") then
        curstate = 3
    else
        local state = SL:GetMetaValue("HERO_STATE")
        state = tonumber(state)
        curstate = state
    end
    HeroStateThreeSelect._curidx = table.indexof(stateSys, curstate)
    if HeroStateThreeSelect._mode == 3 or HeroStateThreeSelect._mode == 2 then
        for i = 1, 3 do
            local txt = HeroStateThreeSelect._ui["Text_" .. i]
            local img = HeroStateThreeSelect._ui["Image_bg" .. i]
            if stateSys[i] then
                local showStrs = { "战斗", "跟随", "休息", "守护"}
                GUI:Text_setString(txt, showStrs[stateSys[i]+1])
                GUI:setVisible(img, i == HeroStateThreeSelect._curidx)
            end
            local shortCallBack = function()
                if stateSys[i] == 3 then
                    local state = SL:GetMetaValue("HERO_GUARD_ISCLICK")
                    SL:SetMetaValue("HERO_GUARD_ISCLICK", not state)
                else
                    SL:RequestChangeHeroMode(stateSys[i])
                end
                SL:CloseHeroStateSelectUI()
            end
            local longCallBack = shortCallBack
            local Panel_touch = HeroStateThreeSelect._ui["Panel_touch" .. i]
            if HeroStateThreeSelect._mode == 2 then
                HeroStateThreeSelect.addLongClickListener(Panel_touch, { shortCallBack = shortCallBack, longCallBack = longCallBack })
            end
        end
    else
        for i = 1, 3 do
            local txt = HeroStateThreeSelect._ui["Text_" .. i]
            local img = HeroStateThreeSelect._ui["Image_bg" .. i]
            if stateSys[i] then
                local showStrs = { "战斗", "跟随", "休息", "守护"}
                GUI:Text_setString(txt, showStrs[stateSys[i]+1])
                GUI:setVisible(img, table.indexof(states, stateSys[i]) ~= false)
            end
            local clickCallBack = function()
                if stateSys[i] == 3 then
                    local state = SL:GetMetaValue("HERO_GUARD_ISCLICK")
                    SL:SetMetaValue("HERO_GUARD_ISCLICK", not state)
                else
                    SL:RequestChangeHeroMode(stateSys[i])
                end
                SL:CloseHeroStateSelectUI()
            end
            local doubleClickCallBack = function()
                local idx = table.indexof(states, stateSys[i])
                if idx then
                    table.remove(states, idx)
                    GUI:setVisible(img, false)
                else
                    GUI:setVisible(img, true)
                    table.insert(states, stateSys[i])
                end
                SL:SetMetaValue("HERO_ACTIVES_STATES", states)
            end
            local Panel_touch = HeroStateThreeSelect._ui["Panel_touch" .. i]
            HeroStateThreeSelect.addDoubleEventListener(Panel_touch, { clickCallBack = clickCallBack, doubleClickCallBack = doubleClickCallBack })
        end
    end
    GUI:addOnClickEvent(HeroStateThreeSelect._ui.Panel_2,function()
        SL:CloseHeroStateSelectUI()
    end)
    HeroStateThreeSelect.refState()

end
--选中触发
function HeroStateThreeSelect.refSelect(val)
    local index = val.index
    local stateSys = SL:GetMetaValue("HERO_STATES_SYS_VALUES")--英雄状态系统 能设置的值3个或四个
    if index == -1 then
        if HeroStateThreeSelect._select and HeroStateThreeSelect._select ~= HeroStateThreeSelect._curidx then
            if stateSys[HeroStateThreeSelect._select] == 3 then
                local state = SL:GetMetaValue("HERO_GUARD_ISCLICK")
                SL:SetMetaValue("HERO_GUARD_ISCLICK", not state)
            else
                SL:RequestChangeHeroMode(stateSys[HeroStateThreeSelect._select])
            end
        end
        SL:CloseHeroStateSelectUI()
        return
    end

    HeroStateThreeSelect._select = index
    for i = 1, 3 do
        local img = HeroStateThreeSelect._ui["Image_bg" .. i]
        GUI:setVisible(img, i == index)
    end

end
--状态改变
function HeroStateThreeSelect.refState()
    GUI:setVisible(HeroStateThreeSelect._ui.Text_4, true)
    local stateStr = ""
    if SL:GetMetaValue("HERO_GUARDSTATE") then
        stateStr = "守护"
    else
        local state = SL:GetMetaValue("HERO_STATE") 
        state = tonumber(state)
        local showStrs = { "战斗", "跟随", "休息"}
        stateStr = showStrs[1 + state]
    end
    GUI:Text_setString(HeroStateThreeSelect._ui.Text_4, stateStr)
end
