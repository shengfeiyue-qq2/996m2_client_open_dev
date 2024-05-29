SettingAuto = {}

SettingAuto._ui = nil
local group1 = {
    SLDefine.SETTINGID.SETTING_IDX_BEDAMAGED_PLAYER, -- 被玩家攻击时
    SLDefine.SETTINGID.SETTING_IDX_N_RANGE_NO_PICK, -- N范围内有多少怪 不走去拾取
    SLDefine.SETTINGID.SETTING_IDX_AUTO_GROUPSKILL, -- 群怪技能
    SLDefine.SETTINGID.SETTING_IDX_FIRST_ATTACK_MASTER, -- 受到BB攻击时先打主人
    SLDefine.SETTINGID.SETTING_IDX_AUTO_SIMPSKILL, -- 单体技能
    SLDefine.SETTINGID.SETTING_IDX_NO_ATTACK_HAVE_BELONG, -- 不抢别人归属怪物


}
local group2 = {
    SLDefine.SETTINGID.SETTING_IDX_NO_MONSTAER_USE, -- 多少秒没怪物使用
    SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE, -- 周围有多少敌人时使用
    SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE, -- 周围有多少红名时使用
    SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK, -- 周围有敌人时主动攻击
}
local group3 = {
    SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER -- 忽略怪物
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

function SettingAuto.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_auto_win32")

    SettingAuto._ui = GUI:ui_delegate(parent)
    SettingAuto._parent = parent
    if not SettingAuto._ui then
        return false
    end

    SettingAuto.initGroup()

    SettingAuto.RegisterEvent()
end

function SettingAuto.initGroup()
    local groupConfig = {}
    groupConfig = getConfigFunc(group1)
    local groupConfig2 = {}
    groupConfig2 = getConfigFunc(group2)
    local groupConfig3 = {}
    groupConfig3 = getConfigFunc(group3)

    ---计算大小 
    local cellW = 300
    local cellH = 54
    local configCount = #groupConfig
    local configCount2 = #groupConfig2
    local ScrollView_1 = SettingAuto._ui.ScrollView_1
    local contentSize = GUI:getContentSize(ScrollView_1)
    local InnerContainerSize = GUI:Size(contentSize.width, cellH * (math.ceil(configCount / 2) + configCount2))
    if InnerContainerSize.height <= contentSize.height then
        InnerContainerSize.height = contentSize.height
    end
    GUI:ScrollView_setInnerContainerSize(ScrollView_1, InnerContainerSize.width, InnerContainerSize.height)

    --计算位置
    local maxy = 0
    for i, v in ipairs(groupConfig) do
        local x = (i - 1) % 2
        local y = math.ceil(i / 2)
        maxy = y
        local cell = SettingAuto.CreateCell(ScrollView_1, v)
        GUI:setPosition(cell, cellW * x, InnerContainerSize.height - y * cellH)
    end

    for i, v in ipairs(groupConfig2) do
        local x = 0
        local y = maxy + i
        local cell = SettingAuto.CreateCell(ScrollView_1, v)
        GUI:setPosition(cell, cellW * x, InnerContainerSize.height - y * cellH)
    end

    local height3 = maxy * cellH
    local width3 = 0
    for i, v in ipairs(groupConfig3) do
        local cell = SettingAuto.CreateCell(ScrollView_1, v)
        if v.id == SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER then
            height3 = height3 + 220
            width3 = width3 + 350
        else
            height3 = height3 + cellH
            width3 = width3 + cellW
        end
        GUI:setPosition(cell, width3, InnerContainerSize.height - height3)
    end
end

function SettingAuto.CreateCell(parent, config)
    local cell
    if config.id == SLDefine.SETTINGID.SETTING_IDX_N_RANGE_NO_PICK then
        cell = SettingAuto.CreateInput2ClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_FIRST_ATTACK_MASTER
    or config.id == SLDefine.SETTINGID.SETTING_IDX_NO_ATTACK_HAVE_BELONG then
        cell = SettingAuto.CreateClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_NO_MONSTAER_USE then
        cell = SettingAuto.CreateClickInputListCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE
    or config.id == SLDefine.SETTINGID.SETTING_IDX_RED_BESIEGE_FLEE then
        cell = SettingAuto.CreateClickInput2ListCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_ENEMY_ATTACK then
        cell = SettingAuto.CreateClickInpuCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER then
        cell = SettingAuto.CreateListPanel(parent, config)
    else
        cell = SettingAuto.CreateSelect2Cell(parent, config)
    end
    return cell
end

function SettingAuto.CreateInput2ClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 346, 54, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 4, 27, 12, "#ffffff", [[身边]])
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 62, 27, 12, "#ffffff", [[格有怪时不捡物]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.5)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:setTag(Text_desc_0, 332)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 45, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 9, 9, 9, 9)
    GUI:setContentSize(Image_2, 28, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 150, 28, 44, 18, false)
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
    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 12, 15, 26, 26, 12)
    GUI:setAnchorPoint(TextField_input, 0.5, 0.5)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 2)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, count)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local count = GUI:TextInput_getString(TextField_input)
            if count ~= "" then
                count = tonumber(count) or 0
                count = math.max(math.min(8, count), 0)
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

