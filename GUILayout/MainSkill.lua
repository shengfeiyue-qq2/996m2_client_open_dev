MainSkill = {}

-- 技能特效 press:按下 select:选择/开启
MainSkill.SkillSfxs =  {
    press     = 4001,
    select    = 4005,
    mainPress = 4002
}

-- 是否显示CD倒计时
MainSkill.IsShowCDNum = false

function MainSkill.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/skill/skill")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    MainSkill._ui = ui

    GUI:setPositionY(parent, 25)

    GUI:setContentSize(ui["Panel_hide"], SL:GetScreenWidth(), SL:GetScreenHeight())

    MainSkill._Panel_skill  = ui["Panel_skill"]
    MainSkill._Panel_active = ui["Panel_active"]

    MainSkill._nodeCells  = {}
    MainSkill._skillCells = {}
    MainSkill._jointSkillCell = nil

    MainSkill.InitPick()
    MainSkill.InitButton()
    MainSkill.InitSkill()
    MainSkill.InitQuickFind()

    -- 1技能; 2按钮
    MainSkill._showIndex = 1
    MainSkill.ChangeShowIndex(MainSkill._showIndex, true)

    MainSkill.RegisterEvent()
end

-- 事件监听注册
function MainSkill.RegisterEvent()
    -- 脚本命令（AutoPickItemByBtn、StopAutoPickItemByBtn）触发
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PICKUP_SHOW, "MainSkill", MainSkill.UpdatePickupVisible)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKBEGIN, "MainSkill", MainSkill.UpdatePickState)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKEND, "MainSkill", MainSkill.UpdatePickState)

    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_INIT, "MainSkill", MainSkill.UpdatePlayEquipChange)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "MainSkill", MainSkill.UpdatePlayEquipChange)

    SL:RegisterLUAEvent(LUA_EVENT_CLEAR_SELECT_SKILL, "MainSkill", MainSkill.OnClearSelectSkill)
    
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "MainSkill", MainSkill.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "MainSkill", MainSkill.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainSkill", MainSkill.OnDelSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, "MainSkill", MainSkill.OnUpdateSkill)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ON, "MainSkill", MainSkill.OnSkillOn)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_OFF, "MainSkill", MainSkill.OnSkillOff)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "MainSkill", MainSkill.OnSkillChangeKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "MainSkill", MainSkill.OnSkillDeleteKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CD_CHNAGE, "MainSkill", MainSkill.OnSkillCDChange)
    
    SL:RegisterLUAEvent(LUA_EVENT_ADD_HERO_SKILL, "MainSkill", MainSkill.OnAddHeroSkill)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGIN, "MainSkill", MainSkill.OnHeroLogin)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT, "MainSkill", MainSkill.OnHeroLogout)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_JOINT_EFFECT, "MainSkill", MainSkill.OnHeroJointEffect)
end

-- 普攻挖矿
function MainSkill.UpdatePlayEquipChange()
    local skillData = SL:GetSkillByKey(1)
    local skillCell = MainSkill._skillCells[0]
    if skillCell and skillData then
        GUI:Button_loadTextureNormal(skillCell["skill_icon"], SL:GetSkillCirclePicPath(skillData.MagicID))
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

    GUI:removeAllChildren(cell["nodeSelect"])
end

-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 英雄技能 ----------------------------------------------------------------------
function MainSkill.OnHeroLogin()
    local jointSkill = SL:GetHeroJointSkill()
    if not jointSkill then
        return false
    end

    MainSkill.OnAddHeroSkill({MagicID = jointSkill})
end

function MainSkill.OnHeroLogout(data)
    MainSkill._jointSkillCell  = nil
    GUI:removeAllChildren(MainSkill._ui["_Node_hj_skill"])
end

function MainSkill.OnHeroJointEffect(canuse)
    local cell = MainSkill._jointSkillCell
    if not cell then
        return false
    end

    GUI:setGrey(cell["skill_icon"], not canuse)
    GUI:setVisible(cell["Node_sfx"], canuse)
