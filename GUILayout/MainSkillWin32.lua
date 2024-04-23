MainSkillWin32 = {}

local SKILL_NUM = 8

MainSkillWin32.skillSfx =  {     -- 技能特效 press:按下 select:选择/开启
    press  = 4001,
    select = 4005
}

function MainSkillWin32.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/skill_win32/skill")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    MainSkillWin32._ui = ui
    
    MainSkillWin32._skillCells = {}

    GUI:addOnClickEvent(ui["Button_arr"], MainSkillWin32.OnButtonArr)
    MainSkillWin32.InitContainer()
    MainSkillWin32.RegisterEvent()

    -- 坐标调成整数
    GUI:RefPosByParent(parent)
end

-- 事件监听注册
function MainSkillWin32.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLEAR_SELECT_SKILL, "MainSkillWin32", MainSkillWin32.OnClearSelectSkill)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "MainSkillWin32", MainSkillWin32.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "MainSkillWin32", MainSkillWin32.OnAddSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainSkillWin32", MainSkillWin32.OnDelSkill)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, "MainSkillWin32", MainSkillWin32.OnUpdateSkill)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ON, "MainSkillWin32", MainSkillWin32.OnSkillOn)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_OFF, "MainSkillWin32", MainSkillWin32.OnSkillOff)

    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "MainSkillWin32", MainSkillWin32.OnSkillChangeKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "MainSkillWin32", MainSkillWin32.OnSkillDeleteKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CD_CHNAGE, "MainSkillWin32", MainSkillWin32.OnSkillCDChange)
end

function MainSkillWin32.InitContainer()
    for key = 1, SKILL_NUM do
        local skillCell = MainSkillWin32.CreateSkillCell()
        GUI:setName(skillCell, key)
        GUI:addChild(MainSkillWin32._ui["ListView_skill"], skillCell)
        GUI:setIgnoreContentAdaptWithSize(skillCell["skill_icon"], false)
        GUI:Image_loadTexture(skillCell["Image_key"], string.format("res/private/main-win32/word/key_F%s.png", key))
    end
    GUI:UserUILayout(MainSkillWin32._ui["ListView_skill"])
end

function MainSkillWin32.OnButtonArr(sender)
    local rotate = GUI:getRotation(sender)
    if rotate == 0 then
        GUI:setVisible(MainSkillWin32._ui["ListView_skill"], false)
        GUI:setRotation(sender, 180)
    else
        GUI:setVisible(MainSkillWin32._ui["ListView_skill"], true)
        GUI:setRotation(sender, 0)
        GUI:UserUILayout(MainSkillWin32._ui["ListView_skill"], {interval = 0.01})
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------- 技能 ------------------------------------------------------------------------
function MainSkillWin32.OnAddSkill(data)
    local skillID = data.MagicID

    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    -- 已存在
    if MainSkillWin32._skillCells[skillID] then
        print("MAIN SKILL ADD ERROR: EXIST SKILL. ID: " .. skillID)
        return false
    end

    MainSkillWin32.UpdateSkillCell(data)
end

function MainSkillWin32.OnDelSkill(data)
    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    -- 不存在
    if not MainSkillWin32._skillCells[data.MagicID] then
        return false
    end

    MainSkillWin32.RmvSkill(data, data.Key)
end

function MainSkillWin32.OnSkillChangeKey(data)
    -- remove
    MainSkillWin32.OnDelSkill(data.last)
    
    -- add
    MainSkillWin32.OnAddSkill(data.skill)
end

function MainSkillWin32.OnUpdateSkill(data)
    -- 没有快捷键
    if (not data.Key) or (data.Key == 0) then
        return false
    end

    local skillID = data.MagicID

    -- 不存在
    local cell = MainSkillWin32._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:Button_loadTextureNormal(cell["skill_icon"], SL:GetSkillPicPath(skillID))
end

function MainSkillWin32.OnSkillChangeKey(data)
    -- remove
    MainSkillWin32.OnDelSkill(data.last)
    
    -- add
    MainSkillWin32.OnAddSkill(data.skill)
end

function MainSkillWin32.OnSkillDeleteKey(data)
    -- 没有快捷键
    if (not data.delKey) or (data.delKey == 0) then
        return false
    end

    -- 不存在
    if not MainSkillWin32._skillCells[data.skill.MagicID] then
        return false
    end

    MainSkillWin32.RmvSkill(data.skill, data.delKey)
end

function MainSkillWin32.OnSkillCDChange(data)
    local cell = MainSkillWin32._skillCells[data.id]
    if not cell then
        return false
    end

    local progressCD = cell["progressCD"]

    local percent = data.percent

    GUI:setVisible(progressCD, percent ~= 0)
    GUI:ProgressTimer_setPercentage(progressCD, percent)

    -- 倒计时
    local Text_cd = cell["Text_cd"]

    local time = data.time or 0
    GUI:setVisible(Text_cd, time ~= 0)
    GUI:Text_setString(Text_cd, string.format("%.1f", time))
end

function MainSkillWin32.OnClearSelectSkill(skillID)
    if not skillID then
        return false
    end

    local cell = MainSkillWin32._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_tx"])
end

