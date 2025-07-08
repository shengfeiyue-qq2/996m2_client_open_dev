GuildChat = {}

function GuildChat.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    GuildChat._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if GuildChat._isWinMode then
        GUI:LoadExport(parent, "guild/guild_chat_win32")
    end

    GuildChat._parent = parent
    GuildChat._ui = GUI:ui_delegate(parent)
    GuildChat._layer = GuildChat._ui.Layer
    GuildChat._limitCount = GUIDefine.ChatConfig.LIMIT_COUNT_PC
    GuildChat._cache = {}

    GuildChat.InitUI()
    GuildChat.RegisterEvent()
end

function GuildChat.InitUI()
    GuildChat._listView = GuildChat._ui.ListView_chat
    GuildChat._input = GuildChat._ui.Input

    local guildCache = ChatData.GetPCGuildCache() or {}
    for _, v in ipairs(guildCache) do
        GuildChat.PushItem(v)
    end
    GUI:ListView_jumpToBottom(GuildChat._listView)

    local function scrollCallback(sender, eventType)
        if eventType == GUIDefine.ScrollEventType.CONTAINER_MOVED or eventType == GUIDefine.ScrollEventType.AUTOSCROLL_ENDED then
            local innerPos = GUI:ListView_getInnerContainerPosition(sender)
            if innerPos.y == 0 and GuildChat._isScrolling then
                GuildChat._isScrolling = false
                GuildChat.ShowCache()
            end
        end
    end
    GUI:ListView_addOnScrollEvent(GuildChat._listView, scrollCallback)
    GUI:ListView_addMouseScrollPercent(GuildChat._listView)

    -- 输入框
    GUI:TextInput_addOnEvent(GuildChat._input, function(sender, eventType)
        if eventType == GUIDefine.TextInputEventType.CHANGE then
            local inputStr = GUI:TextInput_getString(sender)
            if string.len(inputStr) > 0 and string.find(inputStr, "\n") then
                GuildChat.SendChatMsg(inputStr)
                GUI:TextInput_closeInput(sender)
            end
        end
    end)

end

function GuildChat.SendChatMsg(msg)
    msg = msg or GUI:Text_getString(GuildChat._input)
    local channelID = GUIDefine.ChatChannel.GUILD

    -- 换掉空格
    msg = string.trim(msg)
    msg = string.gsub(msg, "[\t\n\r]", "")

    GUI:Text_setString(GuildChat._input, "")

    -- 没有输入
    if string.len(msg) <= 0 then
        return SL:ShowSystemTips("您还未输入任何信息！")
    end

    local function toSendMsg(input, risk_param, ext_param)
        -- 发送 PC端根据消息内容决定频道
        local oriMsg = ext_param and ext_param.originStr
        local sensitiveWords = ext_param and ext_param.replacedWords
        local status = ext_param and ext_param.status
        local sendData  = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = channelID, risk = risk_param, oriMsg = oriMsg, sensitiveWords = sensitiveWords, status = status}
        GUIFunction:SendChatMsg(sendData)
    end

    -- 敏感词
    if not string.find(msg, "^@.-") then
        -- 后台控制不可聊天
        if SL:GetValue("M2_FORBID_SAY", true) then
            return false
        end

        local function handle_Func(state, str, risk_param, ext_param)
            if not str then
                return SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
            end

            toSendMsg(str, risk_param, ext_param)
        end

        local data = {channel_id = channelID}    
        SL:RequestCheckSensitiveWord(msg, 2, handle_Func, data)
    else
        toSendMsg(msg)
    end
end

function GuildChat.PushItem(item)
    if not item then
        return
    end
    GUI:ListView_pushBackCustomItem(GuildChat._listView, item)
    SL:scheduleOnce(GuildChat._listView, function() 
        if GUI:ListView_getItemCount(GuildChat._listView) > GuildChat._limitCount then
            GUI:ListView_removeItemByIndex(GuildChat._listView, 0)
        end
        GUI:ListView_jumpToBottom(GuildChat._listView)
    end, 0)
end

function GuildChat.AddItem(item)
    -- 是否正在拖动
    if next(GUI:ListView_getItems(GuildChat._listView)) then
        local lastIdx   = GUI:ListView_getItemCount(GuildChat._listView) - 1
        local lastItem  = GUI:ListView_getItemByIndex(GuildChat._listView, lastIdx)
        local csize     = GUI:getContentSize(item)
        local worldPosY = GUI:getWorldPosition(lastItem).y
        local listViewY = GUI:getWorldPosition(GuildChat._listView).y
        if worldPosY < listViewY then
            GuildChat._isScrolling = true
        end
    end

    if GuildChat._isScrolling then
        -- 正在拖动，消息缓存
        GUI:addRef(item)
        table.insert(GuildChat._cache, item)
    
        while #GuildChat._cache > GuildChat._limitCount do
            local item = table.remove(GuildChat._cache, 1)
            GUI:autoDecRef(item)
        end
    else
        GuildChat.PushItem(item)
        GUI:ListView_jumpToBottom(GuildChat._listView)
    end
end

function GuildChat.ShowCache()
    -- 缓存填充
    while #GuildChat._cache > 0 do
        local item = table.remove(GuildChat._cache, 1)
        GUI:autoDecRef(item)
        GuildChat.PushItem(item)
    end
    GUI:ListView_jumpToBottom(GuildChat._listView)
end

function GuildChat.ReleaseCache()
    for _, v in ipairs(GuildChat._cache) do
        GUI:autoDecRef(v)
    end
    GuildChat._cache = {}
end

--------------------------------------------------------------------------
function GuildChat.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildChat", GuildChat.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PCGUILD_ITEM_ADD, "GuildChat", GuildChat.AddItem)
end

function GuildChat.OnClose(layerId)
    if layerId == UIConst.LayerTable.GuildChat then
        GuildChat.ReleaseCache()
        GuildChat.RemoveEvent()
        GuildChat._layer = nil
    end
end

function GuildChat.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUILD_CHILD_REMOVE, "GuildChat")
    SL:UnRegisterLUAEvent(LUA_EVENT_CHAT_PCGUILD_ITEM_ADD, "GuildChat")
end
---------------------------------------------------------------------------

GuildChat.main()