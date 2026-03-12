MainNear = {}

local PLAYER_COUNT  = 15    -- 最多显示15个玩家
local MONSTER_COUNT = 15    -- 最多显示15个怪物
local HERO_COUNT    = 15    -- 最多显示15个英雄

local jobIconPaths = {
    "res/private/main/assist/1900012533.png",
    "res/private/main/assist/1900012534.png",
    "res/private/main/assist/1900012535.png"
}
local heroJobIconPath = {
    "res/private/main/assist/1900012537.png",
    "res/private/main/assist/1900012538.png",
    "res/private/main/assist/1900012539.png"
}

local titles = {
    "怪物",
    "人物",
    "英雄"
}

-- 怪物权重
local GetWeight = function(actorID)
    local weight = 0
    if SL:GetValue("ACTOR_IS_ESCORT", actorID) then         -- 镖车
        weight = 4
    elseif SL:GetValue("ACTOR_IS_BOSS", actorID) then       -- BOSS
        weight = 3
    elseif SL:GetValue("ACTOR_IS_ELITE", actorID) then      -- 精英
        weight = 2
    elseif SL:GetValue("ACTOR_IS_MONSTER", actorID) and not SL:GetValue("ACTOR_HAVE_MASTER", actorID) then  -- 怪物
        weight = 1
    end
    return weight
end


MainNear._type = nil
MainNear._typeBtnList = {}
MainNear._selectType = 1

-- 血量进度条
local SetLoadingBarHp = function(bar, actorID)
    local curHp = SL:GetValue("ACTOR_HP", actorID)
    local maxHp = SL:GetValue("ACTOR_MAXHP", actorID)
    GUI:LoadingBar_setPercent(bar, maxHp > 0 and math.floor((curHp / maxHp * 100)) or 0)
end

function MainNear.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.MainNearGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "main/main_near_panel")
    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    MainNear._ui = ui
    MainNear._parent = parent

    local Panel_1 = MainNear._ui["Panel_1"]
    local pSize = GUI:getContentSize(Panel_1)
    -- 显示适配
    GUI:setPosition(Panel_1, SL:GetValue("SCREEN_WIDTH") / 2, SL:GetValue("PC_POS_Y") + pSize.height / 2)

    -- 设置拖拽
    GUI:Win_SetDrag(parent, Panel_1)

    if tonumber(SL:GetValue("GAME_DATA", "syshero")) == 1 then
        MainNear._type = 3
    else
        MainNear._type = 2
    end

    GUI:Win_SetCloseCB(parent, MainNear.OnClose)

    MainNear._listView  = MainNear._ui["ListView_1"]
    MainNear._listTitles = MainNear._ui["ListView_title"]
    GUI:setSwallowTouches(MainNear._listView)

    GUI:addOnTouchEvent(MainNear._ui["Panel_can_touch"], MainNear.OnTouchCallback)
    GUI:setSwallowTouches(MainNear._ui["Panel_can_touch"], false)

    MainNear.Init()
    MainNear.InitUI()

    MainNear.RegisterEvent()
end

function MainNear.OnClose()
    MainNear.UnRegisterEvent()
end

function MainNear.Init()
    MainNear._playerCells  = {}
    MainNear._monsterCells = {}
    MainNear._heroCells    = {}
    MainNear._checkHero    = tonumber(SL:GetValue("GAME_DATA","syshero")) == 1

    GUI:ListView_removeAllItems(MainNear._listView)
    
    -- 1s检测一次
    SL:schedule(MainNear._ui["Panel_bg"], function()
        MainNear.CheckAllNear()
    end, 1)
end

function MainNear.InitUI()
    local btnType = MainNear._ui["Button_type"..MainNear._type]
    if not btnType then
        return false
    end

    for i = 1, MainNear._type do
        local btn = GUI:Clone(btnType)
        GUI:ListView_pushBackCustomItem(MainNear._listTitles, btn)

        GUI:setVisible(btn, true)
        GUI:Button_setTitleText(btn, titles[i])

        MainNear._typeBtnList[i] = btn

        if i ~= MainNear._type then
            -- 标题按钮分割线
            GUI:Image_Create(MainNear._listTitles, "line"..i, 0, 0, "res/private/main/assist/near_panel/line.png")
        end

        GUI:addOnClickEvent(btn, function ()
            if MainNear._selectType ~= i then
                MainNear._selectType = i
                MainNear.OnRefreshBtnShow()
                MainNear.OnShowContent()
            end
        end)
    end

    local sizeW = 0
    for _, v in ipairs(GUI:getChildren(MainNear._listTitles)) do
        sizeW = sizeW + GUI:getContentSize(v).width
    end
    GUI:setContentSize(MainNear._listTitles, sizeW, GUI:getContentSize(MainNear._listTitles).height)

    MainNear.OnRefreshBtnShow()
    MainNear.OnShowContent()
