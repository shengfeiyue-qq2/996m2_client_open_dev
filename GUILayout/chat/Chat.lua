Chat = {}
Chat._path = "res/private/chat/"

ChatInfo = ChatInfo or {}

local DROP_TOTAL_TYPE_ID = 99
local FAKE_DROP_TYPE_ID  = 77

Chat._CHANNEL = GUIDefine.ChatChannel
local CHANNEL = Chat._CHANNEL
-- 选择频道图片资源
Chat._selectChannelPath = {
    [CHANNEL.SHOUT]   = "1900012834.png",
    [CHANNEL.PRIVATE] = "1900012833.png",
    [CHANNEL.GUILD]   = "1900012831.png",
    [CHANNEL.TEAM]    = "1900012832.png",
    [CHANNEL.NEAR]    = "1900012830.png",
    [CHANNEL.WORLD]   = "1900012836.png",
    [CHANNEL.NATION]  = "1900012837.png",
    [CHANNEL.UNION]   = "1900012838.png",
    [CHANNEL.CROSS]   = "1900012839.png",
}
-- 接收频道图片资源
Chat._receiveChannelPath = {
    [CHANNEL.COMMON]  = "1900012846.png",
    [CHANNEL.SYSTEM]  = "1900012845.png",
    [CHANNEL.SHOUT]   = "1900012844.png",
    [CHANNEL.PRIVATE] = "1900012841.png",
    [CHANNEL.GUILD]   = "1900012843.png",
    [CHANNEL.TEAM]    = "1900012842.png",
    [CHANNEL.NEAR]    = "1900012840.png",
    [CHANNEL.WORLD]   = "1900012847.png",
    [CHANNEL.NATION]  = "1900012848.png",
    [CHANNEL.UNION]   = "1900012849.png",
    [CHANNEL.DROP]    = "1900012900.png",
    [CHANNEL.CROSS]   = "1900012901.png",
}

function Chat.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    Chat._setReceiveChannel = data and tonumber(data.receiveChannel)
    Chat._setSelectChannel = data and tonumber(data.selectChannel)
    if GUI:GetWindow(nil, UIConst.LAYERID.ChatGUI) then
        if Chat._setReceiveChannel then
            Chat.SwitchToSetChannel(Chat._setReceiveChannel)
        end
        if Chat._setSelectChannel then
            Chat.SelectChannel(Chat._setSelectChannel)
        end
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.ChatGUI, 0, 0, 0, 0, false, false, false, nil, nil, nil, 0)
    GUI:LoadExport(parent, "chat/chat_main")
    ChatInfo._ui = GUI:ui_delegate(parent)
    ChatInfo._layer = parent

    Chat.InitChatParam()
    Chat.InitUI()
    Chat.InitAdapet()
    Chat.Enter()
    Chat.CheckChatExNotice(ChatInfo._initCheckId)

    -- 指定接收频道
    if Chat._setReceiveChannel then
        Chat.SwitchToSetChannel(Chat._setReceiveChannel)
    end
    if Chat._setSelectChannel then
        Chat.SelectChannel(Chat._setSelectChannel)
    end

    Chat.RegisterEvent()
end

function Chat.InitChatParam()
    ChatInfo._channelCells = {}
    ChatInfo._receiveCells = {}
    ChatInfo._exitStatus = false
    ChatInfo._dropTypeList = {}
    ChatInfo._dropTypeCells = {}
    ChatInfo._dropListShow = true

    ChatInfo._scrollCache = {}
    ChatInfo._isScrolling = false

    ChatInfo._inputCache = {}

    ChatInfo._listInterval = nil
    ChatInfo._richVspace = nil

    ChatInfo._exChatData = {}
    ChatInfo._chatExId = 0
    ChatInfo._initCheckId = 1

    ChatInfo._exCellHei = 18

    local dropTotalData = {
        id = DROP_TOTAL_TYPE_ID,
        name = "全部",
    }
    table.insert(ChatInfo._dropTypeList, dropTotalData)

    local fakeDrop = SL:GetValue("GAME_DATA", "ShowFakeDropType")
    if fakeDrop and string.len(fakeDrop) > 0 then
        local param = string.split(fakeDrop, "#")
        if param[2] and tonumber(param[2]) == 1 and not ChatData.IsCloseFakeDrop() then
            table.insert(ChatInfo._dropTypeList, {id = FAKE_DROP_TYPE_ID, name = param[1]})
        end
    end

    local data = SL:GetValue("GAME_DATA", "DropTypeShow")
    if data and string.len(data) > 0 then
        local list = string.split(data, "|")
        for i, v in ipairs(list) do
            local param1 = string.split(v, "#")
            if param1[1] and tonumber(param1[1]) == 1 then
                table.insert(ChatInfo._dropTypeList, {id = tonumber(param1[2]), name = param1[3]})
            end
        end
    end

    local set = SL:GetValue("GAME_DATA", "ChatShowInterval")
    local idx = SL:GetValue("IS_PC_OPER_MODE") and 2 or 1
    if set and string.len(set) > 0 then
        local setList = string.split(set, "|")
        local param = setList[idx] and string.split(setList[idx], "#")
        if param and next(param) then
            ChatInfo._listInterval = tonumber(param[1])
            ChatInfo._richVspace = tonumber(param[2])
        end
    end

    ChatInfo._listHei = GUI:getContentSize(ChatInfo._ui.ListView_cells).height
    ChatInfo._listY = GUI:getPositionY(ChatInfo._ui.ListView_cells)

    Chat.InitExData()
end

