SkillSetting = {}

-- 普功 ID
local BASIC_SKILL_ID = 0

local MinKey = 1
local MaxKey = 9

-- 当前选中的左侧技能 ID
SkillSetting._selSkillID = nil

-- 右侧技能槽位 cell
SkillSetting._slotCells  = {}

-- 左侧技能列表 cell
SkillSetting._skillCells = {}

function SkillSetting.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.SkillSettingGUI, 0, 0, 0, 0, false, false, true, true)

    GUI:LoadExport(parent, "skill_setting/skill_setting")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    SkillSetting._ui = ui
    SkillSetting._parent = parent

    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(SkillSetting._ui["CloseLayout"], winSizeW, winSizeH)
    GUI:setPosition(SkillSetting._ui["FrameLayout"], winSizeW / 2, winSizeH / 2)

    GUI:Text_setString(SkillSetting._ui["TitleText"], "技能设置")

    GUI:Win_SetCloseCB(parent, SkillSetting.OnClose)

    -- 注册事件
    SkillSetting.RegistEvent()

    SkillSetting.InitEvent()

    SkillSetting.InitSkillSlot()

    SkillSetting.UpdateSkillList()

    SkillSetting.ClearSelectState()
end

function SkillSetting.OnClose()
    SkillSetting.UnRegisterEvent()
end

-- 注册事件
function SkillSetting.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD,  "SkillSetting", SkillSetting.UpdateSkillList)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL,  "SkillSetting", SkillSetting.UpdateSkillList)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "SkillSetting", SkillSetting.UpdateSkillList)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "SkillSetting", SkillSetting.UpdateSkillDeleteKey)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "SkillSetting", SkillSetting.UpdateSkillChangeKey)
end

-- 取消事件
function SkillSetting.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_ADD,  "SkillSetting")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_DEL,  "SkillSetting")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_INIT, "SkillSetting")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "SkillSetting")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "SkillSetting")
end

function SkillSetting.InitEvent()
    -- 全屏关闭
    GUI:setVisible(SkillSetting._ui["CloseLayout"], true)
    GUI:addOnClickEvent(SkillSetting._ui["CloseLayout"], function ()
        GUI:Win_Close(SkillSetting._parent)
    end)

    -- 关闭按钮
    GUI:addOnClickEvent(SkillSetting._ui["CloseButton"], function ()
        GUI:Win_Close(SkillSetting._parent)
    end)

    -- 重置事件
    GUI:addOnClickEvent(SkillSetting._ui["btnReset"], function ()
        local _, skills = SL:GetValue("LEARNED_SKILLS", true)
        for _, v in ipairs(skills) do
            SL:DeleteSkillKey(v.MagicID)
        end
        SL:SetValue("SKILL_KEY", BASIC_SKILL_ID, 1)
    end)

    -- 还原普攻
    GUI:addOnClickEvent(SkillSetting._ui["btnRestore"], function ()
        SL:SetValue("SKILL_KEY", BASIC_SKILL_ID, 1)
    end)

    SkillSetting._slotCells = {}
    for key = MinKey, MaxKey do
        local cell = SkillSetting._ui["ImageSkill_"..key]
        SkillSetting._slotCells[key] = cell
        GUI:addOnClickEvent(cell, function () SkillSetting.OnClickRSkillEvent(key) end)
    end
end

-- 初始化右侧技能槽位
function SkillSetting.InitSkillSlot()
    local _, skills = SL:GetValue("LEARNED_SKILLS", false, true)
    for _, v in ipairs(skills) do
        if v.Key and (v.Key >= MinKey and v.Key <= MaxKey) then
            SkillSetting.UpdateSkillChangeKey({skill = v, isInit = true}, true)
        end
    end
end

