MainProperty = {}

MainProperty._path = "res/private/main/"

-- 斗转星移技能ID
local DZXY_SkillID  = 118

-- 醉酒相关是否显示
local ON_OFF_zuijiu = false

-- 聊天框的宽
MainProperty._ChatItemWidth = 310

function MainProperty.Init()
    MainProperty._bubbleTipsDatas = {}  -- 气泡数据
    MainProperty._bubbleTipsCells = {}

    MainProperty._quickUseCells   = {}

    MainProperty._pSize           = {}
    MainProperty._drawHWay        = {}  -- 绘制方式

    MainProperty._exCellHei       = 17

    local values = GUIDefineEx.ChatContentInterval
    MainProperty._listInterval, MainProperty._richVspace = values.listInterval, values.richVspace or 0

    MainProperty._NGShow = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")
end

function MainProperty.main()
    local parent = GUI:Attach_Bottom()
    GUI:LoadExport(parent, "main/main_property")

    MainProperty._root = GUI:getChildByName(parent, "Main_Property")
    MainProperty._ui = GUI:ui_delegate(MainProperty._root)
    if not MainProperty._ui then
        return false
    end

    MainProperty.Init()

    local screenW = SL:GetValue("SCREEN_WIDTH")
    GUI:setPosition(MainProperty._root, screenW / 2, 0)

    local bottomHei = GUI:getContentSize(MainProperty._ui["bottomImg"]).height
    GUI:setContentSize(MainProperty._ui["bottomImg"], screenW + 200, bottomHei)
    local panelBgWid = GUI:getContentSize(MainProperty._ui["Panel_bg"]).width
    GUI:setPositionX(MainProperty._ui["bottomImg"], panelBgWid / 2 - 100)

    -- 时钟定时器
    local function callback()
        local date = os.date("*t", SL:GetValue("SERVER_TIME"))
        GUI:Text_setString(MainProperty._ui["Text_time"], string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    -- FPS 帧率
    local sumFps = 0
    local count = 0
    SL:Schedule(
        function()
            sumFps = sumFps + SL:GetValue("FPS")
            count = count + 1
        end,
        0
    )
    SL:Schedule(
        function()
            local fps = math.min(math.ceil(sumFps / count), 60)
            GUI:Text_setString(MainProperty._ui["Text_FPS"], string.format("FPS:%s", fps))
            sumFps = 0
            count = 0
        end,
        0.5
    )

    -- 聊天页打开
    GUI:addOnClickEvent(MainProperty._ui["Panel_mini_chat_touch"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Chat)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Chat)
        end
    end)

    -- 转生属性点分配页打开
    GUI:addOnClickEvent(MainProperty._ui["btn_rein_add"], function()
        if not GUI:GetWindow(nil, UIConst.LAYERID.ReinAttrGUI) then
            if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
                SL:CheckOpenLayer(SLDefine.HyperLinkID.ReinAttrPoint)
            else
                SL:JumpTo(SLDefine.HyperLinkID.ReinAttrPoint)
            end
            SL:PlayBtnClickAudio()
        end
    end)

    MainProperty.OnRefreshPropertyShow()
    MainProperty.OnRefreshNetShow()
    MainProperty.OnRefreshBatteryShow()
    MainProperty.RegisterEvent()

    -- 初始化
    MainProperty.InitAutoSFXTips()
    MainProperty.InitHero()
    MainProperty.InitMiniChat()
    MainProperty.InitChatHideBtn()
    MainProperty.InitQuickUseShow()
    MainProperty.InitInternalUI()

    MainProperty.AfterCUILoadFunc()
end

function MainProperty.AfterCUILoadFunc()
    MainProperty.InitQuickUseItems()
end

------------------------------ 快捷栏 -------------------------------------------------------
-- 初始化显示的快捷栏
function MainProperty.InitQuickUseItems()
    local showNum = 0
    
    local Panel_quick = MainProperty._ui["Panel_quick"]
    if Panel_quick and GUI:getVisible(Panel_quick) then
        for i = 1, 6 do
            local item = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if item and GUI:getVisible(item) then
                showNum = showNum + 1
                local cell = MainProperty.CreateQuickUseCell(item, i)
                MainProperty._quickUseCells[i] = cell
            end
        end
    end
    QuickUseData.SetQuickUseSize(showNum)

    MainProperty.UpdateQuickUseItem()
end

-- 初始化显示的快捷栏
function MainProperty.InitQuickUseShow()
    local showNum = 0
    -- 默认个数
    if MainProperty._ui["Panel_quick_use"] and GUI:getVisible(MainProperty._ui["Panel_quick_use"]) then
        for i = 1, 6 do
            local layout = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if layout and GUI:getVisible(layout) then
                showNum = showNum + 1
            end
        end
    end
    -- 设置快捷框个数 (最大：6)
    QuickUseData.SetQuickUseSize(showNum)
end

-- 快捷栏cell
function MainProperty.CreateQuickUseCell(parent, index)
    if not parent then
        return
    end
    -- 点击区域
    local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0, 0, 52, 50)
    GUI:setTouchEnabled(Panel_cell, true)

    local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", 26, 25, "res/public/1900012391.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setContentSize(Image_bg, 49, 49)

    local Node_item = GUI:Node_Create(Panel_cell, "Node_item", 26, 25)
    Panel_cell.nodeItem = Node_item

    -- 拖动区域
    local Panel_touch = GUI:Layout_Create(Panel_cell, "Panel_touch", 0, 0, 52, 50)
    GUI:setTouchEnabled(Panel_touch, true)
    GUI:setSwallowTouches(Panel_touch, false)

    
    GUI:addOnClickEvent(Panel_cell, function(sender)
        local quickUseItem = QuickUseData.GetQuickUseDataByPos(index)
        if not quickUseItem then
            return nil
        end
        SL:RequestUseItem(quickUseItem)
        GUI:delayTouchEnabled(sender)
    end)

    GUI:addMouseButtonEvent(Panel_touch, {
        OnSpecialRFunc = function (touchPos)
            if not SL:GetValue("ITEM_MOVE_STATE") then
                return -1
            end
            SL:ItemMoveCheck({target = GUIDefine.ItemGoTo.QUICK_USE, pos = touchPos, posInQuickUse = index})
        end
    })

    return {layout = Panel_cell, nodeItem = Node_item}
