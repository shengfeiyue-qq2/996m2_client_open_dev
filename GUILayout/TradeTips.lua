TradeTips = {}

function TradeTips.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(Layout, true)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 570, 320, 359, 256)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    local pBg = GUI:Image_Create(PMainUI, "pBg", 185, 130, "res/public/1900000601.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)
    GUI:setRotation(pBg, -90)

    local Image_title = GUI:Image_Create(PMainUI, "Image_title", 182, 224, "res/public/word_jyxszy_03.png")
    GUI:setAnchorPoint(Image_title, 0.5, 0.5)

    local line_1 = GUI:Image_Create(PMainUI, "line_1", 182, 204, "res/public/1900000667_1.png")
    GUI:setAnchorPoint(line_1, 0.5, 0.5)

    local NodeContent = GUI:Node_Create(PMainUI, "NodeContent", 182, 145)
    GUI:setAnchorPoint(NodeContent, 0.5, 0.5)

    -- 关闭按钮
    local btnClose = GUI:Button_Create(PMainUI, "btnClose", 363, 215, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(btnClose, "res/public/1900000511.png")

    local btnRefuse = GUI:Button_Create(PMainUI, "btnRefuse", 90, 50, "res/public/1900000680.png")
    GUI:Button_loadTexturePressed(btnRefuse, "res/public/1900000680_1.png")
    GUI:setAnchorPoint(btnRefuse, 0.5, 0.5)
    GUI:Button_setTitleFontSize(btnRefuse, 16)
    GUI:Button_setTitleText(btnRefuse, "拒绝")
    GUI:Button_setTitleColor(btnRefuse, "#FFFFFF")

    local btnAgree = GUI:Button_Create(PMainUI, "btnAgree", 270, 50, "res/public/1900000680.png")
    GUI:Button_loadTexturePressed(btnAgree, "res/public/1900000680_1.png")
    GUI:setAnchorPoint(btnAgree, 0.5, 0.5)
    GUI:Button_setTitleFontSize(btnAgree, 16)
    GUI:Button_setTitleText(btnAgree, "同意")
    GUI:Button_setTitleColor(btnAgree, "#FFFFFF")
end