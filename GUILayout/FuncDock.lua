FuncDock = {}

-- 功能菜单类型
FuncDock.FuncDockType = {
    Func_Player_Head        = 1,    -- 点击玩家头像
    Func_Friend             = 2,    -- 好友界面
    Func_Team               = 3,    -- 左侧组队导航栏
    Func_Guild              = 4,    -- 行会界面
    Func_Friend_Recent      = 5,    -- 好友最近联系界面
    Func_Friend_Enemy       = 6,    -- 好友仇敌界面
    Func_Friend_BlackList   = 7,    -- 好友黑名单界面
    Func_TeamLayer          = 8,    -- 组队界面
    Func_Monster_Head       = 9,    -- 点击人形怪头像
    Func_Near_Player        = 10,   -- 附近玩家
}

-- 按钮操作类型
FuncDock.BtnOperatorType = {
    look_role       = 1,    -- 查看玩家
    add_friend      = 2,    -- 添加好友
    chat            = 3,    -- 私聊
    team            = 4,    -- 组队
    trade           = 5,    -- 交易
    invite_team     = 6,    -- 邀请入队
    invite_guild    = 7,    -- 邀请入会
    apply_team      = 8,    -- 申请入队
    out_team        = 10,   -- 踢出队伍
    set_teamLeader  = 11,   -- 升为队长
    add_blacklist   = 12,   -- 拉黑
    out_guild       = 13,   -- 踢出行会
    call_teammate   = 14,   -- 召集队员
    send_position   = 15,   -- 发送位置
    exit_team       = 16,   -- 退出队伍

    out_blacklist   = 21,   -- 移出黑名单
    delete_friend   = 22,   -- 删除好友

    challenge       = 24,   -- 挑战
    horse_invite    = 25,   -- 骑马邀请

    appoint_rank1   = 101,  -- 转移会长
    appoint_rank2   = 102,  -- 任命副会
    appoint_rank3   = 103,  -- 行会 任命职位
    appoint_rank4   = 104,  -- 行会 任命职位
    appoint_rank5   = 105,  -- 行会 任命职位
}

local FuncType = FuncDock.FuncDockType
local BtnType = FuncDock.BtnOperatorType

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

-- 不同类型功能菜单对应按钮组
FuncDock.FuncConfig = {
    [FuncType.Func_Player_Head] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.apply_team,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.out_blacklist,
        BtnType.horse_invite
    },
    [FuncType.Func_Team] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.chat,
        BtnType.set_teamLeader,
        BtnType.out_team,
        BtnType.send_position,
        BtnType.exit_team,
        BtnType.call_teammate
    },
    [FuncType.Func_TeamLayer] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.chat,
        BtnType.out_team,
        BtnType.send_position,
        BtnType.exit_team
    },
    [FuncType.Func_Guild] = {
        BtnType.look_role,
        BtnType.add_friend,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.appoint_rank1,
        BtnType.appoint_rank2,
        BtnType.appoint_rank4,
        BtnType.appoint_rank3,
        BtnType.appoint_rank5,
        BtnType.out_guild
    },
    [FuncType.Func_Friend] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.delete_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist
    },
    [FuncType.Func_Friend_Recent] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist
    },
    [FuncType.Func_Friend_Enemy] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_team,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.delete_enemy
    },
    [FuncType.Func_Friend_BlackList] = {BtnType.look_role, BtnType.out_blacklist},
    [FuncType.Func_Monster_Head] = {BtnType.look_role},
    [FuncType.Func_Near_Player] = {
        BtnType.look_role,
        BtnType.chat,
        BtnType.invite_team,
        BtnType.apply_team,
        BtnType.add_friend,
        BtnType.trade,
        BtnType.invite_guild,
        BtnType.add_blacklist,
        BtnType.out_blacklist,
        BtnType.challenge
    }
}

function FuncDock.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "common_tips/func_dock")

    FuncDock._targetName = ""
    FuncDock._targetId = -1

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    FuncDock._ui = GUI:ui_delegate(parent)
    GUI:setContentSize(FuncDock._ui.Panel_1, screenW, screenH)

    FuncDock._ui.Panel_1:addClickEventListener(function()
        SL:CloseFuncDockTips()
    end)

    FuncDock._listView = FuncDock._ui.ListView

    FuncDock.SetLayerType(data)
