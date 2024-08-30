GoldBox = {}

GoldBox._itemList      = nil
GoldBox._posList       = {}
GoldBox._rewardIndex   = 0
GoldBox._startIndex    = 0
GoldBox._canClose      = true
GoldBox._startPosx     = 0
GoldBox._startPosy     = 0
GoldBox._showAnimId    = 4521
GoldBox._showWinAnimId = 4510   -- PC展示特效
GoldBox._animId        = {4521, 4522, 4523, 4524, 4525, 4526, 4527, 4528, 4529}

GoldBox._isPC = SL:GetValue("IS_PC_OPER_MODE")

function GoldBox.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GoldBoxGUI) then
        return
    end
    GoldBox._parent = GUI:Win_Create(UIConst.LAYERID.GoldBoxGUI, 0, 0, 0, 0, false, false, true, true)
    if GoldBox._isPC then
        GUI:LoadExport(GoldBox._parent, "treasure_box/gold_box_panel_win32")
    else
        GUI:LoadExport(GoldBox._parent, "treasure_box/gold_box_panel")
    end

    GoldBox._ui = GUI:ui_delegate(GoldBox._parent)
    if not GoldBox._ui then
        return false
    end

    --设置参数
    GoldBox._itemList = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    GoldBox._moveBg = GoldBox._ui.Image_bg
    GoldBox._panel  = GoldBox._ui.Panel_main
    local function ontouch(sender, event)
        if event == 0 then
            local pos = GUI:getPosition(GoldBox._parent)
            GoldBox._basePosX = pos.x
            GoldBox._basePosy = pos.y
        elseif event == 1 then
            local sPos      = GUI:getTouchBeganPosition(sender)
            local ePos      = GUI:getTouchMovePosition(sender)
            local x         = GoldBox._basePosX + ePos.x - sPos.x
            local y         = GoldBox._basePosy + ePos.y - sPos.y
            local frameSize = GUI:GetWinSize()
            local size      = GUI:getContentSize(GoldBox._panel)
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
            GUI:setPosition(GoldBox._parent, x, y)
        elseif event == 2 or event == 3 then
            local pos = GUI:getPosition(GoldBox._parent)
            GoldBox.GetMoveLayerPos(pos.x, pos.y)
        end
    end
    GUI:addOnTouchEvent(GoldBox._moveBg, ontouch)

    -- 随机特效
    GoldBox._showAnimId = GoldBox._animId[math.random(1, 9)]

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(GoldBox._ui.Panel_1, screenW, screenH)
    GUI:setPosition(GoldBox._ui.Panel_1, screenW / 2, screenH / 2)
    GUI:setPosition(GoldBox._ui.Panel_main, screenW / 2, screenH * 62.5 / 100)

    GoldBox.InitEvent()
    GoldBox.InitPosList()
    GoldBox.SetItemBox(GoldBox._itemList)

    GoldBox.RegisterEvent()
end

function GoldBox.InitEvent()
    GUI:addOnClickEvent(GoldBox._ui.Button_open, function(sender)
        if SL:GetValue("HAVE_GOLDBOX_OPENTIME") then
            -- 请求再开启宝箱
            SL:RequestOpenGoldBox()
            GUI:delayTouchEnabled(sender)
        end
    end)

    GUI:addOnClickEvent(GoldBox._ui.Button_close, function(sender)
        if GoldBox._canClose then
            SL:RequestGetGoldBoxReward()
            GUI:delayTouchEnabled(sender)
        end
    end)
end

function GoldBox.InitPosList()
    for i, v in pairs(GoldBox._itemList) do
        GoldBox._posList[i] = GUI:getPosition(GoldBox._ui["Node_pos" .. i])
    end
end

function GoldBox.CreateShowAnim(root, animId, pos)
    if not root or not animId then
        return
    end

    -- 添加特效
    local lastAnim = GUI:getChildByTag(root, animId)
    GUI:stopAllActions(root)
    if lastAnim then
        if pos then
            GUI:setPosition(lastAnim, pos)
        end
        GUI:stopAllActions(lastAnim)
        GUI:setVisible(lastAnim, true)
    else
        local x = pos and pos.x or 0
        local y = pos and pos.y or 0
        local anim = GUI:Effect_Create(root, "anim", x, y, 0, animId)
        GUI:setTag(anim, animId)
    end
end

function GoldBox.SetItemBox(data)
    local animNode = GoldBox._ui.Node_anim
    local itemNode0 = GUI:getChildByName(animNode, "Node_pos0")
    if GoldBox._isPC then
        GoldBox.CreateShowAnim(GoldBox._ui.Node_btn, GoldBox._showWinAnimId)
    end
    
    GoldBox.CreateShowAnim(animNode, GoldBox._showAnimId, GUI:getPosition(itemNode0))
    for k, v in pairs(data) do
        local itemNode = GUI:getChildByName(GoldBox._ui.Node_icon , "Node_" .. k)
        local coverPanel = GoldBox._ui["Panel_cover" .. k]
        GUI:setVisible(coverPanel, false)
        if itemNode then
            GUI:removeAllChildren(itemNode)
            local item = GUI:ItemShow_Create(itemNode, "item", 0, 0, {index = v.ItemId, count = v.Count, look = true, bgVisible = false, checkPower = true})
            GUI:setAnchorPoint(item, 0.5, 0.5)
            GUI:setScale(item, 0.75)
        end
        if coverPanel then
            GUI:addOnClickEvent(coverPanel, function(sender)
                GUI:delayTouchEnabled(sender)
                SL:RequestGetGoldBoxReward()
            end)
        end
    end

    -- 默认显示
    GUI:setVisible(GoldBox._ui["Panel_cover0"], true)
    
