MainSkill = {}

MainSkill._showIndex = 0

function MainSkill.main()
    local parent = GUI:Attach_RightBottom()
    GUI:LoadExport(parent, "main/skill/main_skill")
    parent = GUI:getChildByName(parent, "Main_Skill") or parent

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    MainSkill._ui = ui

    GUI:setPositionY(parent, 25)

    GUI:setContentSize(ui["Panel_hide"], SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))

    MainSkill._Panel_skill  = ui["Panel_skill"]
    MainSkill._Panel_active = ui["Panel_active"]

    GUI:SetGUIParent(109, MainSkill._Panel_active)

    -- 内功开启
    MainSkill._NGOpen = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")

    MainSkill._nodeCells  = {}
    MainSkill._skillCells = {}
    MainSkill._jointSkillCell = nil
    MainSkill._comboSkillID = nil

    MainSkill.InitPick()
    MainSkill.InitButton()
    MainSkill.InitSkill()
    MainSkill.InitQuickFind()

    -- 1技能; 2按钮
    MainSkill._showIndex = 1
    MainSkill.ChangeShowIndex(MainSkill._showIndex, true)

    SL:AttachTXTSUI({root = ui["Panel_active"], index = SLDefine.SUIComponentTable.MainRootButton})

    MainSkill.RegisterEvent()
end

------------------------------------------------------------ 拾取相关 ----------------------------------------------------------------------
function MainSkill.InitPick()
    local Button_pick = MainSkill._ui["Button_pick"]
    GUI:setVisible(Button_pick, false)
    GUI:addOnClickEvent(Button_pick, function()
        if not SL:GetValue("BATTLE_IS_AUTO_PICK") then
            SL:SetValue("BATTLE_PICK_BEGIN")
        else
            SL:SetValue("BATTLE_PICK_END")
        end
    end)
end

function MainSkill.UpdatePickupVisible(visible)
    GUI:setVisible(MainSkill._ui["Button_pick"], visible)
end

-- 拾取按钮状态（高亮、变灰）
function MainSkill.UpdatePickState()
    GUI:Button_setBright(MainSkill._ui["Button_pick"], not SL:GetValue("BATTLE_IS_AUTO_PICK"))
end
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 切换按钮 ----------------------------------------------------------------------
function MainSkill.InitButton()
    -- 隐藏
    GUI:setVisible(MainSkill._Panel_skill, true)
    GUI:setVisible(MainSkill._Panel_active, false)

    local Panel_hide = MainSkill._ui["Panel_hide"]
    GUI:setVisible(Panel_hide, false)
    GUI:setSwallowTouches(Panel_hide, false)
    GUI:addOnClickEvent(Panel_hide, function()
        MainSkill.ChangeShowIndex(1)
    end)

    -- 切换
    GUI:addOnClickEvent(MainSkill._ui["Button_change"], function()
        SL:PlaySound(50005)
        MainSkill.ChangeShowIndex(3 - MainSkill._showIndex)
    end)

    -- 锁定
    local Button_Lock = MainSkill._ui["Button_Lock"]
    GUI:setVisible(Button_Lock, false)
    GUI:addOnClickEvent(Button_Lock, function()
        GUI:delayTouchEnabled(Button_Lock)
        MainSkill.ClickLockBtn()
    end)
end

function MainSkill.ClickLockBtn()
    if SL:GetValue("HERO_IS_ALIVE") then
        local selectID = MainSkill._selectID
        if selectID and selectID ~= -1 then
            local actorID = selectID
            if SL:GetValue("ACTOR_IS_VALID", actorID) and SL:GetValue("ACTOR_CAN_LOCK_BY_HERO", actorID) then
                local isPlayer = SL:GetValue("ACTOR_IS_PLAYER", actorID) and not SL:GetValue("ACTOR_IS_HERO", actorID)
                SL:RequestLockTargetByHero(actorID, isPlayer)
            end
        else
            SL:RequestCancelLockByHero()
        end
    end
end

