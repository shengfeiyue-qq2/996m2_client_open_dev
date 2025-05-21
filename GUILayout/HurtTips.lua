HurtTips = {}
HurtTips._isShow = false

function HurtTips.main()
    -- 监控血量低于30%
    SL:RegisterLUAEvent(LUA_EVENT_THROW_DAMAGE, "HurtTips", function(data)
        if not data then
            return
        end

        -- 设置- 残血提示
        if not (SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_UNSAFE_TIPS) == 1) then
            return
        end

        local actorID = data.actorID
        local damageID = data.damageID
        local damageNum = data.damageNum
        -- 是伤害类型
        if SL:GetValue("ACTOR_IS_MAINPLAYER", actorID) or SL:GetValue("ACTOR_IS_MAINHERO", actorID) then
            if SL:GetValue("DAMAGE_TYPE_BY_ID", damageID) == 1 then
                if HurtTips.CheckIsLowHP() then
                    if not HurtTips._isShow then
                        HurtTips.Show()
                    end
                end
            end
        end
    end)

    -- TODO: 英雄血量改变未监听，英雄收回未监听
    -- 血量变化
    SL:RegisterLUAEvent(LUA_EVENT_HERO_HPMP_CHANGE, "HurtTips", HurtTips.CheckNeedHide)
    SL:RegisterLUAEvent(LUA_EVENT_HPMP_CHANGE, "HurtTips", HurtTips.CheckNeedHide)

    -- 屏幕宽高改变
    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "HurtTips", function(...)
        if HurtTips._isShow then
            HurtTips.Hide()
            HurtTips.Show()
        end
    end)
end

function HurtTips.CheckNeedHide()
    if not HurtTips.CheckIsLowHP() then
        if HurtTips._isShow then
            HurtTips.Hide()
        end
    end
end

function HurtTips.CheckIsLowHP()
    -- 主玩家低血量
    local curHP = SL:GetValue("HP") or 0
    local maxHP = SL:GetValue("MAXHP") or 1
    local percent = curHP / maxHP
    if percent < 0.3 and percent > 0 then
        return true
    end

    -- 英雄低血量
    if SL:GetValue("HERO_IS_ALIVE") then
        local curHP = SL:GetValue("H.HP") or 0
        local maxHP = SL:GetValue("H.MAXHP") or 1
        if percent < 0.3 and percent > 0 then
            return true
        end
    end

    return false
end

function HurtTips.Show()
    if HurtTips._isShow then
        return
    end
    HurtTips._isShow = true
    local parent = GUI:Attach_UITop()
    HurtTips._content = GUI:LoadExport(parent, "hurt_tips/hurt_tips")
    GUI:runAction(HurtTips._content, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionFadeTo(2,50), GUI:ActionFadeTo(0.5,255))))
end

function HurtTips.Hide()
    if not HurtTips._isShow then
        return
    end
    HurtTips._isShow = false
    if HurtTips._content then
        GUI:removeFromParent(HurtTips._content)
        HurtTips._content = nil
    end
end

-- do
HurtTips.main()