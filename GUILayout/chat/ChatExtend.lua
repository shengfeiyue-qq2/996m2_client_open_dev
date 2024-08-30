ChatExtend = {}

ChatExtendInfo = ChatExtendInfo or {}

function ChatExtend.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    if GUI:GetWindow(nil, UIConst.LAYERID.ChatExtendGUI) then
        if SL:GetValue("IS_PC_OPER_MODE") then
            UIOperator:CloseChatExtendUI()
        end
        ChatExtend.SelectGroup(data.group or 1)
        return 
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.ChatExtendGUI, 0, 0, 0, 0, false, false, false, nil, nil, nil, 0)
    GUI:LoadExport(parent, "chat/chat_extend")
    ChatExtendInfo._ui = GUI:ui_delegate(parent)
    ChatExtendInfo._layer = parent

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setPositionX(ChatExtendInfo._ui.Node, screenW)
    GUI:setContentSize(ChatExtendInfo._ui.Panel_1, screenW, screenH)
    GUI:setSwallowTouches(ChatExtendInfo._ui.Panel_1, false)

    ChatExtendInfo._quickCellWid = 330
    ChatExtendInfo._quickCellHei = 30
    ChatExtendInfo._itemCellWid = 66
    ChatExtendInfo._itemCellHei = 66
    ChatExtendInfo._emojiCellWid = 55
    ChatExtendInfo._emojiCellHei = 55

    ChatExtendInfo._groupCells = {}
    ChatExtendInfo._exitStatus = false
    ChatExtend.InitButton()
    ChatExtend.InitGroup()

    ChatExtend.EnterAction()

    ChatExtend.SelectGroup(data.group or 1)

    ChatExtend.RegisterEvent()
end

-- 弹出动画
function ChatExtend.EnterAction()
    local size = GUI:getContentSize(ChatExtendInfo._ui.Panel_2)
    GUI:setVisible(ChatExtendInfo._ui.Panel_2, true)
    GUI:setPositionX(ChatExtendInfo._ui.Panel_2, size.width)
    GUI:stopAllActions(ChatExtendInfo._ui.Panel_2)
    GUI:runAction(ChatExtendInfo._ui.Panel_2, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.5, 0, GUI:getPositionY(ChatExtendInfo._ui.Panel_2))))
end

function ChatExtend.ExitAction()
    if ChatExtendInfo._exitStatus then
        return
    end

    local size = GUI:getContentSize(ChatExtendInfo._ui.Panel_2)
    GUI:setVisible(ChatExtendInfo._ui.Panel_1, false)
    GUI:setVisible(ChatExtendInfo._ui.Panel_2, true)
    GUI:setPositionX(ChatExtendInfo._ui.Panel_2, 0)
    GUI:stopAllActions(ChatExtendInfo._ui.Panel_2)

    ChatExtendInfo._exitStatus = true
    GUI:runAction(ChatExtendInfo._ui.Panel_2, GUI:ActionSequence(
        GUI:ActionEaseBackIn(GUI:ActionMoveTo(0.5, size.width, GUI:getPositionY(ChatExtendInfo._ui.Panel_2))),
        GUI:CallFunc(function()
            ChatExtendInfo._exitStatus = false
            UIOperator:CloseChatExtendUI()
        end))
    )

end

