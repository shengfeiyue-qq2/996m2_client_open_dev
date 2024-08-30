MainAssist = {}

function MainAssist.main()
    local parent = GUI:Attach_LeftTop()
    GUI:LoadExport(parent, "main/assist/main_assist_win32")
    MainAssist._root = GUI:getChildByName(parent, "Main_Assist")

    MainAssist._ui = GUI:ui_delegate(MainAssist._root)
    if not MainAssist._ui then
        return false
    end

    GUI:setPositionY(MainAssist._root, -5)

    MainAssist._hideAssist = false

    local Panel_assist = MainAssist._ui["Panel_assist"]
    MainAssist._Panel_assist = Panel_assist
    MainAssist._assistPos = GUI:getPosition(Panel_assist)

    -- 是否隐藏
    local Panel_hide = MainAssist._ui["Panel_hide"]
    GUI:addOnClickEvent(Panel_hide, function()
        MainAssist.ChangeHideStatus({status = not MainAssist._hideAssist})
    end)

    GUI:addOnClickEvent(MainAssist._ui["Button_hide"], function()
        MainAssist.ChangeHideStatus({status = not MainAssist._hideAssist})
    end)

    GUI:addOnClickEvent(MainAssist._ui["Button_near"], function()
        MainAssist.ChangeHideStatus({status = not MainAssist._hideAssist})
    end)

    local btnNear = MainAssist._ui["Button_near"]
    GUI:addOnClickEvent(btnNear, function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.MainNear)
        else
            SL:JumpTo(SLDefine.HyperLinkID.MainNear)
        end
        GUI:setClickDelay(btnNear)
    end)

    -- mission
    local ListView_task = MainAssist._ui["ListView_task"]
    MainAssist.ListView_task = ListView_task
    GUI:ListView_autoPaintItems(ListView_task)

    -- reset pos PCAssistNearShow:是否显示附近按钮
    local isShow = (SL:GetValue("GAME_DATA", "PCAssistNearShow") or 0) == 1
    GUI:setVisible(MainAssist._ui["Panel_group"], isShow)
    GUI:setContentSize(Panel_assist, isShow and 244 or 202, GUI:getContentSize(Panel_assist).height)
    GUI:setPositionX(GUI:getChildByName(Panel_assist, "Panel_content"), isShow and 42 or 0)

    GUI:setPositionX(Panel_hide, isShow and 245 or 203)
    MainAssist._hidePos = GUI:getPosition(Panel_hide)

    MainAssist.RegisterEvent()

    SL:AttachTXTSUI({
        root  = MainAssist._ui["Panel_task"],
        index = SLDefine.SUIComponentTable.MainRootMission
    })

    SL:AttachTXTSUI({
        root  = MainAssist._ui["Panel_assist"],
        index = SLDefine.SUIComponentTable.MainRootAssist
    })

    GUI:SetGUIParent(110, MainAssist._ui["Panel_task"])
    GUI:SetGUIParent(111, MainAssist._ui["Panel_assist"])

    -- 开关
    if SL:GetValue("SERVER_OPTION", SW_KEY_MISSTION) ~= 1 then
        GUI:setVisible(MainAssist._root, false)
    end

    -- 挂接点(不可变)
    MainAssist._HangNode = MainAssist._root

    -- 可变挂接点
    MainAssist._VARHangNode = MainAssist._ui["Panel_assist"]
end

-- 任务栏展开、折叠
function MainAssist.ChangeHideStatus(data)
    local status   = (data and data.status) and true or false
    local callback = data and data.callback

    if MainAssist._hideAssist == status then
        return false
    end
    MainAssist._hideAssist = status
    GUI:setFlippedX(MainAssist._ui["Button_hide"], MainAssist._hideAssist)


    local Panel_assist = MainAssist._ui["Panel_assist"]
    local Panel_hide   = MainAssist._ui["Panel_hide"]

    local pAssistWidth = GUI:getContentSize(Panel_assist).width
    local pAssistX     = MainAssist._assistPos.x or 0
    local pAssistY     = MainAssist._assistPos.y or 0
    local pHideX       = MainAssist._hidePos.x or 0
    local pHideY       = MainAssist._hidePos.y or 0

    GUI:stopAllActions(Panel_assist)
    GUI:stopAllActions(Panel_hide)

    if MainAssist._hideAssist then
        GUI:Timeline_EaseSineIn_MoveTo(Panel_hide, {x = pHideX - pAssistWidth, y = pHideY}, 0.2)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_assist, {x = pAssistX - pAssistWidth, y = pAssistY}, 0.2, function ()
            if callback then
                callback()
            end
            GUI:ActionHide()

            -- 110 任务栏引导主ID
            SL:SetValue("GUIDE_EVENT_END", 110)
        end)

        SL:onLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE, {assistSize = GUI:getContentSize(Panel_assist), bHide = true})
    else
        GUI:Timeline_EaseSineIn_MoveTo(Panel_hide, {x = pHideX, y = pHideY}, 0.2)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_assist, {x = pAssistX, y = pAssistY}, 0.2, function ()
            if callback then
                callback()
            end
            GUI:ActionShow()
            SL:SetValue("GUIDE_EVENT_BEGAN", 110, true)
        end)

        SL:onLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE, {assistSize = GUI:getContentSize(Panel_assist), bHide = false})
    end
end

-- 新增任务
function MainAssist.OnTaskAdd(data)
    local cell = MainAssist.CreateTaskCell(data)

    GUI:ListView_pushBackCustomItem(MainAssist._ui["ListView_task"], cell)

    MainAssist.UpdateTaskCellData(cell, data)

    MainAssist.UpdateTaskCellsOrder()
end

