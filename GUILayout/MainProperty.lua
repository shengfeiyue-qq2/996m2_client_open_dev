MainProperty = {}

MainProperty._bubbleTipsData = {} -- 气泡数据
MainProperty._bubbleTipsCells = {}

MainProperty._chatItemWid = 310
MainProperty._path = "res/private/main/"

MainProperty._pSize = {}
MainProperty._drawHWay = {} -- 绘制方式

MainProperty._dzSkillID     = 118       -- 斗转星移技能ID
MainProperty._zjShow        = false     -- 醉酒相关是否显示

function MainProperty.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_property")
    MainProperty._ui = GUI:ui_delegate(parent)

    -- 内功开启
    MainProperty._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    local bottomHei = GUI:getContentSize(MainProperty._ui.bottomImg).height
    GUI:setContentSize(MainProperty._ui.bottomImg, screenW + 200, bottomHei)
    local panelBgWid = GUI:getContentSize(MainProperty._ui.Panel_bg).width
    GUI:setPositionX(MainProperty._ui.bottomImg, panelBgWid / 2 - 100)

    -- 时钟定时器
    local function callback()
        local date = os.date("*t", SL:GetMetaValue("SERVER_TIME"))
        GUI:Text_setString(MainProperty._ui.Text_time, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    GUI:ListView_autoPaintItems(MainProperty._ui.ListView_minichat)
    MainProperty._chatItemWid = GUI:getContentSize(MainProperty._ui.ListView_minichat).width

    -- FPS 帧率
    local sumFps = 0
    local count = 0
    SL:Schedule(
        function()
            sumFps = sumFps + SL:GetMetaValue("FPS")
            count = count + 1
        end,
        0
    )
    SL:Schedule(
        function()
            local fps = math.min(math.ceil(sumFps / count), 60)
            GUI:Text_setString(MainProperty._ui.Text_FPS, string.format("FPS:%s", fps))
            sumFps = 0
            count = 0
        end,
        0.5
    )

    -- 聊天页打开
    GUI:addOnClickEvent(MainProperty._ui.Panel_mini_chat_touch, function()
        SL:JumpTo(52)
    end)

    -- 转生属性点分配页打开
    GUI:addOnClickEvent(MainProperty._ui.btn_rein_add, function()
        SL:JumpTo(51)
    end)

    MainProperty.OnRefreshPropertyShow()
    MainProperty.OnRefreshNetShow()
    MainProperty.OnRefreshBatteryShow()
    MainProperty.RegisterEvent()

    -- 初始化
    MainProperty.InitAutoSFXTips()
    MainProperty.InitHero()
    MainProperty.InitChatHideBtn()
    MainProperty.InitQuickUseShow()
    MainProperty.InitInternalUI()

end

function MainProperty.GetChatWidth()
    return MainProperty._chatItemWid
end

--------------------------- 快捷栏 -----------------------------
-- 初始化显示的快捷栏
function MainProperty.InitQuickUseShow()
    local showNum = 0
    -- 默认个数
    if MainProperty._ui.Panel_quick_use and GUI:getVisible(MainProperty._ui.Panel_quick_use) then
        for i = 1, 6 do
            local layout = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if layout and GUI:getVisible(layout) then
                showNum = showNum + 1
            end
        end
    end
    -- 设置快捷框个数 (最大：6)
    SL:SetMetaValue("QUICK_USE_NUM", showNum)
end

-- 快捷栏cell
function MainProperty.CreateQuickUseCell(parent)
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

    -- 拖动区域
    local Panel_quick = GUI:Layout_Create(Panel_cell, "Panel_quick", 0, 0, 52, 50)
    GUI:setTouchEnabled(Panel_quick, true)
    GUI:setSwallowTouches(Panel_quick, false)
end

--------------------------- 气泡栏 -----------------------------
function MainProperty.AddBubbleTips(data)
    data.endTime = data.time and data.time + SL:GetMetaValue("SERVER_TIME")

    if MainProperty._bubbleTipsData[data.id] then
        MainProperty._bubbleTipsData[data.id] = data
        return false
    end
    MainProperty._bubbleTipsData[data.id] = data

    -- 比较优先级插入
    local insertIndex = 1
    local config = SL:GetMetaValue("BUBBLETIPS_INFO", data.id)
    local order = config and config.order or 1
    for i, cell in ipairs(MainProperty._bubbleTipsCells) do
        local cellCfg = SL:GetMetaValue("BUBBLETIPS_INFO", cell.id)
        local cellOrder = cellCfg and cellCfg.order or 1
        if order > cellOrder then
            insertIndex = i
            break
        end
    end

    local tipsCell = MainProperty.CreateBubbleTipsCell(data)
    table.insert(MainProperty._bubbleTipsCells, insertIndex, tipsCell)
    GUI:ListView_insertCustomItem(MainProperty._ui.ListView_bubble_tips, tipsCell.layout, insertIndex - 1)

    SL:PlaySound(50004)
end

function MainProperty.RmvBubbleTips(data)
    if not MainProperty._bubbleTipsData[data.id] then
        return false
    end
    MainProperty._bubbleTipsData[data.id] = nil

    local removeIdx
    for i, cell in pairs(MainProperty._bubbleTipsCells) do
        if cell.id == data.id then
            removeIdx = i
            break
        end
    end

    if removeIdx then
        local removeCell = table.remove(MainProperty._bubbleTipsCells, removeIdx)
        local index = GUI:ListView_getItemIndex(MainProperty._ui.ListView_bubble_tips, removeCell.layout)
        GUI:ListView_removeItemByIndex(MainProperty._ui.ListView_bubble_tips, index)
    end
end

-- 气泡cell
function MainProperty.CreateBubbleTipsCell(data)
    local id = data.id
    local path = data.path

    local node = GUI:Node_Create(-1, "node", 0, 0)

    local Panel_cell = GUI:Layout_Create(node, "Panel_cell", 0, 0, 50, 50)
    GUI:setTouchEnabled(Panel_cell, true)
    GUI:setAnchorPoint(Panel_cell, 0.5, 0.5)

    -- 图标
    local iconBtn = GUI:Button_Create(Panel_cell, "iconBtn", 25, 25, "Default/Button_Normal.png")
    GUI:setAnchorPoint(iconBtn, 0.5, 0.5)
    GUI:setContentSize(iconBtn, 46, 46)

    -- 倒计时
    local timeText = GUI:Text_Create(Panel_cell, "timeText", 25, 7, 16, "#FF0000", "10")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)

    GUI:removeFromParent(Panel_cell)
    if path and string.len(path) > 0 then
        GUI:Button_loadTextureNormal(iconBtn, "res/" .. path)
    else
        local config = SL:GetMetaValue("BUBBLETIPS_INFO", id)
        local normalPath = string.format(MainProperty._path .. "bubble_tips/%s_1.png", config and config.img)
        local pressPath = string.format(MainProperty._path .. "bubble_tips/%s_2.png", config and config.img)
        GUI:Button_loadTextureNormal(iconBtn, normalPath)
        GUI:Button_loadTexturePressed(iconBtn, pressPath)
    end
    GUI:setIgnoreContentAdaptWithSize(iconBtn, true)
    GUI:addOnClickEvent(iconBtn, function()
        if data.callback then
            data.callback(Panel_cell)
        end
    end)

    -- 时间
    local function callback()
        if data.endTime then
            local remaining = data.endTime - SL:GetMetaValue("SERVER_TIME")
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

    GUI:Timeline_Waggle(Panel_cell, 0.05, 20)

    local cell = {
        id = id,
        layout = Panel_cell,
        button = iconBtn
    }
    return cell
