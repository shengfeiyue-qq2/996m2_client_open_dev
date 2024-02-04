MergePlayerMain = {}

function MergePlayerMain.main( skipPage, skipIndex )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local layoutW = 465
    local layoutH = 571

    -- 全屏关闭
    local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 135, (screenH-layoutH)/2, layoutW, layoutH)

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 232.5, 285.5, "res/private/player_hero/img_bg1.png")
    GUI:setAnchorPoint(FrameBG, 0.5, 0.5)
    GUI:setTouchEnabled(FrameBG, true)
    GUI:Win_SetDrag(parent, FrameBG)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(FrameBG, true)
    end

    -- 玩家名字
    local UserName = GUI:Text_Create(FrameBG, "UserName", 215, 528, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(UserName, 0.5, 0.5)

    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(FrameBG, "AttachLayout", 40, 16, 272, 349)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(FrameBG, "CloseButton", 405, 463, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)

    local BtnPlayer = GUI:Button_Create(FrameBG, "BtnPlayer", 6, 380, "res/private/player_hero/img_btn3.png")
    GUI:Button_loadTextureDisabled(BtnPlayer, "res/private/player_hero/img_btn4.png")
    GUI:setAnchorPoint(BtnPlayer, 0.5, 0.5)
    GUI:addOnClickEvent(BtnPlayer, function()
        MergePlayerMain.ButtonTo(1)
    end)

    local BtnHero = GUI:Button_Create(FrameBG, "BtnHero", 6, 302, "res/private/player_hero/img_btn1.png")
    GUI:Button_loadTextureDisabled(BtnHero, "res/private/player_hero/img_btn2.png")
    GUI:setAnchorPoint(BtnHero, 0.5, 0.5)
    GUI:addOnClickEvent(BtnHero, function()
        MergePlayerMain.ButtonTo(2)
    end)

    local posY = 375
    local distance = 75

    -- 装备
    local Page1 = GUI:Button_Create(FrameBG, "Page1", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        MergePlayerMain.PageTo(1)
    end)
    posY = posY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText1", 13, 60, 18, "#ffffff", "装\n备")
    GUI:setAnchorPoint(PageText1, 0.5, 0.5)

    -- 状态
    local Page2 = GUI:Button_Create(FrameBG, "Page2", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        MergePlayerMain.PageTo(2)
    end)
    posY = posY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText2", 13, 60, 18, "#ffffff", "状\n态")
    GUI:setAnchorPoint(PageText2, 0.5, 0.5)

    -- 属性
    local Page3 = GUI:Button_Create(FrameBG, "Page3", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        MergePlayerMain.PageTo(3)
    end)
    posY = posY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText3", 13, 60, 18, "#ffffff", "属\n性")
    GUI:setAnchorPoint(PageText3, 0.5, 0.5)

    -- 技能
    local Page4 = GUI:Button_Create(FrameBG, "Page4", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        MergePlayerMain.PageTo(4)
    end)
    posY = posY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText4", 13, 60, 18, "#ffffff", "技\n能")
    GUI:setAnchorPoint(PageText4, 0.5, 0.5)

    -- 称号
    local Page5 = GUI:Button_Create(FrameBG, "Page5", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page5, true)
    GUI:addOnClickEvent(Page5, function()
        MergePlayerMain.PageTo(5)
    end)
    posY = posY - distance
    local PageText5 = GUI:Text_Create(Page5, "PageText5", 13, 60, 18, "#ffffff", "称\n号")
    GUI:setAnchorPoint(PageText5, 0.5, 0.5)

    -- 神装
    local Page6 = GUI:Button_Create(FrameBG, "Page6", 405, posY, "res/public/1900000641.png")
    GUI:Button_loadTexturePressed(Page6, "res/public/1900000640.png")
    GUI:Button_loadTextureDisabled(Page6, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page6, true)
    GUI:addOnClickEvent(Page6, function()
        MergePlayerMain.PageTo(6)
    end)
    posY = posY - distance
    local PageText6 = GUI:Text_Create(Page6, "PageText6", 13, 60, 18, "#ffffff", "神\n装")
    GUI:setAnchorPoint(PageText6, 0.5, 0.5)

    MergePlayerMain.ButtonTo(skipPage or 1)
    MergePlayerMain.PageTo(skipIndex or 1)
end