function Chat.InitAdapet()
    local notch, rect = SL:GetValue("NOTCH_PHONE_INFO")
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    
    GUI:setPositionY(ChatInfo._ui.Node, screenH)
    GUI:setPositionX(ChatInfo._ui.Node, rect.x or 0)

    GUI:setContentSize(ChatInfo._ui.Panel_touch, screenW, screenH)
    GUI:setMouseEnabled(ChatInfo._ui.Panel_touch, true)

    local bgSize = GUI:getContentSize(ChatInfo._ui.Panel_bg)
    GUI:setContentSize(ChatInfo._ui.Panel_bg, bgSize.width, screenH)

    GUI:setPositionY(ChatInfo._ui.Button_close, screenH)

    local bgImgSize = GUI:getContentSize(ChatInfo._ui.Image_bg)
    GUI:setContentSize(ChatInfo._ui.Image_bg, bgImgSize.width, screenH - 28)
    GUI:setPositionY(ChatInfo._ui.Image_bg, screenH)

    GUI:setPositionY(ChatInfo._ui.ListView_receive, screenH - 5)

    local listBgSize = GUI:getContentSize(ChatInfo._ui.Image_list_bg)
    GUI:setContentSize(ChatInfo._ui.Image_list_bg, listBgSize.width, screenH - 155)
    GUI:setPositionY(ChatInfo._ui.Image_list_bg, screenH - 5)

    local listSize = GUI:getContentSize(ChatInfo._ui.ListView_cells)
    GUI:setContentSize(ChatInfo._ui.ListView_cells, listSize.width, screenH - 165)
    GUI:setPositionY(ChatInfo._ui.ListView_cells, screenH - 5)

    local wid = GUI:getContentSize(ChatInfo._ui.Panel_drop_t).width
    GUI:setContentSize(ChatInfo._ui.Panel_drop_t, wid, screenH - 158)
    GUI:setPositionY(ChatInfo._ui.Panel_drop_t, screenH - 5)

    ChatInfo._listHei = GUI:getContentSize(ChatInfo._ui.ListView_cells).height
    ChatInfo._listY = GUI:getPositionY(ChatInfo._ui.ListView_cells)

end

function Chat.Enter()
    local bgSize = GUI:getContentSize(ChatInfo._ui.Panel_bg)
    GUI:stopAllActions(ChatInfo._ui.Panel_bg)
    GUI:setPositionX(ChatInfo._ui.Panel_bg, - bgSize.width)
    GUI:Timeline_MoveTo(ChatInfo._ui.Panel_bg, {x = 0, y = 0}, 0.3)
end

function Chat.Exit()
    if ChatInfo._exitStatus then
        return
    end
    ChatInfo._exitStatus = true

    local function callback()
        UIOperator:CloseChatUI()
    end
    local bgSize = GUI:getContentSize(ChatInfo._ui.Panel_bg)
    GUI:stopAllActions(ChatInfo._ui.Panel_bg)
    GUI:Timeline_MoveTo(ChatInfo._ui.Panel_bg, {x = - bgSize.width, y = 0}, 0.3, callback)
end

function Chat.InitUI()
    -- cdTime
    SL:schedule(ChatInfo._ui.Button_send, Chat.UpdateCDTime, 1)

    -- close
    local function close()
        Chat.Exit()
    end
    GUI:addOnClickEvent(ChatInfo._ui.Panel_touch, close)
    GUI:addOnClickEvent(ChatInfo._ui.Image_close, close)
    GUI:addOnClickEvent(ChatInfo._ui.Button_close, close)

    -- 表情
    GUI:addOnClickEvent(ChatInfo._ui.Button_input_2, function()
        UIOperator:OpenChatExtendUI({group = 2})
    end)

    -- 背包
    GUI:addOnClickEvent(ChatInfo._ui.Button_input_3, function()
        UIOperator:OpenChatExtendUI({group = 3})
    end)

    -- 坐标
    GUI:addOnClickEvent(ChatInfo._ui.Button_input_4, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestSendChatPosMsg()
    end)

    -- 配置聊天框列表间隔
    if ChatInfo._listInterval then
        GUI:ListView_setItemsMargin(ChatInfo._ui.ListView_cells, ChatInfo._listInterval)
        GUI:ListView_setItemsMargin(ChatInfo._ui.ListView_ex, ChatInfo._listInterval)
    end

    GUI:ListView_addOnScrollEvent(ChatInfo._ui.ListView_cells, function(_, eventType)
        if eventType == GUIDefine.ScrollEventType.CONTAINER_MOVED or eventType == GUIDefine.ScrollEventType.AUTOSCROLL_ENDED then
            local innerPos = GUI:ListView_getInnerContainerPosition(ChatInfo._ui.ListView_cells)
            if innerPos.y == 0 and ChatInfo._isScrolling then
                ChatInfo._isScrolling = false
                Chat.ShowCacheItems()
            end
        end
    end)

    GUI:addOnClickEvent(ChatInfo._ui.ListView_cells, function()
        SL:onLUAEvent(LUA_EVENT_CHAT_EXTEND_EXIT_ACTION)
    end)


    Chat.InitInput()
    Chat.InitChannels()
    Chat.InitTargets()
    Chat.InitReceiving()
    Chat.InitDropPanel()

    Chat.HideChannels()
    Chat.UpdateChannel()
    Chat.UpdateCDTime()
    Chat.UpdateTarget()
end

