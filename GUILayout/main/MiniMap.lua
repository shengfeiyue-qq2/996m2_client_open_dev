MiniMap = {}
MiniMap._layer      = nil
MiniMap._miniMapWid = 0  -- 小地图宽
MiniMap._miniMapHei = 0  -- 小地图高
MiniMap._pointCache = {} -- 寻路点缓存
MiniMap._released   = false
MiniMap._colors     = {[1] = "#00ff00", [2] = "#ff0000"} --绿色 红色
MiniMap._isPc       = SL:GetValue("IS_PC_OPER_MODE")

function MiniMap.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.MiniMapGUI) then
        return
    end

    MiniMap.Reset()

    MiniMap._layer = GUI:Win_Create(UIConst.LAYERID.MiniMapGUI, 0, 0, 0, 0, false, false, true, true)
    if MiniMap._isPc then 
        GUI:LoadExport(MiniMap._layer, "minimap/mini_map_win32")
    else 
        GUI:LoadExport(MiniMap._layer, "minimap/mini_map")
    end 
    MiniMap._ui = GUI:ui_delegate(MiniMap._layer)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    if MiniMap._isPc then 
        GUI:setPosition(MiniMap._ui["Panel_1"], screenW / 2, SL:GetValue("PC_POS_Y"))
        GUI:Win_SetDrag( MiniMap._layer, MiniMap._ui["Panel_minimap"]) --拖拽
    else 
        local function closeLayer()
            UIOperator:CloseMiniMap()
        end
        GUI:setPosition(MiniMap._ui["Panel_1"], screenW / 2, screenH / 2)
        GUI:setContentSize(MiniMap._ui["CloseLayout"], screenW, screenH)
        GUI:addOnClickEvent(MiniMap._ui["CloseLayout"], closeLayer)
        GUI:addOnClickEvent(MiniMap._ui["CloseButton"], closeLayer)
    end 

    -- 自定义组件挂接
    SL:AttachTXTSUI({root  = MiniMap._ui["Panel_1"], index = SLDefine.SUIComponentTable.MiniMap})

    MiniMap.RegisterEvent()

    MiniMap.InitMiniMap()
    MiniMap.InitPortals()
    MiniMap.InitTeamMember()
    MiniMap.InitMonsters()
    MiniMap.InitMapLinks()

    MiniMap.BlinkPlayer()
end

function MiniMap.Reset()
    MiniMap._imgPlayerBlink = nil
    MiniMap._pathCells      = {}
end

function MiniMap.OnCloseWin(id)
    if id ~= UIConst.LAYERID.MiniMapGUI then
        return
    end
    --移除挂件
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.MiniMap
    })
    MiniMap.Reset()
    MiniMap.RemoveEvent()
    MiniMap._layer = nil
end

