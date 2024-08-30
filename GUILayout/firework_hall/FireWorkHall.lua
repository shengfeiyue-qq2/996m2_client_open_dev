FireWorkHall = {}
FireWorkHall._fireworks_count = 0  --烟花数量
function FireWorkHall.main()
    SL:RegisterLUAEvent(LUA_EVENT_FIRE_WORK_HALL_SHOW, "FireWorkHall", function(data)
        FireWorkHall.ShowFireWorks(data)
    end)
end

--播放烟花特效
--@data: 烟花数据 effectID: 烟花id  userid: 玩家id
function FireWorkHall.ShowFireWorks(data)
    FireWorkHall._fireworks_count = FireWorkHall._fireworks_count or 0
    if FireWorkHall._fireworks_count and FireWorkHall._fireworks_count > 100 then
        return false
    end

    if (not data) or (not data.userid) or (not data.effectID) then
        return
    end

    local actorId    = data.userid
    local effectId   = data.effectID
    local function removeEvent()
        FireWorkHall._fireworks_count = FireWorkHall._fireworks_count - 1
        if FireWorkHall._fireworks_count == 0 then
            if FireWorkHall._anim_layer then
                FireWorkHall._anim_layer:removeFromParent()
                FireWorkHall._anim_layer = nil
            end
        end
    end
    -- 播放烟花
    SL:CreateShowFireWorks(FireWorkHall._anim_layer, actorId, effectId, removeEvent)
    -- 计数
    FireWorkHall._fireworks_count = FireWorkHall._fireworks_count + 1
end

FireWorkHall.main()