end

function MainNear.OnTouchCallback(sender, eventType)
    MainNear._panelBghgt = MainNear._panelBghgt or GUI:getContentSize(MainNear._ui["Panel_bg"]).height

    local worldPosY = GUI:getWorldPosition(sender).y
    local bgSize = GUI:getContentSize(MainNear._ui["Panel_bg"])
    local maxHeight = bgSize.height + worldPosY + 10
    local minHeight = 171

    if eventType == 0 then
        GUI:setTouchEnabled(MainNear._ui["Panel_1"], false)
        MainNear._beginPos = GUI:getTouchBeganPosition(sender)
    elseif eventType == 1 then
        if not MainNear._beginPos then
            return false
        end
        
        local diffY  = GUI:getTouchMovePosition(sender).y - MainNear._beginPos.y
        local height = MainNear._panelBghgt - diffY 
        height = math.min(maxHeight, height)
        height = math.max(minHeight, height)

        local listSize = GUI:getContentSize(MainNear._listView)
        GUI:setContentSize(MainNear._listView, listSize.width, height)

        GUI:setContentSize(MainNear._ui["Panel_bg"], bgSize.width, height)
        GUI:setContentSize(MainNear._ui["Panel_1"], GUI:getContentSize(MainNear._ui["Panel_1"]).width , height + 29)

        GUI:setPositionY(MainNear._ui["Panel_title"], height + 29)
        GUI:setPositionY(MainNear._ui["Image_1"], height + 29)
    elseif eventType == 2 or eventType == 3 then
        MainNear._panelBghgt = GUI:getContentSize(MainNear._ui["Panel_bg"]).height
        GUI:setTouchEnabled(MainNear._ui["Panel_1"], true)
    end
end

function MainNear.OnRefreshBtnShow()
    for i, btn in pairs(MainNear._typeBtnList) do
        GUI:Button_setBright(btn, i ~= MainNear._selectType)
    end
end

function MainNear.OnShowContent()
    MainNear.UpdateAllNear()
end

function MainNear.UpdateList()
    if MainNear._selectType == 1 then
        MainNear.AutoAddMonster()
    
    elseif MainNear._selectType == 2 then
        MainNear.AutoAddPlayer()

    elseif MainNear._selectType == 3 and MainNear._checkHero then
        MainNear.AutoAddHero()
    end
end

function MainNear.CheckAllNear()
    if not MainNear._updateAble then
        return nil
    end
    MainNear._updateAble = false

    MainNear.UpdateList()
end

function MainNear.UpdateAllNear()
    MainNear._playerCells  = {}
    MainNear._monsterCells = {}
    MainNear._heroCells    = {}
    GUI:ListView_removeAllItems(MainNear._listView)

    MainNear.UpdateList()
end

