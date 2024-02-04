AutoTradePut = {}

function AutoTradePut.main()
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

    local Image_0 = GUI:Image_Create(PMainUI, "Image_0", 92, 211, "res/private/trade_ui/word_baitanzy01.png")
    GUI:setAnchorPoint(Image_0, 0.5, 0.5)

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 258, 211, "res/public/1900000668.png")
    GUI:setContentSize(Image_1, {width = 188, height = 31})
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)

    local TextField_price = GUI:TextInput_Create(PMainUI, "TextField_price", 258, 211, 180, 25, 18)
    GUI:Text_setTextHorizontalAlignment(TextField_price, 1)
    GUI:setAnchorPoint(TextField_price, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField_price, 2)

    local Text_currency = GUI:Text_Create(PMainUI, "Text_currency", 223, 153, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_currency, 1, 0.5)

    local ListView = GUI:ListView_Create(PMainUI, "ListView", 197, 138, 68, 60, 1)
    GUI:setAnchorPoint(ListView, 0.5, 1)

    local Text_cell = GUI:Text_Create(PMainUI, "Text_cell", 0, 0, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_cell, 0.5, 0.5)
    GUI:setVisible(Text_cell, false)

    local Button_Arrow = GUI:Button_Create(PMainUI, "Button_Arrow", 238, 153, "res/public/1900000624_1.png")
    GUI:Button_loadTexturePressed(Button_Arrow, "res/public/1900000624.png")
    GUI:setAnchorPoint(Button_Arrow, 0.5, 0.5)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 396, 212, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)

    local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 110, 45, "res/public/btn_sifud_02.png")
    GUI:setAnchorPoint(Button_cancel, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_cancel, 18)
    GUI:Button_setTitleText(Button_cancel, "取消")
    GUI:Button_setTitleColor(Button_cancel, "#FFFFFF")

    local Button_sell = GUI:Button_Create(PMainUI, "Button_sell", 290, 45, "res/public/btn_sifud_02.png")
    GUI:setAnchorPoint(Button_sell, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_sell, 18)
    GUI:Button_setTitleText(Button_sell, "确定")
    GUI:Button_setTitleColor(Button_sell, "#FFFFFF")
end