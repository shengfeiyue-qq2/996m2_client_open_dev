RedDot = {}

function RedDot.main()
    RedDot._GuideWidgetConfig = SL:RequireFile(GUIDefine.PATH_GUIDE_CONFIG)
    local data = GUI:GetLayerOpenParam()
    local function func()
        RedDot._data = data
        if RedDot._data.add == 1 then
            RedDot.addRedDot()
        else
            RedDot.removeRedDot()
        end
    end

    SL:ScheduleOnce(func, 0.3)
end

-- 基础指引：
-- 1 NPC面板组件            辅助参数.组件id
-- 2 主界面技能模块按钮      辅助参数.组件id   挂节点.109
-- 3 任务                   辅助参数.任务id
-- 4 任务 tips              辅助参数.超链id
-- 5 主界面左上挂节点        辅助参数.组件id  挂节点.101
-- 6 主界面右上挂节点        辅助参数.组件id  挂节点.102
-- 7 主界面左下挂节点        辅助参数.组件id  挂节点.103
-- 8 主界面右下挂节点        辅助参数.组件id  挂节点.104
-- 9 主界面左中挂节点        辅助参数.组件id  挂节点.105
-- 10主界面上中挂节点        辅助参数.组件id  挂节点.106
-- 11主界面右中挂节点        辅助参数.组件id  挂节点.107
-- 12主界面下中挂节点        辅助参数.组件id  挂节点.108
function RedDot.findNode()
    local idx = tonumber(RedDot._data.mainId)

    local getNodesFunc = RedDot._GuideWidgetConfig[idx]
    if not getNodesFunc then
        return
    end
    local temp = { typeassist = RedDot._data.uiId }
    RedDot._widget, RedDot._parent = getNodesFunc(temp)

    if (not RedDot._widget) or (not RedDot._parent) then
        return nil
    end

    return RedDot._widget
end

function RedDot.addRedDot()
    local widget = RedDot.findNode()
    if not widget then
        return
    end
    local content = GUI:getBoundingBox(widget)
    local hei = content.height
    local x = RedDot._data.x
    local y = hei - RedDot._data.y
    local reddot = GUI:getChildByName(widget, "_RedDot_")
    if reddot then
        GUI:removeFromParent(reddot)
    end
    local strs = string.split(SL:GetValue("GAME_DATA", "Redtips"), "|")
    local path = strs[SL:GetValue("IS_PC_OPER_MODE") and 1 or 2]
    if not RedDot._data.mode or (RedDot._data.mode and RedDot._data.mode == 0) then -- 图片模式
        if RedDot._data.mode and RedDot._data.res and string.len(RedDot._data.res) > 0 then
            path = RedDot._data.res
        end
        path = SL:SUIHelperFixImageFileName(path)
        reddot = GUI:Sprite_Create(widget, "_RedDot_", x, y, path)
    elseif RedDot._data.mode and RedDot._data.mode == 1 then -- 特效模式
        local sfxID = RedDot._data.res and tonumber(RedDot._data.res)
        if sfxID then
            reddot = GUI:Effect_Create(widget, "_RedDot_", x, y, 0, sfxID)
            if reddot then
                reddot.sfxID = sfxID
            end
        end
    end
end

function RedDot.removeRedDot()
    local widget = RedDot.findNode()
    if not widget then
        return
    end
    local reddot = GUI:getChildByName(widget, "_RedDot_")
    if reddot then
        GUI:removeFromParent(reddot)
    end
end



RedDot.main()
