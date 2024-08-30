TreasureBox = {}
TreasureBox._lastClickTime  = nil
TreasureBox._startPosx      = 0
TreasureBox._startPosy      = 0
TreasureBox._boxNormalId    = 4530
TreasureBox._boxAnimOpenId  = 4511
TreasureBox._openAnimId     = 4512
TreasureBox._animData       = {}
TreasureBox._isWin32        = SL:GetValue("IS_PC_OPER_MODE")
function TreasureBox.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.TreasureBoxGUI) then
        return
    end
    TreasureBox._parent = GUI:Win_Create(UIConst.LAYERID.TreasureBoxGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.NOTICE)
    
    GUI:LoadExport(TreasureBox._parent, "treasure_box/treasure_box")


    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    TreasureBox._ui = GUI:ui_delegate(TreasureBox._parent)
    if not TreasureBox._ui then
        return false
    end
    
    --设置参数
    TreasureBox._data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    GUI:setPosition(TreasureBox._ui.PMainUI, screenW / 2, screenH / 2)

    TreasureBox._boxNormalId = 4530
    TreasureBox._boxAnimOpenId = 4511
    TreasureBox._openAnimId = 4512
    TreasureBox.InitUI(TreasureBox._data)

    SL:SetValue("TREASUREBOX_ITEM_DATA", TreasureBox._data)

    TreasureBox.RegisterEvent()

    TreasureBox._boxMakeIndex = TreasureBox._data.MakeIndex
    SL:onLUAEvent(LUA_EVENT_GOLD_BOX_REFRESH, TreasureBox._data)
end

function TreasureBox.InitUI(data)
    local animIdData = string.split(SL:GetValue("GAME_DATA", "boxtexiao") or "", "|")
    local animIdList = {}
    for k, v in ipairs(animIdData) do
        if v ~= "" then 
            local data = string.split(v, "#")
            if #data >= 4 then 
                animIdList[tonumber(data[1])] = {[1] = tonumber(data[2]), [2] = tonumber(data[3]), [3] = tonumber(data[4])}
            end
        end
    end

    if animIdList[data.Shape] then
        TreasureBox._boxNormalId   = animIdList[data.Shape][1]
        TreasureBox._boxAnimOpenId = animIdList[data.Shape][2]
        TreasureBox._openAnimId    = animIdList[data.Shape][3]
    end
    TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_box_normal, TreasureBox._boxNormalId)

    TreasureBox.InitTouchEventListener()
    TreasureBox.addItemPanel = TreasureBox._ui.Panel_key
    GUI:setSwallowTouches(TreasureBox.addItemPanel,false)
    local function addKeyIntoBox(touchPos)
        GUI:setVisible(TreasureBox._ui.Text_tips, false)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = GUIDefine.ItemGoTo.TreasureBox
            local itemData = {}
            itemData.target = goToName
            itemData.pos = touchPos
            itemData.boxLayer = TreasureBox._ui.PanelPos
            itemData.boxData = data
            SL:ItemMoveCheck(itemData)
        else
            return -1
        end
    end
    local function setNoswallowMouse()
        return -1
    end
    GUI:addMouseButtonEvent(TreasureBox.addItemPanel, {
        onRightDownFunc = setNoswallowMouse,
        onSpecialRFunc = addKeyIntoBox
    })
end

function TreasureBox.CreateBoxAnim(root, id)
    local anim = GUI:Effect_Create(root, "anim", 0, 0, 0, id)
    GUI:Effect_play(anim, 0, 0, false)
end

function TreasureBox.OpenBoxAnim(data)
    SL:PlayOpenBoxAudio()
    local function openBox1()
        TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_box_open, TreasureBox._boxAnimOpenId)
    end
    local function openBox2()
        GUI:setVisible(TreasureBox._ui.Node_box_normal, false)
        TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_open, TreasureBox._openAnimId)
    end
    local function close()
        UIOperator:CloseTreasure()
        UIOperator:OpenGoldBox(data)
    end
    GUI:runAction(TreasureBox._ui.PMainUI, GUI:ActionSequence(GUI:CallFunc(openBox1), GUI:DelayTime(0.8), GUI:CallFunc(openBox2), GUI:DelayTime(1.3), GUI:CallFunc(close)))
end

