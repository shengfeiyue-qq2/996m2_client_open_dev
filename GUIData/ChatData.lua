ChatData = ChatData or {}

local sformat   = string.format
local slen      = string.len
local ssplit    = string.split

ChatData._parseInterval     = 1 / 50    -- 解析间隔
ChatData._dropTotalTypeID   = 99        -- 掉落总分类ID
ChatData._fakeDropType      = 77        -- 假掉落分类ID

function ChatData.Init()
    ChatData._isChatting    = false                 -- 聊天中...
    ChatData._inputCache    = {}                    -- 输入历史
    ChatData._inputDraft    = ""                    -- 输入草稿
    ChatData._receiveCache  = {}                    -- 聊天接收缓存
    ChatData._receivePCCache= {}
    ChatData._channel       = GUIDefine.ChatChannel.NEAR     -- 当前频道
    ChatData._receiveChannel= GUIDefine.ChatChannel.COMMON   -- 当前聊天记录频道
    ChatData._emoji         = {}                    -- 表情包
    ChatData._targets       = {}                    -- 私聊列表
    ChatData._targetName    = ""                    -- 私聊名字
    ChatData._localChat     = {                     -- 本地缓存数据
        autoShout = {                           -- 本地开关
            [tostring(GUIDefine.ChatChannel.SHOUT)] = 0            -- 喊话
        },
        data = {
            [tostring(GUIDefine.ChatChannel.SHOUT)] = "",          -- 本地保存的喊话内容
            [tostring(GUIDefine.ChatChannel.PRIVATE)] = "",        -- 本地保存的私聊自动回复内容
        },
        autoRely = {
            [tostring(GUIDefine.ChatChannel.PRIVATE)] = 0          -- 自动回复开关
        },
        channelSwitch = {                       -- 聊天接收开关
        },
        dropSwitch = {
            ["total"] = 1,                      -- 掉落总开关
        },
    }                
    -- 聊天记录缓存
    for _, v in pairs(GUIDefine.ChatChannel) do
        ChatData._receiveCache[v] = {}
        ChatData._receivePCCache[v] = {}
    end

    -- cd
    ChatData._cdTime = {}
    for _, v in pairs(GUIDefine.ChatChannel) do
        ChatData._cdTime[v] = 0
    end

    local localChatData = ChatData.GetLocalChatData()
    -- 是否接收
    if not ChatData._localChat.channelSwitch then
        ChatData._localChat.channelSwitch = {}
    end
    ChatData._receiving = {}
    for _, v in pairs(GUIDefine.ChatChannel) do
        if v == GUIDefine.ChatChannel.DROP then  --   仅掉落读取本地数据
            local data = localChatData and localChatData.channelSwitch
            ChatData._localChat.channelSwitch[v .. ""] = data and data[v ..""]
        end
        if ChatData._localChat.channelSwitch[v..""] == nil then
            ChatData._receiving[v] = true
        else
            ChatData._receiving[v] = ChatData._localChat.channelSwitch[v..""] == 1
        end
    end

    -- 掉落分类开关读本地数据
    if localChatData and localChatData.dropSwitch then
        ChatData._localChat.dropSwitch = localChatData.dropSwitch or {}
    end

    -- 自动喊话清理本地缓存数据
    ChatData._localChat.autoShout[tostring(GUIDefine.ChatChannel.SHOUT)] = 0
    ChatData._localChat.data[tostring(GUIDefine.ChatChannel.SHOUT)] = ""
    ChatData.SetLocalChatData()

    ChatData._autoRelyList = {}
    ChatData._autoRelyEnable = true

    -- PC聊天记录缓存
    ChatData._PCPrivateCache = {}

    -- PC行会聊天页记录缓存
    ChatData._PCGuildCache = {}

    -- 表情包配置
    ChatData._emoji = SL:Require("config/ZTFace")

    -- 固定聊天
    ChatData._chatExItems = {}
    ChatData._chatExId = 0

    -- 自动喊话间隔时间(s)
    ChatData._autoShoutDelay = 20

    -- 是否关闭假掉落消息
    ChatData._closeFakeDrop = false
    ChatData._fakeDropTimerID = nil

    ChatData._curFakeDropType = nil     -- 当前打开假掉落分类
    ChatData._fakeDropMsgTable = {}     -- 假掉落所有配置
    ChatData._fakeDropMsgTypeTable = {} -- 假掉落分组配置 {[type] = {}, ..}

    -----
    ChatData._parseItems = SL:CreateQueue()
    ChatData._parseEnable = true
    
    ChatData._parseSystemItems = SL:CreateQueue()
    ChatData._parseSystemEnable = true

    ChatData._parseMiniItems = SL:CreateQueue()
    ChatData._parseMiniEnable = true

    ChatData._parsePCPrivateItems = SL:CreateQueue()
    ChatData._parsePCPrivateEnable = true

    ChatData._parsePCGuildItems = SL:CreateQueue()
    ChatData._parsePCGuildEnable = true

    ChatData.RegisterEvent()
