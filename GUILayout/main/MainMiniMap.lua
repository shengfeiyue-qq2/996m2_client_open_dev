MainMiniMap = {}

MainMiniMap._showState = false

-- 战斗模式
local PKType = GUIDefine.PKModeType
MainMiniMap._showPKTab = {PKType.HAM_ALL, PKType.HAM_PEACE, PKType.HAM_GROUP, PKType.HAM_GUILD, PKType.HAM_SHANE, PKType.HAM_NATION, PKType.HAM_CAMP}
MainMiniMap._pkModeStrList = {
    [PKType.HAM_ALL]    = "全体",
    [PKType.HAM_PEACE]  = "和平",
    [PKType.HAM_GROUP]  = "编组",
    [PKType.HAM_GUILD]  = "行会",
    [PKType.HAM_SHANE]  = "善恶",
    [PKType.HAM_NATION] = "国家",
    [PKType.HAM_CAMP]   = "阵营",
    [PKType.HAM_SERVER] = "区服"
} 

MainMiniMap._path = "res/private/minimap/"

MainMiniMap._actorCounts   = {}         -- 位置ID 计数
MainMiniMap._actorPoints   = {}         -- 位置点对象
MainMiniMap._actorPosIDs   = {}         -- actorID = 位置ID
MainMiniMap._pointCache    = {}

-- 右上角小地图进入范围显示相关的提示
MainMiniMap._portals       = {}         -- 提示数据
MainMiniMap._markPortalIdx = nil        -- 标记当前正在显示的提示下标
MainMiniMap._protalRange = tonumber(SL:GetValue("GAME_DATA", "minimap_title_range")) or 60 -- 检测的格子数

local function squLen(x, y)
    local maxv = math.max(math.abs(x), math.abs(y))
    return maxv * maxv
end

function MainMiniMap.main()
    local parent = GUI:Attach_Top()
    GUI:LoadExport(parent, "main/main_minimap")
    MainMiniMap._root = GUI:getChildByName(parent, "Main_Minimap")

    MainMiniMap._ui = GUI:ui_delegate(MainMiniMap._root)
    if not MainMiniMap._ui then
        return false
    end

    local _, rect = SL:GetValue("NOTCH_PHONE_INFO")
    GUI:setPosition(MainMiniMap._root, SL:GetValue("SCREEN_WIDTH") - rect.x, SL:GetValue("SCREEN_HEIGHT") - 30)

    MainMiniMap._Image_minimap = MainMiniMap._ui["Image_minimap"]
    MainMiniMap._miniScaleX = GUI:getScaleX(MainMiniMap._Image_minimap)
    MainMiniMap._miniScaleY = GUI:getScaleY(MainMiniMap._Image_minimap)

    -- 地图名
    local MapName = MainMiniMap._ui["MapName"]
    MainMiniMap._MapName = MapName

    -- 地图状态 安全区/危险区
    local MapStatus = MainMiniMap._ui["MapStatus"]
    MainMiniMap._MapStatus = MapStatus

    -- 地图按钮 控制地图缩回
    local MapButton = MainMiniMap._ui["MapButton"]
    GUI:addOnClickEvent(MapButton, function()
        MainMiniMap.ChangeShowState(not MainMiniMap._showState)
    end)

    -- PK模式按钮
    local PKModelButton = MainMiniMap._ui["PKModelButton"]
    GUI:Win_SetParam(PKModelButton, false)
    MainMiniMap._PKModelButton = PKModelButton
    GUI:addOnClickEvent(PKModelButton, function()
        MainMiniMap.onBtnPkEvent()
    end)

    -- PK模式文本
    local PKModelButtonText = MainMiniMap._ui["PKModelButtonText"]
    MainMiniMap._PKModelButtonText = PKModelButtonText

    local PKModelCell = MainMiniMap._ui["PKModelCell"]
    MainMiniMap._PKModelCell = PKModelCell

    local PKModelListView = MainMiniMap._ui["PKModelListView"]
    MainMiniMap._PKModelListView = PKModelListView

    MainMiniMap._cSize = {width = 56, height = 80}

    MainMiniMap.InitCustomPKMode()
    MainMiniMap.InitMiniMap()

    MainMiniMap.UpdatePKMode()
    MainMiniMap.UpdateMapState()
    MainMiniMap.UpdateMapName()

    MainMiniMap.RegisterEvent()

    -- 挂接点(不可变)
    MainMiniMap._HangNode = MainMiniMap._root

    -- 可变挂接点
    MainMiniMap._VARHangNode = MainMiniMap._ui["Node"]