function Chat.InitInput()
    -- 历史记录
    ChatInfo._inputCache = SL:CopyData(ChatData.GetInputCache())
    -- 上次输入
    GUI:addOnClickEvent(ChatInfo._ui.Button_input_5, function()
        if #ChatInfo._inputCache == 0 then
            return
        end
        local cache = table.remove(ChatInfo._inputCache, #ChatInfo._inputCache)
        GUI:TextInput_setString(ChatInfo._ui.TextField_input, cache)
    end)

    -- 发送
    GUI:addOnClickEvent(ChatInfo._ui.Button_send, function(sender)
        GUI:delayTouchEnabled(sender)
        local input = GUI:TextInput_getString(ChatInfo._ui.TextField_input)
        GUI:TextInput_setString(ChatInfo._ui.TextField_input, "")

        -- 没有输入
        if string.len(input) <= 0 then
            SL:ShowSystemTips("您还未输入任何信息！")
            return
        end

        local function sendChatMsg(input, risk_param, ext_param)
            -- 存储到输入缓存
            ChatData.AddInputCache(input)
            ChatInfo._inputCache = SL:CopyData(ChatData.GetInputCache())

            -- 发送
            local oriMsg = ext_param and ext_param.originStr
            local sensitiveWords = ext_param and ext_param.replacedWords
            local status = ext_param and ext_param.status
            local sendData = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = ChatData.GetCurChannel(), risk = risk_param, oriMsg = oriMsg, sensitiveWords = sensitiveWords, status = status}
            GUIFunction:SendChatMsg(sendData)
        end

        local sIdx, eIdx = string.find(input, "^@传 .-")
        local special_Str = nil
        if sIdx and eIdx then
            special_Str = string.sub(input, eIdx + 1, string.len(input))
        end

        local channelID, content = GUIFunction:GetChannelByChatMsg(input)
        local targetName = GUIFunction:FindTargetByChatMsg(input)

        -- 敏感词
        if not (string.find(input, "^@.-") and not special_Str) then
            -- 后台控制不可聊天
            if SL:GetValue("M2_FORBID_SAY", true) then
                return
            end

            local function handleFunc(_, str, risk_param, ext_param)
                if not str then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    return
                end

                if special_Str then
                    str = "@传 " .. str
                elseif targetName then
                    str = string.format("/%s %s", targetName, str)
                end

                sendChatMsg(str, risk_param, ext_param)
            end

            local data = {}
            local channel = ChatData.GetCurChannel()
            data.channel_id = channel
            if channel == Chat._CHANNEL.PRIVATE then
                local target = ChatData.GetTargets()[1]
                if target then
                    data.to_role_level = SL:GetValue("ACTOR_LEVEL", target.uid)
                    data.to_role_id    = target.uid
                    data.to_role_name  = target.name
                end
            end
            if channelID == Chat._CHANNEL.PRIVATE then
                input = content
            end
            SL:RequestCheckSensitiveWord(special_Str or input, 2, handleFunc, data)
        else
            sendChatMsg(input)
        end
    end)

    -- 自动喊话
    if ChatInfo._ui.Layout_check_auto_shout and GUI:getVisible(ChatInfo._ui.Layout_check_auto_shout) then
        local normalPanel  = GUI:getChildByName(ChatInfo._ui.Layout_check_auto_shout, "Layout_nomal")
        local selectPanel = GUI:getChildByName(ChatInfo._ui.Layout_check_auto_shout, "Layout_select")
        -- 改变自动喊话按钮
        local function changeAutoShoutButton()
            local isOpen = ChatData.GetAutoShoutSwitch()
            GUI:setVisible(normalPanel, not isOpen)
            GUI:setVisible(selectPanel, isOpen)
        end

        local function checkInputContent(inputStr)
            local channel = Chat._CHANNEL.SHOUT
            SL:RequestCheckSensitiveWord(inputStr, 2, function(state, str, risk_param, ex_param) 
                -- 检测，不通过
                if not state then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    return
                end
    
                if risk_param and risk_param ~= 0 then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    return
                end

                if ex_param then
                    if ex_param.status and ex_param.status ~= 0 then
                        SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                        return
                    end
                end

                ChatData.SetAutoShoutSwitch(not ChatData.GetAutoShoutSwitch())

                -- 记录自动喊话内容
                ChatData.SetLocalChatDataByChannel(channel, inputStr or "")

                -- 发送提示
                local isOpen = ChatData.GetAutoShoutSwitch()
                local msg = isOpen and "启动了自动喊话功能，聊天框中内容已记录为喊话内容" or "关闭了自动喊话功能"
                SL:ShowSystemChat(msg, 0, 255)
                SL:PlayBtnClickAudio()
                SL:onLUAEvent(LUA_EVENT_CHAT_MOBILE_AUTO_SHOUT)

                changeAutoShoutButton()

            end, {channel_id = channel})
        end

        local isAutoShout = ChatData.GetAutoShoutSwitch()
        GUI:addOnClickEvent(ChatInfo._ui.Layout_check_auto_shout, function()
            local input = GUI:TextInput_getString(ChatInfo._ui.TextField_input)
            checkInputContent(input)
        end)

        changeAutoShoutButton()
        SL:onLUAEvent(LUA_EVENT_CHAT_MOBILE_AUTO_SHOUT, {openChat = true})
    end

    -- 草稿填入
    local inputStr = ChatData.GetInputDraft()
    if inputStr then
        Chat.AddInput(inputStr)
    end

end

