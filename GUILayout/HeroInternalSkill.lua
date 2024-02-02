HeroInternalSkill = {}
HeroInternalSkill._ui = nil
HeroInternalSkill._path = "res/private/internal/"

function HeroInternalSkill.main()
    local parent = GUI:Attach_Parent()
    HeroInternalSkill._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    if HeroInternalSkill._isWIN32 then
        HeroInternalSkill._path = "res/private/internal_win32/"
        GUI:LoadExport(parent, "internal_hero/internal_skill_node_win32")
    else
        GUI:LoadExport(parent, "internal_hero/internal_skill_node")
    end
    HeroInternalSkill._index = 0 -- 添加的技能条编号
    HeroInternalSkill._ui = GUI:ui_delegate(parent)
    if not HeroInternalSkill._ui then
        return false
    end

    HeroInternalSkill.UpdateSkillCells()

    HeroInternalSkill.RegisterEvent()
    return true
end

-- 检查是否在列表显示
local function checkShowInList(qCell)
    local list = HeroInternalSkill._ui.ListView_cells
    local posY = GUI:getPositionY(qCell)
    local cellH = GUI:getContentSize(qCell).height
    local sizeH = GUI:getContentSize(list).height
    local innerPosY = GUI:ListView_getInnerContainerPosition(list).y
    local isShow = (posY + cellH) >= -innerPosY and posY <= (-innerPosY + sizeH)
    return isShow
end

function HeroInternalSkill.UpdateSkillCells()
    GUI:ListView_removeAllItems(HeroInternalSkill._ui.ListView_cells)
    HeroInternalSkill._cells = {}
    HeroInternalSkill._qCells = {}
    --已学的技能
    local items = SL:CopyData(SL:GetMetaValue("H.INTERNAL_SKILLS"))

    local cellW = HeroInternalSkill._isWIN32 and 244 or 310
    local cellH = HeroInternalSkill._isWIN32 and 50 or 70
    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local skillType = v.SkillType
        local k = string.format("%s_%s", skillID, skillType)
        HeroInternalSkill._qCells[k] = GUI:QuickCell_Create(HeroInternalSkill._ui.ListView_cells, "skillItem" .. i, 0, 0, cellW, cellH, function(parent)
            local cell, ui = HeroInternalSkill.CreateSkillCell(parent, skillID, skillType)
            HeroInternalSkill._cells[k] = ui
            HeroInternalSkill.UpdateSkillCell(k)
            return cell
        end, checkShowInList)
    end
end

function HeroInternalSkill.RefreshSkillCells(...)
    for k, v in pairs(HeroInternalSkill._cells) do
        HeroInternalSkill.UpdateSkillCell(k)
    end
end

function HeroInternalSkill.UpdateSkillCell(key)
    local cell = HeroInternalSkill._cells[key]
    if not cell then
        return
    end

    local qCell = HeroInternalSkill._qCells[key]
    if not checkShowInList(qCell) then
        return
    end

    local data = string.split(key, "_")
    local skillID = tonumber(data[1])
    local skillType = tonumber(data[2])
    if not skillID or not skillType then
        return
    end
    local skill =  SL:GetMetaValue("H.INTERNAL_SKILL_DATA", skillID, skillType)
    if not skill then
        return
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath  = SL:GetMetaValue("H.INTERNAL_SKILL_RECT_ICON_PATH", skillID, skillType) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_" .. skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    local wid = HeroInternalSkill._isWIN32 and 40 or 55
    GUI:setContentSize(imageICON, wid, wid)

    -- 熟练度 等级
    local strTrain = SL:GetMetaValue("H.INTERNAL_SKILL_TRAIN_DATA", skillID, skillType) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

    -- 开关显示
    local state = SL:GetMetaValue("H.INTERNAL_SKILL_ONOFF", skillID, skillType)
    GUI:Button_setBright(cell.Button_onoff, state == 0)
    local path = HeroInternalSkill._path .. (state == 0 and "btn_jnkan_02.png" or "btn_jnkan_01.png")
    GUI:Image_loadTexture(cell.Image_onoff, path)
    GUI:setPositionX(cell.Image_onoff, state == 0 and 30 or 0)
    HeroInternalSkill.SetNormal_Grey(cell.Panel_skill_cell, state)
end

function HeroInternalSkill.CreateSkillCell(parent, skillID, skillType)
    if HeroInternalSkill._isWIN32 then
        GUI:LoadExport(parent, "internal_hero/skill_cell_win32")
    else
        GUI:LoadExport(parent, "internal_hero/skill_cell")
    end
    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_skill_cell")

    local name = SL:GetMetaValue("H.INTERNAL_SKILL_NAME", skillID, skillType) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    GUI:setTouchEnabled(ui.Image_icon, true)
    GUI:addOnClickEvent(ui.Image_icon, function(sneder)
        local desc = SL:GetMetaValue("H.INTERNAL_SKILL_DESC", skillID, skillType)
        if desc then
            local worldPos = GUI:getTouchEndPosition(sneder)
            GUI:ShowWorldTips(desc, worldPos, {x = 0, y = 0})
        end
    end)

    -- 开关
    GUI:addOnClickEvent(ui.Button_onoff, function(sender)
        local state = SL:GetMetaValue("H.INTERNAL_SKILL_ONOFF", skillID, skillType) 
        state = state == 0 and 1 or 0
        GUI:Button_setBright(sender, state == 0)
        local path = HeroInternalSkill._path .. (state == 0 and "btn_jnkan_02.png" or "btn_jnkan_01.png")
        local img = GUI:getChildByName(sender, "Image_onoff")
        GUI:Image_loadTexture(img, path)
        GUI:setPositionX(img, state == 0 and 30 or 0)
        HeroInternalSkill.SetNormal_Grey(ui.Panel_skill_cell, state)
        SL:SetMetaValue("H.INTERNAL_SKILL_ONOFF", skillID, skillType, state)
    end)
    return cell, ui
end

function HeroInternalSkill.SetNormal_Grey(node, state)
    if not node then
        return 
    end 
    local t = GUI:getChildren(node)
    for i, v in ipairs(t) do
        if state == 1 then
            GUI:setGrey(v, true)
        else
            GUI:setGrey(v, false)
        end
        HeroInternalSkill.SetNormal_Grey(v, state)
    end
end

function HeroInternalSkill.RefreshSkillShow(data)
    if data.skillID and data.SkillType then
        local key = string.format("%s_%s", data.skillID, data.SkillType)
        HeroInternalSkill.UpdateSkillCell(key)
    end
end

function HeroInternalSkill.OnClose()
    HeroInternalSkill.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function HeroInternalSkill.RegisterEvent()
    -- 增加技能
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_ADD, "HeroInternalSkill", HeroInternalSkill.UpdateSkillCells)
    -- 删除技能
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_DEL, "HeroInternalSkill", HeroInternalSkill.UpdateSkillCells)
    -- 更新技能
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_UPDATE, "HeroInternalSkill", HeroInternalSkill.RefreshSkillShow)
end

function HeroInternalSkill.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_ADD, "HeroInternalSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_DEL, "HeroInternalSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_SKILL_UPDATE, "HeroInternalSkill")
end

return HeroInternalSkill