end

function MainMiniMap.InitCustomPKMode()
    local typeList = SL:GetValue("RELATION_TYPE_LIST")
    if typeList and next(typeList) then
        for _, modeId in ipairs(typeList) do
            local config = SL:GetValue("RELATION_TYPE_CONFIG", modeId)
            table.insert(MainMiniMap._showPKTab, modeId)
            MainMiniMap._pkModeStrList[modeId] = config and config.mode_name or ""
        end
    end
end

function MainMiniMap.RegisterEvent()
    -- PK模式改变
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, "MainMiniMap", MainMiniMap.UpdatePKMode)

    -- 地图状态改变
    SL:RegisterLUAEvent(LUA_EVENT_MAP_STATE_CHANGE, "MainMiniMap", MainMiniMap.UpdateMapState)

    -- 场景改变
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, "MainMiniMap", MainMiniMap.OnChangeScene)

    -- 折叠/展开
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_MINIMAP_SHOW_STATUS, "MainMiniMap", MainMiniMap.OnChangeStatus)

    -- 小地图下载成功
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_DOWNLOAD_SUCCESS, "MainMiniMap", MainMiniMap.OnDownLoadSuccess)

    -- 人物坐标发生变化
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, "MainMiniMap", MainMiniMap.OnActorMoveComplete)

    -- 网络玩家移动结束
    SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_ACTION_COMPLETE, "MainMiniMap", MainMiniMap.OnNetPlayerMoveComplete)

    -- 怪物移动结束
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_ACTION_COMPLETE, "MainMiniMap", MainMiniMap.OnMonsterMoveComplete)

    -- 进入视野
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_IN_OF_VIEW, "MainMiniMap", MainMiniMap.OnActorInOfView)

    -- 离开视野
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OUT_OF_VIEW, "MainMiniMap", MainMiniMap.OnActorOutOfView)

    -- 复活
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_REVIVE, "MainMiniMap", MainMiniMap.OnActorRevive)
    -- 死亡
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_DIE, "MainMiniMap", MainMiniMap.OnActorDie)

    -- 怪物出生
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_BIRTH, "MainMiniMap", MainMiniMap.OnActorRevive)
    -- 钻地下
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_CAVED, "MainMiniMap", MainMiniMap.OnActorDie)

    -- 释放内存
    SL:RegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "MainMiniMap", MainMiniMap.OnReleaseMemory)
end

function MainMiniMap.OnChangeScene()
    MainMiniMap.UpdateMapName()
    MainMiniMap.UpdateMapPos()
    MainMiniMap.UpdateMiniMap()
    MainMiniMap.UpdateMiniMapPos()
    MainMiniMap.CleanupActorPoints()
    MainMiniMap.InitActorPoints()
    
    -- debug
    if SL._DEBUG and SL:GetValue("GAME_DATA","DebugMapInfoShow") then
        MainMiniMap.SetMapInfoInDebug()
    end
end

function MainMiniMap.OnChangeStatus(show)
    MainMiniMap.ChangShowState(not show)
end

function MainMiniMap.OnDownLoadSuccess(miniMapID)
    if SL:GetValue("MINIMAP_ID") == miniMapID and SL:GetValue("MINIMAP_ABLE") then
        MainMiniMap.UpdateMapPos()
        MainMiniMap.UpdateMiniMap()
        MainMiniMap.UpdateMiniMapPos()
    end
end

function MainMiniMap.OnActorMoveComplete()
    MainMiniMap.UpdateMapPos()
    MainMiniMap.UpdatePortal()
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

