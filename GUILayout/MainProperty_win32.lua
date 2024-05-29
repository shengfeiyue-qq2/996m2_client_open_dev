MainProperty = {}

MainProperty._chatItemWid = 500
MainProperty._path = "res/private/main-win32/"

MainProperty._bubbleTipsData = {} -- 气泡数据
MainProperty._bubbleTipsCells = {}

MainProperty._pSize = {}
MainProperty._drawHWay = {} -- 绘制方式

MainProperty._defaultListWid = 608  -- 1024x768 默认聊天列表尺寸
MainProperty._dValue = nil

MainProperty._dzSkillID     = 118       -- 斗转星移技能ID
MainProperty._zjShow        = false     -- 醉酒相关是否显示

MainProperty._iconPath = {
    [1] = {"190001100.png", "190001101.png"}, -- 系统频道
    [2] = {"190001108.png", "190001109.png"}, -- 喊话
    [3] = {"190001104.png", "190001105.png"}, -- 私聊
    [4] = {"190001106.png", "190001107.png"}, -- 行会
    [7] = {"190001102.png", "190001103.png"}, -- 世界
}
--0-白天，1-黑夜，2-日出，3-傍晚
MainProperty._darkIconPath = {
    [0]="00000044.png",
    [1]="00000046.png",
    [2]="00000045.png",
    [3]="00000047.png"
}
MainProperty._pkModeShow = {
    [0] = "[全体攻击模式]",
    [1] = "[和平攻击模式]",
    [2] = "[夫妻攻击模式]",
    [3] = "[师徒攻击模式]",
    [4] = "[编组攻击模式]",
    [5] = "[行会攻击模式]",
    [6] = "[善恶攻击模式]",
    [7] = "[国家攻击模式]",
    [10] = "[区服攻击模式]"
}

local DROP_TOTAL_TYPE_ID = 99
local FAKE_DROP_TYPE_ID  = 77
local CHANNEL = SL:GetMetaValue("CHAT_CHANNEL_ENUM")
MainProperty._channelNameMap = {            -- 对应选择频道名
    [CHANNEL.Shout]     = "喊 话",
    [CHANNEL.Guild]     = "行 会",
    [CHANNEL.Team]      = "组 队",
    [CHANNEL.Near]      = "附 近",
    [CHANNEL.World]     = "世 界",
    [CHANNEL.Nation]    = "国 家",
    [CHANNEL.Union]     = "联 盟",
    [CHANNEL.Cross]     = "跨 服",
}

function MainProperty.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_property_win32")
    MainProperty._ui = GUI:ui_delegate(parent)

    MainProperty._selectBtnShow = SL:GetMetaValue("GAME_DATA", "PCShowSelectChannels") and true or false

    MainProperty._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")
    MainProperty._angerHei = GUI:getContentSize(MainProperty._ui.Panel_loadBar).height

    MainProperty._dropTypeList = {}
    MainProperty._dropTypeCells = {}
    MainProperty.InitDropData()
    --
    MainProperty.InitHPPanel()
    MainProperty.InitActPanel()
    MainProperty.InitChatPanel()
    MainProperty.InitAutoSFXTips()
    MainProperty.InitPickButton()
    MainProperty.InitQuickUseShow()

    -- 转生属性点分配页
    GUI:addOnClickEvent(MainProperty._ui.btn_rein_add, function()
        SL:JumpTo(51)
        SL:PlayBtnClickAudio()
    end)

    --
    MainProperty.OnRefreshPropertyShow()
    MainProperty.OnUpdatePlayerPosition()
    MainProperty.OnDarkStateChange()

    --
    MainProperty.RegisterEvent()
end

function MainProperty.GetChatWidth()
    return MainProperty._chatItemWid
end

function MainProperty.InitDropData()
    local dropTotalData = {
        id = DROP_TOTAL_TYPE_ID,
        name = "全部",
    }
    table.insert(MainProperty._dropTypeList, dropTotalData)

    local fakeDrop = SL:GetMetaValue("GAME_DATA", "ShowFakeDropType")
    if fakeDrop and string.len(fakeDrop) > 0 then
        local param = string.split(fakeDrop, "#")
        if param[2] and tonumber(param[2]) == 1 and not SL:GetMetaValue("IS_CLOSE_FAKEDROP") then
            table.insert(MainProperty._dropTypeList, {id = FAKE_DROP_TYPE_ID, name = param[1]})
        end
    end

    local data = SL:GetMetaValue("GAME_DATA", "DropTypeShow")
    if data and string.len(data) > 0 then
        local list = string.split(data, "|")
        for i, v in ipairs(list) do
            local param1 = string.split(v, "#")
            if param1[1] and tonumber(param1[1]) == 1 then
                table.insert(MainProperty._dropTypeList, {id = tonumber(param1[2]), name = param1[3]})
            end
        end
    end
end
--------------------------- 快捷栏 -----------------------------
-- 初始化显示的快捷栏
function MainProperty.InitQuickUseShow()
    local showNum = 0
    -- 默认个数
    if MainProperty._ui.Panel_quick and GUI:getVisible(MainProperty._ui.Panel_quick) then
        for i = 1, 6 do
            local layout = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if layout and GUI:getVisible(layout) then
                showNum = showNum + 1
            end
        end
    end
    -- 设置快捷框个数 (最大：6)
    SL:SetMetaValue("QUICK_USE_NUM", showNum)
end

