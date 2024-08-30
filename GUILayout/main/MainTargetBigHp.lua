MainTargetBigHp = {}

local SummonsState = {
    NO_ALIVED = 1,  -- 没有复活
    NO_LOCK   = 2,  -- 没有锁定
    LOCK      = 3   -- 已锁定
}

function MainTargetBigHp.main()
    local parent = GUI:Attach_Center()
    GUI:LoadExport(parent, "main/main_target_big_hp")
    MainTargetBigHp._root = GUI:getChildByName(parent, "Main_Target_Big_Hp")

    MainTargetBigHp._ui = GUI:ui_delegate(MainTargetBigHp._root)
    if not MainTargetBigHp._ui then
        return false
    end

    GUI:setPosition(MainTargetBigHp._root, SL:GetValue("SCREEN_WIDTH") / 2, SL:GetValue("SCREEN_HEIGHT") - 50)

    local size = SL:GetValue("IS_PC_OPER_MODE") and 12 or 16
    local scrollText = GUI:ScrollText_Create(MainTargetBigHp._ui.Text_belong_name, "scrollText", 45, 0, 94, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    MainTargetBigHp._belongScrollNameText = scrollText

    local scrollText1 = GUI:ScrollText_Create(MainTargetBigHp._ui.Text_monster_name, "scrollText1", 84, 0, 162, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText1, 2)
    GUI:ScrollText_enableOutline(scrollText1, "#111111", 1)
    GUI:setAnchorPoint(scrollText1, 0.5, 0.5)
    MainTargetBigHp._monsterScrollNameText = scrollText1

    MainTargetBigHp.Init()
    MainTargetBigHp.InitUI()
    MainTargetBigHp.ClearData()

    MainTargetBigHp.RegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function MainTargetBigHp.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CHANGE, "MainTargetBigHp", MainTargetBigHp.OnTargetChange)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_HP_REFRESH, "MainTargetBigHp", MainTargetBigHp.OnRefreshActorHP)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE, "MainTargetBigHp", MainTargetBigHp.OnActorOwnerChange)
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "MainTargetBigHp", MainTargetBigHp.OnSummonsAliveStatusChange)
end

function MainTargetBigHp.Init()
    MainTargetBigHp._hpUnit = tonumber(SL:GetValue("GAME_DATA", "monster_hp_count")) -- 一条血条的血量配置
    MainTargetBigHp._hpTubeCount = 1                            -- 血条总数
    MainTargetBigHp._currHpTube = -1                            -- 当前显示的血条
    MainTargetBigHp._selectActorID = nil                        -- 目标targetID
    MainTargetBigHp._barHpLocalZ = 99                           -- 血条层级
    MainTargetBigHp._showTubeAction = false                     -- 血量文本是否正在进行动画
    MainTargetBigHp._tubeTipOringPos = cc.p(0, 0)        -- 记录血量文本初始位置
    MainTargetBigHp._hpActions = {}                             -- 血量变化记录
    MainTargetBigHp._lastHP = 0                                 -- 记录最后一次的血量
    MainTargetBigHp._runActioning = false                       -- 记录是否正在进行血量文本加载
    MainTargetBigHp._tubeActions = {}                           -- 血量文本变化记录
    MainTargetBigHp._hpBasePath = global.MMO.PATH_RES_PRIVATE .. "main_monster_ui/hp/"          -- 资源位置
    MainTargetBigHp._monsterBasePath = global.MMO.PATH_RES_PRIVATE .. "main_monster_ui/monster/" -- 资源位置
end

function MainTargetBigHp.InitUI()
    local hpTipText = MainTargetBigHp._ui["Text_hp_tip"]
    local posx, posy = GUI:getPosition(hpTipText)
    MainTargetBigHp._tubeTipOringPos.x = posx
    MainTargetBigHp._tubeTipOringPos.y = posy

    GUI:Text_setString(MainTargetBigHp._ui["Text_belong_name"], "")
    GUI:Text_setString(MainTargetBigHp._ui["Text_monster_name"], "")

    GUI:setLocalZOrder(MainTargetBigHp._ui["Text_hp"], MainTargetBigHp._barHpLocalZ + MainTargetBigHp._barHpLocalZ)
    GUI:setLocalZOrder(MainTargetBigHp._ui["Panel_hp_tip"], MainTargetBigHp._barHpLocalZ + MainTargetBigHp._barHpLocalZ)

    local p = GUI:getPosition(MainTargetBigHp._ui["Node_bar_tip"])
    MainTargetBigHp._sui_root = GUI:Node_Create(MainTargetBigHp._ui["Panel_1"], "xxx", p.x, p.y)
	GUI:setLocalZOrder(MainTargetBigHp._sui_root, 999)

    GUI:addOnTouchEvent(MainTargetBigHp._ui["Image_icon"], MainTargetBigHp.OnTouchHeadPic)
    GUI:addOnClickEvent(MainTargetBigHp._ui["Button_lock"], MainTargetBigHp.OnClickLock)
    GUI:addOnClickEvent(MainTargetBigHp._ui["Button_close"], MainTargetBigHp.OnClose)