-- 频道选择栏
function Chat.InitChannels()
    local CHANNEL = Chat._CHANNEL
    local channelName = {
        [CHANNEL.SHOUT]   = "Image_shout",
        [CHANNEL.PRIVATE] = "Image_private",
        [CHANNEL.GUILD]   = "Image_guild",
        [CHANNEL.TEAM]    = "Image_team",
        [CHANNEL.NEAR]    = "Image_near",
        [CHANNEL.WORLD]   = "Image_world",
        [CHANNEL.NATION]  = "Image_nation",
        [CHANNEL.UNION]   = "Image_union",
        [CHANNEL.CROSS]   = "Image_cross",
    }
    local removeIdList = string.split(SL:GetValue("GAME_DATA", "MobileChannelNotShow") or "", "#")
    for k, v in pairs(channelName) do
        local cell = ChatInfo._ui[v]
        for _, id in ipairs(removeIdList) do
            if tonumber(id) and tonumber(id) == k and cell then
                GUI:removeFromParent(cell)
                cell = nil
                break
            end
        end
        if cell then
            local contentSize = GUI:getContentSize(cell)
            local brightImg = GUI:Image_Create(cell, "brightImg", contentSize.width / 2, contentSize.height / 2, "res/public/1900000678.png")
            GUI:setAnchorPoint(brightImg, 0.5, 0.5)
            GUI:setLocalZOrder(brightImg, -1)
            GUI:setContentSize(brightImg, 115, 25)
            GUI:setTouchEnabled(cell, true)
            GUI:addOnClickEvent(cell, function()
                Chat.HideChannels()
                Chat.SelectChannel(k)
            end)

            ChatInfo._channelCells[k] = {
                button      = cell,
                brightImg   = brightImg,
            }
        end
    end

    local function callback()
        if GUI:getVisible(ChatInfo._ui.Panel_channel) then
            Chat.HideChannels()
        else
            Chat.ShowChannels()
        end
    end

    GUI:setTouchEnabled(ChatInfo._ui.Image_arrow, true)
    GUI:addOnClickEvent(ChatInfo._ui.Image_arrow, callback)
    GUI:setTouchEnabled(ChatInfo._ui.Image_channel, true)
    GUI:addOnClickEvent(ChatInfo._ui.Image_channel, callback)

    local listWid   = GUI:getContentSize(ChatInfo._ui.ListView_channel).width
    local count     = GUI:ListView_getItemCount(ChatInfo._ui.ListView_channel)
    local cell      = GUI:ListView_getItems(ChatInfo._ui.ListView_channel)[1]
    local cellHei   = cell and GUI:getContentSize(cell).height
    local listHei   = cellHei * count
    GUI:setContentSize(ChatInfo._ui.ListView_channel, listWid, listHei)
    GUI:setContentSize(ChatInfo._ui.Panel_channel, listWid, listHei + 4)
    local listBg = GUI:getChildByName(ChatInfo._ui.Panel_channel, "Image_channel")
    GUI:setContentSize(listBg, listWid, listHei + 4)
    GUI:setPositionY(listBg, (listHei + 4) / 2)
    GUI:setPositionY(ChatInfo._ui.ListView_channel, (listHei + 4) / 2)
end

function Chat.ShowChannels()
    GUI:setVisible(ChatInfo._ui.Panel_channel, true)
    GUI:setRotation(ChatInfo._ui.Image_arrow, 180)

    local curChannel = ChatData.GetCurChannel()
    for k, v in pairs(ChatInfo._channelCells) do
        GUI:setVisible(v.brightImg, k == curChannel)
    end
end

function Chat.HideChannels()
    GUI:setVisible(ChatInfo._ui.Panel_channel, false)
    GUI:setRotation(ChatInfo._ui.Image_arrow, 0)
end

function Chat.SelectChannel(channel)
    ChatData.SetCurChannel(channel)
    Chat.UpdateChannel()
    Chat.UpdateTarget()
    Chat.UpdateCDTime()
end

function Chat.UpdateChannel()
    local curChannel = ChatData.GetCurChannel()

    local channelPath = Chat._selectChannelPath
    if channelPath and channelPath[curChannel] then
        GUI:Image_loadTexture(ChatInfo._ui.Image_channel, Chat._path .. channelPath[curChannel])
        GUI:setIgnoreContentAdaptWithSize(ChatInfo._ui.Image_channel, true)
    end
end

function Chat.UpdateCDTime()
    local cdTime = ChatData.GetCurrCDTime()
    local sendEnable = not (cdTime and cdTime > 0)
    GUI:setTouchEnabled(ChatInfo._ui.Button_send, sendEnable)
    GUI:setVisible(ChatInfo._ui.Image_send, sendEnable)
    GUI:Button_setTitleText(ChatInfo._ui.Button_send, sendEnable and "" or cdTime)
end

