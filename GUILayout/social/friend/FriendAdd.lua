FriendAdd = {}

function FriendAdd.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.FriendAddGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/friend/friend_addfriend")
    FriendAdd._ui = GUI:ui_delegate(parent)

    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(FriendAdd._ui["Panel_2"], posX, posY)

    -- 关闭
    GUI:addOnClickEvent(FriendAdd._ui["Button_close"], function()
        UIOperator:CloseAddFriendUI()
    end)

    -- 取消
    GUI:addOnClickEvent(FriendAdd._ui["Button_cancel"], function()
        UIOperator:CloseAddFriendUI()
    end)

    -- 输入框
    local searchInput = FriendAdd._ui["TextField_friend_search"]

    -- 添加好友
    GUI:addOnClickEvent(FriendAdd._ui["Button_ok"], function(sender)
        local inputStr = GUI:TextInput_getString(searchInput)

        -- 输入内容判断是否空
        local searchStr = string.gsub(inputStr, "^%s*(.-)%s*$", "%1")
        if string.len(searchStr) == 0 then
            SL:ShowSystemTips("输入的内容不能为空")
            return
        end

        -- 是玩家自己
        if inputStr == SL:GetValue("USER_NAME") then
            SL:ShowSystemTips("不能添加自己为好友")
            return
        end

        -- 已经是好友
        if SL:GetValue("SOCIAL_IS_FRIEND_BY_NAME", inputStr) then
            SL:ShowSystemTips("该玩家已经是你的好友")
            return
        end

        -- 在黑名单中，二次确认
        if SL:GetValue("SOCIAL_IS_BLICKLIST", inputStr) then
            local data    = {}
            data.btnType  = 2
            data.str      = string.format("玩家 %s 在你的黑名单中，是否将该玩家从黑名单中删除并加为好友?", inputStr)
            data.callback = function(eventType, custom)
                if 1 == eventType then
                    -- 请求添加好友
                    SL:RequestAddFriend(inputStr)
                end
            end
            UIOperator:OpenCommonTipsUI(data)
        else
            -- 请求添加好友
            SL:RequestAddFriend(inputStr)
            GUI:delayTouchEnabled(sender)
        end
    end)
end

FriendAdd.main()