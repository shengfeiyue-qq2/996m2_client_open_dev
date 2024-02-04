SettingFrame = {}

function SettingFrame.main()
    local parent = GUI:Attach_Parent()

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local layoutW = GUIShare.WinView.LayWidth
    local layoutH = GUIShare.WinView.LayHeight
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    -- 全屏关闭
    if not SL:IsWinMode() then
        local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)
        GUI:Layout_setBackGroundColorType(CloseLayout, 1)
        GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
        GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
        GUI:setTouchEnabled(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)
    end

    -- 容器
    local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", screenW/2, screenH/2, layoutW, layoutH)
    GUI:setAnchorPoint(FrameLayout, {x=0.5, y=0.5})
    GUI:setTouchEnabled(FrameLayout, true)
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, FrameLayout)
        GUI:setMouseEnabled(FrameLayout, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0, 0, "res/public/1900000610.png")

    -- 龙头
    local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14, 474, "res/public/1900000610_1.png")

    -- 标题
    local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 32, 498, 18, "#ffffff", "")

    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", GUIShare.WinView.HookX, GUIShare.WinView.HookY, attachW, attachH)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780, 492, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)

    local posY = 380
    local distance = 75

    -- 基础
    local Page1 = GUI:Button_Create(FrameLayout, "Page1", 780, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        SettingFrame.PageTo(1)
    end)
    posY = posY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText", 13, 60, 18, "#ffffff", "基\n础")
    GUI:setAnchorPoint(PageText1, {x=0.5, y=0.5})

    -- 保护
    local Page2 = GUI:Button_Create(FrameLayout, "Page2", 780, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        SettingFrame.PageTo(2)
    end)
    posY = posY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText", 13, 60, 18, "#ffffff", "保\n护")
    GUI:setAnchorPoint(PageText2, {x=0.5, y=0.5})

    -- 战斗
    local Page3 = GUI:Button_Create(FrameLayout, "Page3", 780, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        SettingFrame.PageTo(3)
    end)
    posY = posY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText", 13, 60, 18, "#ffffff", "战\n斗")
    GUI:setAnchorPoint(PageText3, {x=0.5, y=0.5})

    -- 拾取
    local Page4 = GUI:Button_Create(FrameLayout, "Page4", 780, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        SettingFrame.PageTo(4)
    end)
    posY = posY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText", 13, 60, 18, "#ffffff", "拾\n取")
    GUI:setAnchorPoint(PageText4, {x=0.5, y=0.5})

    -- 英雄
    if SL:GetMetaValue("USEHERO") then
        local Page5 = GUI:Button_Create(FrameLayout, "Page5", 780, posY, "res/public/1900000641.png")
        GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
        GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
        GUI:setTouchEnabled(Page5, true)
        GUI:addOnClickEvent(Page5, function()
            SettingFrame.PageTo(5)
        end)
        posY = posY - distance
        local PageText5 = GUI:Text_Create(Page5, "PageText", 13, 60, 18, "#ffffff", "英\n雄")
        GUI:setAnchorPoint(PageText5, {x=0.5, y=0.5})
    end

    -- 其他
    local Page6 = GUI:Button_Create(FrameLayout, "Page6", 780, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page6, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page6, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page6, true)
    GUI:addOnClickEvent(Page6, function()
        SettingFrame.PageTo(6)
    end)
    posY = posY - distance
    local PageText6 = GUI:Text_Create(Page6, "PageText", 13, 60, 18, "#ffffff", "其\n他")
    GUI:setAnchorPoint(PageText6, {x=0.5, y=0.5})


    -- 默认跳到第一个
    SettingFrame.PageTo(1)
end

function SettingFrame.PageTo(index)
    SettingFrame.index = index
end