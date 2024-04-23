MainAssist = {}

local jobIconPaths = {"res/private/main/assist/1900012533.png", "res/private/main/assist/1900012534.png", "res/private/main/assist/1900012535.png"}
local monsterIconPath = "res/private/main/assist/1900012536.png"

local PLAYER_COUNT  = 5
local MONSTER_COUNT = 5

-- 怪物权重
local GetWeight = function(actorID)
    local weight = 0
    if SL:GetMetaValue("ACTOR_IS_ESCORT", actorID) then         -- 镖车
        weight = 4
    elseif SL:GetMetaValue("ACTOR_IS_BOSS", actorID) then       -- BOSS
        weight = 3
    elseif SL:GetMetaValue("ACTOR_IS_ELITE", actorID) then      -- 精英
        weight = 2
    elseif SL:GetMetaValue("ACTOR_IS_MONSTER", actorID) and not SL:GetMetaValue("ACTOR_HAVE_MASTER", actorID) then  -- 怪物
        weight = 1
    end
    return weight
end

-- 血量进度条
local SetLoadingBarHp = function(bar, actorID)
    local curHp = SL:GetMetaValue("ACTOR_HP", actorID)
    local maxHp = SL:GetMetaValue("ACTOR_MAXHP", actorID)
    GUI:LoadingBar_setPercent(bar, maxHp > 0 and math.floor((curHp / maxHp * 100)) or 0)
end

-- 蓝量进度条
local SetLoadingBarMp = function(bar, actorID)
    local curHp = SL:GetMetaValue("ACTOR_MP", actorID)
    local maxHp = SL:GetMetaValue("ACTOR_MAXMP", actorID)
    GUI:LoadingBar_setPercent(bar, maxHp > 0 and math.floor((curHp / maxHp * 100)) or 0)
end

-- 入口函数
function MainAssist.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/assist/assist")

    MainAssist._ui = GUI:ui_delegate(parent)
    if not MainAssist._ui then
        return false
    end
    GUI:setPositionY(parent, -35)

    -- 任务栏是否隐藏
    MainAssist._hideAssist = false
    MainAssist._assistPos  = GUI:getPosition(MainAssist._ui["Panel_assist"])
    MainAssist._hidePos    = GUI:getPosition(MainAssist._ui["Panel_hide"])

    MainAssist.RegisterEvent()

    MainAssist.InitEvent()
    MainAssist.InitAssist()
    MainAssist.InitTeam()
    MainAssist.InitEnemy()
end

-- 事件监听注册
function MainAssist.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW, "MainAssist", MainAssist.OnActorInOfView)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainAssist", MainAssist.OnActorOutOfView)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE, "MainAssist", MainAssist.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE, "MainAssist", MainAssist.OnActorPlayerDie)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE, "MainAssist", MainAssist.OnActorMonsterDie)
    SL:RegisterLUAEvent(LUA_EVENT_PKMODECHANGE, "MainAssist", MainAssist.OnPlayerPKStateChange)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH, "MainAssist", MainAssist.OnRefreshActorHP)
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CAHNGE, "MainAssist", MainAssist.OnTargetChange)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_REPLACE, "MainAssist", MainAssist.OnTaskReplace)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_TO_TOP, "MainAssist", MainAssist.OnTaskTop)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_ADD, "MainAssist", MainAssist.OnTaskAdd)
    SL:RegisterLUAEvent(LUA_EVENT_TASK_DEL, "MainAssist", MainAssist.OnTaskDel)
    SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "MainAssist", MainAssist.UpdateTeamMember)
end

