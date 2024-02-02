SettingLaunch = {}
SettingLaunch._ui = nil
local commonGroup = {
    {
        SLDefine.SETTINGID.SETTING_IDX_HIDE_MONSTER_BODY, --清理尸体
        SLDefine.SETTINGID.SETTING_IDX_AUTO_MOVE, --自动走位
        SLDefine.SETTINGID.SETTING_IDX_ALWAYS_ATTACK, --持续攻击
        SLDefine.SETTINGID.SETTING_IDX_MAGIC_LOCK, --魔法锁定
    },
    {
        SLDefine.SETTINGID.SETTING_IDX_SKILL_NEXT_ATTACK, --技能接平砍
        SLDefine.SETTINGID.SETTING_IDX_ROCKER_CANCEL_ATTACK, --摇杆取消攻击
        SLDefine.SETTINGID.SETTING_IDX_BB_ATTACK_WITH, --宝宝跟随
        SLDefine.SETTINGID.SETTING_IDX_DU_FU_AUTOCHANGE, --毒符互换
        SLDefine.SETTINGID.SETTING_IDX_NOT_NEED_SHIFT, --免shift
    },
    {
        SLDefine.SETTINGID.SETTING_IDX_EXP_IGNORE, --经验过滤
        SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH, --自动练功
    }
}

local commonGroup2 = {
    SLDefine.SETTINGID.SETTING_IDX_BOSS_TIPS, --boss提醒
    SLDefine.SETTINGID.SETTING_IDX_PICK_SETTING, --xxxxxxxxxxxxxxxx--拾取设置
}

local heroGroup = {
    SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_JOINT, -- 自动合击
    SLDefine.SETTINGID.SETTING_IDX_HERO_FOLLOW_ATTACK, -- 跟随主角攻击
    SLDefine.SETTINGID.SETTING_IDX_HERO_AUTO_LOGIN, -- 自动召唤英雄
    SLDefine.SETTINGID.SETTING_IDX_HERO_ATTACK_DODGE, -- 英雄打怪躲避
}

local skillsGroups = {
    [12] = {
        SLDefine.SETTINGID.SETTING_IDX_DAODAOCISHA, --刀刀刺杀
        SLDefine.SETTINGID.SETTING_IDX_GEWEICISHA, --隔位刺杀
        SLDefine.SETTINGID.SETTING_IDX_MOVE_GEWEI_CISHA, --移动隔位刺杀
    },
    [25] = {
        SLDefine.SETTINGID.SETTING_IDX_SMART_BANYUE, --智能半月
    },
    [26] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_LIEHUO, --自动烈火剑法
        SLDefine.SETTINGID.SETTING_IDX_NEAR_LIEHUO, --近身烈火
    },
    [66] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_KAITIAN, --自动开天
    },
    [56] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_ZHURI, --自动逐日剑法
    },
    [87] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SHIELD_OF_FORCE, --武力盾
    },
    [40] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_DOUBLE_DRAGON_Z, --双龙斩
    },
    [42] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_DRAGON_SHADOW_JF, --龙影剑法
    },
    [43] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_THUNDERBOLT_JF, --雷霆剑法
    },
    [81] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_FREELY_JS, --纵横剑术
    },
    ------------------------
    [22] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_FIRE_WALL, --自动火墙
    },
    [31] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_MOFADUN, --自动魔法盾
    },
    [83] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_SICKLE_S, --自动冰镰术
    },
    [36] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_FLAME_ICE, --自动火焰冰
    },
    [84] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_GROUP_RAIN, --自动冰霜群雨
    },
    ------------------------
    [6] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_DU, --自动施毒
    },
    [14] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_YOULINGDUN, --自动幽灵盾
    },
    [15] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SSZJS, --自动神圣战甲术
    },
    [18] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_CLOAKING, --自动隐身
    },
    [50] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_WJZQ, --自动无极真气
    },
    [17] = {--召唤骷髅
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON --自动召唤
    },
    [30] = {--召唤神兽
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON --自动召唤
    },
    [55] = {--月灵
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON --自动召唤
    },
    [76] = {--召唤圣兽
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON --自动召唤
    },
    [73] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_SHIELD_OF_TAOIST --道力盾
    },
    [44] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_ICE_PALM, --自动寒冰掌
    },
    [57] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_BLOODTHIRSTY_S, --自动噬血术
    },
    [85] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_BREACH_NERVE_FU, --自动裂神符
    },
    [86] = {
        SLDefine.SETTINGID.SETTING_IDX_AUTO_DEATH_EYE, --自动死亡之眼
    },
}

