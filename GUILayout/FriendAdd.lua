FriendAdd = {}

function FriendAdd.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "social/friend/friend_addfriend")
    FriendAdd._ui = GUI:ui_delegate(parent)

    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(FriendAdd._ui["Panel_2"], posX, posY)

    -- 关闭
    GUI:addOnClickEvent(FriendAdd._ui["Button_close"], function()
        SL:CloseAddFriendUI()
    end)

    -- 取消
    GUI:addOnClickEvent(FriendAdd._ui["Button_cancel"], function()
        SL:CloseAddFriendUI()
    end)

    -- 输入框
    local searchInput = FriendAdd._ui["TextField_friend_search"]

    -- 添加好友
    GUI:addOnClickEvent(FriendAdd._ui["Button_ok"], function()
        local inputStr = GUI:TextInput_getString(searchInput)

        -- 输入内容判断是否空
        local searchStr = string.gsub(inputStr, "^%s*(.-)%s*$", "%1")
        if string.len(searchStr) == 0 then
            SL:ShowSystemTips("输入的内容不能为空")
            return
        end

        -- 是玩家自己
        if inputStr == SL:GetMetaValue("USER_NAME") then
            SL:ShowSystemTips("不能添加自己为好友")
            return
        end

        -- 已经是好友
        if SL:GetMetaValue("SOCIAL_IS_FRIEND", inputStr) then
            SL:ShowSystemTips("该玩家已经是你的好友")
            return
        end

        -- 在黑名单中，二次确认
        if SL:GetMetaValue("SOCIAL_IS_BLICKLIST", inputStr) then
            local data    = {}
            data.btnType  = 2
            data.str      = string.format("玩家 %s 在你的黑名单中，是否将该玩家从黑名单中删除并加为好友?", inputStr)
            data.callback = function(eventType, custom)
                if 1 == eventType then
                    -- 请求添加好友
                    SL:RequestAddFriend(inputStr)
                end
            end
            SL:OpenCommonTipsPop(data)
        else
            -- 请求添加好友
            SL:RequestAddFriend(inputStr)
        end
    end)
end