-- 初始化事件
function MainAssist.InitEvent()
    -- 折叠、展开
    GUI:addOnClickEvent(MainAssist._ui["Button_hide"], function ()
        MainAssist.ChangeHideStatus({status = not MainAssist._hideAssist})
    end)

    -- 切换按钮
    GUI:addOnClickEvent(MainAssist._ui["Button_change"], function ()
        local group = MainAssist._assistGroup == 1 and 2 or 1
        MainAssist.ChangeAssistGroup(group)
        MainAssist.CalcAssistShow()
    end)

    -- 任务
    GUI:addOnClickEvent(MainAssist._ui["Button_task"], function ()
        MainAssist.ChangeContentIndex(1)
        MainAssist.CalcAssistShow()
    end)

    -- 组队
    GUI:addOnClickEvent(MainAssist._ui["Button_team"], function ()
        MainAssist.ChangeContentIndex(2)
        MainAssist.CalcAssistShow()
    end)

    -- 人物
    GUI:addOnClickEvent(MainAssist._ui["Button_player"], function ()
        MainAssist.ChangeEnemyIndex(1)
        MainAssist.CalcAssistShow()
    end)

    -- 怪物
    GUI:addOnClickEvent(MainAssist._ui["Button_monster"], function ()
        MainAssist.ChangeEnemyIndex(2)
        MainAssist.CalcAssistShow()
    end)
end

-- Assist
function MainAssist.InitAssist()
    MainAssist._assistGroup  = 0        -- 活动 2任务组队 1附近列表  
    MainAssist._contentIndex = 0        -- 任务组队显示索引 1任务 2组队
    MainAssist._enemyIndex   = 0        -- 人物怪物显示索引 1玩家 2怪物

    MainAssist.ChangeAssistGroup(2)
    MainAssist.ChangeContentIndex(1)
    MainAssist.ChangeEnemyIndex(1)
    MainAssist.CalcAssistShow()
end

-- 组队
function MainAssist.InitTeam()
    -- 邀请
    GUI:addOnClickEvent(MainAssist._ui["Button_invite"], function ()
        if SL:GetTeamMemberCount() >= SL:GetTeamMax() then
            return SL:ShowSystemTips("队伍已满")
        end
        SL:OpenTeamInvite()
    end)

    -- 成员
    GUI:addOnClickEvent(MainAssist._ui["Button_member"], function ()
        SL:OpenSocialUI(1)
    end)

    -- 创建
    GUI:addOnClickEvent(MainAssist._ui["Button_create"], function ()
        SL:CreateTeam()
    end)

    -- 附近队伍
    GUI:addOnClickEvent(MainAssist._ui["Button_near"], function ()
        SL:OpenSocialUI({index = 2, page = 2})
    end)

    -- 初始化组队界面
    MainAssist.UpdateTeamMember()
end

-- 玩家、怪物
function MainAssist.InitEnemy()
    MainAssist._playerCells  = {}
    MainAssist._monsterCells = {}

    GUI:ListView_removeAllItems(MainAssist._ui["ListView_player"])
    GUI:ListView_removeAllItems(MainAssist._ui["ListView_monster"])

    -- 1s检测一次
    SL:PerformWithDelayGlobal(function ()
        MainAssist.CheckAllEnemy()
    end, 1)
end

-- 是否是自己
function MainAssist.IsMe(actorID)
    return actorID == SL:GetMetaValue("USERID")
end

-- 复活
function MainAssist.OnActorRevive(data)
    if MainAssist.IsMe(data.actorID) then
        return false
    end
    MainAssist._updateActorAble = true
end

-- 进视野
function MainAssist.OnActorInOfView(data)
    if MainAssist.IsMe(data.actorID) then
        return false
    end
    MainAssist._updateActorAble = true
end

-- 出视野
function MainAssist.OnActorOutOfView(data)
    local actorID = data.actorID
    if MainAssist.IsMe(actorID) then
        return false
    end
    MainAssist._updateActorAble = true

    if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) then
        MainAssist.RmvPlayer(data)
    elseif SL:GetMetaValue("ACTOR_IS_MONSTER", actorID) then
        MainAssist.RmvMonster(data)
    end
end

-- 玩家死亡，非自己
function MainAssist.OnActorPlayerDie(data)
    MainAssist._updateActorAble = true
    MainAssist.RmvPlayer(data)
end

-- 怪物死亡
function MainAssist.OnActorMonsterDie(data)
    MainAssist._updateActorAble = true
    MainAssist.RmvMonster(data)
end