end

function MainSkill.OnAddHeroSkill(data)
    local isHeroSkill = SL:IsHeroSkill(data.MagicID)
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

-- 创建合击技能cell
function MainSkill.CreateJointSkillCell(data)
    local ui = GUI:LoadExportEx("main/skill/skill_hero_cell", "skill_cell")
    GUI:ui_IterChilds(ui, ui)

    local skill_icon = ui["skill_icon"]

    -- 图标
    GUI:Button_loadTextureNormal(skill_icon, SL:GetHeroSkillCirclePicPath(data.MagicID))

    -- 层级
    GUI:setLocalZOrder(skill_icon, 1)

    -- 置灰
    GUI:setGrey(skill_icon, true)

    -- event
    GUI:addOnClickEvent(skill_icon, function ()
        local jointSkill = SL:GetHeroJointSkill()
        if jointSkill then
            SL:ReqJointAttack()
        else
            return ShowSystemTips("当前没有合击英雄技能")
        end
    end)

    -- 合击特效
    GUI:Effect_Create(ui["Node_sfx"], "sfx", -48, 38, 0, 7222)

    return ui
end

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------- 技能 ------------------------------------------------------------------------

function MainSkill.OnAddSkill(data)
    local skillID = data.MagicID

    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    -- 已存在
    if MainSkill._skillCells[skillID] then
        print("MAIN SKILL ADD ERROR: EXIST SKILL. ID: " .. skillID)
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

    GUI:Button_loadTextureNormal(cell["skill_icon"], SL:GetSkillCirclePicPath(skillID))
end

function MainSkill.OnSkillOn(skillID)
    local cell = MainSkill._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_on"])

    MainSkill.CtreateSelecetSfx(cell["Node_on"], skillID)
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

    local percent = data.percent

    GUI:setVisible(progressCD, percent ~= 0)
    GUI:ProgressTimer_setPercentage(progressCD, percent)

    -- 倒计时
    if MainSkill.IsShowCDNum then
        local Text_cd = cell["Text_cd"]

        local time = data.time or 0
        GUI:setVisible(Text_cd, time ~= 0)
        GUI:Text_setString(Text_cd, string.format("%.1f", time))
    end
end

function MainSkill.AddSkill(data)
    -- skill
    local cell = MainSkill.CreateSkillCell(data)
    MainSkill._skillCells[data.MagicID] = cell

    GUI:addChild(MainSkill._nodeCells[data.Key], cell)
end

function MainSkill.RmvSkill(data, key)
    local skillID = data.MagicID

    if not skillID or not key then
        return false
    end

    GUI:removeAllChildren(MainSkill._nodeCells[key])

    MainSkill._skillCells[skillID] = nil

    -- cleanup select skill
    local selSkill = SL:GetSelectSkill()
    if selSkill and selSkill == skillID then
        SL:SelectSkill(nil)
    end
end

function MainSkill.OnClickSkillEvent(skillID)
    -- 是否是开关型技能
    if SL:GetMetaValue("SKILL_IS_ONOFF_SKILL", skillID) then
        SL:SetSkillSwitch(skillID)
    elseif SL:GetMetaValue("SKILL_IS_INPUT_POS_SKILL", skillID) then
        -- 当前选中技能
        local lastSkill = SL:GetSelectSkill()
        if lastSkill then
            local cell = MainSkill._skillCells[lastSkill]
            if cell then
                GUI:removeAllChildren(cell["Node_select"])
            end
            SL:SelectSkill(nil)

            if skillID == lastSkill then
                return false
            end
        end

        -- 十步一杀在cd状态中, 不能进行选中
        if skillID == 82 and SL:GetMetaValue("SKILL_IS_IN_CD", skillID) then
            return false
        end

        -- select
        SL:SelectSkill(skillID)

        local cell = MainSkill._skillCells[skillID]
        if cell then
            MainSkill.CtreateSelecetSfx(cell["Node_select"], skillID)
        end
    else
        -- 普通释放技能
        SL:OnLaunchSkill(skillID) 
    end
