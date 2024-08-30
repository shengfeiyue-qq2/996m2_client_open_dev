SL:Print("Hello World, This is GUIInit!!!")
local sformat = string.format

-----------------------------------------------------------------------------
-- 加载GUIUtil.lua
SL:Require("GUILayout/GUIUtil", true)

-----------------------------------------------------------------------------
-- 主界面UI
local MainUIFiles = SL:GetValue("IS_PC_OPER_MODE") and {
    UIConst.LUAFile.LUA_FILE_PC_SKILL_TO_MAINUI,            -- PC图标移到主界面
    UIConst.LUAFile.LUA_FILE_MAIN_ASSIST_WIN32,             -- PC任务栏
    UIConst.LUAFile.LUA_FILE_MAIN_MINIMAP_WIN32,            -- PC小地图
    UIConst.LUAFile.LUA_FILE_MAIN_PROPERTY_WIN32            -- 主界面

} or {
    UIConst.LUAFile.LUA_FILE_MAIN_ASSIST,                   -- 任务栏
    UIConst.LUAFile.LUA_FILE_MAIN_SKILL,                    -- 技能
    UIConst.LUAFile.LUA_FILE_MAIN_MINIMAP,                  -- 小地图
    UIConst.LUAFile.LUA_FILE_MAIN_JOYSTICK,                 -- 摇杆
    UIConst.LUAFile.LUA_FILE_MAIN_TOP,                      -- 主界面最上面
    UIConst.LUAFile.LUA_FILE_MAIN_DIG,                      -- 挖肉
    UIConst.LUAFile.LUA_FILE_MAIN_SUMMONS,                  -- 召唤物
    UIConst.LUAFile.LUA_FILE_MAIN_COLLECT,                  -- 采集物
    UIConst.LUAFile.LUA_FILE_MAIN_PROPERTY                  -- 主界面
}
SL:RegisterLUAEvent(LUA_EVENT_ENTER_WORLD, "GUIInit", function()
    for i = 1, #MainUIFiles do
        SL:RequireFile(MainUIFiles[i])
    end
    -- 目标
    SL:RequireFile(UIConst.LUAFile.LUA_FILE_MAIN_TARGET)
    -- Buff
    SL:RequireFile(UIConst.LUAFile.LUA_FILE_MAIN_BUFFLIST)
    -- 大血条
    SL:RequireFile(UIConst.LUAFile.LUA_FILE_MAIN_TARGET_BIGHP)
end)


-----------------------------------------------------------------------------
-- 玩家属性初始化完成
SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_INITED, "GUIInit", function ()
    UIOperator:OpenHeroStateUI()
end)


-----------------------------------------------------------------------------
-- 飘血事件，滴血屏幕变红
-- 加载监听
SL:Require("GUILayout/HurtTips", true)
--辅助机器：自动喝药、练功、释放、修复神水、保护等相关
SL:Require("GUILayout/couping/RobotAuto", true)
SL:Require("GUILayout/couping/RobotHeroAuto", true)
-- pc端施法范围框
SL:Require("GUILayout/PCSpellScope", true)
--烟花特效
SL:Require("GUILayout/firework_hall/FireWorkHall", true)

-----------------------------------------------------------------------------
-------社交------------
--监听新邮件提醒
SL:RegisterLUAEvent(LUA_EVENT_MAIL_NEW_NOTICE, "GUIInit", function(data)
    SL:AddBubbleTips(GUIDefine.BubbleType.MAIL, "res/private/main/bubble_tips/1900012564_1.png", function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Mail)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Mail)
        end
    end)
end)

-----------------------------------------------------------------------------
-- 组队
-- 移除队伍相关特效
SL:RegisterLUAEvent(LUA_EVENT_TEAM_MEMBER_UPDATE, "GUIInit", function()
    local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
    if memberCount == 0 then 
        SL:RmEffectOnScreen(3) --移除队伍相关特效
    end
end)
-- 队伍创建成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_CREATE, "GUIInit", function(data)
    SL:ShowSystemTips("创建队伍成功")
end)
-- 拒绝组队申请
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_REFUSE_APPLY, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s拒绝了你的组队申请", name))
end)
-- 离开队伍
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_LEAVE, "GUIInit", function(data)
    SL:ShowSystemTips("您已离开队伍")
end)
-- 踢出队伍
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_OUT, "GUIInit", function(data)
    SL:ShowSystemTips("您被踢出队伍")
end)
-- 解散队伍
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_DISMISS, "GUIInit", function(data)
    SL:ShowSystemTips("队伍被解散了")
end)
-- 其他人离开队伍
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_OTHER_LEAVE, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s离开了队伍", name))
end)
-- 队伍创建成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_REFUSE_INVITE, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s拒绝了你的组队邀请", name))
end)
-- 组队相关操作异常
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_TEAM_ERROR, "GUIInit", function(type)
    if type == -1 then
        SL:ShowSystemTips("对方已经拥有队伍")
    elseif type == -2 then
        SL:ShowSystemTips("你还没有队伍")
    elseif type == -3 then
        SL:ShowSystemTips("邀请信息可能已经过期")
    elseif type == -4 then
        SL:ShowSystemTips("申请信息可能已经过期")
    elseif type == -5 then
        SL:ShowSystemTips("对方没有队伍或已经解散")
    elseif type == -6 then
        SL:ShowSystemTips("你已经拥有队伍了")
    elseif type == -7 then
        SL:ShowSystemTips("只能队长操作")
    elseif type == -8 then
        SL:ShowSystemTips("对方未在队伍内")
    elseif type == -9 then
        SL:ShowSystemTips("对方拒绝组队")
    end
end)
-- 队伍申请 气泡提醒
SL:RegisterLUAEvent(LUA_EVENT_TEAM_APPLY_UPDATE, "GUIInit", function()
    if #SL:GetValue("TEAM_APPLY") > 0 then
        SL:AddBubbleTips(GUIDefine.BubbleType.TEAM_APPLY, "res/private/main/bubble_tips/1900012601_1.png", function()
            local applyLayer = GUI:GetWindow(nil, UIConst.LAYERID.TeamApplyGUI)
            if not applyLayer then 
                UIOperator:OpenTeamApply()
            end
        end)
    else
        SL:DelBubbleTips(GUIDefine.BubbleType.TEAM_APPLY)
    end
end)
-- 队伍邀请 气泡提醒
SL:RegisterLUAEvent(LUA_EVENT_TEAM_BEINVITED_UPDATE, "GUIInit", function()
    local inviteCount = SL:GetValue("TEAM_INVITE_COUNT")
    local status = inviteCount > 0
    if status then 
        SL:AddBubbleTips(GUIDefine.BubbleType.TEAM_INVITE, "res/private/main/bubble_tips/1900012601_1.png", function()
            local inviteCount = SL:GetValue("TEAM_INVITE_COUNT")
            local inviteData = SL:GetValue("TEAM_INVITE_DATA") 
            if inviteCount == 1 then 
                for k,v in pairs(inviteData) do
                    UIOperator:OpenTeamBeInvite(v)
                    break
                end
            elseif inviteCount > 1 then 
                local tipsData = {}
                tipsData.list = {}
                for _, v in pairs(inviteData) do
                    local data = {}
                    data.str = sformat("%s邀请您加入队伍", v.UserName)
                    data.agreeCall = function()
                        SL:RequestTeamInviteAgree(v.UserID)
                    end
                    data.disAgreeCall = function()
                        SL:RequestTeamInviteRefuse(v.UserID)
                    end
                    table.insert(tipsData.list, data)
                end

                if MainProperty and MainProperty.GetBubbleButtonByID then
                    local node = MainProperty.GetBubbleButtonByID(GUIDefine.BubbleType.TEAM_INVITE)
                    if node and not GUI:Widget_IsNull(node) then
                        tipsData.pos = GUI:getWorldPosition(node)
                    end
                end
                UIOperator:OpenCommonBubbleInfoUI(tipsData)
            end
        end)
    else 
        SL:DelBubbleTips(GUIDefine.BubbleType.TEAM_INVITE)
    end
end)


