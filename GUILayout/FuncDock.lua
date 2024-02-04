FuncDock = {}

local BtnOptType = {
    look_role       = 1,    -- 查看玩家
    add_friend      = 2,    -- 添加好友
    chat            = 3,    -- 私聊
    trade           = 4,    -- 交易(面对面)
    invite_team     = 5,    -- 邀请入队
    invite_guild    = 6,    -- 邀请入会
    apply_team      = 7,    -- 申请入队
    kick_team       = 8,    -- 踢出队伍
    set_teamLeader  = 9,    -- 升为队长
    add_blacklist   = 10,   -- 拉黑
    kick_guild      = 11,   -- 踢出行会
    call_team       = 12,   -- 召集队员
    send_position   = 13,   -- 发送位置
    exit_team       = 14,   -- 退出队伍

    kick_blacklist  = 21,   -- 踢出黑名单
    del_friend      = 22,   -- 删除好友
    del_enemy       = 23,   -- 删除仇敌

    appoint_rank1   = 101,  -- 转移会长
    appoint_rank2   = 102,  -- 任命副会
    appoint_rank3   = 103,  -- 行会 任命职位
    appoint_rank4   = 104,  -- 行会 任命职位
    appoint_rank5   = 105,  -- 行会 任命职位
}

local BtnOptCfg = {
    [BtnOptType.look_role]       = { name = "查看角色", callback = function (uid)
            if not SL:IsCanLookRoleEquip() then
                return false
            end
            SL:CheckPlayerEquipInfo(uid)
        end },
    [BtnOptType.add_friend]      = { name = "添加好友", callback = function (uid, name) SL:AddFriend(name) end },
    [BtnOptType.chat]            = { name = "私聊",     callback = function (uid, name) SL:PrivateChat(uid, name) end },
    [BtnOptType.trade]           = { name = "交易",     callback = function (uid, name) SL:RequestTrade(uid, name) end },
    [BtnOptType.invite_team]     = { name = "邀请入队", callback = function (uid) SL:RequestInviteTeam(uid) end },
    [BtnOptType.invite_guild]    = { name = "邀请入会", callback = function (uid) SL:RequestInviteGuild(uid) end },
    [BtnOptType.apply_team]      = { name = "申请入队", callback = function (uid) SL:RequestApllyTeam(uid) end },
    [BtnOptType.kick_team]       = { name = "踢出队伍", callback = function (uid) SL:RequestKickTeam(uid) end },
    [BtnOptType.set_teamLeader]  = { name = "升为队长", callback = function (uid) SL:RequestSetTeamLeader(uid) end },
    [BtnOptType.add_blacklist]   = { name = "拉黑",     callback = function (uid, name) SL:RequestAddBlackList(uid, name) end },
    [BtnOptType.kick_guild]      = { name = "踢出行会", callback = function (uid) SL:RequestKickGuild(uid) end },
    [BtnOptType.call_team]       = { name = "召集队员", callback = function () GUIShare.CallTeamFunc() end },
    [BtnOptType.send_position]   = { name = "发送位置", callback = function () SL:SendPosMsgToChat() end },
    [BtnOptType.exit_team]       = { name = "退出队伍", callback = function () SL:LeaveTeam() end },
    [BtnOptType.kick_blacklist]  = { name = "踢出黑名单", callback = function (uid, name) SL:RequestKickBlackList(uid, name) end },
    [BtnOptType.del_friend]      = { name = "删除好友", callback = function (uid, name)
            local callback = function (type)
                if 1 == type then
                    SL:DelFriend(name)
                end
            end
            SL:OpenCommonTipsPop({
                str = string.format("是否将玩家<font color='#FF0000'>%s</font>从好友列表中删除?", name), 
                callback = callback,
                btnType = 2
            })
        end },
    [BtnOptType.del_enemy]       = { name = "删除仇敌", callback = function (uid, name) SL:RequistDelEnemy(uid, name) end },
    [BtnOptType.appoint_rank1]   = { name = "转移会长", callback = function (uid, name)
            local info = SL:GetGuildMemberByUID(uid)
            if not info then
                return false
            end

            if info.Online ~= 1 then
                return ShowSystemTips("对方不在线")
            end

            local rank = SL:GetMetaValue("GUILD_RANKS").chairman

            local callback = function (type)
                if 1 == type then
                    SL:RequestAppointRank(uid, rank)
                end
            end

            SL:OpenCommonTipsPop({
                str = string.format("是否转移%s给%s?", SL:GetMetaValue("GUILD_OFFICIAL", rank), info.Name), 
                callback = callback,
                btnType = 2
            })
        end },
    [BtnOptType.appoint_rank2]   = { name = "任命副会长", callback = function (uid, name) SL:RequestAppointRank(uid, SL:GetMetaValue("GUILD_RANKS").viceChairman) end },
    [BtnOptType.appoint_rank3]   = { name = "任命精英", callback = function (uid, name) SL:RequestAppointRank(uid, SL:GetMetaValue("GUILD_RANKS").elite) end },
    [BtnOptType.appoint_rank4]   = { name = "任命成员", callback = function (uid, name) SL:RequestAppointRank(uid, SL:GetMetaValue("GUILD_RANKS").member) end },
    [BtnOptType.appoint_rank5]   = { name = "任命成员", callback = function (uid, name) SL:RequestAppointRank(uid, SL:GetMetaValue("GUILD_RANKS").rank5) end },
}

