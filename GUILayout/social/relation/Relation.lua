Relation = {}

RelationInfo = RelationInfo or {} 

function Relation.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    Relation._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if Relation._isWinMode then
        GUI:LoadExport(parent, "social/relation/relation_win32")
    else
        GUI:LoadExport(parent, "social/relation/relation")
    end

    RelationInfo._ui = GUI:ui_delegate(parent)
    RelationInfo._layer = RelationInfo._ui.relationLayer
    RelationInfo._openType = nil

    RelationInfo._typeCells = {}

    RelationInfo._curTypeIdx = 1
    RelationInfo._curNetID = nil
    RelationInfo._curNetRank = nil

    RelationInfo._callBtnPosX = GUI:getPositionX(RelationInfo._ui.Button_call)

    Relation.InitUI()
    Relation.RegisterEvent()
end

function Relation.InitUI()
    Relation.InitTypeList()

    -- 召集成员
    GUI:addOnClickEvent(RelationInfo._ui.Button_call, function(sender)
        if not RelationInfo._curNetID then
            return
        end
        local config = SL:GetValue("RELATION_TYPE_CONFIG", RelationInfo._openType)
        local callCD = config and config.callCD or 50
        callCD = callCD / 1000
        GUI:delayTouchEnabled(sender, callCD)
        ---
        SL:RequestRelationCallMember(RelationInfo._openType, RelationInfo._curNetID, RelationInfo._curNetRank)
    end)

    -- 邀请成员
    GUI:addOnClickEvent(RelationInfo._ui.Button_invite, function()
        UIOperator:OpenRelationInvite(RelationInfo._openType)
    end)

    -- 解除关系
    GUI:addOnClickEvent(RelationInfo._ui.Button_exit, function(sender)
        if not RelationInfo._curNetID then
            return
        end
        GUI:delayTouchEnabled(sender)
        SL:RequestRelationDissolveOrExit(RelationInfo._curNetID)
    end)

    -- 解散关系
    GUI:addOnClickEvent(RelationInfo._ui.Button_dissolve, function(sender)
        if not RelationInfo._curNetID then
            return
        end
        GUI:delayTouchEnabled(sender)
        SL:RequestRelationDissolveOrExit(RelationInfo._curNetID)
    end)

    -- 允许建立关系
    GUI:CheckBox_addOnEvent(RelationInfo._ui.CheckBox_permit, function(sender)
        local isSelected = GUI:CheckBox_isSelected(sender)
        SL:SetValue("RELATION_INVITED_PERMIT_BY_TYPE", RelationInfo._openType, isSelected)
    end)

    -- 允许召集
    GUI:CheckBox_addOnEvent(RelationInfo._ui.CheckBox_permit_call, function(sender)
        local isSelected = GUI:CheckBox_isSelected(sender)
        SL:SetValue("RELATION_CALL_PERMIT_BY_TYPE", RelationInfo._openType, isSelected)
    end)
end

function Relation.InitTypeList()
    local typeList = SL:GetValue("RELATION_TYPE_LIST")
    if not typeList or not next(typeList) then
        return
    end
    for i = 1, #typeList do
        local type = typeList[i]
        if not RelationInfo._openType then
            RelationInfo._openType = type
        end
        local btn = Relation.CreateTypeBtn()
        GUI:Button_setTitleText(btn, SL:GetValue("RELATION_TYPE_NAME", type))
        GUI:ListView_pushBackCustomItem(RelationInfo._ui.ListView_type, btn)
        GUI:setTag(btn, type)
        table.insert(RelationInfo._typeCells, btn)
        GUI:addOnClickEvent(btn, function(sender)
            if RelationInfo._openType == type then
                return
            end
            RelationInfo._openType = type
            Relation.UpdateTypeShow()
        end)
    end
    Relation.UpdateTypeShow()
end