-- 创建玩家、怪物cell
function MainNear.CreateEnemyCell(actorID)
    local ui = GUI:LoadExportEx2("main/assist/main_assist_enemy_cell", "enemy_cell")
    GUI:ui_IterChilds(ui, ui)

    local imageIcon     = ui["Image_icon"]
    local imageTarget   = ui["Image_target"]
    local textName      = ui["Text_name"]
    local LoadingBar_hp = ui["LoadingBar_hp"]

    -- 名字
    GUI:removeAllChildren(textName)
    local actorName = SL:GetValue("ACTOR_NAME", actorID)
    if actorName and SL:GetUTF8ByteLen(actorName) > 7 then
        GUI:Text_setString(textName, "")
        local scrollLabel = GUI:ScrollText_Create(textName, "scrollText", 0, 0, 115, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#ffffff", actorName)
        GUI:setAnchorPoint(scrollLabel, 0.5, 0.5)
    else
        GUI:Text_setString(textName, actorName)
    end

    SetLoadingBarHp(LoadingBar_hp, actorID)

    if SL:GetValue("ACTOR_IS_PLAYER", actorID) then
        if SL:GetValue("ACTOR_IS_HERO", actorID) then
            GUI:Image_loadTexture(imageIcon, heroJobIconPath[SL:GetValue("H.JOB") + 1])
        else
            GUI:Image_loadTexture(imageIcon, jobIconPaths[SL:GetValue("ACTOR_JOB_ID", actorID) + 1])
        end
    else
        GUI:Image_loadTexture(imageIcon, "res/private/main/assist/1900012536.png")
    end

    GUI:setVisible(imageTarget, SL:GetValue("SELECT_TARGET_ID") == actorID)

    local function openFuncDock(touchPos)
        local data = {
            type        = SL:GetValue("ACTOR_IS_HUMAN", actorID) and FuncDockData.FuncDockType.Func_Monster_Head or FuncDockData.FuncDockType.Func_Player_Head,
            targetId    = actorID,
            targetName  = SL:GetValue("ACTOR_NAME", actorID),
            isHero      = SL:GetValue("ACTOR_IS_HERO", actorID), 
            pos         = {x = touchPos.x + 15, y = touchPos.y}
        }
        UIOperator:OpenFuncDockTips(data)
    end

    GUI:addOnClickEvent(ui, function(sender)
        SL:SetValue("SELECT_TARGET_ID", actorID)

        if SL:GetValue("ACTOR_IS_MONSTER", actorID) then
            local mapID = SL:GetValue("MAP_ID")
            local posX = SL:GetValue("ACTOR_MAP_X", actorID)
            local posY = SL:GetValue("ACTOR_MAP_Y", actorID)
            SL:SetValue("BATTLE_MOVE_BEGIN", mapID, posX, posY, nil, GUIDefine.AutoMoveType.TARGET)
        end

        if SL:GetValue("ACTOR_IS_PLAYER", actorID) and not SL:GetValue("IS_PC_OPER_MODE") then
            local touchPos = GUI:getTouchEndPosition(sender)
            openFuncDock(touchPos)
        end
    end)

    -- PC
    if SL:GetValue("IS_PC_OPER_MODE") then
        local onRightDownFunc = function(touchPos)
            if SL:GetValue("ACTOR_IS_PLAYER", actorID) then
                openFuncDock(touchPos)
            end
        end
        GUI:addMouseButtonEvent(ui, {onRightDownFunc = onRightDownFunc, needTouchPos = true})
    end

    return ui
end

------------------------------------- 玩家 ------------------------------------------------------------------------------
function MainNear.AddPlayer(data)
    local actorID = data.actorID

    if MainNear._playerCells[actorID] then
        return false
    end

    if SL:GetValue("ACTOR_IS_DIE", actorID) then
        return false
    end

    if not GUIFunction:CheckLaunchEnableByID(actorID, true) then
        return false
    end
    
    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    local nItems   = #items
    if nItems >= PLAYER_COUNT then
        return false
    end

    -- 找到插入位置
    local index = nItems
    for playerID, cell in pairs(MainNear._playerCells) do
        if SL:GetValue("ACTOR_LEVEL", actorID) > SL:GetValue("ACTOR_LEVEL", playerID) then
            index = math.min(index, GUI:ListView_getItemIndex(listview, cell))
        end
    end

    local cell = MainNear.CreateEnemyCell(actorID)
    GUI:ListView_insertCustomItem(listview, cell, index)

    MainNear._playerCells[actorID] = cell
end

function MainNear.RmvPlayer(data)
    local actorID = data.actorID

    if MainNear._selectType ~= 2 then
        return false
    end

    local cell = MainNear._playerCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    local listview = MainNear._listView
    GUI:ListView_removeItemByIndex(listview, GUI:ListView_getItemIndex(listview, cell))

    MainNear._playerCells[actorID] = nil
end

function MainNear.AutoAddPlayer()
    if MainNear._selectType ~= 2 then
        return false
    end
    
    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items >= PLAYER_COUNT then
        return false
    end

    local actors, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, nPlayer do
        MainNear.AddPlayer({actorID = actors[i]})
        MainNear.AutoRmvPlayer()
    end
end

function MainNear.AutoRmvPlayer()
    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items <= PLAYER_COUNT then
        return false
    end

    local delActorID = nil
    for playerID, _ in pairs(MainNear._playerCells) do
        if nil == delActorID then
            delActorID = playerID
        elseif SL:GetValue("ACTOR_LEVEL", delActorID) > SL:GetValue("ACTOR_LEVEL", playerID) then
            delActorID = playerID
        end
    end

    if delActorID then
        MainNear.RmvPlayer({actorID = delActorID})
    end
end

------------------------------------- 怪物 -------------------------------------------------------------------------------
function MainNear.AddMonster(data)
    local actorID = data.actorID

    if MainNear._monsterCells[actorID] then
        return false
    end

    if SL:GetValue("ACTOR_IS_DIE", actorID) then
        return false
    end

    if SL:GetValue("ACTOR_IS_BORN", actorID) then
        return false
    end
    
    if not SL:GetValue("TARGET_ATTACK_ENABLE", actorID) then
        return false
    end

    -- 权重
    local wight = GetWeight(actorID)

    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    local nItems   = #items
    if nItems >= MONSTER_COUNT and wight == 0 then
        return false
    end

    -- 根据怪物权值找到插入位置
    local index = nItems
    for monsterID, cell in pairs(MainNear._monsterCells) do
        if wight > GetWeight(monsterID) then
            index = math.min(index, GUI:ListView_getItemIndex(listview, cell))
        end
    end

    local cell = MainNear.CreateEnemyCell(actorID)
    GUI:ListView_insertCustomItem(listview, cell, index)

    MainNear._monsterCells[actorID] = cell
end

function MainNear.RmvMonster(data)
    local actorID = data.actorID

    if MainNear._selectType ~= 1 then
        return false
    end

    local cell = MainNear._monsterCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    local listview = MainNear._listView
    GUI:ListView_removeItemByIndex(listview, GUI:ListView_getItemIndex(listview, cell))

    MainNear._monsterCells[actorID] = nil
end

function MainNear.AutoAddMonster()
    if MainNear._selectType ~= 1 then
        return false
    end

    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items >= MONSTER_COUNT then
        return false
    end

    local actors, nActor = SL:GetValue("FIND_IN_VIEW_MONSTER_LIST", nil, false)
    
    local playerVec, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, nPlayer do
        local playerID = playerVec[i]
        if SL:GetValue("ACTOR_IS_HUMAN", playerID) then
            nActor = nActor + 1
            actors[nActor] = playerID
        end
    end

    for i = 1, nActor do
        local actorID = actors[i]
        if actorID then
            MainNear.AddMonster({actorID = actorID})
            MainNear.AutoRmvMonster()
        end
    end
end

function MainNear.AutoRmvMonster()
    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items <= MONSTER_COUNT then
        return false
    end

    local delActorID = nil
    local wight = nil
    for monsterID, _ in pairs(MainNear._monsterCells) do
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
        MainNear.RmvMonster({actorID = delActorID})
    end
end

------------------------------------- 英雄 -------------------------------------------------------------------------------
function MainNear.AddHero(data)
    local actorID = data.actorID

    if MainNear._heroCells[actorID] then
        return false
    end
    
    if not GUIFunction:CheckLaunchEnableByID(actorID, true) then
        return false
    end

    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items >= HERO_COUNT then
        return false
    end

    -- 找到插入位置
    local index = nItems
    for playerID, cell in pairs(MainNear._heroCells) do
        if SL:GetValue("ACTOR_LEVEL", actorID) > SL:GetValue("ACTOR_LEVEL", playerID) then
            index = math.min(index, GUI:ListView_getItemIndex(listview, cell))
        end
    end

    local cell = MainNear.CreateEnemyCell(actorID)
    GUI:ListView_insertCustomItem(listview, cell, index)

    MainNear._heroCells[actorID] = cell
end

function MainNear.RmvHero(data)
    local actorID = data.actorID

    if MainNear._selectType ~= 3 or not MainNear._checkHero then
        return false
    end

    local cell = MainNear._heroCells[actorID]
    if GUI:Win_IsNull(cell) then
        return false
    end

    local listview = MainNear._listView
    GUI:ListView_removeItemByIndex(listview, GUI:ListView_getItemIndex(listview, cell))

    MainNear._heroCells[actorID] = nil
end

function MainNear.AutoAddHero()
    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items >= HERO_COUNT then
        return false
    end

    local delActorID = nil
    for heroID, _ in pairs(MainNear._heroCells) do
        if nil == delActorID then
            delActorID = heroID
        elseif SL:GetValue("ACTOR_LEVEL", delActorID) > SL:GetValue("ACTOR_LEVEL", heroID) then
            delActorID = heroID
        end
    end

    if delActorID then
        MainNear.RmvHero({actorID = delActorID})
    end
end

function MainNear.AutoRmvHero()
    if not (MainNear._selectType == 3 and MainNear._checkHero) then
        return
    end

    local listview = MainNear._listView
    local items    = GUI:ListView_getItems(listview)
    if #items >= HERO_COUNT then
        return false
    end

    local delActorID = nil
    for heroID, _ in pairs(MainNear._heroCells) do
        if nil == delActorID then
            delActorID = heroID
        elseif SL:GetValue("ACTOR_LEVEL", delActorID) > SL:GetValue("ACTOR_LEVEL", heroID) then
            delActorID = heroID
        end
    end

    if delActorID then
        MainNear.RmvHero({actorID = delActorID})
    end
end
------------------------------------- 监听 -------------------------------------------------------------------------------
function MainNear.OnActorRevive(data)
    if GUIFunction:IsMe(data.actorID) then
        return false
    end
    MainNear._updateAble = true
end

function MainNear.OnActorInOfView(data)
    if GUIFunction:IsMe(data.actorID) then
        return false
    end
    MainNear._updateAble = true
end

function MainNear.OnActorOutOfView(data)
    local actorID = data.actorID
    if GUIFunction:IsMe(actorID) then
        return false
    end
    MainNear._updateAble = true
    
    if SL:GetValue("ACTOR_IS_PLAYER", actorID) then
        if SL:GetValue("ACTOR_IS_HERO", actorID) then
            MainNear.RmvHero(data)
        else
            MainNear.RmvPlayer(data)
        end
    elseif SL:GetValue("ACTOR_IS_MONSTER", actorID) then
        MainNear.RmvMonster(data)
    end
end

function MainNear.OnMainNearRefresh(data)
    MainNear.OnActorOutOfView(data)
end

function MainNear.OnActorDie(data)
    MainNear.OnActorOutOfView(data)
end

function MainNear.OnActorMonsterBirth(data)
    MainNear._updateAble = true
end

function MainNear.OnActorMonsterCave(data)
    MainNear._updateAble = true
end

-- 血量刷新
function MainNear.OnRefreshActorHP(data)
    local actorID = data.actorID

    if not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return false
    end

    if not ((MainNear._selectType == 1 and SL:GetValue("ACTOR_IS_MONSTER", actorID)) or (MainNear._selectType == 2 and SL:GetValue("ACTOR_IS_PLAYER", actorID)) or (MainNear._selectType == 3 and SL:GetValue("ACTOR_IS_HERO", actorID))) then
        return false
    end

    local cell = MainNear._selectType == 1 and MainNear._monsterCells[actorID] or (MainNear._selectType == 2 and MainNear._playerCells[actorID] or (MainNear._checkHero and MainNear._heroCells[actorID]))
    if GUI:Win_IsNull(cell) then
        return false
    end

    SetLoadingBarHp(cell["LoadingBar_hp"], actorID)
end

function MainNear.OnTargetChange(targetID)
    local cells = MainNear._selectType == 1 and MainNear._monsterCells or (MainNear._selectType == 2 and MainNear._playerCells or (MainNear._checkHero and MainNear._heroCells))
    for k, v in pairs(cells) do
        GUI:setVisible(v["Image_target"], k == targetID)
    end
end

function MainNear.OnPlayerPKStateChange()
    if MainNear._selectType ~= 2 then
        return false
    end

    MainNear._playerCells = {}
    GUI:ListView_removeAllItems(MainNear._listView)
    MainNear.AutoAddPlayer()
end

-----------------------------------注册事件--------------------------------------
function MainNear.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW,  "MainNear", MainNear.OnActorInOfView)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainNear", MainNear.OnActorOutOfView)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_NEAR_REFRESH,  "MainNear", MainNear.OnMainNearRefresh)
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE,     "MainNear", MainNear.OnActorDie)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_DIE,        "MainNear", MainNear.OnActorDie)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE,       "MainNear", MainNear.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_BIRTH,      "MainNear", MainNear.OnActorMonsterBirth)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_CAVED,      "MainNear", MainNear.OnActorMonsterCave)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH,   "MainNear", MainNear.OnRefreshActorHP)
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CHANGE,      "MainNear", MainNear.OnTargetChange)
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE,      "MainNear", MainNear.OnPlayerPKStateChange)
end

function MainNear.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW,  "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIN_NEAR_REFRESH,  "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_NET_PLAYER_DIE,     "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_DIE,        "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE,       "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_BIRTH,      "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_CAVED,      "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH,   "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_TARGET_CHANGE,      "MainNear")
    SL:UnRegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE,      "MainNear")
end

MainNear.main()