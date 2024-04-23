AutoTradeSet = {}

function AutoTradeSet.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏关闭
    local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, 396, 259)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local pBg = GUI:Image_Create(PMainUI, "pBg", 0, 0, "res/private/trade_ui/bg_baitanzy02.jpg")
    GUI:setTouchEnabled(pBg, true)

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 0, 0, 16, "#FFFFFF", "请输入商户信息")
    GUI:setAnchorPoint(Text_1, 0.5, 0.5)

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 198, 135, "res/public/1900000668.png")
    GUI:setContentSize(Image_1, {width = 348, height = 49})
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)

    local TextField_1 = GUI:TextInput_Create(PMainUI, "TextField_1", 198, 135, 340, 35, 20)
    GUI:Text_setTextHorizontalAlignment(TextField_1, 1)
    GUI:setAnchorPoint(TextField_1, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField_1, 0)
    GUI:TextInput_setMaxLength(TextField_1, 50)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 396, 212, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")

    local Button_ok = GUI:Button_Create(PMainUI, "Button_ok", 198, 55, "res/public/btn_sifud_02.png")
    GUI:setAnchorPoint(Button_ok, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_ok, 18)
    GUI:Button_setTitleText(Button_ok, "确定")
    GUI:Button_setTitleColor(Button_ok, "#FFFFFF")
end