-- 切换操作
function MainSkill.ChangeShowIndex(i, force)
    MainSkill._showIndex = i

    GUI:stopAllActions(MainSkill._Panel_skill)
    GUI:stopAllActions(MainSkill._Panel_active)

    GUI:setVisible(MainSkill._ui["Panel_hide"], i == 2)

    local Image_change_act = MainSkill._ui["Image_change_act"]

    local skillSize = GUI:getContentSize(MainSkill._Panel_skill)
    local skillPosY = GUI:getPositionY(MainSkill._Panel_skill)
    local activeSize = GUI:getContentSize(MainSkill._Panel_active)
    local activePosY = GUI:getPositionY(MainSkill._Panel_active)

    local acttime = (force and 0 or 0.2)
    if MainSkill._showIndex == 1 then
        local distance = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_SKILL_SHOW_DISTANCE) or 0
        GUI:runAction(Image_change_act, GUI:ActionRotateTo(acttime, 0))
        GUI:setVisible(MainSkill._Panel_skill, true)
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_skill, {x = -distance, y = skillPosY}, acttime)
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_active, {x = activeSize.width, y = activePosY}, acttime, function()
            GUI:setVisible(MainSkill._Panel_active, false)
            -- 109 按钮模块引导主ID
            SL:SetValue("GUIDE_EVENT_END", 109)
        end)
    else
        GUI:runAction(Image_change_act, GUI:ActionRotateTo(acttime, 90))
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_skill, {x = skillSize.width, y = skillPosY}, acttime, function()
            GUI:setVisible(MainSkill._Panel_skill, false)
        end)
        GUI:setVisible(MainSkill._Panel_active, true)
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_active, {x = 0, y = activePosY}, acttime, function()
            SL:SetValue("GUIDE_EVENT_BEGAN", 109, true)
        end)
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------- 技能 ------------------------------------------------------------------------
function MainSkill.InitSkill()
    MainSkill._nodeCells = {}

    for i = 1, 9 do
        local node = GUI:getChildByName(MainSkill._Panel_skill, string.format("Node_cell_%s", i))
        table.insert(MainSkill._nodeCells, node)
    end

    -- 强攻
    GUI:addOnTouchEvent(MainSkill._ui["Button_attack"], function (sender, eventType)
        if eventType == 2 or eventType == 3 then
            GUI:stopAllActions(sender)
        elseif eventType == 0 then
            SL:RequestForceAttack()
            GUI:stopAllActions(sender)
            SL:schedule(sender, function () SL:RequestForceAttack() end, 0.01)
        end
    end)
end

function MainSkill.OnAddSkill(data)
    local skillID = data.MagicID

    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    -- 已存在
    if MainSkill._skillCells[skillID] then
        SL:Print("MAIN SKILL ADD ERROR: EXIST SKILL. ID: " .. skillID)
        return false
    end

    MainSkill.AddSkill(data)
end

function MainSkill.OnDelSkill(data)
    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    -- 不存在
    if not MainSkill._skillCells[data.MagicID] then
        return false
    end

    MainSkill.RmvSkill(data, data.Key)
end

function MainSkill.OnSkillChangeKey(data)
    -- remove
    MainSkill.OnDelSkill(data.last)
    
    -- add
    MainSkill.OnAddSkill(data.skill)
end

function MainSkill.OnSkillDeleteKey(data)
    -- 没有快捷键
    if (not data.delKey) or (data.delKey == 0) then
        return false
    end

    -- 不存在
    if not MainSkill._skillCells[data.skill.MagicID] then
        return false
    end

    MainSkill.RmvSkill(data.skill, data.delKey)
end

function MainSkill.OnUpdateSkill(data)
    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    local skillID = data.MagicID

    -- 不存在
    local cell = MainSkill._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:Button_loadTextureNormal(cell["skill_icon"], SL:GetValue("SKILL_ICON_PATH", skillID))
end

function MainSkill.OnSkillOn(skillID)
    local cell = MainSkill._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_on"])

    MainSkill.CreateSelectSfx(cell["Node_on"], skillID)
end

function MainSkill.OnSkillOff(skillID)
    local cell = MainSkill._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_on"])
end