----------------------------------------------------------------
function MainProperty.InitAdapet()
    local notAdapet = tonumber(SL:GetMetaValue("GAME_DATA", "PCPropertyNotAdapet")) == 1
    local contentWidth = GUI:getContentSize(MainProperty._ui.Panel_chat).width
    if notAdapet then
        MainProperty._chatItemWid = GUI:getContentSize(MainProperty._ui.ListView_chat).width
        return
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    GUI:setContentSize(MainProperty._ui.Panel_bg, screenW, screenH)
    GUI:setContentSize(MainProperty._ui.Panel_hide_drop, screenW, screenH)

    GUI:setPosition(MainProperty._ui.Panel_hp, 0, 0)
    GUI:setPosition(MainProperty._ui.Panel_act, screenW, 0)
    local hpPanelWid = GUI:getContentSize(MainProperty._ui.Panel_hp).width
    local actPanelWid = GUI:getContentSize(MainProperty._ui.Panel_act).width

    contentWidth = screenW - hpPanelWid - actPanelWid
    local offsetX = math.floor((hpPanelWid - actPanelWid) / 2)
    GUI:setPositionX(MainProperty._ui.Panel_chat, screenW / 2 + offsetX)
    GUI:setContentSize(
        MainProperty._ui.Panel_chat,
        contentWidth,
        GUI:getContentSize(MainProperty._ui.Panel_chat).height
    )

    GUI:setPositionX(MainProperty._ui.Image_chat_bg, contentWidth / 2)
    GUI:setContentSize(
        MainProperty._ui.Image_chat_bg,
        contentWidth,
        GUI:getContentSize(MainProperty._ui.Image_chat_bg).height
    )

    GUI:setPositionX(MainProperty._ui.Panel_chat_touch, contentWidth / 2)
    GUI:setContentSize(
        MainProperty._ui.Panel_chat_touch,
        contentWidth,
        GUI:getContentSize(MainProperty._ui.Panel_chat_touch).height
    )

    if not MainProperty._dValue then
        MainProperty._dValue = GUI:getContentSize(MainProperty._ui.ListView_chat).width - MainProperty._defaultListWid
    end
    local chatListWid = contentWidth - 28 + MainProperty._dValue
    GUI:setPositionX(MainProperty._ui.ListView_chat, contentWidth / 2)
    GUI:setContentSize(
        MainProperty._ui.ListView_chat,
        chatListWid,
        GUI:getContentSize(MainProperty._ui.ListView_chat).height
    )

    GUI:setPositionX(MainProperty._ui.ListView_chat_ex, contentWidth / 2)
    GUI:setContentSize(
        MainProperty._ui.ListView_chat_ex,
        chatListWid,
        GUI:getContentSize(MainProperty._ui.ListView_chat_ex).height
    )

    local sizeW = MainProperty._selectBtnShow and GUI:getContentSize(MainProperty._ui.Button_channel).width or 0
    GUI:setPositionX(MainProperty._ui.TextField_input, 14 + sizeW - MainProperty._dValue/2)
    GUI:setContentSize(
        MainProperty._ui.TextField_input,
        chatListWid - sizeW,
        GUI:getContentSize(MainProperty._ui.TextField_input).height
    )

    GUI:setPositionX(MainProperty._ui.Panel_exit_funcs, contentWidth - 8)

    MainProperty._chatItemWid = chatListWid
end

function MainProperty.InitHPPanel()
    local function mainSetReceiving(channel, sender)
        if not channel or not sender then
            return
        end
        SL:SetMetaValue("CHAT_CHANNEL_RECEIVIND", channel)
        local path = SL:GetMetaValue("CHAT_CHANNEL_ISRECEIVE", channel) and MainProperty._iconPath[channel][1] or MainProperty._iconPath[channel][2]
        GUI:Button_loadTextureNormal(sender, MainProperty._path .. path)
        GUI:Button_loadTexturePressed(sender, MainProperty._path .. path)
        SL:PlayBtnClickAudio()
    end

    -- 频道接收开关
    -- 系统
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_1, function(sender)
        mainSetReceiving(1, sender)
    end)

    -- 世界
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_2, function(sender)
        mainSetReceiving(7, sender)
    end)

    -- 私聊
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_3, function(sender)
        mainSetReceiving(3, sender)
    end)

    -- 行会
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_4, function(sender)
        mainSetReceiving(4, sender)
    end)

    -- 喊话
    GUI:addOnClickEvent(MainProperty._ui.Button_chat_5, function(sender)
        mainSetReceiving(2, sender)
    end)

    -- 自动喊话开关

    -- 鼠标移入Tips
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_1, "允许所有系统信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_2, "允许所有传音信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_3, "允许所有私聊信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_4, "允许行会聊天信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_5, "允许所有喊话消息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_6, "特殊命令", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui.Button_chat_7, "自动喊话开关", {x = -10, y = -20}, {x = 1, y = 0.5})

    if tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 then
        GUI:addMouseOverTips(MainProperty._ui.Panel_dz, function ()
            local curDZValue = SL:GetMetaValue("INTERNAL_DZ_CURVALUE") or 0
            local maxDZValue = SL:GetMetaValue("INTERNAL_DZ_MAXVALUE") or 0
            return string.format("斗转星移值: %s/%s", curDZValue, maxDZValue)
        end, {x = 0, y = 0}, {x = 0.5, y = 0.5})
        GUI:addMouseOverTips(MainProperty._ui.Panel_zj, string.format("醉酒值: %s%%", 0), {x = 0, y = 0}, {x = 0.5, y = 0.5})
    end

    MainProperty.InitNGShow()
end

function MainProperty.InitNGShow()
    if SL:GetMetaValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    MainProperty.OnRefreshDZShow()
    GUI:setVisible(MainProperty._ui.Panel_zj, MainProperty._zjShow)
    GUI:setVisible(MainProperty._ui.Panel_ng_show, MainProperty._NGShow)

    if MainProperty._NGShow then
        local pSize = GUI:getContentSize(MainProperty._ui.Panel_loadBar)
        local curHeiPer = pSize.height / MainProperty._angerHei
        MainProperty._angerHei = 136
        GUI:setContentSize(MainProperty._ui.Image_laodBarbg, GUI:getContentSize(MainProperty._ui.Image_laodBarbg).width, MainProperty._angerHei)
        GUI:setContentSize(MainProperty._ui.Panel_loadBar, pSize.width, math.floor(MainProperty._angerHei * curHeiPer))
        GUI:setContentSize(MainProperty._ui.Image_loadbar1, GUI:getContentSize(MainProperty._ui.Image_loadbar1).width, MainProperty._angerHei)
        GUI:setContentSize(MainProperty._ui.Image_loadbar2, GUI:getContentSize(MainProperty._ui.Image_loadbar2).width, MainProperty._angerHei)
    end
end

