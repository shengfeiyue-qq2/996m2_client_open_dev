MainMiniMap = {}
MainMiniMap._path = "res/private/main-win32/"

MainMiniMap._mapSizes = {
    [1] = {width = 150, height = 150},
    [2] = {width = 200, height = 200},
}

-- 尺寸2是否跳过
MainMiniMap._skipStatus2   = false

MainMiniMap._curStatus     = 0

MainMiniMap._status        = 0          -- 0不显示 1玩家在中心点 2显示全地图 3打开小地图

MainMiniMap._actorCounts   = {}         -- 位置ID 计数
MainMiniMap._actorPoints   = {}         -- 位置点对象
MainMiniMap._actorPosIDs   = {}         -- actorID = 位置ID
MainMiniMap._pointCache    = {}

function MainMiniMap.main()
    local parent = GUI:Attach_Top()
    GUI:LoadExport(parent, "main/main_minimap_win32")
    MainMiniMap._root = GUI:getChildByName(parent, "Main_Minimap")

    MainMiniMap._ui = GUI:ui_delegate(MainMiniMap._root)
    if not MainMiniMap._ui then
        return false
    end

    GUI:setPosition(MainMiniMap._root, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))

    -- Panel_minimap
    local Panel_minimap = MainMiniMap._ui["Panel_minimap"]
    GUI:setCascadeOpacityEnabled(Panel_minimap, true)
    GUI:addOnClickEvent(Panel_minimap, function()
        if GUI:getOpacity(Panel_minimap) == 255 then
            GUI:setOpacity(Panel_minimap, 150)
        else
            GUI:setOpacity(Panel_minimap, 255)
        end
    end)

    MainMiniMap.InitUI()
    MainMiniMap.InitMiniMap()

    -- 切换的显示状态
    MainMiniMap.ChangeStatus(1)

    GUI:setVisible(MainMiniMap._ui["Text_mouse_pos"], false)
    -- 鼠标移动事件
    MainMiniMap.InitMouseEvent()

    -- 键盘事件
    MainMiniMap.InitKeyCode()

    -- 地图状态改变
    MainMiniMap.UpdateMapState()
    -- 注册事件
    MainMiniMap.RegisterEvent()

    -- 挂接点(不可变)
    MainMiniMap._HangNode = MainMiniMap._root

    -- 可变挂接点
    MainMiniMap._VARHangNode = Panel_minimap
end

function MainMiniMap.InitUI()
    MainMiniMap.InitMiniMapFGameDataCfg()

    MainMiniMap._Image_minimap = MainMiniMap._ui["Image_minimap"]
    MainMiniMap._miniScaleX = GUI:getScaleX(MainMiniMap._Image_minimap)
    MainMiniMap._miniScaleY = GUI:getScaleY(MainMiniMap._Image_minimap)

    GUI:setVisible(MainMiniMap._Image_minimap, false)
    GUI:setVisible(MainMiniMap._ui["Node_player"], false)
end

-- actor 白点 闪烁
function MainMiniMap.InitMiniMap()
    local actorPoint = GUI:Image_Create(MainMiniMap._ui["Node_player"], "ActorPoint", 0, 0, "res/private/main/miniMap/point_main.png")
    GUI:setIgnoreContentAdaptWithSize(actorPoint, false)
    GUI:setContentSize(actorPoint, 4, 4)
    GUI:runAction(actorPoint, GUI:ActionRepeatForever(GUI:ActionBlink(0.8, 1)))
end

function MainMiniMap.InitMiniMapFGameDataCfg()
    local PCMainMiniMapSize = SL:GetValue("GAME_DATA","PCMainMiniMapSize")
    if not PCMainMiniMapSize then
        return false
    end

    local function setSize(i, sizeStr)
        local size = string.split(sizeStr, "#")
        if tonumber(size[1]) and tonumber(size[2]) then
            MainMiniMap._mapSizes[i] = {width = tonumber(size[1]), height = tonumber(size[2])}
        end
    end

    local sizeLists = string.split(PCMainMiniMapSize, "|")
    for _, sizeStr in ipairs(sizeLists) do
        if sizeStr and string.len(sizeStr) > 0 then
            if tonumber(_) == 1 then
                setSize(tonumber(_), sizeStr)
            elseif tonumber(_) == 2 then
                if tonumber(sizeStr) then
                    MainMiniMap._skipStatus2 = tonumber(sizeStr) == 1
                else
                    local data = string.split(sizeStr, "&")
                    MainMiniMap._skipStatus2 = tonumber(data[1]) and tonumber(data[1]) == 1
                    if data[2] and string.len(data[2]) > 0 then
                        setSize(tonumber(_), data[2])
                    end
                end
            end
        end
    end
