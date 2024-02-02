PlayerSkill_Look_TradingBank = {}----交易行 人物 技能
PlayerSkill_Look_TradingBank._ui = nil

function PlayerSkill_Look_TradingBank.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look_tradingbank/player_skill_node")
    PlayerSkill_Look_TradingBank._index = 0--添加的技能条编号
    PlayerSkill_Look_TradingBank._ui = GUI:ui_delegate(parent)
    PlayerSkill_Look_TradingBank._parent = parent
    if not PlayerSkill_Look_TradingBank._ui then
        return false
    end

    GUI:addOnClickEvent(PlayerSkill_Look_TradingBank._ui.Button_setting, function()
        SL:OpenSkillSettingUI()
    end)

    GUI:setVisible(PlayerSkill_Look_TradingBank._ui.Button_setting, false)

    PlayerSkill_Look_TradingBank.UpdateSkillCells()
    return true
end



function PlayerSkill_Look_TradingBank.UpdateSkillCells()
    GUI:ListView_removeAllItems(PlayerSkill_Look_TradingBank._ui.ListView_cells)
    PlayerSkill_Look_TradingBank._cells = {}
    --已学的技能排除普攻
    local items = SL:CopyData(SL:GetMetaValue("T.M.LEARNED_SKILLS", true))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = PlayerSkill_Look_TradingBank.CreateSkillCell(PlayerSkill_Look_TradingBank._ui.ListView_cells, skillID)
        PlayerSkill_Look_TradingBank._cells[skillID] = cell
    end

    for k, v in pairs(PlayerSkill_Look_TradingBank._cells) do
        PlayerSkill_Look_TradingBank.UpdateSkillCell(k)
    end
end

function PlayerSkill_Look_TradingBank.RefreshSkillCells(...)
    for k, v in pairs(PlayerSkill_Look_TradingBank._cells) do
        PlayerSkill_Look_TradingBank.UpdateSkillCell(k)
    end
end

function PlayerSkill_Look_TradingBank.UpdateSkillCell(skillID)
    local cell = PlayerSkill_Look_TradingBank._cells[skillID]
    if not cell then
        return
    end

    local skill =  SL:GetMetaValue("T.M.SKILL_DATA", skillID) 
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
    GUI:setContentSize(imageICON, 55, 55)
    --熟练度 等级
    local strTrain = SL:GetMetaValue("T.M.SKILL_TRAIN_DATA", skillID) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)
end

function PlayerSkill_Look_TradingBank.CreateSkillCell(parent,skillID)
    PlayerSkill_Look_TradingBank._index = PlayerSkill_Look_TradingBank._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..PlayerSkill_Look_TradingBank._index, 0, 0, 348, 70)
    GUI:LoadExport(widget, "player_look_tradingbank/skill_cell")
    local ui =  GUI:ui_delegate(widget)

    local config = SL:GetMetaValue("SKILL_CONFIG", skillID) 
    local name = SL:GetMetaValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    GUI:setTouchEnabled(ui.Image_icon,true)
    GUI:addOnClickEvent(ui.Image_icon,function(sneder)
        if config and config.desc then
            local worldPos = GUI:getTouchEndPosition(sneder)
            GUI:ShowWorldTips(config.desc, worldPos, GUI:p(0, 0))
        end
    end)
    return ui
end

return PlayerSkill_Look_TradingBank