function MainSkill.OnSkillCDChange(data)
    local cell = MainSkill._skillCells[data.id]
    if not cell then
        return false
    end

    local progressCD = cell["progressCD"]
    if progressCD then
        local percent = data.percent
        GUI:setVisible(progressCD, percent ~= 0)
        GUI:ProgressTimer_setPercentage(progressCD, percent)
    end

    -- 倒计时
    local CDTime = cell["CDTime"]
    if CDTime then
        local time = data.percent ~= 0 and string.format("%.1f", data.time) or ""
        GUI:Text_setString(CDTime, time)
    end
end

function MainSkill.OnComboSkillCDChange()
    local skills = SL:GetValue("SET_COMBO_SKILLS")
    local state  = true

    for i = 1, #skills do
        local skillID = skills[i]
        if skillID and skillID ~= 0 then
            if SL:GetValue("SKILL_IS_CDING", skillID) then
                state = false
            end
        end
    end

    SL:SetValue("COMBO_SKILL_STATE", state)
    MainSkill.OnActiveComboSkill(state)
end

function MainSkill.AddSkill(data)
    local pCell = MainSkill._nodeCells[data.Key]
    if GUI:Win_IsNull(pCell) then
        return false
    end
    -- skill
    local cell = MainSkill.CreateSkillCell(data)
    MainSkill._skillCells[data.MagicID] = cell
    GUI:addChild(pCell, cell)
end

function MainSkill.RmvSkill(data, key)
    local skillID = data.MagicID

    if not skillID or not key then
        return false
    end

    GUI:removeAllChildren(MainSkill._nodeCells[key])

    MainSkill._skillCells[skillID] = nil

    -- cleanup select skill
    local selSkill = SL:GetValue("SELECT_SKILL")
    if selSkill and selSkill == skillID then
        SL:SetValue("SELECT_SKILL", nil)
    end
end

function MainSkill.OnClickSkillEvent(skillID)
    -- 是否是开关型技能
    if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) then
        SL:RequestOnOffSkill(skillID)
    elseif SL:GetValue("SKILL_IS_INPUT_POS_SKILL", skillID) then
        -- 当前选中技能
        local lastSkill = SL:GetValue("SELECT_SKILL")
        if lastSkill then
            local cell = MainSkill._skillCells[lastSkill]
            if cell then
                GUI:removeAllChildren(cell["Node_select"])
            end
            SL:SetValue("SELECT_SKILL", nil)
            if skillID == lastSkill then
                return false
            end
        end

        -- select
        SL:SetValue("SELECT_SKILL", skillID)

        local cell = MainSkill._skillCells[skillID]
        if cell then
            MainSkill.CreateSelectSfx(cell["Node_select"], skillID)
        end
    else
        -- 普通释放技能
        if skillID == 0 and MainSkill._comboSkillID then
            skillID = MainSkill._comboSkillID
            MainSkill._comboSkillID = nil
        end
        SL:OnLaunchSkill(skillID) 
    end
end

