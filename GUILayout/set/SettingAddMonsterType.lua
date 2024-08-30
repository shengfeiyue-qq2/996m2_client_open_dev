SettingAddMonsterType = {}

function SettingAddMonsterType.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.SettingAddMonsterTypeGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "set/setting_add_monster_type")
    SettingAddMonsterType._ui = GUI:ui_delegate(parent)
    SettingAddMonsterType._parent = parent
    if not SettingAddMonsterType._ui then
        return false
    end

    SettingAddMonsterType._monsterTypes = {} --怪物的类型
    SettingAddMonsterType._selItem = nil
    SettingAddMonsterType.InitUI()
end

function SettingAddMonsterType.InitUI()
    local ui = SettingAddMonsterType._ui
    local panelSize = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local screenWidth = SL:GetValue("SCREEN_WIDTH")
    local screenHeight = SL:GetValue("SCREEN_HEIGHT")
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or screenHeight / 2
    GUI:setPosition(ui.Panel_1, screenWidth/2 + panelSize.width / 2 + 100, posY)

    GUI:addOnClickEvent(ui.Button_add, function()
        local type = GUI:TextInput_getString(ui.TextField_input)
        if type ~= "" then
            GUI:TextInput_setString(ui.TextField_input, "")
            SettingAddMonsterType.AddItem(type)
            SettingAddMonsterType.SaveSet()
        end
    end)

    GUI:addOnClickEvent(ui.Button_del, function()
        if SettingAddMonsterType._selItem then --有选中
            local monsterType = SettingAddMonsterType._selItem._monsterType
            GUI:ListView_removeChild(SettingAddMonsterType._ui.ListView_1, SettingAddMonsterType._selItem)
            SettingAddMonsterType._selItem = nil
            for i, v in ipairs(SettingAddMonsterType._monsterTypes) do
                if v == monsterType then
                    table.remove(SettingAddMonsterType._monsterTypes, i)
                    break
                end
            end
            SettingAddMonsterType.SaveSet()
            SL:onLUAEvent(LUA_EVENT_MONSTER_NAME_RM, monsterType)
        end
    end)

    GUI:addOnClickEvent(ui.Button_close, function()
        UIOperator:CloseAddMonsterTypeUI()
    end)

    GUI:addOnClickEvent(ui.Panel_cancle, function()
        UIOperator:CloseAddMonsterTypeUI()
    end)

    local monsterTypes = SL:GetValue("SETTING_BOSS_REMIND_TYPE")

    for k, v in ipairs(monsterTypes) do
        SettingAddMonsterType.AddItem(v)
    end
end

function SettingAddMonsterType.IsExistType(monsterType)
    for i, v in ipairs(SettingAddMonsterType._monsterTypes) do
        if v == monsterType then 
            return true
        end
    end
    return false
end

function SettingAddMonsterType.AddItem(monsterType)
    if SettingAddMonsterType.IsExistType(monsterType) then 
        return 
    end
    table.insert(SettingAddMonsterType._monsterTypes, monsterType)
    local ui = SettingAddMonsterType._ui
    -- Create Panel_item
    local Panel_item = GUI:Layout_Create(ui.ListView_1, "Panel_item_" .. monsterType, 11, 185, 314, 43, false)
    GUI:setTouchEnabled(Panel_item, true)

    -- Create Image_1
    local Image_1 = GUI:Image_Create(Panel_item, "Image_1", 1, 2, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(Image_1, 310, 2)
    GUI:setIgnoreContentAdaptWithSize(Image_1, false)
    GUI:setAnchorPoint(Image_1, 0, 0.5)
    GUI:setTouchEnabled(Image_1, false)

    -- Create Image_sel
    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", 0, 21.5, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_sel, 33, 33, 9, 9)
    GUI:setContentSize(Image_sel, 314, 43)
    GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
    GUI:setAnchorPoint(Image_sel, 0, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- Create Text_type
    local Text_type = GUI:Text_Create(Panel_item, "Text_type", 156, 23, 20, "#ffffff", [[Boss]])
    GUI:setAnchorPoint(Text_type, 0.5, 0.5)
    GUI:setTouchEnabled(Text_type, false)
    GUI:Text_enableOutline(Text_type, "#000000", 1)

    Panel_item._monsterType = monsterType

    GUI:Text_setString(Text_type, monsterType)
    GUI:setVisible(Image_sel, false)
    GUI:addOnClickEvent(Panel_item, function()
        if monsterType == "BOSS" or monsterType == "超级BOSS" or monsterType == "大BOSS" then --内置类型
            return
        end
        if SettingAddMonsterType._selItem then
            local last_Image_sel = GUI:getChildByName(SettingAddMonsterType._selItem, "Image_sel")
            GUI:setVisible(last_Image_sel, false)
        end
        SettingAddMonsterType._selItem = Panel_item
        GUI:setVisible(Image_sel, true)
    end)
end

function SettingAddMonsterType.SaveSet()
    SL:SetValue("SETTING_BOSS_REMIND_TYPE", SettingAddMonsterType._monsterTypes)
end

SettingAddMonsterType.main()