end

function MainSkill.CreateSkillCell(data)
    local ui = GUI:LoadExportEx("main/skill/skill_cell", "skill_cell")
    GUI:ui_IterChilds(ui, ui)

    local skillID = data.MagicID

    local skill_icon = ui["skill_icon"]

    GUI:Button_loadTextureNormal(skill_icon, SL:GetSkillCirclePicPath(skillID))
    GUI:setIgnoreContentAdaptWithSize(skill_icon, false)

    local btnSize = {width = 45, height = 45}

    if data.Key == 1 then
        GUI:Image_loadTexture(ui["Image_bg"], "res/private/main/Skill/1900012018.png")
        GUI:setIgnoreContentAdaptWithSize(ui["Image_bg"], true)
        btnSize = {width = 75, height = 75}
    end

    GUI:setContentSize(skill_icon, btnSize)

    -- 技能点击
    GUI:addOnClickEvent(skill_icon, function ()
        -- 按下就有特效
        local sfx = GUI:getChildByName(skill_icon, "sfx")
        if not sfx then
            local pressSfx = MainSkill.SkillSfxs.press
            local key1Sfx  = MainSkill.SkillSfxs.mainPress
            local sfxID    = data.Key == 1 and key1Sfx or pressSfx
            local sfx      = GUI:Effect_Create(skill_icon, "sfx", btnSize.width / 2, btnSize.height / 2, 0, sfxID)

            GUI:Effect_addOnCompleteEvent(sfx, function ()
                GUI:removeFromParent(sfx)
            end)
        end

        -- 点击
        MainSkill.OnClickSkillEvent(skillID)
    end)

    -- CD
    local spriteCD = "res/private/main/Skill/bg_lsxljm_05.png"
    local p = GUI:getPosition(skill_icon)
    local progressCD = GUI:ProgressTimer_Create(ui, "progressCD", p.x, p.y, spriteCD, btnSize.width, btnSize.height)
    GUI:setAnchorPoint(progressCD, 0.5, 0.5)
    GUI:ProgressTimer_setReverseDirection(progressCD, true)
    ui.progressCD = progressCD

    GUI:setLocalZOrder(ui["Text_cd"], 99)

    -- Effect
    if SL:GetMetaValue("SKILL_IS_ONOFF_SKILL", skillID) and SL:GetMetaValue("SKILL_IS_ON_SKILL", skillID) then
        MainSkill.CtreateSelecetSfx(ui["Node_on"], skillID)
    end

    return ui
end

function MainSkill.CtreateSelecetSfx(parent, skillID)
    local sfx = GUI:Effect_Create(parent, "sfx", 0, 0, 0, MainSkill.SkillSfxs.select)
    GUI:Effect_setGlobalElapseEnable(sfx, true)

    local key = SL:GetSkillKey(skillID)
    if key == 1 then
        GUI:setScale(sfx, 0.9)      -- 主技能特效缩放比例
    else
        GUI:setScale(sfx, 0.6)      -- 其他技能特效缩放比例
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 拾取相关 ----------------------------------------------------------------------
-- 初始化拾取按钮
function MainSkill.InitPick()
    local Button_pick = MainSkill._ui["Button_pick"]
    GUI:setVisible(Button_pick, false)

    GUI:addOnClickEvent(Button_pick, function ()
        if SL:IsAutoPick() then
            SL:AutoPickEnd()
        else
            SL:AutoPickBegin()
        end
    end)
end

-- 拾取按钮是否显示
function MainSkill.UpdatePickupVisible(visible)
    GUI:setVisible(MainSkill._ui["Button_pick"], visible)