-- 玩家PK模式发生变化, 刷新附近列表
function MainAssist.OnPlayerPKStateChange()
    if MainAssist._enemyIndex ~= 1 then
        return false
    end

    GUI:ListView_removeAllItems(MainAssist._ui["ListView_player"])
    MainAssist._playerCells = {}
    MainAssist.AutoAddPlayer()
end

-- 血量刷新
function MainAssist.OnRefreshActorHP(data)
    local actorID = data.actorID

    if not ((MainAssist._enemyIndex == 1 and SL:GetMetaValue("ACTOR_IS_PLAYER", actorID)) or (MainAssist._enemyIndex == 2 and SL:GetMetaValue("ACTOR_IS_MONSTER", actorID))) then
        return false
    end

    local cell = MainAssist._enemyIndex == 1 and MainAssist._playerCells[actorID] or MainAssist._monsterCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    SetLoadingBarHp(cell["LoadingBar_hp"], actorID)
end

-- 目标发生改变
function MainAssist.OnTargetChange(targetID)
    local cells = MainAssist._enemyIndex == 1 and MainAssist._playerCells or MainAssist._monsterCells
    for k, v in pairs(cells) do
        GUI:setVisible(v["Image_target"], k == targetID)
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

-- 队伍信息
function MainAssist.UpdateTeamMember()
    local members = SL:GetMetaValue("TEAM_MEMBER_LIST") or {}
    local nCount  = #members
    local maxNum  = SL:GetTeamMax()

    GUI:ListView_removeAllItems(MainAssist._ui["ListView_member"])

    -- 邀请
    GUI:Button_setBright(MainAssist._ui["Button_invite"], nCount < maxNum)

    -- 队伍列表
    local title = "队伍列表" .. (nCount > 0 and string.format("(%s/%s)", nCount, maxNum) or "")
    GUI:Button_setTitleText(MainAssist._ui["Button_member"], title)

    GUI:setVisible(MainAssist._ui["Panel_empty"], nCount == 0)
    GUI:setVisible(MainAssist._ui["Panel_member"], nCount > 0)

    for _, v in ipairs(members) do
        local cell = MainAssist.CreateTeamMemberCell(v)
        GUI:ListView_pushBackCustomItem(MainAssist._ui["ListView_member"], cell)
    end
end

-- 任务、组队选择操作
function MainAssist.ChangeContentIndex(index)
    MainAssist._contentIndex = index

    GUI:Button_setBright(MainAssist._ui["Button_task"], index == 1)
    GUI:setTouchEnabled(MainAssist._ui["Button_task"], index == 2)
    
    GUI:setTouchEnabled(MainAssist._ui["Button_team"], index == 1)
    GUI:Button_setBright(MainAssist._ui["Button_team"], index == 2)
end

-- 玩家、怪物选择操作
function MainAssist.ChangeEnemyIndex(index)
    MainAssist._enemyIndex = index

    GUI:setTouchEnabled(MainAssist._ui["Button_player"], index == 2)
    GUI:Button_setBright(MainAssist._ui["Button_player"], index == 1)
    GUI:setTouchEnabled(MainAssist._ui["Button_monster"], index == 1)
    GUI:Button_setBright(MainAssist._ui["Button_monster"], index == 2)

    MainAssist.UpdateAllEnemy()
end

-- 切换
function MainAssist.ChangeAssistGroup(g)
    MainAssist._assistGroup = g

    GUI:setVisible(MainAssist._ui["BtnG_enemy"], g == 1)
    GUI:setVisible(MainAssist._ui["BtnG_content"], g == 2)
end

function MainAssist.CalcAssistShow()
    GUI:setVisible(MainAssist._ui["Panel_enemy"], MainAssist._assistGroup == 1)
    GUI:setVisible(MainAssist._ui["Panel_content"], MainAssist._assistGroup == 2)

    -- 任务组队
    GUI:setVisible(MainAssist._ui["Panel_task"], MainAssist._contentIndex == 1)
    GUI:setVisible(MainAssist._ui["Panel_team"], MainAssist._contentIndex == 2)

    -- 附近列表
    GUI:setVisible(MainAssist._ui["Panel_player"], MainAssist._enemyIndex == 1)
    GUI:setVisible(MainAssist._ui["Panel_monster"], MainAssist._enemyIndex == 2) 
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
        end)
    else
        GUI:Timeline_EaseSineIn_MoveTo(Panel_hide, {x = pHideX, y = pHideY}, 0.2)
        GUI:Timeline_EaseSineIn_MoveTo(Panel_assist, {x = pAssistX, y = pAssistY}, 0.2, function ()
            if callback then
                callback()
            end
            GUI:ActionShow()
        end)
    end