function MainProperty.InitActPanel()
    -- 英雄相关
    if SL:GetMetaValue("USEHERO") then
        GUI:setVisible(MainProperty._ui.Image_loadbar2, false)
        MainProperty.RefAnger(0)

        GUI:addOnClickEvent(MainProperty._ui.Button_herostate, function()
            SL:RequestCallOrOutHero()
            GUI:delayTouchEnabled(MainProperty._ui.Button_herostate, 0.5)
        end)
        GUI:addMouseOverTips(MainProperty._ui.Button_herostate, "召唤英雄", {x = -20, y = 0}, {x = 0.5, y = 0.5})

        GUI:addOnClickEvent(MainProperty._ui.Button_heroinfo, function()
            if SL:GetMetaValue("HERO_IS_ALIVE") then
                -- 打开英雄角色面板
                SL:OpenMyPlayerHeroUI({extend = 1})
            end
        end)
        GUI:addMouseOverTips(MainProperty._ui.Button_heroinfo, "英雄状态", {x = 0, y = 0}, {x = 0.5, y = 0.5})

        GUI:addOnClickEvent(MainProperty._ui.Button_herobag, function()
            if SL:GetMetaValue("HERO_IS_ALIVE") then
                -- 打开英雄背包
                SL:OpenHeroBagUI()
            end
            GUI:delayTouchEnabled(MainProperty._ui.Button_herobag, 0.5)
        end)
        GUI:addMouseOverTips(MainProperty._ui.Button_herobag, "英雄包裹", {x = 20, y = 0}, {x = 0.5, y = 0.5})
    else
        GUI:setVisible(MainProperty._ui.Image_laodBarbg, false)
        GUI:setVisible(MainProperty._ui.Button_herostate, false)
        GUI:setVisible(MainProperty._ui.Button_heroinfo, false)
        GUI:setVisible(MainProperty._ui.Button_herobag, false)
        GUI:setPositionY(MainProperty._ui.Text_pkmode, GUI:getPositionY(MainProperty._ui.Text_pkmode) + 10)
    end

    -- 功能按钮
    -- 角色
    GUI:addOnClickEvent(MainProperty._ui.Button_role, function()
        SL:JumpTo(1)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_role, "状态信息(F10)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 背包
    GUI:addOnClickEvent(MainProperty._ui.Button_bag, function()
        SL:JumpTo(7)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_bag, "包裹物品(F9)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 技能
    GUI:addOnClickEvent(MainProperty._ui.Button_skill, function()
        SL:JumpTo(4)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_skill, "技能信息(F11)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 音效
    GUI:addOnClickEvent(MainProperty._ui.Button_voice, function()
        local value27 = SL:GetMetaValue("SETTING_ENABLED", 27) or 0
        local value52 = SL:GetMetaValue("SETTING_ENABLED", 52) or 0
        local enable = value27 > 0 and value52 > 0
        SL:SetMetaValue("SETTING_VALUE", 27, { enable and 0 or 100 })
        SL:SetMetaValue("SETTING_VALUE", 52, { enable and 0 or 100 })
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_voice, "音效开关", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 商店
    GUI:addOnClickEvent(MainProperty._ui.Button_store, function()
        SL:JumpTo(9)
        SL:PlayBtnClickAudio()
    end)

    -- pk模式切换
    local function changePKMode()
        local pkModeTB = {0, 1, 4, 5, 6, 3, 2, 7}
        -- 区服模式只能在跨服时可切换
        if SL:GetMetaValue("KFSTATE") then
            table.insert(pkModeTB, 10)
        end
        local canMode = {}
        for _, v in ipairs(pkModeTB) do
            if SL:GetMetaValue("PKMODE_CAN_USE", v) then
                table.insert(canMode, v)
            end
        end
        local function getPKModeIndex(pkm)
            for k, v in pairs(canMode) do
                if pkm == v then
                    return k
                end
            end
            return 1
        end
        local curPKMode = SL:GetMetaValue("PKMODE")
        local index = getPKModeIndex(curPKMode)
        local nextPKMode = canMode[(index >= #canMode and 1 or index + 1)]
        SL:RequestChangePKMode(nextPKMode)
    end
    GUI:addOnClickEvent(MainProperty._ui.Text_pkmode, changePKMode)
    GUI:addMouseOverTips(MainProperty._ui.Text_pkmode, "点击切换", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 时钟
    local function callback()
        local date = os.date("*t", SL:GetMetaValue("SERVER_TIME"))
        GUI:Text_setString(MainProperty._ui.Text_time, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    -- FPS 帧率
    local sumFps = 0
    local count = 0
    SL:Schedule(
        function()
            sumFps = sumFps + SL:GetMetaValue("FPS")
            count = count + 1
        end,
        0
    )
    SL:Schedule(
        function()
            local fps = math.min(math.ceil(sumFps / count), 60)
            GUI:Text_setString(MainProperty._ui.Text_FPS, string.format("FPS:%s", fps))
            sumFps = 0
            count = 0
        end,
        0.5
    )

    GUI:addMouseOverTips(
        MainProperty._ui.Text_level,
        function ()
            return string.format("当前等级：%s", SL:GetMetaValue("LEVEL"))
        end,
        {x = 0, y = -20},
        {x = 0.1, y = 0.5}
    )
    GUI:addMouseOverTips(
        MainProperty._ui.LoadingBar_exp,
        function()
            local curExp = SL:GetMetaValue("EXP")
            local maxExp = math.max(SL:GetMetaValue("MAXEXP"), 1)
            local per = math.min(curExp / maxExp * 100, 100)
            return string.format("当前经验：%.2f%%", per)
        end,
        {x = 0, y = 0},
        {x = 0.3, y = 0.5}
    )
    GUI:addMouseOverTips(
        MainProperty._ui.LoadingBar_weight,
        function()
            local curWeight = SL:GetMetaValue("BW")
            local maxWeight = SL:GetMetaValue("MAXBW")
            return string.format("包裹负重：%s/%s", curWeight, maxWeight)
        end,
        {x = 0, y = 0},
        {x = 0.3, y = 0.5}
    )
end

function MainProperty.InitChatPanel()
    -- 地图
    GUI:addOnClickEvent(MainProperty._ui.Button_map, function()
        SL:OpenPCMiniMapUI()
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_map, "小地图(Tab)", { x = 0, y = 0 })

    -- 交易
    GUI:addOnClickEvent(MainProperty._ui.Button_trade, function()
        SL:OpenTradeUI()
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_trade, "交易(T)", { x = 0, y = 0 })

    -- 服务端交易开关
    local tradeAble = SL:GetMetaValue("SERVER_OPTION", SW_KEY_TRADE_DEAL) == true
    GUI:setVisible(MainProperty._ui.Button_trade, tradeAble)
    if not tradeAble then
        GUI:setPositionX(MainProperty._ui.Button_guild, 41)
        GUI:setPositionX(MainProperty._ui.Button_near, 68)
        GUI:setPositionX(MainProperty._ui.Button_rank, 95)
        GUI:setPositionX(MainProperty._ui.Button_private, 122)
        GUI:setPositionX(MainProperty._ui.Button_drop, 149)
        GUI:setPositionX(MainProperty._ui.btn_rein_add, 176)
    end

    -- 行会
    GUI:addOnClickEvent(MainProperty._ui.Button_guild, function()
        SL:JumpTo(31)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_guild, "行会(G)", { x = 0, y = 0 })

    -- 附近
    GUI:addOnClickEvent(MainProperty._ui.Button_near, function()
        SL:JumpTo(18)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_near, "附近的人", { x = 0, y = 0 })

    -- 排行榜
    GUI:addOnClickEvent(MainProperty._ui.Button_rank, function()
        SL:JumpTo(32)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_rank, "排行榜", { x = 0, y = 0 })

    -- 私聊
    GUI:addOnClickEvent(MainProperty._ui.Button_private, function()
        SL:JumpTo(53)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_private, "私聊记录", { x = 0, y = 0 })

    -- 掉落
    GUI:addOnClickEvent(MainProperty._ui.Button_drop, function()
        MainProperty.ShowDropSwitchPanel()
        SL:PlayBtnClickAudio()
        GUI:delayTouchEnabled(MainProperty._ui.Button_drop)
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_drop, "掉落分类开关", { x = 0, y = 0 })

    GUI:addOnClickEvent(MainProperty._ui.Panel_hide_drop, function()
        MainProperty.HideDropSwitchPanel()
    end)

    -- 小退
    GUI:addOnClickEvent(MainProperty._ui.Button_out, function()
        SL:JumpTo(29)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_out, "退出角色(Alt-X)", { x = 0, y = 0 })

    -- 大退
    GUI:addOnClickEvent(MainProperty._ui.Button_end, function()
        local function callback(bType, custom)
            if bType == 1 then
                SL:ExitGame()
            end
        end
        local data = {}
        data.str = "是否确定退出游戏"
        data.btnType = 2
        data.callback = callback
        SL:OpenCommonTipsPop(data)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui.Button_end, "退出游戏(Alt-Q)", { x = 0, y = 0 })

    GUI:TextInput_setReturnType(MainProperty._ui.TextField_input, 2)
    GUI:TextInput_setInputMode(MainProperty._ui.TextField_input, 6)
    GUI:TextInput_setMaxLength(MainProperty._ui.TextField_input, 60)

    -- auto size
    local minHeight = 155
    local function touchCallback(sender, eventType)
        local maxHeight = SL:GetMetaValue("SCREEN_HEIGHT") - 100
        if eventType == 1 then
            local touchMovedPos = GUI:getTouchMovePosition(sender)
            local height = touchMovedPos.y
            height = math.min(maxHeight, height)
            height = math.max(minHeight, height)
            height = math.round(height)

            GUI:setContentSize(
                MainProperty._ui.Panel_chat,
                GUI:getContentSize(MainProperty._ui.Panel_chat).width,
                height
            )
            GUI:setContentSize(
                MainProperty._ui.Image_chat_bg,
                GUI:getContentSize(MainProperty._ui.Image_chat_bg).width,
                height
            )

            GUI:setPositionY(MainProperty._ui.Panel_chat_touch, height)
            GUI:setPositionY(MainProperty._ui.Panel_chat_funcs, height - 9)
            GUI:setPositionY(MainProperty._ui.Panel_exit_funcs, height - 9)

            local exContentSize = GUI:getContentSize(MainProperty._ui.ListView_chat_ex)
            local exItems = GUI:ListView_getItems(MainProperty._ui.ListView_chat_ex)
            local exHei = #exItems == 0 and 1 or exContentSize.height
            local contentSize = GUI:getContentSize(MainProperty._ui.ListView_chat)
            local chatHei = height - 50 - exHei
            GUI:setContentSize(MainProperty._ui.ListView_chat, contentSize.width, chatHei)
            GUI:ListView_jumpToBottom(MainProperty._ui.ListView_chat)

            GUI:setPositionY(MainProperty._ui.Panel_quick, height - 5)
            GUI:setPositionY(MainProperty._ui.ListView_chat_ex, height - 25)

            GUI:setPositionY(MainProperty._ui.Panel_auto_tips, height + 55)
        end
    end
    GUI:addOnTouchEvent(MainProperty._ui.Panel_chat_touch, touchCallback)
end

function MainProperty.RefreshListView()
    local cellSize  = {width = MainProperty._chatItemWid, height = 12}
    local count     = #GUI:ListView_getItems(MainProperty._ui.ListView_chat_ex)
    local margin    = GUI:ListView_getItemsMargin(MainProperty._ui.ListView_chat_ex)
    local exHei     = (cellSize.height * count) + (count - 1) * margin
    GUI:setContentSize(MainProperty._ui.ListView_chat_ex, MainProperty._chatItemWid, exHei)

    local panelHei = GUI:getContentSize(MainProperty._ui.Panel_chat).height
    local chatHei = panelHei - 50 - exHei
    GUI:setContentSize(MainProperty._ui.ListView_chat, MainProperty._chatItemWid, chatHei)
    GUI:ListView_jumpToBottom(MainProperty._ui.ListView_chat)
end

function MainProperty.RegisterEvent()
    -- 注册事件
    SL:RegisterLUAEvent(LUA_EVENT_HPMPCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_EXPCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_WEIGHTCHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    -- 主玩家位置刷新
    SL:RegisterLUAEvent(LUA_EVENT_BIND_MAINPLAYER, "MainProperty", MainProperty.OnUpdatePlayerPosition)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, "MainProperty", MainProperty.OnChangeScene)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_MAPPOS_CHANGE, "MainProperty", MainProperty.OnUpdatePlayerPosition)
    -- 脚本展示魔血球动画
    SL:RegisterLUAEvent(LUA_EVENT_PLAY_MAGICBALL_EFFECT, "MainProperty", MainProperty.OnPlayMagicBallEffect)
    -- 气泡相关
    SL:RegisterLUAEvent(LUA_EVENT_BUBBLETIPS_STATUS_CHANGE, "MainProperty", MainProperty.OnRefreshBubbleTips)
    -- 自动提示相关
    SL:RegisterLUAEvent(LUA_EVENT_AUTOFIGHT_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoFightTips)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVE_TIPS_SHOW, "MainProperty", MainProperty.OnShowOrHideAutoMoveTips)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICK_TIPS_SHOW, "MainProperty", MainProperty.OnUpdatePickState)
    -- -- 英雄相关
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ANGER_CAHNGE, "MainProperty", MainProperty.OnHeroAngerChange)
    -- 转生点改变
    SL:RegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "MainProperty", MainProperty.OnReinAttrChange)
    -- PK模式改变
    SL:RegisterLUAEvent(LUA_EVENT_PKMODECHANGE, "MainProperty", MainProperty.OnPlayerPKStateChange)
    --黑夜状态改变
    SL:RegisterLUAEvent(LUA_EVENT_DARK_STATE_CHANGE, "MainProperty", MainProperty.OnDarkStateChange)
    --学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MainProperty", MainProperty.OnRefreshNGShow)
    -- 斗转值改变
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_DZVALUE_CHANGE, "MainProperty", MainProperty.OnRefreshNGShow)
    -- 技能初始化/增加/删除
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_INIT, "MainProperty", MainProperty.OnRefreshDZShow)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD, "MainProperty", MainProperty.OnRefreshDZShow)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainProperty", MainProperty.OnRefreshDZShow)
    -- 设置连击技能刷新
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SET_COMBO_REFRESH, "MainProperty", MainProperty.OnUpdateSetComboSkill)
    -- 连击技能CD状态
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_COMBO_SKILLCD_STATE, "MainProperty", MainProperty.OnActiveComboSkill)
end

