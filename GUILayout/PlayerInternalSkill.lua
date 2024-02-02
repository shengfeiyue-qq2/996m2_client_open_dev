PlayerInternalSkill = {}
PlayerInternalSkill._ui = nil
PlayerInternalSkill._path = "res/private/internal/"

function PlayerInternalSkill.main()
    local parent = GUI:Attach_Parent()
    PlayerInternalSkill._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    if PlayerInternalSkill._isWIN32 then
        PlayerInternalSkill._path = "res/private/internal_win32/"
        GUI:LoadExport(parent, "internal_player/internal_skill_node_win32")
    else
        GUI:LoadExport(parent, "internal_player/internal_skill_node")
    end
    PlayerInternalSkill._index = 0 -- 添加的技能条编号
    PlayerInternalSkill._ui = GUI:ui_delegate(parent)
    if not PlayerInternalSkill._ui then
        return false
    end

    PlayerInternalSkill.UpdateSkillCells()

    PlayerInternalSkill.RegisterEvent()
    return true
end

-- 检查是否在列表显示
local function checkShowInList(qCell)
    local list = PlayerInternalSkill._ui.ListView_cells
    local posY = GUI:getPositionY(qCell)
    local cellH = GUI:getContentSize(qCell).height
    local sizeH = GUI:getContentSize(list).height
    local innerPosY = GUI:ListView_getInnerContainerPosition(list).y
    local isShow = (posY + cellH) >= -innerPosY and posY <= (-innerPosY + sizeH)
    return isShow
end

function PlayerInternalSkill.UpdateSkillCells()
    GUI:ListView_removeAllItems(PlayerInternalSkill._ui.ListView_cells)
    PlayerInternalSkill._cells = {}
    PlayerInternalSkill._qCells = {}
    --已学的技能
    local items = SL:CopyData(SL:GetMetaValue("INTERNAL_SKILLS"))

    local cellW = PlayerInternalSkill._isWIN32 and 244 or 310
    local cellH = PlayerInternalSkill._isWIN32 and 50 or 70
    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local skillType = v.SkillType
        local k = string.format("%s_%s", skillID, skillType)
        PlayerInternalSkill._qCells[k] = GUI:QuickCell_Create(PlayerInternalSkill._ui.ListView_cells, "skillItem" .. i, 0, 0, cellW, cellH, function(parent)
            local cell, ui = PlayerInternalSkill.CreateSkillCell(parent, skillID, skillType)
            PlayerInternalSkill._cells[k] = ui
            PlayerInternalSkill.UpdateSkillCell(k)
            return cell
        end, checkShowInList)
    end
end

function PlayerInternalSkill.RefreshSkillCells(...)
    for k, v in pairs(PlayerInternalSkill._cells) do
        PlayerInternalSkill.UpdateSkillCell(k)
    end
end

function PlayerInternalSkill.UpdateSkillCell(key)
    local cell = PlayerInternalSkill._cells[key]
    if not cell then
        return
    end

    local qCell = PlayerInternalSkill._qCells[key]
    if not checkShowInList(qCell) then
        return
    end

    local data = string.split(key, "_")
    local skillID = tonumber(data[1])
    local skillType = tonumber(data[2])
    if not skillID or not skillType then
        return
    end
    local skill =  SL:GetMetaValue("INTERNAL_SKILL_DATA", skillID, skillType)
    if not skill then
        return
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath  = SL:GetMetaValue("INTERNAL_SKILL_RECT_ICON_PATH", skillID, skillType) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_" .. skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    local wid = PlayerInternalSkill._isWIN32 and 40 or 55
    GUI:setContentSize(imageICON, wid, wid)

    -- 熟练度 等级
    local strTrain = SL:GetMetaValue("INTERNAL_SKILL_TRAIN_DATA", skillID, skillType) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

    -- 开关显示
    local state = SL:GetMetaValue("INTERNAL_SKILL_ONOFF", skillID, skillType)
    GUI:Button_setBright(cell.Button_onoff, state == 0)
    local path = PlayerInternalSkill._path .. (state == 0 and "btn_jnkan_02.png" or "btn_jnkan_01.png")
    GUI:Image_loadTexture(cell.Image_onoff, path)
    GUI:setPositionX(cell.Image_onoff, state == 0 and 30 or 0)
    PlayerInternalSkill.SetNormal_Grey(cell.Panel_skill_cell, state)
end

function PlayerInternalSkill.CreateSkillCell(parent, skillID, skillType)
    if PlayerInternalSkill._isWIN32 then
        GUI:LoadExport(parent, "internal_player/skill_cell_win32")
    else
        GUI:LoadExport(parent, "internal_player/skill_cell")
    end
    local ui = GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_skill_cell")
 
    local name = SL:GetMetaValue("INTERNAL_SKILL_NAME", skillID, skillType) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    GUI:setTouchEnabled(ui.Image_icon, true)
    GUI:addOnClickEvent(ui.Image_icon, function(sneder)
        local desc = SL:GetMetaValue("INTERNAL_SKILL_DESC", skillID, skillType)
        if desc then
            local worldPos = GUI:getTouchEndPosition(sneder)
            GUI:ShowWorldTips(desc, worldPos, {x = 0, y = 0})
        end
    end)

    -- 开关
    GUI:addOnClickEvent(ui.Button_onoff, function(sender)
        local state = SL:GetMetaValue("INTERNAL_SKILL_ONOFF", skillID, skillType) 
        state = state == 0 and 1 or 0
        GUI:Button_setBright(sender, state == 0)
        local path = PlayerInternalSkill._path .. (state == 0 and "btn_jnkan_02.png" or "btn_jnkan_01.png")
        local img = GUI:getChildByName(sender, "Image_onoff")
        GUI:Image_loadTexture(img, path)
        GUI:setPositionX(img, state == 0 and 30 or 0)
        PlayerInternalSkill.SetNormal_Grey(ui.Panel_skill_cell, state)
        SL:SetMetaValue("INTERNAL_SKILL_ONOFF", skillID, skillType, state)
    end)
    return cell, ui
end

function PlayerInternalSkill.SetNormal_Grey(node, state)
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
        PlayerInternalSkill.SetNormal_Grey(v, state)
    end
end

function PlayerInternalSkill.RefreshSkillShow(data)
    if data.skillID and data.SkillType then
        local key = string.format("%s_%s", data.skillID, data.SkillType)
        PlayerInternalSkill.UpdateSkillCell(key)
    end
end

function PlayerInternalSkill.OnClose()
    PlayerInternalSkill.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function PlayerInternalSkill.RegisterEvent()
    -- 增加技能
    SL:RegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_ADD, "PlayerInternalSkill", PlayerInternalSkill.UpdateSkillCells)
    -- 删除技能
    SL:RegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_DEL, "PlayerInternalSkill", PlayerInternalSkill.UpdateSkillCells)
    -- 更新技能
    SL:RegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_UPDATE, "PlayerInternalSkill", PlayerInternalSkill.RefreshSkillShow)
end

function PlayerInternalSkill.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_ADD, "PlayerInternalSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_DEL, "PlayerInternalSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_INTERNAL_SKILL_UPDATE, "PlayerInternalSkill")
end

return PlayerInternalSkill