function MiniMap.InitMiniMap()
    MiniMap._nodePath      = MiniMap._ui["Node_path"]
    MiniMap._panelMap      = MiniMap._ui["Panel_map"]
    MiniMap._panelMiniMap  = MiniMap._ui["Panel_minimap"]
    MiniMap._panelTouch    = MiniMap._ui["Panel_event"]
    MiniMap._imgMiniMap    = MiniMap._ui["Image_mini_map"]
    MiniMap._imgPoint      = MiniMap._ui["Image_point"]
    MiniMap._imgPlayer     = MiniMap._ui["Image_player"]
    MiniMap._textPoint     = MiniMap._ui["Text_point"]
    MiniMap._nodeMonster   = GUI:Node_Create(MiniMap._panelMiniMap, "Node_monster_", 0.00, 0.00)
    MiniMap._nodeTeam      = GUI:Node_Create(MiniMap._panelMiniMap, "Node_team_", 0.00, 0.00)
    MiniMap._nodePortal    = GUI:Node_Create(MiniMap._panelMiniMap, "Node_portals_", 0.00, 0.00)
    MiniMap._nodeLinks     = GUI:Node_Create(MiniMap._panelMiniMap, "Node_links_", 0.00, 0.00)

    MiniMap.loadSizeData()

    GUI:setVisible(MiniMap._imgPoint, false)
    GUI:setLocalZOrder(MiniMap._imgPoint, 999)
    GUI:setLocalZOrder(MiniMap._textPoint, 999)
    GUI:setLocalZOrder(MiniMap._imgPlayer, 999)

    GUI:Image_loadTexture(MiniMap._imgMiniMap, SL:GetValue("MINIMAP_FILE"))
    GUI:setIgnoreContentAdaptWithSize(MiniMap._imgMiniMap, true)

    -- 设置小地图的宽高
    local limitSize = GUI:getContentSize(MiniMap._panelMiniMap)
    local size = GUI:getContentSize(MiniMap._imgMiniMap)
    local scaleX = limitSize.width / size.width
    local sceleY = limitSize.height / size.height
    GUI:setScaleX(MiniMap._imgMiniMap, scaleX)
    GUI:setScaleY(MiniMap._imgMiniMap, sceleY)

    -- 设置触摸事件的宽高
    MiniMap._miniMapWid = size.width * scaleX
    MiniMap._miniMapHei = size.height * sceleY
    GUI:setContentSize(MiniMap._panelTouch, MiniMap._miniMapWid, MiniMap._miniMapHei)

    local function mapCallback(touchPos, isTrans)
        GUI:delayTouchEnabled(MiniMap._panelTouch, 0.5)
        local touchPosition = touchPos or GUI:getTouchEndPosition(MiniMap._panelTouch)
        local nodePos = GUI:convertToNodeSpace(MiniMap._panelTouch, touchPosition.x, touchPosition.y)
        local scaleX = nodePos.x / MiniMap._miniMapWid
        local scaleY = (MiniMap._miniMapHei - nodePos.y) / MiniMap._miniMapHei -- Y轴比例反的

        -- 向目标点移动
        local mapX = 0
        local mapY = 0
        local mapRow = SL:GetValue("MAP_ROWS")
        local mapCol = SL:GetValue("MAP_COLS")
        if mapRow and mapCol then 
            mapX = math.ceil(scaleX * mapCol)
            mapY = math.ceil(scaleY * mapRow)

            local function autoMove(mapX, mapY)
                -- 自动寻路
                local mapid = SL:GetValue("MAP_ID")
                local posX = mapX
                local posY = mapY
                SL:SetValue("BATTLE_MOVE_BEGIN", mapid, posX, posY)
            end
            -- pc 寻路聊天框提示
            if MiniMap._isPc then
                autoMove(mapX, mapY)

                local pathPoints = SL:GetValue("MAP_PATH_POINTS") or {}
                if #pathPoints == 0 then
                    SL:ShowSystemChat(string.format("自动移动坐标点(%s:%s)不可到达", mapX, mapY), 154, 255)
                else
                    SL:ShowSystemChat(string.format("自动移动至坐标(%s:%s)，点击鼠标任意键停止...", mapX, mapY), 154, 255)
                end

                -- 是否阻挡
                if SL:GetValue("MAP_IS_OBSTACLE", mapX, mapY) then
                    return
                end  

                -- 直接传送
                if isTrans then 
                    local msg = string.format("okmove %s %s", mapX, mapY)
                    SL:RequestSendChatGMMsg(msg)
                    return
                end
            else
                -- 是否阻挡
                if SL:GetValue("MAP_IS_OBSTACLE", mapX, mapY) then
                    return
                end 
                -- 直接传送
                if isTrans then 
                    local msg = string.format("okmove %s %s", mapX, mapY)
                    SL:RequestSendChatGMMsg(msg)
                    return
                end
                autoMove(mapX, mapY)
            end
        end
    end

    if MiniMap._isPc then
        -- 鼠标坐标
        local textMousePos = MiniMap._ui["Text_mouse_pos"]
        GUI:setVisible(textMousePos, false)

        local function mouseInside()
            GUI:setVisible(textMousePos, true)
            local mmapSize  = {width = MiniMap._miniMapWid, height = MiniMap._miniMapHei}
            local mousePos  = SL:GetValue("MOUSE_MOVE_POS")
            local nodePos   = GUI:convertToNodeSpace(MiniMap._panelTouch, mousePos.x, mousePos.y)
            local sliceRows = SL:GetValue("MAP_ROWS")
            local sliceCols = SL:GetValue("MAP_COLS")
            if sliceRows and sliceCols then 
                local mmapPosX  = math.ceil((nodePos.x / mmapSize.width) * sliceCols)
                local mmapPosY  = math.ceil((1-(nodePos.y / mmapSize.height)) * sliceRows)
                GUI:Text_setString(textMousePos, string.format("%s:%s", mmapPosX, mmapPosY))
            end
        end

        local function mouseLeave()
            GUI:setVisible(textMousePos, false)
        end

        GUI:addMouseMoveEvent(
            MiniMap._panelTouch,
            {
                onInsideFunc = mouseInside,
                onLeaveFunc = mouseLeave
            }
        )

        -- 右键传送
        local function mouseRightDown()
            local mmapSize  = {width = MiniMap._miniMapWid, height = MiniMap._miniMapHei}
            local mousePos  = SL:GetValue("MOUSE_MOVE_POS")
            local nodePos   = GUI:convertToNodeSpace(MiniMap._panelTouch, mousePos.x, mousePos.y)
            local sliceRows = SL:GetValue("MAP_ROWS")
            local sliceCols = SL:GetValue("MAP_COLS")
            if sliceRows and sliceCols then 
                local mmapPosX  = math.ceil((nodePos.x / mmapSize.width) * sliceCols)
                local mmapPosY  = math.ceil((1-(nodePos.y / mmapSize.height)) * sliceRows)
                local msg = string.format("okmove %s %s", mmapPosX, mmapPosY)
                SL:RequestSendChatGMMsg(msg)
            end
        end
        GUI:addMouseButtonEvent(
            MiniMap._panelTouch,
            {
                onRightDownFunc = mouseRightDown,
            }
        )

        local function onTouch(sender, event)
            if event == GUIDefine.TouchEventType.BEGAN then
                local touchPos = GUI:getTouchBeganPosition(sender)
                mapCallback(touchPos)
            end
        end
        GUI:addOnTouchEvent(MiniMap._panelTouch, onTouch)
    else
        local touchLongTime = 1 --长按时间
        local logActionTag = 9962
        local isMoveMap = false
        local function onTouch(sender, event)
            if event == GUIDefine.TouchEventType.BEGAN then
                GUI:stopActionByTag(sender, logActionTag)
                isMoveMap = true
                local touchPos = GUI:getTouchBeganPosition(sender)
                GUI:performWithDelay(sender, function()
                    isMoveMap = false
                    mapCallback(touchPos, true)
                end, touchLongTime)
            elseif event == GUIDefine.TouchEventType.ENDED or event == GUIDefine.TouchEventType.CANCALED then
                GUI:stopActionByTag(sender, logActionTag)
                if isMoveMap and event == GUIDefine.TouchEventType.ENDED then
                    mapCallback()
                end
            end
        end

        GUI:addOnTouchEvent(MiniMap._panelTouch, onTouch)
        GUI:setMouseRSwallowTouches(MiniMap._ui["Panel_1"])
    end

    local function callback()
        MiniMap.UpdatePathPoint()
        MiniMap.UpdatePlayerPos()
    end

    SL:schedule(MiniMap._panelMap, callback, 1/60)
    MiniMap.UpdateFindPath()
    MiniMap.UpdatePathPoint()
    MiniMap.UpdatePlayerPos()