-----------------------------------------------------------------------------
-- 好友
-- 好友相关操作异常
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_ERROR, "GUIInit", function(type)
    if type == -1 then
        SL:ShowSystemTips("申请好友中..")
    elseif type == -2 then
        SL:ShowSystemTips("对方在你黑名单内")
    elseif type == -3 then
        SL:ShowSystemTips("你们已经是好友")
    elseif type == -4 then
        SL:ShowSystemTips("对方不在线")
    elseif type == -5 then
        SL:ShowSystemTips("对方在你好友列表中")
    elseif type == -6 then
        SL:ShowSystemTips("对方不在线或不存在")
    elseif type == -7 then
        SL:ShowSystemTips("加好友失败")
    elseif type == -8 then
        SL:ShowSystemTips("对方不允许增加好友")
    else
        SL:Print("==================UnDefined Friend Error Type" .. type)
        return
    end
end)
-- 好友申请成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_APPLY_SUCCESS, "GUIInit", function()
    SL:ShowSystemTips("好友申请已发送")
    UIOperator:CloseAddFriendUI()
end)
-- 好友增加成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_ADD_SUCCESS, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s成为了你的好友", name))
end)
-- 好友删除成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_DEL_SUCCESS, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s已从你的好友中移除", name))
end)
-- 删除黑名单成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_DEL_BLACKLIST_SUCCESS, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s已从你的黑名单中移除", name))
end)
-- 添加黑名单成功
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_ADD_BLACKLIST_SUCCESS, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s加入了你的黑名单", name))
end)
-- 拒绝好友申请
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_FRIEND_REFUSE_APPLY, "GUIInit", function(name)
    SL:ShowSystemTips(sformat("%s拒绝了你的好友申请", name))
end)
-- 好友申请 气泡提醒
SL:RegisterLUAEvent(LUA_EVENT_FRIEND_APPLY, "GUIInit", function()
    local applyItems = SL:GetValue("FRIEND_APPLYLIST")
    local status =  table.nums(applyItems) > 0
    if status then 
        SL:AddBubbleTips(GUIDefine.BubbleType.FRIEND_APPLY, "res/private/main/bubble_tips/1900012603_1.png", function ()
            local applyLayer = GUI:GetWindow(nil, UIConst.LAYERID.FriendApplyGUI)
            if not applyLayer then 
                UIOperator:OpenFriendApplyUI()
            end
        end)
    else
        SL:DelBubbleTips(GUIDefine.BubbleType.FRIEND_APPLY) 
    end
end)


-----------------------------------------------------------------------------
-- 行会
-- 行会相关操作异常
SL:RegisterLUAEvent(LUA_EVENT_GUILD_OPERATE_ERROR, "GUIInit", function(errorCode)
    if errorCode == -1 then
        SL:ShowSystemTips("名称为空")
        
    elseif errorCode == -2 then
        SL:ShowSystemTips("名字已经存在")
        
    elseif errorCode == -3 then
        SL:ShowSystemTips("没有准备好物品")
        
    elseif errorCode == -4 then
        SL:ShowSystemTips("缺少创建费用")
        
    elseif errorCode == -5 then
        SL:ShowSystemTips("你已经加入或拥有行会")
        
    elseif errorCode == -6 then
        SL:ShowSystemTips("对方已拥有行会")
        
    elseif errorCode == -7 then
        SL:ShowSystemTips("对方拒绝了你的申请")
        
    elseif errorCode == -8 then
        SL:ShowSystemTips("已经申请了")
        
    elseif errorCode == -9 then
        SL:ShowSystemTips("已经联盟")

    elseif errorCode == -10 then
        SL:ShowSystemTips("行会战争中")

    elseif errorCode == -11 then
        SL:ShowSystemTips("对方拒绝联盟")

    elseif errorCode == -12 then
        SL:ShowSystemTips("会长禁止退出行会")

    elseif errorCode == -13 then
        SL:ShowSystemTips("职位数量超过上限")

    elseif errorCode == -14 then
        SL:ShowSystemTips("行会人数超过上限")
    
    elseif errorCode == -15 then
        SL:ShowSystemTips("设置职位错误")
    
    elseif errorCode == -16 then
        SL:ShowSystemTips("只能会长或管理员操作")

    elseif errorCode == -17 then
        SL:ShowSystemTips("货币不足")
    end
end)

-- 行会创建成功
SL:RegisterLUAEvent(LUA_EVENT_GUILD_CREATE_SUCCESS, "GUIInit", function()
    SL:ShowSystemTips("创建行会成功")

    -- 关闭行会创建界面
    UIOperator:CloseGuildCreateUI()
end)

-- 加入行会成功
SL:RegisterLUAEvent(LUA_EVENT_GUILD_JOIN_SUCCESS, "GUIInit", function()
    SL:ShowSystemTips("加入行会成功")
end)

-- 行会删除成员成功
SL:RegisterLUAEvent(LUA_EVENT_GUILD_SUB_MEMBER_SUCCESS, "GUIInit", function(userName)
    SL:ShowSystemTips(userName .. "删除成功")
end)

-- 任命成员职位成功
SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPOINT_RANK_SUCCESS, "GUIInit", function()
    SL:ShowSystemTips("任命成功")
end)

-- 被踢出行会
SL:RegisterLUAEvent(LUA_EVENT_GUILD_KICK_OUT, "GUIInit", function()
    SL:ShowSystemTips("被踢出行会")
    UIOperator:CloseGuildMainUI()
end)

-- 退出行会成功
SL:RegisterLUAEvent(LUA_EVENT_GUILD_QUIT_SUCCESS, "GUIInit", function(userName)
    SL:ShowSystemTips("退出行会成功")
    UIOperator:CloseGuildMainUI()
end)

-- 行会已经解散
SL:RegisterLUAEvent(LUA_EVENT_GUILD_DISSOLVE, "GUIInit", function()
    SL:ShowSystemTips("你所在的行会已经解散")
    UIOperator:CloseGuildMainUI()
end)

