MainProperty = {}

MainProperty._path = "res/private/main-win32/"

-- 斗转星移技能ID
local DZXY_SkillID         = 118

-- 醉酒相关是否显示
local ON_OFF_zuijiu        = false

local DROP_TOTAL_TYPE_ID   = 99

local PCShowSelectChannels =  SL:GetValue("GAME_DATA","PCShowSelectChannels")

local CHANNEL = GUIDefine.ChatChannel

-- 对应选择频道名
local CHANNEL_NAME = {
    [CHANNEL.SHOUT]  = "喊 话",
    [CHANNEL.GUILD]  = "行 会",
    [CHANNEL.TEAM]   = "组 队",
    [CHANNEL.NEAR]   = "附 近",
    [CHANNEL.WORLD]  = "世 界",
    [CHANNEL.NATION] = "国 家",
    [CHANNEL.UNION]  = "联 盟",
    [CHANNEL.CROSS]  = "跨 服",
}

local PKType = GUIDefine.PKModeType
MainProperty._showPKTab = {PKType.HAM_ALL, PKType.HAM_PEACE, PKType.HAM_GROUP, PKType.HAM_GUILD, PKType.HAM_SHANE, PKType.HAM_NATION, PKType.HAM_CAMP}
MainProperty._pkModeStrList = {
    [PKType.HAM_ALL]    = "[全体攻击模式]",
    [PKType.HAM_PEACE]  = "[和平攻击模式]",
    [PKType.HAM_GROUP]  = "[编组攻击模式]",
    [PKType.HAM_GUILD]  = "[行会攻击模式]",
    [PKType.HAM_SHANE]  = "[善恶攻击模式]",
    [PKType.HAM_NATION] = "[国家攻击模式]",
    [PKType.HAM_CAMP]   = "[阵营攻击模式]",
    [PKType.HAM_SERVER] = "[区服攻击模式]"
}

local DarkState = GUIDefine.DarkState or {}
MainProperty._darkImgList = {
    [DarkState.DAYTIME or 0]    = "00000044.png",   -- 白天
    [DarkState.NIGHT or 1]      = "00000046.png",   -- 晚上
    [DarkState.SUNRISE or 2]    = "00000045.png",   -- 日出
    [DarkState.EVENING or 3]    = "00000047.png"    -- 傍晚
}

MainProperty._mhpPrefixList     = {"hp_", "mp_", "fhp_"}
MainProperty._mhpTagList        = {"HPSFX", "MPSFX", "FHPSFX"}

MainProperty._quitTimeTips = {
    [1] = "<outline size='1'><font color = '#00ff00'>%s秒后将返回选角界面</font></outline>",
    [2] = "<outline size='1'><font color = '#ff0000'>%s秒后将退出游戏</font></outline>",
}

local reinAddIcons      = {"1900011003.png", "1900011007.png"}
local comboShowIcons    = {"01121.png", "01122.png"}

MainProperty._ChatItemWidth = 500

function MainProperty.Init()
    MainProperty._bubbleTipsDatas = {}  -- 气泡数据
    MainProperty._bubbleTipsCells = {}

    MainProperty._quickUseCells   = {}

    MainProperty._chatCellCache   = {}
    MainProperty._isScrolling     = false

    MainProperty._pSize           = {}
    MainProperty._drawHWay        = {}  -- 绘制方式

    MainProperty._dropTypeList    = {}
    MainProperty._dropTypeCells   = {}

    MainProperty._inputIndex      = 0
    MainProperty._inputCache      = {}

    MainProperty._channelCells    = {}

    MainProperty._channelSelect   = nil

    MainProperty._exCellHei       = 12

    -- 聊天间隔
    local values = GUIDefineEx.ChatContentInterval
    MainProperty._listInterval, MainProperty._richVspace = values.listInterval, values.richVspace or 0

    MainProperty._NGShow   = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")
    MainProperty._angerHei = GUI:getContentSize(MainProperty._ui["Panel_loadBar"]).height
end

function MainProperty.main()
    local parent = GUI:Attach_Center()
    GUI:LoadExport(parent, "main/main_property_win32")

    MainProperty._root = GUI:getChildByName(parent, "Main_Property")
    MainProperty._ui = GUI:ui_delegate(MainProperty._root)
    if not MainProperty._ui then
        return false
    end

    MainProperty.Init()
    MainProperty.InitDropData()
    MainProperty.InitCustomPKMode()

    MainProperty.InitHPPanel()
    MainProperty.InitAutoShout()
    MainProperty.InitActPanel()
    MainProperty.InitChatPanel()
    MainProperty.InitKeyBoardEvent()
    MainProperty.InitChatInputHandler()
    MainProperty.InitAutoSFXTips()
    MainProperty.InitPickButton()
    MainProperty.InitQuickUseShow()

    -- 转生属性点分配页
    GUI:addOnClickEvent(MainProperty._ui["btn_rein_add"], function()
        if not GUI:GetWindow(nil, UIConst.LAYERID.ReinAttrGUI) then
            if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
                SL:CheckOpenLayer(SLDefine.HyperLinkID.ReinAttrPoint)
            else
                SL:JumpTo(SLDefine.HyperLinkID.ReinAttrPoint)
            end
            SL:PlayBtnClickAudio()
        end
    end)

    MainProperty.OnRefreshPropertyShow()
    MainProperty.OnUpdatePlayerPosition()
    MainProperty.OnDarkStateChange()

    MainProperty.AfterCUILoadFunc()

    MainProperty.RegisterEvent()
    
    GUI:RefPosByParent(MainProperty._root)
    SL:AttachTXTSUI({root = MainProperty._ui["Panel_chat_funcs"], index = SLDefine.SUIComponentTable.PCMainPropertyFuncs})
end

function MainProperty.AfterCUILoadFunc()
    MainProperty.InitAdapet()
    MainProperty.InitQuickUseItems()
end

function MainProperty.InitDropData()
    local dropTotalData = {
        id = DROP_TOTAL_TYPE_ID,
        name = "全部",
    }
    table.insert(MainProperty._dropTypeList, dropTotalData)

    local data = SL:GetValue("GAME_DATA", "DropTypeShow")
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

function MainProperty.InitCustomPKMode()
    local typeList = SL:GetValue("RELATION_TYPE_LIST")
    if typeList and next(typeList) then
        for _, modeId in ipairs(typeList) do
            local config = SL:GetValue("RELATION_TYPE_CONFIG", modeId)
            table.insert(MainProperty._showPKTab, modeId)
            MainProperty._pkModeStrList[modeId] = string.format("[%s攻击模式]" , config and config.mode_name or "")
        end
    end
end

function MainProperty.InitAdapet()
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    GUI:setPositionX(MainProperty._root, screenW / 2)
    
    local notAdapet = tonumber(SL:GetValue("GAME_DATA", "PCPropertyNotAdapet")) == 1
    local contentWidth = GUI:getContentSize(MainProperty._ui["Panel_chat"]).width
    if notAdapet then
        MainProperty._ChatItemWidth = GUI:getContentSize(MainProperty._ui["ListView_chat"]).width

        local sizeW = PCShowSelectChannels and GUI:getContentSize(MainProperty._ui["Button_channel"]).width or 0
        local TextField_input = MainProperty._ui["TextField_input"]
        GUI:setPositionX(TextField_input, 14 + sizeW)
        GUI:setContentSize(TextField_input, MainProperty._ChatItemWidth - sizeW, GUI:getContentSize(TextField_input).height)

        return
    end
    
    GUI:setContentSize(MainProperty._ui["Panel_bg"], screenW, screenH)
    GUI:setContentSize(MainProperty._ui["Panel_hide_drop"], screenW, screenH)

    GUI:setPosition(MainProperty._ui["Panel_hp"], 0, 0)
    GUI:setPosition(MainProperty._ui["Panel_act"], screenW, 0)
    local hpPanelWid = GUI:getContentSize(MainProperty._ui["Panel_hp"]).width
    local actPanelWid = GUI:getContentSize(MainProperty._ui["Panel_act"]).width
    
    contentWidth = screenW - hpPanelWid - actPanelWid
    local offsetX = math.floor((hpPanelWid - actPanelWid) / 2)

    local Panel_chat = MainProperty._ui["Panel_chat"]
    GUI:setPositionX(Panel_chat, screenW / 2 + offsetX)
    GUI:setContentSize(Panel_chat, contentWidth, GUI:getContentSize(Panel_chat).height)

    local Image_chat_bg = MainProperty._ui["Image_chat_bg"]
    GUI:setPositionX(Image_chat_bg, contentWidth / 2)
    GUI:setContentSize(Image_chat_bg, contentWidth, GUI:getContentSize(Image_chat_bg).height)

    local Panel_chat_touch = MainProperty._ui["Panel_chat_touch"]
    GUI:setPositionX(Panel_chat_touch, contentWidth / 2)
    GUI:setContentSize(Panel_chat_touch, contentWidth, GUI:getContentSize(Panel_chat_touch).height)

    local ListView_chat = MainProperty._ui["ListView_chat"]
    local chatListWid = contentWidth - 28
    GUI:setPositionX(ListView_chat, contentWidth / 2)
    GUI:setContentSize(ListView_chat, chatListWid, GUI:getContentSize(ListView_chat).height)

    local ListView_chat_ex = MainProperty._ui["ListView_chat_ex"]
    GUI:setPositionX(ListView_chat_ex, contentWidth / 2)
    GUI:setContentSize(ListView_chat_ex, chatListWid, GUI:getContentSize(ListView_chat_ex).height)

    local sizeW = PCShowSelectChannels and GUI:getContentSize(MainProperty._ui["Button_channel"]).width or 0
    local TextField_input = MainProperty._ui["TextField_input"]
    GUI:setPositionX(TextField_input, 14 + sizeW)
    GUI:setContentSize(TextField_input, chatListWid - sizeW, GUI:getContentSize(TextField_input).height)

    GUI:setPositionX(MainProperty._ui["Panel_exit_funcs"], contentWidth - 8)

    MainProperty._ChatItemWidth = chatListWid
