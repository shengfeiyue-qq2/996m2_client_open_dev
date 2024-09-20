SettingBasic = {}

SettingBasic._clickItems = {}
SettingBasic._ui = nil
local group1 = {
    SLDefine.SETTINGID.SETTING_IDX_PLAYER_NAME, --人名显示
    SLDefine.SETTINGID.SETTING_IDX_ONLY_NAME, --只显人名
    SLDefine.SETTINGID.SETTING_IDX_MONSTER_NAME, --怪物显名
    SLDefine.SETTINGID.SETTING_IDX_PLAYER_JOB_LEVEL, --职业等级
    SLDefine.SETTINGID.SETTING_IDX_HP_NUM, --数字显血
    SLDefine.SETTINGID.SETTING_IDX_HP_HUD, --显示血条
    SLDefine.SETTINGID.SETTING_IDX_HP_UNIT, --血量单位简写
    SLDefine.SETTINGID.SETTING_IDX_LEVEL_SHOW_NAME_HUD, --低于多少等级不显示等级
    SLDefine.SETTINGID.SETTING_IDX_FRAME_RATE_TYPE_HIGH,--高帧率模式
}

local group2 = {
    SLDefine.SETTINGID.SETTING_IDX_ONE_DOUBLE_ROCKER, --单双摇杆
    SLDefine.SETTINGID.SETTING_IDX_EQUIP_COMPARE, --装备对比
    SLDefine.SETTINGID.SETTING_IDX_DAMAGE_NUM, --数字飘血
    SLDefine.SETTINGID.SETTING_IDX_UNSAFE_TIPS, --残血提示
    SLDefine.SETTINGID.SETTING_IDX_AUTO_REPAIR, --自动修理
    SLDefine.SETTINGID.SETTING_IDX_DURABILITY_TIPS, --持久提示
    SLDefine.SETTINGID.SETTING_IDX_AUTO_PUT_IN_EQUIP, --自动穿戴
    SLDefine.SETTINGID.SETTING_IDX_LAYER_OPACITY, --面板半透明
}

local group3 = {
    SLDefine.SETTINGID.SETTING_IDX_MONSTER_PET_VISIBLE, --屏蔽宝宝
    SLDefine.SETTINGID.SETTING_IDX_MONSTER_VISIBLE, --屏蔽怪物
    SLDefine.SETTINGID.SETTING_IDX_EFFECT_SHOW, --屏蔽特效
    SLDefine.SETTINGID.SETTING_IDX_TITLE_VISIBLE, --隐藏称号
    SLDefine.SETTINGID.SETTING_IDX_SKILL_EFFECT_SHOW, --屏蔽技能
    SLDefine.SETTINGID.SETTING_IDX_PLAYER_SHOW_FRIEND, --屏蔽己方玩家
    SLDefine.SETTINGID.SETTING_IDX_PLAYER_SIMPLE_DRESS, --人物简装
    SLDefine.SETTINGID.SETTING_IDX_MONSTER_SIMPLE_DRESS, --怪物简装
    SLDefine.SETTINGID.SETTING_IDX_BOSS_NO_SIMPLE_DRESS, -- Boss不简装
    SLDefine.SETTINGID.SETTING_IDX_IGNORE_STALL,--屏蔽摆摊
}

local group4 = {
    SLDefine.SETTINGID.SETTING_IDX_BGMUSIC, --背景音乐
    SLDefine.SETTINGID.SETTING_IDX_EFFECTMUSIC, --游戏音乐
}

local herogroup2 = {
    SLDefine.SETTINGID.SETTING_IDX_HERO_JOINT_SHAKE, --合击震屏
}

local herogroup3 = {
    SLDefine.SETTINGID.SETTING_IDX_HERO_HIDE, --屏蔽英雄
}