end 

-- 更新寻路图片
function MiniMap.UpdatePathPoint()
    local maxDiff = SL:GetValue("MAP_PATH_SIZE")
    if maxDiff > 0 then
        local currIndex = SL:GetValue("MAP_CURRENT_PATH_INDEX")
        if not currIndex then
            return
        end
        
        for i, cell in pairs(MiniMap._pathCells) do
            if i * 2 > currIndex - 2 then
                GUI:setVisible(cell, false)
            end
        end
    else
        GUI:removeAllChildren(MiniMap._nodePath)
        GUI:stopAllActions(MiniMap._nodePath)
        MiniMap._pathCells = {}
        GUI:setVisible(MiniMap._imgPoint, false)
    end
end

-- 更新人物坐标点
function MiniMap.UpdatePlayerPos()
    -- pos
    local playerPos = SL:GetValue("POS")
    local nodePos = MiniMap.CalcMiniMapPosByWorldPos(playerPos)
    GUI:setPosition(MiniMap._imgPlayer, nodePos.x, nodePos.y)
    -- name
    if not MiniMap._isPc then 
        local mapName = SL:GetValue("MAP_NAME")
        GUI:Text_setString(MiniMap._ui["Text_mapName"], mapName)
        local color1 = MiniMap._colors and MiniMap._colors[1] or "#00ff00"
        local color2 = MiniMap._colors and MiniMap._colors[2] or "#ff0000"
        local bSafeArea = SL:GetValue("MAP_IS_IN_SAFE_AREA")
        GUI:Text_setTextColor(MiniMap._ui["Text_mapName"], bSafeArea and color1 or color2)
    end