-- 目标栏
function Chat.InitTargets()
    -- 选择目标
    GUI:addOnClickEvent(ChatInfo._ui.Image_target, function()
        Chat.ShowTargets()
    end)

    local hideTargetPanel = GUI:Layout_Create(ChatInfo._ui.Panel_targets, "Panel_targets_hide", 0.00, 0.00, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"), false)
	GUI:setLocalZOrder(hideTargetPanel, -1)
    GUI:setTouchEnabled(hideTargetPanel, true)
    ChatInfo._hideTargetPanel = hideTargetPanel
    -- 隐藏
    GUI:addOnClickEvent(ChatInfo._hideTargetPanel, function()
        Chat.HideTargets()
    end)

    Chat.HideTargets()
end

function Chat.ShowTargets()
    GUI:setVisible(ChatInfo._ui.Panel_targets, true)
    GUI:ListView_removeAllItems(ChatInfo._ui.ListView_targets)
    GUI:Image_loadTexture(ChatInfo._ui.Image_target_a, Chat._path .. "1900012827.png")

    GUI:setVisible(ChatInfo._hideTargetPanel, true)
    local worldPos = GUI:convertToNodeSpace(ChatInfo._ui.Panel_targets, 0, 0)
    GUI:setPosition(ChatInfo._hideTargetPanel, worldPos.x, worldPos.y)

    local targets = ChatData.GetTargets()
    for index, target in ipairs(targets) do
        local cell = Chat.CreateTargetCell(target, index)
        GUI:addOnClickEvent(cell, function()
            Chat.HideTargets()
            SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = target.name, uid = target.uid})
        end)
        GUI:ListView_pushBackCustomItem(ChatInfo._ui.ListView_targets, cell)
    end
    local count  = math.min(#targets, 7)
    local width  = 150
    local height = 28 * count
    GUI:setContentSize(ChatInfo._ui.ListView_targets, width, height)
    GUI:setContentSize(ChatInfo._ui.Panel_targets, width, height)
    GUI:setContentSize(ChatInfo._ui.Image_targets, width + 4, height + 4)
end

function Chat.HideTargets()
    GUI:setVisible(ChatInfo._ui.Panel_targets, false)
    GUI:ListView_removeAllItems(ChatInfo._ui.ListView_targets)
    GUI:Image_loadTexture(ChatInfo._ui.Image_target_a, Chat._path .. "1900012828.png")
end

function Chat.CreateTargetCell(target, index)
    local widget = GUI:Widget_Create(-1, "Widget_" .. index, 0, 0, 0, 0)
    GUI:LoadExport(widget, "chat/target_cell")
    local cell = GUI:getChildByName(widget, "Panel_cell")

    local selectImg = GUI:getChildByName(cell, "Image_select")
    local nameText = GUI:getChildByName(cell, "Text_name")
    GUI:setVisible(selectImg, index == 1)
    GUI:Text_setString(nameText, target.name)
    GUI:Text_setTextColor(nameText, index == 1 and "#FFFF00" or "#FFFFFF")
    
    GUI:removeFromParent(cell)
    return cell
end

function Chat.UpdateTarget()
    local target = ChatData.GetTargets()[1]
    local curChannel = ChatData.GetCurChannel()
    if curChannel == Chat._CHANNEL.PRIVATE and target then
        GUI:setVisible(ChatInfo._ui.Image_target, true)
        GUI:Text_setString(ChatInfo._ui.Text_target, target.name)
    else
        GUI:setVisible(ChatInfo._ui.Image_target, false)
    end
end

-- 频道接收
function Chat.InitReceiving()
    local CHANNEL = Chat._CHANNEL
    local channels = {
        CHANNEL.COMMON,
        CHANNEL.DROP,
        CHANNEL.SYSTEM,
        CHANNEL.SHOUT,
        CHANNEL.PRIVATE,
        CHANNEL.GUILD,
        CHANNEL.TEAM,
        CHANNEL.NEAR,
        CHANNEL.WORLD,
        CHANNEL.NATION,
        CHANNEL.UNION,
        CHANNEL.CROSS,
    }

    local function checkHideChannel(channel)
        if SL:GetValue("GAME_DATA","MobileChannelNotShow") then
            local removeIdList = string.split(SL:GetValue("GAME_DATA","MobileChannelNotShow"), "#")
            for i, id in ipairs(removeIdList) do
                if tonumber(id) and tonumber(id) == channel then
                    return true
                end
            end
        end
        return false
    end

    for _, channel in ipairs(channels) do
        if not checkHideChannel(channel) then
            local cell = Chat.CreateReceivingCell(channel)
            -- 接收开关
            GUI:CheckBox_addOnEvent(cell.checkBox, function()
                local isSelected = GUI:CheckBox_isSelected(cell.checkBox)
                if channel == CHANNEL.COMMON then
                    for _, channel in pairs(Chat._CHANNEL) do
                        ChatData.SetReceiving(channel, isSelected)
                    end
                else
                    ChatData.SetReceiving(channel, isSelected)
                end

                for channel, cell in pairs(ChatInfo._receiveCells) do
                    local isReceiving = ChatData.IsReceiving(channel)
                    GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                    if channel == CHANNEL.DROP then
                        ChatData.SetReceiving(channel, isReceiving)
                        for channel, cell in pairs(ChatInfo._dropTypeCells) do
                            ChatData.SetDropTypeSwitch(channel, isReceiving)
                            GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                        end
                    end
                end
            end)

            -- 选择
            GUI:addOnClickEvent(cell.channelBtn, function()
                if channel == CHANNEL.DROP then 
                    ChatInfo._dropListShow = ChatInfo._dropListShow and channel == CHANNEL.DROP
                end
                GUI:setVisible(ChatInfo._ui.Panel_drop, ChatInfo._dropListShow)
                GUI:setVisible(ChatInfo._ui.Panel_drop_t, channel == CHANNEL.DROP)
                Chat.SetReceiveChannel(channel)

                -- 映射到发送频道
                if (channel ~= CHANNEL.COMMON and channel ~= CHANNEL.SYSTEM and channel ~= CHANNEL.DROP) then
                    Chat.HideChannels()
                    Chat.SelectChannel(channel)
                end
            end)

            ChatInfo._receiveCells[channel] = cell
            GUI:ListView_pushBackCustomItem(ChatInfo._ui.ListView_receive, cell.layout)
        end
    end

    Chat.UpdateReceivingShow()
end

function Chat.CreateReceivingCell(channel)
    local widget = GUI:Widget_Create(-1, "Widget_" .. channel, 0, 0, 0, 0)
    GUI:LoadExport(widget, "chat/receiving_cell")
    local cell = GUI:getChildByName(widget, "Panel_cell")

    local channelBtn = GUI:getChildByName(cell, "Button_channel")
    local nameImg = GUI:getChildByName(cell, "Image_name")
    local checkBox = GUI:getChildByName(cell, "CheckBox_receiving")
    
    local isReceiving = ChatData.IsReceiving(channel)
    local channelPath = Chat._receiveChannelPath
    if channelPath and channelPath[channel] then
        GUI:Image_loadTexture(nameImg, Chat._path .. channelPath[channel])
    end
    
    GUI:CheckBox_setSelected(checkBox, isReceiving == true)
    GUI:CheckBox_setZoomScale(checkBox, -0.05)
    
    local data = {
        layout = cell,
        channelBtn = channelBtn,
        checkBox = checkBox
    }
    GUI:removeFromParent(cell)
    return data
end

function Chat.SetReceiveChannel(channel)
    ChatData.SetReceiveChannel(channel)

    Chat.UpdateReceivingShow()
end

function Chat.UpdateReceivingShow()
    local receiveChannel = ChatData.GetReceiveChannel()
    if receiveChannel == Chat._CHANNEL.PRIVATE then
        SL:DelBubbleTips(GUIDefine.BubbleType.PRIVATE_CHAT)
    end

    -- 选中的
    if Chat and ChatInfo._receiveCells then
        for channel, cell in pairs(ChatInfo._receiveCells) do
            GUI:Button_setBrightEx(cell.channelBtn, receiveChannel ~= channel)
        end
        if ChatInfo._ui and ChatInfo._ui.Panel_drop_t then
            GUI:setVisible(ChatInfo._ui.Panel_drop_t, receiveChannel == Chat._CHANNEL.DROP)
        end
    end

    -- 清理
    ChatInfo._scrollCache = {}
    ChatInfo._isScrolling = false
    GUI:ListView_removeAllItems(ChatInfo._ui.ListView_cells)

    -- 消息
    local receiveCache = ChatData.GetCache()
    for _, v in ipairs(receiveCache) do
        Chat.OnPushChatItem(v)
    end
    GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
end

function Chat.ShowCacheItems()
    -- 缓存填充
    while #ChatInfo._scrollCache > 0 do
        local item = table.remove(ChatInfo._scrollCache, 1)
        GUI:autoDecRef(item)
        Chat.OnPushChatItem(item)
    end
    GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
end

function Chat.OnPushChatItem(item)
    local limitCount = GUIDefine.ChatConfig.LIMIT_COUNT
    GUI:ListView_pushBackCustomItem(ChatInfo._ui.ListView_cells, item)

    SL:scheduleOnce(ChatInfo._ui.ListView_cells, function()
        if GUI:ListView_getItemCount(ChatInfo._ui.ListView_cells) > limitCount then
            GUI:ListView_removeItemByIndex(ChatInfo._ui.ListView_cells, 0)
        end
        GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
    end, 1 / 60)
end

function Chat.OnAddChatItem(data)
    local item = data.item
    local channel = data.channel
    if not item or not channel then
        return
    end

    local receiveChannel = ChatData.GetReceiveChannel()
    if receiveChannel == Chat._CHANNEL.COMMON or receiveChannel == channel or (receiveChannel == Chat._CHANNEL.GUILD and channel == Chat._CHANNEL.GUILDTIPS) then
        -- 是否正在拖动
        local chatListView = ChatInfo._ui.ListView_cells
        local cellList = GUI:ListView_getItems(chatListView)
        if next(cellList) then
            local lastItem = GUI:ListView_getItemByIndex(chatListView, #cellList - 1)
            local itemSize = GUI:getContentSize(lastItem)
            local worldPosY = GUI:getWorldPosition(lastItem).y
            local listY = GUI:getWorldPosition(chatListView).y - GUI:getContentSize(chatListView).height
            if worldPosY < listY then
                ChatInfo._isScrolling = true
            end
        end

        if ChatInfo._isScrolling then
            -- 正在拖动, 消息缓存
            GUI:addRef(item)
            table.insert(ChatInfo._scrollCache, item)

            while #ChatInfo._scrollCache > GUIDefine.ChatConfig.LIMIT_COUNT do
                local item = table.remove(ChatInfo._scrollCache, 1)
                GUI:autoDecRef(item)
            end
        else
            Chat.OnPushChatItem(item)
            GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
        end
    end
end

function Chat.AddInput(str)
    local maxInputLength = GUIDefine.ChatConfig.INPUT_LENTH
    -- 是否超出上限
    local textStr = GUI:TextInput_getString(ChatInfo._ui.TextField_input) .. str
    if string.utf8len(textStr) > maxInputLength then
        SL:ShowSystemTips("已超出输入上限")
    else
        GUI:TextInput_setString(ChatInfo._ui.TextField_input, textStr)
    end
end

function Chat.ReplaceInput(str)
    local maxInputLength = GUIDefine.ChatConfig.INPUT_LENTH
    if string.utf8len(str) > maxInputLength then
        SL:ShowSystemTips("已超出输入上限")
    else
        GUI:TextInput_setString(ChatInfo._ui.TextField_input, str)
    end
end

function Chat.InitExData()
    ChatInfo._exChatData = SL:CopyData(ChatData.GetChatExItemsData())
    for _, data in ipairs(ChatInfo._exChatData) do
        ChatInfo._chatExId = ChatInfo._chatExId + 1
        data.chatExId = ChatInfo._chatExId
    end
end

function Chat.RemoveChatExItemData(data)
    if not data then
        return
    end
    local chatExId = data.chatExId
    for i, item in ipairs(ChatInfo._exChatData) do
        if item.chatExId and item.chatExId == chatExId then
            table.remove(ChatInfo._exChatData, i)
            break
        end
    end
end

function Chat.ResetExListSizeByData()
    local exListView = ChatInfo._ui.ListView_ex
    local itemCount = #ChatInfo._exChatData
    local margin = GUI:ListView_getItemsMargin(exListView)
    local height = ChatInfo._exCellHei * itemCount + (itemCount - 1) * margin
    GUI:setContentSize(exListView, GUI:getContentSize(exListView).width, height)

    local listSize = GUI:getContentSize(ChatInfo._ui.ListView_cells)
    GUI:setContentSize(ChatInfo._ui.ListView_cells, listSize.width, ChatInfo._listHei - height)
    GUI:setPositionY(ChatInfo._ui.ListView_cells, ChatInfo._listY - height)
    GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
end

function Chat.AddChatExItemData(data)
    table.insert(ChatInfo._exChatData, data)
    ChatInfo._chatExId = ChatInfo._chatExId + 1
    data.chatExId = ChatInfo._chatExId

    Chat.CheckChatExNotice()
end

function Chat.CheckChatExNotice(initId)
    local exListView = ChatInfo._ui.ListView_ex
    if GUI:ListView_getItemCount(exListView) >= GUIDefine.ChatConfig.LIMIT_COUNT_EX then
        return
    end

    if #ChatInfo._exChatData == 0 then
        local oriWidth = GUI:getContentSize(exListView).width
        GUI:setContentSize(exListView, oriWidth, 0)
        return
    end

    local data = ChatInfo._exChatData[initId or #ChatInfo._exChatData]
    if not data then
        return
    end

    data.Time = data.Time or 5
    if data.Time <= 0 then
        Chat.RemoveChatExItemData(data)
        Chat.ResetExListSizeByData()
        return
    end
    
    data.Label        = data.Label or ""
    data.Y            = data.Y or 0
    data.Count        = data.Count or 1
    data.FColor       = data.FColor or 255
    data.BColor       = data.BColor or 255
    data.SendNameTemp = data.SendName or ""

    local BColorEnable = data.BColor ~= -1
    local FColorHex    = SL:GetHexColorByStyleId(data.FColor)
    local BColorHex    = SL:GetHexColorByStyleId(data.BColor)
    local cWidth       = GUI:getContentSize(exListView).width
    local capacitySize = {width = cWidth, height = ChatInfo._exCellHei}

    local function resetListView()
        local items = GUI:ListView_getItems(exListView)
        local height = 0
        local margin = GUI:ListView_getItemsMargin(exListView)
        for i, v in ipairs(items) do
            local interval = i ~= #items and margin or 0
            height = height + GUI:getContentSize(v).height + interval
        end
        GUI:setContentSize(exListView, capacitySize.width, height)

        local listSize = GUI:getContentSize(ChatInfo._ui.ListView_cells)
        GUI:setContentSize(ChatInfo._ui.ListView_cells, listSize.width, ChatInfo._listHei - height)
        GUI:setPositionY(ChatInfo._ui.ListView_cells, ChatInfo._listY - height)
        GUI:ListView_jumpToBottom(ChatInfo._ui.ListView_cells)
    end

    local layout = GUI:Layout_Create(-1, "layout", 0, 0, capacitySize.width, capacitySize.height)
    if BColorEnable then
        GUI:Layout_setBackGroundColorType(layout, 0)
        GUI:Layout_setBackGroundColor(layout, BColorHex)
    end
    GUI:ListView_pushBackCustomItem(exListView, layout)
    resetListView()

    local scrollWidget = GUI:Widget_Create(layout, "scrollWidget", 0, 0, capacitySize.width, capacitySize.height)
    
    local scrollAble = nil
    local scrollSize = {width = 0, height = 0}
    local remaining = data.Time
    local Msg = SL:FixStringFormatCharacter(data.Msg)
    local hasFormat = string.find(Msg, "%%") 
    local showName = data.SendName and (data.SendName .. ": ") or ""
    local function callback()
        local name = showName or ""
        local str  = name .. (hasFormat and string.format(Msg, remaining) or Msg)
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
        GUI:removeAllChildren(scrollWidget)
        local richText = GUI:RichTextFCOLOR_Create(scrollWidget, "richText", 0, capacitySize.height / 2, str, 1000, fontSize, FColorHex, ChatInfo._richVspace or 0)
        GUI:setAnchorPoint(richText, 0, 0.5)
        GUI:setTouchEnabled(richText, true)
        GUI:addOnClickEvent(richText, function()
            if data.SendName and data.SendId then
                SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = data.SendNameTemp, uid = data.SendId})
            end
        end)
        if BColorEnable then
            GUI:RichTextFCOLOR_setBackgroundColor(richText, BColorHex)
        end
        if not scrollAble then
            scrollSize = GUI:getContentSize(richText)
            scrollAble = scrollSize.width > capacitySize.width
        end
        local richTextSize = GUI:getContentSize(richText)
        GUI:setContentSize(scrollWidget, capacitySize.width, richTextSize.height)
        GUI:setContentSize(layout, capacitySize.width, richTextSize.height)
        if remaining < 0 then
            GUI:ListView_removeItemByIndex(exListView, GUI:ListView_getItemIndex(exListView, layout))
            resetListView()
            Chat.RemoveChatExItemData(data)
        end

        remaining = remaining - 1
    end
    SL:schedule(layout, callback, 1)
    callback()

    -- 滚动
    if scrollAble then
        local actionT = (scrollSize.width - capacitySize.width) / 50
        GUI:runAction(scrollWidget, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionMoveTo(actionT, capacitySize.width - scrollSize.width, 0), 
            GUI:DelayTime(3), GUI:ActionMoveTo(0, 0, 0))))
    end

    if initId then
        ChatInfo._initCheckId = initId + 1
        Chat.CheckChatExNotice(ChatInfo._initCheckId)
    end
