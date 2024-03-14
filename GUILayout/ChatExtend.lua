ChatExtend = {}

function ChatExtend.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "chat/chat_extend")
    ChatExtend._ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(ChatExtend._ui.Panel_1, screenW, screenH)
    GUI:setSwallowTouches(ChatExtend._ui.Panel_1, false)

    ChatExtend._groupCells = {}
    ChatExtend._exitStatus = false
    ChatExtend.InitButton()
    ChatExtend.InitGroup()

    ChatExtend.EnterAction()
end

-- 弹出动画
function ChatExtend.EnterAction()
    local size = GUI:getContentSize(ChatExtend._ui.Panel_2)
    GUI:setVisible(ChatExtend._ui.Panel_2, true)
    GUI:setPositionX(ChatExtend._ui.Panel_2, size.width)
    GUI:stopAllActions(ChatExtend._ui.Panel_2)
    GUI:runAction(ChatExtend._ui.Panel_2, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.5, 0, GUI:getPositionY(ChatExtend._ui.Panel_2))))
end

function ChatExtend.ExitAction()
    if ChatExtend._exitStatus then
        return
    end

    local size = GUI:getContentSize(ChatExtend._ui.Panel_2)
    GUI:setVisible(ChatExtend._ui.Panel_1, false)
    GUI:setVisible(ChatExtend._ui.Panel_2, true)
    GUI:setPositionX(ChatExtend._ui.Panel_2, 0)
    GUI:stopAllActions(ChatExtend._ui.Panel_2)

    ChatExtend._exitStatus = true
    GUI:runAction(ChatExtend._ui.Panel_2, GUI:ActionSequence(
        GUI:ActionEaseBackIn(GUI:ActionMoveTo(0.5, size.width, GUI:getPositionY(ChatExtend._ui.Panel_2))),
        GUI:CallFunc(function()
            ChatExtend._exitStatus = false
            SL:CloseChatExtendUI()
        end))
    )

end