-- 行会自动加入状态
SL:RegisterLUAEvent(LUA_EVENT_GUILD_AUTO_JOIN_STATE, "GUIInit", function(state)
    if state then
        SL:ShowSystemTips("同意自动入会")
    else
        SL:ShowSystemTips("取消自动入会")
    end
end)

-- 收到玩家申请加入行会
SL:RegisterLUAEvent(LUA_EVENT_GUILD_MEMBER_APPLY, "GUIInit", function(userName)
    if SL:GetValue("GUILD_IS_ADMIN") then
        -- 主界面气泡
        local function callback()
            UIOperator:OpenGuildApplyListUI()
        end
        SL:AddBubbleTips(GUIDefine.BubbleType.GUILD_APPLY, "res/private/main/bubble_tips/1900012562_1.png", callback)
    end
end)

-- 收到申请联盟消息
SL:RegisterLUAEvent(LUA_EVENT_GUILD_ALLY_APPLY, "GUIInit", function(data)
    if SL:GetValue("GUILD_IS_CHAIRMAN") then
        -- 主界面气泡
        local function callback()
            UIOperator:OpenGuildAllyApplyUI()
        end
        SL:AddBubbleTips(GUIDefine.BubbleType.GUILD_ALLY_APPLY, "res/private/main/bubble_tips/1900012562_1.png", callback)
    end
end)

-- 行会申请入会列表刷新
SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPLYLIST, "GUIInit", function()
    local applyList = SL:GetValue("GUILD_APPLY_LIST")
    if #applyList == 0 then
        SL:DelBubbleTips(GUIDefine.BubbleType.GUILD_APPLY) 
    end
end)

-- 行会联盟申请列表刷新
SL:RegisterLUAEvent(LUA_EVENT_GUILD_APPLY_ALLY_LIST, "GUIInit", function()
    local applyList = SL:GetValue("GUILD_ALLY_APPLY_LIST")
    if #applyList == 0 then
        SL:DelBubbleTips(GUIDefine.BubbleType.GUILD_ALLY_APPLY) 
    end
end)

-- 收到行会邀请加入
SL:RegisterLUAEvent(LUA_EVENT_GUILD_JOIN_INVITE, "GUIInit", function(data)
    local function callback()
        SL:DelBubbleTips(GUIDefine.BubbleType.GUILD_INVITE)
        
        local function tipsCB(bType)
            if bType == 1 then
                SL:RequestGuildRejectUserInvite(data.guildID)
            elseif bType == 2 then
                SL:RequestGuildApproveUserInvite(data.guildID)
            end
        end
        local str = string.format("邀请你加入行会\n 行会名: %s\n 邀请者: %s", data.guildName, data.masterName)
        local data = {}
        data.str = str
        data.btnDesc = {"拒绝", "同意"}
        data.callback = tipsCB
        UIOperator:OpenCommonTipsUI(data)
    end
    SL:AddBubbleTips(GUIDefine.BubbleType.GUILD_INVITE, "res/private/main/bubble_tips/1900012562_1.png", callback)
end)


-----------------------------------------------------------------------------
--变强提醒
SL:RegisterLUAEvent(LUA_EVENT_BESTRONG_BUTTON_REFRESH, "GUIInit", function()
    local beStrongData = SL:GetValue("BESTRONG_DATA")
    if table.nums(beStrongData) > 0 then 
        if not (BeStrongUpInfo and BeStrongUpInfo._layer) then
            SL:Require(UIConst.LUAFile.LUA_FILE_BESTRONG_UP, true)
        else
            SL:onLUAEvent(LUA_EVENT_BESTRONG_LIST_REFRESH)
        end
    else
        if BeStrongUpInfo and BeStrongUpInfo._layer then 
            SL:onLUAEvent(LUA_EVENT_BESTRONG_CLOSE)
        end
    end
end)


-----------------------------------------------------------------------------
-- 竞拍返回 消息号：1112，recog=0，失败：recog=-1，表示已经有人出更高价，=-2表示已经被买走 =-3自己的物品
SL:RegisterLUAEvent(LUA_EVENT_AUCTION_BID_ERRORCODE, "GUIInit", function (data)
    local errorcode = data.errorcode
    if errorcode == 0 then
        SL:ShowSystemTips("竞价成功")
    elseif errorcode == -1 then
        SL:ShowSystemTips("有人出价更高")
    elseif errorcode == -2 then
        SL:ShowSystemTips("物品已被买走")
    elseif errorcode == -3 then
        SL:ShowSystemTips("无法购买自己的物品")
    elseif errorcode == -4 then
        SL:ShowSystemTips("展示时间内无法购买")
    end
end)
-----------------------------------------------------------------------------
-- 请解锁后操作提示
SL:RegisterLUAEvent(LUA_EVENT_TRADE_UNLOCK_OPERATION, "GUIInit", function(state)
    SL:ShowSystemTips("请解锁后再操作")
end)
-- 摆摊中，禁止操作
SL:RegisterLUAEvent(LUA_EVENT_TRADE_STALL_FORBID, "GUIInit", function(state)
    SL:ShowSystemTips("摆摊中，禁止操作")
end)

-- 交易对方金币改变播放音效
SL:RegisterLUAEvent(LUA_EVENT_TRADE_TARGET_MONEY_CHANGE_AUDIO, "GUIInit", function(state)
    SL:PlayMoneyChangeAudio()
end)

-- 交易失败即弹窗
SL:RegisterLUAEvent(LUA_EVENT_TRADE_FAIL_ERROR_TIPS, "GUIInit", function(errorType)
    --[[        
        -1 自己正在交易
        -2 玩家不在线
        -3 对方正在交易
        -4 距离

        -1 //对方离线不能交易
        -2 //对方不满足交易条件
        -3 //自己不满足交易条件
        -4 //玩家在黑名单不能交易
        -5 //自己正在交易­
        -6 //对方正在交易
        -7 //不能和自己交易
        -8 //距离太远不能交易
        -9 //自己在战斗状态不允许交易
        -10 //对方在战斗状态不允许交易
        -11 //自己死亡不能交易
        -12 //对方死亡不能交易
        -13 //对方没有设置允许交易
    ]]
    local errorStr = "交易被取消。\n要正确交易你必须和对方面对面。"
    if errorType == -1 then
        errorStr = "对方不在线！"
    elseif errorType == -2 then
        errorStr = "对方交易条件不满足"
    elseif errorType == -3 then
        errorStr = "交易条件不满足"
    elseif errorType == -4 then
        errorStr = "该玩家在黑名单中"
    elseif errorType == -5 then
        errorStr = "交易失败，你在交易！"
    elseif errorType == -6 then
        errorStr = "交易失败，对方正在交易！"
    elseif errorType == -7 then
        errorStr = "不能和自己交易"
    elseif errorType == -8 then
        errorStr = "交易失败，距离太远！"
    elseif errorType == -9 then
        errorStr = "自己在战斗状态不允许交易"
    elseif errorType == -10 then
        errorStr = "对方在战斗状态不允许交易"
    elseif errorType == -11 then
        errorStr = "自己已死亡不允许交易"
    elseif errorType == -12 then
        errorStr = "对方已死亡不允许交易"
    elseif errorType == -13 then
        errorStr = "对方没有设置允许交易"
    end
    SL:ShowSystemTips(errorStr)
end)

