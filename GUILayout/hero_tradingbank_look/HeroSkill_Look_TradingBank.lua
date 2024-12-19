HeroSkill_Look_TradingBank = {}----交易行 人物 技能
HeroSkill_Look_TradingBank._ui = nil

function HeroSkill_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_skill_node")
    HeroSkill_Look_TradingBank._index = 0--添加的技能条编号
    HeroSkill_Look_TradingBank._ui = GUI:ui_delegate(parent)
    HeroSkill_Look_TradingBank._parent = parent
    if not HeroSkill_Look_TradingBank._ui then
        return false
    end

    GUI:setVisible(HeroSkill_Look_TradingBank._ui.Button_setting, false)

    HeroSkill_Look_TradingBank.UpdateSkillCells()
    return true
end

function HeroSkill_Look_TradingBank.UpdateSkillCells()
    GUI:ListView_removeAllItems(HeroSkill_Look_TradingBank._ui.ListView_cells)
    HeroSkill_Look_TradingBank._cells = {}
    local items = SL:CopyData(TradingBankLookPlayerData.GetHeroSkills())
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = HeroSkill_Look_TradingBank.CreateSkillCell(HeroSkill_Look_TradingBank._ui.ListView_cells, skillID)
        HeroSkill_Look_TradingBank._cells[skillID] = cell
    end

    for k, v in pairs(HeroSkill_Look_TradingBank._cells) do
        HeroSkill_Look_TradingBank.UpdateSkillCell(k)
    end
end

function HeroSkill_Look_TradingBank.RefreshSkillCells(...)
    for k, v in pairs(HeroSkill_Look_TradingBank._cells) do
        HeroSkill_Look_TradingBank.UpdateSkillCell(k)
    end
end

function HeroSkill_Look_TradingBank.UpdateSkillCell(skillID)
    local cell = HeroSkill_Look_TradingBank._cells[skillID]
    if not cell then
        return
    end

    local skill = TradingBankLookPlayerData.GetHeroSkillByID(skillID)
    if not skill then
        return
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath   = SL:GetValue("SKILL_RECT_ICON_PATH", skillID) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON    = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_"..skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    GUI:setContentSize(imageICON, 55, 55)
    --熟练度 等级
    local strTrain = TradingBankLookPlayerData.GetHeroSkillTrainData(skillID)
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)
end

function HeroSkill_Look_TradingBank.CreateSkillCell(parent, skillID)
    HeroSkill_Look_TradingBank._index = HeroSkill_Look_TradingBank._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..HeroSkill_Look_TradingBank._index, 0, 0, 348, 70)
    GUI:LoadExport(widget, "hero_look_tradingbank/skill_cell")
    local ui =  GUI:ui_delegate(widget)

    local config = SL:GetValue("SKILL_CONFIG", skillID) 
    local name = SL:GetValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui.Text_skillName, name)

    -- show tips
    GUI:setTouchEnabled(ui.Image_icon, true)
    GUI:addOnClickEvent(ui.Image_icon, function(sender)
        if config and config.desc then
            local worldPos = GUI:getTouchEndPosition(sender)
            GUI:ShowWorldTips(config.desc, worldPos, GUI:p(0, 0))
        end
    end)
    return ui
end

function HeroSkill_Look_TradingBank.OnClose()
end

return HeroSkill_Look_TradingBank