function TreasureBox.InitTouchEventListener()
    if TreasureBox._isWin32 then
        local function mouseMoveCallBack()
            GUI:setVisible(TreasureBox._ui.Text_tips, true)
        end
        local function leaveItem()
            GUI:setVisible(TreasureBox._ui.Text_tips, false)
        end
        GUI:addMouseMoveEvent(TreasureBox._ui.Panel_key, {
            onEnterFunc = mouseMoveCallBack,
            onLeaveFunc = leaveItem
        })
    end

    local function doubleEventCallBack()
        local data = {
            storage = {
                MakeIndex = TreasureBox._boxMakeIndex,
                state = 1
            }
        }
        SL:onLUAEvent(LUA_EVENT_BAG_STATE_CHANGE, data)
        UIOperator:CloseTreasure()
    end
    local isEventPress = false
    local isMoved = true
    local function touchEvent(sender, eventType)
        if eventType == 0 then
            isEventPress = false
            isMoved = false
            local pos = GUI:getPosition(TreasureBox._parent)
            TreasureBox._basePosX = pos.x
            TreasureBox._basePosy = pos.y
        elseif eventType == 1 then
            local sPos = GUI:getTouchBeganPosition(TreasureBox._ui.PanelPos)
            local ePos = GUI:getTouchMovePosition(TreasureBox._ui.PanelPos)
            local x = TreasureBox._basePosX + ePos.x - sPos.x
            local y = TreasureBox._basePosy + ePos.y - sPos.y
            local frameSize =  GUI:GetWinSize()
            local size = GUI:getContentSize(TreasureBox._ui.PanelPos)
            if x >= frameSize.width / 2 - size.width / 2 then 
                x = frameSize.width / 2 - size.width / 2
            elseif x <= size.width / 2 - frameSize.width / 2 then 
                x = size.width / 2 - frameSize.width / 2
            end
            if y >= frameSize.height / 2 - size.height / 2 then 
                y = frameSize.height / 2 - size.height / 2
            elseif y <= size.height / 2 - frameSize.height / 2 then 
                y = size.height / 2 - frameSize.height / 2
            end
            GUI:setPosition(TreasureBox._parent, x, y)
            isMoved = true
        elseif eventType == 2 or eventType == 3 then
            if isMoved then     --移动端移动偏移判断太灵敏了
                local sPos = GUI:getTouchBeganPosition(sender)
                local ePos = GUI:getTouchMovePosition(sender)
                local movePosX,movePosY = ePos.x - sPos.x, ePos.y - sPos.y
                if math.abs(movePosX) <= 5 and math.abs(movePosY) <= 5 then
                    isMoved = false
                end
            end
            GUI:stopAllActions(TreasureBox._ui.PanelPos)

            if not isMoved then
                if not isEventPress then
                    -- 判断是否有双击事件
                    if doubleEventCallBack then
                        -- 记录上一次点击时间
                        if not TreasureBox._lastClickTime then
                            TreasureBox._lastClickTime = true
                            -- 记录单击触发
                            TreasureBox._clickDelayHandler =
                            SL:ScheduleOnce(function()
                                if TreasureBox._clickCallback  then
                                    TreasureBox._clickCallback(TreasureBox._parent, eventType)
                                end
                                TreasureBox._lastClickTime = nil
                            end,
                            GUIDefine.CLICK_DOUBLE_TIME
                            )
                        else
                            if TreasureBox._clickDelayHandler then
                                UnSchedule(TreasureBox._clickDelayHandler)
                                TreasureBox._clickDelayHandler = nil
                            end

                            if doubleEventCallBack then
                                doubleEventCallBack()
                            end

                            TreasureBox._lastClickTime = nil
                        end
                    else
                        if TreasureBox._clickCallback  then
                            TreasureBox._clickCallback(TreasureBox._parent, eventType)
                        end
                    end
                end
            else
                local pos = GUI:getPosition(TreasureBox._parent)
                TreasureBox.GetMoveLayerPos(pos.x, pos.y)
            end
        end
    end
    GUI:addOnTouchEvent(TreasureBox._ui.PanelPos, touchEvent)
end

function TreasureBox.GetMoveTouch()
    return TreasureBox._ui.PanelPos
end

function TreasureBox.GetMoveLayerPos(posx, posy)
    TreasureBox._startPosx = posx
    TreasureBox._startPosy = posy
    return TreasureBox._startPosx, TreasureBox._startPosy
end

function TreasureBox.ShowOpenAnim(noticeData)
    if GUI:GetWindow(nil, UIConst.LAYERID.TreasureBoxGUI) then
        TreasureBox.OpenBoxAnim(noticeData)
    else
        UIOperator:OpenGoldBox(noticeData)
    end
end

function TreasureBox.OnCloseWin(id)
    if id ~= UIConst.LAYERID.TreasureBoxGUI then
        return
    end
    TreasureBox.RemoveEvent()
    TreasureBox._parent = nil
end

function TreasureBox.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TreasureBox", TreasureBox.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_TREASUREBOX_DATA_REFRESH,   "TreasureBox", TreasureBox.ShowOpenAnim)
end

function TreasureBox.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "TreasureBox")
    SL:UnRegisterLUAEvent(LUA_EVENT_TREASUREBOX_DATA_REFRESH,   "TreasureBox")
end

TreasureBox.main()