-- 更新当前技能槽位
function SkillSetting.UpdateSkillChangeKey(data)
    local key = data.skill.Key
    if not key then
        return false
    end

    local cell = SkillSetting._slotCells[key]
    if not cell then
        return false
    end

    -- reset last
    if data.last then
        SkillSetting.UpdateSkillDeleteKey({delKey = data.last.Key, skillID = data.last.MagicID})
    end

    local skillID = data.skill.MagicID

    -- new key
    local iSkill = GUI:getChildByName(cell, "iSkill")
    local path = SL:GetValue("SKILL_ICON_PATH", skillID)
    GUI:Image_loadTexture(iSkill, path)
    GUI:setVisible(iSkill, true)

    GUI:Win_SetParam(cell, { skillID = skillID, key = data.skill.Key })

    if data.isInit then
        return false
    end

    if skillID == BASIC_SKILL_ID then
        return false
    end

    if not SL:IsFileExist(path) then
        return false
    end

    local startPos = {x = 0, y = 0}
    local ctrlPos  = {x = 0, y = 0}
    local endPos   = GUI:getWorldPosition(iSkill)

    for id, ui in pairs(SkillSetting._skillCells) do
        if id == data.skill.MagicID then
            startPos = GUI:getWorldPosition(ui.skill_icon)
            break
        end
    end

    local SetUI = SkillSetting._ui["SetUI"]
    startPos = GUI:convertToNodeSpace(SetUI, startPos)
    endPos   = GUI:convertToNodeSpace(SetUI, endPos)
    ctrlPos.x = startPos.x + math.abs(endPos.x - startPos.x) * 0.4
    ctrlPos.y = startPos.y + 200

    local mStreak = GUI:MotionStreak_Create(SetUI, "mStreak", startPos.x, startPos.y, 0.12, 1, 50, "#FFFFFF", path)
    GUI:MotionStreak_reset(mStreak)
    
    -- 贝塞尔曲线
    local bezier = GUI:TimeLine_BezierTo(0.7, startPos, ctrlPos, endPos)
    -- 播放完删除
    local removeFunc = GUI:CallFunc(function ()
        if GUI:Win_IsNotNull(mStreak) then
            GUI:removeFromParent(mStreak)
        end
    end)
    local sequence = GUI:ActionSequence(GUI:ActionEaseSineInOut(bezier), removeFunc)
    -- 播放动作
    GUI:runAction(mStreak, sequence)

    local scale = GUI:getContentSize(iSkill).width / 65
    local image = GUI:Image_Create(SetUI, "image", startPos.x, startPos.y, path)
    GUI:setContentSize(image, 65, 65)

    local callFunc1  = GUI:CallFunc(function() GUI:setVisible(iSkill, false) end)
    local callFunc2  = GUI:CallFunc(function() GUI:setVisible(iSkill, true)  end)
    local actScale   = GUI:ActionScaleTo(0, 1)
    local actionEase = GUI:ActionEaseSineInOut(GUI:ActionSpawn(bezier, GUI:ActionFadeTo(0.7, 150), GUI:ActionFadeTo(0.7, scale)))
    local removeFunc = GUI:CallFunc(function ()
        if GUI:Win_IsNotNull(image) then
            GUI:removeFromParent(image)
        end
    end)
    local sequence = GUI:ActionSequence(callFunc1, actScale, actionEase, callFunc2, removeFunc)
    GUI:runAction(image, sequence)
end

-- 右侧技能槽位点击事件
function SkillSetting.OnClickRSkillEvent(key)
    if not SkillSetting._selSkillID then
        return false
    end

    -- special basic skill
    if SkillSetting._selSkillID ~= BASIC_SKILL_ID and key ~= 1 then
        SL:SetValue("SKILL_KEY", BASIC_SKILL_ID, 1)
    end

    -- new key
    SL:SetValue("SKILL_KEY", SkillSetting._selSkillID, key)

    SkillSetting.ClearSelectState()
end