end

function MainMiniMap.InitMouseEvent()
    GUI:addMouseMoveEvent(MainMiniMap._ui["Panel_minimap"], {
        onEnterFunc = function ()
            if MainMiniMap._curStatus == 1 or MainMiniMap._curStatus == 2 then
                local isEnable = MainMiniMap.IsEnableMiniMap()
                if not isEnable then
                    return nil
                end

                GUI:setVisible(MainMiniMap._ui["Text_mouse_pos"], true)
                local mousePos  = SL:GetValue("MOUSE_MOVE_POS")
                local nodePos   = GUI:convertToNodeSpace(MainMiniMap._ui["Image_minimap"], mousePos.x, mousePos.y)
                local sliceRows = SL:GetValue("MAP_ROWS")
                local sliceCols = SL:GetValue("MAP_COLS")
                local minimapSize = MainMiniMap._minimapSize
                if not sliceRows or not sliceCols or not minimapSize then
                    SL:Print("error with minimap image or map load!!!")
                    return nil
                end
                
                local mmapPosX  = (nodePos.x / minimapSize.width) * sliceRows
                local mmapPosY  = (1 - (nodePos.y / minimapSize.height)) * sliceCols
                GUI:Text_setString(MainMiniMap._ui["Text_mouse_pos"], string.format("%s:%s", math.floor(mmapPosX), math.floor(mmapPosY)))
            end
        end,
        onLeaveFunc = function ()
            local isEnable = MainMiniMap.IsEnableMiniMap()
            if not isEnable then
                return nil
            end
                
            GUI:setVisible(MainMiniMap._ui["Text_mouse_pos"], false)
        end
    })    
end

function MainMiniMap.InitKeyCode()
    -- tab切换小地图
    local function callback()
        local status = MainMiniMap.GetNextStatus()
        MainMiniMap.ChangeStatus(status)
    end
    GUI:addKeyboardEvent("KEY_TAB", callback)

    -- M打开小地图
    local function callback()
        local miniMapID = SL:GetValue("MINIMAP_ID")
        if not miniMapID or miniMapID == 0 then
            return false
        end

        if GUI:GetWindow(nil, UIConst.LAYERID.MiniMapGUI) then
            UIOperator:CloseMiniMap()
        else
            UIOperator:OpenMiniMap()
        end
    end
    GUI:addKeyboardEvent("KEY_M", callback)
end

function MainMiniMap.ChangeStatus(status)
    MainMiniMap._status = status
    MainMiniMap._limitSize = MainMiniMap._mapSizes[MainMiniMap._status] or {width = 110, height = 110}

    MainMiniMap.UpdateMapShowStatus(status)
end

function MainMiniMap.OnTabKeyExchange()
    local status = MainMiniMap and MainMiniMap.GetNextStatus()
    MainMiniMap.ChangeStatus(status)
end

-- next 切换的显示状态
function MainMiniMap.GetNextStatus()
    local status = (MainMiniMap._curStatus >= 3 and 0 or MainMiniMap._curStatus + 1)
    if MainMiniMap._skipStatus2 and status == 2 then
        status = 3
    end
    if MainMiniMap._curStatus == 3 then
        UIOperator:CloseMiniMap()
    end
    return status
end

function MainMiniMap.IsEnableMiniMap()
    local miniMapID = SL:GetValue("MINIMAP_ID")
    if not miniMapID or miniMapID == 0 then
        return false
    end
    return SL:GetValue("MINIMAP_ABLE")
end