function MainSkill.CreateSkillCell(data)
    local ui = GUI:LoadExportEx2("main/skill/main_skill_cell", "skill_cell")
    GUI:ui_IterChilds(ui, ui)

    local skillID = data.MagicID

    local skill_icon = ui["skill_icon"]

    GUI:Button_loadTextureNormal(skill_icon, SL:GetValue("SKILL_ICON_PATH", skillID))
    GUI:setIgnoreContentAdaptWithSize(skill_icon, false)

    local btnSize = {width = 55, height = 55}

    if data.Key == 1 then
        GUI:Image_loadTexture(ui["Image_bg"], "res/private/main/Skill/1900012018.png")
        GUI:setIgnoreContentAdaptWithSize(ui["Image_bg"], true)
        btnSize = {width = 75, height = 75}
    end

    GUI:setContentSize(skill_icon, btnSize)

    -- 技能点击
    local n = 0
    local anchorPoint   = GUI:getAnchorPoint(skill_icon)
    local sizeButton    = GUI:getContentSize(skill_icon)
    local rectButton    = {}
    local isInSideButton = false
    GUI:addOnTouchEvent(skill_icon, function(sender, state)
        -- 开始
        if 0 == state then
            isInSideButton = true
            skill_icon._clicked = false
            local spacePos      = GUI:convertToWorldSpace(skill_icon, GUI:getPositionX(skill_icon), GUI:getPositionY(skill_icon))
            rectButton          = {
                x = spacePos.x - sizeButton.width * anchorPoint.x,
                y = spacePos.y - sizeButton.height * anchorPoint.y,
                width = sizeButton.width,
                height = sizeButton.height
            }
            -- 按下就有特效
            n = n + 1
            local size = GUI:getContentSize(skill_icon)
            local sfx = GUI:Effect_Create(skill_icon, "sfx".. n, size.width / 2, size.height / 2, 0, data.Key == 1 and 4002 or 4001)
            GUI:Effect_addOnCompleteEvent(sfx, function()
                GUI:removeFromParent(sfx)
            end)

            GUI:schedule(skill_icon, function()
                if not isInSideButton then
                    return false
                end

                if skill_icon._clicked then
                    return false
                end

                if SL:GetValue("USER_IS_DIE") then
                    return false
                end

                if SL:GetValue("ACTOR_IS_MOVE", SL:GetValue("USER_ID")) then
                    return false
                end

                -- 技能点击逻辑
                skill_icon._clicked = true
                MainSkill.OnClickSkillEvent(skillID)
                return true
            end, 0.1)
            return true
        -- 移动
        elseif 1 == state then
            isInSideButton = GUI:RectContainsPoint(rectButton, GUI:getTouchMovePosition(skill_icon))
            return true
        -- 结束
        elseif 2 == state then
            GUI:delayTouchEnabled(skill_icon, 0.1)
            GUI:unSchedule(skill_icon)
            if skill_icon._clicked then
                return
            end
            skill_icon._clicked = true
            MainSkill.OnClickSkillEvent(skillID)
        -- 取消
        elseif 3 == state then
            GUI:unSchedule(skill_icon)
        end
    end)

    -- CD
    local spriteCD = "res/private/main/Skill/bg_lsxljm_05.png"
    local p = GUI:getPosition(skill_icon)
    local progressCD = GUI:ProgressTimer_Create(ui, "progressCD", p.x, p.y, spriteCD, btnSize.width, btnSize.height)
    GUI:setAnchorPoint(progressCD, 0.5, 0.5)
    GUI:ProgressTimer_setReverseDirection(progressCD, true)
    ui.progressCD = progressCD

    local CDTime = GUI:Text_Create(ui, "CDTime", p.x, p.y, 12, "#FFFFFF", "")
    GUI:setAnchorPoint(CDTime, 0.5, 0.5)
    local show = tonumber(SL:GetValue("GAME_DATA", "ShowSkillCDTime")) == 1
    GUI:setVisible(CDTime, show)
    ui.CDTime = CDTime

    -- Effect
    if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) and SL:GetValue("SKILL_IS_ON_SKILL", skillID) then
        MainSkill.CreateSelectSfx(ui["Node_on"], skillID)
    end

    return ui
end