end

-- 获取气泡按钮方法
function MainProperty.GetBubbleButtonByID(id)
    for i, cell in pairs(MainProperty._bubbleTipsCells) do
        if cell.id == id then
            return cell.button
        end
    end
    return nil
end

--------------------------- 自动提示 -----------------------------
function MainProperty.InitAutoSFXTips()
    local contentSize = GUI:getContentSize(MainProperty._ui.Panel_auto_tips)
    local posX = contentSize.width / 2
    local posY = 10

    -- 自动战斗
    MainProperty._nodeAutoFight = GUI:Node_Create(MainProperty._ui.Panel_auto_tips, "nodeAutoFight", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoFight, false)
    GUI:Effect_Create(MainProperty._nodeAutoFight, "autoFightSfx", 0, 0, 0, 4009)

    -- 自动寻路
    MainProperty._nodeAutoMove = GUI:Node_Create(MainProperty._ui.Panel_auto_tips, "nodeAutoMove", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoMove, false)
    GUI:Effect_Create(MainProperty._nodeAutoMove, "autoMoveSfx", 0, 0, 0, 4010)
end

--------------------------- 英雄相关 -----------------------------
function MainProperty.InitHero()
    GUI:setVisible(MainProperty._ui.Image_barbg, false)
    MainProperty._maxAngerH = GUI:getContentSize(MainProperty._ui.Image_barbg).height
    MainProperty.RefAnger(0)

    if SL:GetMetaValue("USEHERO") then
        local modeShow = tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) == 0
        if modeShow then
            local size = GUI:getContentSize(MainProperty._ui.Panel_hp)
            local heroProgress = GUI:ProgressTimer_Create(MainProperty._ui.Panel_hp, "heroProgress", size.width / 2, size.height / 2, MainProperty._path .. "Skill/hero2/0_0001.png")
            GUI:setAnchorPoint(heroProgress, 0.5, 0.5)
            GUI:ProgressTimer_setPercentage(heroProgress, 0)
            heroProgress.idx = 1
            SL:schedule(
                MainProperty._ui.Panel_hp,
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
    local size = GUI:getContentSize(MainProperty._ui.Panel_bar)
    GUI:setContentSize(MainProperty._ui.Panel_bar, size.width, value * (MainProperty._maxAngerH or 108))
end

function MainProperty.OnHeroAngerChange(data)
    local modeShow = tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) == 0
    if modeShow and SL:GetMetaValue("USEHERO") then
        if SL:GetMetaValue("HERO_IS_ALIVE") then -- 已召唤英雄
            local forceRefresh = data and data.forceRefresh
            local curAnger = SL:GetMetaValue("H.ANGER")
            local maxAnger = SL:GetMetaValue("H.MAXANGER")
            local angerBarWay = tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao"))
            if angerBarWay and angerBarWay == 1 then -- 条形怒气条
                if maxAnger ~= 0 then
                    MainProperty.RefAnger(curAnger / maxAnger)
                end
                if SL:GetMetaValue("H.SHAN") then
                    if not GUI:getChildByName(MainProperty._ui.Panel_bar, "anger_sfx") then
                        local sfx = GUI:Effect_Create(MainProperty._ui.Panel_bar, "anger_sfx", -6, 66, 0, 7220)
                        GUI:setScaleY(sfx, MainProperty._maxAngerH / 108)
                    end
                    if MainSkill and MainSkill.JointHeroEffect then
                        MainSkill.JointHeroEffect(true)
                    end
                else
                    local sfx = GUI:getChildByName(MainProperty._ui.Panel_bar, "anger_sfx")
                    if sfx then
                        GUI:removeFromParent(sfx)
                    end
                    if MainSkill and MainSkill.JointHeroEffect then
                        MainSkill.JointHeroEffect(false)
                    end
                end
            else -- 圆形怒气条
                local delayTime = SL:GetMetaValue("H.DELAYT")
                local speed = SL:GetMetaValue("H.SPEED")
                local shan = SL:GetMetaValue("H.SHAN")
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
            if tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao")) and tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao")) == 1 then
                MainProperty.RefAnger(0)
            else
                GUI:ProgressTimer_setPercentage(MainProperty._heroProgress, 0)
            end
        end
    end
