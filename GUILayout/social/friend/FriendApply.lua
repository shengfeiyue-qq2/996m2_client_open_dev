FriendApply = {}

function FriendApply.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.FriendApplyGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "social/friend/friend_apply")
    FriendApply._ui = GUI:ui_delegate(parent)

    local posX = SL:GetValue("SCREEN_WIDTH") / 2
    local posY = SL:GetValue("IS_PC_OPER_MODE") and SL:GetValue("PC_POS_Y") or SL:GetValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(FriendApply._ui["Panel_1"], posX, posY)

    -- 关闭
    GUI:addOnClickEvent(FriendApply._ui["Button_close"], function()
        -- 移除主界面气泡 气泡id为5
        SL:DelBubbleTips(5)
        UIOperator:CloseFriendApplyUI()
    end)

    FriendApply.RefreshList()
    FriendApply.RegisterEvent()
end

function FriendApply.RefreshList()
    local data = SL:GetValue("FRIEND_APPLYLIST") or {}
    local ListView = FriendApply._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)
    for _, v in pairs(data) do
        local cell = FriendApply.CreateApplyCell()
        GUI:ListView_pushBackCustomItem(ListView, cell)
        GUI:setPositionX(cell, 8)

        local cellUI = GUI:ui_delegate(cell)

        GUI:Text_setString(cellUI["Text_apply_name"], string.format("%s   请求添加您为好友!", v.UserName))

        -- 同意添加
        GUI:addOnClickEvent(cellUI["Button_ok"], function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestAgreeFriendApply(v.UserID)
            FriendApply.RefreshList()
        end)

        -- 拒绝
        GUI:addOnClickEvent(cellUI["Button_no"], function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestRefuseFriendApply(v.UserID)
            FriendApply.RefreshList()
        end)
    end
end

function FriendApply.CreateApplyCell()
    local parent = GUI:Node_Create(FriendApply._ui["nativeUI"], "node", 0, 0)
    GUI:LoadExport(parent, "social/friend/friend_apply_cell")
    local apply_cell = GUI:getChildByName(parent, "apply_cell")
    GUI:removeFromParent(apply_cell)
    GUI:removeFromParent(parent)
    return apply_cell
end

-----------------------------------注册事件--------------------------------------
function FriendApply.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_FRIEND_APPLY, "FriendApply", FriendApply.RefreshList)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "FriendApply", FriendApply.UnRegisterEvent)

end

function FriendApply.UnRegisterEvent(ID)
    if ID ~= UIConst.LAYERID.FriendApplyGUI then
        return false
    end
    
    SL:UnRegisterLUAEvent(LUA_EVENT_FRIEND_APPLY, "FriendApply")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "FriendApply")
end

FriendApply.main()