end

-- 快捷栏更新
function MainProperty.OnQuickUseRefresh(data)
    local cell = MainProperty._quickUseCells[data.pos]
    if not cell then
        return false
    end
    GUI:ItemShow_resetMoveState(cell.item, data.state == 0)
end

-- 快捷栏操作
function MainProperty.OnQuickUseChange(data)
    local opera = data.opera
    if opera == GUIDefine.OperateType.INIT then
        MainProperty.UpdateQuickUseItem()
    elseif opera == GUIDefine.OperateType.ADD then
        MainProperty.AddQuickUseItem(data.param)
    elseif opera == GUIDefine.OperateType.DEL then
        MainProperty.DelQuickUseItem(data.param)
    elseif opera == GUIDefine.OperateType.CHANGE then
        MainProperty.ChangeQuickUseItem(data.param)
    end
end

--初始化列表
function MainProperty.UpdateQuickUseItem()
    for k, v in pairs(MainProperty._quickUseCells) do
        GUI:removeAllChildren(v.nodeItem)
    end

    local quickUseData = QuickUseData.GetQuickUseData()
    for k, v in pairs(quickUseData) do
        MainProperty.AddQuickUseItem({index = k, itemData = v})
    end
end

-- 添加 item
function MainProperty.AddQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    local function dealSpecialQuickUse()
        local index = data.index
        local size = QuickUseData.GetQuickUseSize()
        local quickUseData = QuickUseData.GetQuickUseData()
        local quickUseList = QuickUseData.GetQuickUseLocalList()

        local replaceCell = nil
        for i = 1, size do
            if not quickUseData[i] and MainProperty._quickUseCells[i] and i ~= index then
                replaceCell = MainProperty._quickUseCells[i]
                cell = replaceCell
                quickUseData[i] = quickUseData[index]
                quickUseData[index] = nil

                quickUseList[i] = quickUseList[index]
                quickUseList[index] = 0
                break
            end
        end

        -- 无替代则放回背包
        if not replaceCell then
            local item = data.itemData
            BagData.AddItemData(item)
            
            --清数据
            quickUseList[index] = 0
            return true
        end
    end

    if not cell then
        if dealSpecialQuickUse() then
            return
        end
    end

    local nodeItem = cell.nodeItem
    
    GUI:removeAllChildren(nodeItem)

    local function getCount(item)
        if item.OverLap > 1 then
            return item.OverLap
        end

        if item.StdMode == 2 and item.Dura > 0 then --使用次数
            return item.Dura < 1000 and 1 or math.floor(item.Dura / 1000)  --小于1000都为1；大于1000向下取整
        end
        return 0
    end

    local itemData = data.itemData
    local data = {index = itemData.Index, itemData = itemData, count = getCount(itemData), from = GUIDefine.ItemFrom.QUICK_USE, movable = true}
    local item = GUI:ItemShow_Create(nodeItem, "quickCell", 0, 0, data)
    GUI:setAnchorPoint(item, 0.5, 0.5)

    GUI:addOnTouchEvent(item, function()
        if nodeItem.touching then
            return false
        end
        cell.nodeItem.touching = true
        SL:RequestUseItem(itemData)
        SL:scheduleOnce(nodeItem, function(sender) sender.touching = nil end, 0.3)
    end)

    cell.item = item
end

-- 删除 item
function MainProperty.DelQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    if not cell then
        return false
    end
    GUI:removeAllChildren(cell.nodeItem)
end

-- 修改 item
function MainProperty.ChangeQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    if not cell then
        return false
    end
    local function getCount(item)
        if item.OverLap > 1 then
            return item.OverLap
        end

        if item.StdMode == 2 and item.Dura > 0 then --使用次数
            return item.Dura < 1000 and 1 or math.floor(item.Dura / 1000)  --小于1000都为1；大于1000向下取整
        end
        return 0
    end
    GUI:ItemShow_UpdateItemCountShow(cell.item, data.itemData, getCount(data.itemData))
end
--------------------------------------------------------------------------------------------

----------------------------- 气泡相关 ------------------------------------------------------
-- 气泡刷新
function MainProperty.OnRefreshBubbleTips(data)
    if data.status then
        MainProperty.AddBubbleTips(data)
    else
        MainProperty.RmvBubbleTips(data)
    end
end

-- 添加气泡
function MainProperty.AddBubbleTips(data)
    data.endTime = data.time and data.time + SL:GetValue("SERVER_TIME")

    if MainProperty._bubbleTipsDatas[data.id] then
        MainProperty._bubbleTipsDatas[data.id] = data
        return false
    end
    MainProperty._bubbleTipsDatas[data.id] = data

    local bubbleCell = MainProperty.CreateBubbleTipsCell(data)
    GUI:ListView_pushBackCustomItem(MainProperty._ui["ListView_bubble_tips"], bubbleCell)
    MainProperty._bubbleTipsCells[data.id] = bubbleCell
    SL:PlaySound(50004)
end

-- 移除气泡
function MainProperty.RmvBubbleTips(data)
    if not MainProperty._bubbleTipsDatas[data.id] then
        return false
    end
    MainProperty._bubbleTipsDatas[data.id] = nil
    GUI:ListView_removeChild(MainProperty._ui["ListView_bubble_tips"], MainProperty._bubbleTipsCells[data.id])
    MainProperty._bubbleTipsCells[data.id] = nil
end

-- 气泡cell
function MainProperty.CreateBubbleTipsCell(data)
    local bubbleCell = GUI:Layout_Create(-1, "bubbleCell", 0, 0, 50, 50)
    GUI:setTouchEnabled(bubbleCell, true)
    GUI:setAnchorPoint(bubbleCell, 0.5, 0.5)

    -- 图标
    local iconBtn = GUI:Button_Create(bubbleCell, "iconBtn", 25, 25, string.len(data.path or "") > 0 and data.path or "Default/Button_Normal.png")
    GUI:setAnchorPoint(iconBtn, 0.5, 0.5)
    GUI:setContentSize(iconBtn, 46, 46)
    GUI:setIgnoreContentAdaptWithSize(iconBtn, true)
    GUI:addOnClickEvent(iconBtn, function()
        if data.callback then
            data.callback(bubbleCell)
        end
    end)

    -- 倒计时
    local timeText = GUI:Text_Create(bubbleCell, "timeText", 25, 7, 16, "#FF0000", "10")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)

    -- 时间
    local function callback()
        if data.endTime then
            local remaining = data.endTime - SL:GetValue("SERVER_TIME")
            GUI:Text_setString(timeText, remaining)

            if remaining <= 0 then
                GUI:stopAllActions(timeText)
                GUI:Text_setString(timeText, "")
                if data.timeOverCB then
                    data.timeOverCB()
                end
            end
        else
            GUI:Text_setString(timeText, "")
        end
    end

    SL:schedule(timeText, callback, 1)
    callback()

    GUI:Timeline_Waggle(bubbleCell, 0.05, 20)

    return bubbleCell