function MainMiniMap.OnActorInOfView(data)
    local actorID = data.actorID
    if GUIFunction:IsMe(actorID) then
        MainMiniMap.UpdateMapPos()
        MainMiniMap.UpdateMiniMapPos()
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

function MainMiniMap.SetMapInfoInDebug()
    local mapID     = SL:GetValue("MAP_ID")
    local mapDataID = SL:GetValue("MAP_DATA_ID")
    local text = string.format("地图.%s\n资源.%s", mapID, mapDataID)

    local DEBUG_MAP_SHOW = GUI:getChildByName(MainMiniMap._ui["Panel_map"], "DEBUG_MAP_SHOW")
    if not DEBUG_MAP_SHOW then
        local x = GUI:getContentSize(MainMiniMap._ui["Panel_map"]).width / 2
        local y = GUI:getContentSize(MainMiniMap._ui["Panel_map"]).height / 2
        local label = GUI:Text_Create(MainMiniMap._ui["Panel_map"], "DEBUG_MAP_SHOW", x, y, 18, "#ffff00", text)
        GUI:setAnchorPoint(label, 0.5, 0.5)
    else
        GUI:Text_setString(DEBUG_MAP_SHOW, text)
    end
end

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

function MainMiniMap.InitMiniMap()
    -- 传送点显示
    MainMiniMap._icon = GUI:Image_Create(MainMiniMap._ui["Node_path"], "portal_icon", 0, 0, MainMiniMap._path .. "icon_xdtzy_04.png")
    GUI:setVisible(MainMiniMap._icon, false)
    GUI:setAnchorPoint(MainMiniMap._icon, 0.5, 0.5)

    MainMiniMap._nameText = GUI:Text_Create(MainMiniMap._ui["Node_path"], "portal_text", 0, 0, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(MainMiniMap._nameText, 0.5, 0.5)

    -- actor白点
    local actorPoint = GUI:Image_Create(MainMiniMap._ui["Node_player"], "ActorPoint", -2, -2, "res/private/main/miniMap/point_main.png")
    GUI:setIgnoreContentAdaptWithSize(actorPoint, false)
    GUI:setContentSize(actorPoint, 4, 4)

    -- 打开小地图
    GUI:addOnClickEvent(MainMiniMap._ui["Panel_minimap"], function()
        if SL:GetValue("MINIMAP_ABLE") then
            if GUI:GetWindow(nil, UIConst.LAYERID.MiniMapGUI) then           
                UIOperator:CloseMiniMap()
            else
                UIOperator:OpenMiniMap()
            end
        end
    end)

    MainMiniMap._limitSize = GUI:getContentSize(MainMiniMap._ui["Panel_minimap"])
    MainMiniMap._minimapSize = {width = 0, height = 0}
    
    MainMiniMap.UpdateMapPos()
    MainMiniMap.UpdateMiniMap()
    MainMiniMap.UpdateMiniMapPos()
end

-- 坐标位置
function MainMiniMap.UpdateMapPos()
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end

    local mapX = SL:GetValue("X")
    local mapY = SL:GetValue("Y")
    GUI:Text_setString(MainMiniMap._ui["PlayerPos"], string.format("%d:%d", mapX, mapY))
end

function MainMiniMap.UpdateMiniMap()
    MainMiniMap._portals = SL:GetValue("MINIMAP_PORTALS")
    MainMiniMap._markPortalIdx = nil
    
    if SL:GetValue("MINIMAP_ABLE") then
        GUI:setVisible(MainMiniMap._ui["Image_empty"], false)
        GUI:setVisible(MainMiniMap._ui["Node_player"], true)
        GUI:setVisible(MainMiniMap._Image_minimap, true)

        GUI:Image_loadTexture(MainMiniMap._Image_minimap, SL:GetValue("MINIMAP_FILE"))
        GUI:setIgnoreContentAdaptWithSize(MainMiniMap._Image_minimap, true)

        local size = GUI:getContentSize(MainMiniMap._Image_minimap)
        local width  = size.width
        local height = size.height 

        width  = math.max(width, MainMiniMap._limitSize.width)
        height = math.max(height, MainMiniMap._limitSize.height)
        GUI:setContentSize(MainMiniMap._Image_minimap, width, height)

        local scaleX = MainMiniMap._miniScaleX
        local scaleY = MainMiniMap._miniScaleY
        MainMiniMap._minimapSize = {width = width * scaleX, height = height * scaleY}

        GUI:setPosition(MainMiniMap._ui["Node_path"], 0, 0)
        GUI:setPosition(MainMiniMap._ui["Node_actors"], 0, 0)
    else
        GUI:setVisible(MainMiniMap._ui["Image_empty"], true)
        GUI:setVisible(MainMiniMap._ui["Node_player"], false)
        GUI:setVisible(MainMiniMap._Image_minimap, false)
    end

    MainMiniMap.UpdatePortal(true)
end

function MainMiniMap.UpdateMiniMapPos()
    if not SL:GetValue("MINIMAP_ABLE") then
        return false
    end

    local playerID = SL:GetValue("USER_ID")
    if not playerID then
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
        minimapX = minimapX + MainMiniMap._limitSize.width  / 2
        minimapX = math.max(minimapX, -(MainMiniMap._minimapSize.width-MainMiniMap._limitSize.width))
        minimapX = math.min(minimapX, 0)

        local minimapY = (mapHeight - worldY) * -ratioY
        minimapY = minimapY + MainMiniMap._limitSize.height / 2
        minimapY = math.max(minimapY, -(MainMiniMap._minimapSize.height-MainMiniMap._limitSize.height))
        minimapY = math.min(minimapY, 0)
        GUI:setPosition(MainMiniMap._Image_minimap, minimapX, minimapY)
    end

    local function calcPlayerPos()
        local playerX   = MainMiniMap._limitSize.width/2
        local playerY   = MainMiniMap._limitSize.height/2
        local minimapX  = worldX * ratioX
        local minimapY  = (mapHeight - worldY) * ratioY

        -- 校正X
        if minimapX < MainMiniMap._limitSize.width/2 then
            playerX = minimapX
        elseif minimapX > MainMiniMap._minimapSize.width - MainMiniMap._limitSize.width / 2 then
            playerX = MainMiniMap._limitSize.width - (MainMiniMap._minimapSize.width - minimapX)
        end

        -- 校正Y
        if minimapY < MainMiniMap._limitSize.height/2 then
            playerY = minimapY
        elseif minimapY > MainMiniMap._minimapSize.height-MainMiniMap._limitSize.height/2 then
            playerY = MainMiniMap._limitSize.height - (MainMiniMap._minimapSize.height - minimapY)
        end

        GUI:setPosition(MainMiniMap._ui["Node_player"], playerX, playerY)
    end

    calcMiniMap()
    calcPlayerPos()
end

function MainMiniMap.onBtnPkEvent(sender, eventType)
    local param = GUI:Win_GetParam(MainMiniMap._PKModelButton)
    if param then
        MainMiniMap.HidePKModeCells()
    else
        MainMiniMap.ShowPKModeCells()
    end
end

function MainMiniMap.HidePKModeCells()
    local pkCell = MainMiniMap._PKModelCell
    if not pkCell then
        return false
    end

    GUI:Win_SetParam(MainMiniMap._PKModelButton, false)

    local mapBGWidth    = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
    local cSize         = MainMiniMap._cSize
    local width         = GUI:ListView_getItemCount(MainMiniMap._PKModelListView) * cSize.width
    local btnActionX    = -mapBGWidth
    local pkActionX     = -mapBGWidth + width

    GUI:stopAllActions(MainMiniMap._PKModelButton)
    GUI:runAction(MainMiniMap._PKModelButton, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, btnActionX, GUI:getPositionY(MainMiniMap._PKModelButton))))

    GUI:stopAllActions(MainMiniMap._PKModelCell)
    GUI:setPositionX(MainMiniMap._PKModelCell, -mapBGWidth)
    GUI:runAction(MainMiniMap._PKModelCell, GUI:ActionSequence(GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, pkActionX, GUI:getPositionY(MainMiniMap._PKModelCell))), GUI:ActionHide()))
