Chat = {}

function Chat.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local pWidth  = 462
    local pHeight = 640
    Chat._parent  = parent

    -- 全屏
    local Panel_touch = GUI:Layout_Create(parent, "Panel_touch", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(Panel_touch, true)
    GUI:setAnchorPoint(Panel_touch, 0, 1)
    GUI:addOnClickEvent(Panel_touch, function () Chat.OnExit() end)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, pWidth, pHeight)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:setAnchorPoint(PMainUI, 0, 1)

    -- 背景
    local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, pHeight, "res/private/chat/1900012800.png")
    GUI:setAnchorPoint(Image_bg, 0, 1)

    local ListView_receive = GUI:ListView_Create(PMainUI, "ListView_receive", 8, pHeight - 10, 108, 400, 1)
    GUI:ListView_setItemsMargin(ListView_receive, 5)
    GUI:setAnchorPoint(ListView_receive, 0, 1)


    local Image_list_bg = GUI:Image_Create(PMainUI, "Image_list_bg", 120, pHeight - 5, "res/private/chat/1900012801.png")
    GUI:setAnchorPoint(Image_list_bg, 0, 1)

    local ListView_cells = GUI:ListView_Create(PMainUI, "ListView_cells", 125, pHeight - 5, 317, pHeight-160, 1)
    GUI:setAnchorPoint(ListView_cells, 0, 1)

    local ListView_ex_bg = GUI:Image_Create(PMainUI, "ListView_ex_bg", 125, pHeight - 5, "res/private/chat/bg_hanghui_01.png")
    GUI:Image_setScale9Slice(ListView_ex_bg, 10, 10, 10, 10)
    GUI:setContentSize(ListView_ex_bg, 315, 100)
    GUI:setAnchorPoint(ListView_ex_bg, 0, 1)
    GUI:setTouchEnabled(ListView_ex_bg, true)
    
    local ListView_ex = GUI:ListView_Create(PMainUI, "ListView_ex", 130, pHeight - 10, 305, 90, 1)
    GUI:setAnchorPoint(ListView_ex, 0, 1)

    local Slider = GUI:Slider_Create(PMainUI, "Slider", 282.5, pHeight-5, "res/public/0.png", "res/public/0.png", "res/private/chat/icon_hanghui_02.png")
    GUI:setAnchorPoint(Slider, 0, 0.5)
    GUI:setRotation(Slider, 90)
    GUI:setContentSize(Slider, 400, 15)
    GUI:Slider_setPercent(Slider, 25)

    local btnClose = GUI:Button_Create(PMainUI, "btnClose", 483, pHeight, "res/private/chat/1900012802.png")
    GUI:setAnchorPoint(btnClose, 1, 1)
    GUI:addOnClickEvent(btnClose, function () Chat.OnExit() end)
    
    local imgClose = GUI:Image_Create(PMainUI, "imgClose", pWidth, pHeight/2, "res/private/chat/1900012803.png")
    GUI:setAnchorPoint(imgClose, 1, 0.5)
    GUI:setTouchEnabled(imgClose, true)
    GUI:addOnClickEvent(imgClose, function () Chat.OnExit() end)

    local line = GUI:Image_Create(PMainUI, "line", pWidth/2, 151, "res/private/chat/1900012806.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)

    -- 综合
    local btnCommon = GUI:Button_Create(ListView_receive, "btnCommon", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnCommon, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnCommon, "Image_name", 75, 22, "res/private/chat/1900012846.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnCommon, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 系统
    local btnSystem = GUI:Button_Create(ListView_receive, "btnSystem", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnSystem, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnSystem, "Image_name", 75, 22, "res/private/chat/1900012845.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnSystem, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 喊话
    local btnShout = GUI:Button_Create(ListView_receive, "btnShout", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnShout, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnShout, "Image_name", 75, 22, "res/private/chat/1900012844.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnShout, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 私聊
    local btnPrivate = GUI:Button_Create(ListView_receive, "btnPrivate", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnPrivate, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnPrivate, "Image_name", 75, 22, "res/private/chat/1900012841.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnPrivate, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 行会
    local btnGuild = GUI:Button_Create(ListView_receive, "btnGuild", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnGuild, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnGuild, "Image_name", 75, 22, "res/private/chat/1900012843.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnGuild, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 组队
    local btnTeam = GUI:Button_Create(ListView_receive, "btnTeam", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnTeam, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnTeam, "Image_name", 75, 22, "res/private/chat/1900012842.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnTeam, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 附近
    local btnNear = GUI:Button_Create(ListView_receive, "btnNear", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnNear, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnNear, "Image_name", 75, 22, "res/private/chat/1900012840.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnNear, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)

    -- 世界
    local btnWorld = GUI:Button_Create(ListView_receive, "btnWorld", 0, 0, "res/private/chat/1900012825.png")
    GUI:Button_loadTextureDisabled(btnWorld, "res/private/chat/1900012825-1.png")
    local Image_name = GUI:Image_Create(btnWorld, "Image_name", 75, 22, "res/private/chat/1900012847.png")
    GUI:setAnchorPoint(Image_name, 0.5, 0.5)
    local CheckBox = GUI:CheckBox_Create(btnWorld, "CheckBox", 25, 22, "res/private/chat/1900012820.png", "res/private/chat/1900012821.png")
    GUI:setAnchorPoint(CheckBox, 0.5, 0.5)


    local PanelBtm = GUI:Layout_Create(PMainUI, "PanelBtm", 0, 30, pWidth, 120)
    local InputBg = GUI:Image_Create(PanelBtm, "InputBg", 10, 32, "res/private/chat/1900012805.png")
    GUI:setAnchorPoint(InputBg, 0, 0.5)
    GUI:Image_setScale9Slice(InputBg, 40, 40, 5, 5)
    GUI:setContentSize(InputBg, 355, 40)

    local Input = GUI:TextInput_Create(PanelBtm, "Input", 120, 32, 240, 33, 24)
    GUI:Text_setTextHorizontalAlignment(Input, 0)
    GUI:setAnchorPoint(Input, 0, 0.5)
    GUI:TextInput_setInputMode(Input, 0)
    GUI:TextInput_setPlaceHolder(Input, "点击输入内容")
    GUI:TextInput_setFontColor(Input, "#FFFFFF")

    local Image_channel = GUI:Image_Create(PanelBtm, "Image_channel", 54, 32, "res/private/chat/1900012834.png")
    GUI:setAnchorPoint(Image_channel, 0.5, 0.5)
    local Image_arrow = GUI:Image_Create(PanelBtm, "Image_arrow", 95, 32, "res/private/chat/1900012828.png")
    GUI:setAnchorPoint(Image_arrow, 0.5, 0.5)

    local line2 = GUI:Image_Create(PanelBtm, "line2", 120, 32, "res/private/chat/bg_liaotianzy_07.png")
    GUI:setAnchorPoint(line2, 0.5, 0.5)

    local Image_target = GUI:Image_Create(PanelBtm, "Image_target", 120, 65, "res/private/chat/bg_siliao_01.png")
    GUI:setContentSize(Image_target, 160, 27)
    GUI:setAnchorPoint(Image_target, 0, 0.5)
    GUI:setTouchEnabled(Image_target, true)
    local Text_target = GUI:Text_Create(Image_target, "Text_target", 5, 13.5, 18, "#FFFF00", "玩家名字八个字")
    GUI:setAnchorPoint(Text_target, 0, 0.5)
    local Image_target_a = GUI:Image_Create(Image_target, "Image_target_a", 160, 13.5, "res/private/chat/1900012828.png")
    GUI:setAnchorPoint(Image_target_a, 1, 0.5)

    local btnSend = GUI:Button_Create(PanelBtm, "btnSend", 411, 32, "res/private/chat/1900012823.png")
    GUI:Button_loadTexturePressed(btnSend, "res/private/chat/1900012824.png")
    GUI:setAnchorPoint(btnSend, 0.5, 0.5)
    GUI:Button_setTitleColor(btnSend, "#FFFFFF")
    GUI:Button_setTitleFontSize(btnSend, 20)
    local Image_send = GUI:Image_Create(PanelBtm, "Image_send", 411, 32, "res/private/chat/1900012835.png")
    GUI:setAnchorPoint(Image_send, 0.5, 0.5)

    -- 表情
    local btn_1 = GUI:Button_Create(PanelBtm, "btn_1", 150, 100, "res/private/chat/1900012852.png")
    GUI:Button_loadTexturePressed(btn_1, "res/private/chat/1900012853.png")
    GUI:setAnchorPoint(btn_1, 0.5, 0.5)

    -- 背包
    local btn_2 = GUI:Button_Create(PanelBtm, "btn_2", 230, 100, "res/private/chat/1900012856.png")
    GUI:Button_loadTexturePressed(btn_2, "res/private/chat/1900012857.png")
    GUI:setAnchorPoint(btn_2, 0.5, 0.5)

    -- 定位
    local btn_3 = GUI:Button_Create(PanelBtm, "btn_3", 310, 100, "res/private/chat/1900012858.png")
    GUI:Button_loadTexturePressed(btn_3, "res/private/chat/1900012859.png")
    GUI:setAnchorPoint(btn_3, 0.5, 0.5)

    -- 复制
    local btn_4 = GUI:Button_Create(PanelBtm, "btn_4", 390, 100, "res/private/chat/1900012860.png")
    GUI:Button_loadTexturePressed(btn_4, "res/private/chat/1900012861.png")
    GUI:setAnchorPoint(btn_4, 0.5, 0.5)

    ------------------------
    local PanelChannel = GUI:Layout_Create(PMainUI, "PanelChannel", 10, 80, 90, 160, true)
    GUI:setVisible(PanelChannel, false)
    GUI:setTouchEnabled(PanelChannel, true)
    local ListView_channel_bg = GUI:Image_Create(PanelChannel, "ListView_channel_bg", 0, 0, "res/public/1900000677.png")
    GUI:Image_setScale9Slice(ListView_channel_bg, 9, 9, 12, 12)
    GUI:setContentSize(ListView_channel_bg, 90, 160)
    local ListView_channel = GUI:ListView_Create(PanelChannel, "ListView_channel", 2, 2, 86, 156, 1)
    GUI:ListView_setGravity(ListView_channel, 2)
    -- 喊话
    local Image_shout = GUI:Image_Create(ListView_channel, "Image_shout", 0, 0, "res/private/chat/1900012834.png")
    local select = GUI:Image_Create(Image_shout, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)

    -- 私聊
    local Image_private = GUI:Image_Create(ListView_channel, "Image_private", 0, 0, "res/private/chat/1900012833.png")
    local select = GUI:Image_Create(Image_private, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)
    -- 行会
    local Image_guild = GUI:Image_Create(ListView_channel, "Image_guild", 0, 0, "res/private/chat/1900012831.png")
    local select = GUI:Image_Create(Image_guild, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)
    -- 组队
    local Image_team = GUI:Image_Create(ListView_channel, "Image_team", 0, 0, "res/private/chat/1900012832.png")
    local select = GUI:Image_Create(Image_team, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)
    -- 附近
    local Image_near = GUI:Image_Create(ListView_channel, "Image_near", 0, 0, "res/private/chat/1900012830.png")
    local select = GUI:Image_Create(Image_near, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)
    -- 世界
    local Image_world = GUI:Image_Create(ListView_channel, "Image_world", 0, 0, "res/private/chat/1900012836.png")
    local select = GUI:Image_Create(Image_world, "select", 24, 13, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 115, 25)

    ------------------------
    local PanelTargets = GUI:Layout_Create(PMainUI, "PanelTargets", 120, 110, 135, 200, false)
    GUI:setVisible(PanelTargets, false)
    GUI:setTouchEnabled(PanelTargets, true)
    local Panel_targets_hide = GUI:Layout_Create(PanelTargets, "Panel_targets_hide", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(Panel_targets_hide, true)
    local ListView_targets_bg = GUI:Image_Create(PanelTargets, "ListView_targets_bg", -2, -2, "res/public/1900000677.png")
    GUI:Image_setScale9Slice(ListView_targets_bg, 9, 9, 12, 12)
    GUI:setContentSize(ListView_targets_bg, 139, 204)
    local ListView_targets = GUI:ListView_Create(PanelTargets, "ListView_targets", 0, 2, 90, 156, 1)
    local targetCell = Chat.CreateTargetCell(PMainUI)
    GUI:setVisible(targetCell, false)
    
    SL:RegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Chat", Chat.OnAdapet)

    Chat._isOpen = false
    Chat.OnEnter()
end

function Chat.CreateTargetCell(parent)
    local targetCell = GUI:Layout_Create(parent, "targetCell", 0, 0, 135, 27)
    GUI:setTouchEnabled(targetCell, true)

    local imgSelect = GUI:Image_Create(targetCell, "imgSelect", 67.5, 13.5, "res/public/1900000678")
    GUI:setAnchorPoint(imgSelect, 0.5, 0.5)

    local textName = GUI:Text_Create(targetCell, "textName", 5, 13.8, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(textName, 0, 0.5)

    return targetCell
end

function Chat.OnAdapet()
    if GUI:Win_IsNull(Chat._parent) then
        return false
    end
    
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Panel_touch = GUI:GetWindow(Chat._parent, "Panel_touch")
    if Panel_touch then
        GUI:setContentSize(Panel_touch, screenW, screenH)
    end

    local PMainUI = GUI:GetWindow(Chat._parent, "PMainUI")
    if PMainUI then
        GUI:setContentSize(PMainUI, GUI:getContentSize(PMainUI).width, screenH)
    end

    local btnClose = GUI:GetWindow(Chat._parent, "PMainUI/btnClose")
    if btnClose then
        GUI:setPositionY(btnClose, screenH)
    end

    local imgClose = GUI:GetWindow(Chat._parent, "PMainUI/imgClose")
    if imgClose then
        GUI:setPositionY(imgClose, screenH/2)
    end

    local Image_bg = GUI:GetWindow(Chat._parent, "PMainUI/Image_bg")
    if  Image_bg then
        GUI:setContentSize(Image_bg, GUI:getContentSize(Image_bg).width, screenH - 28)
        GUI:setPositionY(Image_bg, screenH)
    end
    
    local ListView_receive = GUI:GetWindow(Chat._parent, "PMainUI/ListView_receive")
    if ListView_receive then
        GUI:setPositionY(ListView_receive, screenH - 10)
    end

    local Image_list_bg = GUI:GetWindow(Chat._parent, "PMainUI/Image_list_bg")
    if Image_list_bg then
        GUI:setContentSize(Image_list_bg, 327, screenH - 155)
        GUI:setPositionY(Image_list_bg, screenH - 5)
    end

    local ListView_cells = GUI:GetWindow(Chat._parent, "PMainUI/ListView_cells")
    if ListView_cells then
        GUI:setContentSize(ListView_cells, 317, screenH - 160)
        GUI:setPositionY(ListView_cells, screenH - 5)
    end
end

function Chat.OnEnter()
    if Chat._isOpen then
        return false
    end
    Chat._isOpen = true

    local PMainUI = GUI:GetWindow(Chat._parent, "PMainUI")
    if not PMainUI then
        return false
    end
    GUI:stopAllActions(PMainUI)
    GUI:setPositionX(PMainUI, -GUI:getContentSize(PMainUI).width)
    GUI:runAction(PMainUI, GUI:ActionMoveTo(0.3, cc.p(0, 0)))
end

function Chat.OnExit()
    if not Chat._isOpen then
        return false
    end
    Chat._isOpen = false

    local function callback()
        SL:CloseChatUI()
        SL:UnRegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Chat")
    end

    local PMainUI = GUI:GetWindow(Chat._parent, "PMainUI")
    if not PMainUI then
        return callback()
    end

    GUI:stopAllActions(PMainUI)
    local move = GUI:ActionMoveTo(0.3, cc.p(-GUI:getContentSize(PMainUI).width, 0))
    local func = GUI:CallFunc(callback)
    GUI:runAction(PMainUI, GUI:ActionSequence(move, func))

    if ChatExtend and ChatExtend.OnExit then
        ChatExtend.OnExit()
    end
end