end

-- 获取气泡按钮方法
function MainProperty.GetBubbleButtonByID(id)
    for bubbleID, cell in pairs(MainProperty._bubbleTipsCells) do
        if bubbleID == id then
            return GUI:getChildByName(cell, "iconBtn")
        end
    end
    return nil
end
--------------------------------------------------------------------------------------------

----------------------------- 自动提示 ------------------------------------------------------
function MainProperty.InitAutoSFXTips()
    local contentSize = GUI:getContentSize(MainProperty._ui["Panel_auto_tips"])
    local posX = contentSize.width / 2
    local posY = 10

    -- 自动战斗
    MainProperty._nodeAutoFight = GUI:Node_Create(MainProperty._ui["Panel_auto_tips"], "nodeAutoFight", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoFight, false)
    GUI:Effect_Create(MainProperty._nodeAutoFight, "autoFightSfx", 0, 0, 0, 4009)

    -- 自动寻路
    MainProperty._nodeAutoMove = GUI:Node_Create(MainProperty._ui["Panel_auto_tips"], "nodeAutoMove", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoMove, false)
    GUI:Effect_Create(MainProperty._nodeAutoMove, "autoMoveSfx", 0, 0, 0, 4010)
end

----------------------------- 英雄相关 ------------------------------------------------------
function MainProperty.InitHero()
    GUI:setVisible(MainProperty._ui["Image_barbg"], false)
    MainProperty._maxAngerH = GUI:getContentSize(MainProperty._ui["Image_barbg"]).height
    MainProperty.RefAnger(0)

    if SL:GetValue("USEHERO") then
        local modeShow = tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) == 0
        if modeShow then
            local size = GUI:getContentSize(MainProperty._ui["Panel_hp"])
            local heroProgress = GUI:ProgressTimer_Create(MainProperty._ui["Panel_hp"], "heroProgress", size.width / 2, size.height / 2, MainProperty._path .. "Skill/hero2/0_0001.png")
            GUI:setAnchorPoint(heroProgress, 0.5, 0.5)
            GUI:ProgressTimer_setPercentage(heroProgress, 0)
            heroProgress.idx = 1
            SL:schedule(
                MainProperty._ui["Panel_hp"],
                function()
                    heroProgress.idx = heroProgress.idx + 1
                    if heroProgress.idx > 9 then
                        heroProgress.idx = 1
                    end
                    GUI:ProgressTimer_ChangeImg(
                        heroProgress,
                        string.format(MainProperty._path .. "Skill/hero2/0_000%s.png", heroProgress.idx)
                    )
                end,
                2 / 9
            )
            MainProperty._heroProgress = heroProgress
        end
    end
end

-- 刷新怒气条
function MainProperty.RefAnger(value)
    local size = GUI:getContentSize(MainProperty._ui["Panel_bar"])
    GUI:setContentSize(MainProperty._ui["Panel_bar"], size.width, value * (MainProperty._maxAngerH or 108))
end

function MainProperty.OnHeroAngerChange(data)
    local modeShow = tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) == 0
    if modeShow and SL:GetValue("USEHERO") then
        if SL:GetValue("HERO_IS_ALIVE") then -- 已召唤英雄
            local forceRefresh = data and data.forceRefresh
            local curAnger = SL:GetValue("H.ANGER")
            local maxAnger = SL:GetValue("H.MAXANGER")
            local angerBarWay = tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao"))
            if angerBarWay and angerBarWay == 1 then -- 条形怒气条
                if maxAnger ~= 0 then
                    MainProperty.RefAnger(curAnger / maxAnger)
                end
                if SL:GetValue("H.SHAN") then
                    if not GUI:getChildByName(MainProperty._ui["Panel_bar"], "anger_sfx") then
                        local sfx = GUI:Effect_Create(MainProperty._ui["Panel_bar"], "anger_sfx", -6, 66, 0, 7220)
                        GUI:setScaleY(sfx, MainProperty._maxAngerH / 108)
                    end
                    if MainSkill and MainSkill.JointHeroEffect then
                        MainSkill.JointHeroEffect(true)
                    end
                else
                    local sfx = GUI:getChildByName(MainProperty._ui["Panel_bar"], "anger_sfx")
                    if sfx then
                        GUI:removeFromParent(sfx)
                    end
                    if MainSkill and MainSkill.JointHeroEffect then
                        MainSkill.JointHeroEffect(false)
                    end
                end
            else -- 圆形怒气条
                local delayTime = SL:GetValue("H.DELAYT")
                local speed = SL:GetValue("H.SPEED")
                local shan = SL:GetValue("H.SHAN")
                local curPro = curAnger / maxAnger * 100
                local function ChangeShanEffect()
                    if shan then
                        if not MainProperty._heroProgress._shan or forceRefresh then
                            MainProperty._heroProgress._shan = true
                            if MainSkill and MainSkill.JointHeroEffect then
                                MainSkill.JointHeroEffect(true)
                            end
                        end
                    else
                        if MainProperty._heroProgress._shan or forceRefresh then
                            MainProperty._heroProgress._shan = false
                            if MainSkill and MainSkill.JointHeroEffect then
                                MainSkill.JointHeroEffect(false)
                            end
                        end
                    end
                end
                if GUI:getActionByTag(MainProperty._heroProgress, 77) then
                    GUI:stopAllActions(MainProperty._heroProgress)
                    GUI:ProgressTimer_setPercentage(MainProperty._heroProgress, curPro)
                    GUI:ProgressTimer_setReverseDirection(MainProperty._heroProgress, shan)
                    GUI:ProgressTimer_setPercentage(
                        MainProperty._heroProgress,
                        GUI:ProgressTimer_getPercentage(MainProperty._heroProgress)
                    )
                    ChangeShanEffect()
                else
                    local pro = GUI:ProgressTimer_getPercentage(MainProperty._heroProgress)
                    local time = math.abs(curAnger - pro * maxAnger / 100) / speed * delayTime / 1000
                    GUI:ProgressTimer_progressTo(
                        MainProperty._heroProgress,
                        math.max(time - 0.05, 0),
                        curPro,
                        function()
                            GUI:ProgressTimer_setReverseDirection(MainProperty._heroProgress, shan)
                            local offset = shan and 0.01 or 0
                            GUI:ProgressTimer_setPercentage(
                                MainProperty._heroProgress,
                                GUI:ProgressTimer_getPercentage(MainProperty._heroProgress) - offset
                            )
                            ChangeShanEffect()
                        end,
                        77
                    )
                end
            end
        else
            if tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao")) and tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao")) == 1 then
                MainProperty.RefAnger(0)
            else
                GUI:ProgressTimer_setPercentage(MainProperty._heroProgress, 0)
            end
        end
    end
