MiniMap_Other = {}
MiniMap_OtherInfo = MiniMap_OtherInfo or {} 
MiniMap_Other._layer      = nil
MiniMap_Other._miniMapWid = 0  -- 小地图宽
MiniMap_Other._miniMapHei = 0  -- 小地图高
MiniMap_Other._colors     = {[1] = "#00ff00", [2] = "#ff0000"} --绿色 红色
MiniMap_Other._isPc       = SL:GetValue("IS_PC_OPER_MODE")

MiniMap_Other._mapID      = nil


function MiniMap_Other.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local mapID = data and data.Mapid
    -- 地图ID 
    MiniMap_Other._mapID = mapID
    if not MiniMap_Other._mapID then
        SL:Print("other MiniMap mapID is nil.")
        return
    end

    -- 怪物信息
    MiniMap_Other._monsterData = data and data.Info

    local width = data and data.Width 
    local height = data and data.Height

    MiniMap_Other._rows = height
    MiniMap_Other._cols = width

    if GUI:GetWindow(nil, UIConst.LAYERID.MiniMapOtherGUI) then
        MiniMap_Other.InitLoad()
        return
    end

    MiniMap_Other._layer = GUI:Win_Create(UIConst.LAYERID.MiniMapOtherGUI, 0, 0, 0, 0, false, false, true, true)
    if MiniMap_Other._isPc then 
        GUI:LoadExport(MiniMap_Other._layer, "minimap/mini_map_other_win32")
    else 
        GUI:LoadExport(MiniMap_Other._layer, "minimap/mini_map_other")
    end 
    MiniMap_OtherInfo._ui = GUI:ui_delegate(MiniMap_Other._layer)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    if MiniMap_Other._isPc then 
        GUI:setPosition(MiniMap_OtherInfo._ui["Panel_1"], screenW / 2, SL:GetValue("PC_POS_Y"))
        GUI:Win_SetDrag(MiniMap_Other._layer, MiniMap_OtherInfo._ui["Panel_minimap"]) --拖拽
    else 
        local function closeLayer()
            UIOperator:CloseOtherMiniMap()
        end
        GUI:setPosition(MiniMap_OtherInfo._ui["Panel_1"], screenW / 2, screenH / 2)
        GUI:setContentSize(MiniMap_OtherInfo._ui["CloseLayout"], screenW, screenH)
        GUI:addOnClickEvent(MiniMap_OtherInfo._ui["CloseLayout"], closeLayer)
        GUI:addOnClickEvent(MiniMap_OtherInfo._ui["CloseButton"], closeLayer)
    end 

    MiniMap_Other.InitMiniMap()

    MiniMap_Other.InitLoad()

    MiniMap_Other.RegisterEvent()

end

function MiniMap_Other.InitLoad()
    if not MiniMap_Other._mapID then
        return
    end

    local path = SL:GetMetaValue("MINIMAP_FILE_BY_ID", MiniMap_Other._mapID)
    MiniMap_Other._miniFile = path
    if not SL:IsFileExist(path) then
        SL:DownLoadRes(path, nil, function(isOk)
            if isOk then
                MiniMap_Other.UpdateMapShow()
            end
        end)
    else
        MiniMap_Other.UpdateMapShow()
    end
end

function MiniMap_Other.UpdateMapShow()
    MiniMap_Other.UpdateMapInfo()
    MiniMap_Other.InitMapLinks()
    MiniMap_Other.InitPortals()
    MiniMap_Other.UpdateMonsters()
end

function MiniMap_Other.OnCloseWin(id)
    if id ~= UIConst.LAYERID.MiniMapOtherGUI then
        return
    end

    MiniMap_Other.RemoveEvent()
    MiniMap_Other._layer = nil
end