function MainMiniMap.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAP_STATE_CHANGE, "MainMiniMap", MainMiniMap.UpdateMapState)
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_DOWNLOAD_SUCCESS, "MainMiniMap", MainMiniMap.OnDownLoadSuccess)

    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, "MainMiniMap", MainMiniMap.OnChangeScene)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW, "MainMiniMap", MainMiniMap.OnActorInOfView)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainMiniMap", MainMiniMap.OnActorOutOfView)

    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE, "MainMiniMap", MainMiniMap.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_DIE, "MainMiniMap", MainMiniMap.OnActorDie)
    
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_BIRTH, "MainMiniMap", MainMiniMap.OnActorRevive)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_CAVED, "MainMiniMap", MainMiniMap.OnActorDie)

    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, "MainMiniMap", MainMiniMap.OnActorMoveComplete)
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_ACTION_COMPLETE, "MainMiniMap", MainMiniMap.OnNetPlayerMoveComplete)
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_ACTION_COMPLETE, "MainMiniMap", MainMiniMap.OnMonsterMoveComplete)

    -- 释放内存
    SL:RegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "MainMiniMap", MainMiniMap.OnReleaseMemory)

    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE,       "MainMiniMap", MainMiniMap.OnWindowChange)
end

function MainMiniMap.UpdateMapState()
    local safeArea = SL:GetValue("MAP_IS_IN_SAFE_AREA")
    local path  = not safeArea and "00150.png" or "00151.png"
    GUI:Image_loadTexture(MainMiniMap._ui["Image_mapFlag"], MainMiniMap._path .. path)
end

function MainMiniMap.OnDownLoadSuccess(miniMapID)
    if SL:GetValue("MINIMAP_ID") == miniMapID and SL:GetValue("MINIMAP_ABLE") then
        MainMiniMap.UpdateMiniMap()
        MainMiniMap.UpdateMiniMapPos()
    end
end

function MainMiniMap.UpdateMapShowStatus(status)
    MainMiniMap._curStatus = status

    if MainMiniMap._curStatus == 0 then
        GUI:setVisible(MainMiniMap._ui["Panel_minimap"], false)
    elseif MainMiniMap._curStatus == 1 then
        GUI:setVisible(MainMiniMap._ui["Panel_minimap"], true)
    elseif MainMiniMap._curStatus == 2 then
        GUI:setVisible(MainMiniMap._ui["Panel_minimap"], true)
    elseif MainMiniMap._curStatus == 3 then
        GUI:setVisible(MainMiniMap._ui["Panel_minimap"], false)

        if MainMiniMap.IsEnableMiniMap() then
            if GUI:GetWindow(nil, UIConst.LAYERID.MiniMapGUI) then
                MainMiniMap.ChangeStatus(0)
            else
                UIOperator:OpenMiniMap()
            end
        end
    end

    local size = MainMiniMap._mapSizes[MainMiniMap._curStatus]
    if size then
        GUI:setContentSize(MainMiniMap._ui["Panel_minimap"], size)
        GUI:setPositionX(MainMiniMap._ui["Text_mouse_pos"], size.width)
    end

    MainMiniMap.UpdateMiniMap()
    MainMiniMap.UpdateMiniMapPos()
    MainMiniMap.UpdateActorPoints()
end

function MainMiniMap.UpdateActorPoints()
    for actorID, posID in pairs(MainMiniMap._actorPosIDs) do
        local actorPoint = MainMiniMap._actorPoints[posID]
        if actorPoint then
            local x = SL:GetValue("ACTOR_MAP_X", actorID)
            local y = SL:GetValue("ACTOR_MAP_Y", actorID)
            local miniMapPos = MainMiniMap.CalcMiniMapPos(x, y)
            GUI:setPosition(actorPoint, miniMapPos)
        end
    end
end

function MainMiniMap.CalcMiniMapPos(mapX, mapY)
    if not SL:GetValue("MAP_DATA_LOADED") or not MainMiniMap._minimapSize then
        return {x = 0, y = 0}
    end

    local mapRows = SL:GetValue("MAP_ROWS")
    local mapCols = SL:GetValue("MAP_COLS")
    local posX = mapX / mapCols * MainMiniMap._minimapSize.width
    local posY = (1 - mapY / mapRows) * MainMiniMap._minimapSize.height
    
    return {x = posX, y = posY}