end

function MainProperty.OnHeroLoginOrOut()
    if tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetValue("GAME_DATA", "Progressbarmode")) == 0 then
        if SL:GetValue("USEHERO") then
            if not SL:GetValue("HERO_IS_ALIVE") then
                if MainProperty._heroProgress then
                    GUI:stopAllActions(MainProperty._heroProgress)
                    MainProperty._heroProgress._shan = false
                    GUI:ProgressTimer_setPercentage(MainProperty._heroProgress, 0)
                end
            end
            if tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao")) and tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao")) == 1 then
                GUI:setVisible(MainProperty._ui["Image_barbg"],SL:GetValue("HERO_IS_ALIVE"))
                MainProperty.RefAnger(0)
            end
        end
    end
end
---------------------------------------------------------------------------------------------

----------------------------- 聊天相关 -------------------------------------------------------
-- 聊天框的宽
function MainProperty.GetChatWidth()
    return MainProperty._ChatItemWidth
end

function MainProperty.InitChatHideBtn()
    local widgetList = {
        "Panel_quick_use_1",
        "Panel_quick_use_2",
        "Panel_quick_use_3",
        "Panel_quick_use_4",
        "Panel_quick_use_5",
        "Panel_quick_use_6",
        "Panel_auto_tips",
        "Image_4",
        "Panel_hp",
        "Image_barbg"
    }
    local oriPosYList = {}
    GUI:delayTouchEnabled(MainProperty._ui["Button_chat_hide"], 0.4)
    local _layoutMiniChat = MainProperty._panelMiniChat
    local lastShowState = GUI:getVisible(_layoutMiniChat)
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_hide"], function()
        local state = not GUI:getVisible(_layoutMiniChat)
        if lastShowState == state then
            return
        end
        lastShowState = state
        local function show()
            GUI:setVisible(_layoutMiniChat, state)
        end
        if not oriPosYList["Panel_mini_chat"] then
            oriPosYList["Panel_mini_chat"] = GUI:getPositionY(_layoutMiniChat)
        end
        local chatHei = GUI:getContentSize(_layoutMiniChat).height
        local chatY = not state and (-chatHei) or oriPosYList["Panel_mini_chat"]
        if not state then
            GUI:runAction(
                _layoutMiniChat,
                GUI:ActionSequence(
                    GUI:ActionMoveTo(0.5, GUI:getPositionX(_layoutMiniChat), chatY),
                    GUI:CallFunc(show)
                )
            )
        else
            GUI:runAction(
                _layoutMiniChat,
                GUI:ActionSequence(
                    GUI:CallFunc(show),
                    GUI:ActionMoveTo(0.5, GUI:getPositionX(_layoutMiniChat), chatY)
                )
            )
        end

        GUI:Button_setBright(MainProperty._ui["Button_chat_hide"], state)
        --通知服务端
        SL:RequestNoticeChatVisible(state)

        if SL:GetValue("GAME_DATA", "NeedResetPosWithChat") then
            local idList = string.split(SL:GetValue("GAME_DATA", "NeedResetPosWithChat"), "#")
            for _, id in ipairs(idList) do
                local i = tonumber(id)
                local name = widgetList[i]
                local widget = MainProperty._ui[name]
                if i and name and widget then
                    if i ~= 8 and i ~= 9 and i ~= 10 then
                        local chatHei = GUI:getContentSize(_layoutMiniChat).height
                        if not GUI:Widget_IsNull(widget) then
                            if not oriPosYList[name] then
                                oriPosYList[name] = GUI:getPositionY(widget)
                            end
                            local setY = not state and oriPosYList[name] - (chatHei) or oriPosYList[name]
                            GUI:runAction(widget, GUI:ActionMoveTo(0.5, GUI:getPositionX(widget), setY))
                        end
                    else
                        local function callback()
                            GUI:setVisible(widget, state)
                            GUI:setChildrenCascadeOpacityEnabled(widget, false)
                        end
                        local canSet = true
                        if i == 10 then -- 怒气条
                            canSet = tonumber(SL:GetValue("GAME_DATA", "Heronuqitiao")) == 1 and SL:GetValue("HERO_IS_ALIVE")
                        end
                        if canSet then
                            GUI:setChildrenCascadeOpacityEnabled(widget, true)
                            if not state then
                                GUI:runAction(
                                    widget,
                                    GUI:ActionSequence(GUI:ActionFadeOut(0.5), GUI:CallFunc(callback))
                                )
                            else
                                GUI:runAction(widget, GUI:ActionSequence(GUI:CallFunc(callback), GUI:ActionFadeIn(0.5)))
                            end
                        end
                    end
                end
            end
        end
    end)
end

