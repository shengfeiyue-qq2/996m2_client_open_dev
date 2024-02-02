PlayerSkill = {}----角色面板 技能
PlayerSkill._ui = nil
PlayerSkill._path  = SLDefine.PATH_RES_PRIVATE .. "player_skill-win32/"--快捷键图片路径

function PlayerSkill.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_skill_node_win32")
    PlayerSkill._index = 0--添加的技能条编号
    PlayerSkill._ui = GUI:ui_delegate(parent)
    PlayerSkill._parent = parent
    PlayerSkill._moveIconCells = {}
    if not PlayerSkill._ui then
        return false
    end
    GUI:ListView_addMouseScrollPercent(PlayerSkill._ui.ListView_cells)
    PlayerSkill.UpdateSkillCells()
    return true
end

function PlayerSkill.UpdateSkillCells()
    GUI:ListView_removeAllItems(PlayerSkill._ui.ListView_cells)
    PlayerSkill._cells = {}
    --已学的技能排除普攻
    local items = SL:CopyData(SL:GetMetaValue("LEARNED_SKILLS", true))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = PlayerSkill.CreateSkillCell(PlayerSkill._ui.ListView_cells, skillID)
        PlayerSkill._cells[skillID] = cell
    end

    for k, v in pairs(PlayerSkill._cells) do
        PlayerSkill.UpdateSkillCell(k)
    end
end

function PlayerSkill.RefreshSkillCells(...)
    for k, v in pairs(PlayerSkill._cells) do
        PlayerSkill.UpdateSkillCell(k)
    end
end

function PlayerSkill.UpdateSkillCell(skillID, deleteChange)
    local cell = PlayerSkill._cells[skillID]
    if not cell then
        return
    end

    local skill =  SL:GetMetaValue("SKILL_DATA", skillID) 
    if not skill then
        return
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath   = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON    = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_"..skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON,0.5,0.5)
    GUI:setContentSize(imageICON, 40, 40)

    local skillKey = SL:GetMetaValue("SKILL_KEY", skillID)  
    local level    = SL:GetMetaValue("SKILL_LEVEL", skillID)
    --熟练度 等级
    local strTrain = SL:GetMetaValue("SKILL_TRAIN_DATA", skillID) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_key, skillKey ~= 0)
    GUI:Image_loadTexture(cell.Image_key,PlayerSkill._path .. string.format("word_anzi_%s.png", skillKey > 8 and skillKey-8 or skillKey+8))
    GUI:setIgnoreContentAdaptWithSize(cell.Image_key, true)

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)
    PlayerSkill._parent:RegisterNodeMovable(skillID, deleteChange)
end

function PlayerSkill.CreateSkillCell(parent,skillID)
    PlayerSkill._index = PlayerSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..PlayerSkill._index, 0, 0, 272, 50)
    GUI:setTouchEnabled(widget,true)
    GUI:LoadExport(widget, "player/skill_cell_win32")
    local ui =  GUI:ui_delegate(widget)

    GUI:setSwallowTouches(ui.Panel_skill_cell,false)
    GUI:addOnClickEvent(ui.Panel_skill_cell,function()
        local skill = SL:GetMetaValue("SKILL_DATA", skillID) 
        SL:OpenSkillSettingUI(skill)
    end)

    local config = SL:GetMetaValue("SKILL_CONFIG", skillID) 
    local name = SL:GetMetaValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    if config.desc then
        local param = {
            checkCallback = function(touchPos)
                if touchPos and GUI:isClippingParentContainsPoint(ui.Image_icon, touchPos) then
                    return true
                end
                return false
            end
        }
        GUI:addMouseOverTips(ui.Image_icon, config.desc, nil, nil, param)
    end
    return ui
end

return PlayerSkill