end

-- 创建组队cell
function MainAssist.CreateTeamMemberCell(data)
    local ui = GUI:LoadExportEx("main/assist/cell_member", "member_cell")
    GUI:ui_IterChilds(ui, ui)

    local actorID  = data.UserID
    local userName = data.sUserName
    local job      = data.Job
    local level    = data.Level
    local isLeader = data.Rand == 1      -- 是否是队长

    -- 职业图标
    GUI:setIgnoreContentAdaptWithSize(ui["Image_job"], true)
    GUI:Image_loadTexture(ui["Image_job"], jobIconPaths[job + 1])

    -- 名字
    GUI:Text_setString(ui["Text_name"], userName)

    -- 等级
    GUI:Text_setString(ui["Text_level"], string.format("Lv:%s", level))

    -- 队长标记
    GUI:setVisible(ui["Image_leader"], isLeader)

    -- 点击选中
    GUI:addOnClickEvent(ui, function ()
        SL:OpenFuncDockTips({
            type = SL:EnumDockType().Func_Team, targetId = actorID, targetName = userName, pos = {x = GUI:getTouchEndPosition(ui).x + 20, y = GUI:getTouchEndPosition(ui).y}
        })
    end)

    local Text_status   = ui["Text_status"]
    local LoadingBar_hp = ui["LoadingBar_hp"]
    local LoadingBar_mp = ui["LoadingBar_mp"]

    local function callback()
        if SL:GetMetaValue("ACTOR_DATA", actorID) then
            if SL:GetMetaValue("ACTOR_IS_DIE", actorID) then
                GUI:setVisible(Text_status, true)
                GUI:Text_setString(Text_status, "死亡")

                GUI:setGrey(LoadingBar_hp, true)
                GUI:setGrey(LoadingBar_mp, true)

                GUI:LoadingBar_setPercent(LoadingBar_hp, 0)
            else
                GUI:setVisible(Text_status, false)

                GUI:setGrey(LoadingBar_hp, false)
                GUI:setGrey(LoadingBar_mp, false)

                SetLoadingBarHp(LoadingBar_hp, actorID)
                SetLoadingBarMp(LoadingBar_mp, actorID)
            end
        else
            GUI:setVisible(Text_status, true)
            GUI:Text_setString(Text_status, "远离")

            GUI:setGrey(LoadingBar_hp, true)
            GUI:setGrey(LoadingBar_mp, true)
        end    
    end

    SL:schedule(ui, callback, 0.5)

    callback()

    return ui
end

-- 更新任务cell
function MainAssist.UpdateTaskCellData(ui, data)
    GUI:Win_SetParam(ui, data.order or 0)

    local Node_1   = ui["Node_1"]
    local Node_2   = ui["Node_2"]
    local Node_sfx = ui["Node_sfx"]
    local img_line = ui["image_line"]
    local btn_act  = ui["Button_act"]

    local width    = 200

    local nodeX1   = GUI:getPositionX(Node_1)
    local nodeX2   = GUI:getPositionX(Node_2)

    local size     = SL:GetGameData("DEFAULT_FONT_SIZE")

    -- head
    GUI:removeAllChildren(Node_1)
    local str1  = data.head.content
    local color = SL:GetColorByID(data.head.color)
    local labHead = GUI:RichText_Create(Node_1, "rich", 0, 0, str1, width - nodeX1 * 2, size, color)
    GUI:setAnchorPoint(labHead, 0, 1)

    -- content
    GUI:removeAllChildren(Node_2)
    local str2  = data.body.content
    local color = SL:GetColorByID(data.body.color)
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
    local ui = GUI:LoadExportEx("main/assist/cell_task", "task_cell")
    GUI:ui_IterChilds(ui, ui)

    local taskID = data.type
    ui:setTag(taskID)

    -- 提交任务
    GUI:addOnClickEvent(ui["Button_act"], function ()
        SL:SubmitTask(taskID)
    end)

    return ui
