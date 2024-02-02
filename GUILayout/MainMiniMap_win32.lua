MainMiniMap = {}
MainMiniMap._path = "res/private/main-win32/"

MainMiniMap._minimapSize = {
    [1] = {width = 150, height = 150},
    [2] = {width = 200, height = 200},
}

-- 尺寸2是否跳过
MainMiniMap._skipStatus2 = false

MainMiniMap._curStatus = 0

function MainMiniMap.main()
    local parent = GUI:Attach_MainMiniMap()
    GUI:LoadExport(parent, "main/main_minimap_win32")

    MainMiniMap._parent = parent
    MainMiniMap._ui = GUI:ui_delegate(parent)

    if SL:GetMetaValue("GAME_DATA","PCMainMiniMapSize") then
        local sizeList = string.split(SL:GetMetaValue("GAME_DATA","PCMainMiniMapSize"), "|")
        local function setSize(index, paramStr)
            local size = string.split(paramStr, "#")
            if tonumber(size[1]) and tonumber(size[2]) then
                MainMiniMap._minimapSize[index] = {width = tonumber(size[1]), height = tonumber(size[2])}
            end
        end
        for _, v in ipairs(sizeList) do
            if v and string.len(v) > 0 then
                if tonumber(_) == 1 then
                    setSize(tonumber(_), v)
                elseif tonumber(_) == 2 then
                    if tonumber(v) then
                        MainMiniMap._skipStatus2 = tonumber(v) == 1
                    else
                        local data = string.split(v, "&")
                        MainMiniMap._skipStatus2 = tonumber(data[1]) and tonumber(data[1]) == 1
                        if data[2] and string.len(data[2]) > 0 then
                            setSize(tonumber(_), data[2])
                        end
                    end
                end
            end
        end
    end

    -- Panel_minimap
    local Panel_minimap = MainMiniMap._ui.Panel_minimap
    GUI:setCascadeOpacityEnabled(Panel_minimap, true)
    GUI:addOnClickEvent(Panel_minimap, function()
        if GUI:getOpacity(Panel_minimap) == 255 then
            GUI:setOpacity(Panel_minimap, 150)
        else
            GUI:setOpacity(Panel_minimap, 255)
        end
    end)

    -- 内部处理
    MainMiniMap.ChangeStatus(1)

    GUI:setVisible(MainMiniMap._ui.Text_mouse_pos, false)
    -- 鼠标移动事件
    MainMiniMap.InitMouseEvent()

    -- 键盘事件
    MainMiniMap.InitKeyCode()

    -- 地图状态改变
    MainMiniMap.UpdateMapState()
    -- 注册事件
    MainMiniMap.RegisterEvent()

end

function MainMiniMap.InitMouseEvent()
    GUI:addMouseMoveEvent(MainMiniMap._ui.Panel_minimap, {
        onEnterFunc = function ()
            if MainMiniMap._curStatus == 1 or MainMiniMap._curStatus == 2 then
                local isEnable = MainMiniMap.IsEnableMiniMap()
                if not isEnable then
                    return nil
                end

                GUI:setVisible(MainMiniMap._ui.Text_mouse_pos, true)
                local mousePos  = SL:GetMetaValue("MOUSE_MOVE_POS")
                local nodePos   = GUI:convertToNodeSpace(MainMiniMap._ui.Image_minimap, mousePos.x, mousePos.y)
                local sliceRows = SL:GetMetaValue("MAP_ROWS")
                local sliceCols = SL:GetMetaValue("MAP_COLS")
                local minimapSize = MainMiniMap.GetMiniMapSize()
                if not sliceRows or not sliceCols or not minimapSize then
                    SL:Print("error with minimap image or map load!!!")
                    return nil
                end
                
                local mmapPosX  = (nodePos.x / minimapSize.width) * sliceRows
                local mmapPosY  = (1 - (nodePos.y / minimapSize.height)) * sliceCols
                GUI:Text_setString(MainMiniMap._ui.Text_mouse_pos, string.format("%s:%s", math.floor(mmapPosX), math.floor(mmapPosY)))
            end
        end,
        onLeaveFunc = function ()
            local isEnable = MainMiniMap.IsEnableMiniMap()
            if not isEnable then
                return nil
            end
                
            GUI:setVisible(MainMiniMap._ui.Text_mouse_pos, false)
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
        local miniMapID = SL:GetMetaValue("MINIMAP_ID")
        if not miniMapID or miniMapID == 0 then
            return false
        end

        if SL:GetMetaValue("CHECK_MINIMAP_OPEN") then
            SL:CloseMiniMap()
        else
            SL:OpenMiniMap()
        end
    end
    GUI:addKeyboardEvent("KEY_M", callback)
end

-- next 切换的显示状态
function MainMiniMap.GetNextStatus()
    local status = (MainMiniMap._curStatus >= 3 and 0 or MainMiniMap._curStatus + 1)
    if MainMiniMap._skipStatus2 and status == 2 then
        status = 3
    end
    if MainMiniMap._curStatus == 3 then
        SL:CloseMiniMap()
    end
    return status
end

function MainMiniMap.IsEnableMiniMap()
    local miniMapID = SL:GetMetaValue("MINIMAP_ID")
    if not miniMapID or miniMapID == 0 then
        return false
    end
    return SL:GetMetaValue("MINIMAP_ABLE")
end

function MainMiniMap.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAP_STATE_CHANGE, "MainMiniMap", MainMiniMap.UpdateMapState)
    SL:RegisterLUAEvent(LUA_EVENT_PCMINIMAP_STATUS_CHANGE, "MainMiniMap", MainMiniMap.UpdateMapShowStatus)
end

function MainMiniMap.UpdateMapState()
    local safeArea = SL:GetMetaValue("IN_SAFE_AREA")
    local path  = not safeArea and "00150.png" or "00151.png"
    GUI:Image_loadTexture(MainMiniMap._ui.Image_mapFlag, MainMiniMap._path .. path)
end

function MainMiniMap.UpdateMapShowStatus(status)
    MainMiniMap._curStatus = status

    if MainMiniMap._curStatus == 0 then
        GUI:setVisible(MainMiniMap._ui.Panel_minimap, false)
    elseif MainMiniMap._curStatus == 1 then
        GUI:setVisible(MainMiniMap._ui.Panel_minimap, true)
    elseif MainMiniMap._curStatus == 2 then
        GUI:setVisible(MainMiniMap._ui.Panel_minimap, true)
    elseif MainMiniMap._curStatus == 3 then
        GUI:setVisible(MainMiniMap._ui.Panel_minimap, false)

        if MainMiniMap.IsEnableMiniMap() then
            if SL:GetMetaValue("CHECK_MINIMAP_OPEN") then
                MainMiniMap.ChangeStatus(0)
            else
                SL:OpenMiniMap()
            end
        end
    end

    local size = MainMiniMap._minimapSize[MainMiniMap._curStatus]
    if size then
        GUI:setContentSize(MainMiniMap._ui.Panel_minimap, size)
        GUI:setPositionX(MainMiniMap._ui.Text_mouse_pos, size.width)
    end

    MainMiniMap.UpdateMapShow()
end


