SettingBossTips = {}

function SettingBossTips.main(parent, data)
    GUI:LoadExport(parent, "set/setting_boss_tips")
    SettingBossTips._ui = GUI:ui_delegate(parent)

    -- 适配
    local isWinPlayMode = SL:GetMetaValue("WINPLAYMODE")
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = isWinPlayMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(SettingBossTips._ui.Panel_1, screenW / 2, posY)

    GUI:setContentSize(SettingBossTips._ui.Panel_cancle, screenW, screenH)

    SettingBossTips._parent = parent
    SettingBossTips._selItem = nil
    SettingBossTips.allData = {}
    if not SettingBossTips._ui then
        return false
    end
    SettingBossTips.InitUI(data)
end

function SettingBossTips.InitUI(data)
    local ui = SettingBossTips._ui

    GUI:addOnClickEvent(ui.Button_addMonster, function()
        SL:OpenAddNameUI()
    end)

    GUI:addOnClickEvent(ui.Button_addType, function()
        SL:OpenAddBossTypeUI()
    end)

    GUI:addOnClickEvent(ui.Button_close, function()
        SL:CloseBossTipsUI()
    end)

    GUI:addOnClickEvent(ui.Panel_cancle, function()
        SL:CloseBossTipsUI()
    end)

    GUI:addOnClickEvent(ui.Button_del, function()
        if SettingBossTips._selItem then
            local index = GUI:ListView_getItemIndex(ui.ListView_1, SettingBossTips._selItem)
            GUI:ListView_removeItemByIndex(ui.ListView_1, index)
            table.remove(SettingBossTips.allData, index + 1)
            SettingBossTips._selItem = nil
            SettingBossTips.saveSet()
        end
    end)

    --获取 boss提示的值
    local allData = SL:GetMetaValue("BOS_REMIND_VALUE")
    for k, v in ipairs(allData) do
        SettingBossTips.addItem(v)
    end

    GUI:ListView_jumpToTop(ui.ListView_1)

    SettingBossTips.RegisterEvent()
end

--1 名字 2 开关 3 类型
function SettingBossTips.IsExistBoss(name)
    for i, v in ipairs(SettingBossTips.allData) do
        if v[1] == name then
            return true
        end
    end
    return false
end