-- xx请求和你交易错误弹窗
SL:RegisterLUAEvent(LUA_EVENT_TRADE_REQUEST_ERROR_TIPS, "GUIInit", function(code)
    --[[        
        负数为错误码
        -1;   //交易条件不满足
        -2;   //距离太远不能交易
        -3;   //战斗状态不允许交易
        -4;   //离线不能交易
        -5;  //死亡不能交易
        -6;   //玩家在黑名单不能交易
    ]]
    if code == -1 then
        SL:ShowSystemTips("交易条件不满足")
    elseif code == -2 then
        SL:ShowSystemTips("具体太远，不能交易")
    elseif code == -3 then
        SL:ShowSystemTips("战斗状态中不能交易")
    elseif code == -4 then
        SL:ShowSystemTips("对方已离线，不能交易")
    elseif code == -5 then
        SL:ShowSystemTips("死亡不能交易")
    elseif code == -6 then
        SL:ShowSystemTips("该玩家在黑名单中")
    end
end)

-- 交易气泡提醒
SL:RegisterLUAEvent(LUA_EVENT_TARDE_BUBBLE_TIPS_CHANGE, "GUIInit", function(data)
    local function callback()
        local count = SL:GetValue("TRADE_INVITE_COUNT")
        local tradeList = SL:GetValue("TRADE_INVITE_ITEMS")
        local tradeData = tradeList[data.userId]
        if count == 1 then
            local function CommonTipsCallBack(bType, custom)
                if bType == 1 then
                    SL:RequestInfoTrade(data.userId, data.name)
                end
            end
            local dataTips    = {}
            dataTips.str      = sformat("玩家  <font color='#ebf291'>%s</font>  申请与你交易", data.name)
            dataTips.btnType  = 2
            dataTips.callback = CommonTipsCallBack
            UIOperator:OpenCommonTipsUI(dataTips)
            SL:DelBubbleTips(GUIDefine.BubbleType.TRADE)
        elseif count > 1 then
            local tipsData = {}
            tipsData.list = {}
            for _, v in pairs(tradeList) do
                local data = {}              
                data.str = sformat("请输入要拆分的数量：", v.name)

                data.agreeCall = function()
                    SL:RequestInfoTrade(v.userId, v.name)
                end

                data.disAgreeCall = function()
                    SL:RequestInfoTrade(v.userId, v.name, true)
                    SL:ClearInviteItemsById(v.userId)
                    if SL:GetValue("TRADE_INVITE_COUNT") == 0 then
                        SL:DelBubbleTips(GUIDefine.BubbleType.TRADE)
                    end
                end
                table.insert(tipsData.list, data)
            end

            if MainProperty and MainProperty.GetBubbleButtonByID then
                local node = MainProperty.GetBubbleButtonByID(GUIDefine.BubbleType.TRADE)
                if node and not GUI:Widget_IsNull(node) then
                    tipsData.pos = GUI:getWorldPosition(node)
                end
            end
            UIOperator:OpenCommonBubbleInfoUI(tipsData)
        end
    end

    local function cancelCallBack()
        local tradeList = SL:GetValue("TRADE_INVITE_ITEMS")
        for _, v in pairs(tradeList) do
            SL:RequestInfoTrade(v.userId, v.name, true)
        end
        SL:ClearInviteItems()
    end

    local tipsData = {}
    if data.type == 0 then
        SL:DelBubbleTips(GUIDefine.BubbleType.TRADE)
    elseif data.type == 1 then
        SL:AddBubbleTips(GUIDefine.BubbleType.TRADE, "res/private/main/bubble_tips/1900012602_1.png", callback, 30, cancelCallBack)
    end
end)

-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
---摆摊
-- 主玩家摆摊状态改变
SL:RegisterLUAEvent(LUA_EVENT_PLAYER_STALL_STATUS_CHANGE, "GUIInit", function (data)
    local actorID = data.actorID
    local inStallStatus = SL:GetValue("ACTOR_IS_IN_STALL", actorID)
    SL:SetValue("STALL_MY_TRADING_STATUS", inStallStatus)
    if not inStallStatus then 
        local mySellData = SL:GetValue("STALL_MYSELL_DATA")
        if mySellData and next(mySellData) then
            for i, v in ipairs(mySellData) do
                v.goldtype = nil
                v.price = nil
                BagData.AddItemDataAndNotice(v)
            end
        end
        SL:StallCleanMySellData()
    end
end)

-- 网络玩家摆摊状态改变
SL:RegisterLUAEvent(LUA_EVENT_NET_PLAYER_STALL_STATUS_CHANGE, "GUIInit", function(data)
    local actorID = data.actorID
    if SL:GetValue("STALL_USER_ID") == actorID and not SL:GetValue("ACTOR_IS_IN_STALL", actorID) then 
        UIOperator:CloseStallLayerUI() -- 关闭摆摊
    end
end)

-- 未找到商品提示
SL:RegisterLUAEvent(LUA_EVENT_NOT_FOUND_GOODS, "GUIInit", function(currencyID)
    SL:ShowSystemTips("未找到商品: " .. (currencyID or ""))
end)
-------------------------------------------------------------------------
-- npc
-- 药品研制成功
SL:RegisterLUAEvent(LUA_EVENT_NPC_MAKE_DRUG_SUCCESS, "GUIInit", function ()
    local data   = {}
    data.str     = "药瓶研制成功"
    data.btnDesc = { "确认" }
    UIOperator:OpenCommonTipsUI(data)
end)

-- 药品研制失败
SL:RegisterLUAEvent(LUA_EVENT_NPC_MAKE_DRUG_FAILED, "GUIInit", function (msg)
    if msg then
        local tips = true
        local data = {}
        data.btnDesc = { "确认" }
        if msg == 1 then
            data.str = "药瓶研制失败"
        elseif msg == 2 then
            data.str = "发生了错误"
        elseif msg == 3 then
            data.str = "金币不足"
        elseif msg == 4 then
            data.str = "你缺乏所必须的物品"
        else
            tips = false
        end

        if tips then
            UIOperator:OpenCommonTipsUI(data)
        end
    end
end)

