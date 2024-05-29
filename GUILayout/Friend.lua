Friend = {}

-- 1我的好友 2黑名单
Friend._openPage = 1

function Friend.main(openPage)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "social/friend/friend_panel_win32" or "social/friend/friend_panel")

    Friend._ui = GUI:ui_delegate(parent)

    -- 我的好友
    local Button_myFriend = Friend._ui["Button_myFriend"]
    Friend.Button_myFriend = Button_myFriend
    GUI:addOnClickEvent(Button_myFriend, function()
        if Friend._openPage == 1 then
            return
        end
        Friend._openPage = 1
        Friend.RefreshBtn()
        Friend.RefreshList()
    end)

    -- 黑名单
    local Button_blackList = Friend._ui["Button_blackList"]
    Friend.Button_blackList = Button_blackList
    GUI:addOnClickEvent(Button_blackList, function()
        if Friend._openPage == 2 then
            return
        end
        Friend._openPage = 2
        Friend.RefreshBtn()
        Friend.RefreshList()
    end)

    -- 添加好友
    GUI:addOnClickEvent(Friend._ui["Button_add_friend"], function()
        SL:OpenAddFriendUI()
    end)

    -- 添加黑名单
    GUI:addOnClickEvent(Friend._ui["Button_add_blacklist"], function()
        SL:OpenAddBlackListUI()
    end)


    Friend._openPage = openPage or 1
    Friend.RefreshBtn()
    Friend.RegisterEvent()
    SL:RequestFriendList()
end

function Friend.RefreshBtn()
    GUI:Button_setBright(Friend.Button_myFriend, Friend._openPage ~= 1)
    GUI:Button_setBright(Friend.Button_blackList, Friend._openPage ~= 2)
    GUI:Button_setTitleColor(Friend.Button_myFriend, Friend._openPage == 1 and "#f8e6c6" or "#6c6861")
    GUI:Button_setTitleColor(Friend.Button_blackList, Friend._openPage == 2 and "#f8e6c6" or "#6c6861")

    Friend.RefreshUI()
    Friend.RefreshFriendNumber()
end

function Friend.RefreshUI()
    GUI:setVisible(Friend._ui["Panel_myFriend"], Friend._openPage == 1)
    GUI:setVisible(Friend._ui["Panel_blackList"], Friend._openPage == 2)
end

function Friend.OnFriendListUpdate()
    Friend.RefreshList()
    Friend.RefreshFriendNumber()
end

function Friend.RefreshList()
    local listView      = nil
    local imageNone     = nil
    local isShowImgNone = true
    local data          = nil
    local funcDockType  = nil
    local dockType      = SL:GetMetaValue("DOCKTYPE_NENUM")

    if Friend._openPage == 1 then
        funcDockType = dockType.Func_Friend
        listView = Friend._ui["ListView_myFriend"]
        imageNone = Friend._ui["Image_friend_none"]
        local friends = SL:GetMetaValue("FRIEND_LIST")
        data = table.values(friends)
        if #data >= 2 then
            table.sort(data, function(a, b)
                return a.Online > b.Online
            end)
        end

    elseif Friend._openPage == 2 then
        funcDockType = dockType.Func_Friend_BlackList
        listView = Friend._ui["ListView_blackList"]
        imageNone = Friend._ui["Image_blackList_none"]
        local blacklist = SL:GetMetaValue("FRIEND_BLACKLIST")
        data = table.values(blacklist)
        if #data >= 2 then
            table.sort(data, function(a, b)
                if a.Online ~= b.Online then
                    return a.Online > b.Online
                else
                    if a.Online == 0 then
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
            local Text_name   = cellUI["Text_name"]
            local Text_level  = cellUI["Text_level"]
            local Text_guild  = cellUI["Text_guild"]
            local Text_online = cellUI["Text_online"]
            local onlineColor = v.Online == 0 and "#bfbfbf" or "#ffffff"     -- 设置离线/在线的字体颜色,离线置灰

            GUI:Text_setTextColor(Text_job, onlineColor)
            GUI:Text_setTextColor(Text_name, onlineColor)
            GUI:Text_setTextColor(Text_level, onlineColor)
            GUI:Text_setTextColor(Text_guild, onlineColor)
            GUI:Text_setTextColor(Text_online, onlineColor)

            GUI:Text_setString(Text_job, v.Job)
            GUI:Text_setString(Text_name, v.Name)
            GUI:Text_setString(Text_level, v.Level)
            GUI:Text_setString(Text_guild, v.Guild or "")
            GUI:Text_setString(Text_online, v.Online == 0 and "离线" or "在线")

            GUI:addOnClickEvent(cell, function()
                SL:OpenFuncDockTips({
                    type = funcDockType,
                    targetId = v.UserId,
                    targetName = v.Name,
                    pos = {x = GUI:getTouchEndPosition(cell).x + 20, y = GUI:getTouchEndPosition(cell).y}
                })
            end)
        end
    end

    if imageNone then
        GUI:setVisible(imageNone, isShowImgNone)
    end
end

function Friend.CreateMemberCell()
    local parent = GUI:Node_Create(Friend._ui["nativeUI"], "node", 0, 0)
    if SL:GetMetaValue("WINPLAYMODE") then
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
    local Text_friend_number = Friend._ui["Text_friend_number"]
    GUI:setVisible(Text_friend_number, Friend._openPage == 1)
    if Friend._openPage == 1 then
        local friends = SL:GetMetaValue("FRIEND_LIST")
        local numStr = string.format("好友: %s/%s", table.nums(friends), SL:GetMetaValue("FRIEND_MAX_COUNT"))
        GUI:Text_setString(Text_friend_number, numStr)
    end
end

-----------------------------------注册事件--------------------------------------
function Friend.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_LIST_UPDATE, "Friend", Friend.OnFriendListUpdate)
end

function Friend.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_FRIEND_LIST_UPDATE, "Friend")
end