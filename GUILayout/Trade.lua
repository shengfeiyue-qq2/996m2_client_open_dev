Trade = {}

function Trade.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 650, 25, 400, 505)
    GUI:setTouchEnabled(PMainUI, true)

    Trade.LoadPanelMe(PMainUI, parent)

    Trade.LoadPanelOther(PMainUI, parent)
end

function Trade.LoadPanelMe(parent, win)
    local Panel_me = GUI:Layout_Create(parent, "Panel_me", 5, 0, 400, 280)
    GUI:setTouchEnabled(Panel_me, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, Panel_me)
        GUI:setMouseEnabled(Panel_me, true)
    end

    local pBg = GUI:Image_Create(Panel_me, "pBg", 185, 130, "res/private/trade/trade_ui_mobile/bg_jiaoyidi_01.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)

    local Panel_addGold = GUI:Layout_Create(Panel_me, "Panel_addGold", 10, 8, 185, 45)
    local Image_gold = GUI:Image_Create(Panel_me, "Image_gold", 27.5, 27.5, "res/private/bag_ui/1900015220.png")
    GUI:setAnchorPoint(Image_gold, 0.5, 0.5)
    GUI:setTouchEnabled(Image_gold, true)

    local PanelItems = GUI:Layout_Create(Panel_me, "PanelItems", 19, 198, 340, 136, true)
    GUI:setAnchorPoint(PanelItems, 0, 1)
    local PanelTouch = GUI:Layout_Create(Panel_me, "PanelTouch", 19, 198, 340, 136, true)
    GUI:setAnchorPoint(PanelTouch, 0, 1)

    local Panel_lockStatus = GUI:Layout_Create(Panel_me, "Panel_lockStatus", 19, 198, 340, 136) 
    GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
    GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
    GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 120)
    GUI:setAnchorPoint(Panel_lockStatus, 0, 1)
    GUI:setVisible(Panel_lockStatus, false)

    local Image_4 = GUI:Image_Create(Panel_lockStatus, "Image_4", 170, 68, "res/public/icon_tyzys_01.png")
    GUI:setAnchorPoint(Image_4, 0.5, 0.5)

    local Text_name = GUI:Text_Create(Panel_me, "Text_name", 102, 248, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)

    local Text_gold = GUI:Text_Create(Panel_me, "Text_gold", 63, 37, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_gold, 0, 0.5)

    local Button_trade = GUI:Button_Create(Panel_me, "Button_trade", 324, 36, "res/private/bag_ui/1900015210.png")
    GUI:Button_loadTexturePressed(Button_trade, "res/private/bag_ui/1900015211.png")
    GUI:setAnchorPoint(Button_trade, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_trade, 18)
    GUI:Button_setTitleText(Button_trade, "交易")
    GUI:Button_setTitleColor(Button_trade, "#FFFFFF")

    local Button_lock = GUI:Button_Create(Panel_me, "Button_lock", 235, 36, "res/private/bag_ui/1900015210.png")
    GUI:Button_loadTexturePressed(Button_lock, "res/private/bag_ui/1900015211.png")
    GUI:setAnchorPoint(Button_lock, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_lock, 18)
    GUI:Button_setTitleText(Button_lock, "锁定")
    GUI:Button_setTitleColor(Button_lock, "#FFFFFF")

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(Panel_me, "CloseButton", 370, 170, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:addOnClickEvent(CloseButton, function () GUI:Win_Close(win) end)
end

function Trade.LoadPanelOther(parent, win)
    local Panel_other = GUI:Layout_Create(parent, "Panel_other", 5, 285, 400, 280)
    GUI:setTouchEnabled(Panel_other, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, Panel_other)
        GUI:setMouseEnabled(Panel_other, true)
    end

    local pBg = GUI:Image_Create(Panel_other, "pBg", 185, 130, "res/private/trade/trade_ui_mobile/bg_jiaoyidi_01.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)

    local Image_gold = GUI:Image_Create(Panel_other, "Image_gold", 27.5, 27.5, "res/private/bag_ui/1900015220.png")
    GUI:setAnchorPoint(Image_gold, 0.5, 0.5)

    local PanelItems = GUI:Layout_Create(Panel_other, "PanelItems", 19, 198, 340, 136, true)
    GUI:setAnchorPoint(PanelItems, 0, 1)

    local Panel_lockStatus = GUI:Layout_Create(Panel_other, "Panel_lockStatus", 19, 198, 340, 136) 
    GUI:Layout_setBackGroundColor(Panel_lockStatus, "#000000")
    GUI:Layout_setBackGroundColorType(Panel_lockStatus, 1)
    GUI:Layout_setBackGroundColorOpacity(Panel_lockStatus, 120)
    GUI:setAnchorPoint(Panel_lockStatus, 0, 1)
    GUI:setVisible(Panel_lockStatus, false)

    local Image_4 = GUI:Image_Create(Panel_lockStatus, "Image_4", 170, 68, "res/public/icon_tyzys_01.png")
    GUI:setAnchorPoint(Image_4, 0.5, 0.5)

    local Text_name = GUI:Text_Create(Panel_other, "Text_name", 102, 248, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)

    local Text_gold = GUI:Text_Create(Panel_other, "Text_gold", 63, 37, 18, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_gold, 0, 0.5)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(Panel_other, "CloseButton", 370, 170, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:addOnClickEvent(CloseButton, function () GUI:Win_Close(win) end)
end