function MainSkill.CreateSelectSfx(parent, skillID)
    local sfx = GUI:Effect_Create(parent, "sfx", 0, 0, 0, 4005)
    GUI:Effect_setGlobalElapseEnable(sfx, true)

    local key = SL:GetValue("SKILL_DATA_BY_KEY", skillID)
    if key == 1 then
        GUI:setScale(sfx, 0.9)      -- 主技能特效缩放比例
    else
        GUI:setScale(sfx, 0.6)      -- 其他技能特效缩放比例
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 快速查找 ----------------------------------------------------------------------
local sharedQuickSelTab = {}
function MainSkill.InitQuickFind()
    local items = {
        [1] = {
            image      = MainSkill._ui["Image_player"],
            actorType  = 0,
            normalPath = "res/private/main/Skill/1900012706.png",
            brightPath = "res/private/main/Skill/1900012707.png"
        },
        [2] = {
            image      = MainSkill._ui["Image_monster"],
            actorType  = 50,
            normalPath = "res/private/main/Skill/1900012704.png",
            brightPath = "res/private/main/Skill/1900012705.png"
        },
        [3] = {
            image      = MainSkill._ui["Image_hero"],
            actorType  = 400,
            normalPath = "res/private/main/Skill/1900012710.png",
            brightPath = "res/private/main/Skill/1900012711.png"
        }
    }

    local isOpenHero = SL:GetValue("USEHERO") --英雄开关
    GUI:setVisible(MainSkill._ui["Image_hero"], isOpenHero)

    local function quickFind(index)
        local item  = items[index]
        local image = item.image
        GUI:Image_loadTexture(image, item.brightPath)

        GUI:runAction(image, GUI:ActionSequence(
            GUI:ActionScaleTo(0.1, 1.4), 
            GUI:ActionScaleTo(0.1, 1), 
            GUI:CallFunc(function () GUI:Image_loadTexture(image, item.normalPath) end)
        ))

        sharedQuickSelTab.type = item.actorType
        sharedQuickSelTab.imgNotice = true
        SL:QuickSelectTarget(sharedQuickSelTab)
    end

    local Panel_quick_find = MainSkill._ui["Panel_quick_find"]
    GUI:setSwallowTouches(Panel_quick_find, false)

    GUI:addOnTouchEvent(Panel_quick_find, function(sender, eventType)
        if not (eventType == 2 or eventType == 3) then
            return false
        end

        local beganPos = GUI:getTouchBeganPosition(sender)
        local endedPos = GUI:getTouchEndPosition(sender)

        local dis = SL:GetPointDistanceSQ(beganPos, endedPos)
        if dis < 500 or dis >= 40000 then
            return
        end

        if endedPos.x > beganPos.x then
            return quickFind(1)
        end

        if isOpenHero and endedPos.y > beganPos.y then
            return quickFind(3)
        end

        quickFind(2)
    end)
end
-------------------------------------------------------------------------------------------------------------------------------------------
-- 普攻挖矿
function MainSkill.UpdatePlayEquipChange()
    local skillData = SL:GetValue("SKILL_DATA_BY_KEY", 1)
    local skillCell = MainSkill._skillCells[0]
    if skillCell and skillData then
        GUI:Button_loadTextureNormal(skillCell["skill_icon"], SL:GetValue("SKILL_ICON_PATH", skillData.MagicID))
    end
end

function MainSkill.OnClearSelectSkill(skillID)
    if not skillID then
        return false
    end

    local cell = MainSkill._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_select"])
end
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 英雄技能 ----------------------------------------------------------------------
function MainSkill.OnHeroLogin()
    local jointSkill = SL:GetValue("HERO_JOINT_SKILL")
    if not jointSkill then
        return false
    end

    MainSkill.OnAddHeroSkill({MagicID = jointSkill})
end

function MainSkill.OnHeroLogout(data)
    MainSkill._jointSkillCell  = nil
    GUI:removeAllChildren(MainSkill._ui["Node_hj_skill"])
end

function MainSkill.JointHeroEffect(canuse)
    local cell = MainSkill._jointSkillCell
    if not cell then
        return false
    end

    GUI:setGrey(cell["skill_icon"], not canuse)
    GUI:setVisible(cell["Node_sfx"], canuse)
end

function MainSkill.OnAddHeroSkill(data)
    local isHeroSkill = SL:GetValue("IS_HERO_SKILL", data.MagicID)
    if not isHeroSkill then
        return false
    end

    if MainSkill._jointSkillCell then
        return false
    end

    -- skill
    local cell = MainSkill.CreateJointSkillCell(data)
    GUI:addChild(MainSkill._ui["Node_hj_skill"], cell)

    MainSkill._jointSkillCell = cell
end