end

-- 绘制寻路路径
function MiniMap.UpdateFindPath()
    GUI:removeAllChildren(MiniMap._nodePath)
    GUI:stopAllActions(MiniMap._nodePath)
    MiniMap._pathCells = {}

    local maxDiff = SL:GetValue("MAP_PATH_SIZE")
    if maxDiff > 2 then
        local pathPoints = SL:GetValue("MAP_PATH_POINTS") or {}
        local lastPoint = nil
        for i, v in ipairs(pathPoints) do
            local miniMapPos = MiniMap.CalcMiniMapPos(v)
            if miniMapPos and lastPoint and i % 2 ~= 0 then
                local imgPoint = MiniMap.GetPathPointCell(miniMapPos)
                GUI:setPosition(imgPoint, miniMapPos.x, miniMapPos.y)
                GUI:setVisible(imgPoint, true)
                table.insert(MiniMap._pathCells, imgPoint)
            end
            lastPoint = miniMapPos

            if i == 1 then
                MiniMap.UpdatDestPoint(miniMapPos.x, miniMapPos.y, v.x, v.y)
            end
        end
    end
end

-- 获取寻路图片
function MiniMap.GetPathPointCell(nodePos)
    local index = nodePos.y * 65535 + nodePos.x
    local pointCell = nil
    local cacheSize = #MiniMap._pointCache 
    if cacheSize > 0 then
        pointCell = MiniMap._pointCache[cacheSize]
        MiniMap._pointCache[cacheSize] = nil
        GUI:addChild(MiniMap._nodePath, pointCell)
        GUI:setName(pointCell, "pointCell"..index)
        GUI:decRef(pointCell)
        return pointCell
    end

    pointCell = GUI:Image_Create(MiniMap._nodePath, "pointCell"..index, 0, 0, "res/private/minimap/icon_xdtzy_05.png")
    
    local function callback()
        if not MiniMap._released then 
            GUI:addRef(pointCell)
            table.insert(MiniMap._pointCache, pointCell)
        end   
    end 
    SL:RegisterWndEvent(pointCell, "point", WND_EVENT_WND_DESTROY, callback)
    return pointCell
end

