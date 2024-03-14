GoldBox = {}
GoldBox._showWinAnimId = 4510   -- PC展示特效
GoldBox._animId = {[1] = 4521, [2] = 4522, [3] = 4523, [4] = 4524, [5] = 4525, [6] = 4526, [7] = 4527, [8] = 4528, [9] = 4529}

function GoldBox.main(data)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "treasure_box/gold_box_panel_win32")
    else
        GUI:LoadExport(parent, "treasure_box/gold_box_panel")
    end

    GoldBox._isPC = isWinMode
    GoldBox._ui = GUI:ui_delegate(parent)
    GoldBox._itemList = data
    GoldBox._posList = {}
    GoldBox._rewardIndex = 0
    GoldBox._startIndex = 0
    GoldBox._canClose = true

    -- 随机特效
    local num = math.random(1, 9)
    GoldBox._showAnimId = GoldBox._animId[num]

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(GoldBox._ui.Panel_1, screenW, screenH)
    GUI:setPosition(GoldBox._ui.Panel_1, screenW / 2, screenH / 2)

    GUI:setPosition(GoldBox._ui.Panel_main, screenW / 2, screenH * 62.5 / 100)

    GoldBox.InitEvent()
    GoldBox.InitPosList()
    GoldBox.SetItemBox(data)
end

function GoldBox.InitEvent()
    GUI:addOnClickEvent(GoldBox._ui.Button_open, function()
        if SL:GetMetaValue("HAVE_GOLDBOX_OPENTIME") then
            SL:RequestOpenGoldBox()
        end
    end)

    GUI:addOnClickEvent(GoldBox._ui.Button_close, function()
        if GoldBox._canClose then
            SL:RequestGetGoldBoxReward()
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
            GUI:addOnClickEvent(coverPanel, function()
                SL:RequestGetGoldBoxReward()
            end)
        end
    end

    -- 默认显示
    GUI:setVisible(GoldBox._ui["Panel_cover0"], true)
    
end

function GoldBox.OpenBoxAnim(index)
    if not index then
        return
    end
    GoldBox._rewardIndex = index
    GoldBox._canClose = false
    if not SL:GetMetaValue("HAVE_GOLDBOX_OPENTIME") then
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