end

-- 头像点击事件
function MainTargetBigHp.OnTouchHeadPic(sender, eventType)
    if eventType == GUIDefine.TouchEventType.BEGAN then
        -- 开始点击-图片置灰
        GUI:Image_setGrey(sender, true)
    elseif eventType == GUIDefine.TouchEventType.MOVED then
        -- 移动
    else 
        -- 松开-图片恢复
        GUI:Image_setGrey(sender, false)

        -- 图片内松开
        if eventType == GUIDefine.TouchEventType.ENDED then
            local targetID = MainTargetBigHp._selectActorID
            if not targetID then
                return false
            end

            if not SL:GetValue("ACTOR_IS_MONSTER", targetID) then
                return false
            end
            
            -- 请求点击大血条头像
            local actorIDX = SL:GetValue("ACTOR_TYPE_INDEX", targetID)
            SL:RequestBigHpClick(actorIDX, targetID)
            GUI:delayTouchEnabled(sender)
        end
    end
end

-- 关闭按钮点击事件
function MainTargetBigHp.OnClose()
    SL:SetValue("SELECT_TARGET_ID", nil)
end

-- 锁定按钮点击事件
function MainTargetBigHp.OnClickLock(sender)
    MainTargetBigHp.UpdateLockBtn(function (state)
        if state == SummonsState.LOCK then
            -- 请求取消宠物锁定
            SL:RequestUnLockPetID(MainTargetBigHp._selectActorID)

            -- 按钮延迟0.2s才能重新激活触摸
            GUI:setClickDelay(sender, 0.2)
        elseif state == SummonsState.NO_LOCK then
            -- 请求宠物锁定
            SL:RequestLockPetID(MainTargetBigHp._selectActorID)

            -- 按钮延迟0.2s才能重新激活触摸
            GUI:setClickDelay(sender, 0.2)
        end
    end)
end

-- 刷新锁定按钮
function MainTargetBigHp.UpdateLockBtn(callback)
    local targetID = MainTargetBigHp._selectActorID
    if not targetID then
        return false
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return false
    end

    local btnLock = MainTargetBigHp._ui["Button_lock"]

    if not SL:GetValue("PET_ALIVE") then
        if callback then
            return callback(SummonsState.NO_ALIVED)
        end
        GUI:setVisible(btnLock, false)
        return false
    end

    GUI:setVisible(btnLock, true)

    local lockID = SL:GetValue("PET_LOCK_ID")

    -- 已锁定(_1)
    local path = string.format("%splayer_hero/btn_heji_05%s.png", GUIDefine.PATH_RES_PRIVATE, lockID == targetID and "_1" or "")
    GUI:Button_loadTextureNormal(btnLock, path)
    GUI:Button_loadTexturePressed(btnLock, path)
    GUI:Button_loadTextureDisabled(btnLock, path)

    if callback then
        callback(lockID == targetID and SummonsState.LOCK or SummonsState.NO_LOCK)
    end
end

-- 刷新UI初始化
function MainTargetBigHp.ClearData()
    GUI:setVisible(MainTargetBigHp._ui["Panel_1"], false)
    GUI:stopAllActions(MainTargetBigHp._ui["Panel_1"])
    GUI:stopAllActions(MainTargetBigHp._ui["Node_bar_tip"])
    GUI:Text_setString(MainTargetBigHp._ui["Text_hp"], "")
    GUI:stopAllActions(MainTargetBigHp._ui["Text_hp_tip"])
    GUI:Text_setString(MainTargetBigHp._ui["Text_hp_tip"], "")
    MainTargetBigHp._showTubeAction = false
end