function Relation.UpdateTypeShow()
    local child = GUI:getChildByName(RelationInfo._ui.ListView_type, "filterListView")
    if child then
        GUI:ListView_removeChild(RelationInfo._ui.ListView_type, child)
    end

    local insertIdx = nil
    for i, cell in ipairs(RelationInfo._typeCells) do
        local selected = GUI:getTag(cell) == RelationInfo._openType
        GUI:Button_setBright(cell, not selected)
        local titleColor = selected and "#f8e6c6" or "#6c6861"
        GUI:Button_setTitleColor(cell, titleColor)
        if selected then
            insertIdx = GUI:ListView_getItemIndex(RelationInfo._ui.ListView_type, cell) + 1
        end
    end

    local config = SL:GetValue("RELATION_TYPE_CONFIG", RelationInfo._openType)
    local filterList = config and config.filterNameList or {}
    if next(filterList) and insertIdx then
        RelationInfo._curTypeIdx = 1

        local filterListView = GUI:ListView_Create(-1, "filterListView", 0, 0, 0, 0, 1)
        GUI:ListView_setGravity(filterListView, 5)
        GUI:ListView_addMouseScrollPercent(filterListView)
        GUI:ListView_insertCustomItem(RelationInfo._ui.ListView_type, filterListView, insertIdx)

        local cells = {}
        local jumpIndex = 0
        local itemSize = nil
        for i, v in ipairs(filterList) do
            local selected = i == RelationInfo._curTypeIdx
            jumpIndex      = selected and i or jumpIndex

            local cell     = Relation.CreateFilterCell()
            GUI:ListView_pushBackCustomItem(filterListView, cell)
            GUI:setTag(cell, i)
            table.insert(cells, cell)
            local ui = GUI:ui_delegate(cell)
            GUI:Text_setString(ui.Text_name, v)
            GUI:setVisible(ui.Image_1, selected)
            GUI:addOnClickEvent(cell, function()
                local idx = GUI:getTag(cell)
                if RelationInfo._curTypeIdx == idx then
                    return
                end

                RelationInfo._curTypeIdx = idx
                for k, cell in ipairs(cells) do
                    GUI:setVisible(GUI:getChildByName(cell, "Image_1"), RelationInfo._curTypeIdx == GUI:getTag(cell))
                end

                -- refresh 
                Relation.RefreshContent()
            end)

            if not itemSize then
                itemSize = GUI:getContentSize(cell)
            end
        end
        local listWid = GUI:getContentSize(RelationInfo._ui.ListView_type).width
        local listHei = itemSize.height * #filterList
        GUI:setContentSize(filterListView, listWid, listHei)

        jumpIndex = jumpIndex - 1
        GUI:ListView_jumpToItem(RelationInfo._ui.ListView_type, jumpIndex)
    end

    local allowSwitch = config and config.allowSwitch == 1
    if allowSwitch then
        GUI:CheckBox_setSelected(RelationInfo._ui.CheckBox_permit, SL:GetValue("RELATION_INVITED_PERMIT_BY_TYPE", RelationInfo._openType))
    end
    GUI:CheckBox_setSelected(RelationInfo._ui.CheckBox_permit_call, SL:GetValue("RELATION_CALL_PERMIT_BY_TYPE", RelationInfo._openType))

    Relation.RefreshContent()

end

function Relation.CreateTypeBtn()
    local parent = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/relation/relation_type_cell_win32")
    else
        GUI:LoadExport(parent, "social/relation/relation_type_cell")
    end
    local btn = GUI:getChildByName(parent, "Button_relation")
    GUI:removeFromParent(btn)
    return btn
end

function Relation.CreateFilterCell()
    local parent = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/relation/relation_filter_cell_win32")
    else
        GUI:LoadExport(parent, "social/relation/relation_filter_cell")
    end
    local cell = GUI:getChildByName(parent, "Panel_1")
    GUI:removeFromParent(cell)
    return cell
end

