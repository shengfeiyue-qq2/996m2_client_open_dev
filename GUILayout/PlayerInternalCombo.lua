PlayerInternalCombo = {}

PlayerInternalCombo._ui = nil

function PlayerInternalCombo.main()
    local parent = GUI:Attach_Parent()
    PlayerInternalCombo._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    if PlayerInternalCombo._isWIN32 then
        GUI:LoadExport(parent, "internal_player/internal_combo_node_win32")
    else
        GUI:LoadExport(parent, "internal_player/internal_combo_node")
    end
    PlayerInternalCombo._path = PlayerInternalCombo._isWIN32 and "res/private/internal_win32/" or "res/private/internal/"

    PlayerInternalCombo._index = 0 -- 添加的技能条编号
    PlayerInternalCombo._ui = GUI:ui_delegate(parent)
    if not PlayerInternalCombo._ui then
        return false
    end

    PlayerInternalCombo._cells = {}
    PlayerInternalCombo._qCells = {}
    PlayerInternalCombo._setComboSkill = {}
    PlayerInternalCombo.InitSelectSkill()
    PlayerInternalCombo.UpdateSkillCells()
    PlayerInternalCombo.RegisterEvent()
end

function PlayerInternalCombo.InitSelectSkill()
    local selectSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
    local openNum = SL:GetMetaValue("OPEN_COMBO_NUM")
    for i = 1, 4 do
        local skillID = selectSkills[i]
        if PlayerInternalCombo._isWIN32 then
            GUI:setContentSize(PlayerInternalCombo._ui["skill_icon_" .. i], 46, 46)
            GUI:setIgnoreContentAdaptWithSize(PlayerInternalCombo._ui["skill_icon_" .. i], false)
        end
        if skillID and skillID ~= 0 then
            PlayerInternalCombo._setComboSkill[skillID] = i
            local iconPath = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID, true) 
            if SL:IsFileExist(iconPath) then
                GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. i], iconPath)
            end
        elseif i == 4 and i <= openNum then
            local path = PlayerInternalCombo._path .. string.format("0090%d.png", i)
            GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. i], path)
        end
        GUI:setTouchEnabled(PlayerInternalCombo._ui["skill_icon_" .. i], i <= openNum)
        GUI:addOnClickEvent(PlayerInternalCombo._ui["skill_icon_" .. i], function (sender)
            local worldPos = GUI:getWorldPosition(sender)
            local size = GUI:getContentSize(sender)
            PlayerInternalCombo.ShowSelectPanel(i, worldPos)
        end)
    end
end

function PlayerInternalCombo.ShowSelectPanel(key, pos)
    local list = {}
    local items = SL:CopyData(SL:GetMetaValue("HAVE_COMBO_SKILLS"))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)
    for _, item in ipairs(items) do
        local name = SL:GetMetaValue("SKILL_NAME", item.MagicID)
        table.insert(list, name)
    end
    table.insert(list, "空")

    local function func(idx)
        local skillID = nil
        if idx == 0 or idx == #list then
            local path = PlayerInternalCombo._path .. string.format("0090%d.png", key)
            GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. key], path)
        else
            skillID = items[idx] and items[idx].MagicID
            local iconPath = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID, true) 
            if SL:IsFileExist(iconPath) then
                GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. key], iconPath)
            end
        end
        SL:RequestSetComboSkill(key, skillID)
    end
    local selWid = PlayerInternalCombo._isWIN32 and 110 or 140
    local selHei = PlayerInternalCombo._isWIN32 and 32 or 40
    SL:OpenSelectListUI(list, pos, selWid, selHei, func, {fontSize = PlayerInternalCombo._isWIN32 and 12 or 16})
end

function PlayerInternalCombo.RefreshSetIconShow(key)
    local selectSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
    if selectSkills[key] and selectSkills[key] ~= 0 then
        local iconPath = SL:GetMetaValue("SKILL_RECT_ICON_PATH", selectSkills[key], true) 
        if SL:IsFileExist(iconPath) then
            GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. key], iconPath)
        end
    else
        local path = PlayerInternalCombo._path .. string.format("0090%d.png", key)
        GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. key], path)
    end

    PlayerInternalCombo._setComboSkill = {}
    for i = 1, 4 do
        local skillID = selectSkills[i]
        if skillID and skillID ~= 0 then
            PlayerInternalCombo._setComboSkill[skillID] = i
        end
    end
    PlayerInternalCombo.RefreshSkillCells()
end

-- 检查是否在列表显示
local function checkShowInList(qCell)
    local list = PlayerInternalCombo._ui.ListView_cells
    local posY = GUI:getPositionY(qCell)
    local cellH = GUI:getContentSize(qCell).height
    local sizeH = GUI:getContentSize(list).height
    local innerPosY = GUI:ListView_getInnerContainerPosition(list).y
    local isShow = (posY + cellH) >= -innerPosY and posY <= (-innerPosY + sizeH)
    return isShow
end