--WINPLAYMODE 改变按钮
function ChatExtend.InitButton()
    local isWinPlayMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinPlayMode then
        local btnList = {"Button_emoji", "Button_items", "Button_position"}
        GUI:setVisible(ChatExtend._ui.Button_quick, false)
        local size = GUI:getContentSize(ChatExtend._ui.Panel_group)
        local sizeW = size.width
        local per = sizeW / (#btnList + 1)
        for _, btnName in ipairs(btnList) do
            if ChatExtend._ui[btnName] then
                GUI:setPositionX(ChatExtend._ui[btnName], per * _)
            end
        end
    end
end

-- 初始化按钮
function ChatExtend.InitGroup()
    local bnames = {"Button_quick", "Button_emoji", "Button_items"}
    local pnames = {"Panel_quick", "Panel_emoji", "Panel_items"}
    for i, v in ipairs(bnames) do
        local button    = ChatExtend._ui[v]
        local layout    = ChatExtend._ui[pnames[i]]
        local scontent  = GUI:getChildByName(layout, "ScrollView_content")
        local cell      = 
        {
            button      = button,
            layout      = layout,
            scontent    = scontent,
        }
        table.insert(ChatExtend._groupCells, cell)
        GUI:addOnClickEvent(button, function()
            ChatExtend.SelectGroup(i)
        end)
    end

    -- 发送坐标
    GUI:addOnClickEvent(ChatExtend._ui.Button_position, function()
        SL:SendPosMsgToChat()
    end)
end

-- 按钮事件 选择
function ChatExtend.SelectGroup(g)
    ChatExtend._group = g

    local nPath = {"1900012861.png", "1900012853.png", "1900012857.png"}
    local bPath = {"1900012860.png", "1900012852.png", "1900012856.png"}
    for i, v in ipairs(ChatExtend._groupCells) do
        GUI:Button_loadTextureNormal(v.button, "res/private/chat/" .. (ChatExtend._group == i and bPath[i] or nPath[i]))
    end

    ChatExtend.HideQuick()
    ChatExtend.HideEmoji()
    ChatExtend.HideItems()

    if ChatExtend._group == 1 then -- 快捷命令
        ChatExtend.ShowQuick() 
    elseif ChatExtend._group == 2 then -- 表情
        ChatExtend.ShowEmoji()
    elseif ChatExtend._group == 3 then -- 背包
        ChatExtend.ShowItems()
    end
    local scrollview  = GUI:getChildByName(ChatExtend._ui.Panel_quick, "ScrollView_content")
    GUI:setVisible(scrollview, ChatExtend._group == 1)
    local scrollview  = GUI:getChildByName(ChatExtend._ui.Panel_emoji, "ScrollView_content")
    GUI:setVisible(scrollview, ChatExtend._group == 2)
    local scrollview  = GUI:getChildByName(ChatExtend._ui.Panel_items, "ScrollView_content")
    GUI:setVisible(scrollview, ChatExtend._group == 3)
end

-- 显示背包
function ChatExtend.ShowItems()
    local cell = ChatExtend._groupCells[3]
    GUI:setVisible(cell.layout, true)
    if cell.load then return end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local items     = SL:GetMetaValue("CHAT_SHOW_ITEMS")
    local count     = #items
    local col       = 5
    local row       = math.ceil(count / col)
    local itemWid   = 66
    local itemHei   = 66
    local innerWid  = itemWid * col
    local innerHei  = math.max(itemHei * row, 214)
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
                local layout = GUI:Layout_Create(parent, "Layout_emoji", itemWid/2, itemHei/2, itemWid, itemHei, false)
                GUI:setTouchEnabled(layout, true)
                -- 发送装备
                GUI:addOnClickEvent(layout, function()
                    SL:SendEquipMsgToChat(item)
                end)

                local good_image = GUI:Image_Create(layout, "good_image", itemWid/2, itemHei/2, "res/public/1900000651.png")
                GUI:setAnchorPoint(good_image, 0.5, 0.5)
                local goodsItem = GUI:ItemShow_Create(parent, "good_item", itemWid/2, itemHei/2, {index=item.Index, itemData=item})
                local buttonIcon = goodsItem:GetButtonIcon()
                GUI:setTouchEnabled(buttonIcon, false)
                GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

                -- 显示已装备图片
                if item.wore then
                    local wore_image = GUI:Image_Create(parent, "wore_image", itemWid/2+2, itemHei/2-5, "res/public/word_bqzy_08.png")
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
    local cell = ChatExtend._groupCells[2]
    GUI:setVisible(cell.layout, true)
    if cell.load then return end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local config    = SL:GetMetaValue("CHAT_EMOJI")
    local count     = #config
    local col       = 6
    local row       = math.ceil(count / col)
    local itemWid   = 55
    local itemHei   = 55
    local innerWid  = 330
    local innerHei  = math.max(itemHei * row, 214)
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
                local layout = GUI:Layout_Create(parent, "Layout_emoji", itemWid/2, itemHei/2, itemWid, itemHei, false)
                GUI:setTouchEnabled(layout, true)
                GUI:Effect_Create(layout, "effect_emoji", itemWid/2, itemHei/2-5, 0, config.sfxid)
                -- 发送表情
                GUI:addOnClickEvent(layout, function()
                    SL:SendEmojiMsgToChat(config)
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
    local cell = ChatExtend._groupCells[1]
    GUI:setVisible(cell.layout, true)
    if cell.load then return end
    cell.load = true

    local scrollview = cell.scontent
    GUI:ScrollView_removeAllChildren(scrollview)

    local items     = SL:GetMetaValue("CHAT_INPUT_CACHE")
    local itemWid   = 330
    local itemHei   = 30
    local innerWid  = itemWid
    local innerHei  = math.max(itemHei * #items, 214)
    GUI:ScrollView_setInnerContainerSize(scrollview, innerWid, innerHei)

    for i, v in ipairs(items) do
        local posX = 0
        local posY = innerHei - (i * itemHei)

        local function createCell(parent)
            local quick_gm_cell = GUI:Layout_Create(parent, "quick_gm_cell", 0, 0, 330, 30, false)
            GUI:setTouchEnabled(quick_gm_cell, true)

            local Image_12 = GUI:Image_Create(quick_gm_cell, "Image_12", 165, 0, "res/private/chat/1900012806.png")
            GUI:setContentSize(Image_12, 330, 2)
            GUI:setAnchorPoint(Image_12, 0.50, 0)

            local Text_gm = GUI:Text_Create(quick_gm_cell, "Text_gm", 165, 15, 16, "#ffffff", v)
            GUI:setAnchorPoint(Text_gm, 0, 0.50)
            GUI:Text_enableOutline(Text_gm, "#000000", 1)

            -- 输入聊天内容
            GUI:addOnClickEvent(quick_gm_cell, function()
                SL:SendInputMsgToChat(v)
            end)
            return quick_gm_cell
        end

        local cell = GUI:QuickCell_Create(scrollview, "cell_quick_" .. i, posX, posY, itemWid, itemHei, createCell)
        GUI:setAnchorPoint(cell, 0.5, 0.5)
    end
end

-- 隐藏
function ChatExtend.HideQuick()
    local cell = ChatExtend._groupCells[1]
    GUI:setVisible(cell.layout, false)
end

function ChatExtend.HideEmoji()
    local cell = ChatExtend._groupCells[2]
    GUI:setVisible(cell.layout, false)
end

function ChatExtend.HideItems()
    local cell = ChatExtend._groupCells[3]
    GUI:setVisible(cell.layout, false)
end