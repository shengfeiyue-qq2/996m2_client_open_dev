HeroSkill = {} --英雄面板 技能
HeroSkill._ui = nil

function HeroSkill.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_skill_node")
    HeroSkill._index = 0--添加的技能条编号
    HeroSkill._ui = GUI:ui_delegate(parent)
    HeroSkill._parent = parent
    if not HeroSkill._ui then
        return false
    end
    GUI:setVisible(HeroSkill._ui.Button_setting,false)
    HeroSkill.UpdateSkillCells()
    return true
end

function HeroSkill.UpdateSkillCells()
    GUI:ListView_removeAllItems(HeroSkill._ui.ListView_cells)
    HeroSkill._cells = {}
    HeroSkill._is_update_all = true
    --已学的技能排除普攻
    local items = SL:CopyData(SL:GetMetaValue("H.LEARNED_SKILLS", true))
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)

    for i, v in ipairs(items) do
        local skillID = v.MagicID
        local cell = HeroSkill.CreateSkillCell(HeroSkill._ui.ListView_cells, skillID)
        HeroSkill._cells[skillID] = cell
    end

    for k, v in pairs(HeroSkill._cells) do
        HeroSkill.UpdateSkillCell(k)
    end
    HeroSkill._is_update_all = false
end

function HeroSkill.RefreshSkillCells(...)
    for k, v in pairs(HeroSkill._cells) do
        HeroSkill.UpdateSkillCell(k)
    end
end

function HeroSkill.UpdateSkillCell(skillID)
    local cell = HeroSkill._cells[skillID]
    if not cell then
        return
    end
    HeroSkill._is_update_all = true

    local skill = SL:GetMetaValue("H.SKILL_DATA", skillID) 
    if not skill then
        return
    end
    -- icon
    local contentSize = GUI:getContentSize(cell.Image_icon)
    local iconPath = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID) 
    GUI:removeAllChildren(cell.Image_icon)
    local imageICON = GUI:Image_Create(cell.Image_icon, "rectSkillIcon_"..skillID, contentSize.width / 2, contentSize.height / 2, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON, false)
    GUI:setAnchorPoint(imageICON,0.5,0.5)
    GUI:setContentSize(imageICON, 55, 55)
    GUI:setTouchEnabled(imageICON, true)
    local state = SL:GetMetaValue("H.SKILL_KEY", skillID) 
    local level = skill.Level
    HeroSkill.setNormal_Gray(cell.Panel_skill_cell, state)
    
    --熟练度 等级
    local strTrain = SL:GetMetaValue("H.SKILL_TRAIN_DATA", skillID) 
    GUI:Text_setString(cell.Text_skillTrain, strTrain)
    GUI:Text_setString(cell.Text_skillLevel, level)
    GUI:Text_setString(cell.Text_levelup, string.format("强化%s重", SL:NumberToChinese(skill.LevelUp)))

    -----
    local panel = GUI:getParent(cell.Text_skillName)
    local btn1 = GUI:getChildByName(panel,"text_onoff")
    if not btn1 then
        btn1 = GUI:Button_Create(panel,"text_onoff", 300, 40,"")
        GUI:setAnchorPoint(btn1, 0.5, 0.5)
        local img = GUI:Image_Create(btn1,"_Image_", 0, 0, "")
        GUI:setAnchorPoint(img, 0.5, 0.5)
        GUI:addOnClickEvent(btn1,function()
            local state = SL:GetMetaValue("H.SKILL_KEY", skillID) 
            state = state == 0 and 1 or 0
            HeroSkill.setButton(btn1, state)
            HeroSkill.setNormal_Gray(cell.Panel_skill_cell ,state)
            SL:SetMetaValue("H.SKILL_KEY", skillID, state)
        end)
    end
    HeroSkill.setButton(btn1,state)
    ----
    GUI:setVisible(cell.Image_1, skill.LevelUp <= 0)
    GUI:setVisible(cell.Image_2, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillTrain, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_skillLevel, skill.LevelUp <= 0)
    GUI:setVisible(cell.Text_levelup, skill.LevelUp > 0)

    if HeroSkill._is_update_all then
        GUI:setPositionX(cell.Image_1, GUI:getPositionX(cell.Image_1)+50)
        GUI:setPositionX(cell.Text_skillLevel,GUI:getPositionX(cell.Text_skillLevel)+50)
    end
end

function HeroSkill.setButton(node,state)
    local on_texture = SLDefine.PATH_RES_PRIVATE.."player_hero/bg_jnkan_02.png"
    local off_texture =  SLDefine.PATH_RES_PRIVATE.."player_hero/bg_jnkan_01.png"
    local texture = state == 0 and on_texture or off_texture
    GUI:Button_loadTextures(node,texture,texture)
    GUI:setIgnoreContentAdaptWithSize(node, true)
    local img = GUI:getChildByName(node,"_Image_")
    local on_texture2 = SLDefine.PATH_RES_PRIVATE.."player_hero/btn_jnkan_02.png"
    local off_texture2 =  SLDefine.PATH_RES_PRIVATE.."player_hero/btn_jnkan_01.png"
    local texture2 = state == 0 and on_texture2 or off_texture2
    GUI:Image_loadTexture(img, texture2)
    local pos = state == 0 and GUI:p(42,11) or GUI:p(12,11)
    GUI:setPosition(img,pos.x,pos.y)
end

function HeroSkill.setNormal_Gray(node,state)
    if not node then
        return 
    end 
    local t = GUI:getChildren(node)
    for i,v in ipairs(t) do
        if state == 1 then
            GUI:setGrey(v,true)
        else
            GUI:setGrey(v,false)
        end
        HeroSkill.setNormal_Gray(v,state)
    end
    
end

function HeroSkill.CreateSkillCell(parent,skillID)
    HeroSkill._index = HeroSkill._index + 1
    local widget = GUI:Widget_Create(parent, "SkillItems_"..HeroSkill._index, 0, 0, 348, 70)
    GUI:LoadExport(widget, "hero/skill_cell")
    local ui =  GUI:ui_delegate(widget)

    local config = SL:GetMetaValue("SKILL_CONFIG", skillID) 
    local name = SL:GetMetaValue("H.SKILL_NAME", skillID) 
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

return HeroSkill