end

function MainProperty.OnHeroLoginOrOut()
    if tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) and tonumber(SL:GetMetaValue("GAME_DATA", "Progressbarmode")) == 0 then
        if SL:GetMetaValue("USEHERO") then
            if not SL:GetMetaValue("HERO_IS_ALIVE") then
                if MainProperty._heroProgress then
                    GUI:stopAllActions(MainProperty._heroProgress)
                    MainProperty._heroProgress._shan = false
                    GUI:ProgressTimer_setPercentage(MainProperty._heroProgress, 0)
                end
            end
            if tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao")) and tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao")) == 1 then
                GUI:setVisible(MainProperty._ui.Image_barbg,SL:GetMetaValue("HERO_IS_ALIVE"))
                MainProperty.RefAnger(0)
            end
        end
    end
end

--------------------------- 聊天相关 -----------------------------
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
    local _layoutMiniChat = MainProperty._ui.Panel_mini_chat
    local lastShowState = GUI:getVisible(_layoutMiniChat)
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_hide, function()
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

        GUI:Button_setBright(MainProperty._ui.Button_chat_hide, state)
        --通知服务端
        SL:NoticeChatVisible(state)

        if SL:GetMetaValue("GAME_DATA", "NeedResetPosWithChat") then
            local idList = string.split(SL:GetMetaValue("GAME_DATA", "NeedResetPosWithChat"), "#")
            for _, id in ipairs(idList) do
                local i = tonumber(id)
                local name = widgetList[i]
                local widget = MainProperty._ui[name]
                if i and name and widget then
                    if i ~= 8 and i ~= 9 and i ~= 10 then
                        local chatHei = GUI:getContentSize(_layoutMiniChat).height
                        if not tolua.isnull(widget) then
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
                            canSet = tonumber(SL:GetMetaValue("GAME_DATA", "Heronuqitiao")) == 1 and SL:GetMetaValue("HERO_IS_ALIVE")
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

        GUI:delayTouchEnabled(MainProperty._ui.Button_chat_hide, 0.4)
    end)