function MiniMap_Other.InitMiniMap()
    MiniMap_OtherInfo._nodePath      = MiniMap_OtherInfo._ui["Node_path"]
    MiniMap_OtherInfo._panelMap      = MiniMap_OtherInfo._ui["Panel_map"]
    MiniMap_OtherInfo._panelMiniMap  = MiniMap_OtherInfo._ui["Panel_minimap"]
    MiniMap_OtherInfo._panelTouch    = MiniMap_OtherInfo._ui["Panel_event"]
    MiniMap_OtherInfo._imgMiniMap    = MiniMap_OtherInfo._ui["Image_mini_map"]
    MiniMap_OtherInfo._imgPoint      = MiniMap_OtherInfo._ui["Image_point"]
    MiniMap_OtherInfo._imgPlayer     = MiniMap_OtherInfo._ui["Image_player"]
    MiniMap_OtherInfo._textPoint     = MiniMap_OtherInfo._ui["Text_point"]
    MiniMap_OtherInfo._nodeMonster   = GUI:Node_Create(MiniMap_OtherInfo._panelMiniMap, "Node_monster_", 0.00, 0.00)
    MiniMap_OtherInfo._nodePortal    = GUI:Node_Create(MiniMap_OtherInfo._panelMiniMap, "Node_portals_", 0.00, 0.00)
    MiniMap_OtherInfo._nodeLinks     = GUI:Node_Create(MiniMap_OtherInfo._panelMiniMap, "Node_links_", 0.00, 0.00)

    MiniMap_Other.loadSizeData()

    GUI:setVisible(MiniMap_OtherInfo._imgPoint, false)
    GUI:setVisible(MiniMap_OtherInfo._imgPlayer, false)
    GUI:setLocalZOrder(MiniMap_OtherInfo._imgPoint, 999)
    GUI:setLocalZOrder(MiniMap_OtherInfo._textPoint, 999)
    GUI:setLocalZOrder(MiniMap_OtherInfo._imgPlayer, 999)

    if MiniMap_Other._isPc then
        -- 鼠标坐标
        local textMousePos = MiniMap_OtherInfo._ui["Text_mouse_pos"]
        GUI:setVisible(textMousePos, false)

        local function mouseInside()
            GUI:setVisible(textMousePos, true)
            local mousePos  = SL:GetValue("MOUSE_MOVE_POS")
            local nodePos   = GUI:convertToNodeSpace(MiniMap_OtherInfo._panelTouch, mousePos.x, mousePos.y)
            local mapRows   = MiniMap_Other._rows
            local mapCols   = MiniMap_Other._cols
            if mapRows and mapCols then 
                local mmapPosX  = math.ceil((nodePos.x / MiniMap_Other._miniMapWid) * mapCols)
                local mmapPosY  = math.ceil((1 - (nodePos.y / MiniMap_Other._miniMapHei)) * mapRows)
                GUI:Text_setString(textMousePos, string.format("%s:%s", mmapPosX, mmapPosY))
            end
        end

        local function mouseLeave()
            GUI:setVisible(textMousePos, false)
        end

        GUI:addMouseMoveEvent(
            MiniMap_OtherInfo._panelTouch,
            {
                onInsideFunc = mouseInside,
                onLeaveFunc = mouseLeave
            }
        )
    end

    local function mapCallback(touchPos)
        GUI:delayTouchEnabled(MiniMap_OtherInfo._panelTouch, 0.5)
        local touchPosition = touchPos or GUI:getTouchEndPosition(MiniMap_OtherInfo._panelTouch)
        local nodePos = GUI:convertToNodeSpace(MiniMap_OtherInfo._panelTouch, touchPosition.x, touchPosition.y)
        local scaleX = nodePos.x / MiniMap_Other._miniMapWid
        local scaleY = (MiniMap_Other._miniMapHei - nodePos.y) / MiniMap_Other._miniMapHei -- Y轴比例反的

        -- 发送目标点给引擎
        local mapX = 0
        local mapY = 0
        local mapRow = MiniMap_Other._rows
        local mapCol = MiniMap_Other._cols
        if mapRow and mapCol then 
            mapX = math.ceil(scaleX * mapCol)
            mapY = math.ceil(scaleY * mapRow)
            SL:RequestNotifyClickCrossMiniMap(mapX, mapY)
        end
    end

    local function onTouch(sender, event)
        if event == GUIDefine.TouchEventType.BEGAN then
            local touchPos = GUI:getTouchBeganPosition(sender)
            mapCallback(touchPos)
        end
    end
    GUI:addOnTouchEvent(MiniMap_OtherInfo._panelTouch, onTouch)

