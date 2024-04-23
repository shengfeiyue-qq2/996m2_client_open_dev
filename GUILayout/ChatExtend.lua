ChatExtend = {}

function ChatExtend.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local pWidth  = 371
    local pHeight = 293
    ChatExtend._parent  = parent

    -- 全屏
    local Panel_touch = GUI:Layout_Create(parent, "Panel_touch", 0, 0, screenW, screenH)
    GUI:setAnchorPoint(Panel_touch, 1, 0)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 200, pWidth, pHeight)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:setAnchorPoint(PMainUI, 1, 0)

    -- 背景
    local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, 0, "res/private/chat/1900012804.png")
 
    -- btns
    local btnGroups = GUI:Layout_Create(PMainUI, "btnGroups", 0, 5, pWidth, 60)
    GUI:setTouchEnabled(btnGroups, true)

    -- 快捷命令
    local btnQuick = GUI:Button_Create(btnGroups, "btnQuick", 74.2, 30, "res/private/chat/1900012860.png")
    GUI:Button_loadTexturePressed(btnQuick, "res/private/chat/1900012861.png")
    GUI:setAnchorPoint(btnQuick, 0.5, 0.5)

    -- 表情
    local btnEmoji = GUI:Button_Create(btnGroups, "btnEmoji", 148.4, 30, "res/private/chat/1900012852.png")
    GUI:Button_loadTexturePressed(btnEmoji, "res/private/chat/1900012853.png")
    GUI:setAnchorPoint(btnEmoji, 0.5, 0.5)

    -- 道具
    local btnItems = GUI:Button_Create(btnGroups, "btnItems", 222.6, 30, "res/private/chat/1900012856.png")
    GUI:Button_loadTexturePressed(btnItems, "res/private/chat/1900012857.png")
    GUI:setAnchorPoint(btnItems, 0.5, 0.5)

    -- 位置
    local btnPosition = GUI:Button_Create(btnGroups, "btnPosition", 296.8, 30, "res/private/chat/1900012858.png")
    GUI:Button_loadTexturePressed(btnPosition, "res/private/chat/1900012859.png")
    GUI:setAnchorPoint(btnPosition, 0.5, 0.5)

    if SL:IsWinMode() then
        GUI:setVisible(btnQuick, false)
        GUI:setPosition(btnEmoji, 100, 30)
        GUI:setPosition(btnItems, 185.5, 30)
        GUI:setPosition(btnPosition, 271, 30)
    end

    GUI:ScrollView_Create(PMainUI, "ScrollView_quick", 20, 68, 330, 211, 1)

    GUI:ScrollView_Create(PMainUI, "ScrollView_emoji", 20, 68, 330, 211, 1)

    GUI:ScrollView_Create(PMainUI, "ScrollView_items", 20, 68, 330, 211, 1)

    local quickCell = ChatExtend.CreateQuickCell(PMainUI)
    GUI:setVisible(quickCell)


    ChatExtend._isExit = false
    ChatExtend.OnEnter()
end

function ChatExtend.CreateQuickCell(parent)
    local quickCell = GUI:Layout_Create(parent, "quickCell", 0, 0, 330, 30)
    GUI:setTouchEnabled(quickCell, true)

    local imgLine = GUI:Image_Create(quickCell, "imgLine", 165, 0, "res/private/chat/1900012806.png")
    GUI:setAnchorPoint(imgLine, 0.5, 0)

    local textGm = GUI:Text_Create(quickCell, "textGm", 10, 15, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(textGm, 0, 0.5)

    return quickCell
end

function ChatExtend.OnEnter()
    local PMainUI = GUI:GetWindow(ChatExtend._parent, "PMainUI")
    if not PMainUI then
        return false
    end
    GUI:stopAllActions(PMainUI)
    GUI:setPositionX(PMainUI, GUI:getContentSize(PMainUI).width)
    print(GUI:getPositionY(PMainUI))
    GUI:runAction(PMainUI, GUI:ActionEaseBackOut(GUI:ActionMoveTo(0.5, cc.p(0, GUI:getPositionY(PMainUI)))))
end

function ChatExtend.OnExit()
    if ChatExtend._isExit then
        return false
    end
    ChatExtend._isExit = true

    local function callback()
        SL:CloseChatExtendUI()
    end

    local PMainUI = GUI:GetWindow(ChatExtend._parent, "PMainUI")
    if not PMainUI then
        return callback()
    end

    GUI:stopAllActions(PMainUI)
    GUI:setPositionX(PMainUI, 0)
    local move = GUI:ActionMoveTo(0.5, cc.p(GUI:getContentSize(PMainUI).width, GUI:getPositionY(PMainUI)))
    local func = GUI:CallFunc(callback)
    GUI:runAction(PMainUI, GUI:ActionSequence(move, func))
end