local getConfigFunc = function(group)
    local configs = {}
    local config
    for i, id in ipairs(group) do
        config = SL:GetMetaValue("SETTING_CONFIG", id)
        if config and (config.platform == 0 or config.platform == SL:GetMetaValue("CURRENT_OPERMODE")) then
            if not config.order or  not tonumber(config.order) then
                config.order = 0 
            end
            table.insert(configs, config)
        end
    end
    table.sort(configs, function(a, b)
        return a.order < b.order
    end)
    return configs
end

function SettingBasic.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_basic")

    SettingBasic._ui = GUI:ui_delegate(parent)
    if not SettingBasic._ui then
        return false
    end

    --第一组开关
    SettingBasic.initGroup1()
    --第二组开关
    SettingBasic.initGroup2()
    --第三组开关
    SettingBasic.initGroup3()

    --第四组开关
    local otherTradingBankProxy = global.Facade:retrieveProxy(global.ProxyTable.OtherTradingBankProxy)
    if otherTradingBankProxy:getPublishOpen() == 1 then
        GUI:setVisible(SettingBasic._ui.Image_4, false)
        GUI:setVisible(SettingBasic._ui.Image_4_1, true)
        GUI:setVisible(SettingBasic._ui.Image_4_1_1, true)
        SettingBasic.initGroup4_1()
    else
        SettingBasic.initGroup4()
    end
    --复制key 上传文字
    if otherTradingBankProxy:getPublishOpen() == 1 then
        local sizePanel = GUI:getContentSize(SettingBasic._ui.Panel_1)
        SettingBasic.textTips = GUI:Text_Create(SettingBasic._ui.Panel_1, "uploadtext", sizePanel.width/2, sizePanel.height/2-50, 18, "#FFFFFF", "")
        GUI:setAnchorPoint(SettingBasic.textTips, 0.5, 0.5)
    end
    SL:RegisterLUAEvent(LUA_EVENT_OPEN_SETTING_HELP_UP_LOAD_TIPS, "SettingBasic", SettingBasic.UpLoadTextTipsOpen)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSE_SETTING_HELP_UP_LOAD_TIPS, "SettingBasic", SettingBasic.UpLoadTextTipsClose)
    --监听开关
    SL:RegisterLUAEvent(LUA_EVENT_SETTING_CAHNGE, "SettingBasic", SettingBasic.onSettingChange)
end
function SettingBasic.CloseLayer()
    SL:UnRegisterLUAEvent(LUA_EVENT_SETTING_CAHNGE,"SettingBasic")
end

function SettingBasic.onSettingChange(data)
    if data and data.id == SLDefine.SETTINGID.SETTING_IDX_FRAME_RATE_TYPE_HIGH then --高帧率
        local isOn = SL:GetMetaValue("SETTING_ENABLED", data.id)
        local t = {
            [SLDefine.SETTINGID.SETTING_IDX_MONSTER_PET_VISIBLE] = 1,     -- 屏蔽召唤物
            [SLDefine.SETTINGID.SETTING_IDX_EFFECT_SHOW] = 1,             -- 屏蔽特效
            [SLDefine.SETTINGID.SETTING_IDX_SKILL_EFFECT_SHOW] = 1,       -- 屏蔽技能特效
            [SLDefine.SETTINGID.SETTING_IDX_PLAYER_SHOW_FRIEND] = 1,      -- 屏蔽玩家设置
            [SLDefine.SETTINGID.SETTING_IDX_MONSTER_VISIBLE] = 1,         -- 屏蔽怪物设置
            [SLDefine.SETTINGID.SETTING_IDX_TITLE_VISIBLE] = 1,           -- 隐藏称号
        }
        local enable = isOn == 0
        local func = function(enable,id)
            local panel_item = SettingBasic._clickItems[id or 0]
            if not panel_item then 
                return
            end
            local paneui = GUI:ui_delegate(panel_item)
            --关闭状态ui
            GUI:setVisible(paneui.Panel_1, not enable)
            --开启状态ui
            GUI:setVisible(paneui.Panel_2, enable)
        end

        --刷新开关状态
        for id, v in pairs(t) do
            func(enable,id)
        end
        
    end
end