function MainProperty.OnDarkStateChange()
    local darkState = SL:GetMetaValue("DARK_STATE")
    --0-白天，1-黑夜，2-日出，3-傍晚
    GUI:Image_loadTexture(MainProperty._ui.Image_time,MainProperty._path..MainProperty._darkIconPath[darkState])
    
end

function MainProperty.OnRefreshPropertyShow()
    --Level
    local roleLevel = SL:GetMetaValue("LEVEL")
    GUI:Text_setString(MainProperty._ui.Text_level, roleLevel)

    --EXP
    local curExp = SL:GetMetaValue("EXP")
    local maxExp = SL:GetMetaValue("MAXEXP")
    local expPer = curExp / maxExp * 100
    GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_exp, expPer)

    --HPMP
    local curHP = SL:GetMetaValue("HP")
    local maxHP = SL:GetMetaValue("MAXHP")
    local curMP = SL:GetMetaValue("MP")
    local maxMP = SL:GetMetaValue("MAXMP")
    local hpPer = curHP / maxHP * 100
    local mpPer = curMP / maxMP * 100
    GUI:Text_setString(MainProperty._ui.Text_hp, string.format("%s/%s", SL:HPUnit(curHP), SL:HPUnit(maxHP)))
    GUI:Text_setString(MainProperty._ui.Text_mp, string.format("%s/%s", SL:HPUnit(curMP), SL:HPUnit(maxMP)))

    local roleJob = SL:GetMetaValue("JOB")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        GUI:setVisible(MainProperty._ui.LoadingBar_hp, false)
        GUI:setVisible(MainProperty._ui.LoadingBar_mp, false)
        GUI:setVisible(MainProperty._ui.Image_fhp_bg, true)
        GUI:setVisible(MainProperty._ui.LoadingBar_fhp, true)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_fhp, hpPer)
    else
        GUI:setVisible(MainProperty._ui.LoadingBar_hp, true)
        GUI:setVisible(MainProperty._ui.LoadingBar_mp, true)
        GUI:setVisible(MainProperty._ui.Image_fhp_bg, false)
        GUI:setVisible(MainProperty._ui.LoadingBar_fhp, false)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_hp, hpPer)
        GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_mp, mpPer)
    end

    -- weight
    local curWeight = SL:GetMetaValue("BW")
    local maxWeight = SL:GetMetaValue("MAXBW")
    GUI:LoadingBar_setPercent(MainProperty._ui.LoadingBar_weight, curWeight / maxWeight * 100)

    -- 刷新魔血球动画
    MainProperty.RefreshSfxShowPercent()

    -- 刷新内功相关显示
    MainProperty.OnRefreshNGShow()
