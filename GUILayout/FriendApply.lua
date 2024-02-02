FriendApply = {}

function FriendApply.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "social/friend/friend_apply")
    FriendApply._ui = GUI:ui_delegate(parent)

    local posX = SL:GetMetaValue("SCREEN_WIDTH") / 2
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or SL:GetMetaValue("SCREEN_HEIGHT") / 2
    GUI:setPosition(FriendApply._ui["Panel_1"], posX, posY)

    -- 关闭
    GUI:addOnClickEvent(FriendApply._ui["Button_close"], function()
        -- 移除主界面气泡 气泡id为5
        SL:DelBubbleTips(5)
        SL:CloseFriendApplyUI()
    end)

    FriendApply.RefreshList()
    FriendApply.RegisterEvent()
end

function FriendApply.RefreshList()
    local data = SL:GetMetaValue("FRIEND_APPLYLIST") or {}
    local ListView = FriendApply._ui["ListView"]
    GUI:ListView_removeAllItems(ListView)
    for _, v in pairs(data) do
        local cell = FriendApply.CreateApplyCell()
        GUI:ListView_pushBackCustomItem(ListView, cell)
        cell:setPositionX(8)

        local cellUI = GUI:ui_delegate(cell)

        GUI:Text_setString(cellUI["Text_apply_name"], string.format("%s   请求添加您为好友!", v.Name))

        -- 同意添加
        GUI:addOnClickEvent(cellUI["Button_ok"], function()
            SL:RequestAgreeFriendApply(v.Name)
            SL:RequestDelFriendApplyData(v.Name)
            FriendApply.RefreshList()
        end)

        -- 拒绝
        GUI:addOnClickEvent(cellUI["Button_no"], function()
            SL:RequestDelFriendApplyData(v.Name)
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
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "FriendApply", FriendApply.RemoveEvent)

end

function FriendApply.RemoveEvent(ID)
    if ID ~= "FriendApplyGUI" then
        return false
    end
    
    SL:UnRegisterLUAEvent(LUA_EVENT_FRIEND_APPLY, "FriendApply")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "FriendApply")
end