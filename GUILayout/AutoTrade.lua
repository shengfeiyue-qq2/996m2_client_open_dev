AutoTrade = {}

function AutoTrade.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 850, 320, 386, 520)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local pBg = GUI:Image_Create(PMainUI, "pBg", 176, 240, "res/private/trade_ui/bg_baitanzy01.jpg")
    GUI:setTouchEnabled(pBg, true)
    GUI:setAnchorPoint(pBg, 0.5, 0.5)

    local Image_0 = GUI:Image_Create(PMainUI, "Image_0", 176, 499, "res/private/trade_ui/bg_baitanzy03.png")
    GUI:setAnchorPoint(Image_0, 0.5, 0.5)

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 68, 160, "res/private/trade_ui/word_baitanzy02.png")
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)

    local Image_2 = GUI:Image_Create(PMainUI, "Image_2", 68, 115, "res/private/trade_ui/word_baitanzy01.png")
    GUI:setAnchorPoint(Image_2, 0.5, 0.5)

    local Image_3 = GUI:Image_Create(PMainUI, "Image_3", 235, 160, "res/public/1900000668.png")
    GUI:setContentSize(Image_3, {width = 188, height = 31})
    GUI:setAnchorPoint(Image_3, 0.5, 0.5)

    local Image_4 = GUI:Image_Create(PMainUI, "Image_4", 235, 115, "res/public/1900000668.png")
    GUI:setContentSize(Image_4, {width = 188, height = 31})
    GUI:setAnchorPoint(Image_4, 0.5, 0.5)

    local Text_Title = GUI:Text_Create(PMainUI, "Text_Title", 174, 498, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_Title, 0.5, 0.5)

    local Text_itemName = GUI:Text_Create(PMainUI, "Text_itemName", 235, 160, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_itemName, 0.5, 0.5)

    local Text_price = GUI:Text_Create(PMainUI, "Text_price", 235, 115, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_price, 0.5, 0.5)

    local PanelItems = GUI:Layout_Create(PMainUI, "PanelItems", 18, 462, 316, 256, true)
    GUI:setAnchorPoint(PanelItems, 0, 1)
    local PanelTouch = GUI:Layout_Create(PMainUI, "PanelTouch", 18, 462, 316, 256, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)

    local Image_sel = AutoTrade.createSelImage(PanelTouch)
    GUI:setVisible(Image_sel, false)

    -- 关闭按钮
    local Button_close = GUI:Button_Create(PMainUI, "Button_close", 350, 478, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")

    local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 90, 45, "res/public/btn_sifud_02.png")
    GUI:setAnchorPoint(Button_cancel, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_cancel, 18)
    GUI:Button_setTitleText(Button_cancel, "取消")
    GUI:Button_setTitleColor(Button_cancel, "#FFFFFF")

    local Button_do = GUI:Button_Create(PMainUI, "Button_do", 260, 45, "res/public/btn_sifud_02.png")
    GUI:setAnchorPoint(Button_do, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_do, 18)
    GUI:Button_setTitleText(Button_do, "摆摊")
    GUI:Button_setTitleColor(Button_do, "#FFFFFF")
end

function AutoTrade.createSelImage(parent)
    local Image_sel = GUI:Image_Create(parent, "Image_sel", 0, 0, "res/public/1900000678_1.png")
    GUI:setContentSize(Image_sel, {width = 66, height = 68})
    GUI:Image_setScale9Slice(Image_sel, 10, 10, 10, 10)
    GUI:setAnchorPoint(Image_sel, 0.5, 0.5)

    return Image_sel
end