-- 隐藏UI
function MainTargetBigHp.OnHide()
    if MainTargetBigHp._selectActorID then
        MainTargetBigHp._runActioning = false
        local actionData = MainTargetBigHp._hpActions[#MainTargetBigHp._hpActions] -- 执行最后的数据
        if actionData then
            actionData.timeP = 0
            MainTargetBigHp.CheckRunBarAction(actionData)
        end
        MainTargetBigHp._hpActions = {}
        MainTargetBigHp._tubeActions = {}
        MainTargetBigHp._selectActorID = nil
        MainTargetBigHp._currHpTube = -1

        GUI:stopAllActions(MainTargetBigHp._ui["Node_bar_tip"])
        MainTargetBigHp.ChangeHPBarTX(MainTargetBigHp._ui["Image_loading_bg"])
        MainTargetBigHp.ChangeHPBarTX(MainTargetBigHp._ui["LoadingBar_hp_bar"])
        MainTargetBigHp.ShowHideAction(true, function()
            GUI:setVisible(MainTargetBigHp._ui["Panel_1"], false)
        end)
    end

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.MainTargetBigHp
    })
end

-- 刷新UI
function MainTargetBigHp.UpdateMonsterUI(targetID)
    if MainTargetBigHp._selectActorID == targetID then
        return false
    end

    MainTargetBigHp.ClearData()

    MainTargetBigHp._currHpTube = -1
    MainTargetBigHp._selectActorID = targetID

    MainTargetBigHp.UpdateLockBtn()

    if not targetID then
        return false
    end
    
    -- 非怪或者是宝宝怪
    if not SL:GetValue("ACTOR_IS_MONSTER", targetID) or SL:GetValue("ACTOR_HAVE_MASTER", targetID) then
        MainTargetBigHp.OnHide()
        return false
    end

    local curHp = SL:GetValue("ACTOR_HP", targetID)
    local maxHP = SL:GetValue("ACTOR_MAXHP", targetID)

    MainTargetBigHp._hpUnit = tonumber(SL:GetValue("GAME_DATA", "monster_hp_count")) or maxHP
    MainTargetBigHp._hpTubeCount = math.ceil(maxHP / MainTargetBigHp._hpUnit)
    MainTargetBigHp._lastHP = curHp

    if maxHP < MainTargetBigHp._hpUnit then
        MainTargetBigHp._hpUnit = math.ceil(maxHP / MainTargetBigHp._hpTubeCount)
    end

    local hpTipText = MainTargetBigHp._ui.Text_hp_tip
    local curHpNum = math.ceil(curHp / MainTargetBigHp._hpUnit)
    MainTargetBigHp._currHpTube = curHpNum
    GUI:setPosition(hpTipText, MainTargetBigHp._tubeTipOringPos.x, MainTargetBigHp._tubeTipOringPos.y)

    MainTargetBigHp.UpdateUIHpTip(curHpNum)
    MainTargetBigHp.UpdateMonserIcon()
    MainTargetBigHp.UpdateMonserName()
    MainTargetBigHp.UpdateMonserLevel()
    MainTargetBigHp.UpdateBelongName()

    MainTargetBigHp.OnRefreshHP({
        actorID = MainTargetBigHp._selectActorID,
        isinitui = true
    })
    MainTargetBigHp.ShowHideAction()

    return true
end

-- 刷新UI 当前血条数
function MainTargetBigHp.UpdateUIHpTip(hpnum)
    GUI:Text_setString(MainTargetBigHp._ui.Text_hp_tip, "X " .. hpnum or 0)
end

-- 刷新UI 头像
function MainTargetBigHp.UpdateMonserIcon()
    local path = string.format(MainTargetBigHp._monsterBasePath .. "%05d.png", SL:GetValue("ACTOR_BIGICON_ID", MainTargetBigHp._selectActorID) or 0)
    GUI:Image_loadTexture(MainTargetBigHp._ui["Image_icon"], path)
end

-- 刷新UI 怪物名字
function MainTargetBigHp.UpdateMonserName()
    GUI:ScrollText_setString(MainTargetBigHp._monsterScrollNameText, SL:GetValue("ACTOR_NAME", MainTargetBigHp._selectActorID) or "")
end

-- 刷新UI 怪物等级
function MainTargetBigHp.UpdateMonserLevel()
    GUI:Text_setString(MainTargetBigHp._ui.Text_lv, "LV." .. SL:GetValue("ACTOR_LEVEL", MainTargetBigHp._selectActorID))
end