end

function Chat.SwitchToSetChannel(channel)
    Chat.SetReceiveChannel(channel)

    if channel ~= Chat._CHANNEL.COMMON and channel ~= Chat._CHANNEL.SYSTEM then
        Chat.HideChannels()
        Chat.SelectChannel(channel)
    end
end

-- 掉落分类
function Chat.InitDropPanel(isRefresh)
    local cellWid = nil
    local cellHei = nil
    for _, data in ipairs(ChatInfo._dropTypeList) do
        local id = data.id
        local defaultName = nil
        if string.len(data.name) == 0 then
            defaultName = id == FAKE_DROP_TYPE_ID and "分类0" or ("分类" .. id)
        end
        local name = defaultName or data.name
        local cell = Chat.CreateDropSwitchCell(id)
        local isReceiving = ChatData.GetDropTypeSwitch(id)
        GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
        GUI:Text_setString(cell.nameText, name)
        local nameWid = GUI:getContentSize(cell.nameText).width
        local posX = GUI:getPositionX(cell.nameText)

        -- 接收开关
        GUI:CheckBox_addOnEvent(cell.checkBox, function()
            local isSelected = GUI:CheckBox_isSelected(cell.checkBox)
            if id == DROP_TOTAL_TYPE_ID then
                for channel, cell in pairs(ChatInfo._dropTypeCells) do
                    ChatData.SetDropTypeSwitch(channel, isSelected)
                end
            else
                ChatData.SetDropTypeSwitch(id, isSelected)
            end
            for channel, cell in pairs(ChatInfo._dropTypeCells) do
                local isReceiving = ChatData.GetDropTypeSwitch(channel)
                GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                if channel == DROP_TOTAL_TYPE_ID then
                    ChatData.SetReceiving(Chat._CHANNEL.DROP, isReceiving)
                end
            end
            for channel, cell in pairs(ChatInfo._receiveCells) do
                local isReceiving = ChatData.IsReceiving(channel)
                GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
            end
        end)

        local tempWid = posX + nameWid + 8
        if not cellWid or not cellHei then
            cellWid = math.max(tempWid, GUI:getContentSize(cell.layout).height)
            cellHei = GUI:getContentSize(cell.layout).height
        else
            cellWid = math.max(tempWid, cellWid)
        end

        ChatInfo._dropTypeCells[id] = cell
        GUI:ListView_pushBackCustomItem(ChatInfo._ui.List_drop_type, cell.layout)
    end

    if isRefresh then
        return
    end

    local margin = GUI:ListView_getItemsMargin(ChatInfo._ui.List_drop_type)
    local num = GUI:ListView_getItemCount(ChatInfo._ui.List_drop_type)
    local listWid = cellWid
    local switchSizeH = GUI:getContentSize(ChatInfo._ui.Panel_drop_switch).height
    local bgSizeH = GUI:getContentSize(ChatInfo._ui.Panel_drop_t).height - switchSizeH
    GUI:setContentSize(ChatInfo._ui.Panel_drop, listWid + 2, bgSizeH)
    GUI:setContentSize(ChatInfo._ui.List_drop_type, listWid, bgSizeH - 2)
    GUI:setContentSize(ChatInfo._ui.Panel_drop_switch, listWid + 2, switchSizeH)
    GUI:setPositionX(ChatInfo._ui.Image_drop_arrow, (listWid + 2) / 2)


    GUI:delayTouchEnabled(ChatInfo._ui.Panel_drop_switch, 0.5)
    GUI:addOnClickEvent(ChatInfo._ui.Panel_drop_switch, function ()
        ChatInfo._dropListShow = not ChatInfo._dropListShow
        GUI:setVisible(ChatInfo._ui.Panel_drop, ChatInfo._dropListShow)
        GUI:setOpacity(ChatInfo._ui.Panel_drop_switch, ChatInfo._dropListShow and 255 or 160)
        local path = string.format(Chat._path .. "drop/arrow_%s.png", ChatInfo._dropListShow and 1 or 2)
        GUI:Image_loadTexture(ChatInfo._ui.Image_drop_arrow, path)
    end)