function PlayerInternalCombo.UpdateSkillCells()
    GUI:ListView_removeAllItems(PlayerInternalCombo._ui.ListView_cells)
    PlayerInternalCombo._cells = {}
    PlayerInternalCombo._qCells = {}
    --已学连击技能
    local items = SL:CopyData(SL:GetMetaValue("HAVE_COMBO_SKILLS"))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    local cellW = PlayerInternalCombo._isWIN32 and 244 or 310
    local cellH = PlayerInternalCombo._isWIN32 and 50 or 70
    for i, v in ipairs(items) do
        local skillID = v.MagicID
        PlayerInternalCombo._qCells[skillID] = GUI:QuickCell_Create(PlayerInternalCombo._ui.ListView_cells, "skillItem" .. i, 0, 0, cellW, cellH, function(parent)
            local cell, ui = PlayerInternalCombo.CreateSkillCell(parent, skillID)
            PlayerInternalCombo._cells[skillID] = ui
            PlayerInternalCombo.UpdateSkillCell(skillID)
            return cell
        end, checkShowInList)
    end
end

function PlayerInternalCombo.RefreshSkillCells(...)
    for k, v in pairs(PlayerInternalCombo._cells) do
        PlayerInternalCombo.UpdateSkillCell(k)
    end
end

function PlayerInternalCombo.UpdateSkillCell(skillID)
    local cell = PlayerInternalCombo._cells[skillID]
    if not cell then
        return
    end

    local qCell = PlayerInternalCombo._qCells[skillID]
    if not checkShowInList(qCell) then
        return
    end

    local skill =  SL:GetMetaValue("COMBO_SKILL_DATA", skillID) 
    if not skill then
        return
    end
    -- name 暴击率
    local nameStr = SL:GetMetaValue("SKILL_NAME", skillID)
    if skill.LJBJRate then
        -- 设置连击下标
        local key = PlayerInternalCombo._setComboSkill[skillID]
        if key then
            local extraRate = tonumber(SL:GetMetaValue("EXTRA_COMBO_BJRATE", key)) or 0
            nameStr = string.format("%s:%s%%+%s%%暴击", nameStr, skill.LJBJRate, extraRate)
        else
            nameStr = string.format("%s:%s%%暴击", nameStr, skill.LJBJRate)
        end
        GUI:Text_setString(cell.Text_skillName, nameStr)
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath  = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID, true) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_" .. skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    local wid = PlayerInternalCombo._isWIN32 and 40 or 55
    GUI:setContentSize(imageICON, wid, wid)

    -- 熟练度 等级
    local strTrain = SL:GetMetaValue("COMBO_SKILL_TRAIN_DATA", skillID)
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

end

function PlayerInternalCombo.CreateSkillCell(parent, skillID)
    if PlayerInternalCombo._isWIN32 then
        GUI:LoadExport(parent, "internal_player/combo_skill_cell_win32")
    else
        GUI:LoadExport(parent, "internal_player/combo_skill_cell")
    end
    local ui =  GUI:ui_delegate(parent)
    local cell = GUI:getChildByName(parent, "Panel_skill_cell")

    local config = SL:GetMetaValue("SKILL_CONFIG", skillID) 
    local name = SL:GetMetaValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    GUI:setTouchEnabled(ui.Image_icon, true)
    GUI:addOnClickEvent(ui.Image_icon, function(sender)
        if config and config.desc then
            local worldPos = GUI:getTouchEndPosition(sender)
            GUI:ShowWorldTips(config.desc, worldPos, GUI:p(0, 0))
        end
    end)
    return cell, ui
end

function PlayerInternalCombo.RefreshComboOpenShow()
    local openNum = SL:GetMetaValue("OPEN_COMBO_NUM")
    for i = 1, 4 do
        GUI:setTouchEnabled(PlayerInternalCombo._ui["skill_icon_" .. i], i <= openNum)
        if i == 4 then
            local path = PlayerInternalCombo._path .. string.format("0090%d.png", i <= openNum and i or 5)
            GUI:Image_loadTexture(PlayerInternalCombo._ui["skill_icon_" .. i], path)
        end
    end
end

function PlayerInternalCombo.RefreshSkillShow(data)
    if data.skillID then
        PlayerInternalCombo.UpdateSkillCell(data.skillID)
    end
end

function PlayerInternalCombo.OnClose()
    PlayerInternalCombo.UnRegisterEvent()
end

function PlayerInternalCombo.OnClose()
    PlayerInternalCombo.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function PlayerInternalCombo.RegisterEvent()
    -- 增加技能
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_ADD, "PlayerInternalCombo", PlayerInternalCombo.UpdateSkillCells)
    -- 删除技能
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_DEL, "PlayerInternalCombo", PlayerInternalCombo.UpdateSkillCells)
    -- 更新技能
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_UPDATE, "PlayerInternalCombo", PlayerInternalCombo.RefreshSkillShow)
    -- 设置连击的技能更新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SET_COMBO_REFRESH, "PlayerInternalCombo", PlayerInternalCombo.RefreshSetIconShow)
    -- 开启的连击格子数改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_OPEN_COMBO_NUM, "PlayerInternalCombo", PlayerInternalCombo.RefreshComboOpenShow)
end

function PlayerInternalCombo.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_ADD, "PlayerInternalCombo")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_DEL, "PlayerInternalCombo")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILL_UPDATE, "PlayerInternalCombo")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_SET_COMBO_REFRESH, "PlayerInternalCombo")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_OPEN_COMBO_NUM, "PlayerInternalCombo")
end