end

function MainProperty.OnChangeScene( ... )
    MainProperty.OnUpdatePlayerPosition()
    MainProperty.OnDarkStateChange()
end

function MainProperty.OnUpdatePlayerPosition()
    local mapName = SL:GetMetaValue("MAP_NAME")
    local mapX = SL:GetMetaValue("X")
    local mapY = SL:GetMetaValue("Y")
    if tonumber(mapX) and tonumber(mapY) then
        GUI:Text_setString(MainProperty._ui.Text_position, string.format("%s %s:%s", mapName, mapX, mapY))
    end
end

function MainProperty.OnRefreshBubbleTips(data)
    if data.status then
        MainProperty.AddBubbleTips(data)
    else
        MainProperty.RmvBubbleTips(data)
    end
end

function MainProperty.OnPlayerPKStateChange()
    local pkMode = SL:GetMetaValue("PKMODE")
    GUI:Text_setString(MainProperty._ui.Text_pkmode, MainProperty._pkModeShow[pkMode] or "")
end

function MainProperty.OnShowOrHideAutoFightTips(status)
    if status then
        GUI:setVisible(MainProperty._nodeAutoMove, false)
        GUI:setVisible(MainProperty._nodeAutoFight, true)
    else
        GUI:setVisible(MainProperty._nodeAutoFight, false)
    end
end

function MainProperty.OnShowOrHideAutoMoveTips(status)
    if status then
        GUI:setVisible(MainProperty._nodeAutoFight, false)
        GUI:setVisible(MainProperty._nodeAutoMove, true)
    else
        GUI:setVisible(MainProperty._nodeAutoMove, false)
    end
end

function MainProperty.OnReinAttrChange()
    local point = SL:GetMetaValue("BONUSPOINT")
    local isshow = point and tonumber(point) > 0 or false
    GUI:setVisible(MainProperty._ui.btn_rein_add, isshow)
    GUI:stopAllActions(MainProperty._ui.btn_rein_add)
    if isshow then
        local icon = {"1900011003.png", "1900011007.png"}
        local blink = false
        local function playBlink()
            blink = not blink
            GUI:Button_loadTextureNormal(MainProperty._ui.btn_rein_add, MainProperty._path .. icon[blink and 2 or 1])
        end
        SL:schedule(MainProperty._ui.btn_rein_add, playBlink, 0.2)
    end
end

--------------------------- 气泡栏 -----------------------------
function MainProperty.AddBubbleTips(data)
    data.endTime = data.time and data.time + SL:GetMetaValue("SERVER_TIME")

    if MainProperty._bubbleTipsData[data.id] then
        MainProperty._bubbleTipsData[data.id] = data
        return false
    end
    MainProperty._bubbleTipsData[data.id] = data

    -- 比较优先级插入
    local insertIndex = 1
    local config = SL:GetMetaValue("BUBBLETIPS_INFO", data.id)
    local order = config and config.order or 1
    for i, cell in ipairs(MainProperty._bubbleTipsCells) do
        local cellCfg = SL:GetMetaValue("BUBBLETIPS_INFO", cell.id)
        local cellOrder = cellCfg and cellCfg.order or 1
        if order > cellOrder then
            insertIndex = i
            break
        end
    end

    local tipsCell = MainProperty.CreateBubbleTipsCell(data)
    table.insert(MainProperty._bubbleTipsCells, insertIndex, tipsCell)
    GUI:ListView_insertCustomItem(MainProperty._ui.ListView_bubble_tips, tipsCell.layout, insertIndex - 1)

    SL:PlaySound(50004)