end

function Chat.CreateDropSwitchCell(id)
    local widget = GUI:Widget_Create(-1, "Widget_" .. id, 0, 0, 0, 0)
    GUI:LoadExport(widget, "chat/drop_switch_cell")
    local cell = GUI:getChildByName(widget, "Panel_cell")

    local checkBox = GUI:getChildByName(cell, "CheckBox_drop")
    local nameText = GUI:getChildByName(cell, "Text_drop_name")
    GUI:CheckBox_setZoomScale(checkBox, -0.05)
    
    local data = {
        layout = cell,
        checkBox = checkBox,
        nameText = nameText
    }
    GUI:removeFromParent(cell)
    return data
end

function Chat.RefreshFakeDropType()
    local needRefresh = false
    local hasFake = false
    for i, v in ipairs(ChatInfo._dropTypeList) do
        if v.id == FAKE_DROP_TYPE_ID then
            if ChatData.IsCloseFakeDrop() then
                table.remove(ChatInfo._dropTypeList, i)
                needRefresh = true
            end
            hasFake = true
            break
        end
    end

    if not ChatData.IsCloseFakeDrop() and not hasFake then
        local fakeDrop = SL:GetValue("GAME_DATA", "ShowFakeDropType")
        if fakeDrop and string.len(fakeDrop) > 0 then
            local param = string.split(fakeDrop, "#")
            if param[2] and tonumber(param[2]) == 1 then
                table.insert(ChatInfo._dropTypeList, 2, {id = FAKE_DROP_TYPE_ID, name = param[1]})
                needRefresh = true
            end
        end
    end

    if needRefresh then
        ChatInfo._dropTypeCells = {}
        GUI:ListView_removeAllItems(ChatInfo._ui.List_drop_type)

        Chat.InitDropPanel(true)
    end