end

function MiniMap_Other.UpdateMapInfo()
    GUI:Image_loadTexture(MiniMap_OtherInfo._imgMiniMap, MiniMap_Other._miniFile)
    GUI:setIgnoreContentAdaptWithSize(MiniMap_OtherInfo._imgMiniMap, true)

    -- 设置小地图的宽高
    local limitSize = GUI:getContentSize(MiniMap_OtherInfo._panelMiniMap)
    local size = GUI:getContentSize(MiniMap_OtherInfo._imgMiniMap)
    local scaleX = limitSize.width / size.width
    local sceleY = limitSize.height / size.height
    GUI:setScaleX(MiniMap_OtherInfo._imgMiniMap, scaleX)
    GUI:setScaleY(MiniMap_OtherInfo._imgMiniMap, sceleY)

    -- 设置触摸事件的宽高
    MiniMap_Other._miniMapWid = size.width * scaleX
    MiniMap_Other._miniMapHei = size.height * sceleY
    GUI:setContentSize(MiniMap_OtherInfo._panelTouch, MiniMap_Other._miniMapWid, MiniMap_Other._miniMapHei)

    if not MiniMap_Other._isPc then 
        local mapName = SL:GetValue("MAP_NAME_BY_ID", MiniMap_Other._mapID)
        GUI:Text_setString(MiniMap_OtherInfo._ui["Text_mapName"], mapName)
    end
end

-- 地图坐标 转 Node坐标
function MiniMap_Other.CalcMiniMapPos(mapPos)
    local mapRow = MiniMap_Other._rows
    local mapCol = MiniMap_Other._cols
    local nodePos = nil
    if mapRow and mapCol then 
        local scaleX = mapPos.x / mapCol
        local scaleY = 1 - (mapPos.y / mapRow)
        nodePos = {}
        nodePos.x = scaleX * MiniMap_Other._miniMapWid
        nodePos.y = scaleY * MiniMap_Other._miniMapHei
        local panelSize = GUI:getContentSize(MiniMap_OtherInfo._panelMiniMap)
        local offsetX = panelSize.width / 2 - MiniMap_Other._miniMapWid / 2
        local offsetY = panelSize.height / 2 - MiniMap_Other._miniMapHei / 2

        nodePos.x  = nodePos.x + offsetX
        nodePos.y = nodePos.y + offsetY
    end 
    return nodePos 
end

-- 更新怪物坐标
function MiniMap_Other.UpdateMonsters()
    GUI:removeAllChildren(MiniMap_OtherInfo._nodeMonster)
    local monsters = MiniMap_Other._monsterData or {}
    for i, v in ipairs(monsters) do
        local mapX = tonumber(v.x) or 1
        local mapY = tonumber(v.y) or 1
        local nodePos = MiniMap_Other.CalcMiniMapPos({x = mapX, y = mapY})
        if nodePos then 
            local node = GUI:Node_Create(MiniMap_OtherInfo._nodeMonster, "node_monster" .. i, nodePos.x, nodePos.y)

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

            local zOrder = MiniMap_Other._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

-- 更新NPC相关坐标
function MiniMap_Other.InitPortals()
    GUI:removeAllChildren(MiniMap_OtherInfo._nodePortal)
    local portals = SL:GetValue("MINIMAP_PORTALS_BY_ID", MiniMap_Other._mapID)
    for i, v in pairs(portals) do
        local mapX = tonumber(v.X) or 1
        local mapY = tonumber(v.Y) or 1
        local nodePos = MiniMap_Other.CalcMiniMapPos({x = mapX, y = mapY})
        local bShow = true 
        local showName = string.gsub(v.sShowName or "", "%s+", "") 
        if string.len(showName) == 0 then 
            bShow = false 
        end 

        if nodePos and bShow then 
            local node = GUI:Node_Create(MiniMap_OtherInfo._nodePortal, "node_portal" .. i, nodePos.x, nodePos.y)

            -- icon
            local path = v.sImgPath or "icon_xdtzy_04.png"
            local icon = GUI:Image_Create(node, "icon", 0, 0, "res/private/minimap/" .. path)
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

            local zOrder = MiniMap_Other._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

