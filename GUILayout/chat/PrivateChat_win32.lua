
PrivateChat = {}

function PrivateChat.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.PCPrivateChatGUI) then
        UIOperator:ClosePCPrivateUI()
        return
    end

    SL:DelBubbleTips(GUIDefine.BubbleType.PRIVATE_CHAT)

    local parent = GUI:Win_Create(UIConst.LAYERID.PCPrivateChatGUI, 0, 0, 0, 0)
    GUI:LoadExport(parent, "chat/private_chat_win32")
    PrivateChat._layer = parent

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    PrivateChat._ui = GUI:ui_delegate(parent)
    GUI:setPosition(PrivateChat._ui.Panel_1, screenW / 2, SL:GetValue("PC_POS_Y"))

    -- 设置拖拽
    GUI:Win_SetDrag(parent, PrivateChat._ui.Panel_1)
    GUI:Win_SetZPanel(parent, PrivateChat._ui.Panel_1)

    PrivateChat._autoStr = ""
    PrivateChat._percent = 0
    PrivateChat._cache = {}
    PrivateChat._isScrolling = false

    PrivateChat.InitUI()
    PrivateChat.InitListEvent()
    PrivateChat.RegisterEvent()
end

function PrivateChat.InitUI()
    local CHANNEL = GUIDefine.ChatChannel
    local receiveChannel = ChatData.GetReceiveChannel()

    -- 关闭
    GUI:addOnClickEvent(PrivateChat._ui.Button_close, function()
        UIOperator:ClosePCPrivateUI()
    end)

    -- 清理
    PrivateChat._listView = PrivateChat._ui.ListView_cells
    GUI:ListView_removeAllItems(PrivateChat._listView)

    -- 消息
    local receiveCache = ChatData.GetPCPrivateCache() or {}
    for _, v in ipairs(receiveCache) do
        PrivateChat.PushItem(v)
    end
    GUI:ListView_jumpToBottom(PrivateChat._listView)

    --自动回复
    local isSelected = ChatData.GetAutoReplySwitch()
    GUI:CheckBox_setSelected(PrivateChat._ui.CheckBox_1, isSelected == true)
    GUI:CheckBox_setZoomScale(PrivateChat._ui.CheckBox_1, -0.05)
    GUI:CheckBox_addOnEvent(PrivateChat._ui.CheckBox_1, function()
        local isSelected = GUI:CheckBox_isSelected(PrivateChat._ui.CheckBox_1)
        ChatData.SetAutoReplySwitch(isSelected and 1 or 0)
    end)

    PrivateChat._editBox = PrivateChat._ui.TextField_1
    GUI:TextInput_addOnEvent(PrivateChat._editBox, function (sender, eventType)
        local inputStr = GUI:TextInput_getString(PrivateChat._editBox)
        if eventType == 2 or eventType == 3 or eventType == 4 then
            inputStr = string.gsub(string.trim(inputStr), "[\t\n\r]", "")
            GUI:TextInput_setString(PrivateChat._editBox, inputStr)
        elseif eventType == 1 then
            -- 检测敏感词
            SL:RequestCheckSensitiveWord(inputStr, 2, function(state, str, risk_param, ex_param)
                GUI:TextInput_setString(PrivateChat._editBox, str)
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

                PrivateChat._autoStr = str
                ChatData.SetLocalChatDataByChannel(CHANNEL.PRIVATE, PrivateChat._autoStr)
            end, {channel_id = CHANNEL.PRIVATE})
            
        end
    end)
    
    local str = ChatData.GetLocalChatDataByChannel(CHANNEL.PRIVATE)
    if str and string.len(str) then
        PrivateChat._autoStr = str 
        GUI:TextInput_setString(PrivateChat._editBox, PrivateChat._autoStr)
    end
    
end