end

function MainMiniMap.IsEnableMiniMap()
    local miniMapID = SL:GetValue("MINIMAP_ID")
    if not miniMapID then
        return false
    end
    return SL:GetValue("MINIMAP_ABLE")
end

function MainMiniMap.UpdateMiniMap()
    if MainMiniMap._status == 0 or MainMiniMap._status == 3 then
        return false
    end

    local isEnable = MainMiniMap.IsEnableMiniMap()
    GUI:setVisible(MainMiniMap._ui["Panel_minimap"], isEnable)

    if not isEnable then
        return false
    end

    local miniMapFile = SL:GetValue("MINIMAP_FILE")
    GUI:Image_loadTexture(MainMiniMap._Image_minimap, miniMapFile)

    GUI:setIgnoreContentAdaptWithSize(MainMiniMap._Image_minimap, true)
    GUI:setVisible(MainMiniMap._Image_minimap, true)
    GUI:setVisible(MainMiniMap._ui["Node_player"], true)
    
    if MainMiniMap._status == 2 then
        GUI:setIgnoreContentAdaptWithSize(MainMiniMap._Image_minimap, false)
        GUI:setContentSize(MainMiniMap._Image_minimap, MainMiniMap._limitSize)
    end
    MainMiniMap._minimapSize = GUI:getContentSize(MainMiniMap._Image_minimap)

    if MainMiniMap._minimapSize.width < MainMiniMap._mapSizes[1].width then
        GUI:setContentSize(MainMiniMap._Image_minimap, MainMiniMap._mapSizes[1].width, MainMiniMap._mapSizes[1].height)
        MainMiniMap._minimapSize = GUI:getContentSize(MainMiniMap._Image_minimap)
    end
end

function MainMiniMap.UpdateMiniMapPos()
    if MainMiniMap._status == 0 or MainMiniMap._status == 3 then
        return false
    end
    local isEnable = MainMiniMap.IsEnableMiniMap()
    if not isEnable then
        return false
    end

    local playerID = SL:GetValue("USER_ID")
    if not playerID then
        return false
    end

    if not MainMiniMap._minimapSize then
        return false
    end

    local mapWidth  = SL:GetValue("MAP_SIZE_WIDTH_PIXEL")
    local mapHeight = SL:GetValue("MAP_SIZE_HEIGHT_PIXEL")
    local worldPos  = SL:GetValue("POS", playerID)
    local worldX    = worldPos.x
    local worldY    = -worldPos.y
    local ratioX    = MainMiniMap._minimapSize.width / mapWidth
    local ratioY    = MainMiniMap._minimapSize.height / mapHeight
    
    local function calcMiniMap()
        local minimapX = worldX * -ratioX
        local minimapY = (mapHeight - worldY) * -ratioY
        minimapX = minimapX + MainMiniMap._limitSize.width / 2
        minimapY = minimapY + MainMiniMap._limitSize.height / 2
        minimapX = math.max(minimapX, -(MainMiniMap._minimapSize.width - MainMiniMap._limitSize.width))
        minimapX = math.min(minimapX, 0)
        minimapY = math.max(minimapY, -(MainMiniMap._minimapSize.height - MainMiniMap._limitSize.height))
        minimapY = math.min(minimapY, 0)
        GUI:setPosition(MainMiniMap._Image_minimap, minimapX, minimapY)
    end
    
    local function calcPlayerPos()
        local playerX  = MainMiniMap._limitSize.width / 2
        local playerY  = MainMiniMap._limitSize.height / 2
        local minimapX = worldX * ratioX
        local minimapY = (mapHeight - worldY) * ratioY
        
        -- 校正X
        if minimapX < MainMiniMap._limitSize.width / 2 then
            playerX = minimapX
        elseif minimapX > MainMiniMap._minimapSize.width - MainMiniMap._limitSize.width / 2 then
            playerX = MainMiniMap._limitSize.width - (MainMiniMap._minimapSize.width - minimapX)
        end
        
        -- 校正Y
        if minimapY < MainMiniMap._limitSize.height / 2 then
            playerY = minimapY
        elseif minimapY > MainMiniMap._minimapSize.height - MainMiniMap._limitSize.height / 2 then
            playerY = MainMiniMap._limitSize.height - (MainMiniMap._minimapSize.height - minimapY)
        end
        
        GUI:setPosition(MainMiniMap._ui["Node_player"], playerX, playerY)
    end
    
    calcMiniMap()
    calcPlayerPos()
