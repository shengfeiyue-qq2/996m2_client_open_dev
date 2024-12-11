PlayerSkill = {}

local isPC = SL:GetValue("IS_PC_OPER_MODE")

-- 技能图标尺寸
local iconSize = isPC and {width = 40, height = 40} or {width = 55, height = 55}

function PlayerSkill.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if GUI:Win_IsNull(parent) then
        return false
    end
    GUI:LoadExport(parent, isPC and "player/player_skill_node_win32" or "player/player_skill_node")

    PlayerSkill._index = 0--添加的技能条编号
    PlayerSkill._ui = GUI:ui_delegate(parent)
    if not PlayerSkill._ui then
        return false
    end

    if isPC then
        GUI:ListView_addMouseScrollPercent(PlayerSkill._ui["ListView_cells"])
        PlayerSkill._moveIconCells = {}
    else
        -- 手游有设置按钮入口
        GUI:addOnClickEvent(PlayerSkill._ui["Button_setting"], function()
            UIOperator:OpenSkillSettingUI()
        end)
    end
    
    PlayerSkill.UpdateSkillListView()

    GUI:RefPosByParent(parent)

    PlayerSkill.RegistEvent()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerSkill})
end

-- 界面关闭回调
function PlayerSkill.OnClose()
    PlayerSkill.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSkill
    })
end

function PlayerSkill.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "PlayerSkill", PlayerSkill.OnSkillAdd)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "PlayerSkill", PlayerSkill.OnSkillDel)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, "PlayerSkill", PlayerSkill.OnSkillUpdate)

    if isPC then
        SL:RegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "PlayerSkill", PlayerSkill.OnSkillKeyChange)
        SL:RegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "PlayerSkill", PlayerSkill.OnSkillKeyDel)
    end
end

-- 取消事件
function PlayerSkill.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_ADD, "PlayerSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_DEL, "PlayerSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_UPDATE, "PlayerSkill")

    if isPC then
        SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_CHANGE_KEY, "PlayerSkill")
        SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_DELETE_KEY, "PlayerSkill")
    end
end

function PlayerSkill.OnSkillAdd()
    PlayerSkill.UpdateSkillListView()
end

function PlayerSkill.OnSkillDel()
    PlayerSkill.UpdateSkillListView()
end

function PlayerSkill.OnSkillUpdate(data)
    PlayerSkill.UpdateSkillCell(data.skillID)
end

function PlayerSkill.OnSkillKeyChange(data)
    PlayerSkill.UpdateSkillCell(data.skill.MagicID)
end

function PlayerSkill.OnSkillKeyDel(data)
    PlayerSkill.UpdateSkillCell(data.skill.MagicID, data.change)
end

function PlayerSkill.UpdateSkillListView()
    GUI:ListView_removeAllItems(PlayerSkill._ui["ListView_cells"])
    PlayerSkill._cells = {}

    -- 已学的技能排除普攻
    local _, items = SL:GetValue("LEARNED_SKILLS", true)
    table.sort(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = PlayerSkill.CreateSkillCell(PlayerSkill._ui["ListView_cells"], skillID)
        PlayerSkill._cells[skillID] = cell
    end

    for k, v in pairs(PlayerSkill._cells) do
        PlayerSkill.UpdateSkillCell(k)
    end
end

function PlayerSkill.UpdateSkillCell(skillID, deleteChange)
    local cell = PlayerSkill._cells[skillID]
    if not cell then
        return
    end

    local skill =  SL:GetValue("SKILL_DATA", skillID) 
    if not skill then
        return
    end
    -- icon
    local Image_icon = cell["Image_icon"]

    local contentSize = GUI:getContentSize(Image_icon)
    local iconPath   = SL:GetValue("SKILL_RECT_ICON_PATH", skillID) 
    GUI:removeAllChildren(Image_icon)
    local imageICON    = GUI:Image_Create(Image_icon, "rectSkillIcon_"..skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON,0.5,0.5)
    GUI:setContentSize(imageICON, iconSize)

    -- 熟练度 等级
    local strTrain = SL:GetValue("SKILL_TRAIN_DATA", skillID) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

    if isPC then
        GUI:setTouchEnabled(Image_icon, true)
        local skillKey = SL:GetValue("SKILL_KEY", skillID)  
        GUI:setVisible(cell.Image_key, skillKey ~= 0)
        GUI:Image_loadTexture(cell.Image_key, string.format("res/private/player_skill-win32/word_anzi_%s.png", skillKey > 8 and skillKey-8 or skillKey+8))
        GUI:setIgnoreContentAdaptWithSize(cell.Image_key, true)
        PlayerSkill.RegisterNodeMovable(skillID, deleteChange)
    end
end

function PlayerSkill.CreateSkillCell_Phone(parent, skillID)
    PlayerSkill._index = PlayerSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..PlayerSkill._index, 0, 0, 348, 70)
    GUI:LoadExport(widget, "player/skill_cell")
    local ui =  GUI:ui_delegate(widget)

    local config = SL:GetValue("SKILL_CONFIG", skillID) 
    local name = SL:GetValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui["Text_skillName"], name)

    -- show tips
    GUI:setTouchEnabled(ui["Image_icon"],true)
    GUI:addOnClickEvent(ui["Image_icon"],function(sneder)
        if config and config.desc then
            local worldPos = GUI:getTouchEndPosition(sneder)
            GUI:ShowWorldTips(config.desc, worldPos, GUI:p(0, 0))
        end
    end)
    return ui