function SettingBasic.initGroup1()
    local groupConfig = getConfigFunc(group1)
    local ListView = SettingBasic._ui.ListView_1
    for i, config in ipairs(groupConfig) do
        if SLDefine.SETTINGID.SETTING_IDX_LEVEL_SHOW_NAME_HUD == config.id then
            SettingBasic.CreateInputClickCell(ListView, config)
        else
            SettingBasic.CreateClickCell(ListView, config)
        end
    end
    GUI:ListView_doLayout(ListView)
end

function SettingBasic.initGroup2()
    local tconfigs = SL:CopyData(group2)
    --英雄系统是否开启
    if SL:GetMetaValue("USEHERO") then
        for i, id in ipairs(herogroup2) do
            table.insert(tconfigs, id)
        end
    end
    local groupConfig = getConfigFunc(tconfigs)
    local ListView = SettingBasic._ui.ListView_2
    for i, config in ipairs(groupConfig) do
        SettingBasic.CreateClickCell(ListView, config)
    end
    GUI:ListView_doLayout(ListView)
end

function SettingBasic.initGroup3()
    local tconfigs = SL:CopyData(group3)
    --英雄系统是否开启
    if SL:GetMetaValue("USEHERO") then
        for i, id in ipairs(herogroup3) do
            table.insert(tconfigs, id)
        end
    end
    local groupConfig = getConfigFunc(tconfigs)
    local ListView = SettingBasic._ui.ListView_3
    for i, config in ipairs(groupConfig) do
        SettingBasic.CreateClickCell(ListView, config)
    end
    GUI:ListView_doLayout(ListView)
end

function SettingBasic.initGroup4()
    local groupConfig = getConfigFunc(group4)
    local ListView = SettingBasic._ui.ListView_4
    local Panel_Voice = GUI:Layout_Create(ListView, "Panel_Voice", 0, 0, 340, 95, false)
    for i, config in ipairs(groupConfig) do
        SettingBasic.CreateVoiceProgressCell(Panel_Voice, config, i)
    end
    GUI:ListView_doLayout(ListView)
end

function SettingBasic.initGroup4_1()
    local groupConfig = getConfigFunc(group4)
    local ListView = SettingBasic._ui.ListView_4_1
    local Panel_Voice = GUI:Layout_Create(ListView, "Panel_Voice", 0, 0, 220, 95, false)
    for i, config in ipairs(groupConfig) do
        SettingBasic.CreateVoiceProgressCell2(Panel_Voice, config, i)
    end

    local otherTradingBankProxy = global.Facade:retrieveProxy(global.ProxyTable.OtherTradingBankProxy)
    if otherTradingBankProxy:getPublishOpen() == 1 then
        local Panel_Click = GUI:Layout_Create(SettingBasic._ui.ListView_4_2, "Panel_Click_Key", 0, 0, 100, 95, false)
        GUI:setTouchEnabled(Panel_Click, true)
        -- Create Button_CobyAccountID
        local Button_CobyAccountID = GUI:Button_Create(Panel_Click, "Button_CobyAccountID", 55, 50, "res/public/1900000673.png")
        GUI:Button_loadTexturePressed(Button_CobyAccountID, "res/public/1900000674.png")
        GUI:Button_loadTextureDisabled(Button_CobyAccountID, "res/public/1900000674.png")
        GUI:Button_setTitleText(Button_CobyAccountID, "复制账号ID")
        GUI:Button_setTitleColor(Button_CobyAccountID, "#ffffff")
        GUI:Button_setTitleFontSize(Button_CobyAccountID, 14)
        GUI:Button_titleEnableOutline(Button_CobyAccountID, "#000000", 1)
        GUI:setTouchEnabled(Button_CobyAccountID, true)
        SettingBasic.buttonCobyAccountID = Button_CobyAccountID

        -- Create Button_CobyPlayerID
        local Button_CobyPlayerID = GUI:Button_Create(Panel_Click, "Button_CobyPlayerID", 55, 7, "res/public/1900000673.png")
        GUI:Button_loadTexturePressed(Button_CobyPlayerID, "res/public/1900000674.png")
        GUI:Button_loadTextureDisabled(Button_CobyPlayerID, "res/public/1900000674.png")
        GUI:Button_setTitleText(Button_CobyPlayerID, "复制角色码")
        GUI:Button_setTitleColor(Button_CobyPlayerID, "#ffffff")
        GUI:Button_setTitleFontSize(Button_CobyPlayerID, 14)
        GUI:Button_titleEnableOutline(Button_CobyPlayerID, "#000000", 1)
        GUI:setTouchEnabled(Button_CobyPlayerID, true)
        SettingBasic.buttonCobyPlayerID = Button_CobyPlayerID
        
        --复制账号角色码ID按钮
        SettingBasic.CreateCobyAccountButton()
    end

    GUI:ListView_doLayout(ListView)