function MainSkillWin32.OnSkillOn(skillID)
    local cell = MainSkillWin32._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_tx"])

    MainSkillWin32.CtreateSelecetSfx(cell["Node_tx"], skillID)
end

function MainSkillWin32.OnSkillOff(skillID)
    local cell = MainSkillWin32._skillCells[skillID]
    if not cell then
        return false
    end

    GUI:removeAllChildren(cell["Node_tx"])
end

function MainSkillWin32.RmvSkill(data, key)
    local skillID = data.MagicID

    if not skillID or not key then
        return false
    end

    -- cleanup select skill
    local selSkill = SL:GetSelectSkill()
    if selSkill and selSkill == skillID then
        SL:SelectSkill(nil)
    end

    local cell = MainSkillWin32._skillCells[skillID]
    if cell then
        GUI:setVisible(cell["skill_icon"], false)
        GUI:setVisible(cell["progressCD"], false)
        GUI:setVisible(cell["Text_cd"], false)
        GUI:removeAllChildren(cell["Node_tx"])
    end

    MainSkillWin32._skillCells[skillID] = nil
end

function MainSkillWin32.OnClickSkillEvent(skillID)
    -- 是否是开关型技能
    if SL:GetMetaValue("SKILL_IS_ONOFF_SKILL", skillID) then
        SL:SetSkillSwitch(skillID)
    elseif SL:GetMetaValue("SKILL_IS_INPUT_POS_SKILL", skillID) then
        -- 当前选中技能
        local lastSkill = SL:GetSelectSkill()
        if lastSkill then
            local cell = MainSkillWin32._skillCells[lastSkill]
            if cell then
                GUI:removeAllChildren(cell["Node_tx"])
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

        local cell = MainSkillWin32._skillCells[skillID]
        if cell then
            MainSkillWin32.CtreateSelecetSfx(cell["Node_tx"], skillID)
        end
    else
        -- 普通释放技能
        SL:OnLaunchSkill(skillID) 
    end
end

function MainSkillWin32.UpdateSkillCell(data)
    local key, skillID = data.Key, data.MagicID
    if not key then
        return false
    end

    local cell = MainSkillWin32._ui[key]
    if not cell then
        return false
    end

    MainSkillWin32._skillCells[skillID] = cell

    local btnIcon = cell["skill_icon"]

    GUI:Button_loadTextureNormal(btnIcon, SL:GetSkillPicPath(skillID))
    GUI:setVisible(btnIcon, true)

    GUI:setTag(btnIcon, skillID)

    local onEnterFunc = function ()
        local isInside = GUI:getVisible(btnIcon) and GUI:getVisible(MainSkillWin32._ui["ListView_skill"])
        if not isInside then
            return false
        end

        local skillID = GUI:getTag(btnIcon)
        local config  = SL:GetMetaValue("SKILL_CONFIG", skillID)
        local worPos  = GUI:getWorldPosition(btnIcon)
        GUI:SetWorldTips(config.desc or "", worPos, {x = 1, y = 0})
    end

    local onLeaveFunc = function ()
        GUI:DelWorldTips()
    end

    -- 鼠标移入移出
    GUI:addMouseMoveEvent(btnIcon, {onEnterFunc = onEnterFunc, onLeaveFunc = onLeaveFunc})

    -- 技能点击
    GUI:addOnClickEvent(btnIcon, function ()
        -- 按下就有特效
        local sfx = GUI:getChildByName(btnIcon, "sfx")
        if not sfx then
            local btnSize = GUI:getContentSize(btnIcon)
            sfx = GUI:Effect_Create(btnIcon, "sfx", btnSize.width / 2, btnSize.height / 2, 0, MainSkillWin32.skillSfx.press)
            
            GUI:Effect_addOnCompleteEvent(sfx, function ()
                GUI:removeFromParent(sfx)
            end)
        end

        -- 点击
        MainSkillWin32.OnClickSkillEvent(skillID)
    end)

    -- Effect
    if SL:GetMetaValue("SKILL_IS_ONOFF_SKILL", skillID) and SL:GetMetaValue("SKILL_IS_ON_SKILL", skillID) then
        MainSkillWin32.CtreateSelecetSfx(cell["Node_tx"], skillID)
    end
end

function MainSkillWin32.CtreateSelecetSfx(parent, skillID)
    local sfx = GUI:Effect_Create(parent, "sfx", 0, 0, 0, MainSkillWin32.skillSfx.select)
    GUI:Effect_setGlobalElapseEnable(sfx, true)
    GUI:setScale(sfx, 0.5)
end

function MainSkillWin32.CreateSkillCell()
    -- CD
    local createProgressCD = function (ui)
        local progressCD = GUI:ProgressTimer_Create(ui, "progressCD", 22.5, 22.5, "res/private/main/Skill/bg_lsxljm_05.png")
        GUI:setAnchorPoint(progressCD, 0.5, 0.5)
        GUI:setOpacity(progressCD, 150)
        GUI:setScale(progressCD, 0.6)
        GUI:ProgressTimer_setReverseDirection(progressCD, true)
    end

    local ui = GUI:LoadExportEx("main/skill_win32/skill_cell", "skill_cell")
    createProgressCD(ui)
    GUI:ui_IterChilds(ui, ui)

    return ui
end