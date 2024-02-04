MainMiniMap = {}

MainMiniMap._showState = false

-- 按键Tab M键 开关
MainMiniMap._bKeyCode = {
    KEY_M = true, KEY_TAB = true
}

-- 战斗模式的图片
MainMiniMap._Pics = {
    [0] = "res/private/main/Pattern/1900012200.png",
    [1] = "res/private/main/Pattern/1900012201.png",
    [2] = "res/private/main/Pattern/1900012206.png",
    [3] = "res/private/main/Pattern/1900012207.png",
    [4] = "res/private/main/Pattern/1900012202.png",
    [5] = "res/private/main/Pattern/1900012203.png",
    [6] = "res/private/main/Pattern/1900012204.png",
    [7] = "res/private/main/Pattern/1900012208.png",
    [10] = "res/private/main/Pattern/1900012205.png"
}

function MainMiniMap.main()
    local parent = GUI:Attach_MainMiniMap()
    GUI:LoadExport(parent, "main/main_minimap")

    MainMiniMap._parent = parent
    MainMiniMap._ui = GUI:ui_delegate(parent)

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

    -- PK模式文本 图片
    local PKModelButtonText = MainMiniMap._ui["PKModelButtonText"]
    MainMiniMap._PKModelButtonText = PKModelButtonText

    local PKModelCell = MainMiniMap._ui["PKModelCell"]
    MainMiniMap._PKModelCell = PKModelCell

    local PKModelListView = MainMiniMap._ui["PKModelListView"]
    MainMiniMap._PKModelListView = PKModelListView

    local PKModelListViewCell = MainMiniMap._ui["PKModelListViewCell"]
    MainMiniMap._PKModelListViewCell = PKModelListViewCell

    -- PK模式改变
    MainMiniMap.UpdatePKMode()
    SL:RegisterLUAEvent(LUA_EVENT_PKMODECHANGE, "MainMiniMap", MainMiniMap.UpdatePKMode)

    -- 地图状态改变
    MainMiniMap.UpdateMapState()
    SL:RegisterLUAEvent(LUA_EVENT_MAP_STATE_CHANGE, "MainMiniMap", MainMiniMap.UpdateMapState)

    -- 地图名字改变
    MainMiniMap.UpdateMapName()
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, "MainMiniMap", MainMiniMap.UpdateMapName)

    if SL:IsWinMode() then
        MainMiniMap.InitMapKeyCode()
    end
end

-- PC
function MainMiniMap.InitMapKeyCode()
    local bKeyCode = MainMiniMap._bKeyCode or {}
    for key, value in pairs(bKeyCode) do
        if value then
            GUI:addKeyboardEvent(tostring(key), function () SL:OpenMapUI() end)
        end
    end
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
    local pkCell = MainMiniMap._PKModelListViewCell
    if not pkCell then
        return false
    end

    GUI:Win_SetParam(MainMiniMap._PKModelButton, false)

    local buttonSize    = GUI:getContentSize(MainMiniMap._PKModelButton)
    local mapBGWidth    = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
    local cSize         = GUI:getContentSize(pkCell)
    local width         = GUI:ListView_getItemCount(MainMiniMap._PKModelListView) * cSize.width
    local posY          = GUI:getPositionY(MainMiniMap._PKModelButton)
    local btnActionX    = -mapBGWidth + 1
    local pkActionX     = -mapBGWidth + width

    GUI:stopAllActions(MainMiniMap._PKModelButton)
    GUI:runAction(MainMiniMap._PKModelButton, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, btnActionX, GUI:getPositionY(MainMiniMap._PKModelButton))))

    GUI:stopAllActions(MainMiniMap._PKModelCell)
    GUI:setPositionX(MainMiniMap._PKModelCell, -mapBGWidth)
    GUI:runAction(MainMiniMap._PKModelCell, GUI:ActionSequence(GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.2, cc.p(pkActionX, GUI:getPositionY(MainMiniMap._PKModelCell)))), GUI:ActionHide()))
end

function MainMiniMap.ShowPKModeCells()
    local pkListBg = GUI:getChildByName(MainMiniMap._PKModelCell, "PKModelCellsBg")
    local pkList = MainMiniMap._PKModelListView
    local pkCell = MainMiniMap._PKModelListViewCell

    GUI:Win_SetParam(MainMiniMap._PKModelButton, true)

    GUI:setVisible(pkListBg, true)
    GUI:setVisible(pkCell, false)
    GUI:removeAllChildren(pkList)

    local pkModeTB = { 0, 1, 4, 5, 6, 2, 7 }
    -- 区服模式只能在跨服时可切换
    if SL:GetMetaValue("KFSTATE") then
        table.insert(pkModeTB, 10)
    end

    for i, mode in ipairs(pkModeTB) do
        if SL:GetMetaValue("PKMODE_CAN_USE", mode) then
            local cell = GUI:Clone(pkCell)
            GUI:ListView_pushBackCustomItem(pkList, cell)
            GUI:setVisible(cell, true)

            GUI:getChildByName(cell, "ImageName"):loadTexture(MainMiniMap._Pics[mode])
            GUI:addOnClickEvent(cell, function()
                SL:RequestChangePKMode(mode)
                MainMiniMap.HidePKModeCells()
            end)
        end
    end

    local mapBGWidth    = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
    local cSize         = GUI:getContentSize(pkCell)
    local width         = GUI:ListView_getItemCount(pkList) * cSize.width
    local posY          = GUI:getPositionY(MainMiniMap._PKModelButton)
    local btnActionX    = -(width) - mapBGWidth + 1
    local pkActionX     = -mapBGWidth + 1

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

function MainMiniMap.UpdatePKMode()
    local pkMode = SL:GetMetaValue("PKMODE")
    MainMiniMap._PKModelButtonText:loadTexture(MainMiniMap._Pics[pkMode])
end

function MainMiniMap.UpdateMapState()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        GUI:Text_setString(MainMiniMap._MapStatus, "安全区域")
        GUI:Text_setTextColor(MainMiniMap._MapStatus, "#00ff00")
    else
        GUI:Text_setString(MainMiniMap._MapStatus, "危险区域")
        GUI:Text_setTextColor(MainMiniMap._MapStatus, "#ff0000")
    end
end

function MainMiniMap.UpdateMapName()
    GUI:Text_setString(MainMiniMap._MapName, SL:GetMetaValue("MAP_NAME"))
end

function MainMiniMap.ChangeShowState(state)
    if MainMiniMap._showState == state then
        return nil
    end
    MainMiniMap._showState = state

    GUI:Timeline_StopAll(MainMiniMap._ui.Node)
    local clipWidth = GUI:getContentSize(MainMiniMap._ui["LayoutClip"]).width
    if MainMiniMap._showState then
        local mapBGWidth = GUI:getContentSize(MainMiniMap._ui["MapBG"]).width
        GUI:Timeline_EaseSineIn_MoveTo(MainMiniMap._ui.Node, { x = clipWidth + mapBGWidth-2, y = GUI:getPositionY(MainMiniMap._ui.Node) }, 0.2)
    else
        GUI:Timeline_EaseSineIn_MoveTo(MainMiniMap._ui.Node, { x = clipWidth, y = GUI:getPositionY(MainMiniMap._ui.Node) }, 0.2)
    end
end