end

function ChatData.LoadConfig()
    -- 假掉落配置
    ChatData._fakeDropMsgTable = {}
    ChatData._fakeDropMsgTypeTable = {}
    local fileName = "cfg_chat_drop.lua"
    if SL:IsFileExist("scripts/game_config/" .. fileName) then
        local config = SL:Require("game_config/" .. fileName)
        if ChatData._fakeDropMsgF then
            for _, v in ipairs(config) do
                local str = ChatData._fakeDropMsgF
                -- 参数服务端转大写传
                if v.playerName then
                    str = string.gsub(str, "%%CREATENAME", v.playerName)
                end
                if v.monsterName then
                    str = string.gsub(str, "%%NAME", v.monsterName)
                end
                if v.mapName then
                    str = string.gsub(str, "%%MAP", v.mapName)
                end
                if v.itemID then
                    str = string.gsub(str, "%%ITEMID", v.itemID)
                end
                if v.itemName then
                    str = string.gsub(str, "%%ITEM", v.itemName)
                end
                if v.g_itemName then
                    str = string.gsub(str, "%%G_ITEM", v.g_itemName)
                end
                if v.mapX then
                    str = string.gsub(str, "%%X", v.mapX)
                end
                if v.mapY then
                    str = string.gsub(str, "%%Y", v.mapY)
                end
                table.insert(ChatData._fakeDropMsgTable, str)
                -- 分类
                if v.type then
                    if not ChatData._fakeDropMsgTypeTable[v.type] then
                        ChatData._fakeDropMsgTypeTable[v.type] = {}
                    end
                    table.insert(ChatData._fakeDropMsgTypeTable[v.type], str)
                end
            end
        end
    end
    
end

function ChatData.OnPlayerPropertyInited()
    ChatData.OpenFakeDropTimerID()
end

function ChatData.SetFakeDropParam(param)
    ChatData._fakeDropParam = param
    if param and param.Msg then
        -- 掉落格式配置
        ChatData._fakeDropMsgF = param.Msg
        SL:Print(ChatData._fakeDropMsgF)
    end
end

