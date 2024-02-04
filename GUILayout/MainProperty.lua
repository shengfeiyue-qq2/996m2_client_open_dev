MainProperty = {}

MainProperty.QUICK_USE_NUM = 6  -- 快捷框个数 (最大：6)

function MainProperty.main()
    local parent = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0, 0, 1136, 150)
    GUI:setAnchorPoint(Panel_bg, 0.5, 0)

    -- 底部条
    local bottomImg = GUI:Image_Create(Panel_bg, "bottomImg", screenW/2 - 100, -3, "res/private/main/1900012003.png")
    GUI:setAnchorPoint(bottomImg, 0.5, 0)
    GUI:setContentSize(bottomImg, {width = screenW + 200, height = 30 })

    -- 血量
    local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 350, 13, "res/private/main/1900012006.png")
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)
    GUI:setContentSize(Image_1, {width = 95, height = 16})

    local Text_hp = GUI:Text_Create(Panel_bg, "Text_hp", 350, 14, 16, "#FFFFFF", "xx/xx")
    GUI:setAnchorPoint(Text_hp, 0.5, 0.5)
    MainProperty.Text_hp = Text_hp

    -- 蓝量
    local Image_2 = GUI:Image_Create(Panel_bg, "Image_2", 457, 13, "res/private/main/1900012006.png")
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)
    GUI:setContentSize(Image_2, {width = 95, height = 16})

    local Text_mp = GUI:Text_Create(Panel_bg, "Text_mp", 457, 14, 16, "#FFFFFF", "xx/xx")
    GUI:setAnchorPoint(Text_mp, 0.5, 0.5)
    MainProperty.Text_mp = Text_mp

    -- 等级
    local Image_3 = GUI:Image_Create(Panel_bg, "Image_3", 650, 13, "res/private/main/1900012006.png")
    GUI:setAnchorPoint(Image_3, 0.5, 0.5)
    GUI:setContentSize(Image_3, {width = 95, height = 16})

    local Image_lv = GUI:Image_Create(Panel_bg, "Image_lv", 570, 13, "res/private/main/1900012015.png")
    GUI:setAnchorPoint(Image_lv, 0.5, 0.5)

    local Text_level = GUI:Text_Create(Panel_bg, "Text_level", 650, 14, 16, "#FFFFFF", "xx级")
    GUI:setAnchorPoint(Text_level, 0.5, 0.5)
    MainProperty.Text_level = Text_level

    -- 时钟
    local Image_4 = GUI:Image_Create(Panel_bg, "Image_4", 1080, 14, "res/private/main/m_time.png")
    GUI:setAnchorPoint(Image_4, 0.5, 0.5)
    GUI:setContentSize(Image_4, {width = 97, height = 18})

    local Text_time = GUI:Text_Create(Panel_bg, "Text_time", 1080, 14, 16, "#FFFFFF", "-")
    GUI:setAnchorPoint(Text_time, 0.5, 0.5)

    -- 经验
    local Image_exp = GUI:Image_Create(Panel_bg, "Image_exp", 740, 13, "res/private/main/1900012016.png")
    GUI:setAnchorPoint(Image_exp, 0.5, 0.5)

    local expBarBg = GUI:Image_Create(Panel_bg, "expBarBg", 896, 13, "res/private/main/1900012009.png")
    GUI:setAnchorPoint(expBarBg, 0.5, 0.5)
    GUI:setContentSize(expBarBg, {width = 258, height = 14})

    local LoadingBar_exp = GUI:LoadingBar_Create(Panel_bg, "LoadingBar_exp", 895, 13, "res/private/main/1900012010.png", 0)
    GUI:setAnchorPoint(LoadingBar_exp, 0.5, 0.5)
    MainProperty.LoadingBar_exp = LoadingBar_exp

    local Text_exp = GUI:Text_Create(Panel_bg, "Text_exp", 895, 14, 16, "#FFFFFF", "0%")
    GUI:setAnchorPoint(Text_exp, 0.5, 0.5)
    MainProperty.Text_exp = Text_exp

    -- 转生加点
    local reinAddBtn = GUI:Button_Create(Panel_bg, "reinAddBtn", 535, 13, "res/private/main/00641.png")
    GUI:setAnchorPoint(reinAddBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(reinAddBtn, "res/private/main/00641.png")
    GUI:Button_loadTextureDisabled(reinAddBtn, "res/private/main/00643.png")

    -- 网络 电池
    local Image_net = GUI:Image_Create(Panel_bg, "Image_net", 84, 11, "res/private/main/Other/1900012501.png")
    GUI:setAnchorPoint(Image_net, 0.5, 0.5)
    MainProperty.Image_net = Image_net

    local Image_battery = GUI:Image_Create(Panel_bg, "Image_battery", 147, 11, "res/private/main/Other/1900012502.png")
    GUI:setAnchorPoint(Image_battery, 0.5, 0.5)

    local LoadingBar_battery = GUI:LoadingBar_Create(Panel_bg, "LoadingBar_battery", 146, 11, "res/private/main/Other/1900012503.png", 0)
    GUI:setAnchorPoint(LoadingBar_battery, 0.5, 0.5)
    MainProperty.LoadingBar_battery = LoadingBar_battery

    -- 血球
    local mhpBgImg  = GUI:Image_Create(Panel_bg, "mhpBgImg", 402, 26, "res/private/main/1900012000.png")
    GUI:setAnchorPoint(mhpBgImg, 0.5, 0)

    local Panel_hp = GUI:Layout_Create(Panel_bg, "Panel_hp", 404, 88, 70, 70)
    GUI:setAnchorPoint(Panel_hp, 0.5, 0.5)

    -- FPS
    local Text_FPS = GUI:Text_Create(Panel_bg, "Text_FPS", 230, 13, 16, "#FFFFFF", "FPS:60")
    GUI:setAnchorPoint(Text_FPS, 0.5, 0.5)
    SL:SetColorStyle(Text_FPS, 1006)
    SL:Schedule(function()
        GUI:Text_setString(Text_FPS, string.format("FPS:%s", SL:GetMetaValue("FPS")))
    end, 0.2)

    local Image_divide = GUI:Image_Create(Panel_hp, "Image_divide", 35, 35, "res/private/main/1900012507.png")
    GUI:setAnchorPoint(Image_divide, 0.5, 0.5)
    MainProperty.Image_divide = Image_divide

    local LoadingBar_hp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_hp", 16, 35, "res/private/main/1900012032.png", 0)
    GUI:setAnchorPoint(LoadingBar_hp, 0.5, 0.5)
    GUI:setContentSize(LoadingBar_hp, {width = 70, height = 33})
    GUI:setRotation(LoadingBar_hp, 270)
    MainProperty.LoadingBar_hp = LoadingBar_hp

    local LoadingBar_mp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_mp", 53, 35, "res/private/main/1900012033.png", 0)
    GUI:setAnchorPoint(LoadingBar_mp, 0.5, 0.5)
    GUI:setContentSize(LoadingBar_mp, {width = 70, height = 33})
    GUI:setRotation(LoadingBar_mp, 270)
    MainProperty.LoadingBar_mp = LoadingBar_mp

    local LoadingBar_fhp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_fhp", 35, 35, "res/private/main/1900012504.png", 0)
    GUI:setAnchorPoint(LoadingBar_fhp, 0.5, 0.5)
    GUI:setContentSize(LoadingBar_fhp, {width = 70, height = 70})
    GUI:setRotation(LoadingBar_fhp, 270)
    MainProperty.LoadingBar_fhp = LoadingBar_fhp

    -- 魔血球动画示例
    --[[
    local Panel_hp_sfx = GUI:Layout_Create(Panel_hp, "Panel_hp_sfx", 0, 0, 33, 70, true)
    GUI:setAnchorPoint(Panel_hp_sfx, 0, 0)
    MainProperty.Panel_hp_sfx = Panel_hp_sfx

    local Panel_mp_sfx = GUI:Layout_Create(Panel_hp, "Panel_mp_sfx", 37, 0, 33, 70, true)
    GUI:setAnchorPoint(Panel_mp_sfx, 0, 0)
    MainProperty.Panel_mp_sfx = Panel_mp_sfx

    local Panel_fhp_sfx = GUI:Layout_Create(Panel_hp, "Panel_fhp_sfx", 0, 0, 70, 70, true)
    GUI:setAnchorPoint(Panel_fhp_sfx, 0, 0)
    MainProperty.Panel_fhp_sfx = Panel_fhp_sfx

    local ext = {
        count = 29,
        loop = -1,
        speed = 100
    }
    pSize = {}
    local hpSfx = GUI:Frames_Create(Panel_hp_sfx, "hpSfx", 0, 0, "res/private/mhp_ui/hp_", ".png", 0, nil, ext)
    local hpSfxSize = GUI:getContentSize(hpSfx)
    GUI:setContentSize(Panel_hp_sfx, hpSfxSize)
    pSize[1] = hpSfxSize

    local mpSfx = GUI:Frames_Create(Panel_mp_sfx, "mpSfx", 0, 0, "res/private/mhp_ui/mp_", ".png", 0, nil, ext)
    local mpSfxSize = GUI:getContentSize(mpSfx)
    GUI:setContentSize(Panel_mp_sfx, mpSfxSize)
    GUI:setPosition(Panel_mp_sfx, hpSfxSize.width, 0)
    pSize[2] = mpSfxSize

    local fhpSfx = GUI:Frames_Create(Panel_fhp_sfx, "fhpSfx", 0, 0, "res/private/mhp_ui/fhp_", ".png", 0, nil, ext)
    local fhpSfxSize = GUI:getContentSize(fhpSfx)
    GUI:setContentSize(Panel_fhp_sfx, fhpSfxSize)
    pSize[3] = fhpSfxSize
    ]]

    -- 聊天框
    local Panel_mini_chat = GUI:Layout_Create(parent, "Panel_mini_chat", -50, 27, 316, 108)
    
    local Image_minichat_bg = GUI:Image_Create(Panel_mini_chat, "Image_minichat_bg", 158, 0, "res/private/main/1900012019.png")
    GUI:setAnchorPoint(Image_minichat_bg, 0.5, 0)
    GUI:setContentSize(Image_minichat_bg, {width = 316, height = 108})
    GUI:Image_setScale9Slice(Image_minichat_bg, 69, 69, 22, 20)

    local ListView_minichat = GUI:ListView_Create(Panel_mini_chat, "ListView_minichat", 158, 0, 310, 105, 1)
    GUI:setAnchorPoint(ListView_minichat, 0.5, 0)
    GUI:ListView_setClippingEnabled(ListView_minichat, true)
    
    local ListView_chat_ex = GUI:ListView_Create(Panel_mini_chat, "ListView_chat_ex", 158, 105, 310, 25, 1)
    GUI:setAnchorPoint(ListView_chat_ex, 0.5, 1)
    GUI:ListView_setClippingEnabled(ListView_chat_ex, true)

    local Panel_mini_chat_touch = GUI:Layout_Create(Panel_mini_chat, "Panel_mini_chat_touch", 0, 0, 316, 108)
    GUI:setTouchEnabled(Panel_mini_chat_touch, true)
    GUI:addOnClickEvent(Panel_mini_chat_touch, function () SL:OpenChatUI() end)

    -- 气泡栏
    local Panel_bubble_tips = GUI:Layout_Create(parent, "Panel_bubble_tips", -165, 175, 150, 50)
    GUI:setAnchorPoint(Panel_bubble_tips, 0.5, 0)

    local ListView_bubble_tips = GUI:ListView_Create(Panel_bubble_tips, "ListView_bubble_tips", 0, 0, 150, 50, 2)
    GUI:ListView_setClippingEnabled(ListView_bubble_tips, true)
    GUI:ListView_setGravity(ListView_bubble_tips, 3)
    GUI:setTouchEnabled(ListView_bubble_tips, false)

    -- 自动提示
    local Panel_auto_tips = GUI:Layout_Create(parent, "Panel_auto_tips", -50, 190, 316, 60)

    -- 快键栏
    local Panel_quick_use = GUI:Layout_Create(parent, "Panel_quick_use", -50, 137, 316, 50)

    local Quick_use_1  = GUI:Layout_Create(Panel_quick_use, "Quick_use_1", 0, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_1, true)

    local Quick_use_2  = GUI:Layout_Create(Panel_quick_use, "Quick_use_2", 53, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_2, true)

    local Quick_use_3  = GUI:Layout_Create(Panel_quick_use, "Quick_use_3", 106, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_3, true)

    local Quick_use_4  = GUI:Layout_Create(Panel_quick_use, "Quick_use_4", 159, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_4, true)

    local Quick_use_5  = GUI:Layout_Create(Panel_quick_use, "Quick_use_5", 212, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_5, true)

    local Quick_use_6  = GUI:Layout_Create(Panel_quick_use, "Quick_use_6", 265, 0, 50, 50)
    GUI:setTouchEnabled(Quick_use_6, true)

    -- 英雄怒气条
    local Image_barbg = GUI:Image_Create(parent, "Image_barbg", -55.5, 27, "res/private/main/angerBg2.png")
    GUI:setAnchorPoint(Image_barbg, 0.5, 0)
    
    local Image_2 = GUI:Image_Create(Image_barbg, "Image_2", 6.5, 2, "res/private/main/angerBg.png")
    GUI:setAnchorPoint(Image_2, 0.5, 0)

    local Panel_bar = GUI:Layout_Create(Image_barbg, "Panel_bar", 6.5, 0, 13, 108, true)
    GUI:setAnchorPoint(Panel_bar, 0.5, 0)

    local Image_bar = GUI:Image_Create(Panel_bar, "Image_bar", 6.5, 2, "res/private/main/angerBar.png")
    GUI:setAnchorPoint(Image_bar, 0.5, 0)

    -- 时钟定时器
    local function callback()
        local date = os.date("*t",  SL:GetCurServerTime())
        GUI:Text_setString(Text_time, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    MainProperty.RefreshPropertyShow()
    MainProperty.RefreshNetShow()
    MainProperty.RefreshBatteryShow()
    MainProperty.RegisterEvent()
end

-- 快捷栏cell
function MainProperty.CreateQuickUseCell(parent)
    if not parent then
        return
    end
    -- 点击区域
    local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0, 0, 52, 50)
    GUI:setTouchEnabled(Panel_cell, true)
    
    local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", 26, 25, "res/public/1900012391.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    
    local Node_item = GUI:Node_Create(Panel_cell, "Node_item", 26, 25)
    
    -- 拖动区域
    local Panel_quick = GUI:Layout_Create(Panel_cell, "Panel_quick", 0, 0, 52, 50)
    GUI:setTouchEnabled(Panel_quick, true)

end

-- 气泡cell
function MainProperty.CreateBubbleTipsCell(parent)
    if not parent then
        return
    end
   
    local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0, 0, 50, 50)
    GUI:setTouchEnabled(Panel_cell, true)

    -- 图标
    local iconBtn = GUI:Button_Create(Panel_cell, "iconBtn", 25, 25, "Default/Button_Normal.png")
    GUI:setAnchorPoint(iconBtn, 0.5, 0.5)

    -- 倒计时
    local timeText = GUI:Text_Create(Panel_cell, "timeText", 25, 7, 16, "#FF0000", "10")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)