--点击的开关
function SettingAuto.CreateClickCell(parent, data)
    -- 
    local Panel_Click = GUI:Layout_Create(parent, "Panel_Click_" .. data.id, 0, 1, 235, 40, false)
    GUI:setTouchEnabled(Panel_Click, true)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Click, "Text_desc", 5, 20, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    --开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Click, "CheckBox_able", 150, 19, 44, 18, false)
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
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新开关状态
        func(not enable)
    end)

    return Panel_Click
end

function SettingAuto.CreateClickInputListCell(parent, data)
    --容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 343, 54, false)
    GUI:setTouchEnabled(Panel_Layout, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 8, 27, 34, 36, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 0, 18, "res/private/new_setting/clickbg2.png")
    GUI:Image_setScale9Slice(Image_5, 9, 9, 5, 5)
    GUI:setContentSize(Image_5, 18, 18)
    GUI:setIgnoreContentAdaptWithSize(Image_5, false)
    GUI:setAnchorPoint(Image_5, 0, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 开关
    local Image_sel = GUI:Image_Create(CheckBox_able, "Image_sel", 10, 18, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_sel, 0.5, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 30, 26, 12, "#ffffff", [[寻路]])
    GUI:setAnchorPoint(Text_desc, 0, 0.49)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 100, 26, 12, "#ffffff", [[秒没有怪物时使用]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.49)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    -- 输入框背景
    local Image_bg = GUI:Image_Create(Panel_Layout, "Image_bg", 76, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_bg, 9, 9, 9, 9)
    GUI:setContentSize(Image_bg, 31, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg, false)

    -- 物品名称背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 200, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 100, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0, 0.5)
    GUI:setTouchEnabled(Image_2, true)

    -- 物品名称
    local Text_name = GUI:Text_Create(Image_2, "Text_name", 50, 15, 12, "#109c18", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:setTouchEnabled(Text_name, false)
    GUI:Text_enableOutline(Text_name, "#111111", 1)

    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1--开关
    local count = values[2] or 0 -- 数量
    local index = tonumber(values[3])  --物品index

    --输入框
    local TextField_input = GUI:TextInput_Create(Image_bg, "TextField_input", 13, 14, 29, 26, 12)
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
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, count })
            end
        end
    end)

    --开关设置值
    GUI:setVisible(Image_sel, enable)
    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        GUI:setVisible(Image_sel, not enable)
    end)

    --是否设置了物品
    local refName = function(index)
        if index then
            local name = SL:GetMetaValue("ITEM_NAME", index)
            GUI:Text_setString(Text_name, name or "无")
        else
            GUI:Text_setString(Text_name, "无")
        end
    end
    refName(index)

    --可以设置的物品
    local items = {}
    local indexs = string.split(data.indexs, "#")
    for i, index in ipairs(indexs) do
        local name = SL:GetMetaValue("ITEM_NAME", index)
        table.insert(items, name or "?")
    end
    --点击设置
    GUI:addOnClickEvent(Image_2, function()
        if #items == 0 then
            return
        end
        local func = function(res)
            if res ~= 0 then --选中了对应物品的编号  0是关闭
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, nil, indexs[res] })
                --刷新UI
                refName(indexs[res])
            end
        end
        local size = GUI:getContentSize(Image_2)
        local position = GUI:convertToWorldSpace(Image_2, 0, 0)--初始位置
        --打开 选则下拉框
        SL:OpenSelectListUI(items, position, size.width, size.heigth, func)
    end)

    return Panel_Layout