-- 地图坐标 转 Node坐标
function MiniMap.CalcMiniMapPos(mapPos)
    local mapRow = SL:GetValue("MAP_ROWS")
    local mapCol = SL:GetValue("MAP_COLS")
    local nodePos = nil
    if mapRow and mapCol then 
        local scaleX = mapPos.x / mapCol
        local scaleY = 1 - (mapPos.y / mapRow)
        nodePos = {}
        nodePos.x = scaleX * MiniMap._miniMapWid
        nodePos.y = scaleY * MiniMap._miniMapHei
        local panelSize = GUI:getContentSize(MiniMap._panelMiniMap)
        local offsetX = panelSize.width / 2 - MiniMap._miniMapWid / 2
        local offsetY = panelSize.height / 2 - MiniMap._miniMapHei / 2

        nodePos.x  = nodePos.x + offsetX
        nodePos.y = nodePos.y + offsetY
    end 
    return nodePos 
end

-- 世界坐标 转 Node坐标
function MiniMap.CalcMiniMapPosByWorldPos(worldPos)
    local panelSize = GUI:getContentSize(MiniMap._panelMiniMap) 
    local offsetX = panelSize.width / 2 - MiniMap._miniMapWid / 2
    local offsetY = panelSize.height / 2 - MiniMap._miniMapHei / 2
    local mapWidPixel = SL:GetValue("MAP_SIZE_WIDTH_PIXEL") 
    local mapHeiPixel = SL:GetValue("MAP_SIZE_HEIGHT_PIXEL")
    local posX = worldPos.x / mapWidPixel * MiniMap._miniMapWid
    local posY = (mapHeiPixel + worldPos.y) / mapHeiPixel * MiniMap._miniMapHei
    local nodePos = {}
    nodePos.x = posX + offsetX
    nodePos.y = posY + offsetY
    return nodePos
end

-- 显示坐标提示（X:Y）
function MiniMap.UpdatDestPoint(minimapX, minimapY, mapX, mapY)
    GUI:setVisible(MiniMap._imgPoint, true)
    GUI:setPosition(MiniMap._imgPoint, minimapX, minimapY + 20)
    GUI:Text_setString(MiniMap._textPoint, string.format("(%s,%s)", mapX, mapY))
end

-- 人物坐标动画
function MiniMap.BlinkPlayer()
    if not MiniMap._imgPlayerBlink then
        local size = GUI:getContentSize(MiniMap._imgPlayer)
        MiniMap._imgPlayerBlink = GUI:Image_Create(MiniMap._imgPlayer, "playerAni", size.width/2, size.height/2, "res/public/lizi.png")
        GUI:setAnchorPoint(MiniMap._imgPlayerBlink, 0.5, 0.5)
    end
    GUI:stopAllActions(MiniMap._imgPlayerBlink)
    GUI:setVisible(MiniMap._imgPlayerBlink, true)

    local scaleAct = GUI:ActionSequence(GUI:ActionScaleTo(0.2, 3), GUI:ActionScaleTo(0.2, 1))
    local action = GUI:ActionSequence(GUI:ActionRepeat(scaleAct, 2), GUI:ActionHide())
    GUI:runAction(MiniMap._imgPlayerBlink, action)
end

function MiniMap.InitMonsters()
    SL:RequestMiniMapMonsters()
end

