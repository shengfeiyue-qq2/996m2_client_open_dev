Friend = {}

FriendInfo = FriendInfo or {}

function Friend.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    FriendInfo._parent = parent
    if not FriendInfo._layer then
        Friend.InitData()
        Friend.InitUI()
        Friend.RefreshBtn()
        Friend.RegisterEvent()
        SL:RequestFriendList() --可能被好友删了重新请求
    end
end

function Friend.InitData()
    -- 1我的好友 2黑名单
    FriendInfo._openPageTypes = {
        MyFriend = 1,
        BlackList = 2
    }
    FriendInfo._openPage = FriendInfo._openPageTypes.MyFriend
    FriendInfo._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
end

function Friend.InitUI()
    GUI:LoadExport(FriendInfo._parent, FriendInfo._isWinMode and "social/friend/friend_panel_win32" or "social/friend/friend_panel")
    FriendInfo._ui = GUI:ui_delegate(FriendInfo._parent)
    FriendInfo._layer = FriendInfo._ui.friendLayer
    -- 我的好友
    GUI:addOnClickEvent(FriendInfo._ui.Button_myFriend, function()
        if FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend then
            return
        end
        FriendInfo._openPage = FriendInfo._openPageTypes.MyFriend
        Friend.RefreshBtn()
        Friend.RefreshList()
    end)

    -- 黑名单
    GUI:addOnClickEvent(FriendInfo._ui.Button_blackList, function()
        if FriendInfo._openPage == FriendInfo._openPageTypes.BlackList then
            return
        end
        FriendInfo._openPage = FriendInfo._openPageTypes.BlackList
        Friend.RefreshBtn()
        Friend.RefreshList()
    end)

    -- 添加好友
    GUI:addOnClickEvent(FriendInfo._ui.Button_add_friend, function()
        UIOperator:OpenAddFriendUI()
    end)

    -- 添加黑名单
    GUI:addOnClickEvent(FriendInfo._ui.Button_add_blacklist, function()
        UIOperator:OpenAddBlackListUI()
    end)
end