function Relation.RefreshContent()
    local memberListView = RelationInfo._ui.ListView_member
    GUI:ListView_removeAllItems(memberListView)

    local config = SL:GetValue("RELATION_TYPE_CONFIG", RelationInfo._openType)
    local allowSwitch = config and config.allowSwitch == 1
    GUI:setVisible(RelationInfo._ui.CheckBox_permit, RelationInfo._curTypeIdx == 1 and allowSwitch)
    GUI:setVisible(RelationInfo._ui.CheckBox_permit_call, RelationInfo._curTypeIdx == 1)

    local callBtnShow = true
    local exitBtnShow = RelationInfo._curTypeIdx == 1
    local inviteBtnShow = RelationInfo._curTypeIdx == 1 and config.multistage == 1 or RelationInfo._curTypeIdx == 3
    local dissolveBtnShow = RelationInfo._curTypeIdx == 3

    RelationInfo._curNetID = nil
    local relationData = SL:GetValue("RELATION_TYPE_DATA", RelationInfo._openType)
    if not relationData or not next(relationData) then
        Relation.SetBottomBtnShow(false, false, inviteBtnShow, false)
        return
    end
    
    local memList = {}
    local isMy = false
    for netID, data in pairs(relationData) do
        if RelationInfo._curTypeIdx == 3 and data.MasterID == SL:GetValue("USER_ID") then
            memList = data.MemList
            RelationInfo._curNetID = data.NetID
            isMy = true
            break
        elseif RelationInfo._curTypeIdx == 1 and (config.multistage == 1 or data.MasterID ~= SL:GetValue("USER_ID")) then
            if config.multistage == 1 then
                memList = data.MemList
            else
                for i, v in ipairs(data.MemList) do
                    if v.Rank == 0 or v.UserID == SL:GetValue("USER_ID") then
                        table.insert(memList, v)
                    end
                end
            end
            RelationInfo._curNetID = data.NetID
            break
        elseif RelationInfo._curTypeIdx == 2 and data.MasterID ~= SL:GetValue("USER_ID") then
            for i, v in ipairs(data.MemList) do
                if v.Rank ~= 0 then
                    table.insert(memList, v)
                end
            end
            RelationInfo._curNetID = data.NetID
            break
        end
    end
    
    if #memList <= 1 then
        callBtnShow = false
        exitBtnShow = false
        dissolveBtnShow = false
    end
    Relation.SetBottomBtnShow(callBtnShow, exitBtnShow, inviteBtnShow, dissolveBtnShow)
    
    if GUI:getVisible(RelationInfo._ui.Button_call) then
        local posX = RelationInfo._curTypeIdx == 2 and GUI:getPositionX(RelationInfo._ui.Button_exit) or RelationInfo._callBtnPosX
        GUI:setPositionX(RelationInfo._ui.Button_call, posX)
    end

    Relation.RefreshMemberList(memList, isMy)
end

function Relation.SetBottomBtnShow(callBtnShow, exitBtnShow, inviteBtnShow, dissolveBtnShow)
    GUI:setVisible(RelationInfo._ui.Button_call, callBtnShow)
    GUI:setVisible(RelationInfo._ui.Button_exit, exitBtnShow)
    GUI:setVisible(RelationInfo._ui.Button_invite, inviteBtnShow)
    GUI:setVisible(RelationInfo._ui.Button_dissolve, dissolveBtnShow)
end

function Relation.RefreshMemberList(memberList, isMy)
    local ListView_member = RelationInfo._ui.ListView_member
    GUI:ListView_removeAllItems(ListView_member)

    for _, member in ipairs(memberList) do
        if member.UserID ~= SL:GetValue("USER_ID") then
            local cell = Relation.CreateMemberCell()
            GUI:ListView_pushBackCustomItem(ListView_member, cell)

            local guildName = "无"
            if member.Guild and member.Guild ~= "" then 
                guildName = member.Guild
            end
            local cellUI = GUI:ui_delegate(cell)
            GUI:Text_setString(cellUI.Label_name, member.UserName)
            GUI:Text_setString(cellUI.Label_level, member.Level)
            GUI:Text_setString(cellUI.Label_guild, guildName)
            GUI:Text_setString(cellUI.Label_map, member.Map)
            GUI:Text_setString(cellUI.Label_job, SL:GetValue("JOB_NAME", member.Job))

            if isMy then
                GUI:setVisible(cellUI.Button_del, true)
                GUI:addOnClickEvent(cellUI.Button_del, function()
                    GUI:delayTouchEnabled(cellUI.Button_del)
                    SL:RequestRelationKickOutMember(member.UserID, RelationInfo._curNetID)
                end)
            end
        else
            -- Rank 0邀请者 1被邀进入关系
            RelationInfo._curNetRank = member.Rank
        end
    end
end

function Relation.CreateMemberCell()
    local parent = GUI:Node_Create(-1, "node", 0, 0)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "social/relation/relation_member_cell_win32")
    else
        GUI:LoadExport(parent, "social/relation/relation_member_cell")
    end
    local member_cell = GUI:getChildByName(parent, "member_cell")
    GUI:removeFromParent(member_cell)
    return member_cell
end

function Relation.RefreshTypeContent(type)
    if RelationInfo._openType ~= type then
        return
    end
    Relation.RefreshContent()
end

function Relation.OnClose()
    if RelationInfo and RelationInfo._layer then 
        Relation.UnRegisterEvent()
        RelationInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function Relation.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_DATA_REFRESH, "Relation", Relation.RefreshContent)
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_LAYER_CLOSE, "Relation", Relation.OnClose)
end

function Relation.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_DATA_REFRESH, "Relation")
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_LAYER_CLOSE, "Relation")
end

Relation.main()