end

-- 添加玩家
function MainAssist.AddPlayer(data)
    local actorID = data.actorID

    if MainAssist._playerCells[actorID] then
        return false
    end

    if SL:GetMetaValue("ACTOR_IS_DIE", actorID) then
        return false
    end

    if not SL:checkLaunchTargetByID(actorID) then
        return false
    end
    
    local listview = MainAssist._ui["ListView_player"]
    local items    = GUI:ListView_getItems(listview)
    local nItems   = #items
    if nItems >= PLAYER_COUNT then
        return false
    end

    -- 找到插入位置
    local index = nItems
    for playerID, cell in pairs(MainAssist._playerCells) do
        if SL:GetMetaValue("ACTOR_LEVEL", actorID) > SL:GetMetaValue("ACTOR_LEVEL", playerID) then
            index = math.min(index, GUI:ListView_getItemIndex(listview, cell))
        end
    end

    local cell = MainAssist.CreateEnemyCell(actorID)
    GUI:ListView_insertCustomItem(listview, cell, index)

    MainAssist._playerCells[actorID] = cell
end

-- 添加玩家
function MainAssist.AutoAddPlayer()
    if MainAssist._enemyIndex ~= 1 then
        return false
    end

    local listview = MainAssist._ui["ListView_player"]
    local items    = GUI:ListView_getItems(listview)
    if #items >= PLAYER_COUNT then
        return false
    end

    local actors, ncount = SL:GetPlayerInViewField()
    for i = 1, ncount do
        MainAssist.AddPlayer({actorID = actors[i]})
        MainAssist.AutoRmvPlayer()
    end
end

-- 移除玩家
function MainAssist.RmvPlayer(data)
    local actorID = data.actorID

    if MainAssist._enemyIndex ~= 1 then
        return false
    end

    local cell = MainAssist._playerCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    local listview = MainAssist._ui["ListView_player"]
    GUI:ListView_removeItemByIndex(listview, GUI:ListView_getItemIndex(listview, cell))

    MainAssist._playerCells[actorID] = nil
end

-- 移除玩家
function MainAssist.AutoRmvPlayer()
    local listview = MainAssist._ui["ListView_player"]
    local items    = GUI:ListView_getItems(listview)
    if #items <= PLAYER_COUNT then
        return false
    end

    local delActorID = nil
    for playerID, _ in pairs(MainAssist._playerCells) do
        if nil == delActorID then
            delActorID = playerID
        elseif SL:GetMetaValue("ACTOR_LEVEL", delActorID) > SL:GetMetaValue("ACTOR_LEVEL", playerID) then
            delActorID = playerID
        end
    end

    if delActorID then
        MainAssist.RmvPlayer({actorID = delActorID})
    end
end

-- 添加怪物
function MainAssist.AddMonster(data)
    local actorID = data.actorID

    if MainAssist._monsterCells[actorID] then
        return false
    end

    if SL:GetMetaValue("ACTOR_IS_DIE", actorID) then
        return false
    end

    if SL:GetMetaValue("ACTOR_IS_BORN", actorID) then
        return false
    end
    
    if not SL:checkLaunchTargetByID(actorID) then
        return false
    end

    -- 权重
    local wight = GetWeight(actorID)

    local listview = MainAssist._ui["ListView_monster"]
    local items    = GUI:ListView_getItems(listview)
    local nItems   = #items
    if nItems >= MONSTER_COUNT and wight == 0 then
        return false
    end

    -- 根据怪物权值找到插入位置
    local index = nItems
    for monsterID, cell in pairs(MainAssist._monsterCells) do
        if wight > GetWeight(monsterID) then
            index = math.min(index, GUI:ListView_getItemIndex(listview, cell))
        end
    end

    local cell = MainAssist.CreateEnemyCell(actorID)
    GUI:ListView_insertCustomItem(listview, cell, index)

    MainAssist._monsterCells[actorID] = cell
end

