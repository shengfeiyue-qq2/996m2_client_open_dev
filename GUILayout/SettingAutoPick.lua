SettingAutoPick = {}

SettingAutoPick._parent  = nil
SettingAutoPick._attachW = GUIShare.WinView.Width
SettingAutoPick._attachH = GUIShare.WinView.Height

function SettingAutoPick:loadListCell(cell, data)
    local items   = SettingAutoPick._GetItemConfigByGroup(data.group)
    local isDrop  = false
    local isPick  = false
    local isManual= false
    for _, v in pairs(items) do
        if SettingAutoPick._GetDropState(v.Index) then
            isDrop = true
        end
        if SettingAutoPick._GetPickState(v.Index) then
            isPick = true
        end
        if SettingAutoPick._GetManualPickState(v.Index) then
            isManual = true
        end
        if isDrop and isPick and isManual then
            break
        end
    end

    local cSize = GUI:getContentSize(cell)
    local width = cSize.width
    local height= cSize.height

    local line = GUI:Image_Create(cell, "line", 0, 0, "res/public/bg_yyxsz_01.png")
    GUI:setPosition(line, 0, 0)

    local title = GUI:Text_Create(cell, "Title", 90, height / 2, 16, "#F8E6C6", data.name)
    GUI:setAnchorPoint(title, 0.5, 0.5)

    -- 显示名字
    local CBName = GUI:CheckBox_Create(cell, "CBName", 288, height / 2, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:setAnchorPoint(CBName, 0.5, 0.5)
    GUI:CheckBox_setSelected(CBName, isDrop)
    GUI:Win_SetParam(CBName, items)
    GUI:CheckBox_addOnEvent(CBName, SettingAutoPick.onCheckBoxNameEvent)

    -- 手动拾取
    local CBManual = GUI:CheckBox_Create(cell, "CBManual", 450, height / 2, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:setAnchorPoint(CBManual, 0.5, 0.5)
    GUI:CheckBox_setSelected(CBManual, isManual)
    GUI:Win_SetParam(CBManual, items)
    GUI:CheckBox_addOnEvent(CBManual, SettingAutoPick.onCheckManualBoxEvent)

    -- 自动拾取
    local CBAuto = GUI:CheckBox_Create(cell, "CBAuto", 550, height / 2, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:setAnchorPoint(CBAuto, 0.5, 0.5)
    GUI:CheckBox_setSelected(CBAuto, isPick)
    GUI:Win_SetParam(CBAuto, items)
    GUI:CheckBox_addOnEvent(CBAuto, SettingAutoPick.onCheckAutoBoxEvent)

    local check = GUI:Text_Create(cell, "Check", 666, height / 2, 16, "#00de00", "查 看")
    GUI:setAnchorPoint(check, 0.5, 0.5)
    GUI:Text_enableUnderline(check)
    GUI:setTouchEnabled(check, true)
    GUI:addOnClickEvent(check, function () SettingAutoPick.showAutoPickDesc(items) end)
end

-- 参数1分为 items(table) 和 index(number)
function SettingAutoPick.onCheckBoxNameEvent(sender, eventType)
    SettingAutoPick._SaveCheckBoxSet(GUI:Win_GetParam(sender), GUI:CheckBox_isSelected(sender), 1)
end

-- 参数1分为 items(table) 和 index(number)
function SettingAutoPick.onCheckManualBoxEvent(sender, eventType)
    SettingAutoPick._SaveCheckBoxSet(GUI:Win_GetParam(sender), GUI:CheckBox_isSelected(sender), 2)
end

-- 参数1分为 items(table) 和 index(number)
function SettingAutoPick.onCheckAutoBoxEvent(sender, eventType)
    SettingAutoPick._SaveCheckBoxSet(GUI:Win_GetParam(sender), GUI:CheckBox_isSelected(sender), 3)
end

function SettingAutoPick.showAutoPickDesc(items)
    local parent  = SettingAutoPick._parent
    if GUI:Win_IsNull(parent) then
        return false
    end

    local attachW = SettingAutoPick._attachW
    local attachH = SettingAutoPick._attachH
    local dis = 100
    local width = attachW - dis * 2
    local height= attachH
    
    local PopView = GUI:getChildByName(parent, "PopView")
    if not PopView then
        PopView = GUI:Layout_Create(parent, "PopView", attachW / 2, attachH / 2, attachW, attachH)
        GUI:Layout_setBackGroundColor(PopView, "#000000")
        GUI:Layout_setBackGroundColorOpacity(PopView, 50)
        GUI:Layout_setBackGroundColorType(PopView, 1)
        GUI:setAnchorPoint(PopView, {x=0.5, y=0.5})
        GUI:setTouchEnabled(PopView, true)
        GUI:addOnClickEvent(PopView, function () GUI:setVisible(PopView, false) end)

        local bg = GUI:Image_Create(PopView, "pBg", attachW / 2, height / 2, "res/public/1900000677.png")
        GUI:setContentSize(bg, {width = width, height = height})
        GUI:Image_setScale9Slice(bg, 8, 8, 15, 15)
        GUI:setAnchorPoint(bg, {x=0.5, y=0.5})
        
        local pTitle1 = GUI:Text_Create(PopView, "pTitle1", dis + width / 6, height - 35, 16, "#F8E6C6", "类型")
        GUI:setAnchorPoint(pTitle1, 0.5, 0.5)

        local pTitle2 = GUI:Text_Create(PopView, "pTitle2", dis + width / 2.5, height - 35, 16, "#F8E6C6", "显示名字")
        GUI:setAnchorPoint(pTitle2, 0.5, 0.5)

        local pTitle3 = GUI:Text_Create(PopView, "pTitle3", dis + width - width / 2.5, height - 35, 16, "#F8E6C6", "手动拾取")
        GUI:setAnchorPoint(pTitle3, 0.5, 0.5)

        local pTitle4 = GUI:Text_Create(PopView, "pTitle4", dis + width - width / 6, height - 35, 16, "#F8E6C6", "自动拾取")
        GUI:setAnchorPoint(pTitle4, 0.5, 0.5)
        
        local pline = GUI:Image_Create(PopView, "pline", dis + width / 2, height - 63, "res/public/1900000667.png")
        GUI:setContentSize(pline, {width = width - 10, height = 2})
        GUI:Image_setScale9Slice(pline, 75, 75, 0, 0)
        GUI:setAnchorPoint(pline, 0.5, 0.5)
    end

    local list = GUI:getChildByName(PopView, "pList")
    if not list then
        list = GUI:ListView_Create(PopView, "pList", dis + 5, 5, width - 10, height - 70, 1)
    end
    GUI:removeAllChildren(list)
    
    for i,v in ipairs(items) do
        local item = GUI:Layout_Create(list, "item"..i, 0, 0, width - 10, 60)

        local line = GUI:Image_Create(item, "line1", 0, 0, "res/public/1900000667.png")
        GUI:setContentSize(line, {width = width - 10, height = 2})
        GUI:Image_setScale9Slice(line, 75, 75, 0, 0)
        GUI:setPosition(line, 0, 0)

        local title = GUI:Text_Create(item, "desc1", width / 6, 30, 16, "#F8E6C6", v.Name)
        GUI:setAnchorPoint(title, 0.5, 0.5)

        local p_CBName = GUI:CheckBox_Create(item, "pCBName", width / 2.5, 30, "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:setAnchorPoint(p_CBName, 0.5, 0.5)
        GUI:CheckBox_setSelected(p_CBName, SettingAutoPick._GetDropState(v.Index))
        GUI:Win_SetParam(p_CBName, v.Index)
        GUI:CheckBox_addOnEvent(p_CBName, SettingAutoPick.onCheckBoxNameEvent)

        local p_CBManual = GUI:CheckBox_Create(item, "pCBManual", width - width / 2.5, 30, "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:setAnchorPoint(p_CBManual, 0.5, 0.5)
        GUI:CheckBox_setSelected(p_CBManual, SettingAutoPick._GetManualPickState(v.Index))
        GUI:Win_SetParam(p_CBManual, v.Index)
        GUI:CheckBox_addOnEvent(p_CBManual, SettingAutoPick.onCheckManualBoxEvent)

        local p_CBAuto = GUI:CheckBox_Create(item, "pCBAuto", width - width / 6, 30, "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:setAnchorPoint(p_CBAuto, 0.5, 0.5)
        GUI:CheckBox_setSelected(p_CBAuto, SettingAutoPick._GetPickState(v.Index))
        GUI:Win_SetParam(p_CBAuto, v.Index)
        GUI:CheckBox_addOnEvent(p_CBAuto, SettingAutoPick.onCheckAutoBoxEvent)

    end
    GUI:ListView_jumpToItem(list, 1)

    PopView:setVisible(true)
end

function SettingAutoPick.main()
    local parent = GUI:Attach_Parent()
    if GUI:Win_IsNull(parent) then
        return false
    end
    SettingAutoPick._parent = parent

    local attachW = SettingAutoPick._attachW
    local attachH = SettingAutoPick._attachH

    -- 容器
    local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(FrameLayout, true)

    local FrameLayout = GUI:Image_Create(FrameLayout, "BG", attachW / 2, attachH / 2, "res/private/setting/set_autopick_bg.png")
    GUI:setAnchorPoint(FrameLayout, {x=0.5, y=0.5})
    GUI:setTouchEnabled(FrameLayout, true)

    -- 子标题
    local titles = {
        [1] = {
            title = "类型", x = 90},
        [2] = {
            title = "显示名字", x = 288
        },
        [3] = {
            title = "手动拾取", x = 450
        },
        [4] = {
            title = "自动拾取", x = 550
        },
        [5] = {
            title = "详细信息", x = 666
        },
    }
    for i=1,5 do
        local Title = GUI:Text_Create(FrameLayout, "Title"..i, titles[i].x, attachH - 10, 16, "#F8E6C6", titles[i].title)
        GUI:setAnchorPoint(Title, 0.5, 0.5)
    end

    local list = GUI:ListView_Create(FrameLayout, "list", 0, 0, attachW, attachH - 25, 1)
    local showDatas = SettingAutoPick._GetDatas()
    for i,data in ipairs(showDatas) do
        local cell = GUI:Layout_Create(list, "cell"..i, 0, 0, attachW, 50, true)
        SettingAutoPick:loadListCell(cell, data)
    end
    GUI:ListView_jumpToItem(list, 1)
end