-- 更新怪物坐标
function MiniMap.UpdateMonsters()
    GUI:removeAllChildren(MiniMap._nodeMonster)
    local monsters = SL:GetValue("MINIMAP_MONSTERS")
    for i, v in ipairs(monsters) do
        local mapX = tonumber(v.x) or 1
        local mapY = tonumber(v.y) or 1
        local nodePos = MiniMap.CalcMiniMapPos({x = mapX, y = mapY})
        if nodePos then 
            local node = GUI:Node_Create(MiniMap._nodeMonster, "node_monster" .. i, nodePos.x, nodePos.y)

            -- 显示
            local path = (v.time and v.time > 0) and "icon_xdtzy_10_6.png" or "icon_xdtzy_10_1.png"
            local icon = GUI:Image_Create(node, "icon", 0, 0, "res/private/minimap/" .. path)
            GUI:setAnchorPoint(icon, 0.5, 0.5)
            GUI:setScale(icon, 0.7)

            local nameBG = GUI:Image_Create(node,"nameBG", 0, 20, "res/private/minimap/icon_xdtzy_06.png")
            GUI:setIgnoreContentAdaptWithSize(nameBG, false)
            GUI:setAnchorPoint(nameBG, 0.5, 0.5)

            local textName = GUI:Text_Create(node, "textName", 0, 20, 14, "#ffffff", "")
            local monsterColor = v.color or "#ffffff"
            if v.color and tonumber(v.color) then
                monsterColor = SL:GetHexColorByStyleId(tonumber(v.color))
            end
            GUI:Text_setTextColor(textName, monsterColor)
            GUI:Text_enableOutline(textName, "#000000", 1)
            GUI:Text_setString(textName, v.name)
            GUI:setAnchorPoint(textName, 0.5, 0.5)

            local textTime = GUI:Text_Create(node, "textTime", 0, 0, 13, "#ffffff", "")
            GUI:Text_setTextColor(textTime, "#ffff00")
            GUI:Text_enableOutline(textTime, "#000000", 1)
            GUI:setAnchorPoint(textTime, 0.5, 0.5)

            local endTime = SL:GetValue("SERVER_TIME") + v.time
            local function callback()
                local remaining = math.max(endTime - SL:GetValue("SERVER_TIME"), 0)
                local suffix = (remaining and remaining > 0) and SL:TimeFormatToStr(remaining) or ""
                GUI:Text_setString(textTime, suffix)
                if suffix and string.len( suffix ) > 0 then
                    GUI:setPosition(textName, 0, 36)
                    GUI:setPosition(nameBG, 0, 36)
                    GUI:setPosition(textTime, 0, 20)
                else
                    GUI:setPosition(textName, 0, 20)
                    GUI:setPosition(nameBG, 0, 20)
                end
            end
            SL:schedule(textTime, callback, 1)
            callback()

            local zOrder = MiniMap._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

function MiniMap.InitTeamMember()
    local function callback()
        local memberCount = SL:GetValue("TEAM_MEMBER_COUNT") 
        if memberCount > 1 then
            SL:RequestMiniMapTeam()
        end
    end

    SL:schedule(MiniMap._nodeTeam, callback , 2)
    callback()
end

-- 更新组队坐标
function MiniMap.UpdateTeamMember(data)
    GUI:removeAllChildren(MiniMap._nodeTeam)
    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT") 
    for i, player in ipairs(data) do
        local  mainUid = SL:GetValue("USER_ID")
        if player.UserId ~= tostring(mainUid) then
            local mapX = tonumber(player.X) or 1
            local mapY = tonumber(player.Y) or 1
            local nodePos = MiniMap.CalcMiniMapPos({x = mapX, y = mapY})
            if nodePos then 
                local node = GUI:Node_Create(MiniMap._nodeTeam, "node_team"..i, nodePos.x, nodePos.y)
        
                -- icon
                local icon = GUI:Image_Create(node, "icon", 0, 0, "res/private/minimap/icon_xdtzy_04.png")
                GUI:setAnchorPoint(icon, 0.5, 0.5)

                -- name
                local textName = GUI:Text_Create(node, "textName", 0, 14, 13, "#ffffff", player.UserName)
                GUI:setAnchorPoint(textName, 0.5, 0.5)
                local nameColor = SL:GetHexColorByStyleId(254)
                GUI:Text_setTextColor(textName, nameColor)
                GUI:Text_enableOutline(textName, "#000000", 1)

                local zOrder = MiniMap._miniMapHei - nodePos.y
                GUI:setLocalZOrder(node, zOrder)
            end 
        end
    end
end