end

function MainMiniMap.OnChangeScene()
    MainMiniMap.UpdateMiniMap()
    MainMiniMap.UpdateMiniMapPos()
    MainMiniMap.CleanupActorPoints()
    MainMiniMap.InitActorPoints()
end

function MainMiniMap.OnActorInOfView(data)
    local actorID = data.actorID
    if GUIFunction:IsMe(actorID) then
        MainMiniMap.ChangeStatus(MainMiniMap._status)
    else
        MainMiniMap.AddActorPoint(actorID)
    end
end

function MainMiniMap.OnActorOutOfView(data)
    MainMiniMap.RmvActorPoint(data.actorID)
end

function MainMiniMap.OnActorDie(data)
    MainMiniMap.RmvActorPoint(data.actorID)
end

function MainMiniMap.OnActorRevive(data)
    MainMiniMap.AddActorPoint(data.actorID)
end

function MainMiniMap.OnActorMoveComplete()
    MainMiniMap.UpdateMiniMapPos()
end

function MainMiniMap.OnNetPlayerMoveComplete(data)
    if GUIFunction:IsMoveAction(data.act) then
        MainMiniMap.UpdateActorPoint(data.actorID)
    end
end

function MainMiniMap.OnMonsterMoveComplete(data)
    if GUIFunction:IsMoveAction(data.act) then
        MainMiniMap.UpdateActorPoint(data.actorID)
    end
end

function MainMiniMap.OnReleaseMemory()
    for _, cell in pairs(MainMiniMap._pointCache) do
        GUI:autoDecRef(cell)
    end
    MainMiniMap._pointCache = {}
end

function MainMiniMap.OnWindowChange()
    GUI:setPosition(MainMiniMap._root, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))
end

------------------------------------------------------------------------
function MainMiniMap.CleanupActorPoints()
    for _,cell in ipairs(GUI:getChildren(MainMiniMap._ui["Node_actors"])) do
        GUI:Retain(cell)
        GUI:removeFromParent(cell)
        table.insert(MainMiniMap._pointCache, cell)
    end
    MainMiniMap._actorPoints = {}
    MainMiniMap._actorCounts = {}
    MainMiniMap._actorPosIDs = {}
end

function MainMiniMap.InitActorPoints()
    local playerList, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, nPlayer do
        MainMiniMap.AddActorPoint(playerList[i])
    end

    local npcList, nNpc = SL:GetValue("FIND_IN_VIEW_NPC_LIST")
    for i = 1, nNpc do
        MainMiniMap.AddActorPoint(npcList[i])
    end

    local monsterList, nMonster = SL:GetValue("FIND_IN_VIEW_MONSTER_LIST", true)
    for i = 1, nMonster do
        MainMiniMap.AddActorPoint(monsterList[i])
    end
end

function MainMiniMap.UpdateActorPoint(actorID)
    -- 移除上个位置
    MainMiniMap.RmvActorPoint(actorID)

    -- 处理新位置
    local posID = MainMiniMap.GetActorPointPosID(actorID)

    local actorPoint = MainMiniMap._actorPoints[posID]
    if actorPoint then
        if not MainMiniMap._actorCounts[posID] then
            MainMiniMap._actorCounts[posID] = 0
        end
        MainMiniMap._actorCounts[posID] = MainMiniMap._actorCounts[posID] + 1
        MainMiniMap._actorPosIDs[actorID] = posID
    else
        MainMiniMap.CreateActorPoint(actorID, posID)
        MainMiniMap._actorCounts[posID] = 1
        MainMiniMap._actorPosIDs[actorID] = posID
    end