end

--开启动画
function GoldBox.OpenBoxAnim(index)
    if not index then
        return
    end
    GoldBox._rewardIndex = index
    GoldBox._canClose    = false
    if not SL:GetValue("HAVE_GOLDBOX_OPENTIME") then
        if GoldBox._isPC then
            local anim = GUI:getChildByTag(GoldBox._ui.Node_btn, GoldBox._showWinAnimId)
            if anim then
                GUI:setVisible(anim, false)
            end
        end
    end
    GUI:setTouchEnabled(GoldBox._ui.Button_open, false) 
    for k, v in pairs(GoldBox._itemList) do
        GUI:setVisible(GoldBox._ui["Panel_cover" .. k], false)
    end

    local anim = GUI:getChildByTag(GoldBox._ui.Node_anim, GoldBox._showAnimId)
    local posTable = GoldBox._posList

    -- 抽奖动画
    local function runOpenAnim()
        GUI:setVisible(anim, true)
        local Totaltime = 3     -- 动画循环次数
        local time      = 0     -- 当前动画播放次数
        local delay     = 0.15  -- 延迟时间
        local function movePos()
            SL:PlayFlashBoxAudio()
            if GoldBox._startIndex == #GoldBox._itemList then
                GoldBox._startIndex = 0
                time = time + 1
            end    
            if time < Totaltime then 
                GoldBox._startIndex = GoldBox._startIndex + 1
                GUI:setPosition(anim, posTable[GoldBox._startIndex].x, posTable[GoldBox._startIndex].y)
                GUI:runAction(anim, GUI:ActionEaseExponentialOut(GUI:ActionSequence(GUI:DelayTime(delay), GUI:CallFunc(movePos))))
            elseif time >= Totaltime then
                GoldBox._startIndex = GoldBox._startIndex + 1
                delay = delay + 0.05
                if GoldBox._startIndex < GoldBox._rewardIndex then 
                    GUI:setPosition(anim, posTable[GoldBox._startIndex].x, posTable[GoldBox._startIndex].y)
                    GUI:runAction(anim, GUI:ActionEaseExponentialOut(GUI:ActionSequence(GUI:DelayTime(delay), GUI:CallFunc(movePos))))
                else
                    GUI:setPosition(anim, posTable[GoldBox._rewardIndex].x, posTable[GoldBox._rewardIndex].y)
                    GUI:setVisible(GoldBox._ui["Panel_cover" .. GoldBox._rewardIndex], true)
                    GUI:setTouchEnabled(GoldBox._ui.Button_open, true)
                    GoldBox._startIndex = GoldBox._rewardIndex
                    GoldBox._canClose = true
                end
            end
        end
        GUI:runAction(anim, GUI:ActionEaseExponentialOut(GUI:ActionSequence(GUI:DelayTime(delay), GUI:CallFunc(movePos))))
    end
    if anim then
        runOpenAnim()
    end
end
---------------------GoldBoxLayer

function GoldBox.GetMoveLayerPos(posx, posy)
    GoldBox._startPosx = posx
    GoldBox._startPosy = posy
    return GoldBox._startPosx, GoldBox._startPosy
end

function GoldBox.Refresh(data)
    if GoldBox._canClose then 
        SL:RequestGetGoldBoxReward()
        SL:SetValue("TREASUREBOX_REFRESH_ITEM_DATA", data)
    end
end
------------------------GoldBoxMediator
function GoldBox.ShowOpenAnim(data)
    GoldBox.OpenBoxAnim(data)
end

function GoldBox.CheckGoldBoxCanUse()
    if GUI:GetWindow(nil, UIConst.LAYERID.GoldBoxGUI) and not GoldBox._canClose then
        return false
    end
    return true
end

function GoldBox.OnCloseWin(id)
    if id ~= UIConst.LAYERID.GoldBoxGUI then
        return
    end
    GoldBox.RemoveEvent()
    GoldBox._parent = nil
end

function GoldBox.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN,           "GoldBox", GoldBox.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_GOLD_BOX_REFRESH,   "GoldBox", GoldBox.Refresh)
    SL:RegisterLUAEvent(LUA_EVENT_GOLD_BOX_OPEN_ANIM, "GoldBox", GoldBox.ShowOpenAnim)
end

function GoldBox.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN,           "GoldBox")
    SL:UnRegisterLUAEvent(LUA_EVENT_GOLD_BOX_REFRESH,   "GoldBox")
    SL:UnRegisterLUAEvent(LUA_EVENT_GOLD_BOX_OPEN_ANIM, "GoldBox")
end

GoldBox.main()