function MainProperty.InitMiniChat()
    MainProperty._panelMiniChat   = MainProperty._ui["Panel_mini_chat"]
    MainProperty._panelMiniChatBG = MainProperty._ui["Image_minichat_bg"]
    MainProperty._listMiniChat    = MainProperty._ui["ListView_minichat"]
    MainProperty._listMiniChatEx  = MainProperty._ui["ListView_chat_ex"]

    GUI:ListView_autoPaintItems(MainProperty._listMiniChat)
    MainProperty._ChatItemWidth = GUI:getContentSize(MainProperty._listMiniChat).width
    MainProperty._chatListHei = GUI:getContentSize(MainProperty._listMiniChat).height

    local listInterval = GUIDefineEx.ChatContentInterval.listInterval
    if listInterval then
        GUI:ListView_setItemsMargin(MainProperty._listMiniChat, listInterval)
        GUI:ListView_setItemsMargin(MainProperty._listMiniChatEx, listInterval)
    end
end

function MainProperty.OnChatMiniAddItem(item)
    if not MainProperty._listMiniChat then
        return false
    end

    GUI:ListView_pushBackCustomItem(MainProperty._listMiniChat, item)

    -- 超出限制，移除先放入的
    if #GUI:ListView_getItems(MainProperty._listMiniChat) > GUIDefineEx.MobileMainMaxChatNum then
        GUI:ListView_removeItemByIndex(MainProperty._listMiniChat, 0)
    end
    GUI:ListView_jumpToBottom(MainProperty._listMiniChat)
end

function MainProperty.OnShowChatExNotice()
    MainProperty.CheckChatExNotice()
end

function MainProperty.ResetExListSizeByData()
    local exListView = MainProperty._listMiniChatEx
    local itemCount = #ChatData.GetChatExItemsData()
    local margin = GUI:ListView_getItemsMargin(exListView)
    local height = MainProperty._exCellHei * itemCount + (itemCount - 1) * margin
    GUI:setContentSize(exListView, GUI:getContentSize(exListView).width, height)

    local contentHei = MainProperty._chatListHei or (GUI:getContentSize(MainProperty._panelMiniChat).height - 3)
    local listviewSize = GUI:getContentSize(MainProperty._listMiniChat)
    GUI:setContentSize(MainProperty._listMiniChat, listviewSize.width, contentHei - height)
    GUI:ListView_jumpToBottom(MainProperty._listMiniChat)
end

function MainProperty.CheckChatExNotice()
    local exList = MainProperty._listMiniChatEx
    if not exList then
        return false
    end

    if #GUI:ListView_getItems(exList) >= GUIDefine.ChatConfig.LIMIT_COUNT_EX then
        return false
    end
    
    local chatExItems = SL:CopyData(ChatData.GetChatExItemsData())
    if #chatExItems == 0 then
        local oriWidth = GUI:getContentSize(exList).width
        GUI:setContentSize(exList, oriWidth, 0)
        return false
    end

    local data = chatExItems[#chatExItems]
    if not data then
        return false
    end

    data.Time = data.Time or 5
    if data.Time <= 0 then
        ChatData.RemoveChatExItemsData(data)
        MainProperty.ResetExListSizeByData()
        return false
    end

    data.Label          = data.Label or ""
    data.Y              = data.Y or 0
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    data.SendNameTemp   = data.SendName or ""

    local FColorHex     = SL:GetHexColorByStyleId(data.FColor)
    local BColorHex     = SL:GetHexColorByStyleId(data.BColor)
    local BColorEnable  = data.BColor ~= -1
    local cWidth        = GUI:getContentSize(exList).width
    local capacitySize  = {width = cWidth, height = MainProperty._exCellHei}

    local function resetListView()
        local items = GUI:ListView_getItems(exList)
        local height = 0
        local margin = GUI:ListView_getItemsMargin(exList)
        for i, v in ipairs(items) do
            local interval = i ~= #items and margin or 0
            height = height + GUI:getContentSize(v).height + interval
        end
        GUI:setContentSize(exList, capacitySize.width, height)

        local contentHei = MainProperty._chatListHei or (GUI:getContentSize(MainProperty._panelMiniChat).height - 3)
        local listviewSize = GUI:getContentSize(MainProperty._listMiniChat)
        GUI:setContentSize(MainProperty._listMiniChat, listviewSize.width, contentHei - height)
        GUI:ListView_jumpToBottom(MainProperty._listMiniChat)
    end

    local layout = GUI:Layout_Create(-1, "layout", 0, 0, capacitySize.width, capacitySize.height)
    if BColorEnable then 
        GUI:Layout_setBackGroundColor(layout, BColorHex)
        GUI:Layout_setBackGroundColorType(layout, 0)
    end
    GUI:ListView_pushBackCustomItem(exList, layout)
    resetListView()

    local scrollWidget = GUI:Widget_Create(layout, "scrollWidget", 0, 0, capacitySize.width, capacitySize.height)

    local scrollAble = nil
    local scrollSize = {width = 0, height = 0}
    local remaining  = data.Time
    local Msg = SL:FixStringFormatCharacter(data.Msg)
    local hasFormat = string.find(Msg, "%%") 
    local showName = data.SendName and (data.SendName .. ": ") or ""

    local function callback()
        remaining = math.min(remaining, data.Time)
        ChatData.SyncChatExItemsTime(data, remaining)

        local name = showName or ""
        local str = name .. (hasFormat and string.format(Msg, remaining) or Msg)
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
        GUI:removeAllChildren(scrollWidget)
        local richText = GUI:RichTextFCOLOR_Create(scrollWidget, "richText", 0, capacitySize.height / 2, str, 1000, fontSize, FColorHex, MainProperty._richVspace or 0, nil, nil, {outlineSize = 0})
        GUI:setTouchEnabled(richText, true)
        GUI:setAnchorPoint(richText, 0, 0.5)
        if BColorEnable then
            GUI:RichTextFCOLOR_setBackgroundColor(richText, BColorHex)
        end
        
        if not scrollAble then
            scrollSize = GUI:getContentSize(richText)
            scrollAble = scrollSize.width > capacitySize.width
        end

        local richTextSize = GUI:getContentSize(richText)
        GUI:setContentSize(scrollWidget, capacitySize.width, richTextSize.height)
        GUI:setContentSize(layout, capacitySize.width, richTextSize.height)
        if remaining < 0 then
            GUI:ListView_removeItemByIndex(exList, GUI:ListView_getItemIndex(exList, layout))
            resetListView()
            ChatData.RemoveChatExItemsData(data)
        end

        remaining = remaining - 1
    end
    SL:schedule(layout, callback, 1)
    callback()

    -- 滚动
    if scrollAble then
        local time = (scrollSize.width - capacitySize.width) / 50
        GUI:runAction(scrollWidget, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionMoveTo(time, capacitySize.width - scrollSize.width, 0),
            GUI:DelayTime(3), GUI:ActionMoveTo(0, 0, 0))))
    end