end

function MainProperty.RmvBubbleTips(data)
    if not MainProperty._bubbleTipsData[data.id] then
        return false
    end
    MainProperty._bubbleTipsData[data.id] = nil

    local removeIdx
    for i, cell in pairs(MainProperty._bubbleTipsCells) do
        if cell.id == data.id then
            removeIdx = i
            break
        end
    end

    if removeIdx then
        local removeCell = table.remove(MainProperty._bubbleTipsCells, removeIdx)
        local index = GUI:ListView_getItemIndex(MainProperty._ui.ListView_bubble_tips, removeCell.layout)
        GUI:ListView_removeItemByIndex(MainProperty._ui.ListView_bubble_tips, index)
    end
end

-- 气泡cell
function MainProperty.CreateBubbleTipsCell(data)
    local id = data.id
    local path = data.path

    local node = GUI:Node_Create(-1, "node", 0, 0)

    local Panel_cell = GUI:Layout_Create(node, "Panel_cell", 0, 0, 50, 50)
    GUI:setTouchEnabled(Panel_cell, true)
    GUI:setAnchorPoint(Panel_cell, 0.5, 0.5)

    -- 图标
    local iconBtn = GUI:Button_Create(Panel_cell, "iconBtn", 25, 25, "Default/Button_Normal.png")
    GUI:setAnchorPoint(iconBtn, 0.5, 0.5)
    GUI:setContentSize(iconBtn, 46, 46)

    -- 倒计时
    local timeText = GUI:Text_Create(Panel_cell, "timeText", 25, 7, 16, "#FF0000", "10")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)

    GUI:removeFromParent(Panel_cell)
    if path and string.len(path) > 0 then
        GUI:Button_loadTextureNormal(iconBtn, "res/" .. path)
    else
        local config = SL:GetMetaValue("BUBBLETIPS_INFO", id)
        local path = "res/private/main/"
        local normalPath = string.format(path .. "bubble_tips/%s_1.png", config and config.img)
        local pressPath = string.format(path .. "bubble_tips/%s_2.png", config and config.img)
        GUI:Button_loadTextureNormal(iconBtn, normalPath)
        GUI:Button_loadTexturePressed(iconBtn, pressPath)
    end
    GUI:setIgnoreContentAdaptWithSize(iconBtn, true)
    GUI:addOnClickEvent(iconBtn, function()
        if data.callback then
            data.callback(Panel_cell)
        end
    end)

    -- 时间
    local function callback()
        if data.endTime then
            local remaining = data.endTime - SL:GetMetaValue("SERVER_TIME")
            GUI:Text_setString(timeText, remaining)

            if remaining <= 0 then
                GUI:stopAllActions(timeText)
                GUI:Text_setString(timeText, "")
                if data.timeOverCB then
                    data.timeOverCB()
                end
            end
        else
            GUI:Text_setString(timeText, "")
        end
    end

    SL:schedule(timeText, callback, 1)
    callback()

    GUI:Timeline_Waggle(Panel_cell, 0.05, 20)

    local cell = {
        id     = id,
        layout = Panel_cell,
        button = iconBtn
    }
    return cell
end

-- 获取气泡按钮方法
function MainProperty.GetBubbleButtonByID(id)
    for i, cell in pairs(MainProperty._bubbleTipsCells) do
        if cell.id == id then
            return cell.button
        end
    end
    return nil
end

--------------------------- 自动提示 -----------------------------
function MainProperty.InitAutoSFXTips()
    local contentSize = GUI:getContentSize(MainProperty._ui.Panel_auto_tips)
    local posX = contentSize.width / 2
    local posY = 10

    -- 自动战斗
    MainProperty._nodeAutoFight = GUI:Node_Create(MainProperty._ui.Panel_auto_tips, "nodeAutoFight", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoFight, false)
    GUI:Effect_Create(MainProperty._nodeAutoFight, "autoFightSfx", 0, 0, 0, 4009)

    -- 自动寻路
    MainProperty._nodeAutoMove = GUI:Node_Create(MainProperty._ui.Panel_auto_tips, "nodeAutoMove", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoMove, false)
    GUI:Effect_Create(MainProperty._nodeAutoMove, "autoMoveSfx", 0, 0, 0, 4010)
end

--------------------------- 自动捡物 -----------------------------
function MainProperty.InitPickButton()
    GUI:setVisible(MainProperty._ui.Button_pick, false)
    GUI:addOnClickEvent(MainProperty._ui.Button_pick, function()
        if SL:GetMetaValue("IS_PICK_STATE") then
            SL:SetMetaValue("BATTLE_PICK_END")
        else
            SL:SetMetaValue("BATTLE_PICK_BEGIN")
        end
    end)
end

function MainProperty.OnUpdatePickState()
    local name = string.format("btn_zhijiemian_%02d.png", SL:GetMetaValue("IS_PICK_STATE") and 6 or 5)
    GUI:Button_loadTextureNormal(MainProperty._ui.Button_pick, MainProperty._path .. name)
end

--------------------------- 英雄相关 -----------------------------
function MainProperty.RefAnger(value)
    local size = GUI:getContentSize(MainProperty._ui.Panel_loadBar)
    GUI:setContentSize(MainProperty._ui.Panel_loadBar, size.width, 5 + value * (MainProperty._angerHei - 5))
end

function MainProperty.OnHeroAngerChange()
    if SL:GetMetaValue("USEHERO") then
        local curAnger = SL:GetMetaValue("H.ANGER")
        local maxAnger = SL:GetMetaValue("H.MAXANGER")
        if maxAnger ~= 0 then
            MainProperty.RefAnger(curAnger / maxAnger)
        end
        if SL:GetMetaValue("H.SHAN") then
            if not MainProperty._ui.Image_loadbar2._shan then
                MainProperty._ui.Image_loadbar2._shan = true
                SL:schedule(MainProperty._ui.Image_loadbar2, function ()
                    local show = GUI:getVisible(MainProperty._ui.Image_loadbar2)
                    GUI:setVisible(MainProperty._ui.Image_loadbar2, not show)
                end, 0.2)
            end
        else
            GUI:stopAllActions(MainProperty._ui.Image_loadbar2)
            MainProperty._ui.Image_loadbar2._shan = false
            GUI:setVisible(MainProperty._ui.Image_loadbar2, false)
        end
    end
end

