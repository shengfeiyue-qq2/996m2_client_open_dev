MainAssist = {}

local tinsert = table.insert

MainAssist.MissionFontSize = 14
MainAssist.MissionFontName = "fonts/font2.ttf"  

MainAssist._hideAssist = false
MainAssist._missionCells = {}

function MainAssist.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/assist/main_assist_win32")

    MainAssist._ui = GUI:ui_delegate(parent)

    local Panel_assist = MainAssist._ui["Panel_assist"]
    MainAssist._Panel_assist = Panel_assist
    MainAssist._assistPos = GUI:getPosition(Panel_assist)

    -- 是否隐藏
    local Panel_hide = MainAssist._ui["Panel_hide"]
    MainAssist._Panel_hide = Panel_hide
    GUI:addOnClickEvent(Panel_hide, function()
        MainAssist.ChangeHideStatus(not MainAssist._hideAssist)
    end)

    local Button_hide = MainAssist._ui["Button_hide"]
    MainAssist._Button_hide = Button_hide
    GUI:addOnClickEvent(Button_hide, function()
        MainAssist.ChangeHideStatus(not MainAssist._hideAssist)
    end)

    -- mission
    local ListView_mission = MainAssist._ui["ListView_mission"]
    MainAssist.ListView_mission = ListView_mission
    GUI:ListView_autoPaintItems(ListView_mission)

    -- reset pos PCAssistNearShow:是否显示附近按钮
    local isShow = (SL:GetMetaValue("GAME_DATA", "PCAssistNearShow") or 0) == 1
    GUI:setVisible(MainAssist._ui["Panel_group"], isShow)
    GUI:setContentSize(Panel_assist, isShow and 244 or 202, GUI:getContentSize(Panel_assist).height)
    GUI:setPositionX(GUI:getChildByName(Panel_assist, "Panel_content"), isShow and 42 or 0)

    GUI:setPositionX(Panel_hide, isShow and 245 or 203)
    MainAssist._hidePos = GUI:getPosition(Panel_hide)

    MainAssist.RegisterEvent()
end

function MainAssist.ChangeHideStatus(status)
    if MainAssist._hideAssist == status then
        return
    end

    MainAssist._hideAssist = status

    GUI:setFlippedX(MainAssist._Button_hide, MainAssist._hideAssist)

    local assistSize = GUI:getContentSize(MainAssist._Panel_assist)
    local hideX, hideY = MainAssist._hidePos.x, MainAssist._hidePos.y
    local assitX, assitY = MainAssist._assistPos.x, MainAssist._assistPos.y

    GUI:stopAllActions(MainAssist._Panel_assist)
    GUI:stopAllActions(MainAssist._Panel_hide)

    if MainAssist._hideAssist then
        local movePosHide = { x = hideX - assistSize.width, y = hideY }
        GUI:Timeline_EaseSineIn_MoveTo(MainAssist._Panel_hide, movePosHide, 0.2)
        local movePosAssist = { x = assitX - assistSize.width, y = assitY }
        GUI:Timeline_EaseSineIn_MoveTo(MainAssist._Panel_assist, movePosAssist, 0.2, function()
            GUI:setVisible(MainAssist._Panel_assist, false)
            -- 110 任务栏引导主ID
            SL:SetMetaValue("GUIDE_EVENT_END", 110)
        end)
        SL:onLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE, {assistSize = assistSize, bHide = true})
    else
        GUI:setVisible(MainAssist._Panel_assist, true)
        GUI:Timeline_EaseSineIn_MoveTo(MainAssist._Panel_hide, {x = hideX, y = hideY}, 0.2)
        GUI:Timeline_EaseSineIn_MoveTo(MainAssist._Panel_assist, {x = assitX, y = assitY}, 0.2, function()
            SL:SetMetaValue("GUIDE_EVENT_BEGAN", 110, true)
        end)
        SL:onLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE, {assistSize = assistSize, bHide = false})
    end
end

--------------------------------Mission begin-----------------------------------
function MainAssist.onMissionItemTop(id)
    MainAssist._topMission = id
    MainAssist.UpdateMissionCellsOrder()
end

function MainAssist.onMissionItemAdd(data)
    local cell = MainAssist.CreateMissionCell(data)
    MainAssist._missionCells[data.type] = cell
    GUI:ListView_pushBackCustomItem(MainAssist.ListView_mission, cell.quickUI.nativeUI)
    MainAssist.UpdateMissionCellData(cell, data)
    MainAssist.UpdateMissionCellsOrder()
end

function MainAssist.onMissionItemChange(data)
    local cell = MainAssist._missionCells[data.type]
    if not cell then
        return nil
    end

    local lastOrder = cell.order

    local needUpdate = MainAssist.UpdateMissionCellData(cell, data)

    if needUpdate or lastOrder ~= cell.order then
        MainAssist.UpdateMissionCellsOrder()
    end
end