-- 药品研制失败
SL:RegisterLUAEvent(LUA_EVENT_NPC_STORE_BUY_RESULT_FAIL, "GUIInit", function (msg)
    if msg then
        local str = "购买异常."
        if msg == 2 then
            str = "您无法携带更多物品了."
        elseif msg == 3 then
            str = "您没有足够的钱来购买此物品."
        elseif msg == 1 then
            str = "此物品被卖出."
        end

        local data   = {}
        data.str     = str
        data.btnDesc = { "确认" }
        UIOperator:OpenCommonTipsUI(data)
    end
end)
-----------------------------------------------------------------------------
-- 聊天
-- 收到聊天信息
SL:RegisterLUAEvent(LUA_EVENT_CHAT_MSG_ADD, "GUIInit", function(data)
    -- 附近聊天同步到玩家说话 --头顶的字除了正常字都不显示
    if (data.ChannelId == GUIDefine.ChatChannel.NEAR or data.ChannelId == GUIDefine.ChatChannel.SHOUT)
        and data.SendId and (not data.MT or data.MT == 0) and (not data.textType or data.textType == GUIDefine.ChatTextType.NORMAL) then

        if ChatData.IsReceiving(data.ChannelId) then
            SL:ShowActorSay(data)
        end
    end

    local mainPlayerID = SL:GetValue("USER_ID")
    if SL:GetValue("IS_PC_OPER_MODE") and data.ChannelId == GUIDefine.ChatChannel.PRIVATE and data.SendId and data.SendId ~= mainPlayerID then
        -- 是否自动回复
        local function checkAutoReply()
            local autoRelyList = ChatData.GetAutoReplyList() or {}
            if ChatData.GetAutoReplyEnable() and next(autoRelyList) then
                ChatData.SetAutoReplyEnable(false)
        
                local function autoReplyCB()
                    local item = table.remove(autoRelyList, 1)
                    ChatData.SetAutoRelyList(autoRelyList)
                    if item and item.content and item.SendId and item.SendName then
                        local autoContent = item.content
                        local target = {uid = item.SendId, name = item.SendName}
                        ChatData.AddTarget(target)
        
                        local function toSendMsg(input, risk_param)
                            local sendData = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = GUIDefine.ChatChannel.PRIVATE, risk = risk_param}
                            GUIFunction:SendChatMsg(sendData)
                            ChatData.SetAutoReplyEnable(true)
                            checkAutoReply()
                        end
        
                        -- 敏感词
                        if not string.find(autoContent, "^@.-") then
                            local function handle_Func(state, str, risk_param)
                                if not str then
                                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                                    ChatData.SetAutoReplyEnable(true)
                                    return
                                end
        
                                toSendMsg(str, risk_param)
                            end
                            local data = {}
                            data.channel_id = GUIDefine.ChatChannel.PRIVATE
                            if target then
                                data.to_role_level  = SL:GetValue("ACTOR_LEVEL", target.uid)
                                data.to_role_id     = target.uid
                                data.to_role_name   = target.name
                            end
                            SL:RequestCheckSensitiveWord(autoContent, 2, handle_Func, data)
                        end
                    end
                end
        
                if ChatData.GetCDTime(GUIDefine.ChatChannel.PRIVATE) > 0 then
                    SL:ScheduleOnce(autoReplyCB, ChatData.GetCDTime(GUIDefine.ChatChannel.PRIVATE))
                else
                    autoReplyCB()
                end
            end
        end

        local autoContent = ChatData.GetLocalChatDataByChannel(GUIDefine.ChatChannel.PRIVATE)
        if ChatData.GetAutoReplySwitch() and autoContent and string.len(autoContent) > 0 then
            ChatData.AddAutoReplyData({SendId = data.SendId, SendName = data.SendName, content = autoContent})
            if ChatData.GetAutoReplyEnable() then
                checkAutoReply()
            end
        end
    end

    if data.ChannelId == GUIDefine.ChatChannel.PRIVATE and data.SendId and data.SendId ~= mainPlayerID then
        if SL:GetValue("IS_PC_OPER_MODE") then
            if GUI:GetWindow(nil, UIConst.LAYERID.PCPrivateChatGUI) then
                return
            end
        else
            if GUI:GetWindow(nil, UIConst.LAYERID.ChatGUI) and ChatData.GetReceiveChannel() == GUIDefine.ChatChannel.PRIVATE then
                return
            end
        end

        if SL:GetValue("SOCIAL_IS_BLICKLIST_BY_UID", data.SendId) then
            return
        end

        if not ChatData.IsReceiving(data.ChannelId) then
            return
        end

        local function callback()
            if SL:GetValue("IS_PC_OPER_MODE") then
                UIOperator:OpenPCPrivateUI()
            else
                UIOperator:OpenChatUI({receiveChannel = GUIDefine.ChatChannel.PRIVATE})
            end
            SL:DelBubbleTips(GUIDefine.BubbleType.PRIVATE_CHAT)
        end
        SL:AddBubbleTips(GUIDefine.BubbleType.PRIVATE_CHAT, "res/private/main/bubble_tips/1900012607_1.png", callback)
    end
end)

-- 私聊对象触发
SL:RegisterLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, "GUIInit", function(data)
    if SL:GetValue("IS_PC_OPER_MODE") then
        return
    end

    if not data or not next(data) then
        return
    end

    UIOperator:OpenChatUI({selectChannel = GUIDefine.ChatChannel.PRIVATE})

    ChatData.AddTarget(data)
    SL:onLUAEvent(LUA_EVENT_CHAT_TARGET_CHANGE, data)
end)

-- 设置聊天频道接收状态 提示
SL:RegisterLUAEvent(LUA_EVENT_CHAT_SET_CHANNEL_RECEIVIND, "GUIInit", function(data)
    if not data or not next(data) then
        return
    end
    local status = data.status
    local channel = data.channel
    -- system tips

    local strs = status and {
        [GUIDefine.ChatChannel.SYSTEM]  = "允许接收系统信息",
        [GUIDefine.ChatChannel.SHOUT]   = "允许接收喊话信息",
        [GUIDefine.ChatChannel.PRIVATE] = "允许接收私聊信息",
        [GUIDefine.ChatChannel.GUILD]   = "允许接收行会信息",
        [GUIDefine.ChatChannel.TEAM]    = "允许接收组队信息",
        [GUIDefine.ChatChannel.NEAR]    = "允许接收附近信息",
        [GUIDefine.ChatChannel.WORLD]   = "允许接收传音信息",
    } or {
        [GUIDefine.ChatChannel.SYSTEM]  = "拒绝接收系统信息",
        [GUIDefine.ChatChannel.SHOUT]   = "拒绝接收喊话信息",
        [GUIDefine.ChatChannel.PRIVATE] = "拒绝接收私聊信息",
        [GUIDefine.ChatChannel.GUILD]   = "拒绝接收行会信息",
        [GUIDefine.ChatChannel.TEAM]    = "拒绝接收组队信息",
        [GUIDefine.ChatChannel.NEAR]    = "拒绝接收附近信息",
        [GUIDefine.ChatChannel.WORLD]   = "拒绝接收传音信息",
    }

    local tips = strs[channel]
    if tips then
        SL:ShowSystemTips(tips)
    end
end)