function ChatData.GetRandFakeDropParam()
    if ChatData._fakeDropParam and next(ChatData._fakeDropParam) and next(ChatData._fakeDropMsgTable) then
        if ChatData._curFakeDropType then
            local fakeDropMsgTable = ChatData._fakeDropMsgTypeTable[ChatData._curFakeDropType] or {}
            if next(fakeDropMsgTable) then
                local idx = math.random(1, #fakeDropMsgTable)
                ChatData._fakeDropParam.Msg = fakeDropMsgTable[idx]
                return ChatData._fakeDropParam
            end
        else
            local idx = math.random(1, #ChatData._fakeDropMsgTable)
            ChatData._fakeDropParam.Msg = ChatData._fakeDropMsgTable[idx]
            return ChatData._fakeDropParam
        end
    end

    return nil
end

function ChatData.OpenFakeDropTimerID()
    if not ChatData._fakeDropMsgF then
        return
    end

    if not ChatData.GetFakeDropShow() then
        return
    end

    if not ChatData.GetDropTypeSwitch(ChatData._fakeDropType) then
        return
    end

    if not ChatData._fakeDropTimerID then
        local function callback()
            local data = ChatData.GetRandFakeDropParam()
            if data and next(data) then
                data.ChannelId = GUIDefine.ChatChannel.DROP
                data.textType = GUIDefine.ChatTextType.SRTEXT
                data.dropType = ChatData._fakeDropType
                ChatData.AddChatItem(data)
            end
        end
        if ChatData._needRandTime and ChatData._fakeDropTimeLow and ChatData._fakeDropTimeHigh then
            local time = math.random(ChatData._fakeDropTimeLow, ChatData._fakeDropTimeHigh)
            local function event()
                ChatData._fakeDropTimerID = nil
                callback()
                local timeT = math.random(ChatData._fakeDropTimeLow, ChatData._fakeDropTimeHigh)
                ChatData._fakeDropTimerID = SL:ScheduleOnce(event, timeT / 1000)
            end
            ChatData._fakeDropTimerID = SL:ScheduleOnce(event, time / 1000)
        else
            ChatData._fakeDropTimerID = SL:Schedule(callback, ChatData._fakeDropTime or 0.2)
        end
    end
end

function ChatData.CloseFakeDropTimerID()
    if ChatData._fakeDropTimerID then
        SL:UnSchedule(ChatData._fakeDropTimerID)
        ChatData._fakeDropTimerID = nil
    end
end

function ChatData.ChangeFakeDropTimerID(limitLowTimes, limitHighTimes)
    local isNeedOpen = false
    if ChatData._fakeDropTimerID then
        isNeedOpen = true
        ChatData.CloseFakeDropTimerID()
    end
    
    ChatData._fakeDropTime = nil
    ChatData._needRandTime = false

    if limitHighTimes == limitLowTimes then
        ChatData._fakeDropTime = limitLowTimes / 1000
    else
        ChatData._needRandTime = true
        ChatData._fakeDropTimeLow = limitLowTimes
        ChatData._fakeDropTimeHigh = limitHighTimes
    end
    if isNeedOpen then
        ChatData.OpenFakeDropTimerID()
    end
end

function ChatData.IsCloseFakeDrop()
    return ChatData._closeFakeDrop
end

--- 添加固定聊天数据
---@param data table  服务端下发的固定聊天数据
function ChatData.AddChatExItemsData(data)
    table.insert(ChatData._chatExItems, data)
    ChatData._chatExId = ChatData._chatExId + 1
    data.chatExId = ChatData._chatExId

    SL:onLUAEvent(LUA_EVENT_CHAT_EX_NOTICE_ADD, data)
end

--- 移除固定聊天数据
---@param data table  固定聊天数据
function ChatData.RemoveChatExItemsData(data)
    if not data then
        return
    end
    local chatExId = data.chatExId
    for i, item in ipairs(ChatData._chatExItems) do
        if item.chatExId and item.chatExId == chatExId then
            table.remove(ChatData._chatExItems, i)
            break
        end
    end
end

--- 同步固定聊天倒计时
---@param chatExId integer 自定义的唯一id
---@param value integer 倒计时
function ChatData.SyncChatExItemsTime(data, value)
    if not data then
        return
    end
    local chatExId = data.chatExId
    for i, item in ipairs(ChatData._chatExItems) do
        if item.chatExId and item.chatExId == chatExId then
            ChatData._chatExItems[i].Time = value
            break
        end
    end
end

--- 获取固定聊天数据
function ChatData.GetChatExItemsData()
    return ChatData._chatExItems
end

function ChatData.ClearChatExItemsData()
    ChatData._chatExItems = {}
end

-- 获取自动喊话时间间隔
function ChatData.GetAutoShoutDelay()
    return ChatData._autoShoutDelay or 20
end

-- 设置自动喊话时间间隔
function ChatData.SetAutoShoutDelay(value)
    ChatData._autoShoutDelay = value or 20
end

function ChatData.SetCDTime(channel, cd)
    ChatData._cdTime[channel] = SL:GetValue("SERVER_TIME") + cd
    SL:onLUAEvent(LUA_EVENT_CHAT_ENTER_CD)
end

function ChatData.GetCDTime(channel)
    return ChatData._cdTime[channel] - SL:GetValue("SERVER_TIME")
end

function ChatData.GetCurrCDTime()
    local channel = ChatData.GetCurChannel()
    return ChatData.GetCDTime(channel)
end

function ChatData.GetEmoji()
    return ChatData._emoji
end

function ChatData.SetCurChannel(channel)
    if channel == GUIDefine.ChatChannel.DROP then
        channel = GUIDefine.ChatChannel.PRIVATE
    end
    ChatData._channel = channel
end

function ChatData.GetCurChannel()
    return ChatData._channel
end

function ChatData.SetReceiveChannel(channel)
    ChatData._receiveChannel = channel
end

function ChatData.GetReceiveChannel()
    return ChatData._receiveChannel
end

function ChatData.SetIsChatting(status)
    ChatData._isChatting = status
end

function ChatData.IsChatting()
    return ChatData._isChatting
end

function ChatData.SetInputDraft(draft)
    ChatData._inputDraft = draft
end

function ChatData.GetInputDraft(draft)
    return ChatData._inputDraft
end

function ChatData.AddInputCache(input)
    table.insert(ChatData._inputCache, input)

    if #ChatData._inputCache > GUIDefine.ChatConfig.INPUT_CACHE_COUNT then
        table.remove(ChatData._inputCache, 1)
    end
end

function ChatData.GetInputCache()
    return ChatData._inputCache
end

function ChatData.SetReceiving(channel, status)
    ChatData._receiving[channel] = status
    ChatData._localChat.channelSwitch[tostring(channel)] = status and 1 or 0
    ChatData.SetLocalChatData()

    SL:onLUAEvent(LUA_EVENT_CHAT_SET_CHANNEL_RECEIVIND, {channel = channel, status = status})
end

function ChatData.IsReceiving(channel)
    if channel == GUIDefine.ChatChannel.COMMON then
        for k, v in pairs(ChatData._receiving) do
            if k ~= GUIDefine.ChatChannel.COMMON and v then
                return true
            end
        end
        return false
    end
    return ChatData._receiving[channel]
end

function ChatData.AddTarget(target)
    for k, v in pairs(ChatData._targets) do
        if v.uid == target.uid then
            table.remove(ChatData._targets, k)
            break
        end
    end
    table.insert(ChatData._targets, 1, target)

    if #ChatData._targets > GUIDefine.ChatConfig.PRIVATE_COUNT then
        table.remove(ChatData._targets, #ChatData._targets)
    end
end

function ChatData.GetTargets()
    return ChatData._targets
end

function ChatData.GetTarget()
    return ChatData._targets[1]
end


function ChatData.SetLocalChatDataByChannel(channel, data)
    channel = tostring(channel)
    if ChatData._localChat.data[channel] then
        ChatData._localChat.data[channel] = data
        ChatData.SetLocalChatData()
    end
end

function ChatData.GetLocalChatDataByChannel(channel)
    channel = tostring(channel)
    if ChatData._localChat.data[channel] then
        return ChatData._localChat.data[channel]
    end
    return nil
end

-- 获取聊天相关的本地缓存
function ChatData.GetLocalChatData()
    local jsonData = SL:GetLocalData("chat_local_cache", "chat")

    if not jsonData or jsonData == "" then
        return nil
    end
    local lastlocalData = SL:JsonDecode(jsonData)
    return lastlocalData
end

-- 设置聊天相关的本地缓存
function ChatData.SetLocalChatData()
    local jsonStr = SL:JsonEncode(ChatData._localChat)
    SL:CreateLocalData("chat_local_cache", "chat", jsonStr)
end

function ChatData.SetAutoReplySwitch(value)
    local channel = tostring(GUIDefine.ChatChannel.PRIVATE)
    ChatData._localChat.autoRely[channel] = value
    ChatData.SetLocalChatData()
end

function ChatData.GetAutoReplySwitch()
    local channel = tostring(GUIDefine.ChatChannel.PRIVATE)
    if ChatData._localChat.autoRely[channel] then
        return ChatData._localChat.autoRely[channel] == 1
    end
    return false
end

function ChatData.SetAutoShoutSwitch(value)
    local channel = tostring(GUIDefine.ChatChannel.SHOUT)
    ChatData._localChat.autoShout[channel] = value and 1 or 0
    ChatData.SetLocalChatData()
end

function ChatData.GetAutoShoutSwitch()
    local channel = tostring(GUIDefine.ChatChannel.SHOUT)
    if ChatData._localChat.autoShout[channel] then
        return ChatData._localChat.autoShout[channel] == 1
    end
    return false
end

function ChatData.GetFakeDropShow()
    local fakeDrop = SL:GetValue("GAME_DATA", "ShowFakeDropType")
    if fakeDrop and slen(fakeDrop) > 0 then
        local param = ssplit(fakeDrop, "#")
        if param[2] and tonumber(param[2]) == 1 then
            return true
        end
    end

    return false
end

function ChatData.SetDropTypeSwitch(type, value)
    local key = type ~= ChatData._dropTotalTypeID and ("type" .. type) or "total"
    ChatData._localChat.dropSwitch[key] = value and 1 or 0
    if type ~= ChatData._dropTotalTypeID then
        local enable = false
        local list = ChatData.GetDropTypeShowList()
        if ChatData.GetFakeDropShow() then
            list[ChatData._fakeDropType] = true
        end
        for i, show in pairs(list) do
            if show then
                if not ChatData._localChat.dropSwitch["type" .. i] then
                    ChatData._localChat.dropSwitch["type" .. i] = 1
                end
                if ChatData._localChat.dropSwitch["type" .. i] == 1 then
                    enable = true
                    break
                end
            end
        end
        ChatData._localChat.dropSwitch["total"] = enable and 1 or 0
    end
    ChatData.SetLocalChatData()

    SL:RequestSyncGameSetData()

    if type == ChatData._fakeDropType then
        if ChatData._localChat.dropSwitch[key] == 1 then
            ChatData.OpenFakeDropTimerID()
        else
            ChatData.CloseFakeDropTimerID()
        end
    end
end

function ChatData.GetDropTypeSwitch(type)
    local key = type ~= ChatData._dropTotalTypeID and ("type" .. type) or "total"
    if ChatData._localChat.dropSwitch[key] then
        return ChatData._localChat.dropSwitch[key] == 1
    end
    return true
end

function ChatData.GetDropTypeShowList()
    if ChatData._showDropType then
        return ChatData._showDropType
    end

    ChatData._showDropType = {}

    local data = SL:GetValue("GAME_DATA", "DropTypeShow") or ""
    if slen(data) > 0 then
        local tList = ssplit(data, "|")
        for _, v in ipairs(tList) do
            local param = ssplit(v, "#")
            local dorpType = tonumber(param[2])
            if dorpType then
                ChatData._showDropType[dorpType] = tonumber(param[1] or 0) == 1
            end
        end
    end

    return ChatData._showDropType
end

function ChatData.GetDropTypeShield()
    local showList = ChatData.GetDropTypeShowList()
    local list = {}
    local totalSwitch = ChatData.GetDropTypeSwitch(ChatData._dropTotalTypeID)
    for i = 1, 10 do
        local isOpen = ChatData.GetDropTypeSwitch(i)
        if not isOpen or not totalSwitch or not showList[i] then
            table.insert(list, i)
        end
    end
    return list
end

function ChatData.SetAutoReplyEnable(enable)
    ChatData._autoRelyEnable = enable
end

function ChatData.GetAutoReplyEnable()
    return ChatData._autoRelyEnable
end

function ChatData.GetAutoReplyList()
    return ChatData._autoRelyList
end

function ChatData.SetAutoRelyList(data)
    ChatData._autoRelyList = data
end

function ChatData.AddAutoReplyData(data)
    if data and next(data) then
        table.insert(ChatData._autoRelyList, data)
    end
end
---------------------------------- cache begin----------------------------------
function ChatData.GetCache()
    local channel = ChatData.GetReceiveChannel()
    return ChatData._receiveCache[channel]
end

function ChatData.GetDropCacheByType(type)
    if not type or type == ChatData._dropTotalTypeID then
        return ChatData._receiveCache[GUIDefine.ChatChannel.DROP]
    end
    return ChatData._receiveDropCache[type] or {}
end

function ChatData.StorageItem(item, channel, dropType)
    -- 保存至对应频道
    local receiveCache = ChatData._receiveCache[channel]
    table.insert(receiveCache, item)
    GUI:addRef(item)
    while #receiveCache > GUIDefine.ChatConfig.LIMIT_COUNT do
        local item = table.remove(receiveCache, 1)
        GUI:autoDecRef(item)
    end

    if channel == GUIDefine.ChatChannel.COMMON then
        -- ?? 容错服务端偶发频道ID为0
        SL:Print("CHAT MSG ERROR: CHAT CHANNEL IS COMMON??")
        return
    end

    -- 保存至公共频道
    local receiveCache = ChatData._receiveCache[GUIDefine.ChatChannel.COMMON]
    table.insert(receiveCache, item)
    GUI:addRef(item)
    while #receiveCache > GUIDefine.ChatConfig.LIMIT_COUNT do
        local item = table.remove(receiveCache, 1)
        GUI:autoDecRef(item)
    end
end

function ChatData.ReleaseCache()
    for _, cache in pairs(ChatData._receiveCache) do
        for _, v in ipairs(cache) do
            GUI:autoDecRef(v)
        end
    end
    ChatData._receiveCache = {}

    for _, cache in pairs(ChatData._receivePCCache) do
        for _, v in ipairs(cache) do
            GUI:autoDecRef(v)
        end
    end
    ChatData._receivePCCache = {}

    for _, v in ipairs(ChatData._PCPrivateCache) do
        GUI:autoDecRef(v)
    end
    ChatData._PCPrivateCache = {}

    for _, v in ipairs(ChatData._PCGuildCache) do
        GUI:autoDecRef(v)
    end
    ChatData._PCGuildCache = {}
end

-- 私聊记录
function ChatData.StoragePCPrivateItem(item)
    -- 保存
    if not SL:GetValue("IS_PC_OPER_MODE") then return end
    local cache = ChatData._PCPrivateCache
    table.insert(cache, item)
    GUI:addRef(item)
    while #cache > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
        local item = table.remove(cache, 1)
        GUI:autoDecRef(item)
    end
end

function ChatData.GetPCPrivateCache(...)
    return ChatData._PCPrivateCache
end

-- 行会聊天页记录
function ChatData.StoragePCGuildItem(item)
    -- 保存
    if not SL:GetValue("IS_PC_OPER_MODE") then return end
    local cache = ChatData._PCGuildCache
    table.insert(cache, item)
    GUI:addRef(item)
    while #cache > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
        local item = table.remove(cache, 1)
        GUI:autoDecRef(item)
    end
end

function ChatData.GetPCGuildCache()
    return ChatData._PCGuildCache
end

-- PC Mini
function ChatData.GetPCCache()
    local channel = ChatData.GetReceiveChannel()
    return ChatData._receivePCCache[channel]
end

function ChatData.StoragePCItem(item, channel)
    -- 保存至对应频道
    local receiveCache = ChatData._receivePCCache[channel]
    table.insert(receiveCache, item)
    GUI:addRef(item)
    while #receiveCache > GUIDefine.ChatConfig.LIMIT_COUNT do
        local item = table.remove(receiveCache, 1)
        GUI:autoDecRef(item)
    end

    -- 保存至公共频道
    local receiveCache = ChatData._receivePCCache[GUIDefine.ChatChannel.COMMON]
    table.insert(receiveCache, item)
    GUI:addRef(item)
    while #receiveCache > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
        local item = table.remove(receiveCache, 1)
        GUI:autoDecRef(item)
    end
end

function ChatData.AddChatItem(data)
    -- receiving
    if not ChatData.IsReceiving(data.ChannelId) then
        return false
    end

    -- 黑名单
    if data.SendId and data.SendName and SL:GetValue("SOCIAL_IS_BLACKLIST_BY_UID", data.SendId) then
        return false
    end

    -- chat item
    if not SL:GetValue("IS_PC_OPER_MODE") then
        if data.ChannelId ~= GUIDefine.ChatChannel.SYSTEM and data.ChannelId ~= GUIDefine.ChatChannel.DROP then
            ChatData._parseItems:push(data)
            while ChatData._parseItems:size() > GUIDefine.ChatConfig.LIMIT_COUNT do
                ChatData._parseItems:pop()
            end
            if ChatData._parseEnable then
                ChatData.CheckParseItems()
            end
        else
            -- 系统频道单独缓存
            ChatData._parseSystemItems:push(data)
            while ChatData._parseSystemItems:size() > GUIDefine.ChatConfig.LIMIT_COUNT do
                ChatData._parseSystemItems:pop()
            end
            if ChatData._parseSystemEnable then
                ChatData.CheckParseSystemItems()
            end
        end
    end

    -- mini
    ChatData._parseMiniItems:push(data)
    local limitCount = SL:GetValue("IS_PC_OPER_MODE") and GUIDefine.ChatConfig.LIMIT_COUNT_PC or GUIDefine.ChatConfig.LIMIT_COUNT_MAIN
    while ChatData._parseMiniItems:size() > limitCount do
        ChatData._parseMiniItems:pop()
    end
    if ChatData._parseMiniEnable then
        ChatData.CheckParseMiniItems()
    end

    --PC Private
    if SL:GetValue("IS_PC_OPER_MODE") and data.ChannelId == GUIDefine.ChatChannel.PRIVATE then
        ChatData._parsePCPrivateItems:push(data)
        while ChatData._parsePCPrivateItems:size() > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
            ChatData._parsePCPrivateItems:pop()
        end
        if ChatData._parsePCPrivateEnable then
            ChatData.CheckParsePCPrivateItems()
        end
    end

    -- PC Guild Chat
    if SL:GetValue("IS_PC_OPER_MODE") and data.ChannelId == GUIDefine.ChatChannel.GUILD then
        ChatData._parsePCGuildItems:push(data)
        while ChatData._parsePCGuildItems:size() > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
            ChatData._parsePCGuildItems:pop()
        end
        if ChatData._parsePCGuildEnable then
            ChatData.CheckParsePCGuildItems()
        end
    end
end

function ChatData.CheckParseItems()
    if ChatData._parseEnable and not ChatData._parseItems:empty() then
        ChatData._parseEnable = false

        -- parse
        local function callback()
            local item = ChatData._parseItems:pop()
            ChatData.ParseItem(item)
        end
        SL:ScheduleOnce(callback, 1 / 60)

        -- delay parse next
        local function callback()
            ChatData._parseEnable = true
            ChatData.CheckParseItems()
        end
        SL:ScheduleOnce(callback, ChatData._parseInterval)
    end
end

function ChatData.CheckParseSystemItems()
    if ChatData._parseSystemEnable and not ChatData._parseSystemItems:empty() then
        ChatData._parseSystemEnable = false

        -- parse
        local function callback()
            local item = ChatData._parseSystemItems:pop()
            ChatData.ParseItem(item)
        end
        SL:ScheduleOnce(callback, 1 / 60)

        -- delay parse next
        local function callback()
            ChatData._parseSystemEnable = true
            ChatData.CheckParseSystemItems()
        end
        SL:ScheduleOnce(callback, ChatData._parseInterval)
    end
end

function ChatData.CheckParseMiniItems()
    if ChatData._parseMiniEnable and not ChatData._parseMiniItems:empty() then
        ChatData._parseMiniEnable = false

        -- parse
        local item = ChatData._parseMiniItems:pop()
        ChatData.ParseMiniItem(item)

        -- delay parse next
        local function callback()
            ChatData._parseMiniEnable = true
            ChatData.CheckParseMiniItems()
        end
        SL:ScheduleOnce(callback, ChatData._parseInterval)
    end
end

function ChatData.CheckParsePCPrivateItems()
    if ChatData._parsePCPrivateEnable and not ChatData._parsePCPrivateItems:empty() then
        ChatData._parsePCPrivateEnable = false

        -- parse
        local function callback()
            local item = ChatData._parsePCPrivateItems:pop()
            ChatData.ParsePCPItem(item)
        end
        SL:ScheduleOnce(callback, 1 / 60)

        -- delay parse next
        local function callback()
            ChatData._parsePCPrivateEnable = true
            ChatData.CheckParsePCPrivateItems()
        end
        SL:ScheduleOnce(callback, ChatData._parseInterval)
    end
end

function ChatData.CheckParsePCGuildItems()
    if ChatData._parsePCGuildEnable and not ChatData._parsePCGuildItems:empty() then
        ChatData._parsePCGuildEnable = false

        -- parse
        local function callback()
            local item = ChatData._parsePCGuildItems:pop()
            ChatData.ParsePCGuildItem(item)
        end
        SL:ScheduleOnce(callback, 1 / 60)

        -- delay parse next
        local function callback()
            ChatData._parsePCGuildEnable = true
            ChatData.CheckParsePCGuildItems()
        end
        SL:ScheduleOnce(callback, ChatData._parseInterval)
    end
end

function ChatData.ParseItem(data)
    if not data then
        return
    end
    local item = GUIFunction:GenerateChatItem(data)
    if not item then
        return
    end
    ChatData.StorageItem(item, data.ChannelId, data.dropType)
end

function ChatData.ParseMiniItem(data)
    if not data then
        return
    end
    local item = GUIFunction:GenerateChatMiniItem(data)
    if not item then
        return
    end
    local CHANNEL = GUIDefine.ChatChannel
    local receiveChannel = ChatData.GetReceiveChannel()
    if (receiveChannel == data.ChannelId) or (receiveChannel == CHANNEL.COMMON) or (receiveChannel == CHANNEL.GUILD and data.ChannelId == CHANNEL.GUILDTIPS) then
        SL:onLUAEvent(LUA_EVENT_CHATMINI_ITEM_ADD, item)
    end

    local isOpen = tonumber(SL:GetValue("GAME_DATA", "PCSwitchChannelShow")) == 1
    if SL:GetValue("IS_PC_OPER_MODE") and isOpen then
        ChatData.StoragePCItem(item, data.ChannelId, data.dropType)
    end
end

function ChatData.ParsePCPItem(data)
    if not data then
        return
    end

    if data.ChannelId == GUIDefine.ChatChannel.PRIVATE and SL:GetValue("IS_PC_OPER_MODE") then
        local item = GUIFunction:GenerateChatPCPrivateItem(data)
        if not item then
            return
        end
        SL:onLUAEvent(LUA_EVENT_CHAT_PCPRIVATE_ITEM_ADD, item)

        ChatData.StoragePCPrivateItem(item, data.ChannelId)
    end
end

function ChatData.ParsePCGuildItem(data)
    if not data then
        return
    end

    local item = GUIFunction:GenerateChatPCGuildItem(data)
    if not item then
        return
    end
    SL:onLUAEvent(LUA_EVENT_CHAT_PCGUILD_ITEM_ADD, item)

    ChatData.StoragePCGuildItem(item, data.ChannelId)
end

---------------------------------- cache end----------------------------------


--自动喊话时间
function ChatData.OnChangeAutoShoutTime(time)
    if not time then
        return
    end
    ChatData.SetAutoShoutDelay(time)
end

-- 掉落消息参数
function ChatData.OnAddDropMsg(data)
    if not data or not next(data) then
        return
    end

    if not ChatData._fakeDropMsgF then
        SL:release_print("error: server not send drop_msg_format!")
        return
    end

    local dropType = data.dropType
    if not dropType or dropType == 0 then
        return
    end

    local itemName = SL:GetValue("ITEM_NAME", data.itemID)
    local str = ChatData._fakeDropMsgF
    str = string.gsub(str, "%%CREATENAME", data.playerName or "")
    str = string.gsub(str, "%%NAME", data.monsterName or "")
    str = string.gsub(str, "%%MAP", data.mapName or "")
    str = string.gsub(str, "%%ITEMID", data.itemID)
    str = string.gsub(str, "%%ITEM", itemName)
    str = string.gsub(str, "%%G_ITEM", data.g_itemName or "")
    str = string.gsub(str, "%%X", data.mapX)
    str = string.gsub(str, "%%Y", data.mapY)

    local data = {
        BColor      = data.BColor,
        FColor      = data.FColor,
        Msg         = str,
        ChannelId   = GUIDefine.ChatChannel.DROP,
        textType    = GUIDefine.ChatTextType.SRTEXT,
        dropType    = dropType
    }
    ChatData.AddChatItem(data)
end

function ChatData.OnChangeFakeDropTimes(data)
    local limitLowTimes = data.limitLowTimes
    local limitHighTimes = data.limitHighTimes
    ChatData.ChangeFakeDropTimerID(limitLowTimes, limitHighTimes)
end

-- 通知开关假掉落
function ChatData.OnChangeFakeDropStatus(data)
    if not data or not next(data) then
        return
    end
    local status = data.status
    local type = data.type
    if status == 0 then
        ChatData.CloseFakeDropTimerID()
        ChatData._closeFakeDrop = true
    elseif status == 1 then
        if ChatData.GetFakeDropShow() then
            ChatData.SetDropTypeSwitch(ChatData._fakeDropType, true)
            local isReceiving = ChatData.GetDropTypeSwitch(ChatData._dropTotalTypeID)
            ChatData.SetReceiving(GUIDefine.ChatChannel.DROP, isReceiving)
        end
        ChatData._curFakeDropType = type
        ChatData.OpenFakeDropTimerID()
        ChatData._closeFakeDrop = false
    end
    SL:onLUAEvent(LUA_EVENT_CHAT_FAKE_DROP_STATUS_CHANGE)
end

function ChatData.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_INITED, "ChatData", ChatData.OnPlayerPropertyInited)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_WORLD, "ChatData", ChatData.LoadConfig)
    SL:RegisterLUAEvent(LUA_EVENT_RECONNECT, "ChatData", ChatData.ClearChatExItemsData)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_MSG_ADD, "ChatData", ChatData.AddChatItem)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_AUTO_SHOUT_DELAY_TIME, "ChatData", ChatData.OnChangeAutoShoutTime)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_DROP_MSG_ADD, "ChatData", ChatData.OnAddDropMsg)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_FAKE_DROP_MSG_SPEED, "ChatData", ChatData.OnChangeFakeDropTimes)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_FAKE_DROP_OPEN_STATUS, "ChatData", ChatData.OnChangeFakeDropStatus)
    SL:RegisterLUAEvent(LUA_EVENT_GAME_MEMORY_RELEASE, "ChatData", ChatData.ReleaseCache)
end