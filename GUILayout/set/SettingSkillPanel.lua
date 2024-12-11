SettingSkillPanel = {}

function SettingSkillPanel.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.SettingSkillPanelGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "set/setting_auto_skill_panel")
    SettingSkillPanel._ui = GUI:ui_delegate(parent)
    SettingSkillPanel._parent = parent
    if not SettingSkillPanel._ui then
        return false
    end
    SettingSkillPanel.InitUI()
end

function SettingSkillPanel.InitUI(data)
    local ui = SettingSkillPanel._ui
    local panelSize = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local screenWidth = SL:GetValue("SCREEN_WIDTH")
    local screenHeight = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenHeight / 2
    GUI:setPosition(ui.Panel_1, screenWidth/2 - panelSize.width / 2 - 100, posY)
    GUI:addOnClickEvent(ui.Button_close,function()
        UIOperator:CloseSkillPanelUI()
    end)
    GUI:addOnClickEvent(ui.Panel_cancel,function()
        UIOperator:CloseSkillPanelUI()
    end)
    local skills = SL:GetValue("SKILL_INFO_FILTER", -1, 3, true, true)
    for k, v in pairs(skills) do
        if v.MagicID ~= 22 and SL:GetValue("SKILL_IS_ACTIVE", v.MagicID) then ----主动技能 排除火墙 
            SettingSkillPanel.AddItem(v)
        end
    end
end

function SettingSkillPanel.CreateItem(parent, skill)
    -- Create Panel_item
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. skill.MagicID, 11.76, 185.31, 314, 50, false)
    GUI:setTouchEnabled(Panel_item, true)

    -- Create Image_name
    local Image_name = GUI:Image_Create(Panel_item, "Image_name", 6.28, 24.62, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_name, 33, 33, 9, 9)
    GUI:setContentSize(Image_name, 170, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_name, false)
    GUI:setAnchorPoint(Image_name, 0, 0.5)
    GUI:setTouchEnabled(Image_name, false)

    -- Create Text_SkillName
    local Text_SkillName = GUI:Text_Create(Image_name, "Text_SkillName", 7.62, 15.43, 20, "#ffffff", [[附近怪物名称]])
    GUI:setAnchorPoint(Text_SkillName, 0, 0.5)
    GUI:setTouchEnabled(Text_SkillName, false)
    GUI:Text_enableOutline(Text_SkillName, "#000000", 1)

    -- Create Button_add
    local Button_add = GUI:Button_Create(Panel_item, "Button_add", 282.39, 26.07, "res/private/new_setting/img_add.png")
    GUI:Button_loadTexturePressed(Button_add, "res/private/new_setting/img_add.png")
    GUI:Button_loadTextureDisabled(Button_add, "res/private/new_setting/img_add.png")
    GUI:Button_setScale9Slice(Button_add, 15, 15, 11, 11)
    GUI:setContentSize(Button_add, 31, 32)
    GUI:setIgnoreContentAdaptWithSize(Button_add, false)
    GUI:Button_setTitleText(Button_add, "")
    GUI:Button_setTitleColor(Button_add, "#414146")
    GUI:Button_setTitleFontSize(Button_add, 14)
    GUI:Button_titleDisableOutLine(Button_add)
    GUI:setAnchorPoint(Button_add, 0.5, 0.5)
    GUI:setTouchEnabled(Button_add, true)

    return Panel_item
end

function SettingSkillPanel.AddItem(skill)
    local ui = SettingSkillPanel._ui
    local item = SettingSkillPanel.CreateItem(ui.ListView_1, skill)

    local cell = GUI:ui_delegate(item)
    GUI:Text_setString(cell.Text_SkillName, skill.magicName or "")
    GUI:addOnClickEvent(cell.Button_add, function()
        SL:onLUAEvent(LUA_EVENT_SKILL_RANKDATA_ADD, skill)
    end)
end

SettingSkillPanel.main()