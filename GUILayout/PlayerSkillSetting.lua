PlayerSkillSetting = {}

function PlayerSkillSetting.main()
    local parent = GUI:Attach_Parent()

    GUI:LoadExport(parent, "skill_setting/skill_setting")

    PlayerSkillSetting._ui = GUI:ui_delegate(parent)

    local CloseLayout = PlayerSkillSetting._ui["CloseLayout"]
    local FrameLayout = PlayerSkillSetting._ui["FrameLayout"]
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:setPosition(FrameLayout, winSizeW / 2, winSizeH / 2)

    -- 全屏关闭
    GUI:setVisible(CloseLayout, true)
    GUI:addOnClickEvent(CloseLayout, function()
        GUI:Win_Close(parent)
    end)

    GUI:addOnClickEvent(PlayerSkillSetting._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    PlayerSkillSetting.InitSkillUI()

    GUI:Text_setString(PlayerSkillSetting._ui.TitleText, "技能设置")
end

function PlayerSkillSetting.InitSkillUI()
    for i = 1, 9 do
        local imageBG = GUI:getChildByName(PlayerSkillSetting._ui["Panel_shortcut"], string.format("Image_skill_%s", i))
        local str_index = i > 1 and i - 1 or ""
        GUI:Text_Create(imageBG, "textIndex", 0, 55, 16, "#ffffff", str_index)
    end
end

function PlayerSkillSetting.CreateSkillCell(parent, skillID)
    local item = GUI:Widget_Create(parent, "item" .. skillID, 0, 0)
    GUI:LoadExport(item, "skill_setting/skill_setting_cell")
    local cell = GUI:getChildByName(item, "Panel_cell")
    local quickUI = GUI:ui_delegate(cell)

    -- icon
    local path = SL:GetMetaValue("SKILL_ICON_PATH", skillID)
    local ui_icon = GUI:getChildByName(cell, "Image_icon")
    GUI:Image_loadTexture(ui_icon, path)
    GUI:setContentSize(ui_icon, 65, 65)

    -- sfx
    local ui_skillBg = GUI:getChildByName(cell, "Image_skill_bg")
    local contentSize = GUI:getContentSize(ui_skillBg)
    local sfx = GUI:Effect_Create(ui_skillBg, "sfx", contentSize.width / 2, contentSize.height / 2, 0, 4004)
    GUI:setVisible(sfx, false)

    -- name
    local ui_text = GUI:getChildByName(cell, "Text_name")
    local skillName = SL:GetMetaValue("SKILL_NAME", skillID)
    GUI:Text_setString(ui_text, skillName)

    -- 点击
    GUI:addOnClickEvent(cell, function()
        PlayerSkillSetting.SelectSkill(skillID)
    end)

    return {
        skillID = skillID,
        quickUI = quickUI
    }
end