-- 脚本添加魔血球动画
function MainProperty.OnPlayMagicBallEffect(data)
    local prefixL = {"hp_", "mp_", "fhp_"}
    local tagList = {"HPSFX", "MPSFX", "FHPSFX"}

    if data.type < 0 or data.type > 2 or data.count < 0 or data.interval < 0 then
        return
    end
    local scale = data.scale == 0 and 1 or (data.scale / 100)
    local timeval = data.interval / 1000
    local prefix = prefixL[data.type + 1] or ""

    local ani = GUI:Animation_Create()
    local pSize = {width = 0, height = 0}
    for i = data.beginNum, data.beginNum + data.count - 1 do
        local path = string.format("res/private/mhp_ui_win32/%s%s.png", prefix, i)
        if SL:IsFileExist(path) then
            local sp = GUI:Sprite_Create(-1, "sp", 0, 0, path)
            pSize = GUI:getContentSize(sp)
            GUI:Animation_addSpriteFrame(ani, GUI:Sprite_getSpriteFrame(sp))
        end
    end
    GUI:Animation_setDelayPerUnit(ani, timeval)
    GUI:Animation_setLoops(ani, 1)
    GUI:Animation_setRestoreOriginalFrame(ani, true)

    local contentSize = {width = pSize.width * scale, height = pSize.height * scale}
    local tag = tagList[data.type + 1]
    local widget = MainProperty._ui[string.format("Panel_%ssfx", prefix)]
    local sprite
    if tag and widget then
        MainProperty._pSize[tag] = contentSize
        GUI:setContentSize(widget, contentSize.width, contentSize.height)
        if not GUI:getChildByName(widget, tag) then
            sprite = GUI:Sprite_Create(widget, tag, 0, 0)
            GUI:setScale(sprite, scale)
            GUI:runAction(sprite, GUI:ActionRepeatForever(GUI:ActionAnimate(ani)))
        end
    end

    if data.time ~= -1 and data.time > 0 then
        SL:ScheduleOnce(
            function()
                if sprite and not tolua.isnull(sprite) then
                    GUI:stopAllActions(sprite)
                    GUI:removeFromParent(sprite)
                end
            end,
            data.time
        )
    end

    GUI:setVisible(MainProperty._ui.Panel_hp_sfx, data.type ~= 2)
    GUI:setVisible(MainProperty._ui.Panel_mp_sfx, data.type ~= 2)
    GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, true)

    if data.type == 0 then -- HP
        GUI:setPosition(widget, 38 + data.offsetX, 65 + data.offsetY)
    elseif data.type == 1 then -- MP
        local hpPosX = GUI:getPositionX(MainProperty._ui.Panel_hp_sfx)
        local hpWidth = GUI:getContentSize(MainProperty._ui.Panel_hp_sfx).width
        GUI:setPosition(widget, hpPosX + hpWidth + 4 + data.offsetX, 65 + data.offsetY)
    elseif data.type == 2 then -- FHP
        GUI:setPosition(widget, 38 + data.offsetX, 65 + data.offsetY)
    end

    MainProperty._drawHWay[tag] = data.drawHWay
    if data.drawHWay and data.drawHWay == 1 then --按HP/MP真实高度绘制
        MainProperty.RefreshSfxShowPercent()
    end
end

function MainProperty.RefreshSfxShowPercent()
    --HPMP
    local curHP = SL:GetMetaValue("HP")
    local maxHP = SL:GetMetaValue("MAXHP")
    local curMP = SL:GetMetaValue("MP")
    local maxMP = SL:GetMetaValue("MAXMP")
    local hpPer = curHP / maxHP
    local mpPer = curMP / maxMP

    local roleJob = SL:GetMetaValue("JOB")
    local roleLevel = SL:GetMetaValue("LEVEL")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        if MainProperty._ui.Panel_hp_sfx and MainProperty._ui.Panel_mp_sfx then
            GUI:setVisible(MainProperty._ui.Panel_hp_sfx, false)
            GUI:setVisible(MainProperty._ui.Panel_mp_sfx, false)
            GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, true)
        end
    else
        if MainProperty._ui.Panel_hp_sfx and MainProperty._ui.Panel_mp_sfx then
            GUI:setVisible(MainProperty._ui.Panel_hp_sfx, true)
            GUI:setVisible(MainProperty._ui.Panel_mp_sfx, true)
            GUI:setVisible(MainProperty._ui.Panel_fhp_sfx, false)
        end
    end

    local prefixL = {"hp_", "mp_", "fhp_"}
    local tagList = {"HPSFX", "MPSFX", "FHPSFX"}
    for i, tag in ipairs(tagList) do
        local widget = MainProperty._ui[string.format("Panel_%ssfx", prefixL[i])]
        if widget and GUI:getChildByName(widget, tag) then
            local pSize = MainProperty._pSize[tag]
            local drawHWay = MainProperty._drawHWay[tag]
            if not pSize or (not drawHWay) or drawHWay ~= 1 then
                return
            end
            local percent = tag == "MPSFX" and mpPer or hpPer
            GUI:setContentSize(widget, pSize.width, pSize.height * percent)
        end
    end
end

--------------------------- 内功相关 ------------------------------
function MainProperty.OnRefreshNGShow()
    if SL:GetMetaValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    -- 斗转星移值
    if not MainProperty._dzPanelHei then
        MainProperty._dzPanelHei = GUI:getContentSize(MainProperty._ui.Panel_bar_dz).height
    end
    local wid = GUI:getContentSize(MainProperty._ui.Panel_bar_dz).width
    local curDZValue = SL:GetMetaValue("INTERNAL_DZ_CURVALUE")
    local maxDZValue = SL:GetMetaValue("INTERNAL_DZ_MAXVALUE")
    local per = 0
    if curDZValue and maxDZValue and maxDZValue > 0 then
        per = curDZValue / maxDZValue
    end
    GUI:setContentSize(MainProperty._ui.Panel_bar_dz, {width = wid, height = MainProperty._dzPanelHei * per})
    
    -- 醉酒值
    if not MainProperty._zjPanelHei then
        MainProperty._zjPanelHei = GUI:getContentSize(MainProperty._ui.Panel_bar_zj).height
    end
    local wid = GUI:getContentSize(MainProperty._ui.Panel_bar_zj).width
    local per = 0
    GUI:setContentSize(MainProperty._ui.Panel_bar_zj, {width = wid, height = MainProperty._zjPanelHei * per})

    MainProperty._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL")
    MainProperty.InitNGShow()
    MainProperty.OnUpdateSetComboSkill()
end

function MainProperty.OnRefreshDZShow()
    local dzPanel = MainProperty._ui.Panel_dz
    if dzPanel then
        if SL:GetMetaValue("SKILL_DATA", MainProperty._dzSkillID) then
            GUI:setVisible(dzPanel, MainProperty._NGShow and true)
        else
            GUI:setVisible(dzPanel, false)
        end
    end
end