end

function MainMiniMap.CreatePKModeListCell(i)
    local widget = GUI:Widget_Create(-1, "widget_" .. i, 0, 0, 0, 0)
    GUI:LoadExport(widget, "main/minimap_pk_cell")
    local cell = GUI:getChildByName(widget, "PKModelListViewCell")
    GUI:removeFromParent(cell)

    return cell
end

function MainMiniMap.ShowPKModeCells()
    local pkListBg = GUI:getChildByName(MainMiniMap._PKModelCell, "PKModelCellsBg")
    local pkList = MainMiniMap._PKModelListView

    GUI:Win_SetParam(MainMiniMap._PKModelButton, true)

    GUI:setVisible(pkListBg, true)
    GUI:removeAllChildren(pkList)

    local cSize = nil
    for i, mode in ipairs(MainMiniMap._showPKTab) do
        if SL:GetValue("PKMODE_CAN_USE", mode) then
            local cell = MainMiniMap.CreatePKModeListCell(i)
            GUI:ListView_pushBackCustomItem(pkList, cell)
            GUI:Text_setString(GUI:getChildByName(cell, "PKModeText"), SL:ChineseToVertical(MainMiniMap._pkModeStrList[mode] or ""))
            GUI:addOnClickEvent(cell, function()
                GUI:delayTouchEnabled(cell)
                SL:RequestChangePKMode(mode)
                MainMiniMap.HidePKModeCells()
            end)

            if not cSize then
                cSize = GUI:getContentSize(cell)
                MainMiniMap._cSize = cSize
            end
        end
    end

    local mapBGWidth    = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
    local width         = GUI:ListView_getItemCount(pkList) * cSize.width
    local posY          = GUI:getPositionY(MainMiniMap._PKModelButton)
    local btnActionX    = -(width) - mapBGWidth
    local pkActionX     = -mapBGWidth
    cSize               = cSize or MainMiniMap._cSize

    GUI:setContentSize(pkListBg, width, cSize.height)
    GUI:setContentSize(pkList, width, cSize.height)
    GUI:stopAllActions(MainMiniMap._PKModelButton)
    GUI:setPositionX(MainMiniMap._PKModelButton, -mapBGWidth)
    GUI:runAction(MainMiniMap._PKModelButton, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, btnActionX, GUI:getPositionY(MainMiniMap._PKModelButton))))
    
    GUI:setContentSize(MainMiniMap._PKModelCell, width, cSize.height)
    GUI:stopAllActions(MainMiniMap._PKModelCell)
    GUI:setPositionX(MainMiniMap._PKModelCell, -mapBGWidth+cSize.width)
    GUI:setVisible(MainMiniMap._PKModelCell, true)
    GUI:runAction(MainMiniMap._PKModelCell, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, pkActionX, GUI:getPositionY(MainMiniMap._PKModelCell))))
