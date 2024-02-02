Chat = {}
Chat._path = "res/private/chat/"

function Chat.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "chat/chat_main")
    Chat._ui = GUI:ui_delegate(parent)
    
    Chat._CHANNEL = SL:GetMetaValue("CHAT_CHANNEL_ENUM") 
    Chat._channelCells = {}
    Chat._receiveCells = {}
    Chat._exitStatus = false

    local CHANNEL = Chat._CHANNEL
    -- 选择频道图片资源
    Chat._selectChannelPath = {
        [CHANNEL.Shout]   = "1900012834.png",
        [CHANNEL.Private] = "1900012833.png",
        [CHANNEL.Guild]   = "1900012831.png",
        [CHANNEL.Team]    = "1900012832.png",
        [CHANNEL.Near]    = "1900012830.png",
        [CHANNEL.World]   = "1900012836.png",
        [CHANNEL.Nation]  = "1900012837.png",
        [CHANNEL.Union]   = "1900012838.png",
    }
    -- 接收频道图片资源
    Chat._receiveChannelPath = {
        [CHANNEL.Common]  = "1900012846.png",
        [CHANNEL.System]  = "1900012845.png",
        [CHANNEL.Shout]   = "1900012844.png",
        [CHANNEL.Private] = "1900012841.png",
        [CHANNEL.Guild]   = "1900012843.png",
        [CHANNEL.Team]    = "1900012842.png",
        [CHANNEL.Near]    = "1900012840.png",
        [CHANNEL.World]   = "1900012847.png",
        [CHANNEL.Nation]  = "1900012848.png",
        [CHANNEL.Union]   = "1900012849.png",
    }

    --
    local Panel_targets_hide = GUI:Layout_Create(Chat._ui.Panel_targets, "Panel_targets_hide", 0.00, 0.00, 1136.00, 642.00, false)
	GUI:setLocalZOrder(Panel_targets_hide, -1)
    GUI:setTouchEnabled(Panel_targets_hide, true)
    Chat._hideTargetPanel = Panel_targets_hide

    Chat.InitUI()
    Chat.InitAdapet()
    Chat.Enter()
end

function Chat.InitAdapet()
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    
    GUI:setContentSize(Chat._ui.Panel_touch, screenW, screenH)
    GUI:setMouseEnabled(Chat._ui.Panel_touch, true)

    local bgSize = GUI:getContentSize(Chat._ui.Panel_bg)
    GUI:setContentSize(Chat._ui.Panel_bg, bgSize.width, screenH)

    GUI:setPositionY(Chat._ui.Button_close, screenH)

    local bgImgSize = GUI:getContentSize(Chat._ui.Image_bg)
    GUI:setContentSize(Chat._ui.Image_bg, bgImgSize.width, screenH - 28)
    GUI:setPositionY(Chat._ui.Image_bg, screenH)

    GUI:setPositionY(Chat._ui.ListView_receive, screenH - 5)

    local listBgSize = GUI:getContentSize(Chat._ui.Image_list_bg)
    GUI:setContentSize(Chat._ui.Image_list_bg, listBgSize.width, screenH - 155)
    GUI:setPositionY(Chat._ui.Image_list_bg, screenH - 5)

    local listSize = GUI:getContentSize(Chat._ui.ListView_cells)
    GUI:setContentSize(Chat._ui.ListView_cells, listSize.width, screenH - 165)
    GUI:setPositionY(Chat._ui.ListView_cells, screenH - 5)
end

function Chat.Enter()
    local bgSize = GUI:getContentSize(Chat._ui.Panel_bg)
    GUI:stopAllActions(Chat._ui.Panel_bg)
    GUI:setPositionX(Chat._ui.Panel_bg, - bgSize.width)
    GUI:Timeline_MoveTo(Chat._ui.Panel_bg, {x = 0, y = 0}, 0.3)
end

function Chat.Exit()
    if Chat._exitStatus then
        return
    end
    Chat._exitStatus = true

    local function callback()
        SL:CloseChatUI()
    end
    local bgSize = GUI:getContentSize(Chat._ui.Panel_bg)
    GUI:stopAllActions(Chat._ui.Panel_bg)
    GUI:Timeline_MoveTo(Chat._ui.Panel_bg, {x = - bgSize.width, y = 0}, 0.3, callback)
end

function Chat.InitUI()
    -- cdTime
    SL:schedule(Chat._ui.Button_send, Chat.UpdateCDTime, 1)

    -- close
    local function close()
        Chat.Exit()
    end
    GUI:addOnClickEvent(Chat._ui.Panel_touch, close)
    GUI:addOnClickEvent(Chat._ui.Image_close, close)
    GUI:addOnClickEvent(Chat._ui.Button_close, close)

    -- 表情
    GUI:addOnClickEvent(Chat._ui.Button_input_2, function()
        SL:OpenChatExtendUI(2)
    end)

    -- 背包
    GUI:addOnClickEvent(Chat._ui.Button_input_3, function()
        SL:OpenChatExtendUI(3)
    end)

    -- 坐标
    GUI:addOnClickEvent(Chat._ui.Button_input_4, function()
        SL:SendPosMsgToChat()
    end)


    Chat.InitChannels()
    Chat.InitTargets()
    Chat.InitReceiving()

    Chat.HideChannels()
    Chat.UpdateChannel()
    Chat.UpdateCDTime()
    Chat.UpdateTarget()