end

--------------------------- 内功相关 -----------------------------
function MainProperty.InitInternalUI()
    -- 斗转
    local dzBg = MainProperty._ui.Image_barbg_dz
    if dzBg then
        GUI:addOnClickEvent(dzBg, function ()
            local curDZValue = SL:GetMetaValue("INTERNAL_DZ_CURVALUE") or 0
            local maxDZValue = SL:GetMetaValue("INTERNAL_DZ_MAXVALUE") or 0
            local str = string.format("斗转星移值: %s/%s", curDZValue, maxDZValue)
            local pos = GUI:getWorldPosition(dzBg)
            local data = {}
            data.str = str
            data.worldPos = {x = pos.x, y = pos.y + GUI:getContentSize(dzBg).height}
            data.anchorPoint = {x = 0, y = 1}
            SL:OpenCommonDescTipsPop(data)
        end)
    end

    -- 醉酒
    local zjBg = MainProperty._ui.Image_barbg_zj
    if zjBg then
        GUI:addOnClickEvent(zjBg, function ()
            local per = 0
            local str = string.format("醉酒值: %s%%", per)
            local pos = GUI:getWorldPosition(zjBg)
            local data = {}
            data.str = str
            data.worldPos = {x = pos.x, y = pos.y + GUI:getContentSize(zjBg).height}
            data.anchorPoint = {x = 0, y = 1}
            SL:OpenCommonDescTipsPop(data)
        end)
    end
end
--------------------------- 注册事件 -----------------------------
function MainProperty.RegisterEvent(...)
    -- 注册事件
    SL:RegisterLUAEvent(LUA_EVENT_HPMPCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_EXPCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_NETCHANGE, "MainProperty", MainProperty.OnRefreshNetShow)
    SL:RegisterLUAEvent(LUA_EVENT_BATTERYCHANGE, "MainProperty", MainProperty.OnRefreshBatteryShow)
    -- 脚本展示魔血球动画
    SL:RegisterLUAEvent(LUA_EVENT_PLAY_MAGICBALL_EFFECT, "MainProperty", MainProperty.OnPlayMagicBallEffect)
    -- 气泡相关
    SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_STATUS_CHANGE, "MainProperty", MainProperty.OnRefreshBubbleTips)
    -- 自动提示相关
    SL:RegisterLUAEvent(LUA_EVENT_AUTOFIGHT_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoFightTips)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVE_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoMoveTips)
    -- 英雄相关
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ANGER_CAHNGE, "MainProperty", MainProperty.OnHeroAngerChange)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGIN_OROUT, "MainProperty", MainProperty.OnHeroLoginOrOut)
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