--IS_PC_OPER_MODE 改变按钮
function ChatExtend.InitButton()
    local isWinPlayMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinPlayMode then
        local btnList = {"Button_emoji", "Button_items", "Button_position"}
        GUI:setVisible(ChatExtendInfo._ui.Button_quick, false)
        local size = GUI:getContentSize(ChatExtendInfo._ui.Panel_group)
        local sizeW = size.width
        local per = sizeW / (#btnList + 1)
        for i, btnName in ipairs(btnList) do
            if ChatExtendInfo._ui[btnName] then
                GUI:setPositionX(ChatExtendInfo._ui[btnName], per * i)
            end
        end
    end
end

-- 初始化按钮
function ChatExtend.InitGroup()
    local bnames = {"Button_quick", "Button_emoji", "Button_items"}
    local pnames = {"Panel_quick", "Panel_emoji", "Panel_items"}
    for i, v in ipairs(bnames) do
        local button    = ChatExtendInfo._ui[v]
        local layout    = ChatExtendInfo._ui[pnames[i]]
        local scontent  = GUI:getChildByName(layout, "ScrollView_content")
        local cell      = 
        {
            button      = button,
            layout      = layout,
            scontent    = scontent,
        }
        table.insert(ChatExtendInfo._groupCells, cell)
        GUI:addOnClickEvent(button, function()
            ChatExtend.SelectGroup(i)
        end)
    end

    -- 发送坐标
    GUI:addOnClickEvent(ChatExtendInfo._ui.Button_position, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestSendChatPosMsg()
    end)
end

-- 按钮事件 选择
function ChatExtend.SelectGroup(g)
    ChatExtendInfo._group = g

    local nPath = {"1900012861.png", "1900012853.png", "1900012857.png"}
    local bPath = {"1900012860.png", "1900012852.png", "1900012856.png"}
    for i, v in ipairs(ChatExtendInfo._groupCells) do
        GUI:Button_loadTextureNormal(v.button, "res/private/chat/" .. (ChatExtendInfo._group == i and bPath[i] or nPath[i]))
    end

    ChatExtend.HideQuick()
    ChatExtend.HideEmoji()
    ChatExtend.HideItems()

    if ChatExtendInfo._group == 1 then -- 快捷命令
        ChatExtend.ShowQuick() 
    elseif ChatExtendInfo._group == 2 then -- 表情
        ChatExtend.ShowEmoji()
    elseif ChatExtendInfo._group == 3 then -- 背包
        ChatExtend.ShowItems()
    end
    local quickScrollView = GUI:getChildByName(ChatExtendInfo._ui.Panel_quick, "ScrollView_content")
    GUI:setVisible(quickScrollView, ChatExtendInfo._group == 1)
    local emojiScrollView = GUI:getChildByName(ChatExtendInfo._ui.Panel_emoji, "ScrollView_content")
    GUI:setVisible(emojiScrollView, ChatExtendInfo._group == 2)
    local itemScrollView = GUI:getChildByName(ChatExtendInfo._ui.Panel_items, "ScrollView_content")
    GUI:setVisible(itemScrollView, ChatExtendInfo._group == 3)
end

-- 显示背包
function ChatExtend.ShowItems()
    local cell = ChatExtendInfo._groupCells[3]
    GUI:setVisible(cell.layout, true)
    if cell.load then
        return
    end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local items     = SL:GetValue("CHAT_SHOW_ITEMS")
    local count     = #items
    local col       = 5
    local row       = math.ceil(count / col)
    local itemWid   = ChatExtendInfo._itemCellWid
    local itemHei   = ChatExtendInfo._itemCellHei
    local innerWid  = itemWid * col
    local innerHei  = math.max(itemHei * row, GUI:getContentSize(scrollview).height)
    GUI:ScrollView_setInnerContainerSize(scrollview, innerWid, innerHei)

    for irow = 1, row do
        for icol = 1, col do
            local index = icol + (irow - 1) * col
            if index > count then
                break
            end

            local posX  = (icol - 0.5) * itemWid
            local posY  = innerHei - ((irow - 0.5) * itemHei)
            local item  = items[index]

            local function createCell(parent)
                local layout = GUI:Layout_Create(parent, "Layout_emoji", itemWid / 2, itemHei / 2, itemWid, itemHei, false)
                GUI:setTouchEnabled(layout, true)
                -- 发送装备
                GUI:addOnClickEvent(layout, function()
                    GUI:delayTouchEnabled(layout)
                    SL:RequestSendChatEquipMsg(item)
                end)

                local good_image = GUI:Image_Create(layout, "good_image", itemWid / 2, itemHei / 2, "res/public/1900000651.png")
                GUI:setAnchorPoint(good_image, 0.5, 0.5)
                local item = GUI:ItemShow_Create(parent, "good_item", itemWid / 2, itemHei / 2, {index = item.Index, itemData = item})
                local buttonIcon = GUI:ItemShow_GetItemIcon(item)
                GUI:setTouchEnabled(buttonIcon, false)
                GUI:setAnchorPoint(item, 0.5, 0.5)

                -- 显示已装备图片
                if item.wore then
                    local wore_image = GUI:Image_Create(parent, "wore_image", itemWid / 2 + 2, itemHei / 2 - 5, "res/public/word_bqzy_08.png")
                    GUI:setAnchorPoint(wore_image, 0.5, 0.5)
                end

                return layout
            end
            local cell = GUI:QuickCell_Create(scrollview, "cell_items_" .. index, posX, posY, itemWid, itemHei, createCell)
            GUI:setAnchorPoint(cell, 0.5, 0.5)
        end
    end
end

-- 显示表情
function ChatExtend.ShowEmoji()
    local cell = ChatExtendInfo._groupCells[2]
    GUI:setVisible(cell.layout, true)
    if cell.load then
        return 
    end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local config    = ChatData.GetEmoji()
    local count     = #config
    local col       = 6
    local row       = math.ceil(count / col)
    local itemWid   = ChatExtendInfo._emojiCellWid
    local itemHei   = ChatExtendInfo._emojiCellHei
    local innerWid  = GUI:getContentSize(scrollview).width
    local innerHei  = math.max(itemHei * row, GUI:getContentSize(scrollview).height)
    GUI:ScrollView_setInnerContainerSize(scrollview, innerWid, innerHei)

    for irow = 1, row do
        for icol = 1, col do
            local index = icol + (irow - 1) * col
            if index > count then
                break
            end

            local config    = config[index]
            local posX      = (icol - 0.5) * itemWid
            local posY      = innerHei - ((irow - 0.5) * itemHei)

            local function createCell(parent)
                local layout = GUI:Layout_Create(parent, "Layout_emoji", itemWid / 2, itemHei / 2, itemWid, itemHei, false)
                GUI:setTouchEnabled(layout, true)
                GUI:Effect_Create(layout, "effect_emoji", itemWid / 2, itemHei / 2 - 5, 0, config.sfxid)
                -- 发送表情
                GUI:addOnClickEvent(layout, function()
                    SL:onLUAEvent(LUA_EVENT_CHAT_PUSH_INPUT, config.replace)
                end)
                return layout
            end
            local cell = GUI:QuickCell_Create(scrollview, "cell_emoji_" .. index, posX, posY, itemWid, itemHei, createCell)
            GUI:setAnchorPoint(cell, 0.5, 0.5)
        end
    end
end

-- 快捷命令
function ChatExtend.ShowQuick()
    local cell = ChatExtendInfo._groupCells[1]
    GUI:setVisible(cell.layout, true)
    if cell.load then return end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local items     = ChatData.GetInputCache()
    local itemWid   = ChatExtendInfo._quickCellWid
    local itemHei   = ChatExtendInfo._quickCellHei
    local innerWid  = itemWid
    local innerHei  = math.max(itemHei * #items, GUI:getContentSize(scrollview).height)
    GUI:ScrollView_setInnerContainerSize(scrollview, innerWid, innerHei)

    for i, v in ipairs(items) do
        local posX = 0
        local posY = innerHei - (i * itemHei)

        local function createCell(parent)
            local quick_gm_cell = GUI:Layout_Create(parent, "quick_gm_cell", 0, 0, itemWid, itemHei, false)
            GUI:setTouchEnabled(quick_gm_cell, true)

            local Image_12 = GUI:Image_Create(quick_gm_cell, "Image_12", itemWid / 2, 0, "res/private/chat/1900012806.png")
            GUI:setContentSize(Image_12, 330, 2)
            GUI:setAnchorPoint(Image_12, 0.5, 0)

            local Text_gm = GUI:Text_Create(quick_gm_cell, "Text_gm", itemWid / 2, itemHei / 2, 16, "#ffffff", v)
            GUI:setAnchorPoint(Text_gm, 0, 0.5)
            GUI:Text_enableOutline(Text_gm, "#000000", 1)

            -- 输入聊天内容
            GUI:addOnClickEvent(quick_gm_cell, function()
                SL:onLUAEvent(LUA_EVENT_CHAT_REPLACE_INPUT, v)
            end)
            return quick_gm_cell
        end

        local cell = GUI:QuickCell_Create(scrollview, "cell_quick_" .. i, posX, posY, itemWid, itemHei, createCell)
        GUI:setAnchorPoint(cell, 0.5, 0.5)
    end
end

-- 隐藏
function ChatExtend.HideQuick()
    local cell = ChatExtendInfo._groupCells[1]
    GUI:setVisible(cell.layout, false)
end

function ChatExtend.HideEmoji()
    local cell = ChatExtendInfo._groupCells[2]
    GUI:setVisible(cell.layout, false)
end

function ChatExtend.HideItems()
    local cell = ChatExtendInfo._groupCells[3]
    GUI:setVisible(cell.layout, false)
end

function ChatExtend.OnClose(id)
    if id == UIConst.LAYERID.ChatExtendGUI then
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ChatExtend")
        ChatExtendInfo = nil
    end
end

--------------------------------------------------
function ChatExtend.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_EXTEND_EXIT_ACTION, "ChatExtend", ChatExtend.ExitAction, ChatExtendInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ChatExtend", ChatExtend.OnClose)
end

ChatExtend.main()