end

function MainMiniMap.CalcMiniMapPos(mapX, mapY)
    if not SL:GetValue("MAP_DATA_LOADED") then
        return {x = 0, y = 0}
    end

    local mapRows = SL:GetValue("MAP_ROWS")
    local mapCols = SL:GetValue("MAP_COLS")
    local posX = mapX / mapCols * MainMiniMap._minimapSize.width
    local posY = (1 - mapY / mapRows) * MainMiniMap._minimapSize.height
    
    return {x = posX, y = posY}
end

function MainMiniMap.UpdatePKMode()
    local pkMode = SL:GetValue("PKMODE")
    GUI:Text_setString(MainMiniMap._PKModelButtonText, SL:ChineseToVertical(MainMiniMap._pkModeStrList[pkMode] or ""))
end

function MainMiniMap.UpdateMapState()
    if SL:GetValue("MAP_IS_IN_SAFE_AREA") then
        GUI:Text_setString(MainMiniMap._MapStatus, "安全区域")
        GUI:Text_setTextColor(MainMiniMap._MapStatus, "#00ff00")
    else
        GUI:Text_setString(MainMiniMap._MapStatus, "危险区域")
        GUI:Text_setTextColor(MainMiniMap._MapStatus, "#ff0000")
    end
end

function MainMiniMap.UpdateMapName()
    GUI:Text_setString(MainMiniMap._MapName, SL:GetValue("MAP_NAME"))