SettingLaunch.isHaveHero = false
SettingLaunch.newAutoSummon = false --新的自动召唤 

local getConfigFunc = function(group)
    local configs = {}
    local config
    for i, id in ipairs(group) do
        config = SL:GetMetaValue("SETTING_CONFIG", id)
        if id ==  SLDefine.SETTINGID.SETTING_IDX_PICK_SETTING and not config then --未配置的加上默认配置
            config  = { 
                id=121,
                content="拾取设置",
                default=0,
                platform=0,
                order=4501,
            }
        end
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

function SettingLaunch.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_launch_win32")
    local newAutoSummon = SL:GetMetaValue("SERVER_OPTION", "CallMobSet")
    SettingLaunch.newAutoSummon = newAutoSummon

    SettingLaunch._ui = GUI:ui_delegate(parent)
    SettingLaunch._parent = parent
    if not SettingLaunch._ui then
        return false
    end
    --公共设置
    SettingLaunch.initCommonGroup()
    --英雄设置
    SettingLaunch.initHeroGroup()
    --技能设置
    SettingLaunch.initSkillGroup()
end

function SettingLaunch.initCommonGroup()
    --- 公共设置
    local commonConfig = {}
    for i, v in ipairs(commonGroup) do
        commonConfig[i] = getConfigFunc(v)
    end
    local commonConfig2 = getConfigFunc(commonGroup2)
    ---计算大小
    local cellW = 191
    local cellH = 40
    local cellH2 = 60
    local maxH = 0
    for i, v in ipairs(commonConfig) do
        local h = 0
        for j, v2 in ipairs(v) do
            if v2.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then
                h = cellH2 + h
            else
                h = cellH + h
            end
            v2.height = h
            maxH = math.max(maxH, h)
        end

    end
    --计算位置
    local ScrollView_1 = SettingLaunch._ui.ScrollView_1
    local commonSize = GUI:Size(575, maxH)
    GUI:setContentSize(SettingLaunch._ui.ImageBG1, commonSize.width,commonSize.height + 4)
    GUI:setContentSize(ScrollView_1, commonSize)
    GUI:ScrollView_setInnerContainerSize(ScrollView_1, commonSize)

    for i, configs in ipairs(commonConfig) do
        for j, config in ipairs(configs) do
            local cell = SettingLaunch.CreateCell(ScrollView_1, config)
            if cell then
                GUI:setPosition(cell, cellW * (i - 1), commonSize.height - config.height)
            end 
        end
    end
    local ScrollView_4 = SettingLaunch._ui.ScrollView_4
    local cellW2 = 289
    for i, config in ipairs(commonConfig2) do
        local cell = SettingLaunch.CreateCell(ScrollView_4, config)
        if cell then 
            GUI:setPosition(cell, cellW2 * (i - 1) + 20, 0)
        end 
    end
end

function SettingLaunch.initHeroGroup()
    local cellH = 40
    local ScrollView_2 = SettingLaunch._ui.ScrollView_2
    local heroConfigs = {}
    heroConfigs = getConfigFunc(heroGroup)
    local heroItemCount = #heroConfigs
    if SL:GetMetaValue("USEHERO") and heroItemCount > 0 then
        SettingLaunch.isHaveHero = true
        -- -- ---计算大小
        local contentSize = GUI:getContentSize(ScrollView_2)
        for i, v in ipairs(heroConfigs) do
            local cell = SettingLaunch.CreateCell(ScrollView_2, v)
            if cell then 
                GUI:setPosition(cell, 0, contentSize.height - i * cellH)
            end 
        end
    else
        GUI:setVisible(ScrollView_2, false)
    end
end

