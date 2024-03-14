SettingPickSetting = {}

function SettingPickSetting.main(parent, data)
    GUI:LoadExport(parent, "set/setting_pick_setting")
    SettingPickSetting._Frameui = GUI:ui_delegate(parent)
    SettingPickSetting._parent = parent
    if not SettingPickSetting._Frameui then
        return false
    end
    SettingPickSetting._items = {}
    SettingPickSetting._groupCells = {}
    SettingPickSetting.InitFrameUI(data)
    SettingPickSetting.Init(data)
end

--外框
function SettingPickSetting.InitFrameUI(data)
    local ui = SettingPickSetting._Frameui
    GUI:addOnClickEvent(ui.Button_close, function()
        SL:ClosePickSettingUI()
    end)
    GUI:addOnClickEvent(ui.Panel_cancle, function()
        SL:ClosePickSettingUI()
    end)

    -- 适配
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(ui.Panel_1, screenW / 2, screenH / 2)

    GUI:setContentSize(ui.Panel_cancle, screenW, screenH)
end

--内容
function SettingPickSetting.Init(data)
    local node = SettingPickSetting._Frameui.Node_1
    GUI:LoadExport(node, "set/setting_pick_bg")
    SettingPickSetting._ui = GUI:ui_delegate(node)
    SettingPickSetting.InitItemConfig()
    SettingPickSetting.InitGroupCells()
end

function SettingPickSetting.InitItemConfig()
    local itemConfig = SL:GetMetaValue("STD_ITEMS")
    local groupConfig = SL:GetMetaValue("SETTING_PICK_CONFIG")

    for _, config in ipairs(groupConfig) do
        SettingPickSetting._items[config.group] = {}
    end

    local items = {}
    for _, v in pairs(itemConfig) do
        if v.pickset then
            local slices = string.split(tostring(v.pickset), "#")
            local groupID = tonumber(slices[1])
            if SettingPickSetting._items[groupID] then
                table.insert(SettingPickSetting._items[groupID], v)
            end
        end
    end

    for k, v in pairs(SettingPickSetting._items) do
        table.sort(v, function(a, b)
            return a.Index < b.Index
        end)
    end
end

function SettingPickSetting.GetItemConfigByGroup(groupID)
    return SettingPickSetting._items[groupID]
end

function SettingPickSetting.InitGroupCells()
    local ui = SettingPickSetting._ui
    local groupConfig = SL:GetMetaValue("SETTING_PICK_CONFIG")
    for _, config in ipairs(groupConfig) do
        local cell = GUI:QuickCell_Create(ui.ListView_cells, "group_" .. config.group, 0, 0, 732, 45,
        function(parent)
            return SettingPickSetting.CreateGroupCell(parent, config)
        end)
        SettingPickSetting._groupCells[config.group] = cell
    end
end

function SettingPickSetting.UpdateGroupCellByID(groupID)
    local cell = SettingPickSetting._groupCells[groupID]
    if not cell then
        return nil
    end
    GUI:QuickCell_Exit(cell)
    GUI:QuickCell_Refresh(cell)
end

function SettingPickSetting.CreateGroupCell(parent, data)
    GUI:LoadExport(parent, "set/setting_pick_group_cell")
    local ui = GUI:ui_delegate(parent)

    -- 
    local items = SettingPickSetting.GetItemConfigByGroup(data.group)--当前组的配置
    local drop = true
    local pick = true
    local autopick = true
    --这里当总开关  不管里面有没有都能勾
    local value =   SL:GetMetaValue("SETTING_PICK_GROUP_VALUE", data.group) 
    drop = value[1] and value[1] == 1
    pick = value[2] and value[2] == 1
    autopick = value[3] and value[3] == 1
    -- 
    GUI:Text_setString(ui.Text_type, data.name)

    -- 掉落显示
    GUI:CheckBox_setSelected(ui.CheckBox_drop, drop)
    GUI:addOnClickEvent(ui.Panel_drop,function()
        local groupvalue = SL:GetMetaValue("SETTING_PICK_GROUP_VALUE", data.group) 
        groupvalue[1] = groupvalue[1] == 0 and 1 or 0
        local isSelected = groupvalue[1] == 1
        SL:SetMetaValue("SETTING_PICK_GROUP_VALUE", data.group, groupvalue)
        for _, v in pairs(items) do
            local value = SL:GetMetaValue("SETTING_PICK_VALUE", v.Index)
            value[1]    = isSelected and 1 or 0
            SL:SetMetaValue("SETTING_PICK_VALUE", v.Index, value)
        end
        GUI:CheckBox_setSelected(ui.CheckBox_drop, groupvalue[1] == 1)
    end)
    
    -- 自动拾取 手动拾取
    GUI:CheckBox_setSelected(ui.CheckBox_pick, pick)
    GUI:addOnClickEvent(ui.Panel_pick, function()
        local groupvalue = SL:GetMetaValue("SETTING_PICK_GROUP_VALUE", data.group) 
        groupvalue[2] = groupvalue[2] == 0 and 1 or 0
        local isSelected = groupvalue[2] == 1
        SL:SetMetaValue("SETTING_PICK_GROUP_VALUE", data.group, groupvalue)
        for _, v in pairs(items) do
            local value = SL:GetMetaValue("SETTING_PICK_VALUE", v.Index)
            value[2]    = isSelected and 1 or 0
            SL:SetMetaValue("SETTING_PICK_VALUE", v.Index, value)
        end
        GUI:CheckBox_setSelected(ui.CheckBox_pick, groupvalue[2] == 1)
    end)

    -- 挂机拾取
    GUI:CheckBox_setSelected(ui.CheckBox_pick_hang_up, autopick)
    GUI:addOnClickEvent(ui.Panel_pick_hang_up, function()
        local groupvalue = SL:GetMetaValue("SETTING_PICK_GROUP_VALUE", data.group) 
        groupvalue[3] = groupvalue[3] == 0 and 1 or 0
        local isSelected = groupvalue[3] == 1
        
        SL:SetMetaValue("SETTING_PICK_GROUP_VALUE", data.group, groupvalue)
        for _, v in pairs(items) do
            local value = SL:GetMetaValue("SETTING_PICK_VALUE", v.Index)
            value[3]    = isSelected and 1 or 0
            SL:SetMetaValue("SETTING_PICK_VALUE", v.Index, value)
        end
        GUI:CheckBox_setSelected(ui.CheckBox_pick_hang_up, groupvalue[3] == 1)
    end)
    -- 
    GUI:addOnClickEvent(ui.Text_desc, function()
        SettingPickSetting.ShowAutoPickDesc(data.group)
    end)

    GUI:addOnClickEvent(ui.Panel_1, function()
        SettingPickSetting.ShowAutoPickDesc(data.group)
    end)

    return ui.Panel_1