end

function MainProperty.RegisterEvent( ... )

    -- 注册事件
    SL:RegisterLUAEvent("LUA_EVENT_HPMPCHANGE", "MainProperty", MainProperty.RefreshPropertyShow)
    SL:RegisterLUAEvent("LUA_EVENT_LEVELCHANGE", "MainProperty", MainProperty.RefreshPropertyShow)
    SL:RegisterLUAEvent("LUA_EVENT_EXPCHANGE", "MainProperty", MainProperty.RefreshPropertyShow)
    SL:RegisterLUAEvent("LUA_EVENT_NETCHANGE", "MainProperty", MainProperty.RefreshNetShow)
    SL:RegisterLUAEvent("LUA_EVENT_BATTERYCHANGE", "MainProperty", MainProperty.RefreshBatteryShow)
end

function MainProperty.RefreshPropertyShow( data )
    --Level
    local roleLevel = SL:GetRoleData().level
    local reinLv = SL:GetRoleData().reinLv
    if MainProperty.Text_level then
        local str = string.format( "%s%s", roleLevel.. "级", reinLv > 0 and reinLv.. "转" or "")
        GUI:Text_setString(MainProperty.Text_level, str)
    end

    --EXP
    local curExp = SL:GetRoleData().curExp
    local maxExp = SL:GetRoleData().maxExp
    local expPer = curExp/maxExp * 100
    GUI:LoadingBar_setPercent(MainProperty.LoadingBar_exp, expPer)
    GUI:Text_setString(MainProperty.Text_exp, string.format("%.1f%%", expPer))

    --HPMP
    local curHP = SL:GetRoleData().curHP
    local maxHP = SL:GetRoleData().maxHP
    local curMP = SL:GetRoleData().curMP
    local maxMP = SL:GetRoleData().maxMP
    local hpPer = curHP/maxHP * 100
    local mpPer = curMP/maxMP * 100
    GUI:Text_setString(MainProperty.Text_hp, string.format("%s/%s", curHP, maxHP))
    GUI:Text_setString(MainProperty.Text_mp, string.format("%s/%s", curMP, maxMP))
    
    local roleJob = SL:GetRoleData().job
    if roleLevel < 28 and roleJob == 0 then     -- 战士等级小于28 显示全血
        GUI:setVisible(MainProperty.LoadingBar_hp, false)
        GUI:setVisible(MainProperty.LoadingBar_mp, false)
        GUI:setVisible(MainProperty.Image_divide, false)
        GUI:setVisible(MainProperty.LoadingBar_fhp, true)
        GUI:LoadingBar_setPercent(MainProperty.LoadingBar_fhp, hpPer)
        if MainProperty.Panel_hp_sfx and MainProperty.Panel_mp_sfx and pSize then
            GUI:setVisible(MainProperty.Panel_hp_sfx, false)
            GUI:setVisible(MainProperty.Panel_mp_sfx, false)
            GUI:setVisible(MainProperty.Panel_fhp_sfx, true)
            GUI:setContentSize(MainProperty.Panel_fhp_sfx, {width = pSize[3].width, height = pSize[3].height* hpPer/100})
        end 
    else
        GUI:setVisible(MainProperty.LoadingBar_hp, true)
        GUI:setVisible(MainProperty.LoadingBar_mp, true)
        GUI:setVisible(MainProperty.Image_divide, true)
        GUI:setVisible(MainProperty.LoadingBar_fhp, false)
        GUI:LoadingBar_setPercent(MainProperty.LoadingBar_hp, hpPer)
        GUI:LoadingBar_setPercent(MainProperty.LoadingBar_mp, mpPer)
        if MainProperty.Panel_hp_sfx and MainProperty.Panel_mp_sfx and pSize then
            GUI:setVisible(MainProperty.Panel_hp_sfx, true)
            GUI:setVisible(MainProperty.Panel_mp_sfx, true)
            GUI:setVisible(MainProperty.Panel_fhp_sfx, false)
            GUI:setContentSize(MainProperty.Panel_hp_sfx, {width = pSize[1].width, height = pSize[1].height* hpPer/100})
            GUI:setContentSize(MainProperty.Panel_mp_sfx, {width = pSize[2].width, height = pSize[2].height* mpPer/100})
        end 
    end

end

function MainProperty.RefreshNetShow()
    -- 网络类型 -1:未识别 0:wifi 1:2g 2:3g 3:4g
    local type = SL:GetNetType()
    if MainProperty.Image_net and type then
        if type and type == 0 then
            GUI:Image_loadTexture(MainProperty.Image_net, "res/private/main/Other/1900012501.png")
        else
            GUI:Image_loadTexture(MainProperty.Image_net, "res/private/main/Other/1900012500.png")
        end
    end
end

function MainProperty.RefreshBatteryShow( data )
    local per = data or SL:GetBatteryPer()
    if MainProperty.LoadingBar_battery and per then
        GUI:LoadingBar_setPercent(MainProperty.LoadingBar_battery, per)
    end
end