end

function MainProperty.OnRefreshPropertyShow()
    --Level
    local roleLevel = SL:GetMetaValue("LEVEL")
    local reinLv = SL:GetMetaValue("RELEVEL") or 0
    if MainProperty._ui.Text_level then
        local str = string.format("%s%s", reinLv > 0 and reinLv .. "转" or "", roleLevel .. "级")
        GUI:Text_setString(MainProperty._ui.Text_level, str)
    end

    --EXP
    local curExp = SL:GetMetaValue("EXP")
    local maxExp = SL:GetMetaValue("MAXEXP")
    local expPer = curExp / maxExp * 100
    GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_exp, expPer)
    GUI:Text_setString(MainProperty._ui.Text_exp, string.format("%.1f%%", expPer))

    --HPMP
    local curHP = SL:GetMetaValue("HP")
    local maxHP = SL:GetMetaValue("MAXHP")
    local curMP = SL:GetMetaValue("MP")
    local maxMP = SL:GetMetaValue("MAXMP")
    local hpPer = curHP / maxHP * 100
    local mpPer = curMP / maxMP * 100
    GUI:Text_setString(MainProperty._ui.Text_hp, string.format("%s/%s", SL:HPUnit(curHP), SL:HPUnit(maxHP)))
    GUI:Text_setString(MainProperty._ui.Text_mp, string.format("%s/%s", SL:HPUnit(curMP), SL:HPUnit(maxMP)))

    local roleJob = SL:GetMetaValue("JOB")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        GUI:setVisible(MainProperty._ui.LoadingBar_hp, false)
        GUI:setVisible(MainProperty._ui.LoadingBar_mp, false)
        GUI:setVisible(MainProperty._ui.Image_divide, false)
        GUI:setVisible(MainProperty._ui.LoadingBar_fhp, true)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_fhp, hpPer)
    else
        GUI:setVisible(MainProperty._ui.LoadingBar_hp, true)
        GUI:setVisible(MainProperty._ui.LoadingBar_mp, true)
        GUI:setVisible(MainProperty._ui.Image_divide, true)
        GUI:setVisible(MainProperty._ui.LoadingBar_fhp, false)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_hp, hpPer)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_mp, mpPer)
    end

    -- 刷新魔血球动画
    MainProperty.RefreshSfxShowPercent()

    -- 刷新内功相关显示
    MainProperty.OnRefreshNGShow()
end

function MainProperty.OnRefreshNetShow()
    -- 网络类型 -1:未识别 0:wifi 1:蜂窝
    local netType = SL:GetMetaValue("NET_TYPE")
    if MainProperty._ui.Image_net and netType then
        if netType == 0 then
            GUI:Image_loadTexture(MainProperty._ui.Image_net, "res/private/main/Other/1900012501.png")
        else
            GUI:Image_loadTexture(MainProperty._ui.Image_net, "res/private/main/Other/1900012500.png")
        end
    end
end

function MainProperty.OnRefreshBatteryShow(data)
    local per = tonumber(data or SL:GetMetaValue("BATTERY"))
    if MainProperty._ui.LoadingBar_battery and per then
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_battery, per)
    end
end