function MainAssist.onMissionItemRemove(data)
    local cell = MainAssist._missionCells[data.type]
    if not cell then
        return nil
    end

    local removeIndex = GUI:ListView_getItemIndex(MainAssist.ListView_mission, cell.quickUI.nativeUI)
    GUI:ListView_removeItemByIndex(MainAssist.ListView_mission, removeIndex)
    MainAssist._missionCells[data.type] = nil

    MainAssist.UpdateMissionCellsOrder()
end

function MainAssist.onMissionShow(data)
    GUI:setVisible(MainAssist.ListView_mission, data == nil or data == true)
end

function MainAssist.CreateMissionCell(data)
    local parent = GUI:Node_Create(MainAssist._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "main/assist/main_assist_mission_cell")
    local layout = GUI:getChildByName(parent, "mission_cell")
    GUI:removeFromParent(layout)
    GUI:removeFromParent(parent)

    local quickUI = GUI:ui_delegate(layout)

    GUI:addOnClickEvent(quickUI.Button_act, function()
        SL:RequestSubmitMission(data.type)
    end)

    local cell = {
        quickUI = quickUI,
        data    = data,
        order = 0,
    }

    return cell
end

function MainAssist.UpdateMissionCellData(cell, data)
    cell.data = data
    cell.order = SL:GetMetaValue("MISSION_ITEM_ORDER", data.type)
    local item = cell.quickUI

    -- title
    GUI:removeAllChildren(item.Node_title)
    local richTitle = GUI:RichText_Create(item.Node_title, "richTitle", 0, 0, data.head.content, 999, MainAssist.MissionFontSize, SL:GetHexColorByStyleId(data.head.color))
    GUI:setAnchorPoint(richTitle, 0, 1)

    -- content
    GUI:removeAllChildren(item.Node_content)
    local richContent = GUI:RichText_Create(item.Node_content, "richContent", 0, 0, data.body.content, 999, MainAssist.MissionFontSize, SL:GetHexColorByStyleId(data.body.color))
    GUI:setAnchorPoint(richContent, 0, 1)

    -- sfx
    cell.sfx = nil
    GUI:removeAllChildren(item.Node_sfx)
    if data.animID then
        local x = data.offsetX or 0
        local y = data.offsetY or 0
        local sfx = GUI:Effect_Create(item.Node_sfx, "sfx", x, y, 0, data.animID)
        cell.sfx = sfx
    end

    -- 动态高度
    local oldSize = GUI:getContentSize(item.nativeUI)
    local contentSize = GUI:getContentSize(richContent)
    local defaultW, defaultH, minH = 200, 185, 60
    local height = math.max(minH, 37 + contentSize.height)
    height = ((defaultH - height) <= 15) and defaultH or height

    GUI:setContentSize(item.nativeUI, defaultW, height)
    GUI:setContentSize(item.Button_act, defaultW, height)

    GUI:setPosition(item.Button_act, defaultW / 2, height / 2)
    GUI:setPosition(item.Node_sfx, defaultW / 2, height / 2)
    GUI:setPosition(item.Node_title, 10, height - 5)
    GUI:setPosition(item.Node_content, 10, height - 30)

    return oldSize.height ~= height
end

function MainAssist.UpdateMissionCellsOrder()
    -- 数组化，方便接下来排序
    local cells = {}
    for _, v in pairs(MainAssist._missionCells) do
        tinsert(cells, v)
    end
    table.sort(cells, function(a, b)
        return a.order < b.order
    end)

    -- 找到置顶任务
    local index = nil
    for k, v in ipairs(cells) do
        GUI:addRef(v.quickUI.nativeUI)
        if MainAssist._topMission and MainAssist._topMission == v.data.type then
            index = k
        end
    end

    local ListView_mission = MainAssist.ListView_mission
    GUI:ListView_removeAllItems(ListView_mission)

    -- 置顶
    if index then
        local cell = table.remove(cells, index)
        GUI:ListView_pushBackCustomItem(ListView_mission, cell.quickUI.nativeUI)
        GUI:decRef(cell.quickUI.nativeUI)
        if cell.sfx then
            GUI:Effect_stop(cell.sfx)
            GUI:Effect_play(cell.sfx, 0, 0, true)
        end
    end

    for _, v in ipairs(cells) do
        GUI:ListView_pushBackCustomItem(ListView_mission, v.quickUI.nativeUI)
        GUI:decRef(v.quickUI.nativeUI)
        if v.sfx then
            GUI:Effect_stop(v.sfx)
            GUI:Effect_play(v.sfx, 0, 0, true)
        end
    end

    GUI:ListView_doLayout(ListView_mission)
    GUI:ListView_paintItems(ListView_mission)
    GUI:setTouchEnabled(ListView_mission, #cells > 1)
end
---------------------------------Mission end------------------------------------

-----------------------------------注册事件--------------------------------------
function MainAssist.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_TOP, "MainAssist", MainAssist.onMissionItemTop)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_ADD, "MainAssist", MainAssist.onMissionItemAdd)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_CHANGE, "MainAssist", MainAssist.onMissionItemChange)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_REMOVE, "MainAssist", MainAssist.onMissionItemRemove)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_SHOW, "MainAssist", MainAssist.onMissionShow)
end