end

function SettingAuto.CreateClickInput2ListCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 343, 54, false)
    GUI:setTouchEnabled(Panel_Layout, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 8, 28, 34, 36, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 0, 18, "res/private/new_setting/clickbg2.png")
    GUI:Image_setScale9Slice(Image_5, 9, 9, 5, 5)
    GUI:setContentSize(Image_5, 18, 18)
    GUI:setIgnoreContentAdaptWithSize(Image_5, false)
    GUI:setAnchorPoint(Image_5, 0, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 开关
    local Image_sel = GUI:Image_Create(CheckBox_able, "Image_sel", 10, 18, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_sel, 0.5, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 30, 26, 12, "#ffffff", [[周围]])
    GUI:setAnchorPoint(Text_desc, 0, 0.49)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 95, 26, 12, "#ffffff", [[格有]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.49)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    local desc = ""
    if data.id == SLDefine.SETTINGID.SETTING_IDX_BESIEGE_FLEE then --包围逃脱
        desc = "个敌人使用"
    else--红名逃脱
        desc = "个红名使用"
    end
    local Text_desc_0_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0_0", 160, 26, 12, "#ffffff", desc)
    GUI:setAnchorPoint(Text_desc_0_0, 0, 0.49)
    GUI:setTouchEnabled(Text_desc_0_0, false)
    GUI:Text_enableOutline(Text_desc_0_0, "#000000", 1)


    -- 输入框背景1
    local Image_bg = GUI:Image_Create(Panel_Layout, "Image_bg", 76, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_bg, 9, 9, 9, 9)
    GUI:setContentSize(Image_bg, 31, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg, false)

    -- 输入框背景2
    local Image_bg2 = GUI:Image_Create(Panel_Layout, "Image_bg2", 140, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_bg2, 9, 9, 9, 9)
    GUI:setContentSize(Image_bg2, 31, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_bg2, false)
    GUI:setAnchorPoint(Image_bg2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg2, false)

    -- 物品名称背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 225, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 100, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0, 0.5)
    GUI:setTouchEnabled(Image_2, true)

    -- 物品名称
    local Text_name = GUI:Text_Create(Image_2, "Text_name", 50, 15, 12, "#109c18", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:setTouchEnabled(Text_name, false)
    GUI:Text_enableOutline(Text_name, "#111111", 1)

    --设置的值
    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1--开关
    local count = values[2] or 0
    local count2 = values[3] or 0
    local index = tonumber(values[4])--物品index 

    --开关设置值
    GUI:setVisible(Image_sel, enable)
    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        GUI:setVisible(Image_sel, not enable)
    end)

    --输入框1
    local TextField_input = GUI:TextInput_Create(Image_bg, "TextField_input", 15, 14, 26, 26, 12)
    GUI:setAnchorPoint(TextField_input, 0.5, 0.5)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 2)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, count)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local count = GUI:TextInput_getString(TextField_input)
            if count ~= "" then
                count = tonumber(count) or 0
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, count })
            end
        end
    end)
    --输入框2
    local TextField_input2 = GUI:TextInput_Create(Image_bg2, "TextField_input2", 15, 14, 26, 26, 12)
    GUI:setAnchorPoint(TextField_input2, 0.5, 0.5)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input2, 1)
    GUI:TextInput_setMaxLength(TextField_input2, 3)
    GUI:TextInput_setInputMode(TextField_input2, 2)
    GUI:TextInput_setString(TextField_input2, count2)
    GUI:TextInput_addOnEvent(TextField_input2, function(_, eventType)
        if eventType == 1 then
            local count = GUI:TextInput_getString(TextField_input2)
            if count ~= "" then
                count = tonumber(count) or 0
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, nil, count })
            end
        end
    end)

    --是否设置了物品
    local refName = function(index)
        if index then
            local name = SL:GetMetaValue("ITEM_NAME", index)
            GUI:Text_setString(Text_name, name or "无")
        else
            GUI:Text_setString(Text_name, "无")
        end
    end
    refName(index)

    --可以设置的物品
    local items = {}
    local indexs = string.split(data.indexs, "#")
    for i, index in ipairs(indexs) do
        local name = SL:GetMetaValue("ITEM_NAME", index)
        table.insert(items, name or "?")
    end
    --点击设置
    GUI:addOnClickEvent(Image_2, function()
        if #items == 0 then
            return
        end
        local func = function(res)
            if res ~= 0 then --选中了对应物品的编号  0是关闭
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, nil, nil, indexs[res] })
                --刷新UI
                refName(indexs[res])
            end
        end
        local size = GUI:getContentSize(Image_2)
        local position = GUI:convertToWorldSpace(Image_2, 0, 0)--初始位置
        --打开 选则下拉框
        SL:OpenSelectListUI(items, position, size.width, size.heigth, func)
    end)

    return Panel_Layout
