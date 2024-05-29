MainAssist = {}

local tinsert = table.insert

MainAssist.PLAYER_COUNT  = 5    -- 最多显示5个玩家
MainAssist.MONSTER_COUNT = 5    -- 最多显示5个怪物
MainAssist.HERO_COUNT    = 5    -- 最多显示5个英雄

MainAssist.jobIconPath = {
    "res/private/main/assist/1900012533.png",
    "res/private/main/assist/1900012534.png",
    "res/private/main/assist/1900012535.png"
}

MainAssist.heroJobIconPath = {
    "res/private/main/assist/1900012537.png",
    "res/private/main/assist/1900012538.png",
    "res/private/main/assist/1900012539.png"
}

MainAssist.monsterIconPath = "res/private/main/assist/1900012536.png"
MainAssist.MissionFontSize = 14

MainAssist._hideAssist = false
MainAssist._missionCells = {}

function MainAssist.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/assist/main_assist")

    MainAssist._ui = GUI:ui_delegate(parent)

    local Panel_assist = MainAssist._ui["Panel_assist"]
    MainAssist._Panel_assist = Panel_assist
    MainAssist._assistPos = GUI:getPosition(Panel_assist)

    -- 是否隐藏
    local Panel_hide = MainAssist._ui["Panel_hide"]
    MainAssist._Panel_hide = Panel_hide
    MainAssist._hidePos = GUI:getPosition(Panel_hide)
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

    -- team
    MainAssist.InitTeam()
    MainAssist.UpdateTeamMember()

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

------------------------------TeamMember begin----------------------------------
function MainAssist.InitTeam()
    -- 创建
    GUI:addOnClickEvent(MainAssist._ui["Button_create"], function()
        SL:RequestCreateTeam()
    end)

    -- 附近队伍
    GUI:addOnClickEvent(MainAssist._ui["Button_near"], function()
        SL:OpenSocialUI(1)
    end)

    -- 成员
    GUI:addOnClickEvent(MainAssist._ui["Button_member"], function()
        SL:OpenSocialUI(2)
    end)

    -- 邀请
    GUI:addOnClickEvent(MainAssist._ui["Button_invite"], function()
        local memberCount = SL:GetMetaValue("TEAM_COUNT")
        local memberCountMax = SL:GetMetaValue("TEAM_MAC_COUNT")
        if memberCount >= memberCountMax then
            SL:ShowSystemTips("队伍已满")
        else
            SL:OpenTeamInvite()
        end
    end)
end