function MainTargetBigHp.UpdateMonserHp(hpPercent)
    GUI:Text_setString(MainTargetBigHp._ui["Text_hp"], (hpPercent or 0) .. "%")
end

-- 刷新UI 归属名
function MainTargetBigHp.UpdateBelongName()
    GUI:ScrollText_setString(MainTargetBigHp._belongScrollNameText, SL:GetValue("ACTOR_OWNER_NAME", MainTargetBigHp._selectActorID) or "")
    local Text = GUI:getChildByName(MainTargetBigHp._belongScrollNameText, "Text")
    if Text and GUI:getContentSize(Text).width < 94 then
        GUI:setPositionX(MainTargetBigHp._belongScrollNameText, GUI:getContentSize(Text).width / 2 - 2)
    else
        GUI:setPositionX(MainTargetBigHp._belongScrollNameText, 45)
    end
end

-- 血量刷新
function MainTargetBigHp.OnRefreshHP(data)
    if not MainTargetBigHp._selectActorID then
        return false
    end

    data = data or {}

    local targetID = data.actorID
    if MainTargetBigHp._selectActorID ~= targetID then
        return false
    end

    if not SL:GetValue("ACTOR_IS_VALID", targetID) then
        return MainTargetBigHp:OnHide()
    end

    local curHp = SL:GetValue("ACTOR_HP", targetID)
    local maxHP = SL:GetValue("ACTOR_MAXHP", targetID)
    local currTube  = math.ceil(curHp / MainTargetBigHp._hpUnit)
    local hpPercent = math.ceil(curHp / maxHP * 100)
    MainTargetBigHp.UpdateMonserHp(hpPercent)

    -- 显示血条管的loading的血量
    local showHp = curHp - MainTargetBigHp._hpUnit * (currTube - 1)

    -- 血条管的百分比
    local percent = math.max(showHp / MainTargetBigHp._hpUnit * 100, 0)

    local hpBar = MainTargetBigHp._ui["LoadingBar_hp_bar"]

    -- 是否是重置后的数据，需要重新赋值
    if MainTargetBigHp._currHpTube < 0 then
        MainTargetBigHp._currHpTube = currTube
        MainTargetBigHp._lastHP = curHp
        GUI:LoadingBar_setPercent(hpBar, 100)
    end

    -- 是否是回血状态
    local isRestore = curHp > MainTargetBigHp._lastHP

    -- 读取血量变化的最后一次的记录
    local actionT = MainTargetBigHp._hpActions[#MainTargetBigHp._hpActions]

    -- 读取记录开始的bar的百分比
    local fristP = hpBar:getPercent()
    if actionT and actionT.endP then
        fristP = actionT.endP
    end

    local isCheck = true
    if not data.isinitui and MainTargetBigHp._currHpTube ~= currTube and currTube > 0 then
        isCheck = false
        local startTube = MainTargetBigHp._currHpTube
        local tubeNums = math.abs(startTube - currTube)
        local startIndex = 1
		if tubeNums > 4 then
			startIndex = tubeNums - 4
		end
        for i = startIndex, tubeNums do
            local showHPTube = isRestore and (startTube + i) or (startTube - i)
            MainTargetBigHp.AddLoadingActionData({
                startP      = i == startIndex and fristP or (isRestore and 0 or 100),
                endP        = i == tubeNums and percent or (isRestore and 100 or 0),
                timeP       = 0.2,
                showHPTube  = showHPTube,
                isRestore   = isRestore,
                isChangeBar = true
            })
        end
    end

    if isCheck and (data.isinitui or MainTargetBigHp._lastHP ~= curHp) then
        local isChangeBar = data.isinitui or (actionT and actionT.showHPTube ~= currTube or false)
        MainTargetBigHp.AddLoadingActionData({
            startP = data.isinitui and percent or fristP,
            endP = percent,
            timeP = 0.5,
            showHPTube = currTube,
            isRestore = isRestore,
            isChangeBar = isChangeBar
        })
    end

    MainTargetBigHp._lastHP = curHp
    MainTargetBigHp._currHpTube = currTube

    MainTargetBigHp.CheckLoadingAction()
end

-- 动作变化数据添加
function MainTargetBigHp.AddLoadingActionData(data)
    if #MainTargetBigHp._hpActions > 5 then
        table.remove(MainTargetBigHp._hpActions, 1)
    end
    table.insert(MainTargetBigHp._hpActions, data)
end

-- 检测进度条动作
function MainTargetBigHp.CheckRunBarAction(data)
    if data.isChangeBar then
        table.insert(MainTargetBigHp._tubeActions, {
            tube = data.showHPTube or 0, timeP = data.timeP or 0.1
        })
        MainTargetBigHp.ShowTubeAction()
        MainTargetBigHp.ChangeHPLoadingShow(data.showHPTube or 0)
    end
    MainTargetBigHp.RunBarAction(MainTargetBigHp._ui["LoadingBar_hp_bar"], data)
end

-- 血条更换资源(showHPTube: 更换的血条数)
function MainTargetBigHp.ChangeHPLoadingShow(showHPTube)
    -- 资源下标
    local barTube = showHPTube % 10
    if showHPTube > 0 then
        barTube = barTube == 0 and 10 or barTube
    end

    local loadingBgImage = MainTargetBigHp._ui["Image_loading_bg"]
    local hpBarLoadingBar = MainTargetBigHp._ui["LoadingBar_hp_bar"]

    local animId = nil
    local bgPath = nil
    if showHPTube > 1 then
        local newBarTube = barTube == 1 and 10 or (barTube - 1)
        bgPath = string.format(MainTargetBigHp._hpBasePath .. "%02d.png", newBarTube)
        GUI:Image_loadTexture(loadingBgImage, bgPath)
        GUI:setLocalZOrder(loadingBgImage, MainTargetBigHp._barHpLocalZ + 2)
        animId = 7300 + newBarTube
    end
    MainTargetBigHp.ChangeHPBarTX(loadingBgImage, animId)
    GUI:setVisible(loadingBgImage, showHPTube > 1)

    GUI:setVisible(hpBarLoadingBar, true)
    GUI:setLocalZOrder(hpBarLoadingBar, MainTargetBigHp._barHpLocalZ + 3)
    local loadingImagePath = string.format(MainTargetBigHp._hpBasePath .. "%02d.png", barTube)
    GUI:LoadingBar_loadTexture(hpBarLoadingBar, loadingImagePath)
    GUI:LoadingBar_setPercent(hpBarLoadingBar, 50)

    local animId = 7300 + barTube
    MainTargetBigHp.ChangeHPBarTX(hpBarLoadingBar, animId, function(sender)
        local animBar = GUI:getChildByName(hpBarLoadingBar, "HP_BAR_TX")
        if not MainTargetBigHp._runActioning and animBar and animBar.frameScale then
            local scalex = animBar.frameScale.x or 1
            local currPercent = GUI:LoadingBar_getPercent(hpBarLoadingBar)
            GUI:setScaleX(animBar, currPercent / 100 * scalex)
        end
    end)
end

-- 更换血条特效 (parentNode: 父节点控件; animID: 特效id; func: 回调接口)
function MainTargetBigHp.ChangeHPBarTX(parentNode, animID, func)
    local anim = GUI:getChildByName(parentNode, "HP_BAR_TX")
    if anim then
        GUI:removeFromParent(anim)
        anim = nil
    end
    if not animID then
        return false
    end

    local sz = GUI:getContentSize(parentNode)
    
    local anim = GUI:Effect_Create(parentNode, "HP_BAR_TX", 0, sz.height, 0, animID)
    if not anim then
        return false
    end 
    GUI:setTag(anim, animID)
    GUI:setVisible(anim, false)

    anim.frameScale = {}
    SL:scheduleOnce(anim, function()
        local boundBox = anim:GetFrameBox()
        GUI:setScaleX(anim, boundBox.width / sz.width)
        GUI:setScaleY(anim, boundBox.height / sz.height)
        GUI:setVisible(anim, true)
        if func then
            func()
        end
    end, 0.5)
end

-- 检测加载动作
function MainTargetBigHp.CheckLoadingAction()
    if MainTargetBigHp._runActioning or #MainTargetBigHp._hpActions <= 0 then
        return false
    end
    local actionData = table.remove(MainTargetBigHp._hpActions, 1)
    if actionData then
        MainTargetBigHp.CheckRunBarAction(actionData)
    end
end

-- 血条变化动作 (barNode: loadingbar控件)
function MainTargetBigHp.RunBarAction(barNode, data)
    data = data or {}

    if not next(data) then
        return false
    end

    MainTargetBigHp._runActioning = true

    local times   = 20
    local startP  = data.startP or 100
    local endP    = data.endP or 0
    local hpStand = (endP - startP) / times
    local actionFunc = function(sender)
        if times <= 0 then
            GUI:stopAllActions(barNode)
            MainTargetBigHp._runActioning = false
            MainTargetBigHp.CheckLoadingAction()
            return
        end
        times = times - 1
        startP = startP + hpStand
        GUI:LoadingBar_setPercent(sender, startP)
        local animBar = GUI:getChildByName(sender, "HP_BAR_TX")
        if animBar and animBar.frameScale then
            local scalex = animBar.frameScale.x or 1
            GUI:setScaleX(animBar, startP / 100 * scalex)
        end
    end
    SL:schedule(barNode, actionFunc, 0.01)
end

-- 血条数文本提示动画
function MainTargetBigHp.ShowTubeAction()
    if MainTargetBigHp._showTubeAction then
        return false
    end

    local tubeData = table.remove(MainTargetBigHp._tubeActions, 1)
    if not tubeData then
        return false
    end

    local tube = tubeData.tube
    local delayTime = tubeData.timeP
    if delayTime > 0.2 then
        delayTime = 0.2
    end
    MainTargetBigHp._showTubeAction = true

    local clipSz = GUI:getContentSize(MainTargetBigHp._ui["Panel_hp_tip"])

    local action = GUI:ActionSequence(
        GUI:ActionMoveBy(delayTime / 2, 0, clipSz.height / 2),      -- 往上移动
        GUI:CallFunc(function()                                     -- 往上移动结束的位置位于底部
            MainTargetBigHp.UpdateUIHpTip(tube)
            GUI:setPositionY(MainTargetBigHp._ui["Text_hp_tip"], -(clipSz.height / 2))
        end), 
        GUI:ActionMoveTo(delayTime / 2, MainTargetBigHp._tubeTipOringPos.x, MainTargetBigHp._tubeTipOringPos.y), -- 往上移动
        GUI:CallFunc(function()                                      -- 结束的回调
            MainTargetBigHp._showTubeAction = false
            MainTargetBigHp.ShowTubeAction()
        end))

    GUI:runAction(MainTargetBigHp._ui["Text_hp_tip"], action)
end

-- 显示隐藏时的动画(isHide: 是否是隐藏; func: 动画执行完的回调)
function MainTargetBigHp.ShowHideAction(isHide, func)
    local panelRoot = MainTargetBigHp._ui["Panel_1"]
    local startScale = isHide and 1 or 0.1
    local startOpacity = isHide and 255 or 0
    local endScale = isHide and 0 or 1
    local endOpacity = isHide and 0 or 255

    local action2 = GUI:ActionSequence(
        GUI:ActionSpawn(GUI:ActionScaleTo(0.15, endScale), cc.FadeTo:create(0.15, endOpacity)), 
        GUI:CallFunc(function()
            if func then
                func()
            end
        end))

    GUI:setVisible(panelRoot, true)
    GUI:setScale(panelRoot, startScale)
    GUI:setOpacity(panelRoot, startOpacity)
    GUI:runAction(panelRoot, action2)
end

function MainTargetBigHp.OnTargetChange(targetID)
    if targetID and SL:GetValue("ACTOR_IS_MONSTER", targetID) and SL:GetValue("ACTOR_BIGICON_ID", targetID) then
        if MainTargetBigHp.UpdateMonsterUI(targetID) then
            SL:AttachTXTSUI({root = MainTargetBigHp._sui_root, index = SLDefine.SUIComponentTable.MainTargetBigHp})
        end
        MainTargetBigHp._isShow = true
        -- 目标归属
        UIOperator:OpenTargetBelongUI({parent = MainTargetBigHp._root, targetID = targetID, X = 40, Y = -70})
    else
        MainTargetBigHp.OnHide()

        if not MainTargetBigHp._isShow then
            return false
        end
        MainTargetBigHp._isShow = false
        
        -- 目标归属
        UIOperator:OpenTargetBelongUI({parent = MainTargetBigHp._root, targetID = nil, X = 40, Y = -70})
    end
end

function MainTargetBigHp.OnRefreshActorHP(data)
    MainTargetBigHp.OnRefreshHP(data)
end

-- 更新归属
function MainTargetBigHp.OnActorOwnerChange(data)
    MainTargetBigHp.UpdateBelongName(data)
end

-- 锁定改变
function MainTargetBigHp.OnSummonsAliveStatusChange()
    MainTargetBigHp.UpdateLockBtn()
end

MainTargetBigHp.main()