end

function SettingAuto.CreateClickInpuCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 343, 54, false)
    GUI:setTouchEnabled(Panel_Layout, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 8, 28, 34, 36, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 0, 18, "res/private/new_setting/clickbg2.png")
    GUI:Image_setScale9Slice(Image_5, 9, 9, 5, 5)
    GUI:setContentSize(Image_5, 18, 18)
    GUI:setIgnoreContentAdaptWithSize(Image_5, false)
    GUI:setAnchorPoint(Image_5, 0, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 开关
    local Image_sel = GUI:Image_Create(CheckBox_able, "Image_sel", 10, 18, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_sel, 0.5, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 30, 26, 12, "#ffffff", [[周围]])
    GUI:setAnchorPoint(Text_desc, 0, 0.49)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    local Text_desc_0 = GUI:Text_Create(Panel_Layout, "Text_desc_0", 100, 26, 12, "#ffffff", [[格有敌人时主动攻击]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.49)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#000000", 1)

    -- 输入框背景
    local Image_bg = GUI:Image_Create(Panel_Layout, "Image_bg", 76, 26, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_bg, 9, 9, 9, 9)
    GUI:setContentSize(Image_bg, 31, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg, false)

    --设置的值
    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local enable = values[1] == 1 -- 开关
    local count = values[2] or 8 --数量

    --输入框
    local TextField_input = GUI:TextInput_Create(Image_bg, "TextField_input", 15, 14, 26, 26, 12)
    GUI:setAnchorPoint(TextField_input, 0.5, 0.5)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 10)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, count)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local count = GUI:TextInput_getString(TextField_input)
            if count ~= "" then
                count = tonumber(count) or 0
                SL:SetMetaValue("SETTING_VALUE", data.id, {nil, count })
            end
        end
    end)

    --开关设置值
    GUI:setVisible(Image_sel, enable)
    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1, values[2] or 8 })
        GUI:setVisible(Image_sel, not enable)
    end)
    return Panel_Layout
end