end

function MainProperty.InitHPPanel()
    local iconPaths = {
        [1] = {"190001100.png", "190001101.png"}, -- 系统频道
        [2] = {"190001108.png", "190001109.png"}, -- 喊话
        [3] = {"190001104.png", "190001105.png"}, -- 私聊
        [4] = {"190001106.png", "190001107.png"}, -- 行会
        [7] = {"190001102.png", "190001103.png"}, -- 世界
    }

    local function mainSetReceiving(channel, sender)
        if not channel or not sender then
            return
        end
        
        local isReceiving = ChatData.IsReceiving(channel)
        ChatData.SetReceiving(channel, not isReceiving)
        local path = ChatData.IsReceiving(channel) and iconPaths[channel][1] or iconPaths[channel][2]
        GUI:Button_loadTextureNormal(sender, MainProperty._path .. path)
        GUI:Button_loadTexturePressed(sender, MainProperty._path .. path)
        SL:PlayBtnClickAudio()
    end

    -- 频道接收开关
    -- 系统
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_1"], function(sender)
        mainSetReceiving(1, sender)
    end)

    -- 世界
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_2"], function(sender)
        mainSetReceiving(7, sender)
    end)

    -- 私聊
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_3"], function(sender)
        mainSetReceiving(3, sender)
    end)

    -- 行会
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_4"], function(sender)
        mainSetReceiving(4, sender)
    end)

    -- 喊话
    GUI:addOnClickEvent(MainProperty._ui["Button_chat_5"], function(sender)
        mainSetReceiving(2, sender)
    end)

    -- 自动喊话开关

    -- 鼠标移入Tips
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_1"], "允许所有系统信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_2"], "允许所有传音信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_3"], "允许所有私聊信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_4"], "允许行会聊天信息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_5"], "允许所有喊话消息", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_6"], "特殊命令", {x = -10, y = -20}, {x = 1, y = 0.5})
    GUI:addMouseOverTips(MainProperty._ui["Button_chat_7"], "自动喊话开关", {x = -10, y = -20}, {x = 1, y = 0.5})

    if tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 then
        GUI:addMouseOverTips(MainProperty._ui["Panel_dz"], function ()
            local curDZValue = SL:GetValue("CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
            local maxDZValue = SL:GetValue("MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
            return string.format("斗转星移值: %s/%s", curDZValue, maxDZValue)
        end, {x = 0, y = 0}, {x = 0.5, y = 0.5})
        GUI:addMouseOverTips(MainProperty._ui["Panel_zj"], string.format("醉酒值: %s%%", 0), {x = 0, y = 0}, {x = 0.5, y = 0.5})
    end

    MainProperty.InitNGShow()
end

function MainProperty.InitAutoShout()
    local btnAutoShout = MainProperty._ui["Button_chat_7"]
    if not btnAutoShout then
        return false
    end

    local isAutoShout = ChatData.GetAutoShoutSwitch()

    -- 自动喊话开关
    local function sendAutoShoutMsg(input, channel)
        if not channel or not GUIFunction:CheckAbleToSayByChannel(channel) then
            return
        end

        local sendData = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = channel, risk = 0, oriMsg = input, status = 0}
        GUIFunction:SendChatMsg(sendData)
    end

    local autoShoutCallback = function(shoutInput)
        GUI:stopActionByTag(btnAutoShout, 888)

        if not shoutInput or shoutInput == "" then
            return false
        end

        if not ChatData.GetAutoShoutSwitch() then
            return false
        end

        local action = SL:schedule(btnAutoShout, function()
            -- 发送
            sendAutoShoutMsg(shoutInput, CHANNEL.SHOUT)
        end, ChatData.GetAutoShoutDelay())

        GUI:setTag(action, 888)
    end

    local picPath = string.format("%s/%s", MainProperty._path, isAutoShout and "190001112.png" or "190001113.png") 
    GUI:Button_loadTextureNormal(btnAutoShout, picPath)
    GUI:Button_loadTexturePressed(btnAutoShout, picPath)

    if isAutoShout then
        local shoutInput = ChatData.GetLocalChatDataByChannel(CHANNEL.SHOUT)
        autoShoutCallback(shoutInput)
    end

    local function checkInputContent(inputStr)
        local channel = CHANNEL.Shout
        SL:RequestCheckSensitiveWord(inputStr, 2, function(state, str, risk_param, ex_param) 
            -- 检测，不通过
            if not state then
                SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                return
            end

            if risk_param and risk_param ~= 0 then
                SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                return
            end

            if ex_param then
                if ex_param.status and ex_param.status ~= 0 then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    return
                end
            end

            ChatData.SetAutoShoutSwitch(not ChatData.GetAutoShoutSwitch())

            -- 记录自动喊话内容
            ChatData.SetLocalChatDataByChannel(channel, inputStr or "")
            autoShoutCallback(inputStr)

            -- 发送提示
            local isOpen = ChatData.GetAutoShoutSwitch()
            local msg = isOpen and "启动了自动喊话功能，聊天框中内容已记录为喊话内容" or "关闭了自动喊话功能"
            SL:ShowSystemChat(msg, 0, 255)
            SL:PlayBtnClickAudio()

            local picPath = string.format("%s/%s", MainProperty._path, isOpen and "190001112.png" or "190001113.png") 
            GUI:Button_loadTextureNormal(btnAutoShout, picPath)
            GUI:Button_loadTexturePressed(btnAutoShout, picPath)
            if isOpen then
                if inputStr == "" then
                    return
                end
                sendAutoShoutMsg(inputStr, CHANNEL.SHOUT)
            end
        end, {channel_id = channel})
    end

    GUI:addOnClickEvent(btnAutoShout, function(sender)
        local input = GUI:Text_getString(MainProperty._ui["TextField_input"])
        checkInputContent(input)
    end)
end

function MainProperty.InitNGShow()
    if SL:GetValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    MainProperty.OnRefreshDZShow()
    GUI:setVisible(MainProperty._ui["Panel_zj"], ON_OFF_zuijiu)
    GUI:setVisible(MainProperty._ui["Panel_ng_show"], MainProperty._NGShow)

    if MainProperty._NGShow then
        local pSize = GUI:getContentSize(MainProperty._ui["Panel_loadBar"])
        local curHeiPer = pSize.height / MainProperty._angerHei
        MainProperty._angerHei = 136
        GUI:setContentSize(MainProperty._ui["Image_laodBarbg"], GUI:getContentSize(MainProperty._ui["Image_laodBarbg"]).width, MainProperty._angerHei)
        GUI:setContentSize(MainProperty._ui["Panel_loadBar"], pSize.width, math.floor(MainProperty._angerHei * curHeiPer))
        GUI:setContentSize(MainProperty._ui["Image_loadbar1"], GUI:getContentSize(MainProperty._ui["Image_loadbar1"]).width, MainProperty._angerHei)
        GUI:setContentSize(MainProperty._ui["Image_loadbar2"], GUI:getContentSize(MainProperty._ui["Image_loadbar2"]).width, MainProperty._angerHei)
    end
end

function MainProperty.InitActPanel()
    -- 英雄相关
    if SL:GetValue("USEHERO") then
        GUI:setVisible(MainProperty._ui["Image_loadbar2"], false)
        MainProperty.RefAnger(0)

        GUI:delayTouchEnabled(MainProperty._ui["Button_herostate"], 0.5)
        GUI:addOnClickEvent(MainProperty._ui["Button_herostate"], function(sender)
            GUI:delayTouchEnabled(sender)
            SL:RequestCallOrOutHero()
        end)
        GUI:addMouseOverTips(MainProperty._ui["Button_herostate"], "召唤英雄", {x = -20, y = 0}, {x = 0.5, y = 0.5})

        GUI:addOnClickEvent(MainProperty._ui["Button_heroinfo"], function()
            if SL:GetValue("HERO_IS_ALIVE") then
                -- 打开英雄角色面板
                UIOperator:OpenMyHeroUI()
            end
        end)
        GUI:addMouseOverTips(MainProperty._ui["Button_heroinfo"], "英雄状态", {x = 0, y = 0}, {x = 0.5, y = 0.5})

        GUI:delayTouchEnabled(MainProperty._ui["Button_herobag"], 0.5)
        GUI:addOnClickEvent(MainProperty._ui["Button_herobag"], function()
            if SL:GetValue("HERO_IS_ALIVE") then
                -- 打开英雄背包
                UIOperator:OpenHeroBagUI()
            end
        end)
        GUI:addMouseOverTips(MainProperty._ui["Button_herobag"], "英雄包裹", {x = 20, y = 0}, {x = 0.5, y = 0.5})
    else
        GUI:setVisible(MainProperty._ui["Image_laodBarbg"], false)
        GUI:setVisible(MainProperty._ui["Button_herostate"], false)
        GUI:setVisible(MainProperty._ui["Button_heroinfo"], false)
        GUI:setVisible(MainProperty._ui["Button_herobag"], false)
        GUI:setPositionY(MainProperty._ui["Text_pkmode"], GUI:getPositionY(MainProperty._ui["Text_pkmode"]) + 10)
    end

    -- 功能按钮
    -- 角色
    GUI:addOnClickEvent(MainProperty._ui["Button_role"], function()
        local isOpen = (PlayerFrame and PlayerFrame.IsReOpen) and PlayerFrame:IsReOpen(UIConst.LayerTable.PlayerEquip)
        if isOpen and GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI) then
            UIOperator:CloseMyPlayerUI()
        else
            UIOperator:OpenMyPlayerUI({page = UIConst.LayerTable.PlayerEquip}) 
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_role"], "状态信息(F10)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 背包
    GUI:addOnClickEvent(MainProperty._ui["Button_bag"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Bag)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Bag)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_bag"], "包裹物品(F9)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 技能
    GUI:addOnClickEvent(MainProperty._ui["Button_skill"], function()
        local isOpen = (PlayerFrame and PlayerFrame.IsReOpen) and PlayerFrame:IsReOpen(UIConst.LayerTable.PlayerSkill)
        if isOpen and GUI:GetWindow(nil, UIConst.LAYERID.PlayerMainGUI) then
            UIOperator:CloseMyPlayerUI()
        else
            UIOperator:OpenMyPlayerUI({page = UIConst.LayerTable.PlayerSkill}) 
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_skill"], "技能信息(F11)", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 音效
    GUI:addOnClickEvent(MainProperty._ui["Button_voice"], function()
        local value27 = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_BGMUSIC) or 0
        local value52 = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_EFFECTMUSIC) or 0
        local enable = value27 > 0 and value52 > 0
        SL:SetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_BGMUSIC, { enable and 0 or 100 })
        SL:SetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_EFFECTMUSIC, { enable and 0 or 100 })
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_voice"], "音效开关", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 商店
    GUI:addOnClickEvent(MainProperty._ui["Button_store"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.StoreHot)
        else
            SL:JumpTo(SLDefine.HyperLinkID.StoreHot)
        end
        SL:PlayBtnClickAudio()
    end)

    -- pk模式切换
    local function changePKMode()
        GUI:delayTouchEnabled(MainProperty._ui["Text_pkmode"])

        local canMode = {}
        for _, v in ipairs(MainProperty._showPKTab) do
            if SL:GetValue("PKMODE_CAN_USE", v) then
                table.insert(canMode, v)
            end
        end
        local function getPKModeIndex(pkm)
            for k, v in ipairs(canMode) do
                if pkm == v then
                    return k
                end
            end
            return 1
        end
        local curPKMode = SL:GetValue("PKMODE")
        local index = getPKModeIndex(curPKMode)
        local nextPKMode = canMode[(index >= #canMode and 1 or index + 1)]
        SL:RequestChangePKMode(nextPKMode)
    end
    GUI:addOnClickEvent(MainProperty._ui["Text_pkmode"], changePKMode)
    GUI:addMouseOverTips(MainProperty._ui["Text_pkmode"], "点击切换", {x = 0, y = 0}, {x = 0.7, y = 0.5})

    -- 时钟
    local function callback()
        local date = os.date("*t", SL:GetValue("SERVER_TIME"))
        GUI:Text_setString(MainProperty._ui["Text_time"], string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    -- FPS 帧率
    local sumFps = 0
    local count = 0
    SL:Schedule(
        function()
            sumFps = sumFps + SL:GetValue("FPS")
            count = count + 1
        end,
        0
    )
    SL:Schedule(
        function()
            local fps = math.min(math.ceil(sumFps / count), 60)
            GUI:Text_setString(MainProperty._ui["Text_FPS"], string.format("FPS:%s", fps))
            sumFps = 0
            count = 0
        end,
        0.5
    )

    GUI:addMouseOverTips(
        MainProperty._ui["Text_level"],
        function ()
            return string.format("当前等级：%s", SL:GetValue("LEVEL"))
        end,
        {x = 0, y = -20},
        {x = 0.1, y = 0.5}
    )
    GUI:addMouseOverTips(
        MainProperty._ui["LoadingBar_exp"],
        function()
            local curExp = SL:GetValue("EXP")
            local maxExp = math.max(SL:GetValue("MAXEXP"), 1)
            local per = math.min(curExp / maxExp * 100, 100)
            return string.format("当前经验：%.2f%%", per)
        end,
        {x = 0, y = 0},
        {x = 0.3, y = 0.5}
    )
    GUI:addMouseOverTips(
        MainProperty._ui["LoadingBar_weight"],
        function()
            local curWeight = SL:GetValue("BW")
            local maxWeight = SL:GetValue("MAXBW")
            return string.format("包裹负重：%s/%s", curWeight, maxWeight)
        end,
        {x = 0, y = 0},
        {x = 0.3, y = 0.5}
    )
end

-- 监听聊天输入框
function MainProperty.InitChatInputHandler()
    local TextField_input = MainProperty._ui["TextField_input"]
    TextField_input._lastInput = ""

    local touchEvent = function (sender, eventype)
        if eventype == 2 then
            GUI:TextInput_touchDownAction(TextField_input, 2)
        end
    end
    GUI:addOnTouchEvent(TextField_input, touchEvent)

    local inputEvent = function (sender, eventType)
        if eventType == GUIDefine.TextInputEventType.SEND then
            if string.len(GUI:Text_getString(MainProperty._ui["TextField_input"])) > 0 then
                MainProperty.SendChatMsg()
            end
        elseif eventType == GUIDefine.TextInputEventType.BEGAN or eventType == GUIDefine.TextInputEventType.CHANGE then
            local str = GUI:Text_getString(sender)
            local target = ChatData.GetTargets()[1]
            if sender._lastInput == "" and str == "/" and target then
                MainProperty.OnPrivateChatWithTarget(target)
            end
            sender._lastInput = str
        end
    end
    GUI:TextInput_addOnEvent(TextField_input, inputEvent)
end

function MainProperty.InitKeyBoardEvent()
    GUI:addKeyboardEvent({"KEY_SHIFT", "KEY_1"}, function()
        GUI:Text_setString(MainProperty._ui["TextField_input"], "!")
        GUI:TextInput_touchDownAction(MainProperty._ui["TextField_input"], 2)
    end)

    GUI:addKeyboardEvent({"KEY_SHIFT", "KEY_2"}, function()
        GUI:Text_setString(MainProperty._ui["TextField_input"], "@")
        GUI:TextInput_touchDownAction(MainProperty._ui["TextField_input"], 2)
    end)

    GUI:addKeyboardEvent({"KEY_SHIFT", "KEY_3"}, function()
        GUI:Text_setString(MainProperty._ui["TextField_input"], "#")
        GUI:TextInput_touchDownAction(MainProperty._ui["TextField_input"], 2)
    end)

    GUI:addKeyboardEvent("KEY_SLASH", function()
        GUI:Text_setString(MainProperty._ui["TextField_input"], "/")
        GUI:TextInput_touchDownAction(MainProperty._ui["TextField_input"], 2)
    end)

    -- control ↑
    local function callback()
        MainProperty._inputIndex = MainProperty._inputIndex > 1 and MainProperty._inputIndex - 1 or MainProperty._inputIndex
        local input = MainProperty._inputCache[MainProperty._inputIndex]
        if not input then
            return false
        end
        GUI:Text_setString(MainProperty._ui["TextField_input"], input)
    end
    GUI:addKeyboardEvent({"KEY_CTRL", "KEY_UP_ARROW"}, callback)
    GUI:addKeyboardEvent({"KEY_RIGHT_CTRL", "KEY_UP_ARROW"}, callback)

    -- control ↓
    local function callback()
        MainProperty._inputIndex = MainProperty._inputIndex < #MainProperty._inputCache and MainProperty._inputIndex + 1 or MainProperty._inputIndex
        local input = MainProperty._inputCache[MainProperty._inputIndex]
        if not input then
            return false
        end
        GUI:Text_setString(MainProperty._ui["TextField_input"], input)
    end
    GUI:addKeyboardEvent({"KEY_CTRL", "KEY_DOWN_ARROW"}, callback)
    GUI:addKeyboardEvent({"KEY_RIGHT_CTRL", "KEY_DOWN_ARROW"}, callback)
end

----------------------------- 聊天相关 -------------------------------------------------------
-- 聊天框的宽
function MainProperty.GetChatWidth()
    return MainProperty._ChatItemWidth
end

function MainProperty.InitChatPanel()
    if MainProperty._listInterval then
        GUI:ListView_setItemsMargin(MainProperty._ui["ListView_chat"], MainProperty._listInterval)
        GUI:ListView_setItemsMargin(MainProperty._ui["ListView_chat_ex"], MainProperty._listInterval)
    end

    -- 拖动
    local function listCallback(sender, eventType)
        if eventType == 9 or eventType == 10 then
            local innerPos = GUI:ListView_getInnerContainerPosition(MainProperty._ui["ListView_chat"])
            if innerPos.y == 0 and MainProperty._isScrolling then
                MainProperty._isScrolling = false
                MainProperty.ShowChatCache()
            end
        end
    end
    GUI:ListView_addOnScrollEvent(MainProperty._ui["ListView_chat"], listCallback)
    GUI:ListView_addMouseScrollPercent(MainProperty._ui["ListView_chat"])

    -- 频道切换开关开启
    local isOpen = SL:GetValue("GAME_DATA", "PCSwitchChannelShow") and SL:GetValue("GAME_DATA", "PCSwitchChannelShow") == 1 
    GUI:setVisible(MainProperty._ui["Panel_channel"], isOpen)

    local receiveChannel = ChatData.GetReceiveChannel()
    local strs = {
        [0] = "综合",
        [1] = "系统",
        [2] = "喊话",
        [3] = "私聊",
        [4] = "行会",
        [5] = "组队",
        [6] = "附近",
        [7] = "世界",
        [8] = "国家",
    }

    for i = 0, 8 do
        local btnChannel = MainProperty._ui["Button_channel_" .. i]
        if btnChannel then
            GUI:Button_setBright(btnChannel, i ~= receiveChannel)
            GUI:setTouchEnabled(btnChannel, i ~= receiveChannel)
            GUI:addOnClickEvent(btnChannel, function()
                ChatData.SetReceiveChannel(i)
                MainProperty.UpdateReceiving()
            end)
            if isOpen then
                GUI:addMouseOverTips(btnChannel, strs[i], {x = -10, y = -20}, {x = 1, y = 0.5})
            end
        end
    end
    
    GUI:setVisible(MainProperty._ui["Button_channel"], PCShowSelectChannels and true or false)
    GUI:addOnClickEvent(MainProperty._ui["Button_channel"], function ()
        if GUI:getVisible(MainProperty._ui["Panel_channel_s"]) then
            MainProperty.HideChannels()
        else
            MainProperty.ShowChannels()
        end
    end)

    if PCShowSelectChannels then
        MainProperty._channelSelect = ChatData.GetCurChannel()
        local name = MainProperty._channelSelect and CHANNEL_NAME[MainProperty._channelSelect]
        if name and MainProperty._ui["Text_channel"] then
            GUI:Text_setString(MainProperty._ui["Text_channel"], name)
        end
    end

    MainProperty.HideChannels()

    -- 地图
    GUI:addOnClickEvent(MainProperty._ui["Button_map"], function()
        if MainMiniMap.OnTabKeyExchange then
            MainMiniMap.OnTabKeyExchange()
        end

        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_map"], "小地图(Tab)", { x = 0, y = 0 })

    -- 交易
    GUI:addOnClickEvent(MainProperty._ui["Button_trade"], function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestTrade()
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_trade"], "交易(T)", { x = 0, y = 0 })

    -- 服务端交易开关
    local tradeAble = SL:GetValue("SERVER_OPTION", SW_KEY_TRADE_DEAL) == true
    GUI:setVisible(MainProperty._ui["Button_trade"], tradeAble)
    if not tradeAble then
        GUI:setPositionX(MainProperty._ui["Button_guild"], 41)
        GUI:setPositionX(MainProperty._ui["Button_near"], 68)
        GUI:setPositionX(MainProperty._ui["Button_rank"], 95)
        GUI:setPositionX(MainProperty._ui["Button_private"], 122)
        GUI:setPositionX(MainProperty._ui["Button_drop"], 149)
        GUI:setPositionX(MainProperty._ui["btn_rein_add"], 176)
    end

    -- 行会
    GUI:addOnClickEvent(MainProperty._ui["Button_guild"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Guild)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Guild)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_guild"], "行会(G)", { x = 0, y = 0 })

    -- 附近
    GUI:addOnClickEvent(MainProperty._ui["Button_near"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.NearPlayer)
        else
            SL:JumpTo(SLDefine.HyperLinkID.NearPlayer)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_near"], "附近的人", { x = 0, y = 0 })

    -- 排行榜
    GUI:addOnClickEvent(MainProperty._ui["Button_rank"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.Rank)
        else
            SL:JumpTo(SLDefine.HyperLinkID.Rank)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_rank"], "排行榜", { x = 0, y = 0 })

    -- 私聊
    GUI:addOnClickEvent(MainProperty._ui["Button_private"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.PCPrivate)
        else
            SL:JumpTo(SLDefine.HyperLinkID.PCPrivate)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_private"], "私聊记录", { x = 0, y = 0 })

    -- 掉落
    GUI:delayTouchEnabled(MainProperty._ui["Button_drop"])
    GUI:addOnClickEvent(MainProperty._ui["Button_drop"], function()
        MainProperty.ShowDropSwitchPanel()
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_drop"], "掉落分类开关", { x = 0, y = 0 })

    GUI:addOnClickEvent(MainProperty._ui["Panel_hide_drop"], function()
        MainProperty.HideDropSwitchPanel()
    end)

    -- 小退
    GUI:addOnClickEvent(MainProperty._ui["Button_out"], function()
        if tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
            SL:CheckOpenLayer(SLDefine.HyperLinkID.ExitToRole)
        else
            SL:JumpTo(SLDefine.HyperLinkID.ExitToRole)
        end
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_out"], "退出角色(Alt-X)", { x = 0, y = 0 })

    -- 大退
    GUI:addOnClickEvent(MainProperty._ui["Button_end"], function()
        local function callback(bType, custom)
            if bType == 1 then
                SL:ExitGame()
            end
        end
        local data = {}
        data.str = "是否确定退出游戏"
        data.btnType = 2
        data.callback = callback
        UIOperator:OpenCommonTipsUI(data)
        SL:PlayBtnClickAudio()
    end)
    GUI:addMouseOverTips(MainProperty._ui["Button_end"], "退出游戏(Alt-Q)", { x = 0, y = 0 })

    GUI:TextInput_setReturnType(MainProperty._ui["TextField_input"], 2)
    GUI:TextInput_setInputMode(MainProperty._ui["TextField_input"], 6)
    GUI:TextInput_setMaxLength(MainProperty._ui["TextField_input"], 60)

    -- auto size
    local minHeight = 155
    local function touchCallback(sender, eventType)
        local maxHeight = SL:GetValue("SCREEN_HEIGHT") - 100
        if eventType == 1 then
            local touchMovedPos = GUI:getTouchMovePosition(sender)
            local height = touchMovedPos.y
            height = math.min(maxHeight, height)
            height = math.max(minHeight, height)
            height = math.round(height)

            GUI:setContentSize(MainProperty._ui["Panel_chat"], GUI:getContentSize(MainProperty._ui["Panel_chat"]).width, height)
            GUI:setContentSize(MainProperty._ui["Image_chat_bg"], GUI:getContentSize(MainProperty._ui["Image_chat_bg"]).width, height)

            GUI:setPositionY(MainProperty._ui["Panel_chat_touch"], height)
            GUI:setPositionY(MainProperty._ui["Panel_chat_funcs"], height - 9)
            GUI:setPositionY(MainProperty._ui["Panel_exit_funcs"], height - 9)

            local exContentSize = GUI:getContentSize(MainProperty._ui["ListView_chat_ex"])
            local exItems = GUI:ListView_getItems(MainProperty._ui["ListView_chat_ex"])
            local exHei = #exItems == 0 and 1 or exContentSize.height
            local contentSize = GUI:getContentSize(MainProperty._ui["ListView_chat"])
            local chatHei = height - 50 - exHei
            GUI:setContentSize(MainProperty._ui["ListView_chat"], contentSize.width, chatHei)
            GUI:ListView_jumpToBottom(MainProperty._ui["ListView_chat"])

            GUI:setPositionY(MainProperty._ui["Panel_quick"], height - 5)
            GUI:setPositionY(MainProperty._ui["ListView_chat_ex"], height - 25)

            GUI:setPositionY(MainProperty._ui["Panel_auto_tips"], height + 55)
        end
    end
    GUI:addOnTouchEvent(MainProperty._ui["Panel_chat_touch"], touchCallback)
end

-- 发送聊天数据   input：聊天内容
function MainProperty.SendChatMsg(msg, channelID)
    local TextField_input = MainProperty._ui["TextField_input"]

    msg       = msg or GUI:Text_getString(TextField_input)
    channelID = channelID or MainProperty._channelSelect

    -- 换掉空格
    msg = string.trim(msg)
    msg = string.gsub(msg, "[\t\n\r]", "")

    GUI:Text_setString(TextField_input, "")

    -- 没有输入
    if string.len(msg) <= 0 then
        return SL:ShowSystemTips("您还未输入任何信息！")
    end

    local function toSendMsg(input, risk_param, ext_param)
        -- 存储到输入缓存
        ChatData.AddInputCache(input)
        MainProperty._inputCache = SL:CopyData(ChatData.GetInputCache())
        MainProperty._inputIndex = #MainProperty._inputCache + 1

        -- 发送 PC端根据消息内容决定频道
        local oriMsg = ext_param and ext_param.originStr
        local sensitiveWords = ext_param and ext_param.replacedWords
        local status = ext_param and ext_param.status
        local sendData  = {textType = GUIDefine.ChatTextType.NORMAL, msg = input, channel = channelID, risk = risk_param, oriMsg = oriMsg, sensitiveWords = sensitiveWords, status = status}
        GUIFunction:SendChatMsg(sendData)
    end

    local channel, content, targetName = GUIFunction:GetChannelByChatMsg(msg)
    if channel then
        channelID = channel
        msg = content 
    end

    -- 敏感词
    if not string.find(msg, "^@.-") then
        -- 后台控制不可聊天
        if SL:GetValue("M2_FORBID_SAY", true) then
            return false
        end

        local function handle_Func(state, str, risk_param, ext_param)
            if not str then
                return SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
            end

            if targetName then
                str = string.format("/%s %s", targetName, str)
            end

            toSendMsg(str, risk_param, ext_param)
        end

        local data = {channel_id = channel}
        if channel == CHANNEL.PRIVATE then
            local target = ChatData.GetTargets()[1]
            if target then
                local actorID       = target.uid
                data.to_role_level  = SL:GetValue("ACTOR_LEVEL", actorID)
                data.to_role_id     = actorID
                data.to_role_name   = target.name
            end
            msg = content
        end
    
        SL:RequestCheckSensitiveWord(msg, 2, handle_Func, data)
    else
        toSendMsg(msg)
    end
end

function MainProperty.UpdateReceiving()
    local receiveChannel = ChatData.GetReceiveChannel()
    -- 选中
    for i = 0, 8 do
        local btnChannel = MainProperty._ui["Button_channel_" .. i]
        if btnChannel then
            GUI:Button_setBright(btnChannel, i ~= receiveChannel)
            GUI:setTouchEnabled(btnChannel, i ~= receiveChannel)
        end
    end

    -- 清理
    MainProperty._cache = {}
    MainProperty._isScrolling = false
    GUI:ListView_removeAllItems(MainProperty._ui["ListView_chat"])

    -- 消息
    local receiveCache = ChatData.GetPCCache()
    for _, v in ipairs(receiveCache) do
        MainProperty.PushChatCell(v)
    end
    GUI:ListView_jumpToBottom(MainProperty._ui["ListView_chat"])
end

function MainProperty.PushChatCell(cell)
    -- 超出限制，移除先放入的
    local ListView_chat = MainProperty._ui["ListView_chat"]
    GUI:ListView_pushBackCustomItem(ListView_chat, cell)
    if #GUI:ListView_getItems(ListView_chat) >GUIDefine.ChatConfig.LIMIT_COUNT_PC then
        GUI:ListView_removeItemByIndex(ListView_chat, 0)
    end
end

function MainProperty.ShowChatCache()
    -- 缓存填充
    while #MainProperty._chatCellCache > 0 do
        local cell = table.remove(MainProperty._chatCellCache, 1)
        GUI:autoDecRef(cell)
        MainProperty.PushChatCell(cell)
    end
    GUI:ListView_jumpToBottom(MainProperty._ui["ListView_chat"])
end

function MainProperty.SelectChannel(channel)
    ChatData.SetCurChannel(channel)
    MainProperty._channelSelect = channel
    
    local target = ChatData.GetTargets()[1]
    if target and ChatData.GetCurChannel() == CHANNEL.PRIVATE then
        MainProperty.OnPrivateChatWithTarget(target)
    end
end
function MainProperty.CreateChannelCell(id)
    local widget = GUI:Widget_Create(-1, "Widget_" .. id, 0, 0, 0, 0)
    GUI:LoadExport(widget, "main/main_channel_cell_win32")
    local cell = GUI:getChildByName(widget, "channel_cell")

    GUI:removeFromParent(cell)
    return cell
end

function MainProperty.ShowChannels()
    local Panel_channel_s = MainProperty._ui["Panel_channel_s"]
    local p = GUI:getPosition(MainProperty._ui["Button_channel"])
    GUI:setPosition(Panel_channel_s, p.x, p.y + GUI:getContentSize(MainProperty._ui["Button_channel"]).height / 2)
    GUI:setVisible(Panel_channel_s, true)

    local ListView_channel = MainProperty._ui["ListView_channel"]
    local childs = GUI:getChildren(ListView_channel)
    if #childs > 0 then
        return false
    end

    MainProperty._channelCells = {}
    local channels = {CHANNEL.NEAR} 
    if PCShowSelectChannels and string.len(PCShowSelectChannels) > 0 then
        local list = string.split(PCShowSelectChannels, "#")
        for _, index in ipairs(list) do
            if index and tonumber(index) then
                if tonumber(index) == CHANNEL.NEAR then
                    table.remove(channels, 1)
                end
                table.insert(channels, tonumber(index))
            end
        end
    end

    for _, id in ipairs(channels) do
        while true do 
            if not CHANNEL_NAME[id] then
                break
            end

            local name = CHANNEL_NAME[id]
            local cell = MainProperty.CreateChannelCell(id)
            GUI:Text_setString(GUI:getChildByName(cell, "Text_title"), name)
            GUI:setVisible(GUI:getChildByName(cell, "Image_selected"), id == ChatData.GetCurChannel())

            GUI:setTouchEnabled(cell, true)
            GUI:addOnClickEvent(cell, function()
                MainProperty.HideChannels()
                MainProperty.SelectChannel(id)
                MainProperty.OnRefreshChannelSelect()
            end)
            GUI:ListView_pushBackCustomItem(ListView_channel, cell)
            MainProperty._channelCells[id] = cell
            break
        end
    end

    local count = #GUI:getChildren(ListView_channel)
    local cellHei = count > 0 and GUI:getContentSize(GUI:getChildren(ListView_channel)[1]).height or 0
    local listWid = GUI:getContentSize(ListView_channel).width
    local listHei = cellHei * count
    GUI:setContentSize(ListView_channel, listWid, listHei)
    GUI:setContentSize(Panel_channel_s, listWid + 4, listHei + 6)
    GUI:setContentSize(MainProperty._ui["Image_channel_bg"], listWid + 4, listHei + 6)
    GUI:setPositionY(MainProperty._ui["Image_channel_bg"], (listHei + 6) / 2)
end

function MainProperty.HideChannels()
    GUI:setVisible(MainProperty._ui["Panel_channel_s"], false)
    GUI:setPositionY(MainProperty._ui["Panel_channel_s"], -300)
end

function MainProperty.OnRefreshChannelSelect()
    local curChannel = ChatData.GetCurChannel()
    for id, cell in pairs(MainProperty._channelCells or {}) do
        GUI:setVisible(GUI:getChildByName(cell, "Image_selected"), id == curChannel)
    end

    local channelname = CHANNEL_NAME[curChannel]
    GUI:Text_setString(MainProperty._ui["Text_channel"], channelname)
end

function MainProperty.RefreshListView(byData)
    local cellSize  = {width = MainProperty._ChatItemWidth, height = MainProperty._exCellHei}
    local count     = byData and #ChatData.GetChatExItemsData() or #GUI:ListView_getItems(MainProperty._ui["ListView_chat_ex"])
    local margin    = GUI:ListView_getItemsMargin(MainProperty._ui["ListView_chat_ex"])
    local exHei     = (cellSize.height * count) + (count - 1) * margin
    GUI:setContentSize(MainProperty._ui["ListView_chat_ex"], MainProperty._ChatItemWidth, exHei)

    local panelHei = GUI:getContentSize(MainProperty._ui["Panel_chat"]).height
    local chatHei = panelHei - 50 - exHei
    GUI:setContentSize(MainProperty._ui["ListView_chat"], MainProperty._ChatItemWidth, chatHei)
    GUI:ListView_jumpToBottom(MainProperty._ui["ListView_chat"])
end

function MainProperty.OnAddChatItem(cell)
    -- 是否正在拖动
    local listviewCells = MainProperty._ui["ListView_chat"]
    if next(GUI:ListView_getItems(listviewCells)) then
        local lastIdx   = #GUI:ListView_getItems(listviewCells) - 1
        local lastItem  = GUI:ListView_getItemByIndex(listviewCells, lastIdx)
        local size      = GUI:getContentSize(lastItem)
        local aPoint    = GUI:getAnchorPoint(lastItem)
        local worldPosY = GUI:getWorldPosition(lastItem).y - (size.height * aPoint.y) 
        local listviewY = GUI:getWorldPosition(listviewCells).y
        -- 是否屏幕外
        if worldPosY < listviewY then
            MainProperty._isScrolling = true
        end
    end

    if MainProperty._isScrolling then
        -- 正在拖动，消息缓存
        GUI:addRef(cell)
        table.insert(MainProperty._chatCellCache, cell)
    
        while #MainProperty._chatCellCache > GUIDefine.ChatConfig.LIMIT_COUNT_PC do
            local cell = table.remove(MainProperty._chatCellCache, 1)
            GUI:autoDecRef(cell)
        end
    else
        MainProperty.PushChatCell(cell)
        GUI:ListView_jumpToBottom(listviewCells)
    end
end

function MainProperty.OnFillChatInput(str)
    if str and string.len(str) > 0 then
        GUI:Text_setString(MainProperty._ui["TextField_input"], str)
    end
end

function MainProperty.OnPrivateChatWithTarget(data)
    GUI:Text_setString(MainProperty._ui["TextField_input"], string.format("/%s ", data.name))
end

function MainProperty.OnShowChatExNotice()
    MainProperty.CheckChatExNotice()
end

function MainProperty.CheckChatExNotice()
    local exList = MainProperty._ui["ListView_chat_ex"]
    if not exList then
        return false
    end

    if #GUI:ListView_getItems(exList) >= GUIDefine.ChatConfig.LIMIT_COUNT_EX then
        return false
    end

    local chatExItems = SL:CopyData(ChatData.GetChatExItemsData())
    if #chatExItems == 0 then
        local oriWidth = GUI:getContentSize(exList).width
        GUI:setContentSize(exList, oriWidth, 0)
        return false
    end

    local data = chatExItems[#chatExItems]
    if not data then
        return false
    end

    data.Time = data.Time or 5
    if data.Time <= 0 then
        ChatData.RemoveChatExItemsData(data)
        MainProperty.RefreshListView(true)
        return false
    end

    data.Label          = data.Label or ""
    data.Y              = data.Y or 0
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    data.SendNameTemp   = data.SendName or ""

    local FColorHex     = SL:GetHexColorByStyleId(data.FColor)
    local BColorHex     = SL:GetHexColorByStyleId(data.BColor)
    local BColorEnable  = data.BColor ~= -1
    local capacitySize  = {width = MainProperty._ChatItemWidth, height = MainProperty._exCellHei}

    local layout = GUI:Layout_Create(-1, "layout", 0, 0, capacitySize.width, capacitySize.height)
    if BColorEnable then 
        GUI:Layout_setBackGroundColor(layout, FColorHex)
        GUI:Layout_setBackGroundColorType(layout, 0)
    end
    GUI:ListView_pushBackCustomItem(exList, layout)
    MainProperty.RefreshListView()

    local scrollWidget = GUI:Widget_Create(layout, "scrollWidget", 0, 0, capacitySize.width, capacitySize.height)

    local scrollAble = nil
    local scrollSize = {width = 0, height = 0}
    local remaining  = data.Time
    local Msg = SL:FixStringFormatCharacter(data.Msg)
    local hasFormat = string.find(Msg,"%%") 
    local showName = data.SendName and (data.SendName .. ": ") or ""

    local function callback()
        remaining = math.min(remaining, data.Time)
        ChatData.SyncChatExItemsTime(data, remaining)

        local name = showName or ""
        local str = name .. (hasFormat and string.format(Msg, remaining) or Msg)
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE")
        GUI:removeAllChildren(scrollWidget)
        local richText = GUI:RichTextFCOLOR_Create(scrollWidget, "richText", 0, capacitySize.height / 2, str, 1000, fontSize, FColorHex, MainProperty._richVspace, nil, nil, {outlineSize = 0})
        GUI:setTouchEnabled(richText, true)
        GUI:setAnchorPoint(richText, 0, 0.5)
        GUI:RefPosByParent(richText)
        if BColorEnable then
            GUI:RichTextFCOLOR_setBackgroundColor(richText, BColorHex)
        end
        GUI:addOnClickEvent(richText, function()
            if data.SendId and data.SendName and data.SendId ~= SL:GetValue("USER_ID") then
                SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = data.SendNameTemp, uid = data.SendId})
            else
                MainProperty.OnFillChatInput(string.format(data.Msg, remaining))
            end
        end)

        if not scrollAble then
            scrollSize = GUI:getContentSize(richText)
            scrollAble = scrollSize.width > capacitySize.width
        end
        
        if remaining < 0 then
            GUI:ListView_removeItemByIndex(exList, GUI:ListView_getItemIndex(exList, layout))
            MainProperty.RefreshListView()
            ChatData.RemoveChatExItemsData(data)
        end

        remaining = remaining - 1
    end
    SL:schedule(layout, callback, 1)
    callback()

    -- 滚动
    if scrollAble then
        local time = (scrollSize.width - capacitySize.width) / 50
        GUI:runAction(scrollWidget,GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionMoveTo(time, capacitySize.width - scrollSize.width, 0),
            GUI:DelayTime(3), GUI:ActionMoveTo(0, 0, 0))))
    end
end

function MainProperty.OnChatExClear()
    if not MainProperty._ui or not MainProperty._ui["ListView_chat_ex"] then
        return false
    end

    GUI:stopAllActions(MainProperty._ui["ListView_chat_ex"])
    GUI:removeAllChildren(MainProperty._ui["ListView_chat_ex"])
end

function MainProperty.OnDarkStateChange()
    -- 0-白天，1-黑夜，2-日出，3-傍晚
    local darkState = SL:GetValue("DARK_STATE")
    GUI:Image_loadTexture(MainProperty._ui["Image_time"], MainProperty._path .. MainProperty._darkImgList[darkState])
end

function MainProperty.OnRefreshPropertyShow()
    --Level
    local roleLevel = SL:GetValue("LEVEL")
    GUI:Text_setString(MainProperty._ui["Text_level"], roleLevel)

    --EXP
    local curExp = SL:GetValue("EXP")
    local maxExp = SL:GetValue("MAXEXP")
    local expPer = curExp / maxExp * 100
    GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_exp"], expPer)

    --HPMP
    local curHP = SL:GetValue("HP")
    local maxHP = SL:GetValue("MAXHP")
    local curMP = SL:GetValue("MP")
    local maxMP = SL:GetValue("MAXMP")
    local hpPer = curHP / maxHP * 100
    local mpPer = curMP / maxMP * 100
    GUI:Text_setString(MainProperty._ui["Text_hp"], string.format("%s/%s", SL:HPUnit(curHP), SL:HPUnit(maxHP)))
    GUI:Text_setString(MainProperty._ui["Text_mp"], string.format("%s/%s", SL:HPUnit(curMP), SL:HPUnit(maxMP)))

    local roleJob = SL:GetValue("JOB")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        GUI:setVisible(MainProperty._ui["LoadingBar_hp"], false)
        GUI:setVisible(MainProperty._ui["LoadingBar_mp"], false)
        GUI:setVisible(MainProperty._ui["Image_fhp_bg"], true)
        GUI:setVisible(MainProperty._ui["LoadingBar_fhp"], true)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_fhp"], hpPer)
    else
        GUI:setVisible(MainProperty._ui["LoadingBar_hp"], true)
        GUI:setVisible(MainProperty._ui["LoadingBar_mp"], true)
        GUI:setVisible(MainProperty._ui["Image_fhp_bg"], false)
        GUI:setVisible(MainProperty._ui["LoadingBar_fhp"], false)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_hp"], hpPer)
        GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_mp"], mpPer)
    end

    -- weight
    local curWeight = SL:GetValue("BW")
    local maxWeight = SL:GetValue("MAXBW")
    GUI:LoadingBar_setPercent(MainProperty._ui["LoadingBar_weight"], curWeight / maxWeight * 100)

    -- 刷新魔血球动画
    MainProperty.RefreshSfxShowPercent()

    -- 刷新内功相关显示
    MainProperty.OnRefreshNGShow()
end

function MainProperty.OnChangeScene()
    MainProperty.OnUpdatePlayerPosition()
    MainProperty.OnDarkStateChange()
end

function MainProperty.OnUpdatePlayerPosition()
    local mapName = SL:GetValue("MAP_NAME")
    local mapX = SL:GetValue("X")
    local mapY = SL:GetValue("Y")
    if tonumber(mapX) and tonumber(mapY) then
        mapX = math.ceil(mapX)
        mapY = math.ceil(mapY)
        GUI:Text_setString(MainProperty._ui["Text_position"], string.format("%s %s:%s", mapName, mapX, mapY))
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
    local pkMode = SL:GetValue("PKMODE")

    GUI:Text_setString(MainProperty._ui["Text_pkmode"], MainProperty._pkModeStrList[pkMode] or "")
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
    local btnReinAdd = MainProperty._ui["btn_rein_add"]
    local point = SL:GetValue("BONUS_POINT")
    local isshow = point and tonumber(point) > 0 or false
    GUI:setVisible(btnReinAdd, isshow)
    GUI:stopAllActions(btnReinAdd)
    if isshow then
        local blink = false
        local function playBlink()
            blink = not blink
            GUI:Button_loadTextureNormal(btnReinAdd, MainProperty._path .. reinAddIcons[blink and 2 or 1])
        end
        SL:schedule(btnReinAdd, playBlink, 0.2)
    end
end
---------------------------------------------------------------------------------------------


------------------------------ 气泡栏 --------------------------------------------------------
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
        GUI:Button_loadTextureNormal(iconBtn, path)
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
            local remaining = data.endTime - SL:GetValue("SERVER_TIME")
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

function MainProperty.AddBubbleTips(data)
    data.endTime = data.time and data.time + SL:GetValue("SERVER_TIME")

    if MainProperty._bubbleTipsDatas[data.id] then
        MainProperty._bubbleTipsDatas[data.id] = data
        return false
    end
    MainProperty._bubbleTipsDatas[data.id] = data
    

    local tipsCell = MainProperty.CreateBubbleTipsCell(data)
    MainProperty._bubbleTipsCells[data.id] = tipsCell
    GUI:ListView_pushBackCustomItem(MainProperty._ui["ListView_bubble_tips"], tipsCell.layout)

    SL:PlaySound(50004)
end

function MainProperty.RmvBubbleTips(data)
    if not MainProperty._bubbleTipsDatas[data.id] then
        return false
    end
    MainProperty._bubbleTipsDatas[data.id] = nil

    GUI:ListView_removeChild(MainProperty._ui["ListView_bubble_tips"], MainProperty._bubbleTipsCells[data.id].layout)
    MainProperty._bubbleTipsCells[data.id] = nil
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
---------------------------------------------------------------------------------------------

------------------------------ 自动提示 ------------------------------------------------------
function MainProperty.InitAutoSFXTips()
    local contentSize = GUI:getContentSize(MainProperty._ui["Panel_auto_tips"])
    local posX = contentSize.width / 2
    local posY = 10

    -- 自动战斗
    MainProperty._nodeAutoFight = GUI:Node_Create(MainProperty._ui["Panel_auto_tips"], "nodeAutoFight", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoFight, false)
    GUI:Effect_Create(MainProperty._nodeAutoFight, "autoFightSfx", 0, 0, 0, 4009)

    -- 自动寻路
    MainProperty._nodeAutoMove = GUI:Node_Create(MainProperty._ui["Panel_auto_tips"], "nodeAutoMove", posX, posY)
    GUI:setVisible(MainProperty._nodeAutoMove, false)
    GUI:Effect_Create(MainProperty._nodeAutoMove, "autoMoveSfx", 0, 0, 0, 4010)
end

------------------------------ 自动捡物 ------------------------------------------------------
function MainProperty.InitPickButton()
    GUI:setVisible(MainProperty._ui["Button_pick"], false)
    GUI:addOnClickEvent(MainProperty._ui["Button_pick"], function()
        if SL:GetValue("BATTLE_IS_AUTO_PICK") then
            SL:SetValue("BATTLE_PICK_END")
        else
            SL:SetValue("BATTLE_PICK_BEGIN")
        end
    end)
end

function MainProperty.OnUpdatePickState()
    local name = string.format("btn_zhijiemian_%02d.png", SL:GetValue("BATTLE_IS_AUTO_PICK") and 6 or 5)
    GUI:Button_loadTextureNormal(MainProperty._ui["Button_pick"], MainProperty._path .. name)
end

function MainProperty.UpdatePickupVisible(visible)
    GUI:setVisible(MainProperty._ui["Button_pick"], visible)
end

------------------------------ 英雄相关 -------------------------------------------------------
function MainProperty.RefAnger(value)
    local size = GUI:getContentSize(MainProperty._ui["Panel_loadBar"])
    GUI:setContentSize(MainProperty._ui["Panel_loadBar"], size.width, 5 + value * (MainProperty._angerHei - 5))
end

function MainProperty.OnHeroAngerChange()
    if SL:GetValue("USEHERO") then
        local curAnger = SL:GetValue("H.ANGER")
        local maxAnger = SL:GetValue("H.MAXANGER")
        if maxAnger ~= 0 then
            MainProperty.RefAnger(curAnger / maxAnger)
        end

        local bar = MainProperty._ui["Image_loadbar2"]
        if SL:GetValue("H.SHAN") then
            GUI:setVisible(bar, not GUI:getVisible(bar))
        else
            GUI:stopAllActions(bar)
            GUI:setVisible(bar, false)
        end
    end
end

-- 脚本添加魔血球动画
function MainProperty.OnPlayMagicBallEffect(data)
    if data.type < 0 or data.type > 2 or data.count < 0 or data.interval < 0 then
        return
    end
    local scale = data.scale == 0 and 1 or (data.scale / 100)
    local timeval = data.interval / 1000
    local prefix = MainProperty._mhpPrefixList[data.type + 1] or ""

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

    pSize.width = pSize.width * scale
    pSize.height = pSize.height * scale
    local tag = MainProperty._mhpTagList[data.type + 1]
    local widget = MainProperty._ui[string.format("Panel_%ssfx", prefix)]
    local sprite
    if tag and widget then
        MainProperty._pSize[tag] = pSize
        GUI:setContentSize(widget, pSize.width, pSize.height)
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

    GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], data.type ~= 2)
    GUI:setVisible(MainProperty._ui["Panel_mp_sfx"], data.type ~= 2)
    GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], true)

    if data.type == 0 then -- HP
        GUI:setPosition(widget, 38 + data.offsetX, 65 + data.offsetY)
    elseif data.type == 1 then -- MP
        local hpPosX = GUI:getPositionX(MainProperty._ui["Panel_hp_sfx"])
        local hpWidth = GUI:getContentSize(MainProperty._ui["Panel_hp_sfx"]).width
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
    local curHP = SL:GetValue("HP")
    local maxHP = SL:GetValue("MAXHP")
    local curMP = SL:GetValue("MP")
    local maxMP = SL:GetValue("MAXMP")
    local hpPer = curHP / maxHP
    local mpPer = curMP / maxMP

    local roleJob = SL:GetValue("JOB")
    local roleLevel = SL:GetValue("LEVEL")
    if roleLevel < 28 and roleJob == 0 then -- 战士等级小于28 显示全血
        if MainProperty._ui["Panel_hp_sfx"] and MainProperty._ui["Panel_mp_sfx"] then
            GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], false)
            GUI:setVisible(MainProperty._ui["Panel_mp_sfx"], false)
            GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], true)
        end
    else
        if MainProperty._ui["Panel_hp_sfx"] and MainProperty._ui["Panel_mp_sfx"] then
            GUI:setVisible(MainProperty._ui["Panel_hp_sfx"], true)
            GUI:setVisible(MainProperty._ui["Panel_mp_sfx"], true)
            GUI:setVisible(MainProperty._ui["Panel_fhp_sfx"], false)
        end
    end

    for i, tag in ipairs(MainProperty._mhpTagList) do
        local widget = MainProperty._ui[string.format("Panel_%ssfx", MainProperty._mhpPrefixList[i])]
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
---------------------------------------------------------------------------------------------