end

function MainMiniMap.ChangeShowState(state)
    if MainMiniMap._showState == state then
        return nil
    end
    MainMiniMap._showState = state
    
    local Node = MainMiniMap._ui["Node"]

    GUI:Timeline_StopAll(Node)
    local clipWidth = GUI:getContentSize(MainMiniMap._root).width
    if MainMiniMap._showState then
        local mapBGWidth = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
        GUI:Timeline_EaseSineIn_MoveTo(Node, { x = clipWidth + mapBGWidth-2, y = GUI:getPositionY(Node) }, 0.2)
    else
        GUI:Timeline_EaseSineIn_MoveTo(Node, { x = clipWidth, y = GUI:getPositionY(Node) }, 0.2)
    end
end

-- 更新相关显示
function MainMiniMap.UpdatePortal(isUpdateMap)
    if not MainMiniMap._protalRange then
        return
    end

    local mapX = SL:GetValue("X")
    local mapY = SL:GetValue("Y")

    if not tonumber(mapX) or not tonumber(mapY) then
        return
    end

    MainMiniMap._portals = SL:GetValue("MINIMAP_PORTALS") or {}
    if isUpdateMap then
        MainMiniMap._markPortalIdx = nil
    end

    local showNameIndex = nil
    local mixRange = (MainMiniMap._protalRange + 1) * (MainMiniMap._protalRange + 1)
    for i, v in ipairs(MainMiniMap._portals) do
        local destMapX = tonumber(v.X) or 1
        local destMapY = tonumber(v.Y) or 1

        local len  = math.abs(squLen(mapX - destMapX, mapY - destMapY))
        if len < mixRange then
            mixRange = len
            showNameIndex = i
        end
    end
    
    if showNameIndex then
        if MainMiniMap._markPortalIdx ~= showNameIndex then
            MainMiniMap._markPortalIdx = showNameIndex
            local showConfig = MainMiniMap._portals[showNameIndex] or {}
            local showName = string.gsub(showConfig.sShowName or "", "%s+", "") 
            if string.len(showName) == 0 then 
                return false
            end 

            local miniMapPos = MainMiniMap.CalcMiniMapPos(tonumber(showConfig.X) or 1, tonumber(showConfig.Y) or 1)
            GUI:setPosition(MainMiniMap._nameText, miniMapPos.x, miniMapPos.y + 13)
            GUI:setPosition(MainMiniMap._icon, miniMapPos.x, miniMapPos.y)

            local color = tonumber(showConfig.nColor) and SL:GetHexColorByStyleId(tonumber(showConfig.nColor)) or showConfig.nColor
            GUI:Text_setTextColor(MainMiniMap._nameText, color)
            GUI:Text_enableOutline(MainMiniMap._nameText, "#000000", tonumber(showConfig.bOutLine) or 0)
            GUI:Text_setString(MainMiniMap._nameText, showName)

            local imgPath = showConfig.sImgPath or "icon_xdtzy_04.png"
            GUI:Image_loadTexture(MainMiniMap._icon, MainMiniMap._path .. imgPath)
            GUI:setVisible(MainMiniMap._icon, true)
        end
    else
        MainMiniMap._markPortalIdx = nil
        GUI:Text_setString(MainMiniMap._nameText, "")
        GUI:setVisible(MainMiniMap._icon, false)
    end
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

    GUI:setPosition(actorPoint, MainMiniMap.CalcMiniMapPos(posX, posY))
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
        MainMiniMap.UpdateMapPos()
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

function MainMiniMap.OnReleaseMemory()
    for _, cell in pairs(MainMiniMap._pointCache) do
        GUI:autoDecRef(cell)
    end
    MainMiniMap._pointCache = {}
end

MainMiniMap.main()