-- 经验改变
SL:RegisterLUAEvent(LUA_EVENT_EXP_CHANGE, "GUIInit", function(data)
    if not data or not next(data) then
        return false
    end

    local changed = data.changed or 0
    if changed < 1 then
        return false
    end
    
    local value    = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_EXP_IGNORE)
    local disable  = value[1] == 1
    local limit    = tonumber(value[2]) or 1
    if not disable or changed >= limit then
        -- 服务器开关 经验信息是否显示在聊天框 0：显示在聊天框
        if SL:GetValue("SERVER_OPTION", SW_KEY_EXP_IN_CHAT) == 0 then
            SL:onLUAEvent(LUA_EVENT_CHAT_MSG_ADD, {
                Msg       = string.format("%s 经验值增加.", changed),
                FColor    = 255,
                BColor    = 249,
                ChannelId = GUIDefine.ChatChannel.SYSTEM,
            })
        else
            local EXPcoordinate = GUIDefineEx.EXPcoordinate
            if not next(EXPcoordinate) then
                return false
            end

            if changed < EXPcoordinate[4] then
                return false
            end

            local platformID = SL:GetValue("IS_PC_OPER_MODE") and 1 or 2
            local data = {
                Msg    = string.format("%s 经验值增加.", changed),
                X      = EXPcoordinate[platformID].X,
                Y      = EXPcoordinate[platformID].Y,
                FColor = EXPcoordinate[3].X,
                BColor = EXPcoordinate[3].Y,
            }
            SL:onLUAEvent(LUA_EVENT_NOTICE_EXP, data)
        end
    end
end)