local FuncType = SL:EnumDockType()
local FuncConfig = {
    -- 点击玩家头像
    [FuncType.Func_Player_Head]         = { BtnOptType.look_role, BtnOptType.chat, BtnOptType.invite_team, BtnOptType.apply_team, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_guild, BtnOptType.add_blacklist, BtnOptType.kick_blacklist },
    -- 好友界面
    [FuncType.Func_Friend]              = { BtnOptType.look_role, BtnOptType.chat, BtnOptType.del_friend, BtnOptType.trade, BtnOptType.invite_team, BtnOptType.invite_guild, BtnOptType.add_blacklist },
    -- 左侧组队导航栏
    [FuncType.Func_Team]                = { BtnOptType.look_role, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_guild, BtnOptType.chat, BtnOptType.set_teamLeader, BtnOptType.kick_team, BtnOptType.send_position, BtnOptType.exit_team, BtnOptType.call_team },
    -- 行会界面
    [FuncType.Func_Guild]               = { BtnOptType.look_role, BtnOptType.add_friend, BtnOptType.chat, BtnOptType.invite_team, BtnOptType.appoint_rank1, BtnOptType.appoint_rank2, BtnOptType.appoint_rank4, BtnOptType.appoint_rank3, BtnOptType.appoint_rank5, BtnOptType.kick_guild},
    -- 好友最近联系界面
    [FuncType.Func_Friend_Recent]       = { BtnOptType.look_role, BtnOptType.chat, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_team, BtnOptType.invite_guild, BtnOptType.add_blacklist },
    -- 好友仇敌界面
    [FuncType.Func_Friend_Enemy]        = { BtnOptType.look_role, BtnOptType.chat, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_team, BtnOptType.invite_guild, BtnOptType.add_blacklist, BtnOptType.del_enemy }   ,
    -- 好友黑名单界面
    [FuncType.Func_Friend_BlackList]    = { BtnOptType.look_role, BtnOptType.kick_blacklist },
    -- 组队界面
    [FuncType.Func_TeamLayer]           = { BtnOptType.look_role, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_guild, BtnOptType.chat, BtnOptType.kick_team, BtnOptType.send_position, BtnOptType.exit_team },
    -- 点击人形怪头像
    [FuncType.Func_Monster_Head]        = { BtnOptType.look_role },
    -- 附近玩家
    [FuncType.Func_Near_Player]         = { BtnOptType.look_role, BtnOptType.chat, BtnOptType.invite_team, BtnOptType.apply_team, BtnOptType.add_friend, BtnOptType.trade, BtnOptType.invite_guild, BtnOptType.add_blacklist, BtnOptType.kick_blacklist },
}

