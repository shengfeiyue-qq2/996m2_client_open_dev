HeroSkill = {}

local isPC = SL:GetValue("IS_PC_OPER_MODE")

-- 技能图标尺寸
local iconSize = isPC and {width = 40, height = 40} or {width = 55, height = 55}

function HeroSkill.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_skill_node_win32" or "hero/hero_skill_node")

    HeroSkill._index = 0--添加的技能条编号
    HeroSkill._ui = GUI:ui_delegate(parent)
    if not HeroSkill._ui then
        return false
    end

    if isPC then
        GUI:ListView_addMouseScrollPercent(HeroSkill._ui["ListView_cells"])
    end
    
    HeroSkill.UpdateSkillListView()

    GUI:RefPosByParent(parent)

    HeroSkill.RegistEvent()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerSkill_hero})
end

-- 界面关闭回调
function HeroSkill.OnClose()
    HeroSkill.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerSkill_hero
    })
end

function HeroSkill.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_ADD, "HeroSkill", HeroSkill.OnSkillAdd)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_DEL, "HeroSkill", HeroSkill.OnSkillDel)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_UPDATE, "HeroSkill", HeroSkill.OnSkillUpdate)
end

-- 取消事件
function HeroSkill.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SKILL_ADD, "HeroSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SKILL_DEL, "HeroSkill")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SKILL_UPDATE, "HeroSkill")
end

function HeroSkill.OnSkillAdd()
    HeroSkill.UpdateSkillListView()
end

function HeroSkill.OnSkillDel()
    HeroSkill.UpdateSkillListView()
end

function HeroSkill.OnSkillUpdate(data)
    HeroSkill.UpdateSkillCell(data.skillID)
end

function HeroSkill.UpdateSkillListView()
    GUI:ListView_removeAllItems(HeroSkill._ui["ListView_cells"])
    HeroSkill._cells = {}

    -- 已学的技能排除普攻
    local items = SL:CopyData(SL:GetValue("H.LEARNED_SKILLS", true))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = HeroSkill.CreateSkillCell(HeroSkill._ui["ListView_cells"], skillID)
        HeroSkill._cells[skillID] = cell
    end

    for k, v in pairs(HeroSkill._cells) do
        HeroSkill.UpdateSkillCell(k)
    end
end

function HeroSkill.UpdateSkillCell(skillID)
    local cell = HeroSkill._cells[skillID]
    if not cell then
        return
    end

    local skill =  SL:GetValue("H.SKILL_DATA", skillID) 
    if not skill then
        return
    end
    -- icon
    local Image_icon = cell["Image_icon"]

    local contentSize = GUI:getContentSize(Image_icon)
    local iconPath = SL:GetValue("H.SKILL_RECT_ICON_PATH", skillID) 
    GUI:removeAllChildren(Image_icon)
    local imageICON = GUI:Image_Create(Image_icon, "rectSkillIcon_"..skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON,0.5,0.5)
    GUI:setContentSize(imageICON, iconSize)

    -- 熟练度 等级
    local strTrain = SL:GetValue("H.SKILL_TRAIN_DATA", skillID) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, skill.Level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

    local btnOffon = cell.btnOffon
    GUI:addOnClickEvent(btnOffon,function()
        local state = SL:GetValue("H.SKILL_KEY", skillID) == 0 and 1 or 0
        HeroSkill.SetButtonTexture(btnOffon, state)
        HeroSkill.SetNormal_Gray(cell, state)
        SL:SetValue("H.SKILL_KEY", skillID, state)
    end)

    local state = SL:GetValue("H.SKILL_KEY", skillID) 
    HeroSkill.SetNormal_Gray(cell, state)

    HeroSkill.SetButtonTexture(btnOffon, state)
end

function HeroSkill.SetNormal_Gray(cell, state)
    for k, v in pairs(cell) do
        GUI:setGrey(v, state == 1)
    end
end

function HeroSkill.SetButtonTexture(btn, state)
    local pic = string.format("%s%s", GUIDefine.PATH_RES_PRIVATE, state == 0 and "player_hero/btn_on.png" or "player_hero/btn_off.png")
    GUI:Button_loadTextures(btn, pic, pic)
    GUI:setIgnoreContentAdaptWithSize(btn, true)
end

function HeroSkill.CreateSkillCell_Phone(parent, skillID)
    HeroSkill._index = HeroSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..HeroSkill._index, 0, 0, 348, 70)
    GUI:LoadExport(widget, "hero/skill_cell")
    local ui = GUI:ui_delegate(widget)

    local config = SL:GetValue("SKILL_CONFIG", skillID) 
    local name = SL:GetValue("H.SKILL_NAME", skillID) 
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

function HeroSkill.CreateSkillCell_PC(parent, skillID)
    HeroSkill._index = HeroSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..HeroSkill._index, 0, 0, 272, 50)
    GUI:setTouchEnabled(widget,true)
    GUI:LoadExport(widget, "hero/skill_cell_win32")
    local ui = GUI:ui_delegate(widget)

    GUI:setSwallowTouches(ui["Panel_skill_cell"],false)
    
    local config = SL:GetValue("SKILL_CONFIG", skillID) 
    local name = SL:GetValue("H.SKILL_NAME", skillID) 
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

function HeroSkill.CreateSkillCell(parent, skillID)
    if isPC then
        return HeroSkill.CreateSkillCell_PC(parent,skillID)
    end
    return HeroSkill.CreateSkillCell_Phone(parent,skillID)
end

HeroSkill.main()