function Friend.RefreshBtn()
    GUI:Button_setBright(FriendInfo._ui.Button_myFriend, FriendInfo._openPage ~= FriendInfo._openPageTypes.MyFriend)
    GUI:Button_setBright(FriendInfo._ui.Button_blackList, FriendInfo._openPage ~= FriendInfo._openPageTypes.BlackList)
    GUI:Button_setTitleColor(FriendInfo._ui.Button_myFriend, FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(FriendInfo._ui.Button_blackList, FriendInfo._openPage == FriendInfo._openPageTypes.BlackList and "#f8e6c6" or "#6c6861")

    Friend.RefreshUI()
    Friend.RefreshFriendNumber()
end

function Friend.RefreshUI()
    GUI:setVisible(FriendInfo._ui.Panel_myFriend, FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend)
    GUI:setVisible(FriendInfo._ui.Panel_blackList, FriendInfo._openPage == FriendInfo._openPageTypes.BlackList)
end

function Friend.OnFriendListUpdate()
    Friend.RefreshList()
    Friend.RefreshFriendNumber()
end

function Friend.OnBlackListUpdate()
    Friend.RefreshList()
end

function Friend.RefreshList()
    local listView      = nil
    local imageNone     = nil
    local isShowImgNone = true
    local data          = nil
    local funcDockType  = nil
    local dockType      = FuncDockData.FuncDockType

    if FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend then
        funcDockType = dockType.Func_Friend
        listView = FriendInfo._ui.ListView_myFriend
        imageNone = FriendInfo._ui.Image_friend_none
        local friends = SL:GetValue("FRIEND_LIST")
        data = table.values(friends)
        if #data >= 2 then
            table.sort(data, function(a, b)
                return a.Line > b.Line
            end)
        end

    elseif FriendInfo._openPage == FriendInfo._openPageTypes.BlackList then
        funcDockType = dockType.Func_Friend_BlackList
        listView = FriendInfo._ui.ListView_blackList
        imageNone = FriendInfo._ui.Image_blackList_none
        local blacklist = SL:GetValue("FRIEND_BLACKLIST")
        data = table.values(blacklist)
        if #data >= 2 then
            table.sort(data, function(a, b)
                if a.Line ~= b.Line then
                    return a.Line > b.Line
                else
                    if a.Line == 0 then
                        return a.Level > b.Level
                    end
                end
            end)
        end
    end

    if listView and data then
        GUI:ListView_removeAllItems(listView)
        for _, v in ipairs(data) do
            isShowImgNone = false
            local cell = Friend.CreateMemberCell()
            GUI:ListView_pushBackCustomItem(listView, cell)

            local cellUI = GUI:ui_delegate(cell)
            local Text_job    = cellUI["Text_job"]
            local Text_name = cellUI["Text_name"]
            local Text_level = cellUI["Text_level"]
            local Text_guild = cellUI["Text_guild"]
            local Text_online = cellUI["Text_online"]
            local onlineColor = v.Line == 0 and "#bfbfbf" or "#ffffff"     -- 设置离线/在线的字体颜色,离线置灰
            local guildName = "无"
            if v.GuildName and v.GuildName ~= "" then 
                guildName = v.GuildName
            end
            GUI:Text_setTextColor(Text_job, onlineColor)
            GUI:Text_setTextColor(Text_name, onlineColor)
            GUI:Text_setTextColor(Text_level, onlineColor)
            GUI:Text_setTextColor(Text_guild, onlineColor)
            GUI:Text_setTextColor(Text_online, onlineColor)

            GUI:Text_setString(Text_job, SL:GetValue("JOB_NAME_BY_ID", v.Job))
            GUI:Text_setString(Text_name, v.UserName)
            GUI:Text_setString(Text_level, v.Level)
            GUI:Text_setString(Text_guild, guildName)
            GUI:Text_setString(Text_online, v.Line == 0 and "离线" or "在线")

            GUI:addOnClickEvent(cell, function()
                UIOperator:OpenFuncDockTips({
                    type = funcDockType,
                    targetId = v.UserID,
                    targetName = v.UserName,
                    pos = { x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y }
                })
            end)
        end
    end

    if imageNone then
        GUI:setVisible(imageNone, isShowImgNone)
    end
end

function Friend.CreateMemberCell()
    local parent = GUI:Node_Create(FriendInfo._ui.nativeUI, "node", 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/friend/friend_member_cell_win32")
    else
        GUI:LoadExport(parent, "social/friend/friend_member_cell")
    end
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    GUI:removeFromParent(parent)
    return member_cell
end

function Friend.RefreshFriendNumber()
    GUI:setVisible(FriendInfo._ui.Text_friend_number, FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend)
    if FriendInfo._openPage == FriendInfo._openPageTypes.MyFriend then
        local friends = SL:GetValue("FRIEND_LIST")
        local numStr = string.format("好友: %s/%s", table.nums(friends), SL:GetValue("FRIEND_MAX_COUNT"))
        GUI:Text_setString(FriendInfo._ui.Text_friend_number, numStr)
    end
end

function Friend.OnClose()
    if FriendInfo and FriendInfo._layer then 
        Friend.UnRegisterEvent()
        FriendInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function Friend.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_LIST_UPDATE, "Friend", Friend.OnFriendListUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_BLACK_LIST_UPDATE, "Friend", Friend.OnBlackListUpdate)
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_LAYER_CLOSE, "Friend", Friend.OnClose)
end

function Friend.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_FRIEND_LIST_UPDATE, "Friend")
    SL:UnRegisterLUAEvent(LUA_EVENT_BLACK_LIST_UPDATE, "Friend")
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_LAYER_CLOSE, "Friend")
end

Friend.main()