
BeStrongList = {}

function BeStrongList.main(pos)
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local pTouch = GUI:Layout_Create(parent, "pTouch", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(pTouch, true)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 750, 200, 125, 90)
    GUI:Layout_setBackGroundImage(PMainUI, "res/public/1900000677.png")
    GUI:Layout_setBackGroundImageScale9Slice(PMainUI, 10, 10, 15, 15)
    GUI:setAnchorPoint(PMainUI, 0.5, 0)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:setPosition(PMainUI, pos.x, pos.y + 40)

    -- ListView
    local ListView = GUI:ListView_Create(PMainUI, "ListView", 5, 5, 115, 80, 1)
    GUI:ListView_setItemsMargin(ListView, 5)

    -- ListView Cell
    local BtnCell = GUI:Button_Create(PMainUI, "BtnCell", 62, 23.5, "res/public/1900000662.png")
    GUI:Button_loadTexturePressed(BtnCell, "res/public/1900000663.png")
    GUI:setAnchorPoint(BtnCell, 0.5, 0.5)
    GUI:Button_setTitleColor(BtnCell, "#FFFFFF")
    GUI:Button_setTitleFontSize(BtnCell, 14)
    GUI:Button_setTitleText(BtnCell, "name")
    GUI:setVisible(BtnCell, false)
end