end

-- 频道选择栏
function Chat.InitChannels()
    local CHANNEL = Chat._CHANNEL
    local channelName = {
        [CHANNEL.Shout]   = "Image_shout",
        [CHANNEL.Private] = "Image_private",
        [CHANNEL.Guild]   = "Image_guild",
        [CHANNEL.Team]    = "Image_team",
        [CHANNEL.Near]    = "Image_near",
        [CHANNEL.World]   = "Image_world",
        [CHANNEL.Nation]  = "Image_nation",
        [CHANNEL.Union]   = "Image_union",
    }
    local removeIdList = string.split(SL:GetMetaValue("GAME_DATA", "MobileChannelNotShow") or "", "#")
    for k, v in pairs(channelName) do
        local cell = Chat._ui[v]
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

            Chat._channelCells[k] = {
                button      = cell,
                brightImg   = brightImg,
            }
        end
    end

    local function callback()
        if GUI:getVisible(Chat._ui.Panel_channel) then
            Chat.HideChannels()
        else
            Chat.ShowChannels()
        end
    end

    GUI:setTouchEnabled(Chat._ui.Image_arrow, true)
    GUI:addOnClickEvent(Chat._ui.Image_arrow, callback)
    GUI:setTouchEnabled(Chat._ui.Image_channel, true)
    GUI:addOnClickEvent(Chat._ui.Image_channel, callback)

    local listWid   = GUI:getContentSize(Chat._ui.ListView_channel).width
    local count     = GUI:ListView_getItemCount(Chat._ui.ListView_channel)
    local cell      = GUI:ListView_getItems(Chat._ui.ListView_channel)[1]
    local cellHei   = cell and GUI:getContentSize(cell).height
    local listHei   = cellHei * count
    GUI:setContentSize(Chat._ui.ListView_channel, listWid, listHei)
    GUI:setContentSize(Chat._ui.Panel_channel, listWid, listHei + 4)
    local listBg = GUI:getChildByName(Chat._ui.Panel_channel, "Image_channel")
    GUI:setContentSize(listBg, listWid, listHei + 4)
    GUI:setPositionY(listBg, (listHei + 4) / 2)
    GUI:setPositionY(Chat._ui.ListView_channel, (listHei + 4) / 2)
end

function Chat.ShowChannels()
    GUI:setVisible(Chat._ui.Panel_channel, true)
    GUI:setRotation(Chat._ui.Image_arrow, 180)

    local curChannel = SL:GetMetaValue("CUR_CHAT_CHANNEL")
    for k, v in pairs(Chat._channelCells) do
        v.brightImg:setVisible(k == curChannel)
    end
end

function Chat.HideChannels()
    GUI:setVisible(Chat._ui.Panel_channel, false)
    GUI:setRotation(Chat._ui.Image_arrow, 0)
end

function Chat.SelectChannel(channel)
    SL:SetMetaValue("CUR_CHAT_CHANNEL", channel)
    Chat.UpdateChannel()
    Chat.UpdateTarget()
    Chat.UpdateCDTime()
end

function Chat.UpdateChannel()
    local CHANNEL = Chat._CHANNEL
    local curChannel = SL:GetMetaValue("CUR_CHAT_CHANNEL")

    local channelPath = Chat._selectChannelPath
    if channelPath and channelPath[curChannel] then
        GUI:Image_loadTexture(Chat._ui.Image_channel, Chat._path .. channelPath[curChannel])
        GUI:setIgnoreContentAdaptWithSize(Chat._ui.Image_channel, true)
    end
end

function Chat.UpdateCDTime()
    local cdTime = SL:GetMetaValue("CHAT_CUR_CDTIME")
    local sendEnable = not (cdTime and cdTime > 0)
    GUI:setTouchEnabled(Chat._ui.Button_send, sendEnable)
    GUI:setVisible(Chat._ui.Image_send, sendEnable)
    GUI:Button_setTitleText(Chat._ui.Button_send, sendEnable and "" or cdTime)
end

-- 目标栏
function Chat.InitTargets()
    -- 选择目标
    GUI:addOnClickEvent(Chat._ui.Image_target, function()
        Chat.ShowTargets()
    end)

    -- 隐藏
    GUI:addOnClickEvent(Chat._hideTargetPanel, function()
        Chat.HideTargets()
    end)

    Chat.HideTargets()
end

