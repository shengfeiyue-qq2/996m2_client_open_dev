PlayerHeroMain = {}

function PlayerHeroMain.main( skipPage )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local layoutW = 382
    local layoutH = 571

    -- 全屏关闭
    local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW - layoutW/2 - 80, screenH/2, layoutW, layoutH)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0, 0, "res/private/player_main_layer_ui/player_main_layer_ui_mobile/1900015000.png")
    GUI:setTouchEnabled(FrameBG, true)
    GUI:Win_SetDrag(parent, FrameBG)

    -- 玩家名字
    local UserName = GUI:Text_Create(PMainUI, "UserName", layoutW / 2, 526, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(UserName, 0.5, 0.5)

    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", 17, 15, 272, 349)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", layoutW, 465, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)

    local posY = 375
    local distance = 75

    -- 装备
    local Page1 = GUI:Button_Create(PMainUI, "Page1", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page1, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page1, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page1, true)
    GUI:addOnClickEvent(Page1, function()
        PlayerHeroMain.PageTo(1)
    end)
    posY = posY - distance
    local PageText1 = GUI:Text_Create(Page1, "PageText", 13, 60, 18, "#ffffff", "装\n备")
    GUI:setAnchorPoint(PageText1, 0.5, 0.5)

    -- 状态
    local Page2 = GUI:Button_Create(PMainUI, "Page2", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page2, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page2, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page2, true)
    GUI:addOnClickEvent(Page2, function()
        PlayerHeroMain.PageTo(2)
    end)
    posY = posY - distance
    local PageText2 = GUI:Text_Create(Page2, "PageText", 13, 60, 18, "#ffffff", "状\n态")
    GUI:setAnchorPoint(PageText2, 0.5, 0.5)

    -- 属性
    local Page3 = GUI:Button_Create(PMainUI, "Page3", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page3, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page3, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page3, true)
    GUI:addOnClickEvent(Page3, function()
        PlayerHeroMain.PageTo(3)
    end)
    posY = posY - distance
    local PageText3 = GUI:Text_Create(Page3, "PageText", 13, 60, 18, "#ffffff", "属\n性")
    GUI:setAnchorPoint(PageText3, 0.5, 0.5)

    -- 技能
    local Page4 = GUI:Button_Create(PMainUI, "Page4", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page4, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page4, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page4, true)
    GUI:addOnClickEvent(Page4, function()
        PlayerHeroMain.PageTo(4)
    end)
    posY = posY - distance
    local PageText4 = GUI:Text_Create(Page4, "PageText", 13, 60, 18, "#ffffff", "技\n能")
    GUI:setAnchorPoint(PageText4, 0.5, 0.5)

    -- 称号
    local Page5 = GUI:Button_Create(PMainUI, "Page5", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page5, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page5, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page5, true)
    GUI:addOnClickEvent(Page5, function()
        PlayerHeroMain.PageTo(5)
    end)
    posY = posY - distance
    local PageText5 = GUI:Text_Create(Page5, "PageText", 13, 60, 18, "#ffffff", "称\n号")
    GUI:setAnchorPoint(PageText5, 0.5, 0.5)

    -- 神装
    local Page6 = GUI:Button_Create(PMainUI, "Page6", layoutW, posY, "res/public/1900000641.png")
    GUI:Button_loadTextureDisabled(Page6, "res/public/1900000640.png")
    GUI:Button_loadTexturePressed(Page6, "res/public/1900000640.png")
    GUI:setTouchEnabled(Page6, true)
    GUI:addOnClickEvent(Page6, function()
        PlayerHeroMain.PageTo(6)
    end)
    posY = posY - distance
    local PageText6 = GUI:Text_Create(Page6, "PageText", 13, 60, 18, "#ffffff", "神\n装")
    GUI:setAnchorPoint(PageText6, 0.5, 0.5)

    PlayerHeroMain.PageTo(skipPage or 1)
end

function PlayerHeroMain.PageTo(index)
    PlayerHeroMain.index = index
end