-- 更新NPC相关坐标
function MiniMap.InitPortals()
    GUI:removeAllChildren(MiniMap._nodePortal)
    local portals = SL:GetValue("MINIMAP_PORTALS")
    for i, v in pairs(portals) do
        local mapX = tonumber(v.X) or 1
        local mapY = tonumber(v.Y) or 1
        local nodePos = MiniMap.CalcMiniMapPos({x = mapX, y = mapY})
        local bShow = true 
        local showName = string.gsub(v.sShowName or "", "%s+", "") 
        if string.len(showName) == 0 then 
            bShow = false 
        end 

        if nodePos and bShow then 
            local node = GUI:Node_Create(MiniMap._nodePortal, "node_portal"..i, nodePos.x, nodePos.y)

            -- icon
            local path = v.sImgPath or "icon_xdtzy_04.png"
            local icon = GUI:Image_Create(node, "icon", 0, 0, "res/private/minimap/"..path)
            GUI:setAnchorPoint(icon, 0.5, 0.5)

            -- bg
            local nameBG = GUI:Image_Create(node, "nameBG", 0, 12, "res/private/minimap/icon_xdtzy_06.png")
            GUI:setIgnoreContentAdaptWithSize(nameBG, false)
            GUI:setAnchorPoint(nameBG, 0.5, 0.5)

            -- name
            local textName = GUI:Text_Create(node, "textName", 0, 12, 14, "#ffffff", showName)
            local portalColor = v.nColor or "#ffffff"
            if v.nColor and tonumber(v.nColor) then
                portalColor = SL:GetHexColorByStyleId(tonumber(v.nColor)) 
            end
            GUI:Text_setTextColor(textName, portalColor)
            GUI:Text_enableOutline(textName, "#000000", tonumber(v.bOutLine) or 1)
            GUI:setAnchorPoint(textName, 0.5, 0.5)

            -- 
            if v.xunlu and tonumber(v.xunlu) then
                if tonumber(v.xunlu) == 0 then
                    GUI:setTouchEnabled(icon, false)
                elseif tonumber(v.xunlu) == 1 then
                    local function autoMove( ... )
                        -- 自动寻路
                        local mapid = SL:GetValue("MAP_ID") 
                        local posX = mapX
                        local posY = mapY
                        SL:SetValue("BATTLE_MOVE_BEGIN", mapid, posX, posY)
                    end
                    GUI:setTouchEnabled(icon, true)
                    GUI:addOnClickEvent(icon, autoMove)

                    GUI:setTouchEnabled(textName, true)
                    GUI:addOnClickEvent(textName, autoMove)
                elseif tonumber(v.xunlu) == 2 then 
                    local function moveTo(sender)
                        -- 直接传送
                        local msg = string.format("okmove %s %s", mapX, mapY)
                        SL:RequestSendChatGMMsg(msg)
                        GUI:delayTouchEnabled(sender)
                    end

                    GUI:setTouchEnabled(icon, true)
                    GUI:addOnClickEvent(icon, moveTo)

                    GUI:setTouchEnabled(textName, true)
                    GUI:addOnClickEvent(textName, moveTo)
                end
            end

            local zOrder = MiniMap._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

-- 展示地图连接点
function MiniMap.InitMapLinks()
    GUI:removeAllChildren(MiniMap._nodeLinks)
    local linkPoints = SL:GetMetaValue("MAP_LINKS_BY_ID", SL:GetValue("MAP_ID"))
    if not linkPoints or not next(linkPoints) then
        return
    end
    for i, v in ipairs(linkPoints) do
        local mapX = tonumber(v.mapX) or 1
        local mapY = tonumber(v.mapY) or 1
        local nodePos = MiniMap.CalcMiniMapPos({x = mapX, y = mapY})
        local bShow = true 
        local showName = v.showName
        local showBg = v.showBg
        if not showName or string.len(showName) == 0 then 
            bShow = false 
        end
        if not showBg or string.len(showBg) == 0 then 
            bShow = false 
        end

        local function autoMove()
            -- 自动寻路
            local mapID = SL:GetValue("MAP_ID") 
            local posX = mapX
            local posY = mapY
            SL:SetValue("BATTLE_MOVE_BEGIN", mapID, posX, posY)
        end
        if nodePos and bShow then 
            local node = GUI:Node_Create(MiniMap._nodeLinks, "node_link_" .. i, nodePos.x, nodePos.y)
    
            -- bg
            local nameBG = GUI:Image_Create(node, "nameBG", 0, 0, "res/private/minimap/" .. v.showBg)
            GUI:setIgnoreContentAdaptWithSize(nameBG, false)
            GUI:setAnchorPoint(nameBG, 0.5, 0.5)

            -- name
            local textName = GUI:Text_Create(node, "textName", 0, 0, 14, "#ffffff", showName)
            GUI:Text_setTextColor(textName, SL:GetHexColorByStyleId(v.colorID or 255))
            GUI:Text_enableOutline(textName, "#000000", 1)
            GUI:setAnchorPoint(textName, 0.5, 0.5)

            GUI:setTouchEnabled(nameBG, true)
            GUI:addOnClickEvent(nameBG, autoMove)

            GUI:setTouchEnabled(textName, true)
            GUI:addOnClickEvent(textName, autoMove)

            local zOrder = MiniMap._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