end

-- 拾取按钮状态（高亮、变灰）
function MainSkill.UpdatePickState()
    local state = not SL:IsAutoPick()
    GUI:Button_setBright(MainSkill._ui["Button_pick"], state)
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

    GUI:addOnTouchEvent(Panel_hide, function (_, eventType)
        if eventType ~= 0 then
            return false
        end
        MainSkill.ChangeShowIndex(1)
    end)

    -- 切换
    GUI:addOnClickEvent(MainSkill._ui["Button_change"], function()
        SL:PlayAudio(50005, GUIShare.SND_TYPE_UI)
        MainSkill.ChangeShowIndex(3 - MainSkill._showIndex)
    end)
end

-- 切换操作
function MainSkill.ChangeShowIndex(index, force)
    MainSkill._showIndex = index

    GUI:stopAllActions(MainSkill._Panel_skill)
    GUI:stopAllActions(MainSkill._Panel_active)
    GUI:setVisible(MainSkill._ui["Panel_hide"], index == 2)

    local skillSize  = GUI:getContentSize(MainSkill._Panel_skill)
    local activeSize = GUI:getContentSize(MainSkill._Panel_active)

    local time = force and 0 or 0.2
    if index == 1 then
        GUI:Timeline_RotateTo(MainSkill._ui["Image_change_act"], 0, time)

        GUI:setVisible(MainSkill._Panel_skill, true)
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_skill, {x = 0, y = 0}, time)

        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_active, {x = activeSize.width, y = activeSize.height}, time, function ()
            GUI:ActionHide()
        end)
    else
        GUI:Timeline_RotateTo(MainSkill._ui["Image_change_act"], 90, time)

        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_skill, {x = skillSize.width, y = 0}, time, function ()
            GUI:ActionHide()
        end)

        GUI:setVisible(MainSkill._Panel_active, true)
        GUI:Timeline_EaseSineIn_MoveTo(MainSkill._Panel_active, {x = 0, y = activeSize.height}, time, function ()
            SL:OnUpdateGuide()
        end)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------- 技能 ------------------------------------------------------------------------
function MainSkill.InitSkill()
    MainSkill._nodeCells = {}

    for i = 1, 9 do
        local node = GUI:getChildByName(MainSkill._Panel_skill, string.format("Node_skill_%s", i))
        table.insert(MainSkill._nodeCells, node)
    end

    -- 强攻
    GUI:addOnTouchEvent(MainSkill._ui["Button_attack"], function (sender, eventType)
        if eventType == 2 or eventType == 3 then
            GUI:stopAllActions(sender)
        elseif eventType == 0 then
            SL:OnLaunchAttackSkill()
            GUI:stopAllActions(sender)
            SL:schedule(sender, function () SL:OnLaunchAttackSkill() end, 0.01)
        end
    end)
end

-------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ 快速查找 ----------------------------------------------------------------------
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

    -- 是否开启英雄
    local isOpenHero = SL:GetMetaValue("USEHERO")
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

        -- 快速选择目标
        SL:OnQuickSelectTarget({type = item.actorType, imgNotice = true})
    end

    local Panel_quick_find = MainSkill._ui["Panel_quick_find"]
    GUI:setSwallowTouches(Panel_quick_find, false)

    GUI:addOnTouchEvent(Panel_quick_find, function (sender, eventType)
        if not (eventType == 2 or eventType == 3) then
            return false
        end

        local beganPos = GUI:getTouchBeganPosition(sender)
        local endedPos = GUI:getTouchEndPosition(sender)

        local dis = cc.pLengthSQ(cc.pSub(beganPos, endedPos))
        if dis < 500 or dis >= 40000 then
            return false
        end

        if endedPos.x > beganPos.x then
            return quickFind(1)
        end

        if isOpenHero and endedPos.x > beganPos.x then
            return quickFind(3)
        end

        quickFind(2)
    end)
end