end

function MainProperty.OnChatExClear()
    if not MainProperty._listMiniChatEx then
        return false
    end

    GUI:stopAllActions(MainProperty._listMiniChatEx)
    GUI:removeAllChildren(MainProperty._listMiniChatEx)
end

function MainProperty.OnChatAutoShout(data)
    if data and data.openChat and MainProperty._fristCheckAuto then
        return false
    end

    if not MainProperty._fristCheckAuto then
        MainProperty._fristCheckAuto = true
    end

    if not ChatData.GetAutoShoutSwitch() then
        return GUI:stopActionByTag(MainProperty._panelMiniChat, 888)
    end

    local shoutInput = ChatData.GetLocalChatDataByChannel(GUIDefine.ChatChannel.SHOUT)
    if not shoutInput or shoutInput == "" then
        return false
    end

    -- 发送
    local function sendChatMsg(input, channel)
        if not channel or not GUIFunction:CheckAbleToSayByChannel(channel) then
            return false
        end
        local sendData = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = channel, risk = 0, oriMsg = input, status = 0}
        GUIFunction:SendChatMsg(sendData)
    end

    -- 自动喊话开关
    local autoShoutCallback = nil
    autoShoutCallback = function(shoutInput)
        GUI:stopActionByTag(MainProperty._panelMiniChat, 888)
        if not shoutInput or shoutInput == "" then
            return false
        end
        if not ChatData.GetAutoShoutSwitch() then
            return false
        end
        local delay = ChatData.GetAutoShoutDelay()
        local action = SL:schedule(MainProperty._panelMiniChat, function()
            -- 发送
            sendChatMsg(shoutInput, GUIDefine.ChatChannel.SHOUT)
        end, delay)
        GUI:setTag(action, 888)
        --
        sendChatMsg(shoutInput, GUIDefine.ChatChannel.SHOUT)
    end
    autoShoutCallback(shoutInput)
end
---------------------------------------------------------------------------------------------

