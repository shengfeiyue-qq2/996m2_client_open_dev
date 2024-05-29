SettingProtect = {}

SettingProtect._ui = nil
local group1 = {
    SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT1, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT2, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT3, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_MP_PROTECT4, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT,  -- 红名保护
    SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL,    -- 生命低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT,      -- 复活保护
    SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT_HERO, -- 英雄复活保护
}

local herogroup1 = {
    SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4, -- 生命值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT1, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT2, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT3, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_MP_PROTECT4, -- 魔法值低于多少使用
    SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_LOGINOUT, -- 英雄生命值低于多少自动收回
}

local getConfigFunc = function(group)
    local configs = {}
    local config
    for i, id in ipairs(group) do
        config = SL:GetMetaValue("SETTING_CONFIG", id)
        if config and (config.platform == 0 or config.platform == SL:GetMetaValue("CURRENT_OPERMODE")) then
            if not config.order or  not tonumber(config.order) then
                config.order = 0 
            end
            table.insert(configs, config)
        end
    end
    table.sort(configs, function(a, b)
        return a.order < b.order
    end)
    return configs
end

function SettingProtect.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_protect")

    SettingProtect._ui = GUI:ui_delegate(parent)
    SettingProtect._parent = parent
    if not SettingProtect._ui then
        return false
    end

    SettingProtect.initGroup()
end

function SettingProtect.initGroup()
    local tconfigs = SL:CopyData(group1)
    --英雄系统是否开启
    if SL:GetMetaValue("USEHERO") then
        for i, id in ipairs(herogroup1) do
            table.insert(tconfigs, id)
        end
    end
    local groupConfig = getConfigFunc(tconfigs)

    local ScrollView_1 = SettingProtect._ui.ScrollView_1
    local contentSize = GUI:getContentSize(ScrollView_1)
    local cellW = 343
    local cellH = 54
    local addH = 0
    local y = 0
    for i, config in ipairs(groupConfig) do
        local x = (i - 1) % 2
        y = math.ceil(i / 2)
        if config.id == SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL then
            addH = addH + 10
        elseif config.id == SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT 
        or config.id == SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT_HERO then
            addH = addH - 14
        end
        config.height = y * cellH + addH
        config.width = cellW * x
    end

    local InnerContainerSize = GUI:Size(contentSize.width, y * cellH + addH)
    if InnerContainerSize.height <= contentSize.height then
        InnerContainerSize.height = contentSize.height
    end
    GUI:ScrollView_setInnerContainerSize(ScrollView_1, InnerContainerSize.width, InnerContainerSize.height)

    for i, v in ipairs(groupConfig) do
        local cell = SettingProtect.CreateCell(ScrollView_1, v)
        GUI:setPosition(cell, v.width, InnerContainerSize.height - v.height)
    end
end

function SettingProtect.CreateCell(parent, config)
    local cell
    if config.id == SLDefine.SETTINGID.SETTING_IDX_PK_PROTECT then
        cell = SettingProtect.CreateListClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL then
        cell = SettingProtect.CreateSelectInputClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_LOGINOUT then
        cell = SettingProtect.CreateInput2ClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT  
    or config.id == SLDefine.SETTINGID.SETTING_IDX_REVIVE_PROTECT_HERO then 
        cell = SettingProtect.CreateClickCell(parent, config)
    else
        cell = SettingProtect.CreateClickProgressSelectCell(parent, config)
    end
    return cell
end

--点击的开关
function SettingProtect.CreateClickCell(parent, data)
    -- 
    local Panel_Click = GUI:Layout_Create(parent, "Panel_Click_" .. data.id, 0, 1, 200, 40, false)
    GUI:setTouchEnabled(Panel_Click, true)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Click, "Text_desc", 12, 20, 16, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    --选择容器
    local CheckBox_able = GUI:Layout_Create(Panel_Click, "CheckBox_able", 134, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)

    -- 背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)

    --关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)

    --开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)

    --触摸提示
    if data.tips then
        GUI:Text_enableUnderline(Text_desc)
        GUI:setTouchEnabled(Text_desc, true)
        GUI:addOnClickEvent(Text_desc, function()
            local worldPos = GUI:getTouchEndPosition(Text_desc)
            SL:SHOW_DESCTIP(data.tips, nil, worldPos, GUI:p(0, 1))
        end)
    end
    --设置是否开启
    local isOn = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    local enable = isOn == 1
    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)
    --开关点击
    GUI:addOnClickEvent(Panel_Click, function()
        local isOn = SL:GetMetaValue("SETTING_ENABLED", (data.id))
        local enable = isOn == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, enable and { 0 } or { 1 })
        --刷新开关状态
        func(not enable)
    end)

    return Panel_Click
