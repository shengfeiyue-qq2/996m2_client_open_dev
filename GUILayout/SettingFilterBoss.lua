SettingFilterBoss = {}

function SettingFilterBoss.main(parent, data)
    GUI:LoadExport(parent, "set/setting_filter_boss")
    SettingFilterBoss._ui = GUI:ui_delegate(parent)
    if not SettingFilterBoss._ui then
        return false
    end
    SettingFilterBoss._parent = parent

    SettingFilterBoss.InitUI(data)
end

function SettingFilterBoss.InitUI(data)
    local ui = SettingFilterBoss._ui
    local Panel_Size = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local ScreenWidth  = SL:GetScreenWidth()
    local ScreenHeight = SL:GetScreenHeight()
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or ScreenHeight / 2
    GUI:setPosition(ui.Panel_1, ScreenWidth/2 - Panel_Size.width / 2 - 100, posY)

    local TextField_input = GUI:TextInput_Create(ui.Panel_1, "TextField_1", 17, 34, 158, 29, 20)
    GUI:TextInput_setPlaceHolder(TextField_input, "怪物名字")
    GUI:setAnchorPoint(TextField_input, 0, 0.5)
    GUI:TextInput_setMaxLength(TextField_input, 10)

    GUI:addOnClickEvent(ui.Button_addMonster, function()
        local name = GUI:TextInput_getString(TextField_input)
        if name ~= "" then
            SL:onLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, name)
            GUI:TextInput_setString(TextField_input, "")
        end
    end)

    GUI:addOnClickEvent(ui.Button_close, function()
        SL:CloseFilterBossUI()
    end)

    GUI:addOnClickEvent(ui.Panel_cancle, function()
        SL:CloseFilterBossUI()
    end)

    -- 获取视野内的玩家
    local playerVec = SL:GetPlayerInViewField()
    local monsters  = {}
    for _, player in ipairs(playerVec) do
        -- 人形怪
        if SL:GetMetaValue("ACTOR_IS_HUMAN", player) then
            -- 可攻击
            if true == SL:checkLaunchTargetByID(SL:GetMetaValue("ACTOR_ID", player)) then
                local name = SL:GetMetaValue("ACTOR_NAME", player)
                if name then
                    monsters[name] = 1
                end
            end
        end
    end

    -- 获取视野内的怪物
    local monsterVec = SL:GetMonsterInViewField()
    for _, monster in ipairs(monsterVec) do
        if true == SL:checkLaunchTargetByID(SL:GetMetaValue("ACTOR_ID", monster)) then
            local name = SL:GetMetaValue("ACTOR_NAME", monster)
            if name then
                monsters[name] = 1
            end
        end
    end
    for name, v in pairs(monsters) do
        SettingFilterBoss.addItem(name)
    end
end

function SettingFilterBoss.addItem(name)
    local ui = SettingFilterBoss._ui

    local Panel_item = GUI:Layout_Create(ui.ListView_1, "Panel_item_" .. name, 11, 185, 314, 50, false)
    GUI:setTouchEnabled(Panel_item, true)

    -- Create Image_name
    local Image_name = GUI:Image_Create(Panel_item, "Image_name", 6, 24, "res/private/setting/textBg.png")
    GUI:Image_setScale9Slice(Image_name, 33, 33, 9, 9)
    GUI:setContentSize(Image_name, 170, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_name, false)
    GUI:setAnchorPoint(Image_name, 0, 0.5)
    GUI:setTouchEnabled(Image_name, false)

    -- Text_BossName
    local Text_BossName = GUI:Text_Create(Image_name, "Text_BossName", 7, 15, 20, "#ffffff", [[附近怪物名称]])
    GUI:setAnchorPoint(Text_BossName, 0, 0.5)
    GUI:setTouchEnabled(Text_BossName, false)
    GUI:Text_enableOutline(Text_BossName, "#000000", 1)
    GUI:Text_setString(Text_BossName, name)

    --  Button_add
    local Button_add = GUI:Button_Create(Panel_item, "Button_add", 282, 26, "res/public/1900000621.png")
    GUI:Button_setScale9Slice(Button_add, 15, 15, 11, 11)
    GUI:setContentSize(Button_add, 31, 32)
    GUI:setIgnoreContentAdaptWithSize(Button_add, false)
    GUI:Button_setTitleText(Button_add, "")
    GUI:Button_setTitleColor(Button_add, "#414146")
    GUI:Button_setTitleFontSize(Button_add, 14)
    GUI:Button_titleDisableOutLine(Button_add)
    GUI:setAnchorPoint(Button_add, 0.5, 0.5)
    GUI:setTouchEnabled(Button_add, true)

    GUI:addOnClickEvent(Button_add, function()
        SL:onLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, name)
    end)
end