-- 任务删除
function MainAssist.OnTaskDel(data)
    local list   = MainAssist._ui["ListView_task"]
    local taskID = data.type

    local cell = GUI:getChildByTag(list, taskID)
    if not cell then
        return false
    end

    -- 移除cell
    local index = GUI:ListView_getItemIndex(list, cell)
    GUI:ListView_removeItemByIndex(list, index)

    MainAssist.UpdateTaskCellsOrder()
end

-- 任务替换
function MainAssist.OnTaskReplace(data)
    local list   = MainAssist._ui["ListView_task"]
    local taskID = data.type

    local cell = GUI:getChildByTag(list, taskID)
    if not cell then
        return false
    end

    local lastOrder = GUI:Win_GetParam(cell)
    local isUpdate  = MainAssist.UpdateTaskCellData(cell, data)
    local newOrder  = GUI:Win_GetParam(cell)

    if isUpdate or lastOrder ~= newOrder then
        MainAssist.UpdateTaskCellsOrder()
    end
end

-- 置顶任务
function MainAssist.OnTaskTop(topTaskID)
    MainAssist.UpdateTaskCellsOrder(topTaskID)
end

-- 更新任务cell
function MainAssist.UpdateTaskCellData(ui, data)
    GUI:Win_SetParam(ui, data.order or 0)

    local Node_1   = ui["Node_title"]
    local Node_2   = ui["Node_content"]
    local Node_sfx = ui["Node_sfx"]
    local img_line = ui["image_line"]
    local btn_act  = ui["Button_act"]

    local width    = 200

    local nodeX1   = GUI:getPositionX(Node_1)
    local nodeX2   = GUI:getPositionX(Node_2)

    local size     = SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE")

    -- head
    GUI:removeAllChildren(Node_1)
    local str1  = data.head.content
    local color = SL:GetHexColorByStyleId(data.head.color)
    local labHead = GUI:RichText_Create(Node_1, "rich", 0, 0, str1, width - nodeX1 * 2, size, color)
    GUI:setAnchorPoint(labHead, 0, 1)

    -- content
    GUI:removeAllChildren(Node_2)
    local str2  = data.body.content
    local color = SL:GetHexColorByStyleId(data.body.color)
    local labContent = GUI:RichText_Create(Node_2, "rich", 0, 0, str2, width - nodeX2 * 2, size, color)
    GUI:setAnchorPoint(labContent, 0, 1)

    -- sfx
    ui.sfx = nil
    GUI:removeAllChildren(Node_sfx)
    if data.animID then
        local sfx = GUI:Effect_Create(Node_sfx, "sfx", data.offsetX or 0, data.offsetY or 0, 0, data.animID)
        GUI:Effect_setGlobalElapseEnable(sfx, true)
        ui.sfx = sfx
    end

    -- 动态高度
    local lastHeight        = GUI:getContentSize(ui).height
    local labHeadHeight     = GUI:getContentSize(labHead).height
    local labContentHeight  = GUI:getContentSize(labContent).height
    local lineHeight        = GUI:getContentSize(img_line).height
    local height            = 15 + labHeadHeight + labContentHeight + lineHeight
    GUI:setContentSize(ui, width, height)
    GUI:setContentSize(btn_act, width, height)
    GUI:setPosition(btn_act, width / 2, height / 2)

    GUI:setPosition(Node_sfx, width / 2, height / 2)
    GUI:setPosition(Node_1, nodeX1, height - 5)
    GUI:setPosition(Node_2, nodeX2, height - labHeadHeight - 10)
    GUI:setPosition(img_line, width / 2, 0)

    return lastHeight ~= height
end

-- 任务置顶
function MainAssist.UpdateTaskCellsOrder(topTaskID)
    -- 数组化，方便接下来排序
    local cells = {}
    local list = MainAssist._ui["ListView_task"] 
    for i, cell in ipairs(GUI:getChildren(list)) do
        cells[i] = cell
    end
    table.sort(cells, function(a, b) return GUI:Win_GetParam(a) < GUI:Win_GetParam(a) end)

    local index = -1
    for k, v in ipairs(cells) do
        if topTaskID and topTaskID == GUI:getTag(v) then
            index = k
            break
        end
    end

    GUI:ListView_removeAllItems(list)

    local nCell = #cells
    
    for k, cell in ipairs(cells) do
        GUI:Retain(cell)

        if index == k then
            GUI:ListView_insertCustomItem(list, cell, 0)
        else
            GUI:ListView_pushBackCustomItem(list, cell)
        end

        if nCell == k then
            GUI:setVisible(cell["image_line"], false)
        else
            GUI:setVisible(cell["image_line"], true)
        end

        if cell.sfx then
            GUI:Effect_play(cell.sfx, 0, 0, true)
        end
    end

    GUI:ListView_doLayout(list)
end

-- 创建任务cell
function MainAssist.CreateTaskCell(data)
    local ui = GUI:LoadExportEx2("main/assist/main_assist_mission_cell", "mission_cell")
    GUI:ui_IterChilds(ui, ui)

    local taskID = data.type
    ui:setTag(taskID)

    -- 提交任务
    GUI:addOnClickEvent(ui["Button_act"], function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestSubmitMission(taskID)
    end)

    return ui
end

function MainAssist.OnMissionShow(value)
    GUI:setVisible(MainAssist._ui["ListView_task"], value == true)
end

-----------------------------------注册事件--------------------------------------
function MainAssist.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TASK_CHANGE, "MainAssist", MainAssist.OnTaskReplace)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_TO_TOP, "MainAssist", MainAssist.OnTaskTop)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_ADD, "MainAssist", MainAssist.OnTaskAdd)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_DEL, "MainAssist", MainAssist.OnTaskDel)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_SHOW, "MainAssist", MainAssist.OnMissionShow)
end

MainAssist.main()