------------------------------ 内功相关 ------------------------------------------------------
function MainProperty.OnRefreshNGShow()
    if SL:GetValue("GAME_DATA", "OpenNGUI") ~= 1 then
        return
    end
    -- 斗转星移值
    if not MainProperty._dzPanelHei then
        MainProperty._dzPanelHei = GUI:getContentSize(MainProperty._ui["Panel_bar_dz"]).height
    end
    local wid = GUI:getContentSize(MainProperty._ui["Panel_bar_dz"]).width
    local curDZValue = SL:GetValue("CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local maxDZValue = SL:GetValue("MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local per = 0
    if curDZValue and maxDZValue and maxDZValue > 0 then
        per = curDZValue / maxDZValue
    end
    GUI:setContentSize(MainProperty._ui["Panel_bar_dz"], wid, MainProperty._dzPanelHei * per)
    
    -- 醉酒值
    if not MainProperty._zjPanelHei then
        MainProperty._zjPanelHei = GUI:getContentSize(MainProperty._ui["Panel_bar_zj"]).height
    end
    local wid = GUI:getContentSize(MainProperty._ui["Panel_bar_zj"]).width
    local per = 0
    GUI:setContentSize(MainProperty._ui["Panel_bar_zj"], wid, MainProperty._zjPanelHei * per)

    MainProperty._NGShow = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("IS_LEARNED_INTERNAL")
    MainProperty.InitNGShow()
    MainProperty.OnUpdateSetComboSkill()
end

function MainProperty.OnRefreshDZShow()
    local dzPanel = MainProperty._ui["Panel_dz"]
    if dzPanel then
        if SL:GetValue("SKILL_DATA", DZXY_SkillID) then
            GUI:setVisible(dzPanel, MainProperty._NGShow and true)
        else
            GUI:setVisible(dzPanel, false)
        end
    end
end

-- 连击可释放
function MainProperty.OnRefreshComboShow(state)
    GUI:stopAllActions(MainProperty._ui["Image_ng_shan"])
    GUI:setVisible(MainProperty._ui["Image_ng_shan"], state)
    if state then
        local blink = false
        local function playBlink()
            blink = not blink
            GUI:Image_loadTexture(MainProperty._ui["Image_ng_shan"], MainProperty._path .. comboShowIcons[blink and 2 or 1])
        end
        SL:schedule(MainProperty._ui["Image_ng_shan"], playBlink, 0.2)
    end
end

function MainProperty.OnActiveComboSkill(state)
    if MainProperty._NGShow then 
        local selectSkills = SL:GetValue("SET_COMBO_SKILLS")
        if selectSkills[1] then
            MainProperty.OnRefreshComboShow(state)
        end
    end
end

function MainProperty.OnComboSkillCDChange()
    local skills = SL:GetValue("SET_COMBO_SKILLS")
    local state  = true

    for i = 1, #skills do
        local skillID = skills[i]
        if skillID and skillID ~= 0 then
            if SL:GetValue("SKILL_IS_CDING", skillID) then
                state = false
            end
        end
    end

    SL:SetValue("COMBO_SKILL_STATE", state)
    MainProperty.OnActiveComboSkill(state)
end

function MainProperty.OnUpdateSetComboSkill()
    if MainProperty._NGShow then
        local selectSkills = SL:GetValue("SET_COMBO_SKILLS")
        if selectSkills[1] then
            MainProperty.OnRefreshComboShow(true)
        else
            GUI:stopAllActions(MainProperty._ui["Image_ng_shan"])
            GUI:setVisible(MainProperty._ui["Image_ng_shan"], false)
        end
    end
end

------------------------------ 掉落分类 ------------------------------------------------------
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
    local worldPos = GUI:getWorldPosition(MainProperty._ui["Button_drop"])
    local nodePos = GUI:convertToNodeSpace(MainProperty._root, worldPos.x, worldPos.y)
    GUI:setPosition(MainProperty._ui["Panel_drop"], nodePos.x, nodePos.y + 10)
    GUI:setVisible(MainProperty._ui["Panel_drop"], true)
    GUI:setVisible(MainProperty._ui["Panel_hide_drop"], true)
    GUI:setTouchEnabled(MainProperty._ui["Panel_hide_drop"], true)

    GUI:ListView_removeAllItems(MainProperty._ui["ListView_drop"])

    local cellWid = nil
    local cellHei = nil
    for _, data in ipairs(MainProperty._dropTypeList) do
        local id = data.id
        local name = string.len(data.name) == 0 and ("分类" .. id) or data.name
        local cell = MainProperty.CreateDropSwitchCell(id)
        local isReceiving = ChatData.GetDropTypeSwitch(id)
        GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
        GUI:Text_setString(cell.nameText, name)
        local nameWid = GUI:getContentSize(cell.nameText).width
        local posX = GUI:getPositionX(cell.nameText)

        -- 接收开关
        GUI:CheckBox_addOnEvent(cell.checkBox, function()
            local isSelected = GUI:CheckBox_isSelected(cell.checkBox)
            if id == DROP_TOTAL_TYPE_ID then
                for channel, cell in pairs(MainProperty._dropTypeCells) do
                    ChatData.SetDropTypeSwitch(channel, isSelected)
                end
            else
                ChatData.SetDropTypeSwitch(id, isSelected)
            end
            for channel, cell in pairs(MainProperty._dropTypeCells) do
                local isReceiving = ChatData.GetDropTypeSwitch(channel)
                GUI:CheckBox_setSelected(cell.checkBox, isReceiving == true)
                if channel == DROP_TOTAL_TYPE_ID then
                    ChatData.SetReceiving(CHANNEL.DROP, isReceiving)
                end
            end
        end)

        local tempWid = posX + nameWid + 8
        if not cellWid or not cellHei then
            cellWid = math.max(tempWid, GUI:getContentSize(cell.layout).width)
            cellHei = GUI:getContentSize(cell.layout).height
        else
            cellWid = math.max(tempWid, cellWid)
        end

        MainProperty._dropTypeCells[id] = cell
        GUI:ListView_pushBackCustomItem(MainProperty._ui["ListView_drop"], cell.layout)
    end

    
    local listWid = cellWid
    local listHei = cellHei * num
    GUI:setContentSize(MainProperty._ui["ListView_drop"], listWid, listHei)
    GUI:setContentSize(MainProperty._ui["Panel_drop"], listWid + 2, listHei + 6)
    GUI:setContentSize(MainProperty._ui["Image_drop_bg"], listWid + 2, listHei + 6)
    GUI:setPosition(MainProperty._ui["Image_drop_bg"], (listWid + 2) / 2, (listHei + 6) / 2)
end

function MainProperty.HideDropSwitchPanel()
    GUI:setVisible(MainProperty._ui["Panel_drop"], false)
    GUI:setVisible(MainProperty._ui["Panel_hide_drop"], false)
    GUI:setTouchEnabled(MainProperty._ui["Panel_hide_drop"], false)
end
---------------------------------------------------------------------------------------------

------------------------------ 快捷栏 --------------------------------------------------------
-- 初始化显示的快捷栏
function MainProperty.InitQuickUseShow()
    local showNum = 0
    -- 默认个数
    if MainProperty._ui["Panel_quick"] and GUI:getVisible(MainProperty._ui["Panel_quick"]) then
        for i = 1, 6 do
            local layout = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if layout and GUI:getVisible(layout) then
                showNum = showNum + 1
            end
        end
    end
    -- 设置快捷框个数 (最大：6)
    QuickUseData.SetQuickUseSize(showNum)
end

-- 初始化显示的快捷栏
function MainProperty.InitQuickUseItems()
    local regstetMouseEvent = function (widget, item, i)
        local function addItemIntoBag(touchPos)
            local state = SL:GetValue("ITEM_MOVE_STATE")
            local canMove = item and GUI:getVisible(item)
            if state and canMove then
                local data         = {}
                data.target        = GUIDefine.ItemGoTo.QUICK_USE
                data.pos           = touchPos
                data.posInQuickUse = i
                SL:ItemMoveCheck(data)
            else
                return -1
            end
        end
    
        local function setNoSwallowMouse()
            return -1
        end
    
        GUI:addMouseButtonEvent(widget, {
            onRightDownFunc = setNoSwallowMouse,
            onSpecialRFunc = addItemIntoBag
        })
    end

    local showNum = 0

    local Panel_quick = MainProperty._ui["Panel_quick"]
    if Panel_quick and GUI:getVisible(Panel_quick) then
        for i = 1, 6 do
            local item = MainProperty._ui[string.format("Panel_quick_use_%s", i)]
            if item and GUI:getVisible(item) then
                showNum = showNum + 1

                local size = GUI:getContentSize(item)
                local nodeItem = GUI:Node_Create(item, "nodeItem", size.width/2, size.height/2)
                MainProperty._quickUseCells[i] = {layout = item, nodeItem = nodeItem}

                local Panel_touch = GUI:Layout_Create(item, "Panel_touch", 0, 0, size.width, size.height)
                GUI:setTouchEnabled(Panel_touch, true)
                GUI:setSwallowTouches(Panel_touch, false)
                Panel_touch._noAutoRegisterMouseSwollow = true
                regstetMouseEvent(Panel_touch, item, i)
            end
        end
    end

    QuickUseData.SetQuickUseSize(showNum)

    MainProperty.UpdateQuickUseItem()
end

-- 快捷栏更新
function MainProperty.OnQuickUseRefresh(data)
    local cell = MainProperty._quickUseCells[data.pos]
    if not cell then
        return false
    end
    GUI:ItemShow_resetMoveState(cell.item, data.state == 0)
end

-- 快捷栏变化通知
function MainProperty.OnQuickUseChange(data)
    local opera = data.opera
    if opera == GUIDefine.OperateType.INIT then
        MainProperty.UpdateQuickUseItem()
    elseif opera == GUIDefine.OperateType.ADD then
        MainProperty.AddQuickUseItem(data.param)
    elseif opera == GUIDefine.OperateType.DEL then
        MainProperty.DelQuickUseItem(data.param)
    elseif opera == GUIDefine.OperateType.CHANGE then
        MainProperty.ChangeQuickUseItem(data.param)
    end
end

--初始化item
function MainProperty.UpdateQuickUseItem()
    for k, v in pairs(MainProperty._quickUseCells) do
        GUI:removeAllChildren(v.nodeItem)
    end

    local quickUseData = QuickUseData.GetQuickUseData()
    for k, v in pairs(quickUseData) do
        MainProperty.AddQuickUseItem({index = k, itemData = v})
    end
end

-- 添加 item
function MainProperty.AddQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    local function dealSpecialQuickUse()
        local index = data.index
        local size = QuickUseData.GetQuickUseSize()
        local quickUseData = QuickUseData.GetQuickUseData()
        local quickUseList = QuickUseData.GetQuickUseLocalList()

        local replaceCell = nil
        for i = 1, size do
            if not quickUseData[i] and MainProperty._quickUseCells[i] and i ~= index then
                replaceCell = MainProperty._quickUseCells[i]
                cell = replaceCell
                quickUseData[i] = quickUseData[index]
                quickUseData[index] = nil

                quickUseList[i] = quickUseList[index]
                quickUseList[index] = 0
                break
            end
        end

        -- 无替代则放回背包
        if not replaceCell then
            local item = data.itemData
            BagData.AddItemData(item)
            
            --清数据
            quickUseList[index] = 0

            return true
        end
    end

    if not cell then
        if dealSpecialQuickUse() then
            return
        end
    end

    local nodeItem = cell.nodeItem
    
    GUI:removeAllChildren(nodeItem)

    local function getCount(item)
        if item.OverLap > 1 then
            return item.OverLap
        end

        if item.StdMode == 2 and item.Dura > 0 then --使用次数
            return item.Dura < 1000 and 1 or math.floor(item.Dura / 1000)  --小于1000都为1；大于1000向下取整
        end
        return 0
    end

    local itemData = data.itemData
    local data = {index = itemData.Index, itemData = itemData, count = getCount(itemData), from = GUIDefine.ItemFrom.QUICK_USE, movable = true}
    local item = GUI:ItemShow_Create(nodeItem, "quickCell", 0, 0, data)
    GUI:setAnchorPoint(item, 0.5, 0.5)

    GUI:addMouseButtonEvent(item, {
        onRightUpFunc   = function() SL:RequestUseItem(itemData) end,
        onDoubleLFunc   = function() SL:RequestUseItem(itemData) end,
    })

    -- 延迟0.15s显示goodsitem
    GUI:setVisible(item, false)
    GUI:stopAllActions(item)
    SL:scheduleOnce(item, function(sender) GUI:setVisible(item, true) end, 0.15)

    cell.item = item
end

-- 删除 item
function MainProperty.DelQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    if not cell then
        return false
    end
    GUI:removeAllChildren(cell.nodeItem)
end

-- 修改 item
function MainProperty.ChangeQuickUseItem(data)
    local cell = MainProperty._quickUseCells[data.index]
    if not cell then
        return false
    end
    local function getCount(item)
        if item.OverLap > 1 then
            return item.OverLap
        end

        if item.StdMode == 2 and item.Dura > 0 then --使用次数
            return item.Dura < 1000 and 1 or math.floor(item.Dura / 1000)  --小于1000都为1；大于1000向下取整
        end
        return 0
    end
    GUI:ItemShow_UpdateItemCountShow(cell.item, data.itemData, getCount(data.itemData))
end
---------------------------------------------------------------------------------------------

----------------------------- 倒计时提示 -----------------------------------------------------
function MainProperty.OnAddQuitTimeTips(data)
    if not data or not data.time or not data.type then
        return false
    end

    local time 
    local type = data.type  -- 1 小退 2 大退

    local Node_quit_tip = MainProperty._ui["Node_quit_tip"]
    if not Node_quit_tip then
        return false
    end

    local function refreshTime()
        time = time and time - 1 or data.time

        local str = string.format(MainProperty._quitTimeTips[type], time)

        GUI:removeAllChildren(Node_quit_tip)
        local width = SL:GetValue("SCREEN_WIDTH")
        local richText = GUI:RichText_Create(Node_quit_tip, "richtips", 0, 0, str, width, (SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16) + 1, "#ffffff")
        GUI:setAnchorPoint(richText, 0.5, 0)
    end

    GUI:stopAllActions(Node_quit_tip)
    SL:schedule(Node_quit_tip, refreshTime, 1)
    refreshTime()
end

function MainProperty.OnDelQuitTimeTips()
    local Node_quit_tip = MainProperty._ui["Node_quit_tip"]
    if not Node_quit_tip then
        return false
    end

    GUI:stopAllActions(Node_quit_tip)
    GUI:removeAllChildren(Node_quit_tip)
end
---------------------------------------------------------------------------------------------

---------------------------- 窗体尺寸改变 ----------------------------------------------------
function MainProperty.OnWindowChange()
    MainProperty.InitAdapet()
    GUI:setPositionX(MainProperty._root, SL:GetValue("SCREEN_WIDTH") / 2)
end
---------------------------------------------------------------------------------------------
-- 更新恢复聊天框未聚焦状态:  关闭Keyboard
function MainProperty.OnCloseKeyBoard()
    GUI:TextInput_closeInput(MainProperty._ui["TextField_input"])
end

---------------------------------------------------------------------------------------------
function MainProperty.handlePressedEnter()
    GUI:TextInput_touchDownAction(MainProperty._ui["TextField_input"], 2)
    return true
end

------------------------------ 注册事件 ------------------------------------------------------
function MainProperty.RegisterEvent()
    -- 注册事件
    SL:RegisterLUAEvent(LUA_EVENT_HPMP_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_LEVEL_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_EXP_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
    SL:RegisterLUAEvent(LUA_EVENT_WEIGHT_CHANGE, "MainProperty", MainProperty.OnRefreshPropertyShow)
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
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKBEGIN, "MainProperty", MainProperty.OnUpdatePickState)
    SL:RegisterLUAEvent(LUA_EVENT_AUTOPICKEND, "MainProperty", MainProperty.OnUpdatePickState)

    -- 脚本命令（AutoPickItemByBtn、StopAutoPickItemByBtn）触发
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PICKUP_SHOW, "MainProperty", MainProperty.UpdatePickupVisible)

    -- -- 英雄相关
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ANGER_CHANGE, "MainProperty", MainProperty.OnHeroAngerChange)
    -- 转生点改变
    SL:RegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "MainProperty", MainProperty.OnReinAttrChange)
    -- PK模式改变
    SL:RegisterLUAEvent(LUA_EVENT_PKMODE_CHANGE, "MainProperty", MainProperty.OnPlayerPKStateChange)
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

    SL:RegisterLUAEvent(LUA_EVENT_COMBO_SKILL_CD_CHANGE, "MainProperty", MainProperty.OnComboSkillCDChange)

    SL:RegisterLUAEvent(LUA_EVENT_CHATMINI_ITEM_ADD, "MainProperty", MainProperty.OnAddChatItem)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_EX_NOTICE_ADD, "MainProperty", MainProperty.OnShowChatExNotice)
    SL:RegisterLUAEvent(LUA_EVENT_PC_FILL_CHAT_INPUT, "MainProperty", MainProperty.OnFillChatInput)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PUSH_INPUT, "MainProperty", MainProperty.OnFillChatInput)
    SL:RegisterLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, "MainProperty", MainProperty.OnPrivateChatWithTarget)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_CHAT_EX_CLEAR, "MainProperty", MainProperty.OnChatExClear)
    
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_DATA_OPER, "MainProperty", MainProperty.OnQuickUseChange)
    SL:RegisterLUAEvent(LUA_EVENT_QUICKUSE_ITEM_REFRESH, "MainProperty", MainProperty.OnQuickUseRefresh)

    SL:RegisterLUAEvent(LUA_EVENT_MAIN_ADD_QUIT_TIME_TIPS, "MainProperty", MainProperty.OnAddQuitTimeTips)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_DEL_QUIT_TIME_TIPS, "MainProperty", MainProperty.OnDelQuitTimeTips)
    
    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "MainProperty", MainProperty.OnWindowChange)
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_CLOSE_KEYBOARD, "MainProperty", MainProperty.OnCloseKeyBoard) 
end
----------------------------------------------------------------------------------------------

MainProperty.main()