end

function SettingPickSetting.ShowAutoPickDesc(groupID)
    local parent = SettingPickSetting._ui.Panel_1
    GUI:LoadExport(parent, "set/setting_pick_desc")
    local ui = GUI:ui_delegate(parent)

    -- 
    GUI:addOnClickEvent(ui.Panel_PickDesc, function()
        GUI:removeFromParent(ui.Panel_PickDesc)
    end)


    local items = SettingPickSetting.GetItemConfigByGroup(groupID)
    for _, itemConfig in ipairs(items) do
        GUI:QuickCell_Create(ui.ListView_1, "pick_desc_" .. itemConfig.Index, 0, 0, 430, 60,
        function(parent)
            return SettingPickSetting.CreatePickCell(parent, itemConfig)
        end)
    end
end

function SettingPickSetting.CreatePickCell(parent, data)
    GUI:LoadExport(parent, "set/setting_pick_cell")
    local ui = GUI:ui_delegate(parent)
    -- 
    GUI:Text_setString(ui.Text_name, data.Name)

    local value = SL:GetMetaValue("SETTING_PICK_VALUE", data.Index)
    local drop = value[1] and value[1] == 1
    local pick = value[2] and value[2] == 1
    local autopick = value[3] and value[3] == 1

    -- 掉落显示
    GUI:CheckBox_setSelected(ui.CheckBox_drop, drop)
    GUI:addOnClickEvent(ui.Panel_drop, function()
        local value = SL:GetMetaValue("SETTING_PICK_VALUE", data.Index)
        value[1]    = value[1] == 0 and 1 or 0
        local isSelect = value[1] == 1
        SL:SetMetaValue("SETTING_PICK_VALUE", data.Index, value)
        GUI:CheckBox_setSelected(ui.CheckBox_drop, isSelect)
    end)

    -- 自动拾取 手动拾取
    GUI:CheckBox_setSelected(ui.CheckBox_pick, pick)
    GUI:addOnClickEvent(ui.Panel_pick, function()
        local value = SL:GetMetaValue("SETTING_PICK_VALUE", data.Index)
        value[2]    = value[2] == 0 and 1 or 0
        local isSelect = value[2] == 1
        SL:SetMetaValue("SETTING_PICK_VALUE", data.Index, value)
        GUI:CheckBox_setSelected(ui.CheckBox_pick, isSelect)
    end)

    -- 挂机拾取
    GUI:CheckBox_setSelected(ui.CheckBox_pick_hang_up, autopick)
    GUI:addOnClickEvent(ui.Panel_pick_hang_up, function()
        local value = SL:GetMetaValue("SETTING_PICK_VALUE", data.Index)
        value[3]    = value[3] == 0 and 1 or 0
        local isSelect = value[3] == 1
        SL:SetMetaValue("SETTING_PICK_VALUE", data.Index, value)
        GUI:CheckBox_setSelected(ui.CheckBox_pick_hang_up, isSelect)
    end)

    local cansets = SL:GetMetaValue("SETTING_IS_ITEM_PICK_CAN_SET", data.Index)
    GUI:setVisible(ui.Panel_drop, cansets[1] == 1)
    GUI:setVisible(ui.Panel_pick, cansets[2] == 1)
    GUI:setVisible(ui.Panel_pick_hang_up, cansets[3] == 1)

    return ui.Panel_1
end