-- 添加怪物
function MainAssist.AutoAddMonster()
    if MainAssist._enemyIndex ~= 2 then
        return false
    end

    local listview = MainAssist._ui["ListView_monster"]
    local items    = GUI:ListView_getItems(listview)
    if #items >= MONSTER_COUNT then
        return false
    end

    local actors, nActor = SL:GetMonsterInViewField()
    
    local playerVec, nPlayer = SL:GetPlayerInViewField()
    for i = 1, nPlayer do
        local playerID = playerVec[i]
        if SL:GetMetaValue("ACTOR_IS_HUMAN", playerID) then
            nActor = nActor + 1
            actors[nActor] = playerID
        end
    end

    for i = 1, nActor do
        local actorID = actors[i]
        if actorID then
            MainAssist.AddMonster({actorID = actorID})
            MainAssist.AutoRmvMonster()
        end
    end
end

-- 移除怪物
function MainAssist.RmvMonster(data)
    local actorID = data.actorID

    if MainAssist._enemyIndex ~= 2 then
        return false
    end

    local cell = MainAssist._monsterCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    local listview = MainAssist._ui["ListView_monster"]
    GUI:ListView_removeItemByIndex(listview, GUI:ListView_getItemIndex(listview, cell))

    MainAssist._monsterCells[actorID] = nil
end

-- 移除怪物
function MainAssist.AutoRmvMonster()
    local listview = MainAssist._ui["ListView_monster"]
    local items    = GUI:ListView_getItems(listview)
    if #items <= MONSTER_COUNT then
        return false
    end

    local delActorID = nil
    local wight = nil
    for monsterID, _ in pairs(MainAssist._monsterCells) do
        wight = GetWeight(monsterID)
        if wight == 0 then
            delActorID = monsterID
            break
        end
        if not delActorID or wight < GetWeight(delActorID) then
            delActorID = monsterID
        end
    end

    if delActorID then
        MainAssist.RmvMonster({actorID = delActorID})
    end
end

-- 更新玩家、怪物列表
function MainAssist.UpdateAllEnemy()
    GUI:ListView_removeAllItems(MainAssist._ui["ListView_player"])
    GUI:ListView_removeAllItems(MainAssist._ui["ListView_monster"])

    MainAssist._playerCells  = {}
    MainAssist._monsterCells = {}

    if MainAssist._enemyIndex == 1 then
        MainAssist.AutoAddPlayer()
    elseif MainAssist._enemyIndex == 2 then
        MainAssist.AutoAddMonster()
    end
end

-- 检测玩家、怪物
function MainAssist.CheckAllEnemy()
    if not MainAssist._updateActorAble then
        return false
    end
    MainAssist._updateActorAble = false

    if MainAssist._enemyIndex == 1 then
        MainAssist.AutoAddPlayer()
    elseif MainAssist._enemyIndex == 2 then
        MainAssist.AutoAddMonster()
    end
end

-- 创建玩家、怪物cell
function MainAssist.CreateEnemyCell(actorID)
    local ui = GUI:LoadExportEx("main/assist/cell_enemy", "enemy_cell")
    GUI:ui_IterChilds(ui, ui)

    local imageIcon     = ui["Image_icon"]
    local imageTarget   = ui["Image_target"]
    local textName      = ui["Text_name"]
    local LoadingBar_hp = ui["LoadingBar_hp"]

    -- 名字
    GUI:Text_setString(textName, "")
    local scrollText = GUI:ScrollText_Create(textName, "scrollText", 0, -1, 115, 14, "#ffffff", SL:GetMetaValue("ACTOR_NAME", actorID))
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)

    SetLoadingBarHp(LoadingBar_hp, actorID)

    if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) then
        GUI:Image_loadTexture(imageIcon, jobIconPaths[SL:GetMetaValue("ACTOR_JOB_ID", actorID) + 1])
    else
        GUI:Image_loadTexture(imageIcon, monsterIconPath)
    end

    GUI:setVisible(imageTarget, SL:GetSelTargetID() == actorID)

    GUI:addOnClickEvent(ui, function ()
        SL:SetTargetID(actorID)
    end)

    return ui
end