end

function Chat.OnWindowResized()
    Chat.InitAdapet()
end

function Chat.OnDRotationChanged()
    Chat.InitAdapet()
end

function Chat.OnClearExChat()
    GUI:stopAllActions(ChatInfo._ui.ListView_ex)
    GUI:ListView_removeAllItems(ChatInfo._ui.ListView_ex)
    ChatInfo._exChatData = {}
    Chat.ResetExListSizeByData()
end

function Chat.OnChatFakeDropChange()
    local receiveChannel = ChatData.GetReceiveChannel()
    if receiveChannel == Chat._CHANNEL.DROP then
        Chat.RefreshFakeDropType()
    end
end

function Chat.OnClose()
    ChatData.SetInputDraft(GUI:TextInput_getString(ChatInfo._ui.TextField_input))
    GUI:Win_CloseByID(UIConst.LAYERID.ChatGUI)
    SL:onLUAEvent(LUA_EVENT_CHAT_EXTEND_EXIT_ACTION)
    ChatInfo = nil
    Chat.UnRegisterEvent()
end

----------------------------------------------
function Chat.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_ITEM_ADD, "Chat", Chat.OnAddChatItem, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_ENTER_CD, "Chat", Chat.UpdateCDTime, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PUSH_INPUT, "Chat", Chat.AddInput, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_REPLACE_INPUT, "Chat", Chat.ReplaceInput, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_TARGET_CHANGE, "Chat", Chat.UpdateTarget, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "Chat", Chat.OnWindowResized, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Chat", Chat.OnDRotationChanged, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_EX_NOTICE_ADD, "Chat", Chat.AddChatExItemData, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_RECONNECT, "Chat", Chat.OnClearExChat, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_FAKE_DROP_STATUS_CHANGE, "Chat", Chat.OnChatFakeDropChange, ChatInfo._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PANEL_CLOSE, "Chat", Chat.OnClose)
end

function Chat.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CHAT_PANEL_CLOSE, "Chat")
end
----------------------------------------------

Chat.main()