function MainAssist.UpdateTeamMember()
    MainAssist._teamMemberCells = {}
    local memberList = SL:GetMetaValue("TEAM_MEMBER_LIST")
    local memberCountMax = SL:GetMetaValue("TEAM_MAC_COUNT")
    local ListView_member = MainAssist._ui["ListView_member"]

    GUI:ListView_removeAllItems(ListView_member)

    -- 邀请
    GUI:Button_setBright(MainAssist._ui["Button_invite"], #memberList < memberCountMax)

    -- 队伍列表
    local title = "队伍列表" .. (#memberList > 0 and string.format("(%s/%s)", #memberList, memberCountMax) or "")
    GUI:Button_setTitleText(MainAssist._ui["Button_member"], title)

    GUI:setVisible(MainAssist._ui["Panel_empty"], #memberList == 0)
    GUI:setVisible(MainAssist._ui["Panel_member"], #memberList > 0)

    -- 成员列表
    if #memberList > 0 then
        for _, v in ipairs(memberList) do
            local cell = MainAssist.CreateTeamMemberCell(v)
            GUI:ListView_pushBackCustomItem(ListView_member, cell.quickUI.nativeUI)
            tinsert(MainAssist._teamMemberCells, cell)
        end
    end
end

function MainAssist.CreateTeamMemberCell(data)
    local parent = GUI:Node_Create(MainAssist._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "main/assist/main_assist_member_cell")
    local layout = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(layout)
    GUI:removeFromParent(parent)

    local quickUI = ui_delegate(layout)

    -- 点击选中，打开组队功能菜单
    GUI:addOnClickEvent(quickUI.nativeUI, function()
        SL:OpenFuncDockTips({
            type = SL:GetMetaValue("DOCKTYPE_NENUM").Func_Team,
            targetId = data.UserID,
            targetName = data.sUserName,
            pos = {x = GUI:getTouchEndPosition(quickUI.nativeUI).x + 20, y = GUI:getTouchEndPosition(quickUI.nativeUI).y}
        })
    end)

    GUI:setIgnoreContentAdaptWithSize(quickUI.Image_job, true)
    GUI:Image_loadTexture(quickUI.Image_job, MainAssist.jobIconPath[data.Job + 1])

    GUI:Text_setString(quickUI.Text_name, data.sUserName)

    GUI:setVisible(quickUI.Image_leader, data.Rand == 1)

    local setLevelStr = quickUI.Text_level:getString()
    local hasFormat = string.find(setLevelStr, "%%s") or string.find(setLevelStr, "%%d")
    local showStr = hasFormat and string.format(setLevelStr, data.Level) or (setLevelStr .. data.Level)
    GUI:Text_setString(quickUI.Text_level, showStr)

    local function callback()
        local actor = SL:GetMetaValue("ACTOR_DATA", data.UserID)
        if not actor then
            GUI:setVisible(quickUI.Text_status, true)
            GUI:Text_setString(quickUI.Text_status, "远离")

            GUI:Image_setGrey(quickUI.LoadingBar_hp, true)
            GUI:Image_setGrey(quickUI.LoadingBar_mp, true)
        else
            if (SL:GetMetaValue("ACTOR_IS_DIE", actor)) then
                GUI:setVisible(quickUI.Text_status, true)
                GUI:Text_setString(quickUI.Text_status, "死亡")

                GUI:Image_setGrey(quickUI.LoadingBar_hp, true)
                GUI:Image_setGrey(quickUI.LoadingBar_mp, true)
                GUI:LoadingBar_setPercent(quickUI.LoadingBar_hp, 0)
            else
                GUI:setVisible(quickUI.Text_status, false)

                GUI:Image_setGrey(quickUI.LoadingBar_hp, false)
                GUI:Image_setGrey(quickUI.LoadingBar_mp, false)

                local hpPercent = math.floor(SL:GetMetaValue("ACTOR_HP", actor) / SL:GetMetaValue("ACTOR_MAXHP", actor) * 100)
                GUI:LoadingBar_setPercent(quickUI.LoadingBar_hp, hpPercent)

                local mpPercent = math.floor((SL:GetMetaValue("ACTOR_MP", actor) or 0) / (SL:GetMetaValue("ACTOR_MAXMP", actor) or 1) * 100)
                GUI:LoadingBar_setPercent(quickUI.LoadingBar_mp, mpPercent)
            end
        end
    end

    SL:schedule(quickUI.nativeUI, callback, 0.5)
    callback()

    return {
        quickUI = quickUI
    }
end
-------------------------------TeamMember end-----------------------------------

---------------------------------Enemy begin------------------------------------
function MainAssist.CreateEnemyCell(parent, data)
    GUI:LoadExport(parent, "main/assist/main_assist_enemy_cell")

    local layout = GUI:getChildByName(parent, "enemy_cell")
    if not layout then
        return
    end
    if not data or not data.actorID then
        return
    end
    GUI:removeFromParent(layout)

    local actorID      = data.actorID
    local ui           = GUI:ui_delegate(layout)
    local textName     = ui.Text_name
    local imageName    = ui.Image_name
    local imageIcon    = ui.Image_icon
    local imageTarget  = ui.Image_target
    local loadingBarHp = ui.LoadingBar_hp

    if textName then
        GUI:removeAllChildren(textName)
        local actorName = SL:GetMetaValue("ACTOR_NAME", actorID)
        if actorName and SL:GetUTF8ByteLen(actorName) > 7 then
            GUI:Text_setString(textName, "")
            local scrollLabel = GUI:ScrollText_Create(textName, "scrollText", 0, 0, 115, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", actorName)
            GUI:setAnchorPoint(scrollLabel, 0.5, 0.5)
        else
            GUI:Text_setString(textName, actorName)
        end
    end

    local curHP = SL:GetMetaValue("ACTOR_HP", actorID)
    local maxHP = SL:GetMetaValue("ACTOR_MAXHP", actorID)
    local percent = math.floor((curHP / maxHP * 100))
    if loadingBarHp then
        GUI:LoadingBar_setPercent(loadingBarHp, percent)
    end

    if imageIcon then
        if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) then
            local job = SL:GetMetaValue("ACTOR_JOB_ID", actorID)
            if SL:GetMetaValue("ACTOR_IS_HERO", actorID) then
                if MainAssist.heroJobIconPath then
                    GUI:Image_loadTexture(imageIcon, MainAssist.heroJobIconPath[job + 1])
                end
            else
                if MainAssist.jobIconPath then
                    GUI:Image_loadTexture(imageIcon, MainAssist.jobIconPath[job + 1])
                end
            end
        else
            GUI:Image_loadTexture(imageIcon, MainAssist.monsterIconPath)
        end
    end

    if imageTarget then
        GUI:setVisible(imageTarget, SL:GetMetaValue("SELECT_TARGET_ID") == actorID)
    end

    GUI:addOnClickEvent(layout, function()
        SL:SetMetaValue("SELECT_TARGET_ID", actorID)
    end)

    GUI:setVisible(layout, true)

    return {
        data         = data,
        layout       = layout,
        textName     = textName,
        imageTarget  = imageTarget,
        loadingBarHp = loadingBarHp,
    }
end
----------------------------------Enemy end-------------------------------------

-----------------------------------注册事件--------------------------------------
function MainAssist.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_TOP, "MainAssist", MainAssist.onMissionItemTop)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_ADD, "MainAssist", MainAssist.onMissionItemAdd)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_CHANGE, "MainAssist", MainAssist.onMissionItemChange)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_REMOVE, "MainAssist", MainAssist.onMissionItemRemove)
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_MISSION_SHOW, "MainAssist", MainAssist.onMissionShow)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "MainAssist", MainAssist.UpdateTeamMember)
end