function SettingAuto.CreateListItem(parent, name)
    -- item
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. name, 0, 0, 180, 28, false)
    GUI:setTouchEnabled(Panel_item, true)
    GUI:setVisible(Panel_item, false)

    -- item选中
    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", 0, 0, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_sel, 33, 33, 9, 9)
    GUI:setContentSize(Image_sel, 180, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
    GUI:setTouchEnabled(Image_sel, false)

    -- 名字
    local Text_name = GUI:Text_Create(Panel_item, "Text_name", 90, 15, 16, "#ffffff", [[以下列表中怪物不攻击]])
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:setTouchEnabled(Text_name, false)
    GUI:Text_enableOutline(Text_name, "#000000", 1)

    return Panel_item
end

function SettingAuto.CreateListPanel(parent, data)
    -- rq容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 204, 220, false)
    GUI:setTouchEnabled(Panel_Layout, false)

    -- 标题
    local Image_title = GUI:Image_Create(Panel_Layout, "Image_title", 100, 198, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_title, 33, 33, 9, 9)
    GUI:setContentSize(Image_title, 171, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_title, false)
    GUI:setAnchorPoint(Image_title, 0.5, 0.5)
    GUI:setTouchEnabled(Image_title, false)

    -- 以下列表中怪物不攻击
    local Text_3 = GUI:Text_Create(Image_title, "Text_3", 85.5, 15, 12, "#ffffff", [[以下列表中怪物不攻击]])
    GUI:setAnchorPoint(Text_3, 0.5, 0.5)
    GUI:setTouchEnabled(Text_3, false)
    GUI:Text_enableOutline(Text_3, "#000000", 1)

    -- 背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 100, 180, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 184, 132)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 1)
    GUI:setTouchEnabled(Image_2, true)

    -- 列表
    local ListView = GUI:ListView_Create(Image_2, "ListView", 2, 2, 180, 130, 1)
    GUI:setTouchEnabled(ListView, true)



    -- 新增
    local Button_add = GUI:Button_Create(Panel_Layout, "Button_add", 49, 28, "res/private/new_setting/btnbg.png")
    GUI:Button_loadTexturePressed(Button_add, "res/private/new_setting/btnbg.png")
    GUI:Button_loadTextureDisabled(Button_add, "res/private/new_setting/btnbg.png")
    GUI:Button_setScale9Slice(Button_add, 16, 14, 12, 10)
    GUI:setContentSize(Button_add, 80, 30)
    GUI:setIgnoreContentAdaptWithSize(Button_add, false)
    GUI:Button_setTitleText(Button_add, "新增")
    GUI:Button_setTitleColor(Button_add, "#ffffff")
    GUI:Button_setTitleFontSize(Button_add, 18)
    GUI:Button_titleEnableOutline(Button_add, "#000000", 1)
    GUI:setAnchorPoint(Button_add, 0.5, 0.5)
    GUI:setTouchEnabled(Button_add, true)

    -- 删除
    local Button_del = GUI:Button_Create(Panel_Layout, "Button_del", 151, 28, "res/private/new_setting/btnbg.png")
    GUI:Button_loadTexturePressed(Button_del, "res/private/new_setting/btnbg.png")
    GUI:Button_loadTextureDisabled(Button_del, "res/private/new_setting/btnbg.png")
    GUI:Button_setScale9Slice(Button_del, 16, 14, 12, 10)
    GUI:setContentSize(Button_del, 80, 30)
    GUI:setIgnoreContentAdaptWithSize(Button_del, false)
    GUI:Button_setTitleText(Button_del, "删除")
    GUI:Button_setTitleColor(Button_del, "#ffffff")
    GUI:Button_setTitleFontSize(Button_del, 18)
    GUI:Button_titleEnableOutline(Button_del, "#000000", 1)
    GUI:setAnchorPoint(Button_del, 0.5, 0.5)
    GUI:setTouchEnabled(Button_del, true)


    local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    if not value or (type(value) ~= "table") then
        value = {}
    end
    --之前设置的值
    for name, v in pairs(value) do
        local item = SettingAuto.CreateListItem(ListView, name)
        GUI:setVisible(item, true)
        local Text_name = GUI:getChildByName(item, "Text_name")
        local Image_sel = GUI:getChildByName(item, "Image_sel")
        GUI:Text_setString(Text_name, name)
        GUI:setVisible(Image_sel, false)
        GUI:addOnClickEvent(item, function()
            if Panel_Layout.selectItem then
                local LastImage_sel = GUI:getChildByName(Panel_Layout.selectItem, "Image_sel")
                GUI:setVisible(LastImage_sel, false)
            end
            GUI:setVisible(Image_sel, true)
            Panel_Layout.selectItem = item
        end)
    end
    --新增
    GUI:addOnClickEvent(Button_add, function()
        ----打开 增加名字 设置界面 ignoreName 是否是挂机忽略名字
        SL:OpenAddNameUI({ ignoreName = true })
    end)
    --删除
    GUI:addOnClickEvent(Button_del, function()
        if Panel_Layout.selectItem then
            local selText_name = GUI:getChildByName(Panel_Layout.selectItem, "Text_name")
            local name = GUI:Text_getString(selText_name)
            GUI:ListView_removeChild(ListView, Panel_Layout.selectItem)
            Panel_Layout.selectItem = nil
            local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
            if not value or type(value) ~= "table" then
                value = {}
            end
            value[name] = nil
            SL:SetMetaValue("SETTING_VALUE", data.id, { value })
        end
    end)

    return Panel_Layout