end

-- 复制账号角色码ID按钮
function SettingBasic.CreateCobyAccountButton()
    local otherTradingBankProxy = global.Facade:retrieveProxy(global.ProxyTable.OtherTradingBankProxy)
    local getRoleKey = function()
        otherTradingBankProxy:getRoleKey(SettingBasic, function(code, data, msg)
            if code == 200 then
                SL:SetMetaValue("CLIPBOARD_TEXT", data)--账号ID (购买ID)
                ShowSystemTips(GET_STRING(600000419))
            else
                ShowSystemTips(msg)
            end
        end)
    end
    local TextTips = function()
        local params = {}
        params.type = 1
        params.btntext = {GET_STRING(600000139), GET_STRING(600000170)}
        params.text = GET_STRING(700000134)
        params.titleImg = global.MMO.PATH_RES_PRIVATE .. "trading_bank_other/img_tips.png"
        params.callback = function(res)
            global.Facade:sendNotification(global.NoticeTable.Layer_TradingBankTips2Layer_Close_other)
            if res == 1 then
                --是否登录
                if otherTradingBankProxy:getToken() == "" then 
                    otherTradingBankProxy:Login1_2(function(code, msg)
                        if code == 200 then 
                            if otherTradingBankProxy:getToken() ~= "" then 
                                getRoleKey()
                            end
                        else
                            ShowSystemTips(msg or "")
                        end
                    end)
                else
                    getRoleKey()
                end
            end
            
        end
        global.Facade:sendNotification(global.NoticeTable.Layer_TradingBankTips2Layer_Open_other, params)
    end

    local btn = SettingBasic.buttonCobyAccountID
    btn:addClickEventListener(function()
        otherTradingBankProxy:doTrack(otherTradingBankProxy.UpLoadData.TraingCobyAccountIDBtnClick)
        TextTips()
    end)

    --冻结角色
    -- local LockPublishRole = function()
    --     local params = {
    --         prePublishLockId = otherTradingBankProxy:getPublishLockID()
    --     }
    --     otherTradingBankProxy:lockPublishRole(SettingBasic, params, function(code, data, msg)
    --         if code == 200 then
    --             if data then
    --                 SL:print("冻结成功")
    --                 --SL:SetMetaValue("CLIPBOARD_TEXT", otherTradingBankProxy:getPublishKey())
    --                 --ShowSystemTips(GET_STRING(600000419))
    --                 global.Facade:sendNotification(global.NoticeTable.TradingBank_other_Capture,{type = 1})
    --             else
    --                 --如果冻结失败让玩家重新获取一下寄售码 保证流程畅通
    --                 otherTradingBankProxy:setPublishKeyValidTime(0)
    --                 otherTradingBankProxy:setPublishKey("")
    --                 ShowSystemTips(GET_STRING(700000136))--冻结失败 请稍后再试    备注：服务器处理异常情况
    --             end
    --         else
    --             ShowSystemTips(msg)
    --         end
    --     end)
    -- end

    local getPublishKeyUsing = function()
        if otherTradingBankProxy:getPublishKeyValidTime() <= 0 or  otherTradingBankProxy:getPublishKey() == "" then
            otherTradingBankProxy:getPublishKeyUsing(SettingBasic, function(code, tabledata, msg)
                if code == 200 then
                    dump(tabledata,"tabledata")
                    otherTradingBankProxy:setPublishKeyValidTime(1800)
                    otherTradingBankProxy:setPublishTableData(tabledata)
                    otherTradingBankProxy:setPublishKey(tabledata.key)
                    otherTradingBankProxy:setPublishLockID(tabledata.prePublishId)

                    global.Facade:sendNotification(global.NoticeTable.TradingBank_other_Capture,{type = 1})
                else
                    ShowSystemTips(msg)
                end
            end)
        else
            global.Facade:sendNotification(global.NoticeTable.TradingBank_other_Capture,{type = 1})
        end
    end

    local TextTips = function()
        local params = {}
        params.rich = 1
        params.type = 1
        params.btntext = {GET_STRING(700000137), GET_STRING(600000170)}
        params.text = GET_STRING(700000135)
        params.titleImg = global.MMO.PATH_RES_PRIVATE .. "trading_bank_other/img_tips.png"
        params.callback = function(res)     
            global.Facade:sendNotification(global.NoticeTable.Layer_TradingBankTips2Layer_Close_other)
            if res == 1 then
                --是否登录
                if otherTradingBankProxy:getToken() == "" then 
                    otherTradingBankProxy:Login1_2(function(code, msg)
                        if code == 200 then 
                            if otherTradingBankProxy:getToken() ~= "" then 
                                getPublishKeyUsing()
                            end
                        else
                            ShowSystemTips(msg or "")
                        end
                    end)
                else
                    getPublishKeyUsing()
                end
            end
            
        end
        global.Facade:sendNotification(global.NoticeTable.Layer_TradingBankTips2Layer_Open_other, params)
    end

    local btn = SettingBasic.buttonCobyPlayerID 
    btn:addClickEventListener(function()
        local MapProxy = global.Facade:retrieveProxy( global.ProxyTable.Map )
        if not MapProxy:IsInSafeArea() then--安全区才能打开
            ShowSystemTips(GET_STRING(700000144))
            return
        end

        if SL:GetMetaValue("USEHERO") and SL:GetMetaValue("HERO_IS_ACTIVE") then
            if not SL:GetMetaValue("HERO_IS_ALIVE") then
                SL:ShowSystemTips("英雄还未召唤")
                return
            end
        end
        otherTradingBankProxy:doTrack(otherTradingBankProxy.UpLoadData.TraingCobyPlayerIDBtnClick)
        TextTips()
    end)