function SettingLaunch.initSkillGroup()
    local cellW = 191
    local cellH = 40
    local ScrollView_3 = SettingLaunch._ui.ScrollView_3
    local skills = SL:GetMetaValue("SKILL_INFO_FILTER", -1, 3, true, true)--已学的技能
    local jobConfig = {}
    for i, v in pairs(skills) do
        local showIDS = skillsGroups[v.MagicID]  
        local config = SL:GetMetaValue("SKILL_CONFIG",v.MagicID)
        if not showIDS then 
            if v.skilltype == 4 then --自定义召唤类技能
                showIDS = {SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON}
            elseif v.MagicID > 1000 and SL:GetMetaValue("SKILL_IS_ONOFF_SKILL",v.MagicID) and (config.job == 0 or config.job == 3)  then--自定义战士开关技能
                showIDS = {10000+v.MagicID}
            end
        end
        if showIDS then
            local configs = getConfigFunc(showIDS)
            for i, v in ipairs(configs) do
                jobConfig[v.id] = v
            end
        end
    end
    -- 连击
    local comboSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
    local ngShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1
    if comboSkills[1] and ngShow then
        local configs = getConfigFunc({SLDefine.SETTINGID.SETTING_IDX_AUTO_COMBO})
        for i, v in ipairs(configs) do
            jobConfig[v.id] = v
        end
    end
    --排序
    local sortT = {}
    for k, v in pairs(jobConfig) do
        table.insert(sortT, v)
    end
    table.sort(sortT, function(a, b)
        return a.order < b.order
    end)
    jobConfig = sortT
    local configCount = table.nums(jobConfig)
    local contentSize = GUI:getContentSize(ScrollView_3)
    local innerContainerSize = contentSize
    local colCount = 3
    if SettingLaunch.isHaveHero then
        colCount = 2
        GUI:setPositionX(SettingLaunch._ui.ImageBG3, cellW)
    else
        GUI:setPositionX(SettingLaunch._ui.ImageBG3, 0)
        contentSize = GUI:Size(575, contentSize.height)
        innerContainerSize = contentSize
    end
    local maxH = math.ceil(configCount / colCount) * cellH
    if maxH > contentSize.height then
        if SettingLaunch.isHaveHero then
            innerContainerSize = GUI:Size(575 - cellW, maxH)
        else
            contentSize = GUI:Size(575, contentSize.height)
            innerContainerSize = GUI:Size(575, maxH)
        end
    end
    GUI:setContentSize(ScrollView_3, contentSize)
    GUI:setContentSize(SettingLaunch._ui.ImageBG3, contentSize.width,contentSize.height + 4)
    GUI:ScrollView_setInnerContainerSize(ScrollView_3, innerContainerSize)
    local i = 1
    local maxH = 0
    for k, config in pairs(jobConfig) do
        local x = (i - 1) % colCount
        local y = math.ceil(i / colCount)
        if config.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON then
            maxH = maxH + 20
        end
        local H = y * cellH + maxH
        local cell = SettingLaunch.CreateCell(ScrollView_3, config)
        if cell then 
            GUI:setPosition(cell, cellW * x, innerContainerSize.height - H)
        end 
        i = i + 1
    end
end

function SettingLaunch.CreateCell(parent, config)
    local cell
    if config.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then --自动练功
        cell = SettingLaunch.CreateSelectInputCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_EXP_IGNORE then --经验过滤
        cell = SettingLaunch.CreateInputClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_BOSS_TIPS then --boss提醒
        cell = SettingLaunch.CreateListClickCell(parent, config)
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_PICK_SETTING then --拾取过滤
        if config.default == 0 then 
            cell = SettingLaunch.CreateListCell(parent, config)
        end 
    elseif config.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON then -- 自动召唤
        cell = SettingLaunch.CreateSelectClickCell(parent, config)
    else
        cell = SettingLaunch.CreateClickCell(parent, config)
    end
    return cell
end

--点击的开关
function SettingLaunch.CreateClickCell(parent, data)
    -- 
    local Panel_Click = GUI:Layout_Create(parent, "Panel_Click_" .. data.id, 0, 1, 200, 40, false)
    GUI:setTouchEnabled(Panel_Click, true)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Click, "Text_desc", 22, 20, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    --选择容器
    local CheckBox_able = GUI:Layout_Create(Panel_Click, "CheckBox_able", 130, 19, 44, 18, false)
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