function PrivateChat.InitListEvent()

    local pSize = GUI:getContentSize(PrivateChat._ui.Image_2)
    local progressBar = PrivateChat._ui.Image_bar
    GUI:setTouchEnabled(progressBar, true)
 
    local innerSize     = GUI:ListView_getInnerContainerSize(PrivateChat._listView)
    local contentSize   = GUI:getContentSize(PrivateChat._listView)
    local arrowHei      = 16
  
    local bodyHei   = GUI:getContentSize(progressBar).height
    local originY   = arrowHei + bodyHei / 2
    local minY      = originY
    local maxY      = pSize.height - arrowHei - bodyHei / 2
    local hei       = pSize.height - 2 * arrowHei - bodyHei

    local function setPercent(p)
        PrivateChat._percent = p
        local posY  = (1 - p) * hei + originY
        posY        = math.min(math.max(posY, minY), maxY)
        GUI:setPositionY(progressBar, posY)
    end
    local function bodyCallback(sender, eventType)
        if eventType == 1 then
            local movePos   = GUI:getTouchMovePosition(sender)
            local convertP  = GUI:convertToNodeSpace(PrivateChat._ui.Image_2, movePos.x, movePos.y)
            local posY      = convertP.y
            local p         = (hei - (posY - originY)) / hei
            p               = math.min(math.max(p, 0), 1)
            GUI:ListView_jumpToPercentVertical(PrivateChat._listView, p * 100)
            if p == 1 then
                PrivateChat._isScrolling = false
                PrivateChat.ShowCache()
            end
        end
    end
    local function scrollCallback(sender, eventType)
        if eventType == GUIDefine.ScrollEventType.CONTAINER_MOVED then
            local innerPos      = GUI:ListView_getInnerContainerPosition(sender)
            local innerSize     = GUI:ListView_getInnerContainerSize(sender)
            local contentSize   = GUI:getContentSize(sender)
            local percentHeight = innerSize.height - contentSize.height
            local percent       = percentHeight > 0 and (percentHeight + innerPos.y) / percentHeight or 1
            setPercent(percent)
            if percent == 1 then
                PrivateChat._isScrolling = false
                PrivateChat.ShowCache()
            end
        end
    end
    setPercent(0)
    GUI:addOnTouchEvent(progressBar, bodyCallback)
    GUI:ListView_addOnScrollEvent(PrivateChat._listView, scrollCallback)

    ---
    local function onUpOrDown(isUp)
        if not PrivateChat._percent then return end
        local innerSize     = GUI:ListView_getInnerContainerSize(PrivateChat._listView)
        local contentSize   = GUI:getContentSize(PrivateChat._listView)
        if innerSize.height - contentSize.height <= 0 then
            return
        end

        local per = (14 * 2) / (innerSize.height - contentSize.height)
        PrivateChat._percent = PrivateChat._percent + (isUp and -per or per)
        local posY  = (1 - PrivateChat._percent) * hei + originY
        posY        = math.min(math.max(posY, minY), maxY)
        progressBar:setPositionY(posY)

        local p     = (hei - (posY - originY)) / hei
        p           = math.min(math.max(p, 0), 1)
        GUI:ListView_jumpToPercentVertical(PrivateChat._listView, p * 100)
    end
    GUI:setTouchEnabled(PrivateChat._ui.Image_down, true)
    GUI:addOnClickEvent(PrivateChat._ui.Image_down, function()
        onUpOrDown()
    end)

    GUI:setTouchEnabled(PrivateChat._ui.Image_up, true)
    GUI:addOnClickEvent(PrivateChat._ui.Image_up, function()
        onUpOrDown(true)
    end)
end

function PrivateChat.PushItem(item)
    if not item then
        return
    end
    GUI:ListView_pushBackCustomItem(PrivateChat._listView, item)
    SL:scheduleOnce(PrivateChat._listView, function() 
        if GUI:ListView_getItemCount(PrivateChat._listView) > GUIDefine.ChatConfig.LIMIT_COUNT then
            GUI:ListView_removeItemByIndex(PrivateChat._listView, 0)
        end
        GUI:ListView_jumpToBottom(PrivateChat._listView)
    end, 0)
end

function PrivateChat.AddItem(item)
    -- 是否正在拖动
    if next(GUI:ListView_getItems(PrivateChat._listView)) then
        local lastIdx   = GUI:ListView_getItemCount(PrivateChat._listView) - 1
        local lastItem  = GUI:ListView_getItemByIndex(PrivateChat._listView, lastIdx)
        local csize     = GUI:getContentSize(item)
        local worldPosY = GUI:getWorldPosition(lastItem).y
        local listViewY = GUI:getWorldPosition(PrivateChat._listView).y - GUI:getContentSize(PrivateChat._listView).height
        -- 是否屏幕外
        if worldPosY < listViewY then
            PrivateChat._isScrolling = true
        end
    end

    if PrivateChat._isScrolling then
        -- 正在拖动，消息缓存
        GUI:addRef(item)
        table.insert(PrivateChat._cache, item)
    
        while #PrivateChat._cache > GUIDefine.ChatConfig.LIMIT_COUNT do
            local item = table.remove(PrivateChat._cache, 1)
            GUI:autoDecRef(item)
        end
    else
        PrivateChat.PushItem(item)
        GUI:ListView_jumpToBottom(PrivateChat._listView)
    end
end

function PrivateChat.ShowCache()
    -- 缓存填充
    while #PrivateChat._cache > 0 do
        local item = table.remove(PrivateChat._cache, 1)
        GUI:autoDecRef(item)
        PrivateChat.PushItem(item)
    end
    GUI:ListView_jumpToBottom(PrivateChat._listView)
end

---------------------------------------------------
function PrivateChat.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PCPRIVATE_ITEM_ADD, "PrivateChat", PrivateChat.AddItem, PrivateChat._layer)
end

---------------------------------------------------

PrivateChat.main()