MainSkill = {}

MainSkill.imagePath = {     -- 快速查找图标资源 1 玩家 2 怪物 3 英雄
    [1] = {
        normal = "res/private/main/Skill/1900012706.png",
        bright = "res/private/main/Skill/1900012707.png"
    },
    [2] = {
        normal = "res/private/main/Skill/1900012704.png",
        bright = "res/private/main/Skill/1900012705.png"
    },
    [3] = {
        normal = "res/private/main/Skill/1900012710.png",
        bright = "res/private/main/Skill/1900012711.png"
    },
}

MainSkill.skillSfx =  {     -- 技能特效 press:按下 select:选择/开启
    press = 4001,
    select = 4005,
    mainPress = 4002
}

function MainSkill.main()
    local parent = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 技能模块
    local Panel_skill = GUI:Layout_Create(parent, "Panel_skill", 0, 0, 320, 260)
    GUI:setAnchorPoint(Panel_skill, 1, 0)

    local Node_skill_1 = GUI:Node_Create(Panel_skill, "Node_skill_1", 241, 86.5)

    local Node_skill_2 = GUI:Node_Create(Panel_skill, "Node_skill_2", 130, 31.5)

    local Node_skill_3 = GUI:Node_Create(Panel_skill, "Node_skill_3", 142.5, 109)

    local Node_skill_4 = GUI:Node_Create(Panel_skill, "Node_skill_4", 186, 177.5)

    local Node_skill_5 = GUI:Node_Create(Panel_skill, "Node_skill_5", 260, 212)

    local Node_skill_6 = GUI:Node_Create(Panel_skill, "Node_skill_6", 51, 41.5)

    local Node_skill_7 = GUI:Node_Create(Panel_skill, "Node_skill_7", 62, 114)

    local Node_skill_8 = GUI:Node_Create(Panel_skill, "Node_skill_8", 93, 183.5)

    local Node_skill_9 = GUI:Node_Create(Panel_skill, "Node_skill_9", 147, 243.5)

    local Panel_quick_find = GUI:Layout_Create(Panel_skill, "Panel_quick_find", 240, 85, 120, 120)
    GUI:setAnchorPoint(Panel_quick_find, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_find, true)

    local Image_player = GUI:Image_Create(Panel_quick_find, "Image_player", 120, 120, "res/private/main/Skill/1900012706.png")
    GUI:setAnchorPoint(Image_player, 1, 1)
    
    local Image_monster = GUI:Image_Create(Panel_quick_find, "Image_monster", 0, 0, "res/private/main/Skill/1900012704.png")
    GUI:setAnchorPoint(Image_monster, 0, 0)

    local Image_hero = GUI:Image_Create(Panel_quick_find, "Image_hero", 0, 120, "res/private/main/Skill/1900012710.png")
    GUI:setAnchorPoint(Image_hero, 0, 1)

    local Button_attack = GUI:Button_Create(Panel_skill, "Button_attack", 320, 0, "res/private/main/Skill/icon_sifud_02.png")
    GUI:setAnchorPoint(Button_attack, 1, 0)
    GUI:Button_loadTexturePressed(Button_attack, "res/private/main/Skill/icon_sifud_03.png")

    local Panel_hide = GUI:Layout_Create(parent, "Panel_hide", 0, 0, screenW, screenH)
    GUI:setAnchorPoint(Panel_hide, 1, 0)
    GUI:setTouchEnabled(Panel_hide, true)

    -- 按钮模块
    local Panel_button = GUI:Layout_Create(parent, "Panel_button", 0, 0, 225, 355)
    GUI:setAnchorPoint(Panel_button, 1, 0)

    local Panel_constant = GUI:Layout_Create(Panel_button, "Panel_constant", 225, 355, 225, 70)
    GUI:setAnchorPoint(Panel_constant, 1, 1)

    local Button_change = GUI:Button_Create(Panel_constant, "Button_change", 225, 35, "res/private/main/bottom/1900012580.png")
    GUI:setAnchorPoint(Button_change, 1, 0.5)
    GUI:Button_loadTexturePressed(Button_change, "res/private/main/bottom/1900012580.png")

    local Image_change_act = GUI:Image_Create(Button_change, "Image_change_act", 30, 33, "res/private/main/bottom/1900012538.png")
    GUI:setAnchorPoint(Image_change_act, 0.5, 0.5)
    
    local Panel_active = GUI:Layout_Create(Panel_button, "Panel_active", 0, 285, 225, 280)
    GUI:setAnchorPoint(Panel_active, 0, 1)
    -- 按钮添加到Panel_active 

    -- 拾取按钮
    local Button_pick = GUI:Button_Create(parent, "Button_pick", -160, 320, "res/private/main/Skill/btn_zhijiemian_05.png")
    GUI:setAnchorPoint(Button_pick, 0.5, 0.5)
    GUI:Button_loadTextureDisabled(Button_pick,"res/private/main/Skill/btn_zhijiemian_06.png")

    -- 英雄合击技能节点
    local Node_hj_skill = GUI:Node_Create(parent, "Node_hj_skill", -345, 244)
    
end

function MainSkill.createSkillCell(parent)
    if not parent then
        return
    end
    local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0, 0, 65, 65)
    GUI:setAnchorPoint(Panel_bg, 0.5, 0.5)

    local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 32.5, 32.5, "res/private/main/Skill/1900012017.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)

    local skill_icon = GUI:Button_Create(Panel_bg, "skill_icon", 32.5, 32.5, "res/private/main/Skill/1900012017.png")
    GUI:setAnchorPoint(skill_icon, 0.5, 0.5)

    local Node_select = GUI:Node_Create(Panel_bg, "Node_select", 32.5, 32.5)
    local Node_on = GUI:Node_Create(Panel_bg, "Node_on", 32.5, 32.5)

    MainSkill.cdImagePath =  "res/private/main/Skill/bg_lsxljm_05.png"
    MainSkill.sfxScale = {0.9, 0.6} -- {主技能， 其他} 特效缩放比例
    MainSkill.skillIconSize = {{width = 75, height = 75}, {width = 55, height = 55}}  -- {主技能， 其他} 技能图标大小
    MainSkill.skillKey1Bg = "res/private/main/Skill/1900012018.png"
end

function MainSkill.createHeroSkillCell( parent )
    if not parent then
        return
    end
    local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0, 0, 65, 65)

    local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", 32.5, 39, "res/private/main/bg_hejidj_01.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)

    local Image_progress = GUI:Image_Create(Panel_bg, "Image_progress", 32.5, 32, "res/private/main/bg_hejidj_02.png")
    GUI:setAnchorPoint(Image_progress, 0.5, 0.5)

    local Button_icon = GUI:Button_Create(Panel_bg, "Button_icon", 32.5, 32.5, "res/private/main/bg_hejidj_01.png")
    GUI:setAnchorPoint(Button_icon, 0.5, 0.5)
    GUI:setContentSize(Button_icon, {width = 60, height = 60})

    -- 特效节点
    local Node_sfx = GUI:Node_Create(Panel_bg, "Node_sfx", 32.5, 32.5)

    MainSkill.heroSfxParam = {7222, -48, 38}  -- {合击技能特效id, 坐标X, 坐标Y}
end