--选择 输入 开关
function SettingLaunch.CreateSelectInputCell(parent, data)
    --设置数据
    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    local skillID = values[1]
    local timeSec = values[2] or 3

    local Panel_1 = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 228, 60, false)
    GUI:setTouchEnabled(Panel_1, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_1, "Text_desc", 4, 30, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    -- 技能框
    local Image_skill = GUI:Image_Create(Panel_1, "Image_skill", 100, 30, "res/public/1900000651.png")
    GUI:setAnchorPoint(Image_skill, 0.5, 0.5)

    -- 无
    local Text_empty = GUI:Text_Create(Panel_1, "Text_empty", 100, 33, 12, "#ffffff", [[无]])
    GUI:setAnchorPoint(Text_empty, 0.5, 0.5)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_1, "Image_2", 154, 30, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 30, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)

    --输入框
    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 0, 0, 27, 26, 12)
    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 2)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, timeSec)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local input    = math.min(math.max(tonumber(GUI:TextInput_getString(TextField_input)) or 1, 1), 99)
            local timeSec = input
            SL:SetMetaValue("SETTING_VALUE", data.id, {nil, timeSec })
        end
    end)

    -- 秒
    local Text_desc_0 = GUI:Text_Create(Panel_1, "Text_desc_0", 175, 30, 12, "#ffffff", [[秒]])
    GUI:setAnchorPoint(Text_desc_0, 0, 0.5)

    -- skill
    if skillID and skillID ~= -1  then
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
        SettingLaunch.ShowSelectSkill(data)
    end)

    return Panel_1
end
--显示选择技能
function SettingLaunch.ShowSelectSkill(data)
    local items    = {}
    if data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON then
        -- 自动召唤
        items = SL:GetMetaValue("SKILL_INFO_FILTER", 4, 3, true)
        if SettingLaunch.newAutoSummon then 
            table.insert(items, { MagicID = -1, skillgroup = -1})--自动
        end
    elseif data.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then
        -- 自动练功
        local items2 = SL:GetMetaValue("SKILL_INFO_FILTER", -1, 3, true, true)
        for i, v in pairs(items2) do
            local isActive = SL:GetMetaValue("SKILL_IS_ACTIVE",v.MagicID)--主动技能
            if isActive then 
                table.insert(items,v)
            end
        end
        table.insert(items, { MagicID = -1, skillgroup = -1})--无
    end
    items = SL:HashToSortArray(items, function(a, b)
        return a.MagicID < b.MagicID
    end)
    if not next(items) then
        SL:ShowSystemTips(GET_STRING(30052303))
        return nil
    end

    -- 背景底框
    local Panel_1 = GUI:Layout_Create(SettingLaunch._parent, "Panel_SelectSkill", 0, 0, 606, 390, false)
    GUI:Layout_setBackGroundColorType(Panel_1, 1)
    GUI:Layout_setBackGroundColor(Panel_1, "#000000")
    GUI:Layout_setBackGroundColorOpacity(Panel_1, 127)
    GUI:setTouchEnabled(Panel_1, true)

    -- 底框
    local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 303, 195, 360, 280, false)
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
        local cell = SettingLaunch.CreateSelectSkillCell(ListView, item)
        GUI:ListView_doLayout(ListView)
    end
end
--创建 技能描述item
function SettingLaunch.CreateSelectSkillCell(parent, data)
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
        local RichText
        if data.setting.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then
            RichText = GUI:RichText_Create(Panel_item, "RichText_empty", size.width / 2, size.height / 2, "无")
        elseif data.setting.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON then
            RichText = GUI:RichText_Create(Panel_item, "RichText_auto", size.width / 2, size.height / 2, SettingLaunch.newAutoSummon and "智能召唤" or "无")
        end
        GUI:setAnchorPoint(RichText, 0.5, 0.5)
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
        if data.setting.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then
            tgroupID = data.skill.skillgroup
            SL:SetMetaValue("SETTING_VALUE", data.setting.id, { tgroupID })
        else
            tgroupID = data.skill.skillgroup
            SL:SetMetaValue("SETTING_VALUE", data.setting.id, {nil, tgroupID })
        end
        local panel = SettingLaunch._ui["Panel_" .. data.setting.id]
        local Image_skill = GUI:getChildByName(panel, "Image_skill")
        GUI:removeAllChildren(Image_skill)
        local Text_empty = GUI:getChildByName(panel, "Text_empty")

        if tgroupID  then
            if tgroupID == -1 then 
                if data.setting.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_LAUNCH then
                    GUI:Text_setString(Text_empty, "无")
                elseif data.setting.id == SLDefine.SETTINGID.SETTING_IDX_AUTO_SUMMON then
                    GUI:Text_setString(Text_empty, SettingLaunch.newAutoSummon and "智能召唤" or "无")
                end
                GUI:setVisible(Text_empty, true)
            else
                local contentSize = GUI:getContentSize(Image_skill)
                local skillItem = GUI:CreateSkillItem(Image_skill, tgroupID)
                GUI:setPosition(skillItem, contentSize.width / 2, contentSize.height / 2)
                GUI:setTouchEnabled(skillItem, false)
                GUI:setScale(skillItem, 0.9)
                GUI:setVisible(Text_empty, false)
            end
        else
            GUI:setVisible(Text_empty, true)
        end
        data.callback()
    end)
    return Panel_item