-----------------------------------------------------------------------------
-- 键盘事件
SL:RegisterLUAEvent(LUA_EVENT_ENTER_WORLD, "GUIInit_KeyBoard", function()
    if not SL:GetValue("IS_PC_OPER_MODE") then
        return
    end

    -- F1-F8 技能
    for i = 1, 8 do
        local function pressedCB(isAuto)
            local skillData = SL:GetValue("SKILL_DATA_BY_KEY", i)
            if not skillData then
                return false
            end
            local skillID = skillData.MagicID

            -- 开关技能
            if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) then
                if isAuto then
                    return
                end
                SL:SetValue("SKILL_SWITCH", skillID)
                return
            end

            SL:RequestLaunchSkill(skillID)
        end
        local function releaseCB()
            SL:ClearLaunchSkill()
        end
        GUI:addKeyboardEvent(string.format("KEY_F%s", i), pressedCB, releaseCB, 0.1)
    end

    -- CTRL+F1 - CTRL+F8 技能
    for i = 1, 8 do
        local function pressedCB(isAuto)
            local skillData = SL:GetValue("SKILL_DATA_BY_KEY", i + 8)
            if not skillData then
                return false
            end
            local skillID = skillData.MagicID

            -- 开关技能
            if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) then
                if isAuto then
                    return
                end
                SL:SetValue("SKILL_SWITCH", skillID)
                return
            end

            SL:RequestLaunchSkill(skillID)
        end
        local function releaseCB()
            SL:ClearLaunchSkill()
        end
        local codeKeys = {"KEY_CTRL", string.format("KEY_F%s", i)}
        GUI:addKeyboardEvent(codeKeys, pressedCB, releaseCB, 0.1)
    end

    -- 1-6 使用物品
    for i = 1, 6 do
        local interval   = 1
        local scheduleID = nil

        local function useItemCB()
            local quickUseData = QuickUseData.GetQuickUseDataByPos(i)
            if quickUseData then
                SL:RequestUseItem(quickUseData)
            end
        end

        local function pressedCB()
            useItemCB()
            if scheduleID then
                SL:UnSchedule(scheduleID)
                scheduleID = nil
            end
            scheduleID = SL:Schedule(useItemCB, interval)
        end
        local function releaseCB()
            if scheduleID then
                SL:UnSchedule(scheduleID)
                scheduleID = nil
            end
        end
        GUI:addKeyboardEvent(string.format("KEY_%s", i), pressedCB, releaseCB)
    end

    -- F9 背包
    local function pressedCB()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Bag)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Bag)
        end
    end
    GUI:addKeyboardEvent("KEY_F9", pressedCB)

    -- F10 角色技能页
    local function pressedCB()
        local isOpen = (PlayerFrame and PlayerFrame.IsReOpen) and PlayerFrame:IsReOpen(UIConst.LayerTable.PlayerEquip)
        if isOpen then
            UIOperator:CloseMyPlayerUI()
        else
            UIOperator:OpenMyPlayerUI({page = UIConst.LayerTable.PlayerEquip}) 
        end
    end
    GUI:addKeyboardEvent("KEY_F10", pressedCB)

    -- F11 角色技能页
    local function pressedCB()
        local isOpen = (PlayerFrame and PlayerFrame.IsReOpen) and PlayerFrame:IsReOpen(UIConst.LayerTable.PlayerSkill)
        if isOpen then
            UIOperator:CloseMyPlayerUI()
        else
            UIOperator:OpenMyPlayerUI({page = UIConst.LayerTable.PlayerSkill}) 
        end
    end
    GUI:addKeyboardEvent("KEY_F11", pressedCB)

    -- T 交易
    local function pressedCB()
        if SL:GetValue("SERVER_OPTION", SW_KEY_TRADE_DEAL) then
            SL:RequestTrade()
        end
    end
    GUI:addKeyboardEvent("KEY_T", pressedCB)

    -- G 行会
    local function pressedCB()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Guild)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Guild)
        end
    end
    GUI:addKeyboardEvent("KEY_G", pressedCB)

    -- P 拍卖
    local function pressedCB()
        if tonumber(SL:GetValue("GAME_DATA","OpenAuctionByP")) == 1 then
            return 
        end
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Auction)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Auction)
        end
    end
    GUI:addKeyboardEvent("KEY_P", pressedCB)

    -- F12 内挂
    local function pressedCB()
        UIOperator:OpenSettingUI()
    end
    GUI:addKeyboardEvent("KEY_F12", pressedCB)

    -- CTRL+B 商店
    local function pressedCB()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.StoreHot)
        else
            SL:JumpTo(SLDefine.HyperLinkID.StoreHot)
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_B"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)
    
    -- ALT-X 返回角色
    local function pressedCB()
        local function callback(bType)
            if bType == 1 then
                SL:RequestLeaveWorld()
            end
        end
        local data = {}
        data.str = "是否返回角色"
        data.btnDesc = {"确定", "取消"}
        data.callback = callback
        UIOperator:OpenCommonTipsUI(data)
    end
    local codeKeys = {"KEY_ALT", "KEY_X"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- ALT+Q退出游戏
    local function pressedCB()
        local function callback(bType)
            if bType == 1 then
                SL:ExitGame()
            end
        end
        local data = {}
        data.str = "是否确定退出游戏"
        data.btnDesc = {"确定", "取消"}
        data.callback = callback
        UIOperator:OpenCommonTipsUI(data)
    end
    local codeKeys = {"KEY_ALT", "KEY_Q"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+H 切换攻击模式
    local PKType = GUIDefine.PKModeType
    local pkModeTB = {PKType.HAM_ALL, PKType.HAM_PEACE, PKType.HAM_GROUP, PKType.HAM_GUILD, PKType.HAM_SHANE, PKType.HAM_NATION}
    -- 自定义攻击模式
    if next(SL:GetValue("RELATION_TYPE_LIST")) then
        for _, modeId in ipairs(SL:GetValue("RELATION_TYPE_LIST")) do
            table.insert(pkModeTB, modeId)
        end
    end
    local function pressedCB()
        local canMode = {}
        for _, v in ipairs(pkModeTB) do
            if SL:GetValue("PKMODE_CAN_USE", v) then
                table.insert(canMode, v)
            end
        end
        local function getPKModeIndex(pkMode) 
            for k, v in ipairs(canMode) do
                if pkMode == v then
                    return k
                end
            end
            return 1
        end

        local pkMode         = SL:GetValue("PKMODE")
        local index          = getPKModeIndex(pkMode)
        local nextPKMode     = canMode[(index >= #canMode and 1 or (index + 1))]
        SL:RequestChangePKMode(nextPKMode)
    end
    local codeKeys = {"KEY_LEFT_CTRL", "KEY_H"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+A 召唤物休息或者攻击
    local function pressedCB()
        if not SL:GetValue("PET_ALIVE") then
            return false
        end

        local PetPkType     = GUIDefine.PetPkType
        local currMode      = SL:GetValue("PET_PKMODE")
        local nextMode      = currMode == PetPkType.REST and PetPkType.ATTACK or PetPkType.REST
        SL:RequestChangePetPKMode(nextMode)
    end
    local codeKeys = {"KEY_LEFT_CTRL", "KEY_A"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+E 英雄切换攻击模式
    local function pressedCB()
        if SL:GetValue("HERO_IS_ALIVE") then
            SL:RequestChangeHeroMode()
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_E"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+W 英雄切换锁定目标
    local function pressedCB()
        if SL:GetValue("HERO_IS_ALIVE") then
            local mousePos = SL:GetValue("MOUSE_MOVE_POS")
            local posInWorldX, posInWorldY = SL:ConvertScreen2WorldPos(mousePos.x, mousePos.y)
            local actorID = SL:GetValue("PICK_ACTORID_BY_POS", posInWorldX, posInWorldY)
            if actorID and SL:GetValue("ACTOR_CAN_LOCK_BY_HERO", actorID) then
                local isPlayer = SL:GetValue("ACTOR_IS_PLAYER", actorID) and not SL:GetValue("ACTOR_IS_HERO", actorID)
                SL:RequestLockTargetByHero(actorID, isPlayer)
            end
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_W"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+Q 英雄守护位置
    local function pressedCB()
        if SL:GetValue("HERO_IS_ALIVE") then
            local mousePos = SL:GetValue("MOUSE_MOVE_POS")
            local posInWorldX, posInWorldY = SL:ConvertScreen2WorldPos(mousePos.x, mousePos.y)
            local mapX, mapY = SL:ConvertWorldPos2MapPos(posInWorldX, posInWorldY)
            SL:RequestHeroGuardPos(mapX, mapY)
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_Q"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+S 开启英雄合击
    local function pressedCB()
        if SL:GetValue("HERO_IS_ALIVE") then
            if SL:GetValue("H.SHAN") then -- 闪的时候才能放合击
                -- 请求合击
                SL:RequestHeroJoinAttack()
            end
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_S"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+R 宠物锁定目标
    local function pressedCB()
        if SL:GetValue("PET_ALIVE") then
            local mousePos = SL:GetValue("MOUSE_MOVE_POS")
            local posInWorldX, posInWorldY = SL:ConvertScreen2WorldPos(mousePos.x, mousePos.y)
            local actorID = SL:GetValue("PICK_ACTORID_BY_POS", posInWorldX, posInWorldY)
            if actorID and SL:GetValue("ACTOR_RELATION_TAG", actorID) == GUIDefine.ActorRelationType.RS_ENEMY then
                local lockID = SL:GetValue("PET_LOCK_ID")
                if lockID == actorID then -- 已锁定 
                    SL:RequestUnLockPetID(actorID)
                else
                    SL:RequestLockPetID(actorID)
                end
            end
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_R"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+L 骑马邀请
    local function pressedCB()
        local mainPlayerID = SL:GetValue("USER_ID")
        if not mainPlayerID then
            return
        end
        if not SL:GetValue("ACTOR_IS_DOUBLE_HORSE", mainPlayerID) then -- 主玩家不是双人坐骑
            SL:ShowSystemTips("你的坐骑不是双人坐骑")
            return
        end
        if SL:GetValue("ACTOR_HORSE_MASTER_ID", mainPlayerID) and SL:GetValue("ACTOR_HORSE_COPILOT_ID", mainPlayerID) then -- 主玩家的双人坐骑已满
            SL:ShowSystemTips("已满员")
            return
        end

        local targetID = SL:GetValue("SELECT_TARGET_ID")
        if not targetID then -- 没有选中对象
            return
        end
        if not SL:GetValue("ACTOR_IS_PLAYER", targetID) then -- 选择对象不是玩家
            SL:ShowSystemTips("邀请对象不是角色玩家")
            return
        end

        local mainPos = {x = SL:GetValue("ACTOR_MAP_X", mainPlayerID), y = SL:GetValue("ACTOR_MAP_Y", mainPlayerID)}
        local targetPos = {x = SL:GetValue("ACTOR_MAP_X", targetID), y = SL:GetValue("ACTOR_MAP_Y", targetID)}
        if SL:GetPointDistance(mainPos, targetPos) > 3 then
            SL:ShowSystemTips("邀请玩家不在邀请范围内")
            return
        end
        SL:RequestInvitePlayerInHorse(targetID)
    end
    local codeKeys = {"KEY_CTRL", "KEY_L"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- ALT+W 快速组队
    local function pressedCB()
        local mousePos = SL:GetValue("MOUSE_MOVE_POS")
        local posInWorldX, posInWorldY = SL:ConvertScreen2WorldPos(mousePos.x, mousePos.y)
        local targetID = SL:GetValue("PICK_ACTORID_BY_POS", posInWorldX, posInWorldY)

        if targetID then
            if SL:GetValue("TEAM_IS_MEMBER", targetID) then 
                return 
            else
                local memberCount = SL:GetValue("TEAM_MEMBER_COUNT")
                local memberMaxCount = SL:GetValue("TEAM_MEMBER_MAX_COUNT")
                if memberCount == 0 then
                    SL:RequestCreateTeam()
                elseif memberCount >= memberMaxCount then
                    SL:ShowSystemTips("队伍已满")
                    return
                end
                SL:RequestInviteJoinTeam(targetID)
            end
        end
    end
    local codeKeys = {"KEY_ALT", "KEY_W"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)

    -- CTRL+ALT+X 自动挂机
    local function pressedCB()
        if GUIDefineEx.DisableKeys and GUIDefineEx.DisableKeys[1] == 1 then 
            return
        end
        if SL:GetValue("BATTLE_IS_AFK") then
            SL:SetValue("BATTLE_AFK_END")
        else
            SL:SetValue("BATTLE_AFK_BEGIN")
        end
    end
    local codeKeys = {"KEY_CTRL", "KEY_ALT", "KEY_X"}
    GUI:addKeyboardEvent(codeKeys, pressedCB)


    -- CTRL+D 连击技能
    local function pressedCB(isAuto)
        local selectSkills = SL:GetValue("SET_COMBO_SKILLS")
        if not selectSkills or not selectSkills[1] then
            return false
        end
        local skillID = selectSkills[1]
        local num = #selectSkills
        if skillID then
            for i = 1, num do
                local id = selectSkills[i]
                if id and id ~= 0 then
                    if SL:GetValue("SKILL_IS_CDING", id) then
                        return
                    end
                end
            end
        end

        -- 开关技能
        if SL:GetValue("SKILL_IS_ONOFF_SKILL", skillID) then
            if isAuto then
                return
            end
            SL:SetValue("SKILL_SWITCH", skillID)
            return
        end

        -- 技能释放
        SL:RequestLaunchSkill(skillID)
    end
    local function releaseCB()
        SL:ClearLaunchSkill()
    end
    local codeKeys = {"KEY_CTRL", "KEY_D"}
    GUI:addKeyboardEvent(codeKeys, pressedCB, releaseCB, 0.1)

    -- PC聊天栏 上下键滚动聊天
    local function scrollChatFunc(isUp, isPage)
        local ui = MainProperty and MainProperty._ui
        if not ui then
            return nil
        end

        local list = ui["ListView_chat"]
        if not list then
            return
        end

        local innerSize     = GUI:ListView_getInnerContainerSize(list)
        local contentSize   = GUI:getContentSize(list)
        local innerPos      = GUI:ListView_getInnerContainerPosition(list)
        if innerSize.height - contentSize.height <= 0 then
            return
        end

        local pageHei       = contentSize.height
        local scrollY       = isPage and pageHei or 14
        local mHei          = innerSize.height - contentSize.height
        local percent       = (mHei + innerPos.y + (isUp and -scrollY or scrollY)) / mHei * 100
        percent             = math.min(math.max(0, percent), 100)
        GUI:ListView_scrollToPercentVertical(list, percent, 0.03, false)
    end
    
    local function pressedCB()
        scrollChatFunc(true)
    end
    GUI:addKeyboardEvent("KEY_UP_ARROW", pressedCB)
    
    local function pressedCB()
        scrollChatFunc(false)
    end
    GUI:addKeyboardEvent("KEY_DOWN_ARROW", pressedCB)

    --Page UP/DOWN 聊天翻页
    local function pressedCB()
        scrollChatFunc(true, true)
    end
    GUI:addKeyboardEvent("KEY_PG_UP", pressedCB)

    local function pressedCB()
        scrollChatFunc(false, true)
    end
    GUI:addKeyboardEvent("KEY_PG_DOWN", pressedCB)

    -- 波浪键 ` ~ 拾取当前位置道具
    local function pressedCB()
        SL:RequestPickMainPlayerPosItem()
    end
    GUI:addKeyboardEvent("KEY_GRAVE", pressedCB)

end)

-----------------------------------------------------------------------------
-- 收到NPC出售消息，打开出售界面
SL:RegisterLUAEvent(LUA_EVENT_NPC_SELL_OPEN, "GUIInit", function (param)
    UIOperator:OpenNpcSellRepaireUI(param)
end)

------------------------------------------------------------------------------
-- 收到NPC炼药列表消息，打开炼药界面
SL:RegisterLUAEvent(LUA_EVENT_NPC_MAKE_DRUG_OPEN, "GUIInit", function (data)
    UIOperator:OpenNpcMakeDrugUI(data)
end)

------------------------------------------------------------------------------
-- 打开NPC商店界面
SL:RegisterLUAEvent(LUA_EVENT_NPC_STORE_OPEN, "GUIInit", function (data)
    UIOperator:OpenNpcStoreUI(data)
end)

------------------------------------------------------------------------------
-- 打开进度条
SL:RegisterLUAEvent(LUA_EVENT_OPEN_PROGRESSBAR, "GUIInit", function (data)
    UIOperator:CloseProgressBarUI()

    local jsonData = ParseRawMsgToJson(data)
    if not jsonData then
        return nil
    end

    UIOperator:OpenProgressBarUI(jsonData)
end)

------------------------------------------------------------------------------
-- 自动使用
local OnBagItemChange = function(data, isHero)
    local checkItem = function (item)
        if isHero then
            return GUIFunction:OnAutoUseCheckItem_Hero(item)
        end

        -- 先检测英雄
        local firstHero = SL:GetValue("GAME_DATA", "firstHeroAutoUse")
        return firstHero == 1 and (GUIFunction:OnAutoUseCheckItem_Hero(item) or GUIFunction:OnAutoUseCheckItem(item)) or (GUIFunction:OnAutoUseCheckItem(item) or GUIFunction:OnAutoUseCheckItem_Hero(item))
    end

    if data and data.opera and (data.opera == GUIDefine.OprateType.ADD or data.opera == GUIDefine.OprateType.CHANGE) then
        for _, v in pairs(data.operID) do
            if not v.isHad or (v.change and v.change > 0) then
                local item = v.item or {}
                local isEquipOff = AutoUseItemData.IsEquipOffByMakeIndex(item.MakeIndex)
                local isNotTip   = AutoUseItemData.IsEquipNotTip(item)
                if not isEquipOff and not isNotTip then
                    checkItem(item)
                end
            end
        end
    end
end

SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "GUIInit", function (data)
    OnBagItemChange(data)
end)

SL:RegisterLUAEvent(LUA_EVENT_HERO_BAG_ITEM_CHANGE, "GUIInit", function (data)
    OnBagItemChange(data, true)
end)
------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- 关系
-- 邀请建立关系操作异常
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_INVITE_ERROR, "GUIInit", function(errorCode)
    if errorCode == 1 then
        SL:ShowSystemTips("关系网类型id不存在")
    elseif errorCode == 2 then
        SL:ShowSystemTips("对方拒绝被邀请")
    elseif errorCode == 3 then
        SL:ShowSystemTips("该类型关系网数量达上限")
    elseif errorCode == 4 then
        SL:ShowSystemTips("关系网到达人数上限")
    elseif errorCode == 5 then
        SL:ShowSystemTips("对方该类型关系网数量达上限")
    elseif errorCode == 6 then
        SL:ShowSystemTips("对方已在其他人邀请的同类型关系网")
    elseif errorCode == 7 then
        SL:ShowSystemTips("性别不满足")
    elseif errorCode == 8 then
        SL:ShowSystemTips("不可重复邀请")
    elseif errorCode == 9 then
        SL:ShowSystemTips("对方已经邀请过你")
    else
        SL:ShowSystemTips("其他错误")
    end
end)

-- 关系通知提示
SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_RELATION_NOTICE, "GUIInit", function(data)
    if not data or not next(data) then
        return
    end

    local type          = data.type
    local member        = data.member
    local relationType  = data.relationType
    local relationName  = SL:GetMetaValue("RELATION_TYPE_NAME", relationType)
    if type == GUIDefine.RelationNoticeType.KICKED then
        SL:ShowSystemTips(string.format("你被【%s】里的【%s】踢出了", relationName, member))

    elseif type == GUIDefine.RelationNoticeType.DISSOLVE then
        SL:ShowSystemTips(string.format("你的【%s】解散了", relationName))

    elseif type == GUIDefine.RelationNoticeType.EXIT then
        SL:ShowSystemTips(string.format("【%s】退出了【%s】", member, relationName))

    elseif type == GUIDefine.RelationNoticeType.JOIN then
        SL:ShowSystemTips(string.format("【%s】加入了【%s】", member, relationName))
    end
end)