-- 展示地图连接点
function MiniMap_Other.InitMapLinks()
    GUI:removeAllChildren(MiniMap_OtherInfo._nodeLinks)
    local linkPoints = SL:GetMetaValue("MAP_LINKS_BY_ID", MiniMap_Other._mapID)
    if not linkPoints or not next(linkPoints) then
        return
    end
    for i, v in ipairs(linkPoints) do
        local mapX = tonumber(v.mapX) or 1
        local mapY = tonumber(v.mapY) or 1
        local nodePos = MiniMap_Other.CalcMiniMapPos({x = mapX, y = mapY})
        local bShow = true 
        local showName = v.showName
        local showBg = v.showBg
        if not showName or string.len(showName) == 0 then 
            bShow = false 
        end
        if not showBg or string.len(showBg) == 0 then 
            bShow = false 
        end

        if nodePos and bShow then 
            local node = GUI:Node_Create(MiniMap_OtherInfo._nodeLinks, "node_link_" .. i, nodePos.x, nodePos.y)
    
            -- bg
            local nameBG = GUI:Image_Create(node, "nameBG", 0, 0, string.format("res/private/minimap/%s.png", v.showBg))
            GUI:setIgnoreContentAdaptWithSize(nameBG, false)
            GUI:setAnchorPoint(nameBG, 0.5, 0.5)

            -- name
            local textName = GUI:Text_Create(node, "textName", 0, 0, 14, "#ffffff", showName)
            GUI:Text_setTextColor(textName, SL:GetHexColorByStyleId(v.colorID or 255))
            GUI:Text_enableOutline(textName, "#000000", 1)
            GUI:setAnchorPoint(textName, 0.5, 0.5)

            local zOrder = MiniMap_Other._miniMapHei - nodePos.y
            GUI:setLocalZOrder(node, zOrder)
        end 
    end
end

function MiniMap_Other.loadSizeData()
    if MiniMap_Other._isPc then
        return
    end
    local config = SL:GetValue("GAME_DATA", "MiniMap")
    if not config then
        return
    end
    local data = string.split(config, "#")
    if tonumber(data[1]) and tonumber(data[2]) then
        local pos = GUI:getPosition(MiniMap_OtherInfo._panelMap)
        GUI:setPosition(MiniMap_OtherInfo._panelMap, pos.x + tonumber(data[1]) , pos.y + tonumber(data[2]))
    end

    if tonumber(data[3]) and tonumber(data[4]) then
        local size = {width = tonumber(data[3]), height = tonumber(data[4])}

        GUI:setContentSize(MiniMap_OtherInfo._panelMap, size.width, size.height)
        GUI:setContentSize(MiniMap_OtherInfo._ui.Image_bg, size.width, size.height)
        GUI:setIgnoreContentAdaptWithSize(MiniMap_OtherInfo._ui.Image_bg, false)
        GUI:setPosition(MiniMap_OtherInfo._ui.Image_bg, size.width / 2, size.height / 2)

        GUI:setContentSize(MiniMap_OtherInfo._panelMiniMap, size.width, size.height)
        GUI:setPosition(MiniMap_OtherInfo._panelMiniMap, size.width / 2, size.height / 2)
        GUI:setPosition(MiniMap_OtherInfo._imgMiniMap, size.width / 2, size.height / 2)
        GUI:setPosition(MiniMap_OtherInfo._panelTouch, size.width / 2, size.height / 2)
    end
end

-----------------------------------注册事件--------------------------------------
function MiniMap_Other.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MiniMap_Other", MiniMap_Other.OnCloseWin)
end

function MiniMap_Other.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "MiniMap_Other")
end

MiniMap_Other.main()