end

--notClick: 点击FuncDock的触摸层之后，是否关闭FuncDock
--exitCallBack: 关闭FuncDock之后要调用的回调
function FuncDock.SetLayerType(data)
    local dockType = data.type
    local pos = data.pos or {x = 0, y = 0}
    local targetId = data.targetId
    local targetName = data.targetName
    local notClick = data.notClick
    local exitCallBack = data.exitCallBack
    local anchorPoint = data.anchorPoint or {x = 0, y = 1}
    local showType = data.showType or 1 --1:操作其他玩家显示的列表 2:道具tips用到的按钮
    local playerBasic = data.basic

    if targetId == nil then
        targetId = -1
        data.targetId = -1
    end
    FuncDock._targetId = targetId
    FuncDock._targetName = targetName

    SL:SetMetaValue("FUNCDOCK_PARAM", data)

    if notClick then
        GUI:setTouchEnabled(FuncDock._ui.Panel_1, false)
    end
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:setMouseEnabled(FuncDock._ui.Panel_1, true)
    end

    GUI:setVisible(FuncDock._ui.Image_bg, showType == 1)
    GUI:ListView_removeAllItems(FuncDock._listView)

    local btnList = FuncDock.FuncConfig[dockType] or {}

    local count = 0
    local maxWidth = 0
    local cellHei = 0
    for i = 1, #btnList do
        local btnType = btnList[i]
        if btnType and SL:GetMetaValue("CHECK_FUNCBTN_SHOW", dockType, btnType) then
            count = count + 1
            local cell = FuncDock.CreateFuncDockCell(i)
            local name = ""
            if btnType >= BtnType.appoint_rank1 and btnType <= BtnType.appoint_rank5 then
                name = string.format("任命%s", SL:GetMetaValue("GUILD_OFFICIAL", btnType - 100))
            else
                name = FuncDock.BtnTypeShowName[btnType] or ""
            end
            local nameText = GUI:getChildByName(cell, "Text_name")
            GUI:Text_setString(nameText, name)
            GUI:Text_setFontSize(nameText, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"))
            maxWidth = math.max(maxWidth, GUI:getContentSize(nameText).width)
            if cellHei == 0 then
                cellHei = GUI:getContentSize(cell).height
            end
            GUI:ListView_pushBackCustomItem(FuncDock._listView, cell)
            GUI:addOnClickEvent(cell, function()
                FuncDock.DoFunction(btnType)
                SL:CloseFuncDockTips()
            end)
        end
    end

    if count == 0 then
        SL:CloseFuncDockTips()
        return
    end

    local mainHeight = SL:GetMetaValue("SCREEN_HEIGHT")
    local margin = GUI:ListView_getItemsMargin(FuncDock._listView)
    local size = {}
    local btnHei = cellHei + margin

    size.width = math.max(GUI:getContentSize(FuncDock._listView).width, maxWidth + 8)
    size.height = btnHei * count - margin

    if showType == 1 then
        GUI:setContentSize(FuncDock._listView, size)
        local posY = GUI:getPositionY(FuncDock._listView)
        local height = size.height + posY * 2

        --按钮超过屏幕 改变锚点
        local topH = pos.y + (1 - anchorPoint.y) * height
        local bottomH = pos.y - anchorPoint.y * height
        if topH > mainHeight then
            --超过屏幕顶部
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
    local parent = GUI:Widget_Create(FuncDock._ui.Image_bg, "widget" .. index, 0, 0)
    GUI:LoadExport(parent, "common_tips/func_dock_cell")
    
    local cell = GUI:getChildByName(parent, "Panel_cell")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(cell)
    return cell
end

function FuncDock.DoFunction(btnType)
    if not FuncDock._typeFunction or not next(FuncDock._typeFunction) then
        FuncDock._typeFunction = {}
        -----------------组队-----------------
        FuncDock._typeFunction[BtnType.invite_team] = function()
            --邀请入队
            SL:RequestInviteJoinTeam(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.apply_team] = function()
            --申请入队
            SL:RequestApplyJoinTeam(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.out_team] = function()
            --踢出队伍
            SL:RequestSubTeamMember(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.set_teamLeader] = function()
            --升为队长
            SL:RequestTransferTeamLeader(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.call_teammate] = function()
            --召集队员
            SL:RequestCallTeamMember()
        end
        FuncDock._typeFunction[BtnType.send_position] = function()
            --发送坐标
            SL:SendPosMsgToChat(5)
        end
        FuncDock._typeFunction[BtnType.exit_team] = function()
            --退出队伍
            SL:RequestLeaveTeam()
        end

        ---------------行会------------------
        FuncDock._typeFunction[BtnType.invite_guild] = function()
            --邀请入会
            SL:RequestGuildInviteOther(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.out_guild] = function()
            --踢出行会
            SL:RequestSubGuildMember(FuncDock._targetId)
        end
        FuncDock._typeFunction[BtnType.appoint_rank2] = function()
            --任命副会
            SL:RequestAppointGuildRank(FuncDock._targetId, 2)
        end
        FuncDock._typeFunction[BtnType.appoint_rank4] = function()
            --任命会员
            SL:RequestAppointGuildRank(FuncDock._targetId, 4)
        end
        FuncDock._typeFunction[BtnType.appoint_rank3] = function()
            --任命精英
            SL:RequestAppointGuildRank(FuncDock._targetId, 3)
        end
        FuncDock._typeFunction[BtnType.appoint_rank5] = function()
            --任命
            SL:RequestAppointGuildRank(FuncDock._targetId, 5)
        end
        FuncDock._typeFunction[BtnType.appoint_rank1] = function()
            --转移会长
            local info = SL:GetMetaValue("GUILD_MEMBER_INFO", FuncDock._targetId)
            if info and info.Online == 1 then
                local data    = {}
                data.str = string.format("是否转移%s给%s", SL:GetMetaValue("GUILD_OFFICIAL", 1), info.Name)
                data.btnType  = 2
                data.callback = function(type)
                    if 1 == type then
                        SL:RequestAppointGuildRank(FuncDock._targetId, 1)
                    end
                end
                SL:OpenCommonTipsPop(data)

            else
                SL:ShowSystemTips("对方不在线")
            end
        end

        FuncDock._typeFunction[BtnType.look_role] = function()
            --查看
            SL:RequestLookPlayer(FuncDock._targetId)
        end

        FuncDock._typeFunction[BtnType.chat] = function()
            --私聊
            SL:PrivateChatWithTarget(FuncDock._targetId, FuncDock._targetName)
        end

        FuncDock._typeFunction[BtnType.trade] = function()
            --交易
            SL:RequestTrade(FuncDock._targetId)
        end

        FuncDock._typeFunction[BtnType.add_friend] = function()
            --添加好友
            SL:RequestAddFriend(FuncDock._targetName)
        end

        FuncDock._typeFunction[BtnType.out_blacklist] = function()
            --移出黑名单
            SL:RequestOutBlacklist(FuncDock._targetId)
        end

        FuncDock._typeFunction[BtnType.delete_friend] = function()
            --删除好友
            local data    = {}
            data.btnType  = 2
            data.str      = string.format("是否将玩家<font color='#FF0000'>%s</font>从好友列表中删除?", FuncDock._targetName)
            data.callback = function(type)
                if 1 == type then
                    SL:RequestDelFriend(FuncDock._targetId)
                end
            end
            SL:OpenCommonTipsPop(data)
        end

        FuncDock._typeFunction[BtnType.add_blacklist] = function()
            --拉黑
            SL:RequestAddBlacklistByName(FuncDock._targetName)
        end
        
        FuncDock._typeFunction[BtnType.horse_invite] = function()
            --邀请上马
            SL:RequestInviteInHorse(FuncDock._targetId)
        end
    end

    if FuncDock._typeFunction and FuncDock._typeFunction[btnType] then
        FuncDock._typeFunction[btnType]()
    end
end