function Chat.ShowTargets()
    GUI:setVisible(Chat._ui.Panel_targets, true)
    GUI:ListView_removeAllItems(Chat._ui.ListView_targets)
    GUI:Image_loadTexture(Chat._ui.Image_target_a, Chat._path .. "1900012827.png")

    GUI:setVisible(Chat._hideTargetPanel, true)
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local worldPos = GUI:convertToNodeSpace(Chat._ui.Panel_targets, 0, 0)
    GUI:setContentSize(Chat._hideTargetPanel, screenW, screenH)
    GUI:setPosition(Chat._hideTargetPanel, worldPos.x, worldPos.y)

    local targets = SL:GetMetaValue("CHAT_TARGETS")
    for index, target in ipairs(targets) do
        local cell = Chat.CreateTargetCell(target, index)
        GUI:addOnClickEvent(cell, function()
            Chat.HideTargets()
            SL:PrivateChatWithTarget(target.uid, target.name)
        end)
        GUI:ListView_pushBackCustomItem(Chat._ui.ListView_targets, cell)
    end
    local count  = math.min(#targets, 7)
    local width  = 150
    local height = 28 * count
    GUI:setContentSize(Chat._ui.ListView_targets, width, height)
    GUI:setContentSize(Chat._ui.Panel_targets, width, height)
    GUI:setContentSize(Chat._ui.Image_targets, width + 4, height + 4)
end

function Chat.HideTargets()
    GUI:setVisible(Chat._ui.Panel_targets, false)
    GUI:ListView_removeAllItems(Chat._ui.ListView_targets)
    GUI:Image_loadTexture(Chat._ui.Image_target_a, Chat._path .. "1900012828.png")
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
    
    cell:removeFromParent()
    return cell
end

function Chat.UpdateTarget()
    local CHANNEL = Chat._CHANNEL
    local target  = SL:GetMetaValue("CHAT_TARGETS")[1]
    local curChannel = SL:GetMetaValue("CUR_CHAT_CHANNEL")
    if curChannel == CHANNEL.Private and target then
        GUI:setVisible(Chat._ui.Image_target, true)
        GUI:Text_setString(Chat._ui.Text_target, target.name)
    else
        GUI:setVisible(Chat._ui.Image_target, false)
    end
end

-- 频道接收
function Chat.InitReceiving()
    local CHANNEL = Chat._CHANNEL
    local channels = {
        CHANNEL.Common,
        CHANNEL.System,
        CHANNEL.Shout,
        CHANNEL.Private,
        CHANNEL.Guild,
        CHANNEL.Team,
        CHANNEL.Near,
        CHANNEL.World,
        CHANNEL.Nation,
        CHANNEL.Union,
    }

    local function checkHideChannel(channel)
        if SL:GetMetaValue("GAME_DATA","MobileChannelNotShow") then
            local removeIdList = string.split(SL:GetMetaValue("GAME_DATA","MobileChannelNotShow"), "#")
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
                if channel == CHANNEL.Common then
                    for _, channel in pairs(CHANNEL) do
                        SL:SetMetaValue("CHAT_CHANNEL_RECEIVIND", channel, isSelected)
                    end
                else
                    SL:SetMetaValue("CHAT_CHANNEL_RECEIVIND", channel, isSelected)
                end

                for channel, cell in pairs(Chat._receiveCells) do
                    local isReceiving = SL:GetMetaValue("CHAT_CHANNEL_ISRECEIVE", channel)
                    GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                end
            end)

            -- 选择
            GUI:addOnClickEvent(cell.channelBtn, function()
                Chat.SetReceiveChannel(channel)

                -- 映射到发送频道
                if (channel ~= CHANNEL.Common and channel ~= CHANNEL.System) then
                    Chat.HideChannels()
                    Chat.SelectChannel(channel)
                end
            end)

            Chat._receiveCells[channel] = cell
            GUI:ListView_pushBackCustomItem(Chat._ui.ListView_receive, cell.layout)
        end
    end
end

function Chat.CreateReceivingCell(channel)
    local widget = GUI:Widget_Create(-1, "Widget_" .. channel, 0, 0, 0, 0)
    GUI:LoadExport(widget, "chat/receiving_cell")
    local cell = GUI:getChildByName(widget, "Panel_cell")

    local channelBtn = GUI:getChildByName(cell, "Button_channel")
    local nameImg = GUI:getChildByName(cell, "Image_name")
    local checkBox = GUI:getChildByName(cell, "CheckBox_receiving")

    local channelPath = Chat._receiveChannelPath
    if channelPath and channelPath[channel] then
        GUI:Image_loadTexture(nameImg, Chat._path .. channelPath[channel])
    end
    local isReceiving = SL:GetMetaValue("CHAT_CHANNEL_ISRECEIVE", channel)
    GUI:CheckBox_setSelected(checkBox, isReceiving == true)
    GUI:CheckBox_setZoomScale(checkBox, -0.05)
    
    local data = {
        layout = cell,
        channelBtn = channelBtn,
        checkBox = checkBox
    }
    cell:removeFromParent()
    return data
end