end

function SettingProtect.CreateListClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 200, 40, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 14, 20, 16, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 点击背景
    local Image_ClickBg = GUI:Image_Create(Panel_Layout, "Image_ClickBg", 128, 18, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_ClickBg, 33, 33, 9, 9)
    GUI:setContentSize(Image_ClickBg, 77, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_ClickBg, false)
    GUI:setAnchorPoint(Image_ClickBg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_ClickBg, true)

    -- 列表配置
    local Text_desc_2 = GUI:Text_Create(Image_ClickBg, "Text_desc_2", 39, 16, 18, "#109c18", "列表配置")
    GUI:setAnchorPoint(Text_desc_2, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc_2, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 174, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_bg = GUI:Image_Create(CheckBox_able, "Image_bg", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg, false)

    -- 关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_1, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10.28, 8.78, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- 开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_2, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 9, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1

    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)

    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新开关状态
        func(not enable)
    end)

    GUI:addOnClickEvent(Image_ClickBg, function()
        --打开保护设置
        SL:OpenProtectSettingUI(data)
    end)
    return Panel_Layout
end

function SettingProtect.CreateSelectInputClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, -0, 0, 323, 64, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 6, 32, 16, "#ffffff", [[生命值低于]])
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)
    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 131, 32, 16, "#ffffff", [[%时使用]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.5)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    -- 技能框
    local Image_skill = GUI:Image_Create(Panel_Layout, "Image_skill", 231, 31, "res/public/1900000651.png")
    GUI:setAnchorPoint(Image_skill, 0.5, 0.5)
    GUI:setTouchEnabled(Image_skill, false)

    -- 无
    local Text_empty = GUI:Text_Create(Panel_Layout, "Text_empty", 231, 34, 16, "#ffffff", [[无]])
    GUI:setAnchorPoint(Text_empty, 0.5, 0.5)
    GUI:setTouchEnabled(Text_empty, false)
    GUI:Text_enableOutline(Text_empty, "#000000", 1)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 109, 31, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 30, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 270, 32, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_1, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- 开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_2, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)


    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1
    local percent = values[2] or 20
    local skillID = values[3]
    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)

    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新开关状态
        func(not enable)
    end)

    if skillID and skillID ~= -1 then
        local contentSize = GUI:getContentSize(Image_skill)
        local skillItem = GUI:CreateSkillItem(Image_skill, skillID)
        GUI:setPosition(skillItem, contentSize.width / 2, contentSize.height / 2)
        GUI:setTouchEnabled(skillItem, false)
        GUI:setScale(skillItem, 0.9)
        GUI:setVisible(Text_empty, false)
    end

    -- 
    GUI:setTouchEnabled(Image_skill, true)
    GUI:addOnClickEvent(Image_skill, function()
        SettingProtect.ShowSelectSkill(data)
    end)

    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 0, 0, 30, 26, 14)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 2)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, percent)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local input    = math.min(math.max(tonumber(GUI:TextInput_getString(TextField_input)) or 1, 1), 99)
            SL:SetMetaValue("SETTING_VALUE", data.id, {nil, input })
        end
    end)
    return Panel_Layout
end

