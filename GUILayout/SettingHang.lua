SettingHang = {}

local layoutCfg = {
    [3039] = {str1 = "被玩家攻击时", button = true, place = 1, x = 20},
    [3040] = {str1 = "身边", input1 = true, str2 = "格有怪时不捡物", place = 0},
    [3041] = {str1 = "受到BB攻击时先打主人", touch = true, place = 1, x = 20},
    [3042] = {str1 = "不抢别人归属怪物", touch = true, place = 0},
    [3043] = {str1 = "寻路", input1 = true, str2 = "秒没有怪物时使用", button = true, place = 0, x = 20},
    [3044] = {str1 = "周围", input1 = true, str2 = "格有", input2 = true, str3 = "个敌人使用", button = true, place = 0, x = 20},
    [3045] = {str1 = "周围", input1 = true, str2 = "格有", input2 = true, str3 = "个红名使用", button = true, place = 0, x = 20},
    [3046] = {str1 = "周围", input1 = true, str2 = "格有敌人时主动攻击", place = 0, x = 20},
    [3047] = {},
}

function SettingHang.main()
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height - 40

    local itemWidth  = (attachW - 40) / 2 + 100
    local itemHeight = 70
    --------------------------------------------------------------------------------------------------------------------------

    -- ScrollView 容器
    local FrameList = GUI:ScrollView_Create(parent, "FrameList", 0, 0, attachW, attachH, 1)

    -- 标题
    local TitleText = GUI:Text_Create(parent, "TitleText", 15, attachH+10, 18, "#f8e6c6", "挂机设置")

    if not (GUIShare.SetCfg and GUIShare.SetCfg.HangCfg) then
        return false
    end

    local adjustPos = function (layout)
        local x = 0
        local y = GUI:getContentSize(layout).height / 2
        for i, child in ipairs(layout:getChildren()) do
            GUI:setPositionX(child, x, y+1)
            x = x + GUI:getContentSize(child).width + 5
        end
        return x
    end

    local createContentUI = function (widget, cfg, values, data)
        local layout = GUI:Layout_Create(widget, "layout", 40, 12, 0, 0, false)

        local str1 = cfg.str1
        if str1 then
            SettingHang.CreateLabel(layout, str1, 1)
        end

        local input1 = cfg.input1
        if input1 then
            SettingHang.CreateInput(layout, 2, values[2] or 0, data.id)
        end

        local str2 = cfg.str2
        if str2 then
            SettingHang.CreateLabel(layout, str2, 2)
        end

        local input2 = cfg.input2
        if input2 then
            SettingHang.CreateInput(layout, 3, values[3] or 0, data.id)
        end

        local str3 = cfg.str3
        if str3 then
            SettingHang.CreateLabel(layout, str3, 3)
        end

        local button = cfg.button
        if button then
            SettingHang.CreateSelectButton(layout, values[4], data)
        end

        local width = adjustPos(layout)

        -- CheckBox 触摸层
        if cfg.touch then
            GUI:Layout_Create(widget, "TouchSize", 0, 0, width + GUI:getContentSize(widget).width + 5, 24, false)
        end
    end

    local controls = {}
    local row = 0
    for idx, data in ipairs(GUIShare.SetCfg.HangCfg) do
        if data then
            local id  = data.id
            local cfg = layoutCfg[id]
            local values = SL:GetSettingValue(id)

            if 3047 == id then
                local Layout = SettingHang.CreateListPanel(FrameList, id, values[1] or {})
                -- 位置信息
                controls[#controls+1] = {UI = Layout, x = itemWidth + 20, y = row * itemHeight - 30}
            else
                local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..idx, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")

                createContentUI(CheckBox, cfg, values, data)

                -- 复选框添加事件
                GUI:CheckBox_setSelected(CheckBox, values[1] == 1)
                GUI:Win_SetParam(CheckBox, id)
                GUI:CheckBox_addOnEvent(CheckBox, SettingHang.onCheckBoxEvent)

                -- 位置信息
                controls[#controls+1] = {UI = CheckBox, x = cfg.x or itemWidth, y = row * itemHeight}
            end

            local place = cfg.place
            if place == 0 then
                row = row + 1
            end
        end
    end

    -- 计算滚动层的内部滚动高度
    local ihh = math.max(attachH, row * itemHeight - 15)
    GUI:ScrollView_setInnerContainerSize(FrameList, {width = attachW, height = ihh})

    -- 设置复选框的位置
    for _,control in ipairs(controls) do
        if control.UI then
            GUI:setPosition(control.UI, control.x, ihh - 30 - control.y)
        end
    end

    SettingHang.RegisterEvent()
end

function SettingHang.CreateListPanel(parent, setID, values)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Layout", 0, 0, 204, 220, false)
    GUI:setTouchEnabled(Panel_Layout, false)
    GUI:setAnchorPoint(Panel_Layout, 0, 1)

    SettingHang._Panel_Layout = Panel_Layout

    -- 标题
    local Image_title = GUI:Image_Create(Panel_Layout, "Image_title", 100, 198, "res/private/setting/textBg.png")
    GUI:Image_setScale9Slice(Image_title, 33, 33, 9, 9)
    GUI:setContentSize(Image_title, 171, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_title, false)
    GUI:setAnchorPoint(Image_title, 0.5, 0.5)
    GUI:setTouchEnabled(Image_title, false)

    -- 以下列表中怪物不攻击
    local Text_3 = GUI:Text_Create(Image_title, "Text_3", 85.5, 15, 16, "#ffffff", [[以下列表中怪物不攻击]])
    GUI:setAnchorPoint(Text_3, 0.5, 0.5)
    GUI:setTouchEnabled(Text_3, false)
    GUI:Text_enableOutline(Text_3, "#000000", 1)

    -- 背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 100, 182, "res/private/setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 184, 140)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 1)
    GUI:setTouchEnabled(Image_2, true)

    -- 列表
    local ListView = GUI:ListView_Create(Image_2, "ListView", 2, 2, 180, 136, 1)
    GUI:setTouchEnabled(ListView, true)

    -- 新增
    local Button_add = GUI:Button_Create(Panel_Layout, "Button_add", 50, 20, "res/private/setting/btnbg.png")
    GUI:Button_loadTexturePressed(Button_add, "res/private/setting/btnbg.png")
    GUI:Button_loadTextureDisabled(Button_add, "res/private/setting/btnbg.png")
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
    local Button_del = GUI:Button_Create(Panel_Layout, "Button_del", 150, 20, "res/private/setting/btnbg.png")
    GUI:Button_loadTexturePressed(Button_del, "res/private/setting/btnbg.png")
    GUI:Button_loadTextureDisabled(Button_del, "res/private/setting/btnbg.png")
    GUI:Button_setScale9Slice(Button_del, 16, 14, 12, 10)
    GUI:setContentSize(Button_del, 80, 30)
    GUI:setIgnoreContentAdaptWithSize(Button_del, false)
    GUI:Button_setTitleText(Button_del, "删除")
    GUI:Button_setTitleColor(Button_del, "#ffffff")
    GUI:Button_setTitleFontSize(Button_del, 18)
    GUI:Button_titleEnableOutline(Button_del, "#000000", 1)
    GUI:setAnchorPoint(Button_del, 0.5, 0.5)
    GUI:setTouchEnabled(Button_del, true)

    if type(values) ~= "table" then
        values = {}
    end

    --之前设置的值
    for name, v in pairs(values) do
        local item = SettingHang.CreateListItem(ListView, name)
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

    -- 新增
    GUI:addOnClickEvent(Button_add, function()
        -- 打开过滤baoss设置界面
        SL:OpenFilterBossUI()
    end)

    -- 删除
    GUI:addOnClickEvent(Button_del, function()
        if Panel_Layout.selectItem then
            local selText_name = GUI:getChildByName(Panel_Layout.selectItem, "Text_name")
            local name = GUI:Text_getString(selText_name)
            GUI:ListView_removeChild(ListView, Panel_Layout.selectItem)
            Panel_Layout.selectItem = nil
            values[name] = nil
            SL:SetSettingValue(setID, {values})
        end
    end)

    return Panel_Layout
end

function SettingHang.CreateListItem(parent, name)
    -- item
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. name, 0, 0, 180, 28, false)
    GUI:setTouchEnabled(Panel_item, true)
    GUI:setVisible(Panel_item, false)

    -- item选中
    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", 0, 0, "res/private/setting/textBg.png")
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

-------------------------------------------------------------------
-- 创建输入框
function SettingHang.CreateInput(parent, i, value, id)
    local input_bg = GUI:Image_Create(parent, "Input_bg" .. i, 0, 0, "res/public/1900000676.png")
    local input = GUI:TextInput_Create(input_bg, "Input" .. i, 2, 2, 30, 19, 16)
    GUI:setAnchorPoint(input_bg, 0, 0.5)
    GUI:setContentSize(input_bg, {width = 35, height = 25})
    GUI:Text_setTextHorizontalAlignment(input, 1)
    GUI:TextInput_setMaxLength(input, i)
    GUI:TextInput_setInputMode(input, 2)
    GUI:TextInput_setString(input, value)
    GUI:Win_SetParam(input, {id = id, idx = i})
    GUI:TextInput_addOnEvent(input, SettingHang.onInputEvent)
end

-- 创建文本
function SettingHang.CreateLabel(parent, str, i)
    local label = GUI:Text_Create(parent, "Label" .. i, 0, 0, 16, "#ffffff", str)
    GUI:setAnchorPoint(label, 0, 0.5)
end

-- 创建选择按钮
function SettingHang.CreateSelectButton(parent, key, data)
    -- 配置背景
    local w = 90
    local h = 28
    local btn = GUI:Button_Create(parent, "btn", 0, 0, "res/private/setting/textBg.png")
    GUI:Image_setScale9Slice(btn, 33, 33, 9, 9)
    GUI:setAnchorPoint(btn, 0, 0.5)
    GUI:setContentSize(btn, w, h)
    GUI:setIgnoreContentAdaptWithSize(btn, false)
    GUI:setTouchEnabled(btn, true)

    -- 配置
    local Text_desc_0 = GUI:Text_Create(btn, "Text_desc_0", 45, 14, 16, "#109c18", [[配置]])
    GUI:setAnchorPoint(Text_desc_0, 0.5, 0.5)
    GUI:setTouchEnabled(Text_desc_0, false)
    GUI:Text_enableOutline(Text_desc_0, "#111111", 1)
    
    local setText = function (str)
        GUI:Text_setString(Text_desc_0, str)
    end

    local setID = data.id
    if setID == 3039 then
        local items = data.operates

        setText(items[key] or "无")

        GUI:addOnClickEvent(btn, function ()
            if #items < 1 then
                return false
            end

            local callfunc = function (key)
                local value = items[key]
                if not value then
                    return false
                end
                setText(value)
                SL:SetSettingValue(setID, {nil, nil, nil, key})
            end

            SL:OpenSelectListUI(items, GUI:convertToWorldSpace(btn, 0, 0), w, h, callfunc)
        end)
    else
        local itemIDs = {}
        local items   = {}
        for _, itemID in ipairs(SL:Split(data.indexs, "#")) do
            itemID = tonumber(itemID) or 0
            if itemID > 0 then
                local key = #items + 1
                items[key] = SL:GetMetaValue("ITEM_NAME", itemID)
                itemIDs[key] = itemID
            end
        end

        local itemID = key
        if itemID and tonumber(itemID) > 0 then
            setText(SL:GetMetaValue("ITEM_NAME", itemID))
        else
            setText("无")
        end

        GUI:addOnClickEvent(btn, function ()
            if #items < 1 then
                return false
            end

            local callfunc = function (key)
                local value = items[key]
                if not value then
                    return false
                end
                setText(value)
                SL:SetSettingValue(setID, {nil, nil, nil, itemIDs[key]})
            end

            SL:OpenSelectListUI(items, GUI:convertToWorldSpace(btn, 0, 0), w, h, callfunc)
        end)
    end
end
---------------------------------------------------------------------
-- CheckBox 点击事件
function SettingHang.onCheckBoxEvent(sender)
    local id = GUI:Win_GetParam(sender)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    SL:SetSettingValue(id, {isSelected})
end

---------------------------------------------------------------------
-- 输入框事件
function SettingHang.onInputEvent(sender, eventType)
local input_value = tonumber(GUI:TextInput_getString(sender)) or 0
    GUI:TextInput_setString(sender, input_value)

    if eventType == 1 then
        return false
    end

    local params = GUI:Win_GetParam(sender)
    local values = {}
    values[params.idx] = input_value
    SL:SetSettingValue(params.id, values)
end

function SettingHang.OnAddIgnoreList(name)
    if not name then
        return false
    end

    local Panel_Set = SettingHang._Panel_Layout
    if not Panel_Set then
        return false
    end

    local Panel_UI = GUI:ui_delegate(Panel_Set)
    if not Panel_UI then
        return false
    end
    
    local values = SL:GetSettingValue(3047)
    local names  = values[1] or {}
    if type(names) ~= "table" then
        names = {}
    end

    if names[name] then
        return false
    end

    local Panel_item = Panel_UI.Panel_item
    local item = SettingHang.CreateListItem(Panel_UI.ListView, name)
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
    names[name] = 1

    SL:SetSettingValue(3047, {names})
end


function SettingHang.CloseCallback()
    SettingHang.UnRegisterEvent()
end

-- 怪物忽略列表增加
function SettingHang.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, "SettingHang", SettingHang.OnAddIgnoreList)
end

function SettingHang.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MONSTER_IGNORELIST_ADD, "SettingHang")
end