function MainProperty.OnRefreshBubbleTips(data)
    if data.status then
        MainProperty.AddBubbleTips(data)
    else
        MainProperty.RmvBubbleTips(data)
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
    local point = SL:GetMetaValue("BONUSPOINT")
    local isshow = point and tonumber(point) > 0 or false
    GUI:setVisible(MainProperty._ui.btn_rein_add, isshow)
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
            if sprite and not tolua.isnull(sprite) then
                GUI:stopAllActions(sprite)
                GUI:removeFromParent(sprite)
            end
        end, data.time)
    end

    GUI:setVisible(MainProperty._ui.Panel_hp_sfx, data.type ~= 2)
    GUI:setVisible(MainProperty._ui.Panel_mp_sfx, data.type ~= 2)
    GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, true)

    if data.type == 0 then -- HP
        GUI:setPosition(widget, data.offsetX, data.offsetY)
    elseif data.type == 1 then -- MP
        local hpPosX = GUI:getPositionX(MainProperty._ui.Panel_hp_sfx)
        local hpWidth = GUI:getContentSize(MainProperty._ui.Panel_hp_sfx).width
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
    local curHP = SL:GetMetaValue("HP")
    local maxHP = SL:GetMetaValue("MAXHP")
    local curMP = SL:GetMetaValue("MP")
    local maxMP = SL:GetMetaValue("MAXMP")
    local hpPer = curHP / maxHP
    local mpPer = curMP / maxMP

    local roleJob = SL:GetMetaValue("JOB")
    local roleLevel = SL:GetMetaValue("LEVEL")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        if MainProperty._ui.Panel_hp_sfx and MainProperty._ui.Panel_mp_sfx then
            GUI:setVisible(MainProperty._ui.Panel_hp_sfx, false)
            GUI:setVisible(MainProperty._ui.Panel_mp_sfx, false)
            GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, true)
        end
    else
        if MainProperty._ui.Panel_hp_sfx and MainProperty._ui.Panel_mp_sfx then
            GUI:setVisible(MainProperty._ui.Panel_hp_sfx, true)
            GUI:setVisible(MainProperty._ui.Panel_mp_sfx, true)
            GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, false)
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

function MainProperty.OnRefreshNGShow()
    if SL:GetMetaValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    -- 斗转星移值
    if not MainProperty._dzPanelHei then
        MainProperty._dzPanelHei = GUI:getContentSize(MainProperty._ui.Panel_bar_dz).height
    end
    local wid = GUI:getContentSize(MainProperty._ui.Panel_bar_dz).width
    local curDZValue = SL:GetMetaValue("INTERNAL_DZ_CURVALUE")
    local maxDZValue = SL:GetMetaValue("INTERNAL_DZ_MAXVALUE")
    local per = 0
    if curDZValue and maxDZValue and maxDZValue > 0 then
        per = curDZValue / maxDZValue
    end
    GUI:setContentSize(MainProperty._ui.Panel_bar_dz, {width = wid, height = MainProperty._dzPanelHei * per})
    
    -- 醉酒值
    if not MainProperty._zjPanelHei then
        MainProperty._zjPanelHei = GUI:getContentSize(MainProperty._ui.Panel_bar_zj).height
    end
    local wid = GUI:getContentSize(MainProperty._ui.Panel_bar_zj).width
    local per = 0
    GUI:setContentSize(MainProperty._ui.Panel_bar_zj, {width = wid, height = MainProperty._zjPanelHei * per})

    MainProperty._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")
    MainProperty.OnRefreshDZShow()
    GUI:setVisible(MainProperty._ui.Image_barbg_zj, MainProperty._zjShow)
    GUI:setTouchEnabled(MainProperty._ui.Image_barbg_zj, MainProperty._NGShow and MainProperty._zjShow)
end

function MainProperty.OnRefreshDZShow()
    local dzBg = MainProperty._ui.Image_barbg_dz
    if dzBg then
        if SL:GetMetaValue("SKILL_DATA", MainProperty._dzSkillID) then
            GUI:setVisible(dzBg, MainProperty._NGShow and true)
            GUI:setTouchEnabled(dzBg, MainProperty._NGShow and true)
        else
            GUI:setVisible(dzBg, false)
            GUI:setTouchEnabled(dzBg, false)
        end
    end
end