end

function PlayerSkill.CreateSkillCell_PC(parent, skillID)
    PlayerSkill._index = PlayerSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..PlayerSkill._index, 0, 0, 272, 50)
    GUI:setTouchEnabled(widget,true)
    GUI:LoadExport(widget, "player/skill_cell_win32")
    local ui =  GUI:ui_delegate(widget)

    GUI:setSwallowTouches(ui["Panel_skill_cell"],false)
    GUI:addOnClickEvent(ui["Panel_skill_cell"],function()
        local skill = SL:GetValue("SKILL_DATA", skillID)
        UIOperator:OpenSkillSettingUI(skill)
    end)

    local config = SL:GetValue("SKILL_CONFIG", skillID) 
    local name = SL:GetValue("SKILL_NAME", skillID) 
    GUI:Text_setString(ui["Text_skillName"], name)

    -- show tips
    if config.desc then
        local param = {
            checkCallback = function(touchPos)
                if touchPos and GUI:isClippingParentContainsPoint(ui["Image_icon"], touchPos) then
                    return true
                end
                return false
            end
        }
        GUI:addMouseOverTips(ui["Image_icon"], config.desc, nil, nil, param)
    end
    return ui
end

function PlayerSkill.CreateSkillCell(parent, skillID)
    if isPC then
        return PlayerSkill.CreateSkillCell_PC(parent,skillID)
    end
    return PlayerSkill.CreateSkillCell_Phone(parent,skillID)
end

function PlayerSkill.RegisterNodeMovable(skillID, deleteChange)
    local skillMoveMain = (tonumber(SL:GetValue("GAME_DATA", "skill_move_main")) or 1) == 1 
    local skillKey = SL:GetValue("SKILL_KEY", skillID)
    if skillKey ~= 0 and skillMoveMain then
        if GUI:Win_IsNull(PlayerSkill._moveIconCells[skillID]) then
            PlayerSkill._moveIconCells[skillID] = PlayerSkill._cells[skillID].Image_icon

            local param = {}
            param.nodeFrom = GUIDefine.ItemFrom.SKILL_WIN
            param.moveNode = PlayerSkill._moveIconCells[skillID]
            param.skillId  = skillID

            param.cancelMoveCall = function()
                if PlayerSkill._moveIconCells[skillID] and not tolua.isnull(PlayerSkill._moveIconCells[skillID]) then
                    PlayerSkill._moveIconCells[skillID]._movingState = false
                end
            end
            PlayerSkill._moveIconCells[skillID]:setTouchEnabled(true)
            GUI:RegisterNodeMovaEvent(PlayerSkill._moveIconCells[skillID], param)
        end
    else
        if PlayerSkill._moveIconCells[skillID] and not deleteChange then
            PlayerSkill._moveIconCells[skillID] = nil
            SL:onLUAEvent(LUA_EVENT_SKILL_DEL_TO_UI_WIN32, {skill = skillID})
        end
    end
end

PlayerSkill.main()