-- 左侧技能按钮点击事件
function SkillSetting.OnClickLSkillEvent(skillID)
    SkillSetting._selSkillID = skillID

    for id, ui in pairs(SkillSetting._skillCells) do
        GUI:setVisible(ui.sfx, id == skillID)
    end

    for key, cell in ipairs(SkillSetting._slotCells) do
        local iSkill = GUI:getChildByName(cell, "iSkill")
        if iSkill then 
            local params = GUI:Win_GetParam(cell)
            local isGrey = params and params.skillID == skillID
            GUI:setGrey(iSkill, isGrey or false)
        end
    end
end

-- 清空选中状态
function SkillSetting.ClearSelectState()
    SkillSetting._selSkillID = nil

    for i, cell in ipairs(SkillSetting._slotCells) do
        local iSkill = GUI:getChildByName(cell, "iSkill")
        if iSkill then
            GUI:setGrey(iSkill, false)
        end
    end

    for _, ui in pairs(SkillSetting._skillCells) do
        GUI:setVisible(ui.sfx, false)
    end
end

-- 更新左侧技能列表
function SkillSetting.UpdateSkillList()
    local list = SkillSetting._ui["ScrollView_skills"]
    GUI:removeAllChildren(list)

    SkillSetting._skillCells = {}

    local sort = function (a, b)
        local a_info = SL:GetValue("SKILL_CONFIG", a.MagicID)
        local b_info = SL:GetValue("SKILL_CONFIG", b.MagicID)
        if not a_info or not b_info then
            return false
        end
        if not a_info.index or not b_info.index then
            return false
        end
        return a_info.index < b_info.index
    end

    local _, skills = SL:GetValue("LEARNED_SKILLS", true, true)
    table.sort(skills, sort)

    local itemWid  = 95
    local itemHei  = 110
    local innerHei = math.max(math.ceil(#skills / 3) * itemHei, 410)
    GUI:ScrollView_setInnerContainerSize(list, 385, innerHei)

    for i, v in ipairs(skills) do
        local cell = SkillSetting.CreateSkillCell()
        GUI:ScrollView_addChild(list, cell)
        
        local x = (i-1) % 3 * itemWid
        local y = innerHei - math.floor((i-1)/3) * itemHei
        GUI:setPosition(cell, x, y)
        GUI:setVisible(cell, true)

        local skillID = v.MagicID

        local ui = GUI:ui_delegate(cell)

        SkillSetting._skillCells[skillID] = ui

        -- icon
        GUI:Image_loadTexture(ui.skill_icon, SL:GetValue("SKILL_ICON_PATH", skillID))
        GUI:setContentSize(ui.skill_icon, 65, 65)

        -- sfx
        local size = GUI:getContentSize(ui.skill_bg)
        local sfx = GUI:Effect_Create(ui.skill_bg, "sfx", size.width / 2, size.height / 2, 0, 4004)
        GUI:setVisible(sfx, false)
        ui.sfx = sfx

        -- name
        local skillname = SL:GetValue("SKILL_NAME", skillID)
        GUI:Text_setString(ui.skill_name, skillname)

        -- 点击
        GUI:addOnClickEvent(cell, function () SkillSetting.OnClickLSkillEvent(skillID) end)
    end

    SkillSetting.ClearSelectState()
end

-- 左侧技能列表
function SkillSetting.CreateSkillCell()
    local ui = GUI:LoadExportEx2("skill_setting/skill_setting_cell", "Cell_setting")
    GUI:ui_IterChilds(ui, ui)
    return ui
end

-- 删除技能Key时更新
function SkillSetting.UpdateSkillDeleteKey(data)
    local key = data.delKey
    if not key then
        return false
    end

    local cell = SkillSetting._slotCells[key]
    if not cell then
        return false
    end

    local iSkill = GUI:getChildByName(cell, "iSkill")
    GUI:setVisible(iSkill, false)
    GUI:Win_SetParam(cell, {})
end

SkillSetting.main()