------------------------------ 内功相关 ------------------------------------------------------
function MainProperty.InitInternalUI()
    -- 斗转
    local dzBg = MainProperty._ui["Image_barbg_dz"]
    if dzBg then
        GUI:addOnClickEvent(dzBg, function ()
            local curDZValue = SL:GetValue("CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
            local maxDZValue = SL:GetValue("MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
            local str = string.format("斗转星移值: %s/%s", curDZValue, maxDZValue)
            local pos = GUI:getWorldPosition(dzBg)
            local data = {}
            data.str = str
            data.worldPos = {x = pos.x, y = pos.y + GUI:getContentSize(dzBg).height}
            data.anchorPoint = {x = 0, y = 1}
            UIOperator:OpenCommonDescTipsUI(data)
        end)
    end

    -- 醉酒
    local zjBg = MainProperty._ui["Image_barbg_zj"]
    if zjBg then
        GUI:addOnClickEvent(zjBg, function ()
            local per = 0
            local str = string.format("醉酒值: %s%%", per)
            local pos = GUI:getWorldPosition(zjBg)
            local data = {}
            data.str = str
            data.worldPos = {x = pos.x, y = pos.y + GUI:getContentSize(zjBg).height}
            data.anchorPoint = {x = 0, y = 1}
            UIOperator:OpenCommonDescTipsUI(data)
        end)
    end
end

function MainProperty.OnRefreshNGShow()
    if SL:GetValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    -- 斗转星移值
    if not MainProperty._dzPanelHei then
        MainProperty._dzPanelHei = GUI:getContentSize(MainProperty._ui["Panel_bar_dz"]).height
    end
    local wid = GUI:getContentSize(MainProperty._ui["Panel_bar_dz"]).width
    local curDZValue = SL:GetValue("CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local maxDZValue = SL:GetValue("MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local per = 0
    if curDZValue and maxDZValue and maxDZValue > 0 then
        per = curDZValue / maxDZValue
    end
    GUI:setContentSize(MainProperty._ui["Panel_bar_dz"], {width = wid, height = MainProperty._dzPanelHei * per})
    
    -- 醉酒值
    if not MainProperty._zjPanelHei then
        MainProperty._zjPanelHei = GUI:getContentSize(MainProperty._ui["Panel_bar_zj"]).height
    end
    local wid = GUI:getContentSize(MainProperty._ui["Panel_bar_zj"]).width
    local per = 0
    GUI:setContentSize(MainProperty._ui["Panel_bar_zj"], {width = wid, height = MainProperty._zjPanelHei * per})

    MainProperty._NGShow = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")
    MainProperty.OnRefreshDZShow()
    GUI:setVisible(MainProperty._ui["Image_barbg_zj"], ON_OFF_zuijiu)
    GUI:setTouchEnabled(MainProperty._ui["Image_barbg_zj"], MainProperty._NGShow and ON_OFF_zuijiu)
end

function MainProperty.OnRefreshDZShow()
    local dzBg = MainProperty._ui["Image_barbg_dz"]
    if dzBg then
        if SL:GetValue("SKILL_DATA", DZXY_SkillID) then
            GUI:setVisible(dzBg, MainProperty._NGShow and true)
            GUI:setTouchEnabled(dzBg, MainProperty._NGShow and true)
        else
            GUI:setVisible(dzBg, false)
            GUI:setTouchEnabled(dzBg, false)
        end
    end
end
---------------------------------------------------------------------------------------------

function MainProperty.OnRefreshPropertyShow()
    --Level
    local roleLevel = SL:GetValue("LEVEL")
    local reinLv = SL:GetValue("RELEVEL") or 0

    local str = string.format("%s%s", reinLv > 0 and reinLv .. "转" or "", roleLevel .. "级")
    GUI:Text_setString(MainProperty._ui["Text_level"], str)

    --EXP
    local curExp = SL:GetValue("EXP")
    local maxExp = SL:GetValue("MAXEXP")
    local expPer = maxExp == 0 and 0 or curExp / maxExp * 100
    GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_exp"], expPer)
    GUI:Text_setString(MainProperty._ui["Text_exp"], string.format("%.1f%%", expPer))

    --HPMP
    local curHP = SL:GetValue("HP")
    local maxHP = SL:GetValue("MAXHP")
    local curMP = SL:GetValue("MP")
    local maxMP = SL:GetValue("MAXMP")
    local hpPer = curHP / maxHP * 100
    local mpPer = curMP / maxMP * 100
    GUI:Text_setString(MainProperty._ui["Text_hp"], string.format("%s/%s", SL:HPUnit(curHP), SL:HPUnit(maxHP)))
    GUI:Text_setString(MainProperty._ui["Text_mp"], string.format("%s/%s", SL:HPUnit(curMP), SL:HPUnit(maxMP)))

    local roleJob = SL:GetValue("JOB")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        GUI:setVisible(MainProperty._ui["LoadingBar_hp"], false)
        GUI:setVisible(MainProperty._ui["LoadingBar_mp"], false)
        GUI:setVisible(MainProperty._ui["Image_divide"], false)
        GUI:setVisible(MainProperty._ui["LoadingBar_fhp"], true)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_fhp"], hpPer)
    else
        GUI:setVisible(MainProperty._ui["LoadingBar_hp"], true)
        GUI:setVisible(MainProperty._ui["LoadingBar_mp"], true)
        GUI:setVisible(MainProperty._ui["Image_divide"], true)
        GUI:setVisible(MainProperty._ui["LoadingBar_fhp"], false)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_hp"], hpPer)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_mp"], mpPer)
    end

    -- 刷新魔血球动画
    MainProperty.RefreshSfxShowPercent()

    -- 刷新内功相关显示
    MainProperty.OnRefreshNGShow()
end

function MainProperty.OnRefreshNetShow()
    -- 网络类型 -1:未识别 0:wifi 1:蜂窝
    local netType = SL:GetValue("NET_TYPE")
    if MainProperty._ui["Image_net"] and netType then
        if netType == 0 then
            GUI:Image_loadTexture(MainProperty._ui["Image_net"], "res/private/main/Other/1900012501.png")
        else
            GUI:Image_loadTexture(MainProperty._ui["Image_net"], "res/private/main/Other/1900012500.png")
        end
    end
end

function MainProperty.OnRefreshBatteryShow(data)
    local per = tonumber(data or SL:GetValue("BATTERY"))
    if MainProperty._ui["LoadingBar_battery"] and per then
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_battery"], per)
    end
end

function MainProperty.OnShowOrHideAutoFightTips(status)
    if status then
        GUI:setVisible(MainProperty._nodeAutoMove, false)
        GUI:setVisible(MainProperty._nodeAutoFight, true)
    else
        GUI:setVisible(MainProperty._nodeAutoFight, false)
    end
end

function MainProperty.OnShowOrHideAutoMoveTips(status)
    if status then
        GUI:setVisible(MainProperty._nodeAutoFight, false)
        GUI:setVisible(MainProperty._nodeAutoMove, true)
    else
        GUI:setVisible(MainProperty._nodeAutoMove, false)
    end
end

function MainProperty.OnReinAttrChange()
    local point = SL:GetValue("BONUS_POINT")
    local isshow = point and tonumber(point) > 0 or false
    GUI:setVisible(MainProperty._ui["btn_rein_add"], isshow)
end

-- 脚本添加魔血球动画
function MainProperty.OnPlayMagicBallEffect(data)
    local prefixL = {"hp_", "mp_", "fhp_"}
    local tagList = {"HPSFX", "MPSFX", "FHPSFX"}

    if data.type < 0 or data.type > 2 or data.count < 0 or data.interval < 0 then
        return
    end
    local scale = data.scale == 0 and 1 or (data.scale / 100)
    local timeval = data.interval / 1000
    local prefix = prefixL[data.type + 1] or ""

    local ani = GUI:Animation_Create()
    local pSize = {width = 0, height = 0}
    for i = data.beginNum, data.beginNum + data.count - 1 do
        local path = string.format("res/private/mhp_ui/%s%s.png", prefix, i)
        if SL:IsFileExist(path) then
            local sp = GUI:Sprite_Create(-1, "sp", 0, 0, path)
            pSize = GUI:getContentSize(sp)
            GUI:Animation_addSpriteFrame(ani, GUI:Sprite_getSpriteFrame(sp))
        end
    end
    GUI:Animation_setDelayPerUnit(ani, timeval)
    GUI:Animation_setLoops(ani, 1)
    GUI:Animation_setRestoreOriginalFrame(ani, true)

    local contentSize = {width = pSize.width * scale, height = pSize.height * scale}
    local tag = tagList[data.type + 1]
    local widget = MainProperty._ui[string.format("Panel_%ssfx", prefix)]
    local sprite
    if tag and widget then
        MainProperty._pSize[tag] = contentSize
        GUI:setContentSize(widget, contentSize.width, contentSize.height)
        if not GUI:getChildByName(widget, tag) then
            sprite = GUI:Sprite_Create(widget, tag, 0, 0)
            GUI:setScale(sprite, scale)
            GUI:runAction(sprite, GUI:ActionRepeatForever(GUI:ActionAnimate(ani)))
        end
    end

    if data.time ~= -1 and data.time > 0 then
        SL:ScheduleOnce(function()
            if sprite and not GUI:Widget_IsNull(sprite) then
                GUI:stopAllActions(sprite)
                GUI:removeFromParent(sprite)
            end
        end, data.time)
    end

    GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], data.type ~= 2)
    GUI:setVisible(MainProperty._ui["Panel_mp_sfx"], data.type ~= 2)
    GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], true)

    if data.type == 0 then -- HP
        GUI:setPosition(widget, data.offsetX, data.offsetY)
    elseif data.type == 1 then -- MP
        local hpPosX = GUI:getPositionX(MainProperty._ui["Panel_hp_sfx"])
        local hpWidth = GUI:getContentSize(MainProperty._ui["Panel_hp_sfx"]).width
        GUI:setPosition(widget, hpPosX + hpWidth + 4 + data.offsetX, data.offsetY)
    elseif data.type == 2 then -- FHP
        GUI:setPosition(widget, data.offsetX, data.offsetY)
    end

    MainProperty._drawHWay[tag] = data.drawHWay
    if data.drawHWay and data.drawHWay == 1 then --按HP/MP真实高度绘制
        MainProperty.RefreshSfxShowPercent()
    end