-- 连击可释放
function MainProperty.OnRefreshComboShow(state)
    GUI:stopAllActions(MainProperty._ui.Image_ng_shan)
    GUI:setVisible(MainProperty._ui.Image_ng_shan, state)
    if state then
        local icon = {"01121.png", "01122.png"}
        local blink = false
        local function playBlink()
            blink = not blink
            GUI:Image_loadTexture(MainProperty._ui.Image_ng_shan, MainProperty._path .. icon[blink and 2 or 1])
        end
        SL:schedule(MainProperty._ui.Image_ng_shan, playBlink, 0.2)
    end
end

function MainProperty.OnActiveComboSkill(state)
    if MainProperty._NGShow then 
        local selectSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
        if selectSkills[1] then
            MainProperty.OnRefreshComboShow(state)
        end
    end
end

function MainProperty.OnUpdateSetComboSkill()
    if MainProperty._NGShow then
        local selectSkills = SL:GetMetaValue("SET_COMBO_SKILLS")
        if selectSkills[1] then
            MainProperty.OnRefreshComboShow(true)
        else
            GUI:stopAllActions(MainProperty._ui.Image_ng_shan)
            GUI:setVisible(MainProperty._ui.Image_ng_shan, false)
        end
    end
end

--------------------------- 掉落分类 ------------------------------
function MainProperty.CreateDropSwitchCell(id)
    local widget = GUI:Widget_Create(-1, "Widget_" .. id, 0, 0, 0, 0)
    GUI:LoadExport(widget, "main/drop_switch_cell_win32")
    local cell = GUI:getChildByName(widget, "Panel_cell")

    local checkBox = GUI:getChildByName(cell, "CheckBox_drop")
    local nameText = GUI:getChildByName(cell, "Text_drop_name")
    GUI:CheckBox_setZoomScale(checkBox, -0.05)

    local data = {
        layout = cell,
        nameText = nameText,
        checkBox = checkBox
    }
    cell:removeFromParent()
    return data
end

function MainProperty.ShowDropSwitchPanel()
    local num = #MainProperty._dropTypeList
    if num == 0 then
        return
    end
    local worldPos = GUI:getWorldPosition(MainProperty._ui.Button_drop)
    local nodePos = GUI:convertToNodeSpace(MainProperty._ui.Node, worldPos.x, worldPos.y)
    GUI:setPosition(MainProperty._ui.Panel_drop, nodePos.x, nodePos.y + 10)
    GUI:setVisible(MainProperty._ui.Panel_drop, true)
    GUI:setVisible(MainProperty._ui.Panel_hide_drop, true)
    GUI:setTouchEnabled(MainProperty._ui.Panel_hide_drop, true)

    GUI:ListView_removeAllItems(MainProperty._ui.ListView_drop)

    local cellWid = nil
    local cellHei = nil
    for _, data in ipairs(MainProperty._dropTypeList) do
        local id = data.id
        local defaultName = nil
        if string.len(data.name) == 0 then
            defaultName = id == FAKE_DROP_TYPE_ID and "分类0" or ("分类" .. id)
        end
        local name = defaultName or data.name
        local cell = MainProperty.CreateDropSwitchCell(id)
        local isReceiving = SL:GetMetaValue("DROP_TYPE_ISRECEIVE", id)
        GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
        GUI:Text_setString(cell.nameText, name)
        local nameWid = GUI:getContentSize(cell.nameText).width
        local posX = GUI:getPositionX(cell.nameText)

        -- 接收开关
        GUI:CheckBox_addOnEvent(cell.checkBox, function()
            local isSelected = GUI:CheckBox_isSelected(cell.checkBox)
            if id == DROP_TOTAL_TYPE_ID then
                for channel, cell in pairs(MainProperty._dropTypeCells) do
                    SL:SetMetaValue("DROP_TYPE_ISRECEIVE", channel, isSelected)
                end
            else
                SL:SetMetaValue("DROP_TYPE_ISRECEIVE", id, isSelected)
            end
            for channel, cell in pairs(MainProperty._dropTypeCells) do
                local isReceiving = SL:GetMetaValue("DROP_TYPE_ISRECEIVE", channel)
                GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                if channel == DROP_TOTAL_TYPE_ID then
                    SL:SetMetaValue("CHAT_CHANNEL_RECEIVIND", CHANNEL.Drop, isReceiving)
                end
            end
        end)

        local tempWid = posX + nameWid + 8
        if not cellWid or not cellHei then
            cellWid = math.max(tempWid, GUI:getContentSize(cell.layout).height)
            cellHei = GUI:getContentSize(cell.layout).height
        else
            cellWid = math.max(tempWid, cellWid)
        end

        MainProperty._dropTypeCells[id] = cell
        GUI:ListView_pushBackCustomItem(MainProperty._ui.ListView_drop, cell.layout)
    end

    
    local listWid = cellWid
    local listHei = cellHei * num
    GUI:setContentSize(MainProperty._ui.ListView_drop, listWid, listHei)
    GUI:setContentSize(MainProperty._ui.Panel_drop, listWid + 2, listHei + 6)
    GUI:setContentSize(MainProperty._ui.Image_drop_bg, listWid + 2, listHei + 6)
    GUI:setPosition(MainProperty._ui.Image_drop_bg, (listWid + 2) / 2, (listHei + 6) / 2)
end

function MainProperty.HideDropSwitchPanel()
    GUI:setVisible(MainProperty._ui.Panel_drop, false)
    GUI:setVisible(MainProperty._ui.Panel_hide_drop, false)
    GUI:setTouchEnabled(MainProperty._ui.Panel_hide_drop, false)
end

function MainProperty.RefreshFakeDropType()
    local needRefresh = false
    local hasFake = false
    for i, v in ipairs(MainProperty._dropTypeList) do
        if v.id == FAKE_DROP_TYPE_ID then
            if SL:GetMetaValue("IS_CLOSE_FAKEDROP") then
                table.remove(MainProperty._dropTypeList, i)
                needRefresh = true
            end
            hasFake = true
            break
        end
    end

    if not SL:GetMetaValue("IS_CLOSE_FAKEDROP") and not hasFake then
        local fakeDrop = SL:GetMetaValue("GAME_DATA", "ShowFakeDropType")
        if fakeDrop and string.len(fakeDrop) > 0 then
            local param = string.split(fakeDrop, "#")
            if param[2] and tonumber(param[2]) == 1 then
                table.insert(MainProperty._dropTypeList, 2, {id = FAKE_DROP_TYPE_ID, name = param[1]})
                needRefresh = true
            end
        end
    end

    if needRefresh then
        MainProperty.HideDropSwitchPanel()
    end
end