-- 清除缓存
function MiniMap.OnReleaseMemory()
    for key, value in pairs(MiniMap._pointCache) do
        GUI:decRef(value)
    end
    MiniMap._pointCache = {}
    MiniMap._released   = true
end

function MiniMap.loadSizeData()
    if MiniMap._isPc then
        return
    end
    local config = SL:GetValue("GAME_DATA", "MiniMap")
    if not config then
        return
    end
    local data = string.split(config, "#")
    if tonumber(data[1]) and tonumber(data[2]) then
        local pos = GUI:getPosition(MiniMap._panelMap)
        GUI:setPosition(MiniMap._panelMap, pos.x + tonumber(data[1]) , pos.y + tonumber(data[2]))
    end

    if tonumber(data[3]) and tonumber(data[4]) then
        local size = {width = tonumber(data[3]), height = tonumber(data[4])}

        GUI:setContentSize(MiniMap._panelMap, size.width, size.height)
        GUI:setContentSize(MiniMap._ui.Image_bg, size.width, size.height)
        GUI:setIgnoreContentAdaptWithSize(MiniMap._ui.Image_bg, false)
        GUI:setPosition(MiniMap._ui.Image_bg, size.width / 2, size.height / 2)

        GUI:setContentSize(MiniMap._panelMiniMap, size.width, size.height)
        GUI:setPosition(MiniMap._panelMiniMap, size.width / 2, size.height / 2)
        GUI:setPosition(MiniMap._imgMiniMap, size.width / 2, size.height / 2)
        GUI:setPosition(MiniMap._panelTouch, size.width / 2, size.height / 2)
    end
end

function MiniMap.OnChangeScene(data)
    SL:onLUAEvent(LUA_EVENT_MINIMAP_PLAYER)
end

function MiniMap.OnMapInfoChange()
    UIOperator:CloseMiniMap()
end

-----------------------------------注册事件--------------------------------------
function MiniMap.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_FIND_PATH,   "MiniMap", MiniMap.UpdateFindPath)     -- 寻路路径
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_MONSTER,     "MiniMap", MiniMap.UpdateMonsters)     -- 怪物坐标
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_PLAYER,      "MiniMap", MiniMap.BlinkPlayer)        -- 人物坐标
    SL:RegisterLUAEvent(LUA_EVENT_MINIMAP_TEAM,        "MiniMap", MiniMap.UpdateTeamMember)   -- 队伍坐标
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN,            "MiniMap", MiniMap.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_MAP_INFO_CHANGE,     "MiniMap", MiniMap.OnMapInfoChange)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE,         "MiniMap", MiniMap.OnChangeScene)
    SL:RegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "MiniMap", MiniMap.OnReleaseMemory)   -- 释放游戏内存
end

function MiniMap.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MINIMAP_FIND_PATH,   "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_MINIMAP_MONSTER,     "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_MINIMAP_PLAYER,      "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_MINIMAP_TEAM,        "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN,            "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAP_INFO_CHANGE,     "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_CHANGESCENE,         "MiniMap")
    SL:UnRegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "MiniMap")
end

MiniMap.main()