--显示选择技能
function SettingProtect.ShowSelectSkill(data)
    local items    = {}
    if data.id == SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL then
        -- 道士 治疗技能
        items = SL:GetMetaValue("SKILL_INFO_FILTER", 3, 3, true)
    end
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)
    if not next(items) then
        SL:ShowSystemTips(GET_STRING(30052303))
        return nil
    end

    -- 背景底框
    local Panel_1 = GUI:Layout_Create(SettingProtect._parent, "Panel_SelectSkill", 0, 0, 732, 445, false)
    GUI:Layout_setBackGroundColorType(Panel_1, 1)
    GUI:Layout_setBackGroundColor(Panel_1, "#000000")
    GUI:Layout_setBackGroundColorOpacity(Panel_1, 127)
    GUI:setTouchEnabled(Panel_1, true)

    -- 底框
    local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 366, 222.5, 360, 280, false)
    GUI:setAnchorPoint(Panel_2, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_2, true)

    -- 背景图
    local Image_1 = GUI:Image_Create(Panel_2, "Image_1", 180, 140, "res/public/1900000677.png")
    GUI:Image_setScale9Slice(Image_1, 21, 21, 34, 32)
    GUI:setContentSize(Image_1, 360, 280)
    GUI:setIgnoreContentAdaptWithSize(Image_1, false)
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)
    GUI:setTouchEnabled(Image_1, false)

    --  ListView
    local ListView = GUI:ListView_Create(Panel_2, "ListView", 180, 140, 355, 275, 1)
    GUI:ListView_setGravity(ListView, 0)
    GUI:setAnchorPoint(ListView, 0.5, 0.5)
    GUI:setTouchEnabled(ListView, true)

    GUI:addOnClickEvent(Panel_1, function()
        GUI:removeFromParent(Panel_1)
    end)


    for i, v in ipairs(items) do
        local item    = {}
        item.skill    = v
        item.setting = data
        item.callback = function()
            GUI:removeFromParent(Panel_1)
        end
        local cell = SettingProtect.CreateSelectSkillCell(ListView, item)
        GUI:ListView_doLayout(ListView)
    end
end

--创建 技能描述item
function SettingProtect.CreateSelectSkillCell(parent, data)
    -- 容器
    local Panel_item = GUI:Layout_Create(parent, "Panel_" .. data.skill.MagicID, 0, 0, 355, 80, false)
    GUI:setTouchEnabled(Panel_item, true)

    -- 技能框
    local Image_skill = GUI:Image_Create(Panel_item, "Image_skill", 40, 40, "res/public/1900000651.png")
    GUI:setAnchorPoint(Image_skill, 0.5, 0.5)
    GUI:setTouchEnabled(Image_skill, false)

    -- 描述
    local Node_desc = GUI:Node_Create(Panel_item, "Node_desc", 80, 40)
    GUI:setAnchorPoint(Node_desc, 0.5, 0.5)

    -- 线条
    local Image_2 = GUI:Image_Create(Panel_item, "Image_2", 177.5, 0, "res/public/1900000667.png")
    GUI:setContentSize(Image_2, 355, 2)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0)
    GUI:setTouchEnabled(Image_2, false)

    if data.skill.MagicID == -1 then
        local size = GUI:getContentSize(Panel_item)
        local RichText_empty = GUI:RichText_Create(Panel_item, "RichText_empty", size.width / 2, size.height / 2, "无")
        GUI:setAnchorPoint(RichText_empty, 0.5, 0.5)
        GUI:setVisible(Image_skill, false)
    else
        local contentSize = GUI:getContentSize(Image_skill)
        local skillItem = GUI:CreateSkillItem(Image_skill, data.skill.MagicID)
        GUI:setPosition(skillItem, contentSize.width / 2, contentSize.height / 2)
        GUI:setTouchEnabled(skillItem, false)
        GUI:setScale(skillItem, 0.9)

        GUI:removeAllChildren(Node_desc)
        local RichText_desc = GUI:RichTextFCOLOR_Create(Node_desc, "RichText_desc", 0, 0, data.skill.desc, 2013)
        GUI:setAnchorPoint(RichText_desc, 0, 0.5)
    end
    GUI:addOnClickEvent(Panel_item, function()
        local tgroupID
        if data.setting.id == SLDefine.SETTINGID.SETTING_IDX_HP_LOW_USE_SKILL then
            tgroupID = data.skill.skillgroup
            SL:SetMetaValue("SETTING_VALUE", data.setting.id, {nil, nil, tgroupID })
        end

        local panel = SettingProtect._ui["Panel_" .. data.setting.id]
        local Image_skill = GUI:getChildByName(panel, "Image_skill")
        GUI:removeAllChildren(Image_skill)
        local Text_empty = GUI:getChildByName(panel, "Text_empty")

        if tgroupID then
            local contentSize = GUI:getContentSize(Image_skill)
            local skillItem = GUI:CreateSkillItem(Image_skill, tgroupID)
            GUI:setPosition(skillItem, contentSize.width / 2, contentSize.height / 2)
            GUI:setTouchEnabled(skillItem, false)
            GUI:setScale(skillItem, 0.9)
            GUI:setVisible(Text_empty, false)
        else
            GUI:setVisible(Text_empty, true)
        end
        data.callback()
    end)
    return Panel_item
end