end

function MainMiniMap.CreateActorPoint(actorID, posID)
    local actorPoint = MainMiniMap.GetActorPointCache()
    MainMiniMap._actorPoints[posID] = actorPoint

    local z = SL:GetValue("ACTOR_IS_MONSTER", actorID) and 1 or (SL:GetValue("ACTOR_IS_PLAYER", actorID) and 2 or 3)

    local path = string.format("%smain/miniMap/point_%s.png", GUIDefine.PATH_RES_PRIVATE, z)
    GUI:Image_loadTexture(actorPoint, path)

    GUI:setIgnoreContentAdaptWithSize(actorPoint, false)
    GUI:setContentSize(actorPoint, 5, 5)
    GUI:setLocalZOrder(actorPoint, z)

    GUI:addChild(MainMiniMap._ui["Node_actors"], actorPoint)

    local posX = SL:GetValue("ACTOR_MAP_X", actorID)
    local posY = SL:GetValue("ACTOR_MAP_Y", actorID)

    local miniMapPos = MainMiniMap.CalcMiniMapPos(posX, posY)
    GUI:setPosition(actorPoint, miniMapPos)
end

function MainMiniMap.AddActorPoint(actorID)
    if not (SL:GetValue("ACTOR_IS_PLAYER", actorID) or SL:GetValue("ACTOR_IS_MONSTER", actorID) or SL:GetValue("ACTOR_IS_NPC", actorID)) then
        return false
    end

    -- 死亡
    if SL:GetValue("ACTOR_IS_DIE", actorID) or SL:GetValue("ACTOR_IS_DEATH", actorID) then
        return false
    end

    -- 怪物石化和地下，等出生状态
    if SL:GetValue("ACTOR_IS_BORN", actorID) or SL:GetValue("ACTOR_IS_CAVE", actorID) then
        return false
    end

    local mainPlayerID = SL:GetValue("USER_ID")
    if not mainPlayerID then
        return false
    end

    if actorID == mainPlayerID then
        MainMiniMap.UpdateMiniMap()
        MainMiniMap.UpdateMiniMapPos()
        return false
    end

    -- 自己的宝宝不显示
    if SL:GetValue("ACTOR_MASTER_ID", actorID) == mainPlayerID then
        return false
    end

    if not SL:GetValue("MINIMAP_ABLE") then
        return false
    end

    MainMiniMap.UpdateActorPoint(actorID)
end

function MainMiniMap.GetActorPointPosID(actorID)
    local x = SL:GetValue("ACTOR_MAP_X", actorID)
    local y = SL:GetValue("ACTOR_MAP_Y", actorID)
    local z = SL:GetValue("ACTOR_IS_MONSTER", actorID) and 1 or (SL:GetValue("ACTOR_IS_PLAYER", actorID) and 2 or 3)
    local posID = z * 10000000000 + GUIFunction:KeyMapXY(x, y)
    return posID
end

function MainMiniMap.RmvActorPoint(actorID)
    local posID = MainMiniMap._actorPosIDs[actorID]
    if not posID then
        return false
    end
    MainMiniMap._actorPosIDs[actorID] = nil

    if not MainMiniMap._actorCounts[posID] then
        return false
    end

    MainMiniMap._actorCounts[posID] = MainMiniMap._actorCounts[posID] - 1
    
    if MainMiniMap._actorCounts[posID] > 0 then
        return false
    end
    MainMiniMap._actorCounts[posID] = nil

    local actorPoint = MainMiniMap._actorPoints[posID]
    if not actorPoint then
        return false
    end

    GUI:removeFromParent(actorPoint)
    MainMiniMap._actorPoints[posID] = nil
end

function MainMiniMap.GetActorPointCache()
    local nCache = #MainMiniMap._pointCache 
    if nCache > 0 then
        local point = table.remove(MainMiniMap._pointCache, nCache)
        GUI:autoDecRef(point)
        return point
    end

    local pointCell = GUI:Image_Create(-1, "Cell", 0, 0, "")
    return pointCell
end

MainMiniMap.main()