--1 名字 2 开关 3 类型
function SettingBossTips.addItem(data)
    local name = data[1] or ""
    if SettingBossTips.IsExistBoss(name) then
        return
    end
    table.insert(SettingBossTips.allData, data)

    local ui = SettingBossTips._ui
    local item = SettingBossTips.createPanel_item(ui.ListView_1, name)
    GUI:setPositionX(item, 0)

    item._BossData = data
    local cell = GUI:ui_delegate(item)
    local enable = (data[2] or 1) == 1
    local type = data[3] or ""

    local TextField_input = GUI:TextInput_Create(cell.Image_name, "TextField_1", 1, 4, 198, 22, 16)
    GUI:TextInput_setPlaceHolder(TextField_input, "怪物名字")
    GUI:setAnchorPoint(TextField_input, 0, 0)
    GUI:TextInput_setMaxLength(TextField_input, 10)
    GUI:TextInput_setString(TextField_input, name)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local input    = GUI:TextInput_getString(TextField_input)
            if input ~= "" and not SettingBossTips.IsExistBoss(input) then
                item._BossData[1] = input
                SettingBossTips.updateItemWithItem(item)
            else
                GUI:TextInput_setString(TextField_input, name)
            end
        end
    end)

    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(cell.Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(cell.Panel_2, enable)
    end

    --刷新开关状态
    func(enable)

    GUI:addOnClickEvent(cell.CheckBox_able, function()
        item._BossData[2] = item._BossData[2] == 1 and 0 or 1
        SettingBossTips.updateItemWithItem(item)
    end)

    GUI:Text_setString(cell.Text_type, type)
    GUI:setVisible(cell.Image_bg, false)
    GUI:addOnClickEvent(item, function()
        if SettingBossTips._selItem then
            local last_Image_bg = GUI:getChildByName(SettingBossTips._selItem, "Image_bg")
            last_Image_bg:setVisible(false)
        end
        SettingBossTips._selItem = item
        GUI:setVisible(cell.Image_bg, true)
    end)

    GUI:addOnClickEvent(cell.Image_type, function()
        local monsterTypes = SL:GetMetaValue("BOSS_REMIND_TYPE")
        local func = function(res) --0关闭  非0  选中的编号
            if res ~= 0 then
                item._BossData[3] = monsterTypes[res]
                SettingBossTips.updateItemWithItem(item)
            end
        end
        local size = GUI:getContentSize(cell.Image_type)
        local position = GUI:convertToWorldSpace(cell.Image_type, 0, 0)

        --打开 选择下拉框
        SL:OpenSelectListUI(monsterTypes, position, size.width, size.heigth, func)
    end)
end

function SettingBossTips.updateItemWithItem(item)
    local data = item._BossData
    local name = data[1] or ""
    local enable = (data[2] or 1) == 1
    local type = data[3] or ""
    local cell = GUI:ui_delegate(item)
    GUI:TextInput_setString(cell.TextField_1, name)
    GUI:setVisible(cell.Panel_1, not enable)
    GUI:setVisible(cell.Panel_2, enable)
    GUI:TextInput_setString(cell.Text_type, type)
    SettingBossTips.saveSet()
end

function SettingBossTips.OnRmBossType(BossType)
    local ui = SettingBossTips._ui
    local items = GUI:ListView_getItems(ui.ListView_1)
    for i, item in ipairs(items) do
        local data = item._BossData
        local type = data[3] or ""
        if type == BossType then
            item._BossData[3] = "BOSS"
            SettingBossTips.updateItemWithItem(item)
        end
    end
end

function SettingBossTips.OnAddMonster(data)
    SettingBossTips.addItem(data)
    SettingBossTips.saveSet()
end

function SettingBossTips.saveSet()
    SL:SetMetaValue("BOS_REMIND_VALUE", SettingBossTips.allData)
end

function SettingBossTips.createPanel_item(parent, name)
    -- Create Panel_item
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. name, 24, 397, 685, 50, false)
    GUI:setAnchorPoint(Panel_item, 0, 1)
    GUI:setTouchEnabled(Panel_item, true)

    -- Create Image_bg
    local Image_bg = GUI:Image_Create(Panel_item, "Image_bg", 0, 0, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_bg, 33, 33, 9, 9)
    GUI:setContentSize(Image_bg, 685, 50)
    GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
    GUI:setTouchEnabled(Image_bg, false)

    -- Create Image_name
    local Image_name = GUI:Image_Create(Panel_item, "Image_name", 20, 11, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_name, 33, 33, 9, 9)
    GUI:setContentSize(Image_name, 200, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_name, false)
    GUI:setTouchEnabled(Image_name, false)

    -- Create CheckBox_able
    local CheckBox_able = GUI:Layout_Create(Panel_item, "CheckBox_able", 322, 23, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- Create Image_5
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- Create Panel_1
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_1, false)

    -- Create Image_8
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- Create Panel_2
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_2, false)

    -- Create Image_5
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- Create Image_8
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- Create Image_type
    local Image_type = GUI:Image_Create(Panel_item, "Image_type", 471, 10, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_type, 33, 33, 9, 9)
    GUI:setContentSize(Image_type, 200, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_type, false)
    GUI:setTouchEnabled(Image_type, true)

    -- Create Text_type
    local Text_type = GUI:Text_Create(Image_type, "Text_type", 100, 14, 16, "#ffffff", [[BOSS ]])
    GUI:setAnchorPoint(Text_type, 0.5, 0.5)
    GUI:setTouchEnabled(Text_type, false)
    GUI:Text_enableOutline(Text_type, "#000000", 1)

    return Panel_item
end

function SettingBossTips.CloseCallback()
    SettingBossTips.UnRegisterEvent()
end

function SettingBossTips.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_NAME_RM, "SettingBossTips", SettingBossTips.OnRmBossType)--删除类型名字
    SL:RegisterLUAEvent(LUA_EVENT_BOSSTIPSLIST_ADD, "SettingBossTips", SettingBossTips.OnAddMonster)--增加Monster 
end

function SettingBossTips.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_NAME_RM, "SettingBossTips")
    SL:UnRegisterLUAEvent(LUA_EVENT_BOSSTIPSLIST_ADD, "SettingBossTips")
end