end

--创建 输入 点击 开关
function SettingBasic.CreateInputClickCell(parent, data)
    local values = SL:GetMetaValue("SETTING_VALUE", data.id)
    -- 容器
    local Panel_Layout = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 2, 200, 40, false)
    GUI:setTouchEnabled(Panel_Layout, true)

    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Layout, "Text_desc", 22, 20, 12, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)
    GUI:setTouchEnabled(Text_desc, false)

    -- 输入框背景
    local Image_2 = GUI:Image_Create(Panel_Layout, "Image_2", 107, 18, "res/private/new_setting/textBg.png")
    GUI:Image_setScale9Slice(Image_2, 33, 33, 9, 9)
    GUI:setContentSize(Image_2, 60, 28)
    GUI:setIgnoreContentAdaptWithSize(Image_2, false)
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setTouchEnabled(Image_2, false)

    --输入框
    local TextField_input = GUI:TextInput_Create(Image_2, "TextField_input", 0, 0, 65, 26, 14)

    GUI:TextInput_setTextHorizontalAlignment(TextField_input, 1)
    GUI:TextInput_setMaxLength(TextField_input, 10)
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setString(TextField_input, values[2] and values[2] or 1)
    GUI:TextInput_addOnEvent(TextField_input, function(_, eventType)
        if eventType == 1 then
            local input    = math.min(math.max(tonumber(GUI:TextInput_getString(TextField_input)) or 1, 1), 2000000000)
            SL:SetMetaValue("SETTING_VALUE", data.id, {nil, input })
        end
    end)
    -- 开关容器
    local CheckBox_able = GUI:Layout_Create(Panel_Layout, "CheckBox_able", 144, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)
    GUI:setTouchEnabled(CheckBox_able, true)

    -- 开关背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)

    -- 关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_1, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10.28, 8.78, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)

    -- 开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    GUI:setTouchEnabled(Panel_2, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    GUI:setTouchEnabled(Image_5, false)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)
    GUI:setTouchEnabled(Image_8, false)


    local enable = values[1] == 1
    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)

    GUI:addOnClickEvent(CheckBox_able, function()
        local values = SL:GetMetaValue("SETTING_VALUE", data.id)
        local enable = values[1] == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, { enable and 0 or 1 })
        --刷新开关状态
        func(not enable)
    end)

    return Panel_Layout