function FuncDock.main(params)
    if not (params and next(params)) then
        return main.onClose()
    end

    local fType = params.type
    if fType < FuncType.Func_Player_Head or fType > FuncType.Func_Near_Player then
        return self:onClose()
    end

    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "dialog/func_dock")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    GUI:setContentSize(ui["TouchPanel"], screenW, screenH)


    -- 初始化数据
    local showData = {}
    for _,index in ipairs(FuncConfig[fType] or {}) do
        if index and FuncDock.filterData(fType, index, params) then
            showData[#showData+1] = index
        end
    end

    if #showData < 1 then
        return FuncDock.onClose()
    end

    -- 注册关闭事件
    GUI:addOnClickEvent(ui["TouchPanel"], function ()
        FuncDock.onClose()
    end)

    FuncDock:initUI(ui, showData, params)
end

function FuncDock:initUI(ui, showData, params)
    local pos = params.pos or {x = 0, y = 0}
    local anr = params.anr or {x = 0, y = 1}

    -- 关闭FuncDock之后要调用的回调
    local exitCallBack = params.exitCallBack

    -- 1:操作其他玩家显示的列表 2:道具tips用到的按钮
    local showType = params.showType or 1
    GUI:setVisible(ui["BgImg"], showType==1)

    -- 点击FuncDock的触摸层之后，是否关闭FuncDock
    local notClick = params.notClick
    if notClick then
        GUI:setTouchEnabled(ui["TouchPanel"], false)
    end

    local list = ui["ListView"]
    GUI:ListView_removeAllItems(list)

    local maxWidth = 0

    for i,index in ipairs(showData) do
        local cell = GUI:Clone(ui["Cell"])
        GUI:setVisible(cell, true)
        GUI:ListView_pushBackCustomItem(list, cell)

        local cfg = BtnOptCfg[index]
        if cfg then
            local ui_name = GUI:getChildByName(cell, "Name")
            GUI:Text_setString(ui_name, cfg.name)

            local nWidth = GUI:getContentSize(ui_name).width
            if nWidth > maxWidth then
                maxWidth = nWidth
            end

            GUI:addOnClickEvent(cell, function ()
                if cfg.callback then
                    cfg.callback(params.targetId, params.targetName)
                    FuncDock.onClose()
                end
            end)
        end
    end

    local visibleSize = SL:GetScreenSize()
    local maxHeight = visibleSize.height
    local margin    = GUI:ListView_getItemsMargin(list)
    local btnHeight = GUI:getContentSize(ui["Cell"]).height + margin

    local size = {
        width  = math.max(GUI:getContentSize(list).width, maxWidth + 8),
        height = btnHeight * #showData - margin
    }

    GUI:setContentSize(list, size)

    if showType == 1 then
        local height = size.height + GUI:getPositionY(list) * 2

        --按钮超过屏幕 改变锚点
        local topH = pos.y + (1 - anr.y) * height
        local bottomH = pos.y - anr.y * height
        if topH > maxHeight then
            --超过屏幕顶部
            pos.y = maxHeight - (1 - anr.y) * height
        elseif bottomH < 0 then
            pos.y = anr.y * height
        end

        GUI:setContentSize(ui["BgImg"], size.width, height)
        GUI:setContentSize(ui["TouchPanel"], visibleSize)
        GUI:setAnchorPoint(ui["BgImg"], anr)
        GUI:setPosition(ui["BgImg"], pos.x - 5, pos.y - 10)
    elseif showType == 2 then
        GUI:setAnchorPoint(list, anr)
        GUI:setPosition(ui["BgImg"], pos)
    end
end


function FuncDock.filterData(fType, index, params)
    local uid = params.targetId
    -- 英雄，只有查看
    local actor = SL:GetActorByID(uid)
    if actor and SL:IsHero(actor) and BtnOptType.look_role ~= index then
        return false
    end
    
    local show = true
    if fType == FuncType.Func_Team or fType == FuncType.Func_TeamLayer then
        -- 组队
        show = BtnOptType.call_team == index or BtnOptType.send_position == index or BtnOptType.exit_team == index
        if SL:GetMetaValue("USERID") ~= uid then
            if show then
                show = false
            elseif BtnOptType.set_teamLeader == index or BtnOptType.kick_team == index then
                show = SL:GetMetaValue("TEAM_ISLEADER")
            end
        end
    elseif fType == FuncType.Func_Guild then
        -- 是否是会长
        local isMaster   = SL:GetMetaValue("IS_MASTER")
        -- 是否是副会长
        local isChairman = SL:GetMetaValue("IS_CHAIRMAN")

        local info = SL:GetGuildMemberByUID(uid)
        local rank = info.Rank
        if BtnOptType.appoint_rank1 == index or BtnOptType.appoint_rank2 == index or BtnOptType.appoint_rank3 == index or BtnOptType.appoint_rank4 == index or BtnOptType.appoint_rank5 == index then
            show = false
            if isChairman and info and info.Rank then
                if isMaster then
                    show = true
                else
                    if BtnOptType.appoint_rank3 == index then
                        show = rank ~= SL:GetMetaValue("GUILD_RANKS").elite and not SL:GetMetaValue("IS_CHAIRMAN", rank)
                    elseif BtnOptType.appoint_rank4 == index then
                        show = rank ~= SL:GetMetaValue("GUILD_RANKS").member and not SL:GetMetaValue("IS_CHAIRMAN", rank)
                    elseif BtnOptType.appoint_rank5 == index then
                        show = rank ~= SL:GetMetaValue("GUILD_RANKS").rank5 and not SL:GetMetaValue("IS_CHAIRMAN", rank)
                    elseif BtnOptType.appoint_rank2 == index then
                        show = false
                    end
                end
            end
        end
        if BtnOptType.kick_guild == index then
            show = isMaster or (isChairman and not SL:GetMetaValue("IS_CHAIRMAN", rank))
        elseif BtnOptType.invite_team == index then
            show = info.Online == 1
        end
    elseif fType == FuncType.Func_Player_Head then
        if SL:GetMetaValue("IS_IN_BLACLIST", uid) then
            -- 黑名单中
            show = BtnOptType.look_role == index or false
        else 
            local basic = params.basic
            if basic then
                if BtnOptType.invite_team == index then
                    if basic.group == 1 then
                        show = false
                    end
                elseif BtnOptType.apply_team == index then
                    if (basic.group == 0) or SL:GetTeamMemberCount() > 0 then
                        show = false
                    end
                elseif BtnOptType.invite_guild == index then
                    if (basic.guild) or not SL:GetMetaValue("IS_IN_GUILD") then
                        show = false
                    end
                end
            end
        end
    end

    if index == BtnOptType.add_friend then
        show = not SL:HasFriends(params.targetName) and SL:GetMetaValue("USERID") ~= uid
    elseif index == BtnOptType.add_blacklist then
        --拉黑
        show = not SL:GetMetaValue("IS_IN_BLACLIST", uid)
    elseif index == BtnOptType.kick_blacklist then
        --移除黑名单
        show = SL:GetMetaValue("IS_IN_BLACLIST", uid)
    elseif BtnOptType.invite_team == index then
        if SL:GetMetaValue("IS_TEAM_MEMBER", uid) then
            show = false
        end
    elseif BtnOptType.trade == index then
        local isTrade = SL:GetMetaValue("GAME_DATA", "CloseTradeFunc")
        if isTrade == 1 then
            show = false
        end
    end

    return show
end

function FuncDock.onClose()
    SL:CloseFuncDockTips()
end