end
--创建 输入 点击 开关
function SettingLaunch.CreateInputClickCell(parent, data)
    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 200, 40, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 4, 20, 13, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 96, 18, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 50, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, false)

    --输入框
    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 0, 0, 47, 26, 12)

    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 10)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, values[2] and values[2] or 1)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local input    = math.min(math.max(tonumber(GUI:TextInput_getString(TextField_input)) or 1, 1), 2000000000)
            SL:SetMetaValue("SETTING_VALUE", data.id, {nil, input })
        end
    end)
    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 135, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

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

    return Panel_Layout
end

function SettingLaunch.CreateListClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 200, 40, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 4, 20, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 点击背景
    local Image_ClickBg = GUI:Image_Create(Panel_Layout, "Image_ClickBg", 108, 20, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_ClickBg, 33, 33, 9, 9)
    GUI:setContentSize(Image_ClickBg, 74, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_ClickBg, false)
    GUI:setAnchorPoint(Image_ClickBg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_ClickBg, true)

    -- 列表配置
    local Text_desc_2 = GUI:Text_Create(Image_ClickBg, "Text_desc_2", 39, 16, 14, "#109c18", "列表配置")
    GUI:setAnchorPoint(Text_desc_2, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc_2, false)

    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 154, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_bg = GUI:Image_Create(CheckBox_able, "Image_bg", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_bg, false)

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
        SL:OpenBossTipsUI()
    end)
    return Panel_Layout
end

function SettingLaunch.CreateListCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 200, 40, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 4, 20, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 点击背景
    local Image_ClickBg = GUI:Image_Create(Panel_Layout, "Image_ClickBg", 108, 20, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_ClickBg, 33, 33, 9, 9)
    GUI:setContentSize(Image_ClickBg, 74, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_ClickBg, false)
    GUI:setAnchorPoint(Image_ClickBg, 0.5, 0.5)
    GUI:setTouchEnabled(Image_ClickBg, true)

    -- 列表配置
    local Text_desc_2 = GUI:Text_Create(Image_ClickBg, "Text_desc_2", 39, 16, 14, "#109c18", "列表配置")
    GUI:setAnchorPoint(Text_desc_2, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc_2, false)

    GUI:addOnClickEvent(Image_ClickBg, function()
        SL:OpenPickSettingUI()
    end)

    return Panel_Layout
end

function SettingLaunch.CreateSelectClickCell(parent, data)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 228, 60, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 22, 31, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 技能框
    local Image_skill = GUI:Image_Create(Panel_Layout, "Image_skill", 105, 30, "res/public/1900000651.png")
    GUI:setAnchorPoint(Image_skill, 0.5, 0.5)
    GUI:setTouchEnabled(Image_skill, false)

    -- 无
    local Text_empty = GUI:Text_Create(Panel_Layout, "Text_empty", 104, 31, 12, "#ffffff", [[无]])
    GUI:setAnchorPoint(Text_empty, 0.5, 0.5)
    GUI:setTouchEnabled(Text_empty, false)


    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 137, 30, 44, 18, false)
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
    local skillID = values[2]


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

    if skillID then
        if skillID == -1 then
            GUI:Text_setString(Text_empty, SettingLaunch.newAutoSummon and "智能召唤" or "无")
        else 
            local contentSize = GUI:getContentSize(Image_skill)
            local skillItem = GUI:CreateSkillItem(Image_skill, skillID)
            GUI:setPosition(skillItem, contentSize.width / 2, contentSize.height / 2)
            GUI:setTouchEnabled(skillItem, false)
            GUI:setScale(skillItem, 0.9)
            GUI:setVisible(Text_empty, false)
        end
    end

    -- 
    GUI:setTouchEnabled(Image_skill, true)
    GUI:addOnClickEvent(Image_skill, function()
        SettingLaunch.ShowSelectSkill(data)
    end)
    return Panel_Layout
end