end

function MainProperty.RefreshSfxShowPercent()
    --HPMP
    local curHP = SL:GetValue("HP")
    local maxHP = SL:GetValue("MAXHP")
    local curMP = SL:GetValue("MP")
    local maxMP = SL:GetValue("MAXMP")
    local hpPer = curHP / maxHP
    local mpPer = curMP / maxMP

    local roleJob = SL:GetValue("JOB")
    local roleLevel = SL:GetValue("LEVEL")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        if MainProperty._ui["Panel_hp_sfx"] and MainProperty._ui["Panel_mp_sfx"] then
            GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], false)
            GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], false)
            GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], true)
        end
    else
        if MainProperty._ui["Panel_hp_sfx"] and MainProperty._ui["Panel_mp_sfx"] then
            GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], true)
            GUI:setVisible(MainProperty._ui["Panel_mp_sfx"], true)
            GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], false)
        end
    end

    local prefixL = {"hp_", "mp_", "fhp_"}
    local tagList = {"HPSFX", "MPSFX", "FHPSFX"}
    for _, tag in ipairs(tagList) do
        local widget = MainProperty._ui[string.format("Panel_%ssfx", prefixL[_])]
        if widget and GUI:getChildByName(widget, tag) then
            local pSize = MainProperty._pSize[tag]
            local drawHWay = MainProperty._drawHWay[tag]
            if not pSize or (not drawHWay) or drawHWay ~= 1 then
                return
            end
            local percent = tag == "MPSFX" and mpPer or hpPer
            GUI:setContentSize(widget, pSize.width, pSize.height * percent)
        end
    end
end

----------------------------- 倒计时提示 -----------------------------------------------------
function MainProperty.OnAddQuitTimeTips(data)
    if not data or not data.time or not data.type then
        return false
    end

    local time 
    local type = data.type  -- 1 小退 2 大退

    local Node_quit_tip = MainProperty._ui["Node_quit_tip"]
    if not Node_quit_tip then
        return false
    end

    local tips = {
        [1] = "<outline size='1'><font color = '#00ff00'>%s秒后将返回选角界面</font></outline>",
        [2] = "<outline size='1'><font color = '#ff0000'>%s秒后将退出游戏</font></outline>",
    }

    local function refreshTime()
        time = time and time - 1 or data.time

        local str = string.format(tips[type], time)

        GUI:removeAllChildren(Node_quit_tip)
        local width = SL:GetValue("SCREEN_WIDTH")
        local richText = GUI:RichText_Create(Node_quit_tip, "richtips", 0, 0, str, width, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16, "#ffffff")
        GUI:setAnchorPoint(richText, 0.5, 0)
    end
    GUI:stopAllActions(Node_quit_tip)
    SL:schedule(Node_quit_tip, refreshTime, 1)
    refreshTime()
end

function MainProperty.OnDelQuitTimeTips()
    local Node_quit_tip = MainProperty._ui["Node_quit_tip"]
    if not Node_quit_tip then
        return false
    end

    GUI:stopAllActions(Node_quit_tip)
    GUI:removeAllChildren(Node_quit_tip)
end
---------------------------------------------------------------------------------------------

------------------------------ 注册事件 ------------------------------------------------------
function MainProperty.RegisterEvent(...)
    -- 气泡相关
    SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_STATUS_CHANGE, "MainProperty", MainProperty.OnRefreshBubbleTips)

    -- 注册事件
    SL:RegisterLUAEvent(LUA_EVENT_HPMP_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_LEVEL_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_EXP_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_NET_CHANGE, "MainProperty", MainProperty.OnRefreshNetShow)
    SL:RegisterLUAEvent(LUA_EVENT_BATTERY_CHANGE, "MainProperty", MainProperty.OnRefreshBatteryShow)
    -- 脚本展示魔血球动画
    SL:RegisterLUAEvent(LUA_EVENT_PLAY_MAGICBALL_EFFECT, "MainProperty", MainProperty.OnPlayMagicBallEffect)
    -- 自动提示相关
    SL:RegisterLUAEvent(LUA_EVENT_AUTOFIGHT_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoFightTips)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVE_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoMoveTips)
    -- 英雄相关
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ANGER_CHANGE, "MainProperty", MainProperty.OnHeroAngerChange)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGIN, "MainProperty", MainProperty.OnHeroLoginOrOut)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT, "MainProperty", MainProperty.OnHeroLoginOrOut)
    -- 转生点改变
    SL:RegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "MainProperty", MainProperty.OnReinAttrChange)
    -- 学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MainProperty", MainProperty.OnRefreshNGShow)
    -- 斗转值改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_DZVALUE_CHANGE, "MainProperty", MainProperty.OnRefreshNGShow)
    -- 技能初始化/增加/删除
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "MainProperty", MainProperty.OnRefreshDZShow)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "MainProperty", MainProperty.OnRefreshDZShow)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainProperty", MainProperty.OnRefreshDZShow)


    SL:RegisterLUAEvent(LUA_EVENT_CHATMINI_ITEM_ADD, "MainProperty", MainProperty.OnChatMiniAddItem)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_EX_NOTICE_ADD, "MainProperty", MainProperty.OnShowChatExNotice)

    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, "MainProperty", MainProperty.OnQuickUseChange)
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_ITEM_REFRESH, "MainProperty", MainProperty.OnQuickUseRefresh)

    SL:RegisterLUAEvent(LUA_EVENT_MAIN_ADD_QUIT_TIME_TIPS, "MainProperty", MainProperty.OnAddQuitTimeTips)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_DEL_QUIT_TIME_TIPS, "MainProperty", MainProperty.OnDelQuitTimeTips)

    SL:RegisterLUAEvent(LUA_EVENT_MAIN_CHAT_EX_CLEAR, "MainProperty", MainProperty.OnChatExClear)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_MOBILE_AUTO_SHOUT, "MainProperty", MainProperty.OnChatAutoShout)
end
----------------------------------------------------------------------------------------------

MainProperty.main()