function SettingProtect.CreateInput2ClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 346, 54, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 14, 27, 16, "#ffffff", "英雄生命低于")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 160, 27, 16, "#ffffff", "%时自动收回")
    GUI:setAnchorPoint(Text_desc_0, 0, 0.5)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:setTag(Text_desc_0, 332)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 135, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 9, 9, 9, 9)
    GUI:setContentSize(Image_2, 28, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 260, 26, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)
    GUI:setTag(CheckBox_able, 42)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_1, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10.28, 8.78, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- 开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_2, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33.28, 8.78, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1
    local count = values[2] or 0
    --输入框
    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 12, 15, 24, 24, 14)
    GUI:setAnchorPoint(TextField_input, 0.5, 0.5)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 3)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, count)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local count = GUI:TextInput_getString(TextField_input)
            if count ~= "" then
                count = tonumber(count) or 0
                count = math.max(math.min(100, count), 0)
                GUI:TextInput_setString(TextField_input, count)
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, count })
            end
        end
    end)

    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)

    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新开关状态
        func(not enable)
    end)

    return Panel_Layout
end

function SettingProtect.CreateClickProgressSelectCell(parent, data)

    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1
    local percent = values[2] or 50
    local t        = values[3]

    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 343, 54, false)
    GUI:setTouchEnabled(Panel_Layout, false)
    Panel_Layout.config = data

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 8, 20, 28, 28, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 14, 14, "res/private/new_setting/clickbg2.png")
    GUI:Image_setScale9Slice(Image_5, 9, 9, 5, 5)
    GUI:setContentSize(Image_5, 18, 18)
    GUI:setIgnoreContentAdaptWithSize(Image_5, false)
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 开关
    local Image_sel = GUI:Image_Create(CheckBox_able, "Image_sel", 14, 14, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_sel, 0.5, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 152, 41, 16, "#ffffff", string.format(data.content, percent) or "")
    GUI:setAnchorPoint(Text_desc, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    -- 滑动条
    local Slider_progress = GUI:Slider_Create(Panel_Layout, "Slider_progress", 154, 20, "res/private/new_setting/bg_progress.png", "res/private/new_setting/bg_progress2.png", "res/private/new_setting/icon_xdtzy_17.png")
    GUI:setContentSize(Slider_progress, 228, 14)
    GUI:setIgnoreContentAdaptWithSize(Slider_progress, false)
    GUI:Slider_setPercent(Slider_progress, 50)
    GUI:setAnchorPoint(Slider_progress, 0.5, 0.5)
    GUI:setTouchEnabled(Slider_progress, true)

    -- 配置背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 307, 20, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 59, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, true)

    -- 配置
    local Text_desc_0 = GUI:Text_Create(Image_2, "Text_desc_0", 28, 14, 18, "#109c18", [[配置]])
    GUI:setAnchorPoint(Text_desc_0, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#111111", 1)

    GUI:setVisible(Image_sel, enable)
    GUI:Slider_setPercent(Slider_progress, percent)
    local progressBarPath = ""
    local progressSlidBallPath = ""
    --红条
    if data.id == SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT1
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT2
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT3
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HP_PROTECT4
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT1
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT2
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT3
    or data.id == SLDefine.SETTINGID.SETTING_IDX_HERO_HP_PROTECT4 then
        progressBarPath = SLDefine.PATH_RES_PRIVATE .. "new_setting/bg_progress3.png"
        progressSlidBallPath = SLDefine.PATH_RES_PRIVATE .. "new_setting/hpbar.png"

    else --蓝条
        progressBarPath = SLDefine.PATH_RES_PRIVATE .. "new_setting/bg_progress4.png"
        progressSlidBallPath = SLDefine.PATH_RES_PRIVATE .. "new_setting/mpbar.png"
    end
    GUI:Slider_loadProgressBarTexture(Slider_progress, progressBarPath)
    GUI:Slider_loadSlidBallTextureNormal(Slider_progress, progressSlidBallPath)

    GUI:Slider_addOnEvent(Slider_progress, function(_, eventType)
        if eventType == 0 then
            local newValue = GUI:Slider_getPercent(Slider_progress)
            local values = SL:GetMetaValue("SETTING_VALUE", data.id)
            local percent = values[2] or 50
            if math.abs(newValue - percent) >= 1 then
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, newValue })
                GUI:Text_setString(Text_desc,string.format(data.content, newValue))
            end
        end
    end)

    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新ui
        GUI:setVisible(Image_sel, not enable)
    end)
    GUI:addOnClickEvent(Image_2, function()
        SL:OpenProtectSettingUI(data)
    end)
    return Panel_Layout
end