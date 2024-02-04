Notice = {}

Notice._ui = nil

function Notice.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "notice/notice")

    local ui = GUI:ui_delegate(parent)
    Notice._ui = ui
    
    Notice.OnAdapet()
    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "Notice", Notice.OnAdapet)
end

function Notice.close()
    Notice._ui = nil
    SL:UnRegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "Notice")
end

function Notice.createAttributeCell(parent)
    if parent then
        GUI:LoadExport(parent, "notice/attribute_cell")
    end
end

function Notice.OnAdapet()
    if not Notice._ui then
        return false
    end
    local ui = Notice._ui

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local positionY = 200
    GUI:setPosition(ui["Node_timer_xy_tips"], screenW / 2, positionY)
    GUI:setPosition(ui["Node_timer_tips"], screenW / 2, positionY)

    GUI:setPositionX(ui["Node_normal_tips"], screenW / 2)

    -- 玩家属性变化通知节点
    GUI:setPositionX(ui["Node_attribute"], screenW - 285)

    GUI:setPositionY(ui["Node_server_tips"], screenH)
    GUI:setPosition(ui["Node_system_tips"], screenW / 2, screenH)

    -- 道具消耗、获取类节点
    GUI:setPositionX(ui["Node_item_tips"], 50)

    -- 经验tips位置调整走 cfg_game_data 表 EXPcoordinate 字段
end