function MainSkill.OnRefreshHeroLockIcon()
    local selectID = SL:GetValue("SELECT_TARGET_ID")
    local lockWay = 0 -- 不显示
    if selectID and SL:GetValue("HERO_IS_ALIVE") then
        if SL:GetValue("ACTOR_IS_VALID", selectID) and SL:GetValue("ACTOR_CAN_LOCK_BY_HERO", selectID) then
            if SL:GetValue("H.LOCK_TARGET_ID") == selectID then
                lockWay = 1 -- 显示锁定
            else
                lockWay = 2 -- 显示未锁定
            end
        end
    end

    if lockWay == 0 then
        GUI:setVisible(MainSkill._ui.Button_Lock, false)
        GUI:removeAllChildren(MainSkill._ui.Button_Lock)
        MainSkill._selectID = nil
    elseif lockWay == 1 then
        GUI:setVisible(MainSkill._ui.Button_Lock, true)
        GUI:Button_loadTextureNormal(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05.png")
        GUI:Button_loadTexturePressed(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05.png")
        if not GUI:getChildByName(MainSkill._ui.Button_Lock, "lockAnim") then
            GUI:removeAllChildren(MainSkill._ui.Button_Lock)
            GUI:Effect_Create(MainSkill._ui.Button_Lock, "lockAnim", 7, 45, 0, 7223)
        end
        MainSkill._selectID = -1
    elseif lockWay == 2 then
        GUI:setVisible(MainSkill._ui.Button_Lock, true)
        GUI:Button_loadTextureNormal(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05_1.png")
        GUI:Button_loadTexturePressed(MainSkill._ui.Button_Lock, "res/private/player_hero/btn_heji_05_1.png")
        GUI:removeAllChildren(MainSkill._ui.Button_Lock)
        MainSkill._selectID = selectID
    end
end

-- 创建合击技能cell
function MainSkill.CreateJointSkillCell(data)
    local ui = GUI:LoadExportEx2("main/skill/hero_skill_cell", "skill_cell")
    GUI:ui_IterChilds(ui, ui)

    local skill_icon = ui["skill_icon"]

    -- 图标
    GUI:Button_loadTextureNormal(skill_icon, SL:GetValue("H.SKILL_ICON_PATH", data.MagicID))

    -- 层级
    GUI:setLocalZOrder(skill_icon, 1)

    -- 置灰
    GUI:setGrey(skill_icon, true)

    -- event
    GUI:addOnClickEvent(skill_icon, function()
        GUI:delayTouchEnabled(skill_icon)
        SL:RequestMagicJointAttack()
    end)

    -- 合击特效
    GUI:Effect_Create(ui["Node_sfx"], "sfx", -48, 38, 0, 7222)

    return ui
end
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 连击技能 ----------------------------------------------------------------------
function MainSkill.CreateComboSkillCell(data)
    local ui = GUI:LoadExportEx2("main/skill/combo_skill_cell", "skill_cell")
    GUI:ui_IterChilds(ui, ui)

    local skill_icon = ui["skill_icon"]

    -- 图标
    GUI:Button_loadTextureNormal(skill_icon, SL:GetValue("SKILL_ICON_PATH", data.MagicID, true))

    -- 层级
    GUI:setLocalZOrder(skill_icon, 1)

    -- event
    GUI:addOnClickEvent(skill_icon, function()
        MainSkill.OnClickComboSkillEvent(data.MagicID)
    end)

    -- 特效
    GUI:Effect_Create(ui["Node_sfx"], "sfx", 3, 50, 0, 7230)

    GUI:setVisible(ui, true)

    return ui
end

function MainSkill.OnClickComboSkillEvent(skillID)
    if not (skillID and skillID ~= 0) then
        return false
    end

    -- 开关型技能
    if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) then
        SL:RequestOnOffSkill(skillID)
        MainSkill._comboSkillID = skillID
        return
    end

    -- 普通释放技能
    SL:OnLaunchSkill(skillID) 
end

function MainSkill.OnRefreshComboSkillShow()
    if not MainSkill._NGOpen then
        return false
    end

    GUI:removeAllChildren(MainSkill._ui.Node_combo_skill)

    local selectSkills = SL:GetValue("SET_COMBO_SKILLS")
    MainSkill._comboSkillCell = nil

    if selectSkills[1] then
        local skillID = selectSkills[1]
        if skillID and skillID ~= 0 then
            local data = SL:GetValue("COMBO_SKILL_DATA", skillID)
            if data then
                MainSkill._comboSkillCell = MainSkill.CreateComboSkillCell(data)
                GUI:addChild(MainSkill._ui["Node_combo_skill"], MainSkill._comboSkillCell)
            end
        end
    end
end

function MainSkill.OnActiveComboSkill(state)
    if not MainSkill._NGOpen then
        return false
    end

    local cell = MainSkill._comboSkillCell
    if not cell then
        return false
    end

    GUI:setGrey(cell["skill_icon"], not state)
    GUI:setTouchEnabled(cell["skill_icon"], state)
    GUI:setVisible(cell["Node_sfx"], state)
end

-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------- 内功 ------------------------------------------------------------------------
function MainSkill.OnRefreshNGShow()
    MainSkill._NGOpen = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")
    MainSkill.OnRefreshComboSkillShow()
end

function MainSkill.OnSkillButton_Distance_Change()
    local SETTING_VALUE = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_SKILL_SHOW_DISTANCE)
    local distance = SETTING_VALUE and SETTING_VALUE[1] or 0
    GUI:setPositionX(MainSkill._ui.Panel_skill, -distance)
end

-- 引导进入时切换
function MainSkill.OnGuideEnterTransition(data)
    if data.extent then
        MainSkill.ChangeShowIndex(MainSkill._showIndex == 1 and 2 or 1)
    else
        if data.name == "GUIDE_BEGIN_SKILL_BUTTON" then
            MainSkill.ChangeShowIndex(2)
        elseif data.name == "GUIDE_BEGIN_SKILL_CHANGE_BUTTON" then
            MainSkill.ChangeShowIndex(1)
        end
    end
end

function MainSkill.RegisterEvent( )
    -- 脚本命令（AutoPickItemByBtn、StopAutoPickItemByBtn）触发
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PICKUP_SHOW, "MainSkill", MainSkill.UpdatePickupVisible)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKBEGIN, "MainSkill", MainSkill.UpdatePickState)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKEND, "MainSkill", MainSkill.UpdatePickState)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "MainSkill", MainSkill.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "MainSkill", MainSkill.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainSkill", MainSkill.OnDelSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, "MainSkill", MainSkill.OnUpdateSkill)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ON, "MainSkill", MainSkill.OnSkillOn)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_OFF, "MainSkill", MainSkill.OnSkillOff)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "MainSkill", MainSkill.OnSkillChangeKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "MainSkill", MainSkill.OnSkillDeleteKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CD_CHANGE, "MainSkill", MainSkill.OnSkillCDChange)
    SL:RegisterLUAEvent(LUA_EVENT_COMBO_SKILL_CD_CHANGE, "MainSkill", MainSkill.OnComboSkillCDChange)
    

    SL:RegisterLUAEvent(LUA_EVENT_CLEAR_SELECT_SKILL, "MainSkill", MainSkill.OnClearSelectSkill)

    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_INIT, "MainSkill", MainSkill.UpdatePlayEquipChange)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MainSkill", MainSkill.UpdatePlayEquipChange)

    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_ADD, "MainSkill", MainSkill.OnAddHeroSkill)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGIN, "MainSkill", MainSkill.OnHeroLogin)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT, "MainSkill", MainSkill.OnHeroLogout)

    -- 英雄锁定刷新
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOCK_CHANGE, "MainSkill", MainSkill.OnRefreshHeroLockIcon)
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CHANGE, "MainSkill", MainSkill.OnRefreshHeroLockIcon)

    SL:RegisterLUAEvent(LUA_EVENT_GUIDE_ENTER_TRANSITION, "MainSkill", MainSkill.OnGuideEnterTransition)

    -- 技能边距调整
    SL:RegisterLUAEvent(LUA_EVENT_SKILLBUTTON_DISTANCE_CHANGE, "MainSkill", MainSkill.OnSkillButton_Distance_Change)
    -- 设置连击技能刷新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SET_COMBO_REFRESH, "MainSkill", MainSkill.OnRefreshComboSkillShow)
    -- 连击技能CD状态
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILLCD_STATE, "MainSkill", MainSkill.OnActiveComboSkill)
    -- 学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MainSkill", MainSkill.OnRefreshNGShow)
end

MainSkill.main()