end

--点击的开关
function SettingBasic.CreateClickCell(parent, data)
    -- 
    local Panel_Click = GUI:Layout_Create(parent, "Panel_Click_" .. data.id, 0, 1, 200, 40, false)
    GUI:setTouchEnabled(Panel_Click, true)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel_Click, "Text_desc", 22, 20, 16, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    --选择容器
    local CheckBox_able = GUI:Layout_Create(Panel_Click, "CheckBox_able", 144, 19, 44, 18, false)
    GUI:setAnchorPoint(CheckBox_able, 0, 0.5)

    -- 背景
    local Image_5 = GUI:Image_Create(CheckBox_able, "Image_5", 22, 9, "res/private/new_setting/clickbg2.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)

    --关闭状态
    local Panel_1 = GUI:Layout_Create(CheckBox_able, "Panel_1", 0, 0, 44, 18, false)
    local Image_8 = GUI:Image_Create(Panel_1, "Image_8", 10, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)

    --开启状态
    local Panel_2 = GUI:Layout_Create(CheckBox_able, "Panel_2", 0, 0, 44, 18, false)
    local Image_5 = GUI:Image_Create(Panel_2, "Image_5", 22, 9, "res/private/new_setting/clickbg1.png")
    GUI:setAnchorPoint(Image_5, 0.5, 0.5)
    local Image_8 = GUI:Image_Create(Panel_2, "Image_8", 33, 8, "res/private/new_setting/click3.png")
    GUI:setAnchorPoint(Image_8, 0.5, 0.5)

    --触摸提示
    if data.tips then
        GUI:Text_enableUnderline(Text_desc)
        GUI:setTouchEnabled(Text_desc, true)
        GUI:addOnClickEvent(Text_desc, function()
            local worldPos = GUI:getTouchEndPosition(Text_desc)
            SL:SHOW_DESCTIP(data.tips, nil, worldPos, GUI:p(0, 1))
        end)
    end
    --设置是否开启
    local isOn = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    local enable = isOn == 1
    local func = function(enable)
        --关闭状态ui
        GUI:setVisible(Panel_1, not enable)
        --开启状态ui
        GUI:setVisible(Panel_2, enable)
    end

    --刷新开关状态
    func(enable)
    --开关点击
    GUI:addOnClickEvent(Panel_Click, function()
        local isOn = SL:GetMetaValue("SETTING_ENABLED", (data.id))
        local enable = isOn == 1
        SL:SetMetaValue("SETTING_VALUE", data.id, enable and { 0 } or { 1 })
        --刷新开关状态
        func(not enable)
    end)
    
    SettingBasic._clickItems[data.id or 0] = Panel_Click
end


function SettingBasic.CreateVoiceProgressCell(parent, data, index)
    --设置数据
    local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    -- 描述
    local Text_desc = GUI:Text_Create(parent, "Text_desc"..data.id, 30 + (index-1)*340, 71, 16, "#ffffff", string.format("%s(%s%%)", data.content, value or 100))
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    -- 进度条
    local Slider_progress = GUI:Slider_Create(parent, "Slider_progress"..data.id, 30 + (index-1)*340, 38, "res/private/new_setting/bg_progress.png", "res/private/new_setting/bg_progress2.png", "res/private/new_setting/icon_xdtzy_17.png")
    GUI:setContentSize(Slider_progress, 280, 11)
    GUI:setIgnoreContentAdaptWithSize(Slider_progress, false)
    GUI:Slider_setPercent(Slider_progress, value or 100)
    GUI:setAnchorPoint(Slider_progress, 0, 0.5)
    GUI:Slider_addOnEvent(Slider_progress, function(_, eventType)
        if eventType == 0 then
            local percent = GUI:Slider_getPercent(Slider_progress)
            local value = math.floor((SL:GetMetaValue("SETTING_ENABLED", (data.id)) or 100) / 10) * 10
            local newValue = math.floor(percent / 10) * 10
            if math.abs(value - newValue) >= 10 then
                --设置新值
                SL:SetMetaValue("SETTING_VALUE", data.id, { newValue })
                --刷新ui
                GUI:Text_setString(Text_desc, string.format("%s(%s%%)", data.content, newValue or 100))
            end
        end
    end)
end

function SettingBasic.CreateVoiceProgressCell2(parent, data, index)
    --设置数据
    local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    -- 描述
    local Text_desc = GUI:Text_Create(parent, "Text_desc"..data.id, 10 + (index-1)*220, 60, 16, "#ffffff", string.format("%s(%s%%)", data.content, value or 100))
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    -- 进度条
    local Slider_progress = GUI:Slider_Create(parent, "Slider_progress"..data.id, 10 + (index-1)*220, 38, "res/private/new_setting/bg_progress.png", "res/private/new_setting/bg_progress2.png", "res/private/new_setting/icon_xdtzy_17.png")
    GUI:setContentSize(Slider_progress, 190, 11)
    GUI:setIgnoreContentAdaptWithSize(Slider_progress, false)
    GUI:Slider_setPercent(Slider_progress, value or 100)
    GUI:setAnchorPoint(Slider_progress, 0, 0.5)
    GUI:Slider_addOnEvent(Slider_progress, function(_, eventType)
        if eventType == 0 then
            local percent = GUI:Slider_getPercent(Slider_progress)
            local value = math.floor((SL:GetMetaValue("SETTING_ENABLED", (data.id)) or 100) / 10) * 10
            local newValue = math.floor(percent / 10) * 10
            if math.abs(value - newValue) >= 10 then
                --设置新值
                SL:SetMetaValue("SETTING_VALUE", data.id, { newValue })
                --刷新ui
                GUI:Text_setString(Text_desc, string.format("%s(%s%%)", data.content, newValue or 100))
            end
        end
    end)
end

function SettingBasic.UpLoadTextTipsOpen()
    if SettingBasic.textTips then
        GUI:stopAllActions(SettingBasic.textTips)
        local str = GET_STRING(700000142)--"上传中，请稍等"
        GUI:Text_setString(SettingBasic.textTips, str..".")
        local callback1 = function ()
            GUI:Text_setString(SettingBasic.textTips, str..".")
        end
        local callback2 = function ()
            GUI:Text_setString(SettingBasic.textTips, str.."..")
        end
        local callback3 = function ()
            GUI:Text_setString(SettingBasic.textTips, str.."...")
        end
        GUI:runAction(SettingBasic.textTips,GUI:ActionRepeatForever(GUI:ActionSequence(
            GUI:CallFunc(callback1), GUI:DelayTime(0.3),
            GUI:CallFunc(callback2), GUI:DelayTime(0.3),
            GUI:CallFunc(callback3), GUI:DelayTime(0.3)
        )))
    end
end

function SettingBasic.UpLoadTextTipsClose()
    if SettingBasic.textTips then
        GUI:stopAllActions(SettingBasic.textTips)
        GUI:Text_setString(SettingBasic.textTips, "")
    end
end