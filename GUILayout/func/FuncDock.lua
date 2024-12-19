FuncDock = {}

local FuncType = FuncDockData.FuncDockType
local BtnType = FuncDockData.BtnOperatorType

FuncDock.BtnTypeShowName = {
    [BtnType.look_role]     = "查看玩家",
    [BtnType.add_friend]    = "加为好友",
    [BtnType.chat]          = "私聊",
    [BtnType.team]          = "组队",
    [BtnType.trade]         = "交易",
    [BtnType.invite_team]   = "邀请入队",
    [BtnType.invite_guild]  = "邀请入会",
    [BtnType.apply_team]    = "申请入队",
    [BtnType.out_team]      = "踢出队伍",
    [BtnType.set_teamLeader]= "升为队长",
    [BtnType.add_blacklist] = "拉黑",
    [BtnType.out_guild]     = "踢出行会",
    [BtnType.call_teammate] = "召集队员",
    [BtnType.send_position] = "发送位置",
    [BtnType.exit_team]     = "退出队伍",
    [BtnType.out_blacklist] = "取消拉黑",
    [BtnType.delete_friend] = "删除好友",
    
    [BtnType.challenge]     = "发起挑战",
    [BtnType.horse_invite]  = "邀请骑马",
}

function FuncDock.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    if GUI:GetWindow(nil, UIConst.LAYERID.FuncDockGUI) then
        return
    end

    if not FuncDockData.CanOpen(data) then
        return false
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.FuncDockGUI, 0, 0, 0, 0, false, false, nil, nil, nil, nil, GUIDefine.UIZ.FUNC)
    GUI:LoadExport(parent, "common_tips/func_dock")

    FuncDock._targetName = ""
    FuncDock._targetId = -1

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    FuncDock._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(FuncDock._ui.Panel_1, screenW, screenH)

    GUI:addOnClickEvent(FuncDock._ui.Panel_1, function()
        UIOperator:CloseFuncDockTips()
    end)

    FuncDock._listView = FuncDock._ui.ListView

    FuncDock.SetLayerType(data)
end

-- notClick: 点击FuncDock的触摸层之后，是否关闭FuncDock
-- exitCallBack: 关闭FuncDock之后要调用的回调
function FuncDock.SetLayerType(data)
    local dockType = data.type
    local pos = data.pos or {x = 0, y = 0}
    local targetId = data.targetId
    local targetName = data.targetName
    local notClick = data.notClick
    local exitCallBack = data.exitCallBack
    local anchorPoint = data.anchorPoint or {x = 0, y = 1}
    local showType = data.showType or 1 -- 1:操作其他玩家显示的列表 2:道具tips用到的按钮
    local playerBasic = data.basic

    if targetId == nil then
        targetId = -1
        data.targetId = -1
    end
    FuncDock._targetId = targetId
    FuncDock._targetName = targetName

    FuncDockData.SetParam(data)

    if notClick then
        GUI:setTouchEnabled(FuncDock._ui.Panel_1, false)
    end
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:setMouseEnabled(FuncDock._ui.Panel_1, true)
    end

    GUI:setVisible(FuncDock._ui.Image_bg, showType == 1)
    GUI:ListView_removeAllItems(FuncDock._listView)

    local btnList = FuncDockData.FuncConfig[dockType] or {}

    local count = 0
    local maxWidth = 0
    local cellHei = 0
    for i = 1, #btnList do
        local btnType = btnList[i]
        if btnType and FuncDockData.IsShowBtn(dockType, btnType) then
            count = count + 1
            local cell = FuncDock.CreateFuncDockCell(i)
            local name = ""
            if btnType >= BtnType.appoint_rank1 and btnType <= BtnType.appoint_rank5 then
                name = string.format("任命%s", SL:GetValue("GUILD_OFFICIAL_NAME_BY_RANK", btnType - 101))

            elseif FuncDockData.IsRelationTypeBtn(btnType) then -- 关系类型
                name = SL:GetValue("RELATION_TYPE_FUNC_DESC", btnType - 1000)
            else
                name = FuncDock.BtnTypeShowName[btnType] or ""
            end
            local nameText = GUI:getChildByName(cell, "Text_name")
            GUI:Text_setString(nameText, name)
            GUI:Text_setFontSize(nameText, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
            maxWidth = math.max(maxWidth, GUI:getContentSize(nameText).width)
            if cellHei == 0 then
                cellHei = GUI:getContentSize(cell).height
            end
            GUI:ListView_pushBackCustomItem(FuncDock._listView, cell)
            GUI:addOnClickEvent(cell, function()
                GUI:delayTouchEnabled(cell)
                FuncDock.DoFunction(btnType)
                UIOperator:CloseFuncDockTips()
            end)
        end
    end

    if count == 0 then
        UIOperator:CloseFuncDockTips()
        return
    end

    local mainHeight = SL:GetValue("SCREEN_HEIGHT")
    local margin = GUI:ListView_getItemsMargin(FuncDock._listView)
    local size = {}
    local btnHei = cellHei + margin

    size.width = math.max(GUI:getContentSize(FuncDock._listView).width, maxWidth + 8)
    size.height = btnHei * count - margin

    if showType == 1 then
        GUI:setContentSize(FuncDock._listView, size)
        local posY = GUI:getPositionY(FuncDock._listView)
        local height = size.height + posY * 2

        -- 按钮超过屏幕 改变锚点
        local topH = pos.y + (1 - anchorPoint.y) * height
        local bottomH = pos.y - anchorPoint.y * height
        if topH > mainHeight then
            -- 超过屏幕顶部
            pos.y = mainHeight - (1 - anchorPoint.y) * height
        elseif bottomH < 0 then
            pos.y = anchorPoint.y * height
        end

        GUI:setContentSize(FuncDock._ui.Image_bg, size.width, height)
        GUI:setAnchorPoint(FuncDock._ui.Image_bg, anchorPoint.x, anchorPoint.y)
        pos.x = pos.x - 5
        pos.y = pos.y - 10
        GUI:setPosition(FuncDock._ui.Image_bg, pos.x, pos.y)
    elseif showType == 2 then
        GUI:setContentSize(FuncDock._listView, size)
        GUI:setAnchorPoint(FuncDock._listView, anchorPoint.x, anchorPoint.y)
        GUI:setPosition(FuncDock._ui.Image_bg, pos.x, pos.y)
    end
end

function FuncDock.CreateFuncDockCell(index)
    local parent = GUI:Widget_Create(-1, "widget" .. index, 0, 0)
    GUI:LoadExport(parent, "common_tips/func_dock_cell")
    
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(cell)
    return cell
end

function FuncDock.DoFunction(btnType)
    if FuncDockData._typeFunction and FuncDockData._typeFunction[btnType] then
        FuncDockData._typeFunction[btnType](FuncDock._targetId, FuncDock._targetName)
    elseif FuncDockData.IsRelationTypeBtn(btnType) then
        local relationType = btnType - 1000
        SL:RequestRelationInviteJoin(relationType, FuncDock._targetId, FuncDock._targetName)
    end
end

FuncDock.main()