end

function SettingAuto.CreateSelect2Cell(parent, data)
    --容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 228, 54, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 10, 27, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)
    GUI:Text_enableOutline(Text_desc, "#000000", 1)

    -- 点击的背景
    local Image_Click = GUI:Image_Create(Panel_Layout, "Image_Click", 110, 13, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_Click, 33, 33, 9, 9)
    GUI:setContentSize(Image_Click, 105, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_Click, false)
    GUI:setTouchEnabled(Image_Click, true)

    -- 描述
    local Text_desc2 = GUI:Text_Create(Image_Click, "Text_desc2", 52, 14, 12, "#109c18", "")
    GUI:setAnchorPoint(Text_desc2, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc2, false)
    GUI:Text_enableOutline(Text_desc2, "#111111", 1)

    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local items = {}

    if data.id == SLDefine.SETTINGID.SETTING_IDX_BEDAMAGED_PLAYER then
        --1不处理 2反击 3逃跑
        items = { "不处理", "反击", "逃跑" }
        if not values[1] or (values[1] and values[1] == 0) then --默认值
            values[1] = 1
        end
        GUI:Text_setString(Text_desc2, items[values[1]])
    elseif data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_GROUPSKILL
    or data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SIMPSKILL then
        GUI:Text_setString(Text_desc2, "配置")
    end

    GUI:addOnClickEvent(Image_Click, function()
        if data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_GROUPSKILL
        or data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SIMPSKILL then
            SL:OpenSkillRankPanelUI(data)
        else
            if #items == 0 then
                return
            end
            local func = function(res)
                if res ~= 0 then --0关闭  非0 选中的编号
                    if data.id == SLDefine.SETTINGID.SETTING_IDX_BEDAMAGED_PLAYER then
                        SL:SetMetaValue("SETTING_VALUE", data.id, { res })
                        GUI:Text_setString(Text_desc2, items[res])
                    end
                end
            end
            local size = GUI:getContentSize(Image_Click)
            local position = GUI:convertToWorldSpace(Image_Click, 0, 0)
            SL:OpenSelectListUI(items, position, size.width, size.heigth, func)--打开选则列表
        end
    end)

    return Panel_Layout
end
function SettingAuto.OnAddIgnoreList(name)
    if not name then
        return
    end

    local Panel_Set = SettingAuto._ui["Panel_" .. SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER]
    local Panel_UI = GUI:ui_delegate(Panel_Set)
    if Panel_UI then
        local value = SL:GetMetaValue("SETTING_ENABLED", (SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER))
        if not value or (type(value) ~= "table") then
            value = {}
        end
        if value[name] then
            return
        end
        local Panel_item = Panel_UI.Panel_item
        local item = SettingAuto.CreateListItem(Panel_UI.ListView, name)
        GUI:setVisible(item, true)
        local Text_name = GUI:getChildByName(item, "Text_name")
        local Image_sel = GUI:getChildByName(item, "Image_sel")
        GUI:Text_setString(Text_name, name)
        GUI:setVisible(Image_sel, false)
        GUI:addOnClickEvent(item, function()
            if Panel_Set.selectItem then
                local LastImage_sel = GUI:getChildByName(Panel_Set.selectItem, "Image_sel")
                GUI:setVisible(LastImage_sel, false)
            end
            GUI:setVisible(Image_sel, true)
            Panel_Set.selectItem = item
        end)
        value[name] = 1
        SL:SetMetaValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_IGNORE_MONSTER, { value })
    end
end

function SettingAuto.CloseCallback()
    SettingAuto.UnRegisterEvent()
end

function SettingAuto.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, "SettingAuto", SettingAuto.OnAddIgnoreList)--怪物忽略列表增加
end

function SettingAuto.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, "SettingAuto")
end
